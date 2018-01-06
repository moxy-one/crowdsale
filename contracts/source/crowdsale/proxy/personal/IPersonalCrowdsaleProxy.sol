pragma solidity ^0.4.18;

/**
 * IPersonalCrowdsaleProxy
 *
 * #created 22/11/2017
 * #author Frank Bonnet
 */
interface IPersonalCrowdsaleProxy {


    /**
     * Receive ether to forward to the target crowdsale
     */
    function () public payable;


    /**
     * Invest received ether in target crowdsale
     */
    function invest() public;


    /**
     * Request a refund from the target crowdsale
     */
    function refund() public;


    /**
     * Request outstanding token balance from the 
     * target crowdsale
     */
    function updateTokenBalance() public;


    /**
     * Transfer token balance to beneficiary
     */
    function withdrawTokens() public;


    /**
     * Request outstanding ether balance from the 
     * target crowdsale
     */
    function updateEtherBalance() public;


    /**
     * Transfer ether balance to beneficiary
     */
    function withdrawEther() public;
}
