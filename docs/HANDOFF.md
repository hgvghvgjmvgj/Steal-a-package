# Laptop handoff — Steal a Package

Prepared 2026-10-02. Read this before making changes. This document carries project context; Git does not transfer the original Codex chat or machine configuration.

## Project and boundaries

- Original workspace: C:\Steal A Package!
- Roblox place confirmed by the user: display name `Seal A Package`, place ID `115384109496538`. Confirm the connected place on the laptop; Studio connection IDs are machine/session specific.
- Roblox Studio is the playable project. Edit through Studio/MCP. **Do not use Rojo.** Local `src` files are reviewable source backups, not automatic Studio synchronization.
- Original package-themed identity. Steal an Egg supplies design principles only: simplicity, spatial rhythm and progression pacing. Do not reproduce its geometry, assets, UI artwork, names, branding, sounds or balancing.
- Keep graybox scope: no weight, hard area locks, fusion/crafting, rebirth, monetization, final UI/art or large content pass. Full package opening is not implemented.

## Implemented foundation

Route: Plot → Starter Street → Neighborhood → Rich Street → Mansion → Facility. Eight plots, five stealing stages, three visible package spots per stage and one guardian per stage.

Players carry one package. Stealing activates only that stage's guardian. Concurrent thieves share its threat list. Being caught loses the package. Crossing the mint hub finish line ends pursuit and secures test cash; guardians stay outside the hub/plots. Later stages have faster guardians and better expected rewards without locks. Every stage rolls all seven shipping rarities.

Each plot has treadmill training, treadmill-rate upgrades, a test trail rack and capacity upgrades. Trails multiply training gain, not movement speed directly. Capacity supports 3/6/9/12 future collectibles through a validated storage/display API; gameplay does not yet grant unboxed collectibles.

Day/night uses temporary 150-second day / 30-second night values. All 15 package spots reroll together at sunrise. Claimed spots remain empty until sunrise; carried packages and ongoing chases survive refresh. Night exposes an 8× future opening/incubation hook, with no full opening system.

Schema v2 saves Cash, TrainingPoints, TreadmillLevel, CapacityLevel, OwnedTrails, EquippedTrail and validated Collectibles. It migrates old Speed upgrades into training points. Plot assignments, carried packages, chases and training sessions are transient. See docs/architecture/SAVING.md for session leases, failure handling and Studio/live key separation.

## Important correction / next gameplay change

The **current tested implementation requires held movement input to train** after entering the treadmill. E enters, hold movement to train, jump exits; F upgrades the treadmill, T cycles/buys/equips a trail, R upgrades capacity, all near the relevant station.

The user clarified that the reference treadmill trains **automatically while using it**, without physically holding movement keys. The reference study has been corrected to reflect this. The package game code has NOT been changed to automatic training. Next implementation should adapt automatic training in our own design, update relevant client/server prompts and regression assertions, and verify entry/exit, death, respawn, ownership, saving and multiplayer cleanup. Preserve server authority and rate validation.

## Recorded validation, not newly rerun on this laptop

- tests/results/progression-multiplayer.json: 201/201 M2 checks, two clients, disconnect and replacement join, progression math, trails, capacity, rarity pools, pursuit, sunrise, death/reset and persistence.
- tests/results/progression-client-smoke.json: direct keyboard and real save/reload checkpoints. The source tests currently expect held-input treadmill behavior.
- Disposable Roblox QA DataStore roundtrip verified v2 fields; test profiles restored. Studio API access was enabled and saved by the user on the original place. Recheck permissions/account access on the laptop.
- Older M1 reports are archived evidence, not verification of the latest feature set. See tests/results/README.md for limits.

## Reference study

Read references/gameplay/steal-an-egg-study/REFERENCE_STUDY.md. Each section separates OBSERVED, USEFUL PRINCIPLE and STEAL A PACKAGE ADAPTATION. Open gallery.html for 48 captioned selected screenshots; SCREENSHOT_INDEX.md and curated-screenshots.json identify evidence.

The study used normal visible gameplay and a user-driven walkthrough. No private scripts or hidden developer data were accessed. It used an advanced account, so first-session onboarding and a timed fresh-player 10–30 minute progression remain unverified. Later-stage coverage, continuous safe-line termination, exact rarity odds/catalogs, growth timers, fusion/rebirth menus and controlled refresh comparisons remain incomplete. Audio was not isolated or analyzed; do not invent sound findings. The user's treadmill screenshot is the latest correction.

## Laptop setup and place backup

1. Install Git, Codex and Roblox Studio, then clone the private repository. Open its folder as a local Codex project.
2. Sign into the Roblox account with access to place 115384109496538 and open the latest saved place, or transfer a full `.rbxl` / `.rbxlx` copy from the original PC.
3. **No full place file was found in this folder during handoff preparation.** project/backups contains source ZIPs only; these are not complete place backups. Before turning the original PC off, save the latest Edit-mode place to Roblox and preferably save a local `.rbxl` copy, then transfer it separately. Unsaved Studio edits are not carried by Git.
4. Configure the laptop's Studio MCP/plugin connection. Git does not transfer MCP credentials, plugin installation, Roblox login or Studio settings. Confirm the place and Edit/play state before editing.
5. Read tools/studio/README.md, manifest.json and docs/architecture/STUDIO_HIERARCHY.md. Install-ThroughMCP.ps1 builds a source bundle; it does not connect to Studio itself. BuildGraybox.luau contains inlined configs/WorldBuilder and must stay consistent if regenerated. Do not reinstall or rebuild an existing place blindly.
6. Run the M2 two-client regression via Studio/MCP in Edit mode after verifying the restored build, then a normal gameplay and save/reload smoke. Do not claim transferred code alone proves playability.

## Suggested first prompt on the laptop

“Read docs/HANDOFF.md, README.md, docs/planning/PROGRESSION_FOUNDATION.md and the Steal an Egg REFERENCE_STUDY.md. Continue Steal a Package from the existing tested progression build. Confirm the Studio place and local/source state first. No Rojo. Adapt the treadmill to automatic training while in use, as clarified by the user, preserving treadmill upgrades, trail training multipliers, capacity, stage-local pursuit, hub escape and sunrise refresh. Update tests and docs and verify multiplayer, respawning, cleanup and saving. Keep the original package identity and current graybox scope.”
