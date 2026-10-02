local shared=game:GetService("ReplicatedStorage").StealAPackage.Shared
local Config=require(shared.Configs.GameConfig)
local Areas=require(shared.Configs.AreaConfig)
local Roller=require(shared.Modules.RarityRoller)
local Hub=require(script.Parent.HubService)
local World=require(script.Parent.WorldBuilder)
local template=game:GetService("ServerStorage").StealAPackage.Templates.Package
local Package={Carried={},Spawns={},CycleId=0}
local rng=Random.new()
local function aliveRoot(player)
    local character=player.Character
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    return if humanoid and humanoid.Health>0 then character:FindFirstChild("HumanoidRootPart") else nil
end
local function buildPackage(spawn,cycle,parent)
    local rarity=Roller.Roll(spawn.Area,rng:NextNumber())
    local reward=Roller.Reward(spawn.Area,rarity)
    local model=template:Clone()
    model.Name=spawn.Area.Id.."_"..spawn.Marker.Name
    model:SetAttribute("AreaId",spawn.Area.Id)
    model:SetAttribute("RarityId",rarity.Id)
    model:SetAttribute("Reward",reward)
    model:SetAttribute("CycleId",cycle)
    model.PrimaryPart.Color=rarity.Color
    model:PivotTo(CFrame.new(spawn.Marker:GetAttribute("PackagePosition")))
    World.Label(model.PrimaryPart,rarity.Name.."\n$"..reward,2.7)
    model.PrimaryPart.Label.MaxDistance=40
    model.Parent=parent
    local prompt=Instance.new("ProximityPrompt")
    prompt.Name,prompt.ActionText,prompt.ObjectText="Steal","Steal parcel",rarity.Name.." • $"..reward
    prompt.HoldDuration,prompt.MaxActivationDistance=0.15,Config.PickupDistance
    prompt.RequiresLineOfSight=false
    prompt.Parent=model.PrimaryPart
    prompt.Triggered:Connect(function(player) if spawn.Model==model then Package.TryTake(player,spawn) end end)
    return {Model=model,Rarity=rarity,Reward=reward,CycleId=cycle}
end
function Package.Refresh(cycle)
    -- Prepare all fifteen rolls first, then commit together with no yields.
    local staging=Instance.new("Folder")
    staging.Name="SunriseStaging"
    staging.Parent=game:GetService("ServerStorage").StealAPackage
    local prepared={}
    for i,spawn in ipairs(Package.Spawns) do prepared[i]=buildPackage(spawn,cycle,staging) end
    for i,spawn in ipairs(Package.Spawns) do
        if spawn.Model then spawn.Model:Destroy() end
        local ready=prepared[i]
        spawn.Model,spawn.Rarity,spawn.Reward,spawn.CycleId=ready.Model,ready.Rarity,ready.Reward,ready.CycleId
        ready.Model.Parent=workspace.StealAPackage.Packages
        spawn.Marker:SetAttribute("Occupied",true)
        spawn.Marker:SetAttribute("CycleId",cycle)
        spawn.Marker.Label.Text.Text="PARCEL SPOT "..((i-1)%3+1)
    end
    staging:Destroy()
    Package.CycleId=cycle
    workspace.StealAPackage:SetAttribute("PackageCycleId",cycle)
end
function Package.TryTake(player,spawn)
    local root,profile=aliveRoot(player),Package.Data.Get(player)
    if not root or not profile or profile.Removing or Package.Data.Closing or player:GetAttribute("Training") then return false,"Not ready" end
    if Package.Carried[player] then Package.Notice(player,"You can carry only one parcel");return false,"Already carrying" end
    local model=spawn and spawn.Model
    if not model or not model.Parent then return false,"Spot empty until sunrise" end
    if (root.Position-model.PrimaryPart.Position).Magnitude>Config.PickupDistance then return false,"Too far" end
    local rarity,reward,cycle=spawn.Rarity,spawn.Reward,spawn.CycleId
    spawn.Model=nil
    model:Destroy()
    spawn.Marker:SetAttribute("Occupied",false)
    spawn.Marker.Label.Text.Text="TAKEN • refreshes at sunrise"
    local visual=template:Clone()
    visual.Name="Carried_"..player.UserId
    visual:SetAttribute("OwnerUserId",player.UserId)
    visual.PrimaryPart.Color=rarity.Color
    visual.PrimaryPart.Anchored,visual.PrimaryPart.Massless=false,true
    visual:PivotTo(root.CFrame*CFrame.new(0,0,-2.5))
    local weld=Instance.new("WeldConstraint")
    weld.Part0,weld.Part1,weld.Parent=root,visual.PrimaryPart,visual.PrimaryPart
    visual.Parent=workspace.StealAPackage.CarriedPackages
    Package.Carried[player]={Area=spawn.Area,Visual=visual,Rarity=rarity,Reward=reward,CycleId=cycle}
    player:SetAttribute("Carrying",rarity.Name.." • "..spawn.Area.Name)
    player:SetAttribute("GuardianSpeed",spawn.Area.ChaserSpeed)
    Package.Guardian.Start(player,spawn.Area)
    Package.Notice(player,"Parcel stolen! Cross the mint HUB finish line to escape")
    return true
end
function Package.Clear(player)
    local carried=Package.Carried[player]
    if carried then carried.Visual:Destroy();Package.Carried[player]=nil end
    Package.Guardian.Stop(player)
    player:SetAttribute("Carrying","")
    player:SetAttribute("GuardianSpeed",0)
    return carried
end
function Package.Lose(player,message)
    local carried=Package.Clear(player)
    if carried and player.Parent then Package.Notice(player,message or "Parcel lost") end
end
function Package.Secure(player)
    local root=aliveRoot(player)
    if not root or not Hub.Contains(root.Position) then return false end
    local carried=Package.Clear(player)
    if not carried then return false end
    if Package.Data.AddCash(player,carried.Reward) then Package.Notice(player,"Safe handoff! +$"..carried.Reward);return true end
    return false
end
function Package.Init(data,guardian,notice)
    Package.Data,Package.Guardian,Package.Notice=data,guardian,notice
    for _,area in ipairs(Areas) do
        local model=workspace.StealAPackage.Map.Areas[area.Id]
        for i=1,3 do table.insert(Package.Spawns,{Marker=model.PackageSpawns["Spot"..i],Area=area}) end
    end
end
return Package
