const {
    BN,
    ether,
    expectRevert
} = require('@openzeppelin/test-helpers');
const {
    expect
} = require('chai');
const assert = require('assert');
const {
    web3
} = require('@openzeppelin/test-helpers/src/setup');

const BigNumber = require('bignumber.js');

const DisableKSwapALL = new BN(1 << 0);
const DisableKSwap = new BN(1 << 1);
const DisableKSwapOKT = new BN(1 << 2);
const DisableKSwapUSDT = new BN(1 << 3);

const DisableCherrySwapALL = new BN(1 << 4);
const DisableCherrySwap = new BN(1 << 5);
const DisableCherrySwapOKT = new BN(1 << 6);
const DisableCherrySwapUSDT = new BN(1 << 7);

const DisableAiSwapALL = new BN(1 << 8);
const DisableAiSwap = new BN(1 << 9);
const DisableAiSwapOKT = new BN(1 << 10);
const DisableAiSwapUSDT = new BN(1 << 11);

const DisableBxHashALL = new BN(1 << 12);
const DisableBxHash = new BN(1 << 13);
const DisableBxHashOKT = new BN(1 << 14);
const DisableBxHashUSDT = new BN(1 << 15);

//
// const DisableStakeSwapALL = new BN(1 << 6);
// const DisableStakeSwap = new BN(1 << 7);
// const DisableStakeSwapUSDT = new BN(1 << 8);


const DexOne = artifacts.require("DexOne");
const ERC20 = artifacts.require("IERC20");


var pass = DisableKSwapALL.add(DisableKSwap).add(DisableKSwapOKT).add(DisableKSwapUSDT)
    .add(DisableCherrySwapALL).add(DisableCherrySwap).add(DisableCherrySwapOKT).add(DisableCherrySwapUSDT)
    .add(DisableAiSwapALL).add(DisableAiSwap).add(DisableAiSwapOKT).add(DisableAiSwapUSDT)
    .add(DisableBxHashALL).add(DisableBxHash).add(DisableBxHashOKT).add(DisableBxHashUSDT);


contract('DexOne', (accounts) => {

    it('DexOneAll should swap ETH to CAKE', async () => {
        let ethInnerAddress = "0x0000000000000000000000000000000000000000";
        let usdcAddress = "0xc946daf81b08146b1c7a8da2a851ddf2b3eaaf85";
        let usdtAddress = "0x382bB369d343125BfB2117af9c149795C6C65C50";

        const usdc = await ERC20.at(usdcAddress);
        const usdt = await ERC20.at(usdtAddress);
        let balanceBefore = await usdt.balanceOf(accounts[0]);
        console.log(`balance of ${accounts[0]}: (${balanceBefore}) USDT`);

        let a = await web3.eth.getBalance(accounts[0]);
        console.log(`balance of ${accounts[0]}: (${a}) OKT`);

        let testName = "bxhash";
        if (testName == "kSwap") {
            pass = pass.sub(DisableKSwapALL).sub(DisableKSwap);
        } else if (testName == "cherrySwap") {
            pass = pass.sub(DisableCherrySwapALL).sub(DisableCherrySwap);
        } else if (testName == "aiSwap") {
            pass = pass.sub(DisableAiSwapALL).sub(DisableAiSwap);
        } else if (testName == "bxhash") {
            pass = pass.sub(DisableBxHashALL).sub(DisableBxHash);
        }

        let dexOne = await DexOne.deployed();
        let swapAmt = BigNumber(1e18);

        res = await dexOne.calculateSwapReturn(ethInnerAddress, usdtAddress, swapAmt, 10, pass);
        expectedOutAmount = res.outAmount;
        console.log("usdt calculateSwapReturn:", expectedOutAmount.toString());
        console.log("res.distribution:", res.distribution.toString(), res.distribution.length);
        await usdt.approve(dexOne.address, swapAmt);
        await invokeContract(web3, accounts[0], dexOne, ethInnerAddress, usdtAddress, swapAmt, res);
        balanceAfter = await usdt.balanceOf(accounts[0]);
        console.log(`balance of ${accounts[0]}: (${balanceAfter}) USDT`);
        assert.equal(expectedOutAmount, balanceAfter - balanceBefore);
    });
});

async function invokeContract(web3, account, dexOne, srcToken, dstToken, swapAmt, distribution) {

    swapped = await dexOne.contract.methods.swap(
        srcToken,
        dstToken,
        swapAmt,
        0,
        distribution.distribution.map(dist => dist.toString()),
        pass.toString(),
    ).encodeABI();

    const nonce = await web3.eth.getTransactionCount(account);
    console.log(`account: ${account}`);
    const rawTx = {
        from: account,
        to: dexOne.address,
        gas: "0x166691b7",
        gasPrice: "0x4a817c800",
        data: swapped,
        // value: "0xde0b6b3a7640000",
        value: swapAmt,
        nonce: web3.utils.toHex(nonce),
    }
    const sign = await web3.eth.accounts.signTransaction(rawTx, '0x94e6de53e500b9fec28037c583f5214c854c7229329ce9baf6f5577bd95f9c9a');
    web3.eth.sendSignedTransaction(sign.rawTransaction).on('receipt', receipt => {
        // console.log("receipt:", receipt)
    });
}
