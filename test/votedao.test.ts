import { ethers } from "hardhat";
import { expect } from "chai";

describe("VoteDAO", function () {
  let voteDAO: any;
  let manager: any;
  let addr1: any;
  let addr2: any;

  beforeEach(async function () {
    const VoteDAO = await ethers.getContractFactory("VoteDAO");
    [manager, addr1, addr2] = await ethers.getSigners();
    voteDAO = await VoteDAO.deploy();
    await voteDAO.deployed();
  });

  it("Should allow the manager to create a proposal", async function () {
    await voteDAO.createProposal("Proposal 1", 3600);
    const proposal = await voteDAO.getProposalResults(1);
    expect(proposal[0]).to.equal("Proposal 1");
  });

  it("Should allow a user to vote and prevent double voting", async function () {
    await voteDAO.createProposal("Proposal 1", 3600);
    await voteDAO.connect(addr1).vote(1);
    const proposal = await voteDAO.getProposalResults(1);
    expect(proposal[1]).to.equal(1);

    await expect(voteDAO.connect(addr1).vote(1)).to.be.revertedWith(
      "You have already voted on this proposal"
    );
  });

  it("Should not allow voting after the deadline", async function () {
    await voteDAO.createProposal("Proposal 1", 1); // 1 second duration
    await ethers.provider.send("evm_increaseTime", [2]);
    await ethers.provider.send("evm_mine", []);
    await expect(voteDAO.connect(addr1).vote(1)).to.be.revertedWith(
      "Voting has ended for this proposal"
    );
  });

  it("Should allow retrieving live proposal results", async function () {
    await voteDAO.createProposal("Proposal 1", 3600);
    await voteDAO.connect(addr1).vote(1);

    const proposal = await voteDAO.getProposalResults(1);
    expect(proposal[0]).to.equal("Proposal 1");
    expect(proposal[1]).to.equal(1);
  });
});
