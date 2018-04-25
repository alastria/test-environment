var A = artifacts.require("A");

module.exports = function(deployer) {
  web3.personal.unlockAccount(web3.eth.accounts[0], "Passw0rd");  
  deployer.deploy(A);
};