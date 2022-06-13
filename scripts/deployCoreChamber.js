


async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying Core Chamber...");

    const CoreChamber = await ethers.getContractFactory("CoreChamber");
    const coreChamber = await upgrades.deployProxy(CoreChamber);
  
    console.log(coreChamber.address," core chamber(proxy) address");
    console.log(await upgrades.erc1967.getImplementationAddress(coreChamber.address)," getImplementationAddress");
    console.log(await upgrades.erc1967.getAdminAddress(coreChamber.address)," getAdminAddress");
    
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  