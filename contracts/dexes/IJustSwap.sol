// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "../lib/UniversalERC20.sol";

interface IJustSwapExchange {
    function ethToTokenSwapInput(uint256 minTokens, uint256 deadline) external payable returns (uint256 tokensBought);

    function tokenToEthSwapInput(
        uint256 tokensSold,
        uint256 minEth,
        uint256 deadline
    ) external returns (uint256 ethBought);
}

library IJustSwapExchangeExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    // function calculateToEthSwapReturn(
    //     IJustSwapExchange exchange,
    //     IERC20 token,
    //     uint256 amount
    // ) internal view returns (uint256) {
    //     if (token.isETH()) {
    //         return amount;
    //     }
    //     uint256 inReserve = token.universalBalanceOf(address(exchange));
    //     uint256 outReserve = address(exchange).balance;
    //     return doCalculate(exchange, inReserve, outReserve, amount);
    // }

    // function calculateFromEthSwapReturn(
    //     IJustSwapExchange exchange,
    //     IERC20 token,
    //     uint256 amount
    // ) internal view returns (uint256) {
    //     if (token.isETH()) {
    //         return amount;
    //     }
    //     uint256 inReserve = address(exchange).balance;
    //     uint256 outReserve = token.universalBalanceOf(address(exchange));
    //     return doCalculate(exchange, inReserve, outReserve, amount);
    // }

    function calculate(
        IJustSwapExchange, /* exchange */
        uint256 inReserve,
        uint256 outReserve,
        uint256 amount
    ) internal pure returns (uint256) {
        uint256 inAmountWithFee = amount.mul(997); // JustSwap now requires fixed 0.3% swap fee
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.mul(1000).add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}

interface IJustSwapFactory {
    function getExchange(IERC20 token) external view returns (IJustSwapExchange exchange);
}

library IJustSwapFactoryExtension {
    using IJustSwapExchangeExtension for IJustSwapExchange;
    using UniversalERC20 for IERC20;

    function calculateSwapReturn(
        IJustSwapFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        for (uint256 i = 0; i < inAmounts.length; i++) {
            outAmounts[i] = inAmounts[i];
        }

        if (!inToken.isETH()) {
            IJustSwapExchange exchange = factory.getExchange(inToken);
            if (exchange == IJustSwapExchange(0)) {
                return (new uint256[](inAmounts.length), 0);
            }

            uint256 inReserve = inToken.universalBalanceOf(address(exchange));
            uint256 outReserve = address(exchange).balance;
            for (uint256 i = 0; i < outAmounts.length; i++) {
                outAmounts[i] = exchange.calculate(inReserve, outReserve, outAmounts[i]);
            }
        }
        if (!outToken.isETH()) {
            IJustSwapExchange exchange = factory.getExchange(outToken);
            if (exchange == IJustSwapExchange(0)) {
                return (new uint256[](inAmounts.length), 0);
            }

            uint256 inReserve = address(exchange).balance;
            uint256 outReserve = outToken.universalBalanceOf(address(exchange));
            for (uint256 i = 0; i < outAmounts.length; i++) {
                outAmounts[i] = exchange.calculate(inReserve, outReserve, outAmounts[i]);
            }
        }

        return (outAmounts, inToken.isETH() || outToken.isETH() ? 60_000 : 100_000);
    }

    function swap(
        IJustSwapFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        uint256 outAmount = inAmount;

        if (!inToken.isETH()) {
            IJustSwapExchange exchange = factory.getExchange(inToken);
            if (exchange != IJustSwapExchange(0)) {
                inToken.universalApprove(address(exchange), outAmount);
                outAmount = exchange.tokenToEthSwapInput(outAmount, 1, now);
            } else {
                return;
            }
        }

        if (!outToken.isETH()) {
            IJustSwapExchange exchange = factory.getExchange(outToken);
            if (exchange != IJustSwapExchange(0)) {
                outAmount = exchange.ethToTokenSwapInput.value(outAmount)(1, now);
            }
        }
    }
}
