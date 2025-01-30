pragma solidity 0.5.9;

import "./AccountRulesProxy.sol";
import "./Ingress.sol";


contract AccountIngress is Ingress, AccountRulesProxy {
    // version of this contract: semver eg 1.2.14 represented like 001002014
    uint private constant VERSION_OF_CONTRACT = 1000000; //@audit-ok inserção de constante e em capwords

    function getContractVersion() public pure returns(uint) { //@audit-ok mudança para pure visto que não acessa variáveis de estado
        return VERSION_OF_CONTRACT;
    }

    function transactionAllowed(
        address sender,
        address target,
        uint256 value,
        uint256 gasPrice,
        uint256 gasLimit,
        bytes calldata payload //@audit-ok mudança para calldata
    ) external view returns (bool) { //@audit-ok mudança para função externa
        if(getContractAddress(RULES_CONTRACT) == address(0)) {
            return true;
        }

        return AccountRulesProxy(registry[RULES_CONTRACT]).transactionAllowed(
            sender, target, value, gasPrice, gasLimit, payload
        );
    }
}
