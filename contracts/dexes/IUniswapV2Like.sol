// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/UniversalERC20.sol";
import "../lib/Tokens.sol";

/**
 * @notice Uniswap V2 factory contract interface. See https://uniswap.org/docs/v2/smart-contracts/factory/
 */
interface IUniswapV2LikeFactory {
    function getPair(IERC20 tokenA, IERC20 tokenB) external view returns (address pair);

    /**
     * @notice Mdex factory function
     */
    function pairFees(address) external view returns (uint256);
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
                feeNumerator = uint48(IUniswapV2LikeFactory(factoryAddr).pairFees(pair));
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
            feeNumerator = uint48(IUniswapV2LikeFactory(factoryAddr).pairFees(pair));
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
