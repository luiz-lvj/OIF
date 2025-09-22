// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import { Script, console } from "forge-std/Script.sol";

import { OutputSettlerSimple } from "../../src/output/simple/OutputSettlerSimple.sol";
import { HyperlaneOracle } from "../../src/integrations/oracles/hyperlane/HyperlaneOracle.sol";
import { MockERC20 } from "../../test/mocks/MockERC20.sol";

contract DeployOutputOracle is Script {

    OutputSettlerSimple public outputSettler;
    HyperlaneOracle public hyperlaneOracle;

    function setUp() public {}

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        outputSettler = new OutputSettlerSimple{ salt: bytes32(0) }();

        address mailbox = 0x6966b0E55883d49BFB24539356a2f8A673E02039;
        address customHook = address(0); // No custom hook
        address ism = 0x82E3b437A2944e3fF00258C93e72cD1Ba5E0e921;

        hyperlaneOracle = new HyperlaneOracle(mailbox, customHook, ism);
        MockERC20 token = new MockERC20("TEST", "TEST", 18);
        
        console.log("OutputSettler:", address(outputSettler));
        console.log("HyperlaneOracle Output:", address(hyperlaneOracle));
        console.log("MockERC20:", address(token));





        vm.stopBroadcast();
    }
}
