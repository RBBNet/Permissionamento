const Ingress = artifacts.require('AccountIngress.sol');
const Rules = artifacts.require('AccountRules.sol');
const Admin = artifacts.require('Admin.sol');

var address1 = "0xdE3422671D38EcdD7A75702Db7f54d4b30C022Ea".toLowerCase();

contract('Account Rules (Read-only mode)', () => {

  let ingressContract;
  let adminContract;
  let rulesContract;

  beforeEach(async () => {
    ingressContract = await Ingress.deployed();
    rulesContract = await Rules.new(ingressContract.address);
  })

  it("should toggle read-only flag on enter/exit read-mode method invocation", async () => {
    let readOnly = await rulesContract.isReadOnly();
    assert.notOk(readOnly);

    await rulesContract.enterReadOnly();

    readOnly = await rulesContract.isReadOnly();
    assert.ok(readOnly);

    await rulesContract.exitReadOnly();

    readOnly = await rulesContract.isReadOnly();
    assert.notOk(readOnly);
  });

  it("should fail when adding account in read-only mode", async () => {
    await rulesContract.enterReadOnly();

    try {
      await rulesContract.addAccount(address1);
      assert.fail("Expected error when adding on readOnly mode");
    } catch (err) {
      //expect(err.reason).to.contain('In read only mode: rules cannot be modified'); // alterado para o comando abaixo devido a erro c/ as bibliotecas de teste do hardhat 
      expect(err.message).to.contain("In read only mode: rules cannot be modified");
    }
  });

  it("should fail when removing account in read-only mode", async () => {
    await rulesContract.enterReadOnly();

    try {
      await rulesContract.removeAccount(address1);
      assert.fail("Expected error when adding on readOnly mode");
    } catch (err) {
      //expect(err.reason).to.contain('In read only mode: rules cannot be modified'); // alterado para o comando abaixo devido a erro c/ as bibliotecas de teste do hardhat 
      expect(err.message).to.contain("In read only mode: rules cannot be modified");
    }
  });

  it("should fail when attempting to exit read-only mode and contract is not in read-only mode", async () => {

    try {
      await rulesContract.exitReadOnly();
      assert.fail("Expected error when exiting read-only mode not being in read-only mode");
    } catch (err) {
      //expect(err.reason).to.contain('Not in read only mode'); // alterado para o comando abaixo devido a erro c/ as bibliotecas de teste do hardhat 
      expect(err.message).to.contain("Not in read only mode");
    }
  });

  it("should fail when attempting to enter read-only mode and contract is alread in read-only mode", async () => {
    await rulesContract.enterReadOnly();

    try {
      await rulesContract.enterReadOnly();
      assert.fail("Expected error when entering read-only mode being in read-only mode");
    } catch (err) {
      //expect(err.reason).to.contain('Already in read only mode'); // alterado para o comando abaixo devido a erro c/ as bibliotecas de teste do hardhat 
      expect(err.message).to.contain("Already in read only mode");
    }
  });
});
