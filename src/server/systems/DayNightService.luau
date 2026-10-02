local Lighting=game:GetService("Lighting")
local RunService=game:GetService("RunService")
local Config=require(game:GetService("ReplicatedStorage").StealAPackage.Shared.Configs.GameConfig)
local Cycle={Phase="Day",Elapsed=0,CycleId=0}
function Cycle.Publish()
    local duration=if Cycle.Phase=="Day" then Config.DaySeconds else Config.NightSeconds
    local ratio=math.clamp(Cycle.Elapsed/duration,0,1)
    Lighting.ClockTime=if Cycle.Phase=="Day" then 6+ratio*12 else (18+ratio*12)%24
    local root=workspace.StealAPackage
    root:SetAttribute("Phase",Cycle.Phase)
    root:SetAttribute("PhaseSecondsLeft",math.ceil(duration-Cycle.Elapsed))
    root:SetAttribute("CycleId",Cycle.CycleId)
    root:SetAttribute("OpeningMultiplier",Cycle.GetOpeningMultiplier())
end
function Cycle.GetOpeningMultiplier() return if Cycle.Phase=="Night" then Config.NightOpeningMultiplier else 1 end
function Cycle.Sunrise()
    Cycle.Phase,Cycle.Elapsed="Day",0
    Cycle.CycleId+=1
    Cycle.Package.Refresh(Cycle.CycleId)
    Cycle.Publish()
end
function Cycle.Step(dt)
    Cycle.Elapsed+=math.max(dt,0)
    while true do
        local duration=if Cycle.Phase=="Day" then Config.DaySeconds else Config.NightSeconds
        if Cycle.Elapsed<duration then break end
        local remaining=Cycle.Elapsed-duration
        if Cycle.Phase=="Day" then Cycle.Phase="Night";Cycle.Elapsed=0
        else Cycle.Sunrise() end
        Cycle.Elapsed=remaining
    end
    Cycle.Publish()
end
function Cycle.Init(package)
    Cycle.Package=package
    Cycle.Sunrise()
    Cycle.Connection=RunService.Heartbeat:Connect(Cycle.Step)
end
return Cycle
