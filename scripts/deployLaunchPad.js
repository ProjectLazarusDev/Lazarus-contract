


async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying Launch Pad...");

    const LaunchPad = await ethers.getContractFactory("LaunchPad");
    const launchPad = await upgrades.deployProxy(LaunchPad);
  
    console.log(launchPad.address," launch pad(proxy) address");
    console.log(await upgrades.erc1967.getImplementationAddress(launchPad.address)," getImplementationAddress");
    console.log(await upgrades.erc1967.getAdminAddress(launchPad.address)," getAdminAddress");
    
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  