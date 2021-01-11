// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./dexes/IUnifi.sol";

contract UnifiTradeRegistry is IUnifiTradeRegistry, Ownable {
    mapping(address => address) public override getTrade;

    event UnifiTradeAdded(address indexed tokenAddress, address indexed contractAddress);
    event UnifiTradeUpdated(address indexed tokenAddress, address indexed oldContractAddress, address indexed newContractAddress);

    constructor() public {
        getTrade[0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56] = 0xCb653c02Cf3c01863BA808ED602060eA61fE6Feb; // BUSD
        getTrade[0xb4E8D978bFf48c2D8FA241C0F323F71C1457CA81] = 0xCfAEfCE10CE1f5C2c65B483CE71168070Fd2780C; // UP
        getTrade[0x2170Ed0880ac9A755fd29B2688956BD959F933F8] = 0x446CA8aB11d302CE8d0EBDD0a9fE6DbEc4C9df9a; // ETH
        getTrade[0x7083609fCE4d1d8Dc0C979AAb8c869Ea2C873402] = 0x40A72Db869B60c3765A684cCb977C1934a659266; // DOT
        getTrade[0x1D2F0da169ceB9fC7B3144628dB156f3F6c60dBE] = 0x551D1653e77c1aA5d9271b5BcF55771f7f3e90c3; // XRP
        getTrade[0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3] = 0x212E90bFa3b364061A0e66184E8559ACB1d94612; // DAI
        getTrade[0x47BEAd2563dCBf3bF2c9407fEa4dC236fAbA485A] = 0xb48885D7C28Dcd1f30AFE4816DbC5CeaB2F0FD58; // SXP
        getTrade[0xF8A0BF9cF54Bb92F17374d9e9A321E6a111a51bD] = 0x7A3E6B25f9dA1AB47495178fc3E332e439725B6e; // LINK
        getTrade[0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d] = 0x721CC3bD031700bcb2d6af41be0C9579c546950D; // USDC
        getTrade[0xAD6cAEb32CD2c308980a548bD0Bc5AA4306c6c18] = 0x26772c7Cbcc56d287eFEE37a260ada89D8a68B48; // BAND
        getTrade[0x3EE2200Efb3400fAbB9AacF31297cBdD1d435D47] = 0xEB0ae84ED03e2Cf356AedeF4b5048563BDC4e107; // ADA
        getTrade[0x56b6fB708fC5732DEC1Afc8D8556423A2EDcCbD6] = 0x23F0edB04479524E2c2f4B53Bd34A7cAC245ADFe; // EOS
        getTrade[0x55d398326f99059fF775485246999027B3197955] = 0x63e1861115219Ec3645698E5651f302d8749EC77; // USDT
        getTrade[0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c] = 0x2a1854eEd45591334A7bb2b0e006c6887C2A8635; // BTCB
        getTrade[0x728C5baC3C3e370E372Fc4671f9ef6916b814d8B] = 0xddc53AA5Bb9Be27b60D11DbF0e27B27172E19e46; // UNFI
        getTrade[0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82] = 0x1F7261Ee0180d90c701D28352E2CC8ff7C6B75E7; // CAKE
    }

    function register(address tokenAddress, address contractAddress) public override onlyOwner {
        require(tokenAddress != address(0), "Invalid token address");
        require(contractAddress != address(0), "Invalid contract address");

        address current = getTrade[tokenAddress];
        if (current == address(0)) {
            getTrade[tokenAddress] = contractAddress;
            emit UnifiTradeAdded(tokenAddress, contractAddress);
        } else {
            getTrade[tokenAddress] = contractAddress;
            emit UnifiTradeUpdated(tokenAddress, current, contractAddress);
        }
    }

    function registerMulti(IUnifiTradeRegistry.UnifiTradeEntry[] calldata entries) external override onlyOwner {
        require(entries.length > 0, "Entries should exist");

        for (uint256 i = 0; i < entries.length; i++) {
            UnifiTradeEntry calldata entry = entries[i];
            register(entry.tokenAddress, entry.contractAddress);
        }
    }
}
