// SPDX -License-Identifier: MIT

pragma solidity ^0.8.7;

import 'truffle/Assert.sol';
import '../contracts/Funding.sol';
import 'truffle/DeployedAddresses.sol';

contract FundingTest {
    uint public initialBalance = 10 ether;
    Funding funding;

    receive() external payable {}

    function beforeEach() public {
        funding = new Funding(1 days, 100000000 gwei);
    }
