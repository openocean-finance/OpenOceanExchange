// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";

interface IDMMFactory {

    function getPools(IERC20 token0, IERC20 token1) external view returns (address[] memory _tokenPools);

}

interface IDMMPool {
    function getTradeInfo() external view
    returns (
        uint112 _reserve0,
        uint112 _reserve1,
        uint112 _vReserve0,
        uint112 _vReserve1,
        uint256 feeInPrecision
    );

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata callbackData
    ) external;

}


library IDMMPoolExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    //TODO
    address private constant SKIM_TARGET = 0xe523182610482b8C0DD65d5A08F1Bbd256B1EA0c;
    uint256 public constant PRECISION = 1e18;

    /**
     * @notice Use Uniswap's constant product formula to calculate expected swap return.
     * See https://github.com/runtimeverification/verified-smart-contracts/blob/uniswap/uniswap/x-y-k.pdf
     */
    function calculateSwapReturn(
        IDMMPool pair,
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount
    ) internal view returns (uint256) {
        if (amount == 0) {
            return 0;
        }
        (uint256 reserveIn,uint256 reserveOut,uint256 vReserveIn,uint256 vReserveOut,uint256 feeInPrecision) = getTradeInfo(pair, inToken, outToken);
        return doCalculate(amount, reserveIn, reserveOut, vReserveIn, vReserveOut, feeInPrecision);
    }

    function doCalculate(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut,
        uint256 vReserveIn,
        uint256 vReserveOut,
        uint256 feeInPrecision
    ) private pure returns (uint256 amountOut) {
        require(amountIn > 0, "DMMLibrary: INSUFFICIENT_INPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "DMMLibrary: INSUFFICIENT_LIQUIDITY");
        uint256 amountInWithFee = amountIn.mul(PRECISION.sub(feeInPrecision)).div(PRECISION);
        uint256 numerator = amountInWithFee.mul(vReserveOut);
        uint256 denominator = vReserveIn.add(amountInWithFee);
        amountOut = numerator.div(denominator);
        require(reserveOut > amountOut, "DMMLibrary: INSUFFICIENT_LIQUIDITY");
        return amountOut;
    }

    function getTradeInfo(
        IDMMPool pool,
        IERC20 tokenA,
        IERC20 tokenB
    ) internal view returns (
        uint256 reserveA,
        uint256 reserveB,
        uint256 vReserveA,
        uint256 vReserveB,
        uint256 feeInPrecision
    )
    {
        (IERC20 token0,) = sortTokens(tokenA, tokenB);
        uint256 reserve0;
        uint256 reserve1;
        uint256 vReserve0;
        uint256 vReserve1;
        (reserve0, reserve1, vReserve0, vReserve1, feeInPrecision) = pool.getTradeInfo();
        (reserveA, reserveB, vReserveA, vReserveB) = tokenA == token0 ? (reserve0, reserve1, vReserve0, vReserve1) : (reserve1, reserve0, vReserve1, vReserve0);
    }

    // returns sorted token addresses, used to handle return values from pools sorted in this order
    function sortTokens(IERC20 tokenA, IERC20 tokenB) internal pure returns (IERC20 token0, IERC20 token1){
        require(tokenA != tokenB, "DMMLibrary: IDENTICAL_ADDRESSES");
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(address(token0) != address(0), "DMMLibrary: ZERO_ADDRESS");
    }
}

library IDMMFactoryExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using IDMMPoolExtension for IDMMPool;
    using Tokens for IERC20;

    function calculateSwapReturn(
        IDMMFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapAVAX();
        IERC20 realOutToken = outToken.wrapAVAX();
        address[] memory pools = factory.getPools(realInToken, realOutToken);
        if (pools.length != 0) {
            for (uint256 i = 0; i < inAmounts.length; i++) {
                (outAmounts[i],) = findOptimalAmt(pools, realInToken, realOutToken, inAmounts[i]);
            }
            //TODO gas fee
            return (outAmounts, 50_000);
        }
    }

    function findOptimalAmt(address[] memory pools, IERC20 inToken, IERC20 outToken, uint256 amtIn) internal view returns (uint256, address) {
        uint256 outAmt;
        address pool;
        for (uint i = 0; i < pools.length; i++) {
            uint256 res = IDMMPool(pools[i]).calculateSwapReturn(inToken, outToken, amtIn);
            if (res > outAmt) {
                outAmt = res;
                pool = pools[i];
            }
        }
        return (outAmt, pool);
    }

    function calculateTransitionalSwapReturn(
        IDMMFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapAVAX();
        IERC20 realTransitionToken = transitionToken.wrapAVAX();
        IERC20 realOutToken = outToken.wrapAVAX();

        if (realInToken == realTransitionToken || realOutToken == realTransitionToken) {
            return (new uint256[](inAmounts.length), 0);
        }
        uint256 firstGas;
        uint256 secondGas;
        (outAmounts, firstGas) = calculateSwapReturn(factory, realInToken, realTransitionToken, inAmounts);
        (outAmounts, secondGas) = calculateSwapReturn(factory, realTransitionToken, realOutToken, outAmounts);
        return (outAmounts, firstGas + secondGas);
    }

    function swap(
        IDMMFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWAVAX(inAmount);

        IERC20 realInToken = inToken.wrapAVAX();
        IERC20 realOutToken = outToken.wrapAVAX();
        address[] memory pools = factory.getPools(realInToken, realOutToken);

        if (pools.length != 0) {
            address pool;
            (outAmount, pool) = findOptimalAmt(pools, realInToken, realOutToken, inAmount);
            realInToken.universalTransfer(pool, inAmount);
            if (uint256(address(realInToken)) < uint256(address(realOutToken))) {
                IDMMPool(pool).swap(0, outAmount, address(this), new bytes(0));
            } else {
                IDMMPool(pool).swap(outAmount, 0, address(this), new bytes(0));
            }
        }
        outToken.withdrawFromWAVAX();
    }

    function swapTransitional(
        IDMMFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
    }
}
