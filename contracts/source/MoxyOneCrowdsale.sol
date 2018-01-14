pragma solidity ^0.4.18;

import "./crowdsale/Crowdsale.sol";
import "./token/retriever/TokenRetriever.sol";
import "../infrastructure/state/IPausable.sol";
import "../infrastructure/authentication/IAuthenticator.sol";
import "../infrastructure/authentication/IAuthenticationManager.sol";
import "../thirdparty/wings/source/IWingsAdapter.sol";

/**
 * MoxyOne Crowdsale
 *
 * Advancing the blockchain industry by creating seamless and secure debit card 
 * and payment infrastructure for every company, project and ICO that issues cryptocurrency tokens. 
 *
 * #created 06/01/2018
 * #author Frank Bonnet
 */
contract MoxyOneCrowdsale is Crowdsale, TokenRetriever, IPausable, IAuthenticationManager, IWingsAdapter {

    // State
    bool private paused;

    // Authentication
    IAuthenticator private authenticator;
    bool private requireAuthentication;


    /**
     * Returns whether the implementing contract is 
     * currently paused or not
     *
     * @return Whether the paused state is active
     */
    function isPaused() public view returns (bool) {
        return paused;
    }


    /**
     * Change the state to paused
     */
    function pause() public only_owner {
        paused = true;
    }


    /**
     * Change the state to resume, undo the effects 
     * of calling pause
     */
    function resume() public only_owner {
        paused = false;
    }


    /**
     * Setup authentication
     *
     * @param _authenticator The address of the authenticator (whitelist)
     * @param _requireAuthentication Wether the crowdale requires contributors to be authenticated
     */
    function setupAuthentication(address _authenticator, bool _requireAuthentication) public only_owner at_stage(Stages.Deploying) {
        authenticator = IAuthenticator(_authenticator);
        requireAuthentication = _requireAuthentication;
    }


    /**
     * Returns true if authentication is enabled and false 
     * otherwise
     *
     * @return Whether the converter is currently authenticating or not
     */
    function isAuthenticating() public view returns (bool) {
        return requireAuthentication;
    }


    /**
     * Enable authentication
     */
    function enableAuthentication() public only_owner {
        requireAuthentication = true;
    }


    /**
     * Disable authentication
     */
    function disableAuthentication() public only_owner {
        requireAuthentication = false;
    }


    /**
     * Validate a contributing account
     *
     * @param _contributor Address that is being validated
     * @return Wheter the contributor is accepted or not
     */
    function isAcceptedContributor(address _contributor) internal view returns (bool) {
        return !requireAuthentication || authenticator.authenticate(_contributor);
    }


    /**
     * Indicate if contributions are currently accepted
     *
     * @return Wheter contributions are accepted or not
     */
    function isAcceptingContributions() internal view returns (bool) {
        return !paused;
    }


    /**
     * Wings integration - Get the total raised amount of Ether
     *
     * Can only increased, means if you withdraw ETH from the wallet, should be not modified (you can use two fields 
     * to keep one with a total accumulated amount) amount of ETH in contract and totalCollected for total amount of ETH collected
     *
     * @return Total raised Ether amount
     */
    function totalCollected() public view returns (uint) {
        return raised;
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

        // Retrieve tokens from our token contract
        ITokenRetriever(token).retrieveTokens(_tokenContract);
    }
}