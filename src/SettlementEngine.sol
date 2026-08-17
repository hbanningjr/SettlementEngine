// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import {ICivicPass} from "./interfaces/ICivicPass.sol";
import {IWalletRegistry} from "./interfaces/IPokket.sol";
import {IMine} from "./interfaces/IMine.sol";
import {IAssetRegistry} from "./interfaces/IAssetRegistry.sol";

contract SettlementEngine {
    ICivicPass public immutable civicPass;
    IWalletRegistry public immutable pokket;
    IMine public immutable mine;
    IAssetRegistry public immutable assetRegistry;

    constructor(address civicPassAddress, address pokketAddress, address mineAddress, address assetRegistryAddress) {
        civicPass = ICivicPass(civicPassAddress);
        pokket = IWalletRegistry(pokketAddress);
        mine = IMine(mineAddress);
        assetRegistry = IAssetRegistry(assetRegistryAddress);
    }

    function canSettle(
        address wallet,
        uint256 electionId,
        IWalletRegistry.Category categoryToCheck,
        bytes32 context,
        bytes32 assetId
    ) external view returns (bool) {
        // 1. CivicPass — is the credential valid?
        try civicPass.verifyCredential(wallet, electionId) returns (bool, bool valid, bool, bool, bool) {
            if (!valid) return false;
        } catch {
            return false;
        }

        // 2. POKKET — is this wallet the required category?
        try pokket.isCategory(wallet, categoryToCheck) returns (bool categoryMatch) {
            if (!categoryMatch) return false;
        } catch {
            return false;
        }

        // 3. MINE — is this wallet authorized for the context?
        try mine.isAuthorized(wallet, context) returns (bool authorized) {
            if (!authorized) return false;
        } catch {
            return false;
        }

        // 4. AssetRegistry — is the asset currently eligible?
        try assetRegistry.isEligible(assetId) returns (bool eligible) {
            if (!eligible) return false;
        } catch {
            return false;
        }

        // Every specialist explicitly answered yes.
        return true;
    }
}
