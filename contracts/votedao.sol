// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title VoteDAO
 * @dev A decentralized voting system for proposal creation and voting.
 */
contract VoteDAO {
    // Proposal structure
    struct Proposal {
        string description; // Proposal description
        uint256 voteCount;  // Total votes for the proposal
        uint256 deadline;   // Voting deadline
        bool exists;        // Flag to check if the proposal exists
    }

    // State variables
    address public manager; // Address of the contract manager
    uint256 public proposalCount; // Total number of proposals

    // Mapping of proposal IDs to their details
    mapping(uint256 => Proposal) public proposals;

    // Mapping to prevent double voting: user => proposalId => hasVoted
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    // Events
    event ProposalCreated(uint256 proposalId, string description, uint256 deadline);
    event VoteCast(address voter, uint256 proposalId);

    // Modifier to restrict actions to the contract manager
    modifier onlyManager() {
        require(msg.sender == manager, "Only the manager can perform this action");
        _;
    }

    // Modifier to check if voting is active
    modifier isVotingActive(uint256 proposalId) {
        require(proposals[proposalId].exists, "Proposal does not exist");
        require(block.timestamp < proposals[proposalId].deadline, "Voting has ended for this proposal");
        _;
    }

    /**
     * @dev Constructor to set the manager.
     */
    constructor() {
        manager = msg.sender;
    }

    /**
     * @dev Creates a new proposal.
     * @param _description Description of the proposal.
     * @param _duration Voting duration in seconds.
     */
    function createProposal(string memory _description, uint256 _duration) public onlyManager {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            description: _description,
            voteCount: 0,
            deadline: block.timestamp + _duration,
            exists: true
        });

        emit ProposalCreated(proposalCount, _description, block.timestamp + _duration);
    }

    /**
     * @dev Casts a vote for a proposal.
     * @param _proposalId ID of the proposal to vote for.
     */
    function vote(uint256 _proposalId) public isVotingActive(_proposalId) {
        require(!hasVoted[msg.sender][_proposalId], "You have already voted on this proposal");

        // Mark the voter as having voted for this proposal
        hasVoted[msg.sender][_proposalId] = true;

        // Increment the vote count for the proposal
        proposals[_proposalId].voteCount++;

        emit VoteCast(msg.sender, _proposalId);
    }

    /**
     * @dev Retrieves the live results of a proposal.
     * @param _proposalId ID of the proposal.
     * @return description Description of the proposal.
     * @return voteCount Total votes received.
     * @return deadline Voting deadline.
     * @return isActive Whether the voting is still active.
     */
    function getProposalResults(uint256 _proposalId)
        public
        view
        returns (string memory description, uint256 voteCount, uint256 deadline, bool isActive)
    {
        require(proposals[_proposalId].exists, "Proposal does not exist");

        Proposal memory proposal = proposals[_proposalId];
        return (
            proposal.description,
            proposal.voteCount,
            proposal.deadline,
            block.timestamp < proposal.deadline
        );
    }
}
