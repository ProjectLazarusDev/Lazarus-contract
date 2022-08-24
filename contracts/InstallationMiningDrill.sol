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

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";

import "./IMiningDrill.sol";

contract MiningDrill is 
    Initializable,
    OwnableUpgradeable, 
    PausableUpgradeable,
    ERC721HolderUpgradeable
{
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using AddressUpgradeable for address;

    address public TREASURY_WALLET;
    uint256 public PRICE;

    // immutable states 
    IERC20Upgradeable public MAGIC; 
    IMiningDrill public MINING_DRILL;

    IMiningDrill.Duration[] public DURATIONS; 
    IMiningDrill.Duration[] public allowedDurations; 

    IMiningDrill.Tier[] public TIERS; 

    // operator states
    uint256 public currentDepositId;

    mapping(uint256 => address) public bobotGenesisStakers;

    function initialize(
        address _magic,
        address _miningDrill, 
        address _treasury
    ) external initializer{
        require (_magic != address(0), "Bobots Mining Drill: invalid address");
        require (_miningDrill != address(0), "Bobots Mining Drill: invalid address");

        MAGIC = IERC20Upgradeable(_magic);
        MINING_DRILL = IMiningDrill(_miningDrill);

        DURATIONS = [
            IMiningDrill.Duration.TWO_WEEKS,
            IMiningDrill.Duration.ONE_MTH,
            IMiningDrill.Duration.THREE_MTHS,
            IMiningDrill.Duration.SIX_MTHS,
            IMiningDrill.Duration.ONE_YEAR
        ];

        TIERS = [
            IMiningDrill.Tier.Gold, 
            IMiningDrill.Tier.Silver, 
            IMiningDrill.Tier.Bronze
        ];

        setTreasury(_treasury);
    }
    
    function deposit(uint256 _amount, IMiningDrill.Duration _duration)
        external
        whenNotPaused
        returns (uint256)
    {
        require(_amount > 0, "BattflyAtlasStaker: cannot deposit 0");

        MAGIC.safeTransferFrom(_msgSender(), address(this), _amount);

        uint256 newDepositId = ++currentDepositId;
        // uint256 unlockAt = _deposit(newDepositId, _amount, _lock);
        // emit NewDeposit(_msgSender(), _amount, unlockAt);
        // return newDepositId;
    }

    function _claim(uint256 _depositId) internal returns (uint256) {
        //VaultStake storage vaultStake = vaultStakes[_depositId];
        //require(vaultStake.vault == _msgSender(), "BattleflyAtlasStaker: caller is not a correct vault");

        //(uint256 emission, uint256 fee) = getClaimableEmission(_depositId);
        //require(emission > 0, "BattleflyAtlasStaker: no emission");

        //MAGIC.safeTransfer(_msgSender(), emission);
        //MAGIC.safeTransfer(TREASURY_WALLET, fee);
        //uint256 amount = emission + fee;
        //vaultStake.paidEmission += amount;
        //return emission;
    }

    function stake(uint256 _tokenID, IMiningDrill.Tier _tier) external {

    }

    function unstake(uint256 _tokenID, IMiningDrill.Tier _tier) external {
        require(bobotGenesisStakers[_tokenID] == _msgSender(), "Bobots Mining Drill: Invalid staker");
        // need to check according to the tier on the durability and rewards

        // transfer bobots to the staker 
        getBobotsGenesis().safeTransferFrom(address(this), _msgSender(), _tokenID, "");
        bobotGenesisStakers[_tokenID] = address(0);
        emit UnstakedBobotsGen(_msgSender(), _tokenID);
    }

    // -------------------- OWNER OPERATIONS --------------------------
    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
    
    function setTreasury(address _treasury) public onlyOwner {
        require(_treasury != address(0), "Bobots Mining Drill: invalid address");
        TREASURY_WALLET = _treasury;
        //emit SetTreasury(_treasury);
    }

    // -------------------- VIEW OPERATIONS ---------------------------
    function isValidLock(IMiningDrill.Duration _duration) public view returns (bool) {
        for (uint256 i = 0; i < allowedDurations.length; ++i)
        {
            if (allowedDurations[i] == _duration)
            {
                return true;
            }
        }
        return false;
    }

    function getClaimableEmission(uint256 _depositId, IMiningDrill.Tier _tier) public view returns (uint256 emission, uint256 fee) {
        
    }

    function getBobotsGenesis() public view returns (IERC721Upgradeable) {
        return IERC721Upgradeable(MINING_DRILL.bobotsGenesis());
    }
    
    // --------------------- EVENTS --------------------------
    event SetTreasury(address treasury);
    event UnstakedBobotsGen(address staker, uint256 tokenId);

}

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
