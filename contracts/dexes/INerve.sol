// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";

/**
 * @notice  https://github.com/nerve-finance/contracts
 */
interface INerve {
    function calculateSwap(
        uint8 tokenIndexFrom,
        uint8 tokenIndexTo,
        uint256 dx
    ) external view returns (uint256);

    function swap(
        uint8 tokenIndexFrom,
        uint8 tokenIndexTo,
        uint256 dx,
        uint256 minDy,
        uint256 deadline
    ) external returns (uint256);
}

library INerveExtension {
    using UniversalERC20 for IERC20;

    INerve internal constant POOL3 = INerve(0x1B3771a66ee31180906972580adE9b81AFc5fCDc);
    INerve internal constant BTC = INerve(0x6C341938bB75dDe823FAAfe7f446925c66E6270c);
    INerve internal constant ETH = INerve(0x146CD24dCc9f4EB224DFd010c5Bf2b0D25aFA9C0);

    function calculateSwapReturn(
        INerve beltswap,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        IERC20[] memory tokens;
        bool underlying;
        (tokens, underlying, gas) = getPoolConfig(beltswap);

        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == -1 || j == -1) {
            return (outAmounts, 0);
        }
        if (underlying && i != 0 && j != 0) {
            return (outAmounts, 0);
        }

        for (uint256 k = 0; k < inAmounts.length; k++) {
            if (underlying) {
                outAmounts[k] = 0;
            } else {
                outAmounts[k] = beltswap.calculateSwap(uint8(i), uint8(j), inAmounts[k]);
            }
        }
    }

    function swap(
        INerve pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        (IERC20[] memory tokens, bool underlying, ) = getPoolConfig(pool);

        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == -1 || j == -1) {
            return;
        }
        if (underlying && i != 0 && j != 0) {
            return;
        }

        inToken.universalApprove(address(pool), inAmount);
        if (underlying) {
            // empty
        } else {
            pool.swap(uint8(i), uint8(j), inAmount, 0, block.timestamp + 3600);
        }
    }

    function determineTokenIndex(
        IERC20 inToken,
        IERC20 outToken,
        IERC20[] memory tokens
    ) private pure returns (int128, int128) {
        int128 i = -1;
        int128 j = -1;
        for (uint256 k = 0; k < tokens.length; k++) {
            IERC20 token = tokens[k];
            if (inToken == token) {
                i = int128(k);
            }
            if (outToken == token) {
                j = int128(k);
            }
        }
        return (i, j);
    }

    function getPoolConfig(INerve pool)
        private
        pure
        returns (
            IERC20[] memory tokens,
            bool underlying,
            uint256 gas
        )
    {
        if (pool == POOL3) {
            tokens = new IERC20[](3);
            tokens[0] = Tokens.BUSD;
            tokens[1] = Tokens.USDT;
            tokens[2] = Tokens.USDC;
            underlying = false;
            gas = 720_000;
        } else if (pool == BTC) {
            tokens = new IERC20[](2);
            tokens[0] = Tokens.BTCB;
            tokens[1] = IERC20(0x54261774905f3e6E9718f2ABb10ed6555cae308a); // anyBTC
            underlying = false;
            gas = 720_000;
        } else if (pool == ETH) {
            tokens = new IERC20[](2);
            tokens[0] = IERC20(0x2170Ed0880ac9A755fd29B2688956BD959F933F8); // ETH
            tokens[1] = IERC20(0x6F817a0cE8F7640Add3bC0c1C2298635043c2423); // anyETH
            underlying = false;
            gas = 720_000;
        }
    }
}
