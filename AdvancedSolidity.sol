// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

/*
    ***** Topics *****
    -> Mapping
    -> Memory vs Stroage
    -> Enums
    -> Structs
    -> View and Pure Functions
    -> Moodifiers
    -> Constructors
    -> Events
    -> Inheritance
    -> How to Transfer ETH from Smart Contract
    -> Calling External Smart Contracts
    -> Import Statements
    -> Solidity Libraries
*/

contract Mapping {
    /* 
        Mapping is same as Objects in Javascript and HashMap of Java.
        Map is a DS where you have a key => value
    */
    mapping(address => string) public moods;

    // access someone's mood value like moods[address] => string

    function getMood(address user) public view returns (string memory) {
        return moods[user];
    }

    function setMood(string memory mood) public {
        moods[msg.sender] = mood;
    }
}

contract Enum {
    // Enum is the short for Enumerable or Enumerators
    // Human readable types for a set of values

    enum Status {
        TODO,
        IN_PROGRESS,
        DONE,
        CANCELED
    }

    mapping(uint256 => Status) todos;

    function addTask(uint256 id) public {
        todos[id] = Status.DONE;
    }

    function markTaskInProgress(uint256 id) public {
        todos[id] = Status.IN_PROGRESS;
    }

    function getStatus(uint256 id) public view returns (Status) {
        return todos[id];
    }
}

contract Structs {
    // structs are kind of like classes without any methods defined on them

    // it is a way to hold hold a bunch of information together
    // What does a TODO app mean -> A Title -> and Description for that Task

    enum Status {
        TODO,
        IN_PROGRESS,
        DONE,
        CANCELED
    }

    struct Task {
        string title;
        string description;
        Status status;
    }

    mapping(uint256 => Task) tasks;

    function addTask(
        uint256 id,
        string memory title,
        string memory description
    ) public {
        // Struct has 3 ways to initialize it

        // Method 1
        // tasks[id] = Task(title , description , Status.TODO);

        // Method 2
        tasks[id] = Task({
            title: title,
            description: description,
            status: Status.TODO
        });

        // Method 3
        // Task memory task;
        // task.title = title;
        // task.description = description;
        // task.status = Status.TODO;

        // tasks[id] = task;
    }

    function deleteTask(uint256 id) public {
        delete tasks[id];
    } 

}


contract ViewAndPureFunctions{
    // 3 kinds of keywords to indicate the side effect of functions
    // side effect means something that changes the value of a variable beyond its own scope
    

    // 1. No specified at all
    // 2. view function
    // 3. pure function

    uint y = 9;
    function someFunction() public{
        uint x = 0;
        x = 5;
        y = 5;
    }

    // view function only view from the state of the function does not write
    // view functions are free it doesn't cost you gas to deploy it.
    function getY() public view returns(uint){
        return y;
    }

    // pure function is a function that does not read or write to state
    // pure functions also are free it doesn't cost you gas to deploy it.
    function addTwoNumbers(uint a , uint b) public pure returns(uint){
        return a + b;
    }
}


contract Moodifiers{
    /* 
    Modifiers are pieces of code which can be runn before or after any other function call

    E.g.  Restricting access to functions (only owners)
    E.g.  Validating the input of certain parameters
    E.g.  Prevent certain types of attack (reentrancy attack)

    */

    address owener;
    constructor(){
        owener = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owener , "Unauthorized");
        _;
        // _; means 'run the rest of the code here'
    }


    // these 2 function only be able to called by owner
    function someFunc1() public onlyOwner{
        // run the rest of the code
    }
    function someFunc2() public onlyOwner{
        // run the rest of the code
    }
}


contract Inheritance {
    /* in solidity we perform inheritance using the is keyword.

    1. Solidity supports multiple inheritance , so your contract can inherit from more than one contracts
    2. A child contract can override a parent class's function using the `override` keyword in solidity
    3. But, only function marked `virtual` are the only ones that can be overridden , other functions cannot
       be overridden by the child
    4. ORDER  of Inheritance matters.
    */
}


contract ETHSender{
    // Three different ways to send ETH from contract
    // but 2 of the 3 methods are no longer recommended to use

    // .call method is good.
    function mirror() public payable{
        // msg.sender is the person we are getting the ETH from and 
        // and also the person we send it back to

        // msg.value is the ETH we receive and amount of we send back

        // getting the payable address
        address payable target = payable(msg.sender);
        uint256 amount = msg.value;

        /* 
        (payable address).call{ value : amount }.("");
        .call() returns two variables
        the first is a boolean indicating success or faiure
        the second is some bytes which have some data
        */
        // if we don't want second parameter then we will leave it but we will keep the ,
        (bool success , ) = target.call{value : amount}("");
        require(success , "FAILURE");
    }
}



// defining the SafeMath library
library SafeMath{
    function add(uint a , uint b) public pure returns (uint){
        uint c = a+b;
        // checking that overflow happened or not if then return error else return sum
        require(c >= a+b , "Overflow occured");
        return c;
    }
}


contract Libraries{
    /* 
        So far we have seen 2 top level constructs in Solidity
        1. contract
        2. Interface (will see this soon)

        What is Solidity Library?
        -> Typically used to add some helper functions to your contracts
        -> They cannot contain any states which means that
           1. you cannot have any state variables
           2. you cannot have any mappings/arrays/structs etc
           3. All you can do is to have some functions that take some
            input and return some output

        Before Solidity 0.8 a very common library that was used was 
        called `SafeMath`for performing mathematical operations 
        were `valid` and there was not Integer 'underflow/overflow'
        
        going on solidity 0.8 actually comes with SafeMath built in so we
        don't use nowasays but it is a good example of what Solidity Libraries are?


        **** Pretty much all the functions in Libraries are pure functions ****
    */

    // now using the SafeMath library that just we created above
    function testAddition(uint x , uint y) public pure returns (uint){
        return SafeMath.add(x , y);
    }
}

interface MinimalERC20{
    // We just need to include function definitions
    // for the functions we care about
    // we don't need the interface for the entire contract
    // if we are not using those functions
    function balanceOf(address account) external view returns(uint256);
}

contract ExternalCaller{
    /*
        Contracts can call other Contracts by calling the functions regularly
        on an instance of the other contract
        
        If you are in contract A and you want to call the function foo() of A
        from the contract B you can call like A.fool()
        BUT, to do this 
        you need Interface for A.

        What is an Interface ??
        -> An Interface is kind of an ABI to a contract
        -> It defines the function declaration
            1. What is the name of the function in the present contract
            2. What are the input value
            3. What is the return value
            4. What is the visibility (public/private/external) etc.
            5. What is the mutability (view,pure,nothing)
    */

    // we can have a state variable of the type MinimalERC20 and named externalContract
    MinimalERC20 externalContract;
    constructor(address someERC20Contract){
        // and in our contructor we can set it to the address using MinimalERC20
        externalContract = MinimalERC20(someERC20Contract);
    }

    function doIHaveBalance() public view{
        // check if msg.sender owns any ERC20 tokens from erc20Contract
        // require that the balance is > 0 otherwise fail the txn


        // calling the balanceOf function using the state variable externalContract
        uint balance = externalContract.balanceOf(msg.sender);
        require(balance > 0 , "You don't own any tokens");
    }
}


contract Events{
    /*
        What are events?
        -> Events are logs on Ethereum Blockchain.

        You can use events to 'log' information on the blockchain , kind of
        a proof of history that something happened at a certain block

        Events have:
        1. name
        2. arguments that you want to log

        events are emmited.
    */
    event TestFunctionCalled(address sender , string message);


    function test() public{
        // emit the event.
        emit TestFunctionCalled(msg.sender , "Somebody called test()");
    }
}
