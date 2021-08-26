// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./IKswap.sol";
import "./ICherrySwap.sol";
import "./IAiswap.sol";
import "./IBXHash.sol";

enum Dex {
    // kswap
    Kswap,
    KswapOKT,
    KswapUSDT,
    // cherryswap
    CherrySwap,
    CherrySwapOKT,
    CherrySwapUSDT,
    // aiswap
    AiSwap,
    AiSwapOKT,
    AiSwapUSDT,
    // BXHash
    BXHash,
    BXHashOKT,
    BXHashUSDT,
    // bottom mark
    NoDex
}

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

    IBXHashFactory internal constant bxhash = IBXHashFactory(0xff65BC42c10dcC73aC0924B674FD3e30427C7823);
    using IBXHashFactoryExtension for IBXHashFactory;

    IKswapFactory internal constant kswap = IKswapFactory(0x60DCD4a2406Be12dbe3Bb2AaDa12cFb762A418c1);
    using IKswapFactoryExtension for IKswapFactory;

    ICherryFactory internal constant cherrySwap = ICherryFactory(0x709102921812B3276A65092Fe79eDfc76c4D4AFe);
    using ICherryFactoryExtension for ICherryFactory;

    IAiswapFactory internal constant aiSwap = IAiswapFactory(0x65728c1D0e545DB117940d5745089c256516ad43);
    using IAiswapFactoryExtension for IAiswapFactory;

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
        // bxhash
        if (dex == Dex.BXHash && !flags.or(Flags.FLAG_DISABLE_BXHASH_ALL, Flags.FLAG_DISABLE_BXHASH)) {
            return bxhash.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.BXHashOKT && !flags.or(Flags.FLAG_DISABLE_BXHASH_ALL, Flags.FLAG_DISABLE_BXHASH_OKT)) {
            return bxhash.calculateTransitionalSwapReturn(inToken, Tokens.WOKT, outToken, inAmounts);
        }
        if (dex == Dex.BXHashUSDT && !flags.or(Flags.FLAG_DISABLE_BXHASH_ALL, Flags.FLAG_DISABLE_BXHASH_USDT)) {
            return bxhash.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }

        // kswap
        if (dex == Dex.Kswap && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP)) {
            return kswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.KswapOKT && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP_OKT)) {
            return kswap.calculateTransitionalSwapReturn(inToken, Tokens.WOKT, outToken, inAmounts);
        }
        if (dex == Dex.KswapUSDT && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP_USDT)) {
            return kswap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }

        //cherryswap
        if (dex == Dex.CherrySwap && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP)) {
            return cherrySwap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.CherrySwapOKT && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP_OKT)) {
            return cherrySwap.calculateTransitionalSwapReturn(inToken, Tokens.WOKT, outToken, inAmounts);
        }
        if (dex == Dex.CherrySwapUSDT && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP_USDT)) {
            return cherrySwap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }

        //aiswap
        if (dex == Dex.AiSwap && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP)) {
            return aiSwap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.AiSwapOKT && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP_OKT)) {
            return aiSwap.calculateTransitionalSwapReturn(inToken, Tokens.WOKT, outToken, inAmounts);
        }
        if (dex == Dex.AiSwapUSDT && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP_USDT)) {
            return aiSwap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
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
        // bxhash
        if (dex == Dex.BXHash && !flags.or(Flags.FLAG_DISABLE_BXHASH_ALL, Flags.FLAG_DISABLE_BXHASH)) {
            bxhash.swap(inToken, outToken, amount);
        }
        if (dex == Dex.BXHashOKT && !flags.or(Flags.FLAG_DISABLE_BXHASH_ALL, Flags.FLAG_DISABLE_BXHASH_OKT)) {
            bxhash.swapTransitional(inToken, Tokens.WOKT, outToken, amount);
        }
        if (dex == Dex.BXHashUSDT && !flags.or(Flags.FLAG_DISABLE_BXHASH_ALL, Flags.FLAG_DISABLE_BXHASH_USDT)) {
            bxhash.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }

        //add kswap
        if (dex == Dex.Kswap && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP)) {
            kswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.KswapOKT && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP_OKT)) {
            kswap.swapTransitional(inToken, Tokens.WOKT, outToken, amount);
        }
        if (dex == Dex.KswapUSDT && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP_USDT)) {
            kswap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        //cherryswap
        if (dex == Dex.CherrySwap && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP)) {
            cherrySwap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.CherrySwapOKT && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP_OKT)) {
            cherrySwap.swapTransitional(inToken, Tokens.WOKT, outToken, amount);
        }
        if (dex == Dex.CherrySwapUSDT && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP_USDT)) {
            cherrySwap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        //aiswap
        if (dex == Dex.AiSwap && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP)) {
            aiSwap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.AiSwapOKT && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP_OKT)) {
            aiSwap.swapTransitional(inToken, Tokens.WOKT, outToken, amount);
        }
        if (dex == Dex.AiSwapUSDT && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP_USDT)) {
            aiSwap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
    }
}
