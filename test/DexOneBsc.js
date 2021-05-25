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

const DisableSeeswapAll = new BN(1).shln(0);
const DisableSeeswap = new BN(1).shln(1);
const DisableSeeswapONE = new BN(1).shln(2);

const DexOne = artifacts.require("DexOne");
const ERC20 = artifacts.require("IERC20");


var pass = DisableSeeswapAll.add(DisableSeeswap).add(DisableSeeswapONE);



contract('DexOne', (accounts) => {

    it('DexOneAll should swap ETH to CAKE', async () => {

        // 合约地址
        let usdsAddress = "0xFCE523163e2eE1F5f0828eCe554E9D839bEA17F5";
        const usdt = await ERC20.at(usdsAddress);

        let oneAddress = "0x0000000000000000000000000000000000000000";


        var balance = await web3.eth.getBalance(accounts[0]);
        console.log("one balance:", balance); //

        let balanceBefore = await usdt.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceBefore}) USDs`);

        pass = pass.sub(DisableSeeswapAll);
        pass = pass.sub(DisableSeeswap);


        const dexOne = await DexOne.deployed();
        const res = await dexOne.calculateSwapReturn(
            oneAddress,
            usdsAddress,
            '1000000000000000000', // 1.0
            10,
            pass,
        );
        expectedOutAmount = res.outAmount;
        console.log(`expect out amount ${res.outAmount.toString()} USDs`);
        console.log("res.distribution:", res.distribution.toString());
        const swapped = await dexOne.contract.methods.swap(
            oneAddress,
            usdsAddress,
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
        console.log(`balance of ${accounts[0]}: (${balanceAfter}) USDs`);
        assert.equal(expectedOutAmount, balanceAfter - balanceBefore);
    });
});
