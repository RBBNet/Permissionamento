pragma solidity 0.5.9;


contract AccountRulesList {
    event AccountAdded(
        bool accountAdded,
        address indexed accountGrantee,
        address indexed accountGrantor,
        uint indexed blockTimestamp
    );

    event AccountRemoved(
        bool accountRemoved,
        address indexed accountGrantee,
        address indexed accountGrantor,
        uint indexed blockTimestamp
    );

    address[] public allowlist;
    mapping (address => uint256) private indexOf; //1 based indexing. 0 means non-existent

    function size() internal view returns (uint256) {
        return allowlist.length;
    }

    //@audit internal, mas nunca é usada (dead code)
    function exists(address account) internal view returns (bool) { // @audit-ok mudança do nome para ficar sem _
        return indexOf[account] != 0;
    }

    function add(address account) internal returns (bool) { // @audit-ok mudança do nome para ficar sem _
        if (indexOf[account] == 0) {
            indexOf[account] = allowlist.push(account);
            return true;
        }
        return false;
    }

    //@audit internal, mas nunca é usada (dead code)
    function addAll(address[] memory accounts, address grantor) internal returns (bool) { // @audit-ok mudança do nome para ficar sem _
        bool allAdded = true;
        for (uint i = 0; i < accounts.length; i++) {
            bool added = add(accounts[i]);
            emit AccountAdded(added, accounts[i], grantor, block.timestamp);
            allAdded = allAdded && added;
        }

        return allAdded;
    }

    //@audit internal, mas nunca é usada (dead code)
    function remove(address account) internal returns (bool) { // @audit-ok mudança do nome para ficar sem _
        uint256 index = indexOf[account];
        if (index > 0 && index <= allowlist.length) { //1-based indexing
            //move last address into index being vacated (unless we are dealing with last index)
            if (index != allowlist.length) {
                address lastAccount = allowlist[allowlist.length - 1];
                allowlist[index - 1] = lastAccount;
                indexOf[lastAccount] = index;
            }

            //shrink array
            allowlist.length -= 1;
            indexOf[account] = 0;
            return true;
        }
        return false;
    }
}
