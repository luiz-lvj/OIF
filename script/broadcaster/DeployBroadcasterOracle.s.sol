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

        address owner = 0x9a56fFd72F4B526c523C733F1F74197A51c495E1;
        IReceiver receiver = IReceiver(0xAb23DF3fd78F45E54466d08926c3A886211aC5A1);
        IBroadcaster broadcaster = IBroadcaster(0xAb23DF3fd78F45E54466d08926c3A886211aC5A1);

        BroadcasterOracle broadcasterOracle = new BroadcasterOracle(receiver, broadcaster, owner);

        console.log("BroadcasterOracle deployed to:", address(broadcasterOracle));

        vm.stopBroadcast();
    }
}
