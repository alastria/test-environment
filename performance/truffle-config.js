module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  compilers: {
    solc: {
      version: "0.5.17",//This solc version must be the same as or be ahead of the Alastria node one
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    main: {
      host: "localhost",
      port: 22000,
      network_id: "*", // Match any network id
      gas: 0xfffff,
      gasPrice: 0x0,
      from: "0xB50001FfA410F4D03663D69540c1C8e1C017e7e6"
    },
    validator1: {
      host: "localhost",
      port: 22005,
      network_id: "*", // Match any network id
      gas: 0xfffff,
      gasPrice: 0x0,
      from: "0xD8CfEA3B26B879f9D208975dFE8460F27520876b"
    },
    general1: {
      host: "localhost",
      port: 22001,
      network_id: "*", // Match any network id
      gas: 0xfffff,
      gasPrice: 0x0,
      // from: "0x0defda53d6e0ba7627a4891b43737c5889e280cc"
    },
    general2: {
      host: "localhost",
      port: 22002,
      network_id: "*", // Match any network id
      gas: 0xfffff,
      gasPrice: 0x0,
      // from: "0xd2202fba136c2c57d55bfcf83a376ac2914954cb"
    },
    general3: {
      host: "localhost",
      port: 22003,
      network_id: "*", // Match any network id
      gas: 0xfffff,
      gasPrice: 0x0,
      // from: ""
    }
  }
};
