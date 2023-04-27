// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { Clock } from "../src/Logic/Clock.sol";
import { ClockV2 } from "../src/Logic/ClockV2.sol";
import { BasicProxy } from "../src/BasicProxy.sol";

contract BasicProxyTest is Test {

  Clock public clock;
  ClockV2 public clockV2;
  BasicProxy public basicProxy;
  uint256 public alarm1Time;

  function setUp() public {
    clock = new Clock();
    clockV2 = new ClockV2();
    basicProxy = new BasicProxy(address(clock));
  }

  function testProxyWorks() public {
    // TODO: check Clock functionality is successfully proxied
  }

  function testInitialize() public {
    // TODO: check initialize works
  }

  function testUpgrade() public {

    // TODO: check Clock functionality is successfully proxied

    // upgrade Logic contract to ClockV2
    // check state hadn't been changed
    // check new functionality is available
  }

  function testUpgradeAndCall() public {
    // TODO: calling initialize right after upgrade
    // check state had been changed according to initialize
  }

  function testChangeOwnerWontCollision() public {
    // TODO: call changeOwner to update owner
    // check Clock functionality is successfully proxied
  }
}