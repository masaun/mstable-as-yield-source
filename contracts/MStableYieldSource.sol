// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.7.0;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";

import { IYieldSource } from "./pooltogether/protocol-yield-source-interface/IYieldSource.sol";


/// @title Defines the functions used to interact with a yield source.  The Prize Pool inherits this contract.
/// @dev THIS CONTRACT IS EXPERIMENTAL!  USE AT YOUR OWN RISK
/// @notice Prize Pools subclasses need to implement this interface so that yield can be generated.
contract MStableYieldSource is IYieldSource {

    constructor() public {
        /// [Todo]:
    }

    /// @notice Returns the ERC20 asset token used for deposits.
    /// @return address of SushiToken to be deposited
    function token() public override view returns (address) {
        address testAddr;
        return testAddr;
    }

    /// @notice Returns the total balance (in asset tokens).  This includes the deposits and interest.
    /// @return The underlying (SushiToken) balance of asset tokens (xSushi)
    function balanceOf(address addr) external override returns (uint256) {
        uint256 test;
        return test;
    }

    /// @notice Supplies asset tokens to the yield source.
    /// @param depositAmount The minted-amount of asset tokens to be supplied
    /// @param to The account to be credited
    function supplyTo(uint256 depositAmount, address to) external override {
        /// SushiToken is transferred from a user (msg.sender) to this contract
        uint256 test;
    }

    /// @notice Redeems asset tokens from the yield source.
    /// @param redeemAmount The amount of yield-bearing tokens to be redeemed
    /// @return The actual amount of tokens that were redeemed.
    function redeem(uint256 redeemAmount) external override returns (uint256) {
        uint256 test;
        return test;
    }

}

