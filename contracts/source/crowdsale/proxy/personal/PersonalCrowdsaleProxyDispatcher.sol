pragma solidity ^0.4.18;

import "../../../../infrastructure/dispatcher/SimpleDispatcher.sol";

/**
 * PersonalCrowdsaleProxy Dispatcher
 *
 * #created 31/12/2017
 * #author Frank Bonnet
 */
contract PersonalCrowdsaleProxyDispatcher is SimpleDispatcher {

    // Target
    address public targetCrowdsale;
    address public targetToken;

    // Owner
    address public beneficiary;
    bytes32 private passphraseHash;


    /**
     * Deploy personal proxy
     *
     * @param _target Target contract to dispach calls to
     * @param _targetCrowdsale Target crowdsale to invest in
     * @param _targetToken Token that is bought
     * @param _passphraseHash Hash of the passphrase 
     */
    function PersonalCrowdsaleProxyDispatcher(address _target, address _targetCrowdsale, address _targetToken, bytes32 _passphraseHash) public 
        SimpleDispatcher(_target) {
        targetCrowdsale = _targetCrowdsale;
        targetToken = _targetToken;
        passphraseHash = _passphraseHash;
    }
}