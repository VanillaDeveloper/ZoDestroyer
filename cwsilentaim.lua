if _G.PredictionVal == nil then
	_G.PredictionVal = 0.19
end

local events = game:GetService("ReplicatedStorage").Communication.Events
local functions = game:GetService("ReplicatedStorage").Communication.Functions
for i,v in pairs(getgc(true)) do
    if typeof(v) == "table" and rawget(v,"Remote") then
        v.Remote.Name = v.Name
    end
end
local oldnamecall; oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod();
  
    if (method == "Kick" or method == "kick") and self == game.Players.LocalPlayer then
        return;
    end
  
    return oldnamecall(self, unpack(args))
end)

local antiragdoll = false

local mt = getrawmetatable(game)
make_writeable(mt)

local namecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...} --gets all arguments

    if method == "ToggleRagdoll" and args[1] == true and antiragdoll == true then --check if the method firing is FireSerer (aka remote event) and if the first argument is Kick
        return wait(9e9)
    end
    return namecall(self, ...)
end)

game.CollectionService:AddTag(game:GetService("Workspace").Map,'CAMERA_COLLISION_IGNORE_LIST')
if _G.Wallbang == nil then
    _G.Wallbang = true
end
if _G.Wallbang then
    game.CollectionService:AddTag(game:GetService("Workspace").Map,'RANGED_CASTER_IGNORE_LIST')
end
local LocalPlayer = game.Players.LocalPlayer
local ARROW
local shot = false
local arrowsshooted = 0
local predicted
local silentaim = true
local Players = game.Players
local mouse = LocalPlayer:GetMouse()
local function getClosestToMouse()
    local player, nearestDistance = nil, math.huge*9e9
    for i,v in pairs(Players:GetPlayers()) do
        if v ~= Players.LocalPlayer and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            local root, visible = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if visible then
                local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(root.X, root.Y)).Magnitude

                if distance < nearestDistance then
                    nearestDistance = distance
                    player = v
                end
            end
        end
    end
    return player
end
if _G.NoSpread == nil then
    _G.NoSpread = true
end
if _G.NoRecoil == nil then
    _G.NoRecoil = true
end
if _G.NoGravity == nil then
    _G.NoGravity = true
end
if _G.InfDistance == nil then
    _G.InfDistance = true
end
if _G.ShootAfterCharge == nil then
    _G.ShootAfterCharge = true
end
for i,v in pairs(getgc(true)) do
    if typeof(v) == 'table' and rawget(v,'maxSpread') then
        if _G.NoSpread then
            v.maxSpread = 0
        end
        if _G.NoRecoil then
            v.recoilYMin = 0
            v.recoilZMin = 0
            v.recoilXMin = 0
            v.recoilYMax = 0
            v.recoilZMax = 0
            v.recoilXMax = 0
        end
        if _G.NoGravity then
            v.gravity = Vector3.new(0,0,0)
        end
        if _G.InfDistance then
            v.maxDistance = 999999
        end
        if _G.ShootAfterCharge then
            v.startShootingAfterCharge = true
        end
    end
end
local box = Instance.new("SelectionBox",workspace)
workspace.EffectsJunk.ChildAdded:Connect(function(p)
    task.wait() -- yields to prevent some shit lol!
    if LocalPlayer.Character:FindFirstChildOfClass("Tool") == nil then
        shot = false
        return
    end
    local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if Tool:FindFirstChild("ClientAmmo") == nil then
        shot = false
        return
    end
    if (shot and p:IsA("MeshPart") and p:FindFirstChild("Tip") ~= nil) then
        ARROW = p
        box.Adornee = p
        shot = false
    end
end)

for i,v in pairs(getgc(true)) do
    if typeof(v) == "table" and rawget(v,"shoot") then
        local Old = v.shoot
        v.shoot = function(tbl)
            shot = true
            arrowsshooted = tbl.shotIdx
            return Old(tbl)
        end
    end
    
    if typeof(v) == "table" and rawget(v,"calculateFireDirection") then
        old = v.calculateFireDirection
        v.calculateFireDirection = function(p3,p4,p5,p6)
            local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if Tool:FindFirstChild("ClientAmmo") == nil then
                return old(p3,p4,p5,p6)
            end
            if (shot and silentaim) then
                if not predicted then
                    return old(p3,p4,p5,p6)
                else
                    return predicted
                end
            end
            return old(p3,p4,p5,p6)
        end
    end
end
if _G.HitPart == nil then
    _G.HitPart = "Head"
end
local Parts = {"Head","HumanoidRootPart","Torso","Left Leg","Right Leg","Left Arm","Right Arm"}
for i,v in pairs(Parts) do
    if _G.HitPart ~= v then
        _G.HitPart = "Head"
    end
end
firehit = function(character,arrow)
    local fakepos = character[_G.HitPart].Position + Vector3.new(math.random(1,5),math.random(1,5),math.random(1,5))
    local args = {
        [1] = LocalPlayer.Character:FindFirstChildOfClass("Tool"),
        [2] = character[_G.HitPart],
        [3] = fakepos,
        [4] = character[_G.HitPart].CFrame:ToObjectSpace(CFrame.new(fakepos)),
        [5] = fakepos * Vector3.new(math.random(1,5),math.random(1,5),math.random(1,5)),
        [6] = tostring(arrowsshooted)
    }
    game:GetService("ReplicatedStorage").Communication.Events.RangedHit:FireServer(unpack(args))
end
local bruh = Instance.new("Highlight",game.ReplicatedStorage)
bruh.Adornee = nil
bruh.FillColor = Color3.fromRGB(8, 0, 255) 
local M = game.Players.LocalPlayer:GetMouse()
local Cam = game.Workspace.CurrentCamera
-- dev forum
function WorldToScreen(Pos)
    local point = Cam.CoordinateFrame:pointToObjectSpace(Pos)
    local aspectRatio = M.ViewSizeX / M.ViewSizeY
    local hfactor = math.tan(math.rad(Cam.FieldOfView) / 2)
    local wfactor = aspectRatio*hfactor

    local x = (point.x/point.z) / -wfactor
    local y = (point.y/point.z) /  hfactor

    return Vector2.new(M.ViewSizeX * (0.5 + 0.5 * x), M.ViewSizeY * (0.5 + 0.5 * y))
end
local closest
local Prediction
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Aiming = Instance.new("TextLabel")
local Position = Instance.new("TextLabel")
local PredictionV = Instance.new("TextLabel")

--Properties:

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
Frame.Position = UDim2.new(0.100260414, 0, 0.349072516, 0)
Frame.Size = UDim2.new(0, 10, 0, 10)

UICorner.CornerRadius = UDim.new(10, 10)
UICorner.Parent = Frame

Aiming.Name = "Aiming"
Aiming.Parent = Frame
Aiming.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Aiming.BackgroundTransparency = 1.000
Aiming.BorderColor3 = Color3.fromRGB(27, 42, 53)
Aiming.Position = UDim2.new(-9.5, 0, 1.99999988, 0)
Aiming.Size = UDim2.new(0, 200, 0, 11)
Aiming.Font = Enum.Font.SpecialElite
Aiming.Text = "Aiming At: None"
Aiming.TextColor3 = Color3.fromRGB(255, 255, 255)
Aiming.TextSize = 14.000

Position.Name = "Position"
Position.Parent = Frame
Position.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Position.BackgroundTransparency = 1.000
Position.BorderColor3 = Color3.fromRGB(27, 42, 53)
Position.Position = UDim2.new(-9.5, 0, 3.99999988, 0)
Position.Size = UDim2.new(0, 200, 0, 11)
Position.Font = Enum.Font.SpecialElite
Position.Text = "Position: None"
Position.TextColor3 = Color3.fromRGB(255, 255, 255)
Position.TextSize = 14.000

PredictionV.Name = "PredictionV"
PredictionV.Parent = Frame
PredictionV.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PredictionV.BackgroundTransparency = 1.000
PredictionV.BorderColor3 = Color3.fromRGB(27, 42, 53)
PredictionV.Position = UDim2.new(-9.5, 0, 5.99999988, 0)
PredictionV.Size = UDim2.new(0, 200, 0, 11)
PredictionV.Font = Enum.Font.SpecialElite
PredictionV.Text = "Prediction Value: ".._G.PredictionVal
PredictionV.TextColor3 = Color3.fromRGB(255, 255, 255)
PredictionV.TextSize = 14.000

UIStroke.Thickness = 2
UIStroke.Parent = Frame
if _G.Percent == nil then
    _G.Percent = 100
end
if _G.InstantCharge == nil then
    _G.InstantCharge = true
end
if _G.HitDistance == nil then
    _G.HitDistance = 15
end
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/CatzCode/cattoware/main/libraries/ui.lua'))()
local Window = Library:CreateWindow("cw silent aim", Vector2.new(492, 598), Enum.KeyCode.RightShift)
local Main = Window:CreateTab("Main")
local Section = Main:CreateSector("silent aim", "right")
local Misc = Main:CreateSector("misc", "right")

Section:AddToggle('Silent Aim', false, function(State)
    silentaim = State
end)
Misc:AddToggle('anti-ragdoll', false, function(State)
    antiragdoll = State
end)
Section:AddDropdown("Hit Part", Parts, "Head", false, function(SelectedOpt)
    _G.HitPart = SelectedOpt
end)
Section:AddSlider("Hit Percent", 0, 1, 100, 1, function(Value)
    _G.Percent = Value
end)
Section:AddSlider("Hit Distance", 0, 5, 15, 1, function(Value)
    _G.HitDistance = Value
end)
Section:AddTextbox("arrow prediction value", "0.5", function(text)
    _G.PredictionVal = tonumber(text)
    PredictionV.Text = "Prediction Value: "..text
end)

Section:AddToggle('no spread', false, function(val)
    for i,v in pairs(getgc(true)) do
        if typeof(v) == 'table' and rawget(v,'maxSpread') then
            if val then
                v.maxSpread = 0
            else
                v.maxSpread = 0.35
            end
        end
    end
end)

Section:AddToggle('toggle gui', false, function(val)
    Frame.Visible = not val
end)

Section:AddToggle('no recoil', false, function(val)
    for i,v in pairs(getgc(true)) do
        if typeof(v) == 'table' and rawget(v,'maxSpread') then
            if val then
                v.recoilYMin = 0
                v.recoilZMin = 0
                v.recoilXMin = 0
                v.recoilYMax = 0
                v.recoilZMax = 0
                v.recoilXMax = 0
            else
                v.recoilXMin = 1.25
		        v.recoilXMax = 1.75
	            v.recoilYMin = -1.5
		        v.recoilYMax = 1.5
		        v.recoilZMin = -1.5
		        v.recoilZMax = 1.5
		   end
        end
    end
end)

Section:AddToggle('no gravity', false, function(val)
    for i,v in pairs(getgc(true)) do
        if typeof(v) == 'table' and rawget(v,'maxSpread') then
            if val then
                v.gravity = Vector3.new(0,0,0)
            else
                v.gravity = Vector3.new(0,-10,0)
            end
        end
    end
end)

Section:AddToggle('inf distance', false, function(val)
    for i,v in pairs(getgc(true)) do
        if typeof(v) == 'table' and rawget(v,'maxSpread') then
            if val then
                v.maxDistance = 999999
            else
                v.maxDistance = 1000
            end
        end
    end
end)

Section:AddToggle('shoot after charge', false, function(val)
    for i,v in pairs(getgc(true)) do
        if typeof(v) == 'table' and rawget(v,'maxSpread') then
            v.startShootingAfterCharge = val
        end
    end
end)

local oldcancel
Section:AddToggle('no reload cancel', false, function(val)
    for i,v in pairs(getgc(true)) do
        if typeof(v) == 'table' and rawget(v,'cancelReload') then
            if oldcancel == nil then
                oldcancel = v.cancelReload
            end
            
            if val then
                v.cancelReload = function(e)
                   return
                end
            else
                v.cancelReload = oldcancel
            end
        end
    end
end)

Section:AddToggle('wallbang', false, function(val)
    if val then
        game.CollectionService:AddTag(game:GetService("Workspace").Map,'RANGED_CASTER_IGNORE_LIST')
    else
        game.CollectionService:RemoveTag(game:GetService("Workspace").Map,'RANGED_CASTER_IGNORE_LIST')
    end
end)

task.spawn(function()
    while wait(.05) do
        pcall(function()
            local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if Tool:FindFirstChild("ClientAmmo") == nil then
                return
            end
            closest = getClosestToMouse()
            if closest then
                bruh.Parent = workspace
                bruh.Adornee = closest.Character
                if Frame.Visible == true then
                    Aiming.Text = "Aiming At: "..closest.Name
                    PredictionV.Text = "Prediction Value: ".._G.PredictionVal
                    Prediction = closest.Character.Head.CFrame + (closest.Character.Head.Velocity * _G.PredictionVal + Vector3.new(0, .1, 0))
                    predicted = (CFrame.lookAt(Tool.Contents.Handle.FirePoint.WorldCFrame.Position, Prediction.Position)).LookVector * 30;
                    Position.Text = "Position: "..Prediction.Position.X..", "..Prediction.Y..", "..Prediction.Y
                    local Vec = WorldToScreen(Prediction.Position)
                    Frame.Position = UDim2.new(0,Vec.X,0,Vec.Y)
                end
            end
            if (ARROW and silentaim) then
                if closest then
                    if (ARROW.Position - closest.Character.HumanoidRootPart.Position).Magnitude <= _G.HitDistance then
                        if _G.Percent == 100 then
                            firehit(closest.Character,ARROW)
                            ARROW = nil
                            shot = false
                        elseif _G.Percent ~= 100 then
                            local percent = math.random(1,100)
                            
                            if percent >= Percent then
                                firehit(closest.Character,ARROW)
                                ARROW = nil
                                shot = false
                            end
                        end
                    end
                end
            end
            
            if LocalPlayer.Character then
                if (LocalPlayer.Character:FindFirstChild('Longbow') and _G.InstantCharge) then
                    for i,v in pairs(getconnections(Tool.ChargeProgressClient:GetPropertyChangedSignal("Value"))) do
                        v:Disable()
                    end            
                    Tool.ChargeProgressClient.Value = 1
                end
            end
        end)
    end
end)
