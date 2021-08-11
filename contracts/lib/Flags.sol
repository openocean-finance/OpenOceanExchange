// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
    uint256 internal constant FLAG_DISABLE_KSWAP_ALL = 1 << 0;
    uint256 internal constant FLAG_DISABLE_KSWAP = 1 << 1;
    uint256 internal constant FLAG_DISABLE_KSWAP_USDT = 1 << 2;

    uint256 internal constant FLAG_DISABLE_CHERRYSWAP_ALL = 1 << 3;
    uint256 internal constant FLAG_DISABLE_CHERRYSWAP = 1 << 4;
    uint256 internal constant FLAG_DISABLE_CHERRYSWAP_USDT = 1 << 5;

    uint256 internal constant FLAG_DISABLE_STAKESWAP_ALL = 1 << 6;
    uint256 internal constant FLAG_DISABLE_STAKESWAP = 1 << 7;
    uint256 internal constant FLAG_DISABLE_STAKESWAP_USDT = 1 << 8;


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
