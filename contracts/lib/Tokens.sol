// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./UniversalERC20.sol";

/**
 * @dev Wrapper of ETH. See https://weth.io/
 */
abstract contract IWFTM is IERC20 {
    function deposit() external payable virtual;

    function withdraw(uint256 amount) external virtual;
}

library Tokens {
    using UniversalERC20 for IERC20;


    IERC20 internal constant DAI = IERC20(0x8D11eC38a3EB5E956B052f67Da8Bdc9bef8Abf3E);
    IERC20 internal constant USDC = IERC20(0x04068DA6C83AFCFA0e13ba15A6696662335D5B75);
    IERC20 internal constant fUSDT = IERC20(0x049d68029688eAbF473097a2fC38ef61633A3C7A);
    IERC20 internal constant BTC = IERC20(0x321162Cd933E2Be498Cd2267a90534A804051b11);
    IERC20 internal constant renBTC = IERC20(0xDBf31dF14B66535aF65AaC99C32e9eA844e14501);
    IWFTM internal constant WFTM = IWFTM(0x21be370D5312f44cB42ce377BC9b8a0cEF1A4C83);


    /**
     * @notice Wrap the ETH token to meet the ERC20 standard.
     * @param token token to wrap
     */
    function wrapFTM(IERC20 token) internal pure returns (IERC20) {
        return token.isFTM() ? WFTM : token;
    }

    function depositToWXDAI(IERC20 token, uint256 amount) internal {
        if (token.isFTM()) {
            WFTM.deposit{value : amount}();
        }
    }

    function withdrawFromWETH(IERC20 token) internal {
        if (token.isFTM()) {
            WFTM.withdraw(WFTM.balanceOf(address(this)));
            // library methods will be called in the current contract's context
        }
    }

    function isWETH(IERC20 token) internal pure returns (bool) {
        return address(token) == address(WFTM);
    }
}
