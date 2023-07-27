pragma solidity 0.5.9;

import "./AdminProxy.sol";
import "./AdminList.sol";


contract Admin is AdminProxy, AdminList {
    mapping(address => uint256) private lastCallTimestamp;
    address owner;

    event SuspiciousAdminOperation(
        address indexed accountGrantee,
        address indexed accountGrantor,
        uint indexed blockTimestamp,
        string message
    );

    modifier onlyAdmin() {
        //NÃO REMOVER! Necessário para adicionar primeiro batch de admins.
        require(isAuthorized(msg.sender), "Sender not authorized");
        _;
    }
//
//    modifier notSelf(address _address) {
//        require(msg.sender != _address, "Cannot invoke method with own account as parameter");
//        _;
//    }

    constructor() public {
        add(msg.sender);
        owner = msg.sender;
    }


    function isAuthorized(address _address) public view returns (bool) {
        return exists(_address);
    }

    function lastAdminAttempt() public view returns(uint256){
        //remover essa função quando for dar deploy efetivo. Ela só serve para verificar
        //a última vez que endereço que chamou fez algum evento admin.
        uint256 lastTime = lastCallTimestamp[msg.sender];
        uint256 timeDifference = block.timestamp - lastTime;
        uint256 daysSince = timeDifference/86400; //conversão de tempo para dias
        return daysSince;

    }

    function getAdminSize() public view returns (uint256) {
        address[] memory admins = getAdmins();
        return admins.length;
    }


    function addAdmin(address _address) public returns (bool){
        //se não for autorizado, emitir um evento suspeito
        //se for, pode prosseguir
        bool authorized = isAuthorized(msg.sender);
        if (authorized == false){
            emit SuspiciousAdminOperation(msg.sender, _address, block.timestamp, "Sender not authorized");
            return false;
        } else {
            //se tentou adicionar o próprio endereço, emitir evento AdminAdded
            //se tentou adicionar mais de uma vez por dia, emitir evento AdminAdded
            //conta nova passa por quarentena
            //senão, pode prosseguir
            if (msg.sender == _address){
                emit AdminAdded(false, _address, msg.sender, block.timestamp, "Adding own account as Admin is not permitted");
                return false;
            }
            if (block.timestamp < lastCallTimestamp[msg.sender] + 1 days){
                emit AdminAdded(false, _address, msg.sender, block.timestamp, "You can only do this once a day");
                return false;
            }
            if (block.timestamp < lastCallTimestamp[_address] + 1 days){
                emit AdminAdded(false, _address, msg.sender, block.timestamp, "Account still under quarantine");
                return false;
            }
            else {
                bool result = add(_address);
                string memory message = result ? "Admin account added successfully" : "Account is already an Admin";
                emit AdminAdded(result, _address, msg.sender, block.timestamp, message);
                lastCallTimestamp[msg.sender] = block.timestamp;
                lastCallTimestamp[_address] = block.timestamp;
                return result;
            }
        }

    }


    function removeAdmin(address _address) public returns (bool){
        //se não for admin, emite evento suspeito
        //se estiver tentando remover a própria conta, emite evento suspeito
        //se adicionou admin ou removeu no próprio dia, emite AdminRemoved

        //senão, pode prosseguir
        bool authorized = isAuthorized(msg.sender);
        if (authorized = false){
            emit SuspiciousAdminOperation(msg.sender, _address, block.timestamp, "Sender not authorized");
            return false;
        }
        if (_address == msg.sender){
            emit AdminRemoved(false, _address, msg.sender, block.timestamp);
            return false;
        }
        if (block.timestamp < lastCallTimestamp[msg.sender] + 1 days){
            emit AdminRemoved(false, _address, msg.sender, block.timestamp);
            return false;
        }
        else {
            bool removed = remove(_address);
            emit AdminRemoved(removed, _address, msg.sender, block.timestamp);
            lastCallTimestamp[msg.sender] = block.timestamp;
            return removed;
        }

    }


    function getAdmins() public view returns (address[] memory){
        return allowlist;
    }

    function addAdmins(address[] memory accounts) public onlyAdmin returns (bool) {
        require(msg.sender == owner, "Batch addresses are only allowed during deploy");
        owner = address(0);
        return addAll(accounts, msg.sender);
    }
}
