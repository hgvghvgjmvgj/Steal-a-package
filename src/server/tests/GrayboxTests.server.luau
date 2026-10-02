-- Opt-in Studio regression: ExecuteMultiplayerTestAsync(2,{Suite="Progression"}).
if not game:GetService("RunService"):IsStudio() then return end
local Testing=game:GetService("StudioTestService")
local argsOK,args=pcall(function() return Testing:GetTestArgs() end)
if not argsOK or type(args)~="table" or args.Suite~="Progression" then return end
local Players=game:GetService("Players")
local Http=game:GetService("HttpService")
local server=script.Parent.Parent
local shared=game:GetService("ReplicatedStorage").StealAPackage.Shared
local Game=require(shared.Configs.GameConfig)
local Areas=require(shared.Configs.AreaConfig)
local Rarities=require(shared.Configs.RarityConfig)
local Upgrades=require(shared.Configs.UpgradeConfig)
local Schema=require(shared.Modules.ProfileSchema)
local Math=require(shared.Modules.ProgressionMath)
local Roller=require(shared.Modules.RarityRoller)
local Data=require(server.Data.DataService)
local Store=require(server.Data.ProfileStore)
local Plot=require(server.Systems.PlotService)
local Hub=require(server.Systems.HubService)
local Package=require(server.Systems.PackageService)
local Guardian=require(server.Systems.ChaserService)
local Upgrade=require(server.Systems.UpgradeService)
local Treadmill=require(server.Systems.TreadmillService)
local Trails=require(server.Systems.TrailService)
local Cycle=require(server.Systems.DayNightService)
local results,originals={},{}
local probe=Instance.new("RemoteEvent")
probe.Name,probe.Parent="QAProbe",game:GetService("ReplicatedStorage").StealAPackage.Remotes
local replies={}
local probeConnection=probe.OnServerEvent:Connect(function(player,token,value)
    if type(token)=="string" and type(value)=="table" then replies[player]={Token=token,Value=value} end
end)
local function check(name,condition,detail)
    table.insert(results,{Name=name,Passed=condition==true,Detail=detail or ""})
    assert(condition,name.." failed: "..tostring(detail))
end
local function waitUntil(predicate,seconds)
    local deadline=os.clock()+(seconds or 5)
    repeat if predicate() then return true end;task.wait(0.05) until os.clock()>=deadline
    return false
end
local function move(player,position)
    local root=player.Character.HumanoidRootPart
    root.Anchored=true
    player.Character:PivotTo(CFrame.new(position))
    root.AssemblyLinearVelocity=Vector3.zero
end
local function count(value) local n=0;for _ in pairs(value) do n+=1 end;return n end
local function clientReport(player)
    local token=Http:GenerateGUID(false)
    probe:FireClient(player,token)
    assert(waitUntil(function() return replies[player] and replies[player].Token==token end,8),"Client probe did not reply")
    return replies[player].Value
end
local function reset(player,cash)
    Treadmill.Stop(player);Package.Lose(player)
    Data.Get(player).Data=Schema.Normalize({Version=2,Cash=cash or 0})
    Data.MarkChanged(player);Data.ApplySpeed(player);Plot.Render(player);Trails.Apply(player)
end
local function spawnFor(areaId,index)
    for _,spawn in ipairs(Package.Spawns) do if spawn.Area.Id==areaId and spawn.Marker.Name=="Spot"..(index or 1) then return spawn end end
    error("Missing spot")
end
local function take(player,areaId,index)
    local spawn=spawnFor(areaId,index)
    assert(spawn.Model,"Spot is empty")
    move(player,spawn.Model.PrimaryPart.Position+Vector3.new(0,2,0))
    assert(Package.TryTake(player,spawn),"Theft rejected")
    return Package.Carried[player]
end
local function escape(player)
    move(player,Vector3.new(Game.HubFinishX-1,4,0))
    assert(waitUntil(function() return Package.Carried[player]==nil end),"Hub did not secure")
end
local function trainStep(player,dt)
    move(player,Plot.Get(player).Treadmill.Belt.Position+Vector3.new(0,3,0))
    assert(Treadmill.Start(player),"Treadmill rejected")
    Treadmill.Active[player].LastPacket=0
    assert(Treadmill.Intent(player,"Run",true))
    local before=Data.Get(player).Data.TrainingPoints
    Treadmill.Advance(player,dt)
    local gain=Data.Get(player).Data.TrainingPoints-before
    Treadmill.Stop(player)
    return gain
end
local function nearStation(player,station) move(player,station.Position+Vector3.new(0,3,0)) end
local function close(a,b) return math.abs(a-b)<0.0001 end
local ok,failure=xpcall(function()
    assert(waitUntil(function()
        if #Players:GetPlayers()<2 or not server:GetAttribute("Ready") then return false end
        for _,player in ipairs(Players:GetPlayers()) do
            if not player:GetAttribute("DataReady") or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return false end
        end
        return true
    end,45),"Two loaded clients required")
    local players=Players:GetPlayers();local a,b=players[1],players[2]
    for _,player in ipairs({a,b}) do originals[player]=Schema.Normalize(Data.Get(player).Data);reset(player) end
    check("Separate player plots",Plot.Get(a)~=Plot.Get(b))
    check("Old Speed buttons removed",Plot.Get(a):FindFirstChild("SpeedUpgrade")==nil and Plot.Get(a).Treadmill~=nil)
    check("Five persistent guardians",#workspace.StealAPackage.Guardians:GetChildren()==5)
    check("Fifteen visible package spots and packages",#Package.Spawns==15 and #workspace.StealAPackage.Packages:GetChildren()==15)
    check("Hub line precedes plots",Game.HubFinishX==workspace.StealAPackage.Map.HubFinishLine.Position.X and Plot.Get(a).PlotPad.Position.X<Game.HubFinishX)
    local filter=RaycastParams.new();filter.FilterType=Enum.RaycastFilterType.Include;filter.FilterDescendantsInstances={workspace.StealAPackage.Map}
    for x=-25,490 do assert(workspace:Raycast(Vector3.new(x,10,-24),Vector3.new(0,-20,0),filter),"Ground gap "..x) end
    check("Continuous walking route",true)
    local expectedPrevious=0
    for _,area in ipairs(Areas) do
        local model=workspace.StealAPackage.Map.Areas[area.Id]
        check(area.Name.." has exactly three spots",#model.PackageSpawns:GetChildren()==3)
        check(area.Name.." has every rarity",#area.RarityWeights==#Rarities)
        local total=0;for _,w in ipairs(area.RarityWeights) do check(area.Id.." positive rarity weight "..total,w>0);total+=w end
        local cumulative,expected=0,0
        for i,weight in ipairs(area.RarityWeights) do
            local rolled=Roller.Roll(area,(cumulative+weight*0.5)/total)
            check(area.Id.." can roll "..Rarities[i].Id,rolled.Id==Rarities[i].Id)
            expected+=weight/total*Roller.Reward(area,Rarities[i])
            cumulative+=weight
        end
        check(area.Id.." reward quality increases",expected>expectedPrevious)
        expectedPrevious=expected
    end
    check("Distant theft rejected",Package.TryTake(a,spawnFor("Facility"))==false)
    move(a,Plot.Get(a).Spawn.Position+Vector3.new(0,4,0))
    check("Distant treadmill entry rejected",Treadmill.Start(a)==false)
    nearStation(b,Plot.Get(a).Treadmill.Belt)
    check("Other player's treadmill cannot train you",Treadmill.Start(b)==false)
    nearStation(a,Plot.Get(a).Treadmill.Belt)
    check("Owner can enter physical belt",Treadmill.Start(a))
    local before=Data.Get(a).Data.TrainingPoints
    task.wait(0.35)
    check("Standing idle does not train",Data.Get(a).Data.TrainingPoints==before)
    check("Malformed running intent rejected",Treadmill.Intent(a,"Run","yes")==false)
    Treadmill.Active[a].LastPacket=0
    check("Running intent accepted",Treadmill.Intent(a,"Run",true))
    Treadmill.Advance(a,0.2)
    check("Base running gain",close(Data.Get(a).Data.TrainingPoints-before,1.2))
    Treadmill.Active[a].LastIntent=os.clock()-Game.TrainingIntentExpiry-1
    local stopped=Data.Get(a).Data.TrainingPoints
    Treadmill.Advance(a,0.2)
    check("Stale input cannot continue training",Data.Get(a).Data.TrainingPoints==stopped)
    check("Stop releases training state",Treadmill.Intent(a,"Stop",false) and Treadmill.Active[a]==nil and a:GetAttribute("Training")==false)
    reset(a,10000)
    nearStation(a,Plot.Get(a).Treadmill.Control)
    local movement=a.Character.Humanoid.WalkSpeed
    check("Treadmill upgrade spends cash",Upgrade.TryBuy(a,"Treadmill") and Data.Get(a).Data.Cash==9925 and Data.Get(a).Data.TreadmillLevel==1)
    check("Belt upgrade does not directly change movement",a.Character.Humanoid.WalkSpeed==movement)
    check("Upgraded training rate",close(trainStep(a,0.2),1.8))
    check("Training is isolated from other player",Data.Get(b).Data.TrainingPoints==0)
    nearStation(a,Plot.Get(a).TrailRack)
    check("Unrecognized trail rejected",Trails.TryEquip(a,"Fake")==false)
    local cash=Data.Get(a).Data.Cash
    check("Trail bought and equipped",Trails.TryEquip(a,"CourierRibbon") and Data.Get(a).Data.OwnedTrails.CourierRibbon and Data.Get(a).Data.Cash==cash-100)
    check("Trail multiplies training only",a:GetAttribute("TrailMultiplier")==1.35 and a.Character.Humanoid.WalkSpeed==16)
    check("Trail visual exists",a.Character.HumanoidRootPart:FindFirstChild("TrainingTrail")~=nil)
    check("Trail gain math",close(trainStep(a,0.2),9*1.35*0.2))
    nearStation(a,Plot.Get(a).TrailRack);cash=Data.Get(a).Data.Cash
    check("Owned trail is not charged twice",Trails.TryEquip(a,"CourierRibbon") and Data.Get(a).Data.Cash==cash)
    check("Unequip clears visual and multiplier",Trails.TryEquip(a,"None") and a:GetAttribute("TrailMultiplier")==1 and a.Character.HumanoidRootPart:FindFirstChild("TrainingTrail")==nil)
    nearStation(b,Plot.Get(a).TrailRack)
    check("Another plot cannot buy/equip for you",Trails.TryEquip(b,"DispatchBeam")==false)
    Data.Get(a).Data.TrainingPoints=29.8;Data.MarkChanged(a)
    trainStep(a,0.2)
    check("Earned threshold raises movement by one",a.Character.Humanoid.WalkSpeed==17)
    Data.Get(a).Data.TrainingPoints=Upgrades.PointsPerSpeedLevel*Upgrades.MaxSpeedLevel-0.1
    trainStep(a,0.2)
    check("Training has finite movement cap",Data.Get(a).Data.TrainingPoints==720 and a.Character.Humanoid.WalkSpeed==40)
    reset(a,10000)
    check("Initial collectible capacity is three",a:GetAttribute("PlotCapacity")==3)
    for i=1,3 do check("Store placeholder collectible "..i,Plot.StoreCollectible(a,{Id="QA"..i,Name="Test manifest "..i,Rarity="Standard"})) end
    check("Storage rejects full plot",Plot.StoreCollectible(a,{Id="QA4",Name="Test manifest",Rarity="Standard"})==false)
    check("Three stored displays rendered",#Plot.Get(a).CollectibleDisplays:GetChildren()==3)
    nearStation(a,Plot.Get(a).CapacityStation);cash=Data.Get(a).Data.Cash
    check("Capacity upgrade unlocks six slots",Upgrade.TryBuy(a,"Capacity") and a:GetAttribute("PlotCapacity")==6 and Data.Get(a).Data.Cash==cash-100)
    check("New capacity accepts fourth collectible",Plot.StoreCollectible(a,{Id="QA4",Name="Test manifest 4",Rarity="Priority"}))
    check("Duplicate/invalid collectibles rejected",Plot.StoreCollectible(a,{Id="QA4",Name="Duplicate",Rarity="Priority"})==false and Plot.StoreCollectible(a,{Id="Bad",Name="Bad",Rarity="Fake"})==false)
    check("Fourth pedestal is unlocked",Plot.Get(a).CollectibleSlots.Slot4:GetAttribute("Unlocked")==true)
    nearStation(b,Plot.Get(a).CapacityStation)
    check("Capacity purchase is owner-only",Upgrade.TryBuy(b,"Capacity")==false)
    nearStation(a,Plot.Get(a).CapacityStation)
    assert(Upgrade.TryBuy(a,"Capacity"));assert(Upgrade.TryBuy(a,"Capacity"))
    check("Capacity tops out at twelve",a:GetAttribute("PlotCapacity")==12 and Upgrade.TryBuy(a,"Capacity")==false)
    nearStation(a,Plot.Get(a).Treadmill.Control)
    for i=1,4 do assert(Upgrade.TryBuy(a,"Treadmill")) end
    check("Belt levels have a finite cap",Data.Get(a).Data.TreadmillLevel==4 and Upgrade.TryBuy(a,"Treadmill")==false)
    reset(b,0);nearStation(b,Plot.Get(b).CapacityStation)
    check("Insufficient funds reject upgrades",Upgrade.TryBuy(b,"Capacity")==false)
    nearStation(b,Plot.Get(b).TrailRack)
    check("Insufficient funds reject trail purchase",Trails.TryEquip(b,"DispatchBeam")==false)
    local migrated=Schema.Normalize({Version=1,Cash=77,SpeedLevel=3})
    check("Old cash and Speed migrate without losing movement",migrated.Cash==77 and migrated.TrainingPoints==180 and Math.WalkSpeed(migrated)==22)
    local malformed=Schema.Normalize({Version=2,Cash=0/0,TrainingPoints=math.huge,TreadmillLevel=99,CapacityLevel=-1,EquippedTrail="Fake",OwnedTrails={Fake=true}})
    check("Malformed progression is normalized",malformed.Cash==0 and malformed.TrainingPoints==0 and malformed.TreadmillLevel==4 and malformed.CapacityLevel==0 and malformed.EquippedTrail=="None")
    reset(a);reset(b);Cycle.Sunrise()
    local stolen=take(a,"StarterStreet",1)
    local spot=spawnFor("StarterStreet",1)
    check("Theft empties its spot",spot.Model==nil and #workspace.StealAPackage.Packages:GetChildren()==14)
    move(b,spot.Marker:GetAttribute("PackagePosition")+Vector3.new(0,2,0))
    check("Atomic claim prevents duplicate theft",Package.TryTake(b,spot)==false)
    check("Exactly that stage guardian activates",Guardian.Active[a].Guardian==Guardian.Guardians.StarterStreet and Guardian.Guardians.Neighborhood.Model:GetAttribute("State")=="Idle")
    take(b,"StarterStreet",2)
    check("Concurrent thieves share one guardian",Guardian.Active[a].Guardian==Guardian.Active[b].Guardian and #workspace.StealAPackage.Guardians:GetChildren()==5)
    local extra=spawnFor("StarterStreet",3);move(a,extra.Model.PrimaryPart.Position+Vector3.new(0,2,0))
    check("One-package carrying limit remains",Package.TryTake(a,extra)==false)
    local bValue=Package.Carried[b].Reward
    escape(a)
    check("Finish line awards before reaching own plot",Data.Get(a).Data.Cash==stolen.Reward and not Plot.Contains(a,a.Character.HumanoidRootPart.Position))
    check("Escape clears only your threat",Guardian.Active[a]==nil and Guardian.Active[b]~=nil)
    task.wait(0.2)
    check("Safe-zone cash cannot duplicate",Data.Get(a).Data.Cash==stolen.Reward)
    local guard=Guardian.Guardians.StarterStreet
    Guardian.Active[b].StartsAt=0
    move(b,guard.Model.PrimaryPart.Position+Vector3.new(0,1,0))
    check("Guardian catches remaining thief without cash",waitUntil(function() return Package.Carried[b]==nil end) and Data.Get(b).Data.Cash==0)
    for _,item in pairs(Guardian.Guardians) do check(item.Area.Id.." cannot enter hub",item.Model.PrimaryPart.Position.X>Game.HubFinishX) end
    check("Taken spots wait for sunrise",spawnFor("StarterStreet",1).Model==nil and spawnFor("StarterStreet",2).Model==nil)
    Cycle.Sunrise();check("Sunrise replenishes all fifteen together",#workspace.StealAPackage.Packages:GetChildren()==15)
    for _,spawn in ipairs(Package.Spawns) do check("Same refresh generation "..spawn.Area.Id..spawn.Marker.Name,spawn.CycleId==Cycle.CycleId and spawn.Model:GetAttribute("CycleId")==Cycle.CycleId) end
    local priorSpeed=0
    for _,area in ipairs(Areas) do
        local carried=take(a,area.Id,1)
        local active=Guardian.Active[a];active.StartsAt=0
        check(area.Id.." is open and increasingly fast",active.Area.ChaserSpeed==area.ChaserSpeed and area.ChaserSpeed>priorSpeed)
        priorSpeed=area.ChaserSpeed
        local beforePosition=active.Guardian.Model.PrimaryPart.Position
        task.wait(0.2)
        check(area.Id.." guardian pursues its thief",(active.Guardian.Model.PrimaryPart.Position-beforePosition).Magnitude>0.5)
        local priorCash=Data.Get(a).Data.Cash
        escape(a)
        check(area.Id.." rarity reward secured",Data.Get(a).Data.Cash==priorCash+carried.Reward)
    end
    Cycle.Sunrise()
    local inFlight=take(a,"Neighborhood",2)
    local reward,visual,oldCycle=inFlight.Reward,inFlight.Visual,inFlight.CycleId
    Cycle.Elapsed=Game.DaySeconds-0.1;Cycle.Step(0.2)
    check("Short night begins without refreshing packages",Cycle.Phase=="Night" and Cycle.GetOpeningMultiplier()==8 and Package.CycleId==oldCycle)
    Cycle.Elapsed=Game.NightSeconds-0.1;Cycle.Step(0.2)
    check("Sunrise exits night and refreshes once",Cycle.Phase=="Day" and Cycle.GetOpeningMultiplier()==1 and Package.CycleId==oldCycle+1)
    check("Refresh preserves carried package and pursuit",Package.Carried[a].Visual==visual and Package.Carried[a].Reward==reward and Guardian.Active[a]~=nil)
    check("New sunrise has fifteen packages",#workspace.StealAPackage.Packages:GetChildren()==15)
    escape(a)
    for i=1,5 do Cycle.Sunrise();take(a,"StarterStreet",3);escape(a) end
    check("Repeated sunrise cycles do not duplicate entities",#workspace.StealAPackage.Packages:GetChildren()==14 and #workspace.StealAPackage.Guardians:GetChildren()==5 and #workspace.StealAPackage.CarriedPackages:GetChildren()==0)
    reset(a,1000)
    nearStation(a,Plot.Get(a).TrailRack);assert(Trails.TryEquip(a,"CourierRibbon"))
    Data.Get(a).Data.TrainingPoints=90;Data.MarkChanged(a);Data.ApplySpeed(a)
    nearStation(a,Plot.Get(a).Treadmill.Belt);assert(Treadmill.Start(a))
    a.Character.Humanoid.Health=0
    check("Death stops training and unlocks root",waitUntil(function() return Treadmill.Active[a]==nil and a:GetAttribute("Training")==false end))
    a:LoadCharacterAsync()
    check("Respawn retains learned speed and trail",waitUntil(function() return a.Character and a.Character:FindFirstChild("HumanoidRootPart") and a.Character.Humanoid.WalkSpeed==19 and a.Character.HumanoidRootPart:FindFirstChild("TrainingTrail") end,10))
    check("Respawn returns to own depot",waitUntil(function() return Plot.Contains(a,a.Character.HumanoidRootPart.Position) end,10))
    local response=clientReport(a)
    check("Client HUD survives without duplication",response.HUDCount==1 and response.WalkSpeed==19 and response.Trail==true)
    Cycle.Sunrise();take(a,"RichStreet",1);a:LoadCharacterAsync()
    check("Reset clears carried package and shared threat",waitUntil(function() return Package.Carried[a]==nil and Guardian.Active[a]==nil end,10))
    local records,now={},1000
    local fake={}
    function fake:UpdateAsync(key,callback)
        local old=if records[key] then Http:JSONDecode(records[key]) else nil
        local value=callback(old)
        if value then records[key]=Http:JSONEncode(value);return Http:JSONDecode(records[key]) end
        return nil
    end
    local one=Store.new(fake,"one",function() return now end)
    local two=Store.new(fake,"two",function() return now end)
    check("Profile acquisition uses defaults",one:Acquire("qa").Version==2)
    check("Concurrent session blocked",two:Acquire("qa")==nil)
    local saved=Schema.Normalize({Version=2,Cash=123,TrainingPoints=87.25,TreadmillLevel=2,CapacityLevel=1,OwnedTrails={DispatchBeam=true},EquippedTrail="DispatchBeam",Collectibles={{Id="Saved",Name="Saved manifest",Rarity="Vault"}}})
    check("All progression fields save with lease release",one:Save("qa",saved,true))
    local loaded=two:Acquire("qa")
    check("Training/trail/capacity/collectibles survive serialized reload",loaded.TrainingPoints==87.25 and loaded.TreadmillLevel==2 and loaded.CapacityLevel==1 and loaded.EquippedTrail=="DispatchBeam" and loaded.OwnedTrails.DispatchBeam and #loaded.Collectibles==1)
    check("Stale server cannot overwrite",one:Save("qa",Schema.Normalize(nil),false)==false)
    now+=Game.SessionLeaseSeconds+1
    check("Expired lease recovers stored progression",one:Acquire("qa").TrainingPoints==87.25)
    local real=game:GetService("DataStoreService"):GetDataStore(Game.DataStoreName.."_QA")
    local key="progression:"..Http:GenerateGUID(false)
    local realOne,realTwo=Store.new(real,"real-one"),Store.new(real,"real-two")
    assert(realOne:Acquire(key));assert(realOne:Save(key,saved,true))
    local reopened=realTwo:Acquire(key)
    check("Actual Roblox progression reload",reopened.Cash==123 and reopened.TrainingPoints==87.25 and reopened.TreadmillLevel==2 and reopened.CapacityLevel==1 and reopened.EquippedTrail=="DispatchBeam" and reopened.Collectibles[1].Rarity=="Vault")
    assert(realTwo:Save(key,reopened,true));real:RemoveAsync(key)
    Data.Get(b).Data=originals[b];Data.MarkChanged(b)
    local releasedPlot=Plot.Get(b)
    nearStation(b,releasedPlot.Treadmill.Belt);assert(Treadmill.Start(b))
    workspace:SetAttribute("QA_DisconnectUserId",b.UserId)
    check("Disconnect cleans treadmill, profile, trail connections and plot",waitUntil(function()
        return not b.Parent and Treadmill.Active[b]==nil and Treadmill.Connections[b]==nil and Trails.Connections[b]==nil
            and Upgrade.Connections[b]==nil and Data.Get(b)==nil and Plot.Get(b)==nil and Guardian.Active[b]==nil
    end,25))
    check("Disconnected plot is released",releasedPlot:GetAttribute("OwnerUserId")==0 and #releasedPlot.CollectibleDisplays:GetChildren()==0)
    Testing:AddPlayers(1)
    local replacement
    check("Replacement client loads",waitUntil(function()
        for _,player in ipairs(Players:GetPlayers()) do if player~=a and player:GetAttribute("DataReady") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then replacement=player;return true end end
        return false
    end,40))
    check("Replacement reuses released plot",Plot.Get(replacement)==releasedPlot)
    check("Remaining client still has usable treadmill",Treadmill.Connections[a]~=nil and Data.Get(a)~=nil)
    Cycle.Sunrise()
    check("Final populations stay bounded",#workspace.StealAPackage.Packages:GetChildren()==15 and #workspace.StealAPackage.Guardians:GetChildren()==5 and #workspace.StealAPackage.CarriedPackages:GetChildren()==0)
end,debug.traceback)
for player,original in pairs(originals) do
    Treadmill.Stop(player);Package.Lose(player)
    local profile=Data.Get(player)
    if profile then profile.Data=original;Data.MarkChanged(player);Data.ApplySpeed(player);Trails.Apply(player);Plot.Render(player);Data.Save(player,false) end
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.Anchored=false end
end
workspace:SetAttribute("QA_DisconnectUserId",nil)
probeConnection:Disconnect();probe:Destroy()
local report={Suite="Progression",Passed=ok,Failure=if ok then nil else failure,Results=results}
print("[StealAPackage QA] "..Http:JSONEncode(report))
Testing:EndTest(report)
