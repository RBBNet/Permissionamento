// Load compiled artifacts
const Admin = artifacts.require('Admin.sol');

// Start test block
contract("Admin (admin management)", async accounts => {

  let adminContract;

  beforeEach(async () => {
    // Deploy a new Box contract for each test
    adminContract = await Admin.new();
  })

  it("account that deployed contract should be admin", async () => {
    let isAuthorized = await adminContract.isAuthorized(accounts[0]);

    assert.ok(isAuthorized);
  });

  it("non-deployer account should not be admin", async () => {
    let isAuthorized = await adminContract.isAuthorized(accounts[1]);
    assert.notOk(isAuthorized);
  });

  it("non admin cannot add another admin", async () => {
    try {
      //vote to admin
      await adminContract.addAdmin(accounts[2], { from: accounts[1] });
      expect.fail(null, null, "Modifier was not enforced")
    } catch(err) {
      expect(err.reason).to.contain('Sender not authorized');
    }
  });

  it("admin can add another admin", async () => {
    await adminContract.addAdmin(accounts[2], { from: accounts[0] });
    let isAuthorized = await adminContract.isAuthorized(accounts[2]);
    assert.ok(isAuthorized);
  });

  it("admin cannot add another admin alone if there is more than one admin", async () => {
    await adminContract.addAdmin(accounts[2], { from: accounts[0] });
    await adminContract.addAdmin(accounts[1], { from: accounts[0] });
    await adminContract.addAdmin(accounts[1], { from: accounts[0] });
    let isAuthorized = await adminContract.isAuthorized(accounts[1]);
    assert.notOk(isAuthorized);
  });
  it("admin cannot add another admin alone if there is more than one admin", async () => {
    await adminContract.addAdmin(accounts[2], { from: accounts[0] });
    await adminContract.addAdmin(accounts[1], { from: accounts[0] });
    await adminContract.addAdmin(accounts[1], { from: accounts[0] });
    await adminContract.addAdmin(accounts[1], { from: accounts[0] });
    await adminContract.addAdmin(accounts[1], { from: accounts[0] });
    await adminContract.addAdmin(accounts[1], { from: accounts[0] });
    let isAuthorized = await adminContract.isAuthorized(accounts[1]);
    assert.notOk(isAuthorized);
  });


  it("non admin cannot remove another admin", async () => {
    try {
      await adminContract.removeAdmin(accounts[2], { from: accounts[1] });
      expect.fail(null, null, "Modifier was not enforced")
    } catch(err) {
      expect(err.reason).to.contain("Sender not authorized");
    }
  });
  it("admin can remove himself if he is not the only admin", async () => {
    await adminContract.addAdmin(accounts[2], { from: accounts[0] });
    await adminContract.removeAdmin(accounts[2], { from: accounts[2] });
    let isAuthorized = await adminContract.isAuthorized(accounts[2]);
    assert.notOk(isAuthorized);
  });

  it("admin cannot remove himself if he is the only admin", async () => {
    await adminContract.removeAdmin(accounts[0], { from: accounts[0] });
    let isAuthorized = await adminContract.isAuthorized(accounts[0]);
    assert.Ok(isAuthorized);
  });

  it("admin can remove another admin MS (with 2 admins in the list)", async () => {
    await adminContract.addAdmin(accounts[2], { from: accounts[0] }); // before this line, only accounts[0] is admin
    let isAuthorized = await adminContract.isAuthorized(accounts[2]); // now there's 2 admins, accounts[0] and accounts[2]
    assert.ok(isAuthorized);

    tx = await adminContract.removeAdmin(accounts[2], { from: accounts[0] }); // 1/2 votes
    tx = await adminContract.removeAdmin(accounts[2], { from: accounts[2] }); // 2/2 votes
    isAuthorized = await adminContract.isAuthorized(accounts[2]);
    assert.notOk(isAuthorized);
  });

  it("admin cannot remove themselves", async () => { // pode se remover desde que haja mais que um administrador na lista de admins
    try {
      await adminContract.removeAdmin(accounts[0], { from: accounts[0] });
      expect.fail(null, null, "Modifier was not enforced")
    } catch(err) {
      expect(err.reason).to.contain("Cannot invoke method with own account as parameter");
    }
  });
  it("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwhen i  add a admin this admin need to go to allowlist", async () => { // pode se remover desde que haja mais que um administrador na lista de admins
    
    await adminContract.addAdmin(accounts[1], { from: accounts[0] });
    let allowlist = await adminContract.getAdmins();
    assert.Ok(allowlist[0]==accounts[1] || accounts[1] == accounts[1] );
      
  });

  it("get admins list", async () => {
    let admins = await adminContract.getAdmins.call();

    assert.sameMembers([accounts[0]], admins)
  });

  it("get admins list reflect changes", async () => {
    let admins = await adminContract.getAdmins.call();
    assert.sameMembers([accounts[0]], admins)

    await adminContract.addAdmin(accounts[1], { from: accounts[0] }); // 1 vote needed, 1/1
    admins = await adminContract.getAdmins.call();
    assert.sameMembers([accounts[0], accounts[1]], admins);

    await adminContract.addAdmin(accounts[2], { from: accounts[0] }); // 2 votes needed, 1/2
    await adminContract.addAdmin(accounts[2], { from: accounts[1] }); // 2 votes needed, 2/2
    admins = await adminContract.getAdmins.call();
    assert.sameMembers([accounts[0], accounts[1], accounts[2]], admins);

    await adminContract.removeAdmin(accounts[1], { from: accounts[0] }); // 3 votes needed, 1/3
    await adminContract.removeAdmin(accounts[1], { from: accounts[1] }); // 3 votes needed, 2/3
    await adminContract.removeAdmin(accounts[1], { from: accounts[2] }); // 3 votes needed, 3/3
    admins = await adminContract.getAdmins.call();
    assert.sameMembers([accounts[0], accounts[2]], admins);
  });

  it("Should emit events when an Admin is added", async () => {
    const ownAddress = accounts[0]
    const address = accounts[1];

    // Add a new account
    await adminContract.addAdmin(address);

    // Attempt to add a duplicate entry
    await adminContract.addAdmin(address);

    // Attempt to add self
    await adminContract.addAdmin(ownAddress);

    // Get the events
    let result = await adminContract.getPastEvents("AdminAdded", {fromBlock: 0, toBlock: "latest" });

    // Verify the first AccountAdded event is 'true'
    assert.equal(result[0].returnValues.adminAdded, true, "adminAdded SHOULD be true");

    // Verify the unsuccessful duplicate AccountAdded event is 'false'
    assert.equal(result[1].returnValues.adminAdded, false, "adminAdded with duplicate account SHOULD be false");

    // Verify the unsuccessful duplicate AccountAdded event has correct message
    assert.equal(result[1].returnValues.message, "Account is already an Admin", "duplicate Admin error message SHOULD be correct");

    // Verify the adding own account AccountAdded event is 'false'
    assert.equal(result[2].returnValues.adminAdded, false, "adminAdded with own account SHOULD be false");

    // Verify the adding own account AccountAdded event has correct message
    assert.equal(result[2].returnValues.message, "Adding own account as Admin is not permitted", "adding self Admin error message SHOULD be correct");
  });

  it("Should emit events when multiple Admins are added", async () => { // REMOVER
    const ownAddress = accounts[0]
    const address = accounts[1];
 
    //add same account twice and attempt to add self
    await adminContract.addAdmins([address, address, ownAddress])

 
    // Get the events
    let result = await adminContract.getPastEvents("AdminAdded", {fromBlock: 0, toBlock: "latest" });

    // Verify the first AccountAdded event is 'true'
    assert.equal(result[0].returnValues.adminAdded, true, "adminAdded SHOULD be true");

    // Verify the unsuccessful duplicate AccountAdded event is 'false'
    assert.equal(result[1].returnValues.adminAdded, false, "adminAdded with duplicate account SHOULD be false");

    // Verify the unsuccessful duplicate AccountAdded event has correct message
    assert.equal(result[1].returnValues.message, "Account is already an Admin", "duplicate Admin error message SHOULD be correct");

    // Verify the adding own account AccountAdded event is 'false'
    assert.equal(result[2].returnValues.adminAdded, false, "adminAdded with own account SHOULD be false");

    // Verify the adding own account AccountAdded event has correct message
    assert.equal(result[2].returnValues.message, "Adding own account as Admin is not permitted", "adding self Admin error message SHOULD be correct");
  });

  it("Should emit events when an Admin is removed", async () => {
    const address = accounts[1];

    // Add a new account
    await adminContract.addAdmin(address);

    await adminContract.removeAdmin(address, { from: accounts[0] }); // 2 votes needed, 1/2
    await adminContract.removeAdmin(address, { from: address }); // 2 votes needed, 2/2

    let result = await adminContract.getPastEvents("AdminRemoved", {fromBlock: 0, toBlock: "latest" });

    // Verify the first AccountRemoved event is 'true'
    assert.equal(result[0].returnValues.adminRemoved, true, "adminRemoved SHOULD be true");
    // Verify the second AccountRemoved event is 'false'
    assert.equal(result[1].returnValues.adminRemoved, false, "adminRemoved SHOULD be false");


  });

});
