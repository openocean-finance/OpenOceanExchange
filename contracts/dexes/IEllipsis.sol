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
interface IEllipsisPool {
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
        uint256 minDy
    ) external;

    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 minDy
    ) external;
}

library IEllipsisPoolExtension {
    using UniversalERC20 for IERC20;

    IEllipsisPool internal constant ELLIPSIS_USD = IEllipsisPool(0x160CAed03795365F3A589f10C379FfA7d75d4E76);
    IEllipsisPool internal constant ELLIPSIS_BTC = IEllipsisPool(0x2477fB288c5b4118315714ad3c7Fd7CC69b00bf9);
    IEllipsisPool internal constant ELLIPSIS_FUSDT = IEllipsisPool(0x556ea0b4c06D043806859c9490072FaadC104b63);

    function calculateSwapReturn(
        IEllipsisPool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        IERC20[] memory tokens;
        bool underlying;
        (tokens, underlying, gas) = getPoolConfig(pool);

        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == -1 || j == -1) {
            return (outAmounts, 0);
        }
        if (underlying && i != 0 && j != 0) {
            return (outAmounts, 0);
        }

        for (uint256 k = 0; k < inAmounts.length; k++) {
            if (underlying) {
                outAmounts[k] = pool.get_dy_underlying(i, j, inAmounts[k]);
            } else {
                outAmounts[k] = pool.get_dy(i, j, inAmounts[k]);
            }
        }
    }

    function swap(
        IEllipsisPool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        (IERC20[] memory tokens, bool underlying, ) = getPoolConfig(pool);

        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == -1 || j == -1) {
            return;
        }
        if (underlying && i != 0 && j != 0) {
            return;
        }

        inToken.universalApprove(address(pool), inAmount);
        if (underlying) {
            pool.exchange_underlying(i, j, inAmount, 0);
        } else {
            pool.exchange(i, j, inAmount, 0);
        }
    }

    function determineTokenIndex(
        IERC20 inToken,
        IERC20 outToken,
        IERC20[] memory tokens
    ) private pure returns (int128, int128) {
        int128 i = -1;
        int128 j = -1;
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
    function getPoolConfig(IEllipsisPool pool)
        private
        pure
        returns (
            IERC20[] memory tokens,
            bool underlying,
            uint256 gas
        )
    {
        if (pool == ELLIPSIS_USD) {
            tokens = new IERC20[](3);
            tokens[0] = Tokens.BUSD;
            tokens[1] = Tokens.USDC;
            tokens[2] = Tokens.USDT;
            underlying = false;
            gas = 720_000;
        } else if (pool == ELLIPSIS_FUSDT) {
            tokens = new IERC20[](4);
            tokens[0] = Tokens.fUSDT;
            tokens[1] = Tokens.BUSD;
            tokens[2] = Tokens.USDC;
            tokens[3] = Tokens.USDT;
            underlying = true;
            gas = 1_400_000;
        } else if (pool == ELLIPSIS_BTC) {
            tokens = new IERC20[](3);
            tokens[0] = Tokens.BTCB;
            tokens[1] = Tokens.RENBTC;
            underlying = false;
            gas = 720_000;
        }
    }
}
