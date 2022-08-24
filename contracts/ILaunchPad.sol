// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface ILaunchPad
{

    enum LPTier
    {
        Gold, 
        Silver, 
        Bronze
    }

    // get land tier
    function getTier(uint256 _tokenID) external view returns(LPTier);
}