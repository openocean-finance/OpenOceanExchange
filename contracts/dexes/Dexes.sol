// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./IHoneySwap.sol";
import "./ISushiSwap.sol";
import "./IWETH.sol";

enum Dex {UniswapV2, UniswapV2DAI, UniswapV2USDC, SushiSwap, SushiSwapDAI, SushiSwapUSDC, WXDAI, NoDex}

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

    // Honeyswap
    IUniswapV2Factory internal constant honeyswap = IUniswapV2Factory(0xA818b4F111Ccac7AA31D0BCc0806d64F2E0737D7);
    using IUniswapV2FactoryExtension for IUniswapV2Factory;

    ISushiSwapFactory internal constant sushiswap = ISushiSwapFactory(0xc35DADB65012eC5796536bD9864eD8773aBc74C4);
    using ISushiSwapFactoryExtension for ISushiSwapFactory;

    IWXDAI internal constant weth = IWXDAI(0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d);
    using IWXDAIExtension for IWXDAI;

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
        // add quick swap
        if (dex == Dex.UniswapV2 && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2)) {
            return honeyswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.UniswapV2DAI && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_DAI)) {
            return honeyswap.calculateTransitionalSwapReturn(inToken, Tokens.WXDAI, outToken, inAmounts);
        }
        if (dex == Dex.UniswapV2USDC && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_USDC)) {
            return honeyswap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }

        // add SushiSwap
        if (dex == Dex.SushiSwap && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP)) {
            return sushiswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapDAI && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_DAI)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.WXDAI, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapUSDC && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_USDC)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }

        // WETH
        if (dex == Dex.WXDAI && !flags.on(Flags.FLAG_DISABLE_WETH)) {
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
        if (dex == Dex.UniswapV2 && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2)) {
            honeyswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.UniswapV2DAI && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_DAI)) {
            honeyswap.swapTransitional(inToken, Tokens.WXDAI, outToken, amount);
        }
        if (dex == Dex.UniswapV2USDC && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_USDC)) {
            honeyswap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }

        // add SushiSwap
        if (dex == Dex.SushiSwap && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP)) {
            sushiswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.SushiSwapDAI && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_DAI)) {
            sushiswap.swapTransitional(inToken, Tokens.WXDAI, outToken, amount);
        }
        if (dex == Dex.SushiSwapUSDC && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_USDC)) {
            sushiswap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }

        // WETH
        if (dex == Dex.WXDAI && !flags.on(Flags.FLAG_DISABLE_WETH)) {
            weth.swap(inToken, outToken, amount);
        }
    }
}
