pragma solidity 0.5.9;

contract NodeRulesList {

    enum NodeType{
        Boot,
        Validator,
        Writer,
        WriterPartner,
        ObserverBoot,
        Other
    }

    // struct size = 82 bytes
    struct Enode { //@audit-ok mudando para Enode 
        bytes32 enodeHigh;
        bytes32 enodeLow;
        NodeType nodeType;
        bytes6 geoHash;
        string name;
        string organization;
    }

    Enode[] public allowlist; //@audit-ok mudando para Enode
    mapping (uint256 => uint256) private indexOf; //1-based indexing. 0 means non-existent

    function calculateKey(bytes32 enodeHigh, bytes32 enodeLow) internal pure returns(uint256) {
        return uint256(keccak256(abi.encodePacked(enodeHigh, enodeLow)));
    }

    function size() internal view returns (uint256) {
        return allowlist.length;
    }


    //@audit internal, mas nunca é usada (dead code)
    function exists(bytes32 enodeHigh, bytes32 enodeLow) internal view returns (bool) {
        return indexOf[calculateKey(enodeHigh, enodeLow)] != 0;
    }

    //@audit internal, mas nunca é usada (dead code)
    function add(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, bytes6 geoHash, string memory name, string memory organization) internal returns (bool) {
        uint256 key = calculateKey(enodeHigh, enodeLow);
        if (indexOf[key] == 0) {
            indexOf[key] = allowlist.push(Enode(enodeHigh, enodeLow, nodeType, geoHash, name, organization)); //@audit-ok mudando para Enode
            return true;
        }
        return false;
    }

    //@audit internal, mas nunca é usada (dead code)
    function remove(bytes32 enodeHigh, bytes32 enodeLow) internal returns (bool) {
        uint256 key = calculateKey(enodeHigh, enodeLow);
        uint256 index = indexOf[key];

        if (index > 0 && index <= allowlist.length) { //1 based indexing
            //move last item into index being vacated (unless we are dealing with last index)
            if (index != allowlist.length) {
                Enode memory lastEnode = allowlist[allowlist.length - 1]; //@audit-ok mudando para Enode
                allowlist[index - 1] = lastEnode;
                indexOf[calculateKey(lastEnode.enodeHigh, lastEnode.enodeLow)] = index;
            }

            //shrink array
            allowlist.length -= 1;
            indexOf[key] = 0;
            return true;
        }

        return false;
    }
}
