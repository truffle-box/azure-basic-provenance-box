var BasicProvenance = artifacts.require('BasicProvenance');

module.exports = (deployer, network, accounts) => {
    deployer.deploy(BasicProvenance, accounts[0], accounts[1]);
};