const proxyAddress = '0x12A0f58f40197A3AdBC793670C4E6Ca29FEB20E9';
async function main() {
    console.log(proxyAddress, "original Genesis contract")

    const GenesisV2 = await ethers.getContractFactory("BobotGenesisV2");
    console.log("Preparing upgrade to BobotGenesisV2...");

    const genesisV2 = await upgrades.upgradeProxy(proxyAddress, GenesisV2);
    console.log(genesisV2, "GenesisV2 implementation contract address");
    console.log( genesisV2.revealed());
   // expect(await genesisV2.revealed()).to.equal(true);
  
}


main()
.then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1);
});