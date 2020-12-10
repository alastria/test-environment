const assert = require('assert');

const { exec } = require("child_process");
const keythereum = require('keythereum');
fs = require('fs')
let accounts;
Web3 = require('web3')

web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:22000"));

exec("openssl ecparam -name secp256k1 -genkey -noout | openssl ec -text -noout > Key",(error,stdout,stderr)=>{
console.log(`stdout:${stdout}`);
exec("cat Key | grep pub -A 5 | tail -n +2|tr -d '\n[:space:]:' | sed 's/^04//' > pub",(error,stdout,stderr)=>{
    exec("cat Key | grep priv -A 3 | tail -n +2|tr -d '\n[:space:]:' | sed 's/^00//' > priv",(error,stdout,stderr)=>{
          fs.readFile('priv', 'utf8', function (err,data) {
            var randomstring = Math.random().toString(36).slice(-16);
            console.log('La clave privada es: ',data)
            console.log(randomstring)
            web3.eth.personal.importRawKey(data, 'Passw0rd').then(console.log);

        });
    });

  });

});

web3.eth.getAccounts().then(console.log)
