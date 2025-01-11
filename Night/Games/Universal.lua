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
local plrs = Functions.cloneref(game:GetService("Players"))
local lplr = plrs.LocalPlayer


local SpeedData = {
    Enabled = false,
    Speed = 50,
    JumpPower = 50,
    TPDelay = 3,
    PulseDelay = 20,
    PulseDuration = 15,
    Mode = "Velocity",
    WallCheck = true,
    AutoJump = true,
    Pulse = false,
    OldWS = nil,
    OldJumpPower = nil,
    OldJumpPowerToggle = nil,
    PulseInstances = {}
}
local SpeedModule = tabs.Movement.Functions.NewModule({
    Name = "Speed",
    Description = "Edit local character speed in settings",
    Icon = "rbxassetid://137816060476796",
    Flag = "UniversalSpeedModule",
    Callback = function(self, enabled)
        SpeedData.Enabled = enabled
        if enabled then
            repeat task.wait() until Functions.IsAlive(lplr)
            SpeedData.OldWS = lplr.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed
            SpeedData.OldJumpPower = lplr.Character:FindFirstChildWhichIsA("Humanoid").JumpPower
            SpeedData.OldJumpPowerToggle = lplr.Character:FindFirstChildWhichIsA("Humanoid").UseJumpPower
            repeat
                if Functions.IsAlive(lplr) then
                    local canspeed = true
                    if lplr.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Magnitude > 0 then
                        if SpeedData.WallCheck then
                            local prams = RaycastParams.new()
                            if SpeedData.Mode == "CFrame" or SpeedData.Mode == "TP" then
                                prams.FilterDescendantsInstances = {lplr.Character}
                            else
                                prams.FilterDescendantsInstances = {workspace.Terrain, lplr.Character}
                            end
                            prams.FilterType = Enum.RaycastFilterType.Exclude
                            prams.IgnoreWater = true
                            local rcast = workspace:Raycast(lplr.Character.PrimaryPart.Position, lplr.Character.Humanoid.MoveDirection * 5, prams)
                            if SpeedData.Mode == "TP" then
                                rcast = workspace:Raycast(lplr.Character.PrimaryPart.Position, lplr.Character.Humanoid.MoveDirection * (SpeedData.Speed/10), prams)
                            end
                            if rcast then
                                canspeed = false
                            end
                        end
                        task.spawn(function()
                            if SpeedData.AutoJump then
                                if lplr.Character:FindFirstChildWhichIsA("Humanoid").FloorMaterial ~= Enum.Material.Air then
                                    lplr.Character:FindFirstChildWhichIsA("Humanoid").JumpPower = SpeedData.JumpPower
                                    lplr.Character:FindFirstChildWhichIsA("Humanoid").UseJumpPower = true
                                    lplr.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                                end
                            end
                        end)
                        if SpeedData.Mode == "WalkSpeed" then
                            if SpeedData.Pulse then
                                for i = 0, SpeedData.PulseDuration do
                                    lplr.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = SpeedData.Speed
                                    task.wait(0.01)
                                end
                                lplr.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = SpeedData.OldWS
                                task.wait(SpeedData.PulseDelay/10)
                            else
                                lplr.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = SpeedData.Speed
                            end
                        elseif SpeedData.Mode == "Velocity" then
                            if canspeed then
                                if SpeedData.Pulse then
                                    for i = 0, SpeedData.PulseDuration do
                                        if canspeed then
                                            lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * SpeedData.Speed, lplr.Character.HumanoidRootPart.Velocity.Y, lplr.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * SpeedData.Speed)
                                            task.wait(0.01)
                                        end
                                    end
                                    task.wait(SpeedData.PulseDelay/10)
                                else
                                    lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * SpeedData.Speed, lplr.Character.HumanoidRootPart.Velocity.Y, lplr.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * SpeedData.Speed)
                                end
                            end
                        elseif SpeedData.Mode == "CFrame" then
                            if canspeed then
                                if SpeedData.Pulse then
                                    for i = 0, SpeedData.PulseDuration do
                                        if canspeed then 
                                            lplr.Character.HumanoidRootPart.CFrame += Vector3.new(lplr.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * (SpeedData.Speed/180), 0, lplr.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * (SpeedData.Speed/180))
                                            task.wait(0.01)
                                        end
                                    end
                                    task.wait(SpeedData.PulseDelay/10)
                                else
                                    lplr.Character.HumanoidRootPart.CFrame += Vector3.new(lplr.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * (SpeedData.Speed/80), 0, lplr.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * (SpeedData.Speed/80))
                                end
                            end
                        elseif SpeedData.Mode == "TP" then
                            if canspeed then
                                lplr.Character.HumanoidRootPart.CFrame += Vector3.new(lplr.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.X * (SpeedData.Speed/10), 0, lplr.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection.Z * (SpeedData.Speed/10))
                                task.wait(SpeedData.TPDelay/10)
                            end
                        end
                    end
                end
                task.wait()
            until not SpeedData.Enabled
        else
            if SpeedData.OldWS then
                lplr.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = SpeedData.OldWS
            end
            if SpeedData.OldJumpPower then
                lplr.Character:FindFirstChildWhichIsA("Humanoid").JumpPower = SpeedData.OldJumpPower
            end
            if SpeedData.OldJumpPowerToggle then
                lplr.Character:FindFirstChildWhichIsA("Humanoid").UseJumpPower = SpeedData.OldJumpPowerToggle
            end
        end
    end
})

SpeedModule.Functions.Settings.Slider({
    Name = "Speed",
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
    Min = 0,
    Max = 100,
    Default = 3,
    Decimals = 0,
    Flag = "UniversalSpeedTPDelay",
    Callback = function(self, value)
        SpeedData.TPDelay = value
    end
})

SpeedModule.Functions.Settings.ToggleList({
    Name = "Speed Mode",
    Default = "WalkSpeed",
    Options = {"WalkSpeed", "Velocity", "CFrame", "TP"},
    SelectLimit = 1,
    Divide = "Speed Mode",
    Flag = "UniversalSpeedMode",
    Tab = false,
    Callback = function(self, value)
        SpeedData.Mode = value
        if SpeedData.OldWS then
            lplr.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = SpeedData.OldWS
        end
        if SpeedData.OldJumpPowerToggle then
            lplr.Character:FindFirstChildWhichIsA("Humanoid").UseJumpPower = SpeedData.OldJumpPowerToggle
        end
        if Functions.IsAlive(lplr) then
            task.spawn(function()
                repeat task.wait() until SpeedModule.Settings.UniversalSpeedWallCheck
                if value == "WalkSpeed" then
                    SpeedModule.Settings.UniversalSpeedWallCheck.Functions.SetVisiblity(false)
                else
                    SpeedModule.Settings.UniversalSpeedWallCheck.Functions.SetVisiblity(true)
                end
                repeat task.wait() until #SpeedData.PulseInstances == 3
                if value == "TP" then
                    SpeedModule.Settings.UniversalSpeedTPDelay.Functions.SetVisiblity(true)
                    repeat task.wait() until SpeedModule.Settings.UniversalSpeedPulseToggle
                    SpeedModule.Settings.UniversalSpeedPulseToggle.Functions.SetVisiblity(false)
                    for i,v in SpeedData.PulseInstances do
                        v.Functions.SetVisiblity(false)
                    end
                else
                    SpeedModule.Settings.UniversalSpeedTPDelay.Functions.SetVisiblity(false)
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
    Default = true,
    Flag = "UniversalSpeedWallCheck",
    Callback = function(self, enabled)
        SpeedData.WallCheck = enabled
    end
})

SpeedModule.Functions.Settings.MiniToggle({
    Name = "Auto Jump",
    Default = true,
    Flag = "UniversalSpeedAutoJump",
    Callback = function(self, enabled)
        SpeedData.AutoJump = enabled
        task.spawn(function()
            repeat task.wait() until SpeedModule.Settings.UniversalSpeedJumpPower
            if enabled then
                SpeedModule.Settings.UniversalSpeedJumpPower.Functions.SetVisiblity(true)
            else
                SpeedModule.Settings.UniversalSpeedJumpPower.Functions.SetVisiblity(false)
                if Functions.IsAlive(lplr) then
                    lplr.Character:FindFirstChildWhichIsA("Humanoid").JumpPower = SpeedData.JumpPower
                end
            end
        end)
    end
})

SpeedModule.Functions.Settings.Slider({
    Name = "Jump Power",
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
    Min = 0,
    Max = 150,
    Default = 15,
    Decimals = 0,
    Flag = "UniversalSpeedPulseDuration",
    Callback = function(self, value)
        SpeedData.PulseDuration = value
    end
}))


-- local FlyData = {
--     Speed = 50,
--     TPDelay = 3,
--     PulseDelay = 20,
--     PulseDuration = 15,
--     SpeedMode = "Velocity",
--     FlyMode = "Velocity",
--     WallCheck = true,
--     Pulse = false,
--     OldWS = nil,
--     PulseInstances = {}
-- }
-- local Module = tabs.Movement.Functions.NewModule({
--     Name = "Fly",
--     Description = "Lets you fly",
--     Icon = "rbxassetid://137816060476796",
--     Flag = "UniversalFlyModule",
--     Callback = function(self, enabled)
--         FlyData.Enabled = enabled
--         if enabled then
--             FlyData.OldWS = lplr.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed
--             repeat
--                 if Functions.IsAlive(lplr) then

--                 end
--                 task.wait()
--             until not FlyData.Enabled
--         else
--             if FlyData.OldWS then
--                 lplr.Character:FindFirstChildWhichIsA("Humanoid").WalkFly = FlyData.OldWS
--             end
--         end
--     end
-- })

-- Module.Functions.Settings.Slider({
--     Name = "Speed",
--     Min = 0,
--     Max = 150,
--     Default = 50,
--     Decimals = 0,
--     Flag = "UniversalFlySpeedSlider",
--     Callback = function(self, value)
--         FlyData.Speed = value
--     end
-- })

-- Module.Functions.Settings.Slider({
--     Name = "TP Delay",
--     Min = 0,
--     Max = 100,
--     Default = 3,
--     Decimals = 0,
--     Flag = "UniversalFlySpeedTPDelay",
--     Callback = function(self, value)
--         FlyData.TPDelay = value
--     end
-- })

-- Module.Functions.Settings.ToggleList({
--     Name = "Fly Mode",
--     Default = "WalkFly",
--     Options = {"WalkFly", "Velocity", "CFrame", "TP"},
--     SelectLimit = 1,
--     Divide = "Fly Mode",
--     Flag = "UniversalFlyMode",
--     Tab = true,
--     Callback = function(self, value)
--         FlyData.Mode = value
--         if FlyData.OldWS then
--             lplr.Character:FindFirstChildWhichIsA("Humanoid").WalkFly = FlyData.OldWS
--         end
--         if Functions.IsAlive(lplr) then
--             task.spawn(function()
--                 repeat task.wait() until Module.Settings.UniversalFlyWallCheck
--                 if value == "WalkFly" then
--                     Module.Settings.UniversalFlyWallCheck.Functions.SetVisiblity(false)
--                 else
--                     Module.Settings.UniversalFlyWallCheck.Functions.SetVisiblity(true)
--                 end
--                 repeat task.wait() until #FlyData.PulseInstances == 3
--                 if value == "TP" then
--                     Module.Settings.UniversalFlyTPDelay.Functions.SetVisiblity(true)
--                     repeat task.wait() until Module.Settings.UniversalFlyPulseToggle
--                     Module.Settings.UniversalFlyPulseToggle.Functions.SetVisiblity(false)
--                     for i,v in FlyData.PulseInstances do
--                         v.Functions.SetVisiblity(false)
--                     end
--                 else
--                     Module.Settings.UniversalFlyTPDelay.Functions.SetVisiblity(false)
--                     Module.Settings.UniversalFlyPulseToggle.Functions.SetVisiblity(true)
--                     if Module.Settings.UniversalFlyPulseToggle.Enabled then
--                         for i,v in FlyData.PulseInstances do
--                             v.Functions.SetVisiblity(true)
--                         end
--                     else
--                         for i,v in FlyData.PulseInstances do
--                             v.Functions.SetVisiblity(false)
--                         end
--                         Module.Settings.UniversalFlyPulseToggle.Functions.SetVisiblity(true)
--                     end
--                 end
--             end)
--         end
--     end
-- })

-- Module.Functions.Settings.MiniToggle({
--     Name = "Wall Check",
--     Default = true,
--     Flag = "UniversalFlyWallCheck",
--     Callback = function(self, enabled)
--         FlyData.WallCheck = enabled
--     end
-- })

-- table.insert(FlyData.PulseInstances, Module.Functions.Settings.MiniToggle({
--     Name = "Pulse",
--     Default = false,
--     Flag = "UniversalFlyPulseToggle",
--     Callback = function(self, enabled)
--         FlyData.Pulse = enabled
--         task.spawn(function()
--             repeat task.wait() until Module.Settings.UniversalFlyPulseDelay
--             if enabled then
--                 for i,v in FlyData.PulseInstances do
--                     if v ~= self then
--                         v.Functions.SetVisiblity(true)
--                     end
--                 end
--             else
--                 for i,v in FlyData.PulseInstances do
--                     if v ~= self then
--                         v.Functions.SetVisiblity(false)
--                     end
--                 end
--             end
--         end)
--     end
-- }))

-- table.insert(FlyData.PulseInstances, Module.Functions.Settings.Slider({
--     Name = "Pulse Delay",
--     Min = 0,
--     Max = 150,
--     Default = 20,
--     Decimals = 0,
--     Flag = "UniversalFlyPulseDelay",
--     Callback = function(self, value)
--         FlyData.PulseDelay = value
--     end
-- }))

-- table.insert(FlyData.PulseInstances, Module.Functions.Settings.Slider({
--     Name = "Pulse Duration",
--     Min = 0,
--     Max = 150,
--     Default = 15,
--     Decimals = 0,
--     Flag = "UniversalFlyPulseDuration",
--     Callback = function(self, value)
--         FlyData.PulseDuration = value
--     end
-- }))

