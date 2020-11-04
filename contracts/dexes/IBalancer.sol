// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";

interface IBalancerRegistry {
    function getBestPoolsWithLimit(
        address fromToken,
        address destToken,
        uint256 limit
    ) external view returns (address[] memory pools);
}

interface IBalancerPool {
    function swapExactAmountIn(
        IERC20 tokenIn,
        uint256 tokenAmountIn,
        IERC20 tokenOut,
        uint256 minAmountOut,
        uint256 maxPrice
    ) external returns (uint256 tokenAmountOut, uint256 spotPriceAfter);
}

interface IBalancerHelper {
    function getReturns(
        IBalancerPool pool,
        IERC20 fromToken,
        IERC20 destToken,
        uint256[] calldata amounts
    ) external view returns (uint256[] memory rets);
}

library IBalancerRegistryExtension {
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;

    IBalancerHelper internal constant balancerHelper = IBalancerHelper(0xA961672E8Db773be387e775bc4937C678F3ddF9a);

    function calculateSwapReturn(
        IBalancerRegistry registry,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts,
        uint256 poolIndex
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        address[] memory pools = registry.getBestPoolsWithLimit(address(realInToken), address(realOutToken), poolIndex + 1);
        if (poolIndex >= pools.length) {
            return (new uint256[](inAmounts.length), 0);
        }

        outAmounts = balancerHelper.getReturns(IBalancerPool(pools[poolIndex]), realInToken, realOutToken, inAmounts);
        gas = 75_000 + (inToken.isETH() || outToken.isETH() ? 0 : 65_000);
    }

    function swap(
        IBalancerRegistry registry,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 poolIndex
    ) internal {
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        address[] memory pools = registry.getBestPoolsWithLimit(address(realInToken), address(realOutToken), poolIndex + 1);
        if (poolIndex >= pools.length) {
            return;
        }

        inToken.depositToWETH(inAmount);

        address pool = pools[poolIndex];
        realInToken.universalApprove(pool, inAmount);
        IBalancerPool(pool).swapExactAmountIn(realInToken, inAmount, realOutToken, 0, uint256(-1));

        outToken.withdrawFromWETH();
    }
}
