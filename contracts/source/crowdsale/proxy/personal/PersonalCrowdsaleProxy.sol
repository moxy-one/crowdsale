pragma solidity ^0.4.18;

import "./IPersonalCrowdsaleProxy.sol";
import "../../ICrowdsale.sol";
import "../../../token/IToken.sol";
import "../../../../infrastructure/dispatcher/Dispatchable.sol";

/**
 * PersonalCrowdsaleProxy
 *
 * #created 31/12/2017
 * #author Frank Bonnet
 */
contract PersonalCrowdsaleProxy is IPersonalCrowdsaleProxy, Dispatchable {

    // Target
    ICrowdsale public targetCrowdsale;
    IToken public targetToken;

    // Owner
    address public beneficiary;
    bytes32 private passphraseHash;


    /**
     * Restrict call access to when the beneficiary 
     * address is known
     */
    modifier when_beneficiary_is_known() {
        require(beneficiary != address(0));
        _;
    }


    /**
     * Restrict call access to when the beneficiary 
     * address is unknown
     */
    modifier when_beneficiary_is_unknown() {
        require(beneficiary == address(0));
        _;
    }


    /**
     * Set the beneficiary account. Tokens and ether will be send 
     * to this address
     *
     * @param _beneficiary The address to receive tokens and ether
     * @param _passphrase The raw passphrasse
     */
    function setBeneficiary(address _beneficiary, bytes32 _passphrase) public when_beneficiary_is_unknown {
        require(keccak256(_passphrase) == passphraseHash);
        beneficiary = _beneficiary;
    }


    /**
     * Receive ether to forward to the target crowdsale
     */
    function () public payable {
        // Just receive ether
    }


    /**
     * Invest received ether in target crowdsale
     */
    function invest() public {
        targetCrowdsale.contribute.value(this.balance)();
    }


    /**
     * Request a refund from the target crowdsale
     */
    function refund() public {
        targetCrowdsale.refund();
    }


    /**
     * Request outstanding token balance from the 
     * target crowdsale
     */
    function updateTokenBalance() public {
        targetCrowdsale.withdrawTokens();
    }


    /**
     * Transfer token balance to beneficiary
     */
    function withdrawTokens() public when_beneficiary_is_known {
        uint balance = targetToken.balanceOf(this);
        targetToken.transfer(beneficiary, balance);
    }


    /**
     * Request outstanding ether balance from the 
     * target crowdsale
     */
    function updateEtherBalance() public {
        targetCrowdsale.withdrawEther();
    }


    /**
     * Transfer ether balance to beneficiary
     */
    function withdrawEther() public when_beneficiary_is_known {
        beneficiary.transfer(this.balance);
    }
}