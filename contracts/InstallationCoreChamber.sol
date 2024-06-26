// SPDX-License-Identifier: MIT

//,,,,,,,,,,,,,,,,,,,***************************************,*,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,,,,,**,,,,***********************,*,,,,,,,,,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,****,,,*,,,**,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,((*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*%%#(*/&%( #( %#.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*###(*....         #(,,,,,,,,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(###(,,...          .,,,,,,,,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,(#%%(*,,,...         ,,,,,,,,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/#%%%#**,,,,,... ,,   ,,,,,,,,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/###((/**,,,,*,,,,,*.  ,,,,,,,,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,(##((#%%%%%##//##((/( ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*((/*........      .,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,(%&&&&&&&&&&&&&%%%%%%%%%#/,,,,,,,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,,,,,,,,,,********,,,....                ,,,,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,#(/,,,,,,*@%(#%%%%%&&&&&&&&%%%%%%%(((//,..  /,,,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,##(/,,&&&&&&&&&&&&&&&&&&&&&%%%%%%%%%%%%%%%%%/*,,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,##,.,*/((##(((//****,,,....                  .,,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,,((* .(####(***,,,,,#%%%%%%%%%%%%%#####%%%%%%((/,,,,,,,,,,,,,,,,
//,,,,,,,,,,,,,,,,*&(%%#%%%%###(((((//#%%%######%%%%%%%###########, ,,,,,,,,,,,,,,
//*,,,,,,,,,,,,,,,,((%%%%%%%%###((((//#%%#(    .(##%########(/   (. ,,,,,,,,,,,,,,
//*,*,,,,,,,,,,,,,,/#%%%%%%%####((((//#%%#(    ,(#####   .(#(/   (. ,,,,,,,,,,,,,,
//*******,,,,,*/ .,(&(#%%%%%%###((((//#%%%%#####%%%%%%%%%%%#######, ,,,,,,,,,,,,,,
//********,*,///  ,/##&####(///*****(##%%%%%%%%%%%%%%%%%%%%%%##### ,,,,,,,,,,,,,,,
//********,*/(//  ,,##/.,,,,,,,,,,,,,,,,,*((*,,,,,,,,,,,,(     .*.,,,,,,,,,,,,,,,,
//**********(((*   *,,,..*(/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#(#(/,   ,,,,,,,,,,,,,,,
//*********&&&%*,  ,**((((#(//,/(%&&&%/*,   .%%%%%   ,*,#%## ((,,  (#/,,,,,,,,,,,,
//*********&&&&(##((,.,%%%%(*. ,#%##&&&&((    #%%%%.   ##%/.#/,   *,.. .,,,,,,,,,,
//*********@@@&#%(/*,..%@&%#/, .%%###((*, (&& . .**/(&&     /#(.  (*,. .,,,,,,,*,,
//********(@@@&#%(/*,..***/%%#* .%%%###((////*  %#((((///* .*%#/  #/*,..*,,,,*****
//********(&&@&#%(/*,.*******#.((%%%%%##////((((%#(/**//((((*,%%%#%(*,.***********
//*********#####%(/*,,*******#*(%%%%%%%########***%%%%%%%#/****%%#%%/,,,**********
//                      ____   ____  ____   ____ _______ _____                  //
//                     |  _ \ / __ \|  _ \ / __ \__   __/ ____|                 //
//                     | |_) | |  | | |_) | |  | | | | | (___                   //
//                     |  _ <| |  | |  _ <| |  | | | |  \___ \                  //
//                     | |_) | |__| | |_) | |__| | | |  ____)                   //
//                     |____/ \____/|____/ \____/  |_| |_____/                  //
//////////////////////////////////////////////////////////////////////////////////

pragma solidity ^0.8.13;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

//import Bobot genesis
import "./BobotGenesis.sol";
import "./ICoreChamber.sol";


contract CoreChamberFactory is 
    OwnableUpgradeable
{
    event NewCoreChamber(uint ccID, ICoreChamber.CCTier _tier); 

    struct CoreChamber{
        ICoreChamber.CCTier tierType;
    }

    uint256 public coreChamberLevelCost;
    bool public paused;

    BobotGenesisV2 bobotsGenContract;

    CoreChamber[] public coreChambers;

    mapping (uint => address) public ccToOwners;
    mapping(uint256 => uint256) public genesisTimestampJoined;
    mapping (address => uint) public ownersCCcount;

    mapping (address => uint) public bobotsCorePoints;

    function _createCoreChamber(string memory _name, ICoreChamber.CCTier _tier) private {
        uint id = coreChambers.push(CoreChamber(_tier)) - 1; 
        ccToOwners[id] = msg.sender; 
        ++ownersCCcount[msg.sender];
        emit NewCoreChamber(id, _tier); 

    }

    // amount of core points earned, call when unstaked
    function _calculateEmissions(ICoreChamber.CCTier _tier) private returns (uint points) { 

        // Need a way to get staked bobot
        if (genesisTimestampJoined[_tokenId] == 0) return 0;
        // Seconds staked
        uint256 timedelta = block.timestamp -  genesisTimestampJoined[_tokenId];
        uint corePointsPerHour = 0;

        if (_tier == ICoreChamber.CCTier.Bronze)corePointsPerHour = 3;
        else if (_tier == ICoreChamber.CCTier.Silver) corePointsPerHour = 4;
        else if (_tier == ICoreChamber.CCTier.Gold) corePointsPerHour = 6;
        else corePointsPerHour = 0;
        points = corePointsPerHour * timedelta / 3600;
        return points;
    }

    function _generateRandomCC(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str))); 
        return rand % 100;
    }

    function createRandomCoreChamber(string memory _name) public {
        uint randomTier = _generateRandomCC(_name);
        _createCoreChamber(_name, randomTier);
    }
    
    function emissions(ICoreChamber.CCTier _tier) public {

    }

    function stake(uint _bobotID, uint _ccID, ICoreChamber.CCTier _tier) public {
        require(msg.sender == ccToOwners[_ccID]); 
        

    }

    function unstake(uint _bobotID, uint _ccID, ICoreChamber.CCTier _tier) public {
        
    }

    // ----------------- OWNER FUNCTIONS -----------------------------
    function setCoreChamberLevelCost(uint256 _cost) external onlyOwner {
        coreChamberLevelCost = _cost;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

}

// contract CoreChamber is OwnableUpgradeable
// {
//     uint256 public constant WEEK = 7 days;

//     uint256 public corePointsPerWeekGenesis;
//     uint256 public corePointsPerWeekMegabot;

//     uint256 constant maxGenesisSupply = 4040;
//     uint256 constant maxMegabotSupply = 1000;
//     //bobots genesis contract
//     BobotGenesis public bobotGenesis;

//     //bobots megabots contract 
//     BobotMegaBot public bobotMegabot;
   
//     uint256 public totalCorePointsStored;

//     uint256 public lastRewardTimestamp;

//     uint256 public genesisSupply;
//     uint256 public megabotSupply;

//     mapping(uint256 => uint256) public genesisTimestampJoined;
//     mapping(uint256 => uint256) public megabotTimestampJoined;

//     function initialize() external initializer 
//     {
//         __Ownable_init();
//     }

//     modifier atCoreChamberGenesis(uint256 _tokenId, bool atCore) {
//         require(isAtCoreChamberGenesis(_tokenId) == atCore, "Core chamber: wrong attendance");
//         _;
//     }
//     function isAtCoreChamberGenesis(uint256 _tokenId) public view returns (bool) {
//         return genesisTimestampJoined[_tokenId] > 0;
//     }
//     modifier atCoreChamberMegabot(uint256 _tokenId, bool atCore) {
//         require(isAtCoreChamberMegabot(_tokenId) == atCore, "Core chamber: wrong attendance");
//         _;
//     }
//     function isAtCoreChamberMegabot(uint256 _tokenId) public view returns (bool) {
//         return megabotTimestampJoined[_tokenId] > 0;
//     }
//     modifier onlyGenesisOwner(uint256 _tokenId) {
//         require(bobotGenesis.ownerOf(_tokenId) == msg.sender, "Genesis: only owner can send to core chamber");
//         _;
//     }
//     modifier onlyMegabotOwner(uint256 _tokenId) {
//         require(bobotMegabot.ownerOf(_tokenId) == msg.sender, "Megabot: only megabot owner can send to core chamber");
//         _;
//     }
//     /**************************************************************************/
//     /*!
//        \brief Update total core points
//     */
//     /**************************************************************************/
//     modifier updateTotalCorePoints(bool isJoining, IBobot.BobotType _bobotType) {
//         if (genesisSupply > 0) {
//             totalCorePointsStored = totalCorePoints();
//         }
//         lastRewardTimestamp = block.timestamp;

//         if(_bobotType == IBobot.BobotType.BOBOT_GEN)
//             isJoining ? genesisSupply++ : genesisSupply--;
//         if(_bobotType == IBobot.BobotType.BOBOT_MEGA)
//             isJoining ? megabotSupply++ :  megabotSupply--;
//         _;
//     }
//     /**************************************************************************/
//     /*!
//        \brief Total core points
//     */
//     /**************************************************************************/
//     function totalCorePoints() public view returns (uint256) {
//         uint256 timeDelta = block.timestamp - lastRewardTimestamp;
//         return totalCorePointsStored +
//          (genesisSupply * corePointsPerWeekGenesis * timeDelta / WEEK) + 
//          (megabotSupply * corePointsPerWeekMegabot * timeDelta / WEEK);
//     }

//     /**************************************************************************/
//     /*!
//        \brief Core points earned
//     */
//     /**************************************************************************/
//     function corePointsEarnedGenesis(uint256 _tokenId) public view 
//     returns (uint256 points) 
//     {
//         if (genesisTimestampJoined[_tokenId] == 0) return 0;
//         uint256 timedelta = block.timestamp -  genesisTimestampJoined[_tokenId];
//         points = corePointsPerWeekGenesis * timedelta / WEEK;
//     }
//     /**************************************************************************/
//     /*!
//        \brief Core points earned
//     */
//     /**************************************************************************/
//     function corePointsEarnedMegabot(uint256 _tokenId) public view 
//     returns (uint256 points) 
//     {
//         if (megabotTimestampJoined[_tokenId] == 0) return 0;
//         uint256 timedelta = block.timestamp -  megabotTimestampJoined[_tokenId];
//         points = corePointsPerWeekMegabot * timedelta / WEEK;
//     }
//     /**************************************************************************/
//     /*!
//        \brief Stake Genesis
//     */
//     /**************************************************************************/
//     function stakeGenesis(uint256 _tokenId)  
//         external
//         onlyGenesisOwner(_tokenId)
//         atCoreChamberGenesis(_tokenId, false)
//         updateTotalCorePoints(true,IBobot.BobotType.BOBOT_GEN) {
//         genesisTimestampJoined[_tokenId] = block.timestamp;
//     }
//     /**************************************************************************/
//     /*!
//        \brief Unstake Genesis
//     */
//     /**************************************************************************/
//     function unstakeGenesis(uint256 _tokenId) 
//         external
//         onlyGenesisOwner(_tokenId)
//         atCoreChamberGenesis(_tokenId, true)
//         updateTotalCorePoints(false,IBobot.BobotType.BOBOT_GEN)
//         {
//         bobotGenesis.coreChamberCorePointUpdate(_tokenId, corePointsEarnedGenesis(_tokenId));
//         genesisTimestampJoined[_tokenId] = 0;
//     }
//     /**************************************************************************/
//     /*!
//        \brief Stake megabot
//     */
//     /**************************************************************************/
//     function stakeMegabot(uint256 _tokenId)  
//         external
//         onlyMegabotOwner(_tokenId)
//         atCoreChamberMegabot(_tokenId, false)
//         updateTotalCorePoints(true,IBobot.BobotType.BOBOT_MEGA) {
//         megabotTimestampJoined[_tokenId] = block.timestamp;
//     }
//     /**************************************************************************/
//     /*!
//        \brief Unstake megabot
//     */
//     /**************************************************************************/
//     function unstakeMegabot(uint256 _tokenId) 
//         external
//         onlyMegabotOwner(_tokenId)
//         atCoreChamberMegabot(_tokenId, true)
//         updateTotalCorePoints(false,IBobot.BobotType.BOBOT_MEGA)
//         {
//         bobotMegabot.coreChamberCorePointUpdate(_tokenId, corePointsEarnedMegabot(_tokenId));
//         megabotTimestampJoined[_tokenId] = 0;
//     }
    
//     /**************************************************************************/
//     /*!
//        \brief Set Bobot Genesis contract
//     */
//     /**************************************************************************/
//     function UnstakeAllBobots()
//         external
//         onlyOwner{
//         for (uint256 i; i < maxGenesisSupply; ++i)
//         {
//             if(isAtCoreChamberGenesis(i))
//             {
//                 bobotGenesis.coreChamberCorePointUpdate(i, corePointsEarnedGenesis(i));
//                 genesisTimestampJoined[i] = 0;
                
//             }
//         }

//         for (uint256 i; i < maxMegabotSupply; ++i)
//         {
//             if (isAtCoreChamberMegabot(i))
//             {
//                 bobotMegabot.coreChamberCorePointUpdate(i, corePointsEarnedMegabot(i));
//                 megabotTimestampJoined[i] = 0;
                
//             }
//         }

//         genesisSupply = 0;
//         megabotSupply = 0;
//     }

//     //admin function

//     /**************************************************************************/
//     /*!
//        \brief Set Bobot Genesis contract
//     */
//     /**************************************************************************/
//     function setBobotGenesis(address _bobotGenesis) external onlyOwner {
//         bobotGenesis = BobotGenesis(_bobotGenesis);
//     }
//     /**************************************************************************/
//     /*!
//        \brief Set Bobot Megabots contract
//     */
//     /**************************************************************************/
//    function setBobotMegabot(address _bobotMegabot) external onlyOwner {
//         bobotMegabot = BobotMegaBot(_bobotMegabot);
//     }
//     /**************************************************************************/
//     /*!
//        \brief Set how much core points genesis can earn
//     */
//     /**************************************************************************/
//     function setCorePointsPerWeekGenesis(uint256 _corePointsPerWeekGenesis) external onlyOwner {
//         corePointsPerWeekGenesis = _corePointsPerWeekGenesis;
//     }
//     /**************************************************************************/
//     /*!
//        \brief Set how much core points megabot can earn
//     */
//     /**************************************************************************/
//     function setCorePointsPerWeekMegabot(uint256 _corePointsPerWeekMegabot) external onlyOwner {
//         corePointsPerWeekMegabot = _corePointsPerWeekMegabot;
//     }
// }
