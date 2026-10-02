local Rarities = require(script.Parent.Parent.Configs.RarityConfig)
local Roller = {}
function Roller.Roll(area, fraction)
    local total = 0
    for _, weight in ipairs(area.RarityWeights) do assert(weight > 0); total += weight end
    local target = math.clamp(fraction, 0, 1 - 1e-12) * total
    local cumulative = 0
    for i, weight in ipairs(area.RarityWeights) do
        cumulative += weight
        if target < cumulative then return Rarities[i] end
    end
    return Rarities[#Rarities]
end
function Roller.Reward(area, rarity) return math.floor(area.Reward * rarity.RewardMultiplier + 0.5) end
return Roller
