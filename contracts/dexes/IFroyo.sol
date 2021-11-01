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
interface IFroyoPool {
    function get_dy_underlying(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256 dy);

    function get_dy(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256 dy);

    function exchange_underlying(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 minDy,
        address _receiver
    ) external;

    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 minDy
    ) external;
}

// only support USDC-2 DAI-1 fUSDT-0
library IFroyoPoolExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    function calculateSwapReturn(
        IFroyoPool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        IERC20[] memory tokens = getPoolConfig();

        // determine curve token index
        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == - 1 || j == - 1) {
            return (outAmounts, 0);
        }

        for (uint256 k = 0; k < outAmounts.length; k++) {
            outAmounts[k] = pool.get_dy_underlying(i, j, inAmounts[k]);
        }
    }

    function swap(
        IFroyoPool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        IERC20[] memory tokens = getPoolConfig();

        // determine curve token index
        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == - 1 || j == - 1) {
            return;
        }
        inToken.universalApprove(address(pool), inAmount);
        uint dy = pool.get_dy_underlying(i, j, inAmount);
        pool.exchange(i, j, inAmount, dy);
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

    /**
     * @notice Build calculation arguments.
     * See https://github.com/curvefi/curve-vue/blob/master/src/docs/README.md
     */
    function getPoolConfig() private pure returns (IERC20[] memory tokens){
        tokens = new IERC20[](3);
        tokens[0] = Tokens.fUSDT;
        tokens[1] = Tokens.DAI;
        tokens[2] = Tokens.USDC;
    }
}
