// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";

//https://arbiscan.io/address/0xDdB13e6dd168E1a68DC2285Cb212078ae10394A9#code
// private pool factory
interface IDPPFactory {
    function getDODOPool(IERC20 baseToken, IERC20 quoteToken) external view returns (address[] memory pools);
}

//https://github.com/DODOEX/contractV2/blob/main/contracts/DODOPrivatePool/impl/DPPTrader.sol
interface IDODO {
    enum RState {ONE, ABOVE_ONE, BELOW_ONE}

    function querySellBase(address trader, uint256 payBaseAmount) external view returns (uint256 receiveQuoteAmount, uint256 mtFee, RState newRState, uint256 newBaseTarget);

    function querySellQuote(address trader, uint256 payQuoteAmount) external view returns (uint256 receiveBaseAmount, uint256 mtFee, RState newRState, uint256 newQuoteTarget);

    function sellBase(address to) external returns (uint256 receiveQuoteAmount);

    function sellQuote(address to) external returns (uint256 receiveBaseAmount);

}


library IDPPFactoryExtension {
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;

    function calculateSwapReturn(
        IDPPFactory zoo,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        (address[] memory dodos, bool isQuote) = findDODO(zoo, realInToken, realOutToken);
        if (dodos.length != 0) {
            for (uint256 i = 0; i < inAmounts.length; i++) {
                (outAmounts[i],) = findOptimalAmt(dodos, inAmounts[i], isQuote);
            }
            return (outAmounts, 100_000);
        }
    }

    function findOptimalAmt(address[] memory dodos, uint inAmount, bool isQuote) internal view returns (uint, address){
        uint outAmt = 0;
        address optimalPool;
        for (uint i = 0; i < dodos.length; i++) {
            uint amt = 0;
            if (isQuote) {
                (amt,,,) = IDODO(dodos[i]).querySellQuote(dodos[i], inAmount);
            } else {
                (amt,,,) = IDODO(dodos[i]).querySellBase(dodos[i], inAmount);
            }
            if (outAmt < amt) {
                outAmt = amt;
                optimalPool = dodos[i];
            }
        }
        return (outAmt, optimalPool);
    }

    function calculateTransitionalSwapReturn(
        IDPPFactory zoo,
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
        (outAmounts, firstGas) = calculateSwapReturn(zoo, inToken, transitionToken, inAmounts);
        (outAmounts, secondGas) = calculateSwapReturn(zoo, transitionToken, outToken, outAmounts);
        return (outAmounts, firstGas + secondGas);
    }

    function swap(
        IDPPFactory zoo,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        (address[] memory dodos, bool isQuote) = findDODO(zoo, realInToken, realOutToken);
        if (dodos.length == 0) {
            return inAmount;
        }
        (uint expectAmt, address pool) = findOptimalAmt(dodos, inAmount, isQuote);
        inToken.depositToWETH(inAmount);
        realInToken.universalTransfer(pool, inAmount);
        if (isQuote) {
            outAmount = IDODO(pool).sellQuote(address(this));
        } else {
            outAmount = IDODO(pool).sellBase(address(this));
        }
        require(outAmount >= expectAmt);
        outToken.withdrawFromWETH();
    }

    function swapTransitional(
        IDPPFactory zoo,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        if (inToken == transitionToken || outToken == transitionToken) {
            return;
        }
        swap(zoo, transitionToken, outToken, swap(zoo, inToken, transitionToken, inAmount));
    }

    // isQuote means inToken  is or not the quote token
    function findDODO(
        IDPPFactory zoo,
        IERC20 inToken,
        IERC20 outToken
    ) private view returns (address[] memory dodo, bool isQuote) {
        dodo = zoo.getDODOPool(inToken, outToken);
        if (dodo.length != 0) {
            return (dodo, false);
        }
        dodo = zoo.getDODOPool(outToken, inToken);
        return (dodo, true);
    }
}
