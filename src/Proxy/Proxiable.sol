// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;
import {Slots} from "../SlotManipulate.sol";

contract Proxiable is Slots {
    bytes32 IMPL_ADDRESS = keccak256("PROXIABLE");

    function proxiableUUID() public pure returns (bytes32) {
        return
            0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7;
    }

    function updateCodeAddress(address newAddress) internal {
        // ✅TODO: check if target address has proxiableUUID
        // ✅update code address

        (bool success, bytes memory result) = address(newAddress).call(
            abi.encodeWithSignature("proxiableUUID()")
        );
        // use this line will cause error
        // bytes32 targetUUID = abi.decode(result, (bytes32));
        require(
            success && abi.decode(result, (bytes32)) == proxiableUUID(),
            "Not compatible with UUPS proxy"
        );
    }
}
