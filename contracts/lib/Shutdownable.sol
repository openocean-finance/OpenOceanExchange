// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Shutdownable is Ownable {
    bool public isShutdown;

    event Shutdown();

    modifier notShutdown {
        require(!isShutdown, "Smart contract is shut down.");
        _;
    }

    function shutdown() public onlyOwner {
        isShutdown = true;
        emit Shutdown();
    }
}
