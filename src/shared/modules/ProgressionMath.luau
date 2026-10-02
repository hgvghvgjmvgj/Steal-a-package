local shared = script.Parent.Parent
local Config = require(shared.Configs.UpgradeConfig)
local Game = require(shared.Configs.GameConfig)
local Trails = require(shared.Configs.TrailConfig)
local Progression = {}
function Progression.Level(points)
    return math.clamp(math.floor(points / Config.PointsPerSpeedLevel), 0, Config.MaxSpeedLevel)
end
function Progression.WalkSpeed(data)
    return Game.BaseWalkSpeed + Progression.Level(data.TrainingPoints) * Config.SpeedPerLevel
end
function Progression.Multiplier(data)
    for _, trail in ipairs(Trails) do
        if trail.Id == data.EquippedTrail and data.OwnedTrails[trail.Id] then return trail.Multiplier end
    end
    return 1
end
function Progression.Rate(data)
    return Config.TreadmillRates[data.TreadmillLevel + 1] * Progression.Multiplier(data)
end
function Progression.Capacity(data) return Config.CapacityByLevel[data.CapacityLevel + 1] end
return Progression
