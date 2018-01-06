pragma solidity ^0.4.18;

import "./IDepository.sol";
import "./IDepositoryRecipient.sol";
import "../token/retriever/TokenRetriever.sol";
import "../../infrastructure/ownership/Ownership.sol";

/**
 * Ether depository
 */
contract Depository is Ownership, TokenRetriever {

    /**
     * Receive ether
     */
    function () public payable {
        // Just receiving
    }


    /**
     * Withdraw balance to msg.sender
     */
    function withdraw() public {
        withdrawTo(msg.sender);
    }


    /**
     * Withdraw balance to `_beneficiary`
     *
     * @param _beneficiary Receiver
     */
    function withdrawTo(address _beneficiary) public only_owner {
        IDepositoryRecipient(_beneficiary).deposit.value(this.balance)();
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
}
