// Tools
var _ = require('lodash')
var BigNumber = require('bignumber.js')
var Web3Factory = require('../modules/web3_factory')

// Modules
var web3 = Web3Factory.create({testrpc: true})
var time = require('./time')

var accounts
var artifacts
var _export = {
    setAccounts: (_accounts) => {
        accounts = _accounts
    },
    setArtifacts: (_artifacts) => {
        artifacts = _artifacts
    },
    network: {
        isTestingNetwork: (network) => {
            return network == 'test' || network == 'develop' || network == 'development'
        }
    },
    config: {
        getAccountValue: (account) => {
            if (typeof account === 'number') {
                return accounts[account]
            } else if (typeof account.deployed === 'object') {
                let Contract = artifacts.require(account.deployed.contract)
                return Contract.address
            } else {
                return account
            }
        },
        getWeiValue: (params) => {
            return new BigNumber(
                web3.utils.toWei(params[0].toString(), params[1].toString()))
        },
        getDurationValue: (params) => {
            return typeof params === 'number' ? params : params[0] * time[params[1]]
        },
        getTimestampValue: (param) => {
            return typeof param === 'number' ? param : time.convert.toUnixTime(param)
        }
    },
    transaction: {
        getGasPricePromise: async () => {
            return web3.eth.getGasPricePromise()
        },
        getTransactionCostPromise: async (transaction) => {
            return (new BigNumber(transaction.receipt.gasUsed)).mul(await _export.transaction.getGasPricePromise())
        }
    },
    errors: {
        throws: (error, message) => {
            return new Promise((resolve, reject) => {
                if (error.toString().indexOf("invalid opcode") > -1) {
                    return resolve("Expected evm error")
                    } else {
                        throw Error(message + " (" + error + ")") // Different exeption thrown
                    }
            })
        }
    },
    events: {
        get: (contract, filter) => {
            return new Promise((resolve, reject) => {
                var event = contract[filter.event]()
                event.watch()
                event.get((error, logs) => {
                    var log = _.filter(logs, filter)
                    if (log.length > 0) {
                        resolve(log)
                    } else {
                        throw Error("No logs found for " + filter.event)
                    }
                })
                event.stopWatching()
            })
        },
        assert: (contract, filter) => {
            return new Promise((resolve, reject) => {
                var event = contract[filter.event]()
                event.watch()
                event.get((error, logs) => {
                    var log = _.filter(logs, filter)
                    if (log.length == 1) {
                        resolve(log)
                    } else if (log.length > 0) {
                        throw Error("Multiple events found for " + filter.event)
                    } else {
                        throw Error("Failed to find filtered event for " + filter.event)
                    }
                })
                event.stopWatching()
            })
        }
    }
}

module.exports = _export