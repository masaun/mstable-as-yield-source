pragma solidity >=0.6.0 <0.7.0;
pragma experimental ABIEncoderV2;

import { MassetStructs } from "../masset/shared/MassetStructs.sol";

/**
 * @title   IBasketManager
 * @dev     (Internal) Interface for interacting with BasketManager
 *          VERSION: 1.0
 *          DATE:    2020-05-05
 */
contract IBasketManager is MassetStructs {

    /** @dev Setters for mAsset to update balances */
    function increaseVaultBalance(
        uint8 _bAsset,
        address _integrator,
        uint256 _increaseAmount) external virtual;
    function increaseVaultBalances(
        uint8[] calldata _bAsset,
        address[] calldata _integrator,
        uint256[] calldata _increaseAmount) external virtual;
    function decreaseVaultBalance(
        uint8 _bAsset,
        address _integrator,
        uint256 _decreaseAmount) external virtual;
    function decreaseVaultBalances(
        uint8[] calldata _bAsset,
        address[] calldata _integrator,
        uint256[] calldata _decreaseAmount) external virtual;
    function collectInterest() external virtual 
        returns (uint256 interestCollected, uint256[] memory gains);

    /** @dev Setters for Gov to update Basket composition */
    function addBasset(
        address _basset,
        address _integration,
        bool _isTransferFeeCharged) external virtual returns (uint8 index);
    function setBasketWeights(address[] calldata _bassets, uint256[] calldata _weights) external virtual;
    function setTransferFeesFlag(address _bAsset, bool _flag) external virtual;

    /** @dev Getters to retrieve Basket information */
    function getBasket() external virtual view returns (Basket memory b);
    function prepareForgeBasset(address _token, uint256 _amt, bool _mint) external virtual
        returns (bool isValid, BassetDetails memory bInfo);
    function prepareSwapBassets(address _input, address _output, bool _isMint) external virtual view
        returns (bool, string memory, BassetDetails memory, BassetDetails memory);
    function prepareForgeBassets(address[] calldata _bAssets, uint256[] calldata _amts, bool _mint) external virtual
        returns (ForgePropsMulti memory props);
    function prepareRedeemBassets(address[] calldata _bAssets) external virtual view
        returns (RedeemProps memory props);
    function prepareRedeemMulti() external virtual view
        returns (RedeemPropsMulti memory props);
    function getBasset(address _token) external virtual view
        returns (Basset memory bAsset);
    function getBassets() external virtual view
        returns (Basset[] memory bAssets, uint256 len);
    function paused() external virtual view returns (bool);

    /** @dev Recollateralisation */
    function handlePegLoss(address _basset, bool _belowPeg) external virtual returns (bool actioned);
    function negateIsolation(address _basset) external virtual;
}
