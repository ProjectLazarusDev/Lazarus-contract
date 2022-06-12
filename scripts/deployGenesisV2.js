const { ethers } = require("ethers");

const proxyAddress = '0xbE1568D34094C2dC9A5Ec95CA38f3209c6741832';
async function main() {
    console.log(proxyAddress, "original Genesis contract")

    const GenesisV2 = await ethers.getContractFactory("BobotGenesis");
    console.log("Preparing upgrade to BobotGenesisV2...");
    const genesisV2 = await upgrades.prepareUpgrade(proxyAddress, GenesisV2);
    console.log(genesisV2, "GenesisV2 implementation contract address");

}

main()
.then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1);
});