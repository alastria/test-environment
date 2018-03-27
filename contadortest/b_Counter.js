// b. Cada uno de los hilos tiene la misma cuenta y un único contrato por nodo.
var fs = require('fs');
var Counter = artifacts.require("TestAlastriaCounter");

module.exports = function(deployer) {
    eval(fs.readFileSync('logFormat.js')+'');
    var contador = 0;
    var counteri = null;
    console.log("Se generan " + process.argv[6] + " trx. por contrato.");
    
    function add(retorno, err) {
        if (err) {
            console.log(err);
            return;
        }
        console.log(contador + ": {tx: " + retorno["tx"] + ", blockHash: " + retorno["receipt"].blockHash + "'}");
        contador++;
        return next();
    }

    function next() {
        if (contador == parseInt(process.argv[6]) {
            counteri.get().then((retorno) => {
                console.log("Final value: " + retorno);
                return retorno;
            });
        } else {
            web3.personal.unlockAccount(web3.eth.accounts[0], "Passw0rd");  
            counteri.add().then((err, retorno) => {
                return add(err, retorno);
            });
        }
    }

    Counter.new(0).then(function(instance) {
        if (counteri === null) {
            counteri = instance;
        }
        console.log("Address: " + instance.contract.address);
        instance.add().then(add);
    });



}