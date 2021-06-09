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


const DexOne = artifacts.require("DexOne");
const ERC20 = artifacts.require("IERC20");
const Factory = artifacts.require("IUniswapV2Factory");


var pass = DisableUniswapV2All.add(DisableUniswapV2).add(DisableUniswapV2ETH)
    .add(DisableUniswapV2DAI).add(DisableUniswapV2USDC).add(DisableSushiswapAll)
    .add(DisableSushiswap).add(DisableSushiswapETH).add(DisableSushiswapDAI)
    .add(DisableSushiswapUSDC);


contract('DexOne', (accounts) => {

    it('DexOneAll should swap ETH to CAKE', async () => {

        // 合约地址 不对  TODO
        let usdcAddress = "0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83";
        const usdc = await ERC20.at(usdcAddress);

        let xdaiAddress = "0x0000000000000000000000000000000000000000";
        let wxdaiAddress = "0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d";

        if (false) {
            let fAddress = "0xA818b4F111Ccac7AA31D0BCc0806d64F2E0737D7";//honeyswap
            // sushiswap 地址不对
            // fAddress = "0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac";//sushiswap
            fAddress = "0xc35DADB65012eC5796536bD9864eD8773aBc74C4";
            let f = await Factory.at(fAddress);
            let res = await f.getPair(wxdaiAddress, usdcAddress);
            console.log("res:", res.toString());
            return;
        }

        var balance = await web3.eth.getBalance(accounts[0]);
        console.log("xDAI balance:", balance); //

        let balanceBefore = await usdc.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceBefore}) USDC`);

        let testName = "sushiswap";

        if (testName == "honeyswap") {
            // xdai -> usdc
            pass = pass.sub(DisableUniswapV2All);
            pass = pass.sub(DisableUniswapV2);
        } else if (testName == "sushiswap") {
            pass = pass.sub(DisableSushiswapAll);
            pass = pass.sub(DisableSushiswap);
        }


        const dexOne = await DexOne.deployed();
        const res = await dexOne.calculateSwapReturn(
            xdaiAddress, // matic
            usdcAddress, // usdt
            '1000000000000000000', // 1.0
            10,
            pass,
        );
        expectedOutAmount = res.outAmount;
        console.log(`expect out amount ${res.outAmount.toString()} USDC`);
        console.log("res.distribution:", res.distribution.toString());
        const swapped = await dexOne.contract.methods.swap(
            xdaiAddress,
            usdcAddress,
            '1000000000000000000',
            0,
            res.distribution.map(dist => dist.toString()),
            pass.toString(),
        ).encodeABI();
        const nonce = await web3.eth.getTransactionCount(accounts[0]);

        const account = accounts[0];
        console.log("account:", account);
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

        balanceAfter = await usdc.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceAfter}) USDC`);
        assert.equal(expectedOutAmount, balanceAfter - balanceBefore);
    });
});
