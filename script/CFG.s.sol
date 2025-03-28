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
        uint256 initialMint = 100; // TODO
        address mintDestination = address(1); // TODO
        address initialOwner = 0x423420Ae467df6e90291fd0252c0A8a637C1e03f; // TODO

        // Deployment
        bytes32 salt = 0x423420ae467df6e90291fd0252c0a8a637c1e03f01c1f98b4f75aa1802aea7ff;
        CFG cfg = CFG(create3(salt, abi.encodePacked(type(CFG).creationCode, abi.encode(initialOwner))));
        require(address(cfg) == 0xcCcCccC55c2C57F0FB3bdEd4635Cd41b3Bf1b2DD);

        // Setup
        cfg.mint(mintDestination, initialMint);
        cfg.deny(address(this));

        vm.stopBroadcast();
    }
}
