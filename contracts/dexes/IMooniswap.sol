// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";

interface IMooniswapRegistry {
    function pools(IERC20 token1, IERC20 token2) external view returns (IMooniswap);

    function isPool(address addr) external view returns (bool);
}

interface IMooniswap {
    function fee() external view returns (uint256);

    function slippageFee() external view returns (uint256);

    function tokens(uint256 i) external view returns (IERC20);

    function deposit(uint256[] calldata amounts, uint256[] calldata minAmounts) external payable returns (uint256 fairSupply);

    function withdraw(uint256 amount, uint256[] calldata minReturns) external;

    function getBalanceForAddition(IERC20 token) external view returns (uint256);

    function getBalanceForRemoval(IERC20 token) external view returns (uint256);

    function getReturn(
        IERC20 fromToken,
        IERC20 destToken,
        uint256 amount
    ) external view returns (uint256 returnAmount);

    function swap(
        IERC20 fromToken,
        IERC20 destToken,
        uint256 amount,
        uint256 minReturn,
        address referral
    ) external payable returns (uint256 returnAmount);
}

library IMooniswapExtenstion {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    uint constant _FEE_DENOMINATOR = 1e18;

    function calculateOutAmounts(
        IMooniswap mooniswap,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        for (uint256 i = 0; i < inAmounts.length; i++) {
            outAmounts[i] = mooniswap.getReturn(inToken, outToken, inAmounts[i]);
        }
        // TODO fee
        return (outAmounts, (inToken.isETH() || outToken.isETH()) ? 80_000 : 110_000);
    }
}

library IMooniswapRegistryExtension {
    using IMooniswapExtenstion for IMooniswap;
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;


    function calculateSwapReturn(
        IMooniswapRegistry registry,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IMooniswap mooniswap = registry.pools(
            inToken.isETH() ? UniversalERC20.ZERO_ADDRESS : inToken,
            outToken.isETH() ? UniversalERC20.ZERO_ADDRESS : outToken
        );
        if (mooniswap == IMooniswap(0)) {
            return (new uint256[](inAmounts.length), 0);
        }

        return mooniswap.calculateOutAmounts(inToken, outToken, inAmounts);
    }

    function calculateTransitionalSwapReturn(
        IMooniswapRegistry registry,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        if (transitionToken.isETH()) {
            if (inToken.isETH() || outToken.isETH()) {
                return (new uint256[](inAmounts.length), 0);
            }
        } else if (inToken == transitionToken || outToken == transitionToken) {
            return (new uint256[](inAmounts.length), 0);
        }

        (uint256[] memory outAmounts1, uint256 gas1) = calculateSwapReturn(
            registry,
            inToken,
            transitionToken.isETH() ? UniversalERC20.ZERO_ADDRESS : transitionToken,
            inAmounts
        );
        (outAmounts, gas) = calculateSwapReturn(
            registry,
            transitionToken.isETH() ? UniversalERC20.ZERO_ADDRESS : transitionToken,
            outToken,
            outAmounts1
        );
        gas = gas.add(gas1);
    }

    function swap(
        IMooniswapRegistry registry,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        IMooniswap mooniswap = registry.pools(
            inToken.isETH() ? UniversalERC20.ZERO_ADDRESS : inToken,
            outToken.isETH() ? UniversalERC20.ZERO_ADDRESS : outToken
        );
        if (mooniswap == IMooniswap(0)) {
            return;
        }
        inToken.universalApprove(address(mooniswap), inAmount);
        mooniswap.swap{value : inToken.isETH() ? inAmount : 0}(
            inToken.isETH() ? UniversalERC20.ZERO_ADDRESS : inToken,
            outToken.isETH() ? UniversalERC20.ZERO_ADDRESS : outToken,
            inAmount,
            0,
            address(msg.sender)
        );
    }

    function swapTransitional(
        IMooniswapRegistry registry,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(registry, inToken, transitionToken.isETH() ? UniversalERC20.ZERO_ADDRESS : transitionToken, inAmount);
        swap(
            registry,
            transitionToken.isETH() ? UniversalERC20.ZERO_ADDRESS : transitionToken,
            outToken,
            transitionToken.universalBalanceOf(address(this))
        );
    }
}
