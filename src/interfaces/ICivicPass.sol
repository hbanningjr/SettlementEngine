// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

interface ICivicPass {
    function verifyCredential(address wallet, uint256 electionId)
        external
        view
        returns (bool exists, bool valid, bool revoked, bool used, bool expired);
}
