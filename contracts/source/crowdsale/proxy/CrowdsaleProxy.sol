pragma solidity ^0.4.18;

import "./ICrowdsaleProxy.sol";
import "../ICrowdsale.sol";

/**
 * CrowdsaleProxy
 *
 * #created 22/11/2017
 * #author Frank Bonnet
 */
contract CrowdsaleProxy is ICrowdsaleProxy {

    address public owner;
    ICrowdsale public target;
    

    /**
     * Deploy proxy
     *
     * @param _owner Owner of the proxy
     * @param _target Target crowdsale
     */
    function CrowdsaleProxy(address _owner, address _target) public {
        target = ICrowdsale(_target);
        owner = _owner;
    }


    /**
     * Receive contribution and forward to the crowdsale
     * 
     * This function requires that msg.sender is not a contract. This is required because it's 
     * not possible for a contract to specify a gas amount when calling the (internal) send() 
     * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
     */
    function () public payable {
        target.contributeFor.value(msg.value)(msg.sender);
    }


    /**
     * Receive ether and issue tokens to the sender
     *
     * @return The accepted ether amount
     */
    function contribute() public payable returns (uint) {
        target.contributeFor.value(msg.value)(msg.sender);
    }


    /**
     * Receive ether and issue tokens to `_beneficiary`
     *
     * @param _beneficiary The account that receives the tokens
     * @return The accepted ether amount
     */
    function contributeFor(address _beneficiary) public payable returns (uint) {
        target.contributeFor.value(msg.value)(_beneficiary);
    }
}