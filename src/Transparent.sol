// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {Slots} from "./SlotManipulate.sol";
import {BasicProxy} from "./BasicProxy.sol";

contract Transparent is Slots, BasicProxy {
    constructor(address _implementation) BasicProxy(_implementation) {
        // TODO: set admin address to Admin slot
        _setSlotToAddress(
            bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1),
            msg.sender
        );
    }

    modifier onlyAdmin() {
        // TODO: finish onlyAdmin modifier
        require(
            msg.sender ==
                _getSlotToAddress(
                    bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1)
                ),
            "Transparent: not admin"
        );
        _;
    }

    function upgradeTo(address _newImpl) public override onlyAdmin {
        // TODO: rewrite upgradeTo
        super.upgradeTo(_newImpl);
    }

    function upgradeToAndCall(
        address _newImpl,
        bytes memory data
    ) public override onlyAdmin {
        // TODO: rewriet upgradeToAndCall
        super.upgradeToAndCall(_newImpl, data);
    }

    fallback() external payable override {
        // rewrite fallback
        require(
            msg.sender !=
                _getSlotToAddress(
                    bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1)
                ),
            "Admin cannot call fallback function"
        );
        _fallback();
    }
}
