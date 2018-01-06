pragma solidity ^0.4.18;

import "../../source/token/observer/TokenObserver.sol";

/**
 * Mock TokenObserver for testing only
 *
 * #created 09/10/2017
 * #author Frank Bonnet
 */  
contract MockTokenObserver is TokenObserver {

    struct Record {
        address token;
        address sender;
        uint value;
    }

    Record[] private records;

    function getRecordCount() public view returns (uint) {
        return records.length;
    }

    function getRecordAt(uint _index) public view returns (address, address, uint) {
        Record storage r = records[_index];
        return (r.token, r.sender, r.value);
    }

    function onTokensReceived(address _token, address _sender, uint _value) internal {
        records.push(Record(_token, _sender, _value));
    }
}