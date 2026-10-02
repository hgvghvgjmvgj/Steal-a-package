local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local shared = game:GetService("ReplicatedStorage").StealAPackage.Shared
local Config = require(shared.Configs.GameConfig)
local UpgradeConfig = require(shared.Configs.UpgradeConfig)
local Schema = require(shared.Modules.ProfileSchema)
local Progression = require(shared.Modules.ProgressionMath)
local ProfileStore = require(script.Parent.ProfileStore)
local Data = {Profiles = {}, Closing = false}
local mirrors = game:GetService("ServerStorage").StealAPackage.PlayerData
local adapter = DataStoreService:GetDataStore(Config.DataStoreName)
local store = ProfileStore.new(adapter, game.JobId .. ":" .. HttpService:GenerateGUID(false))

local function retry(callback)
    local last
    for attempt = 1, 3 do
        local ok, value, reason = pcall(callback)
        if ok then return value, reason end
        last = tostring(value)
        if attempt < 3 then task.wait(attempt) end
    end
    return nil, last
end
function Data.Get(player) return Data.Profiles[player] end
function Data.Publish(player)
    local profile = Data.Get(player)
    if not profile then return end
    player:SetAttribute("Cash", profile.Data.Cash)
    player:SetAttribute("SpeedLevel", Progression.Level(profile.Data.TrainingPoints))
    player:SetAttribute("TrainingPoints", profile.Data.TrainingPoints)
    player:SetAttribute("TreadmillLevel", profile.Data.TreadmillLevel)
    player:SetAttribute("TrainingRate", Progression.Rate(profile.Data))
    player:SetAttribute("CapacityLevel", profile.Data.CapacityLevel)
    player:SetAttribute("PlotCapacity", Progression.Capacity(profile.Data))
    player:SetAttribute("StoredCollectibles", #profile.Data.Collectibles)
    player:SetAttribute("EquippedTrail", profile.Data.EquippedTrail)
    player:SetAttribute("TrailMultiplier", Progression.Multiplier(profile.Data))
    player:SetAttribute("WalkSpeed", Progression.WalkSpeed(profile.Data))
    player:SetAttribute("SaveStatus", profile.Status)
    profile.Mirror:SetAttribute("Cash", profile.Data.Cash)
    profile.Mirror:SetAttribute("SpeedLevel", Progression.Level(profile.Data.TrainingPoints))
    profile.Mirror:SetAttribute("TrainingPoints", profile.Data.TrainingPoints)
    profile.Mirror:SetAttribute("TreadmillLevel", profile.Data.TreadmillLevel)
    profile.Mirror:SetAttribute("CapacityLevel", profile.Data.CapacityLevel)
    profile.Mirror:SetAttribute("EquippedTrail", profile.Data.EquippedTrail)
    local stats = player:FindFirstChild("leaderstats")
    if stats then stats.Cash.Value = profile.Data.Cash end
end
function Data.ApplySpeed(player)
    local profile = Data.Get(player)
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if profile and humanoid then humanoid.WalkSpeed = Progression.WalkSpeed(profile.Data) end
end
function Data.Load(player)
    player:SetAttribute("DataReady", false)
    player:SetAttribute("SaveStatus", "Loading")
    local key = (if RunService:IsStudio() then "studio:" else "player:") .. player.UserId
    local value, reason
    local persistent = not RunService:IsStudio() or Config.StudioPersistence
    if persistent then value, reason = retry(function() return store:Acquire(key) end) end
    if not value then
        if not RunService:IsStudio() or (reason and string.find(reason, "active in another", 1, true)) then
            player:Kick("Could not safely load your data. Please rejoin. " .. tostring(reason))
            return false
        end
        value, persistent = Schema.Normalize(nil), false
        warn("[StealAPackage] Studio session-only data: " .. tostring(reason or "StudioPersistence disabled"))
    end
    if not player.Parent or Data.Closing then
        if persistent then retry(function() return store:Save(key, value, true) end) end
        return false
    end
    local mirror = Instance.new("Folder")
    mirror.Name, mirror.Parent = tostring(player.UserId), mirrors
    local profile = {Data = value, Key = key, Persistent = persistent, Busy = false, Removing = false,
        Status = if persistent then "Saved" else "SessionOnly", Mirror = mirror}
    Data.Profiles[player] = profile
    local stats = Instance.new("Folder")
    stats.Name, stats.Parent = "leaderstats", player
    local cash = Instance.new("IntValue")
    cash.Name, cash.Parent = "Cash", stats
    Data.Publish(player)
    player:SetAttribute("DataReady", true)
    return true
end
function Data.AddCash(player, amount)
    local profile = Data.Get(player)
    if not profile or profile.Removing or Data.Closing then return false end
    profile.Data.Cash = math.min(1000000000, profile.Data.Cash + amount)
    return Data.MarkChanged(player)
end
function Data.MarkChanged(player)
    local profile = Data.Get(player)
    if not profile or profile.Removing or Data.Closing then return false end
    profile.Revision = (profile.Revision or 0) + 1
    if profile.Persistent then profile.Status = "Unsaved" end
    Data.Publish(player)
    return true
end
function Data.Save(player, release)
    local profile = Data.Get(player)
    if not profile then return true end
    if profile.Busy and not release then return false end
    while profile.Busy do task.wait(0.05) end
    profile.Busy = true
    local snapshot = Schema.Normalize(profile.Data)
    local revision = profile.Revision or 0
    local ok, reason = true, nil
    if profile.Persistent then
        profile.Status = "Saving"
        Data.Publish(player)
        ok, reason = retry(function() return store:Save(profile.Key, snapshot, release) end)
        if not ok then warn("[StealAPackage] Save failed for " .. player.UserId .. ": " .. tostring(reason)) end
    end
    profile.Busy = false
    if profile.Persistent then
        profile.Status = if ok then (if revision == (profile.Revision or 0) then "Saved" else "Unsaved") else "SaveFailed"
    end
    Data.Publish(player)
    return ok
end
function Data.Remove(player)
    local profile = Data.Get(player)
    if not profile then return end
    -- PlayerRemoving and BindToClose can overlap during server shutdown.
    if profile.RemovalRunning then
        while Data.Profiles[player] == profile do task.wait(0.05) end
        return
    end
    profile.RemovalRunning = true
    profile.Removing = true
    Data.Save(player, true)
    profile.Mirror:Destroy()
    Data.Profiles[player] = nil
end
function Data.Start()
    task.spawn(function()
        while not Data.Closing do
            task.wait(Config.AutoSaveSeconds)
            if Data.Closing then break end
            for player, profile in pairs(Data.Profiles) do
                if not profile.Removing then task.spawn(Data.Save, player, false) end
            end
        end
    end)
    game:BindToClose(function()
        Data.Closing = true
        local pending = 0
        for player in pairs(Data.Profiles) do
            pending += 1
            task.spawn(function() Data.Remove(player); pending -= 1 end)
        end
        local deadline = os.clock() + 25
        while pending > 0 and os.clock() < deadline do task.wait(0.1) end
    end)
end
return Data
