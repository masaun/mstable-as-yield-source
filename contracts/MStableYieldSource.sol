// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.7.0;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";

import { IYieldSource } from "./pooltogether/protocol-yield-source-interface/IYieldSource.sol";

import { IMasset } from "./mstable/mStable-contracts-v2.0.0/interfaces/IMasset.sol";
//import { IMStableHelper } from "./mstable/mStable-contracts-v2.0.0/interfaces/IMStableHelper.sol";
import { ISavingsContractV2 } from "./mstable/mStable-contracts-v2.0.0/interfaces/ISavingsContract.sol";


/// @title Defines the functions used to interact with a yield source. The Prize Pool inherits this contract.
/// @dev THIS CONTRACT IS EXPERIMENTAL!  USE AT YOUR OWN RISK
/// @notice Prize Pools subclasses need to implement this interface so that yield can be generated.
contract MStableYieldSource is IYieldSource {
    using SafeMath for uint256;

    event MAssetYieldSourceInitialized(address indexed cToken);

    mapping(address => uint256) public balances;

    /// @notice Interface for the Yield-bearing mUSD by mStable
    IERC20 public mUSD;     /// [Note]: On the assumption that mUSD is minted from the minting page in advance
    IMasset public mAsset;
    ISavingsContractV2 public save;
    //IMStableHelper public helper;

    address MUSD;
    address SAVE;

    /// @notice Initializes the Yield Service with the Compound cToken
    /// @param _mAsset Address of the Compound cToken interface
    constructor (IERC20 _mUSD, IMasset _mAsset, ISavingsContractV2 _save) public {
        mUSD = _mUSD;
        mAsset = _mAsset;
        save = _save;

        MUSD = address(mUSD);
        SAVE = address(save);

        emit MAssetYieldSourceInitialized(address(mUSD));
    }

    /// @notice Returns the ERC20 asset token used for deposits.
    /// @return address of mUSD to be deposited
    function token() public override view returns (address) {
        return MUSD;
    }

    /// @notice Returns the total balance (in asset tokens).  This includes the deposits and interest.
    /// @return The underlying (mUSD) balance of asset tokens (saved-mUSD)
    function balanceOf(address addr) external override returns (uint256) {
        uint256 totalUnderlying = save.balanceOfUnderlying(address(this));
        uint256 total = save.creditBalances(address(this));
        return balances[addr].mul(totalUnderlying).div(total);
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

