// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.28;

import {CFG} from "src/CFG.sol";
import {IAuth} from "centrifuge/protocol-v3/src/misc/interfaces/IAuth.sol";
import "forge-std/Test.sol";

contract CFGTest is Test {
    function testDeployment() public {
        CFG token = new CFG();

        assertEq(token.name(), "Centrifuge");
        assertEq(token.symbol(), "CFG");
        assertEq(token.decimals(), 18);
    }

    function testMint(address nonWard, address destination, uint256 amount) public {
        vm.assume(nonWard != address(this));
        vm.assume(destination != address(this) && destination != address(0));

        CFG token = new CFG();

        assertEq(token.wards(address(this)), 1);
        assertEq(token.wards(nonWard), 0);

        vm.prank(nonWard);
        vm.expectRevert(IAuth.NotAuthorized.selector);
        token.mint(destination, amount);

        assertEq(token.balanceOf(destination), 0);

        vm.prank(address(this));
        token.mint(destination, amount);

        assertEq(token.balanceOf(destination), amount);
    }

    function testBurn(address nonWard, uint256 amountToMint, uint256 amountToBurn) public {
        vm.assume(nonWard != address(this));
        amountToBurn = bound(amountToBurn, 0, amountToMint);

        CFG token = new CFG();

        assertEq(token.wards(address(this)), 1);
        assertEq(token.wards(nonWard), 0);

        vm.prank(address(this));
        token.mint(address(this), amountToMint);

        assertEq(token.balanceOf(address(this)), amountToMint);

        vm.prank(nonWard);
        vm.expectRevert(IAuth.NotAuthorized.selector);
        token.burn(address(this), amountToBurn);

        token.burn(address(this), amountToBurn);

        assertEq(token.balanceOf(address(this)), amountToMint - amountToBurn);
    }
}
