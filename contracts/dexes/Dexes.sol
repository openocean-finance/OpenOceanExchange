// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./IQuickSwap.sol";
import "./ISushiSwap.sol";

enum Dex {
    Quickswap,
    QuickswapETH,
    QuickswapDAI,
    QuickswapUSDC,
    QuickswapUSDT,
    QuickswapQUICK,
    SushiSwap,
    SushiSwapETH,
    SushiSwapDAI,
    SushiSwapUSDC,
    SushiSwapUSDT,
    NoDex
}

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

    // QuickSwap
    IQuickswapFactory internal constant quickswap = IQuickswapFactory(0x5757371414417b8C6CAad45bAeF941aBc7d3Ab32);
    using IQuickswapFactoryExtension for IQuickswapFactory;

    // Sushiswap
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
        // add Quickswap
        if (dex == Dex.Quickswap && !flags.or(Flags.FLAG_DISABLE_QUICKSWAP_ALL, Flags.FLAG_DISABLE_QUICKSWAP)) {
            return quickswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.QuickswapETH && !flags.or(Flags.FLAG_DISABLE_QUICKSWAP_ALL, Flags.FLAG_DISABLE_QUICKSWAP_ETH)) {
            return quickswap.calculateTransitionalSwapReturn(inToken, Tokens.WMATIC, outToken, inAmounts);
        }
        if (dex == Dex.QuickswapDAI && !flags.or(Flags.FLAG_DISABLE_QUICKSWAP_ALL, Flags.FLAG_DISABLE_QUICKSWAP_DAI)) {
            return quickswap.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.QuickswapUSDC && !flags.or(Flags.FLAG_DISABLE_QUICKSWAP_ALL, Flags.FLAG_DISABLE_QUICKSWAP_USDC)) {
            return quickswap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.QuickswapUSDT && !flags.or(Flags.FLAG_DISABLE_QUICKSWAP_ALL, Flags.FLAG_DISABLE_QUICKSWAP_USDT)) {
            return quickswap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.QuickswapQUICK && !flags.or(Flags.FLAG_DISABLE_QUICKSWAP_ALL, Flags.FLAG_DISABLE_QUICKSWAP_QUICK)) {
            return quickswap.calculateTransitionalSwapReturn(inToken, Tokens.QUICK, outToken, inAmounts);
        }

        // add SushiSwap
        if (dex == Dex.SushiSwap && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP)) {
            return sushiswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapETH && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_ETH)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.WMATIC, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapDAI && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_DAI)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapUSDC && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_USDC)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapUSDT && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_USDT)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
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
        if (dex == Dex.Quickswap && !flags.or(Flags.FLAG_DISABLE_QUICKSWAP_ALL, Flags.FLAG_DISABLE_QUICKSWAP)) {
            quickswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.QuickswapETH && !flags.or(Flags.FLAG_DISABLE_QUICKSWAP_ALL, Flags.FLAG_DISABLE_QUICKSWAP_ETH)) {
            quickswap.swapTransitional(inToken, Tokens.WMATIC, outToken, amount);
        }
        if (dex == Dex.QuickswapDAI && !flags.or(Flags.FLAG_DISABLE_QUICKSWAP_ALL, Flags.FLAG_DISABLE_QUICKSWAP_DAI)) {
            quickswap.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.QuickswapUSDC && !flags.or(Flags.FLAG_DISABLE_QUICKSWAP_ALL, Flags.FLAG_DISABLE_QUICKSWAP_USDC)) {
            quickswap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.QuickswapUSDT && !flags.or(Flags.FLAG_DISABLE_QUICKSWAP_ALL, Flags.FLAG_DISABLE_QUICKSWAP_USDT)) {
            quickswap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.QuickswapQUICK && !flags.or(Flags.FLAG_DISABLE_QUICKSWAP_ALL, Flags.FLAG_DISABLE_QUICKSWAP_QUICK)) {
            quickswap.swapTransitional(inToken, Tokens.QUICK, outToken, amount);
        }

        // add SushiSwap
        if (dex == Dex.SushiSwap && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP)) {
            sushiswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.SushiSwapETH && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_ETH)) {
            sushiswap.swapTransitional(inToken, Tokens.WMATIC, outToken, amount);
        }
        if (dex == Dex.SushiSwapDAI && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_DAI)) {
            sushiswap.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.SushiSwapUSDC && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_USDC)) {
            sushiswap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.SushiSwapUSDT && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_USDT)) {
            sushiswap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
    }
}
