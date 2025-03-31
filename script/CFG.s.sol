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
        uint256 initialMint = 115_000_000e18;
        address mintDestination = 0x30d3bbAE8623d0e9C0db5c27B82dCDA39De40997;
        address initialOwner = 0x0C1fDfd6a1331a875EA013F3897fc8a76ada5DfC;

        // Deployment
        bytes32 salt = 0x7270b20603fbb3df0921381670fbd62b9991ada400a9053bef30e0a10398b302;
        CFG cfg = CFG(create3(salt, abi.encodePacked(type(CFG).creationCode, abi.encode(msg.sender))));
        require(address(cfg) == 0xCCCCcCCCcc111a3d376dACAd7DA330fE751cd9EA);

        // Setup
        cfg.mint(mintDestination, initialMint);
        cfg.deny(initialOwner);
        cfg.deny(msg.sender);

        vm.stopBroadcast();
    }
}
