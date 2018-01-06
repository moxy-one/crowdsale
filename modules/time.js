Date.prototype.getUnixTime = function() { 
    return this.getTime()/1000|0;
}

var _export = {
    now: parseInt(new Date().getTime() / 1000),
    hours: 3600,
    days: 86400,
    weeks: 604800,
    years: 31536000,
    getTimeUntil: function (input) {
        let targetTime = Number.isInteger(input) ? input : _export.convert.toDateObject(input).getUnixTime()
        let currentTime = (new Date()).getUnixTime()
        return targetTime > currentTime ? targetTime + 1 - currentTime : 0;
    },
    convert: {
        toDateObject: function(input) {
            return 'object' === typeof input ? input : new Date(input)
        },
        toUnixTime: function(input) {
            return _export.convert.toDateObject(input).getUnixTime()
        }
    }
}

module.exports = _export