// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {Proxy} from "./Proxy/Proxy.sol";
import {Slots} from "./SlotManipulate.sol";

contract BasicProxy is Proxy, Slots {
    bytes32 constant IMPL_ADDRESS =
        bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);

    constructor(address _implementation) {
        _setSlotToAddress(IMPL_ADDRESS, _implementation);
    }

    function _fallback() internal virtual override {
        _delegate(_getSlotToAddress(IMPL_ADDRESS));
    }

    fallback() external payable virtual {
        _delegate(_getSlotToAddress(IMPL_ADDRESS));
    }

    receive() external payable {}

    function upgradeTo(address _newImpl) public virtual {
        _setSlotToAddress(IMPL_ADDRESS, _newImpl);
    }

    function upgradeToAndCall(
        address _newImpl,
        bytes memory data
    ) public virtual {
        _setSlotToAddress(IMPL_ADDRESS, _newImpl);
        // this will also be avaliable
        // _delegate(_newImpl);
        // _delegate will use revert, and with this, we can use require
        // 可讀性比較好
        (bool success, ) = _newImpl.delegatecall(data);
        require(success);
    }
}
