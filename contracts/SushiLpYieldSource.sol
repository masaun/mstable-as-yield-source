// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.7.0;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";

import { IYieldSource } from "./pooltogether/protocol-yield-source-interface/IYieldSource.sol";


/// @title Defines the functions used to interact with a yield source.  The Prize Pool inherits this contract.
/// @dev THIS CONTRACT IS EXPERIMENTAL!  USE AT YOUR OWN RISK
/// @notice Prize Pools subclasses need to implement this interface so that yield can be generated.
contract SushiLpYieldSource is IYieldSource {

    constructor() public {
        /// [Todo]:
    }

}
