// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

interface IWalletRegistry {
    enum Category {
        None,
        Voting,
        NFT,
        DeFi,
        RealEstate,
        Test
    }

    function isCategory(address wallet, Category categoryToCheck) external view returns (bool);
}
