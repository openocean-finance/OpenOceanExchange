// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
    // uint256 internal constant FLAG_DISABLE_UNISWAP_V2_ALL = 1 << 0;
    // uint256 internal constant FLAG_DISABLE_UNISWAP_V2 = 1 << 1;
    // uint256 internal constant FLAG_DISABLE_UNISWAP_V2_ETH = 1 << 2;
    // uint256 internal constant FLAG_DISABLE_UNISWAP_V2_DAI = 1 << 3;
    // uint256 internal constant FLAG_DISABLE_UNISWAP_V2_USDC = 1 << 4;
    // uint256 internal constant FLAG_DISABLE_CURVE_ALL = 1 << 5;
    // uint256 internal constant FLAG_DISABLE_CURVE_COMPOUND = 1 << 6;
    // uint256 internal constant FLAG_DISABLE_CURVE_USDT = 1 << 7;
    // uint256 internal constant FLAG_DISABLE_CURVE_Y = 1 << 8;
    // uint256 internal constant FLAG_DISABLE_CURVE_BINANCE = 1 << 9;
    // uint256 internal constant FLAG_DISABLE_CURVE_SYNTHETIX = 1 << 10;
    // uint256 internal constant FLAG_DISABLE_CURVE_PAX = 1 << 11;
    // uint256 internal constant FLAG_DISABLE_CURVE_RENBTC = 1 << 12;
    // uint256 internal constant FLAG_DISABLE_CURVE_TBTC = 1 << 13;
    // uint256 internal constant FLAG_DISABLE_CURVE_SBTC = 1 << 14;
    // uint256 internal constant FLAG_DISABLE_OASIS = 1 << 15;
    // uint256 internal constant FLAG_DISABLE_UNISWAP = 1 << 16;
    // // add SushiSwap
    // uint256 internal constant FLAG_DISABLE_SUSHISWAP_ALL = 1 << 17;
    // uint256 internal constant FLAG_DISABLE_SUSHISWAP = 1 << 18;
    // uint256 internal constant FLAG_DISABLE_SUSHISWAP_ETH = 1 << 19;
    // uint256 internal constant FLAG_DISABLE_SUSHISWAP_DAI = 1 << 20;
    // uint256 internal constant FLAG_DISABLE_SUSHISWAP_USDC = 1 << 21;
    // // add Mooniswap
    // uint256 internal constant FLAG_DISABLE_MOONISWAP_ALL = 1 << 22;
    // uint256 internal constant FLAG_DISABLE_MOONISWAP = 1 << 23;
    // uint256 internal constant FLAG_DISABLE_MOONISWAP_ETH = 1 << 24;
    // uint256 internal constant FLAG_DISABLE_MOONISWAP_DAI = 1 << 25;
    // uint256 internal constant FLAG_DISABLE_MOONISWAP_USDC = 1 << 26;
    // // add Balancer
    // uint256 internal constant FLAG_DISABLE_BALANCER_ALL = 1 << 27;
    // uint256 internal constant FLAG_DISABLE_BALANCER_1 = 1 << 28;
    // uint256 internal constant FLAG_DISABLE_BALANCER_2 = 1 << 29;
    // uint256 internal constant FLAG_DISABLE_BALANCER_3 = 1 << 30;
    // // add Kyber
    // uint256 internal constant FLAG_DISABLE_KYBER_ALL = 1 << 31;
    // uint256 internal constant FLAG_DISABLE_KYBER_1 = 1 << 32;
    // uint256 internal constant FLAG_DISABLE_KYBER_2 = 1 << 33;
    // uint256 internal constant FLAG_DISABLE_KYBER_3 = 1 << 34;
    // uint256 internal constant FLAG_DISABLE_KYBER_4 = 1 << 35;

    uint256 internal constant FLAG_DISABLE_PANCAKE_ALL = 1 << 0;
    uint256 internal constant FLAG_DISABLE_PANCAKE = 1 << 1;
    uint256 internal constant FLAG_DISABLE_PANCAKE_ETH = 1 << 2;
    uint256 internal constant FLAG_DISABLE_PANCAKE_DAI = 1 << 3;
    uint256 internal constant FLAG_DISABLE_PANCAKE_USDC = 1 << 4;
    uint256 internal constant FLAG_DISABLE_PANCAKE_USDT = 1 << 5;
    // Bakery
    uint256 internal constant FLAG_DISABLE_BAKERY_ALL = 1 << 6;
    uint256 internal constant FLAG_DISABLE_BAKERY = 1 << 7;
    uint256 internal constant FLAG_DISABLE_BAKERY_ETH = 1 << 8;
    uint256 internal constant FLAG_DISABLE_BAKERY_DAI = 1 << 9;
    uint256 internal constant FLAG_DISABLE_BAKERY_USDC = 1 << 10;
    uint256 internal constant FLAG_DISABLE_BAKERY_USDT = 1 << 11;
    // Burger
    uint256 internal constant FLAG_DISABLE_BURGER_ALL = 1 << 12;
    uint256 internal constant FLAG_DISABLE_BURGER = 1 << 13;
    uint256 internal constant FLAG_DISABLE_BURGER_ETH = 1 << 14;
    uint256 internal constant FLAG_DISABLE_BURGER_DGAS = 1 << 15;
    // Thugswap
    uint256 internal constant FLAG_DISABLE_THUGSWAP_ALL = 1 << 16;
    uint256 internal constant FLAG_DISABLE_THUGSWAP = 1 << 17;
    uint256 internal constant FLAG_DISABLE_THUGSWAP_ETH = 1 << 18;
    uint256 internal constant FLAG_DISABLE_THUGSWAP_DAI = 1 << 19;
    uint256 internal constant FLAG_DISABLE_THUGSWAP_USDC = 1 << 20;
    uint256 internal constant FLAG_DISABLE_THUGSWAP_USDT = 1 << 21;
    // BUSD transitional token
    uint256 internal constant FLAG_DISABLE_PANCAKE_BUSD = 1 << 22;
    uint256 internal constant FLAG_DISABLE_BAKERY_BUSD = 1 << 23;
    uint256 internal constant FLAG_DISABLE_THUGSWAP_BUSD = 1 << 24;
    // StableX
    uint256 internal constant FLAG_DISABLE_STABLEX_ALL = 1 << 25;
    uint256 internal constant FLAG_DISABLE_STABLEX = 1 << 26;
    uint256 internal constant FLAG_DISABLE_STABLEX_BUSD = 1 << 27;
    uint256 internal constant FLAG_DISABLE_STABLEX_QUSD = 1 << 28;
    uint256 internal constant FLAG_DISABLE_STABLEX_USDC = 1 << 29;
    uint256 internal constant FLAG_DISABLE_STABLEX_USDT = 1 << 30;
    uint256 internal constant FLAG_DISABLE_STABLEX_DAI = 1 << 31;
    // Unifi
    uint256 internal constant FLAG_DISABLE_UNIFI_ALL = 1 << 32;
    uint256 internal constant FLAG_DISABLE_UNIFI = 1 << 33;
    // WETH
    uint256 internal constant FLAG_DISABLE_WETH = 1 << 34;
    // Julswap
    uint256 internal constant FLAG_DISABLE_JULSWAP_ALL = 1 << 35;
    uint256 internal constant FLAG_DISABLE_JULSWAP = 1 << 36;
    uint256 internal constant FLAG_DISABLE_JULSWAP_ETH = 1 << 37;
    uint256 internal constant FLAG_DISABLE_JULSWAP_DAI = 1 << 38;
    uint256 internal constant FLAG_DISABLE_JULSWAP_USDC = 1 << 39;
    uint256 internal constant FLAG_DISABLE_JULSWAP_USDT = 1 << 40;
    uint256 internal constant FLAG_DISABLE_JULSWAP_BUSD = 1 << 41;
    // Pancake DOT
    uint256 internal constant FLAG_DISABLE_PANCAKE_DOT = 1 << 42;
    // Acryptos
    uint256 internal constant FLAG_DISABLE_ACRYPTOS_ALL = 1 << 43;
    uint256 internal constant FLAG_DISABLE_ACRYPTOS_USD = 1 << 44;
    uint256 internal constant FLAG_DISABLE_ACRYPTOS_VAI = 1 << 45;
    uint256 internal constant FLAG_DISABLE_ACRYPTOS_UST = 1 << 46;
    uint256 internal constant FLAG_DISABLE_ACRYPTOS_QUSD = 1 << 47;
    // Apeswap
    uint256 internal constant FLAG_DISABLE_APESWAP_ALL = 1 << 48;
    uint256 internal constant FLAG_DISABLE_APESWAP = 1 << 49;
    uint256 internal constant FLAG_DISABLE_APESWAP_ETH = 1 << 50;
    uint256 internal constant FLAG_DISABLE_APESWAP_USDT = 1 << 51;
    uint256 internal constant FLAG_DISABLE_APESWAP_BUSD = 1 << 52;
    uint256 internal constant FLAG_DISABLE_APESWAP_BANANA = 1 << 53;
    // add DODO
    uint256 internal constant FLAG_DISABLE_DODO_ALL = 1 << 54;
    uint256 internal constant FLAG_DISABLE_DODO = 1 << 55;
    uint256 internal constant FLAG_DISABLE_DODO_USDC = 1 << 56;
    uint256 internal constant FLAG_DISABLE_DODO_USDT = 1 << 57;
    // add Smoothy
    uint256 internal constant FLAG_DISABLE_SMOOTHY = 1 << 58;
    // add Ellipsis
    uint256 internal constant FLAG_DISABLE_ELLIPSIS = 1 << 59;
    // add MDex
    uint256 internal constant FLAG_DISABLE_MDEX_ALL = 1 << 60;
    uint256 internal constant FLAG_DISABLE_MDEX = 1 << 61;
    uint256 internal constant FLAG_DISABLE_MDEX_ETH = 1 << 62;
    uint256 internal constant FLAG_DISABLE_MDEX_BUSD = 1 << 63;
    uint256 internal constant FLAG_DISABLE_MDEX_USDC = 1 << 64;
    uint256 internal constant FLAG_DISABLE_MDEX_USDT = 1 << 65;
    // PANCAKE_V2
    uint256 internal constant FLAG_DISABLE_PANCAKE_ALL_V2 = 1 << 66;
    uint256 internal constant FLAG_DISABLE_PANCAKE_V2 = 1 << 67;
    uint256 internal constant FLAG_DISABLE_PANCAKE_ETH_V2 = 1 << 68;
    uint256 internal constant FLAG_DISABLE_PANCAKE_USDC_V2 = 1 << 69;
    uint256 internal constant FLAG_DISABLE_PANCAKE_USDT_V2 = 1 << 70;
    uint256 internal constant FLAG_DISABLE_PANCAKE_DOT_V2 = 1 << 71;
    uint256 internal constant FLAG_DISABLE_PANCAKE_BUSD_V2 = 1 << 72;

    function on(uint256 flags, uint256 flag) internal pure returns (bool) {
        return (flags & flag) != 0;
    }

    function or(
        uint256 flags,
        uint256 flag1,
        uint256 flag2
    ) internal pure returns (bool) {
        return on(flags, flag1 | flag2);
    }
}
