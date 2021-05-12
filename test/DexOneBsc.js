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

const DexOneView = artifacts.require("DexOneView");
const DexOne = artifacts.require("DexOne");
const DexOneAll = artifacts.require("DexOneAll");
const ERC20 = artifacts.require("IERC20");

const pass = DisablePancakeAll.add(DisableBurgerAll).add(DisableThugswapAll)
    .add(DisableStablexAll).add(DisableUnifiAll).add(DisableJulswapAll).add(DisableDODOAll)
    .add(DisableApeswapAll).add(DisableAcryptosAll).add(DisableApeswap).add(DisableSmoothy)
    .add(DisableEllipsis).add(DisableMdexAll).add(DisableBakeryAll).add(DisablePancakeAllV2);

const flags = DisablePancakeAll.add(DisableBakeryAll).add(DisableBurgerAll).add(DisableThugswapAll)
    .add(DisableStablexAll).add(DisableUnifiAll).add(DisableJulswapAll).add(DisableDODOAll)
    .add(DisableApeswapAll).add(DisableAcryptosAll);

contract('DexOne', (accounts) => {
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

    it('DexOneAll should swap ETH to CAKE', async () => {
        const busd = await ERC20.at("0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56");
        let balanceBefore = await busd.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceBefore}) BUSD`);

        const dexOne = await DexOne.deployed();
        const res = await dexOne.calculateSwapReturn(
            '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // DAI
            '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56', // BUSD
            '1000000000000000000', // 1.0
            10,
            // 0,
            pass,
        );
        expectedOutAmount = res.outAmount;
        console.log(`expect out amount ${res.outAmount.toString()} BUSD`);
        // res.distribution.forEach(dist => {
        //     console.log(dist.toString());
        // });
        console.log("res.distribution:", res.distribution.toString());

        const swapped = await dexOne.contract.methods.swap(
            '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE',
            '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56',
            '1000000000000000000',
            0,
            res.distribution.map(dist => dist.toString()),
            pass.toString(),
            // {
            //     value: "1000000000000000000",
            //     from: accounts[0]
            // }
        ).encodeABI();
        // console.log(swapped);

        const nonce = await web3.eth.getTransactionCount(accounts[0]);
        console.log(`nonce: ${nonce}`);

        const account = accounts[0];
        console.log(`account: ${account}`);
        const rawTx = {
            from: account,
            to: dexOne.address,
            gas: "0x166691b7",
            gasPrice: "0x4a817c800",
            data: swapped,
            // value: "0xde0b6b3a7640000",
            value: '1000000000000000000',
            nonce: web3.utils.toHex(nonce),
        }
        // console.log(rawTx);


        const sign = await web3.eth.accounts.signTransaction(rawTx, '0x94e6de53e500b9fec28037c583f5214c854c7229329ce9baf6f5577bd95f9c9a');
        // console.log(sign);

        web3.eth.sendSignedTransaction(sign.rawTransaction).on('receipt', receipt => {
            // console.log(JSON.stringify(receipt));
        });

        balanceAfter = await busd.balanceOf(accounts[0])
        console.log(`balance of ${accounts[0]}: (${balanceAfter}) BUSD`);
        assert.equal(expectedOutAmount, balanceAfter - balanceBefore);
    });

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
