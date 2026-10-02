# Studio hierarchy

```
Workspace
  StealAPackage
    Map
      Areas / StarterStreet, Neighborhood, RichStreet, Mansion, Facility
      Plots / Plot01… (runtime owner attributes)
    Packages / runtime packages
    Guardians / one persistent guardian per stage, shared threat lists
    CarriedPackages / welded package visuals
ReplicatedStorage
  StealAPackage
    Shared
      Configs / GameConfig, AreaConfig, UpgradeConfig, RarityConfig, TrailConfig
      Modules / ProfileSchema, ProgressionMath, RarityRoller
    Remotes / Notice (server → client), TrainingIntent (client → server)
    Assets / UI, Models
ServerStorage
  StealAPackage
    Templates / Package, Guardian
    PlayerData / runtime server-only profile mirrors
ServerScriptService
  StealAPackage
    Bootstrap
    Systems / WorldBuilder, PlotService, PackageService, ChaserService, UpgradeService,
              HubService, TreadmillService, TrailService, DayNightService
    Data / ProfileStore, DataService
    Tests / GrayboxTests (Studio-only, opt-in)
StarterPlayer
  StarterPlayerScripts
    StealAPackageClient / PlaytestHUD
```

Shared configs are the sole graybox balance defaults. WorldBuilder builds primitive geometry in Edit mode through MCP. Bootstrap initializes runtime systems in dependency order. Server checks ownership, proximity, life state, cash, package claims and training rate. The client sends a boolean running intent; the server awards bounded training points on its own heartbeat and expires stale input. Clients render the temporary HUD, belt animation and character animation.

Each plot contains a Treadmill (Belt + Control), TrailRack, CapacityStation, 12 CollectibleSlots and CollectibleDisplays. PlotService exposes validated capacity-aware storage for future opening results. No gameplay opening system or collectible grants exist yet.

Each stage has three PackageSpawns and a GuardianHome. PackageService stages a complete refresh before swapping all 15 spots in one non-yielding transaction. Carried packages retain their rolled reward across sunrise. ChaserService shares one guardian across that stage's active thieves, selects the nearest eligible target, clears individual threats independently, and clamps guardian movement outside HubService's finish boundary.

DayNightService drives a 150-second day / 30-second night, synchronized sunrise refresh, Lighting and replicated phase attributes. OpeningMultiplier is 8 during night and 1 during day for the future incubation system.

Local source → Studio mapping lives in `tools/studio/manifest.json`. Direct MCP writes install sources; there is no live sync or Rojo project.
