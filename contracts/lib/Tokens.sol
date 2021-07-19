// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./UniversalERC20.sol";

/**
 * @dev Wrapper of ETH. See https://weth.io/
 */
abstract contract IWHT is IERC20 {
    function deposit() external payable virtual;

    function withdraw(uint256 amount) external virtual;
}

library Tokens {
    using UniversalERC20 for IERC20;
    IERC20 internal constant USDT = IERC20(0xa71EdC38d189767582C38A3145b5873052c3e47a);
    IERC20 internal constant USDC = IERC20(0x9362Bbef4B8313A8Aa9f0c9808B80577Aa26B73B);
    IWHT internal constant WHT = IWHT(0x5545153CCFcA01fbd7Dd11C0b23ba694D9509A6F);

    /**
     * @notice Wrap the ETH token to meet the ERC20 standard.
     * @param token token to wrap
     */
    function wrapHT(IERC20 token) internal pure returns (IERC20) {
        return token.isHT() ? WHT : token;
    }

    function depositToWHT(IERC20 token, uint256 amount) internal {
        if (token.isHT()) {
            WHT.deposit{value: amount}();
        }
    }

    function withdrawFromWHT(IERC20 token) internal {
        if (token.isHT()) {
            WHT.withdraw(WHT.balanceOf(address(this))); // library methods will be called in the current contract's context
        }
    }

    function isWETH(IERC20 token) internal pure returns (bool) {
        return address(token) == address(WHT);
    }
}
