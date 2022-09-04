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
// import "./ERC721NES.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// //import Bobot genesis
// import "./BobotGenesis.sol";

import "./interfaces/ILaunchPad.sol";

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

        function _missionSuccessChance(uint memory _bobotTokenID, uint _landTokenID) private returns (uint baseSuccess, uint critSuccess)){
            // get stats from bobot

            // Find pri stat of land and save bobot's pri stat
             StatType priStat = land.priStat;
             uint priStatVal = bobot.Stats.priStat;
            bobotsGenesis.getTokenURI(_bobotTokenID)
            // Get both sec stat types from land, find from bobot the 2 stat types and divide by 2
             StatType secStat1 = land.secStat1;
             uint secStat1Val = bobot.Stats.secStat1 / 2;
             StatType secStat2 = land.secStat2;
             uint secStat2Val = bobot.Stats.secStat2 / 2;

            // FameStats highestFound = _getStatsByFame(land.fame);
             uint priDiff = highestFound.priStatValue - priStatVal;
             uint secDiff = (highestFound.secStatValue * 2) - secStat1Val - secStat2Val;
             uint challengeSum = priDiff + secDiff;

             baseSuccess = 50 + challengeSum;
            // Clamp baseSuccess between 0 and 100
             critSuccess = 100 + challengeSum;
            // Clamp critSuccess between 0 and 100

            return baseSuccess, critSuccess;
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


//     // block number multiplier to determine the balance to accrue
//     // during the duration staked. Defaults to 1.
//     uint256 multiplier = 1;

//     //bobots genesis contract
//     BobotGenesis public bobotGenesis;

//     // For each token, this map stores the current block.number
//     // if token is mapped to 0, it is currently unstaked.
//     mapping(uint256 => uint256) public tokenToWhenStaked;

//     // For each token, this map stores the total duration staked
//     // measured by block.number
//     mapping(uint256 => uint256) public tokenToTotalDurationStaked;

//     /**************************************************************************/
//     /*!
//        \brief constructor
//     */
//     /**************************************************************************/
//     constructor( uint256 _multipler) 
//     {
//         multiplier = _multipler;
//     }

//     /**************************************************************************/
//     /*!
//        \brief check if token is staked
//     */
//     /**************************************************************************/

//     function checkStakeStatus(uint256 tokenId) public view returns (uint256) {
//         return tokenToWhenStaked[tokenId];
//     }

//     /**************************************************************************/
//     /*!
//        \brief returns the additional balance between when token was staked until now
//     */
//     /**************************************************************************/
//     function getCurrentAdditionalBalance(uint256 tokenId)
//         public
//         view
//         returns (uint256)
//     {
//         if (tokenToWhenStaked[tokenId] > 0) {
//             return block.number - tokenToWhenStaked[tokenId];
//         } else {
//             return 0;
//         }
//     }

//     /**************************************************************************/
//     /*!
//        \brief returns total duration the token has been staked.
//     */
//     /**************************************************************************/
//     function getCumulativeDurationStaked(uint256 tokenId)
//         public
//         view
//         returns (uint256)
//     {
//         return
//             tokenToTotalDurationStaked[tokenId] +
//             getCurrentAdditionalBalance(tokenId);
//     }

//     /**************************************************************************/
//     /*!
//        \brief Returns the amount of tokens rewarded up until this point.
//     */
//     /**************************************************************************/

//     function getStakingRewards(uint256 tokenId) public view returns (uint256) 
//     {
//         // allows for toke accumulation at ~ 10 per hour
//         return getCumulativeDurationStaked(tokenId) * multiplier; 
//     }

//     /**************************************************************************/
//     /*!
//        \brief Stakes a token and records the start block number or time stamp.
//     */
//     /**************************************************************************/
//     function stake(uint256 tokenId) public {
//         require(
//             ERC721NES( address(bobotGenesis)).ownerOf(tokenId) == msg.sender,
//             "You are not the owner of this token"
//         );

//         tokenToWhenStaked[tokenId] = block.number;
        
//         ERC721NES( address(bobotGenesis)).
//         stakeFromController(tokenId, msg.sender);
//     }

//     /**************************************************************************/
//     /*!
//        \brief Unstakes a token and records the start block number or time stamp.
//     */
//     /**************************************************************************/

//     function unstake(uint256 tokenId) public {
//         require(
//             ERC721NES( address(bobotGenesis)).ownerOf(tokenId) == msg.sender,
//             "You are not the owner of this token"
//         );

//         tokenToTotalDurationStaked[tokenId] += getCurrentAdditionalBalance(
//             tokenId
//         );
//         ERC721NES( address(bobotGenesis)).unstakeFromController(tokenId, msg.sender);
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
 }
