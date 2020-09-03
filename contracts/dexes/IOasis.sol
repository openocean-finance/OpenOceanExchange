// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";

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
