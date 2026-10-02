local Config=require(game:GetService("ReplicatedStorage").StealAPackage.Shared.Configs.UpgradeConfig)
local Upgrade={Connections={}}
function Upgrade.TryBuy(player,kind)
    local profile,plot=Upgrade.Data.Get(player),Upgrade.Plot.Get(player)
    local character=player.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if not profile or profile.Removing or Upgrade.Data.Closing or not plot or not root or not humanoid or humanoid.Health<=0 then return false,"Not ready" end
    local field,costs,station
    if kind=="Treadmill" then field,costs,station="TreadmillLevel",Config.TreadmillCosts,plot.Treadmill.Control
    elseif kind=="Capacity" then field,costs,station="CapacityLevel",Config.CapacityCosts,plot.CapacityStation
    else return false,"Unknown upgrade" end
    if (root.Position-station.Position).Magnitude>8 then return false,"Too far" end
    local level=profile.Data[field]
    local cost=costs[level+1]
    if not cost then Upgrade.Notice(player,kind.." is at maximum");return false,"Maximum level" end
    if profile.Data.Cash<cost then Upgrade.Notice(player,"Need $"..cost.." for "..kind);return false,"Not enough cash" end
    profile.Data.Cash-=cost
    profile.Data[field]+=1
    Upgrade.Data.MarkChanged(player)
    Upgrade.Plot.Render(player)
    Upgrade.Notice(player,kind.." upgraded! -$"..cost)
    task.spawn(Upgrade.Data.Save,player,false)
    return true
end
function Upgrade.Bind(player,plot)
    Upgrade.Unbind(player)
    Upgrade.Connections[player]={
        plot.Treadmill.Control.UpgradeTreadmill.Triggered:Connect(function(who) if who==player then Upgrade.TryBuy(player,"Treadmill") end end),
        plot.CapacityStation.UpgradeCapacity.Triggered:Connect(function(who) if who==player then Upgrade.TryBuy(player,"Capacity") end end),
    }
end
function Upgrade.Unbind(player)
    local list=Upgrade.Connections[player]
    if list then for _,connection in ipairs(list) do connection:Disconnect() end;Upgrade.Connections[player]=nil end
end
function Upgrade.Init(data,plot,notice) Upgrade.Data,Upgrade.Plot,Upgrade.Notice=data,plot,notice end
return Upgrade
