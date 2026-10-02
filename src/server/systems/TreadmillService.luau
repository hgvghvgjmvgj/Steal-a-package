local RunService = game:GetService("RunService")
local shared = game:GetService("ReplicatedStorage").StealAPackage.Shared
local Config = require(shared.Configs.GameConfig)
local UpgradeConfig = require(shared.Configs.UpgradeConfig)
local Progression = require(shared.Modules.ProgressionMath)
local Treadmill = {Active={}, Connections={}}
function Treadmill.Start(player)
    if Treadmill.Active[player] then Treadmill.Stop(player); return true end
    local profile, plot = Treadmill.Data.Get(player), Treadmill.Plot.Get(player)
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not profile or profile.Removing or Treadmill.Data.Closing or not plot or not root or not humanoid or humanoid.Health <= 0 then return false end
    if (root.Position-plot.Treadmill.Belt.Position).Magnitude > 8 or player:GetAttribute("Carrying") ~= "" then return false end
    Treadmill.Active[player] = {Root=root, Character=character, WasAnchored=root.Anchored, Running=false, LastIntent=0, LastPacket=0}
    root.Anchored = true
    character:PivotTo(plot.Treadmill.Belt.CFrame * CFrame.new(0,3.1,0))
    player:SetAttribute("Training",true)
    player:SetAttribute("TrainingRunning",false)
    Treadmill.Notice(player,"Hold movement to RUN and train • jump to leave")
    return true
end
function Treadmill.Stop(player)
    local session = Treadmill.Active[player]
    if session then
        Treadmill.Active[player] = nil
        if session.Root.Parent then
            session.Root.Anchored = session.WasAnchored
            local plot = Treadmill.Plot.Get(player)
            if plot and player.Character == session.Character then
                player.Character:PivotTo(plot.Treadmill.Belt.CFrame * CFrame.new(0,3.1,6))
            end
        end
    end
    player:SetAttribute("Training",false)
    player:SetAttribute("TrainingRunning",false)
end
function Treadmill.Intent(player, action, running)
    local session = Treadmill.Active[player]
    if not session then return false end
    if action == "Stop" then Treadmill.Stop(player); return true end
    if action ~= "Run" or type(running) ~= "boolean" then return false end
    local now = os.clock()
    if now-session.LastPacket < 0.08 then return false end
    session.LastPacket, session.LastIntent, session.Running = now,now,running
    return true
end
function Treadmill.Advance(player, dt)
    local session, profile, plot = Treadmill.Active[player], Treadmill.Data.Get(player), Treadmill.Plot.Get(player)
    if not session then return end
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if not profile or profile.Removing or Treadmill.Data.Closing or not plot or player.Character ~= session.Character
        or not session.Root.Parent or not humanoid or humanoid.Health <= 0 then Treadmill.Stop(player); return end
    local relative = plot.Treadmill.Belt.CFrame:PointToObjectSpace(session.Root.Position)
    if math.abs(relative.X)>2.7 or math.abs(relative.Z)>3.7 or relative.Y<1 or relative.Y>5.5 then Treadmill.Stop(player); return end
    local running = session.Running and os.clock()-session.LastIntent <= Config.TrainingIntentExpiry
    player:SetAttribute("TrainingRunning",running)
    if not running then return end
    local maximum = UpgradeConfig.PointsPerSpeedLevel * UpgradeConfig.MaxSpeedLevel
    local gain = Progression.Rate(profile.Data) * math.clamp(dt,0,0.25)
    local points = math.min(maximum,profile.Data.TrainingPoints + gain)
    if points ~= profile.Data.TrainingPoints then
        profile.Data.TrainingPoints = points
        Treadmill.Data.MarkChanged(player)
        Treadmill.Data.ApplySpeed(player)
    end
end
function Treadmill.Bind(player, plot)
    Treadmill.Unbind(player)
    Treadmill.Connections[player] = plot.Treadmill.Belt.Train.Triggered:Connect(function(who)
        if who == player then Treadmill.Start(player) end
    end)
end
function Treadmill.Unbind(player)
    Treadmill.Stop(player)
    local connection = Treadmill.Connections[player]
    if connection then connection:Disconnect(); Treadmill.Connections[player]=nil end
end
function Treadmill.Init(data,plot,notice)
    Treadmill.Data,Treadmill.Plot,Treadmill.Notice=data,plot,notice
    Treadmill.RemoteConnection = game:GetService("ReplicatedStorage").StealAPackage.Remotes.TrainingIntent.OnServerEvent:Connect(Treadmill.Intent)
    local elapsed = 0
    Treadmill.Heartbeat = RunService.Heartbeat:Connect(function(dt)
        elapsed += dt
        if elapsed >= Config.TrainingTickSeconds then
            local step=elapsed;elapsed=0
            for player in pairs(Treadmill.Active) do Treadmill.Advance(player,step) end
        end
    end)
end
return Treadmill
