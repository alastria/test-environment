pragma solidity >=0.4.9;

contract TestAlastriaCounter {

    uint public value;

    event Change(string message, uint newVal);

    constructor(uint initVal) public {
        value = initVal;
        emit Change("initialized", initVal);
    }

    function add() public {
        value++;
        emit Change("add", value);
    }

    function subtract() public {
        value--;
        emit Change("substract", value);
    }

    function get() public view returns (uint retVal) {
        return value;
    }

}
