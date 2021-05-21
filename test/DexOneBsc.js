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

const DisableUniswapV2All = new BN(1 << 0);
const DisableUniswapV2 = new BN(1).shln(1);
const DisableUniswapV2ETH = new BN(1).shln(2);
const DisableUniswapV2DAI = new BN(1).shln(3);
const DisableUniswapV2USDC = new BN(1).shln(4);

const DisableSushiswapAll = new BN(1).shln(5);
const DisableSushiswap = new BN(1).shln(6);
const DisableSushiswapETH = new BN(1).shln(7);
const DisableSushiswapDAI = new BN(1).shln(8);
const DisableSushiswapUSDC = new BN(1).shln(9);


const DexOneView = artifacts.require("DexOneView");
const DexOne = artifacts.require("DexOne");
const DexOneAll = artifacts.require("DexOneAll");
const ERC20 = artifacts.require("IERC20");
const Factory = artifacts.require("IUniswapV2Factory");


var pass = DisableUniswapV2All.add(DisableUniswapV2).add(DisableUniswapV2ETH)
    .add(DisableUniswapV2DAI).add(DisableUniswapV2USDC).add(DisableSushiswapAll)
    .add(DisableSushiswap).add(DisableSushiswapETH).add(DisableSushiswapDAI)
    .add(DisableSushiswapUSDC);


contract('DexOne', (accounts) => {

    it('DexOneAll should swap ETH to CAKE', async () => {

        let usdtAddress = "0xe0B887D54e71329318a036CF50f30Dbe4444563c";
        const usdt = await ERC20.at(usdtAddress);

        let xdaiAddress = "0x0000000000000000000000000000000000000000";
        let wxdaiAddress = "0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d";

        if (true) {
            let fAddress = "0xA818b4F111Ccac7AA31D0BCc0806d64F2E0737D7";//honeyswap
            fAddress = "0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac";//sushiswap
            let f = await Factory.at(fAddress);
            let res = await f.getPair(xdaiAddress, usdtAddress);
            console.log("res:", res.toString());
            return;
        }

        var balance = await web3.eth.getBalance(accounts[0]);
        console.log("xDAI balance:", balance); //

        let balanceBefore = await usdt.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceBefore}) USDT`);

        let testName = "sushiswap";
        if (testName == "honeyswap") {
            pass = pass.sub(DisableUniswapV2All);
            pass = pass.sub(DisableUniswapV2);
        } else if (testName == "sushiswap") {
            pass = pass.sub(DisableSushiswapAll);
            pass = pass.sub(DisableSushiswap);
        }


        const dexOne = await DexOne.deployed();
        const res = await dexOne.calculateSwapReturn(
            xdaiAddress, // matic
            usdtAddress, // usdt
            '1000000000000000000', // 1.0
            10,
            pass,
        );
        expectedOutAmount = res.outAmount;
        console.log(`expect out amount ${res.outAmount.toString()} USDT`);
        console.log("res.distribution:", res.distribution.toString());
        const swapped = await dexOne.contract.methods.swap(
            xdaiAddress,
            usdtAddress,
            '1000000000000000000',
            0,
            res.distribution.map(dist => dist.toString()),
            pass.toString(),
        ).encodeABI();
        const nonce = await web3.eth.getTransactionCount(accounts[0]);

        const account = accounts[0];
        console.log(`account: ${account}`);
        const rawTx = {
            from: account,
            to: dexOne.address,
            gas: "0x166691b7",
            gasPrice: "0x4a817c800",
            data: swapped,
            value: '1000000000000000000',
            nonce: web3.utils.toHex(nonce),
        }

        const sign = await web3.eth.accounts.signTransaction(rawTx, '0x94e6de53e500b9fec28037c583f5214c854c7229329ce9baf6f5577bd95f9c9a');

        web3.eth.sendSignedTransaction(sign.rawTransaction).on('receipt', receipt => {
        });

        balanceAfter = await usdt.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceAfter}) USDT`);
        assert.equal(expectedOutAmount, balanceAfter - balanceBefore);
    });
});
