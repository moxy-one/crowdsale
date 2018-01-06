pragma solidity ^0.4.18;

import "../../source/SpendCrowdsale.sol";

contract ProxyCrowdsale is SpendCrowdsale {
    function ProxyCrowdsale() public SpendCrowdsale() {}
}