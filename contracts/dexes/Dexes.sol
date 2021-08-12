// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./IKswap.sol";
import "./ICherrySwap.sol";
//import "./IStakeSwap.sol";
import "./IAiswap.sol";

    enum Dex {
        //kswap
        Kswap,
        KswapUSDT,
        // cherryswap
        CherrySwap,
        CherrySwapUSDT,
        //        //stakeswap
        //        StakeSwap,
        //        StakeSwapUSDT,
        // aiswap
        AiSwap,
        AiSwapUSDT,
        // bottom mark
        NoDex
    }

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

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
        // kswap
        if (dex == Dex.Kswap && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP)) {
            return kswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.KswapUSDT && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP_USDT)) {
            return kswap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }

        //cherryswap
        if (dex == Dex.CherrySwap && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP)) {
            return cherrySwap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.CherrySwapUSDT && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP_USDT)) {
            return cherrySwap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }

        //aiswap
        if (dex == Dex.AiSwap && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP)) {
            return aiSwap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.AiSwap && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP_USDT)) {
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
        //add kswap
        if (dex == Dex.Kswap && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP)) {
            kswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.KswapUSDT && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP_USDT)) {
            kswap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        //cherryswap
        if (dex == Dex.CherrySwap && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP)) {
            cherrySwap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.CherrySwapUSDT && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP_USDT)) {
            cherrySwap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        //aiswap
        if (dex == Dex.AiSwap && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP)) {
            aiSwap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.AiSwap && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP_USDT)) {
            aiSwap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
    }
}
