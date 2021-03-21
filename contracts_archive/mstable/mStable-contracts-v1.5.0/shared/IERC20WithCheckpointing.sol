pragma solidity >=0.6.0 <0.7.0;

// From https://github.com/aragonone/voting-connectors
contract IERC20WithCheckpointing {
    function balanceOf(address _owner) public virtual view returns (uint256);
    function balanceOfAt(address _owner, uint256 _blockNumber) public virtual view returns (uint256);

    function totalSupply() public virtual view returns (uint256);
    function totalSupplyAt(uint256 _blockNumber) public virtual view returns (uint256);
}
