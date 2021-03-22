pragma solidity >=0.6.0 <0.7.0;

/**
  * @title INexus
  * @dev Basic interface for interacting with the Nexus i.e. SystemKernel
  */
interface INexus {
    function governor() external virtual view returns (address);
    function getModule(bytes32 key) external virtual view returns (address);

    function proposeModule(bytes32 _key, address _addr) external virtual;
    function cancelProposedModule(bytes32 _key) external virtual;
    function acceptProposedModule(bytes32 _key) external virtual;
    function acceptProposedModules(bytes32[] calldata _keys) external virtual;

    function requestLockModule(bytes32 _key) external virtual;
    function cancelLockModule(bytes32 _key) external virtual;
    function lockModule(bytes32 _key) external virtual;
}
