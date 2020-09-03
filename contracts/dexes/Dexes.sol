// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./IUniswapV2.sol";
import "./ICurvePool.sol";
import "./IOasis.sol";
import "./IUniswap.sol";

enum Dex {
    UniswapV2,
    UniswapV2ETH,
    UniswapV2DAI,
    UniswapV2USDC,
    CurveCompound,
    CurveUSDT,
    CurveY,
    CurveBinance,
    CurveSynthetix,
    CurvePAX,
    CurveRenBTC,
    CurveTBTC,
    CurveSBTC,
    Oasis,
    Uniswap,
    Curve,
    // bottom mark
    NoDex
}

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

    IUniswapV2Factory internal constant uniswapV2 = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
    using IUniswapV2FactoryExtension for IUniswapV2Factory;

    ICurveRegistry internal constant curveRegistry = ICurveRegistry(0x7002B727Ef8F5571Cb5F9D70D13DBEEb4dFAe9d1);
    using ICurveRegistryExtension for ICurveRegistry;

    IOasis internal constant oasis = IOasis(0x794e6e91555438aFc3ccF1c5076A74F42133d08D);
    using IOasisExtension for IOasis;

    IUniswapFactory internal constant uniswap = IUniswapFactory(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);
    using IUniswapFactoryExtension for IUniswapFactory;

    function allDexes() internal pure returns (Dex[] memory dexes) {
        uint256 dexCount = uint256(Dex.NoDex);
        dexes = new Dex[](dexCount);
        for (uint256 i = 0; i < dexCount; i++) {
            dexes[i] = Dex(i);
        }
    }

    function calculateSwapReturn(
        Dex dex,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts,
        uint256 flags
    ) internal view returns (uint256[] memory, uint256) {
        if (dex == Dex.UniswapV2 && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2)) {
            return uniswapV2.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.UniswapV2ETH && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_ETH)) {
            return uniswapV2.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.UniswapV2DAI && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_DAI)) {
            return uniswapV2.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.UniswapV2USDC && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_USDC)) {
            return uniswapV2.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.CurveCompound && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_COMPOUND)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_COMPOUND, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveUSDT && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_USDT)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_USDT, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveY && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_Y)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_Y, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveBinance && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_BINANCE)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_BINANCE, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveSynthetix && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_SYNTHETIX)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_SYNTHETIX, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurvePAX && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_PAX)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_PAX, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveRenBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_RENBTC)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_REN_BTC, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveTBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_TBTC)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_TBTC, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveSBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_SBTC)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_SBTC, inToken, outToken, inAmounts);
        }
        if (dex == Dex.Oasis && !flags.on(Flags.FLAG_DISABLE_OASIS)) {
            return oasis.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.Uniswap && !flags.on(Flags.FLAG_DISABLE_UNISWAP)) {
            return uniswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        // fallback
        return (new uint256[](inAmounts.length), 0);
    }

    function swap(
        Dex dex,
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount,
        uint256 flags
    ) internal {
        if (dex == Dex.UniswapV2 && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2)) {
            uniswapV2.swap(inToken, outToken, amount);
        }
        if (dex == Dex.UniswapV2ETH && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_ETH)) {
            uniswapV2.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.UniswapV2DAI && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_DAI)) {
            uniswapV2.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.UniswapV2USDC && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_USDC)) {
            uniswapV2.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.CurveCompound && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_COMPOUND)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_COMPOUND, inToken, outToken, amount);
        }
        if (dex == Dex.CurveUSDT && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_USDT)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_USDT, inToken, outToken, amount);
        }
        if (dex == Dex.CurveY && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_Y)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_Y, inToken, outToken, amount);
        }
        if (dex == Dex.CurveBinance && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_BINANCE)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_BINANCE, inToken, outToken, amount);
        }
        if (dex == Dex.CurveSynthetix && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_SYNTHETIX)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_SYNTHETIX, inToken, outToken, amount);
        }
        if (dex == Dex.CurvePAX && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_PAX)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_PAX, inToken, outToken, amount);
        }
        if (dex == Dex.CurveRenBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_RENBTC)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_REN_BTC, inToken, outToken, amount);
        }
        if (dex == Dex.CurveTBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_TBTC)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_TBTC, inToken, outToken, amount);
        }
        if (dex == Dex.CurveSBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_SBTC)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_SBTC, inToken, outToken, amount);
        }
        if (dex == Dex.Oasis && !flags.on(Flags.FLAG_DISABLE_OASIS)) {
            oasis.swap(inToken, outToken, amount);
        }
        if (dex == Dex.Uniswap && !flags.on(Flags.FLAG_DISABLE_UNISWAP)) {
            uniswap.swap(inToken, outToken, amount);
        }
    }
}
