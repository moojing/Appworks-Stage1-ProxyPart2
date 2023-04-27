// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import { Slots } from "./SlotManipulate.sol";
import { BasicProxy } from "./BasicProxy.sol";

error Transparent__NotAdmin();

contract Transparent is Slots, BasicProxy {

  bytes32 public constant ADMIN_SLOT = bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1);

  constructor(address _implementation) BasicProxy(_implementation) {
    _setSlotToAddress(ADMIN_SLOT, msg.sender);
  }

  modifier onlyAdmin {
    require(msg.sender == _getAdmin(), "Transparent: not admin");
    _;
  }

  function _getAdmin() internal view returns (address) {
    return _getSlotToAddress(ADMIN_SLOT);
  }

  function upgradeTo(address _newImpl) public override onlyAdmin {
    super.upgradeTo(_newImpl);
  }

  function upgradeToAndCall(address _newImpl, bytes memory data) public override onlyAdmin {
    super.upgradeToAndCall(_newImpl, data);
  }

  fallback() external payable override {
    if (msg.sender == _getAdmin()) {
      revert();
    } else {
      _delegate(_getImpl());
    }
  }
}