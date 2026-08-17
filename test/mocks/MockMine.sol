// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import {IMine} from "../../src/interfaces/IMine.sol";

contract MockMine is IMine {
    bool public result = true;
    bool public shouldRevert;

    function setResult(bool newResult) external {
        result = newResult;
    }

    function setShouldRevert(bool value) external {
        shouldRevert = value;
    }

    function isAuthorized(address, bytes32) external view returns (bool) {
        if (shouldRevert) revert("Mock MINE revert");

        return result;
    }
}
