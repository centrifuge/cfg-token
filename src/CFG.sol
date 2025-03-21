// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.28;

import {DelegationToken} from "src/DelegationToken.sol";

/// @title  Centrifuge Token
contract CFG is DelegationToken {
    constructor(address ward) DelegationToken(18) {
        file("name", "Centrifuge");
        file("symbol", "CFG");
        rely(ward);
    }

    /// @notice Burns sender's tokens.
    function burn(uint256 value) external {
        uint256 balance = balanceOf(msg.sender);
        require(balance >= value, InsufficientBalance());

        unchecked {
            // We don't need overflow checks b/c require(balance >= value) and balance <= totalSupply
            _setBalance(msg.sender, _balanceOf(msg.sender) - value);
            totalSupply = totalSupply - value;
        }

        emit Transfer(msg.sender, address(0), value);
    }
}
