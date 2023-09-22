const { ethers } = require("hardhat");
const { verify } = require("./verify");

const main = async () => {
  const contractFactory = await ethers.getContractFactory("PollingSystem");

  const contract = await contractFactory.deploy();

  const contractAddress = contract.address;

  const chainId = network.config.chainId;

  if (chainId === 11155111) {
    await contract.deployTransaction.wait(6);
    await verify(contractAddress, []);
    console.log(`The contract was deployed at ${contractAddress}.`);
  }
};

main()
  .then(() => {
    process.exit(0);
  })
  .catch((error) => {
    process.exit(1);
  });
