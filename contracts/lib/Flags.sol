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
