// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";

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
            outAmounts[i] = smoothy.getSwapAmount(inTokenIndex, outTokenIndex, inAmounts[i]);
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
