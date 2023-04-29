// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Transparent} from "../src/Transparent.sol";
import {Clock} from "../src/Logic/Clock.sol";
import {ClockV2} from "../src/Logic/ClockV2.sol";

contract TransparentTest is Test {
    Clock public clock;
    ClockV2 public clockV2;
    Clock public clockProxy;
    Transparent public transparentProxy;
    uint256 public alarm1Time;

    address admin;
    address user1;

    function setUp() public {
        admin = makeAddr("admin");
        user1 = makeAddr("noobUser");
        clock = new Clock();
        clockV2 = new ClockV2();
        vm.prank(admin);
        transparentProxy = new Transparent(address(clock));
        clockProxy = Clock(address(transparentProxy));
    }

    function testProxyWorks(uint256 _alarm1) public {
        // check Clock functionality is successfully proxied

        clockProxy.setAlarm1(1);
        assertEq(clockProxy.alarm1(), 1);
    }

    // 參數是啥
    function testUpgradeToOnlyAdmin(uint256 _alarm1, uint256 _alarm2) public {
        // check upgradeTo could be called only by admin

        vm.startPrank(admin);
        transparentProxy.upgradeTo(address(clockV2));
        vm.stopPrank();

        vm.startPrank(user1);
        vm.expectRevert("Transparent: not admin");
        transparentProxy.upgradeTo(address(clockV2));

        ClockV2 clockProxyV2 = ClockV2(address(transparentProxy));
        clockProxyV2.setAlarm2(_alarm2);
        assertEq(clockProxyV2.alarm2(), _alarm2);
        vm.stopPrank();
    }

    function testUpgradeToAndCallOnlyAdmin(
        uint256 _alarm1,
        uint256 _alarm2
    ) public {
        // check upgradeToAndCall could be called only by admin
        vm.startPrank(admin);
        transparentProxy.upgradeToAndCall(
            address(clockV2),
            abi.encodeWithSignature("initialize(uint256)", 1234567890)
        );
        vm.stopPrank();

        vm.startPrank(user1);
        vm.expectRevert("Transparent: not admin");
        transparentProxy.upgradeToAndCall(
            address(clockV2),
            abi.encodeWithSignature("initialize(uint256)", 1234567890)
        );

        ClockV2 clockProxyV2 = ClockV2(address(transparentProxy));
        clockProxyV2.setAlarm2(_alarm2);
        assertEq(clockProxyV2.alarm2(), _alarm2);
        assertEq(clockProxyV2.initialized(), true);
        vm.stopPrank();
    }

    function testFallbackShouldRevertIfSenderIsAdmin(uint256 _alarm1) public {
        // check admin shouldn't trigger fallback
        vm.startPrank(admin);
        vm.expectRevert("Admin cannot call fallback function");
        clockProxy.setAlarm1(_alarm1);
        vm.stopPrank();
    }

    function testFallbackShouldSuccessIfSenderIsntAdmin(
        uint256 _alarm1
    ) public {
        // check admin shouldn't trigger fallback
        vm.startPrank(user1);
        clockProxy.setAlarm1(_alarm1);
        assertEq(clockProxy.alarm1(), _alarm1);
        vm.stopPrank();
    }
}
