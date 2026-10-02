# Progression verification

Automated: run ExecuteMultiplayerTestAsync(2, {Suite = "Progression"}) through Studio MCP in Edit mode. Results are recorded in tests/results/progression-multiplayer.json.

- Separate plots; five persistent guardians; 15 spots; continuous walkable route.
- Three spots per stage, all seven rarities reachable in every weighted pool, increasing expected cash with depth.
- Owner/proximity checks, idle versus running training, intent expiry, finite points/speed caps.
- Treadmill cash upgrades improve gain without directly changing movement.
- Trail purchases, ownership, equip/unequip, visuals and gain math without direct movement multipliers.
- Capacity 3 → 6 → 9 → 12, validated placeholder storage/display, full/duplicate/invalid record rejection.
- Legacy Speed migration, malformed data normalization, real Roblox progression save/reload.
- Atomic package claims, one-package limit, concurrent thieves sharing one stage guardian.
- Finish-line escape before plots, single cash award, independent threat cleanup, catches without cash.
- All stages open, guardians increasingly fast, pursuit and outside-hub bounds.
- Sunrise restores all 15 with one generation; claimed spots wait; carried rewards and chases survive refresh.
- 150-second day / 30-second night and future opening multiplier 1× / 8×.
- Death/reset while training or carrying, learned speed and trail reapplied, own-depot respawn, one client HUD.
- Disconnect cleanup, replacement join, plot reuse, bounded repeated-cycle populations.
- Profile leases, serialized fields, stale-server rejection, expiry recovery and disposable real DataStore roundtrip.

Direct client smoke:

1. Hold E briefly to enter the belt; hold W to train; release W and confirm no further gain; jump to leave.
2. Use E package prompts and ordinary-speed movement to escape across the mint hub line.
3. Earn cash through thefts, use physical F/R/T prompts, confirm exact costs, gain rate and capacity.
4. Train with upgraded belt and equipped trail to cross a movement threshold.
5. Stop/start Play; verify saved cash, training points, belt, capacity and equipped trail, one HUD and clean populations.

Automated movement cases position server characters to test authoritative transactions. The direct smoke uses client teleports only to set up near stations/packages; real held keys trigger prompts, running and escape movement. Placeholder collectible records are internal QA only and are restored after testing.
