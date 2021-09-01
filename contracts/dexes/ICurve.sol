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
interface ICurvePool {
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


library ICurvePoolExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    // Curve.fi pool contracts
    // 0 DAI 1 USDC
    ICurvePool internal constant CURVE_2POOL = ICurvePool(0x27E611FD27b276ACbd5Ffd632E5eAEBEC9761E40);
    // 0 fUSDT 1 DAI  2 USDC
    ICurvePool internal constant CURVE_fUSDT = ICurvePool(0x92D5ebF3593a92888C25C0AbEF126583d4b5312E);
    // 0 BTC 1 renBTC
    ICurvePool internal constant CURVE_renBTC = ICurvePool(0x3eF6A01A0f81D6046290f3e2A8c5b843e738E604);


    function calculateSwapReturn(
        ICurvePool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        IERC20[] memory tokens;
        bool underlying;
        (tokens, underlying) = getPoolConfig(pool);

        // determine curve token index
        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == - 1 || j == - 1) {
            return (outAmounts, 0);
        }

        for (uint256 k = 0; k < outAmounts.length; k++) {
            if (underlying) {
                outAmounts[k] = pool.get_dy_underlying(i, j, inAmounts[k]);
            } else {
                outAmounts[k] = pool.get_dy(i, j, inAmounts[k]);
            }
        }
    }

    function swap(
        ICurvePool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        (IERC20[] memory tokens, bool underlying) = getPoolConfig(pool);

        // determine curve token index
        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == - 1 || j == - 1) {
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
    function getPoolConfig(ICurvePool pool) private pure returns (IERC20[] memory tokens, bool underlying){
        if (pool == CURVE_2POOL) {
            tokens = new IERC20[](2);
            tokens[0] = Tokens.DAI;
            tokens[1] = Tokens.USDC;
            underlying = false;
        } else if (pool == CURVE_fUSDT) {
            tokens = new IERC20[](3);
            tokens[0] = Tokens.fUSDT;
            tokens[1] = Tokens.DAI;
            tokens[2] = Tokens.USDC;
            underlying = true;
        } else if (pool == CURVE_renBTC) {
            tokens = new IERC20[](4);
            tokens[0] = Tokens.BTC;
            tokens[1] = Tokens.renBTC;
            underlying = false;
        }
    }
}
