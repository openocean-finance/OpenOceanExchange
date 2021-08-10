// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./UniversalERC20.sol";

/**
 * @dev Wrapper of ETH. See https://weth.io/
 */
abstract contract IWOKT is IERC20 {
    function deposit() external virtual payable;

    function withdraw(uint256 amount) external virtual;
}

library Tokens {
    using UniversalERC20 for IERC20;

    IERC20 internal constant USDC = IERC20(0xc946DAf81b08146B1C7A8Da2A851Ddf2B3EAaf85);
    IERC20 internal constant USDT = IERC20(0x382bB369d343125BfB2117af9c149795C6C65C50);
    IWOKT internal constant WOKT = IWOKT(0x8F8526dbfd6E38E3D8307702cA8469Bae6C56C15);

    /**
     * @notice Wrap the ETH token to meet the ERC20 standard.
     * @param token token to wrap
     */
    function wrapOKT(IERC20 token) internal pure returns (IERC20) {
        return token.isOKT() ? WOKT : token;
    }

    function depositToWOKT(IERC20 token, uint256 amount) internal {
        if (token.isOKT()) {
            WOKT.deposit{value: amount}();
        }
    }

    function withdrawFromWOKT(IERC20 token) internal {
        if (token.isOKT()) {
            WOKT.withdraw(WOKT.balanceOf(address(this))); // library methods will be called in the current contract's context
        }
    }

    function isWOKT(IERC20 token) private pure returns (bool) {
        return address(token) == address(WOKT);
    }
}
