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

const DisableLYDIASWAPALL = new BN(1).shln(12);
const DisableLYDIASWAP = new BN(1).shln(13);
const DisableLYDIASWAPWAVAX = new BN(1).shln(14);
const DisableLYDIASWAPDAI = new BN(1).shln(15);

const DisableBAGUETTESWAPALL = new BN(1).shln(16);
const DisableBAGUETTESWAP = new BN(1).shln(17);
const DisableBAGUETTESWAPWAVAX = new BN(1).shln(18);
const DisableBAGUETTESWAPDAI = new BN(1).shln(19);

const DisableOOESWAPALL = new BN(1).shln(20);
const DisableOOESWAP = new BN(1).shln(21);
const DisableOOESWAPWAVAX = new BN(1).shln(22);
const DisableOOESWAPDAI = new BN(1).shln(23);

const DexOne = artifacts.require("DexOne");
const ERC20 = artifacts.require("IERC20");
const Factory = artifacts.require("IUniswapV2Factory");


var pass = DisableSushiswapAll.add(DisableSushiswap).add(DisableSushiswapWAVAX).add(DisableSushiswapDAI)
    .add(DisablePANGONLINSWAPALL).add(DisablePANGONLINSWAP).add(DisablePANGONLINSWAPWAVAX).add(DisablePANGONLINSWAPDAI)
    .add(DisableJOESWAPALL).add(DisableJOESWAP).add(DisableJOESWAPWAVAX).add(DisableJOESWAPDAI)
    .add(DisableLYDIASWAPALL).add(DisableLYDIASWAP).add(DisableLYDIASWAPWAVAX).add(DisableLYDIASWAPDAI)
    .add(DisableBAGUETTESWAPALL).add(DisableBAGUETTESWAP).add(DisableBAGUETTESWAPWAVAX).add(DisableBAGUETTESWAPDAI)
    .add(DisableOOESWAPALL).add(DisableOOESWAP).add(DisableOOESWAPWAVAX).add(DisableOOESWAPDAI);


contract('DexOne', (accounts) => {

    it('DexOneAll should swap ETH to CAKE', async () => {

        let usdtAddress = "0xfd086bc7cd5c481dcc9c85ebe478a1c0b69fcbb9";
        const usdt = await ERC20.at(usdtAddress);

        let avaxAddress = "0x0000000000000000000000000000000000000000";
        let wavaxAddress = "0x82af49447d8a07e3bd95bd0d56f35241523fbab1";

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
        } else if (testName == "pangolinSwap") {
            pass = pass.sub(DisablePANGONLINSWAPALL);
            pass = pass.sub(DisablePANGONLINSWAP);
        } else if (testName == "joeswap") {
            pass = pass.sub(DisableJOESWAPALL);
            pass = pass.sub(DisableJOESWAP);
        } else if (testName == "lydia") {
            pass = pass.sub(DisableLYDIASWAPALL);
            pass = pass.sub(DisableLYDIASWAP);
        } else if (testName == "baguette") {
            pass = pass.sub(DisableBAGUETTESWAPALL);
            pass = pass.sub(DisableBAGUETTESWAP);
        }

        const dexOne = await DexOne.deployed();
        let swapAmt = '1000000000000000000';
        const res = await dexOne.calculateSwapReturn(
            avaxAddress, // matic
            usdtAddress, // usdt
            swapAmt, // 1.0
            10,
            pass,
        );
        let expectedOutAmount = res.outAmount;
        console.log(`expect out amount ${res.outAmount.toString()} USDT`);
        console.log("res.distribution:", res.distribution.toString());
        // await busd.approve(dexOne.address, swapAmt);
        await invokeContract(web3, accounts[0], dexOne, avaxAddress, usdtAddress, swapAmt, res);
        let balanceAfter = await usdt.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceAfter}) USDT`);
        assert.equal(BigNumber(expectedOutAmount), BigNumber(balanceAfter) - BigNumber(balanceBefore));

        const ooe = await ERC20.at(ooeAddress);
        // 用USDT 换OOE
        if (testName == "baguette") {
            pass = pass.add(DisableBAGUETTESWAPALL);
            pass = pass.add(DisableBAGUETTESWAP);

            pass = pass.sub(DisableOOESWAPALL);
            pass = pass.sub(DisableOOESWAP);

            const res = await dexOne.calculateSwapReturn(
                usdtAddress, // usdt
                ooeAddress, // ooe
                expectedOutAmount, // 1.0
                10,
                pass,
            );
            let newExpectedOutAmount = res.outAmount;
            console.log(`expect out amount ${res.outAmount.toString()} OOE`);
            console.log("res.distribution:", res.distribution.toString());
            balanceBefore = await ooe.balanceOf(accounts[0]);
            await usdt.approve(dexOne.address, expectedOutAmount);
            await invokeContract(web3, accounts[0], dexOne, usdtAddress, ooeAddress, expectedOutAmount, res);
            balanceAfter = await ooe.balanceOf(accounts[0]);
            console.log(`balance of ${accounts[0]}: (${balanceAfter}) OOE`);
            assert.equal(BigNumber(newExpectedOutAmount), BigNumber(balanceAfter) - BigNumber(balanceBefore));
        }
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
