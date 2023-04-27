// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { Transparent } from "../src/Transparent.sol";
import { Clock } from "../src/Logic/Clock.sol";
import { ClockV2 } from "../src/Logic/ClockV2.sol";

contract TransparentTest is Test {
  
  Clock public clock;
  ClockV2 public clockV2;
  Transparent public transparentProxy;
  uint256 public alarm1Time;

  address admin;
  address user1;

  function setUp() public {
    admin = makeAddr("admin");
    user1 = makeAddr("noob");
    clock = new Clock();
    clockV2 = new ClockV2();
    vm.prank(admin);
    transparentProxy = new Transparent(address(clock));
  }

  function testProxyWorks(uint256 _alarm1) public {
    // check Clock functionality is successfully proxied
    Clock clockProxy = Clock(address(transparentProxy));
    clockProxy.setAlarm1(_alarm1);
    assertEq(clockProxy.alarm1(), _alarm1);
    assertEq(clockProxy.getTimestamp(), block.timestamp);
  }

  function testUpgradeToOnlyAdmin(uint256 _alarm1, uint256 _alarm2) public {
    vm.expectRevert("Transparent: not admin");
    transparentProxy.upgradeTo(address(clockV2));
    vm.prank(admin);
    transparentProxy.upgradeTo(address(clockV2));

    ClockV2 clockProxy = ClockV2(address(transparentProxy));
    clockProxy.setAlarm1(_alarm1);
    clockProxy.setAlarm2(_alarm2);
    assertEq(clockProxy.alarm1(), _alarm1);
    assertEq(clockProxy.alarm2(), _alarm2);
  }

  function testUpgradeToAndCallOnlyAdmin(uint256 _alarm1, uint256 _alarm2) public {
    Clock clockProxy = Clock(address(transparentProxy));

    // check not initialized yet
    assertEq(clockProxy.alarm1(), 0);
    assertEq(clockProxy.initialized(), false);

    bytes memory initilizeData = abi.encodeWithSignature("initialize(uint256)", _alarm1);
    vm.expectRevert("Transparent: not admin");
    transparentProxy.upgradeToAndCall(address(clockV2), initilizeData);
    vm.prank(admin);
    transparentProxy.upgradeToAndCall(address(clockV2), initilizeData);

    ClockV2 clockProxyV2 = ClockV2(address(transparentProxy));
    clockProxyV2.setAlarm1(_alarm1);
    clockProxyV2.setAlarm2(_alarm2);
    assertEq(clockProxyV2.alarm1(), _alarm1);
    assertEq(clockProxyV2.alarm2(), _alarm2);
  }

  function testFallbackShouldRevertIfSenderIsAdmin(uint256 _alarm1) public {
    Clock clockProxy = Clock(address(transparentProxy));
    vm.prank(admin);
    vm.expectRevert();
    clockProxy.setAlarm1(_alarm1);
  }

  function testFallbackShouldSuccessIfSenderIsntAdmin(uint256 _alarm1) public {
    Clock clockProxy = Clock(address(transparentProxy));
    vm.prank(user1);
    clockProxy.setAlarm1(_alarm1);
    assertEq(clockProxy.alarm1(), _alarm1);
  }
}