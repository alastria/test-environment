//b. Each thread has the same account and only one contract per node.
var fs = require('fs');
var Counter = artifacts.require("TestAlastriaCounter");

module.exports = async function(deployer) {
    const repetitions = process.argv[6];
    var testAccount = process.argv[7];
    const password = process.argv[8];
    const testMode = process.argv[9];
    const re = /^0x[0-9A-Fa-f]{40}/g;

    if(re.test(testAccount)) {
        console.log("Will try to use the account provided to perform the test: " + testAccount);
        } else if (Number.isInteger(Number(testAccount))){
            await web3.eth.personal.getAccounts().then(account => {
                testAccount = account[testAccount]
            });
            console.log("Will try to use the account provided to perform the test: " + testAccount);
    } else {
        var testAccount = await web3.eth.personal.newAccount(password);
        console.log("Created new test account to perform the test with the password provided: " + testAccount);
    }

    eval(fs.readFileSync('logFormat.js')+'');
    var counter = 0;
    var counter_i = null;
    console.log("Each contract generates " + repetitions + " trx.");

    console.log("Init awaitings");
        console.log("account: " + testAccount);
        console.log("password: " + password);
    await web3.eth.personal.unlockAccount(String(testAccoagrant upunt), String(password));
    console.log("Unlocked Account");
    await deployer.deploy(Counter, 0).then( instance => {
    if (counter_i === null) {
            counter_i = instance;
    }
            console.log("Address: " + instance.contract.address);
             instance.add().then(add);
    });
    console.log("Instance created");
    web3.eth.personal.lockAccount(testAccount);
    
    // const deployer = await web3.eth.personal.unlockAccount(testAccount, password);
    //     .then(deployer.deploy(Counter, 0))
    //     .then(function(instance) {
    //     if (counter_i === null) {
    //         counter_i = instance;
    //             }
    //             console.log("Address: " + instance.contract.address);
    //             web3.eth.personal.unlockAccount(testAccount, password);
    //             instance.add().then(add);
    //         })
    // )).then(web3.eth.personal.lockAccount(testAccount));

    function add(res, err) {
        if (err) {
            console.log(err);
            return;
        }
        console.log(counter + ": {tx: " + res["tx"] + ", blockHash: " + res["receipt"].blockHash + "'}");
        counter++;
        return next();
    }

    function next() {
        if (counter === parseInt(process.argv[6])) {
            counter_i.get().then((res) => {
                console.log("Final value: " + res);
                return res;
            });
        } else {
            web3.eth.personal.unlockAccount(testAccount, password);
            counter_i.add().then((err, res) => {
                return add(err, res);
            });
        }
    }

    function deploy() {

    }
}