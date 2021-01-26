// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";

library IWETHExtension {
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;

    function calculateSwapReturn(
        IWETH,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal pure returns (uint256[] memory outAmounts, uint256 gas) {
        if (inToken.isETH() && outToken.isWETH()) {
            return (inAmounts, 30_000);
        }
        if (inToken.isWETH() && outToken.isETH()) {
            return (inAmounts, 30_000);
        }

        outAmounts = new uint256[](inAmounts.length);
        return (outAmounts, 0);
    }

    function swap(
        IWETH,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        inToken.depositToWETH(inAmount);
        outToken.withdrawFromWETH();
    }
}
