// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./IQuickSwap.sol";
import "./ISushiSwap.sol";
import "./ICometh.sol";
import "./IWETH.sol";
import "./IDfyn.sol";
import "./IPolyZap.sol";
import "./ICurvePool.sol";

enum Dex {
    Quickswap,
    QuickswapWMATIC,
    QuickswapDAI,
    QuickswapUSDC,
    QuickswapUSDT,
    QuickswapQUICK,
    SushiSwap,
    SushiSwapETH,
    SushiSwapDAI,
    SushiSwapUSDC,
    SushiSwapUSDT,
    // WETH
    WETH,
    // Cometh
    Cometh,
    ComethETH,
    ComethMUST,
    // Dfyn
    Dfyn,
    DfynETH,
    DfynUSDC,
    DfynUSDT,
    // PolyZap
    PolyZap,
    PolyZapETH,
    PolyZapUSDC,
    // Curve
    Curve,
    CurveAAVE,
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

    // Cometh
    IComethFactory internal constant cometh = IComethFactory(0x800b052609c355cA8103E06F022aA30647eAd60a);
    using IComethFactoryExtension for IComethFactory;

    IWMATIC internal constant weth = IWMATIC(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270);
    using IWETHExtension for IWMATIC;

    // Dfyn
    IDfynFactory internal constant dfyn = IDfynFactory(0xE7Fb3e833eFE5F9c441105EB65Ef8b261266423B);
    using IDfynFactoryExtension for IDfynFactory;

    // PolyZap
    IPolyZapFactory internal constant polyZap = IPolyZapFactory(0x34De5ce6c9a395dB5710119419A7a29baa435C88);
    using IPolyZapFactoryExtension for IPolyZapFactory;

    // Curve
    using ICurvePoolExtension for ICurvePool;

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
        if (dex == Dex.QuickswapWMATIC && !flags.or(Flags.FLAG_DISABLE_QUICKSWAP_ALL, Flags.FLAG_DISABLE_QUICKSWAP_WMATIC)) {
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

        // WETH
        if (dex == Dex.WETH && !flags.on(Flags.FLAG_DISABLE_WETH)) {
            return weth.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // add Cometh
        if (dex == Dex.Cometh && !flags.or(Flags.FLAG_DISABLE_COMETH_ALL, Flags.FLAG_DISABLE_COMETH)) {
            return cometh.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.ComethETH && !flags.or(Flags.FLAG_DISABLE_COMETH_ALL, Flags.FLAG_DISABLE_COMETH_ETH)) {
            return cometh.calculateTransitionalSwapReturn(inToken, Tokens.WMATIC, outToken, inAmounts);
        }
        if (dex == Dex.ComethMUST && !flags.or(Flags.FLAG_DISABLE_COMETH_ALL, Flags.FLAG_DISABLE_COMETH_MUST)) {
            return cometh.calculateTransitionalSwapReturn(inToken, Tokens.MUST, outToken, inAmounts);
        }

        // add Dfyn
        if (dex == Dex.Dfyn && !flags.or(Flags.FLAG_DISABLE_DFYN_ALL, Flags.FLAG_DISABLE_DFYN)) {
            return dfyn.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.DfynETH && !flags.or(Flags.FLAG_DISABLE_DFYN_ALL, Flags.FLAG_DISABLE_DFYN_ETH)) {
            return dfyn.calculateTransitionalSwapReturn(inToken, Tokens.WMATIC, outToken, inAmounts);
        }
        if (dex == Dex.DfynUSDC && !flags.or(Flags.FLAG_DISABLE_DFYN_ALL, Flags.FLAG_DISABLE_DFYN_USDC)) {
            return dfyn.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.DfynUSDT && !flags.or(Flags.FLAG_DISABLE_DFYN_ALL, Flags.FLAG_DISABLE_DFYN_USDT)) {
            return dfyn.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }

        // add PolyZap
        if (dex == Dex.PolyZap && !flags.or(Flags.FLAG_DISABLE_POLYZAP_ALL, Flags.FLAG_DISABLE_POLYZAP)) {
            return polyZap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.PolyZapETH && !flags.or(Flags.FLAG_DISABLE_POLYZAP_ALL, Flags.FLAG_DISABLE_POLYZAP_ETH)) {
            return polyZap.calculateTransitionalSwapReturn(inToken, Tokens.WMATIC, outToken, inAmounts);
        }
        if (dex == Dex.PolyZapUSDC && !flags.or(Flags.FLAG_DISABLE_POLYZAP_ALL, Flags.FLAG_DISABLE_POLYZAP_USDC)) {
            return polyZap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }

        // add Curve
        if (dex == Dex.CurveAAVE && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_AAVE)) {
            return ICurvePoolExtension.CURVE_AAVE.calculateSwapReturn(inToken, outToken, inAmounts);
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
        if (dex == Dex.QuickswapWMATIC && !flags.or(Flags.FLAG_DISABLE_QUICKSWAP_ALL, Flags.FLAG_DISABLE_QUICKSWAP_WMATIC)) {
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

        // WETH
        if (dex == Dex.WETH && !flags.on(Flags.FLAG_DISABLE_WETH)) {
            weth.swap(inToken, outToken, amount);
        }

        // add Cometh
        if (dex == Dex.Cometh && !flags.or(Flags.FLAG_DISABLE_COMETH_ALL, Flags.FLAG_DISABLE_COMETH)) {
            cometh.swap(inToken, outToken, amount);
        }
        if (dex == Dex.ComethETH && !flags.or(Flags.FLAG_DISABLE_COMETH_ALL, Flags.FLAG_DISABLE_COMETH_ETH)) {
            cometh.swapTransitional(inToken, Tokens.WMATIC, outToken, amount);
        }
        if (dex == Dex.ComethMUST && !flags.or(Flags.FLAG_DISABLE_COMETH_ALL, Flags.FLAG_DISABLE_COMETH_MUST)) {
            cometh.swapTransitional(inToken, Tokens.MUST, outToken, amount);
        }

        // Dfyn
        if (dex == Dex.Dfyn && !flags.or(Flags.FLAG_DISABLE_DFYN_ALL, Flags.FLAG_DISABLE_DFYN)) {
            dfyn.swap(inToken, outToken, amount);
        }
        if (dex == Dex.DfynETH && !flags.or(Flags.FLAG_DISABLE_DFYN_ALL, Flags.FLAG_DISABLE_DFYN_ETH)) {
            dfyn.swapTransitional(inToken, Tokens.WMATIC, outToken, amount);
        }
        if (dex == Dex.DfynUSDC && !flags.or(Flags.FLAG_DISABLE_DFYN_ALL, Flags.FLAG_DISABLE_DFYN_USDC)) {
            dfyn.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.DfynUSDT && !flags.or(Flags.FLAG_DISABLE_DFYN_ALL, Flags.FLAG_DISABLE_DFYN_USDT)) {
            dfyn.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }

        // add Cometh
        if (dex == Dex.Cometh && !flags.or(Flags.FLAG_DISABLE_COMETH_ALL, Flags.FLAG_DISABLE_COMETH)) {
            cometh.swap(inToken, outToken, amount);
        }
        if (dex == Dex.ComethETH && !flags.or(Flags.FLAG_DISABLE_COMETH_ALL, Flags.FLAG_DISABLE_COMETH_ETH)) {
            cometh.swapTransitional(inToken, Tokens.WMATIC, outToken, amount);
        }
        if (dex == Dex.ComethMUST && !flags.or(Flags.FLAG_DISABLE_COMETH_ALL, Flags.FLAG_DISABLE_COMETH_MUST)) {
            cometh.swapTransitional(inToken, Tokens.MUST, outToken, amount);
        }

        // add PolyZap
        if (dex == Dex.PolyZap && !flags.or(Flags.FLAG_DISABLE_POLYZAP_ALL, Flags.FLAG_DISABLE_POLYZAP)) {
            polyZap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.PolyZapETH && !flags.or(Flags.FLAG_DISABLE_POLYZAP_ALL, Flags.FLAG_DISABLE_POLYZAP_ETH)) {
            polyZap.swapTransitional(inToken, Tokens.WMATIC, outToken, amount);
        }
        if (dex == Dex.PolyZapUSDC && !flags.or(Flags.FLAG_DISABLE_POLYZAP_ALL, Flags.FLAG_DISABLE_POLYZAP_USDC)) {
            polyZap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }

        // add Curve
        if (dex == Dex.CurveAAVE && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_AAVE)) {
            ICurvePoolExtension.CURVE_AAVE.swap(inToken, outToken, amount);
        }
    }
}
