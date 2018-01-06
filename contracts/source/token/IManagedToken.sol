pragma solidity ^0.4.18;

import "./IToken.sol";

/**
 * IManagedToken
 *
 * Adds the following functionality to the basic ERC20 token
 * - Locking
 * - Issuing
 * - Burning 
 *
 * #created 29/09/2017
 * #author Frank Bonnet
 */
interface IManagedToken { 

    /** 
     * Returns true if the token is locked
     * 
     * @return Whether the token is locked
     */
    function isLocked() public view returns (bool);


    /**
     * Locks the token so that the transfering of value is disabled 
     *
     * @return Whether the unlocking was successful or not
     */
    function lock() public returns (bool);


    /**
     * Unlocks the token so that the transfering of value is enabled 
     *
     * @return Whether the unlocking was successful or not
     */
    function unlock() public returns (bool);


    /**
     * Issues `_value` new tokens to `_to`
     *
     * @param _to The address to which the tokens will be issued
     * @param _value The amount of new tokens to issue
     * @return Whether the tokens where sucessfully issued or not
     */
    function issue(address _to, uint _value) public returns (bool);


    /**
     * Burns `_value` tokens of `_from`
     *
     * @param _from The address that owns the tokens to be burned
     * @param _value The amount of tokens to be burned
     * @return Whether the tokens where sucessfully burned or not 
     */
    function burn(address _from, uint _value) public returns (bool);
}