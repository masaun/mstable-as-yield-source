pragma solidity >=0.6.0 <0.7.0;

/**
 * @title Platform interface to integrate with lending platform like Compound, AAVE etc.
 */
interface IPlatformIntegration {

    /**
     * @dev Deposit the given bAsset to Lending platform
     * @param _bAsset bAsset address
     * @param _amount Amount to deposit
     */
    function deposit(address _bAsset, uint256 _amount, bool isTokenFeeCharged)
        external virtual returns (uint256 quantityDeposited);

    /**
     * @dev Withdraw given bAsset from Lending platform
     */
    function withdraw(address _receiver, address _bAsset, uint256 _amount, bool _hasTxFee) external virtual;

    /**
     * @dev Withdraw given bAsset from Lending platform
     */
    function withdraw(address _receiver, address _bAsset, uint256 _amount, uint256 _totalAmount, bool _hasTxFee) external virtual;

    /**
     * @dev Withdraw given bAsset from the cache
     */
    function withdrawRaw(address _receiver, address _bAsset, uint256 _amount) external virtual;

    /**
     * @dev Returns the current balance of the given bAsset
     */
    function checkBalance(address _bAsset) external virtual returns (uint256 balance);

    /**
     * @dev Returns the pToken
     */
    function bAssetToPToken(address _bAsset) external virtual returns (address pToken);
}
