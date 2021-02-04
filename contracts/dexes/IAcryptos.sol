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
interface IAcryptosPool {
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

library IAcryptosPoolExtension {
    using UniversalERC20 for IERC20;

    IAcryptosPool internal constant ACRYPTOS_USD = IAcryptosPool(0xb3F0C9ea1F05e312093Fdb031E789A756659B0AC);
    IAcryptosPool internal constant ACRYPTOS_VAI = IAcryptosPool(0x191409D5A4EfFe25b0f4240557BA2192D18a191e);
    IAcryptosPool internal constant ACRYPTOS_UST = IAcryptosPool(0x99c92765EfC472a9709Ced86310D64C4573c4b77);
    IAcryptosPool internal constant ACRYPTOS_QUSD = IAcryptosPool(0x3919874C7bc0699cF59c981C5eb668823FA4f958);

    function calculateSwapReturn(
        IAcryptosPool pool,
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
        IAcryptosPool pool,
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
    function getPoolConfig(IAcryptosPool pool)
        private
        pure
        returns (
            IERC20[] memory tokens,
            bool underlying,
            uint256 gas
        )
    {
        if (pool == ACRYPTOS_USD) {
            tokens = new IERC20[](4);
            tokens[0] = Tokens.BUSD;
            tokens[1] = Tokens.USDT;
            tokens[2] = Tokens.DAI;
            tokens[3] = Tokens.USDC;
            underlying = false;
            gas = 720_000;
        } else if (pool == ACRYPTOS_VAI) {
            tokens = new IERC20[](5);
            tokens[0] = Tokens.VAI;
            tokens[1] = Tokens.BUSD;
            tokens[2] = Tokens.USDT;
            tokens[3] = Tokens.DAI;
            tokens[4] = Tokens.USDC;
            underlying = true;
            gas = 1_400_000;
        } else if (pool == ACRYPTOS_UST) {
            tokens = new IERC20[](5);
            tokens[0] = Tokens.UST;
            tokens[1] = Tokens.BUSD;
            tokens[2] = Tokens.USDT;
            tokens[3] = Tokens.DAI;
            tokens[4] = Tokens.USDC;
            underlying = true;
            gas = 1_400_000;
        } else if (pool == ACRYPTOS_QUSD) {
            tokens = new IERC20[](5);
            tokens[0] = Tokens.QUSD;
            tokens[1] = Tokens.BUSD;
            tokens[2] = Tokens.USDT;
            tokens[3] = Tokens.DAI;
            tokens[4] = Tokens.USDC;
            underlying = true;
            gas = 1_400_000;
        }
    }
}
