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
    // check Clock functionality is successfully proxied
    Clock clockProxy = Clock(address(basicProxy));
    clockProxy.setAlarm1(100);
    assertEq(clockProxy.alarm1(), 100);
    assertEq(clockProxy.getTimestamp(), block.timestamp);
  }

  function testInitialize() public {
    // check initialize works
    Clock clockProxy = Clock(address(basicProxy));
    clockProxy.initialize(100);
    assertEq(clockProxy.alarm1(), 100);
  }

  function testUpgrade() public {

    // check Clock functionality is successfully proxied
    Clock clockProxy = Clock(address(basicProxy));
    clockProxy.setAlarm1(100);
    assertEq(clockProxy.alarm1(), 100);
    assertEq(clockProxy.alarm2(), 0);
    assertEq(clockProxy.getTimestamp(), block.timestamp);

    // shouldn't be able to setAlarm2
    ClockV2 clockProxyV2 = ClockV2(address(basicProxy));
    vm.expectRevert();
    clockProxyV2.setAlarm2(100);

    // upgrade
    basicProxy.upgradeTo(address(clockV2));
    // check state hadn't been changed
    assertEq(clockProxyV2.alarm1(), 100);
    assertEq(clockProxyV2.alarm2(), 0);
    // check new functionality is available
    clockProxyV2.setAlarm2(100);
    assertEq(clockProxyV2.alarm2(), 100);
  }

  function testUpgradeAndCall() public {
    // calling initialize right after upgrade
    basicProxy.upgradeToAndCall(address(clockV2), abi.encodeWithSignature("initialize(uint256)", 100));
    assertEq(ClockV2(address(basicProxy)).alarm1(), 100);
  }
}