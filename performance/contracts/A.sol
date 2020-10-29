pragma solidity >=0.4.8;

import "./B.sol";


contract A {
   
    address[] public addElements;
    bytes32[] public caracteres;

    event NewAddress(address a);

    constructor() public payable { }

    function create(bytes32 caracter) public returns (address a) {
        B obj = new B();
        addElements.push(address(obj));
        caracteres.push(caracter);

        // Trigger event
        emit NewAddress(address(obj));

        a = address(obj);
        return a;
    }

    function getElements() external view returns (address[] memory) {
        return addElements;
    }
}
