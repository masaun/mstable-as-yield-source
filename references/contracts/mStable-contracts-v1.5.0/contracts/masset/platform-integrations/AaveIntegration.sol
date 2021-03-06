pragma solidity 0.5.16;

import { IAaveATokenV1, IAaveLendingPoolV1, ILendingPoolAddressesProviderV1 } from "./IAave.sol";
import { InitializableAbstractIntegration, MassetHelpers, IERC20 } from "./InitializableAbstractIntegration.sol";


/**
 * @title   AaveIntegration
 * @author  Stability Labs Pty. Ltd.
 * @notice  A simple connection to deposit and withdraw bAssets from Aave
 * @dev     VERSION: 1.2
 *          DATE:    2020-12-24
 */
contract AaveIntegration is InitializableAbstractIntegration {

    /***************************************
                    CORE
    ****************************************/

    /**
     * @dev Deposit a quantity of bAsset into the platform. Credited aTokens
     *      remain here in the vault. Can only be called by whitelisted addresses
     *      (mAsset and corresponding BasketManager)
     * @param _bAsset              Address for the bAsset
     * @param _amount              Units of bAsset to deposit
     * @param _hasTxFee            Is the bAsset known to have a tx fee?
     * @return quantityDeposited   Quantity of bAsset that entered the platform
     */
    function deposit(
        address _bAsset,
        uint256 _amount,
        bool _hasTxFee
    )
        external
        onlyWhitelisted
        nonReentrant
        returns (uint256 quantityDeposited)
    {
        require(_amount > 0, "Must deposit something");
        // Get the Target token
        IAaveATokenV1 aToken = _getATokenFor(_bAsset);

        quantityDeposited = _amount;

        uint16 referralCode = 36; // temp code

        if(_hasTxFee) {
            // If we charge a fee, account for it
            uint256 prevBal = _checkBalance(aToken);
            _getLendingPool().deposit(_bAsset, _amount, referralCode);
            uint256 newBal = _checkBalance(aToken);
            quantityDeposited = _min(quantityDeposited, newBal.sub(prevBal));
        } else {
            // aTokens are 1:1 for each asset
            _getLendingPool().deposit(_bAsset, _amount, referralCode);
        }

        emit Deposit(_bAsset, address(aToken), quantityDeposited);
    }

    /**
     * @dev Withdraw a quantity of bAsset from the platform
     * @param _receiver     Address to which the bAsset should be sent
     * @param _bAsset       Address of the bAsset
     * @param _amount       Units of bAsset to send to recipient
     * @param _hasTxFee     Is the bAsset known to have a tx fee?
     */
    function withdraw(
        address _receiver,
        address _bAsset,
        uint256 _amount,
        bool _hasTxFee
    )
        external
        onlyWhitelisted
        nonReentrant
    {
        _withdraw(_receiver, _bAsset, _amount, _amount, _hasTxFee);
    }

    /**
     * @dev Withdraw a quantity of bAsset from the platform
     * @param _receiver     Address to which the bAsset should be sent
     * @param _bAsset       Address of the bAsset
     * @param _amount       Units of bAsset to send to recipient
     * @param _totalAmount  Total units to pull from lending platform
     * @param _hasTxFee     Is the bAsset known to have a tx fee?
     */
    function withdraw(
        address _receiver,
        address _bAsset,
        uint256 _amount,
        uint256 _totalAmount,
        bool _hasTxFee
    )
        external
        onlyWhitelisted
        nonReentrant
    {
        _withdraw(_receiver, _bAsset, _amount, _totalAmount, _hasTxFee);
    }

    function _withdraw(
        address _receiver,
        address _bAsset,
        uint256 _amount,
        uint256 _totalAmount,
        bool _hasTxFee
    )
        internal
    {
        require(_totalAmount > 0, "Must withdraw something");
        // Get the Target token
        IAaveATokenV1 aToken = _getATokenFor(_bAsset);

        uint256 userWithdrawal = _amount;

        // Don't need to Approve aToken, as it gets burned in redeem()
        if(_hasTxFee) {
            require(_amount == _totalAmount, "Cache inactive for assets with fee");
            IERC20 b = IERC20(_bAsset);
            uint256 prevBal = b.balanceOf(address(this));
            aToken.redeem(_amount);
            uint256 newBal = b.balanceOf(address(this));
            userWithdrawal = _min(userWithdrawal, newBal.sub(prevBal));
        } else {
            aToken.redeem(_totalAmount);
        }

        // Send redeemed bAsset to the receiver
        IERC20(_bAsset).safeTransfer(_receiver, userWithdrawal);

        emit PlatformWithdrawal(_bAsset, address(aToken), _totalAmount, userWithdrawal);
    }

    /**
     * @dev Withdraw a quantity of bAsset from the cache.
     * @param _receiver     Address to which the bAsset should be sent
     * @param _bAsset       Address of the bAsset
     * @param _amount       Units of bAsset to withdraw
     */
    function withdrawRaw(
        address _receiver,
        address _bAsset,
        uint256 _amount
    )
        external
        onlyWhitelisted
        nonReentrant
    {
        require(_amount > 0, "Must withdraw something");
        require(_receiver != address(0), "Must specify recipient");

        // Send redeemed bAsset to the receiver
        IERC20(_bAsset).safeTransfer(_receiver, _amount);

        emit Withdrawal(_bAsset, address(0), _amount);
    }

    /**
     * @dev Get the total bAsset value held in the platform
     *      This includes any interest that was generated since depositing
     *      Aave gradually increases the balances of all aToken holders, as the interest grows
     * @param _bAsset     Address of the bAsset
     * @return balance    Total value of the bAsset in the platform
     */
    function checkBalance(address _bAsset)
        external
        returns (uint256 balance)
    {
        // balance is always with token aToken decimals
        IAaveATokenV1 aToken = _getATokenFor(_bAsset);
        return _checkBalance(aToken);
    }

    /***************************************
                    APPROVALS
    ****************************************/

    /**
     * @dev Re-approve the spending of all bAssets by the Aave lending pool core,
     *      if for some reason is it necessary for example if the address of core changes.
     *      Only callable through Governance.
     */
    function reApproveAllTokens()
        external
        onlyGovernor
    {
        uint256 bAssetCount = bAssetsMapped.length;
        address lendingPoolVault = _getLendingPoolCore();
        // approve the pool to spend the bAsset
        for(uint i = 0; i < bAssetCount; i++){
            MassetHelpers.safeInfiniteApprove(bAssetsMapped[i], lendingPoolVault);
        }
    }

    /**
     * @dev Internal method to respond to the addition of new bAsset / pTokens
     *      We need to approve the Aave lending pool core conrtact and give it permission
     *      to spend the bAsset
     * @param _bAsset Address of the bAsset to approve
     */
    function _abstractSetPToken(address _bAsset, address /*_pToken*/)
        internal
    {
        address lendingPoolVault = _getLendingPoolCore();
        // approve the pool to spend the bAsset
        MassetHelpers.safeInfiniteApprove(_bAsset, lendingPoolVault);
    }

    /***************************************
                    HELPERS
    ****************************************/

    /**
     * @dev Get the current address of the Aave lending pool, which is the gateway to
     *      depositing.
     * @return Current lending pool implementation
     */
    function _getLendingPool()
        internal
        view
        returns (IAaveLendingPoolV1)
    {
        address lendingPool = ILendingPoolAddressesProviderV1(platformAddress).getLendingPool();
        require(lendingPool != address(0), "Lending pool does not exist");
        return IAaveLendingPoolV1(lendingPool);
    }

    /**
     * @dev Get the current address of the Aave lending pool core, which stores all the
     *      reserve tokens in its vault.
     * @return Current lending pool core address
     */
    function _getLendingPoolCore()
        internal
        view
        returns (address payable)
    {
        address payable lendingPoolCore = ILendingPoolAddressesProviderV1(platformAddress).getLendingPoolCore();
        require(lendingPoolCore != address(uint160(address(0))), "Lending pool core does not exist");
        return lendingPoolCore;
    }

    /**
     * @dev Get the pToken wrapped in the IAaveATokenV1 interface for this bAsset, to use
     *      for withdrawing or balance checking. Fails if the pToken doesn't exist in our mappings.
     * @param _bAsset  Address of the bAsset
     * @return aToken  Corresponding to this bAsset
     */
    function _getATokenFor(address _bAsset)
        internal
        view
        returns (IAaveATokenV1)
    {
        address aToken = bAssetToPToken[_bAsset];
        require(aToken != address(0), "aToken does not exist");
        return IAaveATokenV1(aToken);
    }

    /**
     * @dev Get the total bAsset value held in the platform
     * @param _aToken     aToken for which to check balance
     * @return balance    Total value of the bAsset in the platform
     */
    function _checkBalance(IAaveATokenV1 _aToken)
        internal
        view
        returns (uint256 balance)
    {
        return _aToken.balanceOf(address(this));
    }
}