
var AICToken = artifacts.require("./AICToken.sol");

module.exports = function(deployer) {
  deployer.deploy(AICToken);
};
