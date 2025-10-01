const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with account:", deployer.address);

  const balance = await hre.ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", hre.ethers.formatEther(balance), "ETH");

  const Library = await hre.ethers.getContractFactory("Library");
  const library = await Library.deploy();
  await library.waitForDeployment();

  const address = await library.getAddress();
  console.log("Library deployed to:", address);

  // Save to JSON file
  const deploymentsPath = path.join(__dirname, "..", "deployed.json");
  fs.writeFileSync(
    deploymentsPath,
    JSON.stringify({ Library: address }, null, 2)
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
