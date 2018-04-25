module.exports = {
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  },
  networks: {
    general1: {
      host: "localhost",
      port: 22001,
      network_id: "*", // Match any network id
      gas: 0xfffff,
      gasPrice: 0x0,
      from: "0x0defda53d6e0ba7627a4891b43737c5889e280cc"
    },
    general2: {
      host: "localhost",
      port: 22002,
      network_id: "*", // Match any network id
      gas: 0xfffff,
      gasPrice: 0x0,
      from: "0xd2202fba136c2c57d55bfcf83a376ac2914954cb"
    }
  }
};
