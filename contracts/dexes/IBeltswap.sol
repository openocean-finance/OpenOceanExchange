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

    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;

    function get_dy_underlying(int128 i, int128 j, uint256 dx) external view returns (uint256);
}

//  token.index = [ 0 , 1 ,2 ,3 ] = [DAI,USDC,USDT,BUSD]
// DAI = "0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3"
// USDC = "0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d"
// BUSDT = "0x55d398326f99059fF775485246999027B3197955"
// BUSD = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56"


library IBeltSwapExtension {
    address constant DAI = 0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3;
    address constant USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;
    address constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    int128 constant tokensLength = 4;

    function findIndex(address tokenAddress) internal pure returns (int128){
        if (DAI == tokenAddress) {
            return 0;
        } else if (USDC == tokenAddress) {
            return 1;
        } else if (USDT == tokenAddress) {
            return 2;
        } else if (BUSD == tokenAddress) {
            return 3;
        } else {
            return tokensLength;
        }
    }

    function calculateSwapReturn(
        IBeltSwap beltSwap,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        int128 i = findIndex(address(inToken));
        if (i >= tokensLength) {
            return (new uint256[](0), 0);
        }
        int128 j = findIndex(address(outToken));
        if (j >= tokensLength) {
            return (new uint256[](0), 0);
        }
        outAmounts = new uint256[](inAmounts.length);
        for (uint256 k = 0; k < inAmounts.length; k++) {
            outAmounts[k] = beltSwap.get_dy_underlying(i, j, inAmounts[k]);
        }
        //todo gas
        return (outAmounts, 50_000);
    }

    function calculateTransitionalSwapReturn(
        IBeltSwap beltSwap,
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
        (outAmounts, firstGas) = calculateSwapReturn(beltSwap, inToken, transitionToken, inAmounts);
        (outAmounts, secondGas) = calculateSwapReturn(beltSwap, transitionToken, outToken, outAmounts);
        return (outAmounts, firstGas + secondGas);
    }

    function swap(
        IBeltSwap beltSwap,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        uint256[] memory inAmounts = new uint256[](1);
        inAmounts[0] = inAmount;
        (uint256[] memory outAmounts,) = calculateSwapReturn(beltSwap, inToken, outToken, inAmounts);
        require(outAmounts.length == 1);
        int128 i = findIndex(address(inToken));
        if (i >= tokensLength) {
            return 0;
        }
        int128 j = findIndex(address(outToken));
        if (j >= tokensLength) {
            return 0;
        }
        beltSwap.exchange(i, j, inAmount, outAmounts[0]);
    }

    function swapTransitional(
        IBeltSwap beltSwap,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(beltSwap, transitionToken, outToken, swap(beltSwap, inToken, transitionToken, inAmount));
    }
}
