// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./dexes/Dexes.sol";
import "./DexOneView.sol";
import "./IDexOne.sol";

contract DexOne is IDexOne {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using Dexes for Dex;

    DexOneView public dexOneView;

    constructor(DexOneView _dexOneView) public {
        dexOneView = _dexOneView;
    }

    receive() external payable {
        // cannot directly send eth to this contract
        require(msg.sender != tx.origin);
    }

    function calculateSwapReturn(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 partition,
        uint256 flags
    ) public view override returns (uint256 outAmount, uint256[] memory distribution) {
        (outAmount, , distribution) = calculateSwapReturnWithGas(inToken, outToken, inAmount, partition, flags, 0);
    }

    function calculateSwapReturnWithGas(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 partition,
        uint256 flags,
        uint256 outTokenEthPriceTimesGasPrice
    )
        public
        view
        override
        returns (
            uint256 outAmount,
            uint256 estimateGasAmount,
            uint256[] memory distribution
        )
    {
        return dexOneView.calculateSwapReturnWithGas(inToken, outToken, inAmount, partition, flags, outTokenEthPriceTimesGasPrice);
    }

    function calculateDexSwapReturns(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 flags
    ) public view virtual returns (uint256[] memory outAmounts) {
        return dexOneView.calculateDexSwapReturns(inToken, outToken, inAmount, flags);
    }

    function swap(
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount,
        uint256 minOutAmount,
        uint256[] memory distribution,
        uint256 flags
    ) public payable override returns (uint256 outAmount) {
        if (inToken == outToken) {
            return amount;
        }

        Dex[] memory dexes = Dexes.allDexes();
        uint256 partition = 0;
        uint256 lastDex = 0;
        for (uint256 i = 0; i < distribution.length; i++) {
            if (distribution[i] > 0) {
                partition = partition.add(distribution[i]);
                lastDex = i;
            }
        }

        if (partition == 0) {
            if (inToken.isMATIC()) {
                msg.sender.transfer(msg.value);
                return msg.value;
            }
            return amount;
        }

        inToken.universalTransferFrom(msg.sender, address(this), amount);
        uint256 balance = inToken.universalBalanceOf(address(this));
        for (uint256 i = 0; i < distribution.length; i++) {
            if (distribution[i] == 0) {
                continue;
            }
            uint256 swapAmount = amount.mul(distribution[i]).div(partition);
            if (i == lastDex) {
                swapAmount = balance;
            }
            balance -= swapAmount;
            dexes[i].swap(inToken, outToken, swapAmount, flags);
            if (i == lastDex) {
                break;
            }
        }

        outAmount = outToken.universalBalanceOf(address(this));
        require(outAmount >= minOutAmount, "DexOne: Return amount less than the minimum required amount");
        outToken.universalTransfer(msg.sender, outAmount);
        inToken.universalTransfer(msg.sender, inToken.universalBalanceOf(address(this)));
    }
}
