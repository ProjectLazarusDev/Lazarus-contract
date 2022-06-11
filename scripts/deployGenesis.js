


async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying Genesis...");

    const Genesis = await ethers.getContractFactory("BobotGenesis");
    const genesis = await upgrades.deployProxy(Genesis);
  
    console.log(genesis.address," box(proxy) address")
    console.log(await upgrades.erc1967.getImplementationAddress(genesis.address)," getImplementationAddress")
    console.log(await upgrades.erc1967.getAdminAddress(genesis.address)," getAdminAddress")    
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  