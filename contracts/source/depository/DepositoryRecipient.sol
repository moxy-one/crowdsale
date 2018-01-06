pragma solidity ^0.4.18;

import "./IDepositoryRecipient.sol";

/**
 * Depository recipient
 */
contract DepositoryRecipient is IDepositoryRecipient{

    /**
     * Receive an ether deposit
     */
    function deposit() public payable {
        onDepositReceived(msg.sender, msg.value);
    }


    /**
     * Event called when a deposit is received
     *
     * @param _depository The sending depository
     * @param _value The wei value that was received
     */
    function onDepositReceived(address _depository, uint _value) internal;
}
