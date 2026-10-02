# Studio/MCP notes

- Confirmed target: Seal A Package, place 115384109496538, universe 10768945598.
- Use `multi_edit` to create/update normal Script, LocalScript and ModuleScript instances. The execute_luau sandbox cannot parent or require normal game scripts because their Capabilities include more permissions than its execution thread.
- `CreateHierarchy.luau` creates folders/remotes directly. `BuildGraybox.luau` inlines shared config defaults and builds scene geometry without requiring normal game modules.
- Initial vanilla Baseplate and SpawnLocation were removed after map creation to eliminate overlapping floor surfaces and the extra spawn. PlotService assigns each player's respawn point.
- Initial Play had Studio API access disabled. DataService displayed SessionOnly and retained playability. The user then enabled and saved Studio API access; the multiplayer suite completed a genuine write, lease release, reopen and removal of a disposable QA key.
- A real client E-key prompt successfully stole a Starter Street package. Server state showed 14 available packages, one carried visual and one chaser. Leaving the player standing long enough triggered catch and cleared both the visual and chase without awarding cash.
- Installed Studio plugins also emit unrelated Simulator Coins leaderboard/Bloxender messages. Those scripts were not inserted into this game's hierarchy by this project.
- Initial multiplayer run passed 54 gameplay/persistence checks before an invalid server assertion attempted to read the client-created HUD. Client-created GUI instances do not replicate to the server. The assertion was removed; HUD persistence is checked directly from a real Client DataModel after respawn.
- Final multiplayer suite passed 55/55. Direct client HUD check found exactly one ScreenGui after death/respawn, with ResetOnSpawn=false. Actual Studio profile reloaded $50 and Speed level 1/WalkSpeed 18 across a full stop/start.
- Keyboard input success means input was submitted, not that the server already processed the prompt. Allow for client/server delivery and verify stable gameplay state before asserting a transaction result.
- M2 replaces the old Speed button with a physical belt and F/R/T plot stations. Their prompts require a 0.15-second hold; MCP keyPress is instantaneous, so use keyDown → wait 350 ms → keyUp for smoke checks.
- M2 passed 201 checks with two real clients plus a disconnect/replacement join. Same-stage thieves share one guardian; hub escape clears only the escaping thief. Fifteen package rolls refresh atomically at sunrise, preserving carried rewards.
- Genuine client held-W training, idle pause, jump exit, F/R/T transactions, normal-speed package escapes and a fresh Play save/reload all passed. Client setup teleports were only used to place the tester near the physical prompts.
- All 22 local sources match installed Studio scripts after the final presentation edits. progression-2 scene has eight initial plots, five stages and TrainingIntent; old Chasers and SpeedUpgrade objects are removed.
- Source-only milestone snapshots are stored in project/backups. They contain scripts and the primitive scene builder, not a binary .rbxl place file. Keep Studio as the playable project.
