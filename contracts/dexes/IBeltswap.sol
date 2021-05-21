// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";

interface IBeltSwap {
    function coins(int128 i) external view returns (address);

    function underlying_coins(int128 arg0) external view returns (address);

    function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy) external;

    function get_dy(int128 i, int128 j, uint256 dx) external view returns (uint256);

    function get_dy_underlying(int128 i, int128 j, uint256 dx) external view returns (uint256);
}

//  token.index = [ 0 , 1 ,2 ,3 ] = [DAI,USDC,USDT,BUSD]
// DAI = "0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3"
// USDC = "0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d"
// BUSDT = "0x55d398326f99059fF775485246999027B3197955"
// BUSD = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56"


library IBeltSwapExtension {
    int128 constant tokensLength = 4;
    using UniversalERC20 for IERC20;

    IBeltSwap internal constant IBELTSWAP = IBeltSwap(0xAEA4f7dcd172997947809CE6F12018a6D5c1E8b6);

    function findIndex(IERC20 token) internal pure returns (int128){
        if (Tokens.DAI == token) {
            return 0;
        } else if (Tokens.USDC == token) {
            return 1;
        } else if (Tokens.USDT == token) {
            return 2;
        } else if (Tokens.BUSD == token) {
            return 3;
        } else {
            return tokensLength;
        }
    }

    function calculateSwapReturn(
        IBeltSwap beltswap,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        int128 i = findIndex(inToken);
        int128 j = findIndex(outToken);
        if (i < tokensLength && j < tokensLength) {
            for (uint256 k = 0; k < inAmounts.length; k++) {
                if (inAmounts[k] > 0) {
                    outAmounts[k] = beltswap.get_dy_underlying(i, j, inAmounts[k]);
                }
            }
            //todo gas
            return (outAmounts, 50_000);
        }
    }

    function calculateRealSwapReturn(
        IBeltSwap beltswap,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal view returns (uint256 outAmount) {
        int128 i = findIndex(inToken);
        int128 j = findIndex(outToken);
        if (i < tokensLength && j < tokensLength && inAmount > 0) {
            outAmount = beltswap.get_dy_underlying(i, j, inAmount);
            return outAmount;
        }
    }

    function calculateTransitionalSwapReturn(
        IBeltSwap beltswap,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        if (inToken == transitionToken || outToken == transitionToken) {
            return (new uint256[](inAmounts.length), 0);
        }
        uint256 firstGas;
        uint256 secondGas;
        (outAmounts, firstGas) = calculateSwapReturn(beltswap, inToken, transitionToken, inAmounts);
        (outAmounts, secondGas) = calculateSwapReturn(beltswap, transitionToken, outToken, outAmounts);
        return (outAmounts, firstGas + secondGas);
    }

    function swap(
        IBeltSwap beltswap,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        outAmount = calculateRealSwapReturn(beltswap, inToken, outToken, inAmount);
        int128 i = findIndex(inToken);
        if (i >= tokensLength) {
            return 0;
        }
        int128 j = findIndex(outToken);
        if (j >= tokensLength) {
            return 0;
        }
        inToken.universalApprove(address(beltswap), inAmount);
        // todo 1% 修正
        outAmount = outAmount * 99 / 100;
        beltswap.exchange_underlying(i, j, inAmount, outAmount);
        return outAmount;
    }

    function swapTransitional(
        IBeltSwap beltswap,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(beltswap, transitionToken, outToken, swap(beltswap, inToken, transitionToken, inAmount));
    }
}
