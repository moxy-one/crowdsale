module.exports = {
  networks: {
    test: {
      host: "localhost",
      port: 8545,
      gas: 6000000,
      network_id: "*" // Match any network id
    },
    main: {
      host: "localhost",
      port: 8547,
      network_id: 1, // Official Ethereum network 
      gas: 4500000,
      from: "0x3cAf983aCCccc2551195e0809B7824DA6FDe4EC8"
    }
  },
  solc: {
		optimizer: {
			enabled: true,
			runs: 200
		}
	}
}
