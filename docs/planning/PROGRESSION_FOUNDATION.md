# Progression foundation (M2)

Preserve the existing package route. The reference supplies only the simple train/steal/improve rhythm. All geometry, shipping classifications, guardian behavior, prices, durations and test trails are specific to this project.

- Train on your physical treadmill by entering with its prompt, holding movement input to run, and jumping to leave. Upgrades improve points/second. Trails multiply training points only, never current movement speed.
- Earned training raises movement speed in small steps. Preserve old purchased Speed through a schema migration into training points.
- Upgrade plot capacity from 3 → 6 → 9 → 12 future collectible slots. Internal validated storage/display API is present for the later unboxing system; no opening or collectible rewards are added now.
- Three visible package spots and exactly one guardian per stage. Concurrent thieves share that guardian's threat list. Other stages stay idle unless a package is stolen there.
- Hub finish line ends a chase and secures test cash. Guardians cannot cross into the hub or plots. No stage locks, weight, final UI/art, fusion, monetization or rebirth.
- Every stage rolls all seven shipping rarities; high-tier outcomes are possible everywhere. Later stages improve weights, base cash and guardian speed.
- All 15 package spots reroll at sunrise. Claimed spots stay empty until sunrise. In-flight packages and chases survive refresh. A 150-second day and 30-second night expose an 8× future opening/incubation multiplier without implementing opening.

QA covers input-driven training/stop, owner/proximity checks, gain math, trails, capacity limits, migrations and save/reload, shared guardians, finish-line escape, simultaneous refresh, rare-pool coverage, death/reset/disconnect and replacement joins.

## Temporary balance

Training starts at 6 points/second. Every 30 earned points adds 1 movement speed, from 16 up to 40. Belt levels raise base gain to 9, 14, 21 and 30 points/second for $75, $160, $300 and $550. Packing Tape is free at 1× gain, Courier Ribbon costs $100 at 1.35× and Dispatch Beam costs $250 at 1.8×. Capacity costs $100/$240/$500 for 6/9/12 slots.

Stage base cash is $50/$90/$140/$210/$300; guardian speeds are 13/16/20/24/28. Seven rarity reward multipliers span 1× to 12×; each stage has its own weight vector, including the very rare one-of-one shipment. These are centralized test values for tuning after playtests.

Validated: 201 automated multiplayer checks and direct keyboard/save-reload smoke. See tests/results/README.md for evidence and limitations.
