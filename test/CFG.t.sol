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

    function testMint(address nonWard, address destination, uint256 mintAmount) public {
        vm.assume(nonWard != address(this));
        vm.assume(destination != address(this) && destination != address(0));

        CFG token = new CFG();

        assertEq(token.wards(address(this)), 1);
        assertEq(token.wards(nonWard), 0);

        vm.prank(nonWard);
        vm.expectRevert(IAuth.NotAuthorized.selector);
        token.mint(destination, mintAmount);

        assertEq(token.balanceOf(destination), 0);

        vm.prank(address(this));
        token.mint(destination, mintAmount);

        assertEq(token.balanceOf(destination), mintAmount);
    }

    function testBurn(address nonWard, uint256 mintAmount, uint256 burnAmount) public {
        vm.assume(nonWard != address(this));
        burnAmount = bound(burnAmount, 0, mintAmount);

        CFG token = new CFG();

        assertEq(token.wards(address(this)), 1);
        assertEq(token.wards(nonWard), 0);

        token.mint(address(this), mintAmount);
        assertEq(token.balanceOf(address(this)), mintAmount);

        vm.prank(nonWard);
        vm.expectRevert(IAuth.NotAuthorized.selector);
        token.burn(address(this), burnAmount);

        token.burn(address(this), burnAmount);
        assertEq(token.balanceOf(address(this)), mintAmount - burnAmount);
    }

    function testDelegateVotingPower(
        uint256 mintAmount,
        uint256 transferAmount,
        uint256 transferFromAmount,
        uint256 burnAmount,
        address delegatee,
        address user2,
        address delegatee2
    ) public {
        vm.assume(delegatee != address(this) && delegatee != address(0));
        vm.assume(user2 != delegatee && user2 != address(this) && user2 != address(0));
        vm.assume(
            delegatee2 != delegatee && delegatee2 != user2 && delegatee2 != address(this) && delegatee2 != address(0)
        );
        transferAmount = bound(transferAmount, 0, mintAmount);
        transferFromAmount = bound(transferFromAmount, 0, mintAmount - transferAmount);
        burnAmount = bound(burnAmount, 0, mintAmount - transferAmount - transferFromAmount);

        CFG token = new CFG();

        token.mint(address(this), mintAmount);
        assertEq(token.balanceOf(address(this)), mintAmount);

        assertEq(token.delegatee(address(this)), address(0));
        assertEq(token.delegatee(user2), address(0));
        assertEq(token.delegatedVotingPower(address(this)), 0);
        assertEq(token.delegatedVotingPower(delegatee2), 0);

        token.delegate(delegatee);
        vm.prank(user2);
        token.delegate(delegatee2);

        assertEq(token.delegatee(address(this)), delegatee);
        assertEq(token.delegatee(user2), delegatee2);
        assertEq(token.delegatedVotingPower(delegatee), mintAmount);
        assertEq(token.delegatedVotingPower(delegatee2), 0);

        token.transfer(user2, transferAmount);

        assertEq(token.delegatee(address(this)), delegatee);
        assertEq(token.delegatee(user2), delegatee2);
        assertEq(token.delegatedVotingPower(delegatee), mintAmount - transferAmount);
        assertEq(token.delegatedVotingPower(delegatee2), transferAmount);

        token.transferFrom(address(this), user2, transferFromAmount);

        assertEq(token.delegatee(address(this)), delegatee);
        assertEq(token.delegatee(user2), delegatee2);
        assertEq(token.delegatedVotingPower(delegatee), mintAmount - transferAmount - transferFromAmount);
        assertEq(token.delegatedVotingPower(delegatee2), transferAmount + transferFromAmount);

        token.burn(address(this), burnAmount);

        assertEq(token.delegatee(address(this)), delegatee);
        assertEq(token.delegatee(user2), delegatee2);
        assertEq(token.delegatedVotingPower(delegatee), mintAmount - transferAmount - transferFromAmount - burnAmount);
        assertEq(token.delegatedVotingPower(delegatee2), transferAmount + transferFromAmount);
    }
}
