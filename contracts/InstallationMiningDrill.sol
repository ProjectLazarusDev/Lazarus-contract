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
// //import "./ERC721NES.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// //import Bobot genesis
// import "./BobotGenesis.sol";
// import "./BobotMegaBot.sol";

// contract MiningDrill is Ownable 
// {

//     // block number multiplier to determine the balance to accrue
//     // during the duration staked. Defaults to 1.
//     uint256 multiplier = 1;

//     //bobots genesis contract
//     BobotGenesis public bobotGenesis;

//     // bobots megabots contract 
//     BobotMegaBot public bobotMegabot;

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
//     //     require(
//     //         ERC721NES( address(bobotGenesis)).ownerOf(tokenId) == msg.sender,
//     //         "You are not the owner of this token"
//     //     );

//     //     tokenToWhenStaked[tokenId] = block.number;
        
//     //     ERC721NES( address(bobotGenesis)).
//     //     stakeFromController(tokenId, msg.sender);
//     }

//     /**************************************************************************/
//     /*!
//        \brief Unstakes a token and records the start block number or time stamp.
//     */
//     /**************************************************************************/

//     function unstake(uint256 tokenId) public {
//     //     require(
//     //         ERC721NES( address(bobotGenesis)).ownerOf(tokenId) == msg.sender,
//     //         "You are not the owner of this token"
//     //     );

//     //     tokenToTotalDurationStaked[tokenId] += getCurrentAdditionalBalance(
//     //         tokenId
//     //     );
//     //     ERC721NES( address(bobotGenesis)).unstakeFromController(tokenId, msg.sender);
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
// }
