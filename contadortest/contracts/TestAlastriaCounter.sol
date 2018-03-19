pragma solidity ^0.4.9;


contract TestAlastriaCounter {

    uint public value;

    event Change(string message, uint newVal);

    function TestAlastriaCounter(uint initVal) public {
        value = initVal;
        Change("initialized", initVal);
    }

    function add() public {
        value++;
        Change("add", value);
    }

    function subtract() public {
        value--;
        Change("substract", value);
    }

    function get() public constant returns (uint retVal) {
        return value;
    }

}
