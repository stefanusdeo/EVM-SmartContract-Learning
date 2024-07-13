// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/VoteTestQoin.sol";

contract VotingTestQoinTest is Test {
    VotingTestQoin votingTest;
    address candidate1 = address(0x1);
    address candidate2 = address(0x2);
    address voter1 = address(0x3);

    function setUp() public {
        votingTest = new VotingTestQoin();
    }

    function testOwner() public {
        assertEq(votingTest.owner(), address(this));
    }

    function testAddCandidate() public {
        votingTest.addCandidate(candidate1, "Alice", block.timestamp, block.timestamp + 1 days);
        (string memory name, uint256 totalVote) = votingTest.getResult(candidate1);
        assertEq(name, "Alice");
        assertEq(totalVote, 0);
        assertEq(votingTest.candidateCount(), 1);
    }

    function testVoteCandidate() public {
        votingTest.addCandidate(candidate1, "Alice", block.timestamp, block.timestamp + 1 days);

        vm.warp(block.timestamp + 1);

        vm.prank(voter1);
        votingTest.voteCandidate(candidate1, block.timestamp + 2);
        (string memory name, uint256 totalVote) = votingTest.getResult(candidate1);
        assertEq(totalVote, 1);
    }

    function testCannotVoteTwice() public {
        votingTest.addCandidate(candidate1, "Alice", block.timestamp, block.timestamp + 1 days);

        vm.warp(block.timestamp + 1);

        vm.prank(voter1);
        votingTest.voteCandidate(candidate1, block.timestamp + 2);
        
        vm.expectRevert("already vote");
        vm.prank(voter1);
        votingTest.voteCandidate(candidate1, block.timestamp + 3);
    }

    function testSendReward() public {
        votingTest.addCandidate(candidate1, "Alice", block.timestamp, block.timestamp + 1 days);
        votingTest.addCandidate(candidate2, "Bob", block.timestamp, block.timestamp + 1 days);

        vm.warp(block.timestamp + 1);

        vm.prank(voter1);
        votingTest.voteCandidate(candidate1, block.timestamp + 2);

        deal(address(this), 1 ether);
        payable(address(votingTest)).transfer(1 ether);

        uint256 initialBalance = candidate1.balance;

        (string memory winnerName, address winnerAddress, uint winnerVotes) = votingTest.sendReward{value: 0.1 ether}();

        assertEq(winnerName, "Alice");
        assertEq(winnerAddress, candidate1);
        assertEq(winnerVotes, 1);
        assertEq(candidate1.balance, initialBalance + 0.1 ether);
    }
}
