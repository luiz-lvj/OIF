// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import { CatsMulticallHandler } from "../src/integrations/CatsMulticallHandler.sol";
import { Script, console } from "forge-std/Script.sol";

contract DeployMulticallHandler is Script {
    CatsMulticallHandler public multicallHandler;

    function run() public {
        vm.startBroadcast();

        multicallHandler = new CatsMulticallHandler{ salt: bytes32(0) }();

        console.log("MulticallHandler:", address(multicallHandler));

        vm.stopBroadcast();
    }
}
