var Web3 = require('web3')
var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:22000'));
const fs = require('fs');
var Tx = require('ethereumjs-tx');
var Common = require('ethereumjs-common').default;
const contract = JSON.parse(fs.readFileSync('./build/contracts/ArraysAndStructs.json', 'utf8'));
const contractJson = fs.readFileSync('./build/contracts/ArraysAndStructs.json');
const abi = JSON.parse(contractJson);
let contractInstance = new web3.eth.Contract(contract.abi);
let contractBytecode = contract.bytecode
let deploy=contractInstance=contractInstance.deploy({data:contractBytecode}).encodeABI();
//let gas = parseInt(0).toString(16);
//let gasPrice = parseInt(16777215).toString(16);
const customCommon = Common.forCustomChain('mainnet',
 {
            name: 'my-private-blockchain',
            networkId: 9535753591,
            chainId: 9535753591,
 },
 'byzantium',
);

web3.eth.getTransactionCount('0x228cad260b544c71dbe207b8a7b623722f54b1a7').then(nonce=>{

let rawTx = {
   nonce: '0x'+nonce,
   gas: 0xfffffff,
   gasPrice: 0x0,
   data: deploy,
   from: '0x228cad260b544c71dbe207b8a7b623722f54b1a7',
   chainId: 9535753591, 
   value:'0x0'
 };

var tx = new Tx(rawTx, {common: customCommon});
const privateKey = Buffer.from('ebbc907a8838d3eda64bc37c0890f83d6e24af3c57d027c94c9a69d62be29b7e','hex');
tx.sign(privateKey);

const serializedTx = `0x${tx.serialize().toString('hex')}`;

web3.eth.sendSignedTransaction(serializedTx)
.on('receipt', receipt => { console.log('Receipt: ', receipt); console.log('Address: ',receipt.contractAddress)})
.catch(error => { console.log('Error: ', error.message); });
console.log("Saliendo");

});
