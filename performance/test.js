//b. Each thread has the same account and only one contract per node.
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

//TODO: it does not work the account generation from this script
//     function generateKey(len = 64) {
//         n = Math.floor( Math.random() * (16) ),
//         randomKey = n.toString(16);
//     while ( randomKey.length < len ) {
//         randomKey = randomKey + generateKey( len -1 );
//     }
//     return randomKey;
//   };

//     function createAccount(password){
//         var privateKey = generateKey();
//         var PrivKeyBuffer = new Buffer('0x' + privateKey);
//         console.log(privateKey);
//         console.log(PrivKeyBuffer);
//         console.log(password);
//         var testAccount = web3.eth.personal.importRawKey(String(privateKey), String(password)).then(console.log);
//         // await new Promise(r => setTimeout(r, 20000));
//         console.log(testAccount);
//         console.log("Created new test account to perform the test with the password provided: " + testAccount);
//         process.exit();
//         return PrivKeyBuffer;
//     }

    if(re.test(testAccount)) {
        console.log("Will try to use the account provided to perform the test: " + testAccount);
        } else if (Number.isInteger(Number(testAccount))){
            account = await web3.eth.personal.getAccounts();
            testAccount = account[testAccount];
            if(re.test(testAccount)){
            console.log("Will try to use the account provided to perform the test: " + testAccount);
            } else {
                console.log("There was no such account. Will try to create a new one.");
                console.log('Script need fixing, as that is not possible. Stopping execution. PLease, create the account and try again.');
                process.exit();
                // privateKey = createAccount(password);
            }
    } else {
        console.log("There was no such account. Will try to create a new one.");
        console.log('Script need fixing, as that is not possible. Stopping execution. PLease, create the account and try again.');
        process.exit();
        // privateKey = createAccount(password);
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
    //! "Contract será un nombre de contrato que se elegirá por línea de comandos. Hacer un condicional que usando letras o números elija qué contrato desplegar en lugar de poner el literal. Luego relacionar ese comando con el nombre que toque, que será la variable "contract".
    const path = require('path');
    const Web3 = require('web3');
    const Tx = require('ethereumjs-tx').Transaction;
    const httpConnection = 'http://127.0.0.1:22000';//TODO
    web3 = new Web3(new Web3.providers.HttpProvider(httpConnection));
    let gasPrice = web3.utils.toHex(web3.utils.toWei('0', 'gwei'));
    // let gasPrice = web3.eth.gasPrice;
    let gasPriceHex = web3.utils.toHex(gasPrice);
    let gasLimitHex = web3.utils.toHex(6000000);
    let nonce = Math.floor( Math.random() * 100 );//web3.eth.getTransactionCount(testAccount, "pending");
    let nonceHex = web3.utils.toHex(nonce);

    console.log('Completed initialization. Deploying contract...')
    await deployContract('B');

    async function deployContract(contract) {
        let jsonName = contract + '.json';
        let jsonFile = './build/contracts/' + jsonName;
        fs.statSync(jsonFile);
        // Read the JSON file contents
        let contractJsonContent = fs.readFileSync(jsonFile, 'utf8');
        let jsonParsed = await JSON.parse(contractJsonContent);
        // Retrieve the ABI and the bytecode and instantiate the transaction
        let abi = jsonParsed['abi'];
        let bytecode = jsonParsed['bytecode'];
        let contractInstance = new web3.eth.Contract(abi);
        let contractData = await contractInstance.deploy({
                    data: bytecode,
            });
        let contractDeployment = contractData._deployData;
        console.log('Data for the contract deployment: ' + contractDeployment);
        // let rawTx = {
        //     // nonce: nonceHex,
        //     gasPrice: gasPriceHex,
        //     gasLimit: gasLimitHex,
        //     gas: web3.utils.toHex(800000),
        //     data: contractDeployment,
        //     // data: contractData,
        //     from: testAccount
        // };
        let rawTx = {
            // nonce: nonceHex,
            gas: web3.utils.toHex(800000),
            data: bytecode,
        }
        // Get the account private key, need to use it to sign the transaction later.
        var tx = new Tx(rawTx, { hardfork: 'byzantium' });
        // Sign the transaction
        await tx.sign(privateKey);
        let signedTx = `0x${tx.serialize().toString('hex')}`;
        let receipt = null;
        console.log('Signed transaction raw: ');
        console.log(tx);
        console.log('Signed transaction prepared: ');
        console.log(signedTx);
        // Submit the smart contract deployment transaction
        await web3.eth.sendSignedTransaction(signedTx, (err, hash) => {
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
        });
        console.log('Contract address: ' + receipt.contractAddress);
        console.log('Contract File: ' + contract);
        
        // Update JSON
        jsonOutput['contractAddress'] = receipt.contractAddress;
        
        let formattedJson = JSON.stringify(jsonOutput, null, 4);
        let formattedWebJson = JSON.stringify(webJsonOutput);
        
        console.log(formattedJson);
        fs.writeFileSync(jsonFile, formattedJson);
        fs.writeFileSync(webJsonFile, formattedWebJson);
        console.log('==============================');

        // ).on('receipt', console.log);
        // await web3.eth.sendSignedTransaction('0x' + serializedTx.toString('hex')).on('receipt', console.log)
        return true;
    }
}
catch (e) {
console.log(e);
}


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