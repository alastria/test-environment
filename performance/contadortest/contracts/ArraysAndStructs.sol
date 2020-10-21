pragma solidity >=0.4.8;

contract ArraysAndStructs {

    struct dataList  {   
        address[] owners;
        bytes32[] names;
    }
    
    dataList list;
    
    event NewElement(address owner, bytes32 name);

    constructor()  public payable { }

    function addElemements (bytes32 name) public {
        list.owners.push(msg.sender);
        list.names.push(name);

        // Trigger event
        emit NewElement(msg.sender, name);
    }

function getElements() external view returns (address[] memory, bytes32[] memory) {
        return (list.owners, list.names);
    }
}
