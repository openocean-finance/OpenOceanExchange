
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

    function universalTransfer(
        IERC20 token,
        address to,
        uint256 amount
    ) internal returns (bool) {
        if (amount == 0) {
            return true;
        }

        if (isOKT(token)) {
            address(uint160(to)).transfer(amount);
        } else {
            token.safeTransfer(to, amount);
        }
        return true;
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

        if (isOKT(token)) {
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

        if (isOKT(token)) {
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
        if (!isOKT(token)) {
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
        if (isOKT(token)) {
            return who.balance;
        } else {
            return token.balanceOf(who);
        }
    }

    function universalDecimals(IERC20 token) internal view returns (uint256) {
        if (isOKT(token)) {
            return 18;
        }

        (bool success, bytes memory data) = address(token).staticcall{gas: 10000}(abi.encodeWithSignature("decimals()"));
        if (!success || data.length == 0) {
            (success, data) = address(token).staticcall{gas: 10000}(abi.encodeWithSignature("DECIMALS()"));
        }

        return (success && data.length > 0) ? abi.decode(data, (uint256)) : 18;
    }

    function isOKT(IERC20 token) internal pure returns (bool) {
        return (address(token) == address(ZERO_ADDRESS));
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
abstract contract IWOKT is IERC20 {
    function deposit() external payable virtual;

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

// File: contracts/lib/Flags.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library Flags {
    uint256 internal constant FLAG_DISABLE_KSWAP_ALL = 1 << 0;
    uint256 internal constant FLAG_DISABLE_KSWAP = 1 << 1;
    uint256 internal constant FLAG_DISABLE_KSWAP_OKT = 1 << 2;
    uint256 internal constant FLAG_DISABLE_KSWAP_USDT = 1 << 3;

    uint256 internal constant FLAG_DISABLE_CHERRYSWAP_ALL = 1 << 4;
    uint256 internal constant FLAG_DISABLE_CHERRYSWAP = 1 << 5;
    uint256 internal constant FLAG_DISABLE_CHERRYSWAP_OKT = 1 << 6;
    uint256 internal constant FLAG_DISABLE_CHERRYSWAP_USDT = 1 << 7;

    uint256 internal constant FLAG_DISABLE_AISWAP_ALL = 1 << 8;
    uint256 internal constant FLAG_DISABLE_AISWAP = 1 << 9;
    uint256 internal constant FLAG_DISABLE_AISWAP_OKT = 1 << 10;
    uint256 internal constant FLAG_DISABLE_AISWAP_USDT = 1 << 11;

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

// File: contracts/dexes/IKswap.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;






interface IKswapFactory {
    function getPair(IERC20 tokenA, IERC20 tokenB) external view returns (IKswapPair pair);
}

interface IKswapPair {
    function getReserves()
        external
        view
        returns (
            uint112 _reserve0,
            uint112 _reserve1,
            uint32 _blockTimestampLast
        );

    function skim(address to) external;

    function sync() external;

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;
}

library IKswapPairExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    address private constant SKIM_TARGET = 0x5bDCE812ce8409442ac3FBbd10565F9B17A6C49D;

    function calculateSwapReturn(
        IKswapPair pair,
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
        IKswapPair pair,
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
        uint256 inAmountWithFee = amount.mul(997);
        // Uniswap V2 now requires fixed 0.3% swap fee
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.mul(1000).add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}

library IKswapFactoryExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using IKswapPairExtension for IKswapPair;
    using Tokens for IERC20;

    function calculateSwapReturn(
        IKswapFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapOKT();
        IERC20 realOutToken = outToken.wrapOKT();
        IKswapPair pair = factory.getPair(realInToken, realOutToken);
        if (pair != IKswapPair(0)) {
            for (uint256 i = 0; i < inAmounts.length; i++) {
                outAmounts[i] = pair.calculateSwapReturn(realInToken, realOutToken, inAmounts[i]);
            }
            return (outAmounts, 50_000);
        }
    }

    function calculateTransitionalSwapReturn(
        IKswapFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapOKT();
        IERC20 realTransitionToken = transitionToken.wrapOKT();
        IERC20 realOutToken = outToken.wrapOKT();

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
        IKswapFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWOKT(inAmount);

        IERC20 realInToken = inToken.wrapOKT();
        IERC20 realOutToken = outToken.wrapOKT();
        IKswapPair pair = factory.getPair(realInToken, realOutToken);

        outAmount = pair.calculateRealSwapReturn(realInToken, realOutToken, inAmount);
        realInToken.universalTransfer(address(pair), inAmount);
        if (uint256(address(realInToken)) < uint256(address(realOutToken))) {
            pair.swap(0, outAmount, address(this), "");
        } else {
            pair.swap(outAmount, 0, address(this), "");
        }

        outToken.withdrawFromWOKT();
    }

    function swapTransitional(
        IKswapFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
    }
}

// File: contracts/dexes/ICherrySwap.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;






interface ICherryFactory {
    function getPair(IERC20 tokenA, IERC20 tokenB) external view returns (ICherryPair pair);
}

interface ICherryPair {
    function getReserves()
        external
        view
        returns (
            uint112 _reserve0,
            uint112 _reserve1,
            uint32 _blockTimestampLast
        );

    function skim(address to) external;

    function sync() external;

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;
}

library ICherryPairExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    address private constant SKIM_TARGET = 0x5bDCE812ce8409442ac3FBbd10565F9B17A6C49D;

    function calculateSwapReturn(
        ICherryPair pair,
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
        ICherryPair pair,
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
        uint256 inAmountWithFee = amount.mul(997);
        // Uniswap V2 now requires fixed 0.3% swap fee
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.mul(1000).add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}

library ICherryFactoryExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using ICherryPairExtension for ICherryPair;
    using Tokens for IERC20;

    function calculateSwapReturn(
        ICherryFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);
        IERC20 realInToken = inToken.wrapOKT();
        IERC20 realOutToken = outToken.wrapOKT();
        ICherryPair pair = factory.getPair(realInToken, realOutToken);
        if (pair != ICherryPair(0)) {
            for (uint256 i = 0; i < inAmounts.length; i++) {
                outAmounts[i] = pair.calculateSwapReturn(realInToken, realOutToken, inAmounts[i]);
            }
            return (outAmounts, 50_000);
        }
    }

    function calculateTransitionalSwapReturn(
        ICherryFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapOKT();
        IERC20 realTransitionToken = transitionToken.wrapOKT();
        IERC20 realOutToken = outToken.wrapOKT();

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
        ICherryFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWOKT(inAmount);

        IERC20 realInToken = inToken.wrapOKT();
        IERC20 realOutToken = outToken.wrapOKT();
        ICherryPair pair = factory.getPair(realInToken, realOutToken);
        outAmount = pair.calculateRealSwapReturn(realInToken, realOutToken, inAmount);
        realInToken.universalTransfer(address(pair), inAmount);
        if (uint256(address(realInToken)) < uint256(address(realOutToken))) {
            pair.swap(0, outAmount, address(this), "");
        } else {
            pair.swap(outAmount, 0, address(this), "");
        }
        outToken.withdrawFromWOKT();
    }

    function swapTransitional(
        ICherryFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
    }
}

// File: contracts/dexes/IAiswap.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;






interface IAiswapFactory {
    function getPair(IERC20 tokenA, IERC20 tokenB) external view returns (IAiswapPair pair);
}

interface IAiswapPair {
    function getReserves()
        external
        view
        returns (
            uint112 _reserve0,
            uint112 _reserve1,
            uint32 _blockTimestampLast
        );

    function skim(address to) external;

    function sync() external;

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;
}

library IAiswapPairExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;

    address private constant SKIM_TARGET = 0x5bDCE812ce8409442ac3FBbd10565F9B17A6C49D;

    function calculateSwapReturn(
        IAiswapPair pair,
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
        IAiswapPair pair,
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
        uint256 inAmountWithFee = amount.mul(997);
        // Uniswap V2 now requires fixed 0.3% swap fee
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.mul(1000).add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}

library IAiswapFactoryExtension {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    using IAiswapPairExtension for IAiswapPair;
    using Tokens for IERC20;

    function calculateSwapReturn(
        IAiswapFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        outAmounts = new uint256[](inAmounts.length);

        IERC20 realInToken = inToken.wrapOKT();
        IERC20 realOutToken = outToken.wrapOKT();
        IAiswapPair pair = factory.getPair(realInToken, realOutToken);
        if (pair != IAiswapPair(0)) {
            for (uint256 i = 0; i < inAmounts.length; i++) {
                outAmounts[i] = pair.calculateSwapReturn(realInToken, realOutToken, inAmounts[i]);
            }
            return (outAmounts, 50_000);
        }
        outAmounts[0] = 10000;
        return (outAmounts, 50_000);
    }

    function calculateTransitionalSwapReturn(
        IAiswapFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256[] memory inAmounts
    ) internal view returns (uint256[] memory outAmounts, uint256 gas) {
        IERC20 realInToken = inToken.wrapOKT();
        IERC20 realTransitionToken = transitionToken.wrapOKT();
        IERC20 realOutToken = outToken.wrapOKT();

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
        IAiswapFactory factory,
        IERC20 inToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal returns (uint256 outAmount) {
        inToken.depositToWOKT(inAmount);

        IERC20 realInToken = inToken.wrapOKT();
        IERC20 realOutToken = outToken.wrapOKT();
        IAiswapPair pair = factory.getPair(realInToken, realOutToken);

        outAmount = pair.calculateRealSwapReturn(realInToken, realOutToken, inAmount);
        realInToken.universalTransfer(address(pair), inAmount);
        if (uint256(address(realInToken)) < uint256(address(realOutToken))) {
            pair.swap(0, outAmount, address(this), "");
        } else {
            pair.swap(outAmount, 0, address(this), "");
        }

        outToken.withdrawFromWOKT();
    }

    function swapTransitional(
        IAiswapFactory factory,
        IERC20 inToken,
        IERC20 transitionToken,
        IERC20 outToken,
        uint256 inAmount
    ) internal {
        swap(factory, transitionToken, outToken, swap(factory, inToken, transitionToken, inAmount));
    }
}

// File: contracts/dexes/Dexes.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;









enum Dex {
    // kswap
    Kswap,
    KswapOKT,
    KswapUSDT,
    // cherryswap
    CherrySwap,
    CherrySwapOKT,
    CherrySwapUSDT,
    // aiswap
    AiSwap,
    AiSwapOKT,
    AiSwapUSDT,
    // bottom mark
    NoDex
}

library Dexes {
    using UniversalERC20 for IERC20;
    using Flags for uint256;

    IKswapFactory internal constant kswap = IKswapFactory(0x60DCD4a2406Be12dbe3Bb2AaDa12cFb762A418c1);
    using IKswapFactoryExtension for IKswapFactory;

    ICherryFactory internal constant cherrySwap = ICherryFactory(0x709102921812B3276A65092Fe79eDfc76c4D4AFe);
    using ICherryFactoryExtension for ICherryFactory;

    IAiswapFactory internal constant aiSwap = IAiswapFactory(0x65728c1D0e545DB117940d5745089c256516ad43);
    using IAiswapFactoryExtension for IAiswapFactory;

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
        // kswap
        if (dex == Dex.Kswap && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP)) {
            return kswap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.KswapOKT && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP_OKT)) {
            return kswap.calculateTransitionalSwapReturn(inToken, Tokens.WOKT, outToken, inAmounts);
        }
        if (dex == Dex.KswapUSDT && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP_USDT)) {
            return kswap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }

        //cherryswap
        if (dex == Dex.CherrySwap && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP)) {
            return cherrySwap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.CherrySwapOKT && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP_OKT)) {
            return cherrySwap.calculateTransitionalSwapReturn(inToken, Tokens.WOKT, outToken, inAmounts);
        }
        if (dex == Dex.CherrySwapUSDT && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP_USDT)) {
            return cherrySwap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
        }

        //aiswap
        if (dex == Dex.AiSwap && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP)) {
            return aiSwap.calculateSwapReturn(inToken, outToken, inAmounts);
        }
        if (dex == Dex.AiSwapOKT && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP_OKT)) {
            return aiSwap.calculateTransitionalSwapReturn(inToken, Tokens.WOKT, outToken, inAmounts);
        }
        if (dex == Dex.AiSwapUSDT && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP_USDT)) {
            return aiSwap.calculateTransitionalSwapReturn(inToken, Tokens.USDT, outToken, inAmounts);
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
        //add kswap
        if (dex == Dex.Kswap && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP)) {
            kswap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.KswapOKT && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP_OKT)) {
            kswap.swapTransitional(inToken, Tokens.WOKT, outToken, amount);
        }
        if (dex == Dex.KswapUSDT && !flags.or(Flags.FLAG_DISABLE_KSWAP_ALL, Flags.FLAG_DISABLE_KSWAP_USDT)) {
            kswap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        //cherryswap
        if (dex == Dex.CherrySwap && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP)) {
            cherrySwap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.CherrySwapOKT && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP_OKT)) {
            cherrySwap.swapTransitional(inToken, Tokens.WOKT, outToken, amount);
        }
        if (dex == Dex.CherrySwapUSDT && !flags.or(Flags.FLAG_DISABLE_CHERRYSWAP_ALL, Flags.FLAG_DISABLE_CHERRYSWAP_USDT)) {
            cherrySwap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
        }
        //aiswap
        if (dex == Dex.AiSwap && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP)) {
            aiSwap.swap(inToken, outToken, amount);
        }
        if (dex == Dex.AiSwapOKT && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP_OKT)) {
            aiSwap.swapTransitional(inToken, Tokens.WOKT, outToken, amount);
        }
        if (dex == Dex.AiSwapUSDT && !flags.or(Flags.FLAG_DISABLE_AISWAP_ALL, Flags.FLAG_DISABLE_AISWAP_USDT)) {
            aiSwap.swapTransitional(inToken, Tokens.USDT, outToken, amount);
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
            if (inToken.isOKT()) {
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
        dexOne.swap{value: inToken.isOKT() ? inAmount : 0}(inToken, outToken, inAmount, 0, distribution, flags);
    }
}
