pragma solidity ^0.4.18;

/**
 * Adds to the memory signature of the contract 
 * that contains the code that is called by the 
 * dispatcher
 */
contract Dispatchable {


    /**
     * Target contract that contains the code
     */
    address private target;
}