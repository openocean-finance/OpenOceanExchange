// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./UniversalERC20.sol";

/**
 * @dev Wrapper of ETH. See https://weth.io/
 */
abstract contract IWMATIC is IERC20 {
    function deposit() external payable virtual;

    function withdraw(uint256 amount) external virtual;
}

library Tokens {
    using UniversalERC20 for IERC20;

    IERC20 internal constant DAI = IERC20(0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063);
    IERC20 internal constant USDC = IERC20(0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174);
    IERC20 internal constant USDT = IERC20(0xc2132D05D31c914a87C6611C10748AEb04B58e8F);
    IERC20 internal constant QUICK = IERC20(0x831753DD7087CaC61aB5644b308642cc1c33Dc13);
    IERC20 internal constant MUST = IERC20(0x9C78EE466D6Cb57A4d01Fd887D2b5dFb2D46288f);
    IERC20 internal constant WETH = IERC20(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619);

    IWMATIC internal constant WMATIC = IWMATIC(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270);

    /**
     * @notice Wrap the ETH token to meet the ERC20 standard.
     * @param token token to wrap
     */
    function wrapMATIC(IERC20 token) internal pure returns (IERC20) {
        return token.isMATIC() ? WMATIC : token;
    }

    function depositToWETH(IERC20 token, uint256 amount) internal {
        if (token.isMATIC()) {
            WMATIC.deposit{value: amount}();
        }
    }

    function withdrawFromWETH(IERC20 token) internal {
        if (token.isMATIC()) {
            WMATIC.withdraw(WMATIC.balanceOf(address(this))); // library methods will be called in the current contract's context
        }
    }

    function isWETH(IERC20 token) internal pure returns (bool) {
        return address(token) == address(WMATIC);
    }
}
