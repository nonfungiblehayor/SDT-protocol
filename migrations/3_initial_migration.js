const stakeSDT = artifacts.require("stakeSDT");

module.exports = function (deployer) {
    deployer.deploy(stakeSDT);
}