// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";

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

        (bool success, bytes memory data) =
            address(kyberHint).staticcall(
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

        (bool success, bytes memory data) =
            address(kyberHint).staticcall(
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
                0xe523182610482b8C0DD65d5A08F1Bbd256B1EA0c,
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
                0xe523182610482b8C0DD65d5A08F1Bbd256B1EA0c,
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
        (, bytes memory data) =
            address(proxy).staticcall(
                abi.encodeWithSelector(proxy.getExpectedRateAfterFee.selector, inToken, outToken, amount, (flags >> 255) * 10, hint)
            );

        return (data.length == 32) ? abi.decode(data, (uint256)) : 0;
    }
}
