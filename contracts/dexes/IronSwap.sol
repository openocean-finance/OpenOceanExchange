// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";

/**
 * @notice Pool contracts of curve.fi
 * See https://github.com/curvefi/curve-vue/blob/master/src/docs/README.md#how-to-integrate-curve-smart-contracts
 */
interface IronSwap {
    function calculateSwap(
        uint8 inIndex,
        uint8 outIndex,
        uint256 inAmount
    ) external view returns (uint256);

    function getTokenIndex(address token) external view returns (uint8 index);

    function swap(
        uint8 fromIndex,
        uint8 toIndex,
        uint256 inAmount,
        uint256 minOutAmount,
        uint256 deadline
    ) external returns (uint256);
}

// only support USDC-2 DAI-1 fUSDT-0
library IronSwapExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    function calculateSwapReturn(
        IronSwap pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        uint8 i = pool.getTokenIndex(address(inToken));
        uint8 j = pool.getTokenIndex(address(outToken));
        for (uint256 k = 0; k < inAmounts.length; k++) {
            outAmounts[k] = pool.calculateSwap(i, j, inAmounts[k]);
        }
        gas;
        //TODO gas
    }

    function swap(
        IronSwap pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        uint8 i = pool.getTokenIndex(address(inToken));
        uint8 j = pool.getTokenIndex(address(outToken));
        inToken.universalApprove(address(pool), inAmount);
        uint dy = pool.calculateSwap(i, j, inAmount);
        pool.swap(i, j, inAmount, dy, block.timestamp + 1000);
    }

    function determineTokenIndex(
        IERC20 inToken,
        IERC20 outToken,
        IERC20[] memory tokens
    ) private pure returns (int128, int128) {
        int128 i = - 1;
        int128 j = - 1;
        for (uint256 k = 0; k < tokens.length; k++) {
            IERC20 token = tokens[k];
            if (inToken == token) {
                i = int128(k);
            }
            if (outToken == token) {
                j = int128(k);
            }
        }
        return (i, j);
    }
}
