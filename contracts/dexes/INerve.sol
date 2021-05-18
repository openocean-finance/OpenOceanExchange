// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";


/**
 * @notice  https://github.com/nerve-finance/contracts
 */
interface INerve {
    function getTokenIndex(address tokenAddress) external view returns (uint8);

    function calculateSwap(
        uint8 tokenIndexFrom,
        uint8 tokenIndexTo,
        uint256 dx
    ) external view returns (uint256);

    function swap(
        uint8 tokenIndexFrom,
        uint8 tokenIndexTo,
        uint256 dx,
        uint256 minDy,
        uint256 deadline
    ) external returns (uint256);
}

library INerveExtension {
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;


    function calculateSwapReturn(
        INerve nerve,
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount
    ) internal view returns (uint256) {
        if (amount == 0) {
            return 0;
        }
        uint8 inIndex = nerve.getTokenIndex(address(inToken));
        uint8 outIndex = nerve.getTokenIndex(address(outToken));
        return nerve.calculateSwap(inIndex, outIndex, amount);
    }

    function calculateSwapReturn(
        INerve nerve,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        for (uint256 i = 0; i < inAmounts.length; i++) {
            outAmounts[i] = calculateSwapReturn(nerve, realInToken, realOutToken, inAmounts[i]);
        }
        //todo gas
        return (outAmounts, 50_000);
    }

    function calculateTransitionalSwapReturn(
        INerve nerve,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realTransitionToken = transitionToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();

        if (realInToken == realTransitionToken || realOutToken == realTransitionToken) {
            return (new uint256[](inAmounts.length), 0);
        }
        uint256 firstGas;
        uint256 secondGas;
        (outAmounts, firstGas) = calculateSwapReturn(nerve, realInToken, realTransitionToken, inAmounts);
        (outAmounts, secondGas) = calculateSwapReturn(nerve, realTransitionToken, realOutToken, outAmounts);
        return (outAmounts, firstGas + secondGas);
    }


    function swap(
        INerve nerve,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();

        realInToken.approve(address(nerve), inAmount);

        outAmount = calculateSwapReturn(nerve, realInToken, realOutToken, inAmount);

        uint8 inIndex = nerve.getTokenIndex(address(inToken));
        uint8 outIndex = nerve.getTokenIndex(address(outToken));
        uint nowTime = block.timestamp;
        //todo deadline
        nerve.swap(inIndex, outIndex, inAmount, outAmount, nowTime + 1000);
        outToken.withdrawFromWETH();
    }

    function swapTransitional(
        INerve nerve,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(nerve, transitionToken, outToken, swap(nerve, inToken, transitionToken, inAmount));
    }
}

