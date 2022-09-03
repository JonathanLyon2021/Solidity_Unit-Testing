// SPDX -License-Identifier: MIT

pragma solidity ^0.8.7;

contract Funding {
    address payable public owner;
    uint256 public finishesAt;
    uint public goal;
    uint256 public moneyRaised;
    mapping(address => uint256) public balances;

    constructor(uint256 _duration, uint _goal) {
        owner = payable(msg.sender);
        finishesAt = block.timestamp + _duration;
        goal = _goal;
    }
    
    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    modifier onlyFunded() {
        require(isFunded());
        _;
    }

    modifier onlyNotFunded() {
        require(!isFunded());
        _;
    }

    modifier onlyFinished() {
        require(isFinished());
        _;
    }
