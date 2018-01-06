pragma solidity ^0.4.18;

import "./token/IToken.sol";
import "./token/ManagedToken.sol";
import "./token/observer/ITokenObserver.sol";
import "./token/retriever/TokenRetriever.sol";
import "../infrastructure/behaviour/Observable.sol";

/**
 * Spend token (SPEND)
 *
 * SPEND is an ERC20 token as outlined within the whitepaper.
 *
 * #created 06/01/2018
 * #author Frank Bonnet
 */
contract SpendToken is ManagedToken, Observable, TokenRetriever {

    /**
     * Construct the managed token
     */
    function SpendToken() public ManagedToken("Spend Token", "SPEND", 8, true) {}


    /**
     * Returns whether sender is allowed to register `_observer`
     *
     * @param _observer The address to register as an observer
     * @return Whether the sender is allowed or not
     */
    function canRegisterObserver(address _observer) internal view returns (bool) {
        return _observer != address(this) && isOwner(msg.sender);
    }


    /**
     * Returns whether sender is allowed to unregister `_observer`
     *
     * @param _observer The address to unregister as an observer
     * @return Whether the sender is allowed or not
     */
    function canUnregisterObserver(address _observer) internal view returns (bool) {
        return msg.sender == _observer || isOwner(msg.sender);
    }


    /**
     * Issues `_value` new tokens to `_to`
     *
     * @param _to The address to which the tokens will be issued
     * @param _value The amount of new tokens to issue
     * @return Whether the approval was successful or not
     */
    function issue(address _to, uint _value) public returns (bool) {
        bool result = super.issue(_to, _value);
        if (isObserver(_to)) {
            ITokenObserver(_to).notifyTokensReceived(msg.sender, _value);
        }

        return result;
    }


    /** 
     * Send `_value` token to `_to` from `msg.sender`
     * - Notifies registered observers when the observer receives tokens
     * 
     * @param _to The address of the recipient
     * @param _value The amount of token to be transferred
     * @return Whether the transfer was successful or not
     */
    function transfer(address _to, uint _value) public returns (bool) {
        bool result = super.transfer(_to, _value);
        if (isObserver(_to)) {
            ITokenObserver(_to).notifyTokensReceived(msg.sender, _value);
        }

        return result;
    }


    /** 
     * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
     * - Notifies registered observers when the observer receives tokens
     * 
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value The amount of token to be transferred
     * @return Whether the transfer was successful or not
     */
    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        bool result = super.transferFrom(_from, _to, _value);
        if (isObserver(_to)) {
            ITokenObserver(_to).notifyTokensReceived(_from, _value);
        }

        return result;
    }


    /**
     * Failsafe mechanism
     * 
     * Allows the owner to retrieve tokens from the contract that 
     * might have been send there by accident
     *
     * @param _tokenContract The address of ERC20 compatible token
     */
    function retrieveTokens(address _tokenContract) public only_owner {
        super.retrieveTokens(_tokenContract);
    }


    /**
     * Prevents the accidental sending of ether
     */
    function () public payable {
        revert();
    }
}
