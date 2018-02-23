var A = artifacts.require("A.sol");

web3.personal.unlockAccount(web3.eth.accounts[0], "Passw0rd");  
contract('A', function() {

    it("should work", function() {
        return A.deployed().then(function(instance){

            // Send transaction.
            return instance.create("UNO");

        }).then(function(result){
            console.log("transaction:");
            console.log(result.tx);

            console.log("logs:");
            console.log(result.logs[0].args.a); // Here is the new address

            return A.deployed();

        }).then(function(instance){
            // Get the data 
            return instance.getElements.call();

        }).then(function(result){
            console.log("getElements:");
            console.log(result); // same result by calling getElements()
        });
    });
});