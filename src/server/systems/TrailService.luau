local shared=game:GetService("ReplicatedStorage").StealAPackage.Shared
local Config=require(shared.Configs.TrailConfig)
local Trails={Connections={},Cursors={}}
local byId={}
for _,trail in ipairs(Config) do byId[trail.Id]=trail end
function Trails.RefreshPrompt(player)
    local plot,profile=Trails.Plot.Get(player),Trails.Data.Get(player)
    if not plot then return end
    local index=Trails.Cursors[player]
    if not index then
        index=0
        for i,trail in ipairs(Config) do if profile and profile.Data.EquippedTrail==trail.Id then index=i end end
    end
    local nextIndex=(index+1)%(#Config+1)
    local settings=Config[nextIndex]
    local prompt=plot.TrailRack.CycleTrail
    if not settings then prompt.ActionText,prompt.ObjectText="Unequip trail","No training multiplier";return end
    local owned=profile and profile.Data.OwnedTrails[settings.Id]
    prompt.ActionText=if owned then "Equip trail" else "Buy and equip"
    prompt.ObjectText=settings.Name.." • "..settings.Multiplier.."× gain"..(if owned then "" else " • $"..settings.Cost)
end
function Trails.Apply(player)
    Trails.RefreshPrompt(player)
    local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local profile=Trails.Data.Get(player)
    if not root then return end
    for _,name in ipairs({"TrainingTrail","TrainingTrailA","TrainingTrailB"}) do
        local old=root:FindFirstChild(name);if old then old:Destroy() end
    end
    local settings=profile and byId[profile.Data.EquippedTrail]
    if not settings or not profile.Data.OwnedTrails[settings.Id] then return end
    local a,b=Instance.new("Attachment"),Instance.new("Attachment")
    a.Name,b.Name="TrainingTrailA","TrainingTrailB"
    a.Position,b.Position=Vector3.new(-0.6,-1,1),Vector3.new(0.6,-1,1)
    a.Parent,b.Parent=root,root
    local trail=Instance.new("Trail")
    trail.Name,trail.Attachment0,trail.Attachment1="TrainingTrail",a,b
    trail.Color=ColorSequence.new(settings.Color)
    trail.Lifetime,trail.MinLength,trail.LightEmission=0.45,0.1,0.35
    trail.Transparency=NumberSequence.new(0.25,1)
    trail.Parent=root
end
function Trails.TryEquip(player,id)
    local profile,plot=Trails.Data.Get(player),Trails.Plot.Get(player)
    local character=player.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if not profile or profile.Removing or Trails.Data.Closing or not plot or not root or not humanoid or humanoid.Health<=0 then return false,"Not ready" end
    if (root.Position-plot.TrailRack.Position).Magnitude>8 then return false,"Too far" end
    local settings=byId[id]
    if id~="None" and not settings then return false,"Unknown trail" end
    if settings and not profile.Data.OwnedTrails[id] then
        if profile.Data.Cash<settings.Cost then Trails.Notice(player,"Need $"..settings.Cost.." for "..settings.Name);return false,"Not enough cash" end
        profile.Data.Cash-=settings.Cost
        profile.Data.OwnedTrails[id]=true
    end
    profile.Data.EquippedTrail=id
    Trails.Data.MarkChanged(player)
    Trails.Apply(player)
    Trails.Notice(player,if settings then settings.Name.." • "..settings.Multiplier.."× treadmill gain" else "Trail unequipped")
    task.spawn(Trails.Data.Save,player,false)
    return true
end
function Trails.Bind(player,plot)
    Trails.Unbind(player)
    Trails.RefreshPrompt(player)
    Trails.Connections[player]=plot.TrailRack.CycleTrail.Triggered:Connect(function(who)
        if who~=player then return end
        local index=Trails.Cursors[player]
        if not index then
            index=0
            local profile=Trails.Data.Get(player)
            for i,trail in ipairs(Config) do if profile and profile.Data.EquippedTrail==trail.Id then index=i end end
        end
        index=(index+1)%(#Config+1)
        Trails.Cursors[player]=index
        Trails.TryEquip(player,if index==0 then "None" else Config[index].Id)
    end)
end
function Trails.Unbind(player)
    local connection=Trails.Connections[player]
    if connection then connection:Disconnect();Trails.Connections[player]=nil end
    Trails.Cursors[player]=nil
end
function Trails.Init(data,plot,notice) Trails.Data,Trails.Plot,Trails.Notice=data,plot,notice end
return Trails
