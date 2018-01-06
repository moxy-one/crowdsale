pragma solidity ^0.4.18;

import "../../source/SpendTokenBurner.sol";

contract ProxyTokenBurner is SpendTokenBurner {
    function ProxyTokenBurner() public SpendTokenBurner() {}
}