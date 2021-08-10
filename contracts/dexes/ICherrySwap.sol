// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";

interface ICherryFactory {
    function getPair(IERC20 tokenA, IERC20 tokenB) external view returns (ICherryPair pair);
}


interface ICherryPair {
    function getReserves() external view returns (
        uint112 _reserve0,
        uint112 _reserve1,
        uint32 _blockTimestampLast
    );

    function skim(address to) external;

    function sync() external;

    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
}


library ICherryPairExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    address private constant SKIM_TARGET = 0x5bDCE812ce8409442ac3FBbd10565F9B17A6C49D;

    function calculateSwapReturn(ICherryPair pair, IERC20 inToken, IERC20 outToken, uint256 amount) internal view returns (uint256) {
        if (amount == 0) {
            return 0;
        }

        uint256 inReserve = inToken.universalBalanceOf(address(pair));
        uint256 outReserve = outToken.universalBalanceOf(address(pair));
        return doCalculate(inReserve, outReserve, amount);
    }

    function calculateRealSwapReturn(
        ICherryPair pair, IERC20 inToken, IERC20 outToken, uint256 amount) internal returns (uint256) {
        uint256 inReserve = inToken.universalBalanceOf(address(pair));
        uint256 outReserve = outToken.universalBalanceOf(address(pair));

        (uint112 reserve0, uint112 reserve1,) = pair.getReserves();
        if (inToken > outToken) {
            (reserve0, reserve1) = (reserve1, reserve0);
        }
        if (inReserve < reserve0 || outReserve < reserve1) {
            pair.sync();
        } else if (inReserve > reserve0 || outReserve > reserve1) {
            pair.skim(SKIM_TARGET);
        }

        return doCalculate(Math.min(inReserve, reserve0), Math.min(outReserve, reserve1), amount);
    }

    function doCalculate(
        uint256 inReserve,
        uint256 outReserve,
        uint256 amount
    ) private pure returns (uint256) {
        uint256 inAmountWithFee = amount.mul(997);
        // Uniswap V2 now requires fixed 0.3% swap fee
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.mul(1000).add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}


library ICherryFactoryExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using ICherryPairExtension for ICherryPair;
    using Tokens for IERC20;

    event Test(uint index, uint data);

    function calculateSwapReturn(
        ICherryFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapOKT();
        IERC20 realOutToken = outToken.wrapOKT();
        ICherryPair pair = factory.getPair(realInToken, realOutToken);
        if (pair != ICherryPair(0)) {
            for (uint256 i = 0; i < inAmounts.length; i++) {
                outAmounts[i] = pair.calculateSwapReturn(realInToken, realOutToken, inAmounts[i]);
            }
            return (outAmounts, 50_000);
        }
    }

    function calculateTransitionalSwapReturn(
        ICherryFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapOKT();
        IERC20 realTransitionToken = transitionToken.wrapOKT();
        IERC20 realOutToken = outToken.wrapOKT();

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
        ICherryFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWOKT(inAmount);

        IERC20 realInToken = inToken.wrapOKT();
        IERC20 realOutToken = outToken.wrapOKT();
        ICherryPair pair = factory.getPair(realInToken, realOutToken);

        outAmount = pair.calculateRealSwapReturn(realInToken, realOutToken, inAmount);

        realInToken.universalTransfer(address(pair), inAmount);
        if (uint256(address(realInToken)) < uint256(address(realOutToken))) {
            pair.swap(0, outAmount, address(this), "");
        } else {
            pair.swap(outAmount, 0, address(this), "");
        }
        emit Test(1, outToken.balanceOf(address(this)));
        outToken.withdrawFromWOKT();
        emit Test(2, outToken.balanceOf(address(this)));
    }

    function swapTransitional(
        ICherryFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
    }
}
