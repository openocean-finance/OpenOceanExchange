// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./lib/Shutdownable.sol";
import "./lib/UniversalERC20.sol";
import "./lib/ExternalCall.sol";

contract OpenOceanExchange is Shutdownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using UniversalERC20 for IERC20;
    using ExternalCall for address;

    uint256 private feeRate;

    event FeeRateChanged(uint256 indexed oldFeeRate, uint256 indexed newFeeRate);

    event Order(address indexed sender, IERC20 indexed inToken, IERC20 indexed outToken, uint256 inAmount, uint256 outAmount);

    event Swapped(
        IERC20 indexed inToken,
        IERC20 indexed outToken,
        address indexed referrer,
        uint256 inAmount,
        uint256 outAmount,
        uint256 fee,
        uint256 referrerFee
    );

    constructor(address _owner, uint256 _feeRate) public {
        transferOwnership(_owner);
        feeRate = _feeRate;
    }

    function changeFeeRate(uint256 _feeRate) public onlyOwner {
        uint256 oldFeeRate = feeRate;
        feeRate = _feeRate;
        emit FeeRateChanged(oldFeeRate, _feeRate);
    }

    receive() external payable notShutdown {
        require(msg.sender != tx.origin);
    }

    function swap(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 minOutAmount,
        uint256 guaranteedAmount,
        address payable referrer,
        address[] memory addressesToCall,
        bytes memory dataToCall,
        uint256[] memory offsets,
        uint256[] memory gasLimitsAndValues
    ) public payable notShutdown returns (uint256 outAmount) {
        require(minOutAmount > 0, "Min out amount should be greater than zero.");
        require(addressesToCall.length > 0, "Call data should exists.");
        require((msg.value != 0) == inToken.isETH(), "OpenOcean: msg.value should be used only for ETH swap");

        if (!inToken.isETH()) {
            inToken.safeTransferFrom(msg.sender, address(this), inAmount);
        }

        for (uint256 i = 0; i < addressesToCall.length; i++) {
            require(
                addressesToCall[i].externalCall(
                    gasLimitsAndValues[i] & ((1 << 128) - 1),
                    dataToCall,
                    offsets[i],
                    offsets[i + 1] - offsets[i],
                    gasLimitsAndValues[i] >> 128
                )
            );
        }

        inToken.universalTransfer(msg.sender, inToken.universalBalanceOf(address(this)));
        outAmount = outToken.universalBalanceOf(address(this));
        uint256 fee;
        uint256 referrerFee;
        (outAmount, fee, referrerFee) = handleFees(outToken, outAmount, guaranteedAmount, referrer);

        require(outAmount >= minOutAmount, "Return amount less than the minimum required amount");
        outToken.universalTransfer(msg.sender, outAmount);

        emit Order(msg.sender, inToken, outToken, inAmount, outAmount);
        emit Swapped(inToken, outToken, referrer, inAmount, outAmount, fee, referrerFee);
    }

    function handleFees(
        IERC20 toToken,
        uint256 outAmount,
        uint256 guaranteedAmount,
        address referrer
    )
        internal
        returns (
            uint256 realOutAmount,
            uint256 fee,
            uint256 referrerFee
        )
    {
        if (outAmount <= guaranteedAmount || feeRate == 0) {
            return (outAmount, 0, 0);
        }

        fee = outAmount.sub(guaranteedAmount).mul(feeRate).div(10000);

        if (referrer != address(0) && referrer != msg.sender && referrer != tx.origin) {
            referrerFee = fee.div(10);
            if (toToken.universalTransfer(referrer, referrerFee)) {
                outAmount = outAmount.sub(referrerFee);
                fee = fee.sub(referrerFee);
            } else {
                referrerFee = 0;
            }
        }

        if (toToken.universalTransfer(owner(), fee)) {
            outAmount = outAmount.sub(fee);
        }

        return (outAmount, fee, referrerFee);
    }
}
