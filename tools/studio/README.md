# Direct Studio workflow

1. Select the confirmed Studio place via `list_roblox_studios` and stop all tests.
2. Execute `CreateHierarchy.luau` in the Edit DataModel before adding game content.
3. Use `manifest.json` to install each source with `multi_edit` (`className`, empty `old_string` for a new script). Use exact old source for subsequent edits.
4. Execute `BuildGraybox.luau` through MCP in Edit mode. It contains WorldBuilder with AreaConfig, GameConfig and UpgradeConfig inlined from the local files. This avoids the MCP execution sandbox's restriction on requiring normal game ModuleScripts. The playable game requires modules normally.
5. Stop, edit, reinstall only changed scripts, then run the tests below.

`Install-ThroughMCP.ps1` prepares a JSON source bundle for the agent. It does not connect to Studio itself. This project has no Rojo, filesystem sync plugin, third-party framework or generated art dependency.

## Multiplayer regression

Execute in the Edit DataModel through MCP:

```lua
return game:GetService("StudioTestService"):ExecuteMultiplayerTestAsync(2, {Suite = "Progression"})
```

The opt-in GrayboxTests script runs only in Studio. It tests game-service transactions with real connected clients, simulates runner movement, triggers real death/reset/leave/replacement joins, and returns a structured report through EndTest. It restores test players' prior profile values. The Roblox DataStore roundtrip uses a separate `_QA` store and disposable key.

Normal Play does not run regression tests. E steals a package; cross the mint hub line to secure cash. At your plot, E enters the treadmill, held movement trains, jump leaves, F upgrades the treadmill, R upgrades collectible capacity and T cycles test trails at the rack. Prompts also expose touch/gamepad controls.

Save local place copies to `project/backups/`. Never treat the source bundle as a full place backup.
