module.exports = {
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  },
  networks: {
    development: {
      host: "localhost",
      port: 9545,
      network_id: "*", // Match any network id
      gas: 0xfffff,
      gasPrice: 0x0,
      from: "0x170f7fbec842db2919216056adf7ddc553fea086"
    },
    bbva: {
      host: "ec2-34-242-23-114.eu-west-1.compute.amazonaws.co",
      port: 23000,
      network_id: "953474359", // Match any network id
      gas: 0xfffff,
      gasPrice: 0x0,
      from: "0x2f79ed24eb74060ec8265705b1b17f12759af2bb"
    },
    santander: {
      host: "ec2-54-229-173-250.eu-west-1.compute.amazonaws.com",
      port: 23000,
      network_id: "953474359", // Match any network id
      gas: 0xfffff,
      gasPrice: 0x0,
      from: "0xa285a82a165f8f4764cb2d9abcdd5a96647910fd"
    },
    iberclear: {
      host: "ec2-34-252-126-69.eu-west-1.compute.amazonaws.com",
      port: 23000,
      network_id: "953474359", // Match any network id
      gas: 0xfffff,
      gasPrice: 0x0,
      from: "0xdddca1c1d1b917f26d091fda184faf21be828ac2"
    },
    bme: {
      host: "ec2-34-252-79-240.eu-west-1.compute.amazonaws.com",
      port: 23000,
      network_id: "953474359", // Match any network id
      gas: 0xfffff,
      gasPrice: 0x0,
      from: "0x83c7b9b1f316d30c150e081b293e3cea882d0132"
    },
    cnmv: {
      host: "ec2-52-48-236-1.eu-west-1.compute.amazonaws.com",
      port: 23000,
      network_id: "953474359", // Match any network id
      gas: 0xfffff,
      gasPrice: 0x0,
      from: "0x170f7fbec842db2919216056adf7ddc553fea086"
    },
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
