// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./lib/Shutdownable.sol";
import "./lib/UniversalERC20.sol";
import "./lib/ExternalCall.sol";

contract TokenSpender {
    using SafeERC20 for IERC20;

    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function claimToken(
        IERC20 token,
        address who,
        address dest,
        uint256 amount
    ) external {
        require(msg.sender == owner, "Access restricted");
        token.safeTransferFrom(who, dest, amount);
    }
}

contract OpenOceanExchange is Shutdownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using UniversalERC20 for IERC20;
    using ExternalCall for address;

    TokenSpender public spender;

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

    constructor(address _owner) public {
        spender = new TokenSpender();
        transferOwnership(_owner);
    }

    receive() external payable notShutdown {
        require(msg.sender != tx.origin);
    }

    function swap(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 minOutAmount,
        uint256, /*guaranteedAmount*/
        address payable referrer,
        address[] memory addressesToCall,
        bytes memory dataToCall,
        uint256[] memory offsets,
        uint256[] memory gasLimitsAndValues
    ) public payable notShutdown returns (uint256 outAmount) {
        require(minOutAmount > 0, "Min out amount should be greater than zero");
        require(addressesToCall.length > 0, "Call data should exists");
        require((msg.value != 0) == inToken.isETH(), "OpenOcean: msg.value should be used only for ETH swap");

        if (!inToken.isETH()) {
            spender.claimToken(inToken, msg.sender, address(this), inAmount);
        }

        for (uint256 i = 0; i < addressesToCall.length; i++) {
            require(addressesToCall[i] != address(spender), "Access denied");
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

        require(outAmount >= minOutAmount, "Return amount less than the minimum required amount");
        outToken.universalTransfer(msg.sender, outAmount);

        emit Order(msg.sender, inToken, outToken, inAmount, outAmount);
        emit Swapped(inToken, outToken, referrer, inAmount, outAmount, 0, 0);
    }
}
