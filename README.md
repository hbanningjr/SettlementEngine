# AssetRegistry

An on-chain lifecycle registry for tokenized real-world assets — tracking status, validity, and settlement eligibility.

---

## Why AssetRegistry?

Tokenizing a real-world asset proves it exists on-chain. It does not prove the underlying asset is still valid, active, or eligible for settlement today.

AssetRegistry fills that gap. It maintains the lifecycle state of each registered asset and answers one question for the Settlement Engine:

**"Is this asset currently eligible for settlement?"**

---

## Design Philosophy

AssetRegistry follows the principle of single responsibility.

It does not handle identity, wallet authorization, or settlement logic. It only tracks whether a registered asset binding is currently valid.

Other contracts can query this information without inheriting the complexity of asset lifecycle management.

---

## Where AssetRegistry Fits

```text
┌──────────────────────┐
│   CivicPass          │
│   Who is this?       │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   POKKET             │
│   Which wallet?      │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   MINE               │
│   Authorized?        │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   AssetRegistry      │
│   Is the asset       │
│   still valid?       │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   Settlement Engine  │
│   The Conductor      │
└──────────────────────┘
```

---

## Asset Lifecycle

```text
Unregistered
    ↓
registerAsset()
    ↓
Active ◄──────────────────┐
    ↓                      │
suspendAsset()        reactivateAsset()
    ↓                      │
Suspended ─────────────────┘
    ↓
revokeAsset() ──► Revoked (terminal)

Active/Suspended
    ↓
block.timestamp > validUntil ──► Expired (automatic)
```

---

## Public Interface

`src/AssetRegistry.sol`

| Function | Description |
|---|---|
| `registerAsset` | Register a new asset with label and validity window |
| `suspendAsset` | Temporarily suspend an active asset |
| `reactivateAsset` | Restore a suspended asset to active |
| `revokeAsset` | Permanently revoke an asset (terminal) |
| `getAssetInfo` | Retrieve full asset record |
| `isEligible` | Settlement-facing eligibility check |

---

## Design Decisions

- `isEligible()` requires `exists && Active && block.timestamp < validUntil` — all three must pass
- Suspension is reversible; revocation is terminal
- Expiry is automatic — no transaction needed, time alone determines ineligibility
- Revocation is permitted after expiry to preserve audit history
- The `exists` flag prevents unregistered assets from appearing valid via Solidity mapping defaults

---

## Testing

Built with Foundry using a comprehensive unit test suite covering the full asset lifecycle, all state transitions, time-based expiry, boundary conditions, and integration flows.

```
✓ 31 unit tests
✓ 31 passing
```

```bash
forge test -v
```

---

## Deployment

Sepolia testnet — address coming soon.

---

## Related Projects

- [CivicPass](https://github.com/hbanningjr/civicpass) — Privacy-preserving credential verification
- [POKKET](https://github.com/hbanningjr/POKKET) — On-chain wallet categorization
- [MINE](https://github.com/hbanningjr/MINE) — Decentralized authorization layer
