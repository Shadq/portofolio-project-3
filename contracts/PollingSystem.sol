// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract PollingSystem {
    struct Voter {
        address wallet;
        uint id;
        string candidateVoted;
    }

    struct Candidate {
        address wallet;
        string name;
        uint id;
        uint votes;
    }

    address public admin = 0xa9B54220AD207Cf6fffb587493ff774c6d763706;
    address public nullAddress = 0x0000000000000000000000000000000000000000;

    Voter[] public votersArray;
    Candidate[] public candidatesArray;

    mapping(uint => Voter) public votersMapping;
    mapping(uint => Candidate) public candidatesMapping;

    function becomeVoter() public {
        Voter memory newVoter = Voter(msg.sender, votersArray.length, "");
        votersMapping[votersArray.length] = newVoter;
        votersArray.push(newVoter);
    }

    function getVoter() public view returns (Voter[] memory) {
        Voter[] memory temporary = new Voter[](votersArray.length);
        uint counter = 0;
        for (uint i; i < votersArray.length; i++) {
            if (votersArray[i].wallet == msg.sender) {
                temporary[counter] = votersArray[i];
                counter++;
            }
        }
        Voter[] memory result = new Voter[](counter);
        for (uint i; i < counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }

    function getCandidate() public view returns (Candidate[] memory) {
        Candidate[] memory temporary = new Candidate[](candidatesArray.length);
        uint counter = 0;
        for (uint i; i < candidatesArray.length; i++) {
            if (candidatesArray[i].wallet == msg.sender) {
                temporary[counter] = candidatesArray[i];
                counter++;
            }
        }
        Candidate[] memory result = new Candidate[](counter);
        for (uint i; i < counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }

    function getAllCandidates() public view returns (Candidate[] memory) {
        return candidatesArray;
    }

    function becomeCandidate(uint voterId, string memory newCandidateName)
        public
    {
        Candidate memory newCandidate = Candidate(
            msg.sender,
            newCandidateName,
            candidatesArray.length,
            0
        );

        candidatesMapping[candidatesArray.length] = newCandidate;
        candidatesArray.push(newCandidate);

        delete votersArray[voterId];
        delete votersMapping[voterId];
    }

    function voteCandidate(uint voterId, uint candidateId) public {
        Voter storage voterFromMapping = votersMapping[voterId];
        Voter storage voterFromArray = votersArray[voterId];

        Candidate storage candidateFromMapping = candidatesMapping[candidateId];
        Candidate storage candidateFromArray = candidatesArray[candidateId];
        require(
            voterFromMapping.wallet != candidateFromMapping.wallet,
            "You cannot vote for yourself."
        );
        require(
            voterFromMapping.wallet != nullAddress,
            "You have to be a voter to vote"
        );

        voterFromMapping.candidateVoted = candidateFromMapping.name;
        voterFromArray.candidateVoted = candidateFromArray.name;

        candidateFromMapping.votes++;
        candidateFromArray.votes++;
    }

    function findWinner() public view returns (Candidate memory) {
        require(
            msg.sender == admin,
            "To execute this function you must be the admin."
        );

        uint store_var;
        Candidate memory winner;

        for (uint i = 0; i < candidatesArray.length; i++) {
            if (store_var < candidatesArray[i].votes) {
                store_var = candidatesArray[i].votes;
                winner = candidatesArray[i];
            }
        }

        return winner;
    }
}
