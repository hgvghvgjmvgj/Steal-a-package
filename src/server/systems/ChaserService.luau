-- One persistent guardian per stage, with a shared threat list for simultaneous thieves.
local RunService=game:GetService("RunService")
local shared=game:GetService("ReplicatedStorage").StealAPackage.Shared
local Config=require(shared.Configs.GameConfig)
local Areas=require(shared.Configs.AreaConfig)
local Hub=require(script.Parent.HubService)
local template=game:GetService("ServerStorage").StealAPackage.Templates.Guardian
local Guardian={Active={},Guardians={}}
function Guardian.Start(player,area)
    Guardian.Stop(player)
    local guard=Guardian.Guardians[area.Id]
    local threat={Guardian=guard,Area=area,StartsAt=os.clock()+Config.ChaseWarningSeconds}
    guard.Targets[player]=threat
    Guardian.Active[player]=threat
end
function Guardian.Stop(player)
    local threat=Guardian.Active[player]
    if threat then threat.Guardian.Targets[player]=nil;Guardian.Active[player]=nil end
end
function Guardian.Step(dt)
    for _,guard in pairs(Guardian.Guardians) do
        local chosen,closest=nil,math.huge
        local origin=guard.Model.PrimaryPart.Position
        for player,threat in pairs(guard.Targets) do
            local character=player.Character
            local root=character and character:FindFirstChild("HumanoidRootPart")
            local humanoid=character and character:FindFirstChildOfClass("Humanoid")
            if not player.Parent or not root or not humanoid or humanoid.Health<=0 then
                Guardian.OnCaught(player,"Package lost on respawn")
            elseif Hub.Contains(root.Position) then
                Guardian.OnSecure(player)
            elseif os.clock()>=threat.StartsAt then
                local distance=(Vector3.new(root.Position.X,3,root.Position.Z)-origin).Magnitude
                if distance<closest then chosen,closest=root,distance end
            end
        end
        local target=if chosen then Hub.ClampGuardian(chosen.Position) else guard.Home
        local delta=target-origin
        local distance=delta.Magnitude
        local step=math.min(distance,guard.Area.ChaserSpeed*math.min(dt,0.1))
        local position=Hub.ClampGuardian(if distance>0.001 then origin+delta.Unit*step else origin)
        guard.Model:PivotTo(if (target-position).Magnitude>0.01 then CFrame.lookAt(position,target) else CFrame.new(position))
        guard.Model:SetAttribute("State",if chosen then "Chasing" elseif distance>0.2 then "Returning" else "Idle")
        local targetCount=0
        for player,threat in pairs(guard.Targets) do
            targetCount+=1
            local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root and os.clock()>=threat.StartsAt and not Hub.Contains(root.Position)
                and (Vector3.new(root.Position.X,3,root.Position.Z)-position).Magnitude<=Config.CatchRadius
                and math.abs(root.Position.Y-3)<=Config.CatchHeight then Guardian.OnCaught(player,"Guardian caught you! Parcel lost") end
        end
        guard.Model:SetAttribute("ThreatCount",targetCount)
    end
end
function Guardian.Init(onSecure,onCaught)
    Guardian.OnSecure,Guardian.OnCaught=onSecure,onCaught
    for i,area in ipairs(Areas) do
        local home=workspace.StealAPackage.Map.Areas[area.Id].GuardianHome:GetAttribute("GuardianPosition")
        local model=template:Clone()
        model.Name=area.Id.."Guardian"
        model:SetAttribute("AreaId",area.Id)
        model:SetAttribute("Speed",area.ChaserSpeed)
        model:SetAttribute("State","Idle")
        model:SetAttribute("ThreatCount",0)
        model.PrimaryPart.Size=Vector3.new(4+(i-1)*0.3,5,4+(i-1)*0.3)
        model.Body.Label.Text.Text=area.Name.." guardian\nSpeed "..area.ChaserSpeed
        model:PivotTo(CFrame.new(home))
        model.Parent=workspace.StealAPackage.Guardians
        Guardian.Guardians[area.Id]={Model=model,Area=area,Home=home,Targets={}}
    end
    Guardian.Connection=RunService.Heartbeat:Connect(Guardian.Step)
end
return Guardian
