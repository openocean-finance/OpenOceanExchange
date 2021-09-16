// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
    // add SushiSwap
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_ALL = 1 << 0;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP = 1 << 1;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_WETH = 1 << 2;

    // add DODO
    uint256 internal constant FLAG_DISABLE_DODO_ALL = 1 << 3;
    uint256 internal constant FLAG_DISABLE_DODO = 1 << 4;
    uint256 internal constant FLAG_DISABLE_DODO_WETH = 1 << 5;

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
