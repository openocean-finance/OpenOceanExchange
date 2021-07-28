// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
    // add SushiSwap
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_ALL = 1 << 0;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP = 1 << 1;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_WAVAX = 1 << 2;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_DAI = 1 << 3;

    uint256 internal constant FLAG_DISABLE_PANGONLINSWAP_ALL = 1 << 4;
    uint256 internal constant FLAG_DISABLE_PANGONLINSWAP = 1 << 5;
    uint256 internal constant FLAG_DISABLE_PANGONLINSWAP_WAVAX = 1 << 6;
    uint256 internal constant FLAG_DISABLE_PANGONLINSWAP_DAI = 1 << 7;

    uint256 internal constant FLAG_DISABLE_JOESWAP_ALL = 1 << 8;
    uint256 internal constant FLAG_DISABLE_JOESWAP = 1 << 9;
    uint256 internal constant FLAG_DISABLE_JOESWAP_WAVAX = 1 << 10;
    uint256 internal constant FLAG_DISABLE_JOESWAP_DAI = 1 << 11;


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
