// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./ISeeSwap.sol";


    enum Dex {
        SeeSwap,
        NoDex
    }

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;


    using IBPoolExtension for IBPool;

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
        if (dex == Dex.SeeSwap && !flags.or(Flags.FLAG_DISABLE_SEESWAP_ALL, Flags.FLAG_DISABLE_SEESWAP)) {
            address poolAddr = IBPoolExtension.getISeeSwapPool(inToken, outToken);
            IBPool  pool = IBPool(poolAddr);
            return pool.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.SeeSwap && !flags.or(Flags.FLAG_DISABLE_SEESWAP_ALL,Flags.FLAG_DISABLE_SEESWAP_WONE)) {
            address poolAddr = IBPoolExtension.getISeeSwapPool(inToken, Tokens.WONE);
            IBPool  pool = IBPool(poolAddr);
            return pool.calculateTransitionalSwapReturn(inToken, Tokens.WONE, outToken, inAmounts);
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

        if (dex == Dex.SeeSwap && !flags.or(Flags.FLAG_DISABLE_SEESWAP_ALL, Flags.FLAG_DISABLE_SEESWAP)) {
            address poolAddr = IBPoolExtension.getISeeSwapPool(inToken, outToken);
            IBPool  pool = IBPool(poolAddr);
            pool.swap(inToken, outToken, amount);
        }

        if (dex == Dex.SeeSwap && !flags.or(Flags.FLAG_DISABLE_SEESWAP_ALL,Flags.FLAG_DISABLE_SEESWAP_WONE)) {
            address poolAddr = IBPoolExtension.getISeeSwapPool(inToken, Tokens.WONE);
            IBPool  pool = IBPool(poolAddr);
            pool.swapTransitional(inToken, Tokens.WONE, outToken, amount);
        }
    }
}
