// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface ICoreChamber
{

    enum CCTier
    {
        Gold, 
        Silver, 
        Bronze
    }

    // get Bobots staked duration
    function getTier(uint256 _tokenID) external view returns(CCTier);
}