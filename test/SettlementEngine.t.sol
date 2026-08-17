// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import {Test} from "forge-std/Test.sol";

import {SettlementEngine} from "../src/SettlementEngine.sol";
import {IWalletRegistry} from "../src/interfaces/IPokket.sol";

import {MockCivicPass} from "./mocks/MockCivicPass.sol";
import {MockPokket} from "./mocks/MockPokket.sol";
import {MockMine} from "./mocks/MockMine.sol";
import {MockAssetRegistry} from "./mocks/MockAssetRegistry.sol";

contract SettlementEngineTest is Test {
    SettlementEngine internal engine;

    MockCivicPass internal civicPass;
    MockPokket internal pokket;
    MockMine internal mine;
    MockAssetRegistry internal assetRegistry;

    address internal wallet = makeAddr("wallet");

    uint256 internal electionId = 1;

    IWalletRegistry.Category internal categoryToCheck = IWalletRegistry.Category.RealEstate;

    bytes32 internal context = keccak256("RWA_OFFERING");
    bytes32 internal assetId = keccak256("ASSET_ONE");

    function setUp() public {
        civicPass = new MockCivicPass();
        pokket = new MockPokket();
        mine = new MockMine();
        assetRegistry = new MockAssetRegistry();

        engine = new SettlementEngine(address(civicPass), address(pokket), address(mine), address(assetRegistry));
    }

    function test_CanSettleWhenAllLayersPass() public view {
        bool result = engine.canSettle(wallet, electionId, categoryToCheck, context, assetId);

        assertTrue(result);
    }

    function test_CanSettleReturnsFalseWhenCivicPassFails() public {
        civicPass.setResult(false);

        bool result = engine.canSettle(wallet, electionId, categoryToCheck, context, assetId);

        assertFalse(result);
    }

    function test_CanSettleReturnsFalseWhenPokketFails() public {
        pokket.setResult(false);

        bool result = engine.canSettle(wallet, electionId, categoryToCheck, context, assetId);

        assertFalse(result);
    }

    function test_CanSettleReturnsFalseWhenMineFails() public {
        mine.setResult(false);

        bool result = engine.canSettle(wallet, electionId, categoryToCheck, context, assetId);

        assertFalse(result);
    }

    function test_CanSettleReturnsFalseWhenAssetRegistryFails() public {
        assetRegistry.setResult(false);

        bool result = engine.canSettle(wallet, electionId, categoryToCheck, context, assetId);

        assertFalse(result);
    }

    function test_CanSettleReturnsFalseWhenCivicPassReverts() public {
        civicPass.setShouldRevert(true);

        bool result = engine.canSettle(wallet, electionId, categoryToCheck, context, assetId);

        assertFalse(result);
    }

    function test_CanSettleReturnsFalseWhenPokketReverts() public {
        pokket.setShouldRevert(true);

        bool result = engine.canSettle(wallet, electionId, categoryToCheck, context, assetId);

        assertFalse(result);
    }

    function test_CanSettleReturnsFalseWhenMineReverts() public {
        mine.setShouldRevert(true);

        bool result = engine.canSettle(wallet, electionId, categoryToCheck, context, assetId);

        assertFalse(result);
    }

    function test_CanSettleReturnsFalseWhenAssetRegistryReverts() public {
        assetRegistry.setShouldRevert(true);

        bool result = engine.canSettle(wallet, electionId, categoryToCheck, context, assetId);

        assertFalse(result);
    }
}
