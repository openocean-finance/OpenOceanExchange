// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";


interface IOneSwap {
    function getTokenIndex(address tokenAddr) external view returns (uint8);

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

library IOneSwapExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;

    function calculateSwapReturn(
        IOneSwap factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        require(isValid(address(inToken)) && isValid(address(outToken)), "only support DAI USDC USDT");
        uint8 inIndex = factory.getTokenIndex(address(inToken));
        uint8 outIndex = factory.getTokenIndex(address(outToken));
        outAmounts = new uint256[](inAmounts.length);
        for (uint i = 0; i < inAmounts.length; i++) {
            outAmounts[i] = factory.calculateSwap(inIndex, outIndex, inAmounts[i]);
        }
        return (outAmounts, 50_000);
    }

    function swap(
        IOneSwap factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        require(isValid(address(inToken)) && isValid(address(outToken)), "only support DAI USDC USDT");
        uint8 inIndex = factory.getTokenIndex(address(inToken));
        uint8 outIndex = factory.getTokenIndex(address(outToken));
        outAmount = factory.calculateSwap(inIndex, outIndex, inAmount);
        inToken.approve(address(factory), inAmount);
        factory.swap(inIndex, outIndex, inAmount, outAmount, block.timestamp + 1000);
        return outAmount;
    }

    function isValid(address addr) internal pure returns (bool) {
        if (addr == address(Tokens.DAI) || addr == address(Tokens.USDC) || addr == address(Tokens.USDT)) {
            return true;
        } else {
            return false;
        }
    }
}

