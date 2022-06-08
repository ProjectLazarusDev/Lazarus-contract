// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ILandTier  {
    
    enum LandTierType
    {
        TIER_GOLD,
        TIER_SILVER,
        TIER_BRONZE
    }  
    
    // ----------- VIEW FUNCTIONS -----------
    function getLandTierType(uint256 _tokenID) external view  returns (LandTierType);
    
    function getLandCost(uint256 _tokenID, LandTierType _landTier) external view returns (uint256);

    function checkBreakImmunity(uint256 _tokenID, LandTierType _landTier) external view returns (bool);

    function setLandTierType(uint256 _tokenID, LandTierType _landTier) external;

    
}


