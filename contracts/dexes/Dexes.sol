// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./ISushiSwap.sol";


    enum Dex {
        SushiSwap,
        SushiSwapETH,
        SushiSwapDAI,
        SushiSwapUSDC,
        NoDex
    }

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

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
        // add SushiSwap
        if (dex == Dex.SushiSwap && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP)) {
            return sushiswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapETH && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_ETH)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.WFTM, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapDAI && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_DAI)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapUSDC && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_USDC)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
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

        // add SushiSwap
        if (dex == Dex.SushiSwap && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP)) {
            sushiswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.SushiSwapETH && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_ETH)) {
            sushiswap.swapTransitional(inToken, Tokens.WFTM, outToken, amount);
        }
        if (dex == Dex.SushiSwapDAI && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_DAI)) {
            sushiswap.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.SushiSwapUSDC && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_USDC)) {
            sushiswap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
    }
}
