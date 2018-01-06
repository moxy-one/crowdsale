pragma solidity ^0.4.18;

/**
 * Ether depository interface
 */
interface IDepository {

    /**
     * Withdraw balance to msg.sender
     */
    function withdraw() public;


    /**
     * Withdraw balance to `_beneficiary`
     *
     * @param _beneficiary Receiver
     */
    function withdrawTo(address _beneficiary) public;
}
