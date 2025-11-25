// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import { Script, console } from "forge-std/Script.sol";

import { BroadcasterOracle } from "../../src/integrations/oracles/broadcaster/BroadcasterOracle.sol";
import { OutputSettlerSimple } from "../../src/output/simple/OutputSettlerSimple.sol";
import { MockERC20 } from "../../test/mocks/MockERC20.sol";

import { MandateOutput } from "../../src/input/types/MandateOutputType.sol";
import { LibAddress } from "../../src/libs/LibAddress.sol";
import { MandateOutputEncodingLib } from "../../src/libs/MandateOutputEncodingLib.sol";

contract DeployOutputOracle is Script {
    using LibAddress for address;

    OutputSettlerSimple public outputSettler;
    MandateOutput public output;
    BroadcasterOracle public broadcasterOracle;
    MockERC20 public token;

    function setUp() public { }

    function run() external {
        // sepolia

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        broadcasterOracle = BroadcasterOracle(0x947E5E61F63d51e3B7498dfEe96A28B190eD5e8B);

        outputSettler = OutputSettlerSimple(0x674Cd8B4Bec9b6e9767FAa8d897Fd6De0729dd66);
        token = MockERC20(0x287E1E51Dad0736Dc5de7dEaC0751C21b3d88d6e);

        console.log("token deployed to:", address(token));
        console.log("output settler deployed to:", address(outputSettler));

        uint256 amount = 1 ether;

        address filler = 0x9a56fFd72F4B526c523C733F1F74197A51c495E1;

        output = MandateOutput({
            oracle: address(broadcasterOracle).toIdentifier(),
            settler: address(outputSettler).toIdentifier(),
            chainId: block.chainid,
            token: bytes32(abi.encode(address(token))),
            amount: amount,
            recipient: bytes32(abi.encode(filler)),
            callbackData: bytes(""),
            context: bytes("")
        });

        bytes memory fillerData = abi.encodePacked(filler.toIdentifier());

        // token.mint(filler, 1000 * amount);
        // token.approve(address(outputSettler), type(uint256).max);

        bytes32 orderId = keccak256(bytes("orderId"));

        console.log("orderId");
        console.logBytes32(orderId);

        //outputSettler.fill(orderId, output, type(uint48).max, fillerData);

        bytes memory payload = MandateOutputEncodingLib.encodeFillDescriptionMemory(
            filler.toIdentifier(),
            orderId,
            uint32(1764104508),
            output.token,
            output.amount,
            output.recipient,
            bytes(""),
            bytes("")
        );

        bytes[] memory payloads = new bytes[](1);
        payloads[0] = payload;

        broadcasterOracle.submit(address(outputSettler), payloads);

        vm.stopBroadcast();
    }
}
