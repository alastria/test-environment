//b. Each thread has the same account and only one contract per node.
var fs = require('fs');
// var Counter = artifacts.require("TestAlastriaCounter");


module.exports = async function(deployer) {
    const fs = require('fs');
    try{
    const repetitions = process.argv[6];
    var testAccount = process.argv[7];
    const password = process.argv[8];
    const testMode = process.argv[9];
    const re = /^0x[0-9A-Fa-f]{40}/g;
    var privateKey = '';

    if(re.test(testAccount)) {
        console.log("Will try to use the account provided to perform the test: " + testAccount);
        } else if (Number.isInteger(Number(testAccount))){
            account = await web3.eth.personal.getAccounts();
            testAccount = account[testAccount];
            console.log("Will try to use the account provided to perform the test: " + testAccount);
    } else {
        var privateKey = function(len = 64) {
            n = Math.floor( Math.random() * (16) ),
            randomKey = n.toString(16);
        while ( randomKey.length < len ) {
            randomKey = randomKey + randHex( len -1 );
        }
        return randomKey;
      };
        var testAccount = await web3.eth.personal.importRawKey(String(privateKey), String(password));
        console.log("Created new test account to perform the test with the password provided: " + testAccount);
    }

    if(!privateKey) {
        var keythereum = require("keythereum");
        var datadir = "/network/main/";
        var keyObject = await keythereum.importFromFile(testAccount, datadir);
        var privateKey = await keythereum.recover(password, keyObject);
    }

    eval(fs.readFileSync('logFormat.js')+'');
    var counter = 0;
    var counter_i = null;
    console.log("Each contract generates " + repetitions + " trx.");

//! /////////////////////////////////////////////////////////////////////
//! "Contract será un nombre de contrato que se elegirá por línea de comandos. Hacer un condicional que usando letras o números elija qué contrato desplegar e nlugar de poner el literal. Luego relacionar ese comando con el nombre que toque, que será la variable "contract".
    const path = require('path');
    
    // const solc = require('solc');
    // const md5File = require('md5-file');
    const Web3 = require('web3');
    const Tx = require('ethereumjs-tx').Transaction;
    // const SolidityFunction = require('web3/lib/web3/function');
    // Retrieve the command line arguments
    // let argv = require('minimist')(process.argv.slice(2));
    let accounts = [{
        address: testAccount,
        key: privateKey
    }];
    let selectedHost = 'http://127.0.0.1:22000';
    web3 = new Web3(new Web3.providers.HttpProvider(selectedHost));
    let selectedAccountIndex = 0;
    let gasPrice = web3.eth.gasPrice;
    let gasPriceHex = web3.utils.toHex(gasPrice);
    let gasLimitHex = web3.utils.toHex(6000000);
    // let block = web3.eth.getBlock("latest");
    let nonce = web3.eth.getTransactionCount(accounts[selectedAccountIndex].address, "pending");
    let nonceHex = web3.utils.toHex(nonce);

    await deployContract('B');

    async function deployContract(contract) {
        // It will read the ABI & byte code contents from the JSON file in ./build/contracts/ folder
        let jsonName = contract + '.json';
        let jsonFile = './build/contracts/' + jsonName;
        let result = false;
        try {
            result = fs.statSync(jsonFile);
        } catch (error) {
            console.log(error.message);
            return false;
        }
        // Read the JSON file contents
        let contractJsonContent = fs.readFileSync(jsonFile, 'utf8');
        let jsonParsed = await JSON.parse(contractJsonContent);

        // Retrieve the ABI and the bytecode and instantiate the transaction
        let abi = jsonParsed['abi'];
        let bytecode = jsonParsed['bytecode'];
        let contractInstance = new web3.eth.Contract(abi);
        let contractDeployment = contractInstance.deploy({
            data: bytecode,
            // arguments: [,]
        }).encodeABI();

        let rawTx = {
            nonce: nonceHex,
            gasPrice: gasPriceHex,
            gasLimit: gasLimitHex,
            data: contractDeployment,
            // data: contractData,
            // from: accounts[selectedAccountIndex].address
        };
        console.log(rawTx)
        process.exit()

        // Get the account private key, need to use it to sign the transaction later.
        let privKey = new Buffer(accounts[selectedAccountIndex].key, 'hex')
        let tx = new Tx(rawTx);

        // Sign the transaction
        tx.sign(privKey);
        let serializedTx = tx.serialize();
        let receipt = null;

        // console.log(serializedTx.toString('hex'));

        // Submit the smart contract deployment transaction
        web3.eth.sendSignedTransaction('0x' + serializedTx.toString('hex'), (err, hash) => {
            if (err) { 
                console.log(err); return;
            }

            // Log the tx, you can explore status manually with eth.getTransaction()
            console.log('Contract creation tx: ' + hash);

            // Wait for the transaction to be mined
            while (receipt == null) {

                receipt = web3.eth.getTransactionReceipt(hash);

                // Simulate the sleep function
                Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, 1000);
            }

            console.log('Contract address: ' + receipt.contractAddress);
            console.log('Contract File: ' + contract);

            // Update JSON
            jsonOutput['contractAddress'] = receipt.contractAddress;

            // Web frontend just need to have abi & contract address information
            let webJsonOutput = {
                'abi': abi,
                'contractAddress': receipt.contractAddress
            };

            // let formattedJson = JSON.stringify(jsonOutput, null, 4);
            // let formattedWebJson = JSON.stringify(webJsonOutput);

            //console.log(formattedJson);
            // fs.writeFileSync(jsonFile, formattedJson);
            // fs.writeFileSync(webJsonFile, formattedWebJson);

            console.log('==============================');
        });
        return true;
    }
}
catch (e) {
console.log(e);
}

    // if (typeof argv.deploy !== 'undefined') {
    //     // Build contract

    //     let contract = argv.deploy;

    //     let result = deployContract(contract);
    //     return;
    // }

    // console.log('End here.');





// signedTx = await web3.eth.accounts.signTransaction({     
// }, privateKey, function (err, res){
// });

    // let web3 = new Web3()  
    // web3.providers.HttpProvider('https://ropsten.infura.io/my_access_token_here');
    // let contract = web3.eth.contract(abi).at(address)  
    // var coder = require('web3/lib/solidity/coder')  
    // var CryptoJS = require('crypto-js')  
    // var privateKey = new Buffer(myPrivateKey, 'hex')  
    
    // var functionName = 'addRecord'  
    // var types = ['uint','bytes32','bytes20','bytes5','bytes']  
    // var args = [1, 'fjdnjsnkjnsd', '03:00:21 12-12-12', 'true', '']  
    // var fullName = functionName + '(' + types.join() + ')'  
    // var signature = CryptoJS.SHA3(fullName,{outputLength:256}).toString(CryptoJS.enc.Hex).slice(0, 8)  
    // var dataHex = signature + coder.encodeParams(types, args)  
    // var data = '0x'+dataHex  
    
    // // var nonce = web3.toHex(web3.eth.getTransactionCount(account))  
    // var gasPrice = web3.toHex(web3.eth.gasPrice)  
    // var gasLimitHex = web3.toHex(300000) (user defined)//!IUGKLJHBGUIH
    // var rawTx = { 'nonce': nonce, 'gasPrice': gasPrice, 'gasLimit': gasLimitHex, 'from': account, 'to': address, 'data': data}  
    // var tx = new Tx(rawTx)  
    // tx.sign(privateKey)  
    // var serializedTx = '0x'+tx.serialize().toString('hex')  
    // web3.eth.sendRawTransaction(serializedTx, function(err, txHash){ console.log(err, txHash) })









    // await web3.eth.personal.unlockAccount(String(testAccount), String(password));
    // console.log("Unlocked Account");
    // await deployer.deploy(Counter, 0).then( instance => {
    // if (counter_i === null) {
    //         counter_i = instance;
    // }
    //         console.log("Address: " + instance.contract.address);
    //          instance.add().then(add);
    // });
    // console.log("Instance created");
    // web3.eth.personal.lockAccount(testAccount);
    
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