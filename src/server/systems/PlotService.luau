local World=require(script.Parent.WorldBuilder)
local shared=game:GetService("ReplicatedStorage").StealAPackage.Shared
local Progression=require(shared.Modules.ProgressionMath)
local Schema=require(shared.Modules.ProfileSchema)
local Rarities=require(shared.Configs.RarityConfig)
local Plot={Assignments={}}
function Plot.Claim(player)
    local index=1
    while true do
        local model=World.CreatePlot(index)
        if model:GetAttribute("OwnerUserId")==0 then
            model:SetAttribute("OwnerUserId",player.UserId)
            Plot.Assignments[player]=model
            player.RespawnLocation=model.Spawn
            player:SetAttribute("PlotName",model.Name)
            model.PlotPad.Label.Text.Text=player.DisplayName.."'s parcel depot"
            return model
        end
        index+=1
    end
end
function Plot.Get(player) return Plot.Assignments[player] end
function Plot.Contains(player,position)
    local model=Plot.Get(player)
    if not model then return false end
    local p=model.PlotPad.CFrame:PointToObjectSpace(position)
    return math.abs(p.X)<=15 and math.abs(p.Z)<=15 and p.Y>=-2 and p.Y<=12
end
function Plot.Render(player)
    local model,profile=Plot.Get(player),Plot.Data.Get(player)
    if not model or not profile then return end
    local capacity=Progression.Capacity(profile.Data)
    model:SetAttribute("Capacity",capacity)
    model.CollectibleDisplays:ClearAllChildren()
    for _,slot in ipairs(model.CollectibleSlots:GetChildren()) do
        local index=slot:GetAttribute("SlotIndex")
        local unlocked=index<=capacity
        slot:SetAttribute("Unlocked",unlocked)
        slot:SetAttribute("Occupied",profile.Data.Collectibles[index]~=nil)
        slot.Transparency=if unlocked then 0.1 else 0.75
        slot.Color=if unlocked then Color3.fromRGB(150,165,140) else Color3.fromRGB(75,75,75)
        local item=profile.Data.Collectibles[index]
        if item then
            local color=Color3.fromRGB(160,160,160)
            for _,rarity in ipairs(Rarities) do if rarity.Id==item.Rarity then color=rarity.Color end end
            local display=World.Block(model.CollectibleDisplays,item.Id,Vector3.new(1.5,1.5,1.5),slot.Position+Vector3.new(0,1,0),color)
            display.CanCollide=false
            World.Label(display,item.Name,2)
            display.Label.MaxDistance=20
        end
    end
    model.CapacityStation.Label.Text.Text="COLLECTIBLES "..#profile.Data.Collectibles.."/"..capacity.."\nR: upgrade capacity"
    model.Treadmill.Control.UpgradeTreadmill.ObjectText="Treadmill L"..profile.Data.TreadmillLevel.." • "..Progression.Rate(profile.Data).." points/s"
end
function Plot.CanStore(player)
    local profile=Plot.Data.Get(player)
    return profile~=nil and #profile.Data.Collectibles<Progression.Capacity(profile.Data)
end
function Plot.StoreCollectible(player,value)
    local profile=Plot.Data.Get(player)
    local item=Schema.NormalizeCollectible(value)
    if not profile or profile.Removing or Plot.Data.Closing or not item then return false,"Invalid collectible" end
    if not Plot.CanStore(player) then return false,"Plot capacity reached" end
    for _,owned in ipairs(profile.Data.Collectibles) do if owned.Id==item.Id then return false,"Duplicate collectible" end end
    table.insert(profile.Data.Collectibles,item)
    Plot.Data.MarkChanged(player)
    Plot.Render(player)
    return true
end
function Plot.Release(player)
    local model=Plot.Get(player)
    if model then
        model:SetAttribute("OwnerUserId",0)
        model:SetAttribute("Capacity",nil)
        model.PlotPad.Label.Text.Text=model.Name.." • unclaimed"
        model.CollectibleDisplays:ClearAllChildren()
        for _,slot in ipairs(model.CollectibleSlots:GetChildren()) do slot:SetAttribute("Unlocked",false);slot:SetAttribute("Occupied",false);slot.Transparency=0.75 end
        Plot.Assignments[player]=nil
    end
    player.RespawnLocation=nil
end
function Plot.Init(data) Plot.Data=data end
return Plot
