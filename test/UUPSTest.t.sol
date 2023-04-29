// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {UUPSProxy} from "../src/UUPSProxy.sol";
import {ClockUUPS} from "../src/UUPSLogic/ClockUUPS.sol";
import {ClockUUPSV2} from "../src/UUPSLogic/ClockUUPSV2.sol";
import {ClockUUPSV3} from "../src/UUPSLogic/ClockUUPSV3.sol";

contract UUPSTest is Test {
    ClockUUPS public clock;
    ClockUUPS public clockProxy;
    ClockUUPSV2 public clockV2;
    ClockUUPSV2 public clockV2Proxy;
    ClockUUPSV3 public clockV3;
    ClockUUPSV3 public clockV3Proxy;
    UUPSProxy public uupsProxy;
    uint256 public alarm1Time;

    address admin;
    address user1;

    function setUp() public {
        admin = makeAddr("admin");
        user1 = makeAddr("noob");
        clock = new ClockUUPS();
        clockV2 = new ClockUUPSV2();
        clockV3 = new ClockUUPSV3();

        vm.prank(admin);
        // initialize UUPS proxy
        uupsProxy = new UUPSProxy(
            abi.encodeWithSignature("initialize(uint256)", 1),
            address(clock)
        );

        clockProxy = ClockUUPS(address(uupsProxy));
        clockV3Proxy = ClockUUPSV3(address(uupsProxy));
    }

    function testProxyWorks() public {
        // ✅check Clock functionality is successfully proxied
        clockProxy.setAlarm1(1);
        assertEq(clockProxy.alarm1(), 1);
    }

    function testUpgradeToWorks() public {
        // ✅check upgradeTo works aswell
        vm.prank(admin);
        clockProxy.upgradeTo(address(clockV3));
        vm.stopPrank();

        vm.startPrank(user1);
        clockV3Proxy.setAlarm2(2);
        assertEq(clockV3Proxy.alarm2(), 2);
        vm.stopPrank();
    }

    function testCantUpgrade() public {
        // ✅check upgradeTo should fail if implementation doesn't inherit Proxiable
        vm.expectRevert("Not compatible with UUPS proxy");
        clockProxy.upgradeTo(address(clockV2));
    }

    function testCantUpgradeIfLogicDoesntHaveUpgradeFunction() public {
        // ✅check upgradeTo should fail if implementation doesn't implement upgradeTo
        clockProxy.upgradeTo(address(clockV3));
        vm.expectRevert();
        clockProxy.upgradeTo(address(clockV2));
    }
}
