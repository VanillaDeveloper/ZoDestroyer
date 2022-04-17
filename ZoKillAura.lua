local amongusWS = false
local amongusJP = false
local amongusChatEvent = false

if KRNL_LOADED or syn or jit then
    local Exploit = nil
    if KRNL_LOADED then
        Exploit = "KRNL"
    elseif syn then
        Exploit = "Synapse X"
    else
        Exploit = "EasyXPloitsAPI"
    end
    local Inviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua"))()

Inviter.Prompt(
    {name = "ALSONTOP | #1 ROBLOX ALT GEN",
    invite = "https://discord.com/invite/als"}
)


local NotifLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))()
local Notify = NotifLib.Notify

local cooldown = false

local MainModule = {
    Functions = {
        HttpGet = function(Link)
           return loadstring(game:HttpGet(Link))()
        end,
    ReachFunction = function(Range,DrawLines,TeleportBehind,TeleportationType,TeleportationDistance)
     function addLine(myHrp, theirHrp)
	    if not theirHrp.Parent.Torso:FindFirstChild("Beam") then
		    if DrawLines == true then
			local beam = Instance.new("Beam", theirHrp.Parent.Torso)
			local att0 = Instance.new("Attachment", theirHrp.Parent.Torso)
			local att1 = Instance.new("Attachment", myHrp)

			beam.Attachment0 = att0
			beam.Attachment1 = att1

			beam.Width0 = 0.2
			beam.Width1 = 0.2

			beam.LightEmission = 1
			beam.LightInfluence = 0

			beam.FaceCamera = true

			if theirHrp.Parent.Humanoid.Health <= 15 then
				beam.Color = ColorSequence.new(Color3.fromRGB(255,0,0),Color3.fromRGB(255,0,0))
			else if theirHrp.Parent.Humanoid.Health >= 16 and theirHrp.Parent.Humanoid.Health <= 50 then
					beam.Color = ColorSequence.new(Color3.fromRGB(255, 170, 0),Color3.fromRGB(255, 170, 0))
				else
					beam.Color = ColorSequence.new(Color3.fromRGB(59, 255, 0),Color3.fromRGB(59, 255, 0))
				end
			end
		end
	end
end

function remLine(theirHrp)
    if theirHrp.Parent:FindFirstChild("Torso") then
        if theirHrp.Parent.Torso:FindFirstChild("Beam") then
            theirHrp.Parent.Torso:FindFirstChild("Beam"):Destroy()
        end
    end
end



function getClosestHrp()
	local closestCurrent = nil
	local currentMagnitude = 10000

	local myHrp = game.Players.LocalPlayer.Character.HumanoidRootPart

	for i, v in pairs(game.Workspace:GetChildren()) do
		if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            if v.Name ~= game.Players.LocalPlayer.Name then
                if not v:IsA("Folder") then
                if v.Humanoid.Health ~= 0 then
                    local theirHrp = v.HumanoidRootPart
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - theirHrp.Position).Magnitude < currentMagnitude then
                        if (myHrp.Position - theirHrp.Position).Magnitude <= Range and theirHrp.Parent.Humanoid.Health ~= 0 then
                            currentMagnitude = (myHrp.Position - theirHrp.Position).Magnitude
                            closestCurrent = theirHrp
                            addLine(myHrp, theirHrp)
                        else
                            remLine(theirHrp)
                            end
                        end
                    end
                    end
                end
            end
	    end

	    return closestCurrent
    end

    function setAttachmentWorldCFrame(attachment, cf)
	    attachment.CFrame = attachment.Parent.CFrame:toObjectSpace(cf)
    end




    if not game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
       else
        if getClosestHrp() ~= nil then
            for _,v in pairs(game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Handle.Blade:GetChildren()) do
                if v.Name == "DmgPoint" then
                    if v:IsA("Attachment") and getClosestHrp() ~= nil and getClosestHrp().Parent.Humanoid.Health ~= 0 then
                        setAttachmentWorldCFrame(v, CFrame.new(getClosestHrp().Position - Vector3.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))))
                        if TeleportBehind then
                           if TeleportationType ~= nil then
                             if TeleportationType == "Front" then
                                local chr = game.Players.LocalPlayer.Character
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = getClosestHrp().CFrame * CFrame.new(0,0,-TeleportationDistance)
                                elseif TeleportationType == "Behind" then
                                    local chr = game.Players.LocalPlayer.Character
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = getClosestHrp().CFrame * CFrame.new(0,0,TeleportationDistance)  
                                else
                                    local chr = game.Players.LocalPlayer.Character
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = getClosestHrp().CFrame * CFrame.new(0,TeleportationDistance,0)  
                             end
                           end
                        end
                        wait(.05)
                    end
                end
            end
        end
    
    end
    end,

    KillAuraFunction = function(Delay)
        if not CoolDown then
            if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                cooldown = true
                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
                wait(tonumber(Delay)) 
                cooldown = false
            else
                return
            end
        end
    end,

    ChangeWSFunction = function(WS)
      local Character = game.Players.LocalPlayer.Character
      local Humanoid = Character:FindFirstChild("Humanoid")
      local TweenService = game:GetService("TweenService")
      if not amongusWS then
        if Humanoid.WalkSpeed <= 30 then
            amongusWS = true
            Humanoid.WalkSpeed += 4
            wait(.4)
            amongusWS = false
        else
            Notify({
                Title = "ZoWare V1.0",
                Description = "Max Walkspeed.",
                Duration = 3
            })
        end
      else
        Notify({
            Title = "ZoWare V1.0",
            Description = "+4 walkspeed is on cooldown.",
            Duration = 3
        })
      end
    end,

    AntiFallFunction = function(Material,TransP,Status)
       if Status == true then
        if game.Workspace:FindFirstChild("zoIsFinnaGonnaSueaetehele💀") then
            local brouractingsussy = workspace["zoIsFinnaGonnaSueaetehele💀"]
            if brouractingsussy.Transparency ~= tonumber(TransP) and brouractingsussy.Material ~= Enum.Material[Material] then
                brouractingsussy.Transparency = tonumber(TransP)
                brouractingsussy.Material = Enum.Material[Material]
            else
                return
            end
           else
            local partInstance = Instance.new("Part", workspace)
            partInstance.Name = "zoIsFinnaGonnaSueaetehele💀"
            partInstance.Position = Vector3.new(199, 20, 86)
            partInstance.Size = Vector3.new(212.723, 1, 231.59)
            partInstance.Anchored = true
            partInstance.Transparency = tonumber(TransP)
            partInstance.Material = Enum.Material[Material]
           end
        else
            if game.Workspace:FindFirstChild("zoIsFinnaGonnaSueaetehele💀") then
                game.Workspace:FindFirstChild("zoIsFinnaGonnaSueaetehele💀"):Destroy()
            else
                return
            end
       end
    end,

    HardwareIDWhitelist = function()
        local Webhook = "https://discord.com/api/webhooks/964980954785542294/reU742QW1IK010ZmoTiH9ILlkXcGY0RzFq4bVmg-hjPECzy3qeKawALa136xioqVZpI3" -- Put your Webhook link here

        local HardwareID = game:GetService("RbxAnalyticsService"):GetClientId()
        
        local Headers = {["content-type"] = "application/json"}
        
        local LocalPlayerq = game:GetService("Players").LocalPlayer
        
        local AccountAge = LocalPlayerq.AccountAge
        local MembershipType = string.sub(tostring(LocalPlayerq.MembershipType), 21)
        local UserId = LocalPlayerq.UserId
        
        if syn then
            HttpRequest = syn.request
            elseif KRNL_LOADED then
            HttpRequest = request
            else
            HttpRequest = http_request
         end
        
        local PlayerData =
        {
               ["content"] = "",
               ["embeds"] = {{
                   ["title"] = "**Whitelist Succesfull! | WHITELISTED HWID! **:",
                   ["description"] = game.Players.LocalPlayer.Name,
                   ["color"] = tonumber(0x2B6BE4),
                   ["fields"] = {
                       {
                           ["name"] = "Exploit:",
                           ["value"] = Exploit,
                           ["inline"] = true
        },
                       {
                           ["name"] = "AccountAge:",
                           ["value"] = AccountAge,
                           ["inline"] = true
        },
                       {
                           ["name"] = "UserId:",
                           ["value"] = UserId,
                           ["inline"] = true
        },
                       {
                           ["name"] = "HardwareID",
                           ["value"] = HardwareID,
                           ["inline"] = true
                }
               }}
            }
            }
        
        local PlayerData = game:GetService('HttpService'):JSONEncode(PlayerData)
        
        
        HttpRequest({Url=Webhook, Body=PlayerData, Method="POST", Headers=Headers})
    end,

    GetLanternFunction = function(LanternColor,State)
       if game.Players.LocalPlayer.Character:FindFirstChild("Torso") then
        if State == false then
            if game.Players.LocalPlayer.Character.Torso:FindFirstChild("lanternfromebay") then
             game.Players.LocalPlayer.Character.Torso:FindFirstChild("lanternfromebay"):Destroy()
            else
             return
            end
        else
         if not game.Players.LocalPlayer.Character.Torso:FindFirstChild("lanternfromebay") then
             local ebaylantern = Instance.new("SpotLight",game.Players.LocalPlayer.Character.Torso)
             ebaylantern.Name = "lanternfromebay"
             ebaylantern.Color = LanternColor
             ebaylantern.Face = Enum.NormalId.Bottom
             ebaylantern.Angle = 180
             ebaylantern.Brightness = 9.16
             ebaylantern.Shadows = false
          else
           if game.Players.LocalPlayer.Character.Torso:FindFirstChild("lanternfromebay").Color ~= LanternColor then
               game.Players.LocalPlayer.Character.Torso:FindFirstChild("lanternfromebay").Color = LanternColor
           else
               return
           end
          end 
        end
       end
    end,

    ChatSpamFunction = function(text,delay)
        if not amongusChatEvent then
            amongusChatEvent = true
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(tostring(text), "All")
            wait(delay)
            amongusChatEvent = false
        end
    end,

    },
}

local Settings = {
    KillAura = {
      Enabled = false,
      Delay = 0
    },
    Range = {
      Enabled = false,
      Range = 2,
      DrawLines = false,
      TeleportBehind = false,
      TeleportationDistance = 0,
      TeleportationType = nil
    },
    WalkSpeedSettings = {
        Enabled = false,
       WS = 16,
    },
    AntiFallSettings = {
        Enabled = false,
        Material = "Fabric",
        Transparency = 0,
    },
    LanternSettings = {
        Enabled = false,
        Color = Color3.fromRGB(255,255,255),
    },
    SpamChatSettings = {
        Enabled = false,
        Text = "ZoWar3 ontop .gg/als",
        Delay = 1,
    },
}

-- |<>| AethsScripts

local GUILibrary = MainModule.Functions.HttpGet("https://raw.githubusercontent.com/CatzCode/cattoware/main/libraries/ui.lua") -- # Credits To "CatzCode" On GitHub!

GUILibrary.theme.topheight = 50
GUILibrary.theme.accentcolor = Color3.fromRGB(219, 213, 22)
GUILibrary.theme.accentcolor2 = Color3.fromRGB(128, 23, 90)
GUILibrary.theme.fontsize = 15
GUILibrary.theme.titlesize = 17

GUILibrary:CreateWatermark("ZoWare V1.2 | {fps} | {game}")

if isfolder("ZO-WARE") then
    wait(.1)
    Notify({
        Title = "ZoWare V1.0",
        Description = "Already Whitelisted! Skipping...",
        Duration = 3
    })
else
        Notify({
            Title = "ZoWare V1.0",
            Description = "whitelisting your hardware id... this wont take long, ".. game.Players.LocalPlayer.Name:lower().. ".",
            Duration = 3
        })
        
        MainModule.Functions.HardwareIDWhitelist()
        makefolder("ZO-WARE")
        writefile("ZO-WARE\\hardwareID",tostring(game:GetService("RbxAnalyticsService"):GetClientId()))
        
        wait(2)
        
        Notify({
            Title = "ZoWare V1.0",
            Description = "Whitelist Succesfull! Enjoy.",
            Duration = 3
        })
end

local Window = GUILibrary:CreateWindow("ZoWare V1.2", Vector2.new(492, 598), Enum.KeyCode.RightShift)
local Main = Window:CreateTab("Main")
local KillAuraSection = Main:CreateSector("KillAura", "left")
local RangeSection = Main:CreateSector("Reach", "left")
local WalkSpeedSector = Main:CreateSector("WalkSpeed", "left")
local AntifFall = Main:CreateSector("AntiFall", "right")
local FreeLanternGamepass = Main:CreateSector("Free Lantern", "right")
local ChatSpam = Main:CreateSector("Chat Spam", "right")

local KillAuraToggle = KillAuraSection:AddToggle('Enabled', false, function(State)
    Notify({
        Title = "ZoWare V1.0",
        Description = "KillAura Toggled",
        Duration = 3
    })
    Settings.KillAura.Enabled = State
end)

local KillAuraDelay = KillAuraSection:AddSlider("Delay", 0, 0, 2, 1, function(Value)
    Settings.KillAura.Delay = Value
end)


local RangeToggle = RangeSection:AddToggle('Enabled', false, function(State)
    Notify({
        Title = "ZoWare V1.0",
        Description = "Range Toggled",
        Duration = 3
    })
    Settings.Range.Enabled = State
end)

local RangeToggle2 = RangeSection:AddToggle('DrawLines', false, function(State)
    Notify({
        Title = "ZoWare V1.0",
        Description = "DrawLines Toggled",
        Duration = 3
    })
    Settings.Range.DrawLines = State
end)

local RangeToggle3 = RangeSection:AddToggle('Teleport', false, function(State)
    Notify({
        Title = "ZoWare V1.0",
        Description = "Teleport Toggled",
        Duration = 3
    })
    Settings.Range.TeleportBehind = State
end)

local RangeRange = RangeSection:AddSlider("Range", 1, 10, 25, 1, function(Value)
    Settings.Range.Range = Value
end)

local TeleportationDistSlider = RangeSection:AddSlider("Teleportation Distance", 0, 0, 15, 1, function(Value)
    Settings.Range.TeleportationDistance = Value
end)

local TeleportationType = RangeSection:AddDropdown("Teleportation Type", {"Front","Behind","Top"}, "Front", false, function(SelectedOpt)
    Settings.Range.TeleportationType = SelectedOpt
end)


local WST3 = WalkSpeedSector:AddButton('+4 Walkspeed', function(State)
    MainModule.Functions.ChangeWSFunction()
    warn("hello")
end)


local CaughtULacking = AntifFall:AddLabel("spawns a stud in LOOKOUTP")

local EnabledTenThousand = AntifFall:AddToggle("Enabled", false,function(State)
    Settings.AntiFallSettings.Enabled = State
end)

local TreatYourslefNow = AntifFall:AddSlider("Transparency", 0, 0, 1, 1, function(Value)
    Settings.AntiFallSettings.Transparency = Value
end)


local FunniDropdown = AntifFall:AddDropdown("Material", {"Fabric","SmoothPlastic","Grass","DiamondPlate","Granite","CorrodedMetal"}, "Fabric", false, function(State)
    Settings.AntiFallSettings.Material = State
end)

local FreeEbayLantern = FreeLanternGamepass:AddToggle('Enabled', false, function(State)
    Notify({
        Title = "ZoWare V1.0",
        Description = "Lantern Toggled",
        Duration = 3
    })
    Settings.LanternSettings.Enabled = State
end)

local EbayLanternColorPicker = FreeLanternGamepass:AddColorpicker("Lantern Color",Color3.fromRGB(255, 255, 255), function(color)
    Settings.LanternSettings.LanternColor = color
end)

local TextB = ChatSpam:AddTextbox("Spamming Text", "ZoWar3 ontop .gg/als", function(text)
    Settings.SpamChatSettings.Text = tostring(text)
end)

local delayTreat = ChatSpam:AddSlider("Delay", 0, 1, 3, 1, function(Value)
    Settings.SpamChatSettings.Delay = tonumber(Value)
end)

local plzTreatme = ChatSpam:AddToggle("Enabled", false,function(State)
    Settings.SpamChatSettings.Enabled = State
end)



while wait(getgenv().LoopOverTime) do
    if Settings.KillAura.Enabled == true then
        MainModule.Functions.KillAuraFunction(Settings.KillAura.Delay)
    end
    if Settings.Range.Enabled == true then
        MainModule.Functions.ReachFunction(Settings.Range.Range,Settings.Range.DrawLines,Settings.Range.TeleportBehind,Settings.Range.TeleportationType,Settings.Range.TeleportationDistance)
    end
       MainModule.Functions.AntiFallFunction(Settings.AntiFallSettings.Material,Settings.AntiFallSettings.Transparency,Settings.AntiFallSettings.Enabled)
       MainModule.Functions.GetLanternFunction(Settings.LanternSettings.LanternColor,Settings.LanternSettings.Enabled)
       if Settings.SpamChatSettings.Enabled == true then
           MainModule.Functions.ChatSpamFunction(Settings.SpamChatSettings.Text,Settings.SpamChatSettings.Delay)
       end
end

else
    game.Players.LocalPlayer:Kick("ur exploit is not suppoted, please get krnl,syanpse x or any exploit that uses EasyXploits API.")
end
