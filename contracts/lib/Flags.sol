// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
    // add Quickswap
    uint256 internal constant FLAG_DISABLE_QUICKSWAP_ALL = 1 << 0;
    uint256 internal constant FLAG_DISABLE_QUICKSWAP = 1 << 1;
    uint256 internal constant FLAG_DISABLE_QUICKSWAP_ETH = 1 << 2;
    uint256 internal constant FLAG_DISABLE_QUICKSWAP_DAI = 1 << 3;
    uint256 internal constant FLAG_DISABLE_QUICKSWAP_USDC = 1 << 4;
    uint256 internal constant FLAG_DISABLE_QUICKSWAP_USDT = 1 << 5;
    uint256 internal constant FLAG_DISABLE_QUICKSWAP_QUICK = 1 << 6;

    // add SushiSwap
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_ALL = 1 << 7;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP = 1 << 8;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_ETH = 1 << 9;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_DAI = 1 << 10;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_USDC = 1 << 11;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_USDT = 1 << 12;

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
