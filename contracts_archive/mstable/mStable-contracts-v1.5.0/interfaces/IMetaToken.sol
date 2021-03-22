pragma solidity >=0.6.0 <0.7.0;

/**
 * @title IMetaToken
 * @dev Interface for MetaToken
 */
interface IMetaToken {
    /** @dev Basic ERC20 funcs */
    function name() external virtual view returns (string memory);
    function symbol() external virtual view returns (string memory);
    function decimals() external virtual view returns (uint8);
    function totalSupply() external virtual view returns (uint256);
    function balanceOf(address account) external virtual view returns (uint256);
    function transfer(address recipient, uint256 amount) external virtual returns (bool);
    function allowance(address owner, address spender) external virtual view returns (uint256);
    function approve(address spender, uint256 amount) external virtual returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external virtual returns (bool);

    /** @dev Burnable */
    function burn(uint256 amount) external virtual;
    function burnFrom(address account, uint256 amount) external virtual;

    /** @dev Mintable */
    function mint(address account, uint256 amount) external virtual returns (bool);
}
