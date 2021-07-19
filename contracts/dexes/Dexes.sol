// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./IMDex.sol";
import "./IMakiswap.sol";
import "./IWHT.sol";

enum Dex {MDex, MDexHT, MDexUSDC, MDexUSDT, Makiswap, MakiswapHT, MakiswapUSDC, MakiswapUSDT, WETH, NoDex}

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

    // MDex
    IMDexFactory internal constant mdex = IMDexFactory(0xb0b670fc1F7724119963018DB0BfA86aDb22d941);
    using IMDexFactoryExtension for IMDexFactory;

    // Makiswap
    IMakiswapFactory internal constant makiswap = IMakiswapFactory(0x11cdC9Bd86fF68b6A6152037342bAe0c3a717f56);
    using IMakiswapFactoryExtension for IMakiswapFactory;

    IWHT internal constant weth = IWHT(0x5545153CCFcA01fbd7Dd11C0b23ba694D9509A6F);
    using IWHTExtension for IWHT;

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
        // add MDex
        if (dex == Dex.MDex && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX)) {
            return mdex.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.MDexHT && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_HT)) {
            return mdex.calculateTransitionalSwapReturn(inToken, Tokens.WHT, outToken, inAmounts);
        }
        if (dex == Dex.MDexUSDC && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_USDC)) {
            return mdex.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.MDexUSDT && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_USDT)) {
            return mdex.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }

        // add Makiswap
        if (dex == Dex.Makiswap && !flags.or(Flags.FLAG_DISABLE_MAKISWAP_ALL, Flags.FLAG_DISABLE_MAKISWAP)) {
            return makiswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.MakiswapHT && !flags.or(Flags.FLAG_DISABLE_MAKISWAP_ALL, Flags.FLAG_DISABLE_MAKISWAP_HT)) {
            return makiswap.calculateTransitionalSwapReturn(inToken, Tokens.WHT, outToken, inAmounts);
        }
        if (dex == Dex.MakiswapUSDC && !flags.or(Flags.FLAG_DISABLE_MAKISWAP_ALL, Flags.FLAG_DISABLE_MAKISWAP_USDC)) {
            return makiswap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.MakiswapUSDT && !flags.or(Flags.FLAG_DISABLE_MAKISWAP_ALL, Flags.FLAG_DISABLE_MAKISWAP_USDT)) {
            return makiswap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }

        // WETH
        if (dex == Dex.WETH && !flags.on(Flags.FLAG_DISABLE_WETH)) {
            return weth.calculateSwapReturn(inToken, outToken, inAmounts);
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
        // add MDex
        if (dex == Dex.MDex && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX)) {
            mdex.swap(inToken, outToken, amount);
        }
        if (dex == Dex.MDexHT && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_HT)) {
            mdex.swapTransitional(inToken, Tokens.WHT, outToken, amount);
        }
        if (dex == Dex.MDexUSDC && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_USDC)) {
            mdex.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.MDexUSDT && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_USDT)) {
            mdex.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }

        // add Makiswap
        if (dex == Dex.Makiswap && !flags.or(Flags.FLAG_DISABLE_MAKISWAP_ALL, Flags.FLAG_DISABLE_MAKISWAP)) {
            makiswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.MakiswapHT && !flags.or(Flags.FLAG_DISABLE_MAKISWAP_ALL, Flags.FLAG_DISABLE_MAKISWAP_HT)) {
            makiswap.swapTransitional(inToken, Tokens.WHT, outToken, amount);
        }
        if (dex == Dex.MakiswapUSDC && !flags.or(Flags.FLAG_DISABLE_MAKISWAP_ALL, Flags.FLAG_DISABLE_MAKISWAP_USDC)) {
            makiswap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.MakiswapUSDT && !flags.or(Flags.FLAG_DISABLE_MAKISWAP_ALL, Flags.FLAG_DISABLE_MAKISWAP_USDT)) {
            makiswap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }

        // WETH
        if (dex == Dex.WETH && !flags.on(Flags.FLAG_DISABLE_WETH)) {
            weth.swap(inToken, outToken, amount);
        }
    }
}
