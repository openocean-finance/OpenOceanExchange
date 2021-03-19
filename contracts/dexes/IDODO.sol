// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";

interface IDODOZoo {
    function getDODO(IERC20 baseToken, IERC20 quoteToken) external view returns (address);
}

interface IDODO {
    function querySellBaseToken(uint256 amount) external view returns (uint256);

    function queryBuyBaseToken(uint256 amount) external view returns (uint256);

    function sellBaseToken(
        uint256 amount,
        uint256 minReceiveQuote,
        bytes calldata data
    ) external returns (uint256);

    function buyBaseToken(
        uint256 amount,
        uint256 maxPayQuote,
        bytes calldata data
    ) external returns (uint256);
}

interface IDODOSellHelper {
    function querySellQuoteToken(address dodo, uint256 amount) external view returns (uint256);

    function querySellBaseToken(address dodo, uint256 amount) external view returns (uint256);
}

library IDODOZooExtension {
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;

    IDODOSellHelper internal constant helper = IDODOSellHelper(0x0F859706AeE7FcF61D5A8939E8CB9dBB6c1EDA33);

    function calculateSwapReturn(
        IDODOZoo zoo,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        (address dodo, bool reversed) = findDODO(zoo, realInToken, realOutToken);
        if (dodo != address(0)) {
            for (uint256 i = 0; i < inAmounts.length; i++) {
                if (reversed) {
                    outAmounts[i] = helper.querySellQuoteToken(dodo, inAmounts[i]);
                } else {
                    outAmounts[i] = IDODO(dodo).querySellBaseToken(inAmounts[i]);
                }
            }
            return (outAmounts, 100_000);
        }
    }

    function calculateTransitionalSwapReturn(
        IDODOZoo zoo,
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
        IDODOZoo zoo,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        (address dodo, bool reversed) = findDODO(zoo, realInToken, realOutToken);
        if (dodo == address(0)) {
            return inAmount;
        }

        inToken.depositToWETH(inAmount);
        realInToken.universalApprove(dodo, inAmount);
        if (reversed) {
            outAmount = helper.querySellQuoteToken(dodo, inAmount);
            IDODO(dodo).buyBaseToken(outAmount, inAmount, "");
        } else {
            outAmount = IDODO(dodo).sellBaseToken(inAmount, 0, "");
        }
        outToken.withdrawFromWETH();
    }

    function swapTransitional(
        IDODOZoo zoo,
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

    function findDODO(
        IDODOZoo zoo,
        IERC20 inToken,
        IERC20 outToken
    ) private view returns (address dodo, bool reversed) {
        dodo = zoo.getDODO(inToken, outToken);
        if (dodo != address(0)) {
            return (dodo, false);
        }
        dodo = zoo.getDODO(outToken, inToken);
        return (dodo, true);
    }
}
