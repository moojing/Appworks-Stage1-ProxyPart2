// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import { Proxy } from "./Proxy/Proxy.sol";
import { Slots } from "./SlotManipulate.sol";

contract BasicProxy is Proxy, Slots {

  constructor(address _implementation) {
  }

  fallback() external payable virtual {
  }

  receive() external payable {}

  function upgradeTo(address _newImpl) public virtual {
  }

  function upgradeToAndCall(address _newImpl, bytes memory data) public virtual {
  }
}