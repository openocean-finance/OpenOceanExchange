// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
import "./IMooniswap.sol";
// import "./IBurger.sol";
// import "./IUnifi.sol";
import "./IWETH.sol";
import "./IAcryptos.sol";
// import "./IDODO.sol";
import "./ISmoothy.sol";
import "./IEllipsis.sol";
import "./INerve.sol";
// import "./IBeltswap.sol";
import "./IPancakeBunny.sol";
import "./IUniswapV2Like.sol";

enum Dex {
    // Pancake
    Pancake,
    PancakeETH,
    PancakeDAI,
    PancakeUSDC,
    PancakeUSDT,
    // Bakery
    Bakery,
    BakeryETH,
    BakeryDAI,
    BakeryUSDC,
    BakeryUSDT,
    // Burger
    Burger,
    BurgerETH,
    BurgerDGAS,
    // Thugswap
    Thugswap,
    ThugswapETH,
    ThugswapDAI,
    ThugswapUSDC,
    ThugswapUSDT,
    // BUSD transitional
    PancakeBUSD,
    BakeryBUSD,
    ThugswapBUSD,
    // StableX
    Stablex,
    StablexDAI,
    StablexBUSD,
    StablexQUSD,
    StablexUSDC,
    StablexUSDT,
    // Unifi
    Unifi,
    // WETH
    WETH,
    // Julswap
    Julswap,
    JulswapETH,
    JulswapDAI,
    JulswapUSDC,
    JulswapUSDT,
    JulswapBUSD,
    // Pancake DOT
    PancakeDOT,
    // Acrytos
    Acryptos,
    AcryptosUSD,
    AcryptosVAI,
    AcryptosUST,
    AcryptosQUSD,
    // Apeswap
    Apeswap,
    ApeswapETH,
    ApeswapUSDT,
    ApeswapBUSD,
    ApeswapBANANA,
    // DODO
    DODO,
    DODOUSDC,
    DODOUSDT,
    // Smoothy
    Smoothy,
    // Acryptos
    AcryptosBTC,
    // Ellipsis
    Ellipsis,
    EllipsisUSD,
    EllipsisBTC,
    EllipsisFUSDT,
    // MDex
    MDex,
    MDexETH,
    MDexBUSD,
    MDexUSDC,
    MDexUSDT,
    // PancakeV2
    PancakeV2,
    PancakeETHV2,
    PancakeUSDCV2,
    PancakeUSDTV2,
    PancakeBUSDV2,
    PancakeDOTV2,
    // Nerve
    Nerve,
    NervePOOL3,
    NerveBTC,
    NerveETH,
    Cafeswap,
    PantherSwap,
    PancakeBunny,
    // Beltswap,
    // add Mooniswap
    Mooniswap,
    MooniswapETH,
    MooniswapDAI,
    MooniswapUSDC,
    // Innoswap
    Innoswap,
    // WaultSwap
    Waultswap,
    // Babyswap
    Babyswap,
    // Biswap
    Biswap,
    BiswapBNB,
    BiswapBUSD,
    // bottom mark
    NoDex
}

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;
    using IUniswapV2LikeFactories for uint256;

    IZapBsc internal constant zap = IZapBsc(0xdC2bBB0D33E0e7Dea9F5b98F46EDBaC823586a0C);
    using IZapBscExtension for IZapBsc;

    // 1inch
    // 0xbAF9A5d4b0052359326A6CDAb54BABAa3a3A9643 --> 0xD41B24bbA51fAc0E4827b6F94C0D6DDeB183cD64
    IMooniswapRegistry internal constant mooniswap = IMooniswapRegistry(0xD41B24bbA51fAc0E4827b6F94C0D6DDeB183cD64);
    using IMooniswapRegistryExtension for IMooniswapRegistry;

    // IDemaxPlatform internal constant burger = IDemaxPlatform(0xBf6527834dBB89cdC97A79FCD62E6c08B19F8ec0);
    // using IDemaxPlatformExtension for IDemaxPlatform;

    // IUnifiTradeRegistry internal constant unifi = IUnifiTradeRegistry(0xFD4B5179B535df687e0861cDF86E9CCAB50E5A51);
    // using IUnifiTradeRegistryExtenstion for IUnifiTradeRegistry;

    IWETH internal constant weth = IWETH(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    using IWETHExtension for IWETH;

    using IAcryptosPoolExtension for IAcryptosPool;

    // IDODOZoo internal constant dodo = IDODOZoo(0xCA459456a45e300AA7EF447DBB60F87CCcb42828);
    // using IDODOZooExtension for IDODOZoo;

    ISmoothy internal constant smoothy = ISmoothy(0xe5859f4EFc09027A9B718781DCb2C6910CAc6E91);
    using ISmoothyExtension for ISmoothy;

    using IEllipsisPoolExtension for IEllipsisPool;

    using INerveExtension for INerve;

    // using IBeltSwapExtension for IBeltSwap;

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
        // Babyswap
        if (dex == Dex.Babyswap && !flags.on(Flags.FLAG_DISABLE_BABYSWAP_ALL)) {
            return IUniswapV2LikeFactories.BABYSWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Waultswap
        if (dex == Dex.Waultswap && !flags.on(Flags.FLAG_DISABLE_WAULTSWAP_ALL)) {
            return IUniswapV2LikeFactories.WAULTSWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Innoswap
        if (dex == Dex.Innoswap && !flags.on(Flags.FLAG_DISABLE_INNOSWAP_ALL)) {
            return IUniswapV2LikeFactories.INNOSWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // PancakeBunny
        if (dex == Dex.PancakeBunny && !flags.on(Flags.FLAG_DISABLE_ZAPBSC)) {
            return zap.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Pantherswap
        if (dex == Dex.PantherSwap && !flags.or(Flags.FLAG_DISABLE_PANTHERSWAP_ALL, Flags.FLAG_DISABLE_PANTHERSWAP)) {
            return IUniswapV2LikeFactories.PANTHERSWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // 1inch
        if (dex == Dex.Mooniswap && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP)) {
            return mooniswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.MooniswapETH && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_ETH)) {
            return mooniswap.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.MooniswapDAI && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_DAI)) {
            return mooniswap.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.MooniswapUSDC && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_USDC)) {
            return mooniswap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }

        // Pancake
        if (dex == Dex.Pancake && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE)) {
            return IUniswapV2LikeFactories.PANCAKE.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.PancakeETH && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_ETH)) {
            return IUniswapV2LikeFactories.PANCAKE.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.PancakeDAI && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_DAI)) {
            return IUniswapV2LikeFactories.PANCAKE.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.PancakeUSDC && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_USDC)) {
            return IUniswapV2LikeFactories.PANCAKE.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.PancakeUSDT && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_USDT)) {
            return IUniswapV2LikeFactories.PANCAKE.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.PancakeBUSD && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_BUSD)) {
            return IUniswapV2LikeFactories.PANCAKE.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }
        if (dex == Dex.PancakeDOT && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_DOT)) {
            return IUniswapV2LikeFactories.PANCAKE.calculateTransitionalSwapReturn(inToken, Tokens.DOT, outToken, inAmounts);
        }

        // Bakery
        if (dex == Dex.Bakery && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY)) {
            return IUniswapV2LikeFactories.BAKERY.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.BakeryETH && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_ETH)) {
            return IUniswapV2LikeFactories.BAKERY.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.BakeryDAI && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_DAI)) {
            return IUniswapV2LikeFactories.BAKERY.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.BakeryUSDC && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_USDC)) {
            return IUniswapV2LikeFactories.BAKERY.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.BakeryUSDT && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_USDT)) {
            return IUniswapV2LikeFactories.BAKERY.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.BakeryBUSD && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_BUSD)) {
            return IUniswapV2LikeFactories.BAKERY.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }

        // Burger
        // if (dex == Dex.Burger && !flags.or(Flags.FLAG_DISABLE_BURGER_ALL, Flags.FLAG_DISABLE_BURGER)) {
        //     return burger.calculateSwapReturn(inToken, outToken, inAmounts);
        // }
        // if (dex == Dex.BurgerETH && !flags.or(Flags.FLAG_DISABLE_BURGER_ALL, Flags.FLAG_DISABLE_BURGER_ETH)) {
        //     return burger.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        // }
        // if (dex == Dex.BurgerDGAS && !flags.or(Flags.FLAG_DISABLE_BURGER_ALL, Flags.FLAG_DISABLE_BURGER_DGAS)) {
        //     return burger.calculateTransitionalSwapReturn(inToken, Tokens.DGAS, outToken, inAmounts);
        // }

        // Thugswap
        if (dex == Dex.Thugswap && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP)) {
            return IUniswapV2LikeFactories.HYPER_JUMP.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapETH && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_ETH)) {
            return IUniswapV2LikeFactories.HYPER_JUMP.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapDAI && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_DAI)) {
            return IUniswapV2LikeFactories.HYPER_JUMP.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapUSDC && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_USDC)) {
            return IUniswapV2LikeFactories.HYPER_JUMP.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapUSDT && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_USDT)) {
            return IUniswapV2LikeFactories.HYPER_JUMP.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapBUSD && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_BUSD)) {
            return IUniswapV2LikeFactories.HYPER_JUMP.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }

        // Stablex
        if (dex == Dex.Stablex && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX)) {
            return IUniswapV2LikeFactories.IMPOSSIBLE.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.StablexQUSD && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_QUSD)) {
            return IUniswapV2LikeFactories.IMPOSSIBLE.calculateTransitionalSwapReturn(inToken, Tokens.QUSD, outToken, inAmounts);
        }
        if (dex == Dex.StablexDAI && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_DAI)) {
            return IUniswapV2LikeFactories.IMPOSSIBLE.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.StablexUSDC && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_USDC)) {
            return IUniswapV2LikeFactories.IMPOSSIBLE.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.StablexUSDT && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_USDT)) {
            return IUniswapV2LikeFactories.IMPOSSIBLE.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.StablexBUSD && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_BUSD)) {
            return IUniswapV2LikeFactories.IMPOSSIBLE.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }

        // Unifi
        // if (dex == Dex.Unifi && !flags.or(Flags.FLAG_DISABLE_UNIFI_ALL, Flags.FLAG_DISABLE_UNIFI)) {
        //     return unifi.calculateSwapReturn(inToken, outToken, inAmounts);
        // }

        // WETH
        if (dex == Dex.WETH && !flags.on(Flags.FLAG_DISABLE_WETH)) {
            return weth.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Julswap
        if (dex == Dex.Julswap && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP)) {
            return IUniswapV2LikeFactories.JULSWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.JulswapETH && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_ETH)) {
            return IUniswapV2LikeFactories.JULSWAP.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.JulswapDAI && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_DAI)) {
            return IUniswapV2LikeFactories.JULSWAP.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.JulswapUSDC && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_USDC)) {
            return IUniswapV2LikeFactories.JULSWAP.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.JulswapUSDT && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_USDT)) {
            return IUniswapV2LikeFactories.JULSWAP.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.JulswapBUSD && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_BUSD)) {
            return IUniswapV2LikeFactories.JULSWAP.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }

        // Acryptos
        if (dex == Dex.AcryptosUSD && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_USD)) {
            return IAcryptosPoolExtension.ACRYPTOS_USD.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.AcryptosVAI && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_VAI)) {
            return IAcryptosPoolExtension.ACRYPTOS_VAI.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.AcryptosUST && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_UST)) {
            return IAcryptosPoolExtension.ACRYPTOS_UST.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.AcryptosQUSD && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_QUSD)) {
            return IAcryptosPoolExtension.ACRYPTOS_QUSD.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.AcryptosBTC && !flags.on(Flags.FLAG_DISABLE_ACRYPTOS_ALL)) {
            return IAcryptosPoolExtension.ACRYPTOS_BTC.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Apeswap
        if (dex == Dex.Apeswap && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP)) {
            return IUniswapV2LikeFactories.APESWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.ApeswapETH && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_ETH)) {
            return IUniswapV2LikeFactories.APESWAP.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.ApeswapBANANA && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_BANANA)) {
            return IUniswapV2LikeFactories.APESWAP.calculateTransitionalSwapReturn(inToken, Tokens.BANANA, outToken, inAmounts);
        }
        if (dex == Dex.ApeswapUSDT && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_USDT)) {
            return IUniswapV2LikeFactories.APESWAP.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.ApeswapBUSD && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_BUSD)) {
            return IUniswapV2LikeFactories.APESWAP.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }

        // add DODO
        // if (dex == Dex.DODO && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO)) {
        //     return dodo.calculateSwapReturn(inToken, outToken, inAmounts);
        // }
        // if (dex == Dex.DODOUSDC && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO_USDC)) {
        //     return dodo.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        // }
        // if (dex == Dex.DODOUSDT && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO_USDT)) {
        //     return dodo.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        // }

        // add Smoothy
        if (dex == Dex.Smoothy && !flags.on(Flags.FLAG_DISABLE_SMOOTHY)) {
            return smoothy.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // add Ellipsis
        if (dex == Dex.EllipsisUSD && !flags.on(Flags.FLAG_DISABLE_ELLIPSIS)) {
            return IEllipsisPoolExtension.ELLIPSIS_USD.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.EllipsisBTC && !flags.on(Flags.FLAG_DISABLE_ELLIPSIS)) {
            return IEllipsisPoolExtension.ELLIPSIS_BTC.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.EllipsisFUSDT && !flags.on(Flags.FLAG_DISABLE_ELLIPSIS)) {
            return IEllipsisPoolExtension.ELLIPSIS_FUSDT.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // add MDex
        if (dex == Dex.MDex && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX)) {
            return IUniswapV2LikeFactories.MDEX.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.MDexETH && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_ETH)) {
            return IUniswapV2LikeFactories.MDEX.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.MDexUSDC && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_USDC)) {
            return IUniswapV2LikeFactories.MDEX.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.MDexUSDT && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_USDT)) {
            return IUniswapV2LikeFactories.MDEX.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.MDexBUSD && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_BUSD)) {
            return IUniswapV2LikeFactories.MDEX.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }

        // PancakeV2
        if (dex == Dex.PancakeV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_V2)) {
            return IUniswapV2LikeFactories.PANCAKE_V2.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.PancakeETHV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_ETH_V2)) {
            return IUniswapV2LikeFactories.PANCAKE_V2.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.PancakeUSDCV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_USDC_V2)) {
            return IUniswapV2LikeFactories.PANCAKE_V2.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.PancakeUSDTV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_USDT_V2)) {
            return IUniswapV2LikeFactories.PANCAKE_V2.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.PancakeBUSDV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_BUSD_V2)) {
            return IUniswapV2LikeFactories.PANCAKE_V2.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }
        if (dex == Dex.PancakeDOTV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_DOT_V2)) {
            return IUniswapV2LikeFactories.PANCAKE_V2.calculateTransitionalSwapReturn(inToken, Tokens.DOT, outToken, inAmounts);
        }

        // Nerve
        if (dex == Dex.NervePOOL3 && !flags.or(Flags.FLAG_DISABLE_NERVE_ALL, Flags.FLAG_DISABLE_NERVE_POOL3)) {
            return INerveExtension.POOL3.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.NerveBTC && !flags.or(Flags.FLAG_DISABLE_NERVE_ALL, Flags.FLAG_DISABLE_NERVE_BTC)) {
            return INerveExtension.BTC.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.NerveETH && !flags.or(Flags.FLAG_DISABLE_NERVE_ALL, Flags.FLAG_DISABLE_NERVE_ETH)) {
            return INerveExtension.ETH.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Cafeswap
        if (dex == Dex.Cafeswap && !flags.on(Flags.FLAG_DISABLE_CAFESWAP_ALL)) {
            return IUniswapV2LikeFactories.CAFESWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Beltswap
        // if (dex == Dex.Beltswap && !flags.on(Flags.FLAG_DISABLE_BELTSWAP_ALL)) {
        //     return IBeltSwapExtension.BELT4.calculateSwapReturn(inToken, outToken, inAmounts);
        // }

        // Biswap
        if (dex == Dex.Biswap && !flags.on(Flags.FLAG_DISABLE_BISWAP_ALL)) {
            return IUniswapV2LikeFactories.BISWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.BiswapBNB && !flags.on(Flags.FLAG_DISABLE_BISWAP_ALL)) {
            return IUniswapV2LikeFactories.BISWAP.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.BiswapBUSD && !flags.on(Flags.FLAG_DISABLE_BISWAP_ALL)) {
            return IUniswapV2LikeFactories.BISWAP.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
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
        // Babyswap
        if (dex == Dex.Babyswap && !flags.on(Flags.FLAG_DISABLE_BABYSWAP_ALL)) {
            IUniswapV2LikeFactories.BABYSWAP.swap(inToken, outToken, amount);
        }

        // WaultSwap
        if (dex == Dex.Waultswap && !flags.on(Flags.FLAG_DISABLE_WAULTSWAP_ALL)) {
            IUniswapV2LikeFactories.WAULTSWAP.swap(inToken, outToken, amount);
        }

        // Innoswap
        if (dex == Dex.Innoswap && !flags.on(Flags.FLAG_DISABLE_INNOSWAP_ALL)) {
            IUniswapV2LikeFactories.INNOSWAP.swap(inToken, outToken, amount);
        }

        // PancakeBunny
        if (dex == Dex.PancakeBunny && !flags.on(Flags.FLAG_DISABLE_ZAPBSC)) {
            zap.swap(inToken, outToken, amount);
        }

        // PantherSwap
        if (dex == Dex.PantherSwap && !flags.or(Flags.FLAG_DISABLE_PANTHERSWAP_ALL, Flags.FLAG_DISABLE_PANTHERSWAP)) {
            IUniswapV2LikeFactories.PANTHERSWAP.swap(inToken, outToken, amount);
        }

        // 1inch
        if (dex == Dex.Mooniswap && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP)) {
            mooniswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.MooniswapETH && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_ETH)) {
            mooniswap.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.MooniswapETH && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_DAI)) {
            mooniswap.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.MooniswapETH && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_USDC)) {
            mooniswap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }

        // Pancake
        if (dex == Dex.Pancake && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE)) {
            IUniswapV2LikeFactories.PANCAKE.swap(inToken, outToken, amount);
        }
        if (dex == Dex.PancakeETH && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_ETH)) {
            IUniswapV2LikeFactories.PANCAKE.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.PancakeDAI && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_DAI)) {
            IUniswapV2LikeFactories.PANCAKE.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.PancakeUSDC && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_USDC)) {
            IUniswapV2LikeFactories.PANCAKE.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.PancakeUSDT && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_USDT)) {
            IUniswapV2LikeFactories.PANCAKE.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.PancakeBUSD && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_BUSD)) {
            IUniswapV2LikeFactories.PANCAKE.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }
        if (dex == Dex.PancakeDOT && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_DOT)) {
            IUniswapV2LikeFactories.PANCAKE.swapTransitional(inToken, Tokens.DOT, outToken, amount);
        }

        // Bakery
        if (dex == Dex.Bakery && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY)) {
            IUniswapV2LikeFactories.BAKERY.swap(inToken, outToken, amount);
        }
        if (dex == Dex.BakeryETH && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_ETH)) {
            IUniswapV2LikeFactories.BAKERY.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.BakeryDAI && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_DAI)) {
            IUniswapV2LikeFactories.BAKERY.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.BakeryUSDC && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_USDC)) {
            IUniswapV2LikeFactories.BAKERY.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.BakeryUSDT && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_USDT)) {
            IUniswapV2LikeFactories.BAKERY.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.BakeryBUSD && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_BUSD)) {
            IUniswapV2LikeFactories.BAKERY.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }

        // Burger
        // if (dex == Dex.Burger && !flags.or(Flags.FLAG_DISABLE_BURGER_ALL, Flags.FLAG_DISABLE_BURGER)) {
        //     burger.swap(inToken, outToken, amount);
        // }
        // if (dex == Dex.BurgerETH && !flags.or(Flags.FLAG_DISABLE_BURGER_ALL, Flags.FLAG_DISABLE_BURGER_ETH)) {
        //     burger.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        // }
        // if (dex == Dex.BurgerDGAS && !flags.or(Flags.FLAG_DISABLE_BURGER_ALL, Flags.FLAG_DISABLE_BURGER_DGAS)) {
        //     burger.swapTransitional(inToken, Tokens.DGAS, outToken, amount);
        // }

        // Thugswap
        if (dex == Dex.Thugswap && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP)) {
            IUniswapV2LikeFactories.HYPER_JUMP.swap(inToken, outToken, amount);
        }
        if (dex == Dex.ThugswapETH && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_ETH)) {
            IUniswapV2LikeFactories.HYPER_JUMP.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.ThugswapDAI && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_DAI)) {
            IUniswapV2LikeFactories.HYPER_JUMP.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.ThugswapUSDC && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_USDC)) {
            IUniswapV2LikeFactories.HYPER_JUMP.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.ThugswapUSDT && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_USDT)) {
            IUniswapV2LikeFactories.HYPER_JUMP.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.ThugswapBUSD && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_BUSD)) {
            IUniswapV2LikeFactories.HYPER_JUMP.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }

        // Stablex
        if (dex == Dex.Stablex && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX)) {
            IUniswapV2LikeFactories.IMPOSSIBLE.swap(inToken, outToken, amount);
        }
        if (dex == Dex.StablexQUSD && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_QUSD)) {
            IUniswapV2LikeFactories.IMPOSSIBLE.swapTransitional(inToken, Tokens.QUSD, outToken, amount);
        }
        if (dex == Dex.StablexDAI && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_DAI)) {
            IUniswapV2LikeFactories.IMPOSSIBLE.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.StablexUSDC && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_USDC)) {
            IUniswapV2LikeFactories.IMPOSSIBLE.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.StablexUSDT && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_USDT)) {
            IUniswapV2LikeFactories.IMPOSSIBLE.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.StablexBUSD && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_BUSD)) {
            IUniswapV2LikeFactories.IMPOSSIBLE.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }

        // Unifi
        // if (dex == Dex.Unifi && !flags.or(Flags.FLAG_DISABLE_UNIFI_ALL, Flags.FLAG_DISABLE_UNIFI)) {
        //     unifi.swap(inToken, outToken, amount);
        // }

        // WETH
        if (dex == Dex.WETH && !flags.on(Flags.FLAG_DISABLE_WETH)) {
            weth.swap(inToken, outToken, amount);
        }

        // Julswap
        if (dex == Dex.Julswap && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP)) {
            IUniswapV2LikeFactories.JULSWAP.swap(inToken, outToken, amount);
        }
        if (dex == Dex.JulswapETH && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_ETH)) {
            IUniswapV2LikeFactories.JULSWAP.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.JulswapDAI && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_DAI)) {
            IUniswapV2LikeFactories.JULSWAP.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.JulswapUSDC && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_USDC)) {
            IUniswapV2LikeFactories.JULSWAP.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.JulswapUSDT && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_USDT)) {
            IUniswapV2LikeFactories.JULSWAP.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.JulswapBUSD && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_BUSD)) {
            IUniswapV2LikeFactories.JULSWAP.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }

        // Acryptos
        if (dex == Dex.AcryptosUSD && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_USD)) {
            IAcryptosPoolExtension.ACRYPTOS_USD.swap(inToken, outToken, amount);
        }
        if (dex == Dex.AcryptosVAI && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_VAI)) {
            IAcryptosPoolExtension.ACRYPTOS_VAI.swap(inToken, outToken, amount);
        }
        if (dex == Dex.AcryptosUST && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_UST)) {
            IAcryptosPoolExtension.ACRYPTOS_UST.swap(inToken, outToken, amount);
        }
        if (dex == Dex.AcryptosQUSD && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_QUSD)) {
            IAcryptosPoolExtension.ACRYPTOS_QUSD.swap(inToken, outToken, amount);
        }
        if (dex == Dex.AcryptosBTC && !flags.on(Flags.FLAG_DISABLE_ACRYPTOS_ALL)) {
            IAcryptosPoolExtension.ACRYPTOS_BTC.swap(inToken, outToken, amount);
        }

        // Apeswap
        if (dex == Dex.Apeswap && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP)) {
            IUniswapV2LikeFactories.APESWAP.swap(inToken, outToken, amount);
        }
        if (dex == Dex.ApeswapETH && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_ETH)) {
            IUniswapV2LikeFactories.APESWAP.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.ApeswapBANANA && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_BANANA)) {
            IUniswapV2LikeFactories.APESWAP.swapTransitional(inToken, Tokens.BANANA, outToken, amount);
        }
        if (dex == Dex.ApeswapUSDT && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_USDT)) {
            IUniswapV2LikeFactories.APESWAP.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.ApeswapBUSD && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_BUSD)) {
            IUniswapV2LikeFactories.APESWAP.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }

        // add DODO
        // if (dex == Dex.DODO && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO)) {
        //     dodo.swap(inToken, outToken, amount);
        // }
        // if (dex == Dex.DODOUSDC && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO_USDC)) {
        //     dodo.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        // }
        // if (dex == Dex.DODOUSDT && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO_USDT)) {
        //     dodo.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        // }

        // add Smoothy
        if (dex == Dex.Smoothy && !flags.on(Flags.FLAG_DISABLE_SMOOTHY)) {
            smoothy.swap(inToken, outToken, amount);
        }

        // add Ellipsis
        if (dex == Dex.EllipsisUSD && !flags.on(Flags.FLAG_DISABLE_ELLIPSIS)) {
            IEllipsisPoolExtension.ELLIPSIS_USD.swap(inToken, outToken, amount);
        }
        if (dex == Dex.EllipsisBTC && !flags.on(Flags.FLAG_DISABLE_ELLIPSIS)) {
            IEllipsisPoolExtension.ELLIPSIS_BTC.swap(inToken, outToken, amount);
        }
        if (dex == Dex.EllipsisFUSDT && !flags.on(Flags.FLAG_DISABLE_ELLIPSIS)) {
            IEllipsisPoolExtension.ELLIPSIS_FUSDT.swap(inToken, outToken, amount);
        }

        // add MDex
        if (dex == Dex.MDex && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX)) {
            IUniswapV2LikeFactories.MDEX.swap(inToken, outToken, amount);
        }
        if (dex == Dex.MDexETH && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_ETH)) {
            IUniswapV2LikeFactories.MDEX.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.MDexUSDC && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_USDC)) {
            IUniswapV2LikeFactories.MDEX.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.MDexUSDT && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_USDT)) {
            IUniswapV2LikeFactories.MDEX.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.MDexBUSD && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_BUSD)) {
            IUniswapV2LikeFactories.MDEX.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }

        // Pancake V2
        if (dex == Dex.PancakeV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_V2)) {
            IUniswapV2LikeFactories.PANCAKE_V2.swap(inToken, outToken, amount);
        }
        if (dex == Dex.PancakeETHV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_ETH_V2)) {
            IUniswapV2LikeFactories.PANCAKE_V2.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.PancakeUSDCV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_USDC_V2)) {
            IUniswapV2LikeFactories.PANCAKE_V2.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.PancakeUSDTV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_USDT_V2)) {
            IUniswapV2LikeFactories.PANCAKE_V2.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.PancakeBUSDV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_BUSD_V2)) {
            IUniswapV2LikeFactories.PANCAKE_V2.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }
        if (dex == Dex.PancakeDOTV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_DOT_V2)) {
            IUniswapV2LikeFactories.PANCAKE_V2.swapTransitional(inToken, Tokens.DOT, outToken, amount);
        }

        // Nerve
        if (dex == Dex.NervePOOL3 && !flags.or(Flags.FLAG_DISABLE_NERVE_ALL, Flags.FLAG_DISABLE_NERVE_POOL3)) {
            return INerveExtension.POOL3.swap(inToken, outToken, amount);
        }
        if (dex == Dex.NerveBTC && !flags.or(Flags.FLAG_DISABLE_NERVE_ALL, Flags.FLAG_DISABLE_NERVE_BTC)) {
            return INerveExtension.BTC.swap(inToken, outToken, amount);
        }
        if (dex == Dex.NerveETH && !flags.or(Flags.FLAG_DISABLE_NERVE_ALL, Flags.FLAG_DISABLE_NERVE_ETH)) {
            return INerveExtension.ETH.swap(inToken, outToken, amount);
        }

        // Cafeswap
        if (dex == Dex.Cafeswap && !flags.on(Flags.FLAG_DISABLE_CAFESWAP_ALL)) {
            IUniswapV2LikeFactories.CAFESWAP.swap(inToken, outToken, amount);
        }

        // Beltswap
        // if (dex == Dex.Beltswap && !flags.on(Flags.FLAG_DISABLE_BELTSWAP_ALL)) {
        //     IBeltSwapExtension.BELT4.swap(inToken, outToken, amount);
        // }

        // Biswap
        if (dex == Dex.Biswap && !flags.on(Flags.FLAG_DISABLE_BISWAP_ALL)) {
            IUniswapV2LikeFactories.BISWAP.swap(inToken, outToken, amount);
        }
        if (dex == Dex.BiswapBNB && !flags.on(Flags.FLAG_DISABLE_BISWAP_ALL)) {
            IUniswapV2LikeFactories.BISWAP.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.BiswapBUSD && !flags.on(Flags.FLAG_DISABLE_BISWAP_ALL)) {
            IUniswapV2LikeFactories.BISWAP.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }
    }
}
