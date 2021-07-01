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

const DisableQuickSwapAll = new BN(1 << 0);
const DisableQuickSwap = new BN(1).shln(1);
const DisableQuickSwapMATIC = new BN(1).shln(2);
const DisableQuickSwapDAI = new BN(1).shln(3);
const DisableQuickSwapUSDC = new BN(1).shln(4);
const DisableQuickSwapUSDT = new BN(1).shln(5);
const DisableQuickSwapQUICK = new BN(1).shln(6);
const DisableSushiswapAll = new BN(1).shln(7);
const DisableSushiswap = new BN(1).shln(8);
const DisableSushiswapETH = new BN(1).shln(9);
const DisableSushiswapDAI = new BN(1).shln(10);
const DisableSushiswapUSDC = new BN(1).shln(11);
const DisableSushiswapUSDT = new BN(1).shln(12);
const DisableWETH = new BN(1).shln(13);
const DisableComethALL = new BN(1).shln(14);
const DisableCometh = new BN(1).shln(15);
const DisableComethETH = new BN(1).shln(16);
const DisableComethMUST = new BN(1).shln(17);
const DisableDfynALL = new BN(1).shln(18);
const DisableDfyn = new BN(1).shln(19);
const DisableDfynETH = new BN(1).shln(20);
const DisableDfynUSDC = new BN(1).shln(21);
const DisableDfynUSDT = new BN(1).shln(22);
const DisablePolyzapALL = new BN(1).shln(23);
const DisablePolyzap = new BN(1).shln(24);
const DisablePolyzapETH = new BN(1).shln(25);
const DisablePolyzapUSDC = new BN(1).shln(26);
const DisableCurveALL = new BN(1).shln(27);
const DisableCurveAAVE = new BN(1).shln(28);
const DisableOneSwap = new BN(1).shln(29);
const DisablePolyDexALL = new BN(1).shln(30);
const DisablePolyDex = new BN(1).shln(31);
const DisablePolyDexWETH = new BN(1).shln(32);
const DisablePolyDexDAI = new BN(1).shln(33);
const DisablePolyDexUSDC = new BN(1).shln(34);
const DisablePolyDexUSDT = new BN(1).shln(35);

const DexOne = artifacts.require("DexOne");
const ERC20 = artifacts.require("IERC20");
const IPolydexFactory = artifacts.require("IPolydexFactory");


var pass = DisableQuickSwapAll.add(DisableQuickSwap).add(DisableQuickSwapMATIC)
    .add(DisableQuickSwapDAI).add(DisableQuickSwapUSDC).add(DisableQuickSwapUSDT)
    .add(DisableQuickSwapQUICK).add(DisableSushiswapAll)
    .add(DisableSushiswap).add(DisableSushiswapETH).add(DisableSushiswapDAI)
    .add(DisableSushiswapUSDC).add(DisableSushiswapUSDT).add(DisableWETH)
    .add(DisableComethALL).add(DisableCometh).add(DisableComethETH)
    .add(DisableComethMUST).add(DisableDfynALL).add(DisableDfyn)
    .add(DisableDfynETH).add(DisableDfynUSDC).add(DisableDfynUSDT)
    .add(DisablePolyzapALL).add(DisablePolyzap).add(DisablePolyzapETH)
    .add(DisablePolyzapUSDC).add(DisableCurveALL).add(DisableCurveAAVE)
    .add(DisableOneSwap).add(DisablePolyDexALL).add(DisablePolyDex)
    .add(DisablePolyDexWETH).add(DisablePolyDexDAI).add(DisablePolyDexUSDC)
    .add(DisablePolyDexUSDT);


contract('DexOne', (accounts) => {
    it('test swap', async () => {
        let usdtAddress = "0xc2132D05D31c914a87C6611C10748AEb04B58e8F";
        let usdt = await ERC20.at(usdtAddress);
        let maticAddress = "0x0000000000000000000000000000000000001010";
        let mustAddress = "0x9C78EE466D6Cb57A4d01Fd887D2b5dFb2D46288f";
        let testName = "";// TODO
        let wmatic = "0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270";
        let wethAddress = "0x7ceb23fd6bc0add59e62ac25578270cff1b9f619";

        if (false) {
            let factory = await IPolydexFactory.at("0xEAA98F7b5f7BfbcD1aF14D0efAa9d9e68D82f640");
            let res = await factory.getPair(wmatic, wethAddress);
            console.log("res:", res.toString());
            return;
        }
        let tokenIn = {
            address: maticAddress,
            name: "matic",
        }
        let tokenOut = {
            instance: usdt,
            address: usdtAddress,
            name: "usdt",
        }
        let amount = '1000000000000000000';
        testName = "polyDex";
        if (testName == "quickswap") {
            pass = pass.sub(DisableQuickSwapAll);
            // pass = pass.sub(DisableQuickSwap);
            // pass = pass.sub(DisableQuickSwapDAI);
            // pass = pass.sub(DisableQuickSwapUSDC);
            pass = pass.sub(DisableQuickSwapQUICK);
        } else if (testName == "sushiswap") {
            pass = pass.sub(DisableSushiswapAll);
            // pass = pass.sub(DisableSushiswap);
            // pass = pass.sub(DisableSushiswapDAI);
            pass = pass.sub(DisableSushiswapUSDC);
        } else if (testName == "wethAddress") { // 0
            pass = pass.sub(DisableWETH);
        } else if (testName == "cometh") {
            pass = pass.sub(DisableComethALL);
            pass = pass.sub(DisableCometh);
            // pass = pass.sub(DisableComethMUST);
        } else if (testName == "dfyn") {  //0
            pass = pass.sub(DisableDfynALL);
            pass = pass.sub(DisableDfyn);
        } else if (testName == "polyzap") {
            pass = pass.sub(DisablePolyzapALL);
            pass = pass.sub(DisablePolyzap);
        } else if (testName == "curve") {
            pass = pass.sub(DisableCurveALL);
            pass = pass.sub(DisableCurveAAVE);
        } else if (testName == "polyDex") {
            // tokenOut.address = wethAddress;
            // tokenOut.name = "weth";
            // tokenOut.instance = await ERC20.at(wethAddress);
            pass = pass.sub(DisablePolyDexALL);
            // pass = pass.sub(DisablePolyDex);
            pass = pass.sub(DisablePolyDexWETH);
        } else {
            return;
        }
        let balanceBefore = await tokenOut.instance.balanceOf(accounts[0]);
        console.log(`balance of ${accounts[0]}: (${balanceBefore}) (${tokenOut.name})`);
        const dexOne = await DexOne.deployed();

        const res = await dexOne.calculateSwapReturn(
            tokenIn.address,
            tokenOut.address,
            amount, // 1.0
            10,
            pass,
        );
        expectedOutAmount = res.outAmount;
        console.log(`expect out amount ${res.outAmount.toString()} (${tokenOut.name})`);
        console.log("res.distribution:", res.distribution.toString());
        const account = accounts[0];

        await swap(account, dexOne, web3, tokenIn.address, tokenOut.address, amount, res, pass);

        balanceAfter = await tokenOut.instance.balanceOf(accounts[0]);
        console.log(`balance of ${accounts[0]}: (${balanceAfter}) (${tokenOut.name})`);

        // assert.equal(expectedOutAmount, balanceAfter - balanceBefore);
        //test oneSwap
        if (testName == "quickswap") {
            pass = pass.add(DisableQuickSwapAll);
            pass = pass.add(DisableQuickSwapQUICK);
            pass = pass.sub(DisableOneSwap);

            let usdcAddress = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";
            let usdc = await ERC20.at(usdcAddress);

            await usdt.approve(dexOne.address, balanceAfter);

            const res = await dexOne.calculateSwapReturn(
                usdtAddress,
                usdcAddress,
                balanceAfter, // 1.0
                10,
                pass,
            );
            console.log(`expect out amount ${res.outAmount.toString()} USDC`);
            console.log("res.distribution:", res.distribution.toString());
            await swap(account, dexOne, web3, usdtAddress, usdcAddress, balanceAfter, res, pass);
            balanceAfter2 = await usdc.balanceOf(accounts[0]);
            console.log(`balance of ${accounts[0]}: (${balanceAfter2}) USDC`);
            assert.equal(res.outAmount, balanceAfter2);
        }
    });

    async function swap(account, dexOne, web3, maticAddress, usdtAddress, amount, res, pass) {
        const nonce = await web3.eth.getTransactionCount(accounts[0]);
        const swapped = await dexOne.contract.methods.swap(
            maticAddress,
            usdtAddress,
            amount,
            0,
            res.distribution.map(dist => dist.toString()),
            pass.toString(),
        ).encodeABI();

        const rawTx = {
            from: account,
            to: dexOne.address,
            gas: "0x166691b7",
            gasPrice: "0x4a817c800",
            data: swapped,
            value: amount,
            nonce: web3.utils.toHex(nonce),
        }
        const sign = await web3.eth.accounts.signTransaction(rawTx, '0x94e6de53e500b9fec28037c583f5214c854c7229329ce9baf6f5577bd95f9c9a');
        web3.eth.sendSignedTransaction(sign.rawTransaction).on('receipt', receipt => {
        });
    }

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
    //         DisableQuickswapAll.add(DisableUniswap).add(DisableSushiSwapAll).add(DisableMooniswapAll).add(DisableBalancerAll)
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
    //         DisableQuickswapAll
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
    //         DisableQuickswapAll, {
    //             from: accounts[0]
    //         }
    //     );

    //     daiBalance = await dai.balanceOf(account);
    //     busdBalance = await busd.balanceOf(account);
    //     console.log(`balance of ${account}: (${daiBalance}) DAI; (${busdBalance}) BUSD`);
    // });

});
