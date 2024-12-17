import { ethers } from "hardhat";

async function main() {
  const VoteDAO = await ethers.getContractFactory("VoteDAO");
  const voteDAO = await VoteDAO.deploy();

  await voteDAO.deployed();
  console.log("VoteDAO deployed to:", voteDAO.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
