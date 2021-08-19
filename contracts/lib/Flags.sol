// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
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

    // Nerve
    uint256 internal constant FLAG_DISABLE_NERVE_ALL = 1 << 73;
    uint256 internal constant FLAG_DISABLE_NERVE_POOL3 = 1 << 74;
    uint256 internal constant FLAG_DISABLE_NERVE_BTC = 1 << 75;
    uint256 internal constant FLAG_DISABLE_NERVE_ETH = 1 << 76;
    // Cafeswap
    uint256 internal constant FLAG_DISABLE_CAFESWAP_ALL = 1 << 77;
    // Beltswap
    uint256 internal constant FLAG_DISABLE_BELTSWAP_ALL = 1 << 78;

    // add Mooniswap
    uint256 internal constant FLAG_DISABLE_MOONISWAP_ALL = 1 << 79;
    uint256 internal constant FLAG_DISABLE_MOONISWAP = 1 << 80;
    uint256 internal constant FLAG_DISABLE_MOONISWAP_ETH = 1 << 81;
    uint256 internal constant FLAG_DISABLE_MOONISWAP_DAI = 1 << 82;
    uint256 internal constant FLAG_DISABLE_MOONISWAP_USDC = 1 << 83;

    // PantherSwap
    uint256 internal constant FLAG_DISABLE_PANTHERSWAP_ALL = 1 << 84;
    uint256 internal constant FLAG_DISABLE_PANTHERSWAP = 1 << 85;
    uint256 internal constant FLAG_DISABLE_PANTHERSWAP_BNB = 1 << 86;
    uint256 internal constant FLAG_DISABLE_PANTHERSWAP_USDC = 1 << 87;
    uint256 internal constant FLAG_DISABLE_PANTHERSWAP_USDT = 1 << 88;

    // PancakeBunny
    uint256 internal constant FLAG_DISABLE_ZAPBSC = 1 << 89;

    // Innoswap
    uint256 internal constant FLAG_DISABLE_INNOSWAP_ALL = 1 << 90;
    // Waultswap
    uint256 internal constant FLAG_DISABLE_WAULTSWAP_ALL = 1 << 91;
    // Babyswap
    uint256 internal constant FLAG_DISABLE_BABYSWAP_ALL = 1 << 92;
    // Biswap
    uint256 internal constant FLAG_DISABLE_BISWAP_ALL = 1 << 93;

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
