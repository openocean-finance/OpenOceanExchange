const DexOneView = artifacts.require("DexOneView");
const DexOne = artifacts.require("DexOne");
const DexOneAll = artifacts.require("DexOneAll");

module.exports = function (deployer) {
    deployer.deploy(DexOneView).then(function () {
        return deployer.deploy(DexOne, DexOneView.address).then(function () {
            return deployer.deploy(DexOneAll, DexOne.address, DexOneView.address);
        });
    });
};
