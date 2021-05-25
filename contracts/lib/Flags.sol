// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
     // add SushiSwap
    uint256 internal constant FLAG_DISABLE_SEESWAP_ALL = 1 << 0;
    uint256 internal constant FLAG_DISABLE_SEESWAP = 1 << 1;
    uint256 internal constant FLAG_DISABLE_SEESWAP_WONE = 1 << 2;

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
