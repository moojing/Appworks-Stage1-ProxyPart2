// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import { Proxy } from "./Proxy/Proxy.sol";
import { Slots } from "./SlotManipulate.sol";

contract BasicProxy is Proxy, Slots {
  bytes32 constant IMPLEMENTATION_SLOT = bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1);

  constructor(address _implementation) {
    _setSlotToAddress(IMPLEMENTATION_SLOT, _implementation);
  }

  function _getImpl() internal view returns (address impl) {
    impl = _getSlotToAddress(IMPLEMENTATION_SLOT);
  }

  fallback() external payable virtual {
    _delegate(_getImpl());
  }

  receive() external payable {}

  function upgradeTo(address _newImpl) public virtual {
    _setSlotToAddress(IMPLEMENTATION_SLOT, _newImpl);
  }

  function upgradeToAndCall(address _newImpl, bytes memory data) public virtual {
    _setSlotToAddress(IMPLEMENTATION_SLOT, _newImpl);
    (bool success, ) = _newImpl.delegatecall(data);
    require(success);
  }
}