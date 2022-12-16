// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  const lockedAmount = hre.ethers.utils.parseEther("1");

  const NFT = await hre.ethers.getContractFactory("NFT");
  const nft = await NFT.deploy();
const [owner] = await ethers.getSigners();
  await nft.deployed();
  const Token = await hre.ethers.getContractFactory("TestToken");
  const token = await Token.deploy("20000000000000000000000000000000000000");
  await token.deployed();

  await nft.setTokenAddress(token.address);
  await nft.mintNFT(owner.address,"trial","1000000000000000");
  await token.mint(nft.address,"1000000000000000");
  await token.mint(owner.address,"1000000000000000");

  await nft.BorrowNft(owner.address,0,"100");
  await token.approve(nft.address,"30");
  await nft.RepayNft(owner.address,0,"30");
  let details = await nft.nftBorrowedDetails(0);
  console.log(
    token.address,nft.address,details
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
