// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "../lib/UniversalERC20.sol";

interface IUniswapExchange {
    function ethToTokenSwapInput(uint256 minTokens, uint256 deadline) external payable returns (uint256 tokensBought);

    function tokenToEthSwapInput(
        uint256 tokensSold,
        uint256 minEth,
        uint256 deadline
    ) external returns (uint256 ethBought);
}

library IUniswapExchangeExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    function calculateToEthSwapReturn(
        IUniswapExchange exchange,
        IERC20 token,
        uint256 amount
    ) internal view returns (uint256) {
        if (token.isETH()) {
            return amount;
        }
        uint256 inReserve = token.universalBalanceOf(address(exchange));
        uint256 outReserve = address(exchange).balance;
        return doCalculate(inReserve, outReserve, amount);
    }

    function calculateFromEthSwapReturn(
        IUniswapExchange exchange,
        IERC20 token,
        uint256 amount
    ) internal view returns (uint256) {
        if (token.isETH()) {
            return amount;
        }
        uint256 inReserve = address(exchange).balance;
        uint256 outReserve = token.universalBalanceOf(address(exchange));
        return doCalculate(inReserve, outReserve, amount);
    }

    function doCalculate(
        uint256 inReserve,
        uint256 outReserve,
        uint256 amount
    ) private pure returns (uint256) {
        uint256 inAmountWithFee = amount.mul(997); // Uniswap now requires fixed 0.3% swap fee
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.mul(1000).add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}

interface IUniswapFactory {
    function getExchange(IERC20 token) external view returns (IUniswapExchange exchange);
}

library IUniswapFactoryExtension {
    using IUniswapExchangeExtension for IUniswapExchange;
    using UniversalERC20 for IERC20;

    function calculateSwapReturn(
        IUniswapFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = inAmounts;

        if (!inToken.isETH()) {
            IUniswapExchange exchange = factory.getExchange(inToken);
            if (exchange == IUniswapExchange(0)) {
                return (new uint256[](inAmounts.length), 0);
            }
            for (uint256 i = 0; i < outAmounts.length; i++) {
                outAmounts[i] = exchange.calculateToEthSwapReturn(inToken, outAmounts[i]);
            }
        }
        if (!outToken.isETH()) {
            IUniswapExchange exchange = factory.getExchange(outToken);
            if (exchange == IUniswapExchange(0)) {
                return (new uint256[](inAmounts.length), 0);
            }
            for (uint256 i = 0; i < outAmounts.length; i++) {
                outAmounts[i] = exchange.calculateFromEthSwapReturn(outToken, outAmounts[i]);
            }
        }

        return (outAmounts, inToken.isETH() || outToken.isETH() ? 60_000 : 100_000);
    }

    function swap(
        IUniswapFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        uint256 outAmount = inAmount;

        if (!inToken.isETH()) {
            IUniswapExchange exchange = factory.getExchange(inToken);
            if (exchange != IUniswapExchange(0)) {
                inToken.universalApprove(address(exchange), outAmount);
                outAmount = exchange.tokenToEthSwapInput(outAmount, 1, now);
            } else {
                return;
            }
        }

        if (!outToken.isETH()) {
            IUniswapExchange exchange = factory.getExchange(outToken);
            if (exchange != IUniswapExchange(0)) {
                outAmount = exchange.ethToTokenSwapInput{value: outAmount}(1, now);
            }
        }
    }
}
