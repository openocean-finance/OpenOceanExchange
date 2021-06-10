// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";


interface IMooniswap {
    function fee() external view returns (uint256);

    function getReturn(IERC20 src, IERC20 dst, uint256 amount) external view returns (uint256);

    function swap(IERC20 src, IERC20 dst, uint256 amount, uint256 minReturn, address referral) external payable returns (uint256 result);
}

interface IMooniswapFactory {
    function pools(IERC20 tokenA, IERC20 tokenB) external view returns (IMooniswap pool);
}


library IMooniswapFactoryExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;


    function calculateSwapReturn(
        IMooniswapFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        IMooniswap pair = factory.pools(realInToken, realOutToken);
        if (pair != IMooniswap(0)) {
            for (uint256 i = 0; i < inAmounts.length; i++) {
                outAmounts[i] = pair.getReturn(realInToken, realOutToken, inAmounts[i]);
            }
            return (outAmounts, 50_000);
        }
    }

    function calculateRealSwapReturn(IMooniswapFactory factory, IERC20 inToken,
        IERC20 outToken, uint256 inAmount) internal view returns (uint256 outAmount) {
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        IMooniswap pair = factory.pools(realInToken, realOutToken);
        if (pair != IMooniswap(0)) {
            outAmount = pair.getReturn(realInToken, realOutToken, inAmount);
            return outAmount;
        }
    }

    function calculateTransitionalSwapReturn(
        IMooniswapFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realTransitionToken = transitionToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();

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
        IMooniswapFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        IMooniswap pair = factory.pools(realInToken, realOutToken);

        outAmount = calculateRealSwapReturn(factory, realInToken, realOutToken, inAmount);

        realInToken.approve(address(pair), inAmount);
        pair.swap(realInToken, realOutToken, inAmount, outAmount, address(0));
        outToken.withdrawFromWETH();
    }

    function swapTransitional(
        IMooniswapFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
    }
}
