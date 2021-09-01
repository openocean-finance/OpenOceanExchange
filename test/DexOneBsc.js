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
const DisableSushiswapFTM = new BN(1).shln(2);

const DisableSPOOKYSWAPAll = new BN(1).shln(3);
const DisableSPOOKYSWAP = new BN(1).shln(4);
const DisableSPOOKYSWAPFTM = new BN(1).shln(5);

const DisableSPIRITSWAPAll = new BN(1).shln(6);
const DisableSPIRITSWAP = new BN(1).shln(7);
const DisableSPIRITSWAPFTM = new BN(1).shln(8);

const DisableCURVE_2POOL = new BN(1).shln(9);
const DisableCURVE_FUSDT = new BN(1).shln(10);
const DisableCURVE_RENBTC = new BN(1).shln(11);


const DexOneView = artifacts.require("DexOneView");
const DexOne = artifacts.require("DexOne");
const DexOneAll = artifacts.require("DexOneAll");
const ERC20 = artifacts.require("IERC20");
const Factory = artifacts.require("IUniswapV2Factory");


var pass = DisableSushiswapAll.add(DisableSushiswap).add(DisableSushiswapFTM)
    .add(DisableSPOOKYSWAPAll).add(DisableSPOOKYSWAP).add(DisableSPOOKYSWAPFTM)
    .add(DisableSPIRITSWAPAll).add(DisableSPIRITSWAP).add(DisableSPIRITSWAPFTM)
    .add(DisableCURVE_2POOL).add(DisableCURVE_FUSDT).add(DisableCURVE_RENBTC);


contract('DexOne', (accounts) => {

    it('DexOneAll should swap ETH to CAKE', async () => {

        // 合约地址 不对  TODO
        let usdtAddress = "0x049d68029688eabf473097a2fc38ef61633a3c7a";
        const usdt = await ERC20.at(usdtAddress);

        let fmtAddress = "0x0000000000000000000000000000000000000000";
        let wftmAddress = "0x21be370d5312f44cb42ce377bc9b8a0cef1a4c83";

        if (false) {
            let fAddress = "0xA818b4F111Ccac7AA31D0BCc0806d64F2E0737D7";//honeyswap

            fAddress = "0xc35DADB65012eC5796536bD9864eD8773aBc74C4";//sushiswap
            let f = await Factory.at(fAddress);
            let res = await f.getPair(wftmAddress, usdtAddress);
            console.log("res:", res.toString());
            return;
        }

        var balance = await web3.eth.getBalance(accounts[0]);
        console.log("xDAI balance:", balance); //

        let balanceBefore = await usdt.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceBefore}) USDT`);

        let testName = "spookyswap";
        if (testName == "sushiswap") {
            pass = pass.sub(DisableSushiswapAll);
            pass = pass.sub(DisableSushiswap);
        } else if (testName == "spookyswap") {
            pass = pass.sub(DisableSPOOKYSWAPAll);
            pass = pass.sub(DisableSPOOKYSWAP);
        }
        const dexOne = await DexOne.deployed();
        let swapAmt = '1000000000000000000';
        const res = await dexOne.calculateSwapReturn(fmtAddress, usdtAddress, swapAmt, 10, pass);
        expectedOutAmount = res.outAmount;
        console.log(`expect out amount ${res.outAmount.toString()} USDT`);
        console.log("res.distribution:", res.distribution.toString());

        await usdt.approve(dexOne.address, swapAmt);
        await invokeContract(web3, accounts[0], dexOne, fmtAddress, usdtAddress, swapAmt, res);
        balanceAfter = await usdt.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceAfter}) USDT`);
        assert.equal(expectedOutAmount, balanceAfter - balanceBefore);


    });
});

async function invokeContract(web3, account, dexOne, srcToken, dstToken, swapAmt, distribution) {
    console.log(`account: ${account}`);
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
