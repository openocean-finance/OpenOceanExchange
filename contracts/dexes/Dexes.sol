// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./ISushiSwap.sol";
import "./ISpookySwap.sol";
import "./ISpiritSwap.sol";
import "./ICurve.sol";

    enum Dex {
        SushiSwap,
        SushiSwapFTM,

        //ISpookySwap
        SpookySwap,
        SpookySwapFTM,

        //ISpookySwap
        SpiritSwap,
        SpiritSwapFTM,

        //ICurve
        Curve2POOL,
        CurvefUSDT,
        CurverenBTC,
        NoDex
    }

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

    using ICurvePoolExtension for ICurvePool;

    //https://ftmscan.com/address/0xef45d134b73241eda7703fa787148d9c9f4950b0#code
    ISpiritSwapFactory internal constant spiritswap = ISpiritSwapFactory(0xEF45d134b73241eDa7703fa787148D9C9F4950b0);
    using ISpiritSwapFactoryExtension for ISpiritSwapFactory;

    ISpookySwapFactory internal constant spookyswap = ISpookySwapFactory(0x152eE697f2E276fA89E96742e9bB9aB1F2E61bE3);
    using ISpookySwapFactoryExtension for ISpookySwapFactory;

    ISushiSwapFactory internal constant sushiswap = ISushiSwapFactory(0xc35DADB65012eC5796536bD9864eD8773aBc74C4);
    using ISushiSwapFactoryExtension for ISushiSwapFactory;

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

        if (dex == Dex.Curve2POOL && !flags.on(Flags.FLAG_DISABLE_CURVE_2POOL)) {
            return ICurvePoolExtension.CURVE_2POOL.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        if (dex == Dex.CurvefUSDT && !flags.on(Flags.FLAG_DISABLE_CURVE_FUSDT)) {
            return ICurvePoolExtension.CURVE_fUSDT.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurverenBTC && !flags.on(Flags.FLAG_DISABLE_CURVE_RENBTC)) {
            return ICurvePoolExtension.CURVE_renBTC.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // add SpiritSwap
        if (dex == Dex.SpiritSwap && !flags.or(Flags.FLAG_DISABLE_SPIRITSWAP_ALL, Flags.FLAG_DISABLE_SPIRITSWAP)) {
            return spiritswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        if (dex == Dex.SpiritSwapFTM && !flags.or(Flags.FLAG_DISABLE_SPIRITSWAP_ALL, Flags.FLAG_DISABLE_SPIRITSWAP_FTM)) {
            return spiritswap.calculateTransitionalSwapReturn(inToken, Tokens.WFTM, outToken, inAmounts);
        }

        // add SpookySwap
        if (dex == Dex.SpookySwap && !flags.or(Flags.FLAG_DISABLE_SPOOKYSWAP_ALL, Flags.FLAG_DISABLE_SPOOKYSWAP)) {
            return spookyswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.SpookySwapFTM && !flags.or(Flags.FLAG_DISABLE_SPOOKYSWAP_ALL, Flags.FLAG_DISABLE_SPOOKYSWAP_FTM)) {
            return spookyswap.calculateTransitionalSwapReturn(inToken, Tokens.WFTM, outToken, inAmounts);
        }

        // add SushiSwap
        if (dex == Dex.SushiSwap && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP)) {
            return sushiswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapFTM && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_FTM)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.WFTM, outToken, inAmounts);
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

        if (dex == Dex.Curve2POOL && !flags.on(Flags.FLAG_DISABLE_CURVE_2POOL)) {
            ICurvePoolExtension.CURVE_2POOL.swap(inToken, outToken, amount);
        }

        if (dex == Dex.CurvefUSDT && !flags.on(Flags.FLAG_DISABLE_CURVE_FUSDT)) {
            ICurvePoolExtension.CURVE_fUSDT.swap(inToken, outToken, amount);
        }
        if (dex == Dex.CurverenBTC && !flags.on(Flags.FLAG_DISABLE_CURVE_RENBTC)) {
            ICurvePoolExtension.CURVE_renBTC.swap(inToken, outToken, amount);
        }


        // add SpiritSwap
        if (dex == Dex.SpiritSwap && !flags.or(Flags.FLAG_DISABLE_SPIRITSWAP_ALL, Flags.FLAG_DISABLE_SPIRITSWAP)) {
            spiritswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.SpiritSwapFTM && !flags.or(Flags.FLAG_DISABLE_SPIRITSWAP_ALL, Flags.FLAG_DISABLE_SPIRITSWAP_FTM)) {
            spiritswap.swapTransitional(inToken, Tokens.WFTM, outToken, amount);
        }

        // add SpookySwap
        if (dex == Dex.SpookySwap && !flags.or(Flags.FLAG_DISABLE_SPOOKYSWAP_ALL, Flags.FLAG_DISABLE_SPOOKYSWAP)) {
            spookyswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.SpookySwapFTM && !flags.or(Flags.FLAG_DISABLE_SPOOKYSWAP_ALL, Flags.FLAG_DISABLE_SPOOKYSWAP_FTM)) {
            spookyswap.swapTransitional(inToken, Tokens.WFTM, outToken, amount);
        }

        // add SushiSwap
        if (dex == Dex.SushiSwap && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP)) {
            sushiswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.SushiSwapFTM && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_FTM)) {
            sushiswap.swapTransitional(inToken, Tokens.WFTM, outToken, amount);
        }
    }
}
