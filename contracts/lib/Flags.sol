// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2_ALL = 1 << 0;
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2 = 1 << 1;
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2_ETH = 1 << 2;
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2_DAI = 1 << 3;
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2_USDC = 1 << 4;
    uint256 internal constant FLAG_DISABLE_CURVE_ALL = 1 << 5;
    uint256 internal constant FLAG_DISABLE_CURVE_COMPOUND = 1 << 6;
    uint256 internal constant FLAG_DISABLE_CURVE_USDT = 1 << 7;
    uint256 internal constant FLAG_DISABLE_CURVE_Y = 1 << 8;
    uint256 internal constant FLAG_DISABLE_CURVE_BINANCE = 1 << 9;
    uint256 internal constant FLAG_DISABLE_CURVE_SYNTHETIX = 1 << 10;
    uint256 internal constant FLAG_DISABLE_CURVE_PAX = 1 << 11;
    uint256 internal constant FLAG_DISABLE_CURVE_RENBTC = 1 << 12;
    uint256 internal constant FLAG_DISABLE_CURVE_TBTC = 1 << 13;
    uint256 internal constant FLAG_DISABLE_CURVE_SBTC = 1 << 14;
    uint256 internal constant FLAG_DISABLE_OASIS = 1 << 15;
    uint256 internal constant FLAG_DISABLE_UNISWAP = 1 << 16;
    // add SushiSwap
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_ALL = 1 << 17;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP = 1 << 18;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_ETH = 1 << 19;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_DAI = 1 << 20;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_USDC = 1 << 21;
    // add Mooniswap
    uint256 internal constant FLAG_DISABLE_MOONISWAP_ALL = 1 << 22;
    uint256 internal constant FLAG_DISABLE_MOONISWAP = 1 << 23;
    uint256 internal constant FLAG_DISABLE_MOONISWAP_ETH = 1 << 24;
    uint256 internal constant FLAG_DISABLE_MOONISWAP_DAI = 1 << 25;
    uint256 internal constant FLAG_DISABLE_MOONISWAP_USDC = 1 << 26;
    // add Balancer
    uint256 internal constant FLAG_DISABLE_BALANCER_ALL = 1 << 27;
    uint256 internal constant FLAG_DISABLE_BALANCER_1 = 1 << 28;
    uint256 internal constant FLAG_DISABLE_BALANCER_2 = 1 << 29;
    uint256 internal constant FLAG_DISABLE_BALANCER_3 = 1 << 30;
    // add Kyber
    uint256 internal constant FLAG_DISABLE_KYBER_ALL = 1 << 31;
    uint256 internal constant FLAG_DISABLE_KYBER_1 = 1 << 32;
    uint256 internal constant FLAG_DISABLE_KYBER_2 = 1 << 33;
    uint256 internal constant FLAG_DISABLE_KYBER_3 = 1 << 34;
    uint256 internal constant FLAG_DISABLE_KYBER_4 = 1 << 35;
    // add DODO
    uint256 internal constant FLAG_DISABLE_DODO_ALL = 1 << 36;
    uint256 internal constant FLAG_DISABLE_DODO = 1 << 37;
    uint256 internal constant FLAG_DISABLE_DODO_USDC = 1 << 38;
    uint256 internal constant FLAG_DISABLE_DODO_USDT = 1 << 39;
    // add Smoothy
    uint256 internal constant FLAG_DISABLE_SMOOTHY = 1 << 40;

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
