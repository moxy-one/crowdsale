pragma solidity ^0.4.18;

/**
 * ITokenRetriever
 *
 * Allows tokens to be retrieved from a contract
 *
 * #created 29/09/2017
 * #author Frank Bonnet
 */
interface ITokenRetriever {

    /**
     * Extracts tokens from the contract
     *
     * @param _tokenContract The address of ERC20 compatible token
     */
    function retrieveTokens(address _tokenContract) public;
}