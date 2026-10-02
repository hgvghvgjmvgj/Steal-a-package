# Verified progression foundation (M2)

**201/201 checks passed** in the two-client Studio regression, including a real disconnect and replacement join. [progression-multiplayer.json](progression-multiplayer.json) contains every assertion.

Direct keyboard smoke passed. E entered the physical treadmill, held W earned points, idle time earned nothing, and jump released the anchored root. F purchased belt level 1 for $75; T equipped Courier Ribbon for $100 without an immediate movement boost; R purchased six-slot capacity for $100. Ordinary-speed package escapes earned the cash used for these purchases.

The belt/trail combination trained at 12.15 points/s and crossed from movement speed 18 to 19. A fresh Play session reloaded $113, 99.584 training points, treadmill level 1, capacity level 1/six slots and Courier Ribbon. The client had one HUD and its trail; the world had 15 packages, five guardians, no carried visuals and an unlocked root. These are recorded checkpoints; further user play can change the saved values. [progression-client-smoke.json](progression-client-smoke.json) records the observed states.

Persistence was also verified using a disposable real Roblox QA key for all v2 fields, including placeholder collectible storage. Test keys are separate from live keys; the disposable key was removed. Test-player profiles were restored after the automated suite.

Capacity storage/display is a validated server API for future opening results. No opening system or gameplay collectible grants exist yet. Night exposes an 8× future opening/incubation gain hook. Studio is edited directly through MCP; no Rojo was used.

After the suite, temporary billboard sizes/distances were tightened and the trail prompt was given a preview of its next equip/buy cost and gain. A final Play smoke confirmed these presentation changes loaded.

## Archived initial milestone

multiplayer.json (55 checks), client-smoke.json and initial-multiplayer.json belong to M1, before treadmills and sunrise refresh. The initial M1 run's server-side HUD assertion was corrected because client GUI instances do not replicate to the server; M2 uses a runtime-only client probe.
