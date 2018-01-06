pragma solidity ^0.4.18;

/**
 * IAuthenticationManager 
 *
 * Allows the authentication process to be enabled and disabled
 *
 * #created 15/10/2017
 * #author Frank Bonnet
 */
interface IAuthenticationManager {
    

    /**
     * Returns true if authentication is enabled and false 
     * otherwise
     *
     * @return Whether the converter is currently authenticating or not
     */
    function isAuthenticating() public view returns (bool);


    /**
     * Enable authentication
     */
    function enableAuthentication() public;


    /**
     * Disable authentication
     */
    function disableAuthentication() public;
}