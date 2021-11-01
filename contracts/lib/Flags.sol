// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
    // add SushiSwap
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_ALL = 1 << 0;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP = 1 << 1;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_FTM = 1 << 2;

    //add SpookySwap
    uint256 internal constant FLAG_DISABLE_SPOOKYSWAP_ALL = 1 << 3;
    uint256 internal constant FLAG_DISABLE_SPOOKYSWAP = 1 << 4;
    uint256 internal constant FLAG_DISABLE_SPOOKYSWAP_FTM = 1 << 5;

    //add SpookySwap
    uint256 internal constant FLAG_DISABLE_SPIRITSWAP_ALL = 1 << 6;
    uint256 internal constant FLAG_DISABLE_SPIRITSWAP = 1 << 7;
    uint256 internal constant FLAG_DISABLE_SPIRITSWAP_FTM = 1 << 8;

    //add Curve
    uint256 internal constant FLAG_DISABLE_CURVE_2POOL = 1 << 9;
    uint256 internal constant FLAG_DISABLE_CURVE_FUSDT = 1 << 10;
    uint256 internal constant FLAG_DISABLE_CURVE_RENBTC = 1 << 11;

    //add froyo
    uint256 internal constant FLAG_DISABLE_FROYO = 1 << 12;

    //add ironswap
    uint256 internal constant FLAG_DISABLE_IRONSWAP = 1 << 13;

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
