pragma solidity 0.5.9;

import "./AdminProxy.sol";

contract Ingress {
    // Contract keys
    bytes32 public RULES_CONTRACT = 0x72756c6573000000000000000000000000000000000000000000000000000000; // "rules"
    bytes32 public ADMIN_CONTRACT = 0x61646d696e697374726174696f6e000000000000000000000000000000000000; // "administration"

    // Registry mapping indexing
    mapping(bytes32 => address) internal registry;

    struct Vote {
        address proposedAddress;
        mapping(address => bool) voters;
        uint256 count;
    }

    // Voting system mapping
    mapping(bytes32 => mapping(address => Vote)) private votes;

    bytes32[] internal contractKeys;
    mapping (bytes32 => uint256) internal indexOf; //1 based indexing. 0 means non-existent

    event RegistryUpdated(
        address contractAddress,
        bytes32 contractName
    );

    function getContractAddress(bytes32 name) public view returns(address) {
        require(name > 0, "Contract name must not be empty.");
        return registry[name];
    }

    function getSize() public view returns (uint256) {
        return contractKeys.length;
    }

    function isAuthorized(address account) public view returns(bool) {
        if (registry[ADMIN_CONTRACT] == address(0)) {
            return true;
        } else {
            return AdminProxy(registry[ADMIN_CONTRACT]).isAuthorized(account);
        }
    }

    function setContractAddress(bytes32 name, address _address) public returns (bool) {
        require(name > 0, "Contract name must not be empty.");
        require(_address != address(0), "Contract address must not be zero.");
        require(isAuthorized(msg.sender), "Not authorized to update contract registry.");

        if(AdminProxy(registry[ADMIN_CONTRACT]).getAdminSize() < 3) {
            // Less than 3 admins, setting the address directly
            if (indexOf[name] == 0) {
                indexOf[name] = contractKeys.push(name);
            }
            registry[name] = _address;
            emit RegistryUpdated(_address, name);
        } else {
            // Three or more admins exist, need voting mechanism
            require(!votes[name][_address].voters[msg.sender], "Already voted for this proposal");

            if (votes[name][_address].count == 0) {
                votes[name][_address].proposedAddress = _address;
            }

            require(votes[name][_address].proposedAddress == _address, "Different address proposal for the same name exist");

            votes[name][_address].voters[msg.sender] = true; // record the vote
            votes[name][_address].count++;

            if(votes[name][_address].count >= 3) {
                if (indexOf[name] == 0) {
                    indexOf[name] = contractKeys.push(name);
                }
                registry[name] = votes[name][_address].proposedAddress;
                emit RegistryUpdated(votes[name][_address].proposedAddress, name);

                // Reset the votes
                delete votes[name][_address];
            }
        }

        return true;
    }

    function getAllContractKeys() public view returns(bytes32[] memory) {
        return contractKeys;
    }
}
