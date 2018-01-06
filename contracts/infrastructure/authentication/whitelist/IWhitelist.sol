pragma solidity ^0.4.18;

/**
 * IWhitelist 
 *
 * Whitelist authentication interface
 *
 * #created 04/10/2017
 * #author Frank Bonnet
 */
interface IWhitelist {
    

    /**
     * Returns whether an entry exists for `_account`
     *
     * @param _account The account to check
     * @return whether `_account` is has an entry in the whitelist
     */
    function hasEntry(address _account) public view returns (bool);


    /**
     * Add `_account` to the whitelist
     *
     * If an account is currently disabled, the account is reenabled, otherwise 
     * a new entry is created
     *
     * @param _account The account to add
     */
    function add(address _account) public;


    /**
     * Remove `_account` from the whitelist
     *
     * Will not actually remove the entry but disable it by updating
     * the accepted record
     *
     * @param _account The account to remove
     */
    function remove(address _account) public;
}