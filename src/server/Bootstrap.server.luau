local Players=game:GetService("Players")
local root=script.Parent
root:SetAttribute("Ready",false)
local World=require(root.Systems.WorldBuilder)
local world=workspace:FindFirstChild("StealAPackage")
if not world or world:GetAttribute("BuildVersion")~="progression-2" then World.Build() end
local Data=require(root.Data.DataService)
local Plot=require(root.Systems.PlotService)
local Guardian=require(root.Systems.ChaserService)
local Package=require(root.Systems.PackageService)
local Upgrade=require(root.Systems.UpgradeService)
local Treadmill=require(root.Systems.TreadmillService)
local Trails=require(root.Systems.TrailService)
local Cycle=require(root.Systems.DayNightService)
local remote=game:GetService("ReplicatedStorage").StealAPackage.Remotes.Notice
local function notice(player,message) if player.Parent then remote:FireClient(player,message) end end
local connections={}
Plot.Init(Data)
Upgrade.Init(Data,Plot,notice)
Treadmill.Init(Data,Plot,notice)
Trails.Init(Data,Plot,notice)
Package.Init(Data,Guardian,notice)
Guardian.Init(Package.Secure,Package.Lose)
Cycle.Init(Package)
Data.Start()
local function characterReady(player,character)
    Treadmill.Stop(player)
    Package.Lose(player,"Parcel lost on respawn")
    local humanoid=character:WaitForChild("Humanoid",10)
    local characterRoot=character:WaitForChild("HumanoidRootPart",10)
    if not humanoid or not characterRoot or player.Character~=character or not player.Parent then return end
    local state=connections[player]
    if not state then return end
    if state.Death then state.Death:Disconnect() end
    state.Death=humanoid.Died:Connect(function()
        Treadmill.Stop(player)
        Package.Lose(player,"Parcel lost on death")
    end)
    if Data.Get(player) then Data.ApplySpeed(player);Trails.Apply(player);Plot.Render(player) end
    local plot=Plot.Get(player)
    if plot then character:PivotTo(plot.Spawn.CFrame+Vector3.new(0,4,0)) end
end
local function added(player)
    if connections[player] then return end
    local plot=Plot.Claim(player)
    Upgrade.Bind(player,plot)
    Treadmill.Bind(player,plot)
    Trails.Bind(player,plot)
    player:SetAttribute("Carrying","")
    player:SetAttribute("GuardianSpeed",0)
    player:SetAttribute("Training",false)
    player:SetAttribute("TrainingRunning",false)
    connections[player]={
        Added=player.CharacterAdded:Connect(function(character) characterReady(player,character) end),
        Removing=player.CharacterRemoving:Connect(function() Treadmill.Stop(player);Package.Lose(player,"Parcel lost on reset") end),
    }
    if player.Character then task.spawn(characterReady,player,player.Character) end
    if Data.Load(player) then
        Data.ApplySpeed(player);Trails.Apply(player);Plot.Render(player)
    end
end
local function removing(player)
    Treadmill.Unbind(player)
    Trails.Unbind(player)
    Package.Lose(player)
    Upgrade.Unbind(player)
    Plot.Release(player)
    local state=connections[player]
    if state then for _,connection in pairs(state) do connection:Disconnect() end;connections[player]=nil end
    Data.Remove(player)
end
Players.PlayerAdded:Connect(function(player) task.spawn(added,player) end)
Players.PlayerRemoving:Connect(removing)
for _,player in ipairs(Players:GetPlayers()) do task.spawn(added,player) end
root:SetAttribute("Ready",true)
print("[StealAPackage] Progression ready: treadmill/trails/capacity • sunrise parcels • hub-safe guardians")
