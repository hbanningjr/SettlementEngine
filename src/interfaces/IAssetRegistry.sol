// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

interface IAssetRegistry {
    function isEligible(bytes32 assetId) external view returns (bool);
}
