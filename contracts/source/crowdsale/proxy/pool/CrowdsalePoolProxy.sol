pragma solidity ^0.4.18;

import "./CrowdsalePool.sol";
import "../../ICrowdsale.sol";
import "../../../token/IToken.sol";

/**
 * Crowdsale proxy pool
 *
 * This crowdsale pool forwards contributions directly
 *
 * #created 25/12/2017
 * #author Frank Bonnet
 */
contract CrowdsalePoolProxy is CrowdsalePool {

    /**
     * Deploy pool
     *
     * @param _targetCrowdsale Target crowdsale
     * @param _targetToken Token that is bought
     */
    function CrowdsalePoolProxy(address _targetCrowdsale, address _targetToken) public 
        CrowdsalePool(_targetCrowdsale, _targetToken) {
    }


    /** 
     * Get the total share of the received tokens of `_member`
     *
     * Share calcuation is based on the drpu and drps token balances and the 
     * contributed amount of ether. The weight factor and contributed factor 
     * determin the weight of each factor
     * 
     * @param _member The address from which the share will be retrieved
     * @return The total share
     */
    function shareOf(address _member) public view returns (uint) {
        return records[_member].contributed * totalTokensReceived / totalContributed; // Calculate share (member / total * tokens)
    }


    /**
     * Handle incoming transactions
     * 
     * @param _beneficiary Tokens are issued to this account
     * @return Accepted ether amount
     */
    function handleTransaction(address _beneficiary) internal returns (uint) {

        // Contribute for beneficiary
        uint acceptedAmount = targetCrowdsale.contributeFor.value(msg.value)(_beneficiary);

        // Record transaction
        if (!hasRecord(_beneficiary)) {
            records[_beneficiary].contributed = acceptedAmount;
            records[_beneficiary].index = recordIndex.push(_beneficiary) - 1;
        } else {
            records[_beneficiary].contributed += acceptedAmount;
        }

        // Record contribution
        totalContributed += acceptedAmount;
        return acceptedAmount;
    }
}