pragma solidity ^0.4.18;

/**
 * Depository recipient
 */
interface IDepositoryRecipient {

    /**
     * Receive an ether deposit
     */
    function deposit() public payable;
}
