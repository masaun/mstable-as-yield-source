pragma solidity >=0.7.0 <0.8.0;

import { RNGInterface } from "@pooltogether/pooltogether-rng-contracts/contracts/RNGInterface.sol";

contract RNGMStableHarness is RNGInterface {
    uint256 internal random;
    address internal feeToken;
    uint256 internal requestFee;

    /// @notice Gets the last request id used by the RNG service
    function getLastRequestId() external view override returns (uint32 requestId) {
        uint32 _requestId = 1;
        return _requestId;
    }

    function setRequestFee(address _feeToken, uint256 _requestFee) external {
        feeToken = _feeToken;
        requestFee = _requestFee;
    }

    function getRequestFee() external view override returns (address feeToken, uint256 requestFee) {
        address _feeToken;
        uint256 _requestFee;
        return (_feeToken, _requestFee);
    }

    function setRandomNumber(uint256 _random) external {
        random = _random;
    }

    function requestRandomNumber() external override returns (uint32 requestId, uint32 lockBlock) {
        return (1, 1);
    }

    function isRequestComplete(uint32) external view override returns (bool isCompleted) {
        bool _isCompleted = true;
        return _isCompleted;
    }

    function randomNumber(uint32 requestId) external override returns (uint256 randomNum) {
        uint256 _randomNum;
        return _randomNum;
    }
}
