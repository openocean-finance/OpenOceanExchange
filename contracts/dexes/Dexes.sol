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
import "./ILydiaSwap.sol";
import "./IBaguette.sol";
import "./IOoeswap.sol";
import "./IKyberDMM.sol";

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
        LydiaSwap,
        LydiaSwapETH,
        LydiaSwapDAI,
        BaguetteSwap,
        BaguetteSwapETH,
        BaguetteSwapDAI,
        OOESwap,
        KyberDMM,
        NoDex
    }

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

    IDMMFactory internal constant kyberDMM = IDMMFactory(0x10908C875D865C66f271F5d3949848971c9595C9);
    using IDMMFactoryExtension for IDMMFactory;


    IOoeswapFactory internal constant ooe = IOoeswapFactory(0x042AF448582d0a3cE3CFa5b65c2675e88610B18d);
    using IOoeswapFactoryExtension for IOoeswapFactory;

    IBaguetteFactory internal constant baguette = IBaguetteFactory(0x3587B8c0136c2C3605a9E5B03ab54Da3e4044b50);
    using IBaguetteFactoryExtension for IBaguetteFactory;

    ILydiaSwapFactory internal constant lydia = ILydiaSwapFactory(0xe0C1bb6DF4851feEEdc3E14Bd509FEAF428f7655);
    using ILydiaSwapFactoryExtension for ILydiaSwapFactory;

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
        // add kyberDMM
        if (dex == Dex.KyberDMM && !flags.on(Flags.FLAG_DISABLE_KYBERDMM_ALL)) {
            return kyberDMM.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // add ooeswap
        if (dex == Dex.OOESwap && !flags.on(Flags.FLAG_DISABLE_OOE_ALL)) {
            return ooe.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        //add baguette
        if (dex == Dex.BaguetteSwap && !flags.or(Flags.FLAG_DISABLE_BAGUETTE_ALL, Flags.FLAG_DISABLE_BAGUETTE)) {
            return baguette.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.BaguetteSwapETH && !flags.or(Flags.FLAG_DISABLE_BAGUETTE_ALL, Flags.FLAG_DISABLE_BAGUETTE_WAVAX)) {
            return baguette.calculateTransitionalSwapReturn(inToken, Tokens.WAVAX, outToken, inAmounts);
        }
        if (dex == Dex.BaguetteSwapDAI && !flags.or(Flags.FLAG_DISABLE_BAGUETTE_ALL, Flags.FLAG_DISABLE_BAGUETTE_DAI)) {
            return baguette.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }

        //add lydia
        if (dex == Dex.LydiaSwap && !flags.or(Flags.FLAG_DISABLE_LYDIA_ALL, Flags.FLAG_DISABLE_LYDIA)) {
            return lydia.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.LydiaSwapETH && !flags.or(Flags.FLAG_DISABLE_LYDIA_ALL, Flags.FLAG_DISABLE_LYDIA_WAVAX)) {
            return lydia.calculateTransitionalSwapReturn(inToken, Tokens.WAVAX, outToken, inAmounts);
        }
        if (dex == Dex.LydiaSwapDAI && !flags.or(Flags.FLAG_DISABLE_LYDIA_ALL, Flags.FLAG_DISABLE_LYDIA_DAI)) {
            return lydia.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }

        //add Joe
        if (dex == Dex.JoeSwap && !flags.or(Flags.FLAG_DISABLE_JOESWAP_ALL, Flags.FLAG_DISABLE_JOESWAP)) {
            return joe.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.JoeSwapETH && !flags.or(Flags.FLAG_DISABLE_JOESWAP_ALL, Flags.FLAG_DISABLE_JOESWAP_WAVAX)) {
            return joe.calculateTransitionalSwapReturn(inToken, Tokens.WAVAX, outToken, inAmounts);
        }
        if (dex == Dex.JoeSwapDAI && !flags.or(Flags.FLAG_DISABLE_JOESWAP_ALL, Flags.FLAG_DISABLE_JOESWAP_DAI)) {
            return joe.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }

        //add PangolinSwap
        if (dex == Dex.PangolinSwap && !flags.or(Flags.FLAG_DISABLE_PANGONLINSWAP_ALL, Flags.FLAG_DISABLE_PANGONLINSWAP)) {
            return pangolin.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.PangolinSwapETH && !flags.or(Flags.FLAG_DISABLE_PANGONLINSWAP_ALL, Flags.FLAG_DISABLE_PANGONLINSWAP_WAVAX)) {
            return pangolin.calculateTransitionalSwapReturn(inToken, Tokens.WAVAX, outToken, inAmounts);
        }
        if (dex == Dex.PangolinSwapDAI && !flags.or(Flags.FLAG_DISABLE_PANGONLINSWAP_ALL, Flags.FLAG_DISABLE_PANGONLINSWAP_DAI)) {
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
        // add kyberDMM
        if (dex == Dex.KyberDMM && !flags.on(Flags.FLAG_DISABLE_KYBERDMM_ALL)) {
            kyberDMM.swap(inToken, outToken, amount);
        }
        //add ooeswap
        if (dex == Dex.OOESwap && !flags.on(Flags.FLAG_DISABLE_OOE_ALL)) {
            ooe.swap(inToken, outToken, amount);
        }

        //add baguette
        if (dex == Dex.BaguetteSwap && !flags.or(Flags.FLAG_DISABLE_BAGUETTE_ALL, Flags.FLAG_DISABLE_BAGUETTE)) {
            baguette.swap(inToken, outToken, amount);
        }
        if (dex == Dex.BaguetteSwapETH && !flags.or(Flags.FLAG_DISABLE_BAGUETTE_ALL, Flags.FLAG_DISABLE_BAGUETTE_WAVAX)) {
            baguette.swapTransitional(inToken, Tokens.WAVAX, outToken, amount);
        }
        if (dex == Dex.BaguetteSwapDAI && !flags.or(Flags.FLAG_DISABLE_BAGUETTE_ALL, Flags.FLAG_DISABLE_BAGUETTE_DAI)) {
            baguette.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }

        //add lydia
        if (dex == Dex.LydiaSwap && !flags.or(Flags.FLAG_DISABLE_LYDIA_ALL, Flags.FLAG_DISABLE_LYDIA)) {
            lydia.swap(inToken, outToken, amount);
        }
        if (dex == Dex.LydiaSwapETH && !flags.or(Flags.FLAG_DISABLE_LYDIA_ALL, Flags.FLAG_DISABLE_LYDIA_WAVAX)) {
            lydia.swapTransitional(inToken, Tokens.WAVAX, outToken, amount);
        }
        if (dex == Dex.LydiaSwapDAI && !flags.or(Flags.FLAG_DISABLE_LYDIA_ALL, Flags.FLAG_DISABLE_LYDIA_DAI)) {
            lydia.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }

        //add Joe
        if (dex == Dex.JoeSwap && !flags.or(Flags.FLAG_DISABLE_JOESWAP_ALL, Flags.FLAG_DISABLE_JOESWAP)) {
            joe.swap(inToken, outToken, amount);
        }
        if (dex == Dex.JoeSwapETH && !flags.or(Flags.FLAG_DISABLE_JOESWAP_ALL, Flags.FLAG_DISABLE_JOESWAP_WAVAX)) {
            joe.swapTransitional(inToken, Tokens.WAVAX, outToken, amount);
        }
        if (dex == Dex.JoeSwapDAI && !flags.or(Flags.FLAG_DISABLE_JOESWAP_ALL, Flags.FLAG_DISABLE_JOESWAP_DAI)) {
            joe.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }

        //add PangolinSwap
        if (dex == Dex.PangolinSwap && !flags.or(Flags.FLAG_DISABLE_PANGONLINSWAP_ALL, Flags.FLAG_DISABLE_PANGONLINSWAP)) {
            pangolin.swap(inToken, outToken, amount);
        }
        if (dex == Dex.PangolinSwapETH && !flags.or(Flags.FLAG_DISABLE_PANGONLINSWAP_ALL, Flags.FLAG_DISABLE_PANGONLINSWAP_WAVAX)) {
            pangolin.swapTransitional(inToken, Tokens.WAVAX, outToken, amount);
        }
        if (dex == Dex.PangolinSwapDAI && !flags.or(Flags.FLAG_DISABLE_PANGONLINSWAP_ALL, Flags.FLAG_DISABLE_PANGONLINSWAP_DAI)) {
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
