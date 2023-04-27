// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { UUPSProxy } from "../src/UUPSProxy.sol";
import { ClockUUPS } from "../src/UUPSLogic/ClockUUPS.sol";
import { ClockUUPSV2 } from "../src/UUPSLogic/ClockUUPSV2.sol";

contract UUPSTest is Test {
  
  ClockUUPS public clock;
  ClockUUPSV2 public clockV2;
  UUPSProxy public uupsProxy;
  uint256 public alarm1Time;

  address admin;
  address user1;

  function setUp() public {
    admin = makeAddr("admin");
    user1 = makeAddr("noob");
    clock = new ClockUUPS();
    clockV2 = new ClockUUPSV2();
    vm.prank(admin);
    alarm1Time = 2023_4_27;
    bytes memory initilizeData = abi.encodeWithSignature("initialize(uint256)", alarm1Time);
    uupsProxy = new UUPSProxy(initilizeData, address(clock));
  }

  function testProxyWorks(uint256 _alarm1) public {
    // check Clock functionality is successfully proxied
    ClockUUPS clockProxy = ClockUUPS(address(uupsProxy));
    clockProxy.setAlarm1(_alarm1);
    assertEq(clockProxy.alarm1(), _alarm1);
    assertEq(clockProxy.getTimestamp(), block.timestamp);
  }

  function testUpgradeToWorks(uint256 _alarm1, uint256 _alarm2) public {
    ClockUUPS(address(uupsProxy)).upgradeTo(address(clockV2));
    ClockUUPSV2 clockProxy = ClockUUPSV2(address(uupsProxy));
    clockProxy.setAlarm1(_alarm1);
    clockProxy.setAlarm2(_alarm2);

    assertEq(clockProxy.alarm1(), _alarm1);
    assertEq(clockProxy.alarm2(), _alarm2);
  }

  function testCantUpgrade(uint256 _alarm1, uint256 _alarm2) public {
    ClockUUPS clockUUPS = ClockUUPS(address(uupsProxy));
    clockUUPS.upgradeTo(address(clockV2));
    vm.expectRevert();
    clockUUPS.upgradeTo(address(clock));
  }
}