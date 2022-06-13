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

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";

//other staking contracts
import "./interfaces/IBobot.sol";
import "./InstallationCoreChamber.sol";
import "./interfaces/IStake.sol";

contract BobotGenesisV2 is IBobot, ERC721EnumerableUpgradeable, OwnableUpgradeable 
{
    
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using AddressUpgradeable for address;
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using StringsUpgradeable for uint256;

    //revealed and unrevealed uri
    string public baseRevealedURI;
    string public baseHiddenURI;

    string public baseExtention;
    uint256 constant maxSupply = 4040;
    uint256 public maxLevelAmount;

    //reveal whitelist variables
    bool public revealed;
    bool public onlyWhitelisted;

    //store whitelisted addresses
    address[] whitelistedAddressesGuardians;
    address[] whitelistedAddressesLunars;

    //root hash for merkle proof
    bytes32 public rootGuardiansHash;
    bytes32 public rootLunarsHash;

    //core chamber level update cost
    uint256 public coreChamberLevelCost;

    //token id counter
    CountersUpgradeable.Counter private _tokenIdCounter;

    //level cost
    uint256 levelCost;

    //amount mintable per whitelist
    mapping(address => bool) public whitelistedAddressesGuardiansClaimed;
    mapping(address => bool) public whitelistedAddressesLunarClaimed;

    //core chamber
    CoreChamber public coreChamber;

    //core points on a per bobot basis
    //one bobot -> core point
    mapping(uint256 => uint256) public bobotCorePoints;

    //is the contract running
    bool public paused;

    function initialize() external initializer 
    {
        __ERC721Enumerable_init();
        __Ownable_init();

        baseExtention = ""; 
        maxLevelAmount = 10; 
        revealed = false; 
        onlyWhitelisted = true;
        paused = false;
    }
    
    //modifiers
    /**************************************************************************/
    /*!
       \brief only core chamber can access this function
    */
    /**************************************************************************/
    modifier onlyCoreChamber() {
        require(msg.sender == address(coreChamber), "Bobots: !CoreChamber");
        _;
    }

    /**************************************************************************/
    /*!
       \brief view URI reveal / hidden
    */
    /**************************************************************************/
    function _baseURI() internal view virtual override returns (string memory) {
        return revealed ? baseRevealedURI : baseHiddenURI; // return own base URI
    }

    // public
    /**************************************************************************/
    /*!
       \brief mint a bobot - multiple things to check 
       does user have $MAGIC in their wallet?
    */
    /**************************************************************************/
    function mintBobot(
        bytes32[] calldata _merkleProof,
        bytes32[] calldata _merkleProof2
    ) public payable {
        //is contract running?
        require(!paused);
       
        uint256 mintCount = 0;
        
        //minter must be whitelisted
        if (onlyWhitelisted == true) {

            // check if user already white listed either as a guardian or lunar
            require(
                 whitelistedAddressesGuardiansClaimed[msg.sender] == false ||
                 whitelistedAddressesLunarClaimed[msg.sender] == false,
                "user already whitelisted"
            );

            bytes32 leaf = keccak256(abi.encodePacked(msg.sender));

            bool isGuardians = MerkleProof.verify(
                _merkleProof,
                rootGuardiansHash,
                leaf
            );
            bool isLunars = MerkleProof.verify(
                _merkleProof2,
                rootLunarsHash,
                leaf
            );

            //check if leaf is valid
            require(
                isGuardians || isLunars,
                "Invalid proof - not whitelisted"
            );

            //guardians will have 1 mint
            //lunars will have 2 mint

            if (isGuardians) {
                require(_getNextTokenId() <= maxSupply);
                mintCount = 1;
                whitelistedAddressesGuardiansClaimed[msg.sender] = true;
            }

            if (isLunars) {
                require(_getNextTokenId() + 1 <= maxSupply);
                mintCount = 2;
                whitelistedAddressesLunarClaimed[msg.sender] = true;
            }
        }
            

        for (uint256 i = 1; i <= mintCount; ++i) {
            uint256 nextTokenId = _getNextTokenId();
            _safeMint(msg.sender, nextTokenId);
        }
    }

    /**************************************************************************/
    /*!
       \brief mint a bobot - test
    */
    /**************************************************************************/
    function mintBobotTest() public payable {
        //is contract running?
        require(!paused);
        uint256 nextTokenId = _getNextTokenId();
        _safeMint(msg.sender, nextTokenId);
    }

    function getBobotType()
        external
        view
        override
        returns (BobotType)
    {
        return BobotType.BOBOT_GEN;
    }

    /**************************************************************************/
    /*!
       \brief return all token ids a holder owns
    */
    /**************************************************************************/
    function getTokenIds(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 t = ERC721Upgradeable.balanceOf(_owner);
        uint256[] memory _tokensOfOwner = new uint256[](t);

        for (uint256 i = 0; i < ERC721Upgradeable.balanceOf(_owner); i++) {
            _tokensOfOwner[i] = ERC721EnumerableUpgradeable.tokenOfOwnerByIndex(
                _owner,
                i
            );
        }
        return (_tokensOfOwner);
    }

    /**************************************************************************/
    /*!
       \brief return URI of a token - could be revealed or hidden
    */
    /**************************************************************************/
    function getTokenURI(uint256 tokenID)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenID),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();

        string memory revealedURI = string(
            abi.encodePacked(
                baseRevealedURI,
                tokenID.toString(),
                "/",
                getCurrentBobotLevel(tokenID).toString(),
                baseExtention
            )
        );

        return 
            bytes(currentBaseURI).length > 0
                ? (revealed ? revealedURI : baseHiddenURI)
                : "";
    }

    function _getNextTokenId() private view returns (uint256) {
        return (_tokenIdCounter.current() + 1);
    }

    function _safeMint(address to, uint256 tokenId)
        internal
        override(ERC721Upgradeable)
    {
        super._safeMint(to, tokenId);
        _tokenIdCounter.increment();
    }

    /**************************************************************************/
    /*!
       \brief returns the bobots current level
    */
    /**************************************************************************/
    function getCurrentBobotLevel(uint256 _tokenID) 
        public 
        view 
        returns (uint256)
    {
        return  Math.min(
            bobotCorePoints[_tokenID] / coreChamberLevelCost,
            maxLevelAmount
        );
    }

    /**************************************************************************/
    /*!
       \brief earning core points logic
    */
    /**************************************************************************/
    function coreChamberCorePointUpdate(uint256 _tokenId, uint256 _coreEarned)
        external
        onlyCoreChamber
    {
        bobotCorePoints[_tokenId] += _coreEarned;
    }

    //------------------------- ADMIN FUNCTIONS -----------------------------------

    function setRootGuardiansHash(bytes32 _rootHash) external onlyOwner {
        rootGuardiansHash = _rootHash;
    }

    function setRootLunarsHash(bytes32 _rootHash) external onlyOwner {
        rootLunarsHash = _rootHash;
    }

    /**************************************************************************/
    /*!
       \brief enable reveal phase
    */
    /**************************************************************************/
    function reveal(bool _revealed) external onlyOwner {
        revealed = _revealed;
    }
    function setCoreChamberLevelCost(uint256 _cost) external onlyOwner {
        coreChamberLevelCost = _cost;
    }
    /**************************************************************************/
    /*!
       \brief set Core Chamber Contract
    */
    /**************************************************************************/
    function setCoreChamber(address _coreChamber) external onlyOwner {
        coreChamber = CoreChamber(_coreChamber);
    }

    /**************************************************************************/
    /*!
       \brief set base URI
    */
    /**************************************************************************/
    function setBaseRevealedURI(string memory _newBaseURI) public onlyOwner {
        baseRevealedURI = _newBaseURI;
    }

    /**************************************************************************/
    /*!
       \brief set base URI
    */
    /**************************************************************************/
    function setBaseHiddenURI(string memory _newBaseURI) public onlyOwner {
        baseHiddenURI = _newBaseURI;
    }

    /**************************************************************************/
    /*!
       \brief set Base Extensions
    */
    /**************************************************************************/
    function setBaseExtentions(string memory _newBaseExtentions)
        public
        onlyOwner
    {
        baseExtention = _newBaseExtentions;
    }

    function _beforeTokenTransfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal override {

        super._beforeTokenTransfer(_from, _to, _tokenId);

        if (address(coreChamber) != address(0))
            require(!coreChamber.isAtCoreChamberGenesis(_tokenId), "Genesis: at core chamber. Unstake to transfer.");
    }

    /**************************************************************************/
    /*!
       \brief set Max Level
    */
    /**************************************************************************/
    function setMaxLevel(uint256 _newLevelAmount)
        public
        onlyOwner
    {
        maxLevelAmount = _newLevelAmount;
    }

    /**************************************************************************/
    /*!
       \brief pause smart contract (for safety purposes)
    */
    /**************************************************************************/
    function pause(bool _state) public onlyOwner {
        paused = _state;
    }
}
