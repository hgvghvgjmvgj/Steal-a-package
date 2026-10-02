local Config = require(script.Parent.Parent.Configs.UpgradeConfig)
local Trails = require(script.Parent.Parent.Configs.TrailConfig)
local Rarities = require(script.Parent.Parent.Configs.RarityConfig)
local Schema = {}
local function number(value, maximum, integer)
    if type(value) ~= "number" or value ~= value or math.abs(value) == math.huge then return 0 end
    value = math.clamp(value, 0, maximum)
    return if integer then math.floor(value) else math.floor(value * 1000 + 0.5) / 1000
end
function Schema.NormalizeCollectible(value)
    if type(value) ~= "table" or type(value.Id) ~= "string" or #value.Id == 0 or #value.Id > 64
        or type(value.Name) ~= "string" or #value.Name == 0 or #value.Name > 64 then return nil end
    for _, rarity in ipairs(Rarities) do
        if value.Rarity == rarity.Id then return {Id=value.Id, Name=value.Name, Rarity=value.Rarity} end
    end
    return nil
end
function Schema.Normalize(value)
    local data = if type(value) == "table" then value else {}
    local points = data.TrainingPoints
    if data.Version ~= 2 then
        -- v1's +2 movement speed per purchased level becomes earned training.
        points = number(data.SpeedLevel, 5, true) * 2 * Config.PointsPerSpeedLevel
    end
    local owned = {PackingTape=true}
    for _, trail in ipairs(Trails) do
        if type(data.OwnedTrails) == "table" and data.OwnedTrails[trail.Id] == true then owned[trail.Id] = true end
    end
    local equipped = if type(data.EquippedTrail) == "string" and owned[data.EquippedTrail] then data.EquippedTrail else "None"
    local level = number(data.CapacityLevel, #Config.CapacityCosts, true)
    local collectibles, ids = {}, {}
    if type(data.Collectibles) == "table" then
        for _, entry in ipairs(data.Collectibles) do
            local item = Schema.NormalizeCollectible(entry)
            if item and not ids[item.Id] and #collectibles < Config.CapacityByLevel[level + 1] then
                ids[item.Id] = true
                table.insert(collectibles, item)
            end
        end
    end
    return {Version=2, Cash=number(data.Cash, 1000000000, true),
        TrainingPoints=number(points, Config.PointsPerSpeedLevel * Config.MaxSpeedLevel, false),
        TreadmillLevel=number(data.TreadmillLevel, #Config.TreadmillCosts, true),
        CapacityLevel=level, OwnedTrails=owned, EquippedTrail=equipped, Collectibles=collectibles}
end
return Schema
