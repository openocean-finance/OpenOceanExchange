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

library IMDexPairExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    address private constant SKIM_TARGET = 0xe523182610482b8C0DD65d5A08F1Bbd256B1EA0c;

    /**
     * @notice Use Uniswap's constant product formula to calculate expected swap return.
     * See https://github.com/runtimeverification/verified-smart-contracts/blob/uniswap/uniswap/x-y-k.pdf
     */
    function calculateSwapReturn(
        IMDexPair pair,
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount,
        uint256 fee
    ) internal view returns (uint256) {
        if (amount == 0) {
            return 0;
        }
        uint256 inReserve = inToken.universalBalanceOf(address(pair));
        uint256 outReserve = outToken.universalBalanceOf(address(pair));
        return doCalculate(inReserve, outReserve, amount, fee);
    }

    function calculateRealSwapReturn(
        IMDexPair pair,
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount,
        uint256 fee
    ) internal returns (uint256) {
        uint256 inReserve = inToken.universalBalanceOf(address(pair));
        uint256 outReserve = outToken.universalBalanceOf(address(pair));

        (uint112 reserve0, uint112 reserve1, ) = pair.getReserves();
        if (inToken > outToken) {
            (reserve0, reserve1) = (reserve1, reserve0);
        }
        if (inReserve < reserve0 || outReserve < reserve1) {
            pair.sync();
        } else if (inReserve > reserve0 || outReserve > reserve1) {
            pair.skim(SKIM_TARGET);
        }

        return doCalculate(Math.min(inReserve, reserve0), Math.min(outReserve, reserve1), amount, fee);
    }

    function doCalculate(
        uint256 inReserve,
        uint256 outReserve,
        uint256 amount,
        uint256 fee
    ) private pure returns (uint256) {
        uint256 inAmountWithFee = amount.mul(10000 - fee); // MDex now requires fixed 0.2% swap fee
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.mul(10000).add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}

library IMDexFactoryExtension {
    using UniversalERC20 for IERC20;
    using IMDexPairExtension for IMDexPair;
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
        IMDexPair pair = factory.getPair(realInToken, realOutToken);
        if (pair != IMDexPair(0)) {
            uint256 fee = factory.getPairFees(address(pair));
            for (uint256 i = 0; i < inAmounts.length; i++) {
                outAmounts[i] = pair.calculateSwapReturn(realInToken, realOutToken, inAmounts[i], fee);
            }
            return (outAmounts, 50_000);
        }
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
        uint256 fee = factory.getPairFees(address(pair));
        outAmount = pair.calculateRealSwapReturn(realInToken, realOutToken, inAmount, fee);

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
