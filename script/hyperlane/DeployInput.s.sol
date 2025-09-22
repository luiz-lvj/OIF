// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import { Script, console } from "forge-std/Script.sol";

import { OutputSettlerSimple } from "../../src/output/simple/OutputSettlerSimple.sol";
import { HyperlaneOracle } from "../../src/integrations/oracles/hyperlane/HyperlaneOracle.sol";
import { MockERC20 } from "../../test/mocks/MockERC20.sol";

contract DeployInputOracle is Script {

    HyperlaneOracle public hyperlaneOracle;

    function setUp() public {}

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address mailbox = 0x6966b0E55883d49BFB24539356a2f8A673E02039;
        address customHook = address(0); // No custom hook
        address ism = 0x426539Fda024e1Ae9CaB738D6EAb721F9eA6F2B3;

        hyperlaneOracle = new HyperlaneOracle(mailbox, customHook, ism);
        
        console.log("HyperlaneOracle Input:", address(hyperlaneOracle));

        vm.stopBroadcast();
    }
}
