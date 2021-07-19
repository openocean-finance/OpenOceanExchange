// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
    // add MDex
    uint256 internal constant FLAG_DISABLE_MDEX_ALL = 1 << 0;
    uint256 internal constant FLAG_DISABLE_MDEX = 1 << 1;
    uint256 internal constant FLAG_DISABLE_MDEX_HT = 1 << 2;
    uint256 internal constant FLAG_DISABLE_MDEX_USDC = 1 << 3;
    uint256 internal constant FLAG_DISABLE_MDEX_USDT = 1 << 4;

    // add Makiswap
    uint256 internal constant FLAG_DISABLE_MAKISWAP_ALL = 1 << 5;
    uint256 internal constant FLAG_DISABLE_MAKISWAP = 1 << 6;
    uint256 internal constant FLAG_DISABLE_MAKISWAP_HT = 1 << 7;
    uint256 internal constant FLAG_DISABLE_MAKISWAP_USDC = 1 << 8;
    uint256 internal constant FLAG_DISABLE_MAKISWAP_USDT = 1 << 9;

    // add WHT
    uint256 internal constant FLAG_DISABLE_WETH = 1 << 10;

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
