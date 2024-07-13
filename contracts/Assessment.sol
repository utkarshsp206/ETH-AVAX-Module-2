pragma solidity ^0.8.9;

contract Assessment {
    address payable public owner;
    uint256 public balance;
    uint256 public minBalance = 1 ether; // 1 ETH
    uint256 public maxBalance = 5 ether; // 5 ETH
    string public warningMessage;

    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);
    event Warning(string message);


    constructor(uint initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
    }

    function getBalance() public view returns(uint256){
        return balance;
    }

    function getOwner() public view returns(address) {
        return owner;
    }

    function deposit(uint256 _amount) public payable {
        uint _previousBalance = balance;

        // make sure this is the owner
        require(msg.sender == owner, "You are not the owner of this account");

        // check if deposit would exceed max balance
        if (balance + _amount > maxBalance) {
            warningMessage = "Deposit would exceed maximum balance of 5 ETH";
            emit Warning(warningMessage);
            return;
        }

        // perform transaction
        balance += _amount;

        // assert transaction completed successfully
        assert(balance == _previousBalance + _amount);

        // emit the event
        emit Deposit(_amount);

    
    }

    function withdraw(uint256 _withdrawAmount) public {
        require(msg.sender == owner, "You are not the owner of this account");
        uint _previousBalance = balance;

        // check if withdrawal would go below min balance
        if (balance - _withdrawAmount < minBalance) {
            warningMessage = "Withdrawal would go below minimum balance of 1 ETH";
            emit Warning(warningMessage);
            return;
        }

        // perform transaction
        balance -= _withdrawAmount;

        // assert the balance is correct
        assert(balance == (_previousBalance - _withdrawAmount));

        // emit the event
        emit Withdraw(_withdrawAmount);
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "You are not the owner of this account");
        owner = payable(newOwner);
        emit OwnershipTransferred(newOwner);
    }
}
