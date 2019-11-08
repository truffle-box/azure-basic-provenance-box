const BasicProvenance = artifacts.require("BasicProvenance")
const truffleAssert = require('truffle-assertions');

contract('BasicProvenance', accounts => {
    const zeroAddress = '0x0000000000000000000000000000000000000000';
    const owner = accounts[0];
    const observer = accounts[1];
    const new_owner = accounts[2];

    it('should return a new instance of the contract with an observer', async() => {
        const basicProvenance = await BasicProvenance.deployed();
        const supplyChainOwner = await basicProvenance.Counterparty();
        const supplyChainObserver = await basicProvenance.SupplyChainObserver();

        assert.equal(supplyChainOwner, owner, 'owner not correctly set');
        assert.equal(supplyChainObserver, observer, 'observer not correctly set');
    });

    it('nonowner can not transfer/complete', async() => {
        const basicProvenance = await BasicProvenance.deployed();

        truffleAssert.reverts(basicProvenance.TransferResponsibility(owner, { from: new_owner}));
        truffleAssert.reverts(basicProvenance.Complete({ from: new_owner}));

    });

    it('owner can transfer', async() => {
        const basicProvenance = await BasicProvenance.deployed();

        await basicProvenance.TransferResponsibility(new_owner);
        const newCounterParty = await basicProvenance.Counterparty(); 

        assert.equal(newCounterParty, new_owner, 'responsibility not transferred successfully');
    });

    it('should be only usable when not completed', async() => {
        const basicProvenance = await BasicProvenance.deployed();

        await basicProvenance.Complete();

        await truffleAssert.reverts(basicProvenance.TransferResponsibility(owner));
        await truffleAssert.reverts(basicProvenance.Complete());
    });
});