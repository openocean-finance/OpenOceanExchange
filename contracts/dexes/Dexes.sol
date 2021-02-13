// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./IUSwap.sol";
import "./IWETH.sol";
import "./IJustSwap.sol";

enum Dex {
    // WTRX
    WTRX,
    // USwap
    USwap,
    USwapTRX,
    USwapUSDT,
    // JustSwap
    JustSwap,
    // bottom mark
    NoDex
}

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

    IWETH internal constant WTRX = IWETH(0x891cdb91d149f23B1a45D9c5Ca78a88d0cB44C18);
    IERC20 internal constant USDT = IERC20(0xa614f803B6FD780986A42c78Ec9c7f77e6DeD13C);

    uint256 internal constant FLAG_DISABLE_WTRX = 1 << 0;
    uint256 internal constant FLAG_DISABLE_USWAP_ALL = 1 << 1;
    uint256 internal constant FLAG_DISABLE_USWAP = 1 << 2;
    uint256 internal constant FLAG_DISABLE_USWAP_TRX = 1 << 3;
    uint256 internal constant FLAG_DISABLE_USWAP_USDT = 1 << 4;
    uint256 internal constant FLAG_DISABLE_JUSTSWAP = 1 << 5;

    IUSwapFactory internal constant uswap = IUSwapFactory(0x9A859d3834C354320ba664187FE1CEDE6E6BE042);
    using IUSwapFactoryExtension for IUSwapFactory;

    IJustSwapFactory internal constant justswap = IJustSwapFactory(0xeEd9e56a5CdDaA15eF0C42984884a8AFCf1BdEbb);
    using IJustSwapFactoryExtension for IJustSwapFactory;

    using IWETHExtension for IWETH;

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
        if (dex == Dex.WTRX && !flags.on(FLAG_DISABLE_WTRX)) {
            return WTRX.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        // USwap
        if (dex == Dex.USwap && !flags.or(FLAG_DISABLE_USWAP_ALL, FLAG_DISABLE_USWAP)) {
            return uswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.USwapTRX && !flags.or(FLAG_DISABLE_USWAP_ALL, FLAG_DISABLE_USWAP_TRX)) {
            return uswap.calculateTransitionalSwapReturn(inToken, WTRX, outToken, inAmounts);
        }
        if (dex == Dex.USwapUSDT && !flags.or(FLAG_DISABLE_USWAP_ALL, FLAG_DISABLE_USWAP_USDT)) {
            return uswap.calculateTransitionalSwapReturn(inToken, USDT, outToken, inAmounts);
        }
        // JustSwap
        if (dex == Dex.JustSwap && !flags.on(FLAG_DISABLE_JUSTSWAP)) {
            return justswap.calculateSwapReturn(inToken, outToken, inAmounts);
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
        if (dex == Dex.WTRX && !flags.on(FLAG_DISABLE_WTRX)) {
            WTRX.swap(inToken, outToken, amount);
        }
        // USwap
        if (dex == Dex.USwap && !flags.or(FLAG_DISABLE_USWAP_ALL, FLAG_DISABLE_USWAP)) {
            uswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.USwapTRX && !flags.or(FLAG_DISABLE_USWAP_ALL, FLAG_DISABLE_USWAP_TRX)) {
            uswap.swapTransitional(inToken, WTRX, outToken, amount);
        }
        if (dex == Dex.USwapUSDT && !flags.or(FLAG_DISABLE_USWAP_ALL, FLAG_DISABLE_USWAP_USDT)) {
            uswap.swapTransitional(inToken, USDT, outToken, amount);
        }
        // JustSwap
        if (dex == Dex.JustSwap && !flags.on(FLAG_DISABLE_JUSTSWAP)) {
            justswap.swap(inToken, outToken, amount);
        }
    }
}
