local Night = getgenv().Night
local Dashboard = Night.Assets.Dashboard
local Functions = Night.Assets.Functions

local tabs = {
    Movement = Dashboard.NewTab({
        Name = "Movement", 
        Icon = "rbxassetid://91498840989140", 
        TabInfo = "Modules that affect your movement",
        Dashboard = Night.Dashboard 
    }),
    Combat = Dashboard.NewTab({
        Name = "Combat", 
        Icon = "rbxassetid://136782547250878", 
        TabInfo = "Modules that affect game combat",
        Dashboard = Night.Dashboard 
    }),
    Render = Dashboard.NewTab({
        Name = "Render", 
        Icon = "rbxassetid://79994571770852", 
        TabInfo = "Modules that affect game visuals",
        Dashboard = Night.Dashboard 
    }),
    Player = Dashboard.NewTab({
        Name = "Player", 
        Icon = "rbxassetid://123989691251374", 
        TabInfo = "Modules that affect local player",
        Dashboard = Night.Dashboard 
    }),
    World = Dashboard.NewTab({
        Name = "World", 
        Icon = "rbxassetid://72575228899700", 
        TabInfo = "Modules that affect the game",
        Dashboard = Night.Dashboard 
    }),
    Utility = Dashboard.NewTab({
        Name = "Utility", 
        Icon = "rbxassetid://116522046546969", 
        TabInfo = "Universal utility modules",
        Dashboard = Night.Dashboard 
    })
}

local lighting = Functions.cloneref(game:GetService("Lighting")) :: Lighting
local plrs = Functions.cloneref(game:GetService("Players")) :: Players
local ws = Functions.cloneref(game:GetService("Workspace")) :: Workspace
local rs = Functions.cloneref(game:GetService("RunService")) :: RunService
local virtual = Functions.cloneref(game:GetService("VirtualUser")) :: VirtualUser
local lp = plrs.LocalPlayer
local cam = ws.CurrentCamera

local SpeedData = {
    Enabled = false,
    Speed = 50,
    JumpPower = 50,
    TPDelay = 3,
    PulseDelay = 20,
    PulseDuration = 15,
    Mode = "Velocity",
    WallCheck = false,
    AutoJump = false,
    Pulse = false,
    OldWS = nil,
    OldJumpPower = nil,
    OldJumpPowerToggle = nil,
    PulseInstances = {},
    Disable = false
}
local SpeedModule = tabs.Movement.Functions.NewModule({
    Name = "Speed",
    Description = "Edit local character speed in settings",
    Icon = "rbxassetid://137816060476796",
    Flag = "UniversalSpeedModule",
    Callback = function(self, enabled)
        SpeedData.Enabled = enabled
        if enabled then
            repeat task.wait() until Functions.IsAlive(lp)
            SpeedData.OldWS = lp.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed
            SpeedData.OldJumpPower = lp.Character:FindFirstChildWhichIsA("Humanoid").JumpPower
            SpeedData.OldJumpPowerToggle = lp.Character:FindFirstChildWhichIsA("Humanoid").UseJumpPower
            repeat
                if Functions.IsAlive(lp) and not SpeedData.Disable then
                    local canspeed = true
                    if lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Magnitude > 0 then
                        if SpeedData.WallCheck then
                            local prams = RaycastParams.new()
                            if SpeedData.Mode == "CFrame" or SpeedData.Mode == "TP" then
                                prams.FilterDescendantsInstances = {lp.Character}
                            else
                                prams.FilterDescendantsInstances = {ws.Terrain, lp.Character}
                            end
                            prams.FilterType = Enum.RaycastFilterType.Exclude
                            prams.IgnoreWater = true
                            local rcast = ws:Raycast(lp.Character.HumanoidRootPart.Position, lp.Character.Humanoid.MoveDirection * 5, prams)
                            if SpeedData.Mode == "TP" then
                                rcast = ws:Raycast(lp.Character.HumanoidRootPart.Position, lp.Character.Humanoid.MoveDirection * (SpeedData.Speed/10), prams)
                            end
                            if rcast then
                                canspeed = false
                            end
                        end
                        task.spawn(function()
                            if SpeedData.AutoJump then
                                if lp.Character:FindFirstChildWhichIsA("Humanoid").FloorMaterial ~= Enum.Material.Air then
                                    lp.Character:FindFirstChildWhichIsA("Humanoid").JumpPower = SpeedData.JumpPower
                                    lp.Character:FindFirstChildWhichIsA("Humanoid").UseJumpPower = true
                                    lp.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                                end
                            end
                        end)
                        if SpeedData.Mode == "WalkSpeed" then
                            if SpeedData.Pulse then
                                for i = 0, SpeedData.PulseDuration do
                                    lp.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = SpeedData.Speed
                                    task.wait(0.01)
                                end
                                lp.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = SpeedData.OldWS
                                task.wait(SpeedData.PulseDelay/10)
                            else
                                lp.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = SpeedData.Speed
                            end
                        elseif SpeedData.Mode == "Velocity" then
                            if canspeed then
                                if SpeedData.Pulse then
                                    for i = 0, SpeedData.PulseDuration do
                                        if canspeed then
                                            lp.Character.HumanoidRootPart.Velocity = Vector3.new(lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * SpeedData.Speed, lp.Character.HumanoidRootPart.Velocity.Y, lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * SpeedData.Speed)
                                            task.wait(0.01)
                                        end
                                    end
                                    task.wait(SpeedData.PulseDelay/10)
                                else
                                    lp.Character.HumanoidRootPart.Velocity = Vector3.new(lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * SpeedData.Speed, lp.Character.HumanoidRootPart.Velocity.Y, lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * SpeedData.Speed)
                                end
                            end
                        elseif SpeedData.Mode == "CFrame" then
                            if canspeed then
                                if SpeedData.Pulse then
                                    for i = 0, SpeedData.PulseDuration do
                                        if canspeed then 
                                            lp.Character.HumanoidRootPart.CFrame += Vector3.new(lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * (SpeedData.Speed/80), 0, lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * (SpeedData.Speed/80))
                                            task.wait(0.01)
                                        end
                                    end
                                    task.wait(SpeedData.PulseDelay/10)
                                else
                                    lp.Character.HumanoidRootPart.CFrame += Vector3.new(lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * (SpeedData.Speed/80), 0, lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * (SpeedData.Speed/80))
                                end
                            end
                        elseif SpeedData.Mode == "TP" then
                            if canspeed then
                                lp.Character.HumanoidRootPart.CFrame += Vector3.new(lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * (SpeedData.Speed/10), 0, lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * (SpeedData.Speed/10))
                                task.wait(SpeedData.TPDelay/10)
                            end
                        end
                    else
                        lp.Character.HumanoidRootPart.Velocity = Vector3.new(0, lp.Character.HumanoidRootPart.Velocity.Y, 0)
                    end
                end
                task.wait()
            until not SpeedData.Enabled
        else
            if Functions.IsAlive(lp) then
                if SpeedData.OldWS then
                    lp.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = SpeedData.OldWS
                end
                if SpeedData.OldJumpPower then
                    lp.Character:FindFirstChildWhichIsA("Humanoid").JumpPower = SpeedData.OldJumpPower
                end
                if SpeedData.OldJumpPowerToggle then
                    lp.Character:FindFirstChildWhichIsA("Humanoid").UseJumpPower = SpeedData.OldJumpPowerToggle
                end
            end
        end
    end
})

SpeedModule.Functions.Settings.Slider({
    Name = "Speed",
    Description = "Change How Fast You Move",
    Min = 0,
    Max = 150,
    Default = 50,
    Decimals = 0,
    Flag = "UniversalSpeedSlider",
    Callback = function(self, value)
        SpeedData.Speed = value
    end
})

SpeedModule.Functions.Settings.Slider({
    Name = "TP Delay",
    Description = "Change How Long Each Wait After A TP is",
    Min = 0,
    Max = 100,
    Default = 3,
    Decimals = 0,
    Flag = "UniversalSpeedTPDelay",
    Callback = function(self, value)
        SpeedData.TPDelay = value
    end
})

SpeedModule.Functions.Settings.Dropdown({
    Name = "Speed Mode",
    Description = "Change Which Mode Of Speed To Use",
    Default = "Velocity",
    Options = {"WalkSpeed", "Velocity", "CFrame", "TP"},
    SelectLimit = 1,
    Flag = "UniversalSpeedMode",
    Callback = function(self, value)
        SpeedData.Mode = value
        if Functions.IsAlive(lp) then
            if SpeedData.OldWS then
                lp.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = SpeedData.OldWS
            end
            if SpeedData.OldJumpPowerToggle then
                lp.Character:FindFirstChildWhichIsA("Humanoid").UseJumpPower = SpeedData.OldJumpPowerToggle
            end
            task.spawn(function()
                repeat task.wait() until SpeedModule.Settings.UniversalSpeedWallCheck
                if value == "WalkSpeed" then
                    SpeedModule.Settings.UniversalSpeedWallCheck.Functions.SetVisiblity(false)
                else
                    SpeedModule.Settings.UniversalSpeedWallCheck.Functions.SetVisiblity(true)
                end
                repeat task.wait() until #SpeedData.PulseInstances == 3 
                if value == "TP" then
                    if SpeedModule and SpeedModule.Settings then
                        repeat task.wait() until SpeedModule and SpeedModule.Settings and SpeedModule.Settings.UniversalSpeedTPDelay
                        if SpeedModule.Settings.UniversalSpeedTPDelay then
                            SpeedModule.Settings.UniversalSpeedTPDelay.Functions.SetVisiblity(true)
                        else
                            return
                        end
                    else
                        return
                    end

                    repeat task.wait() until SpeedModule.Settings.UniversalSpeedPulseToggle
                    SpeedModule.Settings.UniversalSpeedPulseToggle.Functions.SetVisiblity(false)
                    for i,v in SpeedData.PulseInstances do
                        v.Functions.SetVisiblity(false)
                    end
                else
                    if SpeedModule and SpeedModule.Settings then
                        repeat task.wait() until SpeedModule and SpeedModule.Settings and SpeedModule.Settings.UniversalSpeedTPDelay
                        if SpeedModule.Settings.UniversalSpeedTPDelay then
                            SpeedModule.Settings.UniversalSpeedTPDelay.Functions.SetVisiblity(false)
                        else
                            return
                        end
                    else
                        return
                    end
                    SpeedModule.Settings.UniversalSpeedPulseToggle.Functions.SetVisiblity(true)
                    if SpeedModule.Settings.UniversalSpeedPulseToggle.Enabled then
                        for i,v in SpeedData.PulseInstances do
                            v.Functions.SetVisiblity(true)
                        end
                    else
                        for i,v in SpeedData.PulseInstances do
                            v.Functions.SetVisiblity(false)
                        end
                        SpeedModule.Settings.UniversalSpeedPulseToggle.Functions.SetVisiblity(true)
                    end
                end
            end)
        end
    end
})

SpeedModule.Functions.Settings.MiniToggle({
    Name = "Wall Check",
    Description = "Stops You From Going Through Walls",
    Default = true,
    Flag = "UniversalSpeedWallCheck",
    Callback = function(self, enabled)
        SpeedData.WallCheck = enabled
    end
})

SpeedModule.Functions.Settings.MiniToggle({
    Name = "Auto Jump",
    Description = "Automatically Jumps",
    Flag = "UniversalSpeedAutoJump",
    Callback = function(self, enabled)
        SpeedData.AutoJump = enabled
        task.spawn(function()
            repeat task.wait() until SpeedModule.Settings.UniversalSpeedJumpPower
            if enabled then
                SpeedModule.Settings.UniversalSpeedJumpPower.Functions.SetVisiblity(true)
            else
                SpeedModule.Settings.UniversalSpeedJumpPower.Functions.SetVisiblity(false)
                if Functions.IsAlive(lp) then
                    lp.Character:FindFirstChildWhichIsA("Humanoid").JumpPower = SpeedData.JumpPower
                end
            end
        end)
    end
})

SpeedModule.Functions.Settings.Slider({
    Name = "Jump Power",
    Description = "Change How High You Jump",
    Min = 0,
    Max = 150,
    Default = 50,
    Decimals = 0,
    Flag = "UniversalSpeedJumpPower",
    Callback = function(self, value)
        SpeedData.JumpPower = value
    end
})

table.insert(SpeedData.PulseInstances, SpeedModule.Functions.Settings.MiniToggle({
    Name = "Pulse",
    Description = "Mini Speed Ups",
    Default = false,
    Flag = "UniversalSpeedPulseToggle",
    Callback = function(self, enabled)
        SpeedData.Pulse = enabled
        task.spawn(function()
            repeat task.wait() until SpeedModule.Settings.UniversalSpeedPulseDelay
            if enabled then
                for i,v in SpeedData.PulseInstances do
                    if v ~= self then
                        v.Functions.SetVisiblity(true)
                    end
                end
            else
                for i,v in SpeedData.PulseInstances do
                    if v ~= self then
                        v.Functions.SetVisiblity(false)
                    end
                end
            end
        end)
    end
}))

table.insert(SpeedData.PulseInstances, SpeedModule.Functions.Settings.Slider({
    Name = "Pulse Delay",
    Description = "Delay For A Speed Up",
    Min = 0,
    Max = 150,
    Default = 20,
    Decimals = 0,
    Flag = "UniversalSpeedPulseDelay",
    Callback = function(self, value)
        SpeedData.PulseDelay = value
    end
}))

table.insert(SpeedData.PulseInstances, SpeedModule.Functions.Settings.Slider({
    Name = "Pulse Duration",
    Description = "How Long Speed Ups Last",
    Min = 0,
    Max = 150,
    Default = 15,
    Decimals = 0,
    Flag = "UniversalSpeedPulseDuration",
    Callback = function(self, value)
        SpeedData.PulseDuration = value
    end
}))

local FlyData = {
    Enabled = false,
    Modes = {Fly = "Velocity", Speed = "Velocity"},
    CurrentValue = nil,
    KeyValues = {
        Up = "Space",
        Down = "LeftControl"
    },
    FlySpeeds = {Vertical = 40},
    Data = {Up = false, Down = false, CanBounce = false},
    SpeedData = {
        Pulse = false,
        PulseDuration = 15,
        PulseDelay = 20,
        Speed = 50,
        TPDelay = 3,
        OldWS = nil,
        CanPulse = false,
        CanTP = false,
        PulseInstances = {}
    },
    Connections = {}
}

local FlyModule = tabs.Movement.Functions.NewModule({
    Name = "Fly",
    Description = "Edit local character flight settings",
    Icon = "rbxassetid://131835120840758",
    Flag = "UniversalFlyModule",
    Callback = function(self, enabled)
        FlyData.Enabled = enabled
        if FlyData.Enabled then
            repeat 
                if Functions.IsAlive(lp) then
                    SpeedData.Disable = true
                
                    if FlyData.Modes.Fly == "Velocity" then
                        FlyData.CurrentValue = lp.Character.HumanoidRootPart:GetMass()/1.67
                        if FlyData.Data.Up then
                            FlyData.CurrentValue += (FlyData.FlySpeeds.Vertical)
                        elseif FlyData.Data.Down then
                            FlyData.CurrentValue -= (FlyData.FlySpeeds.Vertical)
                        end
                        lp.Character.HumanoidRootPart.Velocity = Vector3.new(lp.Character.HumanoidRootPart.Velocity.X, FlyData.CurrentValue, lp.Character.HumanoidRootPart.Velocity.Z)
                    elseif FlyData.Modes.Fly == "Bounce" then
                        FlyData.CurrentValue = lp.Character.HumanoidRootPart:GetMass() * 10
                        if FlyData.Data.Up then
                            FlyData.CurrentValue += (FlyData.FlySpeeds.Vertical/1.5)
                        elseif FlyData.Data.Down then
                            FlyData.CurrentValue -= (FlyData.FlySpeeds.Vertical*3)
                        end
                        if FlyData.Data.CanBounce then
                            lp.Character.HumanoidRootPart.Velocity = Vector3.new(0, FlyData.CurrentValue, 0)
                            FlyData.Data.CanBounce = false
                            task.delay(FlyData.CurrentValue/100.4, function()
                                FlyData.Data.CanBounce = true
                            end)
                        else
                            if FlyData.Data.Up or FlyData.Data.Down then
                                lp.Character.HumanoidRootPart.Velocity = Vector3.new(0, FlyData.CurrentValue, 0)
                            end
                        end
                    end

                    task.spawn(function()
                        if lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Magnitude > 0 then
                            if FlyData.Modes.Speed == "WalkSpeed" then
                                if SpeedData.OldWS then
                                    FlyData.SpeedData.OldWS = SpeedData.OldWS
                                else
                                    FlyData.SpeedData.OldWS = lp.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed
                                end

                            if FlyData.SpeedData.Pulse then
                                if FlyData.SpeedData.CanPulse then
                                    for i = 0, FlyData.SpeedData.PulseDuration do
                                        lp.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = FlyData.SpeedData.Speed
                                        task.wait(0.01)
                                    end
                                    lp.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = FlyData.SpeedData.OldWS
                                    FlyData.SpeedData.CanPulse = false
                                    task.delay(FlyData.SpeedData.PulseDelay/10, function()
                                        FlyData.SpeedData.CanPulse = true
                                    end)
                                end
                            else
                                lp.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = FlyData.SpeedData.OldWS
                            end
                            elseif FlyData.Modes.Speed == "Velocity" then
                                if FlyData.SpeedData.Pulse then
                                    if FlyData.SpeedData.CanPulse then
                                        for i = 0, FlyData.SpeedData.PulseDuration do
                                            lp.Character.HumanoidRootPart.Velocity = Vector3.new(lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * FlyData.SpeedData.Speed, lp.Character.HumanoidRootPart.Velocity.Y, lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * FlyData.SpeedData.Speed)
                                            task.wait(0.01)
                                        end
                                        FlyData.SpeedData.CanPulse = false
                                        task.delay(FlyData.SpeedData.PulseDelay/10, function()
                                            FlyData.SpeedData.CanPulse = true
                                        end)
                                    end
                                else
                                    lp.Character.HumanoidRootPart.Velocity = Vector3.new(lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * FlyData.SpeedData.Speed, lp.Character.HumanoidRootPart.Velocity.Y, lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * FlyData.SpeedData.Speed)
                                end
                            elseif FlyData.Modes.Speed == "CFrame" then
                                if FlyData.SpeedData.Pulse then
                                    if FlyData.SpeedData.CanPulse then
                                        for i = 0, FlyData.SpeedData.PulseDuration do
                                            lp.Character.HumanoidRootPart.CFrame += Vector3.new(lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * (FlyData.SpeedData.Speed/80), 0, lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * (FlyData.SpeedData.Speed/80))
                                            task.wait(0.01)
                                        end
                                        FlyData.SpeedData.CanPulse = false
                                        task.delay(FlyData.SpeedData.PulseDelay/10, function()
                                            FlyData.SpeedData.CanPulse = true
                                        end)
                                    end
                                else
                                    lp.Character.HumanoidRootPart.CFrame += Vector3.new(lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * (FlyData.SpeedData.Speed/80), 0, lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * (FlyData.SpeedData.Speed/80))
                                end
                            elseif FlyData.Modes.Speed == "TP" then
                                if FlyData.SpeedData.CanTP then
                                    lp.Character.HumanoidRootPart.CFrame += Vector3.new(lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * (FlyData.SpeedData.Speed/10), 0, lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * (FlyData.SpeedData.Speed/10))
                                    FlyData.SpeedData.CanTP = false
                                    task.delay(FlyData.SpeedData.TPDelay/10, function()
                                        FlyData.SpeedData.CanTP = true
                                    end)
                                end
                            end
                        else
                            lp.Character.HumanoidRootPart.Velocity = Vector3.new(0, lp.Character.HumanoidRootPart.Velocity.Y, 0)
                        end
                    end)
                end
                task.wait(0.001)
            until not FlyData.Enabled
        else
            FlyData.Data.Up = false
            FlyData.Data.Down = false
            SpeedData.Disable = false
            if Functions.IsAlive(lp) and FlyData.SpeedData.OldWS then
                lp.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = FlyData.SpeedData.OldWS
            end
        end
    end
})


FlyModule.Functions.Settings.Slider({
    Name = "Fly Speed",
    Description = "Change How Fast You Fly",
    Min = 0,
    Max = 150,
    Default = 50,
    Decimals = 0,
    Flag = "UniversalFlySpeedSlider",
    Callback = function(self, value)
        FlyData.SpeedData.Speed = value
    end
})

FlyModule.Functions.Settings.Slider({
    Name = "Vertical Speed",
    Description = "Change How Fast Your Move Up And Down",
    Min = 0,
    Max = 150,
    Default = 40,
    Decimals = 0,
    Flag = "UniversalFlyVerticalSpeedSlider",
    Callback = function(self, value)
        FlyData.FlySpeeds.Vertical = value
    end
})

FlyModule.Functions.Settings.Slider({
    Name = "TP Delay",
    Description = "Change How Long Each Wait After A TP is",
    Min = 0,
    Max = 100,
    Default = 3,
    Decimals = 0,
    Flag = "UniversalFlySpeedTPDelay",
    Callback = function(self, value)
        FlyData.SpeedData.TPDelay = value
    end
})

FlyModule.Functions.Settings.Dropdown({
    Name = "Fly Mode",
    Description = "Change Which Mode Of Flight To Use",
    Default = "Velocity",
    Options = {"Velocity", "Bounce"},
    SelectLimit = 1,
    Flag = "UniversalFlyMode",
    Callback = function(self, value)
        FlyData.Modes.Fly = value
    end
})

FlyModule.Functions.Settings.Dropdown({
    Name = "Fly Speed Mode",
    Description = "Change Which Mode Of Speed To Use",
    Default = "Velocity",
    Options = {"WalkSpeed", "Velocity", "CFrame", "TP"},
    SelectLimit = 1,
    Flag = "UniversalFlySpeedMode",
    Callback = function(self, value)
        FlyData.Modes.Speed = value
        if Functions.IsAlive(lp) then
            if FlyData.SpeedData.OldWS then
                lp.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = FlyData.SpeedData.OldWS
            end
            task.spawn(function()
                repeat task.wait() until #FlyData.SpeedData.PulseInstances == 3
                if value == "TP" then
                    FlyModule.Settings.UniversalFlySpeedTPDelay.Functions.SetVisiblity(true)
                    repeat task.wait() until FlyModule.Settings.UniversalFlySpeedPulseToggle
                    FlyModule.Settings.UniversalFlySpeedPulseToggle.Functions.SetVisiblity(false)
                    for i,v in FlyData.SpeedData.PulseInstances do
                        v.Functions.SetVisiblity(false)
                    end
                else
                    FlyModule.Settings.UniversalFlySpeedTPDelay.Functions.SetVisiblity(false)
                    FlyModule.Settings.UniversalFlySpeedPulseToggle.Functions.SetVisiblity(true)
                    if FlyModule.Settings.UniversalFlySpeedPulseToggle.Enabled then
                        for i,v in FlyData.SpeedData.PulseInstances do
                            v.Functions.SetVisiblity(true)
                        end
                    else
                        for i,v in FlyData.SpeedData.PulseInstances do
                            v.Functions.SetVisiblity(false)
                        end
                        FlyModule.Settings.UniversalFlySpeedPulseToggle.Functions.SetVisiblity(true)
                    end
                end
            end)
        end
    end
})

table.insert(FlyData.SpeedData.PulseInstances, FlyModule.Functions.Settings.MiniToggle({
    Name = "Pulse",
    Description = "Mini Speed Ups",
    Default = false,
    Flag = "UniversalFlySpeedPulseToggle",
    Callback = function(self, enabled)
        FlyData.SpeedData.Pulse = enabled
        task.spawn(function()
            repeat task.wait() until FlyModule.Settings.UniversalFlySpeedPulseDelay
            if enabled then
                for i,v in FlyData.SpeedData.PulseInstances do
                    if v ~= self then
                        v.Functions.SetVisiblity(true)
                    end
                end
            else
                for i,v in FlyData.SpeedData.PulseInstances do
                    if v ~= self then
                        v.Functions.SetVisiblity(false)
                    end
                end
            end
        end)
    end
}))

table.insert(FlyData.SpeedData.PulseInstances, FlyModule.Functions.Settings.Slider({
    Name = "Pulse Delay",
    Description = "Delay For A Speed Up",
    Min = 0,
    Max = 150,
    Default = 20,
    Decimals = 0,
    Flag = "UniversalFlySpeedPulseDelay",
    Callback = function(self, value)
        FlyData.SpeedData.PulseDelay = value
    end
}))

table.insert(FlyData.SpeedData.PulseInstances, FlyModule.Functions.Settings.Slider({
    Name = "Pulse Duration",
    Description = "How Long Speed Ups Last",
    Min = 0,
    Max = 150,
    Default = 15,
    Decimals = 0,
    Flag = "UniversalFlySpeedPulseDuration",
    Callback = function(self, value)
        FlyData.SpeedData.PulseDuration = value
    end
}))

FlyModule.Functions.Settings.Keybind({
    Name = "Set Fly Up Keybind",
    Description = "Which Keybind Will Make You Move Up",
    Default = "Space",
    Mobile = {Text = "Fly Up", Default = true, Visible = false},
    Flag = "UniversalFlySetUpKeybind",
    Callbacks = {
        Began = function()
            FlyData.Data.Up = true
            FlyData.Data.Down = false
        end,
        End = function()
            FlyData.Data.Up = false
        end
    }
})

FlyModule.Functions.Settings.Keybind({
    Name = "Set Fly Down Keybind",
    Description = "Which Keybind Will Make You Move Down",
    Default = "LeftControl",
    Mobile = {Text = "Fly Down", Default = true, Visible = false},
    Flag = "UniversalFlySetDownKeybind",
    Callbacks = {
        Began = function()
            FlyData.Data.Down = true
            FlyData.Data.Up = false
        end,
        End = function()
            FlyData.Data.Down = false
        end
    }
})


local ShaderData = {
    Enabled = false,
    OldLighting = {},
    ShaderInstances = {}
}

tabs.Render.Functions.NewModule({
    Name = "Shader",
    Description = "Apply custom lighting shader to the game",
    Icon = "rbxassetid://137880047383411",
    Flag = "UniversalShaderModule",
    Callback = function(self, enabled)
        ShaderData.Enabled = enabled

        if enabled then
            for _, prop in pairs({"Ambient", "ClockTime", "GeographicLatitude", "Brightness", 
                "ColorShift_Bottom", "ColorShift_Top", "EnvironmentDiffuseScale", 
                "EnvironmentSpecularScale", "GlobalShadows", "OutdoorAmbient", 
                "ExposureCompensation", "FogEnd", "FogStart", "FogColor"}) do
                ShaderData.OldLighting[prop] = lighting[prop]
            end
            
            for _, obj in pairs(lighting:GetChildren()) do
                if obj:IsA("Atmosphere") or obj:IsA("Sky") or obj:IsA("ColorCorrectionEffect") then
                    table.insert(ShaderData.OldLighting, obj:Clone())
                    obj:Destroy()
                end
            end
            
            local game = Functions.cloneref(game)
            local services = {
                Lighting = Functions.cloneref(game:GetService("Lighting"))
            }
            
            local createInstance = function(className, properties)
                local instance = services.Lighting:FindFirstChildOfClass(className) or Instance.new(className)
                instance.Parent = services.Lighting
                for prop, value in pairs(properties) do 
                    instance[prop] = value 
                end
                table.insert(ShaderData.ShaderInstances, instance)
                return instance
            end
            
            createInstance("ColorCorrectionEffect", {
                Brightness = 0,
                Contrast = 0,
                Saturation = -0.3,
                TintColor = Color3.fromRGB(255,255,255),
                Enabled = true
            })
            
            createInstance("Atmosphere", {
                Density = 0.296,
                Offset = 0,
                Color = Color3.fromRGB(199,170,107),
                Decay = Color3.fromRGB(92,60,13),
                Glare = 0,
                Haze = 0
            })
            
            createInstance("Sky", {
                SkyboxBk = "http://www.roblox.com/asset/?id=245972325",
                SkyboxDn = "http://www.roblox.com/asset/?id=245972441",
                SkyboxFt = "http://www.roblox.com/asset/?id=245972389",
                SkyboxLf = "http://www.roblox.com/asset/?id=245972361",
                SkyboxRt = "http://www.roblox.com/asset/?id=245972302",
                SkyboxUp = "http://www.roblox.com/asset/?id=245972410",
                CelestialBodiesShown = false,
                SunAngularSize = 0,
                MoonAngularSize = 0
            })
            
            local properties = {
                Ambient=Color3.fromRGB(44,33,19),
                ClockTime=7.3,
                GeographicLatitude=41.7333,
                Brightness=1.1,
                ColorShift_Bottom=Color3.fromRGB(0,0,0),
                ColorShift_Top=Color3.fromRGB(0,0,0),
                EnvironmentDiffuseScale=0.1,
                EnvironmentSpecularScale=0,
                GlobalShadows=true,
                OutdoorAmbient=Color3.fromRGB(115,115,115),
                ExposureCompensation=-0.8,
                FogEnd=600,
                FogStart=20,
                FogColor=Color3.fromRGB(93,93,93)
            }
            
            for prop, value in pairs(properties) do
                lighting[prop] = value
            end
        else
            for prop, value in pairs(ShaderData.OldLighting) do
                if typeof(value) == "Instance" then
                    value:Clone().Parent = lighting
                else
                    lighting[prop] = value
                end
            end
            
            for _, instance in pairs(ShaderData.ShaderInstances) do
                instance:Destroy()
            end
            ShaderData.ShaderInstances = {}
            ShaderData.OldLighting = {}
        end
    end
})

local AimbotData = {
    Enabled = false,
    FovCircle = {enabled = false, instance = nil, Size = 90, color = Color3.fromRGB(255,0,0), thickness = 2},
    TriggerDistance = {Use = false, dist = 50},
    TeamCheck = false,
    AimPart = "Head",
    WallCheck = false,
    Smoothness = 0,
    MadeCircle = false,
    Tween = nil,
    Settings = {Fov = {}, TriggerDist = {}},
    Data = {aimpart = nil, Delta = 0},
    Connections = {}
}

local aimbotmodule = tabs.Combat.Functions.NewModule({
    Name = "Aimbot",
    Description = "Automatically locks onto nearby players.",
    Icon = "rbxassetid://84665607455807",
    Flag = "UniversalAimbotModule",
    Callback = function(self, enabled)
        AimbotData.Enabled = enabled
        if enabled then
            if ws.CurrentCamera then
                table.insert(AimbotData.Connections, ws.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function()
                    if AimbotData.Data.aimpart then
                        if AimbotData.Smoothness <= 0 then
                            ws.CurrentCamera.CFrame = CFrame.new(ws.CurrentCamera.CFrame.Position, AimbotData.Data.aimpart.CFrame.Position)
                        else
                            ws.CurrentCamera.CFrame = ws.CurrentCamera.CFrame:Lerp(CFrame.new(ws.CurrentCamera.CFrame.Position, AimbotData.Data.aimpart.CFrame.Position), AimbotData.Smoothness * AimbotData.Data.Delta)
                        end
                    end
                end))

                table.insert(AimbotData.Connections, rs.Heartbeat:Connect(function(delta)
                    AimbotData.Data.Delta = delta
                    if Drawing then
                        if AimbotData.FovCircle.enabled then
                            local vec = Vector2.new(0,0)
                            if lp:GetMouse() and ws.CurrentCamera then
                                local pos = ws.CurrentCamera:WorldToScreenPoint(lp:GetMouse().Hit.Position)
                                if pos then
                                    vec = Vector2.new(pos.X, pos.Y+(AimbotData.FovCircle.Size/2))
                                end
                            end
                            if not AimbotData.FovCircle.instance then
                                if not AimbotData.MadeCircle then
                                    AimbotData.MadeCircle = true

                                    AimbotData.FovCircle.instance = Drawing.new("Circle")
                                    AimbotData.FovCircle.instance.Radius = AimbotData.FovCircle.Size
                                    AimbotData.FovCircle.instance.Color = AimbotData.FovCircle.color
                                    AimbotData.FovCircle.instance.Filled = false
                                    AimbotData.FovCircle.instance.Thickness = AimbotData.FovCircle.thickness
                                    AimbotData.FovCircle.instance.Position = vec
                                    AimbotData.FovCircle.instance.Visible = true
                                end
                            else
                                AimbotData.FovCircle.instance.Position = vec
                            end
                        end
                    end

                    local targetplr, targetdist = nil, nil
                    local exclude = {}
                    if not AimbotData.FovCircle.enabled then
                        targetplr, targetdist = Functions.GetNearestPlr(lp, AimbotData.TeamCheck)
                    else
                        local Data = Functions.GetNearestPlrToMouse({
                            Team = AimbotData.TeamCheck,
                            Limit = (AimbotData.FovCircle.Size),
                            Exclude = {lp}
                        })
                        if Data and Data.Player then
                            targetplr = Data.Player 
                            targetdist = Data.Distance
                        else
                            targetplr = nil
                            targetdist = nil
                        end
                    end

                    if targetplr and ws.CurrentCamera then
                        if AimbotData.TriggerDistance.Use and targetdist and targetdist <= AimbotData.TriggerDistance.dist or not AimbotData.TriggerDistance.Use then
                            if AimbotData.AimPart == "Head" then
                                if targetplr.Character.Head then
                                    AimbotData.Data.aimpart = targetplr.Character.Head
                                end
                            elseif AimbotData.AimPart == "Torso" then
                                AimbotData.Data.aimpart = targetplr.Character.HumanoidRootPart
                            else
                                if targetplr.Character[AimbotData.AimPart] then
                                    AimbotData.Data.aimpart = targetplr.Character[AimbotData.AimPart]
                                end
                            end
                            if AimbotData.Data.aimpart then
                                if AimbotData.WallCheck then
                                    for i,v in plrs:GetPlayers() do
                                        table.insert(exclude, v.Character)
                                    end
                                    
                                    local prams = RaycastParams.new()
                                    prams.IgnoreWater = true
                                    prams.FilterDescendantsInstances = exclude
                                    prams.FilterType = Enum.RaycastFilterType.Exclude

                                    local rcast: RaycastResult = ws:Raycast(AimbotData.Data.aimpart.CFrame.Position, lp.character.HumanoidRootPart.Position - AimbotData.Data.aimpart.CFrame.Position, prams)
                                    if rcast and rcast.Instance then
                                        targetplr = nil
                                        AimbotData.Data.aimpart = nil
                                    end

                                end
                            end
                        end
                    end
                    

                end))
            end

        else
            if AimbotData.Tween then
                AimbotData.Tween:Cancel()
                AimbotData.Tween = nil
            end
            AimbotData.MadeCircle = false
            if AimbotData.FovCircle.instance then
                AimbotData.FovCircle.instance:Destroy()
                AimbotData.FovCircle.instance = nil
            end
            for i,v in AimbotData.Connections do
                v:Disconnect()
            end
            table.clear(AimbotData.Connections)
        end
    end
})

aimbotmodule.Functions.Settings.MiniToggle({
    Name = "Wall Check",
    Description = "Wont Lock Onto Players Behind a Wall.",
    Default = true,
    Flag = "AimbotWallCheck",
    Callback = function(self, call)
        AimbotData.WallCheck = call
    end
})

aimbotmodule.Functions.Settings.MiniToggle({
    Name = "Team Check",
    Description = "Only targets a player if they are NOT on your team.",
    Default = true,
    Flag = "AimbotTeamCheckToggle",
    Callback = function(self, call)
        AimbotData.TeamCheck = call
    end
})

aimbotmodule.Functions.Settings.Slider({
    Name = "Smoothness",
    Description = "How fast the camera moves to the player in seconds.",
    Min = 0,
    Max = 10,
    Default = 0,
    Decimals = 1,
    Flag = "AimbotSmoothnessSlider",
    Callback = function(self, value)
        AimbotData.Smoothness = value
    end
})

local options = {"Torso", "Head", "Left Leg", "Right Leg"}
if lp.Character then
    options = {}
    for i,v in lp.Character:GetChildren() do
        if v:IsA("Part") or v:IsA("MeshPart") then
            table.insert(options, v.Name)
        end
    end
end
aimbotmodule.Functions.Settings.Dropdown({
    Name = "Aim Part",
    Description = "Which Part You Will Lock Onto.",
    Default = options[1],
    Options = options,
    SelectLimit = 1,
    Flag = "AimbotAimPart",
    Callback = function(self, value)
        AimbotData.AimPart = value
    end
})

aimbotmodule.Functions.Settings.MiniToggle({
    Name = "Fov Circle",
    Description = "Only aims at a player if they are in your circle.",
    Default = true,
    Flag = "FovCircleToggle",
    Callback = function(self, call)
        AimbotData.FovCircle.enabled = call
        if call then
            if #AimbotData.Settings.Fov ~= 3 then
                task.spawn(function()
                    repeat task.wait() until #AimbotData.Settings.Fov == 3
                    for i,v in AimbotData.Settings.Fov do
                        v.Functions.SetVisiblity(true)
                    end
                end)
            else
                for i,v in AimbotData.Settings.Fov do
                    v.Functions.SetVisiblity(true)
                end
            end
        else
            if AimbotData.FovCircle.instance then
                AimbotData.FovCircle.instance:Destroy()
                AimbotData.FovCircle.instance = nil
            end
            if #AimbotData.Settings.Fov ~= 3 then
                task.spawn(function()
                    repeat task.wait() until #AimbotData.Settings.Fov == 3
                    for i,v in AimbotData.Settings.Fov do
                        v.Functions.SetVisiblity(false)
                    end
                end)
            else
                for i,v in AimbotData.Settings.Fov do
                    v.Functions.SetVisiblity(false)
                end
            end
        end
    end
})

table.insert(AimbotData.Settings.Fov, aimbotmodule.Functions.Settings.Slider({
    Name = "Fov Size",
    Description = "Changes the size of your fov circle.",
    Min = 0,
    Max = 360,
    Default = 90,
    Decimals = 0,
    Flag = "AimbotFovSizeSlider",
    Callback = function(self, value)
        AimbotData.FovCircle.Size = value
        if AimbotData.FovCircle.instance then
            AimbotData.FovCircle.instance.Radius = value
        end
    end
}))

table.insert(AimbotData.Settings.Fov, aimbotmodule.Functions.Settings.Slider({
    Name = "Fov Thickness",
    Description = "Changes the thickness of your fov circle.",
    Min = 0,
    Max = 12,
    Default = 2,
    Decimals = 0,
    Flag = "AimbotFovThickness",
    Callback = function(self, value)
        AimbotData.FovCircle.thickness = value
        if AimbotData.FovCircle.instance then
            AimbotData.FovCircle.instance.Thickness = value
        end
    end
}))

table.insert(AimbotData.Settings.Fov, aimbotmodule.Functions.Settings.TextBox({
    Name = "Fov Circle Color",
    Flag = "AimbotFovCircleColor",
    Description = "Changes the color of your fov circle.",
    Default = "255, 0, 0",
    Callback = function(self, value)
        local split = string.split(value, ",")
        if #split == 3 then
            local v1, v2, v3 = split[1]:gsub(" ", ""), split[2]:gsub(" ", ""), split[3]:gsub(" ", "")
            if tonumber(v1) and tonumber(v2) and tonumber(v3) then
                AimbotData.FovCircle.color = Color3.fromRGB(tonumber(v1), tonumber(v2), tonumber(v3))
                if AimbotData.FovCircle.instance then
                    AimbotData.FovCircle.instance.Color = Color3.fromRGB(tonumber(v1), tonumber(v2), tonumber(v3))
                end
            end
        end
    end
}))

aimbotmodule.Functions.Settings.MiniToggle({
    Name = "Trigger Distance",
    Description = "Only aims at a player if they are in a specifc distance.",
    Default = false,
    Flag = "AimbotTriggerDistToggle",
    Callback = function(self, call)
        AimbotData.TriggerDistance.Use = call
        if call then
            if #AimbotData.Settings.TriggerDist ~= 2 then
                task.spawn(function()
                    repeat task.wait() until #AimbotData.Settings.TriggerDist == 2
                    for i,v in AimbotData.Settings.TriggerDist do
                        v.Functions.SetVisiblity(true)
                    end
                end)
            else
                for i,v in AimbotData.Settings.TriggerDist do
                    v.Functions.SetVisiblity(true)
                end
            end
        else
            if #AimbotData.Settings.TriggerDist ~= 2 then
                task.spawn(function()
                    repeat task.wait() until #AimbotData.Settings.TriggerDist == 2
                    for i,v in AimbotData.Settings.TriggerDist do
                        v.Functions.SetVisiblity(false)
                    end
                end)
            else
                for i,v in AimbotData.Settings.TriggerDist do
                    v.Functions.SetVisiblity(false)
                end
            end
        end
    end
})

table.insert(AimbotData.Settings.TriggerDist, aimbotmodule.Functions.Settings.Slider({
    Name = "Trigger Distance",
    Description = "Changes the distance for the trigger.",
    Min = 0,
    Max = 600,
    Default = 50,
    Decimals = 0,
    Flag = "AimbotTriggerDistSlider",
    Callback = function(self, value)
        AimbotData.TriggerDistance.dist = value
    end
}))

local NameTagData = {
    Enabled = false,
    Connections = {},
    Mode = "DisplayName",
    Instances = {},
    TeamCheck = false
}

local nametagplr = function(v: Player, user: string)
    if not v or not Functions.IsAlive(v) then 
        repeat task.wait() until v and Functions.IsAlive(v) or not v
        if not v then return end
    end

    local char = v.Character

    NameTagData.Instances[v] = Instance.new("BillboardGui", char.HumanoidRootPart)
    NameTagData.Instances[v].Size = UDim2.fromOffset(320, 50)
    NameTagData.Instances[v].StudsOffset = Vector3.new(0, 3.2, 0)
    NameTagData.Instances[v].AlwaysOnTop = true
    NameTagData.Instances[v].ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local nametagframe = Instance.new("Frame", NameTagData.Instances[v])
    nametagframe.AnchorPoint = Vector2.new(0.5, 0.5)
    nametagframe.AutomaticSize = Enum.AutomaticSize.X
    nametagframe.BackgroundColor3 = Color3.fromRGB(0,0,0)
    nametagframe.BackgroundTransparency = 0.55
    nametagframe.Position = UDim2.fromScale(0.5, 0.5)
    nametagframe.Size = UDim2.fromOffset(0, 23)
    Instance.new("UICorner", nametagframe)

    local layout = Instance.new("UIListLayout", nametagframe)
    layout.Padding = UDim.new(0, 1)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local padding = Instance.new("UIPadding", nametagframe)
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingRight = UDim.new(0, 4)

    local health = Instance.new("Frame", nametagframe)
    health.AutomaticSize = Enum.AutomaticSize.X
    health.BackgroundTransparency = 1
    health.LayoutOrder = 1
    health.Size = UDim2.fromScale(0, 1)
    
    local hearthealth = Instance.new("ImageLabel", health)
    hearthealth.AnchorPoint = Vector2.new(1, 0.5)
    hearthealth.BackgroundTransparency = 1
    hearthealth.LayoutOrder = 1
    hearthealth.Position = UDim2.fromScale(1, 0.5)
    hearthealth.Size = UDim2.fromOffset(20, 20)
    hearthealth.Image = "rbxassetid://14595054463"
    hearthealth.ImageColor3 = Color3.fromRGB(250, 84, 99)

    local healthvalue = Instance.new("TextLabel", health)
    healthvalue.Font = Enum.Font.Gotham
    healthvalue.AutomaticSize = Enum.AutomaticSize.XY
    healthvalue.FontFace.Weight = Enum.FontWeight.Medium
    healthvalue.LineHeight = 1
    healthvalue.TextColor3 = Color3.fromRGB(250, 84, 99)
    healthvalue.MaxVisibleGraphemes = -1
    healthvalue.TextDirection = Enum.TextDirection.Auto
    healthvalue.TextSize = 14
    healthvalue.TextStrokeTransparency = 1
    healthvalue.TextXAlignment = Enum.TextXAlignment.Center
    healthvalue.TextYAlignment = Enum.TextYAlignment.Center
    healthvalue.BackgroundTransparency = 1
    healthvalue.Size = UDim2.new(0,0,1,0)

    local healthval = tostring(char:FindFirstChild("Humanoid").Health)
    if char:GetAttribute("Health") then
        healthval = tostring(char:GetAttribute("Health"))
    end
    healthvalue.Text = healthval or "0"

    local healthvaluepad = Instance.new("UIPadding", healthvalue)
    healthvaluepad.PaddingRight = UDim.new(0, 20)
    healthvaluepad.PaddingLeft = UDim.new(0, 2)

    local mag = Instance.new("Frame", nametagframe)
    mag.AutomaticSize = Enum.AutomaticSize.X
    mag.BackgroundTransparency = 1
    mag.LayoutOrder = 3
    mag.Size = UDim2.fromOffset(0, 1)

    local magvalue = Instance.new("TextLabel", mag)
    magvalue.AutomaticSize = Enum.AutomaticSize.X
    magvalue.BackgroundTransparency = 1
    magvalue.Size = UDim2.fromOffset(0, 1)
    magvalue.Font = Enum.Font.Gotham
    magvalue.FontFace.Weight = Enum.FontWeight.Medium
    magvalue.TextColor3 = Color3.fromRGB(170, 167, 174)
    magvalue.TextSize = 14
    magvalue.LineHeight = 1
    magvalue.MaxVisibleGraphemes = -1
    magvalue.TextStrokeTransparency = 1
    magvalue.Text = math.round(lp:DistanceFromCharacter(char.HumanoidRootPart.Position)).."m" or "nil"
    
    local magpad = Instance.new("UIPadding", magvalue)
    magpad.PaddingLeft = UDim.new(0,2)

    local player = Instance.new("Frame", nametagframe)
    player.AutomaticSize = Enum.AutomaticSize.X
    player.BackgroundTransparency = 1
    player.LayoutOrder = 2
    player.Size = UDim2.fromOffset(0, 1)

    local playername = Instance.new("TextLabel", player)
    playername.AutomaticSize = Enum.AutomaticSize.X
    playername.BackgroundTransparency = 1
    playername.Size = UDim2.fromOffset(0,1)
    playername.Font = Enum.Font.Gotham
    playername.FontFace.Weight = Enum.FontWeight.Medium
    playername.TextColor3 = Color3.fromRGB(255, 255, 255)
    playername.TextSize = 14
    playername.LineHeight = 1
    playername.MaxVisibleGraphemes = -1
    playername.TextStrokeTransparency = 1
    playername.Text = user

    local plrnamepad = Instance.new("UIPadding")
    plrnamepad.PaddingLeft = UDim.new(0,7)
    plrnamepad.PaddingRight = UDim.new(0,7)

    NameTagData.Connections[v] = {}

    task.spawn(function()
        repeat 
            if v then
                if v.Team == lp.Team and NameTagData.TeamCheck then
                    for i,v in NameTagData.Connections[v] do
                        v:Disconnect()
                    end
                    table.clear(NameTagData.Connections[v])
                    NameTagData.Connections[v] = nil
        
                    if NameTagData.Instances[v] then
                        NameTagData.Instances[v]:Destroy()
                        NameTagData.Instances[v] = nil
                    end
                    break
                end

                if Functions.IsAlive(v) then
                    char = v.Character
                    magvalue.Text = math.round(lp:DistanceFromCharacter(char.HumanoidRootPart.Position)).."m" or "nil"
                    local health = tostring(char.Humanoid.Health)
                    if char:GetAttribute("Health") then
                        health = tostring(char:GetAttribute("Health"))
                    end
                    if health then
                        healthvalue.Text = math.round(health)
                    end
                else
                    magvalue.Text = "nil" 
                    healthvalue.Text = "0" 
                end
            else
                for i,v in NameTagData.Connections[v] do
                    v:Disconnect()
                end
                table.clear(NameTagData.Connections[v])
                NameTagData.Connections[v] = nil
    
                if NameTagData.Instances[v] then
                    NameTagData.Instances[v]:Destroy()
                    NameTagData.Instances[v] = nil
                end
                break
            end
            task.wait()
        until not v or not NameTagData.Instances[v]
    end)

end

local starttag = function()
    for i,v in plrs:GetPlayers() do
        if v and v ~= lp and Functions.IsAlive(v) and (NameTagData.TeamCheck and v.Team ~= lp.Team or not NameTagData.TeamCheck) then
            if NameTagData.Mode == "DisplayName" then 
                nametagplr(v, v.DisplayName)
            else
                nametagplr(v, v.Name)
            end
            NameTagData.Connections[v].Respawn = v.CharacterAdded:Connect(function()
                repeat task.wait() until v and Functions.IsAlive(v) or not v
                if v and (NameTagData.TeamCheck and v.Team ~= lp.Team or not NameTagData.TeamCheck) then
                    if NameTagData.Mode == "DisplayName" then 
                        nametagplr(v, v.DisplayName)
                    else
                        nametagplr(v, v.Name)
                    end
                end
            end)
        end
    end

    NameTagData.Connections.Add = plrs.PlayerAdded:Connect(function(v)
        repeat task.wait() until v and Functions.IsAlive(v) or not v
        if v and (NameTagData.TeamCheck and v.Team ~= lp.Team or not NameTagData.TeamCheck) then
            if NameTagData.Mode == "DisplayName" then 
                nametagplr(v, v.DisplayName)
            else
                nametagplr(v, v.Name)
            end

            NameTagData.Connections[v].Respawn = v.CharacterAdded:Connect(function()
                repeat task.wait() until v and Functions.IsAlive(v) or not v
                if v then
                    if NameTagData.Mode == "DisplayName" then 
                        nametagplr(v, v.DisplayName)
                    else
                        nametagplr(v, v.Name)
                    end
                end
            end)
        end
    end)
    
    NameTagData.Connections.Remove = plrs.PlayerRemoving:Connect(function(v)
        if NameTagData.Connections[v] then
            for i,v in NameTagData.Connections[v] do
                v:Disconnect()
            end
            table.clear(NameTagData.Connections[v])
            NameTagData.Connections[v] = nil
        end
        if NameTagData.Instances[v] then
            NameTagData.Instances[v]:Destroy()
            NameTagData.Instances[v] = nil
        end
    end)
end

local NameTagModule = tabs.Render.Functions.NewModule({
    Name = "NameTags",
    Description = "Puts nametags on every player.",
    Icon = "rbxassetid://81972501042490",
    Flag = "UniversalNameTagModule",
    Callback = function(self, enabled)
        NameTagData.Enabled = enabled
        if enabled then
            starttag()
        else
            for i,v in NameTagData.Connections do
                if typeof(v) == "RBXScriptConnection" then
                    v:Disconnect()
                elseif typeof(v) == "table" then
                    for i2, v2 in v do
                        v2:Disconnect()
                    end
                    table.clear(v)
                end
            end
            table.clear(NameTagData.Connections)

            for i,v in NameTagData.Instances do
                v:Destroy()
            end
            table.clear(NameTagData.Instances)
        end
    end
})

NameTagModule.Functions.Settings.Dropdown({
    Name = "Mode",
    Description = "What Form Of The Players Name Will Be Shown",
    Default = "DisplayName",
    Options = {"DisplayName", "UserName"},
    SelectLimit = 1,
    Flag = "NameTagUserNameMode",
    Callback = function(self, value)
        NameTagData.Mode = value
        for i,v in NameTagData.Connections do
            if typeof(v) == "RBXScriptConnection" then
                v:Disconnect()
            elseif typeof(v) == "table" then
                for i2, v2 in v do
                    v2:Disconnect()
                end
                table.clear(v)
            end
        end
        table.clear(NameTagData.Connections)

        for i,v in NameTagData.Instances do
            v:Destroy()
        end
        table.clear(NameTagData.Instances)
        if NameTagData.Enabled then
            starttag()
        end
    end
})


NameTagModule.Functions.Settings.MiniToggle({
    Name = "Team Check",
    Description = "Doesnt give your teammates a nametag",
    Default = true,
    Flag = "NameTagTeamCheck",
    Callback = function(self, enabled)
        NameTagData.TeamCheck = enabled
        for i,v in NameTagData.Connections do
            if typeof(v) == "RBXScriptConnection" then
                v:Disconnect()
            elseif typeof(v) == "table" then
                for i2, v2 in v do
                    v2:Disconnect()
                end
                table.clear(v)
            end
        end
        table.clear(NameTagData.Connections)

        for i,v in NameTagData.Instances do
            v:Destroy()
        end
        table.clear(NameTagData.Instances)
        if NameTagData.Enabled then
            starttag()
        end
    end
})

local FovData = {
    Fov = 120,
    Original = 70,
    Connection = nil
}

FovData.Toggle = tabs.Render.Functions.NewModule({
    Name = "FOVChanger",
    Description = "Changes your FOV",
    Icon = "rbxassetid://124243860531404",
    Flag = "FOVChanger",
    Callback = function(self, callback)
        if callback then
            FovData.Original = ws.CurrentCamera.FieldOfView
            FovData.Connection = ws.CurrentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
                ws.CurrentCamera.FieldOfView = FovData.Fov
            end)
            ws.CurrentCamera.FieldOfView = FovData.Fov
        else
            if FovData.Connection then
                FovData.Connection:Disconnect()
            end
            if FovData.Original then
                ws.CurrentCamera.FieldOfView = FovData.Original
            end
        end
    end
})

FovData.Toggle.Functions.Settings.Slider({
    Name = "FOV",
    Description = "Amount of FOV to change to",
    Min = 0,
    Max = 120,
    Default = 120,
    Flag = "FOVChangerValue",
    Callback = function(self, callback)
        FovData.Fov = callback
        if FovData.Toggle.Data.Enabled then
            ws.CurrentCamera.FieldOfView = callback
        end
    end
})

tabs.World.Functions.NewModule({
    Name = "AntiAFK",
    Description = "Blocks Roblox from kicking you while being AFK",
    Icon = "rbxassetid://112131645518908",
    Flag = "AntiAFK",
    Callback = function(self, callback)
        if callback then
            lp.Idled:Connect(function()
                if not self.Data.Enabled then return end
                virtual:CaptureController()
                virtual:ClickButton2(Vector2.new())
                virtual:Button2Up(Vector2.new(), cam.CFrame)
                virtual:Button2Down(Vector2.new(), cam.CFrame)
            end)
        end
    end
})
