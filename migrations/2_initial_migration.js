const SDTToken = artifacts.require("SDTToken");

module.exports = function (deployer) {
  deployer.deploy(SDTToken);
};
