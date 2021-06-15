// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "./IPancakeV2.sol";

interface IZapBsc {
    function zapInToken(address _from, uint amount, address _to) external;
}

interface IPancakeRouter02 {
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external view returns (uint amountOut);
}


library IZapBscExtension {

    using UniversalERC20 for IERC20;
    using Tokens for IERC20;


    IPancakeRouter02 private constant ROUTER = IPancakeRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
    IPancakeFactoryV2 private constant pancakeFactory = IPancakeFactoryV2(0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73);

    function calculateSwapReturn(
        IZapBsc factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        IPancakePairV2 pair = pancakeFactory.getPair(realInToken, realOutToken);
        if (address(pair) != address(0)) {
            uint inBalance = realInToken.balanceOf(address(pair));
            uint outBalance = realOutToken.balanceOf(address(pair));
            for (uint256 i = 0; i < inAmounts.length; i++) {
                outAmounts[i] = ROUTER.getAmountOut(inAmounts[i], inBalance, outBalance);
            }
            return (outAmounts, 50_000);
        }
    }

    function calculateRealSwapReturn(
        IZapBsc factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal view returns (uint256 outAmount, uint256 gas){
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        IPancakePairV2 pair = pancakeFactory.getPair(realInToken, realOutToken);
        if (address(pair) != address(0)) {
            uint inBalance = realInToken.balanceOf(address(pair));
            uint outBalance = realOutToken.balanceOf(address(pair));
            outAmount = ROUTER.getAmountOut(inAmount, inBalance, outBalance);
            return (outAmount, 50_000);
        }
    }

    function calculateTransitionalSwapReturn(
        IZapBsc factory,
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
        (outAmounts, firstGas) = calculateSwapReturn(factory, realInToken, realTransitionToken, inAmounts);
        (outAmounts, secondGas) = calculateSwapReturn(factory, realTransitionToken, realOutToken, outAmounts);
        return (outAmounts, firstGas + secondGas);
    }

    function swap(
        IZapBsc factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();

        realInToken.approve(address(factory), inAmount);
        factory.zapInToken(address(realInToken), inAmount, address(realOutToken));

        realOutToken.withdrawFromWETH();
    }

    function swapTransitional(
        IZapBsc factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
    }
}
