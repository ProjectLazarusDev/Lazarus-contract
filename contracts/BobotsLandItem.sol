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
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

//other staking contracts
import "./InstallationCoreChamber.sol";
import "./interfaces/ILandTier.sol";

//$MAGIC transactions
import "./Magic20.sol";

contract BobotsLandItem is 
    ERC1155, 
    OwnableUpgradeable
{
    using StringsUpgradeable for uint256;

    mapping (address => bool) private _approvedAddresses; 
    mapping (address => address) private _coreChamberAddress;
    mapping (address => address) private _miningDrillAddress; 
    mapping (address => address) private _launchPadAddress;

    // TO SET THIS
    string private uriPrefix; 
    string private uriSuffix;

    enum LandType 
    {
        CORE_CHAMBER, 
        MINING_DRILL, 
        LAUNCH_PAD
    }

    constructor() ERC1155("overrided"){
        _approvedAddresses[msg.sender] = true;
    }

    function setCCAddress(address _ccAddr) external onlyOwner{
        _coreChamberAddress = _ccAddr;
    }

    function setMDAddress(address _mdAddr) external onlyOwner {
        _miningDrillAddress = _mdAddr;
    }
    
    function setLPAddress(address _lpAddr) external onlyOwner {
        _launchPadAddress = _lpAddr;
    }

    function setURI(string memory _prefix, string memory _suffix) external onlyOwner {
        uriPrefix = _prefix; 
        uriSuffix = _suffix;
    }

    function airdrop(address _to, uint256 _amount, LandType _type, ILandTier _tier) public onlyOwner {
        _mintSpecificLand(_to, _amount, _type, _tier);
    }

    function uri(uint256 _tokenID) public override view returns (string memory){
        return(string(abi.encodePacked(uriPrefix, StringsUpgradeable.toString(_tokenID), uriSuffix)));
    }

    function mint(address _to, uint256 _id, uint256 _amount) external {
        require(_approvedAddresses[msg.sender], "You are not an approved address.");
        _mint(_to, _id, _amount, "");
    }

    function burn(address _from, uint256 _id, uint256 _amount) external {
        require(_approvedAddresses[msg.sender], "You are not an approved address.");
        _burn(_from, _id, _amount);
    }

    function burnBatch(address _from, uint256[] memory _ids, uint256[] memory _amounts) external {
        require(_approvedAddresses[msg.sender], "You are not an approved address.");
        _burnBatch(_from, _ids, _amounts);
    }

    function _mintSpecificLand(address _account, uint256 _amount, LandType _type, ILandTier _tier) public onlyOwner {
        if (_type == LandType.CORE_CHAMBER) {
            
        }
        else if (_type == LandType.LAUNCH_PAD) {

        }
        else {
            
        }
    }

    function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal override {
        // INSERT RATES HERE 
        
        // LandTierRoll = RandomValue % 100; 
        // if (LandTierRoll < 70) LandTier is Bronze
        // else if (LandTierRoll < 95) LandTier is Silver
        // else LandTier is Gold

        // LandTypeRoll = RandomValue % 100; 
        // if (LandTypeRoll < 60) LandType is Core Chamber
        // else if (LandTypeRoll < 95) LandType is Launch Pad
        // else LandType is Mining Drill
        
        //uint256 rand = _createRandom(3);

    }

    function _createRandom(uint _number) private returns (uint) { 
        return uint(blockhash(block.number - 1)) % _number;
    }
}    


// contract BobotsLandItem is ERC721EnumerableUpgradeable, OwnableUpgradeable
// {
//     using SafeERC20Upgradeable for IERC20Upgradeable;
//     using AddressUpgradeable for address;
//     using CountersUpgradeable for CountersUpgradeable.Counter;
//     //using StringsUpgradeable  for uint256;

//     //magic contract
//     IERC20Upgradeable public magic;

//     uint256 currencyExchange = (10**9);
//     uint256 magicBalanceCost = 25;

//     //revealed and unrevealed uri
//     string public baseRevealedURI;
//     string public baseHiddenURI;

//     string public baseExtention = ".json";
//     uint256 public maxSupply = 999999;
//     uint256 public maxMintAmount = 1;

//     //core chamber
//     CoreChamber public coreChamber;

//     //core points on a per bobot basis
//     //one bobot -> core point
//     mapping(uint256 => uint256) public bobotCorePoints;

//     //is the contract running
//     bool public paused = false;

//     CountersUpgradeable.Counter private _tokenIdCounter;



//     function initialize(  address _magicAddress) external initializer {
//         __ERC721Enumerable_init();
//         __Ownable_init();

//         magic = IERC20Upgradeable(_magicAddress);
//     }


//     //modifiers
//     /**************************************************************************/
//     /*!
//        \brief only core chamber can access this function
//     */
//     /**************************************************************************/
//     modifier onlyCoreChamber() {
//         require(msg.sender == address(coreChamber), "Bobots: !CoreChamber");
//         _;
//     }

//     /**************************************************************************/
//     /*!
//        \brief view URI reveal / hidden
//     */
//     /**************************************************************************/
//     function _baseURI() internal view virtual override returns (string memory) {
//         return  baseRevealedURI; // return own base URI
//     }

//     // public

//     /**************************************************************************/
//     /*!
//        \brief mint a bobot - multiple things to check 
//        does user have $MAGIC in their wallet?
//     */
//     /**************************************************************************/
//     function mintBobot(
       
//     ) public payable {
//         //is contract running?
//         require(!paused);
//         require(
//             magic.balanceOf(msg.sender) / currencyExchange > magicBalanceCost,
//             "Not enough magic in wallet"
//         );

//         uint256 mintCount = 0;

//         for (uint256 i = 1; i <= mintCount; ++i) {
//             uint256 nextTokenId = _getNextTokenId();
//             _safeMint(msg.sender, nextTokenId + i);
//         }
//     }

//     /**************************************************************************/
//     /*!
//        \brief mint a bobot - multiple things to check 
//        does user have $MAGIC in their wallet?
//     */
//     /**************************************************************************/
//     function mintBobotTest() public payable {
//         //is contract running?
//         require(!paused);
//         uint256 nextTokenId = _getNextTokenId();
//         _safeMint(msg.sender, nextTokenId);
//     }

//     /**************************************************************************/
//     /*!
//        \brief return all token ids a holder owns
//     */
//     /**************************************************************************/
//     function getTokenIds(address _owner)
//         public
//         view
//         returns (uint256[] memory)
//     {
//         uint256 t = ERC721Upgradeable.balanceOf(_owner);
//         uint256[] memory _tokensOfOwner = new uint256[](t);
//         uint256 i;

//         for (i = 0; i < ERC721Upgradeable.balanceOf(_owner); i++) {
//             _tokensOfOwner[i] = ERC721EnumerableUpgradeable.tokenOfOwnerByIndex(
//                 _owner,
//                 i
//             );
//         }
//         return (_tokensOfOwner);
//     }

//     /**************************************************************************/
//     /*!
//        \brief return URI of a token - could be revealed or hidden
//     */
//     /**************************************************************************/
//     function tokenURI(uint256 tokenID)
//         public
//         view
//         virtual
//         override
//         returns (string memory)
//     {
//         require(
//             _exists(tokenID),
//             "ERC721Metadata: URI query for nonexistent token"
//         );

//         string memory currentBaseURI = _baseURI();
       

//         string memory revealedURI = string(
//             abi.encodePacked(
//                 baseRevealedURI,
//                 baseExtention
//             )
//         );

//         return
//             bytes(currentBaseURI).length > 0
//                 ? (revealedURI)
//                 : "";
//     }

//     function _getNextTokenId() private view returns (uint256) {
//         return (_tokenIdCounter.current() + 1);
//     }

//     function _safeMint(address to, uint256 tokenId)
//         internal
//         override(ERC721Upgradeable)
//     {
//         super._safeMint(to, tokenId);
//         _tokenIdCounter.increment();
//     }

//     /**************************************************************************/
//     /*!
//        \brief earning core points logic
//     */
//     /**************************************************************************/
//     function coreChamberCorePointUpdate(uint256 _tokenId, uint256 _coreEarned)
//         external
//         onlyCoreChamber
//     {
//         bobotCorePoints[_tokenId] += _coreEarned;
//     }

//     //admin functions


//     /**************************************************************************/
//     /*!
//        \brief set Core Chamber Contract
//     */
//     /**************************************************************************/
//     function setCoreChamber(address _coreChamber) external onlyOwner {
//         coreChamber = CoreChamber(_coreChamber);
//     }

//     /**************************************************************************/
//     /*!
//        \brief set max mint amount
//     */
//     /**************************************************************************/
//     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
//         maxMintAmount = _newmaxMintAmount;
//     }

//     /**************************************************************************/
//     /*!
//        \brief set max mint amount
//     */
//     /**************************************************************************/
//     function setMagicBalanceCost(uint256 _newAmount) public onlyOwner {
//         magicBalanceCost = _newAmount;
//     }

//     /**************************************************************************/
//     /*!
//        \brief set base URI
//     */
//     /**************************************************************************/
//     function setBaseRevealedURI(string memory _newBaseURI) public onlyOwner {
//         baseRevealedURI = _newBaseURI;
//     }

//     /**************************************************************************/
//     /*!
//        \brief set base URI
//     */
//     /**************************************************************************/
//     function setBaseHiddenURI(string memory _newBaseURI) public onlyOwner {
//         baseHiddenURI = _newBaseURI;
//     }

//     /**************************************************************************/
//     /*!
//        \brief set magic address
//     */
//     /**************************************************************************/
//     function setMagicAddress(address _address) public onlyOwner {
//         magic = IERC20Upgradeable(_address);
//     }

//     /**************************************************************************/
//     /*!
//        \brief set Base Extensions
//     */
//     /**************************************************************************/
//     function setBaseExtentions(string memory _newBaseExtentions)
//         public
//         onlyOwner
//     {
//         baseExtention = _newBaseExtentions;
//     }

//     /**************************************************************************/
//     /*!
//        \brief pause smart contract
//     */
//     /**************************************************************************/
//     function pause(bool _state) public onlyOwner {
//         paused = _state;
//     }

//     /**************************************************************************/
//     /*!
//        \brief withdraw
//     */
//     /**************************************************************************/
//     function withdraw() public payable onlyOwner {
//         require(payable(msg.sender).send(address(this).balance));
//     }
// }
