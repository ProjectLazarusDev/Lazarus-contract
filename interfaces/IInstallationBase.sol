// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./IBobot.sol";
import "./ILandTier.sol";

interface IInstallationBase
{

    // -------------- EVENTS ------------------
    event StakeNFT(address indexed nft, uint256 tokenId, uint256 amount, IBobot.BobotType bobotType);
    event UnstakeNFT(address indexed nft, uint256 tokenId, uint256 amount, IBobot.BobotType bobotType);
    event StakingPauseToggle(bool paused);
    event ClaimCorePoints(address vaultOwner, uint256 amount, IBobot.BobotType bobotType);

    // ------------- DATA TYPES ----------------
    struct BobotStake
    {
        address owner;
        uint256 bobotLevel;
        IBobot.BobotType bobotType;
        ILandTier.LandTierType landType;
    }
    
    // ------------- VIEW FUNCTIONS --------------
    function checkStakeCost(uint256 _tokenID) external view returns (bool);     // check if user has 5 $MAGIC to stake

    function checkStakedStatus(uint256 _tokenID) external view returns(bool);

    function getCurrentCorePoints(uint256 _tokenID) external view returns(uint256);
    
    function getBreakabilityStatus(uint256 _tokenID) external view returns(bool);

    function getCurrentLandTierType(uint256 _tokenID) external view returns(ILandTier.LandTierType);

    // ------------- OWNER FUNCTIONS -------------
    function setBobotLevel(uint256 _tokenID) external;

    

}