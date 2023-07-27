// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Script.sol";

import {Utilities} from "./utils/Utilities.sol";

import {FlashLoanReceiver} from "../../../src/contracts/naive-receiver/FlashLoanReceiver.sol";
import {NaiveReceiverLenderPool} from "../../../src/contracts/naive-receiver/NaiveReceiverLenderPool.sol";

contract NativeReceiverDeployScript is Script {
    uint256 internal constant ETHER_IN_POOL = 1_000e18;
    uint256 internal constant ETHER_IN_RECEIVER = 10e18;

    Utilities internal utils;
    NaiveReceiverLenderPool internal naiveReceiverLenderPool;
    FlashLoanReceiver internal flashLoanReceiver;
    address payable internal user;
    address payable internal attacker;
    address payable internal richman;

    function setUp() public {
        utils = new Utilities();
    }

    function run() public {
        
        address deployer = utils.getUserAccount(0);
        

        attacker = utils.getUserAccount(1);
        richman = utils.getUserAccount(2);

        uint256 deployerPrivateKey = utils.getUserPrivateKey(deployer);
        uint256 richmanPrivateKey = utils.getUserPrivateKey(richman);
        
        console.log("[*] deployer address %s ", deployer);
        console.log("[*] attacker address %s ", attacker);
        console.log("[*] richman address %s ", richman);

        vm.startBroadcast(deployerPrivateKey);

        // deploy NaiveReceiverLenderPool
        naiveReceiverLenderPool = new NaiveReceiverLenderPool();

        // deploy flashLoanReceiver
        flashLoanReceiver = new FlashLoanReceiver(
            payable(naiveReceiverLenderPool)
        );

        vm.stopBroadcast();

        // use richman to send Ether
        vm.startBroadcast(richmanPrivateKey);
        bool sent;

        // Transfer Ether into pool from rich man
        (sent, ) = address(naiveReceiverLenderPool).call{value: ETHER_IN_POOL}("");
        require(sent, "Failed to send Ether");
         
        require(address(naiveReceiverLenderPool).balance == ETHER_IN_POOL);
        require(naiveReceiverLenderPool.fixedFee() == 1e18);

        //Transfer Ether into pool from rich man
        (sent, ) = address(flashLoanReceiver).call{value: ETHER_IN_RECEIVER}("");
        require(sent, "Failed to send Ether");

        require(address(flashLoanReceiver).balance == ETHER_IN_RECEIVER);
        vm.stopBroadcast();



        console.log(unicode"🧨 Let's see if you can break it... 🧨");
    }
}