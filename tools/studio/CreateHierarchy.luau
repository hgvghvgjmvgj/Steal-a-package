-- Run in the Edit DataModel through Studio MCP. Creates architecture only.
local function ensure(parent, name, class)
    local item = parent:FindFirstChild(name)
    if item then assert(item.ClassName == class, name .. " has an unexpected class"); return item end
    item = Instance.new(class)
    item.Name, item.Parent = name, parent
    return item
end
local replicated = ensure(game:GetService("ReplicatedStorage"), "StealAPackage", "Folder")
local shared = ensure(replicated, "Shared", "Folder")
ensure(shared, "Configs", "Folder")
ensure(shared, "Modules", "Folder")
ensure(ensure(replicated, "Remotes", "Folder"), "Notice", "RemoteEvent")
ensure(replicated.Remotes, "TrainingIntent", "RemoteEvent")
local assets = ensure(replicated, "Assets", "Folder")
ensure(assets, "UI", "Folder")
ensure(assets, "Models", "Folder")
local server = ensure(game:GetService("ServerScriptService"), "StealAPackage", "Folder")
for _, name in ipairs({"Systems", "Data", "Tests"}) do ensure(server, name, "Folder") end
local storage = ensure(game:GetService("ServerStorage"), "StealAPackage", "Folder")
ensure(storage, "Templates", "Folder")
ensure(storage, "PlayerData", "Folder")
ensure(game:GetService("StarterPlayer").StarterPlayerScripts, "StealAPackageClient", "Folder")
local world = ensure(workspace, "StealAPackage", "Folder")
local map = ensure(world, "Map", "Folder")
ensure(map, "Areas", "Folder")
ensure(map, "Plots", "Folder")
for _, name in ipairs({"Packages", "Guardians", "CarriedPackages"}) do ensure(world, name, "Folder") end
return "StealAPackage hierarchy created without Rojo"
