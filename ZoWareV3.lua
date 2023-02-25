local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()
local Window = Rayfield:CreateWindow({
    Name = "ZOWARE - IN MAINTENANCE",
    LoadingTitle = "ZOWARE_MAINTENANCE",
    LoadingSubtitle = "by Slayn & Delexory",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "zoware", -- Create a custom folder for your hub/game
        FileName = "ZoWarePI"
    },
    Discord = {
        Enabled = false,
        Invite = "zoware", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD.
        RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
        Title = "ZoWare Private",
        Subtitle = "Key System",
        Note = "Join our discord (discord.gg/MsgpWXC322)",
        FileName = "ZoWareV3.3.0-B_Key",
        SaveKey = false,
        GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
        Key = ""
    }
})

Rayfield:Notify({
    Title = "MAINTENANCE",
    Content = "ZoWare Is in maintenance, check back later.",
    Duration = 6.5,
    Image = 4483362458,
    Actions = { -- Notification Buttons
        Ignore = {
            Name = "k",
            Callback = function()
                warn('k')
            end
        }
    }
})
