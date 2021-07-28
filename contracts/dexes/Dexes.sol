// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./ISushiSwap.sol";
import "./IPangolinSwap.sol";
import "./IJoeSwap.sol";


    enum Dex {
        SushiSwap,
        SushiSwapETH,
        SushiSwapDAI,
        PangolinSwap,
        PangolinSwapETH,
        PangolinSwapDAI,
        JoeSwap,
        JoeSwapETH,
        JoeSwapDAI,
        NoDex
    }

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

    ISushiSwapFactory internal constant sushiswap = ISushiSwapFactory(0xc35DADB65012eC5796536bD9864eD8773aBc74C4);
    using ISushiSwapFactoryExtension for ISushiSwapFactory;

    IPangolinFactory internal constant pangolin = IPangolinFactory(0xefa94DE7a4656D787667C749f7E1223D71E9FD88);
    using IPangolinFactoryExtension for IPangolinFactory;

    IJoeFactory internal constant joe = IJoeFactory(0x9Ad6C38BE94206cA50bb0d90783181662f0Cfa10);
    using IJoeFactoryExtension for IJoeFactory;

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
        //add Joe
        if (dex == Dex.JoeSwap && !flags.or(Flags.FLAG_DISABLE_JOESWAP_ALL, Flags.FLAG_DISABLE_JOESWAP)) {
            return joe.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.JoeSwap && !flags.or(Flags.FLAG_DISABLE_JOESWAP_ALL, Flags.FLAG_DISABLE_JOESWAP_WAVAX)) {
            return joe.calculateTransitionalSwapReturn(inToken, Tokens.WAVAX, outToken, inAmounts);
        }
        if (dex == Dex.JoeSwap && !flags.or(Flags.FLAG_DISABLE_JOESWAP_ALL, Flags.FLAG_DISABLE_JOESWAP_DAI)) {
            return joe.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }

        //add pangolinSwap
        if (dex == Dex.PangolinSwap && !flags.or(Flags.FLAG_DISABLE_PANGONLINSWAP_ALL, Flags.FLAG_DISABLE_PANGONLINSWAP)) {
            return pangolin.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.PangolinSwap && !flags.or(Flags.FLAG_DISABLE_PANGONLINSWAP_ALL, Flags.FLAG_DISABLE_PANGONLINSWAP_WAVAX)) {
            return pangolin.calculateTransitionalSwapReturn(inToken, Tokens.WAVAX, outToken, inAmounts);
        }
        if (dex == Dex.PangolinSwap && !flags.or(Flags.FLAG_DISABLE_PANGONLINSWAP_ALL, Flags.FLAG_DISABLE_PANGONLINSWAP_DAI)) {
            return pangolin.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }

        // add SushiSwap
        if (dex == Dex.SushiSwap && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP)) {
            return sushiswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapETH && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_WAVAX)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.WAVAX, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapDAI && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_DAI)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
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
        //add Joe
        if (dex == Dex.JoeSwap && !flags.or(Flags.FLAG_DISABLE_JOESWAP_ALL, Flags.FLAG_DISABLE_JOESWAP)) {
            joe.swap(inToken, outToken, amount);
        }
        if (dex == Dex.JoeSwap && !flags.or(Flags.FLAG_DISABLE_JOESWAP_ALL, Flags.FLAG_DISABLE_JOESWAP_WAVAX)) {
            joe.swapTransitional(inToken, Tokens.WAVAX, outToken, amount);
        }
        if (dex == Dex.JoeSwap && !flags.or(Flags.FLAG_DISABLE_JOESWAP_ALL, Flags.FLAG_DISABLE_JOESWAP_DAI)) {
            joe.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }

        //add pangolinSwap
        if (dex == Dex.PangolinSwap && !flags.or(Flags.FLAG_DISABLE_PANGONLINSWAP_ALL, Flags.FLAG_DISABLE_PANGONLINSWAP)) {
            pangolin.swap(inToken, outToken, amount);
        }
        if (dex == Dex.PangolinSwap && !flags.or(Flags.FLAG_DISABLE_PANGONLINSWAP_ALL, Flags.FLAG_DISABLE_PANGONLINSWAP_WAVAX)) {
            pangolin.swapTransitional(inToken, Tokens.WAVAX, outToken, amount);
        }
        if (dex == Dex.PangolinSwap && !flags.or(Flags.FLAG_DISABLE_PANGONLINSWAP_ALL, Flags.FLAG_DISABLE_PANGONLINSWAP_DAI)) {
            pangolin.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }

        // add SushiSwap
        if (dex == Dex.SushiSwap && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP)) {
            sushiswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.SushiSwapETH && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_WAVAX)) {
            sushiswap.swapTransitional(inToken, Tokens.WAVAX, outToken, amount);
        }
        if (dex == Dex.SushiSwapDAI && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_DAI)) {
            sushiswap.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
    }
}
