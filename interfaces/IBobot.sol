// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface IBobot 
{
    enum BobotType
    {
        BOBOT_GEN,
        BOBOT_NANO,
        BOBOT_MEGA
    }

    struct UserInfo
    {
        uint256 numberofBobots;
        uint256 magicinWallet;
        BobotType bobotType;
    }

    // ------------------ VIEW FUNCTIONS -----------------
    function getBobotType() external view returns (BobotType);

    function getTokenURI(uint256 _tokenID) external view returns (string memory);
    
    //function getCurrentBobotLevel(uint256 _tokenID, BobotType _bobotType) external view returns (uint256);

    //function getBobotLevel(uint256 _tokenID, BobotType _bobotType) external view returns (uint256);

  
    // ---------------- OWNER OPERATIONS -----------------
    /*
    function stakeInCoreChamber(uint256 _tokenID, BobotType bobotType) external;
    
    function unstakeInCoreChamber(uint256 _tokenID, BobotType bobotType) external;
    
    function stakeInMiningDrill(uint256 _tokenID, BobotType bobotType) external; 
    
    function unstakeInMiningDrill(uint256 _tokenID, BobotType bobotType) external;

    function stakeInLaunchPad(uint256 _tokenID, BobotType bobotType) external;

    function unstakeInLaunchPad(uint256 _tokenID, BobotType bobotType) external;
    */

    
}
