// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";


interface IWOOFi {
    enum RState {ONE, ABOVE_ONE, BELOW_ONE}

    function querySellBase(address trader, uint256 payBaseAmount) external view returns (uint256 receiveQuoteAmount, uint256 mtFee, RState newRState, uint256 newBaseTarget);

    function querySellQuote(address trader, uint256 payQuoteAmount) external view returns (uint256 receiveBaseAmount, uint256 mtFee, RState newRState, uint256 newQuoteTarget);

    function sellBase(address to) external returns (uint256 receiveQuoteAmount);

    function sellQuote(address to) external returns (uint256 receiveBaseAmount);
}


library IWOOFiExtension {
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;
    address constant internal BNB_BUSD = 0x0fe261aeE0d1C4DFdDee4102E82Dd425999065F4;
    address constant internal BTC_BUSD = 0xe3C58d202D4047Ba227e437b79871d51982deEb7;
    address constant internal ETH_BUSD = 0x9BA8966B706c905E594AcbB946Ad5e29509f45EB;
    address constant internal DOT_BUSD = 0xA7E60e63560C36D81d5Cf80e175941A6a80e6A3d;
    address constant internal LINK_BUSD = 0x64B2E6Bba89e5C9788A4Fb238694055a16c2f1e3;
    address constant internal WOO_BUSD = 0x88CBf433471A0CD8240D2a12354362988b4593E5;

    function calculateSwapReturn(
        IWOOFi zoo,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        zoo;
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        (address dodo,bool isQuote) = findDODO(realInToken, realOutToken);
        if (dodo != address(0)) {
            for (uint256 i = 0; i < inAmounts.length; i++) {
                if (isQuote) {
                    (outAmounts[i],,,) = IWOOFi(dodo).querySellQuote(dodo, inAmounts[i]);
                } else {
                    (outAmounts[i],,,) = IWOOFi(dodo).querySellBase(dodo, inAmounts[i]);
                }
            }
            return (outAmounts, 100_000);
        }
    }

    function calculateTransitionalSwapReturn(
        IWOOFi zoo,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        zoo;
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
        IWOOFi zoo,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        zoo;
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        (address dodo, bool isQuote) = findDODO(realInToken, realOutToken);
        if (dodo == address(0)) {
            return inAmount;
        }

        if (isQuote) {
            (outAmount,,,) = IWOOFi(dodo).querySellQuote(dodo, inAmount);
        } else {
            (outAmount,,,) = IWOOFi(dodo).querySellBase(dodo, inAmount);
        }
        inToken.depositToWETH(inAmount);
        realInToken.universalTransfer(dodo, inAmount);
        if (isQuote) {
            uint res = IWOOFi(dodo).sellQuote(address(this));
            require(res >= outAmount);
        } else {
            uint res = IWOOFi(dodo).sellBase(address(this));
            require(res >= outAmount);
        }
        outToken.withdrawFromWETH();
    }

    function swapTransitional(
        IWOOFi zoo,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        zoo;
        if (inToken == transitionToken || outToken == transitionToken) {
            return;
        }
        swap(zoo, transitionToken, outToken, swap(zoo, inToken, transitionToken, inAmount));
    }

    function findDODO(
        IERC20 inToken,
        IERC20 outToken
    ) private pure returns (address dodo, bool isQuote) {
        // 其中一个必须是BUSD
        if (Tokens.BUSD != inToken && Tokens.BUSD != outToken) {
            return (address(0), false);
        }
        IERC20 another = Tokens.BUSD == inToken ? outToken : inToken;
        if (another == Tokens.WETH) {
            dodo = BNB_BUSD;
        } else if (another == Tokens.BTCB) {
            dodo = BTC_BUSD;
        } else if (another == Tokens.ETH) {
            dodo = ETH_BUSD;
        } else if (another == Tokens.DOT) {
            dodo = DOT_BUSD;
        } else if (another == Tokens.LINK) {
            dodo = LINK_BUSD;
        } else if (another == Tokens.WOO) {
            dodo = WOO_BUSD;
        }
        if (inToken == Tokens.BUSD) {
            isQuote = true;
        }
        return (dodo, isQuote);
    }
}
