// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Clock} from "../src/Logic/Clock.sol";
import {ClockV2} from "../src/Logic/ClockV2.sol";
import {BasicProxy} from "../src/BasicProxy.sol";

contract BasicProxyTest is Test {
    Clock public clock;
    ClockV2 public clockV2;
    BasicProxy public basicProxy;
    uint256 public alarm1Time;
    Clock clockProxy;

    function setUp() public {
        clock = new Clock();
        clockV2 = new ClockV2();
        basicProxy = new BasicProxy(address(clock));
        clockProxy = Clock(address(basicProxy));
    }

    function testProxyWorks() public {
        // TODO: check Clock functionality is successfully proxied

        clockProxy.setAlarm1(1);
        assertEq(clockProxy.alarm1(), 1);
    }

    function testInitialize() public {
        // TODO: check initialize works
        clockProxy.initialize(1);
        assertEq(clockProxy.alarm1(), 1);
    }

    function testUpgrade() public {
        // TODO: check Clock functionality is successfully proxied
        // upgrade Logic contract to ClockV2
        // check state hadn't been changed
        // check new functionality is available

        basicProxy.upgradeTo(address(clockV2));

        ClockV2 clockProxyV2 = ClockV2(address(basicProxy));
        clockProxyV2.setAlarm2(2);
        assertEq(clockProxyV2.alarm2(), 2);

        // test initialized
        clockProxy.initialize(1);
        assertEq(clockProxyV2.initialized(), true);
        // assertEq(
        //     vm.load(
        //         address(basicProxy),
        //         bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
        //     ),
        //     address(clockV2)
        // );
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
