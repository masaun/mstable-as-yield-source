// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MUSDToken is ERC20 {
    constructor() public ERC20("mUSD", "MUSD") {
        uint256 initialSupply = 1e8 * 1e18;  /// 1 milion
        _mint(msg.sender, initialSupply);
    }
}
