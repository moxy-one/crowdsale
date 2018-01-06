var extensions = require('./web3_extensions.js')
var promisify = require('./web3_promisify.js')

module.exports = {
    create: function (options) {
        var web3 = extensions.create(options)
        promisify.promisifyWeb3(web3)
        return web3
    }
}