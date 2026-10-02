local Config = require(game:GetService("ReplicatedStorage").StealAPackage.Shared.Configs.GameConfig)
local Hub = {}
function Hub.Contains(position)
    return position.X <= Config.HubFinishX and math.abs(position.Z) <= Config.HubHalfWidth
        and position.Y >= -2 and position.Y <= 14
end
function Hub.ClampGuardian(position)
    return Vector3.new(math.max(position.X,Config.HubFinishX+2),3,position.Z)
end
return Hub
