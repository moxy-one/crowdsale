pragma solidity ^0.4.18;

/**
 * ICrowdsaleProxy
 *
 * #created 23/11/2017
 * #author Frank Bonnet
 */
interface ICrowdsaleProxy {

    /**
     * Receive ether and issue tokens to the sender
     * 
     * This function requires that msg.sender is not a contract. This is required because it's 
     * not possible for a contract to specify a gas amount when calling the (internal) send() 
     * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
     * 
     * Contracts can call the contribute() function instead
     */
    function () public payable;


    /**
     * Receive ether and issue tokens to the sender
     *
     * @return The accepted ether amount
     */
    function contribute() public payable returns (uint);


    /**
     * Receive ether and issue tokens to `_beneficiary`
     *
     * @param _beneficiary The account that receives the tokens
     * @return The accepted ether amount
     */
    function contributeFor(address _beneficiary) public payable returns (uint);
}
