// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.7.0;

import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import { SafeMathUpgradeable } from "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import { IERC20Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import { FixedPoint } from "@pooltogether/fixed-point/contracts/FixedPoint.sol";

import { PrizePool } from "./pooltogether/pooltogether-pool-contracts/prize-pool/PrizePool.sol";
import { RegistryInterface } from "./pooltogether/pooltogether-pool-contracts/registry/RegistryInterface.sol";
import { ControlledTokenInterface } from "./pooltogether/pooltogether-pool-contracts/token/ControlledTokenInterface.sol";


/// @title Prize Pool with Sushi LP Token (SLP)
/// @notice Manages depositing and withdrawing assets from the Prize Pool
contract SushiLpPrizePool is PrizePool {

    constructor() public {
        /// [Todo]:
    }

}
