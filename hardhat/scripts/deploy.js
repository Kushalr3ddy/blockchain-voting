// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
//contract address :0xf21cdcfd9CA7605132FCaaC3Eb85E482b738AC0e
//https://mumbai.polygonscan.com/address/0xf21cdcfd9CA7605132FCaaC3Eb85E482b738AC0e#code
async function main() {
  const votingContract = await hre.ethers.getContractFactory("Voting"); //contract name
  const deployedVotingContract = await votingContract.deploy();
  console.log(`contract address :${deployedVotingContract.target}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
