local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local player=Players.LocalPlayer
local replicated=game:GetService("ReplicatedStorage"):WaitForChild("StealAPackage")
local remotes=replicated:WaitForChild("Remotes")
local UpgradeConfig=require(replicated.Shared.Configs.UpgradeConfig)
local world=workspace:WaitForChild("StealAPackage")
local gui=Instance.new("ScreenGui")
gui.Name,gui.ResetOnSpawn,gui.DisplayOrder="GrayboxHUD",false,10
gui.Parent=player:WaitForChild("PlayerGui")
local info=Instance.new("TextLabel")
info.Name,info.Position,info.Size="Status",UDim2.fromOffset(12,12),UDim2.new(0,390,0,200)
info.BackgroundColor3,info.BackgroundTransparency=Color3.fromRGB(25,25,25),0.15
info.TextColor3,info.Font,info.TextSize=Color3.new(1,1,1),Enum.Font.Code,15
info.TextXAlignment,info.TextYAlignment=Enum.TextXAlignment.Left,Enum.TextYAlignment.Top
info.TextWrapped=true
info.Parent=gui
local message=Instance.new("TextLabel")
message.Name,message.AnchorPoint="Notice",Vector2.new(0.5,1)
message.Position,message.Size=UDim2.new(0.5,0,1,-24),UDim2.new(0.8,0,0,50)
message.BackgroundColor3,message.BackgroundTransparency=Color3.fromRGB(25,25,25),0.2
message.TextColor3,message.Font,message.TextSize=Color3.new(1,1,1),Enum.Font.Gotham,17
message.TextWrapped=true
message.Text="Parcels refresh at sunrise • cross the mint line to escape"
message.Parent=gui
local function refresh()
    local treadmill=player:GetAttribute("TreadmillLevel") or 0
    local capacity=player:GetAttribute("CapacityLevel") or 0
    local tmCost,capCost=UpgradeConfig.TreadmillCosts[treadmill+1],UpgradeConfig.CapacityCosts[capacity+1]
    local carried=player:GetAttribute("Carrying")
    info.Text=string.format(" STEAL A PACKAGE • TEST BUILD\n Cash $%d • movement Speed %d\n Training %.1f points • belt L%d • %.1f/s\n Trail %s • %.2fx training gain\n Collectible slots %d/%d • %s\n Treadmill F: %s • Capacity R: %s\n %s: %ds • opening boost %dx (future)\n Carrying: %s\n E: treadmill • hold movement • jump: leave\n T: cycle test trails • Data: %s",
        player:GetAttribute("Cash") or 0,player:GetAttribute("WalkSpeed") or 16,
        player:GetAttribute("TrainingPoints") or 0,treadmill,player:GetAttribute("TrainingRate") or 6,
        player:GetAttribute("EquippedTrail") or "None",player:GetAttribute("TrailMultiplier") or 1,
        player:GetAttribute("StoredCollectibles") or 0,player:GetAttribute("PlotCapacity") or 3,player:GetAttribute("PlotName") or "assigning",
        if tmCost then "$"..tmCost else "MAX",if capCost then "$"..capCost else "MAX",
        world:GetAttribute("Phase") or "Day",world:GetAttribute("PhaseSecondsLeft") or 0,world:GetAttribute("OpeningMultiplier") or 1,
        if carried and carried~="" then carried else "none",player:GetAttribute("SaveStatus") or "Loading")
end
for _,attr in ipairs({"Cash","WalkSpeed","TrainingPoints","TreadmillLevel","TrainingRate","CapacityLevel","PlotCapacity","StoredCollectibles","EquippedTrail","TrailMultiplier","PlotName","Carrying","SaveStatus"}) do
    player:GetAttributeChangedSignal(attr):Connect(refresh)
end
for _,attr in ipairs({"Phase","PhaseSecondsLeft","OpeningMultiplier"}) do world:GetAttributeChangedSignal(attr):Connect(refresh) end
refresh()
local serial=0
remotes.Notice.OnClientEvent:Connect(function(text)
    serial+=1;local current=serial;message.Text=text
    task.delay(5,function() if current==serial then message.Text="Train → steal → cross the hub line → earn → improve your depot" end end)
end)
local elapsed=0
local track,trackHumanoid,marks=nil,nil,nil
local visualElapsed=0
local function animateRunning(humanoid,running)
    if not running then if track and track.IsPlaying then track:Stop(0.1) end;return end
    if trackHumanoid~=humanoid then
        if track then track:Stop();track:Destroy() end
        track,trackHumanoid=nil,humanoid
        local animate=player.Character:FindFirstChild("Animate")
        local run=animate and animate:FindFirstChild("run")
        local animation=run and run:FindFirstChildOfClass("Animation")
        local animator=humanoid:FindFirstChildOfClass("Animator")
        if animation and animator then
            local ok,loaded=pcall(function() return animator:LoadAnimation(animation) end)
            if ok then track=loaded;track.Priority=Enum.AnimationPriority.Movement;track.Looped=true end
        end
    end
    if track and not track.IsPlaying then track:Play(0.1) end
end
RunService.RenderStepped:Connect(function(dt)
    local training=player:GetAttribute("Training")==true
    local humanoid=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    local running=training and humanoid and humanoid.MoveDirection.Magnitude>0.05 and humanoid.Health>0
    elapsed+=dt
    if training and elapsed>=0.15 then elapsed=0;remotes.TrainingIntent:FireServer("Run",running==true) end
    if humanoid then animateRunning(humanoid,running==true) end
    if training then
        local plotName=player:GetAttribute("PlotName")
        local plot=plotName and world.Map.Plots:FindFirstChild(plotName)
        if plot then
            if not marks then
                marks={}
                for i=1,3 do local mark=plot.Treadmill["BeltMark"..i];marks[i]={Part=mark,Original=mark.CFrame} end
                visualElapsed=0
            end
            if running then visualElapsed+=dt*3 end
            for i,item in ipairs(marks) do
                local z=((i-1)*2+visualElapsed)%6-3
                item.Part.CFrame=plot.Treadmill.Belt.CFrame*CFrame.new(0,0.23,z)
            end
        end
    elseif marks then
        for _,item in ipairs(marks) do if item.Part.Parent then item.Part.CFrame=item.Original end end
        marks=nil
    end
end)
UserInputService.JumpRequest:Connect(function()
    if player:GetAttribute("Training") then remotes.TrainingIntent:FireServer("Stop",false) end
end)
if RunService:IsStudio() then
    workspace:GetAttributeChangedSignal("QA_DisconnectUserId"):Connect(function()
        if workspace:GetAttribute("QA_DisconnectUserId")==player.UserId then
            local testing=game:GetService("StudioTestService")
            if testing:CanLeaveTest() then testing:LeaveTest() end
        end
    end)
    -- Runtime-only QA request; it cannot grant progression or change game state.
    local function bindProbe(remote)
        if remote.Name~="QAProbe" or not remote:IsA("RemoteEvent") then return end
        remote.OnClientEvent:Connect(function(token)
            local hudCount=0
            for _,item in ipairs(player.PlayerGui:GetChildren()) do if item.Name=="GrayboxHUD" then hudCount+=1 end end
            local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            remote:FireServer(token,{HUDCount=hudCount,WalkSpeed=humanoid and humanoid.WalkSpeed or 0,Trail=root and root:FindFirstChild("TrainingTrail")~=nil or false})
        end)
    end
    remotes.ChildAdded:Connect(bindProbe)
    local probe=remotes:FindFirstChild("QAProbe");if probe then bindProbe(probe) end
end
