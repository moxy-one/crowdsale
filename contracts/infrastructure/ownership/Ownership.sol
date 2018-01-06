pragma solidity ^0.4.18;

import "./IOwnership.sol";

/**
 * Ownership
 *
 * Perminent ownership
 *
 * #created 01/10/2017
 * #author Frank Bonnet
 */
contract Ownership is IOwnership {

    // Owner
    address internal owner;


    /**
     * Access is restricted to the current owner
     */
    modifier only_owner() {
        require(msg.sender == owner);
        _;
    }


    /**
     * The publisher is the inital owner
     */
    function Ownership() public {
        owner = msg.sender;
    }


    /**
     * Returns true if `_account` is the current owner
     *
     * @param _account The address to test against
     */
    function isOwner(address _account) public view returns (bool) {
        return _account == owner;
    }


    /**
     * Gets the current owner
     *
     * @return address The current owner
     */
    function getOwner() public view returns (address) {
        return owner;
    }
}
