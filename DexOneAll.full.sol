
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

// File: contracts/lib/Flags.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2_ALL = 1 << 0;
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2 = 1 << 1;
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2_ETH = 1 << 2;
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2_DAI = 1 << 3;
    uint256 internal constant FLAG_DISABLE_UNISWAP_V2_USDC = 1 << 4;
    uint256 internal constant FLAG_DISABLE_CURVE_ALL = 1 << 5;
    uint256 internal constant FLAG_DISABLE_CURVE_COMPOUND = 1 << 6;
    uint256 internal constant FLAG_DISABLE_CURVE_USDT = 1 << 7;
    uint256 internal constant FLAG_DISABLE_CURVE_Y = 1 << 8;
    uint256 internal constant FLAG_DISABLE_CURVE_BINANCE = 1 << 9;
    uint256 internal constant FLAG_DISABLE_CURVE_SYNTHETIX = 1 << 10;
    uint256 internal constant FLAG_DISABLE_CURVE_PAX = 1 << 11;
    uint256 internal constant FLAG_DISABLE_CURVE_RENBTC = 1 << 12;
    uint256 internal constant FLAG_DISABLE_CURVE_TBTC = 1 << 13;
    uint256 internal constant FLAG_DISABLE_CURVE_SBTC = 1 << 14;
    uint256 internal constant FLAG_DISABLE_OASIS = 1 << 15;
    uint256 internal constant FLAG_DISABLE_UNISWAP = 1 << 16;
    // add SushiSwap
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_ALL = 1 << 17;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP = 1 << 18;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_ETH = 1 << 19;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_DAI = 1 << 20;
    uint256 internal constant FLAG_DISABLE_SUSHISWAP_USDC = 1 << 21;
    // add Mooniswap
    uint256 internal constant FLAG_DISABLE_MOONISWAP_ALL = 1 << 22;
    uint256 internal constant FLAG_DISABLE_MOONISWAP = 1 << 23;
    uint256 internal constant FLAG_DISABLE_MOONISWAP_ETH = 1 << 24;
    uint256 internal constant FLAG_DISABLE_MOONISWAP_DAI = 1 << 25;
    uint256 internal constant FLAG_DISABLE_MOONISWAP_USDC = 1 << 26;
    // add Balancer
    uint256 internal constant FLAG_DISABLE_BALANCER_ALL = 1 << 27;
    uint256 internal constant FLAG_DISABLE_BALANCER_1 = 1 << 28;
    uint256 internal constant FLAG_DISABLE_BALANCER_2 = 1 << 29;
    uint256 internal constant FLAG_DISABLE_BALANCER_3 = 1 << 30;
    // add Kyber
    uint256 internal constant FLAG_DISABLE_KYBER_ALL = 1 << 31;
    uint256 internal constant FLAG_DISABLE_KYBER_1 = 1 << 32;
    uint256 internal constant FLAG_DISABLE_KYBER_2 = 1 << 33;
    uint256 internal constant FLAG_DISABLE_KYBER_3 = 1 << 34;
    uint256 internal constant FLAG_DISABLE_KYBER_4 = 1 << 35;

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

// File: contracts/dexes/IUniswapV2.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;






/**
 * @notice Uniswap V2 factory contract interface. See https://uniswap.org/docs/v2/smart-contracts/factory/
 */
interface IUniswapV2Factory {
    function getPair(IERC20 tokenA, IERC20 tokenB) external view returns (IUniswapV2Pair pair);
}

/**
 * @notice Uniswap V2 pair pool interface. See https://uniswap.org/docs/v2/smart-contracts/pair/
 */
interface IUniswapV2Pair {
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

library IUniswapV2PairExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    address private constant SKIM_TARGET = 0x5bDCE812ce8409442ac3FBbd10565F9B17A6C49D;

    /**
     * @notice Use Uniswap's constant product formula to calculate expected swap return.
     * See https://github.com/runtimeverification/verified-smart-contracts/blob/uniswap/uniswap/x-y-k.pdf
     */
    function calculateSwapReturn(
        IUniswapV2Pair pair,
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
        IUniswapV2Pair pair,
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
        uint256 inAmountWithFee = amount.mul(997); // Uniswap V2 now requires fixed 0.3% swap fee
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.mul(1000).add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}

library IUniswapV2FactoryExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using IUniswapV2PairExtension for IUniswapV2Pair;
    using Tokens for IERC20;

    function calculateSwapReturn(
        IUniswapV2Factory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        IUniswapV2Pair pair = factory.getPair(realInToken, realOutToken);
        if (pair != IUniswapV2Pair(0)) {
            for (uint256 i = 0; i < inAmounts.length; i++) {
                outAmounts[i] = pair.calculateSwapReturn(realInToken, realOutToken, inAmounts[i]);
            }
            return (outAmounts, 50_000);
        }
    }

    function calculateTransitionalSwapReturn(
        IUniswapV2Factory factory,
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
        IUniswapV2Factory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        IUniswapV2Pair pair = factory.getPair(realInToken, realOutToken);

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
        IUniswapV2Factory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
    }
}

// File: contracts/dexes/ICurvePool.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;





/**
 * @notice Pool contracts of curve.fi
 * See https://github.com/curvefi/curve-vue/blob/master/src/docs/README.md#how-to-integrate-curve-smart-contracts
 */
interface ICurvePool {
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

/**
 * See https://github.com/curvefi/curve-pool-registry/blob/b17/doc/notebook/playbook.ipynb
 */
interface ICurveRegistry {
    function get_pool_info(address pool)
        external
        view
        returns (
            uint256[8] memory balances,
            uint256[8] memory underlyingBalances,
            uint256[8] memory decimals,
            uint256[8] memory underlyingDecimals,
            address curveToken,
            uint256 amp,
            uint256 fee
        );
}

interface ICurveCalculator {
    /**
     * @notice Bulk-calculate amount of of coin j given in exchange for coin i
     * @param nCoins Number of coins in the pool
     * @param balances Array with coin balances
     * @param amp Amplification coefficient
     * @param fee Pool's fee at 1e10 basis
     * @param rates Array with rates for "lent out" tokens
     * @param precisions Precision multipliers to get the coin to 1e18 basis
     * @param underlying Whether the coin is in raw or lent-out form
     * @param i Index of the changed coin (trade in)
     * @param j Index of the other changed coin (trade out)
     * @param dx Array of values of coin i (trade in)
     * Return array of values of coin j (trade out)
     * See https://github.com/curvefi/curve-pool-registry/blob/master/contracts/CurveCalc.vy
     */
    function get_dy(
        int128 nCoins,
        uint256[8] calldata balances,
        uint256 amp,
        uint256 fee,
        uint256[8] calldata rates,
        uint256[8] calldata precisions,
        bool underlying,
        int128 i,
        int128 j,
        uint256[100] calldata dx
    ) external view returns (uint256[100] memory dy);
}

library ICurveRegistryExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    ICurveCalculator internal constant CURVE_CALCULATOR = ICurveCalculator(0xc1DB00a8E5Ef7bfa476395cdbcc98235477cDE4E);

    // Curve.fi pool contracts
    ICurvePool internal constant CURVE_COMPOUND = ICurvePool(0xA2B47E3D5c44877cca798226B7B8118F9BFb7A56);
    ICurvePool internal constant CURVE_USDT = ICurvePool(0x52EA46506B9CC5Ef470C5bf89f17Dc28bB35D85C);
    ICurvePool internal constant CURVE_Y = ICurvePool(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
    ICurvePool internal constant CURVE_BINANCE = ICurvePool(0x79a8C46DeA5aDa233ABaFFD40F3A0A2B1e5A4F27);
    ICurvePool internal constant CURVE_SYNTHETIX = ICurvePool(0xA5407eAE9Ba41422680e2e00537571bcC53efBfD);
    ICurvePool internal constant CURVE_PAX = ICurvePool(0x06364f10B501e868329afBc005b3492902d6C763);
    ICurvePool internal constant CURVE_REN_BTC = ICurvePool(0x93054188d876f558f4a66B2EF1d97d16eDf0895B);
    ICurvePool internal constant CURVE_TBTC = ICurvePool(0x9726e9314eF1b96E45f40056bEd61A088897313E);
    ICurvePool internal constant CURVE_SBTC = ICurvePool(0x7fC77b5c7614E1533320Ea6DDc2Eb61fa00A9714);

    struct PoolInfo {
        uint256[8] balances;
        uint256[8] precisions;
        uint256[8] rates;
        uint256 amp;
        uint256 fee;
    }

    function calculateSwapReturn(
        ICurveRegistry registry,
        ICurvePool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        IERC20[] memory tokens;
        bool underlying;
        (tokens, underlying, gas) = getPoolConfig(pool);

        // determine curve token index
        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == -1 || j == -1) {
            return (outAmounts, 0);
        }

        // fill in amounts, ICurve need an array with fixed size 100
        uint256[100] memory amounts;
        for (uint256 k = 0; k < inAmounts.length; k++) {
            amounts[k] = inAmounts[k];
        }

        PoolInfo memory info = getCurvePoolInfo(registry, pool, underlying);

        (bool success, bytes memory data) = address(CURVE_CALCULATOR).staticcall(
            abi.encodePacked(
                abi.encodeWithSelector(
                    CURVE_CALCULATOR.get_dy.selector,
                    tokens.length,
                    info.balances,
                    info.amp,
                    info.fee,
                    info.rates,
                    info.precisions
                ),
                abi.encodePacked(uint256(underlying ? 1 : 0), uint256(i), uint256(j), amounts)
            )
        );

        if (success && data.length > 0) {
            uint256[100] memory dy = abi.decode(data, (uint256[100]));
            for (uint256 k = 0; k < outAmounts.length; k++) {
                outAmounts[k] = dy[k];
            }
        }
    }

    function swap(
        ICurveRegistry,
        ICurvePool pool,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        (IERC20[] memory tokens, bool underlying, ) = getPoolConfig(pool);

        // determine curve token index
        (int128 i, int128 j) = determineTokenIndex(inToken, outToken, tokens);
        if (i == -1 || j == -1) {
            return;
        }

        inToken.universalApprove(address(pool), inAmount);
        if (underlying) {
            pool.exchange_underlying(i, j, inAmount, 0);
        } else {
            pool.exchange(i, j, inAmount, 0);
        }
    }

    function getCurvePoolInfo(
        ICurveRegistry registry,
        ICurvePool pool,
        bool underlying
    ) private view returns (PoolInfo memory info) {
        uint256[8] memory underlyingBalances;
        uint256[8] memory decimals;
        uint256[8] memory underlyingDecimals;
        (info.balances, underlyingBalances, decimals, underlyingDecimals, , info.amp, info.fee) = registry.get_pool_info(
            address(pool)
        );

        for (uint256 i = 0; i < 8 && info.balances[i] > 0; i++) {
            uint256 decimal = underlying ? underlyingDecimals[i] : decimals[i];
            info.precisions[i] = 10**(18 - decimal);
            if (underlying) {
                info.rates[i] = underlyingBalances[i].mul(1e18).div(info.balances[i]);
            } else {
                info.rates[i] = 1e18;
            }
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
    function getPoolConfig(ICurvePool pool)
        private
        pure
        returns (
            IERC20[] memory tokens,
            bool underlying,
            uint256 gas
        )
    {
        if (pool == CURVE_COMPOUND) {
            tokens = new IERC20[](2);
            tokens[0] = Tokens.DAI;
            tokens[1] = Tokens.USDC;
            underlying = true;
            gas = 720_000;
        } else if (pool == CURVE_USDT) {
            tokens = new IERC20[](3);
            tokens[0] = Tokens.DAI;
            tokens[1] = Tokens.USDC;
            tokens[2] = Tokens.USDT;
            underlying = true;
            gas = 720_000;
        } else if (pool == CURVE_Y) {
            tokens = new IERC20[](4);
            tokens[0] = Tokens.DAI;
            tokens[1] = Tokens.USDC;
            tokens[2] = Tokens.USDT;
            tokens[3] = Tokens.TUSD;
            underlying = true;
            gas = 1_400_000;
        } else if (pool == CURVE_BINANCE) {
            tokens = new IERC20[](4);
            tokens[0] = Tokens.DAI;
            tokens[1] = Tokens.USDC;
            tokens[2] = Tokens.USDT;
            tokens[3] = Tokens.BUSD;
            underlying = true;
            gas = 1_400_000;
        } else if (pool == CURVE_SYNTHETIX) {
            tokens = new IERC20[](4);
            tokens[0] = Tokens.DAI;
            tokens[1] = Tokens.USDC;
            tokens[2] = Tokens.USDT;
            tokens[3] = Tokens.SUSD;
            underlying = true;
            gas = 200_000;
        } else if (pool == CURVE_PAX) {
            tokens = new IERC20[](4);
            tokens[0] = Tokens.DAI;
            tokens[1] = Tokens.USDC;
            tokens[2] = Tokens.USDT;
            tokens[3] = Tokens.PAX;
            underlying = true;
            gas = 1_000_000;
        } else if (pool == CURVE_REN_BTC) {
            tokens = new IERC20[](2);
            tokens[0] = Tokens.RENBTC;
            tokens[1] = Tokens.WBTC;
            underlying = false;
            gas = 130_000;
        } else if (pool == CURVE_TBTC) {
            tokens = new IERC20[](3);
            tokens[0] = Tokens.TBTC;
            tokens[1] = Tokens.WBTC;
            tokens[2] = Tokens.HBTC;
            underlying = false;
            gas = 145_000;
        } else if (pool == CURVE_SBTC) {
            tokens = new IERC20[](3);
            tokens[0] = Tokens.RENBTC;
            tokens[1] = Tokens.WBTC;
            tokens[2] = Tokens.SBTC;
            underlying = false;
            gas = 150_000;
        }
    }
}

// File: contracts/dexes/IOasis.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;




interface IOasis {
    function getBuyAmount(
        IERC20 buyGem,
        IERC20 payGem,
        uint256 payAmt
    ) external view returns (uint256 fillAmt);

    function sellAllAmount(
        IERC20 payGem,
        uint256 payAmt,
        IERC20 buyGem,
        uint256 minFillAmount
    ) external returns (uint256 fillAmt);
}

library IOasisExtension {
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;

    function calculateSwapReturn(
        IOasis oasis,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        for (uint256 i = 0; i < inAmounts.length; i++) {
            (bool success, bytes memory data) = address(oasis).staticcall{gas: 500000}(
                abi.encodeWithSelector(oasis.getBuyAmount.selector, realOutToken, realInToken, inAmounts[i])
            );

            if (!success || data.length == 0) {
                for (; i < inAmounts.length; i++) {
                    outAmounts[i] = 0;
                }
                break;
            } else {
                outAmounts[i] = abi.decode(data, (uint256));
            }
        }
        return (outAmounts, 500_000);
    }

    function swap(
        IOasis oasis,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();

        realInToken.universalApprove(address(oasis), inAmount);
        oasis.sellAllAmount(realInToken, inAmount, realOutToken, 1);

        outToken.withdrawFromWETH();
    }
}

// File: contracts/dexes/IUniswap.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;




interface IUniswapExchange {
    function ethToTokenSwapInput(uint256 minTokens, uint256 deadline) external payable returns (uint256 tokensBought);

    function tokenToEthSwapInput(
        uint256 tokensSold,
        uint256 minEth,
        uint256 deadline
    ) external returns (uint256 ethBought);
}

library IUniswapExchangeExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    // function calculateToEthSwapReturn(
    //     IUniswapExchange exchange,
    //     IERC20 token,
    //     uint256 amount
    // ) internal view returns (uint256) {
    //     if (token.isETH()) {
    //         return amount;
    //     }
    //     uint256 inReserve = token.universalBalanceOf(address(exchange));
    //     uint256 outReserve = address(exchange).balance;
    //     return doCalculate(exchange, inReserve, outReserve, amount);
    // }

    // function calculateFromEthSwapReturn(
    //     IUniswapExchange exchange,
    //     IERC20 token,
    //     uint256 amount
    // ) internal view returns (uint256) {
    //     if (token.isETH()) {
    //         return amount;
    //     }
    //     uint256 inReserve = address(exchange).balance;
    //     uint256 outReserve = token.universalBalanceOf(address(exchange));
    //     return doCalculate(exchange, inReserve, outReserve, amount);
    // }

    function calculate(
        IUniswapExchange, /* exchange */
        uint256 inReserve,
        uint256 outReserve,
        uint256 amount
    ) internal pure returns (uint256) {
        uint256 inAmountWithFee = amount.mul(997); // Uniswap now requires fixed 0.3% swap fee
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.mul(1000).add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}

interface IUniswapFactory {
    function getExchange(IERC20 token) external view returns (IUniswapExchange exchange);
}

library IUniswapFactoryExtension {
    using IUniswapExchangeExtension for IUniswapExchange;
    using UniversalERC20 for IERC20;

    function calculateSwapReturn(
        IUniswapFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        for (uint256 i = 0; i < inAmounts.length; i++) {
            outAmounts[i] = inAmounts[i];
        }

        if (!inToken.isETH()) {
            IUniswapExchange exchange = factory.getExchange(inToken);
            if (exchange == IUniswapExchange(0)) {
                return (new uint256[](inAmounts.length), 0);
            }

            uint256 inReserve = inToken.universalBalanceOf(address(exchange));
            uint256 outReserve = address(exchange).balance;
            for (uint256 i = 0; i < outAmounts.length; i++) {
                outAmounts[i] = exchange.calculate(inReserve, outReserve, outAmounts[i]);
            }
        }
        if (!outToken.isETH()) {
            IUniswapExchange exchange = factory.getExchange(outToken);
            if (exchange == IUniswapExchange(0)) {
                return (new uint256[](inAmounts.length), 0);
            }

            uint256 inReserve = address(exchange).balance;
            uint256 outReserve = outToken.universalBalanceOf(address(exchange));
            for (uint256 i = 0; i < outAmounts.length; i++) {
                outAmounts[i] = exchange.calculate(inReserve, outReserve, outAmounts[i]);
            }
        }

        return (outAmounts, inToken.isETH() || outToken.isETH() ? 60_000 : 100_000);
    }

    function swap(
        IUniswapFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        uint256 outAmount = inAmount;

        if (!inToken.isETH()) {
            IUniswapExchange exchange = factory.getExchange(inToken);
            if (exchange != IUniswapExchange(0)) {
                inToken.universalApprove(address(exchange), outAmount);
                outAmount = exchange.tokenToEthSwapInput(outAmount, 1, now);
            } else {
                return;
            }
        }

        if (!outToken.isETH()) {
            IUniswapExchange exchange = factory.getExchange(outToken);
            if (exchange != IUniswapExchange(0)) {
                outAmount = exchange.ethToTokenSwapInput{value: outAmount}(1, now);
            }
        }
    }
}

// File: contracts/dexes/ISushiSwap.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;






/**
 * @notice Uniswap V2 factory contract interface. See https://uniswap.org/docs/v2/smart-contracts/factory/
 */
interface ISushiSwapFactory {
    function getPair(IERC20 tokenA, IERC20 tokenB) external view returns (ISushiSwapPair pair);
}

/**
 * @notice Uniswap V2 pair pool interface. See https://uniswap.org/docs/v2/smart-contracts/pair/
 */
interface ISushiSwapPair {
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

library ISushiSwapPairExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    address private constant SKIM_TARGET = 0x5bDCE812ce8409442ac3FBbd10565F9B17A6C49D;

    /**
     * @notice Use Uniswap's constant product formula to calculate expected swap return.
     * See https://github.com/runtimeverification/verified-smart-contracts/blob/uniswap/uniswap/x-y-k.pdf
     */
    function calculateSwapReturn(
        ISushiSwapPair pair,
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
        ISushiSwapPair pair,
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
        uint256 inAmountWithFee = amount.mul(997); // Uniswap V2 now requires fixed 0.3% swap fee
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.mul(1000).add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}

library ISushiSwapFactoryExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using ISushiSwapPairExtension for ISushiSwapPair;
    using Tokens for IERC20;

    function calculateSwapReturn(
        ISushiSwapFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        ISushiSwapPair pair = factory.getPair(realInToken, realOutToken);
        if (pair != ISushiSwapPair(0)) {
            for (uint256 i = 0; i < inAmounts.length; i++) {
                outAmounts[i] = pair.calculateSwapReturn(realInToken, realOutToken, inAmounts[i]);
            }
            return (outAmounts, 50_000);
        }
    }

    function calculateTransitionalSwapReturn(
        ISushiSwapFactory factory,
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
        ISushiSwapFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWETH(inAmount);

        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        ISushiSwapPair pair = factory.getPair(realInToken, realOutToken);

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
        ISushiSwapFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
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

        uint256 fee = mooniswap.fee();
        uint256 fromBalance = mooniswap.getBalanceForAddition(inToken.isETH() ? UniversalERC20.ZERO_ADDRESS : inToken);
        uint256 toBalance = mooniswap.getBalanceForRemoval(outToken.isETH() ? UniversalERC20.ZERO_ADDRESS : outToken);
        if (fromBalance == 0 || toBalance == 0) {
            return (outAmounts, 0);
        }

        for (uint256 i = 0; i < inAmounts.length; i++) {
            uint256 amount = inAmounts[i].sub(inAmounts[i].mul(fee).div(1e18));
            outAmounts[i] = amount.mul(toBalance).div(fromBalance.add(amount));
        }

        return (outAmounts, (inToken.isETH() || outToken.isETH()) ? 80_000 : 110_000);
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
        IMooniswap mooniswap = registry.pools(
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

        (uint256[] memory outAmounts1, uint256 gas1) = calculateSwapReturn(
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
        IMooniswap mooniswap = registry.pools(
            inToken.isETH() ? UniversalERC20.ZERO_ADDRESS : inToken,
            outToken.isETH() ? UniversalERC20.ZERO_ADDRESS : outToken
        );
        if (mooniswap == IMooniswap(0)) {
            return;
        }

        inToken.universalApprove(address(mooniswap), inAmount);

        mooniswap.swap{value: inToken.isETH() ? inAmount : 0}(
            inToken.isETH() ? UniversalERC20.ZERO_ADDRESS : inToken,
            outToken.isETH() ? UniversalERC20.ZERO_ADDRESS : outToken,
            inAmount,
            0,
            0x5bDCE812ce8409442ac3FBbd10565F9B17A6C49D
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

// File: contracts/dexes/IBalancer.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;




interface IBalancerRegistry {
    function getBestPoolsWithLimit(
        address fromToken,
        address destToken,
        uint256 limit
    ) external view returns (address[] memory pools);
}

interface IBalancerPool {
    function swapExactAmountIn(
        IERC20 tokenIn,
        uint256 tokenAmountIn,
        IERC20 tokenOut,
        uint256 minAmountOut,
        uint256 maxPrice
    ) external returns (uint256 tokenAmountOut, uint256 spotPriceAfter);
}

interface IBalancerHelper {
    function getReturns(
        IBalancerPool pool,
        IERC20 fromToken,
        IERC20 destToken,
        uint256[] calldata amounts
    ) external view returns (uint256[] memory rets);
}

library IBalancerRegistryExtension {
    using UniversalERC20 for IERC20;
    using Tokens for IERC20;

    IBalancerHelper internal constant balancerHelper = IBalancerHelper(0xA961672E8Db773be387e775bc4937C678F3ddF9a);

    function calculateSwapReturn(
        IBalancerRegistry registry,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts,
        uint256 poolIndex
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        address[] memory pools = registry.getBestPoolsWithLimit(address(realInToken), address(realOutToken), poolIndex + 1);
        if (poolIndex >= pools.length) {
            return (new uint256[](inAmounts.length), 0);
        }

        outAmounts = balancerHelper.getReturns(IBalancerPool(pools[poolIndex]), realInToken, realOutToken, inAmounts);
        gas = 75_000 + (inToken.isETH() || outToken.isETH() ? 0 : 65_000);
    }

    function swap(
        IBalancerRegistry registry,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 poolIndex
    ) internal {
        IERC20 realInToken = inToken.wrapETH();
        IERC20 realOutToken = outToken.wrapETH();
        address[] memory pools = registry.getBestPoolsWithLimit(address(realInToken), address(realOutToken), poolIndex + 1);
        if (poolIndex >= pools.length) {
            return;
        }

        inToken.depositToWETH(inAmount);

        address pool = pools[poolIndex];
        realInToken.universalApprove(pool, inAmount);
        IBalancerPool(pool).swapExactAmountIn(realInToken, inAmount, realOutToken, 0, uint256(-1));

        outToken.withdrawFromWETH();
    }
}

// File: contracts/dexes/IKyber.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;



interface IKyberHint {
    enum TradeType {BestOfAll, MaskIn, MaskOut, Split}

    function buildTokenToEthHint(
        IERC20 tokenSrc,
        TradeType tokenToEthType,
        bytes32[] calldata tokenToEthReserveIds,
        uint256[] calldata tokenToEthSplits
    ) external view returns (bytes memory hint);

    function buildEthToTokenHint(
        IERC20 tokenDest,
        TradeType ethToTokenType,
        bytes32[] calldata ethToTokenReserveIds,
        uint256[] calldata ethToTokenSplits
    ) external view returns (bytes memory hint);
}

interface IKyberNetworkProxy {
    function getExpectedRateAfterFee(
        IERC20 src,
        IERC20 dest,
        uint256 srcQty,
        uint256 platformFeeBps,
        bytes calldata hint
    ) external view returns (uint256 expectedRate);

    function tradeWithHintAndFee(
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest,
        address payable destAddress,
        uint256 maxDestAmount,
        uint256 minConversionRate,
        address payable platformWallet,
        uint256 platformFeeBps,
        bytes calldata hint
    ) external payable returns (uint256 destAmount);
}

interface IKyberStorage {
    function getReserveIdsPerTokenSrc(IERC20 token) external view returns (bytes32[] memory);
}

library IKyberStorageExtension {
    using UniversalERC20 for IERC20;

    function getReserveIdByTokens(
        IKyberStorage kyberStorage,
        IERC20 inToken,
        IERC20 outToken
    ) internal view returns (bytes32) {
        if (!inToken.isETH() && !outToken.isETH()) {
            return 0;
        }

        bytes32[] memory reserveIds = kyberStorage.getReserveIdsPerTokenSrc(inToken.isETH() ? outToken : inToken);

        for (uint256 i = 0; i < reserveIds.length; i++) {
            bytes32 reserveId = reserveIds[i];
            if (
                (uint256(reserveId) >> 248) != 0xBB && // Bridge
                reserveId != 0xff4b796265722046707200000000000000000000000000000000000000000000 && // Reserve 1
                reserveId != 0xffabcd0000000000000000000000000000000000000000000000000000000000 && // Reserve 2
                reserveId != 0xff4f6e65426974205175616e7400000000000000000000000000000000000000 // Reserve 3
            ) {
                return reserveId;
            }
        }

        return 0;
    }
}

library IKyberHintExtension {
    function getFromHint(
        IKyberHint kyberHint,
        IERC20 token,
        bytes32 reserveId
    ) internal view returns (bytes memory hint) {
        bytes32[] memory reserveIds = new bytes32[](1);
        reserveIds[0] = reserveId;

        (bool success, bytes memory data) = address(kyberHint).staticcall(
            abi.encodeWithSelector(
                kyberHint.buildTokenToEthHint.selector,
                token,
                IKyberHint.TradeType.MaskIn,
                reserveIds,
                new uint256[](0)
            )
        );
        hint = success ? abi.decode(data, (bytes)) : bytes("");
    }

    function getToHint(
        IKyberHint kyberHint,
        IERC20 token,
        bytes32 reserveId
    ) internal view returns (bytes memory hint) {
        bytes32[] memory reserveIds = new bytes32[](1);
        reserveIds[0] = reserveId;

        (bool success, bytes memory data) = address(kyberHint).staticcall(
            abi.encodeWithSelector(
                kyberHint.buildEthToTokenHint.selector,
                token,
                IKyberHint.TradeType.MaskIn,
                reserveIds,
                new uint256[](0)
            )
        );
        hint = success ? abi.decode(data, (bytes)) : bytes("");
    }
}

library IKyberNetworkProxyExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    IKyberStorage internal constant kyberStorage = IKyberStorage(0xC8fb12402cB16970F3C5F4b48Ff68Eb9D1289301);
    using IKyberStorageExtension for IKyberStorage;

    IKyberHint internal constant kyberHint = IKyberHint(0xa1C0Fa73c39CFBcC11ec9Eb1Afc665aba9996E2C);
    using IKyberHintExtension for IKyberHint;

    function calculateSwapReturn(
        IKyberNetworkProxy proxy,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts,
        uint256 flags,
        bytes32 reserveId
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        if (reserveId == 0) {
            reserveId = kyberStorage.getReserveIdByTokens(inToken, outToken);
            if (reserveId == 0) {
                return (new uint256[](inAmounts.length), 0);
            }
        }

        bytes memory fromHint = kyberHint.getFromHint(inToken, reserveId);
        bytes memory toHint = kyberHint.getToHint(outToken, reserveId);

        uint256 inTokenDecimals = 10**inToken.universalDecimals();
        uint256 outTokenDecimals = 10**outToken.universalDecimals();
        outAmounts = new uint256[](inAmounts.length);

        for (uint256 i = 0; i < inAmounts.length; i++) {
            if (i > 0 && outAmounts[i - 1] == 0) {
                break;
            }
            outAmounts[i] = inAmounts[i];

            if (!inToken.isETH()) {
                if (fromHint.length == 0) {
                    outAmounts[i] = 0;
                    break;
                }
                uint256 rate = getRate(proxy, inToken, UniversalERC20.ETH_ADDRESS, outAmounts[i], flags, fromHint);
                outAmounts[i] = rate.mul(outAmounts[i]).div(inTokenDecimals);
            }

            if (!outToken.isETH() && outAmounts[i] > 0) {
                if (toHint.length == 0) {
                    outAmounts[i] = 0;
                    break;
                }
                uint256 rate = getRate(proxy, UniversalERC20.ETH_ADDRESS, outToken, outAmounts[i], 10, toHint);
                outAmounts[i] = rate.mul(outAmounts[i]).mul(outTokenDecimals).div(1e36);
            }
        }

        return (outAmounts, 100_000);
    }

    function swap(
        IKyberNetworkProxy proxy,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount,
        uint256 flags,
        bytes32 reserveId
    ) internal {
        if (reserveId == 0) {
            reserveId = kyberStorage.getReserveIdByTokens(inToken, outToken);
            if (reserveId == 0) {
                return;
            }
        }
        uint256 outAmount = inAmount;

        if (!inToken.isETH()) {
            bytes memory fromHint = kyberHint.getFromHint(inToken, reserveId);
            inToken.universalApprove(address(proxy), inAmount);
            outAmount = proxy.tradeWithHintAndFee(
                inToken,
                outAmount,
                UniversalERC20.ETH_ADDRESS,
                payable(address(this)),
                uint256(-1),
                0,
                0x5bDCE812ce8409442ac3FBbd10565F9B17A6C49D,
                (flags >> 255) * 10,
                fromHint
            );
        }

        if (!outToken.isETH()) {
            bytes memory toHint = kyberHint.getToHint(outToken, reserveId);
            outAmount = proxy.tradeWithHintAndFee{value: outAmount}(
                UniversalERC20.ETH_ADDRESS,
                outAmount,
                outToken,
                payable(address(this)),
                uint256(-1),
                0,
                0x5bDCE812ce8409442ac3FBbd10565F9B17A6C49D,
                (flags >> 255) * 10,
                toHint
            );
        }
    }

    function getRate(
        IKyberNetworkProxy proxy,
        IERC20 inToken,
        IERC20 outToken,
        uint256 amount,
        uint256 flags,
        bytes memory hint
    ) private view returns (uint256) {
        (, bytes memory data) = address(proxy).staticcall(
            abi.encodeWithSelector(proxy.getExpectedRateAfterFee.selector, inToken, outToken, amount, (flags >> 255) * 10, hint)
        );

        return (data.length == 32) ? abi.decode(data, (uint256)) : 0;
    }
}

// File: contracts/dexes/Dexes.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;














enum Dex {
    UniswapV2,
    UniswapV2ETH,
    UniswapV2DAI,
    UniswapV2USDC,
    CurveCompound,
    CurveUSDT,
    CurveY,
    CurveBinance,
    CurveSynthetix,
    CurvePAX,
    CurveRenBTC,
    CurveTBTC,
    CurveSBTC,
    Oasis,
    Uniswap,
    Curve,
    // add Mooniswap
    Mooniswap,
    MooniswapETH,
    MooniswapDAI,
    MooniswapUSDC,
    // add SushiSwap
    SushiSwap,
    SushiSwapETH,
    SushiSwapDAI,
    SushiSwapUSDC,
    // add Balancer
    Balancer,
    Balancer1,
    Balancer2,
    Balancer3,
    // add Kyber
    Kyber,
    Kyber1,
    Kyber2,
    Kyber3,
    Kyber4,
    // bottom mark
    NoDex
}

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

    IUniswapV2Factory internal constant uniswapV2 = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
    using IUniswapV2FactoryExtension for IUniswapV2Factory;

    ICurveRegistry internal constant curveRegistry = ICurveRegistry(0x7002B727Ef8F5571Cb5F9D70D13DBEEb4dFAe9d1);
    using ICurveRegistryExtension for ICurveRegistry;

    IOasis internal constant oasis = IOasis(0x794e6e91555438aFc3ccF1c5076A74F42133d08D);
    using IOasisExtension for IOasis;

    IUniswapFactory internal constant uniswap = IUniswapFactory(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);
    using IUniswapFactoryExtension for IUniswapFactory;

    ISushiSwapFactory internal constant sushiswap = ISushiSwapFactory(0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac);
    using ISushiSwapFactoryExtension for ISushiSwapFactory;

    IMooniswapRegistry internal constant mooniswap = IMooniswapRegistry(0x71CD6666064C3A1354a3B4dca5fA1E2D3ee7D303);
    using IMooniswapRegistryExtension for IMooniswapRegistry;

    IBalancerRegistry internal constant balancer = IBalancerRegistry(0x65e67cbc342712DF67494ACEfc06fe951EE93982);
    using IBalancerRegistryExtension for IBalancerRegistry;

    IKyberNetworkProxy internal constant kyber = IKyberNetworkProxy(0x9AAb3f75489902f3a48495025729a0AF77d4b11e);
    using IKyberNetworkProxyExtension for IKyberNetworkProxy;

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
        if (dex == Dex.UniswapV2 && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2)) {
            return uniswapV2.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.UniswapV2ETH && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_ETH)) {
            return uniswapV2.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.UniswapV2DAI && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_DAI)) {
            return uniswapV2.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.UniswapV2USDC && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_USDC)) {
            return uniswapV2.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        if (dex == Dex.CurveCompound && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_COMPOUND)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_COMPOUND, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveUSDT && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_USDT)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_USDT, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveY && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_Y)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_Y, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveBinance && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_BINANCE)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_BINANCE, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveSynthetix && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_SYNTHETIX)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_SYNTHETIX, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurvePAX && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_PAX)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_PAX, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveRenBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_RENBTC)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_REN_BTC, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveTBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_TBTC)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_TBTC, inToken, outToken, inAmounts);
        }
        if (dex == Dex.CurveSBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_SBTC)) {
            return curveRegistry.calculateSwapReturn(ICurveRegistryExtension.CURVE_SBTC, inToken, outToken, inAmounts);
        }
        if (dex == Dex.Oasis && !flags.on(Flags.FLAG_DISABLE_OASIS)) {
            return oasis.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.Uniswap && !flags.on(Flags.FLAG_DISABLE_UNISWAP)) {
            return uniswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        // add SushiSwap
        if (dex == Dex.SushiSwap && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP)) {
            return sushiswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapETH && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_ETH)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.WETH, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapDAI && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_DAI)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.SushiSwapUSDC && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_USDC)) {
            return sushiswap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        // add Mooniswap
        if (dex == Dex.Mooniswap && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP)) {
            return mooniswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.MooniswapETH && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_ETH)) {
            return mooniswap.calculateTransitionalSwapReturn(inToken, UniversalERC20.ETH_ADDRESS, outToken, inAmounts);
        }
        if (dex == Dex.MooniswapDAI && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_DAI)) {
            return mooniswap.calculateTransitionalSwapReturn(inToken, Tokens.DAI, outToken, inAmounts);
        }
        if (dex == Dex.MooniswapUSDC && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_USDC)) {
            return mooniswap.calculateTransitionalSwapReturn(inToken, Tokens.USDC, outToken, inAmounts);
        }
        // add Balancer
        if (dex == Dex.Balancer1 && !flags.or(Flags.FLAG_DISABLE_BALANCER_ALL, Flags.FLAG_DISABLE_BALANCER_1)) {
            return balancer.calculateSwapReturn(inToken, outToken, inAmounts, 0);
        }
        if (dex == Dex.Balancer2 && !flags.or(Flags.FLAG_DISABLE_BALANCER_ALL, Flags.FLAG_DISABLE_BALANCER_2)) {
            return balancer.calculateSwapReturn(inToken, outToken, inAmounts, 1);
        }
        if (dex == Dex.Balancer3 && !flags.or(Flags.FLAG_DISABLE_BALANCER_ALL, Flags.FLAG_DISABLE_BALANCER_3)) {
            return balancer.calculateSwapReturn(inToken, outToken, inAmounts, 2);
        }
        // add Kyber
        if (dex == Dex.Kyber1 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_1)) {
            return
                kyber.calculateSwapReturn(
                    inToken,
                    outToken,
                    inAmounts,
                    flags,
                    0xff4b796265722046707200000000000000000000000000000000000000000000
                );
        }
        if (dex == Dex.Kyber2 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_2)) {
            return
                kyber.calculateSwapReturn(
                    inToken,
                    outToken,
                    inAmounts,
                    flags,
                    0xffabcd0000000000000000000000000000000000000000000000000000000000
                );
        }
        if (dex == Dex.Kyber3 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_3)) {
            return
                kyber.calculateSwapReturn(
                    inToken,
                    outToken,
                    inAmounts,
                    flags,
                    0xff4f6e65426974205175616e7400000000000000000000000000000000000000
                );
        }
        if (dex == Dex.Kyber4 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_4)) {
            return kyber.calculateSwapReturn(inToken, outToken, inAmounts, flags, 0);
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
        if (dex == Dex.UniswapV2 && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2)) {
            uniswapV2.swap(inToken, outToken, amount);
        }
        if (dex == Dex.UniswapV2ETH && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_ETH)) {
            uniswapV2.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.UniswapV2DAI && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_DAI)) {
            uniswapV2.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.UniswapV2USDC && !flags.or(Flags.FLAG_DISABLE_UNISWAP_V2_ALL, Flags.FLAG_DISABLE_UNISWAP_V2_USDC)) {
            uniswapV2.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        if (dex == Dex.CurveCompound && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_COMPOUND)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_COMPOUND, inToken, outToken, amount);
        }
        if (dex == Dex.CurveUSDT && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_USDT)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_USDT, inToken, outToken, amount);
        }
        if (dex == Dex.CurveY && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_Y)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_Y, inToken, outToken, amount);
        }
        if (dex == Dex.CurveBinance && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_BINANCE)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_BINANCE, inToken, outToken, amount);
        }
        if (dex == Dex.CurveSynthetix && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_SYNTHETIX)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_SYNTHETIX, inToken, outToken, amount);
        }
        if (dex == Dex.CurvePAX && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_PAX)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_PAX, inToken, outToken, amount);
        }
        if (dex == Dex.CurveRenBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_RENBTC)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_REN_BTC, inToken, outToken, amount);
        }
        if (dex == Dex.CurveTBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_TBTC)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_TBTC, inToken, outToken, amount);
        }
        if (dex == Dex.CurveSBTC && !flags.or(Flags.FLAG_DISABLE_CURVE_ALL, Flags.FLAG_DISABLE_CURVE_SBTC)) {
            curveRegistry.swap(ICurveRegistryExtension.CURVE_SBTC, inToken, outToken, amount);
        }
        if (dex == Dex.Oasis && !flags.on(Flags.FLAG_DISABLE_OASIS)) {
            oasis.swap(inToken, outToken, amount);
        }
        if (dex == Dex.Uniswap && !flags.on(Flags.FLAG_DISABLE_UNISWAP)) {
            uniswap.swap(inToken, outToken, amount);
        }
        // add SushiSwap
        if (dex == Dex.SushiSwap && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP)) {
            sushiswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.SushiSwapETH && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_ETH)) {
            sushiswap.swapTransitional(inToken, Tokens.WETH, outToken, amount);
        }
        if (dex == Dex.SushiSwapDAI && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_DAI)) {
            sushiswap.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.SushiSwapUSDC && !flags.or(Flags.FLAG_DISABLE_SUSHISWAP_ALL, Flags.FLAG_DISABLE_SUSHISWAP_USDC)) {
            sushiswap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        // add Mooniswap
        if (dex == Dex.Mooniswap && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP)) {
            mooniswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.MooniswapETH && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_ETH)) {
            mooniswap.swapTransitional(inToken, UniversalERC20.ETH_ADDRESS, outToken, amount);
        }
        if (dex == Dex.MooniswapDAI && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_DAI)) {
            mooniswap.swapTransitional(inToken, Tokens.DAI, outToken, amount);
        }
        if (dex == Dex.MooniswapUSDC && !flags.or(Flags.FLAG_DISABLE_MOONISWAP_ALL, Flags.FLAG_DISABLE_MOONISWAP_USDC)) {
            mooniswap.swapTransitional(inToken, Tokens.USDC, outToken, amount);
        }
        // add Balancer
        if (dex == Dex.Balancer1 && !flags.or(Flags.FLAG_DISABLE_BALANCER_ALL, Flags.FLAG_DISABLE_BALANCER_1)) {
            balancer.swap(inToken, outToken, amount, 0);
        }
        if (dex == Dex.Balancer2 && !flags.or(Flags.FLAG_DISABLE_BALANCER_ALL, Flags.FLAG_DISABLE_BALANCER_2)) {
            balancer.swap(inToken, outToken, amount, 1);
        }
        if (dex == Dex.Balancer3 && !flags.or(Flags.FLAG_DISABLE_BALANCER_ALL, Flags.FLAG_DISABLE_BALANCER_3)) {
            balancer.swap(inToken, outToken, amount, 2);
        }
        // add Kyber
        if (dex == Dex.Kyber1 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_1)) {
            return kyber.swap(inToken, outToken, amount, flags, 0xff4b796265722046707200000000000000000000000000000000000000000000);
        }
        if (dex == Dex.Kyber2 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_2)) {
            return kyber.swap(inToken, outToken, amount, flags, 0xffabcd0000000000000000000000000000000000000000000000000000000000);
        }
        if (dex == Dex.Kyber3 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_3)) {
            return kyber.swap(inToken, outToken, amount, flags, 0xff4f6e65426974205175616e7400000000000000000000000000000000000000);
        }
        if (dex == Dex.Kyber4 && !flags.or(Flags.FLAG_DISABLE_KYBER_ALL, Flags.FLAG_DISABLE_KYBER_4)) {
            return kyber.swap(inToken, outToken, amount, flags, 0);
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
                uint256 gas = param.gases[i].mul(param.outTokenEthPriceTimesGasPrice).div(1e18);
                outAmount = outAmount.add(uint256(amount)).add(gas);
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
        uint256 amount,
        uint256 minOutAmount,
        uint256[] memory distribution,
        uint256 flags
    ) public override payable returns (uint256 outAmount) {
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
