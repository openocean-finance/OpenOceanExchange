// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./UniversalERC20.sol";

/**
 * @dev Wrapper of ETH. See https://weth.io/
 */
abstract contract IWETH is IERC20 {
    function deposit() external payable virtual;

    function withdraw(uint256 amount) external virtual;
}

library Tokens {
    using UniversalERC20 for IERC20;

    IWETH internal constant WETH = IWETH(0x891cdb91d149f23B1a45D9c5Ca78a88d0cB44C18);

    /**
     * @notice Wrap the ETH token to meet the ERC20 standard.
     * @param token token to wrap
     */
    function wrapETH(IERC20 token) internal pure returns (IERC20) {
        return token.isETH() ? WETH : token;
    }

    function depositToWETH(IERC20 token, uint256 amount) internal {
        if (token.isETH()) {
            WETH.deposit.value(amount)();
        }
    }

    function withdrawFromWETH(IERC20 token) internal {
        if (token.isETH()) {
            WETH.withdraw(WETH.balanceOf(address(this))); // library methods will be called in the current contract's context
        }
    }

    function isWETH(IERC20 token) internal pure returns (bool) {
        return address(token) == address(WETH);
    }
}
