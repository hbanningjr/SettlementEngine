// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

interface IMine {
    function isAuthorized(address wallet, bytes32 context) external view returns (bool);
}
