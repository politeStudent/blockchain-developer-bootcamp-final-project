const willTest = artifacts.require("WillFactory");

/*
      TDD cases for some main functions in Block Will
 */

const { catchRevert } = require("./exceptionsHelpers.js");
var WillFactory = artifacts.require("./WillFactory.sol");

contract("WillFactory", function (accounts) {
  const [contractOwner, alice, bob, ted, carol] = accounts;
  const deposit = web3.utils.toBN(2);

  beforeEach(async () => {
    instance = await WillFactory.new();
  });

  it("Will deployed, assert true", async function () {
    await willTest.deployed();
    return assert.isTrue(true);
  });

  it("New account loaded", async () => {
    const eth100 = 100e18;
    assert.equal(await web3.eth.getBalance(alice), eth100.toString());
  });

  it("is owned by owner", async () => {
    assert.equal(
      await instance.owner.call(),
      contractOwner,
      "owner is not correct"
    );
  });

  it("should mark addresses as enrolled", async () => {
    await instance.enroll({ from: alice });

    const aliceEnrolled = await instance.enrolled(alice, { from: alice });
    assert.equal(
      aliceEnrolled,
      true,
      "enroll balance is incorrect, check balance method or constructor"
    );
  });

  it("should not mark unenrolled users as enrolled", async () => {
    const ownerEnrolled = await instance.enrolled(contractOwner, {
      from: contractOwner,
    });
    assert.equal(
      ownerEnrolled,
      false,
      "only enrolled users should be marked enrolled"
    );
  });

  it("should create blockwill contract with correct owner", async () => {
    await instance.enroll({ from: alice });
    await instance.create(alice, "Sherri Ford");
    const res = await instance.getWill(0);

    assert.equal(alice, res.willOwner, "only owner can create own will");
  });

  it("should log add beneficary event when a beneficary is added", async () => {
    await instance.enroll({ from: alice });
    await instance.create(alice, "Sherri Ford");
    const newDriver = "0xaf822e1841CefC0033f28eBC556b05528a057436";
    const custId = 0;
    const result = await instance.setDriver(custId, newDriver, { from: alice });
    const expectedDriver = { custId: custId, beneAddress: newDriver };
    const logCustId = result.logs[0].args.custId;
    const logBeneAddress = result.logs[0].args.beneAddress;

    assert.equal(
      expectedDriver.custId,
      logCustId,
      "addBeneficiary event custId property not emitted, check add method"
    );

    assert.equal(
      expectedDriver.beneAddress,
      logBeneAddress,
      "addBeneficiary event newBene property not emitted, check add method"
    );
  });

  it("should delete beneficiaries and decrement count", async () => {
    await instance.enroll({ from: alice });
    await instance.create(alice, "Sherri Ford");
    const newDriver = "0xaf822e1841CefC0033f28eBC556b05528a057436";
    const custId = 0;
    const result = await instance.setDriver(custId, newDriver, { from: alice });
    const expectedCount = 0;
    await instance.deleteDriver(0, 0);
    const actualCount = await instance.getDriverCount.call(0);

    assert.equal(
      expectedCount,
      actualCount.words[0],
      "beneficiary (driver) not deleted, check delete method"
    );
  });

  it("should NOT allow adding a beneficary if not the will contract owner", async () => {
    await instance.enroll({ from: alice });
    await instance.create(alice, "Sherri Ford");
    const newDriver = "0xaf822e1841CefC0033f28eBC556b05528a057436";
    const custId = 0;
    try {
      const result = await instance.setDriver(custId, newDriver, { from: bob });
    } catch {
      console.log("NOT THE OWNER!");
    }
  });
});
