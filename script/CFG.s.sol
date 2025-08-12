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
        address initialOwner = 0x8b83962fB9dB346a20c95D98d4E312f17f4C0d9b;

        // Deployment
        bytes32 salt = 0x7270b20603fbb3df0921381670fbd62b9991ada4005d46c19eec362902ac385f;
        CFG cfg = CFG(create3(salt, abi.encodePacked(type(CFG).creationCode, abi.encode(msg.sender))));
        require(address(cfg) == 0xcccCCCcCCC33D538DBC2EE4fEab0a7A1FF4e8A94);

        // Setup
        cfg.rely(initialOwner);
        cfg.deny(msg.sender);

        vm.stopBroadcast();
    }
}
