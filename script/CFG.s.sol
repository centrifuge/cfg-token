// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.28;

import {CFG} from "src/CFG.sol";

import "forge-std/Script.sol";
import {CreateXScript} from "createx-forge/script/CreateXScript.sol";

// Script to deploy the CFG token
contract CFGScript is Script, CreateXScript {
    function setUp() public withCreateX {}

    function run() public {
        vm.startBroadcast();

        // Parameters
        uint256 initialMint = 115_000_000e6;
        address mintDestination = 0x30d3bbAE8623d0e9C0db5c27B82dCDA39De40997;
        address initialOwner = 0x0C1fDfd6a1331a875EA013F3897fc8a76ada5DfC;

        // Deployment
        bytes32 salt = 0x7270b20603fbb3df0921381670fbd62b9991ada400b1c499ec4040ff037c0ea5;
        CFG cfg = CFG(create3(salt, abi.encodePacked(type(CFG).creationCode, abi.encode(initialOwner))));
        require(address(cfg) == 0xCCCCccCCCCce608916f3eeB1D09E1D8B8246DC4A);

        // Setup
        cfg.mint(mintDestination, initialMint);
        cfg.deny(address(this));

        vm.stopBroadcast();
    }
}
