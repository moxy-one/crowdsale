pragma solidity ^0.4.18;

import "../../source/MoxyOneCrowdsale.sol";

contract ProxyCrowdsale is MoxyOneCrowdsale {
    function ProxyCrowdsale() public MoxyOneCrowdsale() {}
}