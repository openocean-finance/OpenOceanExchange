// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";

//https://github.com/mstable/mStable-contracts/blob/master-v2/contracts/masset/Masset.sol

interface IMasset {
    function getSwapOutput(
        address _input,
        address _output,
        uint256 _inputQuantity
    ) external view returns (uint256 swapOutput);

    function swap(
        address _input,
        address _output,
        uint256 _inputQuantity,
        uint256 _minOutputQuantity,
        address _recipient
    ) external returns (uint256 swapOutput);
}

library IMassetExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;

    function calculateSwapReturn(
        IMasset factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapMATIC();
        IERC20 realOutToken = outToken.wrapMATIC();
        if (isValidAddress(address(realInToken)) && isValidAddress(address(realOutToken))) {
            for (uint256 i = 0; i < inAmounts.length; i++) {
                if (inAmounts[i] > 0) {
                    outAmounts[i] = factory.getSwapOutput(address(realInToken), address(realOutToken), inAmounts[i]);
                }
            }
            return (outAmounts, 50_000);
            //TODO fee
        }
    }

    function isValidAddress(address token) internal pure returns (bool) {
        if (token == address(Tokens.DAI) || token == address(Tokens.USDT) || token == address(Tokens.USDC)) {
            return true;
        } else {
            return false;
        }
    }

    function calculateTransitionalSwapReturn(
        IMasset factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapMATIC();
        IERC20 realTransitionToken = transitionToken.wrapMATIC();
        IERC20 realOutToken = outToken.wrapMATIC();

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
        IMasset factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapMATIC();
        IERC20 realOutToken = outToken.wrapMATIC();
        if (isValidAddress(address(realInToken)) && isValidAddress(address(realOutToken))) {
            outAmount = factory.getSwapOutput(address(realInToken), address(realOutToken), inAmount);
            realInToken.approve(address(factory), inAmount);
            outAmount = factory.swap(address(realInToken), address(realOutToken), inAmount, outAmount, address(this));
        }
        realOutToken.withdrawFromWETH();
        return outAmount;
    }

    function swapTransitional(
        IMasset factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
    }
}
