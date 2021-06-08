// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

/// @author Brink
/// @title Executor access controller for Brink transactions
contract ExecutorAccessController {

  /// @dev owner of the contract
  address private owner;

  /// @dev Mapping of Executor address -> boolean (is an executor?)
  mapping(address => bool) public isExecutorMap;

  /// @dev Mapping of Admin address -> boolean (is an admin?)
  mapping(address => bool) public isAdminMap;

  /// @dev Mapping of Executor address -> Admin address (what admin added this executor)
  mapping(address => address) public executorAdminMap;

  /// Constructor, which stores the address of the owner
  /// @param _owner the specified owner address
  constructor(address _owner) {
    owner = _owner;
  }

  /// addAdmin, which allows owner to add an Admin
  /// @param _admin the specified Admin Addresss to add
  function addAdmin(address _admin) external onlyOwner {
    isAdminMap[_admin] = true;
  }

  /// removeAdmin, which allows owner to remove an Admin
  /// @param _admin the specified Admin Addresss to remove
  function removeAdmin(address _admin) external onlyOwner {
    isAdminMap[_admin] = false;
  }

  /// addExecutor, which allows an Admin to add an Executor
  /// @param _executor the specified Executor Addresss to add
  function addExecutor(address _executor) external onlyAdmin {
    require(executorAdminMap[_executor] == address(0), "ExecutorAccessController: Address given already has an admin associated with it");
    executorAdminMap[_executor] = msg.sender;
    isExecutorMap[_executor] = true;
  }

  /// removeExecutor, which allows an Admin to remove an Executor they added or Owner to remove any executor
  /// @param _executor the specified Executor Addresss to remove
  function removeExecutor(address _executor) external {
    require(_isExecutorOwner(_executor), "ExecutorAccessController: Address cannot remove an executor they did not add");
    _removeExecutor(_executor);
  }

  /// isExecutor, returns true if specified address is an Executor Address
  /// @param _executor the specified Executor Addresss
  /// @return bool if the address is an Executor Address
  function isExecutor(address _executor) external view returns(bool) {
    return _isExecutor(_executor);
  }

  /// @dev internal helper to check if specified address is an Executor Address
  function _isExecutor(address _executor) internal view returns (bool) {
    return isExecutorMap[_executor];
  }

  /// @dev internal helper to check if specified address is the Executor Owner
  function _isExecutorOwner(address _executor) internal view returns (bool) {
    return executorAdminMap[_executor] == msg.sender || owner == msg.sender;
  }

  /// isAdmin, returns true if specified address is an Admin Address
  /// @param _admin the specified Admin Address
  /// @return if the address is an Admin Address
  function isAdmin(address _admin) external view returns(bool) {
    return _isAdmin(_admin);
  }

  /// @dev internal helper to check if specified address is an Admin Address
  function _isAdmin(address _admin) internal view returns (bool) {
    return isAdminMap[_admin];
  }

  /// isOwner, returns true if specified address is the Owner Address
  /// @param _owner the specified Owner Address
  /// @return if the address is the Owner Address
  function isOwner(address _owner) external view returns(bool) {
    return owner == _owner;
  }

  /// @dev internal helper that does the work of removing an Executor Address with checks
  function _removeExecutor(address _executor) internal {
    executorAdminMap[_executor] = address(0);
    isExecutorMap[_executor] = false;
  }

  /// @dev modifier, checks address is the Owner
  modifier onlyOwner {
    require(
      msg.sender == owner,
      "ExecutorAccessController: Only the owner can call this function"
    );
    _;
  }

  /// @dev modifier, checks address is an Admin
  modifier onlyAdmin {
    require(
      isAdminMap[msg.sender],
      "ExecutorAccessController: Only an admin can call this function"
    );
    _;
  }

}