local Assets = {
    Functions = {},
    Config = {},
    Notifications = {},
    MainBackground = {},
    Pages = {},
    Dashboard = {},
    SettingsPage = {},
    ArrayList = {},
    Font = {},
    Main = {ToggleVisibility = nil}
}

local Night = getgenv().Night
Assets.Functions.cloneref = cloneref or function(ref: Instance) return ref end

local PlayersSV = Assets.Functions.cloneref(game:GetService("Players")) :: Players
local HttpService = Assets.Functions.cloneref(game:GetService("HttpService")) :: HttpService
local TweenService = Assets.Functions.cloneref(game:GetService("TweenService")) :: TweenService
local UserInputService = Assets.Functions.cloneref(game:GetService("UserInputService")) :: UserInputService
local Workspace = Assets.Functions.cloneref(game:GetService("Workspace")) :: Workspace
local TextService = Assets.Functions.cloneref(game:GetService("TextService")) :: TextService

local UserCamera = Workspace.CurrentCamera :: Camera
local LocalPlayer = PlayersSV.LocalPlayer :: Player

do
    Assets.Functions.clonefunction = clonefunction or function(func: any) return func end

    Assets.Functions.gethui = gethui or function() return LocalPlayer:FindFirstChildWhichIsA("PlayerGui") end
    Assets.Functions.GenerateString = function(chars : number) : string
        local str = ""
        for i = 0, chars do
            str = str..string.char(math.random(33,126))
        end
        return str
    end
    Assets.Functions.GetGameInfo = function()
        local gameinfo = game:HttpGet("https://games.roblox.com/v1/games?universeIds="..tostring(game.GameId))
        if gameinfo then
            local dencgameinfo = HttpService:JSONDecode(gameinfo)
            if dencgameinfo and dencgameinfo.data and dencgameinfo.data[1] then
                return dencgameinfo.data[1]                
            else
                return "no game info after json"
            end
        else
            return "no game info returned"
        end
    end
    Assets.Functions.LoadFile = function(file : string, githublink : string)
        if Night.Dev and isfile(file) then
            return loadstring(readfile(file))()
        else
            local suc, err = pcall(function() 
                file = http.request({
                    Url = githublink,
                    Method = "GET"
                }).Body
            end)
            if suc and not err and file and not tostring(file):lower():find("404: not found") then
                return loadstring(file)()
            end
        end
        return "error"
    end
    Assets.Functions.IsAlive = function(plr: Player)
        plr = plr or LocalPlayer
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hum = plr.Character:FindFirstChildWhichIsA("Humanoid")
            if hum and hum.Health > 0.1 then
                return true
            end
        end
        return false
    end
    Assets.Functions.GetModule = function(name: string)
        if name and Night and Night.Tabs and Night.Tabs.Tabs then
            for i,v in Night.Tabs.Tabs do
                if v.Modules and v.Modules[name] then
                    return v.Modules[name]
                end
            end
        end
        return
    end
    Assets.Functions.GetAllModules = function()
        local modules = {}
        if Night and Night.Tabs and Night.Tabs.Tabs then
            for i,v in Night.Tabs.Tabs do
                if v.Modules then
                    for i2, v2 in v.Modules do 
                        modules[i2] = v2
                    end
                end
            end
        end
        return modules
    end
    Assets.Functions.GetNearestPlr = function(tplr, teamcheck)
        tplr = tplr or LocalPlayer
        local lastpos, plr = math.huge, nil
        for i,v in PlayersSV:GetPlayers() do
            if teamcheck and v.Team ~= tplr.Team or not teamcheck then
                if v and v ~= tplr and Assets.Functions.IsAlive(v) and Assets.Functions.IsAlive(tplr) then
                    local dist = (tplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if lastpos > dist then
                        lastpos = dist
                        plr = v
                    end
                end
            end
        end
        return plr, lastpos
    end
    Assets.Functions.GetNearestPlrToMouse = function(Data: {Team: boolean, Limit: number, Exclude: {}, Extras: {}})
        Data = {
            Team = Data and Data.Team or false,
            Limit = Data and Data.Limit or math.huge,
            Exclude = Data and Data.Exclude or {},
            Extras = Data and Data.Extras or {}
        }

        local RData = {Player = nil, Distance = math.huge, PlayerDist = math.huge}
        local Players = {}
        for i,v in PlayersSV:GetPlayers() do
            if Assets.Functions.IsAlive(v) then
                if Data.Team and v.Team ~= LocalPlayer.Team or not Data.Team then
                    table.insert(Players, v.Character)
                end
            end
        end

        for i,v in Data.Extras do
            table.insert(Players, v)
        end

        for i,v in Players do
            if not table.find(Data.Exclude, v) then
                local Part = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                if Part then
                    local screenpos, onscreen = UserCamera:WorldToScreenPoint(Part.Position)
                    if screenpos and onscreen then
                        local mouse = LocalPlayer:GetMouse()
                        local mousepos = mouse.Hit.Position
                        local mag = (mousepos - Part.Position).Magnitude
                        local plrdist = (Part.Position - Part.Position).Magnitude
                        if Data.Limit >= mag and RData.Distance >= mag and (RData.Distance == mag and RData.PlayerDist >= plrdist or RData.Distance ~= mag) then
                            RData = {
                                Player = PlayersSV:GetPlayerFromCharacter(v) :: Player,
                                Character = v,
                                Distance = mag :: number,
                                PlayerDist = plrdist :: number
                            }
                        end
                    end
                end
            end
        end
        return RData :: {Player: Player, Distance: number, PlayerDist: number}
    end
end

do
    Assets.Config.Save = function(File, data)
        writefile("Night/Config/"..File..".json", HttpService:JSONEncode(data))
    end
    
    Assets.Config.Load = function(File, set)
        if isfile("Night/Config/"..File..".json") then
            local data = readfile("Night/Config/"..File..".json")
            local data2 = HttpService:JSONDecode(data)
            if set then
                Night.Config[set] = data2
                if set == "Game" then
                    local allmodules = Assets.Functions.GetAllModules()
                    for i,v in allmodules do
                        for i2, v2 in v.Settings do
                            if v2.Type then
                                if data2[v2.Type] then
                                    if data2[v2.Type][v2.Flag] ~= nil then
                                        v2.Functions.SetValue(data2[v2.Type][v2.Flag], false)
                                    elseif data2[v2.Type][v2.Flag] == nil and v2.Default ~= nil then
                                        v2.Functions.SetValue(v2.Default, false)
                                    elseif data2[v2.Type][v2.Flag] == false then
                                        v2.Functions.SetValue(false, false)
                                    end
                                else
                                    if v2.Default ~= nil then
                                        v2.Functions.SetValue(v2.Default, false)
                                    end
                                end
                            end
                        end

                        if data2.Keybinds and data2.Keybinds[i] then
                            if v.Functions and v.Functions.BindKeybind then
                                v.Functions.BindKeybind(data2.Keybinds[i], false)
                            end
                        end
                        if data2.Modules and data2.Modules[i] or data2.Modules and v.Default and data2.Modules[i] == nil then
                            if not v.Data.Enabled then
                                v.Functions.Toggle(true, false, false, false, true)
                            end
                        else
                            if v.Data.Enabled then
                                v.Functions.Toggle(false, false, false, false, true)
                            end
                        end
                    end

                    if Night.Config.Game.Other.TabPos then
                        for i,v in Night.Tabs.Tabs do
                            local tabpos = Night.Config.Game.Other.TabPos[i]
                            if tabpos and v.Objects and v.Objects.ActualTab then
                                local tab = v.Objects.ActualTab
                                if tabpos.X then
                                    tab.Position = UDim2.fromScale(tabpos.X, tab.Position.Y.Scale)
                                end
                                if tabpos.Y then
                                    tab.Position = UDim2.fromScale(tab.Position.X.Scale, tabpos.Y)
                                end
                            end
                        end
                    end
                end
            end
            return data2
        end
        return "no file"
    end
    
end

local function GetTextBounds(str: string, font: Font, textsize: number)
    local Params = Instance.new("GetTextBoundsParams")
    Params.Text = str
    Params.Font = font
    Params.Size = textsize
    Params.Width = 1e9
    Params.RichText = false
    
    return TextService:GetTextBoundsAsync(Params)
end

do
    type FontFamily = {
        name: string,
        faces: { FontFace },
    }
    
    type FontFace = {
        name: string,
        file: string,
        weight: number,
        style: string?,
    }

    Assets.Font.Download = function(Name: string, Font: string)
        local data = game:HttpGet(Font)
        if not isfile("Night/Assets/Fonts/"..Name..".ttf") then
            if data and not tostring(data):find("404") then
                writefile("Night/Assets/Fonts/"..Name..".ttf", data)
            else
                return false
            end
        end
        return true
    end

    local family_cache = {}
    Assets.Font.create_family = function(name: string, faces: { FontFace })
        local family = { name = name, faces = {} }

        for i, face in next, faces do
            local rbx_face = {
                name = assert(face.name, `Face #{i} is invalid (no name field)`),
                weight = assert(face.weight, `Face #{i} is invalid (no weight field)`),
                style = face.style or "normal",
                assetId = getcustomasset(face.file),
            }

            table.insert(family.faces, rbx_face)
        end

        writefile("Night/Assets/Fonts/"..name..".json", HttpService:JSONEncode(family))

        local id = getcustomasset("Night/Assets/Fonts/"..name..".json")
        family_cache[name] = id

        return id
    end

    Assets.Font.get_family = function(name: string)
        local id = assert(family_cache[name], `Family {name} not found!`)

        return id
    end
end

do

    Assets.Notifications.Send = function(data: any)
        local NotificationData = {
            Description = data.Description or "This is a notification",
            Duration = data.Duration or 5,
            Flag = data.Flag,
            Running = true,
            Objects = {},
            Functions = {},
            Connections = {}
        }

        local flag = NotificationData.Flag or NotificationData.Description
        for i, v in Night.Notifications.Active do
            if v.Objects.Notification then
                TweenService:Create(v.Objects.Notification, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(v.Objects.Notification.Position.X.Scale, v.Objects.Notification.Position.X.Offset, v.Objects.Notification.Position.Y.Scale, v.Objects.Notification.Position.Y.Offset + 50)}):Play()
            end
        end
        

        NotificationData.Objects.Notification = Instance.new("ImageButton", Night.Notifications.Objects.NotificationGui)
        NotificationData.Objects.Notification.AnchorPoint = Vector2.new(0.5, 0)
        NotificationData.Objects.Notification.AutoButtonColor = false
        NotificationData.Objects.Notification.AutomaticSize = Enum.AutomaticSize.X
        NotificationData.Objects.Notification.BackgroundColor3 = Color3.fromRGB(79, 79, 79)
        NotificationData.Objects.Notification.BackgroundTransparency = 0.05
        NotificationData.Objects.Notification.Position = UDim2.new(0.5, 0, -1, 30)
        NotificationData.Objects.Notification.Size = UDim2.new(0, 0, 0, 40)
        NotificationData.Objects.Notification.ZIndex = 10
        NotificationData.Objects.Notification.Image = "rbxassetid://16294030997"
        NotificationData.Objects.Notification.ScaleType = Enum.ScaleType.Crop
        NotificationData.Objects.Notification.ImageColor3 = Color3.fromRGB(80, 80, 80)
        NotificationData.Objects.Notification.ClipsDescendants = true
        Instance.new("UICorner", NotificationData.Objects.Notification).CornerRadius = UDim.new(0, 100)

        local NotificationPadding = Instance.new("UIPadding", NotificationData.Objects.Notification)
        NotificationPadding.PaddingBottom = UDim.new(0, 5)
        NotificationPadding.PaddingLeft = UDim.new(0, 20)
        NotificationPadding.PaddingRight = UDim.new(0, 20)
        NotificationPadding.PaddingTop = UDim.new(0, 5)

        local NotificationStroke = Instance.new("UIStroke", NotificationData.Objects.Notification)
        NotificationStroke.Color = Color3.fromRGB(255, 255, 255)
        local NotificationStrokeGradient = Instance.new("UIGradient", NotificationStroke)
        NotificationStrokeGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0.694, 0), NumberSequenceKeypoint.new(1, 0.869, 0)}
        NotificationStrokeGradient.Rotation = 80

        local CloseButton = Instance.new("ImageButton", NotificationData.Objects.Notification)
        CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
        CloseButton.BackgroundTransparency = 1
        CloseButton.Position = UDim2.new(0, 8, 0.5, 0)
        CloseButton.Size = UDim2.new(0, 16, 0, 16)
        CloseButton.ZIndex = 10
        CloseButton.Image = "rbxassetid://11295275950"
        CloseButton.ScaleType = Enum.ScaleType.Fit
        CloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.AutoButtonColor = false


        local TimeLine = Instance.new("ImageLabel", NotificationData.Objects.Notification)
        TimeLine.AnchorPoint = Vector2.new(0.5, 1)
        TimeLine.BackgroundTransparency = 1
        TimeLine.Position = UDim2.fromScale(0.5, 1)
        TimeLine.Size = UDim2.new(0.1, 50, 0, 2)
        TimeLine.ZIndex = 10
        TimeLine.Image = "rbxassetid://16294678871"
        TimeLine.ScaleType = Enum.ScaleType.Slice
        TimeLine.SliceCenter = Rect.new(206, 206, 206, 206)
        TimeLine.ImageColor3 = Color3.fromRGB(255, 255, 255)
        TimeLine.ImageTransparency = 0.8
        TimeLine.Visible = false

        local TimeLineBar = Instance.new("ImageLabel", TimeLine)
        TimeLineBar.AnchorPoint = Vector2.new(0, 0.5)
        TimeLineBar.BackgroundTransparency = 1
        TimeLineBar.Position = UDim2.fromScale(0, 0.5)
        TimeLineBar.Size = UDim2.fromScale(0, 2)
        TimeLineBar.Image = "rbxassetid://16294678871"
        TimeLineBar.BorderSizePixel = 0
        TimeLineBar.ScaleType = Enum.ScaleType.Slice
        TimeLineBar.SliceCenter = Rect.new(206, 206, 206, 206)
        TimeLineBar.ImageTransparency = 0.2
        TimeLineBar.ZIndex = 10

        NotificationData.Objects.NotificationDescription = Instance.new("TextLabel", NotificationData.Objects.Notification)
        NotificationData.Objects.NotificationDescription.AutomaticSize = Enum.AutomaticSize.X
        NotificationData.Objects.NotificationDescription.BackgroundTransparency = 1
        NotificationData.Objects.NotificationDescription.Position = UDim2.fromOffset(26, 0)
        NotificationData.Objects.NotificationDescription.Size = UDim2.fromScale(0, 1)
        NotificationData.Objects.NotificationDescription.ZIndex = 10
        NotificationData.Objects.NotificationDescription.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
        NotificationData.Objects.NotificationDescription.Text = NotificationData.Description
        NotificationData.Objects.NotificationDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotificationData.Objects.NotificationDescription.TextSize = 15
        NotificationData.Objects.NotificationDescription.TextTransparency = 0.2

        NotificationData.Functions.Remove = function(anim: boolean)
            if not Night or not Night.Notifications or not Night.Notifications.Active then return end
            for i,v in NotificationData.Connections do
                v:Disconnect()
                if table.find(Night.Connections, v) then
                    table.remove(Night.Connections, table.find(Night.Connections, v))
                end
            end

            for i, v in Night.Notifications.Active do
                if v.Objects.Notification and v.Objects.Notification.Position.Y.Offset > NotificationData.Objects.Notification.Position.Y.Offset then
                    TweenService:Create(v.Objects.Notification, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(v.Objects.Notification.Position.X.Scale, v.Objects.Notification.Position.X.Offset, v.Objects.Notification.Position.Y.Scale, v.Objects.Notification.Position.Y.Offset - 50)}):Play()
                end
            end

            if anim then
                TweenService:Create(TimeLineBar, TweenInfo.new(0.15), {ImageTransparency = 1}):Play()
                for i,v in NotificationData.Objects.Notification:GetChildren() do
                    if v:IsA("ImageButton") or v:IsA("ImageLabel") then
                        TweenService:Create(v, TweenInfo.new(0.15), {ImageTransparency = 1, BackgroundTransparency = 1}):Play()
                    elseif v:IsA("TextLabel") then
                        TweenService:Create(v, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
                    end
                end
                task.wait(0.05)
                TweenService:Create(NotificationData.Objects.Notification, TweenInfo.new(0.2), {ImageTransparency = 1, BackgroundTransparency = 1}):Play()
                task.wait(0.22)
            end

            NotificationData.Objects.Notification:Destroy()
            if Night and Night.Notifications and Night.Notifications.Active then
                Night.Notifications.Active[flag] = nil
            end
            table.clear(NotificationData)
        end
        
        NotificationData.Connections.conhover = NotificationData.Objects.Notification.MouseEnter:Connect(function()
            TimeLine.Visible = true
            CloseButton.Image = "rbxassetid://11293981586"
        end)
        
        NotificationData.Connections.unconhover = NotificationData.Objects.Notification.MouseLeave:Connect(function()
            TimeLine.Visible = false
            CloseButton.Image = "rbxassetid://11295275950"
        end)

        NotificationData.Connections.closecon = CloseButton.MouseButton1Click:Connect(function() NotificationData.Functions.Remove(true) end)

        table.insert(Night.Connections, NotificationData.Connections.conhover)
        table.insert(Night.Connections, NotificationData.Connections.unconhover)
        table.insert(Night.Connections, NotificationData.Connections.closecon)

        TweenService:Create(NotificationData.Objects.Notification, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 30)}):Play()
        if Night.Notifications.Active[flag] then
            flag = NotificationData.Description..tostring(math.random(0, 1000000000))
            Night.Notifications.Active[flag] = NotificationData
        else
            Night.Notifications.Active[flag] = NotificationData
        end

        local start = os.clock()
        task.spawn(function()
            repeat 
                TimeLineBar.Size = UDim2.new((os.clock() - start) / Night.Notifications.Active[flag].Duration, 0, 0, 2)
                task.wait()
            until Night and Night.Notifications and Night.Notifications.Active[flag] and (os.clock() - start) >= Night.Notifications.Active[flag].Duration or Night and Night.Notifications and Night.Notifications.Active and not Night.Notifications.Active[flag] or not Night or not Night.Notifications
            if Night and Night.Notifications and Night.Notifications.Active and Night.Notifications.Active[flag] then
                NotificationData.Functions.Remove(true)
            end
        end)

        return NotificationData
    end
end


do    
    Assets.MainBackground.Init = function()
        local InitInfo = {
            Functions = {Resize = nil, Drag = nil}, 
            Data = {Resizing = false, Dragging = false, LastInputPosition = nil, IsToggleAnimating = false}, 
            Objects = {},
            NavigationButtons = {},
            WindowControls = {IsOpened = false, Instances = {}},
            MobileButtons = {indxs = {}, Buttons = {}}
        }
    
        Night.Notifications.Objects.NotificationGui = Instance.new("ScreenGui", Assets.Functions.gethui())
        Night.Notifications.Objects.NotificationGui.ResetOnSpawn = false
        Night.Notifications.Objects.NotificationGui.IgnoreGuiInset = true
        Night.Notifications.Objects.NotificationGui.DisplayOrder = 10000
        if Night.Mobile then
            Instance.new("UIScale", Night.Notifications.Objects.NotificationGui).Scale = Night.Config.UI.Scale
        end

        Night.ArrayList.Objects.ArrayGui = Instance.new("ScreenGui", Assets.Functions.gethui())
        Night.ArrayList.Objects.ArrayGui.ResetOnSpawn = false
        Night.ArrayList.Objects.ArrayGui.DisplayOrder = 10000
        Night.ArrayList.Objects.ArrayGui.Enabled = false
        if Night.Config.UI.ArrayList == nil then
            Night.Config.UI.ArrayList = false
        end
    
        InitInfo.Objects.MainScreenGui = Instance.new("ScreenGui", Assets.Functions.gethui())
        InitInfo.Objects.MainScreenGui.ResetOnSpawn = false
        InitInfo.Objects.MainScreenGui.IgnoreGuiInset = true
        InitInfo.Objects.MainScreenGui.DisplayOrder = 10000
        InitInfo.Objects.MainScreenGuiScale = Instance.new("UIScale", InitInfo.Objects.MainScreenGui)
        InitInfo.Objects.MainScreenGuiScale.Scale = Night.Config.UI.Scale
            
        InitInfo.Objects.MainFrame = Instance.new("ImageButton", InitInfo.Objects.MainScreenGui)
        InitInfo.Objects.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        InitInfo.Objects.MainFrame.AutoButtonColor = false
        InitInfo.Objects.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        InitInfo.Objects.MainFrame.BackgroundTransparency = 1
        InitInfo.Objects.MainFrame.Position = UDim2.fromScale(Night.Config.UI.Position.X, Night.Config.UI.Position.Y)
        InitInfo.Objects.MainFrame.Size = UDim2.fromScale(Night.Config.UI.Size.X, Night.Config.UI.Size.Y)
        InitInfo.Objects.MainFrame.Image = "rbxassetid://16255699706"
        InitInfo.Objects.MainFrame.ImageTransparency = 1
        InitInfo.Objects.MainFrame.ScaleType = Enum.ScaleType.Crop
        InitInfo.Objects.MainFrame.Visible = false
        local mainframecorner = Instance.new("UICorner", InitInfo.Objects.MainFrame)
        mainframecorner.CornerRadius = UDim.new(0, 20)
        InitInfo.Objects.MainFrameScale = Instance.new("UIScale", InitInfo.Objects.MainFrame)
        InitInfo.Objects.MainFrameScale.Scale = 1.2
        table.insert(Night.Corners, mainframecorner)
    
        InitInfo.Objects.PageHolder = Instance.new("Frame", InitInfo.Objects.MainFrame)
        InitInfo.Objects.PageHolder.BackgroundTransparency = 1
        InitInfo.Objects.PageHolder.AnchorPoint = Vector2.new(0.5, 0.5)
        InitInfo.Objects.PageHolder.Size = UDim2.fromScale(1, 1)
        InitInfo.Objects.PageHolder.Position = UDim2.fromScale(0.5, 0.5)
        InitInfo.Objects.PageHolder.ClipsDescendants = true
    
        if Night.Mobile then
            InitInfo.Objects.ToggleButton = Instance.new("ImageButton", Night.Notifications.Objects.NotificationGui)
            InitInfo.Objects.ToggleButton.AnchorPoint = Vector2.new(0.5, 0)
            InitInfo.Objects.ToggleButton.AutoButtonColor = false
            InitInfo.Objects.ToggleButton.BackgroundColor3 = Color3.new(0,0,0)
            InitInfo.Objects.ToggleButton.BackgroundTransparency = 0.2
            InitInfo.Objects.ToggleButton.BorderSizePixel = 0
            InitInfo.Objects.ToggleButton.Position = UDim2.fromScale(0.5, 0)
            InitInfo.Objects.ToggleButton.Size = UDim2.fromOffset(45, 44)
            InitInfo.Objects.ToggleButton.Draggable = true
    
            local NightIcon = Instance.new("ImageLabel", InitInfo.Objects.ToggleButton)
            NightIcon.AnchorPoint = Vector2.new(0.5, 0.5)
            NightIcon.BackgroundTransparency = 1
            NightIcon.Position = UDim2.fromScale(0.5, 0.5)
            NightIcon.Size = UDim2.fromScale(0.5, 0.5)
            NightIcon.Image = "rbxassetid://88680068080114"
            Instance.new("UICorner", InitInfo.Objects.ToggleButton).CornerRadius = UDim.new(1, 0)
    
            table.insert(Night.Connections, InitInfo.Objects.ToggleButton.MouseButton1Click:Connect(function()
                Assets.Main.ToggleVisibility(not InitInfo.Objects.MainFrame.Visible)
            end))
            

            InitInfo.Objects.MobileKeybindFolder = Instance.new("Folder", InitInfo.Objects.MainScreenGui)
            InitInfo.Functions.CreateMobileButton = function(info)
                local MobileButtonInfo = {
                    Name = info.Name or "mobile button",
                    Flag = info.Flag or "flagbutton",
                    Callbacks = info.Callbacks or {Began = function() end, End = function() end},
                    Instances = {},
                    Connections = {},
                    Functions = {},
                    Data = {Position = {X = 0.062, Y = 0.418}, CurrIndex = 1, NextChange = "Y", Dragging = false},
                }

                if not MobileButtonInfo.Callbacks.Began then
                    MobileButtonInfo.Callbacks.Began = function() end
                end

                if not MobileButtonInfo.Callbacks.End then
                    MobileButtonInfo.Callbacks.End = function() end
                end
    
                if #InitInfo.MobileButtons.indxs > 0 then
                    MobileButtonInfo.Data.CurrIndex = #InitInfo.MobileButtons.indxs + 1
                    local curinfo = InitInfo.MobileButtons.indxs[#InitInfo.MobileButtons.indxs]
                    if curinfo and curinfo.Data and curinfo.Data.Position then
                        local pos = curinfo.Data.Position
                        MobileButtonInfo.Data.Position.X = pos.X
                        if curinfo.Data.NextChange == "Y" then
                            MobileButtonInfo.Data.Position.Y = pos.Y + 0.082
                            MobileButtonInfo.Data.NextChange = "X"
                        else
                            MobileButtonInfo.Data.Position.X = pos.X + 0.048
                        end
                    end
                end
    
                MobileButtonInfo.Instances.MainBG = Instance.new("TextButton", InitInfo.Objects.MobileKeybindFolder)
                MobileButtonInfo.Instances.MainBG.AutoButtonColor = false
                MobileButtonInfo.Instances.MainBG.AnchorPoint = Vector2.new(0.5,0.5)
                MobileButtonInfo.Instances.MainBG.BackgroundTransparency = 0.2
                MobileButtonInfo.Instances.MainBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
                MobileButtonInfo.Instances.MainBG.BorderSizePixel = 0
                MobileButtonInfo.Instances.MainBG.Position = UDim2.fromScale(MobileButtonInfo.Data.Position.X, MobileButtonInfo.Data.Position.Y)
                MobileButtonInfo.Instances.MainBG.Size = UDim2.fromScale(0.049, 0.086)
                MobileButtonInfo.Instances.MainBG.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                MobileButtonInfo.Instances.MainBG.Text = MobileButtonInfo.Name
                MobileButtonInfo.Instances.MainBG.TextScaled = true
                MobileButtonInfo.Instances.MainBG.ZIndex = 1000000
                MobileButtonInfo.Instances.MainBG.TextColor3 = Color3.fromRGB(255,255,255)
                MobileButtonInfo.Instances.MainBG.Draggable = true
    
                Instance.new("UICorner", MobileButtonInfo.Instances.MainBG).CornerRadius = UDim.new(0, 5)

                local button = Instance.new("ImageButton", MobileButtonInfo.Instances.MainBG)
                button.AnchorPoint = Vector2.new(0.5, 0.5)
                button.Size = UDim2.fromScale(1, 1)
                button.Position = UDim2.fromScale(0.5, 0.5)
                button.ZIndex = 10000000
                button.ImageTransparency = 1
                button.BackgroundTransparency = 1
    
                MobileButtonInfo.Functions.Destroy = function()
                    InitInfo.MobileButtons.Buttons[MobileButtonInfo.Flag] = nil
                    InitInfo.MobileButtons.indxs[MobileButtonInfo.Data.CurrIndex] = nil
    
                    MobileButtonInfo.Instances.MainBG:Destroy()
                    for i,v in MobileButtonInfo.Connections do
                        if table.find(Night.Connections, v) then
                            table.remove(Night.Connections, table.find(Night.Connections, v))
                        end
                        v:Disconnect()
                    end
    
                    local nextbutton = InitInfo.MobileButtons[MobileButtonInfo.Data.CurrIndex + 1]
                    if nextbutton and nextbutton.Data then
                        nextbutton.Data.CurrIndex -= 1
                    end
    
                    
                    table.clear(MobileButtonInfo)
                end

                MobileButtonInfo.Functions.Drag = function(mouseStart: Vector2 | Vector3 | nil, frameStart: UDim2, input: InputObject?)
                    pcall(function()
                        if UserCamera then
                            local Viewport = UserCamera.ViewportSize
                            local Delta = Vector2.new(0, 0)
                            local FrameSize = MobileButtonInfo.Instances.MainBG.AbsoluteSize
                            if mouseStart and input then
                                Delta = (Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(mouseStart.X, mouseStart.Y :: Vector2 & Vector3))
                            end
                
                            local newX = math.clamp(frameStart.X.Scale + (Delta.X / Viewport.X), FrameSize.X / Viewport.X / 2, 1 - FrameSize.X / Viewport.X / 2)
                            local newY = math.clamp(frameStart.Y.Scale + (Delta.Y / Viewport.Y), FrameSize.Y / Viewport.Y / 2, 1 - FrameSize.Y / Viewport.Y / 2)
                
                            local Position = UDim2.new(newX, 0, newY, 0)
                            MobileButtonInfo.Instances.MainBG.Position = Position 
                            MobileButtonInfo.Data.Position = {X = newX, Y = newY}           
                        end
                    end)
                end

                local InputStarting, FrameStarting, HoldTime = nil, nil, 0
                local dragcon = button.InputBegan:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then

                        MobileButtonInfo.Callbacks.Began(MobileButtonInfo)

                        Night.InputEndFunc = function(input)
                            if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
                                local hold = (tick()-HoldTime) >= 0.8
                                MobileButtonInfo.Callbacks.End(MobileButtonInfo, hold)
                                HoldTime = 0
                                Night.CurrntInputChangeCallback = function() end
                                Night.InputEndFunc = nil
                                
                                if hold then
                                    MobileButtonInfo.Data.Dragging, InputStarting, FrameStarting = false, input.Position, MobileButtonInfo.Instances.MainBG.Position

                                    if not Night.Config.Game.Other.MobileButtonPos then 
                                        Night.Config.Game.Other.MobileButtonPos = {}
                                    end

                                    Night.Config.Game.Other.MobileButtonPos[MobileButtonInfo.Flag] = {X = FrameStarting.X.Scale, Y = FrameStarting.Y.Scale}
                                    Assets.Config.Save(Night.GameSave, Night.Config.Game)
                                end
                            end
                        end

                        HoldTime = tick()
                        repeat task.wait() until tick() - HoldTime >= 0.8 or HoldTime == 0
                        if HoldTime >= 0.8 then
                            MobileButtonInfo.Data.Dragging, InputStarting, FrameStarting = true, input.Position, MobileButtonInfo.Instances.MainBG.Position
                            Night.CurrntInputChangeCallback = function(input)
                                if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then  
                                    if MobileButtonInfo.Data.Dragging and not Night.Config.UI.FullScreen then
                                        MobileButtonInfo.Functions.Drag(InputStarting, FrameStarting, input)
                                    end
                                end
                            end
                        end

                    end
                end)

                table.insert(Night.Connections, dragcon)
                table.insert(MobileButtonInfo.Connections, dragcon)

                if Night.Config.Game.Other.MobileButtonPos and Night.Config.Game.Other.MobileButtonPos[MobileButtonInfo.Flag] then
                    local pos = Night.Config.Game.Other.MobileButtonPos[MobileButtonInfo.Flag]
                    if pos.X then
                        MobileButtonInfo.Instances.MainBG.Position = UDim2.fromScale(pos.X, MobileButtonInfo.Instances.MainBG.Position.Y.Scale)
                    end
                    if pos.Y then
                        MobileButtonInfo.Instances.MainBG.Position = UDim2.fromScale(MobileButtonInfo.Instances.MainBG.Position.X.Scale, pos.Y)
                    end
                end
            
    
                InitInfo.MobileButtons.indxs[MobileButtonInfo.Data.CurrIndex] = MobileButtonInfo
                InitInfo.MobileButtons.Buttons[MobileButtonInfo.Flag] = MobileButtonInfo
                return MobileButtonInfo
            end
        end
    
        InitInfo.Objects.DropShadow = Instance.new("ImageLabel", InitInfo.Objects.MainFrame)
        InitInfo.Objects.DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        InitInfo.Objects.DropShadow.BackgroundTransparency = 1
        InitInfo.Objects.DropShadow.BorderSizePixel = 0
        InitInfo.Objects.DropShadow.Position = UDim2.fromScale(0.5, 0.5)
        InitInfo.Objects.DropShadow.Size = UDim2.new(1, 88, 1, 88)
        InitInfo.Objects.DropShadow.ZIndex = -10
        InitInfo.Objects.DropShadow.Image = "rbxassetid://16286730454"
        InitInfo.Objects.DropShadow.ScaleType = Enum.ScaleType.Slice
        InitInfo.Objects.DropShadow.SliceCenter = Rect.new(512, 512, 512, 512)
        InitInfo.Objects.DropShadow.SliceScale = 0.19
    
        local ZoomFrame = Instance.new("Frame", InitInfo.Objects.MainFrame)
        ZoomFrame.Size = UDim2.fromScale(1, 1)
        ZoomFrame.BackgroundTransparency = 1
        ZoomFrame.ZIndex = 100000
        table.insert(Night.Connections, ZoomFrame.MouseWheelForward:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) and Night.Background.Objects.MainFrame.Visible then
                Night.Config.UI.Scale = Night.Config.UI.Scale + 0.05
                if Night.Config.UI.Scale > 3 then
                    Night.Config.UI.Scale = 3
                end
                InitInfo.Objects.MainScreenGuiScale.Scale = Night.Config.UI.Scale
                Assets.Config.Save("UI", Night.Config.UI)
            end
        end))
    
        table.insert(Night.Connections, ZoomFrame.MouseWheelBackward:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) and Night.Background.Objects.MainFrame.Visible then
                Night.Config.UI.Scale = Night.Config.UI.Scale - 0.05
                if Night.Config.UI.Scale < 0.4 then
                    Night.Config.UI.Scale = 0.4
                end
                InitInfo.Objects.MainScreenGuiScale.Scale = Night.Config.UI.Scale
                Assets.Config.Save("UI", Night.Config.UI)
            end
        end))
    
        InitInfo.Objects.NavigationButtons = Instance.new("Frame", InitInfo.Objects.MainFrame)
        InitInfo.Objects.NavigationButtons.BackgroundTransparency = 1
        InitInfo.Objects.NavigationButtons.Position = UDim2.fromScale(0.025, 0.091)
        InitInfo.Objects.NavigationButtons.Size = UDim2.fromScale(0.074, 0.058)
        InitInfo.Objects.NavigationButtons.BorderSizePixel = 0
        local navlist = Instance.new("UIListLayout", InitInfo.Objects.NavigationButtons)
        navlist.Padding = UDim.new(0, 10)
        navlist.FillDirection = Enum.FillDirection.Horizontal
    
        InitInfo.Objects.WindowControls = Instance.new("CanvasGroup", InitInfo.Objects.MainFrame)
        InitInfo.Objects.WindowControls.AnchorPoint = Vector2.new(0.5, 0.5)
        InitInfo.Objects.WindowControls.BackgroundTransparency = 1
        InitInfo.Objects.WindowControls.Position = UDim2.fromScale(0.5, 0.5)
        InitInfo.Objects.WindowControls.Size = UDim2.fromScale(1, 1)
        InitInfo.Objects.WindowControls.ZIndex = 2
    
        local MainControlsWindow = Instance.new("Frame", InitInfo.Objects.WindowControls)
        MainControlsWindow.AnchorPoint = Vector2.new(1, 1)
        MainControlsWindow.BackgroundTransparency = 1
        MainControlsWindow.Position = UDim2.fromScale(1, 1)
        MainControlsWindow.Size = UDim2.fromOffset(100, 50)
    
        local MainWindowControlList = Instance.new("UIListLayout", MainControlsWindow)
        MainWindowControlList.FillDirection = Enum.FillDirection.Horizontal
        MainWindowControlList.SortOrder = Enum.SortOrder.LayoutOrder
        MainWindowControlList.HorizontalFlex = Enum.UIFlexAlignment.Fill
    
    
        InitInfo.Functions.CreateNavigationButton = function(Data: any)
            local buttondata = {
                Button = nil,
                Name = Data.Name or "Button",
                Icon = Data.Icon or "",
                Callback = Data.Callback or function() end
            }
    
            buttondata.Button = Instance.new("ImageButton", InitInfo.Objects.NavigationButtons)
            buttondata.Button.AutoButtonColor = false
            buttondata.Button.BackgroundTransparency = 0.9
            buttondata.Button.Size = UDim2.fromOffset(40, 40)
            buttondata.Button.Image = ""
            Instance.new("UICorner",buttondata.Button).CornerRadius = UDim.new(1,0)
    
            local hovergradient = Instance.new("UIGradient", buttondata.Button)
            hovergradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0), NumberSequenceKeypoint.new(1, 0.331, 0)}
            hovergradient.Enabled = false
    
            local iconimage = Instance.new("ImageLabel", buttondata.Button)
            iconimage.AnchorPoint = Vector2.new(0.5, 0.5)
            iconimage.BackgroundTransparency = 1
            iconimage.BorderSizePixel = 0
            iconimage.Position = UDim2.fromScale(0.5, 0.5)
            iconimage.Size = UDim2.fromScale(0.45, 0.45)
            iconimage.Image = buttondata.Icon
            local iconscale = Instance.new("UIScale", iconimage)
    
            table.insert(Night.Connections, buttondata.Button.MouseEnter:Connect(function()
                hovergradient.Enabled = true
                TweenService:Create(iconscale, TweenInfo.new(0.15), {Scale = 1.2}):Play()
            end))
            table.insert(Night.Connections, buttondata.Button.MouseLeave:Connect(function()
                hovergradient.Enabled = false
                TweenService:Create(iconscale, TweenInfo.new(0.15), {Scale = 1}):Play()
            end))
            table.insert(Night.Connections, buttondata.Button.MouseButton1Click:Connect(function() 
                buttondata.Callback(buttondata)
                TweenService:Create(iconscale, TweenInfo.new(0.15), {Scale = 1.4}):Play()
                task.wait(0.15)
                TweenService:Create(iconscale, TweenInfo.new(0.15), {Scale = 1}):Play()
            end))
    
            InitInfo.NavigationButtons[Data.Name] = buttondata
            return buttondata
        end
    
        InitInfo.Functions.CreateWindowControlButton = function(Data: any)
            local buttondata = {
                Name = Data.Name or "Button",
                Icon = Data.Icon or "",
                Drag = Data.IsDrag or false,
                LayoutOrder = Data.LayoutOrder or 1,
                Visible = Data.Visible or false,
                Objects = {Button = nil, Selection = nil},
                Callbacks = Data.Callbacks or {Clicked = function() end, InputBegan = function() end}
            }
    
            local HasInput = true
            if not buttondata.Callbacks.Clicked then
                buttondata.Callbacks.Clicked = function() end
            elseif not buttondata.Callbacks.InputBegan then
                HasInput = false
                buttondata.Callbacks.InputBegan = function() end
            elseif not buttondata.Callbacks.InputBegan and not buttondata.Callbacks.Clicked then
                HasInput = false
                buttondata.Callbacks.InputBegan = function() end
                buttondata.Callbacks.Clicked = function() end
            end
    
            if buttondata.Drag then
                buttondata.Objects.Button = Instance.new("ImageButton", InitInfo.Objects.WindowControls)
                buttondata.Objects.Button.AnchorPoint = Vector2.new(0.5, 0)
                buttondata.Objects.Button.AutoButtonColor = false
                buttondata.Objects.Button.BackgroundTransparency = 1
                buttondata.Objects.Button.BorderSizePixel = 0
                buttondata.Objects.Button.Position = UDim2.fromScale(0.5, 0)
                buttondata.Objects.Button.Size = UDim2.fromOffset(60, 40)
                buttondata.Objects.Button.ZIndex = 10
                
                local dragicon = Instance.new("ImageLabel", buttondata.Objects.Button)
                dragicon.AnchorPoint = Vector2.new(0.5, 0)
                dragicon.BackgroundTransparency = 1
                dragicon.BorderSizePixel = 0
                dragicon.Position = UDim2.fromScale(0.5, 0)
                dragicon.Size = UDim2.fromScale(1, 0.75)
                dragicon.ZIndex = 10
                dragicon.Image = "rbxassetid://12974354535"
                dragicon.ImageTransparency = 0.5
                dragicon.ScaleType = Enum.ScaleType.Fit
    
                table.insert(Night.Connections, buttondata.Objects.Button.MouseButton1Click:Connect(function()
                    buttondata.Callbacks.Clicked(buttondata)
                end))
            else
                buttondata.Objects.Button = Instance.new("ImageButton", MainControlsWindow)
                buttondata.Objects.Button.AutoButtonColor = false
                buttondata.Objects.Button.BackgroundTransparency = 1
                buttondata.Objects.Button.LayoutOrder = buttondata.LayoutOrder
                buttondata.Objects.Button.Size = UDim2.fromOffset(50, 50)
                buttondata.Objects.Button.ZIndex = 10
        
                buttondata.Objects.ActualIcon = Instance.new("ImageLabel", buttondata.Objects.Button)
                buttondata.Objects.ActualIcon.AnchorPoint = Vector2.new(0.5, 0.5)
                buttondata.Objects.ActualIcon.BackgroundTransparency = 1
                buttondata.Objects.ActualIcon.BorderSizePixel = 0
                buttondata.Objects.ActualIcon.Position = UDim2.fromScale(0.5, 0.5)
                buttondata.Objects.ActualIcon.Size = UDim2.fromOffset(20, 20)
                buttondata.Objects.ActualIcon.Image = buttondata.Icon
                buttondata.Objects.ActualIcon.ImageTransparency = 0.2
                buttondata.Objects.ActualIcon.ScaleType = Enum.ScaleType.Fit
                local ActualIconScale = Instance.new("UIScale", buttondata.Objects.ActualIcon)
        
                buttondata.Objects.Selection = Instance.new("ImageLabel", buttondata.Objects.Button)
                buttondata.Objects.Selection.AnchorPoint = Vector2.new(0.5, 0.5)
                buttondata.Objects.Selection.BackgroundTransparency = 1
                buttondata.Objects.Selection.BorderSizePixel = 0
                buttondata.Objects.Selection.Position = UDim2.fromScale(0.5, 0.5)
                buttondata.Objects.Selection.Size = UDim2.fromOffset(40, 40)
                buttondata.Objects.Selection.Image = "rbxassetid://18412474498"
                buttondata.Objects.Selection.ImageTransparency = 1
                buttondata.Objects.Selection.ScaleType = Enum.ScaleType.Fit
    
                table.insert(Night.Connections, buttondata.Objects.Button.MouseButton1Click:Connect(function()
                    buttondata.Callbacks.Clicked(buttondata)
                    TweenService:Create(ActualIconScale, TweenInfo.new(0.15), {Scale = 0.5}):Play()
        
                    TweenService:Create(buttondata.Objects.Selection, TweenInfo.new(0.15), {ImageTransparency = 0.9}):Play()
                    TweenService:Create(ActualIconScale, TweenInfo.new(0.15), {Scale = 1}):Play()
                end))
    
                if not Night.Mobile then
                    table.insert(Night.Connections, buttondata.Objects.Button.MouseEnter:Connect(function()
                        buttondata.Objects.Selection.ImageTransparency = 1
                        ActualIconScale.Scale = 1.2
    
                        TweenService:Create(ActualIconScale, TweenInfo.new(0.15), {Scale = 1.2}):Play()
                        TweenService:Create(buttondata.Objects.Selection, TweenInfo.new(0.15), {ImageTransparency = 0.8}):Play()
                    end))
    
                    table.insert(Night.Connections, buttondata.Objects.Button.MouseLeave:Connect(function()
                        TweenService:Create(ActualIconScale, TweenInfo.new(0.15), {Scale = 1}):Play()
                        TweenService:Create(buttondata.Objects.Selection, TweenInfo.new(0.15), {ImageTransparency = 1}):Play()
                        task.wait(0.15)
                        buttondata.Objects.Selection.ImageTransparency = 1
                        ActualIconScale.Scale = 1
                    end))
                end
    
            end
    
            if HasInput then
                table.insert(Night.Connections, buttondata.Objects.Button.InputBegan:Connect(buttondata.Callbacks.InputBegan))
            end
        
            InitInfo.WindowControls.Instances[buttondata.Name] = buttondata
            return buttondata
        end
    
        table.insert(Night.Connections, UserInputService.InputEnded:Connect(function(input)
            if Night.InputEndFunc then
                Night.InputEndFunc(input)
            end
        end))
    
        InitInfo.Functions.Resize = function(input : InputObject)
            if InitInfo.Data.Resizing and not Night.Config.UI.FullScreen then
                if not UserCamera then return end
                local delta = input.Position - InitInfo.Data.LastInputPosition
        
                local sensitivity = 0.008
        
                local scaleX = delta.X * sensitivity
                local scaleY = delta.Y * sensitivity
        
                local minScale = 0.15
                local maxScaleX = 0.95
                local maxScaleY = 0.95
        
                local newScaleX = math.clamp(InitInfo.Objects.MainFrame.Size.X.Scale + scaleX, minScale, maxScaleX)
                local newScaleY = math.clamp(InitInfo.Objects.MainFrame.Size.Y.Scale + scaleY, minScale, maxScaleY)
        
                TweenService:Create(InitInfo.Objects.MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Size = UDim2.fromScale(newScaleX, newScaleY)}):Play()
                InitInfo.Data.LastInputPosition = input.Position
                Night.Config.UI.Size = {X = newScaleX, Y = newScaleY}
            end
        end
    
        InitInfo.Functions.Drag = function(mouseStart: Vector2 | Vector3 | nil, frameStart: UDim2, input: InputObject?)
            -- lowww taper fadeee
            pcall(function()
                if UserCamera then
                    local Viewport = UserCamera.ViewportSize
                    local Delta = Vector2.new(0, 0)
                    local FrameSize = InitInfo.Objects.MainFrame.AbsoluteSize
                    if mouseStart and input then
                        Delta = (Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(mouseStart.X, mouseStart.Y :: Vector2 & Vector3))
                    end
        
                    local newX = math.clamp(frameStart.X.Scale + (Delta.X / Viewport.X), FrameSize.X / Viewport.X / 2, 1 - FrameSize.X / Viewport.X / 2)
                    local newY = math.clamp(frameStart.Y.Scale + (Delta.Y / Viewport.Y), FrameSize.Y / Viewport.Y / 2, 1 - FrameSize.Y / Viewport.Y / 2)
        
                    local Position = UDim2.new(newX, 0, newY, 0)
                    InitInfo.Objects.MainFrame.Position = Position
    
                    Night.Config.UI.Position = {X = newX, Y = newY}
                end
            end)
        end
    
    
        Night.CurrntInputChangeCallback = function() end 
        table.insert(Night.Connections, UserInputService.InputChanged:Connect(function(input)
            Night.CurrntInputChangeCallback(input)
        end))
    
    
        InitInfo.Functions.CreateNavigationButton({
            Name = "Close", 
            Icon = "rbxassetid://11293981586", 
            Callback = function()
                if Night and Night.Assets then
                    if Assets.Main and Assets.Main.ToggleVisibility then
                        Assets.Main.ToggleVisibility(false)
                        Assets.Notifications.Send({
                            Description = "Night has been minimized!",
                            Duration = 5
                        })
                    else
                        Assets.Notifications.Send({
                            Description = "Missing close function, send this to a dev!",
                            Duration = 5
                        })
                    end
                end
            end
        })
    
        local forcefullscreen = false
        InitInfo.Functions.CreateWindowControlButton({
            Name = "FullScreen", 
            Icon = "rbxassetid://11295287158", 
            LayoutOrder = 1, 
            Callbacks = {
                Clicked = function(self)
                    if not forcefullscreen then
                        Night.Config.UI.FullScreen = not Night.Config.UI.FullScreen
                    end
                    
                    if Night.Config.UI.FullScreen or forcefullscreen then
                        if not forcefullscreen then
                            Night.Config.UI.Position = {X = InitInfo.Objects.MainFrame.Position.X.Scale, Y = InitInfo.Objects.MainFrame.Position.Y.Scale}
                            Night.Config.UI.Size = {X = InitInfo.Objects.MainFrame.Size.X.Scale, Y = InitInfo.Objects.MainFrame.Size.Y.Scale}
                            Night.Config.UI.Scale = InitInfo.Objects.MainFrameScale.Scale
                        else
                            Night.Config.UI.FullScreen = true
                            forcefullscreen = false
                        end
    
                        TweenService:Create(InitInfo.Objects.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(.5, .5), Size = UDim2.fromScale(1, 1)}):Play()
                        for i,v in Night.Corners do
                            TweenService:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {CornerRadius = UDim.new(0, 0)}):Play()
                        end
                        TweenService:Create(InitInfo.Objects.MainFrameScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Scale = 1}):Play()
                        self.Objects.ActualIcon.Image = "rbxassetid://11422140434"
                        InitInfo.WindowControls.Instances.Resize.Objects.ActualIcon.ImageTransparency = 0.5
                    else
                        self.Objects.ActualIcon.Image = "rbxassetid://11295287158"
                        InitInfo.WindowControls.Instances.Resize.Objects.ActualIcon.ImageTransparency = 0.2
                        TweenService:Create(InitInfo.Objects.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(Night.Config.UI.Position.X, Night.Config.UI.Position.Y), Size = UDim2.fromScale(Night.Config.UI.Size.X, Night.Config.UI.Size.Y)}):Play()
                        for i,v in Night.Corners do
                            TweenService:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {CornerRadius = UDim.new(0, 20)}):Play()
                        end
                        TweenService:Create(InitInfo.Objects.MainFrameScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Scale = Night.Config.UI.Scale}):Play()
                    end
                
                    Assets.Config.Save("UI", Night.Config.UI)
                    
                end
            }
        })
    
    
        local InputStarting, FrameStarting = nil, nil
        InitInfo.Functions.CreateWindowControlButton({
            Name = "Drag", 
            IsDrag = true, 
            Callbacks = {
                InputBegan = function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
                        if Night.Config.UI.FullScreen then 
    
                            Night.Config.UI.FullScreen = false
    
                            InitInfo.WindowControls.Instances.FullScreen.Objects.ActualIcon.Image = "rbxassetid://11295287158"
                            InitInfo.WindowControls.Instances.Resize.Objects.ActualIcon.ImageTransparency = 0.2
    
                            TweenService:Create(InitInfo.Objects.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(Night.Config.UI.Position.X, Night.Config.UI.Position.Y), Size = UDim2.fromScale(Night.Config.UI.Size.X, Night.Config.UI.Size.Y)}):Play()
                            for i,v in Night.Corners do
                                TweenService:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {CornerRadius = UDim.new(0, 20)}):Play()
                            end
                            TweenService:Create(InitInfo.Objects.MainFrameScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Scale = Night.Config.UI.Scale}):Play()
                        end
    
                        InitInfo.Data.Dragging, InputStarting, FrameStarting = true, input.Position, InitInfo.Objects.MainFrame.Position
                        Night.CurrntInputChangeCallback = function(input)
                            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then  
                                if InitInfo.Data.Dragging and not Night.Config.UI.FullScreen then
                                    InitInfo.Functions.Drag(InputStarting, FrameStarting, input)
                                end
                            end
                        end
                        Night.InputEndFunc = function(input)
                            if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
                                InitInfo.Data.Dragging, InputStarting, FrameStarting = false, input.Position, InitInfo.Objects.MainFrame.Position
                                Night.CurrntInputChangeCallback = function() end
                                Assets.Config.Save("UI", Night.Config.UI)
                                Night.InputEndFunc = nil
                            end
                        end
                    end
                end,
                Clicked = function(self)
                    Night.ControlsVisible = not Night.ControlsVisible
                    if Night.ControlsVisible then
                        MainControlsWindow.Visible = true
                        TweenService:Create(MainControlsWindow, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(1, 1), Size = UDim2.fromOffset(100, 50)}):Play()
                    else
                        TweenService:Create(MainControlsWindow, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Position = UDim2.new(1, 100, 1, 0), Size = UDim2.fromOffset(50, 50)}):Play()
                        task.wait(0.5)
                        MainControlsWindow.Visible = false
                    end
                end
            }
        })
    
        InitInfo.Functions.CreateWindowControlButton({
            Name = "Resize", 
            Icon = "rbxassetid://11295287825", 
            LayoutOrder = 2, 
            Callbacks = {
                InputBegan = function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
                        InitInfo.Data.LastInputPosition, InitInfo.Data.Resizing = input.Position, true
                        Night.CurrntInputChangeCallback = function(input)
                            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                                InitInfo.Functions.Resize(input)
                            end
                        end
                        Night.InputEndFunc = function(input)
                            if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
                                InitInfo.Data.Resizing = false
                                Night.CurrntInputChangeCallback = function() end
                                Assets.Config.Save("UI", Night.Config.UI)
                                Night.InputEndFunc = function() end
                            end
                        end
                    end
                end
            }
        })
    
        if Night.Config.UI.FullScreen then
            forcefullscreen = true
            InitInfo.WindowControls.Instances.FullScreen.Callbacks.Clicked(InitInfo.WindowControls.Instances.FullScreen)
        end
    
        return InitInfo
    end
        
end

do 
    Assets.ArrayList.Init = function()
        local Data = {
            Entries = {},
            Connections = {},
            Functions = {},
            RainbowSpeed = 5000,
            Loaded = true,
            Objects = Night.ArrayList.Objects
        }


        local Create = function(Class: string, Properties: { [string]: any }): Instance
            local Inst = Instance.new(Class)
            
            for Index, Value in next, Properties do
                if Index == 'Children' then continue end
                Inst[Index] = Value
            end
            
            if Properties.Children then
                for Index, Child in Properties.Children do
                    Child.Name = Index
                    Child.Parent = Inst
                end
            end
            
            return Inst
        end

        local TEXT_SIZE = if Night.Mobile then 16 else 24
        
        local download = Assets.Font.Download("Product-Sans-Regular", "https://raw.githubusercontent.com/warprbx/NightRewrite/refs/heads/main/Night/Assets/Fonts/Product-Sans-Regular.ttf")
        if not download then
            return 
        end

        local product_sans_id = Assets.Font.create_family("ProductSans", {
            {
                name = "Regular",
                weight = 400,
                file = "Night/Assets/Fonts/Product-Sans-Regular.ttf",
            },
        })
        local font = Font.new(product_sans_id)

        type EntryInstance = Frame & {
            Line: Frame,
            MainText: TextLabel
        }
        
        type ModuleEntry = {
            Name: string,
            Instance: EntryInstance?,
        }
        
        local Template: EntryInstance = Create("Frame", {
            BackgroundColor3 = Color3.new(),
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0,
            Size = UDim2.fromOffset(0, 30),
            
            Children = {
                Line = Create("Frame", {
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Position = UDim2.fromScale(1, 0),
                    Size = UDim2.new(0, 2, 1, 0),
                    BorderSizePixel = 0,
                }),
                MainText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    FontFace = font,
                    Text = '',
                    TextColor3 = Color3.fromRGB(239, 239, 239),
                    TextSize = TEXT_SIZE,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.fromScale(1, 1),
                }),
                UIPadding = Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 6)
                })
            }
        })
        
        local Holder: Frame = Create("Frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -10, 0, 10),
            Size = UDim2.new(0.5, 0, 1, -10),
            Children = {
                UIListLayout = Create("UIListLayout", {
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            },
        })


        function Data.Functions.PushModule(Entry: ModuleEntry)
            local EntryInstance = Template:Clone()
            local MainText = EntryInstance.MainText
            local MainSize = GetTextBounds(Entry.Name, font, TEXT_SIZE)
            
            MainText.Text = Entry.Name
            
            local XSize = MainSize.X + 14
            local YSize = TEXT_SIZE + 6
            
            MainText.Size = UDim2.new(0, MainSize.X, 1, 0)
            
            EntryInstance.Size = UDim2.fromOffset(XSize, YSize)
            EntryInstance.LayoutOrder = #Data.Entries
            EntryInstance.Parent = Holder
                        
            local Index = #Data.Entries + 1
            local _Entry
            _Entry = {
                Name = Entry.Name,
                Instance = EntryInstance,
                Index = Index,
                Deconstruct = function()
                    _Entry.Instance:Destroy()
                    Entry.Instance = nil
                    local Index = table.find(Data.Entries, _Entry)
                    if Index then
                        table.remove(Data.Entries, Index)
                    end
                    Data.Functions.Resort()
                end
                
            }
            
            Data.Entries[Index] = _Entry
            
            Data.Functions.Resort()
            
            return _Entry
        end


        function Data.Functions.Resort()
            table.sort(Data.Entries, function(a: ModuleEntry, b: ModuleEntry)
                local TotalTextA = a.Name
                local TotalTextB = b.Name
                
                local SizeA = GetTextBounds(TotalTextA, font, TEXT_SIZE)
                local SizeB = GetTextBounds(TotalTextB, font, TEXT_SIZE)
        
                return SizeA.X > SizeB.X
            end)
            
            for Index, Entry in next, Data.Entries do
                Entry.Instance.LayoutOrder = Index
            end
        end

        local function Rainbow(Delay: number)
            local time = (os.clock() * 1000 + Delay) / 1000
            local hue = (math.sin(time * 0.5) * 40 + 240) 
            local saturation = math.sin(time * 0.3) * 0.1 + 0.35
            local value = 0.95
            
            return Color3.fromHSV(hue / 360, saturation, value)
        end
        
        local function ArrayListRainbow()
            local Speed = Data.RainbowSpeed
            
            for i, Module in Data.Entries do
                local Color = Rainbow(Speed - i * 250) 
                Module.Instance.MainText.TextColor3 = Color
                Module.Instance.Line.BackgroundColor3 = Color
            end
        end

        function Data.Functions.Toggle(visible: boolean)
            Night.ArrayList.Objects.ArrayGui.Enabled = visible
            if not visible then
                for i,v in Data.Connections do
                    if table.find(Night.Connections, v) then
                        table.remove(Night.Connections, table.find(Night.Connections, v))
                    end
                    v:Disconnect()
                    Data.Connections[i] = nil
                end
            else
                if not Data.Connections.Rainbow then
                    local r = game:GetService("RunService").RenderStepped:Connect(ArrayListRainbow)
                    table.insert(Data.Connections, r)
                    table.insert(Night.Connections, r)
                end
            end
        end

        Holder.Parent = Night.ArrayList.Objects.ArrayGui

        Night.ArrayList = Data
        return Data
    end
end

do
    
    Assets.Pages.Init = function()
        local InitInfo = {
            Objects = {},
            Data = {},
            Functions = {},
            Connections = {}
        }  
    
        InitInfo.Objects.Pageselector = Instance.new("Frame", Night.Background.Objects.MainFrame)
        InitInfo.Objects.Pageselector.AnchorPoint = Vector2.new(0.5, 0.5)
        InitInfo.Objects.Pageselector.BackgroundTransparency = 0.9
        InitInfo.Objects.Pageselector.Position = UDim2.fromScale(0.5, 0.5)
        InitInfo.Objects.Pageselector.Size = UDim2.fromScale(1, 1)
        InitInfo.Objects.Pageselector.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        InitInfo.Objects.Pageselector.ZIndex = 40
        InitInfo.Objects.Pageselector.Visible = false
        InitInfo.Objects.Pageselector.ClipsDescendants = false
        InitInfo.Objects.Pageselector.BackgroundTransparency = 1
    
    
        InitInfo.Objects.PageselectorCorner = Instance.new("UICorner", InitInfo.Objects.Pageselector)
        InitInfo.Objects.PageselectorCorner.CornerRadius = UDim.new(0, 20)
        table.insert(Night.Corners, InitInfo.Objects.PageselectorCorner)
    
        local MainPageselectorMenu = Instance.new("ImageLabel", InitInfo.Objects.Pageselector)
        MainPageselectorMenu.AnchorPoint = Vector2.new(0.5, 0.5)
        MainPageselectorMenu.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
        MainPageselectorMenu.Position = UDim2.new(0, -10, 0.5, 0)
        MainPageselectorMenu.Size = UDim2.new(0, 60, 0, 180)
        MainPageselectorMenu.Image = "rbxassetid://16255699706"
        MainPageselectorMenu.ImageTransparency = 0.8
        MainPageselectorMenu.ScaleType = Enum.ScaleType.Crop
        Instance.new("UICorner", MainPageselectorMenu).CornerRadius = UDim.new(1, 0)
        InitInfo.Objects.MainPageselectorScale = Instance.new("UIScale", MainPageselectorMenu)
        InitInfo.Objects.MainPageselectorScale.Scale = 0.5
        MainPageselectorMenu.ZIndex = 40
        
        local PageselectorShadow = Instance.new("ImageLabel", MainPageselectorMenu)
        PageselectorShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        PageselectorShadow.BackgroundTransparency = 1
        PageselectorShadow.Position = UDim2.fromScale(0.5, 0.5)
        PageselectorShadow.Size = UDim2.new(1, 50, 1, 50)
        PageselectorShadow.Image = "rbxassetid://16264499577"
        PageselectorShadow.ImageTransparency = 0.8
        PageselectorShadow.ScaleType = Enum.ScaleType.Slice
        PageselectorShadow.SliceCenter = Rect.new(379, 379, 379, 379)
    
        InitInfo.Objects.PageselectorButtons = Instance.new("Frame", MainPageselectorMenu)
        InitInfo.Objects.PageselectorButtons.AnchorPoint = Vector2.new(0.5, 0.5)
        InitInfo.Objects.PageselectorButtons.BackgroundTransparency = 1
        InitInfo.Objects.PageselectorButtons.Position = UDim2.fromScale(0.5, 0.5)
        InitInfo.Objects.PageselectorButtons.Size = UDim2.fromScale(1, 1)
        InitInfo.Objects.PageselectorButtons.ZIndex = 40
    
        local PageselectorButtonsLayout = Instance.new("UIListLayout", InitInfo.Objects.PageselectorButtons)
        PageselectorButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageselectorButtonsLayout.Padding = UDim.new(0, 10)
        PageselectorButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        PageselectorButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
        InitInfo.Functions.ToggleSelectorVisibility = function(visible)
            if visible then
                InitInfo.Objects.Pageselector.Visible = true
                InitInfo.Objects.MainPageselectorScale.Scale = 0.5
                InitInfo.Objects.PageselectorButtons.Parent.Position = UDim2.new(0,0,0.5,0)
                InitInfo.Objects.Pageselector.ClipsDescendants = true
                InitInfo.Objects.Pageselector.BackgroundTransparency = 1
        
                TweenService:Create(InitInfo.Objects.Pageselector, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.9}):Play()
                TweenService:Create(InitInfo.Objects.PageselectorButtons.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.new(0, 60, 0.5, 0)}):Play()
                TweenService:Create(InitInfo.Objects.MainPageselectorScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Scale = 1}):Play()
        
            else
                TweenService:Create(InitInfo.Objects.Pageselector, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
                TweenService:Create(InitInfo.Objects.PageselectorButtons.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.new(0, -10, 0.5, 0)}):Play()
                TweenService:Create(InitInfo.Objects.MainPageselectorScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Scale = 0.5}):Play()
                task.wait(0.15)
                InitInfo.Objects.Pageselector.Visible = false
                InitInfo.Objects.Pageselector.ClipsDescendants = false
            end
        end

    
        Night.Background.Functions.CreateNavigationButton({
            Name = "Menu", 
            Icon = "rbxassetid://11295285432", 
            Callback = function()
                InitInfo.Functions.ToggleSelectorVisibility(not Night.Pageselector.Objects.Pageselector.Visible)
            end
        })
    
        Night.Pageselector = InitInfo
        return InitInfo
    end
    
    Assets.Pages.NewPage = function(Data)
        local PageData = {
            Name = Data.Name or "New Page",
            Icon = Data.Icon or "",
            Objects = {},
            Connections = {},
            Default = Data.Default,
            Selected = Data.Default
        }
    
        if not Night.Pageselector then Assets.Pages.Init() end
        PageData.Objects.PageselectorButton = Instance.new("ImageButton", Night.Pageselector.Objects.PageselectorButtons)
        PageData.Objects.PageselectorButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
        PageData.Objects.PageselectorButton.BackgroundTransparency = 1
        PageData.Objects.PageselectorButton.Position = UDim2.fromScale(0.5, 0.5)
        PageData.Objects.PageselectorButton.Size = UDim2.new(0, 50, 0, 50)
        PageData.Objects.PageselectorButton.AutoButtonColor = false
        PageData.Objects.PageselectorButton.ZIndex = 40
        PageData.Objects.PageselectorButton.AutoButtonColor = false
        Instance.new("UICorner", PageData.Objects.PageselectorButton).CornerRadius = UDim.new(1, 0)
        
        local PageselectorButtonIcon = Instance.new("ImageLabel", PageData.Objects.PageselectorButton)
        PageselectorButtonIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        PageselectorButtonIcon.BackgroundTransparency = 1
        PageselectorButtonIcon.Position = UDim2.fromScale(0.5, 0.5)
        PageselectorButtonIcon.Size = UDim2.new(0, 24, 0, 24)
        PageselectorButtonIcon.Image = PageData.Icon
        PageselectorButtonIcon.ImageTransparency = 0.2
        PageselectorButtonIcon.ScaleType = Enum.ScaleType.Fit
        PageselectorButtonIcon.ZIndex = 40
    
        local PageSelectorButtonIconScale = Instance.new("UIScale", PageselectorButtonIcon) 
    
        PageData.Objects.ActualPage = Instance.new("CanvasGroup", Night.Background.Objects.PageHolder)
        PageData.Objects.ActualPage.AnchorPoint = Vector2.new(0.5, 1)
        PageData.Objects.ActualPage.BackgroundTransparency = 1
        PageData.Objects.ActualPage.Position = UDim2.fromScale(0.5, 1)
        PageData.Objects.ActualPage.Size = UDim2.fromScale(1, 1)
        PageData.Objects.ActualPage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        PageData.Objects.ActualPage.Visible = PageData.Default
        PageData.Objects.ActualPage.ClipsDescendants = true
        if not PageData.Default then
            PageData.Objects.ActualPage.GroupTransparency = 1
            PageData.Objects.ActualPage.Position = UDim2.new(0.5, 0, 1.2, 0)
        end
        
        local Pagepad = Instance.new("UIPadding", PageData.Objects.ActualPage)
        Pagepad.PaddingBottom = UDim.new(0, 20)
        Pagepad.PaddingLeft = UDim.new(0, 10)
        Pagepad.PaddingRight = UDim.new(0, 10)
        Pagepad.PaddingTop = UDim.new(0, 10)
    
        local Header = Instance.new("TextLabel", PageData.Objects.ActualPage)
        Header.AnchorPoint = Vector2.new(0.5, 0)
        Header.BackgroundTransparency = 1
        Header.Position = UDim2.new(0.5, 0, 0, 20)
        Header.Size = UDim2.new(1, 0, 0, 40)
        Header.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
        Header.Text = PageData.Name
        Header.TextColor3 = Color3.fromRGB(255, 255, 255)
        Header.TextSize = 22
        Header.TextXAlignment = Enum.TextXAlignment.Center
    
        local MainFrameScrollPage = Instance.new("ScrollingFrame", PageData.Objects.ActualPage)
        MainFrameScrollPage.AnchorPoint = Vector2.new(0.5, 1)
        MainFrameScrollPage.BackgroundTransparency = 1
        MainFrameScrollPage.Position = UDim2.new(0.5, 0, 1, 30)
        MainFrameScrollPage.Size = UDim2.new(1, 0, 0.87, 0)
        MainFrameScrollPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        MainFrameScrollPage.ScrollBarThickness = 2
        MainFrameScrollPage.ScrollBarImageTransparency = 0.8
        MainFrameScrollPage.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
        MainFrameScrollPage.BorderSizePixel = 0
        MainFrameScrollPage.ClipsDescendants = true
        MainFrameScrollPage.CanvasSize = UDim2.new(0,0,0,0)
        MainFrameScrollPage.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    
        local ScrollPad = Instance.new("UIPadding", MainFrameScrollPage)
        ScrollPad.PaddingBottom = UDim.new(0, 20)
        ScrollPad.PaddingLeft = UDim.new(0, 10)
        ScrollPad.PaddingRight = UDim.new(0, 10)
        ScrollPad.PaddingTop = UDim.new(0, 5)
    
        local ScrollList = Instance.new("UIListLayout", MainFrameScrollPage)
        ScrollList.SortOrder = Enum.SortOrder.LayoutOrder
        ScrollList.Padding = UDim.new(0, 10)
        ScrollList.VerticalAlignment = Enum.VerticalAlignment.Top
        ScrollList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
        table.insert(Night.Connections, PageData.Objects.PageselectorButton.MouseEnter:Connect(function()
            TweenService:Create(PageData.Objects.PageselectorButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.8}):Play()
            TweenService:Create(PageSelectorButtonIconScale, TweenInfo.new(0.1), {Scale = 1.4}):Play()
        end))
    
        table.insert(Night.Connections, PageData.Objects.PageselectorButton.MouseLeave:Connect(function()
            TweenService:Create(PageData.Objects.PageselectorButton, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
            TweenService:Create(PageSelectorButtonIconScale, TweenInfo.new(0.1), {Scale = 1}):Play()
        end))
    
        table.insert(Night.Connections, PageData.Objects.PageselectorButton.MouseButton1Click:Connect(function()  
            Night.Pageselector.Functions.ToggleSelectorVisibility(false)
            for i,v in Night.Pages do
                if v.Objects and v.Objects.ActualPage then
                    if v.Objects.ActualPage ~= PageData.Objects.ActualPage then
                        v.Selected = false
                        v.Objects.ActualPage.Visible = false
                        TweenService:Create(v.Objects.ActualPage, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 1.2, 0), GroupTransparency = 1}):Play()
                    else
                        PageData.Selected = true
                        v.Objects.ActualPage.Visible = true
                        TweenService:Create(v.Objects.ActualPage, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 1, 0), GroupTransparency = 0}):Play()
                    end
                end
            end
        end))
    
        Night.Pages[PageData.Name] = PageData
        return PageData
    end

end

do
    Assets.Dashboard.NewTab = function(data)
        local tab = {
            Name = data and data.Name or "Tab",
            Icon = data and data.Icon or "",
            Dashboard = data and data.Dashboard or Night.Pages.Dashboard,
            TabInfo = data and data.TabInfo or "Tab",
            Opened = false,
            Objects = {},
            ClipNeeded = false,
            Tweens = {SearchBackGround = nil},
            Connections = {},
            Modules = {},
            Functions = {}, 
            Data = {Dragging = false, SettingsOpen = false}
        }

        if not tab.Dashboard then return end
        tab.Objects.DashBoardButton = Instance.new("TextButton", tab.Dashboard.Objects.ActualPage:FindFirstChildWhichIsA("ScrollingFrame"))
        tab.Objects.DashBoardButton.AnchorPoint = Vector2.new(0.5, 0)
        tab.Objects.DashBoardButton.AutoButtonColor = false
        tab.Objects.DashBoardButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        tab.Objects.DashBoardButton.BackgroundTransparency = 0.7
        tab.Objects.DashBoardButton.Size = UDim2.new(1, 0, 0, 80)
        tab.Objects.DashBoardButton.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
        tab.Objects.DashBoardButton.Text = tab.Name
        tab.Objects.DashBoardButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tab.Objects.DashBoardButton.TextSize = 16
        tab.Objects.DashBoardButton.TextTransparency = 0.2
        tab.Objects.DashBoardButton.TextXAlignment = Enum.TextXAlignment.Left
        tab.Objects.DashBoardButton.TextYAlignment = Enum.TextYAlignment.Top
        Instance.new("UICorner", tab.Objects.DashBoardButton).CornerRadius = UDim.new(0, 12)
        local DashBoardButtonPad = Instance.new("UIPadding", tab.Objects.DashBoardButton)
        DashBoardButtonPad.PaddingBottom = UDim.new(0, 20)
        DashBoardButtonPad.PaddingLeft = UDim.new(0, 80)
        DashBoardButtonPad.PaddingRight = UDim.new(0, 15)
        DashBoardButtonPad.PaddingTop = UDim.new(0, 20)

        local uistroke = Instance.new("UIStroke", tab.Objects.DashBoardButton)
        uistroke.Color = Color3.fromRGB(255, 255, 255)
        uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local strokegradient = Instance.new("UIGradient", uistroke)
        strokegradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(135, 135, 135)), ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 135, 135))}
        strokegradient.Offset = Vector2.new(-1, 0)
        strokegradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(0.5, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})

        local ButtonArrow = Instance.new("ImageLabel", tab.Objects.DashBoardButton)
        ButtonArrow.AnchorPoint = Vector2.new(1, 0.5)
        ButtonArrow.BackgroundTransparency = 1
        ButtonArrow.Position = UDim2.fromScale(1, 0.5)
        ButtonArrow.Size = UDim2.new(0, 20, 0, 20)
        ButtonArrow.Image = "rbxassetid://11419703997"
        ButtonArrow.ImageColor3 = Color3.fromRGB(255, 255, 255)
        ButtonArrow.ImageTransparency = 0.5
        ButtonArrow.ScaleType = Enum.ScaleType.Fit

        local UserIcon = Instance.new("ImageLabel", tab.Objects.DashBoardButton)
        UserIcon.AnchorPoint = Vector2.new(0, 0.5)
        UserIcon.BackgroundTransparency = 1
        UserIcon.BorderSizePixel = 0
        UserIcon.Position = UDim2.new(0, -55, 0.5, 0)
        UserIcon.Size = UDim2.fromOffset(35, 35)
        UserIcon.Image = tab.Icon
        UserIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        UserIcon.ImageTransparency = 0.2
        UserIcon.ScaleType = Enum.ScaleType.Fit

        if not tab.TabInfo then 
            tab.Objects.DashBoardButton.TextYAlignment = Enum.TextYAlignment.Center
            tab.Objects.DashBoardButton.Size = UDim2.new(1, 0, 0, 60)
        else
            local tabinfolabel = Instance.new("TextLabel", tab.Objects.DashBoardButton)
            tabinfolabel.AnchorPoint = Vector2.new(0.5, 1)
            tabinfolabel.BackgroundTransparency = 1
            tabinfolabel.Position = UDim2.fromScale(0.5, 1)
            tabinfolabel.Size = UDim2.new(1, 0, 0, 22)
            tabinfolabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
            tabinfolabel.Text = tab.TabInfo
            tabinfolabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabinfolabel.TextTransparency = 0.5
            tabinfolabel.TextSize = 14
            tabinfolabel.TextXAlignment = Enum.TextXAlignment.Left
            tabinfolabel.TextWrapped = true
            Instance.new("UIPadding", tabinfolabel).PaddingLeft = UDim.new(0, 20)

            local tabinfoicon = Instance.new("ImageLabel", tabinfolabel)
            tabinfoicon.AnchorPoint = Vector2.new(0, 0.5)
            tabinfoicon.BackgroundTransparency = 1
            tabinfoicon.Position = UDim2.new(0, -20, 0.5, 0)
            tabinfoicon.Size = UDim2.fromOffset(15, 15)
            tabinfoicon.Image = "rbxassetid://11422155687"
            tabinfoicon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            tabinfoicon.ImageTransparency = 0.5
            tabinfoicon.ScaleType = Enum.ScaleType.Fit
        end

        if tab.Name == "Premium" then
            tab.Tweens.PremiumGradient = TweenService:Create(strokegradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, math.huge, true), {Offset = Vector2.new(1,0)})
            tab.Tweens.PremiumGradient:Play()
        end

        if not Night.Tabs.TabBackground then
            Night.Tabs.TabBackground = Instance.new("ImageButton", Night.Background.Objects.MainFrame)
            Night.Tabs.TabBackground.AnchorPoint = Vector2.new(0.5, 0.5)
            Night.Tabs.TabBackground.BackgroundTransparency = 1
            Night.Tabs.TabBackground.Position = UDim2.fromScale(0.5, 0.5)
            Night.Tabs.TabBackground.Size = UDim2.fromScale(1, 1)
            Night.Tabs.TabBackground.Image = "rbxassetid://16286761786"
            Night.Tabs.TabBackground.ImageTransparency = 0.5
            Night.Tabs.TabBackground.ScaleType = Enum.ScaleType.Stretch
            Night.Tabs.TabBackground.Visible = false
            Night.Tabs.TabBackground.AutoButtonColor = false
            Instance.new("UICorner", Night.Tabs.TabBackground).CornerRadius = UDim.new(0, 20)
        end

        tab.Objects.ActualTab = Instance.new("ImageButton", Night.Tabs.TabBackground)
        tab.Objects.ActualTab.AnchorPoint = Vector2.new(0.5, 0.5)
        tab.Objects.ActualTab.BackgroundTransparency = 1
        tab.Objects.ActualTab.Position = UDim2.fromScale(0.5, 0.5)
        tab.Objects.ActualTab.Size = UDim2.fromScale(0.8, 0.8)
        tab.Objects.ActualTab.Image = "rbxassetid://16286719854"
        tab.Objects.ActualTab.ImageColor3 = Color3.fromRGB(Night.Config.UI.TabColor.value1, Night.Config.UI.TabColor.value2, Night.Config.UI.TabColor.value3)
        tab.Objects.ActualTab.ImageTransparency = Night.Config.UI.TabTransparency
        tab.Objects.ActualTab.ScaleType = Enum.ScaleType.Slice
        tab.Objects.ActualTab.SliceCenter = Rect.new(512, 512, 512, 512)
        tab.Objects.ActualTab.SliceScale = 0.1
        tab.Objects.ActualTab.AutoButtonColor = false
        tab.Objects.ActualTab.Visible = false
        if not Night.Config.Game.Other.TabPos then 
            Night.Config.Game.Other.TabPos = {}
        end
        if Night.Config.Game.Other.TabPos[tab.Name] then
            local pos = Night.Config.Game.Other.TabPos[tab.Name]
            if pos.X then
                tab.Objects.ActualTab.Position = UDim2.fromScale(pos.X, tab.Objects.ActualTab.Position.Y.Scale)
            end
            if pos.Y then
                tab.Objects.ActualTab.Position = UDim2.fromScale(tab.Objects.ActualTab.Position.X.Scale, pos.Y)
            end
        end

        local TabPrism = Instance.new("ImageLabel", tab.Objects.ActualTab)
        TabPrism.AnchorPoint = Vector2.new(0.5, 0.5)
        TabPrism.BackgroundTransparency = 1
        TabPrism.Position = UDim2.fromScale(0.5, 0.5)
        TabPrism.Size = UDim2.new(1, 20, 1, 20)
        TabPrism.ZIndex = 1000
        TabPrism.Image = "rbxassetid://16255699706"
        TabPrism.ImageColor3 = Color3.fromRGB(143, 143, 143)
        TabPrism.ImageTransparency = 0.8
        TabPrism.ScaleType = Enum.ScaleType.Crop
        Instance.new("UICorner", TabPrism).CornerRadius = UDim.new(0, 27)
        local PrismStroke = Instance.new("UIStroke", TabPrism)
        PrismStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        PrismStroke.Color = Color3.fromRGB(255, 255, 255)
        PrismStroke.Transparency = 0.85

        tab.Objects.TabDragCanvas = Instance.new("CanvasGroup", tab.Objects.ActualTab)
        tab.Objects.TabDragCanvas.AnchorPoint = Vector2.new(0.5, 0.5)
        tab.Objects.TabDragCanvas.BackgroundTransparency = 1
        tab.Objects.TabDragCanvas.Position = UDim2.fromScale(0.5, 0.5)
        tab.Objects.TabDragCanvas.Size = UDim2.fromScale(1, 1)
        tab.Objects.TabDragCanvas.ZIndex = 10000000

        tab.Objects.DragButton = Instance.new("ImageButton", tab.Objects.TabDragCanvas)
        tab.Objects.DragButton.AnchorPoint = Vector2.new(0.5, 0)
        tab.Objects.DragButton.AutoButtonColor = false
        tab.Objects.DragButton.BackgroundTransparency = 1
        tab.Objects.DragButton.BorderSizePixel = 0
        tab.Objects.DragButton.Position = UDim2.fromScale(0.5, 0)
        tab.Objects.DragButton.Size = UDim2.fromOffset(60, 40)
        tab.Objects.DragButton.ZIndex = 10
        
        local dragicon = Instance.new("ImageLabel", tab.Objects.DragButton)
        dragicon.AnchorPoint = Vector2.new(0.5, 0)
        dragicon.BackgroundTransparency = 1
        dragicon.BorderSizePixel = 0
        dragicon.Position = UDim2.fromScale(0.5, 0)
        dragicon.Size = UDim2.fromScale(1, 0.75)
        dragicon.ZIndex = 10
        dragicon.Image = "rbxassetid://12974354535"
        dragicon.ImageTransparency = 0.5
        dragicon.ScaleType = Enum.ScaleType.Fit

        tab.Functions.Drag = function(mouseStart: Vector2 | Vector3 | nil, frameStart: UDim2, input: InputObject?)
            pcall(function()
                if UserCamera then
                    local Viewport = UserCamera.ViewportSize
                    local Delta = Vector2.new(0, 0)
                    if mouseStart and input then
                        Delta = (Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(mouseStart.X, mouseStart.Y :: Vector2 & Vector3))
                    end
        
                    local newX = frameStart.X.Scale + (Delta.X / (Viewport.X / (Night.Background.Objects.MainFrame.Size.X.Scale + 2.13)))
                    local newY = frameStart.Y.Scale + (Delta.Y / (Viewport.Y / 2))
        
                    tab.Objects.ActualTab.Position = UDim2.fromScale(newX, newY)
                    local flagged = false
                    for i,v in Night.Tabs.Tabs do
                        if v.Objects and v.Objects.ActualTab then
                            local Tab = v.Objects.ActualTab
                            local TabPos = Tab.Position
                            if TabPos.X.Scale > 0.9 or 0 > TabPos.X.Scale or TabPos.Y.Scale >= 0.95 or 0 > TabPos.Y.Scale then
                                if not flagged then
                                    local t = TweenService:Create(Night.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 1})
                                    t:Play()
                                    task.spawn(function()
                                        t.Completed:Wait()
                                        task.wait(0.1)
                                        if not flagged and Night.Tabs.TabBackground.ZIndex ~= -100 then
                                            Night.Tabs.TabBackground.ZIndex = -100
                                        end
                                    end)
                                end
                            else
                                if v.Objects.ActualTab.Visible then
                                    TweenService:Create(Night.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
                                    Night.Tabs.TabBackground.ZIndex = 1
                                    flagged = true
                                end
                            end
                        end
                    end
    
                    if not Night.Config.Game.Other.TabPos then
                        Night.Config.Game.Other.TabPos = {}
                    end
                    Night.Config.Game.Other.TabPos[tab.Name] = {X = newX, Y = newY}
                end
            end)
        end

        local InputStarting, FrameStarting = nil, nil
        table.insert(Night.Connections, tab.Objects.DragButton.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
                tab.Data.Dragging, InputStarting, FrameStarting = true, input.Position, tab.Objects.ActualTab.Position
                Night.CurrntInputChangeCallback = function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then  
                        if tab.Data.Dragging then
                            tab.Functions.Drag(InputStarting, FrameStarting, input)
                        end
                    end
                end
                Night.InputEndFunc = function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
                        tab.Data.Dragging, InputStarting, FrameStarting = false, input.Position, tab.Objects.ActualTab.Position
                        Night.CurrntInputChangeCallback = function() end

                        Assets.Config.Save(Night.GameSave, Night.Config.Game)
                        Night.InputEndFunc = nil
                    end
                end
            end
        end))


        
        local TabPad = Instance.new("UIPadding", tab.Objects.ActualTab)
        TabPad.PaddingBottom = UDim.new(0, 10)
        TabPad.PaddingLeft = UDim.new(0, 10)
        TabPad.PaddingRight = UDim.new(0, 10)
        TabPad.PaddingTop = UDim.new(0, 10)

        local TabScale = Instance.new("UIScale", tab.Objects.ActualTab)
        TabScale.Scale = 0
        
        local TabConstraint = Instance.new("UISizeConstraint", tab.Objects.ActualTab)
        TabConstraint.MaxSize = Vector2.new(1000, 800)

        local TabHeader = Instance.new("TextLabel", tab.Objects.ActualTab)
        TabHeader.AnchorPoint = Vector2.new(0.5, 0)
        TabHeader.BackgroundTransparency = 1
        TabHeader.Position = UDim2.fromScale(0.5, 0.04)
        TabHeader.Size = UDim2.new(1, 0, 0, 40)
        TabHeader.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
        TabHeader.Text = tab.Name
        TabHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabHeader.TextSize = 22
        TabHeader.TextTransparency = 0.1
        TabHeader.ZIndex = 2

        local CloseButton = Instance.new("ImageButton", tab.Objects.ActualTab)
        CloseButton.AnchorPoint = Vector2.new(1, 0)
        CloseButton.BackgroundColor3 = Color3.fromRGB(Night.Config.UI.TabColor.value1 + 20, Night.Config.UI.TabColor.value2 + 20, Night.Config.UI.TabColor.value3 + 20)
        CloseButton.Position = UDim2.new(1, -5, 0, 5)
        CloseButton.Size = UDim2.fromOffset(30, 30)
        CloseButton.AutoButtonColor = false
        CloseButton.ZIndex = 2
        Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)
        tab.Objects.CloseButton = CloseButton

        local CloseButtonIcon = Instance.new("ImageLabel", CloseButton)
        CloseButtonIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        CloseButtonIcon.BackgroundTransparency = 1
        CloseButtonIcon.Position = UDim2.fromScale(0.5, 0.5)
        CloseButtonIcon.Size = UDim2.fromOffset(16, 16)
        CloseButtonIcon.Image = "rbxassetid://11293981586"
        CloseButtonIcon.ImageTransparency = 0.2
        CloseButtonIcon.ZIndex = 2
        CloseButtonIcon.ScaleType = Enum.ScaleType.Fit

        tab.Objects.ScrollFrame = Instance.new("ScrollingFrame", tab.Objects.ActualTab)
        tab.Objects.ScrollFrame.AnchorPoint = Vector2.new(0.5, 0)
        tab.Objects.ScrollFrame.BackgroundTransparency = 1
        tab.Objects.ScrollFrame.Position = UDim2.new(0.5, 0, 0.04, 50)
        tab.Objects.ScrollFrame.Size = UDim2.new(1, -10, 1, -70)
        tab.Objects.ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tab.Objects.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tab.Objects.ScrollFrame.ScrollBarThickness = 2
        tab.Objects.ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        tab.Objects.ScrollFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
        tab.Objects.ScrollFrame.BorderSizePixel = 0

        local ScrollFrameList = Instance.new("UIListLayout", tab.Objects.ScrollFrame)
        ScrollFrameList.SortOrder = Enum.SortOrder.LayoutOrder
        ScrollFrameList.Padding = UDim.new(0, 10)
        ScrollFrameList.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local ScrollFramePad = Instance.new("UIPadding", tab.Objects.ScrollFrame)
        ScrollFramePad.PaddingBottom = UDim.new(0, 10)
        ScrollFramePad.PaddingLeft = UDim.new(0, 15)
        ScrollFramePad.PaddingRight = UDim.new(0, 15)

        local SearchBar = Instance.new("Frame", tab.Objects.ScrollFrame)
        SearchBar.AnchorPoint = Vector2.new(0.5, 0)
        SearchBar.BackgroundTransparency = 0.7
        SearchBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        SearchBar.Size = UDim2.new(1, 0, 0, 40)
        SearchBar.LayoutOrder = -1000
        Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(1, 0)

        local SearchBarFocusGradient = Instance.new("UIGradient", SearchBar)
        SearchBarFocusGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(29, 59, 95)), ColorSequenceKeypoint.new(1, Color3.fromRGB(81, 32, 124))}
        SearchBarFocusGradient.Offset = Vector2.new(-0.5, 0)
        SearchBarFocusGradient.Enabled = false

        local SearchBarPadding = Instance.new("UIPadding", SearchBar)
        SearchBarPadding.PaddingLeft = UDim.new(0, 40)

        local SearchBarDepth = Instance.new("ImageLabel", SearchBar)
        SearchBarDepth.AnchorPoint = Vector2.new(0, 0.5)
        SearchBarDepth.BackgroundTransparency = 1
        SearchBarDepth.Position = UDim2.new(0, -40, 0.5, 0)
        SearchBarDepth.Size = UDim2.new(1, 40, 1, 0)
        SearchBarDepth.Image = "rbxassetid://16264857615"
        SearchBarDepth.ImageColor3 = Color3.fromRGB(255, 255, 255)
        SearchBarDepth.ScaleType = Enum.ScaleType.Slice
        SearchBarDepth.SliceCenter = Rect.new(206, 206, 206, 206)

        local MainSearchBarTextBox = Instance.new("TextBox", SearchBar)
        MainSearchBarTextBox.BackgroundTransparency = 1
        MainSearchBarTextBox.Position = UDim2.fromOffset(0, -1)
        MainSearchBarTextBox.Size = UDim2.new(1, -50, 1, 0)
        MainSearchBarTextBox.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
        MainSearchBarTextBox.PlaceholderColor3 = Color3.fromRGB(175, 175, 175)
        MainSearchBarTextBox.PlaceholderText = "Search..."
        MainSearchBarTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        MainSearchBarTextBox.TextSize = 16
        MainSearchBarTextBox.TextTransparency = 0.2
        MainSearchBarTextBox.TextXAlignment = Enum.TextXAlignment.Left
        MainSearchBarTextBox.Text = ""
        MainSearchBarTextBox.ClearTextOnFocus = false

        local SearchBarIcon = Instance.new("ImageLabel", SearchBar)
        SearchBarIcon.AnchorPoint = Vector2.new(0, 0.5)
        SearchBarIcon.BackgroundTransparency = 1
        SearchBarIcon.Position = UDim2.new(0, -25, 0.5, 0)
        SearchBarIcon.Size = UDim2.fromOffset(17, 17)
        SearchBarIcon.Image = "rbxassetid://11293977875"
        SearchBarIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        SearchBarIcon.ImageTransparency = 0.5
        SearchBarIcon.ScaleType = Enum.ScaleType.Fit

        local SearchBarClear = Instance.new("ImageButton", SearchBar)
        SearchBarClear.AnchorPoint = Vector2.new(1, 0.5)
        SearchBarClear.BackgroundTransparency = 1
        SearchBarClear.Position = UDim2.fromScale(1, 0.5)
        SearchBarClear.Size = UDim2.fromOffset(40, 40)
        SearchBarClear.AutoButtonColor = false

        local SearchBarClearIcon = Instance.new("ImageLabel", SearchBarClear)
        SearchBarClearIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        SearchBarClearIcon.BackgroundTransparency = 1
        SearchBarClearIcon.Position = UDim2.fromScale(0.5, 0.5)
        SearchBarClearIcon.Size = UDim2.fromOffset(14, 14)
        SearchBarClearIcon.Image = "rbxassetid://11293981586"
        SearchBarClearIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        SearchBarClearIcon.ImageTransparency = 0.5
        SearchBarClearIcon.ScaleType = Enum.ScaleType.Fit

        local SearchBarClearScale = Instance.new("UIScale", SearchBarClearIcon)
        SearchBarClearScale.Scale = 0


        local resotredback = {backbuttons = {}, keybinds = {}}
        tab.Functions.ToggleTab = function(visible, anim, reopen)
            task.spawn(function()
                tab.Opened = visible
                tab.Objects.ScrollFrame.Visible = visible
                if visible then
                    if not reopen then
                        if not Night.CurrentOpenTab then
                            Night.CurrentOpenTab = {tab}
                        else
                            table.insert(Night.CurrentOpenTab, tab)
                        end
                    end

                    Night.Tabs.TabBackground.Visible = true
                    if not tab.Data.SettingsOpen then
                        CloseButton.Visible = true
                    end
                    tab.Objects.TabDragCanvas.Visible = true
                    TabHeader.TextTransparency = 0.1
                    for i,v in resotredback.backbuttons do
                        v.Visible = true
                    end
                    for i,v in resotredback.keybinds do
                        v.Visible = true
                    end
                    table.clear(resotredback.backbuttons)
                    table.clear(resotredback.keybinds)
                    if anim and Night.Config.UI.Anim then
                        tab.Objects.ActualTab.ImageTransparency = 1
                        TabScale.Scale = 1.2

                        local flagged = false
                        for i,v in Night.Tabs.Tabs do
                            if v.Objects and v.Objects.ActualTab then
                                local Tab = v.Objects.ActualTab
                                local TabPos = Tab.Position
                                if TabPos.X.Scale > 0.9 or 0 > TabPos.X.Scale or TabPos.Y.Scale >= 0.95 or 0 > TabPos.Y.Scale then
                                    if not flagged then
                                        local t = TweenService:Create(Night.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 1})
                                        t:Play()
                                        task.spawn(function()
                                            t.Completed:Wait()
                                            task.wait(0.1)
                                            if not flagged and Night.Tabs.TabBackground.ZIndex ~= -100 then
                                                Night.Tabs.TabBackground.ZIndex = -100
                                            end
                                        end)
                                        Night.IsAllowedToHoverTabButton = false
                                    end
                                else
                                    if v.Objects.ActualTab.Visible and v ~= tab or v == tab then
                                        Night.Tabs.TabBackground.ZIndex = 1
                                        TweenService:Create(Night.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0.5}):Play()
                                        Night.IsAllowedToHoverTabButton = true
                                        flagged = true
                                    end
                                end
                            end
                        end
                        TweenService:Create(tab.Objects.ActualTab, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = Night.Config.UI.TabTransparency}):Play()
                        TweenService:Create(TabScale, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Scale = 1}):Play()
                    else
                        local flagged = false
                        for i,v in Night.Tabs.Tabs do
                            if v.Objects and v.Objects.ActualTab then
                                local Tab = v.Objects.ActualTab
                                local TabPos = Tab.Position
                                if TabPos.X.Scale > 0.9 or 0 > TabPos.X.Scale or TabPos.Y.Scale >= 0.95 or 0 > TabPos.Y.Scale then
                                    if not flagged then
                                        local t = TweenService:Create(Night.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 1})
                                        t:Play()
                                        task.spawn(function()
                                            t.Completed:Wait()
                                            task.wait(0.1)
                                            if not flagged and Night.Tabs.TabBackground.ZIndex ~= -100 then
                                                Night.Tabs.TabBackground.ZIndex = -100
                                            end
                                        end)
                                        Night.IsAllowedToHoverTabButton = false
                                    end
                                else
                                    if v.Objects.ActualTab.Visible and v ~= tab or v == tab then
                                        Night.Tabs.TabBackground.ZIndex = 1
                                        TweenService:Create(Night.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0.5}):Play()
                                        Night.IsAllowedToHoverTabButton = true
                                        flagged = true
                                    end
                                end
                            end
                        end
                        TabScale.Scale = 1
                        tab.Objects.ActualTab.ImageTransparency = Night.Config.UI.TabTransparency
                    end
                else
                    if not reopen then
                        table.remove(Night.CurrentOpenTab, table.find(Night.CurrentOpenTab, tab))
                    end
                    Night.IsAllowedToHoverTabButton = false
                    CloseButton.Visible = false
                    tab.Objects.TabDragCanvas.Visible = false
                    for i,v in tab.Modules do
                        if v.Objects and v.Objects.BackButton and v.Objects.BackButton.Visible then 
                            v.Objects.BackButton.Visible = false
                            table.insert(resotredback.backbuttons, v.Objects.BackButton)
                        end
                        if v.Objects and v.Objects.KeybindButton and v.Objects.KeybindButton.Visible then
                            v.Objects.KeybindButton.Visible = false
                            table.insert(resotredback.keybinds, v.Objects.KeybindButton)
                        end
                    end
                    TabHeader.TextTransparency = 1
                    if anim and Night.Config.UI.Anim  then
                        TweenService:Create(tab.Objects.ActualTab, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
                        TweenService:Create(TabScale, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Scale = 1.2}):Play()

                        local flagged = false
                        for i,v in Night.Tabs.Tabs do
                            if v.Objects and v.Objects.ActualTab then
                                local Tab = v.Objects.ActualTab
                                local TabPos = Tab.Position
                                if TabPos.X.Scale > 0.9 or 0 > TabPos.X.Scale or TabPos.Y.Scale >= 0.95 or 0 > TabPos.Y.Scale then
                                    if not flagged then
                                        local t = TweenService:Create(Night.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 1})
                                        t:Play()
                                        task.spawn(function()
                                            t.Completed:Wait()
                                            task.wait(0.1)
                                            if not flagged and Night.Tabs.TabBackground.ZIndex ~= -100 then
                                                Night.Tabs.TabBackground.ZIndex = -100
                                            end
                                        end)
                                        Night.IsAllowedToHoverTabButton = false
                                    end
                                else
                                    if v.Objects.ActualTab.Visible and v ~= tab then
                                        TweenService:Create(Night.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
                                        Night.Tabs.TabBackground.ZIndex = 1
                                        Night.IsAllowedToHoverTabButton = true
                                        flagged = true
                                    end
                                end
                            end
                        end

                        task.wait(0.15)
                    else
                        TabScale.Scale = 1.2
                        tab.Objects.ActualTab.ImageTransparency = 1
                        local flagged = false
                        for i,v in Night.Tabs.Tabs do
                            if v.Objects and v.Objects.ActualTab then
                                local Tab = v.Objects.ActualTab
                                local TabPos = Tab.Position
                                if TabPos.X.Scale > 0.9 or 0 > TabPos.X.Scale or TabPos.Y.Scale >= 0.95 or 0 > TabPos.Y.Scale then
                                    if not flagged then
                                        local t = TweenService:Create(Night.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 1})
                                        t:Play()
                                        task.spawn(function()
                                            t.Completed:Wait()
                                            task.wait(0.1)
                                            if not flagged and Night.Tabs.TabBackground.ZIndex ~= -100 then
                                                Night.Tabs.TabBackground.ZIndex = -100
                                            end
                                        end)
                                        Night.IsAllowedToHoverTabButton = false
                                    end
                                else
                                    if v.Objects.ActualTab.Visible and v ~= tab then
                                        TweenService:Create(Night.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
                                        Night.Tabs.TabBackground.ZIndex = 1
                                        Night.IsAllowedToHoverTabButton = true
                                        flagged = true
                                    end
                                end
                            end
                        end
                    end
                    local cnt = 0 
                    for i,v in Night.CurrentOpenTab do
                        cnt += 1
                    end
                    if 0 >= cnt then
                        Night.Tabs.TabBackground.Visible = false
                    end
                end
                tab.Objects.ActualTab.Visible = visible
            end)
        end

        tab.Functions.Search = function(result)
            for i,v in tab.Modules do
                if result == "" then
                    v.Objects.Module.Visible = true
                else
                    if v.Name:lower():find(result:lower()) then
                        v.Objects.Module.Visible = true
                    else
                        v.Objects.Module.Visible = false
                    end
                end
            end
        end

        local dashboardbuttonclickcon = tab.Objects.DashBoardButton.MouseButton1Click:Connect(function()
            TweenService:Create(tab.Objects.DashBoardButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(17,17,17)}):Play()
            tab.Functions.ToggleTab(not tab.Opened, true)
        end)
        table.insert(tab.Connections, dashboardbuttonclickcon)
        table.insert(Night.Connections, dashboardbuttonclickcon)


        local dashboardbuttonhovercon =  tab.Objects.DashBoardButton.MouseEnter:Connect(function()
            if not Night.IsAllowedToHoverTabButton then
                TweenService:Create(tab.Objects.DashBoardButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
            end
        end)
        table.insert(tab.Connections, dashboardbuttonhovercon)
        table.insert(Night.Connections, dashboardbuttonhovercon)

        local dashboardbuttonleavecon = tab.Objects.DashBoardButton.MouseLeave:Connect(function()
            TweenService:Create(tab.Objects.DashBoardButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
        end)
        table.insert(tab.Connections, dashboardbuttonleavecon)
        table.insert(Night.Connections, dashboardbuttonleavecon)

        local tabclosebuttoncon = CloseButton.MouseButton1Click:Connect(function()
            tab.Functions.ToggleTab(false, true)
        end)
        table.insert(tab.Connections, tabclosebuttoncon)
        table.insert(Night.Connections, tabclosebuttoncon)

        local searchclearcon =  SearchBarClear.MouseButton1Click:Connect(function()
            MainSearchBarTextBox.Text = ""
            tab.Functions.Search("")
            TweenService:Create(SearchBarClearScale, TweenInfo.new(0.1), {Scale = 0}):Play()
        end)
        table.insert(tab.Connections, searchclearcon)
        table.insert(Night.Connections, searchclearcon)

        local searchfocuslostcon =  MainSearchBarTextBox.FocusLost:Connect(function()
            tab.Functions.Search(MainSearchBarTextBox.Text)
            if MainSearchBarTextBox.Text ~= "" then
                TweenService:Create(SearchBarClearScale, TweenInfo.new(0.1), {Scale = 1}):Play()
            else
                TweenService:Create(SearchBarClearScale, TweenInfo.new(0.3), {Scale = 0}):Play()
            end
            TweenService:Create(SearchBar, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0.7}):Play()
            task.wait(0.3)
            SearchBarFocusGradient.Enabled = false
            if tab.Tweens.SearchBackGround then
                tab.Tweens.SearchBackGround:Cancel()
            end
        end)
        table.insert(tab.Connections, searchfocuslostcon)
        table.insert(Night.Connections, searchfocuslostcon)

        local searchfocuscon =  MainSearchBarTextBox.Focused:Connect(function()
            SearchBarFocusGradient.Enabled = true
            tab.Tweens.SearchBackGround = TweenService:Create(SearchBarFocusGradient, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, math.huge, true), {Offset = Vector2.new(.5, 0)})
            tab.Tweens.SearchBackGround:Play()

            TweenService:Create(SearchBar, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0}):Play()
        end)
        table.insert(tab.Connections, searchfocuscon)
        table.insert(Night.Connections, searchfocuscon)

        tab.Functions.NewModule = function(data)
            local ModuleData = {
                Name = data and data.Name or "New Module",
                Description = data and data.Description or "New Module",
                Icon = data and data.Icon or "",
                Default = data and data.Default or false,
                Data = {Enabled = false, Keybind = nil, SettingKeybind = false, ExcludeSettingsVisiblity = {}, SettingsOpen = false, ArrayIndex = nil},
                Button = data and data.Button,
                Flag = data and data.Flag or "New Module",
                Callback = data and data.Callback or function() end,
                Settings = {},
                Objects = {},
                Connections = {},
                Functions = {Toggle = nil, Settings = {}},
            }

            if tab.Name == "Premium" then
                ModuleData.Callback = function(self, callback)
                    if callback then
                        task.wait(0.3)
                        Assets.Notifications.Send({
                            Description = "Join https://discord.gg/qyKF3MydKz to purchase or get a trial",
                            Duration = 4
                        })

                        if setclipboard then
                            setclipboard("https://discord.gg/qyKF3MydKz")
                        else
                            if toclipboard then
                                toclipboard("https://discord.gg/qyKF3MydKz")
                            end
                        end
                        task.wait(0.1)
                        ModuleData.Functions.Toggle(false, false, false, true, true)
                    end
                end
            end

            ModuleData.Objects.Module = Instance.new("ImageButton", tab.Objects.ScrollFrame)
            ModuleData.Objects.Module.AutoButtonColor = false
            ModuleData.Objects.Module.BackgroundTransparency = 0.95
            ModuleData.Objects.Module.Size = UDim2.new(1, 0, 0, 65)
            ModuleData.Objects.Module.ZIndex = 2
            ModuleData.Objects.Module.ImageTransparency = 1
            ModuleData.Objects.Module.ClipsDescendants = true
            Instance.new("UICorner", ModuleData.Objects.Module).CornerRadius = UDim.new(0, 15)
            
            local ModulePadding = Instance.new("UIPadding", ModuleData.Objects.Module)
            ModulePadding.PaddingBottom = UDim.new(0, 10)
            ModulePadding.PaddingLeft = UDim.new(0, 20)
            ModulePadding.PaddingRight = UDim.new(0, 20)
            ModulePadding.PaddingTop = UDim.new(0, 10)
            

            local ModuleIcon = Instance.new("ImageLabel", ModuleData.Objects.Module)
            ModuleIcon.BackgroundTransparency = 1
            ModuleIcon.Position = UDim2.fromOffset(0, 10)
            ModuleIcon.Size = UDim2.fromOffset(25, 25)
            ModuleIcon.Image = ModuleData.Icon
            ModuleIcon.ImageColor3 = Color3.fromRGB(255,255,255)
            ModuleIcon.ScaleType = Enum.ScaleType.Fit

            local ModuleDetails = Instance.new("Frame", ModuleData.Objects.Module)
            ModuleDetails.BackgroundTransparency = 1
            ModuleDetails.Position = UDim2.fromOffset(40, 2)
            ModuleDetails.Size = UDim2.new(1, -40, 0, 40)

            local ModuleDetailsList = Instance.new("UIListLayout", ModuleDetails)
            ModuleDetailsList.SortOrder = Enum.SortOrder.LayoutOrder
            ModuleDetailsList.Padding = UDim.new(0, 2)
            ModuleDetailsList.VerticalAlignment = Enum.VerticalAlignment.Center

            local NameText = Instance.new("TextLabel", ModuleDetails)
            NameText.BackgroundTransparency = 1
            NameText.Size = UDim2.fromScale(1, 0.35)
            NameText.ZIndex = 2
            NameText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
            NameText.Text = ModuleData.Name
            NameText.TextColor3 = Color3.fromRGB(255,255,255)
            NameText.TextSize = 16
            NameText.TextTruncate = Enum.TextTruncate.AtEnd
            NameText.TextXAlignment = Enum.TextXAlignment.Left
            NameText.TextYAlignment = Enum.TextYAlignment.Bottom

            local KeybindInfoText = Instance.new("TextLabel", ModuleDetails)
            KeybindInfoText.AnchorPoint = Vector2.new(0.5, 1)
            KeybindInfoText.BackgroundTransparency = 1
            KeybindInfoText.Size = UDim2.new(0.9, 0, 0, 15)
            KeybindInfoText.ZIndex = 2
            KeybindInfoText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
            KeybindInfoText.Text = "No Keybind Set"
            KeybindInfoText.TextColor3 = Color3.fromRGB(255,255,255)
            KeybindInfoText.TextSize = 14
            KeybindInfoText.TextTransparency = 0.5
            KeybindInfoText.TextXAlignment = Enum.TextXAlignment.Left
            KeybindInfoText.TextWrapped = true

            local KeybindInfoPadding = Instance.new("UIPadding", KeybindInfoText)
            KeybindInfoPadding.PaddingLeft = UDim.new(0, 20)

            local KeybindInfoIcon = Instance.new("ImageLabel", KeybindInfoText)
            KeybindInfoIcon.AnchorPoint = Vector2.new(0, 0.5)
            KeybindInfoIcon.BackgroundTransparency = 1
            KeybindInfoIcon.Position = UDim2.new(0, -20, 0.5, 0)
            KeybindInfoIcon.Size = UDim2.fromOffset(15, 15)
            KeybindInfoIcon.Image = "rbxassetid://11422155687"
            KeybindInfoIcon.ImageColor3 = Color3.fromRGB(255,255,255)
            KeybindInfoIcon.ImageTransparency = 0.5
            KeybindInfoIcon.ScaleType = Enum.ScaleType.Fit

            local Requirements = Instance.new("Frame", ModuleData.Objects.Module)
            Requirements.AnchorPoint = Vector2.new(0.5, 0)
            Requirements.BackgroundTransparency = 1
            Requirements.BorderSizePixel = 0
            Requirements.Position = UDim2.new(0.5, 0, 0, 2)
            Requirements.Size = UDim2.new(1, 0, 0, 165)
            Requirements.Visible = false

            local RequirementsList = Instance.new("UIListLayout", Requirements)
            RequirementsList.SortOrder = Enum.SortOrder.LayoutOrder
            RequirementsList.Padding = UDim.new(0, 10)
            RequirementsList.HorizontalAlignment = Enum.HorizontalAlignment.Right


            local ToggleButton = Instance.new("ImageButton", Requirements)
            ToggleButton.AutoButtonColor = false
            ToggleButton.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
            ToggleButton.Position = UDim2.fromOffset(0, 55)
            ToggleButton.Size = UDim2.fromOffset(40, 40)
            ToggleButton.ZIndex = 2
            Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

            local ToggleButtonPadding = Instance.new("UIPadding", ToggleButton)
            ToggleButtonPadding.PaddingLeft = UDim.new(0, 10)

            local ToggleButtonEnabledIcon = Instance.new("ImageLabel", ToggleButton)
            ToggleButtonEnabledIcon.BackgroundTransparency = 1
            ToggleButtonEnabledIcon.Position = UDim2.fromScale(0, 0.25)
            ToggleButtonEnabledIcon.Size = UDim2.fromOffset(20, 20)
            ToggleButtonEnabledIcon.ZIndex = 2
            ToggleButtonEnabledIcon.Image = "rbxassetid://3926305904"
            ToggleButtonEnabledIcon.ImageColor3 = Color3.fromRGB(255,255,255)
            ToggleButtonEnabledIcon.ImageRectOffset = Vector2.new(284, 4)
            ToggleButtonEnabledIcon.ImageRectSize = Vector2.new(24, 24)

            local DescriptionText = Instance.new("TextLabel", Requirements)
            DescriptionText.BackgroundTransparency = 1
            DescriptionText.LayoutOrder = 100
            DescriptionText.Size = UDim2.new(1, 0, 0, 20)
            DescriptionText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
            DescriptionText.Text = ModuleData.Description
            DescriptionText.TextColor3 = Color3.fromRGB(255,255,255)
            DescriptionText.TextSize = 12
            DescriptionText.TextTransparency = 0.6
            DescriptionText.TextXAlignment = Enum.TextXAlignment.Left

            local SettingsButton = Instance.new("TextButton", Requirements)
            SettingsButton.AnchorPoint = Vector2.new(0.5, 0)
            SettingsButton.AutoButtonColor = false
            SettingsButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            SettingsButton.BackgroundTransparency = 0.7
            SettingsButton.LayoutOrder = 5
            SettingsButton.Size = UDim2.new(1, 0, 0, 50)
            SettingsButton.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
            SettingsButton.Text = ModuleData.Name .. " Settings"
            SettingsButton.TextColor3 = Color3.fromRGB(255,255,255)
            SettingsButton.TextSize = 16
            SettingsButton.TextTransparency = 0.2
            SettingsButton.TextXAlignment = Enum.TextXAlignment.Left
            SettingsButton.ZIndex = 2
            SettingsButton.Visible = false
            Instance.new("UICorner", SettingsButton).CornerRadius = UDim.new(0, 12)

            local SettingsButtonPadding = Instance.new("UIPadding", SettingsButton)
            SettingsButtonPadding.PaddingBottom = UDim.new(0, 1)
            SettingsButtonPadding.PaddingLeft = UDim.new(0, 20)
            SettingsButtonPadding.PaddingRight = UDim.new(0, 15)

            local SettingsButtonIcon = Instance.new("ImageLabel", SettingsButton)
            SettingsButtonIcon.AnchorPoint = Vector2.new(1, 0.5)
            SettingsButtonIcon.BackgroundTransparency = 1
            SettingsButtonIcon.Position = UDim2.fromScale(1, 0.5)
            SettingsButtonIcon.Size = UDim2.fromOffset(20, 20)
            SettingsButtonIcon.Image = "rbxassetid://11419703997"
            SettingsButtonIcon.ImageColor3 = Color3.fromRGB(255,255,255)
            SettingsButtonIcon.ImageTransparency = 0.5
            SettingsButtonIcon.ScaleType = Enum.ScaleType.Fit

            local Backbutton = Instance.new("ImageButton", tab.Objects.ActualTab)
            Backbutton.BackgroundColor3 = Color3.fromRGB(Night.Config.UI.TabColor.value1 + 20, Night.Config.UI.TabColor.value2 + 20, Night.Config.UI.TabColor.value3 + 20)
            Backbutton.Position = UDim2.new(1.8, 0, 0, 5)
            Backbutton.Size = UDim2.fromOffset(30, 30)
            Backbutton.AutoButtonColor = false
            Backbutton.ZIndex = 2
            Backbutton.Visible = false
            Instance.new("UICorner", Backbutton).CornerRadius = UDim.new(1, 0)
            ModuleData.Objects.BackButton = Backbutton

            local BackButtonIcon = Instance.new("ImageLabel", Backbutton)
            BackButtonIcon.AnchorPoint = Vector2.new(0.5, 0.5)
            BackButtonIcon.BackgroundTransparency = 1
            BackButtonIcon.Position = UDim2.fromScale(0.5, 0.5)
            BackButtonIcon.Size = UDim2.fromOffset(16, 16)
            BackButtonIcon.Image = "rbxassetid://11293981980"
            BackButtonIcon.ImageTransparency = 0.2
            BackButtonIcon.ZIndex = 2
            BackButtonIcon.ScaleType = Enum.ScaleType.Fit

            local ModuleSettingsList = Instance.new("UIListLayout", nil)
            ModuleSettingsList.SortOrder = Enum.SortOrder.LayoutOrder
            ModuleSettingsList.Padding = UDim.new(0, 15)
            ModuleSettingsList.HorizontalAlignment = Enum.HorizontalAlignment.Center

            local ModuleSettings = Instance.new("Folder", ModuleData.Objects.Module)

            local KeyBindButton = Instance.new("TextButton", tab.Objects.ActualTab)
            KeyBindButton.AnchorPoint = Vector2.new(0.5, 1)
            KeyBindButton.AutoButtonColor = false
            KeyBindButton.BackgroundColor3 = Color3.fromRGB(Night.Config.UI.KeybindColor.value1, Night.Config.UI.KeybindColor.value2, Night.Config.UI.KeybindColor.value3)
            KeyBindButton.BackgroundTransparency = Night.Config.UI.KeybindTransparency
            KeyBindButton.Position = UDim2.new(0.5,0,1,-20)
            KeyBindButton.Size = UDim2.new(1, -40, 0, 45)
            KeyBindButton.ZIndex = 2
            KeyBindButton.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
            KeyBindButton.Text = "CLICK TO BIND"
            KeyBindButton.TextColor3 = Color3.fromRGB(255,255,255)
            KeyBindButton.TextSize = 17
            KeyBindButton.Visible = false
            Instance.new("UICorner", KeyBindButton).CornerRadius = UDim.new(1, 0)
            ModuleData.Objects.KeybindButton = KeyBindButton

            local DropOpen = false
            local db = false
            local moduleclickcon = ModuleData.Objects.Module.MouseButton1Click:Connect(function()
                if db then return end
                db = true
                DropOpen = not DropOpen
                if DropOpen then
                    DescriptionText.TextTransparency = 0.6
                    SettingsButton.TextTransparency = 0.2
                    SettingsButton.BackgroundTransparency = 0.7
                    SettingsButtonIcon.ImageTransparency = 0.5

                    DescriptionText.Visible = true
                    SettingsButton.Visible = true
                    Requirements.Visible = true
                    Requirements.AnchorPoint = Vector2.new(0.5, 1)
                    Requirements.Position = UDim2.new(0.5, 0, 1, 2)
                    TweenService:Create(Requirements, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 2)}):Play()
                    TweenService:Create(ModuleData.Objects.Module, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 150)}):Play()
                else
                    TweenService:Create(ModuleData.Objects.Module, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 65)}):Play()
                    if not ModuleData.Data.Enabled then
                        Requirements.Visible = false
                        TweenService:Create(Requirements, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, 2)}):Play()
                    else
                        TweenService:Create(DescriptionText, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
                        TweenService:Create(SettingsButton, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
                        TweenService:Create(SettingsButtonIcon, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
                        task.wait(0.5)
                        DescriptionText.Visible = false
                        SettingsButton.Visible = false
                    end
                end
                db = false
            end)
            table.insert(Night.Connections, moduleclickcon)
            table.insert(ModuleData.Connections, moduleclickcon)

            ModuleData.onToggles = {}
            ModuleData.Functions.Toggle = function(enabled: boolean, override: boolean, notify: boolean, save: boolean, updateArray: boolean)
                if setthreadidentity then
                    setthreadidentity(8)
                end

                if notify == nil then notify = true end
                if enabled == nil or typeof(enabled) == "string" then
                    enabled = not ModuleData.Data.Enabled
                end
                if save == nil then save = true end
                if ModuleData.Button then
                    ModuleData.Callback(ModuleData, true); task.wait(0.1); ModuleData.Callback(ModuleData, false)
                end

                local Array
                if not Night.ArrayList.Loaded then
                    Array = Assets.ArrayList.Init()
                else
                    Array = Night.ArrayList
                end

                if enabled then
                    if not ModuleData.Data.Enabled or override then
                        ModuleData.Data.Enabled = enabled
                        task.spawn(function()
                            ModuleData.Callback(ModuleData, enabled)
                        end)

                        task.spawn(function()
                            for i,v in next, ModuleData.onToggles do
                                v(ModuleData, enabled)
                            end
                        end)

                        if updateArray then
                            ModuleData.Data.ArrayIndex = Array.Functions.PushModule({
                                Name = ModuleData.Name
                            })
                        end

                        if not DropOpen then
                            DescriptionText.Visible = false
                            SettingsButton.Visible = false
                            Requirements.Visible = true
                            Requirements.AnchorPoint = Vector2.new(0.5, 0)
                            Requirements.Position = UDim2.new(0.5, 0, 0, 2)
                        end
                        TweenService:Create(ToggleButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(32, 175, 77)}):Play()
                        TweenService:Create(ToggleButtonEnabledIcon, TweenInfo.new(0.1), {ImageTransparency = 1}):Play()
                        task.wait(0.05)
                        ToggleButtonEnabledIcon.ImageRectOffset = Vector2.new(644, 204)
                        ToggleButtonEnabledIcon.ImageRectSize = Vector2.new(36, 36)
                        TweenService:Create(ToggleButtonEnabledIcon, TweenInfo.new(0.1), {ImageTransparency = 0}):Play()
                        if notify and Night.Config.UI.Notifications then
                            Assets.Notifications.Send({
                                Description = ModuleData.Name.." enabled!",
                                Duration = 2.5
                            })
                        end
                    end
                else
                    if ModuleData.Data.Enabled or override then
                        ModuleData.Data.Enabled = enabled
                        task.spawn(function()
                            ModuleData.Callback(ModuleData, enabled)
                            for i,v in next, ModuleData.onToggles do
                                v(ModuleData, enabled)
                            end
                        end)

                        if updateArray and ModuleData.Data.ArrayIndex then
                            local Index = ModuleData.Data.ArrayIndex
                            if Index.Deconstruct then
                                Index.Deconstruct()
                            end
                            ModuleData.Data.ArrayIndex = nil
                        end

                        TweenService:Create(ToggleButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(43, 43, 43)}):Play()
                        TweenService:Create(ToggleButtonEnabledIcon, TweenInfo.new(0.1), {ImageTransparency = 1}):Play()
                        task.wait(0.05)
                        ToggleButtonEnabledIcon.ImageRectOffset = Vector2.new(284, 4)
                        ToggleButtonEnabledIcon.ImageRectSize = Vector2.new(24, 24)
                        TweenService:Create(ToggleButtonEnabledIcon, TweenInfo.new(0.1), {ImageTransparency = 0}):Play()
                        if not DropOpen then
                            Requirements.Visible = false
                            DescriptionText.Visible = true
                            SettingsButton.Visible = true
                            Requirements.AnchorPoint = Vector2.new(0.5, 1)
                            Requirements.Position = UDim2.new(0.5, 0, 1, 2)
                        end
                        if notify and Night.Config.UI.Notifications then
                            Assets.Notifications.Send({
                                Description = ModuleData.Name.." disabled!",
                                Duration = 2.5
                            })
                        end
                    end
                end
                if save then
                    Night.Config.Game.Modules[ModuleData.Flag] = enabled
                    Assets.Config.Save(Night.GameSave, Night.Config.Game)
                end
            end

            if Night.Mobile then
                KeyBindButton.Text = "TAP TO BIND"
            end

            ModuleData.Functions.BindKeybind = function(Bind: string, Save: boolean)
                if not ModuleData.Data.Keybind then
                    local suc = pcall(function()
                        if not Night.Mobile then
                            ModuleData.Data.Keybind = Enum.KeyCode[Bind]
                            ModuleData.Data.SettingKeybind = false
                            KeybindInfoText.Text = "Set Keybind is: "..Bind
                            KeyBindButton.Text = "Bound to: "..Bind
                        else
                            Night.Background.Functions.CreateMobileButton({
                                Name = ModuleData.Name,
                                Flag = ModuleData.Flag.."MobileButton",
                                Callbacks = {
                                    End = function(self, drag : boolean)
                                        if drag then return end
                                        ModuleData.Functions.Toggle(nil, false, true, true, true)
                                    end
                                }
                            })
                            KeyBindButton.Text = "TAP TO UNBIND"
                            KeybindInfoText.Text = "Set Keybind is a Button"
                            ModuleData.Data.Keybind = "button"
                        end
                    end)

                    if Save and suc then
                        Night.Config.Game.Keybinds[ModuleData.Flag] = Bind
                        Assets.Config.Save(Night.GameSave, Night.Config.Game)
                    end
                end
            end

            ModuleData.Functions.UnbindKeybind = function(Save: boolean)
                if Night.Mobile then
                    if Night.Background.MobileButtons and Night.Background.MobileButtons.Buttons[ModuleData.Flag.."MobileButton"] and Night.Background.MobileButtons.Buttons[ModuleData.Flag.."MobileButton"].Functions then
                        Night.Background.MobileButtons.Buttons[ModuleData.Flag.."MobileButton"].Functions.Destroy()
                    end
                    KeyBindButton.Text = "TAP TO BIND"
                else
                    ModuleData.Data.Keybind = nil 
                    KeyBindButton.Text = "CLICK TO BIND" 
                    ModuleData.Data.SettingKeybind = false
                end

                KeybindInfoText.Text = "No Keybind Set"
                Night.Config.Game.Keybinds[ModuleData.Flag] = nil
                ModuleData.Data.Keybind = nil

                if Save then
                    Assets.Config.Save(Night.GameSave, Night.Config.Game)
                end
            end

            local keybindbuttonpresscon = KeyBindButton.MouseButton1Click:Connect(function()
                if not Night.Mobile then
                    ModuleData.Data.SettingKeybind = true
                    KeyBindButton.Text = "Press Any Key"
                else
                    if ModuleData.Data.Keybind then
                        ModuleData.Functions.UnbindKeybind(true)
                    else
                        ModuleData.Functions.BindKeybind("Binded", true)
                    end
                end
            end)
            table.insert(Night.Connections, keybindbuttonpresscon)
            table.insert(ModuleData.Connections, keybindbuttonpresscon)

            if Night.Config.Game.Keybinds[ModuleData.Flag] then
                if Night.Config.Game.Keybinds[ModuleData.Flag] == "Binded" and Night.Mobile then
                    ModuleData.Functions.BindKeybind("Binded", false)
                else
                    ModuleData.Functions.BindKeybind(Night.Config.Game.Keybinds[ModuleData.Flag], false)
                end
            end

            local keybindinputbegancon = UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode then
                    if ModuleData.Data.SettingKeybind then
                        if ModuleData.Data.Keybind and ModuleData.Data.Keybind == input.KeyCode then
                            ModuleData.Functions.UnbindKeybind(true)
                            return
                        end
                        ModuleData.Functions.BindKeybind(input.KeyCode.Name, true)
                    else
                        if not UserInputService:GetFocusedTextBox() then
                            if ModuleData.Data.Keybind and ModuleData.Data.Keybind == input.KeyCode then
                                ModuleData.Functions.Toggle(not ModuleData.Data.Enabled, false, true, true, true)
                            end
                        end
                    end
                end
            end)
            table.insert(Night.Connections, keybindinputbegancon)
            table.insert(ModuleData.Connections, keybindinputbegancon)


            local togglebuttoncon = ToggleButton.MouseButton1Click:Connect(function()
                ModuleData.Functions.Toggle(not ModuleData.Data.Enabled, false, true, true, true)
            end)
            table.insert(Night.Connections, togglebuttoncon)
            table.insert(ModuleData.Connections, togglebuttoncon)

            local settingsbuttoncon = SettingsButton.MouseButton1Click:Connect(function()
                tab.Data.SettingsOpen = true
                ModuleData.Data.SettingsOpen = true
                tab.Objects.ActualTab.ClipsDescendants = true      
                tab.ClipNeeded = true          
                TweenService:Create(tab.Objects.ScrollFrame, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(-1.8, 0, 0.04, 50)}):Play()
                TweenService:Create(TabHeader, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(-1.8, 0.04)}):Play()
                TweenService:Create(CloseButton, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(-1.8, 0, 0, 5)}):Play()
                TweenService:Create(KeyBindButton, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(-1.8,0,1,-20)}):Play()
                task.wait(0.2)
                if not tab.Data.SettingsOpen then
                    return
                end
                
                for i,v in tab.Modules do
                    v.Objects.Module.Visible = false
                end
                CloseButton.Visible = false
                Backbutton.Visible = true
                ModuleSettings.Parent = tab.Objects.ScrollFrame
                tab.Objects.ScrollFrame.Size = UDim2.new(1, -10, 1, -160)
                ModuleData.Objects.Module.Size = UDim2.fromScale(1, 1)
                ModuleData.Objects.Module.ZIndex = -1000
                ModuleData.Objects.Module.BackgroundTransparency = 1
                ModuleSettingsList.Parent = ModuleSettings
                tab.Objects.ScrollFrame.Position = UDim2.new(1.8, 0, 0.04, 50)
                TabHeader.Position = UDim2.fromScale(1.8, 0.04)
                KeyBindButton.Position = UDim2.new(1.8,0,1,-20)
                TabHeader.Text = ModuleData.Name .. " Settings"

                SearchBar.Visible = false
                KeyBindButton.Visible = true
                for i,v in ModuleData.Objects.Module:GetChildren() do
                    if v:IsA("Frame") or v:IsA("ImageLabel") then
                        v.Visible = false
                    end
                end
                for i,v in tab.Modules do
                    if v ~= ModuleData then
                        v.Objects.Module.Visible = false
                    end
                end
                for i,v in ModuleData.Settings do
                    if not table.find(ModuleData.Data.ExcludeSettingsVisiblity, v) then
                        v.Objects.MainInstance.Visible = true
                    end
                end

                TweenService:Create(tab.Objects.ScrollFrame, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 0.04, 50)}):Play()
                TweenService:Create(TabHeader, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(0.5, 0.04)}):Play()
                TweenService:Create(Backbutton, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.fromOffset(5, 5)}):Play()
                TweenService:Create(KeyBindButton, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5,0,1,-20)}):Play()
                tab.ClipNeeded = false
                task.wait(0.8)
                if not tab.ClipNeeded then
                    tab.Objects.ActualTab.ClipsDescendants = false
                end
            end)
            table.insert(Night.Connections, settingsbuttoncon)
            table.insert(ModuleData.Connections, settingsbuttoncon)

            local currentbackbuttonfunc = function()
                tab.Data.SettingsOpen = false
                ModuleData.Data.SettingsOpen = false
                if ModuleData.Data.SettingKeybind then
                    ModuleData.Data.SettingKeybind = false
                    KeyBindButton.Text = "CLICK TO BIND"
                end
                tab.Objects.ActualTab.ClipsDescendants = true
                tab.ClipNeeded = true
                ModuleSettings.Parent = ModuleData.Objects.Module
                tab.Objects.ScrollFrame.Size = UDim2.new(1, -10, 1, -70)
                ModuleData.Objects.Module.Size = UDim2.new(1, 0, 0, 150)
                TweenService:Create(tab.Objects.ScrollFrame, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(1.8, 0, 0.04, 50)}):Play()
                TweenService:Create(TabHeader, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(1.8, 0.04)}):Play()
                TweenService:Create(Backbutton, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(1.8, 0, 0, 5)}):Play()
                TweenService:Create(KeyBindButton, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(1.8,0,1,-20)}):Play()
                task.wait(0.2)
                for i,v in tab.Modules do
                    v.Objects.Module.Visible = true
                end
                Backbutton.Visible = false
                CloseButton.Visible = true
                ModuleData.Objects.Module.ZIndex = 2
                tab.Objects.ScrollFrame.Position = UDim2.new(-1.8, 0, 0.04, 50)
                TabHeader.Position = UDim2.fromScale(-1.8, 0.04)
                ModuleSettingsList.Parent = nil
                ModuleData.Objects.Module.BackgroundTransparency = 0.95
                KeyBindButton.Position = UDim2.new(-1.8,0,1,-20)
                KeyBindButton.Visible = false

                TabHeader.Text = tab.Name
                SearchBar.Visible = true
                for i,v in ModuleData.Objects.Module:GetChildren() do
                    if v:IsA("Frame") or v:IsA("ImageLabel") then
                        v.Visible = true
                    end
                end
                for i,v in ModuleData.Settings do
                    v.Objects.MainInstance.Visible = false
                end
                for i,v in tab.Modules do
                    v.Objects.Module.Visible = true
                end


                TweenService:Create(tab.Objects.ScrollFrame, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 0.04, 50)}):Play()
                TweenService:Create(TabHeader, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(0.5, 0.04)}):Play()
                TweenService:Create(CloseButton, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(1, -5, 0, 5)}):Play()
                tab.ClipNeeded = false
                task.wait(0.8)
                if not tab.ClipNeeded then
                    tab.Objects.ActualTab.ClipsDescendants = false
                end
            end

            local settingsbackbuttoncon = Backbutton.MouseButton1Click:Connect(function() currentbackbuttonfunc() end)
            table.insert(Night.Connections, settingsbackbuttoncon)
            table.insert(ModuleData.Connections, settingsbackbuttoncon)

            ModuleData.Functions.ConstructSetting = function(data: {Size: number, Description: string, Name: string, ToolTip: string, OnToolTipEdit: any, Layout: boolean})
                local ConstructionData = {
                    Name = data and data.Name or "Setting",
                    Description = data and data.Description or "Setting",
                    ToolTip = data and data.ToolTip or "Tooltip",
                    YSize = data and data.Size or 100,
                    NeedsLayout = data and data.Layout,
                    Objects = {},
                    Functions = {},
                    OnToolTipEdit = data and data.OnToolTipEdit or function() end
                }

                ConstructionData.Objects.MainInstance = Instance.new("ImageButton", ModuleSettings)
                ConstructionData.Objects.MainInstance.AutoButtonColor = false
                ConstructionData.Objects.MainInstance.BackgroundColor3 = Color3.fromRGB(0,0,0)
                ConstructionData.Objects.MainInstance.BackgroundTransparency = 0.8
                ConstructionData.Objects.MainInstance.Size = UDim2.new(1, 0, 0, ConstructionData.YSize)
                ConstructionData.Objects.MainInstance.ImageTransparency = 1
                ConstructionData.Objects.MainInstance.Visible = false
                Instance.new("UICorner", ConstructionData.Objects.MainInstance).CornerRadius = UDim.new(0, 10)
                
                if ConstructionData.NeedsLayout then
                    local layout = Instance.new("UIListLayout", ConstructionData.Objects.MainInstance)
                    layout.Padding = UDim.new(0, 10)
                    layout.SortOrder = Enum.SortOrder.LayoutOrder
                end

                local SettingPadding = Instance.new("UIPadding", ConstructionData.Objects.MainInstance)
                SettingPadding.PaddingBottom = UDim.new(0, 10)
                SettingPadding.PaddingLeft = UDim.new(0, 15)
                SettingPadding.PaddingRight = UDim.new(0, 15)
                SettingPadding.PaddingTop = UDim.new(0, 10)

                local stroke = Instance.new("UIStroke", ConstructionData.Objects.MainInstance)
                stroke.Color = Color3.fromRGB(255, 255, 255)
                stroke.Transparency = 0.95

                local SettingDescLabel = Instance.new("TextLabel", ConstructionData.Objects.MainInstance)
                SettingDescLabel.AnchorPoint = Vector2.new(0, 1)
                SettingDescLabel.BackgroundTransparency = 1
                SettingDescLabel.Position = UDim2.fromScale(0, 1)
                SettingDescLabel.Size = UDim2.new(0.997, 0, 0, 15)
                SettingDescLabel.ZIndex = 2
                SettingDescLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                SettingDescLabel.Text = ConstructionData.Description
                SettingDescLabel.TextColor3 = Color3.fromRGB(255,255,255)
                SettingDescLabel.TextSize = 13
                SettingDescLabel.TextTransparency = 0.6
                SettingDescLabel.TextXAlignment = Enum.TextXAlignment.Left
                SettingDescLabel.LayoutOrder = 3

                local SettingDetails = Instance.new("Frame", ConstructionData.Objects.MainInstance)
                SettingDetails.BackgroundTransparency = 1
                SettingDetails.Size = UDim2.new(0.63, 0, 0, 35)
                SettingDetails.LayoutOrder = 1

                local SettingNameText = Instance.new("TextLabel", SettingDetails)
                SettingNameText.BackgroundTransparency = 1
                SettingNameText.Size = UDim2.new(0.997, 0, 0, 15)
                SettingNameText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
                SettingNameText.Text = ConstructionData.Name
                SettingNameText.TextColor3 = Color3.fromRGB(255, 255, 255)
                SettingNameText.TextSize = 15
                SettingNameText.TextTransparency = 0.1
                SettingNameText.TextTruncate = Enum.TextTruncate.AtEnd
                SettingNameText.TextXAlignment = Enum.TextXAlignment.Left
                SettingNameText.TextYAlignment = Enum.TextYAlignment.Bottom

                local ToolTip = Instance.new("TextLabel", SettingDetails)
                ToolTip.AnchorPoint = Vector2.new(0, 1)
                ToolTip.BackgroundTransparency = 1
                ToolTip.Position = UDim2.new(0, 20, 1, 0)
                ToolTip.Size = UDim2.new(0.944, 0, 0, 15)
                ToolTip.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                ToolTip.Text = ConstructionData.ToolTip
                ToolTip.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToolTip.TextSize = 13
                ToolTip.TextTransparency = 0.6
                ToolTip.TextXAlignment = Enum.TextXAlignment.Left

                local ToolTipIcon = Instance.new("ImageLabel", SettingDetails)
                ToolTipIcon.BackgroundTransparency = 1
                ToolTipIcon.Position = UDim2.fromScale(-0.004, 0.571)
                ToolTipIcon.Size = UDim2.fromOffset(15, 15)
                ToolTipIcon.Image = "rbxassetid://82132857700485"
                ToolTipIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                ToolTipIcon.ImageTransparency = 0.6
                ToolTipIcon.ScaleType = Enum.ScaleType.Stretch

                ConstructionData.Functions.EditToolTip = function(newdata: {ToolTip: string})
                    if newdata.ToolTip then
                        ConstructionData.ToolTip = newdata.ToolTip
                        ToolTip.Text = newdata.ToolTip

                        ConstructionData.OnToolTipEdit({ToolTip = newdata.ToolTip})
                    end
                end

                return ConstructionData
            end
            
            ModuleData.Functions.Settings.TextBox = function(data)
                local TextBoxData = {
                    Name = data and data.Name or "Textbox",
                    PlaceHolderText = data and data.PlaceHolderText or data and data.Name or "",
                    Description = data and data.Description or "Textbox",
                    ToolTip = data and data.ToolTip or "Click to Enter A Value",
                    Flag = data and data.Flag or data and data.Name or "New TextBox",
                    Default = data and data.Default or "",
                    Hide = data and data.Hide or false,
                    Callback = data and data.Callback or function() end,
                    Type = "TextBoxes",
                    Objects = {},
                    Functions = {}
                }

                if Night.Config.Game.TextBoxes[TextBoxData.Flag] then
                    TextBoxData.Default = Night.Config.Game.TextBoxes[TextBoxData.Flag]                
                end
                
                TextBoxData.Construction = ModuleData.Functions.ConstructSetting({
                    Name = TextBoxData.Name,
                    Description = TextBoxData.Description,
                    Size = 125,
                    ToolTip = TextBoxData.ToolTip,
                    Layout = true,
                    OnToolTipEdit = function(new: {ToolTip: string})
                        TextBoxData.ToolTip = new.ToolTip
                    end
                })

                TextBoxData.Objects.MainInstance = TextBoxData.Construction.Objects.MainInstance
                if Night.Mobile and TextBoxData.ToolTip == "Click to Enter A Value" then
                    TextBoxData.Construction.Functions.EditToolTip({ToolTip = "Tap to Enter A Value"})
                end

                TextBoxData.Functions.EditToolTip = TextBoxData.Construction.Functions.EditToolTip

                TextBoxData.Objects.MainInstance.AutomaticSize = Enum.AutomaticSize.Y

                local ActualTextBoxBox = Instance.new("Frame", TextBoxData.Objects.MainInstance)
                ActualTextBoxBox.AnchorPoint = Vector2.new(1,0.5)
                ActualTextBoxBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                ActualTextBoxBox.BackgroundTransparency = 0.6
                ActualTextBoxBox.Size = UDim2.new(1, 0, 0, 35)
                ActualTextBoxBox.LayoutOrder = 2
                ActualTextBoxBox.AutomaticSize = Enum.AutomaticSize.Y
                Instance.new("UICorner", ActualTextBoxBox).CornerRadius = UDim.new(0, 6)

                local BoxStroke = Instance.new("UIStroke", ActualTextBoxBox)
                BoxStroke.Color = Color3.fromRGB(255,255,255)
                BoxStroke.Transparency = 0.9
                
                local BoxPadding = Instance.new("UIPadding", ActualTextBoxBox)
                BoxPadding.PaddingBottom = UDim.new(0, 12)
                BoxPadding.PaddingLeft = UDim.new(0, 15)
                BoxPadding.PaddingTop = UDim.new(0, 12)

                local ActualTextBox = Instance.new("TextBox", ActualTextBoxBox)
                ActualTextBox.BackgroundTransparency = 1
                ActualTextBox.BorderSizePixel = 0
                ActualTextBox.Position = UDim2.fromScale(0, 0)
                ActualTextBox.Size = UDim2.fromScale(0.98, 0.26)
                ActualTextBox.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
                ActualTextBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
                ActualTextBox.Text = TextBoxData.Default
                ActualTextBox.TextColor3 = Color3.fromRGB(255,255,255)
                ActualTextBox.TextSize = 13
                ActualTextBox.TextTransparency = 0.2
                ActualTextBox.TextWrapped = true
                ActualTextBox.TextXAlignment = Enum.TextXAlignment.Left
                ActualTextBox.AutomaticSize = Enum.AutomaticSize.Y

                if TextBoxData.PlaceHolderText and typeof(TextBoxData.PlaceHolderText) == "string" then
                    ActualTextBox.PlaceholderText = TextBoxData.PlaceHolderText
                end

                TextBoxData.Functions.SetVisiblity = function(enabled)
                    if enabled then
                        if table.find(ModuleData.Data.ExcludeSettingsVisiblity, TextBoxData) then
                            table.remove(ModuleData.Data.ExcludeSettingsVisiblity, table.find(ModuleData.Data.ExcludeSettingsVisiblity, TextBoxData))
                        end
                        if ModuleData.Data.SettingsOpen then
                            TextBoxData.Objects.MainInstance.Visible = enabled
                        end
                    else
                        if not table.find(ModuleData.Data.ExcludeSettingsVisiblity, TextBoxData) then
                            table.insert(ModuleData.Data.ExcludeSettingsVisiblity, TextBoxData)
                        end
                        TextBoxData.Objects.MainInstance.Visible = false
                    end
                end

                if TextBoxData.Hide then
                    TextBoxData.Functions.SetVisiblity(false)
                end

                TextBoxData.Functions.SetValue = function(text: string, save: boolean)
                    if text and tostring(text) then
                        text = tostring(text)

                        ActualTextBox.Text = text
                        TextBoxData.Callback(TextBoxData, text)
                        Night.Config.Game.TextBoxes[TextBoxData.Flag] = text
                        if save then
                            Assets.Config.Save(Night.GameSave, Night.Config.Game)
                        end
                    end
                end

                local actualtextboxfocuslostcon = ActualTextBox.FocusLost:Connect(function() 
                    TextBoxData.Callback(TextBoxData, ActualTextBox.Text)
                    Night.Config.Game.TextBoxes[TextBoxData.Flag] = ActualTextBox.Text
                    Assets.Config.Save(Night.GameSave, Night.Config.Game)
                end)
                table.insert(Night.Connections, actualtextboxfocuslostcon)
                table.insert(ModuleData.Connections, actualtextboxfocuslostcon)

                ModuleData.Settings[TextBoxData.Flag] = TextBoxData
                return TextBoxData
            end

            ModuleData.Functions.Settings.MiniToggle = function(data)
                local MiniToggleData = {
                    Name = data and data.Name or "New MiniToggle",
                    Description = data and data.Description or "MiniToggle",
                    ToolTip = data and data.Tooltip or "Click to toggle",
                    Default = data and data.Default or false,
                    Enabled = false,
                    Flag = data and data.Flag or data and data.Name or "New MiniToggle",
                    Hide = data and data.Hide or false,
                    Callback = data and data.Callback or function() end,
                    Type = "MiniToggles",
                    Objects = {},
                    Functions = {}
                }

                MiniToggleData.Construction = ModuleData.Functions.ConstructSetting({
                    Name = MiniToggleData.Name,
                    Description = MiniToggleData.Description,
                    Size = 80,
                    Layout = false,
                    ToolTip = MiniToggleData.ToolTip,
                    OnToolTipEdit = function(new: {ToolTip: string})
                        MiniToggleData.ToolTip = new.ToolTip
                    end
                })

                MiniToggleData.Objects.MainInstance = MiniToggleData.Construction.Objects.MainInstance
                if Night.Mobile and MiniToggleData.ToolTip == "Click to toggle" then
                    MiniToggleData.Construction.Functions.EditToolTip({ToolTip = "Tap to toggle"})
                end
                
                MiniToggleData.Functions.EditToolTip = MiniToggleData.Construction.Functions.EditToolTip

                local ToggleBox = Instance.new("Frame", MiniToggleData.Objects.MainInstance)
                ToggleBox.AnchorPoint = Vector2.new(1, 0.5)
                ToggleBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                ToggleBox.BackgroundTransparency = 0.4
                ToggleBox.Position = UDim2.fromScale(1, 0.5)
                ToggleBox.Size = UDim2.fromOffset(36, 21)
                Instance.new("UICorner", ToggleBox).CornerRadius = UDim.new(0, 15)
                
                local ToggleCircle = Instance.new("Frame", ToggleBox)
                ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
                ToggleCircle.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
                ToggleCircle.Position = UDim2.fromScale(0.05, 0.5)
                ToggleCircle.Size = UDim2.fromOffset(17, 17)
                Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(0, 15)

                MiniToggleData.Functions.Toggle = function(enabled, save, override)
                    if enabled and not MiniToggleData.Enabled or override or not enabled and MiniToggleData.Enabled then
                        MiniToggleData.Callback(MiniToggleData, enabled)
                    end
                    if enabled then
                        TweenService:Create(ToggleBox, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(195, 195, 195)}):Play()
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.fromScale(0.95, 0.5)}):Play()
                    else
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0.05, 0.5)}):Play()
                        TweenService:Create(ToggleBox, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.4, BackgroundColor3 = Color3.fromRGB(65, 65, 65)}):Play()

                    end
                    MiniToggleData.Enabled = enabled

                    if save then
                        Night.Config.Game.MiniToggles[MiniToggleData.Flag] = enabled
                        Assets.Config.Save(Night.GameSave, Night.Config.Game)
                    end
                end
                MiniToggleData.Functions.SetValue = MiniToggleData.Functions.Toggle

                MiniToggleData.Functions.SetVisiblity = function(enabled)
                    if enabled then
                        if table.find(ModuleData.Data.ExcludeSettingsVisiblity, MiniToggleData) then
                            table.remove(ModuleData.Data.ExcludeSettingsVisiblity, table.find(ModuleData.Data.ExcludeSettingsVisiblity, MiniToggleData))
                        end
                        if ModuleData.Data.SettingsOpen then
                            MiniToggleData.Objects.MainInstance.Visible = enabled
                        end
                    else
                        if not table.find(ModuleData.Data.ExcludeSettingsVisiblity, MiniToggleData) then
                            table.insert(ModuleData.Data.ExcludeSettingsVisiblity, MiniToggleData)
                        end
                        MiniToggleData.Objects.MainInstance.Visible = false
                    end
                end

                
                if MiniToggleData.Hide then
                    MiniToggleData.Functions.SetVisiblity(false)
                end

                local minitoggleclickcon = MiniToggleData.Objects.MainInstance.MouseButton1Click:Connect(function()
                    MiniToggleData.Functions.Toggle(not MiniToggleData.Enabled, true)
                end)
                table.insert(Night.Connections, minitoggleclickcon)
                table.insert(ModuleData.Connections, minitoggleclickcon)

                ModuleData.Settings[MiniToggleData.Flag] = MiniToggleData
                return MiniToggleData
            end

            ModuleData.Functions.Settings.Slider = function(data)
                local SliderData = {
                    Name = data and data.Name or "New Slider",
                    Description = data and data.Description or "Slider",
                    ToolTip = data and data.Tooltip or "Slide the circle to edit value",
                    Min = data and tonumber(data.Min) or 0,
                    Max = data and tonumber(data.Max) or 100,
                    Default = data and data.Default or {Value1 = 50, Value2 = 100},
                    Decimals = data and tonumber(data.Decimals) or 0,
                    Multi = data and data.DoubleValue or false,
                    Flag = data and data.Flag or data and data.Name or "New Slider",
                    Hide = data and data.Hide or false,
                    Callback = data and data.Callback or function() end,
                    Type = "Sliders",
                    Data = {Dragging = false},
                    Tweens = {},
                    Objects = {},
                    Functions = {}
                }


                if Night.Config.Game.Sliders[SliderData.Flag] then
                    if typeof(Night.Config.Game.Sliders[SliderData.Flag]) == "table" then
                        SliderData.Default = Night.Config.Game.Sliders[SliderData.Flag]
                    elseif typeof(Night.Config.Game.Sliders[SliderData.Flag]) == "number" then
                        SliderData.Default = {Value2 = Night.Config.Game.Sliders[SliderData.Flag]}
                    end
                else
                    if typeof(SliderData.Default) == "number" then
                        SliderData.Default = {Value2 = SliderData.Default}
                    end
                end

                if not SliderData.Default.Value1 then
                    SliderData.Default.Value1 = SliderData.Min
                end
                if not SliderData.Default.Value2 then
                    SliderData.Default.Value2 = SliderData.Max
                end

                SliderData.Construction = ModuleData.Functions.ConstructSetting({
                    Name = SliderData.Name,
                    Description = SliderData.Description,
                    Size = 100,
                    Layout = false,
                    ToolTip = SliderData.ToolTip,
                    OnToolTipEdit = function(new: {ToolTip: string})
                        SliderData.ToolTip = new.ToolTip
                    end
                })

                SliderData.Objects.MainInstance = SliderData.Construction.Objects.MainInstance
                if SliderData.Multi then
                    SliderData.Construction.Functions.EditToolTip({ToolTip = "Slide a circle to edit the value"})
                end
                
                SliderData.Functions.EditToolTip = SliderData.Construction.Functions.EditToolTip

                local Numbers = Instance.new("Frame", SliderData.Objects.MainInstance)
                Numbers.BackgroundTransparency = 1
                Numbers.Position = UDim2.fromScale(0.59, 0.237)
                Numbers.Size = UDim2.fromScale(0.409, 0.15)

                local NumbersLayout = Instance.new("UIListLayout", Numbers)
                NumbersLayout.Padding = UDim.new(0, 20)
                NumbersLayout.FillDirection = Enum.FillDirection.Horizontal
                NumbersLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                NumbersLayout.SortOrder = Enum.SortOrder.LayoutOrder

                local SliderValue1
                local SliderValue2 = Instance.new("TextBox", Numbers)
                SliderValue2.AnchorPoint = Vector2.new(0, 0.5)
                SliderValue2.BackgroundTransparency = 1
                SliderValue2.Size = UDim2.new(0.043, 0, 0, 15)
                SliderValue2.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                SliderValue2.Text = tonumber(SliderData.Default.Value2)
                SliderValue2.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderValue2.TextSize = 13
                SliderValue2.TextTransparency = 0.2
                SliderValue2.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue2.AutomaticSize = Enum.AutomaticSize.X
                SliderValue2.LayoutOrder = 2

                local SliderBox = Instance.new("Frame", SliderData.Objects.MainInstance)
                SliderBox.AnchorPoint = Vector2.new(0, 0.5)
                SliderBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                SliderBox.BackgroundTransparency = 0.6
                SliderBox.Position = UDim2.fromScale(0, 0.63)
                SliderBox.Size = UDim2.fromScale(1, 0.05)
                Instance.new("UICorner", SliderBox).CornerRadius = UDim.new(0, 15)

                local Fill = Instance.new("Frame", SliderBox)
                Fill.AnchorPoint = Vector2.new(0, 0.5)
                Fill.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
                Fill.Position = UDim2.fromScale(0, 0.5)
                Fill.Size = UDim2.fromScale(math.clamp((tonumber(SliderValue2.Text)-SliderData.Min)/(SliderData.Max-SliderData.Min), 0, 1), 1)
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 15)

                local Circle2 = Instance.new("ImageButton", Fill)
                Circle2.AutoButtonColor = false
                Circle2.AnchorPoint = Vector2.new(0.5,0.5)
                Circle2.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
                Circle2.Position = UDim2.fromScale(1, 0.5)
                Circle2.Size = UDim2.fromOffset(10, 10)
                Circle2.ImageTransparency = 1
                Instance.new("UICorner", Circle2).CornerRadius = UDim.new(0, 15)

                SliderData.Functions.SetValue = function(value: number, save: boolean, target: number)

                    if value then
                        local info = {Value1 = SliderData.Default.Value1, Value2 = value}
                        if target == 2 then
                            if Night.Config.Game.Sliders[SliderData.Flag] and typeof(Night.Config.Game.Sliders[SliderData.Flag]) == "table" and Night.Config.Game.Sliders[SliderData.Flag].Value1 then
                                info = {Value1 = Night.Config.Game.Sliders[SliderData.Flag].Value1, Value2 = value}
                            end

                        elseif target == 1 then
                            info = {Value1 = value, Value2 = SliderData.Default.Value2}
                            if Night.Config.Game.Sliders[SliderData.Flag] and typeof(Night.Config.Game.Sliders[SliderData.Flag]) == "table" and Night.Config.Game.Sliders[SliderData.Flag].Value2 then
                                info = {Value1 = value, Value2 = Night.Config.Game.Sliders[SliderData.Flag].Value2}
                            end
                        else
                            if typeof(value) == "table" then
                                info = value
                            end
                        end

                        if target == 1 and SliderData.Multi then
                            if tonumber(SliderValue2.Text) < value then return end
                            local val = math.clamp((tonumber(value)-SliderData.Min)/(SliderData.Max-SliderData.Min), 0, 1)
                            local val2 = math.clamp((tonumber(SliderValue2.Text)-SliderData.Min)/(SliderData.Max-SliderData.Min) - val, 0, 1)
                            TweenService:Create(Fill, TweenInfo.new(0.45), {Size = UDim2.fromScale(val2 , 1), Position = UDim2.fromScale(val, 0.5)}):Play()
                            SliderValue1.Text = tostring(value)
                        elseif target == 1 and not SliderData.Multi or target == 2 then
                            if SliderData.Multi and value > tonumber(SliderValue1.Text) or not SliderData.Multi then
                                TweenService:Create(Fill, TweenInfo.new(0.45), {Size = UDim2.fromScale(math.clamp((tonumber(value)-SliderData.Min)/(SliderData.Max-SliderData.Min) - Fill.Position.X.Scale, 0, 1), 1)}):Play()
                                SliderValue2.Text = tostring(value)
                            else
                                return
                            end
                        elseif not target then
                            if SliderData.Multi then
                                if SliderData.Multi and info.Value2 > tonumber(SliderValue1.Text) or not SliderData.Multi then
                                    TweenService:Create(Fill, TweenInfo.new(0.45), {Size = UDim2.fromScale(math.clamp((tonumber(info.Value2)-SliderData.Min)/(SliderData.Max-SliderData.Min) - Fill.Position.X.Scale, 0, 1), 1)}):Play()
                                    SliderValue2.Text = tostring(info.Value2)
                                end

                                if tonumber(SliderValue2.Text) >= info.Value1 then
                                    local val = math.clamp((tonumber(info.Value1)-SliderData.Min)/(SliderData.Max-SliderData.Min), 0, 1)
                                    local val2 = math.clamp((tonumber(SliderValue2.Text)-SliderData.Min)/(SliderData.Max-SliderData.Min) - val, 0, 1)
                                    TweenService:Create(Fill, TweenInfo.new(0.45), {Size = UDim2.fromScale(val2 , 1), Position = UDim2.fromScale(val, 0.5)}):Play()
                                    SliderValue1.Text = tostring(info.Value1)
                                end
                            else
                                TweenService:Create(Fill, TweenInfo.new(0.45), {Size = UDim2.fromScale(math.clamp((tonumber(info.Value2)-SliderData.Min)/(SliderData.Max-SliderData.Min) - Fill.Position.X.Scale, 0, 1), 1)}):Play()
                                SliderValue2.Text = tostring(info.Value2)
                            end
                        end

                        if SliderData.Multi then
                            SliderData.Callback(SliderData, info)
                        else
                            SliderData.Callback(SliderData, tonumber(info.Value2))
                        end

                        if save then
                            Night.Config.Game.Sliders[SliderData.Flag] = info
                            Assets.Config.Save(Night.GameSave, Night.Config.Game)
                        end
                    end
                end

                local Circle1
                if SliderData.Multi then

                    SliderValue1 = Instance.new("TextBox", Numbers)
                    SliderValue1.AnchorPoint = Vector2.new(0, 0.5)
                    SliderValue1.BackgroundTransparency = 1
                    SliderValue1.Size = UDim2.new(0.044, 0, 0, 15)
                    SliderValue1.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                    SliderValue1.Text = tonumber(SliderData.Default.Value1)
                    SliderValue1.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SliderValue1.TextSize = 13
                    SliderValue1.TextTransparency = 0.2
                    SliderValue1.TextXAlignment = Enum.TextXAlignment.Left
                    SliderValue1.AutomaticSize = Enum.AutomaticSize.X
                    SliderValue1.LayoutOrder = 0
                    local ValueSplitIcon = Instance.new("ImageLabel", Numbers)
                    ValueSplitIcon.BackgroundTransparency = 1
                    ValueSplitIcon.Size = UDim2.fromOffset(15, 15)
                    ValueSplitIcon.Image = "rbxassetid://136254264936851"
                    ValueSplitIcon.ImageColor3 = Color3.fromRGB(255,255,255)
                    ValueSplitIcon.ImageTransparency = 0.6
                    ValueSplitIcon.ScaleType = Enum.ScaleType.Stretch
                    ValueSplitIcon.LayoutOrder = 1

                    Circle1 = Instance.new("ImageButton", Fill)
                    Circle1.AutoButtonColor = false
                    Circle1.AnchorPoint = Vector2.new(0.5,0.5)
                    Circle1.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
                    Circle1.Position = UDim2.fromScale(0, 0.5)
                    Circle1.Size = UDim2.fromOffset(10, 10)
                    Circle1.ImageTransparency = 1
                    Instance.new("UICorner", Circle1).CornerRadius = UDim.new(0, 15)

                    local sliderdragbuttonclickcon2 =  Circle1.MouseButton1Down:Connect(function()
                        Night.CurrntInputChangeCallback = function(input)
                            if SliderData.Data.Dragging then
                                local mouse = UserInputService:GetMouseLocation()
                                local relativePos = mouse-SliderBox.AbsolutePosition
                                local percent = math.clamp(relativePos.X/(SliderBox.AbsoluteSize.X - 20), 0, 1)
                                local value = math.floor(((((SliderData.Max - SliderData.Min) * percent) + SliderData.Min) * (10 ^ SliderData.Decimals)) + 0.5) / (10 ^ SliderData.Decimals) 

                                SliderData.Functions.SetValue(value, true, 1)

                            end
                        end
                        SliderData.Data.Dragging = true

                        Night.InputEndFunc = function(input) 
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                Night.CurrntInputChangeCallback = function() end
                                SliderData.Data.Dragging = false
                            end
                        end
                    end)
                    table.insert(Night.Connections, sliderdragbuttonclickcon2)
                    table.insert(ModuleData.Connections, sliderdragbuttonclickcon2)                                
                end

                local sliderdragbuttonclickcon
                if Night.Mobile and not SliderData.Multi then
                    sliderdragbuttonclickcon = SliderData.Objects.MainInstance.MouseButton1Down:Connect(function()
                        Night.CurrntInputChangeCallback = function(input)
                            if SliderData.Data.Dragging then
                                local mouse = UserInputService:GetMouseLocation()
                                local relativePos = mouse-SliderBox.AbsolutePosition
                                local percent = math.clamp(relativePos.X/(SliderBox.AbsoluteSize.X - 20), 0, 1)
                                local value = math.floor(((((SliderData.Max - SliderData.Min) * percent) + SliderData.Min) * (10 ^ SliderData.Decimals)) + 0.5) / (10 ^ SliderData.Decimals) 

                                SliderData.Functions.SetValue(value, true, 2)

                            end
                        end
                        SliderData.Data.Dragging = true

                        Night.InputEndFunc = function(input) 
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                Night.CurrntInputChangeCallback = function() end
                                SliderData.Data.Dragging = false
                            end
                        end
                    end)
                else
                    sliderdragbuttonclickcon = Circle2.MouseButton1Down:Connect(function()
                        Night.CurrntInputChangeCallback = function(input)
                            if SliderData.Data.Dragging then
                                local mouse = UserInputService:GetMouseLocation()
                                local relativePos = mouse-SliderBox.AbsolutePosition
                                local percent = math.clamp(relativePos.X/(SliderBox.AbsoluteSize.X - 20), 0, 1)
                                local value = math.floor(((((SliderData.Max - SliderData.Min) * percent) + SliderData.Min) * (10 ^ SliderData.Decimals)) + 0.5) / (10 ^ SliderData.Decimals) 

                                SliderData.Functions.SetValue(value, true, 2)

                            end
                        end
                        SliderData.Data.Dragging = true

                        Night.InputEndFunc = function(input) 
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                Night.CurrntInputChangeCallback = function() end
                                SliderData.Data.Dragging = false
                            end
                        end
                    end)
                end
                table.insert(Night.Connections, sliderdragbuttonclickcon)
                table.insert(ModuleData.Connections, sliderdragbuttonclickcon)
            

                local slidervaluetextchangecon = SliderValue2.FocusLost:Connect(function()
                    if SliderValue2.Text and tonumber(SliderValue2.Text) then
                        SliderData.Functions.SetValue(tonumber(SliderValue2.Text), true, 2)
                    end
                end)
                table.insert(Night.Connections, slidervaluetextchangecon)
                table.insert(ModuleData.Connections, slidervaluetextchangecon)

                if SliderData.Multi then
                    local slidervaluetextchangecon2 = SliderValue1.FocusLost:Connect(function()
                        if SliderValue1.Text and tonumber(SliderValue1.Text) then
                            SliderData.Functions.SetValue(tonumber(SliderValue1.Text), true, 1)
                        end
                    end)
                    table.insert(Night.Connections, slidervaluetextchangecon2)
                    table.insert(ModuleData.Connections, slidervaluetextchangecon2)
                end

                SliderData.Functions.SetVisiblity = function(enabled)
                    if enabled then
                        if table.find(ModuleData.Data.ExcludeSettingsVisiblity, SliderData) then
                            table.remove(ModuleData.Data.ExcludeSettingsVisiblity, table.find(ModuleData.Data.ExcludeSettingsVisiblity, SliderData))
                        end
                        if ModuleData.Data.SettingsOpen then
                            SliderData.Objects.MainInstance.Visible = true
                        end
                    else
                        if not table.find(ModuleData.Data.ExcludeSettingsVisiblity, SliderData) then
                            table.insert(ModuleData.Data.ExcludeSettingsVisiblity, SliderData)
                        end
                        SliderData.Objects.MainInstance.Visible = false
                    end
                end

                if SliderData.Hide then
                    SliderData.Functions.SetVisiblity(false)
                end

                ModuleData.Settings[SliderData.Flag] = SliderData
                return SliderData
            end

            ModuleData.Functions.Settings.Dropdown = function(data)
                local DropdownData = {
                    Name = data and data.Name or "Dropdown",
                    Description = data and data.Description or "Dropdown",
                    ToolTip = data and data.ToolTip or "Select a option",
                    Default = data and data.Default or "",
                    SelectLimit = data and data.SelectLimit or 1,
                    Options = data and data.Options or {},
                    Flag = data and data.Flag or "Dropdown",
                    Hide = data and data.Hide or false,
                    Callback = data and data.Callback or function() end,
                    Type = "Dropdowns",
                    Objects = {},
                    Connections = {},
                    Functions = {},
                    Buttons = {Selected = {}, Buttons = {}},
                    Data = {ExtendSize = 0, Opened = false},
                }

                if not Night.Config.Game.Dropdowns then
                    Night.Config.Game.Dropdowns = {}
                else
                    if Night.Config.Game.Dropdowns[DropdownData.Flag] then
                        DropdownData.Default = Night.Config.Game.Dropdowns[DropdownData.Flag]
                    end
                end

                DropdownData.Construction = ModuleData.Functions.ConstructSetting({
                    Name = DropdownData.Name,
                    Description = DropdownData.Description,
                    Size = 125,
                    Layout = true,
                    ToolTip = DropdownData.ToolTip,
                    OnToolTipEdit = function(new: {ToolTip: string})
                        DropdownData.ToolTip = new.ToolTip
                    end
                })

                DropdownData.Objects.MainInstance = DropdownData.Construction.Objects.MainInstance
                DropdownData.Functions.EditToolTip = DropdownData.Construction.Functions.EditToolTip

                local DropBox = Instance.new("ImageButton", DropdownData.Objects.MainInstance)
                DropBox.AutoButtonColor = false
                DropBox.AnchorPoint = Vector2.new(1, 0.5)
                DropBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                DropBox.BackgroundTransparency = 0.6
                DropBox.LayoutOrder = 2
                DropBox.Size = UDim2.new(1, 0, 0, 35)
                DropBox.ImageTransparency = 1
                DropBox.ClipsDescendants = true
                Instance.new("UICorner", DropBox).CornerRadius = UDim.new(0, 6)
                -- DropBox.AutomaticSize = Enum.AutomaticSize.Y
                
                local BoxStroke = Instance.new("UIStroke", DropBox)
                BoxStroke.Color = Color3.fromRGB(255, 255, 255)
                BoxStroke.Transparency = 0.9

                local Details = Instance.new("Frame", DropBox)
                Details.AnchorPoint = Vector2.new(0.5, 0)
                Details.BackgroundTransparency = 1
                Details.Position = UDim2.fromScale(0.5, 0)
                Details.Size = UDim2.new(1, 0, 0, 35)

                local SelectedText = Instance.new("TextLabel", Details)
                SelectedText.AnchorPoint = Vector2.new(0, 0.5)
                SelectedText.BackgroundTransparency = 1
                SelectedText.Position = UDim2.fromScale(0.02, 0.5)
                SelectedText.Size = UDim2.new(0.892, 0, 0, 140)
                SelectedText.ZIndex = 2
                SelectedText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                SelectedText.TextSize = 13
                SelectedText.TextColor3 = Color3.fromRGB(255, 255, 255)
                SelectedText.TextTransparency = 0.2
                SelectedText.TextXAlignment = 0.2
                if typeof(DropdownData.Default) == "table" then
                    SelectedText.Text = table.concat(DropdownData.Default, ", ")
                else
                    SelectedText.Text = tostring(DropdownData.Default)
                end

                local DropIcon = Instance.new("ImageLabel", Details)
                DropIcon.AnchorPoint = Vector2.new(1, 0.5)
                DropIcon.BackgroundTransparency = 1
                DropIcon.Position = UDim2.fromScale(0.97, 0.5)      
                DropIcon.Size = UDim2.fromOffset(10, 10)    
                DropIcon.ZIndex = 2
                DropIcon.Image = "rbxassetid://133663094711296"
                DropIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                DropIcon.ImageTransparency = 0.2
                DropIcon.ScaleType = Enum.ScaleType.Fit

                local OptionsList = Instance.new("ScrollingFrame", Details)
                OptionsList.AnchorPoint = Vector2.new(0.5, 0)
                OptionsList.BackgroundTransparency = 1
                OptionsList.Position = UDim2.fromScale(0.5, 1)
                OptionsList.Size = UDim2.fromScale(1, 0)
                OptionsList.ScrollBarThickness = 0
                OptionsList.ScrollBarImageTransparency = 1
                OptionsList.CanvasSize = UDim2.fromScale(0, 0)
                OptionsList.AutomaticCanvasSize = Enum.AutomaticSize.Y

                local OptionsLayout = Instance.new("UIListLayout", OptionsList)
                OptionsLayout.Padding = UDim.new(0, 2)
                OptionsLayout.VerticalAlignment = Enum.VerticalAlignment.Top

                local OptionsPadding = Instance.new("UIPadding", OptionsList)
                OptionsPadding.PaddingLeft = UDim.new(0, 13)
                OptionsPadding.PaddingTop = UDim.new(0, -5)

                DropdownData.Functions.SetValue = function(NewData: string | {}, Save: boolean)
                    if NewData then
                        local ReturnData = NewData
                        if typeof(NewData) == "string" then
                            if DropdownData.SelectLimit == 1  then
                                table.clear(DropdownData.Buttons.Selected)
                                table.insert(DropdownData.Buttons.Selected, NewData)
                            end

                            SelectedText.Text = NewData
                            if DropdownData.SelectLimit > 1 then
                                ReturnData = {NewData}
                            end
                        elseif typeof(NewData) == "table" then
                            if DropdownData.SelectLimit > 1  then
                                if DropdownData.SelectLimit >= #NewData then
                                    DropdownData.Buttons.Selected = NewData
                                else
                                    DropdownData.Buttons.Selected[#DropdownData.Buttons.Selected] = nil
                                end
                            else
                                table.clear(DropdownData.Buttons.Selected)
                                for i,v in NewData do
                                    table.insert(DropdownData.Buttons.Selected, v)                                        
                                end
                            end

                            if #NewData >= 1 then
                                SelectedText.Text = table.concat(NewData, ", ")
                            else
                                SelectedText.Text = "No Option Selected"
                            end
                        end

                        for i,v in DropdownData.Buttons.Buttons do
                            if table.find(DropdownData.Buttons.Selected, i) then
                                v.CheckMark.Visible = true
                                v.ButtonText.Position = UDim2.fromScale(0.037, 0.5)
                                v.ButtonText.Size = UDim2.fromScale(0.961, 1)
                            else
                                if v.CheckMark.Visible then
                                    v.CheckMark.Visible = false
                                    v.ButtonText.Position = UDim2.fromScale(0, 0.5)
                                    v.ButtonText.Size = UDim2.fromScale(1, 1)
                                end
                            end
                        end

                        DropdownData.Callback(DropdownData, ReturnData)

                        if Save then
                            Night.Config.Game.Dropdowns[DropdownData.Flag] = ReturnData
                            Assets.Config.Save(Night.GameSave, Night.Config.Game)
                        end
                    end
                end

                for i,v in DropdownData.Options do
                    DropdownData.Data.ExtendSize += 22

                    local ButtonInfo = {
                        CheckMark = Instance.new("ImageLabel"),
                        ButtonText = Instance.new("TextLabel"),
                        Functions = {},
                        Connections = {}
                    }

                    local Button = Instance.new("TextButton", OptionsList)
                    Button.AutoButtonColor = false
                    Button.BackgroundTransparency = 1
                    Button.Size = UDim2.new(0.97, 0, 0, 20)
                    Button.Text = ""

                    ButtonInfo.ButtonText.Parent = Button
                    ButtonInfo.ButtonText.AnchorPoint = Vector2.new(0, 0.5)
                    ButtonInfo.ButtonText.BackgroundTransparency = 1
                    ButtonInfo.ButtonText.Position = UDim2.fromScale(0, 0.5)
                    ButtonInfo.ButtonText.Size = UDim2.fromScale(1, 1)
                    ButtonInfo.ButtonText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                    ButtonInfo.ButtonText.Text = tostring(v)
                    ButtonInfo.ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ButtonInfo.ButtonText.TextSize = 13
                    ButtonInfo.ButtonText.TextTransparency = 0.2
                    ButtonInfo.ButtonText.TextXAlignment = Enum.TextXAlignment.Left

                    ButtonInfo.CheckMark.Parent = Button
                    ButtonInfo.CheckMark.AnchorPoint = Vector2.new(0, 0.5)
                    ButtonInfo.CheckMark.BackgroundTransparency = 1
                    ButtonInfo.CheckMark.Position = UDim2.fromScale(0, 0.4)
                    ButtonInfo.CheckMark.Size = UDim2.fromOffset(13, 13)
                    ButtonInfo.CheckMark.Image = "rbxassetid://91799225292383"
                    ButtonInfo.CheckMark.ImageColor3 = Color3.fromRGB(255, 255, 255)
                    ButtonInfo.CheckMark.ImageTransparency = 0.2
                    ButtonInfo.CheckMark.ScaleType = Enum.ScaleType.Stretch
                    ButtonInfo.CheckMark.Visible = false

                    if typeof(DropdownData.Default) == "table" then
                        if table.find(DropdownData.Default, tostring(v)) then
                            ButtonInfo.CheckMark.Visible = true
                            ButtonInfo.ButtonText.Position = UDim2.fromScale(0.037, 0.5)
                            ButtonInfo.ButtonText.Size = UDim2.fromScale(0.961, 1)
                        end
                    elseif typeof(DropdownData.Default) == "string" then
                        if DropdownData.Default == tostring(v) then
                            ButtonInfo.CheckMark.Visible = true
                            ButtonInfo.ButtonText.Position = UDim2.fromScale(0.037, 0.5)
                            ButtonInfo.ButtonText.Size = UDim2.fromScale(0.961, 1)
                        end
                    end

                    local ClickCon = Button.MouseButton1Down:Connect(function()
                        if DropdownData.SelectLimit > 1 then
                            if not table.find(DropdownData.Buttons.Selected, v) then
                                table.insert(DropdownData.Buttons.Selected, v)                                        
                            else
                                table.remove(DropdownData.Buttons.Selected, table.find(DropdownData.Buttons.Selected, v))
                            end

                            DropdownData.Functions.SetValue(DropdownData.Buttons.Selected, true)
                        else
                            DropdownData.Functions.SetValue(v, true)
                        end
                    end)

                    table.insert(ButtonInfo.Connections, ClickCon)
                    table.insert(DropdownData.Connections, ClickCon)
                    table.insert(Night.Connections, ClickCon)

                    ButtonInfo.Functions.Destroy = function()
                        for i,v in ButtonInfo.Connections do
                            local con1 = table.find(DropdownData.Connections, v)
                            local con2 = table.find(Night.Connections, v)
                            v:Disconnect()
                            if con1 then
                                table.remove(DropdownData.Connections, con1)
                            end
                            if con2 then
                                table.remove(Night.Connections, con2)
                            end
                        end
                    end

                    DropdownData.Buttons.Buttons[v] = ButtonInfo
                end

                local OpenCon = DropBox.MouseButton1Down:Connect(function()
                    DropdownData.Data.Opened = not DropdownData.Data.Opened
                    if DropdownData.Data.Opened then
                        local extend = DropdownData.Data.ExtendSize
                        if extend > 88 then
                            extend = 88
                        end

                        TweenService:Create(DropdownData.Objects.MainInstance, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 125 + extend)}):Play()
                        TweenService:Create(DropBox, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 35 + extend)}):Play()
                        TweenService:Create(OptionsList, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, extend)}):Play()
                    else
                        TweenService:Create(OptionsList, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {Size = UDim2.fromScale(1, 0)}):Play()
                        TweenService:Create(DropBox, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                        TweenService:Create(DropdownData.Objects.MainInstance, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 125)}):Play()
                    end
                end)
                table.insert(DropdownData.Connections, OpenCon)
                table.insert(Night.Connections, OpenCon)


                DropdownData.Functions.SetVisiblity = function(enabled)
                    if enabled then
                        if table.find(ModuleData.Data.ExcludeSettingsVisiblity, DropdownData) then
                            table.remove(ModuleData.Data.ExcludeSettingsVisiblity, table.find(ModuleData.Data.ExcludeSettingsVisiblity, DropdownData))
                        end
                        if ModuleData.Data.SettingsOpen then
                            DropdownData.Objects.MainInstance.Visible = true
                        end
                    else
                        if not table.find(ModuleData.Data.ExcludeSettingsVisiblity, DropdownData) then
                            table.insert(ModuleData.Data.ExcludeSettingsVisiblity, DropdownData)
                        end
                        DropdownData.Objects.MainInstance.Visible = false
                    end
                end

                if DropdownData.Hide then
                    DropdownData.Functions.SetVisiblity(false)
                end

                ModuleData.Settings[DropdownData.Flag] = DropdownData
                return DropdownData
            end

            ModuleData.Functions.Settings.Button = function(data: {Name: string, Flag: string, Description: string, ToolTip: string, Hide: boolean, Callback: any})
                local ButtonData = {
                    Name = data and data.Name or "Button",
                    Flag = data and data.Flag or "Button",
                    Description = data and data.Description or "Button",
                    ToolTip = data and data.ToolTip or "Click to Toggle",
                    Hide = data and data.Hide or false,
                    Callback = data and data.Callback or function() end,
                    Connections = {},
                    Functions = {},
                    Objects = {}
                }

                ButtonData.Construction = ModuleData.Functions.ConstructSetting({
                    Name = ButtonData.Name,
                    Description = ButtonData.Description,
                    Size = 80,
                    Layout = false,
                    ToolTip = ButtonData.ToolTip,
                    OnToolTipEdit = function(new: {ToolTip: string})
                        ButtonData.ToolTip = new.ToolTip
                    end
                })
                ButtonData.Objects.MainInstance = ButtonData.Construction.Objects.MainInstance
                ButtonData.Functions.EditToolTip = ButtonData.Construction.Functions.EditToolTip
                if Night.Mobile and ButtonData.ToolTip == "Click to toggle" then
                    ButtonData.Construction.Functions.EditToolTip({ToolTip = "Tap to toggle"})
                end

                local ClickCon = ButtonData.Objects.MainInstance.MouseButton1Down:Connect(function()
                    ButtonData.Callback(ButtonData)
                end)
                table.insert(ButtonData.Connections, ClickCon)
                table.insert(Night.Connections, ClickCon)

                ButtonData.Functions.SetVisiblity = function(enabled)
                    if enabled then
                        if table.find(ModuleData.Data.ExcludeSettingsVisiblity, ButtonData) then
                            table.remove(ModuleData.Data.ExcludeSettingsVisiblity, table.find(ModuleData.Data.ExcludeSettingsVisiblity, ButtonData))
                        end
                        if ModuleData.Data.SettingsOpen then
                            ButtonData.Objects.MainInstance.Visible = true
                        end
                    else
                        if not table.find(ModuleData.Data.ExcludeSettingsVisiblity, ButtonData) then
                            table.insert(ModuleData.Data.ExcludeSettingsVisiblity, ButtonData)
                        end
                        ButtonData.Objects.MainInstance.Visible = false
                    end
                end

                if ButtonData.Hide then
                    ButtonData.Functions.SetVisiblity(false)
                end

                ModuleData.Settings[ButtonData.Flag] = ButtonData
                return ButtonData
            end

            ModuleData.Functions.Settings.NewSection = function(Data: {Name: string, Flag: string})
                local SectionData = {
                    Name = Data and Data.Name or "Section",
                    Flag = Data and Data.Flag or "Flag", 
                    Objects = {}
                }

                SectionData.Objects.MainInstance = Instance.new("TextLabel", ModuleSettings)
                SectionData.Objects.MainInstance.BackgroundTransparency = 1
                SectionData.Objects.MainInstance.Size = UDim2.new(0.976, 0, 0, 35)
                SectionData.Objects.MainInstance.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
                SectionData.Objects.MainInstance.Text = tostring(SectionData.Name)
                SectionData.Objects.MainInstance.TextColor3 = Color3.fromRGB(255, 255, 255)
                SectionData.Objects.MainInstance.TextSize = 17
                SectionData.Objects.MainInstance.TextTransparency = 0.1
                SectionData.Objects.MainInstance.TextXAlignment = Enum.TextXAlignment.Left
                SectionData.Objects.MainInstance.Visible = false

                ModuleData.Settings[SectionData.Flag] = SectionData
                return SectionData
            end

            ModuleData.Functions.Settings.Keybind = function(Data: {Name: string, Description: string, Default: string, ToolTip: string, Hide: boolean, Flag: string, Callbacks: {Began: () -> (), End: () -> (), Changed: () -> ()}, Mobile: {Text: string, Default: boolean, Visible: boolean}})
                local KeybindData = {
                    Name = Data and Data.Name or "Keybind",
                    Description = Data and Data.Description or "Keybind",
                    Default = Data and Data.Default or "",
                    Flag = Data and Data.Flag or "FlagKeybind", 
                    Hide = data and data.Hide or false,
                    ToolTip = Data and Data.ToolTip or "Click The Box To Bind",
                    Callbacks = Data and Data.Callbacks or {Began = function() end, End = function() end, Changed = function() end},
                    Data = {Keybind = nil, Binding = false},
                    Mobile = Data and Data.Mobile or {Text = "Keybind", Default = false, Visible = true},
                    Type = "ModuleKeybinds",
                    Functions = {},
                    Objects = {},
                    Connections = {}
                }

                if not KeybindData.Callbacks.Began then
                    KeybindData.Callbacks.Began = function() end
                end
                if not KeybindData.Callbacks.End then
                    KeybindData.Callbacks.End = function() end
                end
                if not KeybindData.Callbacks.Changed then
                    KeybindData.Callbacks.Changed = function() end
                end

                if not Night.Config.Game.ModuleKeybinds then
                    Night.Config.Game.ModuleKeybinds = {}
                else
                    if Night.Config.Game.ModuleKeybinds[KeybindData.Flag] then
                        if Night.Config.Game.ModuleKeybinds[KeybindData.Flag] == "unbinded" then
                            KeybindData.Default = ""
                        else
                            KeybindData.Default = Night.Config.Game.ModuleKeybinds[KeybindData.Flag]
                        end
                    else
                        if KeybindData.Mobile.Default then
                            KeybindData.Default = "button"
                        end
                    end
                end

                KeybindData.Construction = ModuleData.Functions.ConstructSetting({
                    Name = KeybindData.Name,
                    Description = KeybindData.Description,
                    Size = 80,
                    Layout = false,
                    ToolTip = KeybindData.Flag,
                    OnToolTipEdit = function(new: {ToolTip: string})
                        KeybindData.ToolTip = new.ToolTip
                    end
                })
                KeybindData.Objects.MainInstance = KeybindData.Construction.Objects.MainInstance

                local KeybindBox = Instance.new("ImageButton", KeybindData.Objects.MainInstance)
                KeybindBox.AnchorPoint = Vector2.new(1, 0.5)
                KeybindBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                KeybindBox.BackgroundTransparency = 0.4
                KeybindBox.Position = UDim2.fromScale(1, 0.5)
                KeybindBox.Size = UDim2.fromOffset(25, 25)
                KeybindBox.AutoButtonColor = false
                Instance.new("UICorner", KeybindBox).CornerRadius = UDim.new(0, 5)
                
                local BoxStroke = Instance.new("UIStroke", KeybindBox)
                BoxStroke.Color = Color3.fromRGB(255, 255, 255)
                BoxStroke.Transparency = 0.9

                local BoxIcon = Instance.new("ImageLabel", KeybindBox)
                BoxIcon.AnchorPoint = Vector2.new(0.5, 0.5)
                BoxIcon.BackgroundTransparency = 1
                BoxIcon.Position = UDim2.fromScale(0.5, 0.5)
                BoxIcon.Size = UDim2.fromOffset(13, 13)
                BoxIcon.Image = "rbxassetid://101725457581159"
                BoxIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                BoxIcon.ImageTransparency = 0.6
                BoxIcon.ScaleType = Enum.ScaleType.Stretch

                local KeybindText = Instance.new("TextLabel", KeybindBox)
                KeybindText.AnchorPoint = Vector2.new(0.5, 0.5)
                KeybindText.BackgroundTransparency = 1
                KeybindText.Position = UDim2.fromScale(0.5, 0.5)
                KeybindText.Size = UDim2.fromOffset(10, 15)
                KeybindText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
                KeybindText.Text = KeybindData.Default
                KeybindText.TextColor3 = Color3.fromRGB(255, 255, 255)
                KeybindText.TextSize = 13
                KeybindText.TextTransparency = 0.6
                KeybindText.Visible = false

                if Night.Mobile then
                    table.insert(ModuleData.onToggles, function(self, enabled)
                        if enabled then
                            if KeybindData.Data.Keybind and KeybindData.Data.Keybind ~= "unbinded" then
                                Night.Background.Functions.CreateMobileButton({
                                    Name = KeybindData.Mobile.Text,
                                    Flag = KeybindData.Flag.."MobileKeybind",
                                    Callbacks = {
                                        Began = function(self)
                                            return KeybindData.Callbacks.Began(KeybindData)
                                        end,
                                        End = function(self, drag : boolean)
                                            return KeybindData.Callbacks.End(KeybindData)
                                        end
                                    }
                                })

                            end
                        else
                            if Night.Background.MobileButtons.Buttons[KeybindData.Flag.."MobileKeybind"] then
                                Night.Background.MobileButtons.Buttons[KeybindData.Flag.."MobileKeybind"].Functions.Destroy()
                            end
                        end
                    end)
                end

                if tostring(KeybindData.Default):gsub(" ", "") ~= "" then
                    KeybindData.Data.Keybind = KeybindData.Default
                    local Size = GetTextBounds(KeybindData.Default, Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium), 13)
                    KeybindBox.Size = UDim2.fromOffset(Size.X + 18, 25)

                    BoxIcon.Visible = false
                    KeybindText.Visible = true 
                    BoxIcon.Image = "rbxassetid://135395971960120"

                    if Night.Mobile and tostring(KeybindData.Default) == "button" then
                        KeybindData.Construction.Functions.EditToolTip({ToolTip = "Tap The Box To Unbind"})
                            KeybindData.Callbacks.Changed(KeybindData, KeybindData.Default)
                    elseif Night.Mobile and tostring(KeybindData.Default) == "unbinded" then
                        KeybindData.Callbacks.Changed(KeybindData, nil)

                        KeybindData.Data.Keybind = nil
                        BoxIcon.Image = "rbxassetid://101725457581159"
                        BoxIcon.Visible = true
                        KeybindText.Visible = false
                        KeybindText.Text = "binded"
                    elseif not Night.Mobile then
                        KeybindData.Callbacks.Changed(KeybindData, KeybindData.Default)
                        KeybindData.Construction.Functions.EditToolTip({ToolTip = "Click The Box To Unbind"})
                    end

                end

                local ClickCon = KeybindBox.MouseButton1Down:Connect(function()
                    if not KeybindData.Data.Keybind then
                        if Night.Mobile then
                            KeybindData.Data.Keybind = "button"

                            local Size = GetTextBounds("button", Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium), 13)
                            KeybindBox.Size = UDim2.fromOffset(Size.X + 18, 25)
                            KeybindText.Text = "binded"

                            BoxIcon.Visible = false
                            KeybindText.Visible = true 
                            BoxIcon.Image = "rbxassetid://135395971960120"
                            KeybindData.Construction.Functions.EditToolTip({ToolTip = "Tap The Box To Unbind"})

                            if not Night.Config.Game.ModuleKeybinds then
                                Night.Config.Game.ModuleKeybinds = {}
                            end

                            if not Night.Background.MobileButtons.Buttons[KeybindData.Flag.."MobileKeybind"] and ModuleData.Data.Enabled then
                                Night.Background.Functions.CreateMobileButton({
                                    Name = KeybindData.Mobile.Text,
                                    Flag = KeybindData.Flag.."MobileKeybind",
                                    Callbacks = {
                                        Began = function(self)
                                            return KeybindData.Callbacks.Began(KeybindData)
                                        end,
                                        End = function(self, drag : boolean)
                                            return KeybindData.Callbacks.End(KeybindData)
                                        end
                                    }
                                })
                            end
                            
                            KeybindData.Callbacks.Changed(KeybindData, "button")

                            Night.Config.Game.ModuleKeybinds[KeybindData.Flag] = "button"
                            Night.Assets.Config.Save(tostring(Night.GameSave), Night.Config.Game)
                        else
                            KeybindData.Construction.Functions.EditToolTip({ToolTip = "Please Click A Button"})
                            KeybindData.Data.Binding = true
                        end
                    else
                        KeybindData.Callbacks.Changed(KeybindData, nil)

                        KeybindData.Data.Keybind = nil
                        BoxIcon.Image = "rbxassetid://101725457581159"
                        BoxIcon.Visible = true
                        KeybindText.Visible = false 

                        KeybindBox.Size = UDim2.fromOffset(25, 25)
                        if Night.Mobile then
                            if Night.Background.MobileButtons.Buttons[KeybindData.Flag.."MobileKeybind"] then
                                Night.Background.MobileButtons.Buttons[KeybindData.Flag.."MobileKeybind"].Functions.Destroy()
                            end
                            KeybindData.Construction.Functions.EditToolTip({ToolTip = "Tap The Box To Bind"})
                        else
                            KeybindData.Construction.Functions.EditToolTip({ToolTip = "Click The Box To Bind"})
                        end

                        Night.Config.Game.ModuleKeybinds[KeybindData.Flag] = nil
                        if Night.Mobile then
                            Night.Config.Game.ModuleKeybinds[KeybindData.Flag] = "unbinded"
                        end
                        Night.Assets.Config.Save(tostring(Night.GameSave), Night.Config.Game)
                    end
                end)

                local CallbackCon = UserInputService.InputBegan:Connect(function(input)
                    if UserInputService:GetFocusedTextBox() and not KeybindData.Data.Binding then return end
                    if KeybindData.Data.Binding then
                        if input.KeyCode and input.KeyCode.Name ~= "Unknown" then
                            KeybindData.Data.Keybind = input.KeyCode.Name

                            local Size = GetTextBounds(input.KeyCode.Name, Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium), 13)
                            KeybindBox.Size = UDim2.fromOffset(Size.X + 18, 25)
                            KeybindText.Text = input.KeyCode.Name

                            BoxIcon.Visible = false
                            KeybindText.Visible = true 
                            BoxIcon.Image = "rbxassetid://135395971960120"
                            KeybindData.Construction.Functions.EditToolTip({ToolTip = "Click The Box To Unbind"})

                            if not Night.Config.Game.ModuleKeybinds then
                                Night.Config.Game.ModuleKeybinds = {}
                            end

                            KeybindData.Callbacks.Changed(KeybindData, input.KeyCode.Name)
                            Night.Config.Game.ModuleKeybinds[KeybindData.Flag] = input.KeyCode.Name
                            Night.Assets.Config.Save(tostring(Night.GameSave), Night.Config.Game)
                        end
                    else
                        if KeybindData.Data.Keybind and KeybindData.Data.Keybind == input.KeyCode.Name then
                            KeybindData.Callbacks.Began(KeybindData)
                        end
                    end
                end)

                local EndCon = UserInputService.InputEnded:Connect(function(input)
                    if UserInputService:GetFocusedTextBox() then return end
                    if KeybindData.Data.Keybind and KeybindData.Data.Keybind == input.KeyCode.Name then
                        if KeybindData.Data.Binding then
                            KeybindData.Data.Binding = false
                            return
                        end
                        KeybindData.Callbacks.End(KeybindData)
                    end
                end)

                local HoverCon = KeybindBox.MouseEnter:Connect(function()
                    if KeybindData.Data.Keybind then
                        KeybindText.Visible = false
                        BoxIcon.Visible = true
                    end
                end)

                local UnHoverCon = KeybindBox.MouseLeave:Connect(function()
                    if KeybindData.Data.Keybind then
                        KeybindText.Visible = true
                        BoxIcon.Visible = false
                    end
                end)
                
                table.insert(KeybindData.Connections, ClickCon)
                table.insert(Night.Connections, ClickCon)

                table.insert(KeybindData.Connections, CallbackCon)
                table.insert(Night.Connections, CallbackCon)

                table.insert(KeybindData.Connections, EndCon)
                table.insert(Night.Connections, EndCon)

                table.insert(KeybindData.Connections, HoverCon)
                table.insert(Night.Connections, HoverCon)
                
                table.insert(KeybindData.Connections, UnHoverCon)
                table.insert(Night.Connections, UnHoverCon)


                KeybindData.Functions.SetValue = function(NewValue: string, save: boolean)
                    if not NewValue or NewValue == "" or NewValue == "unbinded" then
                        KeybindData.Data.Keybind = nil
                        BoxIcon.Image = "rbxassetid://101725457581159"
                        BoxIcon.Visible = true
                        KeybindText.Visible = false 

                        KeybindBox.Size = UDim2.fromOffset(25, 25)
                        KeybindData.Construction.Functions.EditToolTip({ToolTip = "Click The Box To Bind"})

                        if save then
                            Night.Config.Game.ModuleKeybinds[KeybindData.Flag] = nil
                            Night.Assets.Config.Save(tostring(Night.GameSave), Night.Config.Game)
                        end
                    else
                        KeybindData.Data.Keybind = NewValue

                        local Size = GetTextBounds(NewValue, Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium), 13)
                        KeybindBox.Size = UDim2.fromOffset(Size.X + 18, 25)

                        KeybindText.Text = NewValue

                        BoxIcon.Visible = false
                        KeybindText.Visible = true 
                        BoxIcon.Image = "rbxassetid://135395971960120"
                        KeybindData.Construction.Functions.EditToolTip({ToolTip = "Click The Box To Unbind"})

                        if not Night.Config.Game.ModuleKeybinds then
                            Night.Config.Game.ModuleKeybinds = {}
                        end
                        if save then
                            Night.Config.Game.ModuleKeybinds[KeybindData.Flag] = NewValue
                            Night.Assets.Config.Save(tostring(Night.GameSave), Night.Config.Game)
                        end
                    end
                end

                KeybindData.Functions.SetVisiblity = function(enabled)
                    if enabled then
                        if table.find(ModuleData.Data.ExcludeSettingsVisiblity, KeybindData) then
                            table.remove(ModuleData.Data.ExcludeSettingsVisiblity, table.find(ModuleData.Data.ExcludeSettingsVisiblity, KeybindData))
                        end
                        if ModuleData.Data.SettingsOpen then
                            KeybindData.Objects.MainInstance.Visible = true
                        end
                    else
                        if not table.find(ModuleData.Data.ExcludeSettingsVisiblity, KeybindData) then
                            table.insert(ModuleData.Data.ExcludeSettingsVisiblity, KeybindData)
                        end
                        KeybindData.Objects.MainInstance.Visible = false
                    end
                end
                
                if KeybindData.Hide then
                    KeybindData.Functions.SetVisiblity(false)
                end

                ModuleData.Settings[KeybindData.Flag] = KeybindData
                return KeybindData
            end

            ModuleData.Functions.Destroy = function()
                for i,v in ModuleData.Connections do
                    v:Disconnect()
                end
                ModuleData.Callback(ModuleData, false)
                table.clear(ModuleData.Connections)
                tab.Modules[ModuleData.Flag] = nil

                ModuleData.Objects.Module:Destroy()
                table.clear(ModuleData)
            end

            tab.Modules[ModuleData.Flag] = ModuleData
            return ModuleData
        end

        tab.Functions.Destroy = function()
            for i,v in tab.Modules do
                if v and v.Functions and v.Functions.Destroy then
                    v.Functions.Destroy()
                end
            end
            for i,v in tab.Connections do
                v:Disconnect()
            end
            tab.Objects.ActualTab:Destroy()
            tab.Objects.DashBoardButton:Destroy()
            table.clear(tab)
        end

        Night.Tabs.Tabs[tab.Name] = tab
        return tab
    end

end

do
    Assets.SettingsPage.Init = function(Settings)
        if not Settings then return end
        local SettingsPageInfo = {
            Functions = {},
        }

        local pageselectorbuttonicon = Settings.Objects.PageselectorButton:FindFirstChildWhichIsA("ImageLabel")
        if pageselectorbuttonicon then
            pageselectorbuttonicon.ImageTransparency = 0.1
        end
        
        local SettingsScroll = Instance.new("ScrollingFrame", Settings.Objects.ActualPage)
        SettingsScroll.AnchorPoint = Vector2.new(0.5, 1)
        SettingsScroll.BackgroundTransparency = 1
        SettingsScroll.Position = UDim2.new(0.5, 0, 1, 20)
        SettingsScroll.Size = UDim2.new(1, 0, 1, -100)
        SettingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        SettingsScroll.CanvasSize = UDim2.fromScale(1, 0)
        SettingsScroll.ScrollBarImageTransparency = 0.8
        SettingsScroll.ScrollBarThickness = 2
        SettingsScroll.ScrollingDirection = Enum.ScrollingDirection.Y

        local SettingsScrollList = Instance.new("UIListLayout", SettingsScroll)
        SettingsScrollList.SortOrder = Enum.SortOrder.LayoutOrder
        SettingsScrollList.Padding = UDim.new(0, 10)
        SettingsScrollList.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local scrollPadding = Instance.new("UIPadding", SettingsScroll)
        scrollPadding.PaddingBottom = UDim.new(0, 20)
        scrollPadding.PaddingLeft = UDim.new(0, 20)
        scrollPadding.PaddingRight = UDim.new(0, 20)
        scrollPadding.PaddingTop = UDim.new(0, 5)

        SettingsPageInfo.Functions.NewSection = function(data)
            local SectionData = {
                Functions = {},
            }

            local Section = Instance.new("Frame", SettingsScroll)
            Section.AnchorPoint = Vector2.new(0.5, 0)
            Section.AutomaticSize = Enum.AutomaticSize.Y
            Section.BackgroundTransparency = 1
            Section.Size = UDim2.fromScale(1, 0)

            local SectionList = Instance.new("UIListLayout", Section)
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            SectionList.HorizontalAlignment = Enum.HorizontalAlignment.Center

            local SectionText = Instance.new("TextLabel", Section)
            SectionText.BackgroundTransparency = 1
            SectionText.Size = UDim2.new(1, -40, 0, 20)
            SectionText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
            SectionText.Text = data.Name:upper()
            SectionText.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionText.TextTransparency = 0.5
            SectionText.TextSize = 14
            SectionText.TextXAlignment = Enum.TextXAlignment.Left
            SectionText.TextYAlignment = Enum.TextYAlignment.Top

            local madebutton = false
            SectionData.Functions.NewButton = function(data)
                local ButtonData = {
                    Name = data.Name or "Button",
                    Input = data.Input,
                    Last = data.Last or false,
                    Toggle = data.Toggle or false,
                    Default = data.Default or false,
                    Textbox = data.Textbox or false,
                    Flag = data.Flag or nil,
                    Data = {Enabled = false},
                    Objects = {},
                    Callback = data.Callback or function() end,
                }

                ButtonData.Objects.MainButton = Instance.new("ImageButton", Section)
                ButtonData.Objects.MainButton.BackgroundTransparency = 1
                ButtonData.Objects.MainButton.Size = UDim2.new(1, 0, 0, 45)
                ButtonData.Objects.MainButton.AutoButtonColor = false
                ButtonData.Objects.MainButton.Image = "rbxassetid://16286719854"
                ButtonData.Objects.MainButton.ImageColor3 = Color3.fromRGB(0, 0, 0)
                ButtonData.Objects.MainButton.ImageTransparency = 0.6
                ButtonData.Objects.MainButton.ScaleType = Enum.ScaleType.Crop

                if not madebutton then
                    ButtonData.Objects.MainButton.ScaleType = Enum.ScaleType.Slice
                    ButtonData.Objects.MainButton.SliceCenter = Rect.new(512, 214, 512, 214)
                    ButtonData.Objects.MainButton.SliceScale = 0.12
                    ButtonData.Objects.MainButton.Image = "rbxassetid://16287196357"
                    madebutton = true
                end
                if ButtonData.Last then
                    ButtonData.Objects.MainButton.ScaleType = Enum.ScaleType.Slice
                    ButtonData.Objects.MainButton.SliceCenter = Rect.new(512, 0, 512, 0)
                    ButtonData.Objects.MainButton.SliceScale = 0.12
                    ButtonData.Objects.MainButton.Image = "rbxassetid://16287194510"
                end

                local ButtonPadding = Instance.new("UIPadding", ButtonData.Objects.MainButton)
                ButtonPadding.PaddingLeft = UDim.new(0, 20)
                ButtonPadding.PaddingRight = UDim.new(0, 20)

                ButtonData.Objects.MainButtonText = Instance.new("TextLabel", ButtonData.Objects.MainButton)
                ButtonData.Objects.MainButtonText.AnchorPoint = Vector2.new(0, 0.5)
                ButtonData.Objects.MainButtonText.BackgroundTransparency = 1
                ButtonData.Objects.MainButtonText.Position = UDim2.fromScale(0, 0.5)
                ButtonData.Objects.MainButtonText.Size = UDim2.new(1, -50, 1, 0)
                ButtonData.Objects.MainButtonText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                ButtonData.Objects.MainButtonText.Text = ButtonData.Name
                ButtonData.Objects.MainButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
                ButtonData.Objects.MainButtonText.TextTransparency = 0.3
                ButtonData.Objects.MainButtonText.TextSize = 16
                ButtonData.Objects.MainButtonText.TextXAlignment = Enum.TextXAlignment.Left
                ButtonData.Objects.MainButtonText.TextYAlignment = Enum.TextYAlignment.Center

                local EnabledCheckMark
                if ButtonData.Toggle then
                    EnabledCheckMark = Instance.new("ImageLabel", ButtonData.Objects.MainButton)
                    EnabledCheckMark.AnchorPoint = Vector2.new(1, 0.5)
                    EnabledCheckMark.BackgroundTransparency = 1
                    EnabledCheckMark.Position = UDim2.fromScale(1, 0.5)
                    EnabledCheckMark.Size = UDim2.fromOffset(18, 18)
                    EnabledCheckMark.Image = "rbxassetid://10709790644"
                    EnabledCheckMark.ImageColor3 = Color3.fromRGB(255,255,255)
                    EnabledCheckMark.ImageTransparency = 0.5
                    EnabledCheckMark.ScaleType = Enum.ScaleType.Stretch
                    EnabledCheckMark.Visible = false
                    if ButtonData.Flag then
                        if Night.Config.UI[ButtonData.Flag] == nil and ButtonData.Default or Night.Config.UI[ButtonData.Flag] then
                            ButtonData.Data.Enabled = true
                            EnabledCheckMark.Visible = true
                            ButtonData.Callback(ButtonData, true)
                        end
                    end
                end

                if ButtonData.Textbox then
                    local Textbox = Instance.new("TextBox", ButtonData.Objects.MainButton)
                    Textbox.AnchorPoint = Vector2.new(1, 0.5)
                    Textbox.BackgroundTransparency = 1
                    Textbox.Position = UDim2.fromScale(1, 0.5)
                    Textbox.Size = UDim2.new(1, -60, 0, 18)
                    Textbox.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                    Textbox.Text = ""
                    Textbox.TextSize = 16
                    Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Textbox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)   
                    Textbox.TextTransparency = 0.3
                    Textbox.TextXAlignment = Enum.TextXAlignment.Right
                    Textbox.ZIndex = 1000
                    Textbox.TextWrapped = true
                    if ButtonData.Default and typeof(ButtonData.Default) == "string" and Night.Config.UI[ButtonData.Flag] == nil then
                        Textbox.Text = ButtonData.Default
                    end
                    if Night.Config.UI[ButtonData.Flag] then
                        if typeof(Night.Config.UI[ButtonData.Flag]) == "table" then
                            for i,v in Night.Config.UI[ButtonData.Flag] do
                                Textbox.Text = Textbox.Text .. tostring(v) .. ", "
                            end
                            Textbox.Text = string.sub(Textbox.Text, 0, #Textbox.Text-2)
                        else
                            Textbox.Text = tostring(Night.Config.UI[ButtonData.Flag])
                        end
                    end

                    table.insert(Night.Connections, Textbox.FocusLost:Connect(function()
                        ButtonData.Callback(ButtonData, Textbox.Text)
                    end))

                    return ButtonData.Callback(ButtonData, Textbox.Text)
                end

                table.insert(Night.Connections, ButtonData.Objects.MainButton.MouseButton1Click:Connect(function() 
                    if ButtonData.Toggle then
                        ButtonData.Data.Enabled = not ButtonData.Data.Enabled
                        EnabledCheckMark.Visible = ButtonData.Data.Enabled
                        return ButtonData.Callback(ButtonData, ButtonData.Data.Enabled)
                    end
                    return ButtonData.Callback(ButtonData) 
                end))

                return ButtonData
            end
            return SectionData
        end
        return SettingsPageInfo
    end

end 

do    
    if not Night then 
        LocalPlayer:Kick("Night not supported/couldn't load global environment")
        return 
    end

    Assets.Main.OnUninject = Instance.new("BindableEvent")
    Assets.Main.Uninject = function()
        Assets.Main.OnUninject:Fire(true)

        Night.Background.Objects.MainScreenGui:Destroy()
        Night.Notifications.Objects.NotificationGui:Destroy()
        Night.ArrayList.Objects.ArrayGui:Destroy()

        if Night.Mobile then
            for i,v in Night.Background.MobileButtons.Buttons do
                if v and v.Functions and v.Functions.Destroy then
                    v.Functions.Destroy()
                end
            end
        end

        for i,v in Night.Tabs.Tabs do
            if v.Modules then
                for i2,v2 in v.Modules do
                    if v2 and v2.Callback then
                        v2.Callback(v2, false)
                        if v2.Data and v2.Data.Enabled then
                            v2.Data.Enabled = false
                        end
                    end
                end
            end
        end
        for i,v in Night.Connections do
            v:Disconnect()
        end
        
        Assets.Main.OnUninject:Destroy()
        table.clear(getgenv().Night)
        getgenv().Night = nil
    end

    local cantogglewithkeybind = true
    Assets.Main.Load = function(file)
        if not Night.Background then
            Night.Background = Assets.MainBackground.Init()
        end

        if not Night.Dashboard then
            Night.Dashboard = Assets.Pages.NewPage({
                Name = "Dashboard",
                Icon = "rbxassetid://11295288868",
                Default = true
            })
            Assets.Dashboard.NewTab({
                Name = "Premium",
                Icon = "rbxassetid://102351199755031",
                TabInfo = "Powerful modules kept premium",
                Dashboard = Night.Dashboard
            })

            local Settings = Assets.Pages.NewPage({
                Name = "Settings",
                Icon = "rbxassetid://11293977610",
                Default = false
            })

            local SettingsPage = Assets.SettingsPage.Init(Settings)
            local MainSettings = SettingsPage.Functions.NewSection({Name = "main"})
            MainSettings.Functions.NewButton({Name = "Uninject", Callback = function()
                Assets.Main.Uninject()
            end})
            MainSettings.Functions.NewButton({Name = "Notifications", Default = true, Toggle = true, Flag = "Notifications", Callback = function(self, enabled)
                Night.Config.UI.Notifications = enabled
                Assets.Config.Save("UI", Night.Config.UI)
            end})
            MainSettings.Functions.NewButton({Name = "Animations", Default = true, Toggle = true, Flag = "Anim", Callback = function(self, enabled)
                Night.Config.UI.Anim = enabled
                Assets.Config.Save("UI", Night.Config.UI)
            end})
            MainSettings.Functions.NewButton({Name = "ArrayList", Default = false, Toggle = true, Flag = "ArrayList", Callback = function(self, enabled)
                Night.Config.UI.ArrayList = enabled
                local Array
                if not Night.ArrayList.Loaded then
                    Array = Assets.ArrayList.Init()
                else
                    Array = Night.ArrayList
                end
                Array.Functions.Toggle(enabled)

                Assets.Config.Save("UI", Night.Config.UI)
            end})
            MainSettings.Functions.NewButton({Name = "Change Keybind", Callback = function(self)
                self.Objects.MainButtonText.Text = "Press the key you want to bind"
                local changecon = nil
                changecon = UserInputService.InputBegan:Connect(function(input)
                    if input and input.KeyCode.Name ~= "Unknown" then
                        cantogglewithkeybind = false
                        self.Objects.MainButtonText.Text = "Changed Keybind to " .. input.KeyCode.Name
                        Night.Config.UI.ToggleKeyCode = input.KeyCode.Name
                        Assets.Config.Save("UI", Night.Config.UI)
                        task.wait(1)
                        cantogglewithkeybind = true
                        self.Objects.MainButtonText.Text = "Change Keybind"
                    else
                        self.Objects.MainButtonText.Text = "Error Setting Bind"
                        task.wait(1)
                        self.Objects.MainButtonText.Text = "Change Keybind"
                    end
                    changecon:Disconnect()
                end)
                table.insert(Night.Connections, changecon)
            end})
            MainSettings.Functions.NewButton({Name = "Reset Game Config", Callback = function()
                Night.Config.Game = {
                    Modules = {},
                    Keybinds = {},
                    Sliders = {},
                    TextBoxes = {},
                    MiniToggles = {},
                    Dropdowns = {},
                    ToggleLists = {},
                    ModuleKeybinds = {},
                    Other = {}
                }
                Assets.Config.Save(Night.GameSave, Night.Config.Game)
            end})
            MainSettings.Functions.NewButton({Name = "Reset UI Config", Last = true, Callback = function()
                Night.Config.UI = {
                    Position = {X = 0.5, Y = 0.5},
                    Size = {X = 0.37294304370880129, Y = 0.683131217956543},
                    FullScreen = false,
                    ToggleKeyCode = "LeftAlt",
                    Scale = 1,
                    Notifications = true,
                    Anim = true,
                    ArrayList = false,
                    TabColor = {value1 = 40, value2 = 40, value3 = 40},
                    TabTransparency = 0.07,
                    KeybindTransparency = 0.7,
                    KeybindColor = {value1 = 0, value2 = 0, value3 = 0},
                }
                Assets.Config.Save("UI", Night.Config.UI)
            end})

            local ThemeSettings = SettingsPage.Functions.NewSection({Name = "Theme"})
            ThemeSettings.Functions.NewButton({Name = "TabColor", Textbox = true, Flag = "TabColor", Default = "70, 70, 70", Callback = function(self, value)
                local split = string.split(value, ",")
                if #split == 3 then
                    local v1, v2, v3 = split[1]:gsub(" ", ""), split[2]:gsub(" ", ""), split[3]:gsub(" ", "")
                    if tonumber(v1) and tonumber(v2) and tonumber(v3) then
                        Night.Config.UI.TabColor = {value1 = tonumber(v1), value2 = tonumber(v2), value3 = tonumber(v3)}
                        Assets.Config.Save("UI", Night.Config.UI)
                        for i,v in Night.Tabs.Tabs do
                            v.Objects.ActualTab.ImageColor3 = Color3.fromRGB(tonumber(v1), tonumber(v2), tonumber(v3))
                            v.Objects.CloseButton.BackgroundColor3 = Color3.fromRGB(tonumber(v1 + 20), tonumber(v2 + 20), tonumber(v3 + 20))
                            for i2, b in v.Modules do
                                if b.Objects and b.Objects.BackButton then 
                                    b.Objects.BackButton.BackgroundColor3 = Color3.fromRGB(tonumber(v1 + 20), tonumber(v2 + 20), tonumber(v3 + 20))
                                end
                            end
                        end
                    end
                end
            end})
            ThemeSettings.Functions.NewButton({Name = "TabTransparency", Textbox = true, Flag = "TabTransparency", Default = "0.1", Callback = function(self, value)
                if tonumber(value) then
                    Night.Config.UI.TabTransparency = tonumber(value)
                    for i,v in Night.Tabs.Tabs do
                        v.Objects.ActualTab.ImageTransparency = Night.Config.UI.TabTransparency
                    end
                    Assets.Config.Save("UI", Night.Config.UI)
                end
            end})
            ThemeSettings.Functions.NewButton({Name = "KeybindColor", Textbox = true, Flag = "KeybindColor", Default = "85, 89, 91", Callback = function(self, value)
                local split = string.split(value, ",")
                if #split == 3 then
                    local v1, v2, v3 = split[1]:gsub(" ", ""), split[2]:gsub(" ", ""), split[3]:gsub(" ", "")
                    if tonumber(v1) and tonumber(v2) and tonumber(v3) then
                        Night.Config.UI.KeybindColor = {value1 = tonumber(v1), value2 = tonumber(v2), value3 = tonumber(v3)}
                        Assets.Config.Save("UI", Night.Config.UI)
                        for i,v in Night.Tabs.Tabs do
                            if v.Objects.ActualTab:FindFirstChildWhichIsA("TextButton") then
                                v.Objects.ActualTab:FindFirstChildWhichIsA("TextButton").BackgroundColor3 = Color3.fromRGB(tonumber(v1), tonumber(v2), tonumber(v3))
                            end
                        end
                    end
                end
            end})
            ThemeSettings.Functions.NewButton({Name = "KeybindTransparency", Textbox = true, Flag = "KeybindTransparency", Last = true, Default = "0.015", Callback = function(self, value)
                if tonumber(value) then
                    Night.Config.UI.KeybindTransparency = tonumber(value)
                    Assets.Config.Save("UI", Night.Config.UI)
                    for i,v in Night.Tabs.Tabs do
                        if v.Objects.ActualTab:FindFirstChildWhichIsA("TextButton") then
                            v.Objects.ActualTab:FindFirstChildWhichIsA("TextButton").BackgroundTransparency = tonumber(value)
                        end
                    end
                end
            end})


            Assets.Functions.LoadFile("Night/Games/"..file..".lua", "https://raw.githubusercontent.com/warprbx/NightRewrite/refs/heads/main/Night/Games/"..file..".lua")
            Assets.Config.Load(file, "Game")
            return {Background = Night.Background, Dashboard = Night.Dashboard, Settings = Settings}
        else
            Assets.Functions.LoadFile("Night/Games/"..file..".lua", "https://raw.githubusercontent.com/warprbx/NightRewrite/refs/heads/main/Night/Games/"..file..".lua")
            Assets.Config.Load(Night.GameSave, "Game")
            return {Background = Night.Background, Dashboard = Night.Dashboard}
        end
    end




    local ToggleTweens = {}
    local Restore = {}
    local IsToggleAnimating = false
    Assets.Main.ToggleVisibility = function(visible)
        do
            if not Night.Config.UI.Anim then
                Night.Background.Objects.MainFrame.Visible = visible
                if visible then
                    Night.Background.Objects.MainFrame.BackgroundTransparency = 0.1
                    Night.Background.Objects.MainFrame.ImageTransparency = 0.8
                    Night.Background.Objects.MainFrameScale.Scale = 1
                    Night.Background.Objects.WindowControls.GroupTransparency = 0.4
                end
                return
            end

            if IsToggleAnimating then repeat task.wait() until not IsToggleAnimating end
            IsToggleAnimating = true

            local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            if visible then
                if not Night.Background.Objects.MainFrame.Visible then  
                    if Night.Mobile then
                        Night.Background.Objects.ToggleButton.Visible = false
                    end
                    Night.Background.Objects.MainFrame.Visible = true
                    Night.Background.Objects.DropShadow.Visible = true
                    
                    Night.Background.Objects.MainFrame.BackgroundTransparency = 1
                    Night.Background.Objects.MainFrame.ImageTransparency = 1
                    Night.Background.Objects.MainFrameScale.Scale = 1.2
                    Night.Background.Objects.WindowControls.GroupTransparency = 1


                    table.insert(ToggleTweens, TweenService:Create(Night.Background.Objects.MainFrame, tweenInfo, {BackgroundTransparency = 0.1, ImageTransparency = 0.8}))
                    table.insert(ToggleTweens, TweenService:Create(Night.Background.Objects.WindowControls, tweenInfo, {GroupTransparency = 0.4}))
                    table.insert(ToggleTweens, TweenService:Create(Night.Background.Objects.MainFrameScale, tweenInfo, {Scale = 1}))

                    for i,v in Restore do
                        v.Visible = true
                    end
                    for i,v in Night.Pages do
                        if v.Objects and v.Objects.ActualPage and v.Selected then
                            v.Objects.ActualPage.Visible = true
                        end
                    end
                    table.clear(Restore)

                    local completedTweens = 0
                    for i,v in ToggleTweens do
                        v:Play()
                        v.Completed:Connect(function()
                            completedTweens += 1
                            if completedTweens == #ToggleTweens then
                                IsToggleAnimating = false
                            end
                        end)
                    end
                    if Night.CurrentOpenTab then
                        for i,v in Night.CurrentOpenTab do
                            if v.Functions then
                                task.wait(0.015)
                                v.Functions.ToggleTab(true, true, true)
                            end
                        end
                    end

                else
                    IsToggleAnimating = false
                end

            else
                if Night.Notifications.Active.discordnoti then
                    Night.Notifications.Active.discordnoti.Functions.Remove(true)
                end
                if Night.Mobile then
                    Night.Background.Objects.ToggleButton.Visible = true
                end

                if Night.CurrentOpenTab then
                    for i,v in Night.CurrentOpenTab do
                        if v.Functions then
                            v.Functions.ToggleTab(false, true, true)
                        end
                    end
                end

                table.insert(ToggleTweens, TweenService:Create(Night.Background.Objects.MainFrame, tweenInfo, {BackgroundTransparency = 1, ImageTransparency = 1}))
                table.insert(ToggleTweens, TweenService:Create(Night.Background.Objects.WindowControls, tweenInfo, {GroupTransparency = 1}))
                table.insert(ToggleTweens, TweenService:Create(Night.Background.Objects.MainFrameScale, tweenInfo, {Scale = 1.2}))

                if Night.Pageselector.Objects.Pageselector.Visible then
                    Night.Pageselector.Objects.Pageselector.Visible = false
                    table.insert(Restore, Night.Pageselector.Objects.Pageselector)
                end
                Night.Background.Objects.NavigationButtons.Visible = false
                table.insert(Restore, Night.Background.Objects.NavigationButtons)
                Night.Background.Objects.WindowControls.Visible = false
                table.insert(Restore, Night.Background.Objects.WindowControls)

                for i,v in Night.Pages do
                    if v.Objects and v.Objects.ActualPage then
                        v.Objects.ActualPage.Visible = false
                    end
                end
                Night.Background.Objects.DropShadow.Visible = false

                local completedTweens = 0
                for i,v in ToggleTweens do
                    v:Play()
                    v.Completed:Connect(function()
                        completedTweens += 1
                        if completedTweens == #ToggleTweens then
                            IsToggleAnimating = false
                        end
                    end)
                end

                task.wait(0.5)
                Night.Background.Objects.MainFrame.Visible = false
            end
        end
    end
    table.insert(Night.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed and UserInputService:GetFocusedTextBox() or not cantogglewithkeybind then return end
        if input.KeyCode.Name == Night.Config.UI.ToggleKeyCode then
            Assets.Main.ToggleVisibility(not Night.Background.Objects.MainFrame.Visible)
        end
    end))

end

Night.Assets = Assets
return Assets
