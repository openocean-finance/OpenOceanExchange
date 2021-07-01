// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
    // add Quickswap
    uint256 internal constant FLAG_DISABLE_QUICKSWAP_ALL = 1 << 0;
    uint256 internal constant FLAG_DISABLE_QUICKSWAP = 1 << 1;
    uint256 internal constant FLAG_DISABLE_QUICKSWAP_WMATIC = 1 << 2;
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

    // WETH
    uint256 internal constant FLAG_DISABLE_WETH = 1 << 13;

    // add Cometh
    uint256 internal constant FLAG_DISABLE_COMETH_ALL = 1 << 14;
    uint256 internal constant FLAG_DISABLE_COMETH = 1 << 15;
    uint256 internal constant FLAG_DISABLE_COMETH_ETH = 1 << 16;
    uint256 internal constant FLAG_DISABLE_COMETH_MUST = 1 << 17;

    // add Dfyn
    uint256 internal constant FLAG_DISABLE_DFYN_ALL = 1 << 18;
    uint256 internal constant FLAG_DISABLE_DFYN = 1 << 19;
    uint256 internal constant FLAG_DISABLE_DFYN_ETH = 1 << 20;
    uint256 internal constant FLAG_DISABLE_DFYN_USDC = 1 << 21;
    uint256 internal constant FLAG_DISABLE_DFYN_USDT = 1 << 22;

    // add PolyZap
    uint256 internal constant FLAG_DISABLE_POLYZAP_ALL = 1 << 23;
    uint256 internal constant FLAG_DISABLE_POLYZAP = 1 << 24;
    uint256 internal constant FLAG_DISABLE_POLYZAP_ETH = 1 << 25;
    uint256 internal constant FLAG_DISABLE_POLYZAP_USDC = 1 << 26;

    // add Curve
    uint256 internal constant FLAG_DISABLE_CURVE_ALL = 1 << 27;
    uint256 internal constant FLAG_DISABLE_CURVE_AAVE = 1 << 28;

    //add oneswap
    uint256 internal constant FLAG_DISABLE_ONESWAP = 1 << 29;

    // add polydex
    uint256 internal constant FLAG_DISABLE_POLYDEX_ALL = 1 << 30;
    uint256 internal constant FLAG_DISABLE_POLYDEX = 1 << 31;
    uint256 internal constant FLAG_DISABLE_POLYDEX_WETH = 1 << 32;
    uint256 internal constant FLAG_DISABLE_POLYDEX_DAI = 1 << 33;
    uint256 internal constant FLAG_DISABLE_POLYDEX_USDC = 1 << 34;
    uint256 internal constant FLAG_DISABLE_POLYDEX_USDT = 1 << 35;


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
