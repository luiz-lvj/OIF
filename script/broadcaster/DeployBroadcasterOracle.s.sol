// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import { BroadcasterOracle } from "../../src/integrations/oracles/broadcaster/BroadcasterOracle.sol";
import { IBroadcaster } from "broadcaster/interfaces/IBroadcaster.sol";
import { IReceiver } from "broadcaster/interfaces/IReceiver.sol";
import { Script, console } from "forge-std/Script.sol";

contract DeployBroadcasterOracle is Script {
    function setUp() public { }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address owner = 0xCc2ACDd7eF3e9841d42E00199D4cF5bcdCa77a7e;
        IReceiver receiver = IReceiver(0x16681d01c9169aacaFB6BbCBaF4c7C3002C63059);
        IBroadcaster broadcaster = IBroadcaster(0x536c398D9bBAf896b128C99bB7c78CfA3243AE27);

        BroadcasterOracle broadcasterOracle = new BroadcasterOracle{ salt: bytes32(0) }(receiver, broadcaster, owner);

        console.log("BroadcasterOracle deployed to:", address(broadcasterOracle));

        vm.stopBroadcast();
    }
}
