// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import {ICivicPass} from "../../src/interfaces/ICivicPass.sol";

contract MockCivicPass is ICivicPass {
    bool public result = true;
    bool public shouldRevert;

    function setResult(bool newResult) external {
        result = newResult;
    }

    function setShouldRevert(bool value) external {
        shouldRevert = value;
    }

    function verifyCredential(address, uint256)
        external
        view
        returns (bool exists, bool valid, bool revoked, bool used, bool expired)
    {
        if (shouldRevert) revert("Mock CivicPass revert");

        return (true, result, false, false, false);
    }
}
