pragma solidity ^0.4.8;

contract ArraysAndStructs {

    struct dataList  {   
        address[] owners;
        bytes32[] names;
    }
    
    dataList list;
    
    event NewElement(address owner, bytes32 name);

    function ArraysAndStructs() public payable { }

    function addElemements (bytes32 name) public {
        list.owners.push(msg.sender);
        list.names.push(name);

        // Trigger event
        NewElement(msg.sender, name);
    }

function getElements() external view returns (address[],bytes32[]) {
        return (list.owners, list.names);
    }
}