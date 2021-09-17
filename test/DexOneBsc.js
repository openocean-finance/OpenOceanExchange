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

const DisableSushiswapAll = new BN(1).shln(0);
const DisableSushiswap = new BN(1).shln(1);
const DisableSushiswapWETH = new BN(1).shln(2);

const DisableDODOALL = new BN(1).shln(3);
const DisableDODO = new BN(1).shln(4);
const DisableDODOWETH = new BN(1).shln(5);

const DexOne = artifacts.require("DexOne");
const ERC20 = artifacts.require("IERC20");
const Factory = artifacts.require("IUniswapV2Factory");


var pass = DisableSushiswapAll.add(DisableSushiswap).add(DisableSushiswapWETH).add(DisableDODOALL)
    .add(DisableDODO).add(DisableDODOWETH);


contract('DexOne', (accounts) => {

    it('DexOneAll should swap ETH to CAKE', async () => {

        let usdtAddress = "0xfd086bc7cd5c481dcc9c85ebe478a1c0b69fcbb9";
        let busdAddress = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56";
        //在bsc链上测试
        // usdtAddress = busdAddress;
        const usdt = await ERC20.at(usdtAddress);

        let ethAddress = "0x0000000000000000000000000000000000000000";

        let ooeAddress = "0x0ebd9537A25f56713E34c45b38F421A1e7191469";


        if (false) {
            let fAddress = "0xe0C1bb6DF4851feEEdc3E14Bd509FEAF428f7655";//sushiswap
            let f = await Factory.at(fAddress);
            let res = await f.getPair(wavaxAddress, usdtAddress);
            console.log("res:", res.toString());
            return;
        }

        var balance = await web3.eth.getBalance(accounts[0]);
        console.log("avax balance:", balance); //

        let balanceBefore = await usdt.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceBefore}) USDT`);

        let testName = "sushiswap";
        if (testName == "sushiswap") {
            pass = pass.sub(DisableSushiswapAll);
            pass = pass.sub(DisableSushiswap);
        } else if (testName == "dodo") {
            pass = pass.sub(DisableDODOALL);
            pass = pass.sub(DisableDODO);
        }

        const dexOne = await DexOne.deployed();
        let swapAmt = '1000000000000000000';
        const res = await dexOne.calculateSwapReturn(
            ethAddress, // matic
            usdtAddress, // usdt
            swapAmt, // 1.0
            10,
            pass,
        );
        let expectedOutAmount = res.outAmount;
        console.log(`expect out amount ${res.outAmount.toString()} USDT`);
        console.log("res.distribution:", res.distribution.toString());
        // await busd.approve(dexOne.address, swapAmt);
        await invokeContract(web3, accounts[0], dexOne, ethAddress, usdtAddress, swapAmt, res);
        let balanceAfter = await usdt.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceAfter}) USDT`);
        assert.equal(BigNumber(expectedOutAmount), BigNumber(balanceAfter) - BigNumber(balanceBefore));
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
    });
}
