local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local shared = ReplicatedStorage:WaitForChild("StealAPackage"):WaitForChild("Shared")
local areas = require(shared.Configs.AreaConfig)
local config = require(shared.Configs.GameConfig)
local upgrades = require(shared.Configs.UpgradeConfig)
local World = {}
World.Block = nil

local function folder(parent, name)
    local existing = parent:FindFirstChild(name)
    if existing then return existing end
    local value = Instance.new("Folder")
    value.Name = name
    value.Parent = parent
    return value
end
local function block(parent, name, size, position, color)
    local part = Instance.new("Part")
    part.Name, part.Size, part.Position = name, size, position
    part.Anchored = true
    part.Material = Enum.Material.SmoothPlastic
    part.Color = color
    part.TopSurface, part.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
    part.Parent = parent
    return part
end
local function label(part, text, height)
    local gui = Instance.new("BillboardGui")
    gui.Name = "Label"
    gui.Size = UDim2.fromOffset(240, 64)
    gui.StudsOffset = Vector3.new(0, height or 5, 0)
    gui.MaxDistance = 150
    gui.AlwaysOnTop = false
    gui.Parent = part
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Size = UDim2.fromScale(1, 1)
    textLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    textLabel.BackgroundTransparency = 0.2
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 16
    textLabel.TextWrapped = true
    textLabel.Text = text
    textLabel.Parent = gui
end


World.Block, World.Label = block, label
local function prompt(parent, name, action, key, distance)
    local value = Instance.new("ProximityPrompt")
    value.Name, value.ActionText, value.ObjectText = name, action, parent.Name
    value.KeyboardKeyCode = key
    value.HoldDuration, value.MaxActivationDistance = 0.15, distance or 8
    value.RequiresLineOfSight = false
    value.Parent = parent
    return value
end
function World.CreatePlot(index)
    local root = workspace.StealAPackage
    local name = string.format("Plot%02d", index)
    if root.Map.Plots:FindFirstChild(name) then return root.Map.Plots[name] end
    local model = Instance.new("Model")
    model.Name, model.Parent = name, root.Map.Plots
    model.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
    model:SetAttribute("Slot", index)
    model:SetAttribute("OwnerUserId", 0)
    local column, row = math.floor((index-1)/4), (index-1)%4
    local position = Vector3.new(-25-column*36,0.2,-54+row*36)
    local pad = block(model,"PlotPad",Vector3.new(30,0.4,30),position,Color3.fromRGB(85,130,110))
    model.PrimaryPart = pad
    label(pad, name .. " • unclaimed", 9)
    pad.Label.Size = UDim2.fromOffset(180,32)
    pad.Label.Text.TextSize = 13
    pad.Label.MaxDistance = 24
    local spawn = Instance.new("SpawnLocation")
    spawn.Name, spawn.Size, spawn.Position = "Spawn", Vector3.new(4,0.2,4), position+Vector3.new(0,0.4,-3)
    spawn.Anchored, spawn.Neutral, spawn.Duration, spawn.Transparency = true,true,0,1
    spawn.Parent = model
    local treadmill = Instance.new("Model")
    treadmill.Name, treadmill.Parent = "Treadmill", model
    local belt = block(treadmill,"Belt",Vector3.new(5,0.4,7),position+Vector3.new(8,0.7,1),Color3.fromRGB(35,40,40))
    treadmill.PrimaryPart = belt
    for side=-1,1,2 do
        block(treadmill,"Rail"..side,Vector3.new(0.35,3,6),belt.Position+Vector3.new(side*2.65,1.1,0),Color3.fromRGB(180,165,130)).CanCollide=false
    end
    for i=1,3 do
        block(treadmill,"BeltMark"..i,Vector3.new(4.5,0.04,0.3),belt.Position+Vector3.new(0,0.23,(i-2)*2),Color3.fromRGB(155,125,80)).CanCollide=false
    end
    local control=block(treadmill,"Control",Vector3.new(1,2,1),belt.Position+Vector3.new(-3.3,0.8,-2),Color3.fromRGB(90,135,180))
    label(control,"TREADMILL\nE: train • F: upgrade",3)
    control.Label.Size=UDim2.fromOffset(150,40)
    control.Label.Text.TextSize=14
    control.Label.MaxDistance=18
    prompt(belt,"Train","Enter / leave treadmill",Enum.KeyCode.E,8)
    prompt(control,"UpgradeTreadmill","Upgrade training rate",Enum.KeyCode.F,8).GamepadKeyCode=Enum.KeyCode.ButtonY
    local capacity=block(model,"CapacityStation",Vector3.new(3,2,3),position+Vector3.new(-9,1,-8),Color3.fromRGB(175,145,95))
    label(capacity,"COLLECTIBLE CAPACITY\nR: upgrade slots",3)
    capacity.Label.Size=UDim2.fromOffset(155,40)
    capacity.Label.Text.TextSize=14
    capacity.Label.MaxDistance=18
    prompt(capacity,"UpgradeCapacity","Expand collectible slots",Enum.KeyCode.R,8).GamepadKeyCode=Enum.KeyCode.ButtonL1
    local trail=block(model,"TrailRack",Vector3.new(3,2,3),position+Vector3.new(9,1,-8),Color3.fromRGB(100,175,170))
    label(trail,"TEST TRAILS\nT: buy / equip / cycle",3)
    trail.Label.Size=UDim2.fromOffset(145,40)
    trail.Label.Text.TextSize=14
    trail.Label.MaxDistance=18
    prompt(trail,"CycleTrail","Next training trail",Enum.KeyCode.T,8).GamepadKeyCode=Enum.KeyCode.ButtonR1
    local slots=folder(model,"CollectibleSlots")
    folder(model,"CollectibleDisplays")
    for i=1,upgrades.CapacityByLevel[#upgrades.CapacityByLevel] do
        local col,slotRow=(i-1)%4,math.floor((i-1)/4)
        local slot=block(slots,"Slot"..i,Vector3.new(3.8,0.5,2),position+Vector3.new(-9+col*5.4,0.6,6+slotRow*2.5),Color3.fromRGB(80,80,80))
        slot.CanCollide=false
        slot:SetAttribute("SlotIndex",i)
    end
    if column>=4 then
        block(model,"ExtensionFloor",Vector3.new(36,1,36),position-Vector3.new(0,0.7,0),Color3.fromRGB(105,105,105))
    end
    return model
end
function World.Build()
    local old=workspace:FindFirstChild("StealAPackage")
    if old then old:Destroy() end
    local root=folder(workspace,"StealAPackage")
    root:SetAttribute("BuildVersion","progression-2")
    local map=folder(root,"Map")
    local stageFolder=folder(map,"Areas")
    folder(map,"Plots")
    for _,name in ipairs({"Packages","Guardians","CarriedPackages"}) do folder(root,name) end
    block(map,"PlotGround",Vector3.new(200,1,180),Vector3.new(-60,-0.5,0),Color3.fromRGB(105,105,105))
    block(map,"Route",Vector3.new(510,1,180),Vector3.new(295,-0.5,0),Color3.fromRGB(120,120,120))
    block(map,"Road",Vector3.new(510,0.06,16),Vector3.new(295,0.03,0),Color3.fromRGB(65,65,65))
    local finish=block(map,"HubFinishLine",Vector3.new(2,0.12,180),Vector3.new(config.HubFinishX,0.08,0),Color3.fromRGB(110,215,170))
    finish.CanCollide=false
    local sign=block(map,"HubSign",Vector3.new(2,7,2),Vector3.new(38,3.5,40),Color3.fromRGB(110,215,170))
    label(sign,"HUB • SAFE HANDOFF\nCross the mint line to secure a parcel",6)
    for _,area in ipairs(areas) do
        local model=Instance.new("Model")
        model.Name,model.Parent=area.Id,stageFolder
        model.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
        model:SetAttribute("DisplayName",area.Name)
        model:SetAttribute("GuardianSpeed",area.ChaserSpeed)
        local stageSign=block(model,"AreaSign",Vector3.new(2,8,2),Vector3.new(area.CenterX-42,4,-35),area.Color)
        label(stageSign,area.Name.."\nGuardian speed "..area.ChaserSpeed,7)
        local spawns=folder(model,"PackageSpawns")
        for i=1,3 do
            local position=Vector3.new(area.CenterX-10,1.6,(i-2)*24)
            local marker=block(spawns,"Spot"..i,Vector3.new(5,0.2,5),position-Vector3.new(0,1.4,0),area.Color)
            marker:SetAttribute("AreaId",area.Id)
            marker:SetAttribute("PackagePosition",position)
            label(marker,"PARCEL SPOT "..i,2.5)
            marker.Label.MaxDistance=25
            block(model,"GrayboxBuilding"..i,Vector3.new(18,14+i*2,12),Vector3.new(area.CenterX+16,7+i,(i-2)*24+8),area.Color)
        end
        local home=block(model,"GuardianHome",Vector3.new(8,0.2,8),Vector3.new(area.CenterX+24,0.2,0),Color3.fromRGB(125,70,65))
        home:SetAttribute("GuardianPosition",Vector3.new(area.CenterX+24,3,0))
    end
    for i=1,config.InitialPlotCount do World.CreatePlot(i) end
    local storage=folder(ServerStorage,"StealAPackage")
    local templates=folder(storage,"Templates")
    templates:ClearAllChildren()
    folder(storage,"PlayerData")
    local package=Instance.new("Model")
    package.Name,package.Parent="Package",templates
    package.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
    local box=block(package,"Box",Vector3.new(2.5,2.5,2.5),Vector3.new(0,1.6,0),Color3.fromRGB(165,125,80))
    box.CanCollide,box.CanTouch=false,false
    package.PrimaryPart=box
    local tape=block(package,"PackingTape",Vector3.new(0.6,0.05,2.52),box.Position+Vector3.new(0,1.27,0),Color3.fromRGB(225,200,145))
    tape.Anchored,tape.CanCollide,tape.CanTouch,tape.Massless=false,false,false,true
    local weld=Instance.new("WeldConstraint")
    weld.Part0,weld.Part1,weld.Parent=box,tape,tape
    local guardian=Instance.new("Model")
    guardian.Name,guardian.Parent="Guardian",templates
    guardian.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
    local body=block(guardian,"Body",Vector3.new(4,5,4),Vector3.new(0,3,0),Color3.fromRGB(195,80,65))
    body.CanCollide,body.CanTouch=false,false
    guardian.PrimaryPart=body
    label(body,"PARCEL GUARDIAN",4)
    body.Label.MaxDistance=75
    return "Built progression-2: treadmills, collectible slots, 15 package spots, 5 guardian homes, hub finish line"
end
return World
