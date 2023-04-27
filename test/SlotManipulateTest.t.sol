// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {SlotManipulate} from "../src/SlotManipulate.sol";

contract SlotManipulateTest is Test {
    using stdStorage for StdStorage;
    address randomAddress;
    SlotManipulate instance;

    function setUp() public {
        instance = new SlotManipulate();
        randomAddress = makeAddr("jack");
    }

    function bytes32ToAddress(
        bytes32 _bytes32
    ) internal pure returns (address) {
        return address(uint160(uint256(_bytes32)));
    }

    function testValueSet() public {
        // TODO: set bytes32(keccak256("appwork.week8"))
        instance.setAppworksWeek8(2023_4_27);
        // Assert that the value is set
        assertEq(
            uint256(vm.load(address(instance), keccak256("appworks.week8"))),
            2023_4_27
        );

        assertEq(
            uint(instance.getSlotToBytes32(keccak256("appworks.week8"))),
            2023_4_27
        );
    }

    function testSetProxyImplementation() public {
        // TODO: set Proxy Implementation address
        // Assert that the value is set
        instance.setProxyImplementation(randomAddress);
        assertEq(
            bytes32ToAddress(
                vm.load(
                    address(instance),
                    bytes32(
                        uint256(keccak256("eip1967.proxy.implementation")) - 1
                    )
                )
            ),
            randomAddress
        );
    }

    function testSetBeaconImplementation() public {
        // TODO: set Beacon Implementation address
        // Assert that the value is set
        instance.setBeaconImplementation(randomAddress);
        assertEq(
            bytes32ToAddress(
                vm.load(
                    address(instance),
                    bytes32(uint256(keccak256("eip1967.proxy.beacon")) - 1)
                )
            ),
            randomAddress
        );
    }

    function testSetAdminImplementation() public {
        // TODO: set admin address
        // Assert that the value is set
        instance.setAdminImplementation(randomAddress);
        assertEq(
            bytes32ToAddress(
                vm.load(
                    address(instance),
                    bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1)
                )
            ),
            randomAddress
        );
    }

    function testSetProxiableImplementation() public {
        // TODO: set Proxiable address
        // Assert that the value is set
        instance.setProxiable(randomAddress);
        assertEq(
            bytes32ToAddress(
                vm.load(address(instance), keccak256("PROXIABLE"))
            ),
            randomAddress
        );
    }
}
