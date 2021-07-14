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

const DisablePancakeAll = new BN(1 << 0);
// const DisableUniswapV2 = new BN(1 << 1);
// const DisableUniswap = new BN(1).shln(16);
const DisableBakeryAll = new BN(1).shln(6);
const DisableBurgerAll = new BN(1).shln(12);
const DisableThugswapAll = new BN(1).shln(16);
const DisableStablexAll = new BN(1).shln(25);
const DisableUnifiAll = new BN(1).shln(32);
const DisableJulswapAll = new BN(1).shln(35);
const DisableAcryptosAll = new BN(1).shln(43);
const DisableApeswapAll = new BN(1).shln(48);
const DisableApeswap = new BN(1).shln(49);
const DisableDODOAll = new BN(1).shln(54);
const DisableSmoothy = new BN(1).shln(58);
const DisableEllipsis = new BN(1).shln(59);
const DisableMdexAll = new BN(1).shln(60);
const DisablePancakeAllV2 = new BN(1).shln(66);
const DisableNerveAll = new BN(1).shln(73);
const DisableCafeswapAll = new BN(1).shln(77);
const DisableBeltswapAll = new BN(1).shln(78);

const DisableMooniswapAll = new BN(1).shln(79);
const DisableMooniswap = new BN(1).shln(80);
const DisableMooniswapETH = new BN(1).shln(81);
const DisableMooniswapDAI = new BN(1).shln(82);
const DisableMooniswapUSDC = new BN(1).shln(83);

const DisablePantherSwapALL = new BN(1).shln(84);
const DisablePantherSwap = new BN(1).shln(85);
const DisablePantherSwapBNB = new BN(1).shln(86);
const DisablePantherSwapUSDC = new BN(1).shln(87);
const DisablePantherSwapUSDT = new BN(1).shln(88);

const DisablePancakeBunny = new BN(1).shln(89);

const DisableOOSWAP = new BN(1).shln(90);


const DexOne = artifacts.require("DexOne");
const ERC20 = artifacts.require("IERC20");
const IMooniswap = artifacts.require("IMooniswap");


var pass = DisablePancakeAll.add(DisableBurgerAll).add(DisableThugswapAll)
    .add(DisableStablexAll).add(DisableUnifiAll).add(DisableJulswapAll).add(DisableDODOAll)
    .add(DisableApeswapAll).add(DisableAcryptosAll).add(DisableApeswap).add(DisableSmoothy)
    .add(DisableEllipsis).add(DisableMdexAll).add(DisableBakeryAll).add(DisableNerveAll)
    .add(DisableCafeswapAll).add(DisableBeltswapAll).add(DisableMooniswapAll)
    .add(DisableMooniswap).add(DisableMooniswapETH).add(DisableMooniswapDAI)
    .add(DisableMooniswapUSDC).add(DisablePantherSwapALL).add(DisablePantherSwap)
    .add(DisablePantherSwapBNB).add(DisablePantherSwapUSDC).add(DisablePantherSwapUSDT)
    .add(DisablePancakeBunny).add(DisableOOSWAP);


contract('DexOne', (accounts) => {

    it('DexOneAll should swap ETH to CAKE', async () => {
        let ooeAddress = "0x9029fdfae9a03135846381c7ce16595c3554e10a";
        let busdAddress = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56";
        let ethInnerAddress = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE";
        let usdtAddress = "0x55d398326f99059fF775485246999027B3197955";
        if (false) {
            const belt = await IBeltSwap.at("0xAEA4f7dcd172997947809CE6F12018a6D5c1E8b6");
            res = await belt.get_dy(3, 2, '1000000000000000000');
            console.log("res:", res.toString());
            return;
        }
        const busd = await ERC20.at(busdAddress);
        let balanceBefore = await busd.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceBefore}) BUSD`);

        const dexOne = await DexOne.deployed();
        let swapAmt = BigNumber(1000000000000000000);
        // eth 换成 busd
        let res = await dexOne.calculateSwapReturn(ethInnerAddress, busdAddress, swapAmt, 10, pass,);
        expectedOutAmount = res.outAmount;
        console.log(`expect out amount ${res.outAmount.toString()} BUSD`);
        console.log("res.distribution:", res.distribution.toString());


        await invokeContract(web3, accounts[0], dexOne, ethInnerAddress, busdAddress, swapAmt, res);
        balanceAfter = await busd.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceAfter}) BUSD`);
        // assert.equal(expectedOutAmount, balanceAfter - balanceBefore);
        const ooe = await ERC20.at(ooeAddress);
        const usdt = await ERC20.at(usdtAddress);
        let tokenOut = {
            name:"usdt",
            instance:usdt,
            address:usdtAddress,
        }
        let testName = "pantherswap";
        // busd swap usdt
        if (testName == "nerve") {
            console.log("*************** nerve ***************");
            pass = pass.add(DisablePancakeAllV2);
            pass = pass.sub(DisableNerveAll);
        } else if (testName == "cafeswap") {
            console.log("*************** cafeswap ***************");
            pass = pass.add(DisablePancakeAllV2);
            pass = pass.sub(DisableCafeswapAll);
        } else if (testName == "beltswap") {
            console.log("*************** beltswap ***************");
            pass = pass.add(DisablePancakeAllV2);
            pass = pass.sub(DisableBeltswapAll);
        } else if (testName == "mooniswap") {
            pass = pass.add(DisablePancakeAllV2);
            pass = pass.sub(DisableMooniswapAll);
            pass = pass.sub(DisableMooniswap);
        } else if (testName == "pantherswap") {
            pass = pass.add(DisablePancakeAllV2);
            pass = pass.sub(DisablePantherSwapALL);
            // pass = pass.sub(DisablePantherSwap);
            // pass = pass.sub(DisablePantherSwapBNB);
            pass = pass.sub(DisablePantherSwapUSDC);
            // pass = pass.sub(DisablePantherSwapUSDT);
        } else if (testName == "pancakeBunny") {
            pass = pass.add(DisablePancakeAllV2);
            pass = pass.sub(DisablePancakeBunny);
        } else if (testName == "ooswap") {
            pass = pass.add(DisablePancakeAllV2);
            pass = pass.sub(DisableOOSWAP);
            tokenOut = {
                name:"ooe",
                instance:ooe,
                address:ooeAddress,
            }
        }


        balanceBefore = await tokenOut.instance.balanceOf(accounts[0]);
        console.log(`balance of ${accounts[0]}: (${balanceBefore}) (${tokenOut.name})`);
        res = await dexOne.calculateSwapReturn(busdAddress, tokenOut.address, swapAmt, 5, pass);
        expectedOutAmount = res.outAmount;
        console.log("ooe calculateSwapReturn:", expectedOutAmount.toString());
        console.log("res.distribution:", res.distribution.toString());
        await busd.approve(dexOne.address, swapAmt);
        await invokeContract(web3, accounts[0], dexOne, busdAddress, tokenOut.address, swapAmt, res);
        balanceAfter = await tokenOut.instance.balanceOf(accounts[0]);
        console.log(`balance of ${accounts[0]}: (${balanceAfter}) (${tokenOut.name})`);
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
