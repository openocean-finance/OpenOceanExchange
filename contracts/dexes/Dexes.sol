// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";
import "../lib/Flags.sol";
// import "./IUniswapV2.sol";
// import "./ICurvePool.sol";
// import "./IOasis.sol";
// import "./IUniswap.sol";
// import "./ISushiSwap.sol";
import "./IMooniswap.sol";
// import "./IBalancer.sol";
// import "./IKyber.sol";
// import "./IPancake.sol";
import "./IPancakeV2.sol";
import "./IBakery.sol";
// import "./IBurger.sol";
import "./IThugswap.sol";
import "./IStablex.sol";
// import "./IUnifi.sol";
import "./IWETH.sol";
import "./IJulswap.sol";
import "./IAcryptos.sol";
import "./IApeswap.sol";
// import "./IDODO.sol";
import "./ISmoothy.sol";
import "./IEllipsis.sol";
import "./IMDex.sol";
import "./INerve.sol";
import "./ICafeswap.sol";
// import "./IBeltswap.sol";
import "./IPantherSwap.sol";
import "./IPancakeBunny.sol";
import "./IInnoswap.sol";
import "./IWaultSwap.sol";
import "./IBabyswap.sol";
enum Dex {
    // UniswapV2,
    // UniswapV2ETH,
    // UniswapV2DAI,
    // UniswapV2USDC,
    // CurveCompound,
    // CurveUSDT,
    // CurveY,
    // CurveBinance,
    // CurveSynthetix,
    // CurvePAX,
    // CurveRenBTC,
    // CurveTBTC,
    // CurveSBTC,
    // Oasis,
    // Uniswap,
    // Curve,
    // // add SushiSwap
    // SushiSwap,
    // SushiSwapETH,
    // SushiSwapDAI,
    // SushiSwapUSDC,
    // // add Balancer
    // Balancer,
    // Balancer1,
    // Balancer2,
    // Balancer3,
    // // add Kyber
    // Kyber,
    // Kyber1,
    // Kyber2,
    // Kyber3,
    // Kyber4,

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
    //waultSwap
    Waultswap,
    //babyswap
    Babyswap,
    // bottom mark
    NoDex
}

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

    IBabyswapFactory internal constant babyswap = IBabyswapFactory(0x86407bEa2078ea5f5EB5A52B2caA963bC1F889Da);
    using IBabyswapFactoryExtension for IBabyswapFactory;

    IWaultSwapFactory internal constant waultswap = IWaultSwapFactory(0xB42E3FE71b7E0673335b3331B3e1053BD9822570);
    using IWaultSwapFactoryExtension for IWaultSwapFactory;

    IInnoswapFactory internal constant innoswap = IInnoswapFactory(0xd76d8C2A7CA0a1609Aea0b9b5017B3F7782891bf);
    using IInnoswapFactoryExtension for IInnoswapFactory;

    IZapBsc internal constant zap = IZapBsc(0xdC2bBB0D33E0e7Dea9F5b98F46EDBaC823586a0C);
    using IZapBscExtension for IZapBsc;

    // https://docs.pantherswap.com/others/contracts
    //PantherSwap
    IPantherSwapFactory internal constant pantherSwap = IPantherSwapFactory(0x670f55c6284c629c23baE99F585e3f17E8b9FC31);
    using IPantherSwapFactoryExtension for IPantherSwapFactory;

    // 1inch
    //old   0xbAF9A5d4b0052359326A6CDAb54BABAa3a3A9643
    //0xD41B24bbA51fAc0E4827b6F94C0D6DDeB183cD64
    IMooniswapRegistry internal constant mooniswap = IMooniswapRegistry(0xD41B24bbA51fAc0E4827b6F94C0D6DDeB183cD64);
    using IMooniswapRegistryExtension for IMooniswapRegistry;

    // IPancakeFactory internal constant pancake = IPancakeFactory(0xBCfCcbde45cE874adCB698cC183deBcF17952812);
    // using IPancakeFactoryExtension for IPancakeFactory;

    IPancakeFactoryV2 internal constant pancakeV2 = IPancakeFactoryV2(0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73);
    using IPancakeFactoryExtensionV2 for IPancakeFactoryV2;

    IBakeryFactory internal constant bakery = IBakeryFactory(0x01bF7C66c6BD861915CdaaE475042d3c4BaE16A7);
    using IBakeryFactoryExtension for IBakeryFactory;

    // IDemaxPlatform internal constant burger = IDemaxPlatform(0xBf6527834dBB89cdC97A79FCD62E6c08B19F8ec0);
    // using IDemaxPlatformExtension for IDemaxPlatform;

    IThugswapFactory internal constant thugswap = IThugswapFactory(0xaC653cE27E04C6ac565FD87F18128aD33ca03Ba2);
    using IThugswapFactoryExtension for IThugswapFactory;

    IStablexFactory internal constant stablex = IStablexFactory(0x918d7e714243F7d9d463C37e106235dCde294ffC);
    using IStablexFactoryExtension for IStablexFactory;

    // IUnifiTradeRegistry internal constant unifi = IUnifiTradeRegistry(0xFD4B5179B535df687e0861cDF86E9CCAB50E5A51);
    // using IUnifiTradeRegistryExtenstion for IUnifiTradeRegistry;

    IWETH internal constant weth = IWETH(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    using IWETHExtension for IWETH;

    IJulswapFactory internal constant julswap = IJulswapFactory(0x553990F2CBA90272390f62C5BDb1681fFc899675);
    using IJulswapFactoryExtension for IJulswapFactory;

    using IAcryptosPoolExtension for IAcryptosPool;

    IApeswapFactory internal constant apeswap = IApeswapFactory(0x0841BD0B734E4F5853f0dD8d7Ea041c241fb0Da6);
    using IApeswapFactoryExtension for IApeswapFactory;

    // IDODOZoo internal constant dodo = IDODOZoo(0xCA459456a45e300AA7EF447DBB60F87CCcb42828);
    // using IDODOZooExtension for IDODOZoo;

    ISmoothy internal constant smoothy = ISmoothy(0xe5859f4EFc09027A9B718781DCb2C6910CAc6E91);
    using ISmoothyExtension for ISmoothy;

    using IEllipsisPoolExtension for IEllipsisPool;

    IMDexFactory internal constant mdex = IMDexFactory(0x3CD1C46068dAEa5Ebb0d3f55F6915B10648062B8);
    using IMDexFactoryExtension for IMDexFactory;

    using INerveExtension for INerve;

    ICafeFactory internal constant cafeswap = ICafeFactory(0x3e708FdbE3ADA63fc94F8F61811196f1302137AD);
    using ICafeFactoryExtension for ICafeFactory;

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
        if (dex == Dex.Babyswap && !flags.on(Flags.FLAG_DISABLE_BABYSWAP)) {
            return babyswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.Waultswap && !flags.on(Flags.FLAG_DISABLE_WAULTSWAP)) {
            return waultswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.Innoswap && !flags.on(Flags.FLAG_DISABLE_INNOSWAP)) {
            return innoswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.PancakeBunny && !flags.on(Flags.FLAG_DISABLE_ZAPBSC)) {
            return zap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.PantherSwap && !flags.or(Flags.FLAG_DISABLE_PANTHERSWAP_ALL, Flags.FLAG_DISABLE_PANTHERSWAP)) {
            return pantherSwap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        // if (dex == Dex.PantherSwap && !flags.or(Flags.FLAG_DISABLE_PANTHERSWAP_ALL, Flags.FLAG_DISABLE_PANTHERSWAP_BNB)) {
        //     return pantherSwap.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        // }
        // if (dex == Dex.PantherSwap && !flags.or(Flags.FLAG_DISABLE_PANTHERSWAP_ALL, Flags.FLAG_DISABLE_PANTHERSWAP_USDC)) {
        //     return pantherSwap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        // }
        // if (dex == Dex.PantherSwap && !flags.or(Flags.FLAG_DISABLE_PANTHERSWAP_ALL, Flags.FLAG_DISABLE_PANTHERSWAP_USDT)) {
        //     return pantherSwap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        // }
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
        // if (dex == Dex.Pancake && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE)) {
        //     return pancake.calculateSwapReturn(inToken, outToken, inAmounts);
        // }
        // if (dex == Dex.PancakeETH && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_ETH)) {
        //     return pancake.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        // }
        // if (dex == Dex.PancakeDAI && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_DAI)) {
        //     return pancake.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        // }
        // if (dex == Dex.PancakeUSDC && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_USDC)) {
        //     return pancake.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        // }
        // if (dex == Dex.PancakeUSDT && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_USDT)) {
        //     return pancake.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        // }
        // if (dex == Dex.PancakeBUSD && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_BUSD)) {
        //     return pancake.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        // }
        // if (dex == Dex.PancakeDOT && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_DOT)) {
        //     return pancake.calculateTransitionalSwapReturn(inToken, Tokens.DOT, outToken, inAmounts);
        // }
        // Bakery
        if (dex == Dex.Bakery && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY)) {
            return bakery.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.BakeryETH && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_ETH)) {
            return bakery.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.BakeryDAI && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_DAI)) {
            return bakery.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.BakeryUSDC && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_USDC)) {
            return bakery.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.BakeryUSDT && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_USDT)) {
            return bakery.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.BakeryBUSD && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_BUSD)) {
            return bakery.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
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
            return thugswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapETH && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_ETH)) {
            return thugswap.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapDAI && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_DAI)) {
            return thugswap.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapUSDC && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_USDC)) {
            return thugswap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapUSDT && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_USDT)) {
            return thugswap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapBUSD && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_BUSD)) {
            return thugswap.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }
        // Stablex
        if (dex == Dex.Stablex && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX)) {
            return stablex.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.StablexQUSD && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_QUSD)) {
            return stablex.calculateTransitionalSwapReturn(inToken, Tokens.QUSD, outToken, inAmounts);
        }
        if (dex == Dex.StablexDAI && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_DAI)) {
            return stablex.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.StablexUSDC && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_USDC)) {
            return stablex.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.StablexUSDT && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_USDT)) {
            return stablex.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.StablexBUSD && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_BUSD)) {
            return stablex.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
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
            return julswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.JulswapETH && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_ETH)) {
            return julswap.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.JulswapDAI && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_DAI)) {
            return julswap.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.JulswapUSDC && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_USDC)) {
            return julswap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.JulswapUSDT && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_USDT)) {
            return julswap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.JulswapBUSD && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_BUSD)) {
            return julswap.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
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
            return apeswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.ApeswapETH && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_ETH)) {
            return apeswap.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.ApeswapBANANA && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_BANANA)) {
            return apeswap.calculateTransitionalSwapReturn(inToken, Tokens.BANANA, outToken, inAmounts);
        }
        if (dex == Dex.ApeswapUSDT && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_USDT)) {
            return apeswap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.ApeswapBUSD && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_BUSD)) {
            return apeswap.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
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
            return mdex.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.MDexETH && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_ETH)) {
            return mdex.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
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

        // PancakeV2
        if (dex == Dex.PancakeV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_V2)) {
            return pancakeV2.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.PancakeETHV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_ETH_V2)) {
            return pancakeV2.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.PancakeUSDCV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_USDC_V2)) {
            return pancakeV2.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.PancakeUSDTV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_USDT_V2)) {
            return pancakeV2.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.PancakeBUSDV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_BUSD_V2)) {
            return pancakeV2.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }
        if (dex == Dex.PancakeDOTV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_DOT_V2)) {
            return pancakeV2.calculateTransitionalSwapReturn(inToken, Tokens.DOT, outToken, inAmounts);
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
            return cafeswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Beltswap
        // if (dex == Dex.Beltswap && !flags.on(Flags.FLAG_DISABLE_BELTSWAP_ALL)) {
        //     return IBeltSwapExtension.BELT4.calculateSwapReturn(inToken, outToken, inAmounts);
        // }

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
        if (dex == Dex.Babyswap && !flags.on(Flags.FLAG_DISABLE_BABYSWAP)) {
            babyswap.swap(inToken, outToken, amount);
        }
        // waultSwap
        if (dex == Dex.Waultswap && !flags.on(Flags.FLAG_DISABLE_WAULTSWAP)) {
            waultswap.swap(inToken, outToken, amount);
        }

        // Innoswap
        if (dex == Dex.Innoswap && !flags.on(Flags.FLAG_DISABLE_INNOSWAP)) {
            innoswap.swap(inToken, outToken, amount);
        }
        // PancakeBunny
        if (dex == Dex.PancakeBunny && !flags.on(Flags.FLAG_DISABLE_ZAPBSC)) {
            zap.swap(inToken, outToken, amount);
        }
        // PantherSwap
        if (dex == Dex.PantherSwap && !flags.or(Flags.FLAG_DISABLE_PANTHERSWAP_ALL, Flags.FLAG_DISABLE_PANTHERSWAP)) {
            pantherSwap.swap(inToken, outToken, amount);
        }
        // add 1inch
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
        // if (dex == Dex.Pancake && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE)) {
        //     pancake.swap(inToken, outToken, amount);
        // }
        // if (dex == Dex.PancakeETH && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_ETH)) {
        //     pancake.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        // }
        // if (dex == Dex.PancakeDAI && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_DAI)) {
        //     pancake.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        // }
        // if (dex == Dex.PancakeUSDC && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_USDC)) {
        //     pancake.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        // }
        // if (dex == Dex.PancakeUSDT && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_USDT)) {
        //     pancake.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        // }
        // if (dex == Dex.PancakeBUSD && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_BUSD)) {
        //     pancake.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        // }
        // if (dex == Dex.PancakeDOT && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_DOT)) {
        //     pancake.swapTransitional(inToken, Tokens.DOT, outToken, amount);
        // }
        // Bakery
        if (dex == Dex.Bakery && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY)) {
            bakery.swap(inToken, outToken, amount);
        }
        if (dex == Dex.BakeryETH && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_ETH)) {
            bakery.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.BakeryDAI && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_DAI)) {
            bakery.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.BakeryUSDC && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_USDC)) {
            bakery.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.BakeryUSDT && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_USDT)) {
            bakery.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.BakeryBUSD && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_BUSD)) {
            bakery.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
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
            thugswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.ThugswapETH && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_ETH)) {
            thugswap.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.ThugswapDAI && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_DAI)) {
            thugswap.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.ThugswapUSDC && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_USDC)) {
            thugswap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.ThugswapUSDT && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_USDT)) {
            thugswap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.ThugswapBUSD && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_BUSD)) {
            thugswap.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }
        // Stablex
        if (dex == Dex.Stablex && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX)) {
            stablex.swap(inToken, outToken, amount);
        }
        if (dex == Dex.StablexQUSD && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_QUSD)) {
            stablex.swapTransitional(inToken, Tokens.QUSD, outToken, amount);
        }
        if (dex == Dex.StablexDAI && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_DAI)) {
            stablex.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.StablexUSDC && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_USDC)) {
            stablex.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.StablexUSDT && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_USDT)) {
            stablex.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.StablexBUSD && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_BUSD)) {
            stablex.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
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
            julswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.JulswapETH && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_ETH)) {
            julswap.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.JulswapDAI && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_DAI)) {
            julswap.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.JulswapUSDC && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_USDC)) {
            julswap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.JulswapUSDT && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_USDT)) {
            julswap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.JulswapBUSD && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_BUSD)) {
            julswap.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
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
            apeswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.ApeswapETH && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_ETH)) {
            apeswap.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.ApeswapBANANA && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_BANANA)) {
            apeswap.swapTransitional(inToken, Tokens.BANANA, outToken, amount);
        }
        if (dex == Dex.ApeswapUSDT && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_USDT)) {
            apeswap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.ApeswapBUSD && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_BUSD)) {
            apeswap.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
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
            mdex.swap(inToken, outToken, amount);
        }
        if (dex == Dex.MDexETH && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_ETH)) {
            mdex.swapTransitional(inToken, Tokens.WETH, outToken, amount);
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

        // Pancake V2
        if (dex == Dex.PancakeV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_V2)) {
            pancakeV2.swap(inToken, outToken, amount);
        }
        if (dex == Dex.PancakeETHV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_ETH_V2)) {
            pancakeV2.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.PancakeUSDCV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_USDC_V2)) {
            pancakeV2.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.PancakeUSDTV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_USDT_V2)) {
            pancakeV2.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.PancakeBUSDV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_BUSD_V2)) {
            pancakeV2.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }
        if (dex == Dex.PancakeDOTV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_DOT_V2)) {
            pancakeV2.swapTransitional(inToken, Tokens.DOT, outToken, amount);
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
            cafeswap.swap(inToken, outToken, amount);
        }

        // Beltswap
        // if (dex == Dex.Beltswap && !flags.on(Flags.FLAG_DISABLE_BELTSWAP_ALL)) {
        //     IBeltSwapExtension.BELT4.swap(inToken, outToken, amount);
        // }
    }
}
