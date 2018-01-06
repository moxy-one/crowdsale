pragma solidity ^0.4.18;

import "../ICrowdsaleProxy.sol";
import "../../ICrowdsale.sol";
import "../../../token/IToken.sol";
import "../../../token/observer/TokenObserver.sol";
import "../../../token/retriever/TokenRetriever.sol";
import "../../../../infrastructure/ownership/Ownership.sol";

/**
 * Abstract Crowdsale pool
 *
 * #created 25/12/2017
 * #author Frank Bonnet
 */
contract CrowdsalePool is Ownership, TokenObserver, TokenRetriever, ICrowdsaleProxy {

    struct Record {
        uint weight;
        uint contributed;
        uint withdrawn;
        uint index;
    }

    // Member records
    mapping (address => Record) internal records;
    address[] internal recordIndex;

    // Pool records
    uint public totalContributed;
    uint public totalTokensReceived;
    uint public totalTokensWithdrawn;

    // Target
    ICrowdsale public targetCrowdsale;
    IToken public targetToken;


    /**
     * Deploy pool
     *
     * @param _targetCrowdsale Target crowdsale
     * @param _targetToken Token that is bought
     */
    function CrowdsalePool(address _targetCrowdsale, address _targetToken) public {
        targetCrowdsale = ICrowdsale(_targetCrowdsale);
        targetToken = IToken(_targetToken);
    }


    /**
     * Returns true if `_member` has a record
     *
     * @param _member The account that has contributed
     * @return True if there is a record that belongs to `_member`
     */
    function hasRecord(address _member) public view returns (bool) {
        return records[_member].index < recordIndex.length && _member == recordIndex[records[_member].index];
    }


    /** 
     * Get the recorded amount of ether that is contributed by `_member`
     * 
     * @param _member The address from which the contributed amount will be retrieved
     * @return The contributed amount
     */
    function contributedAmountOf(address _member) public view returns (uint) {
        return records[_member].contributed;
    }


    /** 
     * Get the allocated token balance of `_member`
     * 
     * @param _member The address from which the allocated token balance will be retrieved
     * @return The allocated token balance
     */
    function balanceOf(address _member) public view returns (uint) {
        Record storage r = records[_member];
        uint balance = 0;
        uint share = shareOf(_member);
        if (share > 0 && r.withdrawn < share) {
            balance = share - r.withdrawn;
        }

        return balance;
    }


    /**
     * Receive Eth and issue tokens to the sender
     * 
     * This function requires that msg.sender is not a contract. This is required because it's 
     * not possible for a contract to specify a gas amount when calling the (internal) send() 
     * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
     * 
     * Contracts can call the contribute() function instead
     */
    function () public payable {
        require(msg.sender == tx.origin);
        handleTransaction(msg.sender);
    }


    /**
     * Receive ether and issue tokens to the sender
     *
     * @return The accepted ether amount
     */
    function contribute() public payable returns (uint) {
        return handleTransaction(msg.sender);
    }


    /**
     * Receive ether and issue tokens to `_beneficiary`
     *
     * @param _beneficiary The account that receives the tokens
     * @return The accepted ether amount
     */
    function contributeFor(address _beneficiary) public payable returns (uint) {
        return handleTransaction(_beneficiary);
    }


    /**
     * Update pool balance
     *
     * Request tokens from the targetCrowdsale crowdsale by calling 
     * it's withdraw token function
     */
    function update() public {
        targetCrowdsale.withdrawTokens();
    }


    /**
     * Event handler that processes the token received event
     * 
     * Called by `_token` when a token amount is received on 
     * the address of this proxy
     *
     * @param _token The token contract that received the transaction
     * @param _from The account or contract that send the transaction
     * @param _value The value of tokens that where received
     */
    function onTokensReceived(address _token, address _from, uint _value) internal {
        require(_token == msg.sender);
        require(_token == address(targetToken));
        require(_from != address(this));
        
        // Record deposit
        totalTokensReceived += _value;
    }


    /**
     * Withdraw tokens
     */
    function withdrawTokens() public {
        withdrawTokensTo(msg.sender);
    }


    /**
     * Withdraw tokens
     *
     * @param _beneficiary Address to send to
     */
    function withdrawTokensTo(address _beneficiary) public {
        uint balance = balanceOf(msg.sender);

        // Record internally
        records[msg.sender].withdrawn += balance;
        totalTokensWithdrawn += balance;

        // Transfer share
        if (!targetToken.transfer(_beneficiary, balance)) {
            revert();
        }
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
        require(_tokenContract != address(targetToken));
        super.retrieveTokens(_tokenContract);
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
    function shareOf(address _member) public view returns (uint);


    /**
     * Handle incoming transactions
     * 
     * @param _beneficiary Tokens are issued to this account
     * @return Accepted ether amount
     */
    function handleTransaction(address _beneficiary) internal returns (uint);
}