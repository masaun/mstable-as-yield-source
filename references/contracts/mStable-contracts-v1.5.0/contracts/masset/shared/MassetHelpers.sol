pragma solidity 0.5.16;

import { StableMath } from "../../shared/StableMath.sol";
import { SafeMath }  from "@openzeppelin/contracts/math/SafeMath.sol";
import { SafeERC20 }  from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import { IERC20 }     from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title   MassetHelpers
 * @author  Stability Labs Pty. Ltd.
 * @notice  Helper functions to facilitate minting and redemption from off chain
 * @dev     VERSION: 1.0
 *          DATE:    2020-03-28
 */
library MassetHelpers {

    using StableMath for uint256;
    using SafeMath for uint256;
    using SafeERC20 for IERC20;


    function transferReturnBalance(
        address _sender,
        address _recipient,
        address _basset,
        uint256 _qty
    )
        internal
        returns (uint256 receivedQty, uint256 recipientBalance)
    {
        uint256 balBefore = IERC20(_basset).balanceOf(_recipient);
        IERC20(_basset).safeTransferFrom(_sender, _recipient, _qty);
        recipientBalance = IERC20(_basset).balanceOf(_recipient);
        receivedQty = StableMath.min(_qty, recipientBalance.sub(balBefore));
    }

    function safeInfiniteApprove(address _asset, address _spender)
        internal
    {
        IERC20(_asset).safeApprove(_spender, 0);
        IERC20(_asset).safeApprove(_spender, uint256(-1));
    }
}
