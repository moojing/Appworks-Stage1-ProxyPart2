// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import { Slots } from "./SlotManipulate.sol";
import { BasicProxy } from "./BasicProxy.sol";

contract Transparent is Slots, BasicProxy {

  constructor(address _implementation) BasicProxy(_implementation) {
    // TODO: set admin address to Admin slot
  }

  modifier onlyAdmin {
    // TODO: finish onlyAdmin modifier
    _;
  }

  function upgradeTo(address _newImpl) public override onlyAdmin {
    // TODO: rewriet upgradeTo
  }

  function upgradeToAndCall(address _newImpl, bytes memory data) public override onlyAdmin {
    // TODO: rewriet upgradeToAndCall
  }

  fallback() external payable override {
    // rewrite fallback
  }
}