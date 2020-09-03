const Exchange = artifacts.require("OpenOceanExchange");

module.exports = function (deployer, _, accounts) {
    deployer.deploy(Exchange, accounts[0], 0);
};
