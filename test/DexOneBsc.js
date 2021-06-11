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

const DisableUniswapV2ALL = new BN(1 << 0);
const DisableUniswapV2 = new BN(1).shln(1);
const DisableUniswapV2ETH = new BN(1).shln(2);
const DisableUniswapV2DAI = new BN(1).shln(3);
const DisableUniswapV2USDC = new BN(1).shln(4);
const DisableCurveALL = new BN(1).shln(5);
const DisableCurveCompound = new BN(1).shln(6);
const DisableCurveUSDT = new BN(1).shln(7);
const DisableCurveY = new BN(1).shln(8);
const DisableCurveBINANCE = new BN(1).shln(9);
const DisableCurveSYNTHETIX = new BN(1).shln(10);
const DisableCurvePAX = new BN(1).shln(11);
const DisableCurveRENBTC = new BN(1).shln(12);
const DisableCurveTBTC = new BN(1).shln(13);
const DisableCurveSBTC = new BN(1).shln(14);
const DisableOASIS = new BN(1).shln(15);
const DisableUNISWAP = new BN(1).shln(16);
const DisableSUSHISWAPALL = new BN(1).shln(17);
const DisableSUSHISWAP = new BN(1).shln(18);
const DisableSUSHISWAPETH = new BN(1).shln(19);
const DisableSUSHISWAPDAI = new BN(1).shln(20);
const DisableSUSHISWAPUSDC = new BN(1).shln(21);
const DisableMOONISWAP_ALL = new BN(1).shln(22);
const DisableMOONISWAP = new BN(1).shln(23);
const DisableMOONISWAP_ETH = new BN(1).shln(24);
const DisableMOONISWAP_DAI = new BN(1).shln(25);
const DisableMOONISWAP_USDC = new BN(1).shln(26);
const DisableBALANCER_ALL = new BN(1).shln(27);
const DisableBALANCER_1 = new BN(1).shln(28);
const DisableBALANCER_2 = new BN(1).shln(29);
const DisableBALANCER_3 = new BN(1).shln(30);
const DisableKYBER_ALL = new BN(1).shln(31);
const DisableKYBER_1 = new BN(1).shln(32);
const DisableKYBER_2 = new BN(1).shln(33);
const DisableKYBER_3 = new BN(1).shln(34);
const DisableKYBER_4 = new BN(1).shln(35);
const DisableDODO_ALL = new BN(1).shln(36);
const DisableDODO = new BN(1).shln(37);
const DisableDODO_USDC = new BN(1).shln(38);
const DisableDODO_USDT = new BN(1).shln(39);
const DisableSMOOTHY = new BN(1).shln(40);


const DexOne = artifacts.require("DexOne");
const ERC20 = artifacts.require("IERC20");
const IMooniswap = artifacts.require("IMooniswap");


var pass = DisableUniswapV2ALL.add(DisableUniswapV2).add(DisableUniswapV2ETH).add(DisableUniswapV2DAI)
    .add(DisableUniswapV2USDC).add(DisableCurveALL).add(DisableCurveCompound).add(DisableCurveUSDT)
    .add(DisableCurveY).add(DisableCurveBINANCE).add(DisableCurveSYNTHETIX).add(DisableCurvePAX)
    .add(DisableCurveRENBTC).add(DisableCurveTBTC).add(DisableCurveSBTC).add(DisableOASIS)
    .add(DisableUNISWAP).add(DisableSUSHISWAPALL).add(DisableSUSHISWAP).add(DisableSUSHISWAPETH)
    .add(DisableSUSHISWAPDAI).add(DisableSUSHISWAPUSDC).add(DisableMOONISWAP_ALL).add(DisableMOONISWAP)
    .add(DisableMOONISWAP_ETH).add(DisableMOONISWAP_DAI).add(DisableMOONISWAP_USDC).add(DisableBALANCER_ALL)
    .add(DisableBALANCER_1).add(DisableBALANCER_2).add(DisableBALANCER_3).add(DisableKYBER_ALL).add(DisableKYBER_1)
    .add(DisableKYBER_2).add(DisableKYBER_3).add(DisableKYBER_4).add(DisableDODO_ALL).add(DisableDODO)
    .add(DisableDODO_USDC).add(DisableDODO_USDT).add(DisableSMOOTHY);


contract('DexOne', (accounts) => {

    it('DexOneAll should swap ETH to CAKE', async () => {
        let ethInnerAddress = "0x0000000000000000000000000000000000000000";
        let usdcAddress = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";


        if (false) {
            const belt = await IBeltSwap.at("0xAEA4f7dcd172997947809CE6F12018a6D5c1E8b6");
            res = await belt.get_dy(3, 2, '1000000000000000000');
            console.log("res:", res.toString());
            return;
        }

        const usdc = await ERC20.at(usdcAddress);
        let balanceBefore = await usdc.balanceOf(accounts[0]);
        console.log(`balance of ${accounts[0]}: (${balanceBefore}) USDC`);

        let a = await web3.eth.getBalance(accounts[0]);
        console.log(`balance of ${accounts[0]}: (${a}) ETH`);

        pass = pass.sub(DisableMOONISWAP_ALL).sub(DisableMOONISWAP);

        let dexOne = await DexOne.deployed();
        let swapAmt = BigNumber(1e18);

        res = await dexOne.calculateSwapReturn(ethInnerAddress, usdcAddress, swapAmt, 0, pass);
        expectedOutAmount = res.outAmount;
        console.log("usdc calculateSwapReturn:", expectedOutAmount.toString());
        console.log("res.distribution:", res.distribution.toString());
        await usdc.approve(dexOne.address, swapAmt);
        await invokeContract(web3, accounts[0], dexOne, ethInnerAddress, usdcAddress, swapAmt, res);
        balanceAfter = await usdc.balanceOf(accounts[0]);
        console.log(`balance of ${accounts[0]}: (${balanceAfter}) USDC`);

        balanceAfter = await usdc.balanceOf(dexOne.address);
        console.log(`balance of ${dexOne.address}: (${balanceAfter}) USDC`);
        // assert.equal(expectedOutAmount, balanceAfter - balanceBefore);
    });

    // it('DexOneView should calculate', async () => {
    //     // const dexOne = await DexOneView.at('0x8338D73536699acFfEf9A2FD24311B85fa515F7F');
    //     const dexOne = await DexOneView.deployed();
    //     const res = await dexOne.calculateSwapReturn(
    //         // '0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c', // BNB
    //         // '0xfCe146bF3146100cfe5dB4129cf6C82b0eF4Ad8c', // DAI
    //         // '0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3', // DAI
    //         '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // BNB
    //         '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56', // DAI
    //         '1000000000000000000', // 1
    //         20,
    //         pass,
    //     );
    //     console.log(`expect out amount ${res.outAmount.toString()} DAI`);
    //     res.distribution.forEach(dist => {
    //         console.log(dist.toString());
    //     });
    // });

    // it('DexOneView should calculate single', async () => {
    //     const dexOne = await DexOneView.deployed();
    //     const res = await dexOne.calculateDexSwapReturns(
    //         '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // ETH
    //         '0x6B175474E89094C44Da98b954EedeAC495271d0F', // DAI
    //         '1000000000000000000', // 1.0
    //         DisableUniswapV2All.add(DisableUniswap).add(DisableSushiSwapAll).add(DisableMooniswapAll).add(DisableBalancerAll)
    //     );
    //     // console.log(`expect out amount ${res.outAmount.toString()} DAI`);
    //     res.forEach(dist => {
    //         console.log(dist.toString());
    //     });
    // });

    // it('DexOneView should return dex swap values', async function () {
    //     const dexOne = await DexOneView.deployed();
    //     const res = await dexOne.calculateDexSwapReturns(
    //         '0x6B175474E89094C44Da98b954EedeAC495271d0F', // DAI
    //         '0xB6eD7644C69416d67B522e20bC294A9a9B405B31', // BUSD
    //         '1000000000000000000', // 1.0
    //         0
    //     );

    //     res.forEach(amount => {
    //         console.log(amount.toString());
    //     });
    // });

    // it('DexOneAll should swap ETH to CAKE', async () => {
    //     const busd = await ERC20.at("0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56");
    //     let balanceBefore = await busd.balanceOf(accounts[0])
    //     console.log(`balance of ${accounts[0]}: (${balanceBefore}) BUSD`);
    //
    //     const dexOne = await DexOne.deployed();
    //     const res = await dexOne.calculateSwapReturn(
    //         '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // DAI
    //         '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56', // BUSD
    //         '1000000000000000000', // 1.0
    //         10,
    //         // 0,
    //         pass,
    //     );
    //     expectedOutAmount = res.outAmount;
    //     console.log(`expect out amount ${res.outAmount.toString()} BUSD`);
    //     // res.distribution.forEach(dist => {
    //     //     console.log(dist.toString());
    //     // });
    //     console.log("res.distribution:", res.distribution.toString());
    //
    //     const swapped = await dexOne.contract.methods.swap(
    //         '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE',
    //         '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56',
    //         '1000000000000000000',
    //         0,
    //         res.distribution.map(dist => dist.toString()),
    //         pass.toString(),
    //         // {
    //         //     value: "1000000000000000000",
    //         //     from: accounts[0]
    //         // }
    //     ).encodeABI();
    //     // console.log(swapped);
    //
    //     const nonce = await web3.eth.getTransactionCount(accounts[0]);
    //     console.log(`nonce: ${nonce}`);
    //
    //     const account = accounts[0];
    //     console.log(`account: ${account}`);
    //     const rawTx = {
    //         from: account,
    //         to: dexOne.address,
    //         gas: "0x166691b7",
    //         gasPrice: "0x4a817c800",
    //         data: swapped,
    //         // value: "0xde0b6b3a7640000",
    //         value: '1000000000000000000',
    //         nonce: web3.utils.toHex(nonce),
    //     }
    //     // console.log(rawTx);
    //
    //
    //     const sign = await web3.eth.accounts.signTransaction(rawTx, '0x94e6de53e500b9fec28037c583f5214c854c7229329ce9baf6f5577bd95f9c9a');
    //     // console.log(sign);
    //
    //     web3.eth.sendSignedTransaction(sign.rawTransaction).on('receipt', receipt => {
    //         // console.log(JSON.stringify(receipt));
    //     });
    //
    //     balanceAfter = await busd.balanceOf(accounts[0])
    //     console.log(`balance of ${accounts[0]}: (${balanceAfter}) BUSD`);
    //     assert.equal(expectedOutAmount, balanceAfter - balanceBefore);
    // });

    // it('DexOneAll should swap CAKE to BNB', async () => {
    //     const dai = await ERC20.at("0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c");
    //     const busd = await ERC20.at('0xfCe146bF3146100cfe5dB4129cf6C82b0eF4Ad8c');
    //     let balance = await dai.balanceOf(accounts[0])
    //     let bnbBalance = await busd.balanceOf(accounts[0])
    //     console.log(`balance of ${accounts[0]}: (${balance}) BUSD; (${bnbBalance}) USDT`);

    //     const dexOne = await DexOneAll.deployed();
    //     const res = await dexOne.calculateSwapReturn(
    //         '0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c', // DAI
    //         '0xfCe146bF3146100cfe5dB4129cf6C82b0eF4Ad8c', // BUSD
    //         balance, // 40
    //         20,
    //         flags
    //         );
    //     console.log(`expect out amount ${res.outAmount.toString()} BUSD`);
    //     res.distribution.forEach(dist => {
    //         console.log(dist.toString());
    //     });

    //     await dai.approve(DexOneAll.address, balance, {
    //         from: accounts[0]
    //     })
    //     const swapped = await dexOne.swap(
    //         '0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c', // DAI
    //         '0xfCe146bF3146100cfe5dB4129cf6C82b0eF4Ad8c', // BUSD
    //         balance,
    //         0,
    //         res.distribution,
    //         flags
    //         );
    //     console.log(swapped);

    //     balance = await dai.balanceOf(accounts[0])
    //      bnbBalance = await busd.balanceOf(accounts[0])
    //     console.log(`balance of ${accounts[0]}: (${balance}) BUSD; (${bnbBalance}) USDT`);
    // });

    // it('DexOneTransitional should execute', async () => {
    //     console.log(DexOneAll.address);

    //     let account = accounts[0];
    //     const dai = await ERC20.at("0x6B175474E89094C44Da98b954EedeAC495271d0F");
    //     const usdc = await ERC20.at("0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48");
    //     const busd = await ERC20.at("0x4Fabb145d64652a948d72533023f6E7A623C7C53");

    //     let daiBalance = await dai.balanceOf(account);
    //     let busdBalance = await busd.balanceOf(account);
    //     console.log(`balance of ${account}: (${daiBalance}) DAI; (${busdBalance}) BUSD`);

    //     const dexOne = await DexOneAll.deployed();

    //     const res = await dexOne.calculateSwapReturnWithGasTransitional(
    //         [
    //             '0x6B175474E89094C44Da98b954EedeAC495271d0F', // DAI
    //             '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48', // USDC
    //             '0x4Fabb145d64652a948d72533023f6E7A623C7C53' // BUSD
    //         ],
    //         '1000000000000000000', // 1.0
    //         [10, 10],
    //         [0, 0],
    //         [0, 0]
    //     );

    //     res.outAmounts.forEach(amount => {
    //         console.log(amount.toString());
    //     })
    //     res.distribution.forEach(dist => {
    //         console.log(dist.toString());
    //     });

    //     await dai.approve(DexOneAll.address, '1000000000000000000', {
    //         from: account
    //     })
    //     const swapped = await dexOne.swapTransitional(
    //         [
    //             '0x6B175474E89094C44Da98b954EedeAC495271d0F', // DAI
    //             '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48', // USDC
    //             '0x4Fabb145d64652a948d72533023f6E7A623C7C53' // BUSD
    //         ],
    //         '1000000000000000000',
    //         0,
    //         res.distribution,
    //         [0, 0], {
    //             from: accounts[0]
    //         }
    //     );

    //     daiBalance = await dai.balanceOf(account);
    //     busdBalance = await busd.balanceOf(account);
    //     console.log(`balance of ${account}: (${daiBalance}) DAI; (${busdBalance}) BUSD`);
    // });

    // it('DexOne should swap DAI to WBTC via Curves', async function () {
    //     console.log(DexOne.address);

    //     let account = accounts[0];
    //     const dai = await ERC20.at("0x6B175474E89094C44Da98b954EedeAC495271d0F");
    //     const busd = await ERC20.at("0x4Fabb145d64652a948d72533023f6E7A623C7C53");

    //     let daiBalance = await dai.balanceOf(account);
    //     let busdBalance = await busd.balanceOf(account);
    //     console.log(`balance of ${account}: (${daiBalance}) DAI; (${busdBalance}) BUSD`);

    //     const dexOne = await DexOne.deployed();
    //     const res = await dexOne.calculateSwapReturn(
    //         '0x6B175474E89094C44Da98b954EedeAC495271d0F', // DAI
    //         '0x4Fabb145d64652a948d72533023f6E7A623C7C53', // BUSD
    //         '1000000000000000000', // 1.0
    //         10,
    //         DisableUniswapV2All
    //     );

    //     console.log(res.outAmount.toString());
    //     res.distribution.forEach(dist => {
    //         console.log(dist.toString());
    //     });

    //     await dai.approve(DexOne.address, '1000000000000000000', {
    //         from: account
    //     })
    //     const swapped = await dexOne.swap(
    //         '0x6B175474E89094C44Da98b954EedeAC495271d0F',
    //         '0x4Fabb145d64652a948d72533023f6E7A623C7C53',
    //         '1000000000000000000',
    //         0,
    //         res.distribution,
    //         DisableUniswapV2All, {
    //             from: accounts[0]
    //         }
    //     );

    //     daiBalance = await dai.balanceOf(account);
    //     busdBalance = await busd.balanceOf(account);
    //     console.log(`balance of ${account}: (${daiBalance}) DAI; (${busdBalance}) BUSD`);
    // });

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
