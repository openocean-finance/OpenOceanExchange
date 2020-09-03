// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./UniversalERC20.sol";

/**
 * @dev Wrapper of ETH. See https://weth.io/
 */
abstract contract IWETH is IERC20 {
    function deposit() external virtual payable;

    function withdraw(uint256 amount) external virtual;
}

library Tokens {
    using UniversalERC20 for IERC20;

    IERC20 internal constant DAI = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    IERC20 internal constant USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IERC20 internal constant USDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    IERC20 internal constant TUSD = IERC20(0x0000000000085d4780B73119b644AE5ecd22b376);
    IERC20 internal constant BUSD = IERC20(0x4Fabb145d64652a948d72533023f6E7A623C7C53);
    IERC20 internal constant SUSD = IERC20(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);
    IERC20 internal constant PAX = IERC20(0x8E870D67F660D95d5be530380D0eC0bd388289E1);
    IERC20 internal constant RENBTC = IERC20(0xEB4C2781e4ebA804CE9a9803C67d0893436bB27D);
    IERC20 internal constant WBTC = IERC20(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
    IERC20 internal constant TBTC = IERC20(0x1bBE271d15Bb64dF0bc6CD28Df9Ff322F2eBD847);
    IERC20 internal constant HBTC = IERC20(0x0316EB71485b0Ab14103307bf65a021042c6d380);
    IERC20 internal constant SBTC = IERC20(0xfE18be6b3Bd88A2D2A7f928d00292E7a9963CfC6);

    IWETH internal constant WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    /**
     * @notice Wrap the ETH token to meet the ERC20 standard.
     * @param token token to wrap
     */
    function wrapETH(IERC20 token) internal pure returns (IERC20) {
        return token.isETH() ? WETH : token;
    }

    function depositToWETH(IERC20 token, uint256 amount) internal {
        if (token.isETH()) {
            WETH.deposit{value: amount}();
        }
    }

    function withdrawFromWETH(IERC20 token) internal {
        if (token.isETH()) {
            WETH.withdraw(WETH.balanceOf(address(this))); // library methods will be called in the current contract's context
        }
    }

    function isWETH(IERC20 token) private pure returns (bool) {
        return address(token) == address(WETH);
    }
}
