pragma solidity ^0.4.18;

import "../CrowdsaleProxy.sol";
import "../personal/PersonalCrowdsaleProxy.sol";
import "../personal/PersonalCrowdsaleProxyDispatcher.sol";

/**
 * CrowdsaleProxyFactory
 *
 * #created 21/12/2017
 * #author Frank Bonnet
 */
contract CrowdsaleProxyFactory {

    // Target 
    address public targetCrowdsale;
    address public targetToken;

    // Dispatch target
    address private personalCrowdsaleProxyTarget;


    // Events
    event ProxyCreated(address proxy, address beneficiary);


    /**
     * Deploy factory
     *
     * @param _targetCrowdsale Target crowdsale to invest in
     * @param _targetToken Token that is bought
     */
    function CrowdsaleProxyFactory(address _targetCrowdsale, address _targetToken) public {
        targetCrowdsale = _targetCrowdsale;
        targetToken = _targetToken;
        personalCrowdsaleProxyTarget = new PersonalCrowdsaleProxy();
    }

    
    /**
     * Deploy a contract that serves as a proxy to 
     * the target crowdsale
     *
     * @return The address of the deposit address
     */
    function createProxyAddress() public returns (address) {
        address proxy = new CrowdsaleProxy(msg.sender, targetCrowdsale);
        ProxyCreated(proxy, msg.sender);
        return proxy;
    }


    /**
     * Deploy a contract that serves as a proxy to 
     * the target crowdsale
     *
     * @param _beneficiary The owner of the proxy
     * @return The address of the deposit address
     */
    function createProxyAddressFor(address _beneficiary) public returns (address) {
        address proxy = new CrowdsaleProxy(_beneficiary, targetCrowdsale);
        ProxyCreated(proxy, _beneficiary);
        return proxy;
    }


    /**
     * Deploy a contract that serves as a proxy to 
     * the target crowdsale
     *
     * Contributions through this address will be made 
     * for the person that knows the passphrase
     *
     * @param _passphraseHash Hash of the passphrase 
     * @return The address of the deposit address
     */
    function createPersonalDepositAddress(bytes32 _passphraseHash) public returns (address) {
        address proxy = new PersonalCrowdsaleProxyDispatcher(
            personalCrowdsaleProxyTarget, targetCrowdsale, targetToken, _passphraseHash);
        ProxyCreated(proxy, msg.sender);
        return proxy;
    }


    /**
     * Deploy a contract that serves as a proxy to 
     * the target crowdsale
     *
     * Contributions through this address will be made 
     * for `_beneficiary`
     *
     * @param _beneficiary The owner of the proxy
     * @return The address of the deposit address
     */
    function createPersonalDepositAddressFor(address _beneficiary) public returns (address) {
        PersonalCrowdsaleProxy proxy = PersonalCrowdsaleProxy(new PersonalCrowdsaleProxyDispatcher(
            personalCrowdsaleProxyTarget, targetCrowdsale, targetToken, keccak256(bytes32(_beneficiary))));
        proxy.setBeneficiary(_beneficiary, bytes32(_beneficiary));
        ProxyCreated(proxy, _beneficiary);
        return proxy;
    }
}