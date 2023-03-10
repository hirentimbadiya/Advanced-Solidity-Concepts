// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract A{
    // Top level parent contract

    // virtual marks this function to be overridden by children
    function foo() public pure virtual returns (string memory){
        return "Hello!! Good Morning from contract A!";
    }
}

contract B is A{
    // override the A.foo()
    // when you call foo() from contract B it will return "Hello!! Good Afternoon from contract B!"
    function foo() public pure virtual override returns (string memory){
        return "Hello!! Good Afternoon from contract B!";
    }
}

contract C is A {
    // this means I am overriding this function coming from A
    // and at the same time I am marking it virtual so
    // it can be overridden later by its children.
    function foo() public pure virtual override returns (string memory){
        return "Hello!! Good Evening from contract C!";
    }
    
}


// D Inherits from both B and C
contract D is B , C{
    // super is a keyword that lets you call the parent functions.
    function foo() public pure override(B , C) returns(string memory){
        return super.foo();
        // this will return the foo() function inside the contract C.
    }
}

contract E is C , B{
    function foo() public pure override(C , B) returns (string memory){
        return super.foo();
        // this will return the foo() function inside the contract B.
    }
}
