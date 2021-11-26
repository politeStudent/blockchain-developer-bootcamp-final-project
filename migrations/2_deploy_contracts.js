const Will = artifacts.require("Will.sol");
const WillFactory = artifacts.require("WillFactory.sol");

module.exports = function (deployer) {
  deployer.deploy(Will, "0xd61a66588b388082c7c7da20b6dd5483c6634078", "first");
  deployer.deploy(WillFactory);
};
