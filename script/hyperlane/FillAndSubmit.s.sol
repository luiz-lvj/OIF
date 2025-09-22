// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import { Script, console } from "forge-std/Script.sol";

import { OutputSettlerSimple } from "../../src/output/simple/OutputSettlerSimple.sol";
import { HyperlaneOracle } from "../../src/integrations/oracles/hyperlane/HyperlaneOracle.sol";
import { MockERC20 } from "../../test/mocks/MockERC20.sol";

import { MandateOutput } from "../../src/input/types/MandateOutputType.sol";
import { LibAddress } from "../../src/libs/LibAddress.sol";
import { MandateOutputEncodingLib } from "../../src/libs/MandateOutputEncodingLib.sol";

contract DeployOutputOracle is Script {
    using LibAddress for address;

    OutputSettlerSimple public outputSettler;
    HyperlaneOracle public hyperlaneOutputOracle;
    MandateOutput public output;
    MockERC20 public token;

    function setUp() public {}

    function run() external {

        hyperlaneOutputOracle = HyperlaneOracle(0x378220D6De1301c9FbCe19f1860459CE84D4bBe7);
        outputSettler = OutputSettlerSimple(0x3770f7095aEA35E488724EB02eBB88d9004f3958);
        token = MockERC20(0x713468f906cc643c3484767559baA417214827B8);

        uint256 outputChainId = 84532; // Base Sepolia 
        uint256 amount = 0.01 ether;

        address hyperlaneInputOracle = 0xc8604e4aBC757C5C1990BAe679A7b219808EDc9c;

        output = MandateOutput({
            oracle: address(hyperlaneOutputOracle).toIdentifier(),
            settler: address(outputSettler).toIdentifier(),
            chainId: outputChainId,
            token: bytes32(abi.encode(address(token))),
            amount: amount,
            recipient: bytes32(abi.encode(hyperlaneInputOracle)),
            call: bytes(""),
            context: bytes("")
        });

        address filler = 0x9a56fFd72F4B526c523C733F1F74197A51c495E1;

        bytes memory fillerData = abi.encodePacked(filler.toIdentifier());

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        //token.approve(address(outputSettler), type(uint256).max);

        bytes32 orderId = keccak256(bytes("orderId"));

        console.log("orderId");
        console.logBytes32(orderId);

        //outputSettler.fill(orderId, output, type(uint48).max, fillerData);

        uint32 inputChainId = 11155420; // Optimism Sepolia

        bytes memory payload = MandateOutputEncodingLib.encodeFillDescriptionMemory(
            filler.toIdentifier(),
            orderId,
            uint32(1758569298),
            output.token,
            output.amount,
            output.recipient,
            bytes(""),
            bytes("")
        );

        bytes[] memory payloads = new bytes[](1);
        payloads[0] = payload;

        uint256 gasLimit = 1000000;

        uint256 gasPayment = hyperlaneOutputOracle.quoteGasPayment(
            inputChainId,
            hyperlaneInputOracle,
            gasLimit,
            bytes(""),
            address(outputSettler),
            payloads
        );

        hyperlaneOutputOracle.submit{ value: gasPayment }(
            inputChainId,
            hyperlaneInputOracle,
            gasLimit,
            bytes(""),
            address(outputSettler),
            payloads
        );

        vm.stopBroadcast();
    }
}
