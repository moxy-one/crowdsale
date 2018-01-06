pragma solidity ^0.4.18;

/**
 * IObservable
 *
 * Allows observers to register and unregister with the 
 * implementing smart-contract that is observable
 *
 * #created 09/10/2017
 * #author Frank Bonnet
 */
interface IObservable {


    /**
     * Returns true if `_account` is a registered observer
     * 
     * @param _account The account to test against
     * @return Whether the account is a registered observer
     */
    function isObserver(address _account) public view returns (bool);


    /**
     * Gets the amount of registered observers
     * 
     * @return The amount of registered observers
     */
    function getObserverCount() public view returns (uint);


    /**
     * Gets the observer at `_index`
     * 
     * @param _index The index of the observer
     * @return The observers address
     */
    function getObserverAtIndex(uint _index) public view returns (address);


    /**
     * Register `_observer` as an observer
     * 
     * @param _observer The account to add as an observer
     */
    function registerObserver(address _observer) public;


    /**
     * Unregister `_observer` as an observer
     * 
     * @param _observer The account to remove as an observer
     */
    function unregisterObserver(address _observer) public;
}
