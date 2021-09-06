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

    function stableTokens(address token) external view returns (bool);

    function getMinPrice(address _token) external view returns (uint256);

    function getMaxPrice(address _token) external view returns (uint256);

    function adjustForDecimals(uint256 _amount, address _tokenDiv, address _tokenMul) external view returns (uint256);
}

library IVaultSwapExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;

    uint256 public constant BASIS_POINTS_DIVISOR = 10000;
    uint256 public constant stableSwapFeeBasisPoints = 1; // 0.04%
    uint256 public constant swapFeeBasisPoints = 15; // 0.3%
    uint256 public constant marginFeeBasisPoints = 10; // 0.1%
    address private constant SKIM_TARGET = 0xe523182610482b8C0DD65d5A08F1Bbd256B1EA0c;

    address constant USDG = 0x85E76cbf4893c1fbcB34dCF1239A91CE2A4CF5a7;


    function calculateSwapReturn(
        IVaultSwap vault,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        for (uint256 i = 0; i < inAmounts.length; i++) {
            outAmounts[i] = calculateRealSwapReturn(vault, inToken, outToken, inAmounts[i]);
        }
        //TODO gas
        return (outAmounts, 0);
    }

    function calculateRealSwapReturn(
        IVaultSwap vault,
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount
    ) internal view returns (uint256) {
        if (amount == 0) {
            return 0;
        }
        uint256 priceIn = vault.getMinPrice(address(inToken));
        uint256 priceOut = vault.getMaxPrice(address(outToken));
        uint256 amountOut = amount.mul(priceIn).div(priceOut);
        amountOut = vault.adjustForDecimals(amountOut, address(inToken), address(outToken));
        bool boo1 = vault.stableTokens(address(inToken));
        bool boo2 = vault.stableTokens(address(outToken));
        return _collectSwapFees(amountOut, boo1 && boo2);
    }

    function _collectSwapFees(uint256 _amount, bool _isStableSwap) internal pure returns (uint256) {
        uint256 feeBasisPoints = _isStableSwap ? stableSwapFeeBasisPoints : swapFeeBasisPoints;
        uint256 afterFeeAmount = _amount.mul(BASIS_POINTS_DIVISOR.sub(feeBasisPoints)).div(BASIS_POINTS_DIVISOR);
        return afterFeeAmount;
    }

    function swap(
        IVaultSwap vault,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();

        outAmount = calculateRealSwapReturn(vault, realInToken, realOutToken, inAmount);

        realInToken.universalTransfer(address(vault), inAmount);
        IERC20[] memory _path = new IERC20[](2);
        _path[0] = inToken;
        _path[1] = outToken;
        _swap(vault, _path, outAmount, address(this));
        outToken.withdrawFromWETH();
    }

    function swapTransitional(
        IVaultSwap vault,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        //        swap(vault, transitionToken, outToken, swap(vault, inToken, transitionToken, inAmount));

        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapETH();

        uint outAmount = calculateRealSwapReturn(vault, realInToken, transitionToken, inAmount);
        outAmount = calculateRealSwapReturn(vault, transitionToken, outToken, outAmount);

        realInToken.universalTransfer(address(vault), inAmount);
        IERC20[] memory _path = new IERC20[](3);
        _path[0] = inToken;
        _path[1] = transitionToken;
        _path[2] = outToken;
        _swap(vault, _path, outAmount, address(this));
        outToken.withdrawFromWETH();
    }

    function _swap(IVaultSwap vault, IERC20[] memory _path, uint256 _minOut, address _receiver) private returns (uint256) {
        if (_path.length == 2) {
            return _vaultSwap(vault, _path[0], _path[1], _minOut, _receiver);
        }
        if (_path.length == 3) {
            uint256 midOut = _vaultSwap(vault, _path[0], _path[1], 0, address(this));
            _path[1].universalTransfer(address(vault), midOut);
            return _vaultSwap(vault, _path[1], _path[2], _minOut, _receiver);
        }

        revert("Router: invalid _path.length");
    }

    function _vaultSwap(IVaultSwap vault, IERC20 _tokenIn, IERC20 _tokenOut, uint256 _minOut, address _receiver) private returns (uint256) {
        uint256 amountOut;

        if (address(_tokenOut) == USDG) {// buyUSDG
            amountOut = vault.buyUSDG(address(_tokenIn), _receiver);
        } else if (address(_tokenIn) == USDG) {// sellUSDG
            amountOut = vault.sellUSDG(address(_tokenOut), _receiver);
        } else {// swap
            amountOut = vault.swap(address(_tokenIn), address(_tokenOut), _receiver);
        }

        require(amountOut >= _minOut, "Router: insufficient amountOut");
        return amountOut;
    }
}
