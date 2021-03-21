pragma solidity >=0.6.0 <0.7.0;


interface ISavingsContractV1 {
    function depositInterest(uint256 _amount) external virtual;

    function depositSavings(uint256 _amount) external virtual returns (uint256 creditsIssued);
    function redeem(uint256 _amount) external virtual returns (uint256 massetReturned);

    function exchangeRate() external virtual view returns (uint256);
    function creditBalances(address) external virtual view returns (uint256);
}

interface ISavingsContractV2 {

    // DEPRECATED but still backwards compatible
    function redeem(uint256 _amount) external virtual returns (uint256 massetReturned);
    function creditBalances(address) external virtual view returns (uint256); // V1 & V2 (use balanceOf)

    // --------------------------------------------

    function depositInterest(uint256 _amount) external virtual; // V1 & V2

    function depositSavings(uint256 _amount) external virtual returns (uint256 creditsIssued); // V1 & V2
    function depositSavings(uint256 _amount, address _beneficiary) external virtual returns (uint256 creditsIssued); // V2

    function redeemCredits(uint256 _amount) external virtual returns (uint256 underlyingReturned); // V2
    function redeemUnderlying(uint256 _amount) external virtual returns (uint256 creditsBurned); // V2

    function exchangeRate() external virtual view returns (uint256); // V1 & V2

    function balanceOfUnderlying(address _user) external virtual view returns (uint256 balance); // V2

    function underlyingToCredits(uint256 _credits) external virtual view returns (uint256 underlying); // V2
    function creditsToUnderlying(uint256 _underlying) external virtual view returns (uint256 credits); // V2

}