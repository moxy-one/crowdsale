pragma solidity ^0.4.18;

import "./token/IToken.sol";
import "./token/ManagedToken.sol";
import "./token/burner/TokenBurner.sol";
import "./token/observer/TokenObserver.sol";
import "./token/retriever/TokenRetriever.sol";

/**
 * Spend token (SPEND) burner
 *
 * Provides the ability to burn SPEND tokens by sending SPEND
 * tokens to the token burners address
 *
 * #created 06/01/2018
 * #author Frank Bonnet
 */
contract SpendTokenBurner is TokenBurner, TokenObserver, TokenRetriever {

    /**
     * Construct the token burner
     */
    function SpendTokenBurner() public 
        TokenBurner() {}


    /**
     * Event handler that initializes the token burning
     * 
     * Called by `_token` when a token amount is received on 
     * the address of this token burner
     *
     * @param _token The token contract that received the transaction
     * @param _from The account or contract that send the transaction
     * @param _value The value of tokens that where received
     */
    function onTokensReceived(address _token, address _from, uint _value) internal only_token(_token) at_stage(Stages.Deployed) {
        require(_token == msg.sender);
        require(_from != address(0));
        token.burn(this, _value);
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
        require(_tokenContract != address(token));
        super.retrieveTokens(_tokenContract);
    }


    /**
     * Prevents the accidental sending of ether
     */
    function () public payable {
        revert();
    }
}
