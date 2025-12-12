if getgenv().Night then
    return error("Night is already loaded")
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

getgenv().Night = {
    Dev = false,
    Connections = {},
    Pages = {},
    Tabs = {Tabs = {}},
    Corners = {},
    Load = os.clock(),
    Notifications = {Objects = {}, Active = {}},
    ArrayList = {Objects = {}, Loaded = false},
    ControlsVisible = true,
    Mobile = false,
    CurrentOpenTab = nil,
    GameSave = game.PlaceId,
    CheckOtherConfig = true,
    Assets = {},
    Teleporting = false,
    InitSave = nil,
    Config = {
        UI = {
            Position = {X = 0.5, Y = 0.5},
            Size = {X = 0.37294304370880129, Y = 0.683131217956543},
            FullScreen = false,
            ToggleKeyCode = "LeftAlt",
            Scale = 1,
            Notifications = true,
            Anim = true,
            ArrayList = false,
            TabColor = {value1 = 25, value2 = 25, value3 = 25},
            TabTransparency = 0.03,
            KeybindTransparency = 0.7,
            KeybindColor = {value1 = 0, value2 = 0, value3 = 0},
        },
        Game = {
            Modules = {},
            Keybinds = {},
            Sliders = {},
            TextBoxes = {},
            MiniToggles = {},
            Dropdowns = {},
            ModuleKeybinds = {},
            Other = {}
        },
    }
} 
if getgenv().NightInit then
    if getgenv().NightInit.GameSave then
        getgenv().Night.GameSave = getgenv().NightInit.GameSave
    end
    if getgenv().NightInit.CheckOtherConfig then
        getgenv().Night.CheckOtherConfig = getgenv().NightInit.CheckOtherConfig
    end
    if getgenv().NightInit.Dev then
        getgenv().Night.Dev = true
    end
    getgenv().Night.InitSave = getgenv().NightInit
    getgenv().NightInit = nil
end



local Assets = nil
if getgenv().Night.Dev and isfile("Night/Library/Init.lua") then
    loadstring(readfile("Night/Library/Init.lua"))()
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/warprbx/NightRewrite/refs/heads/main/Night/Library/Init.lua"))()
end
Assets = getgenv().Night.Assets

if not Assets or typeof(Assets) ~= "table" or (Assets and not Assets.Functions) then
    getgenv().Night = nil
    return warn("Failed to load Functions, Night uninjected")

end

local uis = Assets.Functions.cloneref(game:GetService("UserInputService")) :: UserInputService
local ws = Assets.Functions.cloneref(game:GetService("Workspace")) :: Workspace
local plrs = Assets.Functions.cloneref(game:GetService("Players")) :: Players

local currentCamera = ws:FindFirstChildWhichIsA("Camera") :: Camera

if not uis.KeyboardEnabled and uis.TouchEnabled then
    getgenv().Night.Mobile = true
    getgenv().Night.Config.UI.Size = {X = 0.7, Y = 0.9}
end


if not isfolder("Night") then
    makefolder("Night")
end
if not isfolder("Night/Config") then
    makefolder("Night/Config")
end 
if not isfolder("Night/Assets") then
    makefolder("Night/Assets")
end
if not isfolder("Night/Assets/Fonts") then
    makefolder("Night/Assets/Fonts")
end

local gameinfo = Assets.Functions.GetGameInfo()
if typeof(gameinfo) == "table" then
    getgenv().Night.GameRootId = gameinfo.rootPlaceId 
    if getgenv().Night.GameSave == "root" then
        getgenv().Night.GameSave = tostring(getgenv().Night.GameRootId)
    end
end


local UI = Assets.Config.Load("UI", "UI")
local gamesave = Assets.Config.Load(tostring(getgenv().Night.GameSave), "Game")
if UI == "no file" then
    Assets.Config.Save("UI", getgenv().Night.Config.UI)
end

if gamesave == "no file" and getgenv().Night.CheckOtherConfig then
    if getgenv().Night.GameRootId == getgenv().Night.GameSave then
        gamesave = Assets.Config.Load(tostring(game.PlaceId), "Game")
    else
        gamesave = Assets.Config.Load(tostring(getgenv().Night.GameRootId), "Game")
    end
end

if gamesave == "no file" then
    Assets.Config.Save(tostring(getgenv().Night.GameSave), getgenv().Night.Config.Game)
end

if getgenv().Night.Mobile then
    if currentCamera then
        if 0.4 >= (currentCamera.ViewportSize.X / 1000) - 0.1 then
            getgenv().Night.Config.UI.Scale = 0.4
        else
            getgenv().Night.Config.UI.Scale = (currentCamera.ViewportSize.X / 1000) - 0.1
        end
    end
end

if queue_on_teleport then
    table.insert(getgenv().Night.Connections, plrs.LocalPlayer.OnTeleport:Connect(function(state)
        if not getgenv().Night.Teleporting then
            getgenv().Night.Teleporting = true
            
            local str = ""
            if getgenv().Night.InitSave then
                str = "getgenv().NightInit = {"
                for i, v in getgenv().Night.InitSave do
                    if i ~= #getgenv().Night.InitSave then
                        if typeof(v) == "string" then
                            str = str..tostring(i)..' = "'..tostring(v)..'" , '
                        else
                            str = str..tostring(i).." = "..tostring(v).." , "
                        end
                    end
                end
                str = string.sub(str, 0, #str-2).."}\n"
            end

            str = str..[[
                if not game:IsLoaded() then
                    game.Loaded:Wait()
                end

                if getgenv().NightInit and getgenv().NightInit.Dev and isfile("Night/Loader.lua") then
                    loadstring(readfile("Night/Loader.lua"))()
                else
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/warprbx/NightRewrite/refs/heads/main/Night/Loader.luau"))()
                end
            ]]
            queue_on_teleport(str)
        end
    end))
end

Assets.Main.Load("Universal")
Assets.Main.Load(getgenv().Night.GameSave)

Assets.Main.ToggleVisibility(true)

getgenv().Night.Main = Assets.Main
getgenv().Night.LoadTime = os.clock() - getgenv().Night.Load
Assets.Notifications.Send({
    Description = "Loaded in " .. string.format("%.1f", getgenv().Night.LoadTime) .. " seconds",
    Duration = 5
})
--[[if getgenv().Night.Mobile or getgenv().Night.Config.UI.ToggleKeyCode and getgenv().Night.Config.UI.ToggleKeyCode ~= "" and getgenv().Night.Config.UI.ToggleKeyCode ~= "Unknown" then
    task.wait(0.5)
    Assets.Notifications.Send({
        Description = "Current Keybind is: " .. getgenv().Night.Config.UI.ToggleKeyCode,
        Duration = 5
    })
end]]
task.wait(0.15)

if not isfile("Night/Version.txt") then
    writefile("Night/Version.txt", "Current version: 2.1.4")
    Assets.Notifications.Send({
        Description = "Night has been updated to V2.1.4",
        Duration = 15
    })
end

local text = readfile("Night/Version.txt")
if text ~= "Current version: 2.1.4" then
    Assets.Notifications.Send({
        Description = "Night has been updated to V2.1.4",
        Duration = 15
    })
    writefile("Night/Version.txt", "Current version: 2.1.4")
end

Night.Loaded = true
return Assets.Main
