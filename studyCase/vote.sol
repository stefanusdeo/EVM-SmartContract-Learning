// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract Votting {
    address owner;

    constructor() {
        owner=msg.sender;
    }

    uint numberVote;
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping (uint => Candidate) public candidates;
    mapping (address=>bool) historyVote;

    error AccessDenied();

    event votedEvent(address addresVoter,uint candidateId);

    modifier onlyOwner{
        if(msg.sender != owner) revert AccessDenied();
        _;
    }

    function addCandidate(string memory _name) external onlyOwner {
        uint numVote=++numberVote;

        candidates[numVote]= Candidate({
            id:numVote,
            name:_name,
            voteCount:0
        });
    }

    function vote(uint _number) external {
        require(!historyVote[msg.sender], "already vote");
        require(_number > 0 && _number <= numberVote, "Wrong number");


        historyVote[msg.sender]=true;
        candidates[_number].voteCount++;

        emit votedEvent(msg.sender, _number);
    }

    function result() external view returns(Candidate[] memory) {
        Candidate[] memory allCandidates = new Candidate[](numberVote);
        for (uint i = 1; i <= numberVote; i++) {
            allCandidates[i - 1] = candidates[i];
        }
        return allCandidates;
    }
}