var truffle = require('../truffle')
var config = require('../config')
var util = require('../modules/util')

// Contracts
var Whitelist = artifacts.require('Whitelist')
var CrowdsaleProxyFactory = artifacts.require('CrowdsaleProxyFactory')
var CrowdsalePoolFactory = artifacts.require('CrowdsalePoolFactory')

// Dynamic contracts
var Token
var Crowdsale

// Testing contracts
var Accounts = artifacts.require('Accounts')

// Events
var preDeploy = () => Promise.resolve()
var postDeploy = () => Promise.resolve()

// Deploy
var deploy = async function(deployer, network, accounts, config) {
  
  // Setup
  util.setArtifacts(artifacts)
  util.setAccounts(accounts)

  // Dynamic artifacts
  Token = artifacts.require(config.token.contract)
  TokenBurner = artifacts.require(config.token.burner.contract)
  Crowdsale = artifacts.require(config.crowdsale.contract)

  // Events
  if (await util.network.isTestingNetwork(network)) {
    preDeploy = async function () {
      await deployer.deploy(Accounts, accounts)
    }
  } else if (network == 'main') {
    postDeploy = async function () {
      let token = await Token.deployed()
      await token.removeOwner(truffle.networks[network].from)
    }
  }

  // Before deploying
  await preDeploy()

  // Deploy Whitelist
  await deployer.deploy(Whitelist)
  let whitelist = await Whitelist.deployed()
  
  // Deploy crowdsale and token
  await deployer.deploy(Token)
  await deployer.deploy(TokenBurner)
  await deployer.deploy(Crowdsale)

  let token = await Token.deployed()
  let tokenBurner = await TokenBurner.deployed()
  let crowdsale = await Crowdsale.deployed()

  // Deploy factories
  await deployer.deploy(CrowdsaleProxyFactory, crowdsale.address, token.address)
  await deployer.deploy(CrowdsalePoolFactory, crowdsale.address, token.address)

  let crowdsalePoolFactory = await CrowdsalePoolFactory.deployed()

  // Configure factories
  await token.addOwner(crowdsalePoolFactory.address)

  // Configure token burner
  await token.addOwner(tokenBurner.address)
  await token.registerObserver(tokenBurner.address)
  await tokenBurner.setup(token.address)
  await tokenBurner.deploy()

  // Configure crowdsale
  await token.addOwner(crowdsale.address)
  await setupCrowdsale(
    crowdsale, 
    token, 
    whitelist, 
    config.precision, 
    config.crowdsale, 
    accounts)

  // After deploying
  await postDeploy()
}

// Configure crowdsale
var setupCrowdsale = async function(crowdsale, token, whitelist, precision, config, accounts) {
  let tokenDecimals = await token.decimals.call()

  await crowdsale.setup(
    util.config.getTimestampValue(config.presale.start),
    token.address,
    Math.pow(10, tokenDecimals.toNumber()),
    Math.pow(10, precision),
    util.config.getWeiValue(config.presale.soft),
    util.config.getWeiValue(config.presale.hard),
    util.config.getWeiValue(config.presale.accepted),
    util.config.getWeiValue(config.publicsale.soft),
    util.config.getWeiValue(config.publicsale.hard),
    util.config.getWeiValue(config.publicsale.accepted))

  await crowdsale.setupPhases(
    config.baseRate,
    Array.from(config.phases, val => val.rate), 
    Array.from(config.phases, val => util.config.getDurationValue(val.duration)), 
    Array.from(config.phases, val => util.config.getDurationValue(val.lockupPeriod)),
    Array.from(config.phases, val => val.usesVolumeMultiplier))

  await crowdsale.setupVolumeMultipliers(
    Array.from(config.volumeMultipliers, val => val.rate), 
    Array.from(config.volumeMultipliers, val => val.lockupPeriod), 
    Array.from(config.volumeMultipliers, val => util.config.getWeiValue(val.threshold)))

  await crowdsale.setupStakeholders(
    Array.from(config.stakes.stakeholders, val => util.config.getAccountValue(val.account)), 
    Array.from(config.stakes.stakeholders, val => val.eth), 
    Array.from(config.stakes.stakeholders, val => val.tokens),
    Array.from(config.stakes.stakeholders, val => val.overwriteReleaseDate),
    Array.from(config.stakes.stakeholders, val => util.config.getTimestampValue(val.fixedReleaseDate)),
    Array.from(config.stakes.tokenReleasePhases, val => val.percentage),
    Array.from(config.stakes.tokenReleasePhases, val => util.config.getDurationValue(val.vestingPeriod)))

  if (typeof config.authentication.whitelist === 'object') {
    await crowdsale.setupAuthentication(
      typeof config.authentication.whitelist.address === 'string' ? config.authentication.whitelist.address : whitelist.address, 
      config.authentication.whitelist.require)    
  }

  await crowdsale.deploy()
}

module.exports = function(deployer, network, accounts) {
  return deployer.then(async () => await deploy(deployer, network, accounts, config.network[network]))
}