//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Test Token Contract
/// @author Bru-finance team
/// @notice ERC20 standard test token
contract TestToken is ERC20 {
    uint256 internal MAX_INT = 2**256 - 1;

    /// @notice Mints token while contract deployed
    /// @param initialSupply The amount of token to be minted
    constructor(uint256 initialSupply) ERC20("USD Tether", "USDT") {
        _mint(msg.sender, initialSupply);
    }

    /// @notice Mints specified amount of tokens
    /// @param _address The address of the user
    /// @param amount The amount of token to mint
    function mint(address _address, uint256 amount) public {
        _mint(_address, amount);
    }

    /// @notice Burns specified amount of tokens
    /// @param _address The address of the user
    /// @param amount The amount of token to be burned
    function burn(address _address, uint256 amount) public {
        _burn(_address, amount);
    }

    /// @notice Approves a tokens which can be used by other address
    /// @param _address The address of the user
    function approveTokensForTransfer(address _address) public {
        approve(_address, MAX_INT);
    }
}