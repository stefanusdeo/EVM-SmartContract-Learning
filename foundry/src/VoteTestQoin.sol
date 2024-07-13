// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract VotingTestQoin{
    address public owner;
    uint startDate;
    uint endDate;
    struct Candidate{
        string name;
        uint256 totalVote;
    }
    mapping (address => Candidate) public candidates;
    mapping (address => bool) history;
    address[] public candidateAddresses;
    uint public candidateCount;

    event historyVote(address vote, address selectedVote);

    constructor() {
        owner=msg.sender;
    }

    error OnlyOwner();

    modifier onlyOwner(){
        if(msg.sender != owner) revert OnlyOwner();
        _;
    }

    function addCandidate(address candidateAddress, string calldata _name, uint256 _startDate, uint256 _endDate) external onlyOwner {
        require(bytes(candidates[candidateAddress].name).length == 0, "number vote already exists");
        require(_endDate > _startDate, "End date must be after start date");
        candidateCount++;
        candidates[candidateAddress] = Candidate({
            name:_name,
            totalVote:0
        });

        candidateAddresses.push(candidateAddress);
        startDate=_startDate;
        endDate=_endDate;
    }

    function voteCandidate(address addressCandidate, uint time)external {
        require(bytes(candidates[addressCandidate].name).length > 0, "number vote not exists");
        require(time < endDate && time > startDate, "not this time");
        require(!history[msg.sender], "already vote");

        history[msg.sender] = true ;
        candidates[addressCandidate].totalVote++;

        emit historyVote(msg.sender, addressCandidate);
    }

    function getResult(address addressCandidate)external view returns(string memory name, uint totalVote) {
        Candidate memory candidate = candidates[addressCandidate];
        require(bytes(candidate.name).length != 0, "Candidate does not exist");
        return (candidate.name, candidate.totalVote);
    }

    function sendReward() external onlyOwner payable returns (string memory, address, uint) {
        require(candidateCount > 0, "No candidates available");

        address topCandidateAddress;
        uint256 maxVotes = 0;

        for (uint256 i = 0; i < candidateCount; i++) {
            address candidateAddress = candidateAddresses[i];
            if (candidates[candidateAddress].totalVote > maxVotes) {
                maxVotes = candidates[candidateAddress].totalVote;
                topCandidateAddress = candidateAddress;
            }
        }

        Candidate memory topCandidate = candidates[topCandidateAddress];
        (bool success, ) = topCandidateAddress.call{value: msg.value}("");
        require(success, "Transfer failed");

        return (topCandidate.name, topCandidateAddress, topCandidate.totalVote);
    }


}