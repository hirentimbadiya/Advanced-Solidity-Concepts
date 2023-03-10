// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/* 
    there are two kinds of imports in solidity
    1. Local imports ( importing files from local storage )
    2. External imports ( from web / github / anywhere )
*/

// local import
import "./Inheritance.sol";
// remote import
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

/*
    When using Hardhat we use OpenZeppelin Contract , but we don't import them externally

    we download OpenZeppelinContract as a node package using npm
    like npm install @openzeppelin/contracts like that
*/
