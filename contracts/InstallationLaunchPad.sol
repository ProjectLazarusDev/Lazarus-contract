// // SPDX-License-Identifier: MIT

// //,,,,,,,,,,,,,,,,,,,***************************************,*,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,,,,,**,,,,***********************,*,,,,,,,,,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,****,,,*,,,**,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,((*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*%%#(*/&%( #( %#.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*###(*....         #(,,,,,,,,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(###(,,...          .,,,,,,,,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,(#%%(*,,,...         ,,,,,,,,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/#%%%#**,,,,,... ,,   ,,,,,,,,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/###((/**,,,,*,,,,,*.  ,,,,,,,,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,,,,,,,,,,,,(##((#%%%%%##//##((/( ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*((/*........      .,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,,,,,,,,,,,,(%&&&&&&&&&&&&&%%%%%%%%%#/,,,,,,,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,,,,,,,,,,********,,,....                ,,,,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,#(/,,,,,,*@%(#%%%%%&&&&&&&&%%%%%%%(((//,..  /,,,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,##(/,,&&&&&&&&&&&&&&&&&&&&&%%%%%%%%%%%%%%%%%/*,,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,##,.,*/((##(((//****,,,....                  .,,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,,((* .(####(***,,,,,#%%%%%%%%%%%%%#####%%%%%%((/,,,,,,,,,,,,,,,,
// //,,,,,,,,,,,,,,,,*&(%%#%%%%###(((((//#%%%######%%%%%%%###########, ,,,,,,,,,,,,,,
// //*,,,,,,,,,,,,,,,,((%%%%%%%%###((((//#%%#(    .(##%########(/   (. ,,,,,,,,,,,,,,
// //*,*,,,,,,,,,,,,,,/#%%%%%%%####((((//#%%#(    ,(#####   .(#(/   (. ,,,,,,,,,,,,,,
// //*******,,,,,*/ .,(&(#%%%%%%###((((//#%%%%#####%%%%%%%%%%%#######, ,,,,,,,,,,,,,,
// //********,*,///  ,/##&####(///*****(##%%%%%%%%%%%%%%%%%%%%%%##### ,,,,,,,,,,,,,,,
// //********,*/(//  ,,##/.,,,,,,,,,,,,,,,,,*((*,,,,,,,,,,,,(     .*.,,,,,,,,,,,,,,,,
// //**********(((*   *,,,..*(/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#(#(/,   ,,,,,,,,,,,,,,,
// //*********&&&%*,  ,**((((#(//,/(%&&&%/*,   .%%%%%   ,*,#%## ((,,  (#/,,,,,,,,,,,,
// //*********&&&&(##((,.,%%%%(*. ,#%##&&&&((    #%%%%.   ##%/.#/,   *,.. .,,,,,,,,,,
// //*********@@@&#%(/*,..%@&%#/, .%%###((*, (&& . .**/(&&     /#(.  (*,. .,,,,,,,*,,
// //********(@@@&#%(/*,..***/%%#* .%%%###((////*  %#((((///* .*%#/  #/*,..*,,,,*****
// //********(&&@&#%(/*,.*******#.((%%%%%##////((((%#(/**//((((*,%%%#%(*,.***********
// //*********#####%(/*,,*******#*(%%%%%%%########***%%%%%%%#/****%%#%%/,,,**********
// //                      ____   ____  ____   ____ _______ _____                  //
// //                     |  _ \ / __ \|  _ \ / __ \__   __/ ____|                 //
// //                     | |_) | |  | | |_) | |  | | | | | (___                   //
// //                     |  _ <| |  | |  _ <| |  | | | |  \___ \                  //
// //                     | |_) | |__| | |_) | |__| | | |  ____)                   //
// //                     |____/ \____/|____/ \____/  |_| |_____/                  //
// //////////////////////////////////////////////////////////////////////////////////

pragma solidity ^0.8.13;

import "./ILaunchPad.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
contract LaunchPad is OwnableUpgradeable
{

        // KF IS HERE


        struct LaunchPadData{
            ILaunchPad.LPTier tierType;
            uint missionId;
            uint fame;
            uint completedMissions;
            uint burnImmunity;
            uint burnChance;
        }

        enum RewardType{
            none,
            fail,
            success,
            crit
        }

        struct FameStats
        {
            uint fame;
            uint priStatValue;
            uint secStatValue;
        }
        struct RewardValues
        {
            uint failValue;
            uint successValue;
            uint critValue;
        }
        struct MissionRewards
        {
            // BobotType;
            uint rewardMultiplier;
            // Land Tier;
            uint minFame;
            uint maxFame;
            RewardValues corePoints;
            RewardValues magic; // how to convert to decimals?
            RewardValues nanobotChance;
            RewardValues fameGain;
        }

        
        uint missionTypes = 30;
        LaunchPadData[] public launchPads;
        FameStats[] private FameTiers;
        MissionRewards[] private AllMissionRewards;

        BobotsGenesis public bobotsGenesis;

        event NewLaunchPad(LPTier tier, uint missionId);
        event BurnLaunchPad(uint launchPadId);

        /**************************************************************************/
        /*!
        \brief set Core Chamber Contract
        */
        /**************************************************************************/
        function setBobotsGensis(address _bobotsGenesis) external onlyOwner {
            bobotsGenesis = BobotsGensis(_bobotsGenesis);
        }

        function _createLaunchPad(ILaunchPad.LPTier _tier, uint _missionId) private {
        launchPads.push(LaunchPad(_tier, _missionId, 0, 0));
        emit NewLaunchPad(_tier, _missionId);
        }

        function _generateRandomMission(string memory _randomString) private view returns (uint){
        uint rand = uint(keccak256(abi.encodePacked(_randomString)));
        return rand % missionTypes;
        }

        function createRandomLaunchPad(string memory _randomString, ILaunchPad.LPTier _tier, uint _missionId) public {
        uint randMission = _generateRandomMission(_randomString);
        _createLaunchPad(_tier, _missionId);
        }

        function _getStatsByFame(uint memory _fame) private returns (FameStats _highestFound) {
            // _highestFound = FameStats(0,0,0);
            // foreach (FameStats fameTier in FameTiers)
            // if _fame >= fameTier.fame && fameTier.fame > _highestFound.fame
            //    _highestFound = fameTier;
            // return _highestFound;
        }

        function _missionSuccessChance(uint memory _bobotTokenID, uint _landTokenID) private returns (uint baseSuccess, uint critSuccess){
            

            return ( 0,0);
        }

        function _generateRandomUint(string memory _str) private view returns (uint) {
            uint rand = uint(keccak256(abi.encodePacked(_str)));
            // random value between 0 to 99
            return rand % 2;
        }

        function _getRewardType(uint memory _bobotTokenID, uint _landTokenID) private returns (RewardType rewardType){
            rewardType = RewardType.none;
            // if unstaked before 12hrs, return

            uint baseSuccess = 0;
            uint critSuccess = 0;
            (baseSuccess, critSuccess) = _missionSuccessChance(_bobotTokenID, _landTokenID);
            // not sure how to reliably get a "random"
            uint rand = _generateRandomUint("randomString");

            if (rand >= critSuccess) rewardType = RewardType.crit;
            else if (rand >= baseSuccess) rewardType = RewardType.success;
            else rewardType = RewardType.fail;
        }

        // Define all mission rewards in AllMissionRewards, compare botType, landTier, fameTier and _getRewardType to output rewards

        // function to check burn immunity
        // function to check burn chance success or fail
        // function to burnLaunchPad


        // KF END

}