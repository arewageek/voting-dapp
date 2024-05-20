// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Ballot {
    struct Candidate {
        bytes32 name;
        uint voteCount;
    }

    struct Voter {
        bool voted;
        uint8 weight;
    }

    Candidate[] public candidates;

    mapping(address => Voter) public voters;

    uint public votingStart;
    uint public votingEnd;
    address owner;

    constructor(uint _voteEndTimestamp){
        owner = msg.sender;
        votingStart = block.timestamp;
        votingEnd = _voteEndTimestamp;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Unauthorized");
        _;
    }

    modifier notVotedYet(address voter) {
        require(!voters[voter].voted, "You already voted");
        _;
    }

    modifier votingInSession{
        require(block.timestamp >= votingStart, "Voting has not started yet");
        require(block.timestamp <= votingEnd, "Voting has ended");
        _;
    }

    function createCandidate(bytes32[] memory _name) public onlyOwner {
        for (uint i = 0; i<_name.length; i++){
            candidates.push(Candidate({
                name: _name[i],
                voteCount: 0
            }));
        }
    }

    function vote(uint _candidateIndex) public notVotedYet(msg.sender) {
        require(_candidateIndex < candidates.length, "Invalid candidate index");

        candidates[_candidateIndex].voteCount ++;
        voters[msg.sender].voted = true;
    }

    function getAllVotesOfCandidates() public view returns (Candidate[] memory){
        return candidates;
    }

    function getVotingStatus() public votingInSession view returns(bool){
        return true;
    }

    function getRemainingTime() public votingInSession() view returns (uint){
        return votingEnd - block.timestamp;
    }
}
