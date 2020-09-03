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

/**
 * See https://github.com/curvefi/curve-pool-registry/blob/b17/doc/notebook/playbook.ipynb
 */
interface ICurveRegistry {
    function get_pool_info(address pool)
        external
        view
        returns (
            uint256[8] memory balances,
            uint256[8] memory underlyingBalances,
            uint256[8] memory decimals,
            uint256[8] memory underlyingDecimals,
            address curveToken,
            uint256 amp,
            uint256 fee
        );
}

interface ICurveCalculator {
    /**
     * @notice Bulk-calculate amount of of coin j given in exchange for coin i
     * @param nCoins Number of coins in the pool
     * @param balances Array with coin balances
     * @param amp Amplification coefficient
     * @param fee Pool's fee at 1e10 basis
     * @param rates Array with rates for "lent out" tokens
     * @param precisions Precision multipliers to get the coin to 1e18 basis
     * @param underlying Whether the coin is in raw or lent-out form
     * @param i Index of the changed coin (trade in)
     * @param j Index of the other changed coin (trade out)
     * @param dx Array of values of coin i (trade in)
     * Return array of values of coin j (trade out)
     * See https://github.com/curvefi/curve-pool-registry/blob/master/contracts/CurveCalc.vy
     */
    function get_dy(
        int128 nCoins,
        uint256[8] calldata balances,
        uint256 amp,
        uint256 fee,
        uint256[8] calldata rates,
        uint256[8] calldata precisions,
        bool underlying,
        int128 i,
        int128 j,
        uint256[100] calldata dx
    ) external view returns (uint256[100] memory dy);
}

library ICurveRegistryExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    ICurveCalculator internal constant CURVE_CALCULATOR = ICurveCalculator(0xc1DB00a8E5Ef7bfa476395cdbcc98235477cDE4E);

    // Curve.fi pool contracts
    ICurvePool internal constant CURVE_COMPOUND = ICurvePool(0xA2B47E3D5c44877cca798226B7B8118F9BFb7A56);
    ICurvePool internal constant CURVE_USDT = ICurvePool(0x52EA46506B9CC5Ef470C5bf89f17Dc28bB35D85C);
    ICurvePool internal constant CURVE_Y = ICurvePool(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
    ICurvePool internal constant CURVE_BINANCE = ICurvePool(0x79a8C46DeA5aDa233ABaFFD40F3A0A2B1e5A4F27);
    ICurvePool internal constant CURVE_SYNTHETIX = ICurvePool(0xA5407eAE9Ba41422680e2e00537571bcC53efBfD);
    ICurvePool internal constant CURVE_PAX = ICurvePool(0x06364f10B501e868329afBc005b3492902d6C763);
    ICurvePool internal constant CURVE_REN_BTC = ICurvePool(0x93054188d876f558f4a66B2EF1d97d16eDf0895B);
    ICurvePool internal constant CURVE_TBTC = ICurvePool(0x9726e9314eF1b96E45f40056bEd61A088897313E);
    ICurvePool internal constant CURVE_SBTC = ICurvePool(0x7fC77b5c7614E1533320Ea6DDc2Eb61fa00A9714);

    struct PoolInfo {
        uint256[8] balances;
        uint256[8] precisions;
        uint256[8] rates;
        uint256 amp;
        uint256 fee;
    }

    function calculateSwapReturn(
        ICurveRegistry registry,
        ICurvePool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        IERC20[] memory tokens;
        bool underlying;
        (tokens, underlying, gas) = getPoolConfig(pool);

        // determine curve token index
        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == -1 || j == -1) {
            return (outAmounts, 0);
        }

        // fill in amounts, ICurve need an array with fixed size 100
        uint256[100] memory amounts;
        for (uint256 k = 0; k < inAmounts.length; k++) {
            amounts[k] = inAmounts[k];
        }

        PoolInfo memory info = getCurvePoolInfo(registry, pool, underlying);

        (bool success, bytes memory data) = address(CURVE_CALCULATOR).staticcall(
            abi.encodePacked(
                abi.encodeWithSelector(
                    CURVE_CALCULATOR.get_dy.selector,
                    tokens.length,
                    info.balances,
                    info.amp,
                    info.fee,
                    info.rates,
                    info.precisions
                ),
                abi.encodePacked(uint256(underlying ? 1 : 0), uint256(i), uint256(j), amounts)
            )
        );

        if (success && data.length > 0) {
            uint256[100] memory dy = abi.decode(data, (uint256[100]));
            for (uint256 k = 0; k < outAmounts.length; k++) {
                outAmounts[k] = dy[k];
            }
        }
    }

    function swap(
        ICurveRegistry,
        ICurvePool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        (IERC20[] memory tokens, bool underlying, ) = getPoolConfig(pool);

        // determine curve token index
        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == -1 || j == -1) {
            return;
        }

        inToken.universalApprove(address(pool), inAmount);
        if (underlying) {
            pool.exchange_underlying(i, j, inAmount, 0);
        } else {
            pool.exchange(i, j, inAmount, 0);
        }
    }

    function getCurvePoolInfo(
        ICurveRegistry registry,
        ICurvePool pool,
        bool underlying
    ) private view returns (PoolInfo memory info) {
        uint256[8] memory underlyingBalances;
        uint256[8] memory decimals;
        uint256[8] memory underlyingDecimals;
        (info.balances, underlyingBalances, decimals, underlyingDecimals, , info.amp, info.fee) = registry.get_pool_info(
            address(pool)
        );

        for (uint256 i = 0; i < 8 && info.balances[i] > 0; i++) {
            uint256 decimal = underlying ? underlyingDecimals[i] : decimals[i];
            info.precisions[i] = 10**(18 - decimal);
            if (underlying) {
                info.rates[i] = underlyingBalances[i].mul(1e18).div(info.balances[i]);
            } else {
                info.rates[i] = 1e18;
            }
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
    function getPoolConfig(ICurvePool pool)
        private
        pure
        returns (
            IERC20[] memory tokens,
            bool underlying,
            uint256 gas
        )
    {
        if (pool == CURVE_COMPOUND) {
            tokens = new IERC20[](2);
            tokens[0] = Tokens.DAI;
            tokens[1] = Tokens.USDC;
            underlying = true;
            gas = 720_000;
        } else if (pool == CURVE_USDT) {
            tokens = new IERC20[](3);
            tokens[0] = Tokens.DAI;
            tokens[1] = Tokens.USDC;
            tokens[2] = Tokens.USDT;
            underlying = true;
            gas = 720_000;
        } else if (pool == CURVE_Y) {
            tokens = new IERC20[](4);
            tokens[0] = Tokens.DAI;
            tokens[1] = Tokens.USDC;
            tokens[2] = Tokens.USDT;
            tokens[3] = Tokens.TUSD;
            underlying = true;
            gas = 1_400_000;
        } else if (pool == CURVE_BINANCE) {
            tokens = new IERC20[](4);
            tokens[0] = Tokens.DAI;
            tokens[1] = Tokens.USDC;
            tokens[2] = Tokens.USDT;
            tokens[3] = Tokens.BUSD;
            underlying = true;
            gas = 1_400_000;
        } else if (pool == CURVE_SYNTHETIX) {
            tokens = new IERC20[](4);
            tokens[0] = Tokens.DAI;
            tokens[1] = Tokens.USDC;
            tokens[2] = Tokens.USDT;
            tokens[3] = Tokens.SUSD;
            underlying = true;
            gas = 200_000;
        } else if (pool == CURVE_PAX) {
            tokens = new IERC20[](4);
            tokens[0] = Tokens.DAI;
            tokens[1] = Tokens.USDC;
            tokens[2] = Tokens.USDT;
            tokens[3] = Tokens.PAX;
            underlying = true;
            gas = 1_000_000;
        } else if (pool == CURVE_REN_BTC) {
            tokens = new IERC20[](2);
            tokens[0] = Tokens.RENBTC;
            tokens[1] = Tokens.WBTC;
            underlying = false;
            gas = 130_000;
        } else if (pool == CURVE_TBTC) {
            tokens = new IERC20[](3);
            tokens[0] = Tokens.TBTC;
            tokens[1] = Tokens.WBTC;
            tokens[2] = Tokens.HBTC;
            underlying = false;
            gas = 145_000;
        } else if (pool == CURVE_SBTC) {
            tokens = new IERC20[](3);
            tokens[0] = Tokens.RENBTC;
            tokens[1] = Tokens.WBTC;
            tokens[2] = Tokens.SBTC;
            underlying = false;
            gas = 150_000;
        }
    }
}
