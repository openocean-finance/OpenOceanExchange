// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./IUniswapV2.sol";
import "./ICurvePool.sol";
import "./IOasis.sol";
import "./IUniswap.sol";
import "./ISushiSwap.sol";
import "./IMooniswap.sol";
import "./IBalancer.sol";
import "./IKyber.sol";
import "./IDODO.sol";

enum Dex {
    UniswapV2,
    UniswapV2ETH,
    UniswapV2DAI,
    UniswapV2USDC,
    CurveCompound,
    CurveUSDT,
    CurveY,
    CurveBinance,
    CurveSynthetix,
    CurvePAX,
    CurveRenBTC,
    CurveTBTC,
    CurveSBTC,
    Oasis,
    Uniswap,
    Curve,
    // add Mooniswap
    Mooniswap,
    MooniswapETH,
    MooniswapDAI,
    MooniswapUSDC,
    // add SushiSwap
    SushiSwap,
    SushiSwapETH,
    SushiSwapDAI,
    SushiSwapUSDC,
    // add Balancer
    Balancer,
    Balancer1,
    Balancer2,
    Balancer3,
    // add Kyber
    Kyber,
    Kyber1,
    Kyber2,
    Kyber3,
    Kyber4,
    // DODO
    DODO,
    DODOUSDC,
    DODOUSDT,
    // bottom mark
    NoDex
}

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

    IUniswapV2Factory internal constant uniswapV2 = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
    using IUniswapV2FactoryExtension for IUniswapV2Factory;

    ICurveRegistry internal constant curveRegistry = ICurveRegistry(0x7002B727Ef8F5571Cb5F9D70D13DBEEb4dFAe9d1);
    using ICurveRegistryExtension for ICurveRegistry;

    IOasis internal constant oasis = IOasis(0x794e6e91555438aFc3ccF1c5076A74F42133d08D);
    using IOasisExtension for IOasis;

    IUniswapFactory internal constant uniswap = IUniswapFactory(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);
    using IUniswapFactoryExtension for IUniswapFactory;

    ISushiSwapFactory internal constant sushiswap = ISushiSwapFactory(0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac);
    using ISushiSwapFactoryExtension for ISushiSwapFactory;

    IMooniswapRegistry internal constant mooniswap = IMooniswapRegistry(0x71CD6666064C3A1354a3B4dca5fA1E2D3ee7D303);
    using IMooniswapRegistryExtension for IMooniswapRegistry;

    IBalancerRegistry internal constant balancer = IBalancerRegistry(0x65e67cbc342712DF67494ACEfc06fe951EE93982);
    using IBalancerRegistryExtension for IBalancerRegistry;

    IKyberNetworkProxy internal constant kyber = IKyberNetworkProxy(0x9AAb3f75489902f3a48495025729a0AF77d4b11e);
    using IKyberNetworkProxyExtension for IKyberNetworkProxy;

    IDODOZoo internal constant dodo = IDODOZoo(0x3A97247DF274a17C59A3bd12735ea3FcDFb49950);
    using IDODOZooExtension for IDODOZoo;

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
        if (dex == Dex.UniswapV2 && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2)) {
            return uniswapV2.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.UniswapV2ETH && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_ETH)) {
            return uniswapV2.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.UniswapV2DAI && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_DAI)) {
            return uniswapV2.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.UniswapV2USDC && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_USDC)) {
            return uniswapV2.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.CurveCompound && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_COMPOUND)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_COMPOUND, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveUSDT && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_USDT)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_USDT, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveY && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_Y)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_Y, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveBinance && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_BINANCE)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_BINANCE, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveSynthetix && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_SYNTHETIX)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_SYNTHETIX, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurvePAX && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_PAX)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_PAX, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveRenBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_RENBTC)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_REN_BTC, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveTBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_TBTC)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_TBTC, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveSBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_SBTC)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_SBTC, inToken, outToken, inAmounts);
        }
        if (dex == Dex.Oasis && !flags.on(Flags.FLAG_DISABLE_OASIS)) {
            return oasis.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.Uniswap && !flags.on(Flags.FLAG_DISABLE_UNISWAP)) {
            return uniswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        // add SushiSwap
        if (dex == Dex.SushiSwap && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP)) {
            return sushiswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapETH && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_ETH)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapDAI && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_DAI)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapUSDC && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_USDC)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        // add Mooniswap
        if (dex == Dex.Mooniswap && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP)) {
            return mooniswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.MooniswapETH && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_ETH)) {
            return mooniswap.calculateTransitionalSwapReturn(inToken, UniversalERC20.ETH_ADDRESS, outToken, inAmounts);
        }
        if (dex == Dex.MooniswapDAI && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_DAI)) {
            return mooniswap.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.MooniswapUSDC && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_USDC)) {
            return mooniswap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        // add Balancer
        if (dex == Dex.Balancer1 && !flags.or(Flags.FLAG_DISABLE_BALANCER_ALL, Flags.FLAG_DISABLE_BALANCER_1)) {
            return balancer.calculateSwapReturn(inToken, outToken, inAmounts, 0);
        }
        if (dex == Dex.Balancer2 && !flags.or(Flags.FLAG_DISABLE_BALANCER_ALL, Flags.FLAG_DISABLE_BALANCER_2)) {
            return balancer.calculateSwapReturn(inToken, outToken, inAmounts, 1);
        }
        if (dex == Dex.Balancer3 && !flags.or(Flags.FLAG_DISABLE_BALANCER_ALL, Flags.FLAG_DISABLE_BALANCER_3)) {
            return balancer.calculateSwapReturn(inToken, outToken, inAmounts, 2);
        }
        // add Kyber
        if (dex == Dex.Kyber1 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_1)) {
            return
                kyber.calculateSwapReturn(
                    inToken,
                    outToken,
                    inAmounts,
                    flags,
                    0xff4b796265722046707200000000000000000000000000000000000000000000
                );
        }
        if (dex == Dex.Kyber2 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_2)) {
            return
                kyber.calculateSwapReturn(
                    inToken,
                    outToken,
                    inAmounts,
                    flags,
                    0xffabcd0000000000000000000000000000000000000000000000000000000000
                );
        }
        if (dex == Dex.Kyber3 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_3)) {
            return
                kyber.calculateSwapReturn(
                    inToken,
                    outToken,
                    inAmounts,
                    flags,
                    0xff4f6e65426974205175616e7400000000000000000000000000000000000000
                );
        }
        if (dex == Dex.Kyber4 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_4)) {
            return kyber.calculateSwapReturn(inToken, outToken, inAmounts, flags, 0);
        }

        // add DODO
        if (dex == Dex.DODO && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO)) {
            return dodo.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.DODOUSDC && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO_USDC)) {
            return dodo.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.DODOUSDT && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO_USDT)) {
            return dodo.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
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
            uniswapV2.swap(inToken, outToken, amount);
        }
        if (dex == Dex.UniswapV2ETH && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_ETH)) {
            uniswapV2.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.UniswapV2DAI && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_DAI)) {
            uniswapV2.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.UniswapV2USDC && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_USDC)) {
            uniswapV2.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.CurveCompound && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_COMPOUND)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_COMPOUND, inToken, outToken, amount);
        }
        if (dex == Dex.CurveUSDT && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_USDT)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_USDT, inToken, outToken, amount);
        }
        if (dex == Dex.CurveY && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_Y)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_Y, inToken, outToken, amount);
        }
        if (dex == Dex.CurveBinance && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_BINANCE)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_BINANCE, inToken, outToken, amount);
        }
        if (dex == Dex.CurveSynthetix && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_SYNTHETIX)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_SYNTHETIX, inToken, outToken, amount);
        }
        if (dex == Dex.CurvePAX && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_PAX)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_PAX, inToken, outToken, amount);
        }
        if (dex == Dex.CurveRenBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_RENBTC)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_REN_BTC, inToken, outToken, amount);
        }
        if (dex == Dex.CurveTBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_TBTC)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_TBTC, inToken, outToken, amount);
        }
        if (dex == Dex.CurveSBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_SBTC)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_SBTC, inToken, outToken, amount);
        }
        if (dex == Dex.Oasis && !flags.on(Flags.FLAG_DISABLE_OASIS)) {
            oasis.swap(inToken, outToken, amount);
        }
        if (dex == Dex.Uniswap && !flags.on(Flags.FLAG_DISABLE_UNISWAP)) {
            uniswap.swap(inToken, outToken, amount);
        }
        // add SushiSwap
        if (dex == Dex.SushiSwap && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP)) {
            sushiswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.SushiSwapETH && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_ETH)) {
            sushiswap.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.SushiSwapDAI && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_DAI)) {
            sushiswap.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.SushiSwapUSDC && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_USDC)) {
            sushiswap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        // add Mooniswap
        if (dex == Dex.Mooniswap && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP)) {
            mooniswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.MooniswapETH && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_ETH)) {
            mooniswap.swapTransitional(inToken, UniversalERC20.ETH_ADDRESS, outToken, amount);
        }
        if (dex == Dex.MooniswapDAI && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_DAI)) {
            mooniswap.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.MooniswapUSDC && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_USDC)) {
            mooniswap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        // add Balancer
        if (dex == Dex.Balancer1 && !flags.or(Flags.FLAG_DISABLE_BALANCER_ALL, Flags.FLAG_DISABLE_BALANCER_1)) {
            balancer.swap(inToken, outToken, amount, 0);
        }
        if (dex == Dex.Balancer2 && !flags.or(Flags.FLAG_DISABLE_BALANCER_ALL, Flags.FLAG_DISABLE_BALANCER_2)) {
            balancer.swap(inToken, outToken, amount, 1);
        }
        if (dex == Dex.Balancer3 && !flags.or(Flags.FLAG_DISABLE_BALANCER_ALL, Flags.FLAG_DISABLE_BALANCER_3)) {
            balancer.swap(inToken, outToken, amount, 2);
        }
        // add Kyber
        if (dex == Dex.Kyber1 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_1)) {
            return kyber.swap(inToken, outToken, amount, flags, 0xff4b796265722046707200000000000000000000000000000000000000000000);
        }
        if (dex == Dex.Kyber2 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_2)) {
            return kyber.swap(inToken, outToken, amount, flags, 0xffabcd0000000000000000000000000000000000000000000000000000000000);
        }
        if (dex == Dex.Kyber3 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_3)) {
            return kyber.swap(inToken, outToken, amount, flags, 0xff4f6e65426974205175616e7400000000000000000000000000000000000000);
        }
        if (dex == Dex.Kyber4 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_4)) {
            return kyber.swap(inToken, outToken, amount, flags, 0);
        }

        // add DODO
        if (dex == Dex.DODO && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO)) {
            dodo.swap(inToken, outToken, amount);
        }
        if (dex == Dex.DODOUSDC && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO_USDC)) {
            dodo.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.DODOUSDT && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO_USDT)) {
            dodo.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
    }
}
