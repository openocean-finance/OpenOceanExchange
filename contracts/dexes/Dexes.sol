// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./IMDex.sol";


    enum Dex {
        MDex,
        MDexHT,
        MDexBUSD,
        MDexUSDC,
        MDexUSDT,
        NoDex
    }

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

    // MDex
    IMDexFactory internal constant mdex = IMDexFactory(0xb0b670fc1F7724119963018DB0BfA86aDb22d941);
    using IMDexFactoryExtension for IMDexFactory;


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
            if(true){
                uint256[] memory res = new uint256[](inAmounts.length);
                for(uint i=0;i<inAmounts.length;i++){
                    res[i] = 10000000000;
                }
                res[0] = 10000000000;
                return (res, 20000);
            }
            return mdex.calculateTransitionalSwapReturn(inToken, Tokens.WHT, outToken, inAmounts);
        }
        if (dex == Dex.MDexUSDC && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_USDC)) {
            return mdex.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.MDexUSDT && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_USDT)) {
            return mdex.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.MDexBUSD && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_BUSD)) {
            return mdex.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
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
        if (dex == Dex.MDexBUSD && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_BUSD)) {
            mdex.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }
    }
}
