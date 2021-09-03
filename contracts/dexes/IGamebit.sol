// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";


/**
 * @notice https://github.com/xvi10/gambit-contracts/blob/master/contracts/core/Vault.sol
 */
interface IVaultSwap {
    function swap(address _tokenIn, address _tokenOut, address _receiver) external returns (uint256);
    function sellUSDG(address _token, address _receiver) external returns (uint256);
    function buyUSDG(address _token, address _receiver) external returns (uint256);
}

library IVaultSwapExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;

    uint256 public constant BASIS_POINTS_DIVISOR = 10000;
    uint256 public stableSwapFeeBasisPoints = 4; // 0.04%
    address private constant SKIM_TARGET = 0xe523182610482b8C0DD65d5A08F1Bbd256B1EA0c;

    /**
     * @notice Use Uniswap's constant product formula to calculate expected swap return.
     * See https://github.com/runtimeverification/verified-smart-contracts/blob/uniswap/uniswap/x-y-k.pdf
     */
    function calculateSwapReturn(
        IVaultSwap pair,
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount
    ) internal view returns (uint256) {
        if (amount == 0) {
            return 0;
        }
        uint256 inReserve = inToken.universalBalanceOf(address(pair));
        uint256 outReserve = outToken.universalBalanceOf(address(pair));
        return doCalculate(inReserve, outReserve, amount);
    }

    function doCalculate(
        uint256 inReserve,
        uint256 outReserve,
        uint256 amount
    ) private pure returns (uint256) {
        uint256 inAmountWithFee = amount.mul(9975);
        // Pancake now requires fixed 0.2% swap fee
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.mul(10000).add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }

    function _collectSwapFees(address _token, uint256 _amount, bool _isStableSwap) private returns (uint256) {
        uint256 feeBasisPoints = _isStableSwap ? stableSwapFeeBasisPoints : swapFeeBasisPoints;
        uint256 afterFeeAmount = _amount.mul(BASIS_POINTS_DIVISOR.sub(feeBasisPoints)).div(BASIS_POINTS_DIVISOR);
        uint256 feeAmount = _amount.sub(afterFeeAmount);
        feeReserves[_token] = feeReserves[_token].add(feeAmount);
        return afterFeeAmount;
    }

    function swap(
        IVaultSwap factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        IPancakePairV2 pair = factory.getPair(realInToken, realOutToken);

        outAmount = pair.calculateRealSwapReturn(realInToken, realOutToken, inAmount);

        realInToken.universalTransfer(address(pair), inAmount);
        if (uint256(address(realInToken)) < uint256(address(realOutToken))) {
            pair.swap(0, outAmount, address(this), "");
        } else {
            pair.swap(outAmount, 0, address(this), "");
        }

        outToken.withdrawFromWETH();
    }

    function swapTransitional(
        IVaultSwap factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
    }
}
