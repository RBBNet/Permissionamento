pragma solidity 0.5.9;

import "./AccountRulesProxy.sol";
import "./AccountRulesList.sol";
import "./AccountIngress.sol";
import "./Admin.sol";


contract AccountRules is AccountRulesProxy, AccountRulesList {

    // in read-only mode rules can't be added/removed
    // this will be used to protect data when upgrading contracts
    bool private readOnlyMode = false;
    // version of this contract: semver like 1.2.14 represented like 001002014
    uint private constant VERSION_OF_CONTRACT = 1000000;  //@audit-ok inserção de constante e em capwords

    AccountIngress private ingressContract;

    modifier onlyOnEditMode() {
        require(!readOnlyMode, "In read only mode: rules cannot be modified"); //@audit-ok removendo redundância booleana
        _;
    }

    modifier onlyAdmin() {
        address adminContractAddress = ingressContract.getContractAddress(ingressContract.ADMIN_CONTRACT());

        require(adminContractAddress != address(0), "Ingress contract must have Admin contract registered");
        require(Admin(adminContractAddress).isAuthorized(msg.sender), "Sender not authorized");
        _;
    }

    constructor (AccountIngress newIngressContract) public { //@audit-ok mudança do nome para não ter os _
        ingressContract = newIngressContract;
        add(msg.sender);
    }

    // VERSION
    function getContractVersion() public view returns (uint) {
        return VERSION_OF_CONTRACT;
    }

    // READ ONLY MODE
    function isReadOnly() public view returns (bool) {
        return readOnlyMode;
    }

    function enterReadOnly() public onlyAdmin returns (bool) {
        require(!readOnlyMode, "Already in read only mode"); //@audit-ok removendo redundância booleana
        readOnlyMode = true;
        return true;
    }

    function exitReadOnly() public onlyAdmin returns (bool) {
        require(readOnlyMode, "Not in read only mode");
        readOnlyMode = false;
        return true;
    }

    function transactionAllowed(
        address sender,
        address, // target
        uint256, // value
        uint256, // gasPrice
        uint256, // gasLimit
        bytes calldata // payload
    ) external view returns (bool) {
        if (
            accountPermitted (sender)
        ) {
            return true;
        } else {
            return false;
        }
    }

    function accountPermitted(
        address account //@audit-ok mudança do nome para ficar sem _
    ) public view returns (bool) {
        return exists(account);
    }

    function addAccount(
        address account
    ) public onlyAdmin onlyOnEditMode returns (bool) {
        bool added = add(account);
        emit AccountAdded(added, account, msg.sender, block.timestamp);
        return added;
    }

    function removeAccount(
        address account
    ) public onlyAdmin onlyOnEditMode returns (bool) {
        bool removed = remove(account);
        emit AccountRemoved(removed, account, msg.sender, block.timestamp);
        return removed;
    }

    function getSize() public view returns (uint) {
        return size();
    }

    function getByIndex(uint index) public view returns (address account) {
        return allowlist[index];
    }

    function getAccounts() public view returns (address[] memory){
        return allowlist;
    }

    function addAccounts(address[] calldata accounts) external onlyAdmin returns (bool) { // @audit-ok mudança da visibilidade e de memory
        return addAll(accounts, msg.sender);
    }
}
