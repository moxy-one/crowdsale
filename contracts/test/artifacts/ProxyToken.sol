pragma solidity ^0.4.18;

import "../../source/SpendToken.sol";

contract ProxyToken is SpendToken {
    function ProxyToken() public SpendToken() {}
}