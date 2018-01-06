pragma solidity ^0.4.18;

import "./CrowdsalePool.sol";
import "../../ICrowdsale.sol";
import "../../../token/IToken.sol";
import "../../../depository/Depository.sol";
import "../../../depository/DepositoryRecipient.sol";

/**
 * Crowdsale pool
 *
 * This crowdsale pool uses a token for weight calculations and 
 * adhears to set constraints when investing
 *
 * #created 30/12/2017
 * #author Frank Bonnet
 */
contract CrowdsalePoolAccumulator is CrowdsalePool, DepositoryRecipient {

    // State
    enum Stages {
        Deploying,
        Deployed,
        Invested,
        Failed
    }

    Stages public stage;

    // Pool records
    uint public totalReceived;

    // Constraints
    uint public deadline;
    uint public minAmountInPool;
    uint public minAmountInCrowdsale;

    // Commission
    address public commissionBeneficiary;
    uint public commissionPercentage;
    uint public commissionPercentageDenominator;

    // Refunded amounts
    mapping (address => uint) private refunded;

    // Recovery
    IDepository public depository;
    bool public recovering;


    /**
     * Throw if at stage other than current stage
     * 
     * @param _stage expected stage to test for
     */
    modifier at_stage(Stages _stage) {
        require(stage == _stage);
        _;
    }


    /**
     * Restrict calls to before the deadline
     */
    modifier before_deadline() {
        require(now <= deadline);
        _;
    }


    /**
     * Restrict calls to after the deadline
     */
    modifier after_deadline() {
        require(now > deadline);
        _;
    }


    /**
     * Restrict calls to the recovering state
     */
    modifier when_recovering() {
        require(recovering);
        _;
    }


    /**
     * Only after deadline plus `_time`
     * 
     * @param _time Time to pass
     */
    modifier only_after(uint _time) {
        require(now > deadline + _time);
        _;
    }


    /**
     * Throw if sender is not beneficiary
     */
    modifier only_beneficiary() {
        require(commissionBeneficiary == msg.sender);
        _;
    }


    /**
     * Deploy pool
     *
     * @param _targetCrowdsale Target crowdsale
     * @param _targetToken Token that is bought
     */
    function CrowdsalePoolAccumulator(address _targetCrowdsale, address _targetToken) public 
        CrowdsalePool(_targetCrowdsale, _targetToken) {
    }


    /**
     * Setup constraints
     *
     * @param _deadline Must be invested before this date
     * @param _minAmountInPool Can only invest when at least this amount is collected in the pool
     * @param _minAmountInCrowdsale Can only invest when at least this amount is raised in the crowdsale
     */
    function setupConstraints(uint _deadline, uint _minAmountInPool, uint _minAmountInCrowdsale) public only_owner at_stage(Stages.Deploying) {
        deadline = _deadline;
        minAmountInPool = _minAmountInPool;
        minAmountInCrowdsale = _minAmountInCrowdsale;
    }


    /**
     * Setup commission
     *
     * @param _beneficiary Receives the commission
     * @param _percentage The hight of the commission as a percentage from the amount in the pool
     * @param _denominator Percentage denominator
     */
    function setupCommission(address _beneficiary, uint _percentage, uint _denominator) public only_owner at_stage(Stages.Deploying) {
        commissionBeneficiary = _beneficiary;
        commissionPercentage = _percentage;
        commissionPercentageDenominator = _denominator;
    }


    /**
     * Deploy the pool
     */
    function deploy() public only_owner at_stage(Stages.Deploying) {
        stage = Stages.Deployed;
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
     * Invest in the targetCrowdsale crowdsale
     */
    function invest() public payable before_deadline at_stage(Stages.Deployed) {
        require(totalReceived >= minAmountInPool);
        require(targetCrowdsale.balance >= minAmountInCrowdsale);
        require(msg.value >= totalReceived * commissionPercentage / commissionPercentageDenominator);

        // Mark complete
        stage = Stages.Invested;

        // Send commission (safe)
        if (!commissionBeneficiary.send(msg.value)) {
            revert();
        }

        // Invest pool balance
        totalContributed = targetCrowdsale.contribute.value(totalReceived)();
    }


    /**
     * If after the deadline the pool is still in the deployed 
     * stage, the pool is failed
     */
    function fail() public after_deadline at_stage(Stages.Deployed) {
        stage = Stages.Failed;
    }


    /**
     * Request a refund
     */
    function refund() public {
        require(stage == Stages.Failed || (stage == Stages.Invested && totalReceived > totalContributed));

        address member = msg.sender;
        uint contributedAmount = contributedAmountOf(member);

        uint amountToRefund = 0;
        if (stage == Stages.Failed) {
            // Refund everything
            amountToRefund = contributedAmount - refunded[member];
        } else {
            // Refund overflow - member / total * overflow
            amountToRefund = (contributedAmount * (totalReceived - totalContributed) / totalReceived) - refunded[member]; 
        }
        
        refunded[member] += amountToRefund;
        if (amountToRefund > 0 && !msg.sender.send(amountToRefund)) {
            refunded[member] -= amountToRefund;
        }
    }


    /**
     * Start the process of recovering investements. Creates a 
     * depository that acts as a proxy for received refunds
     */
    function activateInvestmentRecovery() public at_stage(Stages.Invested) {
        require(!recovering);
        recovering = true;

        // Create depository to receive refunded investements
        depository = IDepository(new Depository());
    }


    /**
     * Try to recover invested ether from
     * the target crowdsale
     */
    function recoverInvestment() public when_recovering {
        targetCrowdsale.refundTo(depository);
        depository.withdraw();
    }


    /**
     * Failsafe and clean-up mechanism
     */
    function destroy() public only_beneficiary only_after(2 years) {
        selfdestruct(commissionBeneficiary);
    }


    /**
     * Event handler that processes the deposit received event
     * 
     * Called by `_depository` when a deposit amount is received on 
     * the address of this receiver
     *
     * @param _depository The account or contract that send the transaction
     * @param _value The value that was received
     */
    function onDepositReceived(address _depository, uint _value) internal when_recovering {
        require(_depository == address(depository));

        // Check for an overflow
        require(totalContributed - _value <= totalContributed);

        // Allow refunds
        totalContributed -= _value;
    }


    /**
     * Handle incoming transactions
     * 
     * @param _beneficiary Tokens are issued to this account
     * @return Accepted ether amount
     */
    function handleTransaction(address _beneficiary) internal before_deadline at_stage(Stages.Deployed) returns (uint) {
        uint received = msg.value;

        // Record transaction
        if (!hasRecord(_beneficiary)) {
            records[_beneficiary].contributed = received;
            records[_beneficiary].index = recordIndex.push(_beneficiary) - 1;
        } else {
            records[_beneficiary].contributed += received;
        }

        // Record contribution
        totalReceived += received;
        return received;
    }
}