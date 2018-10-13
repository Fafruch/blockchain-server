pragma solidity ^0.4.21;

contract Lock {
    struct LockedFunds { uint256 value; uint256 until; }
    address public owner;
    mapping(address => LockedFunds) public locked;

    // Declare an event
    event FundsLocked(address indexed sender, uint256 value);

    function Lock() public { owner = msg.sender; }

    function lock() public payable {
        // NOTE bug below
        locked[msg.sender].value = msg.value;
        locked[msg.sender].until = block.number + 5;

        // emit an event
        emit FundsLocked(msg.sender, locked[msg.sender].value);
    }
    function unlock() public {
        LockedFunds memory data = locked[msg.sender];
        require(data.value != 0);
        require(data.until >= block.number);

        // NOTE re-entrant transfer
        msg.sender.call(data.value);
        delete locked[msg.sender];
    }

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(address(this).balance);
    }
}
