pragma solidity ^0.4.18;

/**
 * IPausable
 *
 * Simple interface to pause and resume 
 *
 * #created 11/10/2017
 * #author Frank Bonnet
 */
interface IPausable {


    /**
     * Returns whether the implementing contract is 
     * currently paused or not
     *
     * @return Whether the paused state is active
     */
    function isPaused() public view returns (bool);


    /**
     * Change the state to paused
     */
    function pause() public;


    /**
     * Change the state to resume, undo the effects 
     * of calling pause
     */
    function resume() public;
}