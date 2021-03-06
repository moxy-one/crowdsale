module.exports = {
    network: {
        test: {
            precision: 4, // Amount of decimals
            token: {
                contract: 'ProxyToken',
                burner: {
                    contract: 'ProxyTokenBurner'
                }
            },
            crowdsale: {
                contract: 'ProxyCrowdsale',
                baseRate: 1000,
                authentication: {
                    whitelist: {
                        require: true
                    }
                },
                presale: {
                    start: 'January 19, 2018 01:00:00 GMT+0000',
                    soft: [500, 'ether'],
                    hard: [20000, 'ether'],
                    accepted: [1, 'ether']
                },
                publicsale: {
                    start: 'March 14, 2018 01:00:00 GMT+0000',
                    soft: [4000, 'ether'],
                    hard: [24000, 'ether'],
                    accepted: [10, 'finney']
                },
                phases: [{
                    duration: [50, 'days'], // Presale - until March 10, 2018
                    rate: 1000,
                    lockupPeriod: [30, 'days'],
                    usesVolumeMultiplier: true
                }, {
                    duration: [4, 'days'], // Break - until March 14, 2018
                    rate: 0,
                    lockupPeriod: 0,
                    usesVolumeMultiplier: false
                }, {
                    duration: [1, 'days'], // First day - until March 15, 2018
                    rate: 1400, // 40% 
                    lockupPeriod: 0,
                    usesVolumeMultiplier: false
                }, {
                    duration: [7, 'days'], // First week - until March 21, 2018
                    rate: 1200, // 20%
                    lockupPeriod: 0,
                    usesVolumeMultiplier: false
                }, {
                    duration: [7, 'days'], // Second week - until March 28, 2018
                    rate: 1150, // 15%
                    lockupPeriod: 0,
                    usesVolumeMultiplier: false
                }, {
                    duration: [7, 'days'], // Third week - until April 4, 2018
                    rate: 1100, // 10%
                    lockupPeriod: 0,
                    usesVolumeMultiplier: false
                }, {
                    duration: [10, 'days'], // Last week - until April 14, 2018
                    rate: 1000, // 0%
                    lockupPeriod: 0,
                    usesVolumeMultiplier: false
                }],
                volumeMultipliers: [{
                    rate: 4000, // 1:1400
                    lockupPeriod: 0,
                    threshold: [1, 'ether']
                }, {
                    rate: 4500, // 1:1450
                    lockupPeriod: 0,
                    threshold: [30, 'ether']
                }, {
                    rate: 5000, // 1:1500
                    lockupPeriod: 5000,
                    threshold: [100, 'ether']
                }, {
                    rate: 5500, // 1:1550
                    lockupPeriod: 10000,
                    threshold: [500, 'ether']
                }, {
                    rate: 6000, // 1:1600
                    lockupPeriod: 15000,
                    threshold: [1000, 'ether']
                }, {
                    rate: 6500, // 1:1650
                    lockupPeriod: 20000,
                    threshold: [2500, 'ether']
                }],
                stakes: {
                    stakeholders: [{
                        account: 0, // Beneficiary 
                        tokens: 1000,
                        eth: 9400,
                        overwriteReleaseDate: false,
                        fixedReleaseDate: 0
                    }, {
                        account: 1, // Founders
                        tokens: 600,
                        eth: 0,
                        overwriteReleaseDate: true,
                        fixedReleaseDate: 0
                    }, {
                        account: 2, // Marketing 1
                        tokens: 500,
                        eth: 300,
                        overwriteReleaseDate: true,
                        fixedReleaseDate: 0
                    }, {
                        account: 3, // Marketing 2
                        tokens: 500,
                        eth: 300,
                        overwriteReleaseDate: true,
                        fixedReleaseDate: 0
                    }, {
                        account: 4, // Wings.ai community
                        tokens: 200,
                        eth: 0,
                        overwriteReleaseDate: true,
                        fixedReleaseDate: 0
                    }, {
                        account: 5, // Dcorp community
                        tokens: 200,
                        eth: 0,
                        overwriteReleaseDate: true,
                        fixedReleaseDate: 0
                    }],
                    tokenReleasePhases: [{ // Vesting period of 6 months then 10% each month
                        percentage: 1000,
                        vestingPeriod: [180, 'days'] // [6, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [210, 'days'] // [7, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [240, 'days'] // [8, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [270, 'days'] // [9, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [300, 'days'] // [10, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [330, 'days'] // [11, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [360, 'days'] // [12, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [390, 'days'] // [13, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [420, 'days'] // [14, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [450, 'days'] // [15, 'months']
                    }]
                }
            }
        }, 
        main: {
            precision: 4, // Amount of decimals
            token: {
                contract: 'SpendToken',
                burner: {
                    contract: 'SpendTokenBurner'
                }
            },
            crowdsale: {
                contract: 'MoxyOneCrowdsale',
                baseRate: 1000,
                authentication: {
                    whitelist: {
                        require: true
                    }
                },
                presale: {
                    start: 'January 19, 2018 01:00:00 GMT+0000',
                    soft: [500, 'ether'],
                    hard: [20000, 'ether'],
                    accepted: [1, 'ether']
                },
                publicsale: {
                    start: 'March 14, 2018 01:00:00 GMT+0000',
                    soft: [4000, 'ether'],
                    hard: [24000, 'ether'],
                    accepted: [10, 'finney']
                },
                phases: [{
                    duration: [50, 'days'], // Presale - until March 10, 2018
                    rate: 1000,
                    lockupPeriod: [30, 'days'],
                    usesVolumeMultiplier: true
                }, {
                    duration: [4, 'days'], // Break - until March 14, 2018
                    rate: 0,
                    lockupPeriod: 0,
                    usesVolumeMultiplier: false
                }, {
                    duration: [1, 'days'], // First day - until March 15, 2018
                    rate: 1400, // 40% 
                    lockupPeriod: 0,
                    usesVolumeMultiplier: false
                }, {
                    duration: [7, 'days'], // First week - until March 21, 2018
                    rate: 1200, // 20%
                    lockupPeriod: 0,
                    usesVolumeMultiplier: false
                }, {
                    duration: [7, 'days'], // Second week - until March 28, 2018
                    rate: 1150, // 15%
                    lockupPeriod: 0,
                    usesVolumeMultiplier: false
                }, {
                    duration: [7, 'days'], // Third week - until April 4, 2018
                    rate: 1100, // 10%
                    lockupPeriod: 0,
                    usesVolumeMultiplier: false
                }, {
                    duration: [10, 'days'], // Last week - until April 14, 2018
                    rate: 1000, // 0%
                    lockupPeriod: 0,
                    usesVolumeMultiplier: false
                }],
                volumeMultipliers: [{
                    rate: 4000, // 1:1400
                    lockupPeriod: 0,
                    threshold: [1, 'ether']
                }, {
                    rate: 4500, // 1:1450
                    lockupPeriod: 0,
                    threshold: [30, 'ether']
                }, {
                    rate: 5000, // 1:1500
                    lockupPeriod: 5000,
                    threshold: [100, 'ether']
                }, {
                    rate: 5500, // 1:1550
                    lockupPeriod: 10000,
                    threshold: [500, 'ether']
                }, {
                    rate: 6000, // 1:1600
                    lockupPeriod: 15000,
                    threshold: [1000, 'ether']
                }, {
                    rate: 6500, // 1:1650
                    lockupPeriod: 20000,
                    threshold: [2500, 'ether']
                }],
                stakes: {
                    stakeholders: [{
                        account: '0xb9E422C14Dc386ecABA087763042F7aaf979F2C9', // Beneficiary 
                        tokens: 1000,
                        eth: 9400,
                        overwriteReleaseDate: false,
                        fixedReleaseDate: 0
                    }, {
                        account: '0xd0aa53768b851f48ed7b463c727232428cb6f04d', // Founders 
                        tokens: 600,
                        eth: 0,
                        overwriteReleaseDate: true,
                        fixedReleaseDate: 0
                    }, {
                        account: '0xfc4Ac0FedF39179fC9725f5ee8CCFDd0E28b1aCF', // Marketing 1
                        tokens: 500,
                        eth: 300,
                        overwriteReleaseDate: true,
                        fixedReleaseDate: 0
                    }, {
                        account: '0xF83D6D63d25a63ef460cBA916e12315F1be1a786', // Marketing 2
                        tokens: 500,
                        eth: 300,
                        overwriteReleaseDate: true,
                        fixedReleaseDate: 0
                    }, {
                        account: '0x72f38252217aD228da137aCf3a2CbF9adC61B24d', // Wings.ai community
                        tokens: 200,
                        eth: 0,
                        overwriteReleaseDate: true,
                        fixedReleaseDate: 0
                    }, {
                        account: '0xba998e5DcE0ef01E481087B51790eD537eAf4832', // DCorp community
                        tokens: 200,
                        eth: 0,
                        overwriteReleaseDate: true,
                        fixedReleaseDate: 0
                    }],
                    tokenReleasePhases: [{ // Vesting period of 6 months then 10% each month
                        percentage: 1000,
                        vestingPeriod: [180, 'days'] // [6, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [210, 'days'] // [7, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [240, 'days'] // [8, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [270, 'days'] // [9, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [300, 'days'] // [10, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [330, 'days'] // [11, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [360, 'days'] // [12, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [390, 'days'] // [13, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [420, 'days'] // [14, 'months']
                    }, {
                        percentage: 1000,
                        vestingPeriod: [450, 'days'] // [15, 'months']
                    }]
                }
            }
        }
    }
}
  