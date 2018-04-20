pragma solidity ^0.4.8;

import "contracts/B.sol";


contract A {
   
    address[] public addElements;
    bytes32[] public caracteres;

    event NewAddress(address a);

    function A() public payable { }

    function create(bytes32 caracter) public returns (address a) {
        B obj = new B();
        addElements.push(obj);
        caracteres.push(caracter);

        // Trigger event
        NewAddress(obj);

        a = obj;
        return;
    }

    function getElements() external view returns (address[]) {
        return addElements;
    }
}