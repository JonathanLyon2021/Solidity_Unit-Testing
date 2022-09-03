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
    
     function testWithdrawalByOwner() public {
        uint initBalance = address(this).balance;
        funding.donate{value: 50000000 gwei}();

        bytes memory bs = abi.encodePacked((keccak256('withdraw()')));
        (bool result,) = address(funding).call(bs);
        Assert.equal(result, false, 'Allows for withdrawal before reaching the goal');

        funding.donate{value: 50000000 gwei}();
        Assert.equal(address(this).balance, initBalance - 100000000 gwei,
        "Balance before withdrawal doesn't correspond to sum of donations");

        bs = abi.encodePacked((keccak256('withdraw()')));
        (result,) = address(funding).call(bs);Assert.equal(result, true, 'Does not allow for withdrawal after reaching the goal');
        Assert.equal(address(this).balance, initBalance,
        "Balance after withdrawal doesn't correspond to sum of donations");

    }
    
    function testDonatingAfterTimeIsUp() public {
        Funding newFund = new Funding(0, 100000000 gwei);
        bytes memory bs = abi.encodePacked((keccak256('donate()')));

        (bool result,) = address(newFund).call{value: 100000000 gwei}(bs);
        Assert.equal(result, false, 'Allows for donations when time is up');
    }

    function testTrackinigDonatorsBalance() public {
       // Funding funding = new Funding();
        funding.donate{value: 5000000 gwei}();
        funding.donate{value: 15000000 gwei}();
        Assert.equal(funding.balances(address(this)), 20000000 gwei, 'Donator balance is different from donations');
    }

