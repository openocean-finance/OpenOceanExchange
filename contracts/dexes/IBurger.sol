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
interface IDemaxFactory {
    function getPair(IERC20 tokenA, IERC20 tokenB) external view returns (IDemaxPair pair);
}

/**
 * @notice Uniswap V2 pair pool interface. See https://uniswap.org/docs/v2/smart-contracts/pair/
 */
interface IDemaxPair {
    // function CONFIG() external view returns (IDemaxConfig);

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

    // function skim(address to) external;

    function sync() external;
}

interface IDemaxConfig {
    function PERCENT_DENOMINATOR() external view returns (uint256);

    function getConfigValue(bytes32 _name) external view returns (uint256);
}

interface IDemaxPlatform {
    function CONFIG() external view returns (IDemaxConfig);

    function FACTORY() external view returns (IDemaxFactory);

    function swapPrecondition(IERC20 token) external view returns (bool);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function getAmountsOut(uint256 amountIn, address[] memory path) external view returns (uint256[] memory amounts);
}

library IDemaxPairExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    /**
     * @notice Use Uniswap's constant product formula to calculate expected swap return.
     * See https://github.com/runtimeverification/verified-smart-contracts/blob/uniswap/uniswap/x-y-k.pdf
     */
    function calculateSwapReturn(
        IDemaxPair pair,
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount,
        uint256 feePercent,
        uint256 percentDenominator
    ) internal view returns (uint256) {
        if (amount == 0) {
            return 0;
        }

        uint256 inReserve = 0;
        uint256 outReserve = 0;
        if (address(inToken) < address(outToken)) {
            (inReserve, outReserve, ) = pair.getReserves();
        } else {
            (outReserve, inReserve, ) = pair.getReserves();
        }

        uint256 inAmountWithFee = amount.mul(percentDenominator.sub(feePercent)).div(percentDenominator);
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}

library IDemaxPlatformExtension {
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;
    using IDemaxPairExtension for IDemaxPair;

    bytes32 private constant SWAP_FEE_PERCENT = bytes32("SWAP_FEE_PERCENT");

    function calculateSwapReturn(
        IDemaxPlatform platform,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();

        if (platform.swapPrecondition(realInToken) && platform.swapPrecondition(realOutToken)) {
            IDemaxFactory factory = platform.FACTORY();
            IDemaxPair pair = factory.getPair(realInToken, realOutToken);
            if (pair != IDemaxPair(0)) {
                IDemaxConfig config = platform.CONFIG();
                uint256 feePercent = config.getConfigValue(SWAP_FEE_PERCENT);
                uint256 percentDenominator = config.PERCENT_DENOMINATOR();
                for (uint256 i = 0; i < inAmounts.length; i++) {
                    outAmounts[i] = pair.calculateSwapReturn(
                        realInToken,
                        realOutToken,
                        inAmounts[i],
                        feePercent,
                        percentDenominator
                    );
                }
                return (outAmounts, 50_000);
            }
        }
    }

    function calculateTransitionalSwapReturn(
        IDemaxPlatform platform,
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
        (outAmounts, firstGas) = calculateSwapReturn(platform, realInToken, realTransitionToken, inAmounts);
        (outAmounts, secondGas) = calculateSwapReturn(platform, realTransitionToken, realOutToken, outAmounts);
        return (outAmounts, firstGas + secondGas);
    }

    function swap(
        IDemaxPlatform platform,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapETH();
        address[] memory path = new address[](2);
        path[0] = address(realInToken);
        path[1] = address(outToken.wrapETH());

        realInToken.universalApprove(address(platform), inAmount);
        platform.swapExactTokensForTokens(inAmount, 0, path, address(this), uint256(-1));

        outToken.withdrawFromWETH();
    }

    function swapTransitional(
        IDemaxPlatform platform,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapETH();
        address[] memory path = new address[](3);
        path[0] = address(realInToken);
        path[1] = address(transitionToken.wrapETH());
        path[2] = address(outToken.wrapETH());

        realInToken.universalApprove(address(platform), inAmount);
        platform.swapExactTokensForTokens(inAmount, 0, path, address(this), uint256(-1));

        outToken.withdrawFromWETH();
    }
}
