// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import {IAssetRegistry} from "../../src/interfaces/IAssetRegistry.sol";

contract MockAssetRegistry is IAssetRegistry {
    bool public result = true;
    bool public shouldRevert;

    function setResult(bool newResult) external {
        result = newResult;
    }

    function setShouldRevert(bool value) external {
        shouldRevert = value;
    }

    function isEligible(bytes32) external view returns (bool) {
        if (shouldRevert) revert("Mock AssetRegistry revert");

        return result;
    }
}
