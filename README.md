# Steal a Package — progression graybox

Roblox Studio is the playable project. The `src` folder contains reviewable Luau source backups installed through Studio MCP; this project does not use Rojo.

## Folder map

- `docs/planning`: scope, gameplay loop and next decisions.
- `docs/architecture`: Studio hierarchy, system ownership and persistence notes.
- `references/gameplay`, `references/visual`: reference material; empty until useful.
- `assets/ui/placeholders`, `assets/models/graybox`, `assets/audio`: temporary assets and future source assets.
- `src/server/systems`, `src/server/data`: authoritative game systems and saving.
- `src/client`: temporary playtest HUD and client feedback.
- `src/shared/config`, `src/shared/modules`: reusable balance data and helpers.
- `src/server/tests`, `tests/results`, `tests/debug-notes`: Studio-only integration checks and test evidence.
- `tools/studio`: direct Studio installer and hierarchy manifest.
- `project/backups`: local place snapshots and supporting project files.

Current milestone: physical treadmill training, training-multiplier trails, collectible capacity upgrades, three parcels and one shared guardian per stage, hub finish-line escape, and synchronized sunrise refresh. The route remains Plot → Starter Street → Neighborhood → Rich Street → Mansion → Facility.

Keyboard controls: E enters your treadmill; hold movement to train; jump leaves. F upgrades its training rate, T cycles temporary trails at the rack, and R upgrades capacity at the capacity station. E steals a package; cross the mint hub line to secure its test cash. Walk near the corresponding physical station before using its prompt.

See `docs/planning/PROGRESSION_FOUNDATION.md` for current scope, `docs/planning/GRAYBOX_SCOPE.md` for the initial milestone, and `docs/architecture/STUDIO_HIERARCHY.md` for the DataModel map. Test evidence lives in `tests/results`.

## Continue on a laptop

Read [docs/HANDOFF.md](docs/HANDOFF.md) for build status, the automatic-treadmill correction, Studio backup requirements and a continuation prompt. See [docs/GIT_WORKFLOW.md](docs/GIT_WORKFLOW.md) for private-repository transfer instructions.
