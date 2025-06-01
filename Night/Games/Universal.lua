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
local rep = Functions.cloneref(game:GetService("ReplicatedStorage")) :: ReplicatedStorage
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

if rep:FindFirstChild('Themes') then
    rep:FindFirstChild('Themes'):Destroy()
end

local themeProps = {
    Stars = {
        Ambient = Color3.fromRGB(107, 107, 107),
        OutdoorAmbient = Color3.fromRGB(115, 93, 137),
        ColorShift_Bottom = Color3.fromRGB(219, 3, 246),
        ColorShift_Top = Color3.fromRGB(144, 6, 177),
        Enviroment = 0.4,
        Brightness = 0.05,
        Exposure = 0.8,
        Lat = 60,
        Time = 10,
        Shadows = true
    },
    Warm = {
        Ambient = Color3.fromRGB(58, 58, 58),
        OutdoorAmbient = Color3.fromRGB(127, 116, 79),
        ColorShift_Bottom = Color3.fromRGB(219, 3, 246),
        ColorShift_Top = Color3.fromRGB(144, 6, 177),
        Enviroment = 0.5,
        Brightness = 0.2,
        Exposure = 0.6,
        Lat = 310,
        Time = 13,
        Shadows = true
    },
    Galaxy = {
        Ambient = Color3.fromRGB(101, 101, 101),
        OutdoorAmbient = Color3.fromRGB(131, 77, 122),
        ColorShift_Bottom = Color3.fromRGB(219, 3, 246),
        ColorShift_Top = Color3.fromRGB(144, 6, 177),
        Enviroment = 0.5,
        Brightness = 0.2,
        Exposure = 0.7,
        Lat = 0,
        Time = 15.25,
        Shadows = true
    },
    Sunset = {
        Ambient = Color3.fromRGB(93, 59, 88),
        OutdoorAmbient = Color3.fromRGB(128, 94, 100),
        ColorShift_Bottom = Color3.fromRGB(213, 173, 117),
        ColorShift_Top = Color3.fromRGB(255, 255, 255),
        Enviroment = 0.5,
        Brightness = 0.2,
        Exposure = 0.8,
        Lat = 325,
        Time = 11,
        Shadows = true
    },
    Morning = {
        Ambient = Color3.fromRGB(101, 72, 51),
        OutdoorAmbient = Color3.fromRGB(175, 132, 119),
        ColorShift_Bottom = Color3.fromRGB(213, 161, 134),
        ColorShift_Top = Color3.fromRGB(203, 167, 102),
        Enviroment = 0.3,
        Brightness = 1,
        Exposure = 0.7,
        Lat = 326,
        Time = 16 + (1/3),
        Shadows = true
    },
    Ocean = {
        Ambient = Color3.fromRGB(79, 54, 101),
        OutdoorAmbient = Color3.fromRGB(162, 118, 175),
        ColorShift_Bottom = Color3.fromRGB(213, 10, 180),
        ColorShift_Top = Color3.fromRGB(103, 68, 203),
        Enviroment = 0.4,
        Brightness = 0.2,
        Exposure = 1,
        Lat = 306,
        Time = 10,
        Shadows = true
    }
}

local GameThemes = Instance.new('Folder', rep)
GameThemes.Name = 'Themes'

local TheMilkyWaySkyA = Instance.new('Sky', GameThemes)
TheMilkyWaySkyA.Name = 'Stars'
TheMilkyWaySkyA.CelestialBodiesShown = false
TheMilkyWaySkyA.StarCount = 3000
TheMilkyWaySkyA.SkyboxUp = 'rbxassetid://5559302033'
TheMilkyWaySkyA.SkyboxLf = 'rbxassetid://5559292825'
TheMilkyWaySkyA.SkyboxFt = 'rbxassetid://5559300879'
TheMilkyWaySkyA.SkyboxBk = 'rbxassetid://5559289158'
TheMilkyWaySkyA.SkyboxDn = 'rbxassetid://5559290893'
TheMilkyWaySkyA.SkyboxRt = 'rbxassetid://5559302989'
TheMilkyWaySkyA.SunTextureId = 'rbxasset://sky/sun.jpg'
TheMilkyWaySkyA.SunAngularSize = 1.44
TheMilkyWaySkyA.MoonTextureId = 'rbxasset://sky/moon.jpg'
TheMilkyWaySkyA.MoonAngularSize = 0.57
local TheMilkyWaySkyADOF = Instance.new('DepthOfFieldEffect', TheMilkyWaySkyA)
TheMilkyWaySkyADOF.FarIntensity = 0.12
TheMilkyWaySkyADOF.NearIntensity = 0.3
TheMilkyWaySkyADOF.FocusDistance = 20
TheMilkyWaySkyADOF.InFocusRadius = 17
local TheMilkyWaySkyACC = Instance.new('ColorCorrectionEffect', TheMilkyWaySkyA)
TheMilkyWaySkyACC.TintColor = Color3.fromRGB(245, 200, 245)
TheMilkyWaySkyACC.Brightness = 0
TheMilkyWaySkyACC.Contrast = 0.2
TheMilkyWaySkyACC.Saturation = -0.1
local TheMilkyWaySkyABloom = Instance.new('BloomEffect', TheMilkyWaySkyA)
TheMilkyWaySkyABloom.Intensity = 0.4
TheMilkyWaySkyABloom.Size = 12
TheMilkyWaySkyABloom.Threshold = 0.2

local TheMilkyWaySkyB = Instance.new('Sky', GameThemes)
TheMilkyWaySkyB.Name = 'Warm'
TheMilkyWaySkyB.CelestialBodiesShown = false
TheMilkyWaySkyB.StarCount = 3000
TheMilkyWaySkyB.SkyboxUp = 'http://www.roblox.com/asset?id=232707707'
TheMilkyWaySkyB.SkyboxLf = 'http://www.roblox.com/asset?id=232708001'
TheMilkyWaySkyB.SkyboxFt = 'http://www.roblox.com/asset?id=232707879'
TheMilkyWaySkyB.SkyboxBk = 'http://www.roblox.com/asset?id=232707959'
TheMilkyWaySkyB.SkyboxDn = 'http://www.roblox.com/asset?id=232707790'
TheMilkyWaySkyB.SkyboxRt = 'http://www.roblox.com/asset?id=232707983'
local TheMilkyWaySkyBCC = Instance.new('ColorCorrectionEffect', TheMilkyWaySkyB)
TheMilkyWaySkyBCC.TintColor = Color3.fromRGB(255, 255, 255)
TheMilkyWaySkyBCC.Brightness = 0
TheMilkyWaySkyBCC.Contrast = 0.3
TheMilkyWaySkyBCC.Saturation = 0.2
local TheMilkyWaySkyBDOF = Instance.new('DepthOfFieldEffect', TheMilkyWaySkyB)
TheMilkyWaySkyBDOF.FarIntensity = 0.12
TheMilkyWaySkyBDOF.NearIntensity = 0.3
TheMilkyWaySkyBDOF.FocusDistance = 20
TheMilkyWaySkyBDOF.InFocusRadius = 17
local TheMilkyWaySkyBBloom = Instance.new('BloomEffect', TheMilkyWaySkyB)
TheMilkyWaySkyBBloom.Intensity = 0.6
TheMilkyWaySkyBBloom.Size = 12
TheMilkyWaySkyBBloom.Threshold = 0.2
local TheMilkyWaySkyBSunRay = Instance.new('SunRaysEffect', TheMilkyWaySkyB)
TheMilkyWaySkyBSunRay.Enabled = true
TheMilkyWaySkyBSunRay.Intensity = 0.003
TheMilkyWaySkyBSunRay.Spread = 1

local TheMilkyWaySkyC = Instance.new('Sky', GameThemes)
TheMilkyWaySkyC.Name = 'Galaxy'
TheMilkyWaySkyC.CelestialBodiesShown = false
TheMilkyWaySkyC.StarCount = 3000
TheMilkyWaySkyC.SkyboxUp = 'rbxassetid://1903391299'
TheMilkyWaySkyC.SkyboxLf = 'rbxassetid://1903388369'
TheMilkyWaySkyC.SkyboxFt = 'rbxassetid://1903389258'
TheMilkyWaySkyC.SkyboxBk = 'rbxassetid://1903390348'
TheMilkyWaySkyC.SkyboxDn = 'rbxassetid://1903391981'
TheMilkyWaySkyC.SkyboxRt = 'rbxassetid://1903387293'
TheMilkyWaySkyC.SunTextureId = 'rbxasset://sky/sun.jpg'
TheMilkyWaySkyC.SunAngularSize = 21
TheMilkyWaySkyC.MoonTextureId = 'rbxassetid://sky/moon.jpg'
TheMilkyWaySkyC.MoonAngularSize = 11
local TheMilkyWaySkyCDOF = Instance.new('DepthOfFieldEffect', TheMilkyWaySkyC)
TheMilkyWaySkyCDOF.FarIntensity = 0.12
TheMilkyWaySkyCDOF.NearIntensity = 0.3
TheMilkyWaySkyCDOF.FocusDistance = 20
TheMilkyWaySkyCDOF.InFocusRadius = 17
local TheMilkyWaySkyCBloom = Instance.new('BloomEffect', TheMilkyWaySkyC)
TheMilkyWaySkyCBloom.Intensity = 0.6
TheMilkyWaySkyCBloom.Size = 12
TheMilkyWaySkyCBloom.Threshold = 0.2
local TheMilkyWaySkyCSunRay = Instance.new('SunRaysEffect', TheMilkyWaySkyC)
TheMilkyWaySkyCSunRay.Enabled = true
TheMilkyWaySkyCSunRay.Intensity = 0.003
TheMilkyWaySkyCSunRay.Spread = 1
local TheMilkyWaySkyCCC = Instance.new('ColorCorrectionEffect', TheMilkyWaySkyC)
TheMilkyWaySkyCCC.TintColor = Color3.fromRGB(245, 240, 255)
TheMilkyWaySkyCCC.Brightness = -0.04
TheMilkyWaySkyCCC.Contrast = 0.2
TheMilkyWaySkyCCC.Saturation = 0.2

local LunarVapeOld = Instance.new('Sky', GameThemes)
LunarVapeOld.Name = 'Sunset'
LunarVapeOld.CelestialBodiesShown = false
LunarVapeOld.StarCount = 3000
LunarVapeOld.SkyboxUp = 'rbxassetid://2670644331'
LunarVapeOld.SkyboxLf = 'rbxassetid://2670643070'
LunarVapeOld.SkyboxFt = 'rbxassetid://2670643214'
LunarVapeOld.SkyboxBk = 'rbxassetid://2670643994'
LunarVapeOld.SkyboxDn = 'rbxassetid://2670643365'
LunarVapeOld.SkyboxRt = 'rbxassetid://2670644173'
LunarVapeOld.SunTextureId = 'rbxasset://sky/sun.jpg'
LunarVapeOld.SunAngularSize = 21
LunarVapeOld.MoonTextureId = 'rbxassetid://1075087760'
LunarVapeOld.MoonAngularSize = 11
local LunarVapeOldCC = Instance.new('ColorCorrectionEffect', LunarVapeOld)
LunarVapeOldCC.Enabled = true
LunarVapeOldCC.Brightness = 0.13
LunarVapeOldCC.Contrast = 0.4
LunarVapeOldCC.Saturation = 0.06
LunarVapeOldCC.TintColor = Color3.fromRGB(255, 230, 245)
local LunarVapeOldDOF = Instance.new('DepthOfFieldEffect', LunarVapeOld)
LunarVapeOldDOF.FarIntensity = 0.12
LunarVapeOldDOF.NearIntensity = 0.3
LunarVapeOldDOF.FocusDistance = 20
LunarVapeOldDOF.InFocusRadius = 17
local LunarVapeOldBloom = Instance.new('BloomEffect', LunarVapeOld)
LunarVapeOldBloom.Intensity = 0.4
LunarVapeOldBloom.Size = 12
LunarVapeOldBloom.Threshold = 0.2

local LunarVapeNew = Instance.new('Sky', GameThemes)
LunarVapeNew.Name = 'Morning'
LunarVapeNew.CelestialBodiesShown = false
LunarVapeNew.StarCount = 0
LunarVapeNew.SkyboxUp = 'http://www.roblox.com/asset/?id=458016792'
LunarVapeNew.SkyboxLf = 'http://www.roblox.com/asset/?id=458016655'
LunarVapeNew.SkyboxFt = 'http://www.roblox.com/asset/?id=458016532'
LunarVapeNew.SkyboxBk = 'http://www.roblox.com/asset/?id=458016711'
LunarVapeNew.SkyboxDn = 'http://www.roblox.com/asset/?id=458016826'
LunarVapeNew.SkyboxRt = 'http://www.roblox.com/asset/?id=458016782'
LunarVapeNew.SunTextureId = 'rbxasset://sky/sun.jpg'
LunarVapeNew.SunAngularSize = 21
LunarVapeNew.MoonTextureId = 'rbxasset://sky/moon.jpg'
LunarVapeNew.MoonAngularSize = 11
local LunarVapeNewBloom = Instance.new('BloomEffect', LunarVapeNew)
LunarVapeNewBloom.Enabled = true
LunarVapeNewBloom.Threshold = 0.24
LunarVapeNewBloom.Size = 8
LunarVapeNewBloom.Intensity = 0.5
local LunarVapeNewSunRay = Instance.new('SunRaysEffect', LunarVapeNew)
LunarVapeNewSunRay.Enabled = true
LunarVapeNewSunRay.Intensity = 0.05
LunarVapeNewSunRay.Spread = 0.4
local LunarVapeNewCC = Instance.new('ColorCorrectionEffect', LunarVapeNew)
LunarVapeNewCC.Saturation = 0.14
LunarVapeNewCC.Brightness = -0.1
LunarVapeNewCC.Contrast = 0.14
local LunarVapeNewDOF = Instance.new('DepthOfFieldEffect', LunarVapeNew)
LunarVapeNewDOF.FarIntensity = 0.2
LunarVapeNewDOF.InFocusRadius = 17
LunarVapeNewDOF.FocusDistance = 20
LunarVapeNewDOF.NearIntensity = 0.3

local AntarcticEvening = Instance.new('Sky', GameThemes)
AntarcticEvening.Name = 'Ocean'
AntarcticEvening.CelestialBodiesShown = false
AntarcticEvening.StarCount = 3000
AntarcticEvening.SkyboxUp = 'http://www.roblox.com/asset/?id=5260824661'
AntarcticEvening.SkyboxLf = 'http://www.roblox.com/asset/?id=5260800833'
AntarcticEvening.SkyboxFt = 'http://www.roblox.com/asset/?id=5260817288'
AntarcticEvening.SkyboxBk = 'http://www.roblox.com/asset/?id=5260808177'
AntarcticEvening.SkyboxDn = 'http://www.roblox.com/asset/?id=5260653793'
AntarcticEvening.SkyboxRt = 'http://www.roblox.com/asset/?id=5260811073'
AntarcticEvening.SunTextureId = 'rbxasset://sky/sun.jpg'
AntarcticEvening.SunAngularSize = 21
AntarcticEvening.MoonTextureId = 'rbxasset://sky/moon.jpg'
AntarcticEvening.MoonAngularSize = 11
local AntarcticEveningBloom = Instance.new('BloomEffect', AntarcticEvening)
AntarcticEveningBloom.Enabled = true
AntarcticEveningBloom.Threshold = 0.4
AntarcticEveningBloom.Size = 12
AntarcticEveningBloom.Intensity = 0.5
local AntarcticEveningCC = Instance.new('ColorCorrectionEffect', AntarcticEvening)
AntarcticEveningCC.Brightness = -0.03	
AntarcticEveningCC.Contrast = 0.16
AntarcticEveningCC.Saturation = 0.06
AntarcticEveningCC.TintColor = Color3.fromRGB(220, 175, 255)
local AntarcticEveningDOF = Instance.new('DepthOfFieldEffect', AntarcticEvening)
AntarcticEveningDOF.FarIntensity = 0.12
AntarcticEveningDOF.InFocusRadius = 17
AntarcticEveningDOF.FocusDistance = 20
AntarcticEveningDOF.NearIntensity = 0.3

local timeConnection
local ShaderData = {
    Enabled = false,
    OldLighting = {},
    ShaderInstances = {},
    Mode = "Realistic",
    Simple = "Rain",
    Complex = "Stars",
    RemoveClouds = false
}

local Applied = false
local Shaders = tabs.Render.Functions.NewModule({
    Name = "Shader",
    Description = "Applies a custom shader to the game",
    Icon = "rbxassetid://137880047383411",
    Flag = "UniversalShaderModule",
    Callback = function(self, enabled)
        ShaderData.Enabled = enabled
        if enabled then
            for _, prop in next, {"Ambient", "ClockTime", "GeographicLatitude", "Brightness", 
                "ColorShift_Bottom", "ColorShift_Top", "EnvironmentDiffuseScale", 
                "EnvironmentSpecularScale", "GlobalShadows", "OutdoorAmbient", 
                "ExposureCompensation", "FogEnd", "FogStart", "FogColor"} do
                ShaderData.OldLighting[prop] = lighting[prop]
            end
            
            for _, obj in next, lighting:GetChildren() do
                if obj:IsA("Atmosphere") or obj:IsA("Sky") or obj:IsA("ColorCorrectionEffect") then
                    table.insert(ShaderData.OldLighting, obj:Clone())
                    obj:Destroy()
                end
            end

            if workspace:FindFirstChild("Clouds") and ShaderData.RemoveClouds then
                for _, v in next, workspace:FindFirstChild("Clouds"):GetChildren() do
                    if v:IsA('Part') then
                        v.Transparency = 1
                    end
                end
            end

            if ShaderData.Mode == "Realistic" then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/warprbx/NightRewrite/refs/heads/main/Night/Games/Shader.lua"))()
            elseif ShaderData.Mode == "Simple" then
                local Sky = Instance.new('Sky', lighting)

                if ShaderData.Simple == 'Rain' then
                    Sky.SkyboxBk = 'http://www.roblox.com/asset/?id=4495864450'
                    Sky.SkyboxDn = 'http://www.roblox.com/asset/?id=4495864887'
                    Sky.SkyboxFt = 'http://www.roblox.com/asset/?id=4495865458'
                    Sky.SkyboxLf = 'http://www.roblox.com/asset/?id=4495866035'
                    Sky.SkyboxRt = 'http://www.roblox.com/asset/?id=4495866584'
                    Sky.SkyboxUp = 'http://www.roblox.com/asset/?id=4495867486'

                    local RainColor = Instance.new('ColorCorrectionEffect', lighting)
                    RainColor.Brightness = 0.05
                    RainColor.Contrast = 0.05
                    RainColor.TintColor = Color3.fromRGB(170, 170, 170)
                elseif ShaderData.Simple == 'Nebula' then
                    Sky.SkyboxBk = 'http://www.roblox.com/asset/?id=15983968922'
                    Sky.SkyboxDn = 'http://www.roblox.com/asset/?id=15983966825'
                    Sky.SkyboxFt = 'http://www.roblox.com/asset/?id=15983965025'
                    Sky.SkyboxLf = 'http://www.roblox.com/asset/?id=15983967420'
                    Sky.SkyboxRt = 'http://www.roblox.com/asset/?id=15983966246'
                    Sky.SkyboxUp = 'http://www.roblox.com/asset/?id=15983964246'

                    local NebulaColor = Instance.new('ColorCorrectionEffect', lighting)
                    NebulaColor.Brightness = 0.05
                    NebulaColor.Contrast = -0.02
                    NebulaColor.TintColor = Color3.fromRGB(105, 72, 255)
                else
                    Sky.SkyboxBk = 'http://www.roblox.com/asset/?id=12064107'
                    Sky.SkyboxDn = 'http://www.roblox.com/asset/?id=12064152'
                    Sky.SkyboxFt = 'http://www.roblox.com/asset/?id=12064121'
                    Sky.SkyboxLf = 'http://www.roblox.com/asset/?id=12063984'
                    Sky.SkyboxRt = 'http://www.roblox.com/asset/?id=12064115'
                    Sky.SkyboxUp = 'http://www.roblox.com/asset/?id=12064131'

                    local NightColor = Instance.new('ColorCorrectionEffect', lighting)
                    NightColor.Brightness = 0.07
                    NightColor.Contrast = -0.07
                    NightColor.TintColor = Color3.fromRGB(44, 70, 187)
                end
            elseif ShaderData.Mode == "Complex" then
                for _, v in next, lighting:GetChildren() do
                    v:Destroy()
                end

                local newSky = GameThemes[ShaderData.Complex]:Clone()
                newSky.Parent = lighting

                for _, v in next, newSky:GetChildren() do
                    v.Parent = lighting
                end

                lighting.Brightness = themeProps[ShaderData.Complex].Brightness
                lighting.ExposureCompensation = themeProps[ShaderData.Complex].Exposure
                lighting.EnvironmentDiffuseScale = themeProps[ShaderData.Complex].Enviroment
                lighting.EnvironmentSpecularScale = themeProps[ShaderData.Complex].Enviroment
                lighting.Ambient = themeProps[ShaderData.Complex].Ambient
                lighting.OutdoorAmbient = themeProps[ShaderData.Complex].OutdoorAmbient
                lighting.GeographicLatitude = themeProps[ShaderData.Complex].Lat
                lighting.ClockTime = themeProps[ShaderData.Complex].Time		

                timeConnection = lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
                    lighting.ClockTime = themeProps[ShaderData.Complex].Time
                end)

                lighting.GlobalShadows = themeProps[ShaderData.Complex].Shadows
                lighting.ShadowSoftness = 0.08

                if sethiddenproperty then
                    sethiddenproperty(lighting, 'Technology', 'Future')
                end
            else
                local game = Functions.cloneref(game)
                local services = {
                    Lighting = Functions.cloneref(game:GetService("Lighting"))
                }
                
                local createInstance = function(className, properties)
                    local instance = services.Lighting:FindFirstChildOfClass(className) or Instance.new(className)
                    instance.Parent = services.Lighting
                    for prop, value in next, properties do 
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
                
                for prop, value in next, properties do
                    lighting[prop] = value
                end
            end

            Applied = true
        else
            if Applied then
                if ShaderData.Mode == "Simple" or ShaderData.Mode == "Complex" then
                    lighting.Brightness = 2
                    lighting.EnvironmentDiffuseScale = 1
                    lighting.EnvironmentSpecularScale = 1
                    lighting.Ambient = Color3.fromRGB(89, 60, 86)
                    lighting.OutdoorAmbient = Color3.fromRGB(216, 191, 161)
                    lighting.GeographicLatitude = 0
                    lighting.ClockTime = 14

                    if timeConnection then
                        timeConnection:Disconnect()
                    end

                    lighting.ShadowSoftness = 0.2
                    lighting.ExposureCompensation = 0.1
                    lighting.GlobalShadows = true

                    if sethiddenproperty then
                        sethiddenproperty(lighting, "Technology", "ShadowMap")
                    end

                    for _, v in next, lighting:GetChildren() do
                        v:Destroy()
                    end
                else
                    for prop, value in next, ShaderData.OldLighting do
                        if typeof(value) == "Instance" then
                            value:Clone().Parent = lighting
                        else
                            lighting[prop] = value
                        end
                    end
                    
                    for _, instance in next, ShaderData.ShaderInstances do
                        instance:Destroy()
                    end
                    ShaderData.ShaderInstances = {}
                    ShaderData.OldLighting = {}
                end
            end
        end
    end
})
local ShaderSimple, ShaderComplex
Shaders.Functions.Settings.Dropdown({
    Name = "Mode",
    Description = "Type of shader to apply",
    Default = "Realistic",
    Options = {"Realistic", "Simple", "Complex", "Dark"},
    SelectLimit = 1,
    Flag = "ShaderMode",
    Callback = function(self, value)
        ShaderData.Mode = value
        task.spawn(function()
            repeat task.wait() until ShaderSimple and ShaderComplex
            ShaderSimple.Functions.SetVisiblity(value == "Simple")
            ShaderComplex.Functions.SetVisiblity(value == "Complex")
        end)
    end
})
ShaderSimple = Shaders.Functions.Settings.Dropdown({
    Name = "Simple",
    Description = "Shader to apply using 'Simple' mode",
    Default = "Rain",
    Options = {"Rain", "Nebula", "Night"},
    SelectLimit = 1,
    Flag = "ShaderSimple",
    Callback = function(self, value)
        ShaderData.Simple = value
    end
})
ShaderComplex = Shaders.Functions.Settings.Dropdown({
    Name = "Complex",
    Description = "Shader to apply using 'Complex' mode",
    Default = "Stars",
    Options = {"Stars", "Warm", "Galaxy", "Sunset", "Morning", "Ocean", "Rain"},
    SelectLimit = 1,
    Flag = "ShaderComplex",
    Callback = function(self, value)
        ShaderData.Complex = value
    end
})
Shaders.Functions.Settings.MiniToggle({
    Name = "Remove Clouds",
    Description = "Removes clouds from the game",
    Default = true,
    Flag = "RemoveCloudsToggle",
    Callback = function(self, call)
        ShaderData.RemoveClouds = call
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
