var Counter = artifacts.require("TestAlastriaCounter");

module.exports = function(deployer) {
  web3.personal.unlockAccount(web3.eth.accounts[0], "Passw0rd");  
  deployer.deploy(Counter, 0);
};