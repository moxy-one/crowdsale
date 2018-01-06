pragma solidity ^0.4.18;

/**
 * IAuthenticator 
 *
 * Authenticator interface
 *
 * #created 15/10/2017
 * #author Frank Bonnet
 */
interface IAuthenticator {
    

    /**
     * Authenticate 
     *
     * Returns whether `_account` is authenticated or not
     *
     * @param _account The account to authenticate
     * @return whether `_account` is successfully authenticated
     */
    function authenticate(address _account) public view returns (bool);
}