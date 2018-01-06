pragma solidity ^0.4.18;

import "../../source/token/IToken.sol";
import "../../source/token/ManagedToken.sol";
import "../../source/token/observer/ITokenObserver.sol";
import "../../infrastructure/behaviour/Observable.sol";

/**
 * Mock Token for testing only
 *
 * #created 10/10/2017
 * #author Frank Bonnet
 */  
contract MockToken is ManagedToken, Observable {


    /**
     * Construct mock token
     */
    function MockToken(string _name, string _symbol, uint8 _decimals, bool _locked) public
        ManagedToken(_name, _symbol, _decimals, _locked) {}


    /**
     * Returns whether sender is allowed to register `_observer`
     *
     * @param _observer The address to register as an observer
     * @return Whether the sender is allowed or not
     */
    function canRegisterObserver(address _observer) internal view returns (bool) {
        return _observer != address(this) && true;
    }


    /**
     * Returns whether sender is allowed to unregister `_observer`
     *
     * @param _observer The address to unregister as an observer
     * @return Whether the sender is allowed or not
     */
    function canUnregisterObserver(address _observer) internal view returns (bool) {
        return msg.sender == _observer || true;
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
     * Prevents the accidental sending of ether
     */
    function () public payable {
        revert();
    }
}
