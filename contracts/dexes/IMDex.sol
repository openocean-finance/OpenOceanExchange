// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";

/**
 * @notice Uniswap V2 factory contract interface. See https://uniswap.org/docs/v2/smart-contracts/factory/
 */
interface IMDexFactory {
    function getPair(IERC20 tokenA, IERC20 tokenB) external view returns (IMDexPair pair);

    function getPairFees(address pair) external view returns (uint256);

    function getReserves(address tokenA, address tokenB) external view returns (uint reserveA, uint reserveB);

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external view returns (uint amountOut);
}

/**
 * @notice Uniswap V2 pair pool interface. See https://uniswap.org/docs/v2/smart-contracts/pair/
 */
interface IMDexPair {
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function getReserves()
    external
    view
    returns (
        uint112 reserve0,
        uint112 reserve1,
        uint32 blockTimestampLast
    );

    function skim(address to) external;

    function sync() external;
}

library IMDexFactoryExtension {
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;

    function calculateSwapReturn(
        IMDexFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapHT();
        IERC20 realOutToken = outToken.wrapHT();
        (uint reserveA, uint reserveB) = factory.getReserves(address(realInToken), address(realOutToken));
        for (uint256 i = 0; i < inAmounts.length; i++) {
            outAmounts[i] = factory.getAmountOut(inAmounts[i], reserveA, reserveB);
        }
        return (outAmounts, 50_000);
    }

    function calculateTransitionalSwapReturn(
        IMDexFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapHT();
        IERC20 realTransitionToken = transitionToken.wrapHT();
        IERC20 realOutToken = outToken.wrapHT();

        if (realInToken == realTransitionToken || realOutToken == realTransitionToken) {
            return (new uint256[](inAmounts.length), 0);
        }
        uint256 firstGas;
        uint256 secondGas;
        (outAmounts, firstGas) = calculateSwapReturn(factory, realInToken, realTransitionToken, inAmounts);
        (outAmounts, secondGas) = calculateSwapReturn(factory, realTransitionToken, realOutToken, outAmounts);
        return (outAmounts, firstGas + secondGas);
    }

    function swap(
        IMDexFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWHT(inAmount);

        IERC20 realInToken = inToken.wrapHT();
        IERC20 realOutToken = outToken.wrapHT();

        IMDexPair pair = factory.getPair(realInToken, realOutToken);
        if (address(pair) == address(0)) {
            return 0;
        }
        (uint reserveA, uint reserveB) = factory.getReserves(address(realInToken), address(realOutToken));
        outAmount = factory.getAmountOut(inAmount, reserveA, reserveB);

        realInToken.universalTransfer(address(pair), inAmount);
        if (uint256(address(realInToken)) < uint256(address(realOutToken))) {
            pair.swap(0, outAmount, address(this), "");
        } else {
            pair.swap(outAmount, 0, address(this), "");
        }

        outToken.withdrawFromWHT();
    }

    function swapTransitional(
        IMDexFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
    }
}
