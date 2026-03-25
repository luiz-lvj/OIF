// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import { Script, console } from "forge-std/Script.sol";

import { InputSettlerEscrow } from "../src/input/escrow/InputSettlerEscrow.sol";
import { OutputSettlerSimple } from "../src/output/simple/OutputSettlerSimple.sol";

contract DeploySettlers is Script {
    OutputSettlerSimple public outputSettler;
    InputSettlerEscrow public inputSettlerEscrow;

    function run() public {
        vm.startBroadcast();
        outputSettler = new OutputSettlerSimple{ salt: bytes32(0) }();
        inputSettlerEscrow = new InputSettlerEscrow{ salt: bytes32(0) }();

        console.log("OutputSettler:", address(outputSettler));
        console.log("InputSettlerEscrow:", address(inputSettlerEscrow));
        vm.stopBroadcast();
    }
}
