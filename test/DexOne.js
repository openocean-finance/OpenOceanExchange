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

const DisableUniswapV2ALL = new BN(1 << 0);
// const DisableUniswapV2 = new BN(1 << 1);
// const DisableUniswap = new BN(1).shln(16);
const DisalbeCurveAll = new BN(1).shln(5);
const DisableOasis = new BN(1).shln(15);
const DisableUniswap = new BN(1).shln(16);
const DisableSushiSwapAll = new BN(1).shln(17);
const DisableMooniswapAll = new BN(1).shln(22);
const DisableBalancerAll = new BN(1).shln(27);
const DisableKyberAll = new BN(1).shln(31);
const DisableDODOAll = new BN(1).shln(36)

const DexOneView = artifacts.require("DexOneView");
const DexOne = artifacts.require("DexOne");
const DexOneAll = artifacts.require("DexOneAll");
const ERC20 = artifacts.require("IERC20");

contract('DexOne', (accounts) => {
    // it('DexOneView should calculate', async () => {
    //     // const dexOne = await DexOneView.at('0x8338D73536699acFfEf9A2FD24311B85fa515F7F');
    //     const dexOne = await DexOneView.deployed();
    //     const res = await dexOne.calculateSwapReturn(
    //         // '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // BNB
    //         '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48', // DAI
    //         '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // DAI
    //         // '0x0000000000085d4780B73119b644AE5ecd22b376', // BNB
    //         // '1000000000000000000', // 1
    //         '1767402568', // 1
    //         10,
    //         // 0
    //         DisableUniswapV2ALL.add(DisalbeCurveAll).add(DisableOasis).add(DisableUniswap).add(DisableSushiSwapAll).add(DisableMooniswapAll).add(DisableBalancerAll).add(DisableKyberAll),
    //     );
    //     console.log(`expect out amount ${res.outAmount.toString()} USDC`);
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
    //     const dai = await ERC20.at("0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48");
    //     let balance = await dai.balanceOf(accounts[0])
    //     console.log(`balance of ${accounts[0]}: (${balance}) USDC`);

    //     const dexOne = await DexOne.deployed();
    //     const res = await dexOne.calculateSwapReturn(
    //         '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', // DAI
    //         '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48', // USDC
    //         '1000000000000000000', // 1.0
    //         10,
    //         // 0,
    //         DisableUniswapV2ALL.add(DisalbeCurveAll).add(DisableOasis).add(DisableUniswap).add(DisableSushiSwapAll).add(DisableMooniswapAll).add(DisableBalancerAll).add(DisableKyberAll),
    //     );
    //     console.log(`expect out amount ${res.outAmount.toString()} USDC`);
    //     res.distribution.forEach(dist => {
    //         console.log(dist.toString());
    //     });

    //     const swapped = await dexOne.contract.methods.swap(
    //         '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE',
    //         '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48',
    //         '1000000000000000000',
    //         0,
    //         res.distribution.map(dist => dist.toString()),
    //         // 0,
    //         DisableUniswapV2ALL.add(DisalbeCurveAll).add(DisableOasis).add(DisableUniswap).add(DisableSushiSwapAll).add(DisableMooniswapAll).add(DisableBalancerAll).add(DisableKyberAll).toString(),
    //         // {
    //         //     value: "1000000000000000000",
    //         //     from: accounts[0]
    //         // }
    //     ).encodeABI();
    //     // console.log(swapped);

    //     const nonce = await web3.eth.getTransactionCount(accounts[0]);
    //     console.log(`nonce: ${nonce}`);

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


    //     const sign = await web3.eth.accounts.signTransaction(rawTx, '0x94e6de53e500b9fec28037c583f5214c854c7229329ce9baf6f5577bd95f9c9a');
    //     // console.log(sign);

    //     web3.eth.sendSignedTransaction(sign.rawTransaction).on('receipt', receipt => {
    //         // console.log(JSON.stringify(receipt));
    //     });

    //     balance = await dai.balanceOf(accounts[0])
    //     console.log(`balance of ${accounts[0]}: (${balance}) USDC`);
    // });

    // it('DexOneAll should swap CAKE to BNB', async () => {
    //     const dai = await ERC20.at("0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56");
    //     const busd = await ERC20.at('0xb8C540d00dd0Bf76ea12E4B4B95eFC90804f924E');
    //     let balance = await dai.balanceOf(accounts[0])
    //     let bnbBalance = await busd.balanceOf(accounts[0])
    //     console.log(`balance of ${accounts[0]}: (${balance}) BUSD; (${bnbBalance}) USDT`);

    //     const dexOne = await DexOneAll.deployed();
    //     const res = await dexOne.calculateSwapReturn(
    //         '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56', // DAI
    //         '0xb8C540d00dd0Bf76ea12E4B4B95eFC90804f924E', // BUSD
    //         '1000000000000000000', // 40
    //         20,
    //         DisablePancakeAll.add(DisableBakeryAll).add(DisableBurgerAll).add(DisableThugswapAll).add(DisableStablexAll).add(DisableUnifiAll).add(DisableJulswapAll)
    //     );
    //     console.log(`expect out amount ${res.outAmount.toString()} BUSD`);
    //     res.distribution.forEach(dist => {
    //         console.log(dist.toString());
    //     });

    //     await dai.approve(DexOneAll.address, '1000000000000000000', {
    //         from: accounts[0]
    //     })
    //     const swapped = await dexOne.swap(
    //         '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56', // DAI
    //         '0xb8C540d00dd0Bf76ea12E4B4B95eFC90804f924E', // BUSD
    //         '1000000000000000000',
    //         0,
    //         res.distribution,
    //         DisablePancakeAll.add(DisableBakeryAll).add(DisableBurgerAll).add(DisableThugswapAll).add(DisableStablexAll).add(DisableUnifiAll).add(DisableJulswapAll)
    //     );
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
