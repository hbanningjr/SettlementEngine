SettlementEngine

The conductor — a neutral coordinator that composes four upstream checks into one deterministic settlement decision.

Why SettlementEngine?

Each layer in the identity stack answers one question. None of them knows whether settlement should proceed. That decision belongs to a separate layer — one that asks each specialist and composes their answers into a single, unambiguous result.

SettlementEngine is that layer.

It does not verify identity. It does not categorize wallets. It does not manage whitelists. It does not track asset lifecycles. It only asks four questions and returns one answer.

Design Philosophy

A conductor does not play the instruments. It coordinates the musicians.

SettlementEngine follows three principles:

Fail closed. Any false answer, any revert, any inability to respond from any upstream layer returns false. Uncertainty is never interpreted as permission.

Neutral coordination. SettlementEngine contains no business logic. It composes facts established by specialists — it does not recreate them.

Separation of coordination and execution. canSettle() decides whether settlement is permitted. It does not execute the settlement. That boundary keeps the conductor swappable and its trust logic auditable.

Where SettlementEngine Fits
text
┌──────────────────────┐
│ CivicPass │
│ Who is this? │
└──────────┬───────────┘
│
▼
┌──────────────────────┐
│ POKKET │
│ Which wallet? │
└──────────┬───────────┘
│
▼
┌──────────────────────┐
│ MINE │
│ Authorized? │
└──────────┬───────────┘
│
▼
┌──────────────────────┐
│ AssetRegistry │
│ Asset still valid? │
└──────────┬───────────┘
│
▼
┌──────────────────────┐
│ SettlementEngine │
│ May we proceed? │
└──────────┬───────────┘
│
▼
true / false
│
▼
Execution layer (future)
The Decision Table
CivicPass POKKET MINE AssetRegistry Result
✓ ✓ ✓ ✓ true
✗ ✓ ✓ ✓ false
✓ ✗ ✓ ✓ false
✓ ✓ ✗ ✓ false
✓ ✓ ✓ ✗ false
revert any any any false
Public Interface

src/SettlementEngine.sol

Function Description
canSettle Returns true only when all four layers explicitly confirm

Parameters:

Parameter Type Purpose
wallet address The wallet being checked across all layers
electionId uint256 CivicPass credential context
categoryToCheck IWalletRegistry.Category Required wallet category
context bytes32 MINE authorization context
assetId bytes32 Asset to verify eligibility
Design Decisions
All four upstream dependencies are immutable — trust relationships are fixed at deployment
No Ownable — there are no privileged administrative operations
try/catch wraps every external call — upstream reverts are caught and return false
Early exit on first failure — if CivicPass fails, POKKET, MINE, and AssetRegistry are never called
Coordination ends at return true — no transfers, no state mutations, no execution
Testing

Built with Foundry using four configurable mock contracts — one per upstream dependency. Each mock supports independent control of return value and revert behavior, enabling exhaustive branch coverage.

✓ 9 unit tests
✓ 9 passing
bash
forge test -v
Deployment

Sepolia testnet — address coming soon.

The Full Stack
Contract Question
CivicPass Who is this?
POKKET Which wallet?
MINE Authorized?
AssetRegistry Asset still valid?
SettlementEngine May we proceed?
