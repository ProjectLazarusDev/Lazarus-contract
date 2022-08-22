// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface IMiningDrill
{
    enum Duration
    {
        TWO_WEEKS, 
        ONE_MTH, 
        THREE_MTHS, 
        SIX_MTHS, 
        ONE_YEAR
    }

    enum Tier
    {
        Gold, 
        Silver, 
        Bronze
    }

    // get Bobots staked duration
    function getStakedDuration(uint256 _tokenID) external view returns(Duration);

}