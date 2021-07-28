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

const DisableSushiswapAll = new BN(1).shln(0);
const DisableSushiswap = new BN(1).shln(1);
const DisableSushiswapWAVAX = new BN(1).shln(2);
const DisableSushiswapDAI = new BN(1).shln(3);

const DisablePANGONLINSWAPALL = new BN(1).shln(4);
const DisablePANGONLINSWAP = new BN(1).shln(5);
const DisablePANGONLINSWAPWAVAX = new BN(1).shln(6);
const DisablePANGONLINSWAPDAI = new BN(1).shln(7);

const DisableJOESWAPALL = new BN(1).shln(8);
const DisableJOESWAP = new BN(1).shln(9);
const DisableJOESWAPWAVAX = new BN(1).shln(10);
const DisableJOESWAPDAI = new BN(1).shln(11);


const DexOne = artifacts.require("DexOne");
const ERC20 = artifacts.require("IERC20");
const Factory = artifacts.require("IUniswapV2Factory");


var pass = DisableSushiswapAll.add(DisableSushiswap)
    .add(DisableSushiswapWAVAX).add(DisableSushiswapDAI)
    .add(DisablePANGONLINSWAPALL).add(DisablePANGONLINSWAP).add(DisablePANGONLINSWAPWAVAX)
    .add(DisablePANGONLINSWAPDAI).add(DisableJOESWAPALL).add(DisableJOESWAP).add(DisableJOESWAPWAVAX)
    .add(DisableJOESWAPDAI);


contract('DexOne', (accounts) => {

    it('DexOneAll should swap ETH to CAKE', async () => {

        // 合约地址 不对  TODO
        let usdtAddress = "0xde3A24028580884448a5397872046a019649b084";
        const usdt = await ERC20.at(usdtAddress);

        let avaxAddress = "0x0000000000000000000000000000000000000000";
        let wavaxAddress = "0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7";

        if (false) {
            let fAddress = "0xc35DADB65012eC5796536bD9864eD8773aBc74C4";//sushiswap
            let f = await Factory.at(fAddress);
            let res = await f.getPair(wavaxAddress, usdtAddress);
            console.log("res:", res.toString());
            return;
        }

        var balance = await web3.eth.getBalance(accounts[0]);
        console.log("xDAI balance:", balance); //

        let balanceBefore = await usdt.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceBefore}) USDT`);

        let testName = "joeswap";
        if (testName == "sushiswap") {
            pass = pass.sub(DisableSushiswapAll);
            pass = pass.sub(DisableSushiswap);
        } else if (testName == "pangolinSwap") {
            pass = pass.sub(DisablePANGONLINSWAPALL);
            pass = pass.sub(DisablePANGONLINSWAP);
        } else if (testName == "joeswap") {
            pass = pass.sub(DisableJOESWAPALL);
            pass = pass.sub(DisableJOESWAP);
        }

        const dexOne = await DexOne.deployed();
        const res = await dexOne.calculateSwapReturn(
            avaxAddress, // matic
            usdtAddress, // usdt
            '1000000000000000000', // 1.0
            10,
            pass,
        );
        expectedOutAmount = res.outAmount;
        console.log(`expect out amount ${res.outAmount.toString()} USDT`);
        console.log("res.distribution:", res.distribution.toString());
        const swapped = await dexOne.contract.methods.swap(
            avaxAddress,
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
