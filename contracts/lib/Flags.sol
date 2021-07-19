// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
    // add uniswap
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2_ALL = 1 << 0;
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2 = 1 << 1;
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2_ETH = 1 << 2;
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2_DAI = 1 << 3;
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2_USDC = 1 << 4;

    // add SushiSwap
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_ALL = 1 << 5;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP = 1 << 6;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_ETH = 1 << 7;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_DAI = 1 << 8;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_USDC = 1 << 9;

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
