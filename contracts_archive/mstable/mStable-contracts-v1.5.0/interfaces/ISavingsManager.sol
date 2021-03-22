pragma solidity >=0.6.0 <0.7.0;

/**
 * @title ISavingsManager
 */
interface ISavingsManager {

    /** @dev Admin privs */
    function distributeUnallocatedInterest(address _mAsset) external virtual;

    /** @dev Liquidator */
    function depositLiquidation(address _mAsset, uint256 _liquidation) external virtual;

    /** @dev Liquidator */
    function collectAndStreamInterest(address _mAsset) external virtual;

    /** @dev Public privs */
    function collectAndDistributeInterest(address _mAsset) external virtual;
}

interface IRevenueRecipient {

    /** @dev Recipient */
    function notifyRedistributionAmount(address _mAsset, uint256 _amount) external virtual;
}
