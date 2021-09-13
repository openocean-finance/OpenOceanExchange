// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./UniversalERC20.sol";

/**
 * @dev Wrapper of ETH. See https://weth.io/
 */
abstract contract IWAVAX is IERC20 {
    function deposit() external payable virtual;

    function withdraw(uint256 amount) external virtual;
}

library Tokens {
    using UniversalERC20 for IERC20;

    IERC20 internal constant DAI = IERC20(0xbA7dEebBFC5fA1100Fb055a87773e1E99Cd3507a);
    IERC20 internal constant USDT = IERC20(0xc7198437980c041c805A1EDcbA50c1Ce5db95118);
    IWAVAX internal constant WAVAX = IWAVAX(0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7);

    /**
     * @notice Wrap the ETH token to meet the ERC20 standard.
     * @param token token to wrap
     */
    function wrapAVAX(IERC20 token) internal pure returns (IERC20) {
        return token.isAVAX() ? WAVAX : token;
    }

    function depositToWAVAX(IERC20 token, uint256 amount) internal {
        if (token.isAVAX()) {
            WAVAX.deposit{value : amount}();
        }
    }

    function withdrawFromWAVAX(IERC20 token) internal {
        if (token.isAVAX()) {
            WAVAX.withdraw(WAVAX.balanceOf(address(this)));
            // library methods will be called in the current contract's context
        }
    }

    function isAVAX(IERC20 token) internal pure returns (bool) {
        return address(token) == address(WAVAX);
    }
}
