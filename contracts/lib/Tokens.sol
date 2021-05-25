// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./UniversalERC20.sol";

/**
 * @dev Wrapper of ETH. See https://weth.io/
 */
abstract contract IWONE is IERC20 {
    function deposit() external payable virtual;

    function withdraw(uint256 amount) external virtual;
}

library Tokens {
    using UniversalERC20 for IERC20;

    //- ONEs  0xB2f2C1D77113042f5ee9202d48F6d15FB99efb63
    //- USDs  0xFCE523163e2eE1F5f0828eCe554E9D839bEA17F5
    //- SEE   0x7fA202fdb3B0eCB975119cc3A895BFB3104aDA68
    //- ARANK 0xBD16b0B2eB520b7Ff4A4156d367Ee359Ac19c531
    //- EUSK  0x85a1DD919cd605aa2EAD4b01ff1190504BcAb609
    //- SEED  0x793DAC3Ec4969A5BEE684BcF4290d52feB8F51b4

    IWONE internal constant WONE = IWONE(0xB2f2C1D77113042f5ee9202d48F6d15FB99efb63);
    IERC20 internal constant USDs = IERC20(0xFCE523163e2eE1F5f0828eCe554E9D839bEA17F5);
    IERC20 internal constant SEE = IERC20(0x7fA202fdb3B0eCB975119cc3A895BFB3104aDA68);
    IERC20 internal constant ARANK = IERC20(0xBD16b0B2eB520b7Ff4A4156d367Ee359Ac19c531);
    IERC20 internal constant EUSK = IERC20(0x85a1DD919cd605aa2EAD4b01ff1190504BcAb609);
    IERC20 internal constant SEED = IERC20(0x793DAC3Ec4969A5BEE684BcF4290d52feB8F51b4);

    /**
     * @notice Wrap the ETH token to meet the ERC20 standard.
     * @param token token to wrap
     */
    function wrapONE(IERC20 token) internal pure returns (IERC20) {
        return token.isONE() ? WONE : token;
    }

    function depositToWAVAX(IERC20 token, uint256 amount) internal {
        if (token.isONE()) {
            WONE.deposit{value : amount}();
        }
    }

    function withdrawFromWONE(IERC20 token) internal {
        if (token.isONE()) {
            WONE.withdraw(WONE.balanceOf(address(this)));
            // library methods will be called in the current contract's context
        }
    }

    function isWAVAX(IERC20 token) internal pure returns (bool) {
        return address(token) == address(WONE);
    }
}
