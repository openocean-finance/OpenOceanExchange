// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./UniversalERC20.sol";

/**
 * @dev Wrapper of ETH. See https://weth.io/
 */
abstract contract IWXDAI is IERC20 {
    function deposit() external payable virtual;

    function withdraw(uint256 amount) external virtual;
}

library Tokens {
    using UniversalERC20 for IERC20;

    // IERC20 internal constant DAI = IERC20(0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d);
    IERC20 internal constant USDC = IERC20(0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83);

    //LibertyCoin ETH TODO
    IERC20 internal constant ETH = IERC20(0xfBFe4F9f800490601C5cE4852BC09F5f6dDDB3A7);

    IWXDAI internal constant WXDAI = IWXDAI(0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d);

    /**
     * @notice Wrap the ETH token to meet the ERC20 standard.
     * @param token token to wrap
     */
    function wrapXDAI(IERC20 token) internal pure returns (IERC20) {
        return token.isXDAI() ? WXDAI : token;
    }

    function depositToWXDAI(IERC20 token, uint256 amount) internal {
        if (token.isXDAI()) {
            WXDAI.deposit{value: amount}();
        }
    }

    function withdrawFromWXDAI(IERC20 token) internal {
        if (token.isXDAI()) {
            WXDAI.withdraw(WXDAI.balanceOf(address(this)));
            // library methods will be called in the current contract's context
        }
    }

    function isWXDAI(IERC20 token) internal pure returns (bool) {
        return address(token) == address(WXDAI);
    }
}
