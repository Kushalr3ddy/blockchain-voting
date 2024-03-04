// SPDX-License-Identifier:MIT
pragma solidity ^0.8.2;

contract Voting{ //contract name should be same as filename

    //struct for candidates
    struct Candidate{
        uint256 id;
        string name;
        uint256 numberofVotes;
    }


    //array of all the candidates
    Candidate[] public candidates;
    //contract owner address
    address public owner;

    // map all voters addresses
    mapping(address => bool) public voters;
    
    // list of voters
    address[] public listofVoters;

    //creating a voting start and end session (timespace)
    uint256 public votingStart;
    uint256 public votingEnd;

    //create election status
    bool public electionStarted;



    // restrict start/create election to the owner of contract only
    modifier onlyOwner(){
        require(msg.sender == owner,"you are not authorised to start/create election");
        _; // modifiers need a separate line with _; to work
    }

    // check if election is ongoing/started
    modifier electionOngoing(){
        require(electionStarted,"no election started yet");
        _;
    }

    // constructor stuff below
    constructor(){
        owner = msg.sender;
    }

    // start election code
    function startElection(string[] memory _candidates,uint256 _votingDuration) public onlyOwner{
        require(electionStarted ==false,"election is already ongoing");
        delete candidates; // this will clear out previous candidates array
        resetAllVoterStatus();
        for(uint256 i=0; i<_candidates.length; i++){
            candidates.push(
                Candidate({id:i, name:_candidates[i], numberofVotes:0})
            );
        }
        electionStarted = true;
        votingStart = block.timestamp;
        votingEnd = block.timestamp+(_votingDuration* 1 minutes);
    }
    // to add a new candidate
    function addCandidate(string memory _name) public onlyOwner electionOngoing{
        require(checkElectionPeriod(),"Election Period has ended");
        candidates.push(
            Candidate({id:candidates.length, name: _name, numberofVotes:0})
        );
    }

    // check voter status
    function voterStatus(address _voter) public view electionOngoing returns(bool){
        if(voters[_voter] == true){
            return true;
        }
        return false;
    }

    //vote function
    function voteTo(uint256 _id) public electionOngoing{
        require(checkElectionPeriod(),"election period has ended");
        require(!voterStatus(msg.sender),"you already voted");
        candidates[_id].numberofVotes++;
        voters[msg.sender] =true;
        listofVoters.push(msg.sender);
    }

    // get the number of votes
    function retrieveVotes() public view returns (Candidate[] memory){
        return candidates;
    }

    //monitor the election time
    function electionTimer() public view electionOngoing returns(uint256) {
        if(block.timestamp >= votingEnd){
            return 0;
        }
        return (votingEnd-block.timestamp);
    }


    //check if election period is still ongoing
    function checkElectionPeriod() public returns(bool){
        if(electionTimer()>0){
            return true;
        }
        electionStarted =false;
        return false;
    }


    //reset all voters status
    function resetAllVoterStatus() public onlyOwner {
        for(uint256 i=0; i < listofVoters.length;i++){
            voters[listofVoters[i]] =false;
        }
        delete listofVoters;
    }
}