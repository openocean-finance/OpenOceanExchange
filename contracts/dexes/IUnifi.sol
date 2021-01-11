// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";

interface IUnifiTrade {
    function getEstimatedBuyReceiveAmount(uint256 amount) external view returns (uint256);

    function getEstimatedSellReceiveAmount(uint256 amount) external view returns (uint256);

    function getMinTransaction() external view returns (uint256);

    function getMaxTransaction() external view returns (uint256);

    function getSTATE() external view returns (uint256);

    function Buy(address account) external payable returns (uint256);

    function Sell(uint256 amount) external returns (uint256);
}

interface IUnifiTradeRegistry {
    struct UnifiTradeEntry {
        address tokenAddress;
        address contractAddress;
    }

    function getTrade(address tokenAddress) external view returns (address);

    function register(address tokenAddress, address contractAddress) external;

    function registerMulti(UnifiTradeEntry[] calldata entries) external;
}

library IUnifiTradeRegistryExtenstion {
    using UniversalERC20 for IERC20;

    function calculateSwapReturn(
        IUnifiTradeRegistry registry,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        if (inToken == outToken) {
            return (outAmounts, 0);
        }

        address inTokenTrade;
        address outTokenTrade;
        if (!inToken.isETH()) {
            inTokenTrade = registry.getTrade(address(inToken));
            if (inTokenTrade == address(0)) {
                return (outAmounts, 0);
            }
        }
        if (!outToken.isETH()) {
            outTokenTrade = registry.getTrade(address(outToken));
            if (outTokenTrade == address(0)) {
                return (outAmounts, 0);
            }
        }

        for (uint256 i = 0; i < inAmounts.length; i++) {
            outAmounts[i] = inAmounts[i];

            if (inTokenTrade != address(0)) {
                outAmounts[i] = IUnifiTrade(inTokenTrade).getEstimatedSellReceiveAmount(outAmounts[i]);
            }

            if (outTokenTrade != address(0)) {
                outAmounts[i] = IUnifiTrade(outTokenTrade).getEstimatedBuyReceiveAmount(outAmounts[i]);
            }
        }
        return (outAmounts, 200_000);
    }

    function swap(
        IUnifiTradeRegistry registry,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        address inTokenTrade;
        address outTokenTrade;
        if (!inToken.isETH()) {
            inTokenTrade = registry.getTrade(address(inToken));
            if (inTokenTrade == address(0)) {
                return 0;
            }
        }
        if (!outToken.isETH()) {
            outTokenTrade = registry.getTrade(address(outToken));
            if (outTokenTrade == address(0)) {
                return 0;
            }
        }

        outAmount = inAmount;
        if (inTokenTrade != address(0)) {
            inToken.universalApprove(inTokenTrade, outAmount);
            outAmount = IUnifiTrade(inTokenTrade).Sell(outAmount);
        }

        if (outTokenTrade != address(0)) {
            outAmount = IUnifiTrade(outTokenTrade).Buy{value: outAmount}(address(this));
        }
    }
}
