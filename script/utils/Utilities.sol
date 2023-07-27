// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Script.sol";

contract Utilities is Script {
    bytes32 internal nextUser = keccak256(abi.encodePacked("user address"));

    address[] accounts;

    mapping(address => uint256) public pks;

    constructor() {
        accounts =
            [0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC,
            0x90F79bf6EB2c4f870365E785982E1f101E93b906];

        pks[accounts[0]] = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        pks[accounts[1]] = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;
        pks[accounts[2]] = 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a;
        pks[accounts[3]] = 0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6;
    }

    
    function getUserAccount(uint256 i) external returns (address payable) {
        return payable(accounts[i]);
    }

    function getUserPrivateKey(address account) external returns (uint256 pk) {
        return pks[account];
    }

}