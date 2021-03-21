// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.7.0;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";

import { IYieldSource } from "./pooltogether/protocol-yield-source-interface/IYieldSource.sol";


/// @title Defines the functions used to interact with a yield source.  The Prize Pool inherits this contract.
/// @dev THIS CONTRACT IS EXPERIMENTAL!  USE AT YOUR OWN RISK
/// @notice Prize Pools subclasses need to implement this interface so that yield can be generated.
contract SushiLpYieldSource is IYieldSource {

   using SafeMath for uint256;

    event SushiLpYieldSourceInitialized(address indexed sushiLpToken);

    /// @notice - Sushi LP balance (SLP balance)
    mapping(address => uint256) public balances;

    /// @notice - Interface for the SushiToken and the SushiBar (xSushi) of SushiSwap
    ISushiToken public sushi;
    IERC20 public lpToken;  /// [Note]: This is Sushi LP Token (SLP Token)

    address SUSHI;
    address LP_TOKEN;

    /// @notice Initializes the Yield Service with the Sushi
    constructor (
        ISushiToken _sushiToken,
        IERC20 _lpToken
    )
      public
    {
        sushi = _sushiToken;
        lpToken = _lpToken;
        SUSHI = address(sushi);
        LP_TOKEN = address(lpToken);

        emit LpYieldSourceInitialized(address(lpToken));
    }

    /// @notice Returns the ERC20 asset token used for deposits.
    /// @return address of Sushi LP Token (SLP) to be deposited
    function token() public override view returns (address) {
        return LP_TOKEN;  /// Sushi LP Token (SLP Token)
    }

    /// @notice Returns the total balance (in asset tokens).  This includes the deposits and interest.
    /// @return The underlying (SushiToken) balance of asset tokens (Sushi LP Token)
    function balanceOf(address addr) external override returns (uint256) {
        uint256 lpTokenBalance = lpToken.balanceOf(address(this));
        uint256 lpTokenTotalSupply = lpToken.totalSupply();

        /// Calculate SushiToken balance of this contract
        uint256 sushiBalance = sushi.balanceOf(XSUSHI).mul(lpTokenBalance).div(sushiLpTokenTotalSupply);

        return balances[addr].mul(sushiBalance).div(xSushiTotalSupply);
    }

    /// @notice Supplies asset tokens to the yield source.
    /// @param depositAmount The minted-amount of asset tokens to be supplied
    /// @param to The account to be credited
    function supplyTo(uint256 depositAmount, address to) external override {
        /// Sushi LP TOken is transferred from a user (msg.sender) to this contract
        sushiLpToken.transferFrom(msg.sender, address(this), depositAmount);

        uint256 xSushiBalanceBefore = xSushi.balanceOf(address(this));

        sushi.approve(XSUSHI, depositAmount);  /// [Note]: xSushi is also SushiBar contract
        xSushi.enter(depositAmount);
        uint256 xSushiBalanceAfter = xSushi.balanceOf(address(this));

        /// Calculate difference of xSushi balance
        uint256 xSushiDiff = xSushiBalanceAfter.sub(xSushiBalanceBefore);

        /// Update xSushi balance of an account ("to" address)
        balances[to] = balances[to].add(xSushiDiff);
    }

    /// @notice Redeems asset tokens from the yield source.
    /// @param redeemAmount The amount of yield-bearing tokens to be redeemed
    /// @return The actual amount of tokens that were redeemed.
    function redeem(uint256 redeemAmount) external override returns (uint256) {
        uint256 xSushiTotalSupply = xSushi.totalSupply();
        uint256 sushiBalanceOfSushiBar = sushi.balanceOf(XSUSHI);

        /// Calculate shares to be redeemed
        uint256 redeemedShares = redeemAmount.mul(xSushiTotalSupply).div(sushiBalanceOfSushiBar);

        uint256 xSushiBalanceBefore = xSushi.balanceOf(address(this));
        uint256 sushiBalanceBefore = sushi.balanceOf(address(this));

        xSushi.leave(redeemedShares);

        uint256 xSushiBalanceAfter = xSushi.balanceOf(address(this));
        uint256 sushiBalanceAfter = sushi.balanceOf(address(this));

        /// Calculate difference of each token balance
        uint256 xSushiBalanceDiff = xSushiBalanceBefore.sub(xSushiBalanceAfter);        
        uint256 sushiBalanceDiff = sushiBalanceAfter.sub(sushiBalanceBefore);

        /// Update xSushi balance of a user (msg.sender)
        balances[msg.sender] = balances[msg.sender].sub(xSushiBalanceDiff);

        /// Transfer diff of SushiToken balance into a user (msg.sender)
        sushi.transfer(msg.sender, sushiBalanceDiff);
        return sushiBalanceDiff;
    }
}
