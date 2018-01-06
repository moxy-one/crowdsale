pragma solidity ^0.4.18;

import "../pool/CrowdsalePoolProxy.sol";
import "../pool/CrowdsalePoolAccumulator.sol";
import "../../../../infrastructure/behaviour/IObservable.sol";

/**
 * CrowdsalePoolFactory
 *
 * #created 25/12/2017
 * #author Frank Bonnet
 */
contract CrowdsalePoolFactory {

    // Target crowdsale 
    address public targetCrowdsale;
    IObservable public targetToken;

    // Default settings
    uint public constant PERCENTAGE_DENOMINATOR = 10000;


    // Events
    event PoolCreated(address pool);


    /**
     * Deploy factory
     *
     * @param _targetCrowdsale Crowdsale
     */
    function CrowdsalePoolFactory(address _targetCrowdsale, address _targetToken) public {
        targetCrowdsale = _targetCrowdsale;
        targetToken = IObservable(_targetToken);
    }

    
    /**
     * Deploy a contract that serves as a pool with a proxy function to 
     * the targetCrowdsale crowdsale
     *
     * @return The address of the pool
     */
    function createProxyPool() public returns (address) {
        address pool = new CrowdsalePoolProxy(targetCrowdsale, targetToken);

        // Notify pool when token is received
        targetToken.registerObserver(pool); 

        PoolCreated(pool);
        return pool;
    }


    /**
     * Deploy a contract that serves as a pool that accumulates contributions 
     * and invests in the target crowdsale if certain conditions are met
     *
     * @return The address of the pool
     */
    function createAccumulatingPool(uint _deadline, uint _minAmountInPool, uint _minAmountInCrowdsale, address _commissionBeneficiary, uint _commissionPercentage) public returns (address) {
        CrowdsalePoolAccumulator pool = new CrowdsalePoolAccumulator(targetCrowdsale, targetToken);

        // Configure and deploy pool
        pool.setupConstraints(_deadline, _minAmountInPool, _minAmountInCrowdsale);
        pool.setupCommission(_commissionBeneficiary, _commissionPercentage, PERCENTAGE_DENOMINATOR);
        pool.deploy();

        // Notify pool when token is received
        targetToken.registerObserver(pool); 

        PoolCreated(pool);
        return pool;
    }
}