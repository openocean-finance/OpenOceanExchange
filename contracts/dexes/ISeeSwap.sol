// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
// POOL
//ONEs/USDs  0xc156f4a70c3f3fc0150e018e5fd424e590e24980
//SEE/ONEs   0xc7a55ce3182fe700535d1c37624b80313e4ed3ff
//ARANK/ONEs 0xec5fff2adb40a78be2969caae0f0bb45da2adaed
//EUSK/ONEs  0x5c5ce2b57c8a1c000c1bfd306ce39ff255b21dc3
//SEED/ONEs  0x8faa4dd7577d0966aaa6cbb399c8d58c57cd9fe5


interface IBPool {
    function getSwapFee() external view returns (uint);

    function swapExactAmountIn(
        address tokenIn,
        uint tokenAmountIn,
        address tokenOut,
        uint minAmountOut,
        uint maxPrice
    ) external returns (uint tokenAmountOut, uint spotPriceAfter);

    function calcSpotPrice(
        uint tokenBalanceIn,
        uint tokenWeightIn,
        uint tokenBalanceOut,
        uint tokenWeightOut,
        uint swapFee
    ) external pure returns (uint spotPrice);

    function calcOutGivenIn(
        uint tokenBalanceIn,
        uint tokenWeightIn,
        uint tokenBalanceOut,
        uint tokenWeightOut,
        uint tokenAmountIn,
        uint swapFee
    ) external pure returns (uint tokenAmountOut);

    // get denorm
    function getDenormalizedWeight(address token) external view returns (uint);

    function getBalance(address token) external view returns (uint);
}

library IBPoolExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;

    address internal constant ONEsUSDs = address(0xc156F4A70c3f3FC0150E018e5fD424e590e24980);
    address internal constant ONEsSEE = address(0xc7A55CE3182Fe700535D1C37624b80313e4ed3FF);
    address internal constant ONEsARANK = address(0xec5FfF2AdB40A78BE2969CAaE0F0Bb45DA2adAED);
    address internal constant ONEsEUSK = address(0x5C5ce2b57C8a1C000c1bFd306CE39ff255b21Dc3);
    address internal constant ONEsSEED = address(0x8FaA4dd7577d0966AAa6Cbb399c8D58C57CD9fe5);

    function getISeeSwapPool(IERC20 inToken, IERC20 outToken) internal pure returns (address) {
        IERC20 realInToken = inToken.wrapONE();
        IERC20 realOutToken = outToken.wrapONE();
        address other;
        if (address(realInToken) == address(Tokens.WONE)) {
            other = address(outToken);
        } else if (address(realOutToken) == address(Tokens.WONE)) {
            other = address(inToken);
        }
        if (address(other) == address(Tokens.USDs)) {
            return IBPoolExtension.ONEsUSDs;
        } else if (address(other) == address(Tokens.SEE)) {
            return IBPoolExtension.ONEsSEE;
        } else if (address(other) == address(Tokens.ARANK)) {
            return IBPoolExtension.ONEsARANK;
        } else if (address(other) == address(Tokens.EUSK)) {
            return IBPoolExtension.ONEsEUSK;
        } else if (address(other) == address(Tokens.SEED)) {
            return IBPoolExtension.ONEsSEED;
        }
        return address(0);
    }

    struct CalculateSwapReturnS {
        uint inBalance;
        uint inDenorm;
        uint outBalance;
        uint outDenorm;
        uint swapFee;
    }

    function calculateSwapReturn(
        IBPool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapONE();
        IERC20 realOutToken = outToken.wrapONE();
        CalculateSwapReturnS memory vars;
        vars.inBalance = pool.getBalance(address(realInToken));
        vars.inDenorm = pool.getDenormalizedWeight(address(realInToken));

        vars.outBalance = pool.getBalance(address(realOutToken));
        vars.outDenorm = pool.getDenormalizedWeight(address(realOutToken));

        vars.swapFee = pool.getSwapFee();

        for (uint256 i = 0; i < inAmounts.length; i++) {
            outAmounts[i] = pool.calcOutGivenIn(vars.inBalance, vars.inDenorm, vars.outBalance, vars.outDenorm, inAmounts[i], vars.swapFee);
        }
        return (outAmounts, vars.swapFee);
    }

    function calculateTransitionalSwapReturn(
        IBPool pool,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapONE();
        IERC20 realTransitionToken = transitionToken.wrapONE();
        IERC20 realOutToken = outToken.wrapONE();

        if (realInToken == realTransitionToken || realOutToken == realTransitionToken) {
            return (new uint256[](inAmounts.length), 0);
        }
        uint256 firstGas;
        uint256 secondGas;
        (outAmounts, firstGas) = calculateSwapReturn(pool, realInToken, realTransitionToken, inAmounts);
        address poolAddress = getISeeSwapPool(Tokens.WONE, realOutToken);
        IBPool pool2 = IBPool(poolAddress);
        (outAmounts, secondGas) = calculateSwapReturn(pool2, realTransitionToken, realOutToken, outAmounts);
        return (outAmounts, firstGas + secondGas);
    }

    function calculateRealSwapReturn(IBPool pool, IERC20 realInToken, IERC20 realOutToken, uint inAmount) internal view returns (uint, uint){
        uint inBalance = pool.getBalance(address(realInToken));
        uint inDenorm = pool.getDenormalizedWeight(address(realInToken));

        uint outBalance = pool.getBalance(address(realOutToken));
        uint outDenorm = pool.getDenormalizedWeight(address(realOutToken));

        uint swapFee = pool.getSwapFee();

        uint price = pool.calcSpotPrice(inBalance, inDenorm, outBalance, outDenorm, swapFee);

        uint out = pool.calcOutGivenIn(inBalance, inDenorm, outBalance, outDenorm, inAmount, swapFee);
        return (out, price);
    }

    function swap(
        IBPool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWAVAX(inAmount);

        IERC20 realInToken = inToken.wrapONE();
        IERC20 realOutToken = outToken.wrapONE();
        uint price;
        (outAmount, price) = calculateRealSwapReturn(pool, realInToken, realOutToken, inAmount);

        //TODO
        realInToken.universalTransfer(address(pool), inAmount);

        realInToken.approve(address(pool), inAmount);
        pool.swapExactAmountIn(address(realInToken), inAmount, address(realOutToken), outAmount, price);

        outToken.withdrawFromWONE();
    }

    function swapTransitional(
        IBPool factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        address poolAddr = getISeeSwapPool(transitionToken, outToken);
        IBPool pool2 = IBPool(poolAddr);
        swap(factory, transitionToken, outToken, swap(pool2, inToken, transitionToken, inAmount));
    }
}
