// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import {IWalletRegistry} from "../../src/interfaces/IPokket.sol";

contract MockPokket is IWalletRegistry {
    bool public result = true;
    bool public shouldRevert;

    function setResult(bool newResult) external {
        result = newResult;
    }

    function setShouldRevert(bool value) external {
        shouldRevert = value;
    }

    function isCategory(address, Category) external view returns (bool) {
        if (shouldRevert) revert("Mock POKKET revert");

        return result;
    }
}
