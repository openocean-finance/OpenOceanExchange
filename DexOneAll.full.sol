
// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin/contracts/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/IDexOne.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


abstract contract IDexOne {
    function calculateSwapReturn(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 partition,
        uint256 flags
    ) public virtual view returns (uint256 outAmount, uint256[] memory distribution);

    function calculateSwapReturnWithGas(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 partition,
        uint256 flags,
        uint256 outTokenEthPriceTimesGasPrice
    )
        public
        virtual
        view
        returns (
            uint256 outAmount,
            uint256 estimateGasAmount,
            uint256[] memory distribution
        );

    function swap(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 minOutAmount,
        uint256[] memory distribution,
        uint256 flags
    ) public virtual payable returns (uint256 outAmount);
}

abstract contract IDexOneTransitional is IDexOne {
    function calculateSwapReturnWithGasTransitional(
        IERC20[] memory tokens,
        uint256 inAmount,
        uint256[] memory partitions,
        uint256[] memory flags,
        uint256[] memory outTokenEthPriceTimesGasPrices
    )
        public
        virtual
        view
        returns (
            uint256[] memory outAmounts,
            uint256 estimateGasAmount,
            uint256[] memory distribution
        );

    function swapTransitional(
        IERC20[] memory tokens,
        uint256 inAmount,
        uint256 minOutAmount,
        uint256[] memory distribution,
        uint256[] memory flags
    ) public virtual payable returns (uint256 outAmount);
}

// File: @openzeppelin/contracts/utils/Address.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;




/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: contracts/lib/UniversalERC20.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;




/**
 * @dev See https://github.com/CryptoManiacsZone/1inchProtocol/blob/master/contracts/UniversalERC20.sol
 */
library UniversalERC20 {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 internal constant ZERO_ADDRESS = IERC20(0x0000000000000000000000000000000000000000);
    IERC20 internal constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    function universalTransfer(
        IERC20 token,
        address to,
        uint256 amount
    ) internal returns (bool) {
        if (amount == 0) {
            return true;
        }

        if (isETH(token)) {
            address(uint160(to)).transfer(amount);
            return true;
        } else {
            token.safeTransfer(to, amount);
            return true;
        }
    }

    function universalTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 amount
    ) internal {
        if (amount == 0) {
            return;
        }

        if (isETH(token)) {
            require(from == msg.sender && msg.value >= amount, "Wrong useage of ETH.universalTransferFrom()");
            if (to != address(this)) {
                address(uint160(to)).transfer(amount);
            }
            if (msg.value > amount) {
                // return the remainder
                msg.sender.transfer(msg.value.sub(amount));
            }
        } else {
            token.safeTransferFrom(from, to, amount);
        }
    }

    function universalTransferFromSenderToThis(IERC20 token, uint256 amount) internal {
        if (amount == 0) {
            return;
        }

        if (isETH(token)) {
            if (msg.value > amount) {
                // return the remainder
                msg.sender.transfer(msg.value.sub(amount));
            }
        } else {
            token.safeTransferFrom(msg.sender, address(this), amount);
        }
    }

    function universalApprove(
        IERC20 token,
        address to,
        uint256 amount
    ) internal {
        if (!isETH(token)) {
            if (amount == 0) {
                token.safeApprove(to, 0);
                return;
            }

            uint256 allowance = token.allowance(address(this), to);
            if (allowance < amount) {
                if (allowance > 0) {
                    token.safeApprove(to, 0);
                }
                token.safeApprove(to, amount);
            }
        }
    }

    function universalBalanceOf(IERC20 token, address who) internal view returns (uint256) {
        if (isETH(token)) {
            return who.balance;
        } else {
            return token.balanceOf(who);
        }
    }

    function universalDecimals(IERC20 token) internal view returns (uint256) {
        if (isETH(token)) {
            return 18;
        }

        (bool success, bytes memory data) = address(token).staticcall{gas: 10000}(abi.encodeWithSignature("decimals()"));
        if (!success || data.length == 0) {
            (success, data) = address(token).staticcall{gas: 10000}(abi.encodeWithSignature("DECIMALS()"));
        }

        return (success && data.length > 0) ? abi.decode(data, (uint256)) : 18;
    }

    function isETH(IERC20 token) internal pure returns (bool) {
        return (address(token) == address(ZERO_ADDRESS) || address(token) == address(ETH_ADDRESS));
    }

    function notExist(IERC20 token) internal pure returns (bool) {
        return (address(token) == address(-1));
    }
}

// File: contracts/lib/Tokens.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;



/**
 * @dev Wrapper of ETH. See https://weth.io/
 */
abstract contract IWETH is IERC20 {
    function deposit() external payable virtual;

    function withdraw(uint256 amount) external virtual;
}

library Tokens {
    using UniversalERC20 for IERC20;

    IERC20 internal constant OOE = IERC20(0x9029FdFAe9A03135846381c7cE16595C3554e10A);
    IERC20 internal constant DAI = IERC20(0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3);
    IERC20 internal constant USDC = IERC20(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d);
    IERC20 internal constant USDT = IERC20(0x55d398326f99059fF775485246999027B3197955);
    IERC20 internal constant BUSD = IERC20(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
    IERC20 internal constant QUSD = IERC20(0xb8C540d00dd0Bf76ea12E4B4B95eFC90804f924E);
    IERC20 internal constant DOT = IERC20(0x7083609fCE4d1d8Dc0C979AAb8c869Ea2C873402);

    IERC20 internal constant VAI = IERC20(0x4BD17003473389A42DAF6a0a729f6Fdb328BbBd7);
    IERC20 internal constant UST = IERC20(0x23396cF899Ca06c4472205fC903bDB4de249D6fC);

    // Apeswap
    IERC20 internal constant BANANA = IERC20(0x603c7f932ED1fc6575303D8Fb018fDCBb0f39a95);

    // Acryptos
    IERC20 internal constant BTCB = IERC20(0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c);
    IERC20 internal constant pBTC = IERC20(0xeD28A457A5A76596ac48d87C0f577020F6Ea1c4C);
    IERC20 internal constant RENBTC = IERC20(0xfCe146bF3146100cfe5dB4129cf6C82b0eF4Ad8c);

    // Ellipsis
    IERC20 internal constant fUSDT = IERC20(0x049d68029688eAbF473097a2fC38ef61633A3C7A);

    IERC20 internal constant TUSD = IERC20(0x0000000000085d4780B73119b644AE5ecd22b376);
    IERC20 internal constant SUSD = IERC20(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);
    IERC20 internal constant PAX = IERC20(0x8E870D67F660D95d5be530380D0eC0bd388289E1);
    IERC20 internal constant WBTC = IERC20(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
    IERC20 internal constant TBTC = IERC20(0x1bBE271d15Bb64dF0bc6CD28Df9Ff322F2eBD847);
    IERC20 internal constant HBTC = IERC20(0x0316EB71485b0Ab14103307bf65a021042c6d380);
    IERC20 internal constant SBTC = IERC20(0xfE18be6b3Bd88A2D2A7f928d00292E7a9963CfC6);

    // IWETH internal constant WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IWETH internal constant WETH = IWETH(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);

    // BURGER Token
    IERC20 internal constant DGAS = IERC20(0xAe9269f27437f0fcBC232d39Ec814844a51d6b8f);


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

    function isWETH(IERC20 token) internal pure returns (bool) {
        return address(token) == address(WETH);
    }
}

// File: contracts/lib/Flags.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
    uint256 internal constant FLAG_DISABLE_PANCAKE_ALL = 1 << 0;
    uint256 internal constant FLAG_DISABLE_PANCAKE = 1 << 1;
    uint256 internal constant FLAG_DISABLE_PANCAKE_ETH = 1 << 2;
    uint256 internal constant FLAG_DISABLE_PANCAKE_DAI = 1 << 3;
    uint256 internal constant FLAG_DISABLE_PANCAKE_USDC = 1 << 4;
    uint256 internal constant FLAG_DISABLE_PANCAKE_USDT = 1 << 5;
    // Bakery
    uint256 internal constant FLAG_DISABLE_BAKERY_ALL = 1 << 6;
    uint256 internal constant FLAG_DISABLE_BAKERY = 1 << 7;
    uint256 internal constant FLAG_DISABLE_BAKERY_ETH = 1 << 8;
    uint256 internal constant FLAG_DISABLE_BAKERY_DAI = 1 << 9;
    uint256 internal constant FLAG_DISABLE_BAKERY_USDC = 1 << 10;
    uint256 internal constant FLAG_DISABLE_BAKERY_USDT = 1 << 11;
    // Burger
    uint256 internal constant FLAG_DISABLE_BURGER_ALL = 1 << 12;
    uint256 internal constant FLAG_DISABLE_BURGER = 1 << 13;
    uint256 internal constant FLAG_DISABLE_BURGER_ETH = 1 << 14;
    uint256 internal constant FLAG_DISABLE_BURGER_DGAS = 1 << 15;
    // Thugswap
    uint256 internal constant FLAG_DISABLE_THUGSWAP_ALL = 1 << 16;
    uint256 internal constant FLAG_DISABLE_THUGSWAP = 1 << 17;
    uint256 internal constant FLAG_DISABLE_THUGSWAP_ETH = 1 << 18;
    uint256 internal constant FLAG_DISABLE_THUGSWAP_DAI = 1 << 19;
    uint256 internal constant FLAG_DISABLE_THUGSWAP_USDC = 1 << 20;
    uint256 internal constant FLAG_DISABLE_THUGSWAP_USDT = 1 << 21;
    // BUSD transitional token
    uint256 internal constant FLAG_DISABLE_PANCAKE_BUSD = 1 << 22;
    uint256 internal constant FLAG_DISABLE_BAKERY_BUSD = 1 << 23;
    uint256 internal constant FLAG_DISABLE_THUGSWAP_BUSD = 1 << 24;
    // StableX
    uint256 internal constant FLAG_DISABLE_STABLEX_ALL = 1 << 25;
    uint256 internal constant FLAG_DISABLE_STABLEX = 1 << 26;
    uint256 internal constant FLAG_DISABLE_STABLEX_BUSD = 1 << 27;
    uint256 internal constant FLAG_DISABLE_STABLEX_QUSD = 1 << 28;
    uint256 internal constant FLAG_DISABLE_STABLEX_USDC = 1 << 29;
    uint256 internal constant FLAG_DISABLE_STABLEX_USDT = 1 << 30;
    uint256 internal constant FLAG_DISABLE_STABLEX_DAI = 1 << 31;
    // Unifi
    uint256 internal constant FLAG_DISABLE_UNIFI_ALL = 1 << 32;
    uint256 internal constant FLAG_DISABLE_UNIFI = 1 << 33;
    // WETH
    uint256 internal constant FLAG_DISABLE_WETH = 1 << 34;
    // Julswap
    uint256 internal constant FLAG_DISABLE_JULSWAP_ALL = 1 << 35;
    uint256 internal constant FLAG_DISABLE_JULSWAP = 1 << 36;
    uint256 internal constant FLAG_DISABLE_JULSWAP_ETH = 1 << 37;
    uint256 internal constant FLAG_DISABLE_JULSWAP_DAI = 1 << 38;
    uint256 internal constant FLAG_DISABLE_JULSWAP_USDC = 1 << 39;
    uint256 internal constant FLAG_DISABLE_JULSWAP_USDT = 1 << 40;
    uint256 internal constant FLAG_DISABLE_JULSWAP_BUSD = 1 << 41;
    // Pancake DOT
    uint256 internal constant FLAG_DISABLE_PANCAKE_DOT = 1 << 42;
    // Acryptos
    uint256 internal constant FLAG_DISABLE_ACRYPTOS_ALL = 1 << 43;
    uint256 internal constant FLAG_DISABLE_ACRYPTOS_USD = 1 << 44;
    uint256 internal constant FLAG_DISABLE_ACRYPTOS_VAI = 1 << 45;
    uint256 internal constant FLAG_DISABLE_ACRYPTOS_UST = 1 << 46;
    uint256 internal constant FLAG_DISABLE_ACRYPTOS_QUSD = 1 << 47;
    // Apeswap
    uint256 internal constant FLAG_DISABLE_APESWAP_ALL = 1 << 48;
    uint256 internal constant FLAG_DISABLE_APESWAP = 1 << 49;
    uint256 internal constant FLAG_DISABLE_APESWAP_ETH = 1 << 50;
    uint256 internal constant FLAG_DISABLE_APESWAP_USDT = 1 << 51;
    uint256 internal constant FLAG_DISABLE_APESWAP_BUSD = 1 << 52;
    uint256 internal constant FLAG_DISABLE_APESWAP_BANANA = 1 << 53;
    // add DODO
    uint256 internal constant FLAG_DISABLE_DODO_ALL = 1 << 54;
    uint256 internal constant FLAG_DISABLE_DODO = 1 << 55;
    uint256 internal constant FLAG_DISABLE_DODO_USDC = 1 << 56;
    uint256 internal constant FLAG_DISABLE_DODO_USDT = 1 << 57;
    // add Smoothy
    uint256 internal constant FLAG_DISABLE_SMOOTHY = 1 << 58;
    // add Ellipsis
    uint256 internal constant FLAG_DISABLE_ELLIPSIS = 1 << 59;
    // add MDex
    uint256 internal constant FLAG_DISABLE_MDEX_ALL = 1 << 60;
    uint256 internal constant FLAG_DISABLE_MDEX = 1 << 61;
    uint256 internal constant FLAG_DISABLE_MDEX_ETH = 1 << 62;
    uint256 internal constant FLAG_DISABLE_MDEX_BUSD = 1 << 63;
    uint256 internal constant FLAG_DISABLE_MDEX_USDC = 1 << 64;
    uint256 internal constant FLAG_DISABLE_MDEX_USDT = 1 << 65;
    // PANCAKE_V2
    uint256 internal constant FLAG_DISABLE_PANCAKE_ALL_V2 = 1 << 66;
    uint256 internal constant FLAG_DISABLE_PANCAKE_V2 = 1 << 67;
    uint256 internal constant FLAG_DISABLE_PANCAKE_ETH_V2 = 1 << 68;
    uint256 internal constant FLAG_DISABLE_PANCAKE_USDC_V2 = 1 << 69;
    uint256 internal constant FLAG_DISABLE_PANCAKE_USDT_V2 = 1 << 70;
    uint256 internal constant FLAG_DISABLE_PANCAKE_DOT_V2 = 1 << 71;
    uint256 internal constant FLAG_DISABLE_PANCAKE_BUSD_V2 = 1 << 72;

    // Nerve
    uint256 internal constant FLAG_DISABLE_NERVE_ALL = 1 << 73;
    uint256 internal constant FLAG_DISABLE_NERVE_POOL3 = 1 << 74;
    uint256 internal constant FLAG_DISABLE_NERVE_BTC = 1 << 75;
    uint256 internal constant FLAG_DISABLE_NERVE_ETH = 1 << 76;
    // Cafeswap
    uint256 internal constant FLAG_DISABLE_CAFESWAP_ALL = 1 << 77;
    // Beltswap
    uint256 internal constant FLAG_DISABLE_BELTSWAP_ALL = 1 << 78;

    // add Mooniswap
    uint256 internal constant FLAG_DISABLE_MOONISWAP_ALL = 1 << 79;
    uint256 internal constant FLAG_DISABLE_MOONISWAP = 1 << 80;
    uint256 internal constant FLAG_DISABLE_MOONISWAP_ETH = 1 << 81;
    uint256 internal constant FLAG_DISABLE_MOONISWAP_DAI = 1 << 82;
    uint256 internal constant FLAG_DISABLE_MOONISWAP_USDC = 1 << 83;

    // PantherSwap
    uint256 internal constant FLAG_DISABLE_PANTHERSWAP_ALL = 1 << 84;
    uint256 internal constant FLAG_DISABLE_PANTHERSWAP = 1 << 85;
    uint256 internal constant FLAG_DISABLE_PANTHERSWAP_BNB = 1 << 86;
    uint256 internal constant FLAG_DISABLE_PANTHERSWAP_USDC = 1 << 87;
    uint256 internal constant FLAG_DISABLE_PANTHERSWAP_USDT = 1 << 88;

    // PancakeBunny
    uint256 internal constant FLAG_DISABLE_ZAPBSC = 1 << 89;

    // Innoswap
    uint256 internal constant FLAG_DISABLE_INNOSWAP_ALL = 1 << 90;
    // Waultswap
    uint256 internal constant FLAG_DISABLE_WAULTSWAP_ALL = 1 << 91;
    // Babyswap
    uint256 internal constant FLAG_DISABLE_BABYSWAP_ALL = 1 << 92;
    // Biswap
    uint256 internal constant FLAG_DISABLE_BISWAP_ALL = 1 << 93;

    function on(uint256 flags, uint256 flag) internal pure returns (bool) {
        return (flags & flag) != 0;
    }

    function or(
        uint256 flags,
        uint256 flag1,
        uint256 flag2
    ) internal pure returns (bool) {
        return on(flags, flag1 | flag2);
    }
}

// File: contracts/dexes/IMooniswap.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;




interface IMooniswapRegistry {
    function pools(IERC20 token1, IERC20 token2) external view returns (IMooniswap);

    function isPool(address addr) external view returns (bool);
}

interface IMooniswap {
    function fee() external view returns (uint256);

    function tokens(uint256 i) external view returns (IERC20);

    function deposit(uint256[] calldata amounts, uint256[] calldata minAmounts) external payable returns (uint256 fairSupply);

    function withdraw(uint256 amount, uint256[] calldata minReturns) external;

    function getBalanceForAddition(IERC20 token) external view returns (uint256);

    function getBalanceForRemoval(IERC20 token) external view returns (uint256);

    function getReturn(
        IERC20 fromToken,
        IERC20 destToken,
        uint256 amount
    ) external view returns (uint256 returnAmount);

    function swap(
        IERC20 fromToken,
        IERC20 destToken,
        uint256 amount,
        uint256 minReturn,
        address referral
    ) external payable returns (uint256 returnAmount);
}

library IMooniswapExtenstion {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    function calculateOutAmounts(
        IMooniswap mooniswap,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        for (uint256 i = 0; i < inAmounts.length; i++) {
            outAmounts[i] = mooniswap.getReturn(inToken, outToken, inAmounts[i]);
        }
        return (outAmounts, (inToken.isETH() || outToken.isETH()) ? 80_000 : 110_000);
        //TODO
    }
}

library IMooniswapRegistryExtension {
    using IMooniswapExtenstion for IMooniswap;
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    function calculateSwapReturn(
        IMooniswapRegistry registry,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IMooniswap mooniswap =
        registry.pools(
            inToken.isETH() ? UniversalERC20.ZERO_ADDRESS : inToken,
            outToken.isETH() ? UniversalERC20.ZERO_ADDRESS : outToken
        );
        if (mooniswap == IMooniswap(0)) {
            return (new uint256[](inAmounts.length), 0);
        }

        return mooniswap.calculateOutAmounts(inToken, outToken, inAmounts);
    }

    function calculateTransitionalSwapReturn(
        IMooniswapRegistry registry,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        if (transitionToken.isETH()) {
            if (inToken.isETH() || outToken.isETH()) {
                return (new uint256[](inAmounts.length), 0);
            }
        } else if (inToken == transitionToken || outToken == transitionToken) {
            return (new uint256[](inAmounts.length), 0);
        }

        (uint256[] memory outAmounts1, uint256 gas1) =
        calculateSwapReturn(
            registry,
            inToken,
            transitionToken.isETH() ? UniversalERC20.ZERO_ADDRESS : transitionToken,
            inAmounts
        );
        (outAmounts, gas) = calculateSwapReturn(
            registry,
            transitionToken.isETH() ? UniversalERC20.ZERO_ADDRESS : transitionToken,
            outToken,
            outAmounts1
        );
        gas = gas.add(gas1);
    }

    function swap(
        IMooniswapRegistry registry,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        IMooniswap mooniswap =
        registry.pools(
            inToken.isETH() ? UniversalERC20.ZERO_ADDRESS : inToken,
            outToken.isETH() ? UniversalERC20.ZERO_ADDRESS : outToken
        );
        if (mooniswap == IMooniswap(0)) {
            return;
        }

        inToken.universalApprove(address(mooniswap), inAmount);
        mooniswap.swap{value : inToken.isETH() ? inAmount : 0}(
            inToken.isETH() ? UniversalERC20.ZERO_ADDRESS : inToken,
            outToken.isETH() ? UniversalERC20.ZERO_ADDRESS : outToken,
            inAmount,
            0,
            0xe523182610482b8C0DD65d5A08F1Bbd256B1EA0c// TODO
        );
    }

    function swapTransitional(
        IMooniswapRegistry registry,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(registry, inToken, transitionToken.isETH() ? UniversalERC20.ZERO_ADDRESS : transitionToken, inAmount);
        swap(
            registry,
            transitionToken.isETH() ? UniversalERC20.ZERO_ADDRESS : transitionToken,
            outToken,
            transitionToken.universalBalanceOf(address(this))
        );
    }
}

// File: contracts/dexes/IWETH.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;




library IWETHExtension {
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;

    function calculateSwapReturn(
        IWETH,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal pure returns (uint256[] memory outAmounts, uint256 gas) {
        if (inToken.isETH() && outToken.isWETH()) {
            return (inAmounts, 30_000);
        }
        if (inToken.isWETH() && outToken.isETH()) {
            return (inAmounts, 30_000);
        }

        outAmounts = new uint256[](inAmounts.length);
        return (outAmounts, 0);
    }

    function swap(
        IWETH,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        inToken.depositToWETH(inAmount);
        outToken.withdrawFromWETH();
    }
}

// File: contracts/dexes/IAcryptos.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;





/**
 * @notice Pool contracts of curve.fi
 * See https://github.com/curvefi/curve-vue/blob/master/src/docs/README.md#how-to-integrate-curve-smart-contracts
 */
interface IAcryptosPool {
    function get_dy_underlying(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256 dy);

    function get_dy(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256 dy);

    function exchange_underlying(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 minDy
    ) external;

    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 minDy
    ) external;
}

library IAcryptosPoolExtension {
    using UniversalERC20 for IERC20;

    IAcryptosPool internal constant ACRYPTOS_USD = IAcryptosPool(0xb3F0C9ea1F05e312093Fdb031E789A756659B0AC);
    IAcryptosPool internal constant ACRYPTOS_VAI = IAcryptosPool(0x191409D5A4EfFe25b0f4240557BA2192D18a191e);
    IAcryptosPool internal constant ACRYPTOS_UST = IAcryptosPool(0x99c92765EfC472a9709Ced86310D64C4573c4b77);
    IAcryptosPool internal constant ACRYPTOS_QUSD = IAcryptosPool(0x3919874C7bc0699cF59c981C5eb668823FA4f958);
    IAcryptosPool internal constant ACRYPTOS_BTC = IAcryptosPool(0xbE7CAa236544d1B9A0E7F91e94B9f5Bfd3B5ca81);

    function calculateSwapReturn(
        IAcryptosPool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        IERC20[] memory tokens;
        bool underlying;
        (tokens, underlying, gas) = getPoolConfig(pool);

        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == -1 || j == -1) {
            return (outAmounts, 0);
        }
        if (underlying && i != 0 && j != 0) {
            return (outAmounts, 0);
        }

        for (uint256 k = 0; k < inAmounts.length; k++) {
            if (underlying) {
                outAmounts[k] = pool.get_dy_underlying(i, j, inAmounts[k]);
            } else {
                outAmounts[k] = pool.get_dy(i, j, inAmounts[k]);
            }
        }
    }

    function swap(
        IAcryptosPool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        (IERC20[] memory tokens, bool underlying, ) = getPoolConfig(pool);

        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == -1 || j == -1) {
            return;
        }
        if (underlying && i != 0 && j != 0) {
            return;
        }

        inToken.universalApprove(address(pool), inAmount);
        if (underlying) {
            pool.exchange_underlying(i, j, inAmount, 0);
        } else {
            pool.exchange(i, j, inAmount, 0);
        }
    }

    function determineTokenIndex(
        IERC20 inToken,
        IERC20 outToken,
        IERC20[] memory tokens
    ) private pure returns (int128, int128) {
        int128 i = -1;
        int128 j = -1;
        for (uint256 k = 0; k < tokens.length; k++) {
            IERC20 token = tokens[k];
            if (inToken == token) {
                i = int128(k);
            }
            if (outToken == token) {
                j = int128(k);
            }
        }
        return (i, j);
    }

    /**
     * @notice Build calculation arguments.
     * See https://github.com/curvefi/curve-vue/blob/master/src/docs/README.md
     */
    function getPoolConfig(IAcryptosPool pool)
        private
        pure
        returns (
            IERC20[] memory tokens,
            bool underlying,
            uint256 gas
        )
    {
        if (pool == ACRYPTOS_USD) {
            tokens = new IERC20[](4);
            tokens[0] = Tokens.BUSD;
            tokens[1] = Tokens.USDT;
            tokens[2] = Tokens.DAI;
            tokens[3] = Tokens.USDC;
            underlying = false;
            gas = 720_000;
        } else if (pool == ACRYPTOS_VAI) {
            tokens = new IERC20[](5);
            tokens[0] = Tokens.VAI;
            tokens[1] = Tokens.BUSD;
            tokens[2] = Tokens.USDT;
            tokens[3] = Tokens.DAI;
            tokens[4] = Tokens.USDC;
            underlying = true;
            gas = 1_400_000;
        } else if (pool == ACRYPTOS_UST) {
            tokens = new IERC20[](5);
            tokens[0] = Tokens.UST;
            tokens[1] = Tokens.BUSD;
            tokens[2] = Tokens.USDT;
            tokens[3] = Tokens.DAI;
            tokens[4] = Tokens.USDC;
            underlying = true;
            gas = 1_400_000;
        } else if (pool == ACRYPTOS_QUSD) {
            tokens = new IERC20[](5);
            tokens[0] = Tokens.QUSD;
            tokens[1] = Tokens.BUSD;
            tokens[2] = Tokens.USDT;
            tokens[3] = Tokens.DAI;
            tokens[4] = Tokens.USDC;
            underlying = true;
            gas = 1_400_000;
        } else if (pool == ACRYPTOS_BTC) {
            tokens = new IERC20[](3);
            tokens[0] = Tokens.BTCB;
            tokens[1] = Tokens.RENBTC;
            tokens[2] = Tokens.pBTC;
            underlying = false;
            gas = 720_000;
        }
    }
}

// File: contracts/dexes/ISmoothy.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;



interface ISmoothy {
    function _ntokens() external view returns (uint256);

    function _tokenExist(address) external view returns (uint256);

    function _tokenInfos(uint256) external view returns (uint256);

    function getSwapAmount(
        uint256 bTokenIdxIn,
        uint256 bTokenIdxOut,
        uint256 bTokenInAmount
    ) external view returns (uint256);

    function swap(
        uint256 bTokenIdxIn,
        uint256 bTokenIdxOut,
        uint256 bTokenInAmount,
        uint256 bTokenOutMin
    ) external;
}

library ISmoothyExtension {
    using UniversalERC20 for IERC20;

    function calculateSwapReturn(
        ISmoothy smoothy,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        if (smoothy._tokenExist(address(inToken)) == 0 || smoothy._tokenExist(address(outToken)) == 0) {
            return (outAmounts, 0);
        }
        (uint256 inTokenIndex, uint256 outTokenIndex) = findTokenIndices(smoothy, inToken, outToken);
        for (uint256 i = 0; i < inAmounts.length; i++) {
            try smoothy.getSwapAmount(inTokenIndex, outTokenIndex, inAmounts[i]) returns (uint256 outAmount) {
                outAmounts[i] = outAmount;
            } catch {
                // bypass smoothy calculation revert
                outAmounts[i] = 0;
            }
        }
        return (outAmounts, 0);
    }

    function swap(
        ISmoothy smoothy,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        if (smoothy._tokenExist(address(inToken)) == 0 || smoothy._tokenExist(address(outToken)) == 0) {
            return;
        }
        (uint256 inTokenIndex, uint256 outTokenIndex) = findTokenIndices(smoothy, inToken, outToken);
        inToken.universalApprove(address(smoothy), inAmount);
        smoothy.swap(inTokenIndex, outTokenIndex, inAmount, 0);
    }

    function findTokenIndices(
        ISmoothy smoothy,
        IERC20 inToken,
        IERC20 outToken
    ) private view returns (uint256 inTokenIndex, uint256 outTokenIndex) {
        uint256 ntokens = smoothy._ntokens();
        for (uint256 i = 0; i < ntokens; i++) {
            uint256 tokenInfo = smoothy._tokenInfos(i);
            address tokenAddress = address(tokenInfo);
            if (tokenAddress == address(inToken)) {
                inTokenIndex = i;
            }
            if (tokenAddress == address(outToken)) {
                outTokenIndex = i;
            }
        }
    }
}

// File: contracts/dexes/IEllipsis.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;





/**
 * @notice Pool contracts of curve.fi
 * See https://github.com/curvefi/curve-vue/blob/master/src/docs/README.md#how-to-integrate-curve-smart-contracts
 */
interface IEllipsisPool {
    function get_dy_underlying(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256 dy);

    function get_dy(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256 dy);

    function exchange_underlying(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 minDy
    ) external;

    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 minDy
    ) external;
}

library IEllipsisPoolExtension {
    using UniversalERC20 for IERC20;

    IEllipsisPool internal constant ELLIPSIS_USD = IEllipsisPool(0x160CAed03795365F3A589f10C379FfA7d75d4E76);
    IEllipsisPool internal constant ELLIPSIS_BTC = IEllipsisPool(0x2477fB288c5b4118315714ad3c7Fd7CC69b00bf9);
    IEllipsisPool internal constant ELLIPSIS_FUSDT = IEllipsisPool(0x556ea0b4c06D043806859c9490072FaadC104b63);

    function calculateSwapReturn(
        IEllipsisPool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        IERC20[] memory tokens;
        bool underlying;
        (tokens, underlying, gas) = getPoolConfig(pool);

        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == -1 || j == -1) {
            return (outAmounts, 0);
        }
        if (underlying && i != 0 && j != 0) {
            return (outAmounts, 0);
        }

        for (uint256 k = 0; k < inAmounts.length; k++) {
            if (underlying) {
                outAmounts[k] = pool.get_dy_underlying(i, j, inAmounts[k]);
            } else {
                outAmounts[k] = pool.get_dy(i, j, inAmounts[k]);
            }
        }
    }

    function swap(
        IEllipsisPool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        (IERC20[] memory tokens, bool underlying, ) = getPoolConfig(pool);

        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == -1 || j == -1) {
            return;
        }
        if (underlying && i != 0 && j != 0) {
            return;
        }

        inToken.universalApprove(address(pool), inAmount);
        if (underlying) {
            pool.exchange_underlying(i, j, inAmount, 0);
        } else {
            pool.exchange(i, j, inAmount, 0);
        }
    }

    function determineTokenIndex(
        IERC20 inToken,
        IERC20 outToken,
        IERC20[] memory tokens
    ) private pure returns (int128, int128) {
        int128 i = -1;
        int128 j = -1;
        for (uint256 k = 0; k < tokens.length; k++) {
            IERC20 token = tokens[k];
            if (inToken == token) {
                i = int128(k);
            }
            if (outToken == token) {
                j = int128(k);
            }
        }
        return (i, j);
    }

    /**
     * @notice Build calculation arguments.
     * See https://github.com/curvefi/curve-vue/blob/master/src/docs/README.md
     */
    function getPoolConfig(IEllipsisPool pool)
        private
        pure
        returns (
            IERC20[] memory tokens,
            bool underlying,
            uint256 gas
        )
    {
        if (pool == ELLIPSIS_USD) {
            tokens = new IERC20[](3);
            tokens[0] = Tokens.BUSD;
            tokens[1] = Tokens.USDC;
            tokens[2] = Tokens.USDT;
            underlying = false;
            gas = 720_000;
        } else if (pool == ELLIPSIS_FUSDT) {
            tokens = new IERC20[](4);
            tokens[0] = Tokens.fUSDT;
            tokens[1] = Tokens.BUSD;
            tokens[2] = Tokens.USDC;
            tokens[3] = Tokens.USDT;
            underlying = true;
            gas = 1_400_000;
        } else if (pool == ELLIPSIS_BTC) {
            tokens = new IERC20[](3);
            tokens[0] = Tokens.BTCB;
            tokens[1] = Tokens.RENBTC;
            underlying = false;
            gas = 720_000;
        }
    }
}

// File: @openzeppelin/contracts/math/Math.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// File: contracts/dexes/INerve.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;






/**
 * @notice  https://github.com/nerve-finance/contracts
 */
interface INerve {
    function calculateSwap(
        uint8 tokenIndexFrom,
        uint8 tokenIndexTo,
        uint256 dx
    ) external view returns (uint256);

    function swap(
        uint8 tokenIndexFrom,
        uint8 tokenIndexTo,
        uint256 dx,
        uint256 minDy,
        uint256 deadline
    ) external returns (uint256);
}

library INerveExtension {
    using UniversalERC20 for IERC20;

    INerve internal constant POOL3 = INerve(0x1B3771a66ee31180906972580adE9b81AFc5fCDc);
    INerve internal constant BTC = INerve(0x6C341938bB75dDe823FAAfe7f446925c66E6270c);
    INerve internal constant ETH = INerve(0x146CD24dCc9f4EB224DFd010c5Bf2b0D25aFA9C0);

    function calculateSwapReturn(
        INerve beltswap,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        IERC20[] memory tokens;
        bool underlying;
        (tokens, underlying, gas) = getPoolConfig(beltswap);

        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == -1 || j == -1) {
            return (outAmounts, 0);
        }
        if (underlying && i != 0 && j != 0) {
            return (outAmounts, 0);
        }

        for (uint256 k = 0; k < inAmounts.length; k++) {
            if (underlying) {
                outAmounts[k] = 0;
            } else {
                outAmounts[k] = beltswap.calculateSwap(uint8(i), uint8(j), inAmounts[k]);
            }
        }
    }

    function swap(
        INerve pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        (IERC20[] memory tokens, bool underlying, ) = getPoolConfig(pool);

        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == -1 || j == -1) {
            return;
        }
        if (underlying && i != 0 && j != 0) {
            return;
        }

        inToken.universalApprove(address(pool), inAmount);
        if (underlying) {
            // empty
        } else {
            pool.swap(uint8(i), uint8(j), inAmount, 0, block.timestamp + 3600);
        }
    }

    function determineTokenIndex(
        IERC20 inToken,
        IERC20 outToken,
        IERC20[] memory tokens
    ) private pure returns (int128, int128) {
        int128 i = -1;
        int128 j = -1;
        for (uint256 k = 0; k < tokens.length; k++) {
            IERC20 token = tokens[k];
            if (inToken == token) {
                i = int128(k);
            }
            if (outToken == token) {
                j = int128(k);
            }
        }
        return (i, j);
    }

    function getPoolConfig(INerve pool)
        private
        pure
        returns (
            IERC20[] memory tokens,
            bool underlying,
            uint256 gas
        )
    {
        if (pool == POOL3) {
            tokens = new IERC20[](3);
            tokens[0] = Tokens.BUSD;
            tokens[1] = Tokens.USDT;
            tokens[2] = Tokens.USDC;
            underlying = false;
            gas = 720_000;
        } else if (pool == BTC) {
            tokens = new IERC20[](2);
            tokens[0] = Tokens.BTCB;
            tokens[1] = IERC20(0x54261774905f3e6E9718f2ABb10ed6555cae308a); // anyBTC
            underlying = false;
            gas = 720_000;
        } else if (pool == ETH) {
            tokens = new IERC20[](2);
            tokens[0] = IERC20(0x2170Ed0880ac9A755fd29B2688956BD959F933F8); // ETH
            tokens[1] = IERC20(0x6F817a0cE8F7640Add3bC0c1C2298635043c2423); // anyETH
            underlying = false;
            gas = 720_000;
        }
    }
}

// File: contracts/dexes/IPancakeV2.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;






/**
 * @notice Uniswap V2 factory contract interface. See https://uniswap.org/docs/v2/smart-contracts/factory/
 */
interface IPancakeFactoryV2 {
    function getPair(IERC20 tokenA, IERC20 tokenB) external view returns (IPancakePairV2 pair);
}

/**
 * @notice Uniswap V2 pair pool interface. See https://uniswap.org/docs/v2/smart-contracts/pair/
 */
interface IPancakePairV2 {
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function skim(address to) external;

    function sync() external;
}

library IPancakePairExtensionV2 {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    address private constant SKIM_TARGET = 0xe523182610482b8C0DD65d5A08F1Bbd256B1EA0c;

    /**
     * @notice Use Uniswap's constant product formula to calculate expected swap return.
     * See https://github.com/runtimeverification/verified-smart-contracts/blob/uniswap/uniswap/x-y-k.pdf
     */
    function calculateSwapReturn(
        IPancakePairV2 pair,
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount
    ) internal view returns (uint256) {
        if (amount == 0) {
            return 0;
        }
        uint256 inReserve = inToken.universalBalanceOf(address(pair));
        uint256 outReserve = outToken.universalBalanceOf(address(pair));
        return doCalculate(inReserve, outReserve, amount);
    }

    function calculateRealSwapReturn(
        IPancakePairV2 pair,
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount
    ) internal returns (uint256) {
        uint256 inReserve = inToken.universalBalanceOf(address(pair));
        uint256 outReserve = outToken.universalBalanceOf(address(pair));

        (uint112 reserve0, uint112 reserve1, ) = pair.getReserves();
        if (inToken > outToken) {
            (reserve0, reserve1) = (reserve1, reserve0);
        }
        if (inReserve < reserve0 || outReserve < reserve1) {
            pair.sync();
        } else if (inReserve > reserve0 || outReserve > reserve1) {
            pair.skim(SKIM_TARGET);
        }

        return doCalculate(Math.min(inReserve, reserve0), Math.min(outReserve, reserve1), amount);
    }

    function doCalculate(
        uint256 inReserve,
        uint256 outReserve,
        uint256 amount
    ) private pure returns (uint256) {
        uint256 inAmountWithFee = amount.mul(9975);
        // Pancake now requires fixed 0.2% swap fee
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.mul(10000).add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}

library IPancakeFactoryExtensionV2 {
    using UniversalERC20 for IERC20;
    using IPancakePairExtensionV2 for IPancakePairV2;
    using Tokens for IERC20;

    function calculateSwapReturn(
        IPancakeFactoryV2 factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        IPancakePairV2 pair = factory.getPair(realInToken, realOutToken);
        if (pair != IPancakePairV2(0)) {
            for (uint256 i = 0; i < inAmounts.length; i++) {
                outAmounts[i] = pair.calculateSwapReturn(realInToken, realOutToken, inAmounts[i]);
            }
            return (outAmounts, 50_000);
        }
    }

    function calculateTransitionalSwapReturn(
        IPancakeFactoryV2 factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realTransitionToken = transitionToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();

        if (realInToken == realTransitionToken || realOutToken == realTransitionToken) {
            return (new uint256[](inAmounts.length), 0);
        }
        uint256 firstGas;
        uint256 secondGas;
        (outAmounts, firstGas) = calculateSwapReturn(factory, realInToken, realTransitionToken, inAmounts);
        (outAmounts, secondGas) = calculateSwapReturn(factory, realTransitionToken, realOutToken, outAmounts);
        return (outAmounts, firstGas + secondGas);
    }

    function swap(
        IPancakeFactoryV2 factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        IPancakePairV2 pair = factory.getPair(realInToken, realOutToken);

        outAmount = pair.calculateRealSwapReturn(realInToken, realOutToken, inAmount);

        realInToken.universalTransfer(address(pair), inAmount);
        if (uint256(address(realInToken)) < uint256(address(realOutToken))) {
            pair.swap(0, outAmount, address(this), "");
        } else {
            pair.swap(outAmount, 0, address(this), "");
        }

        outToken.withdrawFromWETH();
    }

    function swapTransitional(
        IPancakeFactoryV2 factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
    }
}

// File: contracts/dexes/IPancakeBunny.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;







interface IZapBsc {
    function zapInToken(
        address _from,
        uint256 amount,
        address _to
    ) external;
}

interface IPancakeRouter02 {
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external view returns (uint256 amountOut);
}

library IZapBscExtension {
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;

    IPancakeRouter02 private constant ROUTER = IPancakeRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
    IPancakeFactoryV2 private constant pancakeFactory = IPancakeFactoryV2(0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73);

    function calculateSwapReturn(
        IZapBsc _zap,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        _zap;
        outAmounts = new uint256[](inAmounts.length);
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        IPancakePairV2 pair = pancakeFactory.getPair(realInToken, realOutToken);
        if (address(pair) != address(0)) {
            uint256 inBalance = realInToken.balanceOf(address(pair));
            uint256 outBalance = realOutToken.balanceOf(address(pair));
            for (uint256 i = 0; i < inAmounts.length; i++) {
                outAmounts[i] = ROUTER.getAmountOut(inAmounts[i], inBalance, outBalance);
            }
            return (outAmounts, 50_000);
        }
    }

    function calculateRealSwapReturn(
        IZapBsc _zap,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal view returns (uint256 outAmount, uint256 gas) {
        _zap;
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        IPancakePairV2 pair = pancakeFactory.getPair(realInToken, realOutToken);
        if (address(pair) != address(0)) {
            uint256 inBalance = realInToken.balanceOf(address(pair));
            uint256 outBalance = realOutToken.balanceOf(address(pair));
            outAmount = ROUTER.getAmountOut(inAmount, inBalance, outBalance);
            return (outAmount, 50_000);
        }
    }

    function calculateTransitionalSwapReturn(
        IZapBsc zap,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realTransitionToken = transitionToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();

        if (realInToken == realTransitionToken || realOutToken == realTransitionToken) {
            return (new uint256[](inAmounts.length), 0);
        }
        uint256 firstGas;
        uint256 secondGas;
        (outAmounts, firstGas) = calculateSwapReturn(zap, realInToken, realTransitionToken, inAmounts);
        (outAmounts, secondGas) = calculateSwapReturn(zap, realTransitionToken, realOutToken, outAmounts);
        return (outAmounts, firstGas + secondGas);
    }

    function swap(
        IZapBsc factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();

        (outAmount, ) = calculateRealSwapReturn(factory, inToken, outToken, inAmount);
        realInToken.approve(address(factory), inAmount);
        factory.zapInToken(address(realInToken), inAmount, address(realOutToken));
        uint256 res = realOutToken.balanceOf(address(this));
        require(res >= outAmount, "swap outToken is low");
        realOutToken.withdrawFromWETH();
    }

    function swapTransitional(
        IZapBsc factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
    }
}

// File: contracts/dexes/IUniswapV2Like.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;






/**
 * @notice Uniswap V2 factory contract interface. See https://uniswap.org/docs/v2/smart-contracts/factory/
 */
interface IUniswapV2LikeFactory {
    function getPair(IERC20 tokenA, IERC20 tokenB) external view returns (address pair);

    /**
     * @notice Mdex factory function
     */
    function getPairFees(address) external view returns (uint256);
}

/**
 * @notice Uniswap V2 pair pool interface. See https://uniswap.org/docs/v2/smart-contracts/pair/
 */
interface IUniswapV2LikePair {
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function skim(address to) external;

    function sync() external;
}

interface IBakeryPair is IUniswapV2LikePair {
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to
    ) external;
}

interface IBiswapPair is IUniswapV2LikePair {
    function swapFee() external view returns (uint32);
}

library IUniswapV2LikePairExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    address private constant SKIM_TARGET = 0xe523182610482b8C0DD65d5A08F1Bbd256B1EA0c;

    /**
     * @notice Use Uniswap's constant product formula to calculate expected swap return.
     * See https://github.com/runtimeverification/verified-smart-contracts/blob/uniswap/uniswap/x-y-k.pdf
     */
    function calculateSwapReturn(
        IUniswapV2LikePair pair,
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount,
        uint48 feeNumerator,
        uint48 feeDenominator
    ) internal view returns (uint256) {
        if (amount == 0) {
            return 0;
        }
        uint256 inReserve = inToken.universalBalanceOf(address(pair));
        uint256 outReserve = outToken.universalBalanceOf(address(pair));
        return doCalculate(inReserve, outReserve, amount, feeNumerator, feeDenominator);
    }

    function calculateRealSwapReturn(
        IUniswapV2LikePair pair,
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount,
        uint48 feeNumerator,
        uint48 feeDenominator
    ) internal returns (uint256) {
        uint256 inReserve = inToken.universalBalanceOf(address(pair));
        uint256 outReserve = outToken.universalBalanceOf(address(pair));

        (uint112 reserve0, uint112 reserve1, ) = pair.getReserves();
        if (inToken > outToken) {
            (reserve0, reserve1) = (reserve1, reserve0);
        }
        if (inReserve < reserve0 || outReserve < reserve1) {
            pair.sync();
        } else if (inReserve > reserve0 || outReserve > reserve1) {
            pair.skim(SKIM_TARGET);
        }

        return doCalculate(Math.min(inReserve, reserve0), Math.min(outReserve, reserve1), amount, feeNumerator, feeDenominator);
    }

    function doCalculate(
        uint256 inReserve,
        uint256 outReserve,
        uint256 amount,
        uint48 feeNumerator,
        uint48 feeDenominator
    ) private pure returns (uint256) {
        uint256 inAmountWithFee = amount.mul(feeDenominator - feeNumerator); // Uniswap V2 now requires fixed 0.3% swap fee
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.mul(feeDenominator).add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}

library IUniswapV2LikeFactories {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using IUniswapV2LikePairExtension for IUniswapV2LikePair;
    using Tokens for IERC20;

    uint256 internal constant PANCAKE = (2 << 208) | (1000 << 160) | uint256(address(0xBCfCcbde45cE874adCB698cC183deBcF17952812));
    uint256 internal constant PANCAKE_V2 =
        (25 << 208) | (10000 << 160) | uint256(address(0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73));
    uint256 internal constant BAKERY = (3 << 208) | (1000 << 160) | uint256(address(0x01bF7C66c6BD861915CdaaE475042d3c4BaE16A7));
    uint256 internal constant HYPER_JUMP =
        (3 << 208) | (1000 << 160) | uint256(address(0xaC653cE27E04C6ac565FD87F18128aD33ca03Ba2));
    uint256 internal constant IMPOSSIBLE =
        (6 << 208) | (10000 << 160) | uint256(address(0x918d7e714243F7d9d463C37e106235dCde294ffC));
    uint256 internal constant JULSWAP = (3 << 208) | (1000 << 160) | uint256(address(0x553990F2CBA90272390f62C5BDb1681fFc899675));
    uint256 internal constant APESWAP = (2 << 208) | (1000 << 160) | uint256(address(0x0841BD0B734E4F5853f0dD8d7Ea041c241fb0Da6));
    uint256 internal constant MDEX = (30 << 208) | (10000 << 160) | uint256(address(0x3CD1C46068dAEa5Ebb0d3f55F6915B10648062B8));
    uint256 internal constant CAFESWAP = (2 << 208) | (1000 << 160) | uint256(address(0x3e708FdbE3ADA63fc94F8F61811196f1302137AD));
    uint256 internal constant PANTHERSWAP =
        (2 << 208) | (1000 << 160) | uint256(address(0x670f55c6284c629c23baE99F585e3f17E8b9FC31));
    uint256 internal constant INNOSWAP = (2 << 208) | (1000 << 160) | uint256(address(0xd76d8C2A7CA0a1609Aea0b9b5017B3F7782891bf));
    uint256 internal constant WAULTSWAP = (2 << 208) | (1000 << 160) | uint256(address(0xB42E3FE71b7E0673335b3331B3e1053BD9822570));
    uint256 internal constant BABYSWAP = (2 << 208) | (1000 << 160) | uint256(address(0x86407bEa2078ea5f5EB5A52B2caA963bC1F889Da));
    uint256 internal constant BISWAP = (1 << 208) | (1000 << 160) | uint256(address(0x858E3312ed3A876947EA49d572A7C42DE08af7EE));

    function calculateSwapReturn(
        uint256 factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();

        (address factoryAddr, uint48 feeNumerator, uint48 feeDenominator) = decodeFactory(factory);

        address pair = IUniswapV2LikeFactory(factoryAddr).getPair(realInToken, realOutToken);
        if (pair != address(0)) {
            if (factory == MDEX) {
                feeNumerator = uint48(IUniswapV2LikeFactory(factoryAddr).getPairFees(pair));
            } else if (factory == BISWAP) {
                feeNumerator = IBiswapPair(pair).swapFee();
            }
            for (uint256 i = 0; i < inAmounts.length; i++) {
                outAmounts[i] = IUniswapV2LikePair(pair).calculateSwapReturn(
                    realInToken,
                    realOutToken,
                    inAmounts[i],
                    feeNumerator,
                    feeDenominator
                );
            }
            return (outAmounts, 50_000);
        }
    }

    function calculateTransitionalSwapReturn(
        uint256 factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realTransitionToken = transitionToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();

        if (realInToken == realTransitionToken || realOutToken == realTransitionToken) {
            return (new uint256[](inAmounts.length), 0);
        }
        uint256 firstGas;
        uint256 secondGas;
        (outAmounts, firstGas) = calculateSwapReturn(factory, realInToken, realTransitionToken, inAmounts);
        (outAmounts, secondGas) = calculateSwapReturn(factory, realTransitionToken, realOutToken, outAmounts);
        return (outAmounts, firstGas + secondGas);
    }

    function swap(
        uint256 factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();

        (address factoryAddr, uint48 feeNumerator, uint48 feeDenominator) = decodeFactory(factory);
        address pair = IUniswapV2LikeFactory(factoryAddr).getPair(realInToken, realOutToken);
        if (factory == MDEX) {
            feeNumerator = uint48(IUniswapV2LikeFactory(factoryAddr).getPairFees(pair));
        } else if (factory == BISWAP) {
            feeNumerator = IBiswapPair(pair).swapFee();
        }
        outAmount = IUniswapV2LikePair(pair).calculateRealSwapReturn(
            realInToken,
            realOutToken,
            inAmount,
            feeNumerator,
            feeDenominator
        );

        realInToken.universalTransfer(address(pair), inAmount);
        if (factory == BAKERY) {
            if (uint256(address(realInToken)) < uint256(address(realOutToken))) {
                IBakeryPair(pair).swap(0, outAmount, address(this));
            } else {
                IBakeryPair(pair).swap(outAmount, 0, address(this));
            }
        } else {
            if (uint256(address(realInToken)) < uint256(address(realOutToken))) {
                IUniswapV2LikePair(pair).swap(0, outAmount, address(this), "");
            } else {
                IUniswapV2LikePair(pair).swap(outAmount, 0, address(this), "");
            }
        }

        outToken.withdrawFromWETH();
    }

    function swapTransitional(
        uint256 factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
    }

    function decodeFactory(uint256 factory)
        private
        pure
        returns (
            address factoryAddr,
            uint48 feeNumerator,
            uint48 feeDenominator
        )
    {
        factoryAddr = address(factory);
        uint96 fee = uint96(factory >> 160);
        feeNumerator = uint48(fee >> 48);
        feeDenominator = uint48(fee);
    }
}

// File: contracts/dexes/Dexes.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;






// import "./IBurger.sol";
// import "./IUnifi.sol";


// import "./IDODO.sol";



// import "./IBeltswap.sol";



enum Dex {
    // Pancake
    Pancake,
    PancakeETH,
    PancakeDAI,
    PancakeUSDC,
    PancakeUSDT,
    // Bakery
    Bakery,
    BakeryETH,
    BakeryDAI,
    BakeryUSDC,
    BakeryUSDT,
    // Burger
    Burger,
    BurgerETH,
    BurgerDGAS,
    // Thugswap
    Thugswap,
    ThugswapETH,
    ThugswapDAI,
    ThugswapUSDC,
    ThugswapUSDT,
    // BUSD transitional
    PancakeBUSD,
    BakeryBUSD,
    ThugswapBUSD,
    // StableX
    Stablex,
    StablexDAI,
    StablexBUSD,
    StablexQUSD,
    StablexUSDC,
    StablexUSDT,
    // Unifi
    Unifi,
    // WETH
    WETH,
    // Julswap
    Julswap,
    JulswapETH,
    JulswapDAI,
    JulswapUSDC,
    JulswapUSDT,
    JulswapBUSD,
    // Pancake DOT
    PancakeDOT,
    // Acrytos
    Acryptos,
    AcryptosUSD,
    AcryptosVAI,
    AcryptosUST,
    AcryptosQUSD,
    // Apeswap
    Apeswap,
    ApeswapETH,
    ApeswapUSDT,
    ApeswapBUSD,
    ApeswapBANANA,
    // DODO
    DODO,
    DODOUSDC,
    DODOUSDT,
    // Smoothy
    Smoothy,
    // Acryptos
    AcryptosBTC,
    // Ellipsis
    Ellipsis,
    EllipsisUSD,
    EllipsisBTC,
    EllipsisFUSDT,
    // MDex
    MDex,
    MDexETH,
    MDexBUSD,
    MDexUSDC,
    MDexUSDT,
    // PancakeV2
    PancakeV2,
    PancakeETHV2,
    PancakeUSDCV2,
    PancakeUSDTV2,
    PancakeBUSDV2,
    PancakeDOTV2,
    // Nerve
    Nerve,
    NervePOOL3,
    NerveBTC,
    NerveETH,
    Cafeswap,
    PantherSwap,
    PancakeBunny,
    // Beltswap,
    // add Mooniswap
    Mooniswap,
    MooniswapETH,
    MooniswapDAI,
    MooniswapUSDC,
    // Innoswap
    Innoswap,
    // WaultSwap
    Waultswap,
    // Babyswap
    Babyswap,
    // Biswap
    Biswap,
    BiswapBNB,
    BiswapBUSD,
    // bottom mark
    NoDex
}

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;
    using IUniswapV2LikeFactories for uint256;

    IZapBsc internal constant zap = IZapBsc(0xdC2bBB0D33E0e7Dea9F5b98F46EDBaC823586a0C);
    using IZapBscExtension for IZapBsc;

    // 1inch
    // 0xbAF9A5d4b0052359326A6CDAb54BABAa3a3A9643 --> 0xD41B24bbA51fAc0E4827b6F94C0D6DDeB183cD64
    IMooniswapRegistry internal constant mooniswap = IMooniswapRegistry(0xD41B24bbA51fAc0E4827b6F94C0D6DDeB183cD64);
    using IMooniswapRegistryExtension for IMooniswapRegistry;

    // IDemaxPlatform internal constant burger = IDemaxPlatform(0xBf6527834dBB89cdC97A79FCD62E6c08B19F8ec0);
    // using IDemaxPlatformExtension for IDemaxPlatform;

    // IUnifiTradeRegistry internal constant unifi = IUnifiTradeRegistry(0xFD4B5179B535df687e0861cDF86E9CCAB50E5A51);
    // using IUnifiTradeRegistryExtenstion for IUnifiTradeRegistry;

    IWETH internal constant weth = IWETH(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    using IWETHExtension for IWETH;

    using IAcryptosPoolExtension for IAcryptosPool;

    // IDODOZoo internal constant dodo = IDODOZoo(0xCA459456a45e300AA7EF447DBB60F87CCcb42828);
    // using IDODOZooExtension for IDODOZoo;

    ISmoothy internal constant smoothy = ISmoothy(0xe5859f4EFc09027A9B718781DCb2C6910CAc6E91);
    using ISmoothyExtension for ISmoothy;

    using IEllipsisPoolExtension for IEllipsisPool;

    using INerveExtension for INerve;

    // using IBeltSwapExtension for IBeltSwap;

    function allDexes() internal pure returns (Dex[] memory dexes) {
        uint256 dexCount = uint256(Dex.NoDex);
        dexes = new Dex[](dexCount);
        for (uint256 i = 0; i < dexCount; i++) {
            dexes[i] = Dex(i);
        }
    }

    function calculateSwapReturn(
        Dex dex,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts,
        uint256 flags
    ) internal view returns (uint256[] memory, uint256) {
        // Babyswap
        if (dex == Dex.Babyswap && !flags.on(Flags.FLAG_DISABLE_BABYSWAP_ALL)) {
            return IUniswapV2LikeFactories.BABYSWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Waultswap
        if (dex == Dex.Waultswap && !flags.on(Flags.FLAG_DISABLE_WAULTSWAP_ALL)) {
            return IUniswapV2LikeFactories.WAULTSWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Innoswap
        if (dex == Dex.Innoswap && !flags.on(Flags.FLAG_DISABLE_INNOSWAP_ALL)) {
            return IUniswapV2LikeFactories.INNOSWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // PancakeBunny
        if (dex == Dex.PancakeBunny && !flags.on(Flags.FLAG_DISABLE_ZAPBSC)) {
            return zap.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Pantherswap
        if (dex == Dex.PantherSwap && !flags.or(Flags.FLAG_DISABLE_PANTHERSWAP_ALL, Flags.FLAG_DISABLE_PANTHERSWAP)) {
            return IUniswapV2LikeFactories.PANTHERSWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // 1inch
        if (dex == Dex.Mooniswap && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP)) {
            return mooniswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.MooniswapETH && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_ETH)) {
            return mooniswap.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.MooniswapDAI && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_DAI)) {
            return mooniswap.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.MooniswapUSDC && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_USDC)) {
            return mooniswap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }

        // Pancake
        if (dex == Dex.Pancake && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE)) {
            return IUniswapV2LikeFactories.PANCAKE.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.PancakeETH && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_ETH)) {
            return IUniswapV2LikeFactories.PANCAKE.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.PancakeDAI && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_DAI)) {
            return IUniswapV2LikeFactories.PANCAKE.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.PancakeUSDC && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_USDC)) {
            return IUniswapV2LikeFactories.PANCAKE.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.PancakeUSDT && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_USDT)) {
            return IUniswapV2LikeFactories.PANCAKE.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.PancakeBUSD && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_BUSD)) {
            return IUniswapV2LikeFactories.PANCAKE.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }
        if (dex == Dex.PancakeDOT && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_DOT)) {
            return IUniswapV2LikeFactories.PANCAKE.calculateTransitionalSwapReturn(inToken, Tokens.DOT, outToken, inAmounts);
        }

        // Bakery
        if (dex == Dex.Bakery && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY)) {
            return IUniswapV2LikeFactories.BAKERY.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.BakeryETH && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_ETH)) {
            return IUniswapV2LikeFactories.BAKERY.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.BakeryDAI && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_DAI)) {
            return IUniswapV2LikeFactories.BAKERY.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.BakeryUSDC && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_USDC)) {
            return IUniswapV2LikeFactories.BAKERY.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.BakeryUSDT && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_USDT)) {
            return IUniswapV2LikeFactories.BAKERY.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.BakeryBUSD && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_BUSD)) {
            return IUniswapV2LikeFactories.BAKERY.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }

        // Burger
        // if (dex == Dex.Burger && !flags.or(Flags.FLAG_DISABLE_BURGER_ALL, Flags.FLAG_DISABLE_BURGER)) {
        //     return burger.calculateSwapReturn(inToken, outToken, inAmounts);
        // }
        // if (dex == Dex.BurgerETH && !flags.or(Flags.FLAG_DISABLE_BURGER_ALL, Flags.FLAG_DISABLE_BURGER_ETH)) {
        //     return burger.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        // }
        // if (dex == Dex.BurgerDGAS && !flags.or(Flags.FLAG_DISABLE_BURGER_ALL, Flags.FLAG_DISABLE_BURGER_DGAS)) {
        //     return burger.calculateTransitionalSwapReturn(inToken, Tokens.DGAS, outToken, inAmounts);
        // }

        // Thugswap
        if (dex == Dex.Thugswap && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP)) {
            return IUniswapV2LikeFactories.HYPER_JUMP.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapETH && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_ETH)) {
            return IUniswapV2LikeFactories.HYPER_JUMP.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapDAI && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_DAI)) {
            return IUniswapV2LikeFactories.HYPER_JUMP.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapUSDC && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_USDC)) {
            return IUniswapV2LikeFactories.HYPER_JUMP.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapUSDT && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_USDT)) {
            return IUniswapV2LikeFactories.HYPER_JUMP.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.ThugswapBUSD && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_BUSD)) {
            return IUniswapV2LikeFactories.HYPER_JUMP.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }

        // Stablex
        if (dex == Dex.Stablex && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX)) {
            return IUniswapV2LikeFactories.IMPOSSIBLE.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.StablexQUSD && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_QUSD)) {
            return IUniswapV2LikeFactories.IMPOSSIBLE.calculateTransitionalSwapReturn(inToken, Tokens.QUSD, outToken, inAmounts);
        }
        if (dex == Dex.StablexDAI && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_DAI)) {
            return IUniswapV2LikeFactories.IMPOSSIBLE.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.StablexUSDC && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_USDC)) {
            return IUniswapV2LikeFactories.IMPOSSIBLE.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.StablexUSDT && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_USDT)) {
            return IUniswapV2LikeFactories.IMPOSSIBLE.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.StablexBUSD && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_BUSD)) {
            return IUniswapV2LikeFactories.IMPOSSIBLE.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }

        // Unifi
        // if (dex == Dex.Unifi && !flags.or(Flags.FLAG_DISABLE_UNIFI_ALL, Flags.FLAG_DISABLE_UNIFI)) {
        //     return unifi.calculateSwapReturn(inToken, outToken, inAmounts);
        // }

        // WETH
        if (dex == Dex.WETH && !flags.on(Flags.FLAG_DISABLE_WETH)) {
            return weth.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Julswap
        if (dex == Dex.Julswap && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP)) {
            return IUniswapV2LikeFactories.JULSWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.JulswapETH && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_ETH)) {
            return IUniswapV2LikeFactories.JULSWAP.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.JulswapDAI && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_DAI)) {
            return IUniswapV2LikeFactories.JULSWAP.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.JulswapUSDC && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_USDC)) {
            return IUniswapV2LikeFactories.JULSWAP.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.JulswapUSDT && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_USDT)) {
            return IUniswapV2LikeFactories.JULSWAP.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.JulswapBUSD && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_BUSD)) {
            return IUniswapV2LikeFactories.JULSWAP.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }

        // Acryptos
        if (dex == Dex.AcryptosUSD && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_USD)) {
            return IAcryptosPoolExtension.ACRYPTOS_USD.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.AcryptosVAI && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_VAI)) {
            return IAcryptosPoolExtension.ACRYPTOS_VAI.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.AcryptosUST && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_UST)) {
            return IAcryptosPoolExtension.ACRYPTOS_UST.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.AcryptosQUSD && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_QUSD)) {
            return IAcryptosPoolExtension.ACRYPTOS_QUSD.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.AcryptosBTC && !flags.on(Flags.FLAG_DISABLE_ACRYPTOS_ALL)) {
            return IAcryptosPoolExtension.ACRYPTOS_BTC.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Apeswap
        if (dex == Dex.Apeswap && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP)) {
            return IUniswapV2LikeFactories.APESWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.ApeswapETH && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_ETH)) {
            return IUniswapV2LikeFactories.APESWAP.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.ApeswapBANANA && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_BANANA)) {
            return IUniswapV2LikeFactories.APESWAP.calculateTransitionalSwapReturn(inToken, Tokens.BANANA, outToken, inAmounts);
        }
        if (dex == Dex.ApeswapUSDT && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_USDT)) {
            return IUniswapV2LikeFactories.APESWAP.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.ApeswapBUSD && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_BUSD)) {
            return IUniswapV2LikeFactories.APESWAP.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }

        // add DODO
        // if (dex == Dex.DODO && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO)) {
        //     return dodo.calculateSwapReturn(inToken, outToken, inAmounts);
        // }
        // if (dex == Dex.DODOUSDC && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO_USDC)) {
        //     return dodo.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        // }
        // if (dex == Dex.DODOUSDT && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO_USDT)) {
        //     return dodo.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        // }

        // add Smoothy
        if (dex == Dex.Smoothy && !flags.on(Flags.FLAG_DISABLE_SMOOTHY)) {
            return smoothy.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // add Ellipsis
        if (dex == Dex.EllipsisUSD && !flags.on(Flags.FLAG_DISABLE_ELLIPSIS)) {
            return IEllipsisPoolExtension.ELLIPSIS_USD.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.EllipsisBTC && !flags.on(Flags.FLAG_DISABLE_ELLIPSIS)) {
            return IEllipsisPoolExtension.ELLIPSIS_BTC.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.EllipsisFUSDT && !flags.on(Flags.FLAG_DISABLE_ELLIPSIS)) {
            return IEllipsisPoolExtension.ELLIPSIS_FUSDT.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // add MDex
        if (dex == Dex.MDex && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX)) {
            return IUniswapV2LikeFactories.MDEX.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.MDexETH && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_ETH)) {
            return IUniswapV2LikeFactories.MDEX.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.MDexUSDC && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_USDC)) {
            return IUniswapV2LikeFactories.MDEX.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.MDexUSDT && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_USDT)) {
            return IUniswapV2LikeFactories.MDEX.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.MDexBUSD && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_BUSD)) {
            return IUniswapV2LikeFactories.MDEX.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }

        // PancakeV2
        if (dex == Dex.PancakeV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_V2)) {
            return IUniswapV2LikeFactories.PANCAKE_V2.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.PancakeETHV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_ETH_V2)) {
            return IUniswapV2LikeFactories.PANCAKE_V2.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.PancakeUSDCV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_USDC_V2)) {
            return IUniswapV2LikeFactories.PANCAKE_V2.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.PancakeUSDTV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_USDT_V2)) {
            return IUniswapV2LikeFactories.PANCAKE_V2.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }
        if (dex == Dex.PancakeBUSDV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_BUSD_V2)) {
            return IUniswapV2LikeFactories.PANCAKE_V2.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }
        if (dex == Dex.PancakeDOTV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_DOT_V2)) {
            return IUniswapV2LikeFactories.PANCAKE_V2.calculateTransitionalSwapReturn(inToken, Tokens.DOT, outToken, inAmounts);
        }

        // Nerve
        if (dex == Dex.NervePOOL3 && !flags.or(Flags.FLAG_DISABLE_NERVE_ALL, Flags.FLAG_DISABLE_NERVE_POOL3)) {
            return INerveExtension.POOL3.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.NerveBTC && !flags.or(Flags.FLAG_DISABLE_NERVE_ALL, Flags.FLAG_DISABLE_NERVE_BTC)) {
            return INerveExtension.BTC.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.NerveETH && !flags.or(Flags.FLAG_DISABLE_NERVE_ALL, Flags.FLAG_DISABLE_NERVE_ETH)) {
            return INerveExtension.ETH.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Cafeswap
        if (dex == Dex.Cafeswap && !flags.on(Flags.FLAG_DISABLE_CAFESWAP_ALL)) {
            return IUniswapV2LikeFactories.CAFESWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }

        // Beltswap
        // if (dex == Dex.Beltswap && !flags.on(Flags.FLAG_DISABLE_BELTSWAP_ALL)) {
        //     return IBeltSwapExtension.BELT4.calculateSwapReturn(inToken, outToken, inAmounts);
        // }

        // Biswap
        if (dex == Dex.Biswap && !flags.on(Flags.FLAG_DISABLE_BISWAP_ALL)) {
            return IUniswapV2LikeFactories.BISWAP.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.BiswapBNB && !flags.on(Flags.FLAG_DISABLE_BISWAP_ALL)) {
            return IUniswapV2LikeFactories.BISWAP.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.BiswapBUSD && !flags.on(Flags.FLAG_DISABLE_BISWAP_ALL)) {
            return IUniswapV2LikeFactories.BISWAP.calculateTransitionalSwapReturn(inToken, Tokens.BUSD, outToken, inAmounts);
        }

        // fallback
        return (new uint256[](inAmounts.length), 0);
    }

    function swap(
        Dex dex,
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount,
        uint256 flags
    ) internal {
        // Babyswap
        if (dex == Dex.Babyswap && !flags.on(Flags.FLAG_DISABLE_BABYSWAP_ALL)) {
            IUniswapV2LikeFactories.BABYSWAP.swap(inToken, outToken, amount);
        }

        // WaultSwap
        if (dex == Dex.Waultswap && !flags.on(Flags.FLAG_DISABLE_WAULTSWAP_ALL)) {
            IUniswapV2LikeFactories.WAULTSWAP.swap(inToken, outToken, amount);
        }

        // Innoswap
        if (dex == Dex.Innoswap && !flags.on(Flags.FLAG_DISABLE_INNOSWAP_ALL)) {
            IUniswapV2LikeFactories.INNOSWAP.swap(inToken, outToken, amount);
        }

        // PancakeBunny
        if (dex == Dex.PancakeBunny && !flags.on(Flags.FLAG_DISABLE_ZAPBSC)) {
            zap.swap(inToken, outToken, amount);
        }

        // PantherSwap
        if (dex == Dex.PantherSwap && !flags.or(Flags.FLAG_DISABLE_PANTHERSWAP_ALL, Flags.FLAG_DISABLE_PANTHERSWAP)) {
            IUniswapV2LikeFactories.PANTHERSWAP.swap(inToken, outToken, amount);
        }

        // 1inch
        if (dex == Dex.Mooniswap && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP)) {
            mooniswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.MooniswapETH && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_ETH)) {
            mooniswap.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.MooniswapETH && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_DAI)) {
            mooniswap.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.MooniswapETH && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_USDC)) {
            mooniswap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }

        // Pancake
        if (dex == Dex.Pancake && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE)) {
            IUniswapV2LikeFactories.PANCAKE.swap(inToken, outToken, amount);
        }
        if (dex == Dex.PancakeETH && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_ETH)) {
            IUniswapV2LikeFactories.PANCAKE.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.PancakeDAI && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_DAI)) {
            IUniswapV2LikeFactories.PANCAKE.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.PancakeUSDC && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_USDC)) {
            IUniswapV2LikeFactories.PANCAKE.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.PancakeUSDT && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_USDT)) {
            IUniswapV2LikeFactories.PANCAKE.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.PancakeBUSD && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_BUSD)) {
            IUniswapV2LikeFactories.PANCAKE.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }
        if (dex == Dex.PancakeDOT && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL, Flags.FLAG_DISABLE_PANCAKE_DOT)) {
            IUniswapV2LikeFactories.PANCAKE.swapTransitional(inToken, Tokens.DOT, outToken, amount);
        }

        // Bakery
        if (dex == Dex.Bakery && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY)) {
            IUniswapV2LikeFactories.BAKERY.swap(inToken, outToken, amount);
        }
        if (dex == Dex.BakeryETH && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_ETH)) {
            IUniswapV2LikeFactories.BAKERY.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.BakeryDAI && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_DAI)) {
            IUniswapV2LikeFactories.BAKERY.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.BakeryUSDC && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_USDC)) {
            IUniswapV2LikeFactories.BAKERY.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.BakeryUSDT && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_USDT)) {
            IUniswapV2LikeFactories.BAKERY.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.BakeryBUSD && !flags.or(Flags.FLAG_DISABLE_BAKERY_ALL, Flags.FLAG_DISABLE_BAKERY_BUSD)) {
            IUniswapV2LikeFactories.BAKERY.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }

        // Burger
        // if (dex == Dex.Burger && !flags.or(Flags.FLAG_DISABLE_BURGER_ALL, Flags.FLAG_DISABLE_BURGER)) {
        //     burger.swap(inToken, outToken, amount);
        // }
        // if (dex == Dex.BurgerETH && !flags.or(Flags.FLAG_DISABLE_BURGER_ALL, Flags.FLAG_DISABLE_BURGER_ETH)) {
        //     burger.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        // }
        // if (dex == Dex.BurgerDGAS && !flags.or(Flags.FLAG_DISABLE_BURGER_ALL, Flags.FLAG_DISABLE_BURGER_DGAS)) {
        //     burger.swapTransitional(inToken, Tokens.DGAS, outToken, amount);
        // }

        // Thugswap
        if (dex == Dex.Thugswap && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP)) {
            IUniswapV2LikeFactories.HYPER_JUMP.swap(inToken, outToken, amount);
        }
        if (dex == Dex.ThugswapETH && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_ETH)) {
            IUniswapV2LikeFactories.HYPER_JUMP.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.ThugswapDAI && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_DAI)) {
            IUniswapV2LikeFactories.HYPER_JUMP.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.ThugswapUSDC && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_USDC)) {
            IUniswapV2LikeFactories.HYPER_JUMP.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.ThugswapUSDT && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_USDT)) {
            IUniswapV2LikeFactories.HYPER_JUMP.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.ThugswapBUSD && !flags.or(Flags.FLAG_DISABLE_THUGSWAP_ALL, Flags.FLAG_DISABLE_THUGSWAP_BUSD)) {
            IUniswapV2LikeFactories.HYPER_JUMP.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }

        // Stablex
        if (dex == Dex.Stablex && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX)) {
            IUniswapV2LikeFactories.IMPOSSIBLE.swap(inToken, outToken, amount);
        }
        if (dex == Dex.StablexQUSD && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_QUSD)) {
            IUniswapV2LikeFactories.IMPOSSIBLE.swapTransitional(inToken, Tokens.QUSD, outToken, amount);
        }
        if (dex == Dex.StablexDAI && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_DAI)) {
            IUniswapV2LikeFactories.IMPOSSIBLE.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.StablexUSDC && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_USDC)) {
            IUniswapV2LikeFactories.IMPOSSIBLE.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.StablexUSDT && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_USDT)) {
            IUniswapV2LikeFactories.IMPOSSIBLE.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.StablexBUSD && !flags.or(Flags.FLAG_DISABLE_STABLEX_ALL, Flags.FLAG_DISABLE_STABLEX_BUSD)) {
            IUniswapV2LikeFactories.IMPOSSIBLE.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }

        // Unifi
        // if (dex == Dex.Unifi && !flags.or(Flags.FLAG_DISABLE_UNIFI_ALL, Flags.FLAG_DISABLE_UNIFI)) {
        //     unifi.swap(inToken, outToken, amount);
        // }

        // WETH
        if (dex == Dex.WETH && !flags.on(Flags.FLAG_DISABLE_WETH)) {
            weth.swap(inToken, outToken, amount);
        }

        // Julswap
        if (dex == Dex.Julswap && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP)) {
            IUniswapV2LikeFactories.JULSWAP.swap(inToken, outToken, amount);
        }
        if (dex == Dex.JulswapETH && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_ETH)) {
            IUniswapV2LikeFactories.JULSWAP.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.JulswapDAI && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_DAI)) {
            IUniswapV2LikeFactories.JULSWAP.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.JulswapUSDC && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_USDC)) {
            IUniswapV2LikeFactories.JULSWAP.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.JulswapUSDT && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_USDT)) {
            IUniswapV2LikeFactories.JULSWAP.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.JulswapBUSD && !flags.or(Flags.FLAG_DISABLE_JULSWAP_ALL, Flags.FLAG_DISABLE_JULSWAP_BUSD)) {
            IUniswapV2LikeFactories.JULSWAP.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }

        // Acryptos
        if (dex == Dex.AcryptosUSD && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_USD)) {
            IAcryptosPoolExtension.ACRYPTOS_USD.swap(inToken, outToken, amount);
        }
        if (dex == Dex.AcryptosVAI && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_VAI)) {
            IAcryptosPoolExtension.ACRYPTOS_VAI.swap(inToken, outToken, amount);
        }
        if (dex == Dex.AcryptosUST && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_UST)) {
            IAcryptosPoolExtension.ACRYPTOS_UST.swap(inToken, outToken, amount);
        }
        if (dex == Dex.AcryptosQUSD && !flags.or(Flags.FLAG_DISABLE_ACRYPTOS_ALL, Flags.FLAG_DISABLE_ACRYPTOS_QUSD)) {
            IAcryptosPoolExtension.ACRYPTOS_QUSD.swap(inToken, outToken, amount);
        }
        if (dex == Dex.AcryptosBTC && !flags.on(Flags.FLAG_DISABLE_ACRYPTOS_ALL)) {
            IAcryptosPoolExtension.ACRYPTOS_BTC.swap(inToken, outToken, amount);
        }

        // Apeswap
        if (dex == Dex.Apeswap && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP)) {
            IUniswapV2LikeFactories.APESWAP.swap(inToken, outToken, amount);
        }
        if (dex == Dex.ApeswapETH && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_ETH)) {
            IUniswapV2LikeFactories.APESWAP.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.ApeswapBANANA && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_BANANA)) {
            IUniswapV2LikeFactories.APESWAP.swapTransitional(inToken, Tokens.BANANA, outToken, amount);
        }
        if (dex == Dex.ApeswapUSDT && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_USDT)) {
            IUniswapV2LikeFactories.APESWAP.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.ApeswapBUSD && !flags.or(Flags.FLAG_DISABLE_APESWAP_ALL, Flags.FLAG_DISABLE_APESWAP_BUSD)) {
            IUniswapV2LikeFactories.APESWAP.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }

        // add DODO
        // if (dex == Dex.DODO && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO)) {
        //     dodo.swap(inToken, outToken, amount);
        // }
        // if (dex == Dex.DODOUSDC && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO_USDC)) {
        //     dodo.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        // }
        // if (dex == Dex.DODOUSDT && !flags.or(Flags.FLAG_DISABLE_DODO_ALL, Flags.FLAG_DISABLE_DODO_USDT)) {
        //     dodo.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        // }

        // add Smoothy
        if (dex == Dex.Smoothy && !flags.on(Flags.FLAG_DISABLE_SMOOTHY)) {
            smoothy.swap(inToken, outToken, amount);
        }

        // add Ellipsis
        if (dex == Dex.EllipsisUSD && !flags.on(Flags.FLAG_DISABLE_ELLIPSIS)) {
            IEllipsisPoolExtension.ELLIPSIS_USD.swap(inToken, outToken, amount);
        }
        if (dex == Dex.EllipsisBTC && !flags.on(Flags.FLAG_DISABLE_ELLIPSIS)) {
            IEllipsisPoolExtension.ELLIPSIS_BTC.swap(inToken, outToken, amount);
        }
        if (dex == Dex.EllipsisFUSDT && !flags.on(Flags.FLAG_DISABLE_ELLIPSIS)) {
            IEllipsisPoolExtension.ELLIPSIS_FUSDT.swap(inToken, outToken, amount);
        }

        // add MDex
        if (dex == Dex.MDex && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX)) {
            IUniswapV2LikeFactories.MDEX.swap(inToken, outToken, amount);
        }
        if (dex == Dex.MDexETH && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_ETH)) {
            IUniswapV2LikeFactories.MDEX.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.MDexUSDC && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_USDC)) {
            IUniswapV2LikeFactories.MDEX.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.MDexUSDT && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_USDT)) {
            IUniswapV2LikeFactories.MDEX.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.MDexBUSD && !flags.or(Flags.FLAG_DISABLE_MDEX_ALL, Flags.FLAG_DISABLE_MDEX_BUSD)) {
            IUniswapV2LikeFactories.MDEX.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }

        // Pancake V2
        if (dex == Dex.PancakeV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_V2)) {
            IUniswapV2LikeFactories.PANCAKE_V2.swap(inToken, outToken, amount);
        }
        if (dex == Dex.PancakeETHV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_ETH_V2)) {
            IUniswapV2LikeFactories.PANCAKE_V2.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.PancakeUSDCV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_USDC_V2)) {
            IUniswapV2LikeFactories.PANCAKE_V2.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.PancakeUSDTV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_USDT_V2)) {
            IUniswapV2LikeFactories.PANCAKE_V2.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        if (dex == Dex.PancakeBUSDV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_BUSD_V2)) {
            IUniswapV2LikeFactories.PANCAKE_V2.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }
        if (dex == Dex.PancakeDOTV2 && !flags.or(Flags.FLAG_DISABLE_PANCAKE_ALL_V2, Flags.FLAG_DISABLE_PANCAKE_DOT_V2)) {
            IUniswapV2LikeFactories.PANCAKE_V2.swapTransitional(inToken, Tokens.DOT, outToken, amount);
        }

        // Nerve
        if (dex == Dex.NervePOOL3 && !flags.or(Flags.FLAG_DISABLE_NERVE_ALL, Flags.FLAG_DISABLE_NERVE_POOL3)) {
            return INerveExtension.POOL3.swap(inToken, outToken, amount);
        }
        if (dex == Dex.NerveBTC && !flags.or(Flags.FLAG_DISABLE_NERVE_ALL, Flags.FLAG_DISABLE_NERVE_BTC)) {
            return INerveExtension.BTC.swap(inToken, outToken, amount);
        }
        if (dex == Dex.NerveETH && !flags.or(Flags.FLAG_DISABLE_NERVE_ALL, Flags.FLAG_DISABLE_NERVE_ETH)) {
            return INerveExtension.ETH.swap(inToken, outToken, amount);
        }

        // Cafeswap
        if (dex == Dex.Cafeswap && !flags.on(Flags.FLAG_DISABLE_CAFESWAP_ALL)) {
            IUniswapV2LikeFactories.CAFESWAP.swap(inToken, outToken, amount);
        }

        // Beltswap
        // if (dex == Dex.Beltswap && !flags.on(Flags.FLAG_DISABLE_BELTSWAP_ALL)) {
        //     IBeltSwapExtension.BELT4.swap(inToken, outToken, amount);
        // }

        // Biswap
        if (dex == Dex.Biswap && !flags.on(Flags.FLAG_DISABLE_BISWAP_ALL)) {
            IUniswapV2LikeFactories.BISWAP.swap(inToken, outToken, amount);
        }
        if (dex == Dex.BiswapBNB && !flags.on(Flags.FLAG_DISABLE_BISWAP_ALL)) {
            IUniswapV2LikeFactories.BISWAP.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.BiswapBUSD && !flags.on(Flags.FLAG_DISABLE_BISWAP_ALL)) {
            IUniswapV2LikeFactories.BISWAP.swapTransitional(inToken, Tokens.BUSD, outToken, amount);
        }
    }
}

// File: contracts/DexOneView.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;




contract DexOneView {
    using SafeMath for uint256;
    using Dexes for Dex;

    int256 internal constant MIN_VALUE = -1e72;

    // holding parameters to avoid Solidity's `Stack too deep` error
    struct Parameter {
        Dex[] dexes;
        IERC20 inToken;
        IERC20 outToken;
        uint256 inAmount;
        uint256 partition;
        uint256 flags;
        uint256 outTokenEthPriceTimesGasPrice;
        int256[][] matrix;
        uint256[] gases;
        uint256[] distribution;
    }

    function calculateSwapReturn(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 partition,
        uint256 flags
    ) public virtual view returns (uint256 outAmount, uint256[] memory distribution) {
        (outAmount, , distribution) = calculateSwapReturnWithGas(inToken, outToken, inAmount, partition, flags, 0);
    }

    function calculateSwapReturnWithGas(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 partition,
        uint256 flags,
        uint256 outTokenEthPriceTimesGasPrice
    )
        public
        virtual
        view
        returns (
            uint256 outAmount,
            uint256 estimateGasAmount,
            uint256[] memory distribution
        )
    {
        Parameter memory param;
        param.dexes = Dexes.allDexes();
        if (inToken == outToken) {
            return (inAmount, 0, new uint256[](param.dexes.length));
        }

        param.matrix = new int256[][](param.dexes.length);
        param.gases = new uint256[](param.dexes.length);

        uint256[] memory inAmounts = interpolation(inAmount, partition);
        bool hasPositive = false;
        for (uint256 i = 0; i < param.dexes.length; i++) {
            uint256[] memory outAmounts;
            (outAmounts, param.gases[i]) = param.dexes[i].calculateSwapReturn(inToken, outToken, inAmounts, flags);
            int256 gas = int256(param.gases[i].mul(outTokenEthPriceTimesGasPrice).div(1e18));
            param.matrix[i] = new int256[](partition + 1);
            for (uint256 j = 0; j < partition; j++) {
                param.matrix[i][j + 1] = int256(outAmounts[j]) - gas;
                hasPositive = hasPositive || (param.matrix[i][j + 1] > 0);
            }
        }
        if (!hasPositive) {
            for (uint256 i = 0; i < param.dexes.length; i++) {
                for (uint256 j = 1; j <= partition; j++) {
                    if (param.matrix[i][j] == 0) {
                        param.matrix[i][j] = MIN_VALUE;
                    }
                }
            }
        }

        // find the best DEX distribution
        distribution = findDistribution(partition, param.matrix);

        // populate parameters
        param.inToken = inToken;
        param.outToken = outToken;
        param.inAmount = inAmount;
        param.partition = partition;
        param.flags = flags;
        param.outTokenEthPriceTimesGasPrice = outTokenEthPriceTimesGasPrice;
        param.distribution = distribution;

        (outAmount, estimateGasAmount) = getRealOutAmountAndGas(param);
    }

    function findDistribution(uint256 partition, int256[][] memory amounts) internal pure returns (uint256[] memory distribution) {
        uint256 dexCount = amounts.length;

        int256[][] memory answer = new int256[][](dexCount);
        uint256[][] memory parent = new uint256[][](dexCount);

        for (uint256 i = 0; i < dexCount; i++) {
            answer[i] = new int256[](partition + 1);
            parent[i] = new uint256[](partition + 1);
        }

        for (uint256 j = 0; j <= partition; j++) {
            answer[0][j] = amounts[0][j];
            for (uint256 i = 1; i < dexCount; i++) {
                answer[i][j] = MIN_VALUE;
            }
            parent[0][j] = 0;
        }

        for (uint256 i = 1; i < dexCount; i++) {
            for (uint256 j = 0; j <= partition; j++) {
                answer[i][j] = answer[i - 1][j];
                parent[i][j] = j;

                for (uint256 k = 1; k <= j; k++) {
                    if (answer[i - 1][j - k] + amounts[i][k] > answer[i][j]) {
                        answer[i][j] = answer[i - 1][j - k] + amounts[i][k];
                        parent[i][j] = j - k;
                    }
                }
            }
        }

        distribution = new uint256[](dexCount);

        uint256 left = partition;
        for (uint256 dex = dexCount - 1; left > 0; dex--) {
            distribution[dex] = left - parent[dex][left];
            left = parent[dex][left];
        }
    }

    function getRealOutAmountAndGas(Parameter memory param) internal pure returns (uint256 outAmount, uint256 estimateGasAmount) {
        for (uint256 i = 0; i < param.distribution.length; i++) {
            if (param.distribution[i] > 0) {
                estimateGasAmount = estimateGasAmount.add(param.gases[i]);
                int256 amount = param.matrix[i][param.distribution[i]];
                if (amount == MIN_VALUE) {
                    amount = 0;
                }
                int256 gas = int256(param.gases[i].mul(param.outTokenEthPriceTimesGasPrice).div(1e18));
                outAmount = outAmount.add(uint256(amount + gas));
            }
        }
    }

    function interpolation(uint256 value, uint256 partition) internal pure returns (uint256[] memory results) {
        results = new uint256[](partition);
        for (uint256 i = 0; i < partition; i++) {
            results[i] = value.mul(i + 1).div(partition);
        }
    }

    function calculateDexSwapReturns(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 flags
    ) public virtual view returns (uint256[] memory outAmounts) {
        Dex[] memory dexes = Dexes.allDexes();
        outAmounts = new uint256[](dexes.length);
        if (inToken == outToken) {
            return outAmounts;
        }
        uint256[] memory inAmounts = new uint256[](1);
        inAmounts[0] = inAmount;
        for (uint256 i = 0; i < dexes.length; i++) {
            (uint256[] memory amounts, ) = dexes[i].calculateSwapReturn(inToken, outToken, inAmounts, flags);
            outAmounts[i] = amounts[0];
        }
        return outAmounts;
    }
}

// File: contracts/DexOne.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;






contract DexOne is IDexOne {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using Dexes for Dex;

    DexOneView public dexOneView;

    constructor(DexOneView _dexOneView) public {
        dexOneView = _dexOneView;
    }

    receive() external payable {
        // cannot directly send eth to this contract
        require(msg.sender != tx.origin);
    }

    function calculateSwapReturn(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 partition,
        uint256 flags
    ) public view override returns (uint256 outAmount, uint256[] memory distribution) {
        (outAmount, , distribution) = calculateSwapReturnWithGas(inToken, outToken, inAmount, partition, flags, 0);
    }

    function calculateSwapReturnWithGas(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 partition,
        uint256 flags,
        uint256 outTokenEthPriceTimesGasPrice
    )
        public
        view
        override
        returns (
            uint256 outAmount,
            uint256 estimateGasAmount,
            uint256[] memory distribution
        )
    {
        return dexOneView.calculateSwapReturnWithGas(inToken, outToken, inAmount, partition, flags, outTokenEthPriceTimesGasPrice);
    }

    function calculateDexSwapReturns(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 flags
    ) public view virtual returns (uint256[] memory outAmounts) {
        return dexOneView.calculateDexSwapReturns(inToken, outToken, inAmount, flags);
    }

    function swap(
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount,
        uint256 minOutAmount,
        uint256[] memory distribution,
        uint256 flags
    ) public payable override returns (uint256 outAmount) {
        if (inToken == outToken) {
            return amount;
        }

        Dex[] memory dexes = Dexes.allDexes();
        uint256 partition = 0;
        uint256 lastDex = 0;
        for (uint256 i = 0; i < distribution.length; i++) {
            if (distribution[i] > 0) {
                partition = partition.add(distribution[i]);
                lastDex = i;
            }
        }

        if (partition == 0) {
            if (inToken.isETH()) {
                msg.sender.transfer(msg.value);
                return msg.value;
            }
            return amount;
        }

        // uint256 senderBalance = inToken.universalBalanceOf(msg.sender);
        // if (senderBalance < amount) {
        //     amount = senderBalance;
        // }
        inToken.universalTransferFrom(msg.sender, address(this), amount);
        uint256 balance = inToken.universalBalanceOf(address(this));

        for (uint256 i = 0; i < distribution.length; i++) {
            if (distribution[i] == 0) {
                continue;
            }
            uint256 swapAmount = amount.mul(distribution[i]).div(partition);
            if (i == lastDex) {
                swapAmount = balance;
            }
            balance -= swapAmount;
            dexes[i].swap(inToken, outToken, swapAmount, flags);
            if (i == lastDex) {
                break;
            }
        }

        outAmount = outToken.universalBalanceOf(address(this));
        require(outAmount >= minOutAmount, "DexOne: Return amount less than the minimum required amount");
        outToken.universalTransfer(msg.sender, outAmount);
        inToken.universalTransfer(msg.sender, inToken.universalBalanceOf(address(this)));
    }
}

// File: contracts/DexOneAll.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;






contract DexOneAll is IDexOneTransitional {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    DexOne public dexOne;
    DexOneView public dexOneView;

    constructor(DexOne _dexOne, DexOneView _dexOneView) public {
        dexOne = _dexOne;
        dexOneView = _dexOneView;
    }

    receive() external payable {
        // cannot directly send eth to this contract
        require(msg.sender != tx.origin);
    }

    function calculateSwapReturn(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 partition,
        uint256 flags
    ) public override view returns (uint256 outAmount, uint256[] memory distribution) {
        (outAmount, , distribution) = calculateSwapReturnWithGas(inToken, outToken, inAmount, partition, flags, 0);
    }

    function calculateSwapReturnWithGas(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 partition,
        uint256 flags,
        uint256 outTokenEthPriceTimesGasPrice
    )
        public
        override
        view
        returns (
            uint256 outAmount,
            uint256 estimateGasAmount,
            uint256[] memory distribution
        )
    {
        return dexOneView.calculateSwapReturnWithGas(inToken, outToken, inAmount, partition, flags, outTokenEthPriceTimesGasPrice);
    }

    function calculateDexSwapReturns(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 flags
    ) public virtual view returns (uint256[] memory outAmounts) {
        return dexOneView.calculateDexSwapReturns(inToken, outToken, inAmount, flags);
    }

    function swap(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 minOutAmount,
        uint256[] memory distribution,
        uint256 flags
    ) public override payable returns (uint256 outAmount) {
        inToken.universalTransferFrom(msg.sender, address(this), inAmount);
        uint256 amount = inToken.universalBalanceOf(address(this));
        doSwap(inToken, outToken, amount, distribution, flags);

        outAmount = outToken.universalBalanceOf(address(this));
        require(outAmount >= minOutAmount, "DexOne: Return amount less than the minimum required amount");

        // return the swapped token and remainder
        outToken.universalTransfer(msg.sender, outAmount);
        inToken.universalTransfer(msg.sender, inToken.universalBalanceOf(address(this)));
    }

    function calculateSwapReturnWithGasTransitional(
        IERC20[] memory tokens,
        uint256 inAmount,
        uint256[] memory partitions,
        uint256[] memory flags,
        uint256[] memory outTokenEthPriceTimesGasPrices
    )
        public
        override
        view
        returns (
            uint256[] memory outAmounts,
            uint256 estimateGasAmount,
            uint256[] memory distribution
        )
    {
        outAmounts = new uint256[](tokens.length - 1);
        uint256[] memory transitionalDistribution;

        for (uint256 i = 0; i < tokens.length - 1; i++) {
            if (tokens[i] == tokens[i + 1]) {
                outAmounts[i] = i == 0 ? inAmount : outAmounts[i - 1];
            }

            uint256 gas;
            (outAmounts[i], gas, transitionalDistribution) = calculateSwapReturnWithGas(
                tokens[i],
                tokens[i + 1],
                i == 0 ? inAmount : outAmounts[i - 1],
                partitions[i],
                flags[i],
                outTokenEthPriceTimesGasPrices[i]
            );

            estimateGasAmount = estimateGasAmount.add(gas);

            if (distribution.length == 0) {
                distribution = new uint256[](transitionalDistribution.length);
            }
            for (uint256 j = 0; j < distribution.length; j++) {
                distribution[j] = distribution[j].add(transitionalDistribution[j] << (i * 8));
            }
        }
    }

    function swapTransitional(
        IERC20[] memory tokens,
        uint256 inAmount,
        uint256 minOutAmount,
        uint256[] memory distribution,
        uint256[] memory flags
    ) public override payable returns (uint256 outAmount) {
        tokens[0].universalTransferFrom(msg.sender, address(this), inAmount);
        outAmount = tokens[0].universalBalanceOf(address(this));

        for (uint256 i = 0; i < tokens.length - 1; i++) {
            if (tokens[i] == tokens[i + 1]) {
                continue;
            }

            uint256[] memory transitionalDistribution = new uint256[](distribution.length);
            for (uint256 j = 0; j < distribution.length; j++) {
                transitionalDistribution[j] = (distribution[j] >> (i * 8)) & 0xFF;
            }

            doSwap(tokens[i], tokens[i + 1], outAmount, transitionalDistribution, flags[i]);
            outAmount = tokens[i + 1].universalBalanceOf(address(this));
            // return remainder
            tokens[i].universalTransfer(msg.sender, tokens[i].universalBalanceOf(address(this)));
        }

        require(outAmount >= minOutAmount, "DexOne: Return amount less than the minimum required amount");
        tokens[tokens.length - 1].universalTransfer(msg.sender, outAmount);
    }

    function doSwap(
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256[] memory distribution,
        uint256 flags
    ) internal {
        inToken.universalApprove(address(dexOne), inAmount);
        dexOne.swap{value: inToken.isETH() ? inAmount : 0}(inToken, outToken, inAmount, 0, distribution, flags);
    }
}
