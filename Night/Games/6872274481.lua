if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Night = getgenv().Night
local Assets = Night.Assets
local Functions = Assets.Functions :: {
    cloneref: (service: Instance) -> Instance, 
    IsAlive: (Player: Player) -> boolean,
    Notify: (Description: string, Duration: number, Flag: string | any) -> {Functions: {Remove: (RemoveAnimation: boolean) -> nil}}
}

local Noti = Assets.Notifications :: {Send: ({Description: string, Duration: number, Flag: string}) -> any}
local Tabs = Night.Tabs.Tabs

local Rep = Functions.cloneref(game:GetService("ReplicatedStorage")) ::ReplicatedStorage
local WS = Functions.cloneref(game:GetService("Workspace")) :: Workspace
local CS = Functions.cloneref(game:GetService("CollectionService")) :: CollectionService
local TS = Functions.cloneref(game:GetService("TweenService")) :: TweenService
local Plrs = Functions.cloneref(game:GetService("Players")) :: Players
local HttpService = Functions.cloneref(game:GetService("HttpService")) :: HttpService
local UIS = Functions.cloneref(game:GetService("UserInputService")) :: UserInputService
local RS = Functions.cloneref(game:GetService("RunService")) :: RunService
local LP = Plrs.LocalPlayer
local Cam = WS.CurrentCamera


Functions.Notify = function(Description: string, Duration: number, Flag: string | any)
    if Description == nil or not tonumber(Duration) then return "Failed to send make sure you have a description and a valid duration" end
    if setthreadidentity then
        pcall(setthreadidentity, 8)
    end
    if Flag then
        return Noti:Send({
            Description = tostring(Description),
            Duration = tonumber(Duration),
            Flag = tostring(Flag)
        }) :: {Functions: {
            Remove: (RemoveAnimation: boolean) -> nil
        }}
    else
        return Noti.Send({
            Description = tostring(Description),
            Duration = tonumber(Duration)
        }) :: {Functions: {
            Remove: (RemoveAnimation: boolean) -> nil
        }}
    end
end

local KnitPath = Rep.rbxts_include.node_modules["@easy-games"].knit
local Knit = require(KnitPath.src).KnitClient
local GameData = {
    Controllers = {
        Sword = Knit.Controllers.SwordController,
        Sprint = Knit.Controllers.SprintController,
        Balloon = Knit.Controllers.BalloonController,
        ViewModel = Knit.Controllers.ViewmodelController,
        BlockBreaker = Knit.Controllers.BlockBreakController.blockBreaker,
        Queue = Knit.Controllers.QueueController,
        Chest = Knit.Controllers.ChestController,
        TeamUpgrades = Knit.Controllers.TeamUpgradeController,
        TeamCrate = Knit.Controllers.TeamCrateController,
        SpiritAssasin = Knit.Controllers.SpiritAssassinController
    },
    Modules = {
        Remotes = require(Rep.TS.remotes).default.Client,
        Store = require(LP.PlayerScripts.TS.ui.store).ClientStore,
        Network = require(LP.PlayerScripts.TS.lib.network),
        DamageType = require(Rep.TS.damage["damage-type"]).DamageType,
        Inventory = require(Rep.TS.inventory["inventory-util"]).InventoryUtil,
        ItemMeta = require(Rep.TS.item["item-meta"]).items,
        Animation = require(Rep.TS.animation["animation-util"]).GameAnimationUtil,
        AnimationTypes = require(Rep.TS.animation["animation-type"]).AnimationType,
        ChargeState = require(Rep.TS.combat["charge-state"]).ChargeState,
        BlockEngine = require(Rep.rbxts_include.node_modules["@easy-games"]['block-engine'].out).BlockEngine,
        BlockRemotes = require(Rep.rbxts_include.node_modules["@easy-games"]['block-engine'].out.shared.remotes).BlockEngineRemotes,
        BlockPlacer = require(Rep.rbxts_include.node_modules["@easy-games"]['block-engine'].out.client.placement['block-placer']).BlockPlacer,
        BlockEngineClient = require(LP.PlayerScripts.TS.lib['block-engine']['client-block-engine']).ClientBlockEngine,
        PlayerUtil = require(Rep.TS.player["player-util"]).GamePlayerUtil,
        Promise = require(KnitPath.src.Knit.Util.Promise),
        SyncEvents = require(LP.PlayerScripts.TS["client-sync-events"]).ClientSyncEvents,
        ShopPurchase = require(LP.PlayerScripts.TS.controllers.global.shop.api["purchase-item"]).shopPurchaseItem,
        Shop = require(Rep.TS.games.bedwars.shop['bedwars-shop']).BedwarsShop,
        ArmorSets = require(Rep.TS.games.bedwars['bedwars-armor-set']),
        TeamUpgradeMeta = require(Rep.TS.games.bedwars["team-upgrade"]["team-upgrade-meta"])
    },
    Remotes = {},
    Events = {
        Damage = Instance.new("BindableEvent"),
        Death = Instance.new("BindableEvent")
    },
    GameEvents = {}
}

repeat task.wait() until GameData.Modules.Store:getState().Game and GameData.Modules.Store:getState().Game.matchState and Cam:FindFirstChild("Viewmodel")

local OnUninject = Assets.Main.OnUninject :: BindableEvent
table.insert(Night.Connections, OnUninject.Event:Connect(function()
    for i,v in GameData.Events do
        v:Destroy()
    end
    for i,v in GameData.GameEvents do
        if typeof(v) == "function" then
            v()
        elseif typeof(v) == "RBXScriptConnection" then
            v:Disconnect()
        end
    end
    table.clear(GameData.GameEvents)
    table.clear(GameData.Events)
end))


local Hit = GameData.Controllers.Sword.sendServerRequest
local SwordServerRequestConstants = debug.getconstants(Hit)
local find = table.find(SwordServerRequestConstants, "Client")
local HitRemoteName = SwordServerRequestConstants[find + 1]
if find and SwordServerRequestConstants[find + 1] then
    HitRemoteName = SwordServerRequestConstants[find + 1]
else
    for i,v in SwordServerRequestConstants do
        if v == "Client" then
            HitRemoteName = SwordServerRequestConstants[i + 1]
            return
        end
    end

    for i,v in SwordServerRequestConstants do
        if v == "SwordHit" then
            HitRemoteName = v
            return
        end
    end
end

if not HitRemoteName then
    Functions.Notify("Failed to get the hit remote, please send this to a dev, https://discord.gg/PvhQnTWaHy, copied to clipboard", 15)
    if setclipboard then
        setclipboard("https://discord.gg/PvhQnTWaHy")
    elseif toclipboard then
        toclipboard("https://discord.gg/PvhQnTWaHy")
    end
    return
end

local GetSpeedModifier = function(val: number)
	local speed = 0
	if Functions.IsAlive() then 
        local speedm = GameData.Controllers.Sprint:getMovementStatusModifier():getModifiers()
        for i,v in speedm do 
            if v and i.moveSpeedMultiplier then
                speed += (val * (i.moveSpeedMultiplier - 1)) / 2
            end
        end
    end

	return speed
end

local GetDistance = function(pos: Vector3, ignoreylevel: boolean)
    if Functions.IsAlive() then
        local LPos = LP.Character.HumanoidRootPart.Position :: Vector3
        if ignoreylevel then
            return (Vector3.new(LPos.X, pos.Y, LPos.Z) - pos).Magnitude
        else 
            return (LPos - pos).Magnitude
        end
    end
    return math.huge
end

local GetEntities = function()
    local Entities = {}
    for i,v in CS:GetTagged("entity") do
        Entities[v] = {
            PrimaryPart = v.PrimaryPart,
            Player = Plrs:GetPlayerFromCharacter(v),
            Health = v:GetAttribute("Health") or 0
        }
        if table.find(CS:GetTags(v), "Drone") then
            Entities[v].Drone = {Team = v:GetAttribute("Team"), Player = v:GetAttribute("PlayerUserId")}
        end
    end
    return Entities
end

local GetNearestEntity = function()
    local Data = {Entity = nil, Distance = math.huge}
    local Entities = GetEntities()
    for i,v in Entities do
        if v.Health > 0 and v.PrimaryPart and (v.PrimaryPart:IsA("Part") or v.PrimaryPart:IsA("BasePart")) then
            if v.Player and v.Player.Team ~= LP.Team and Functions.IsAlive(v.Player) or not v.Player then
                local Distance = GetDistance(v.PrimaryPart.Position, false)
                if Data.Distance > Distance then
                    Data = {
                        Entity = i,
                        Distance = Distance,
                        EntityData = v
                    }
                end
            end
        end
    end
    return Data
end

local GetInventory = function(plr: Player)
    plr = plr or LP
    return GameData.Modules.Inventory.getInventory(plr)
end

local GetItemType = function(Item: string, find: boolean, checkitemmeta: string)
    for i,v in GetInventory().items do
        if v and typeof(v) == "table" then
            if v.itemType then
                local metadata = GameData.Modules.ItemMeta[v.itemType]
                if Item and v.itemType == Item or Item and find and tostring(v.itemType):find(Item) then
                    return {Item = v, Meta = metadata}
                else
                    if checkitemmeta then
                        if metadata[checkitemmeta] then
                            return {Item = v, Meta = metadata}
                        end
                    end
                end
            end
        end
    end
    return
end

local GetBestSword = function()
    local inventory = GetInventory()
    local Sword = {Sword = nil, Damage = 0}
    for i,v in inventory.items do
        if GameData.Modules.ItemMeta[v.itemType] and GameData.Modules.ItemMeta[v.itemType].sword then
            local sword = GameData.Modules.ItemMeta[v.itemType].sword
            if sword.baseDamage > Sword.Damage then
                Sword = {Sword = v, Damage = sword.baseDamage}
            end
        end
    end
    return Sword
end

local scaleVector = function(vec, dist, height)
    return vec * Vector3.new(dist, height, dist)
end

local calcAngle = function(vec1, vec2)
    return math.acos(math.clamp(vec1:Dot(vec2), -1, 1))
end

local getAngle = function(look, plrpos, pos)
    local scaledVec = scaleVector(plrpos - pos, 1, 0)
    return calcAngle(look, scaledVec.Unit)
end

GameData.GameEvents.EntityDamage = GameData.Modules.Network.EntityDamageEventZap.On(function(...)
    GameData.Events.Damage:Fire({
        Player = ...,
        Damage = select(2, ...),
        DamageType = select(3, ...),
        Position = select(4, ...),
        Damager = select(5, ...),
        Idek = select(6, ...),
        Knockbackid = select(7, ...)
    })
end)

task.spawn(function()
    GameData.GameEvents.EntityDeath = GameData.Modules.Remotes:Get("EntityDeathEvent"):Connect(function(T)
        GameData.Events.Death:Fire({
            RespawnDuration = T.respawnDuration,
            Entity = T.entityInstance,
            ItemUsed = T.itemUsed,
            DeathPayout = T.deathPayout,
            FromEntity = T.fromEntity,
            MultiKillCount = T.multiKillCount,
            CFrame = T.cframe,
            FinalKill = T.finalKill,
            DamageType = T.damageType,
            TeamIdBeforeDeath = T.entityTeamIdBeforeDeath
        })
    end)
end)

Tabs.Movement.Modules.UniversalSpeedModule.Functions.Destroy()
Tabs.Movement.Modules.UniversalFlyModule.Functions.Destroy()


local SpeedData
(function()
    SpeedData = {
        Allowed = true,
        Settings = {
            Speed = 23,
            Increase = 45,
            Wallcheck = false,
            AutoJump = false,
            AutoJumpDistance = 18,
            DamageBoostAddition = 25,
            BoostTime = 0.5,
            CurrentDamageBoost = 0,
            LastHit = os.clock(),
            SpeedUpCooldown = false,
            AlwaysJump = false,
            DamageBoost = false
        },
        Connections = {}
    }

    SpeedData.Toggle = Tabs.Movement.Functions.NewModule({
        Name = "Speed",
        Description = "Lets you move faster",
        Icon = "rbxassetid://90453358286627",
        Flag = "Speed",
        Callback = function(self, Callback: boolean)
            if Callback then
                table.insert(SpeedData.Connections, GameData.Events.Damage.Event:Connect(function(data)
                    if SpeedData.Settings.DamageBoost and not SpeedData.Settings.SpeedUpCooldown then
                        if data.Player and data.Player == LP.Character and data.Damager and (data.DamageType ~= GameData.Modules.DamageType.FALL and data.DamageType ~= GameData.Modules.DamageType.VOID) then
                            SpeedData.Settings.LastHit = os.clock()
                            SpeedData.Settings.CurrentDamageBoost = SpeedData.Settings.DamageBoostAddition
                            task.delay(SpeedData.Settings.BoostTime, function()
                                if os.clock() - SpeedData.Settings.LastHit >= SpeedData.Settings.BoostTime then
                                    SpeedData.Settings.CurrentDamageBoost = 0
                                else
                                    SpeedData.Settings.SpeedUpCooldown = true
                                    task.delay(0.25, function()
                                        SpeedData.Settings.SpeedUpCooldown = false
                                    end)
                                end
                            end)
                        end
                    end
                end))

                repeat
                    if Functions.IsAlive() and SpeedData.Allowed then
                        local Multiplier = GetSpeedModifier(SpeedData.Settings.Increase) + SpeedData.Settings.CurrentDamageBoost :: number
                        local MoveDir = LP.Character.Humanoid.MoveDirection :: Vector3
                        local Velocity = LP.Character.HumanoidRootPart.AssemblyLinearVelocity :: Vector3
                        
                        if MoveDir.Magnitude > 0 then
                            if SpeedData.Settings.Wallcheck then
                                local RPrams = RaycastParams.new()
                                RPrams.FilterType = Enum.RaycastFilterType.Include
                                RPrams.FilterDescendantsInstances = CS:GetTagged("block")
                                local rcast = WS:Raycast(LP.Character.HumanoidRootPart.Position, MoveDir * 2, RPrams)
                                if rcast and rcast.Instance then
                                    task.wait()
                                    continue
                                end
                            end

                            LP.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(MoveDir.X * (SpeedData.Settings.Speed + Multiplier), Velocity.Y, MoveDir.Z * (SpeedData.Settings.Speed + Multiplier))
                            if SpeedData.Settings.AutoJump then
                                local NearestEntity = GetNearestEntity()
                                if NearestEntity.Entity and SpeedData.Settings.AutoJumpDistance >= NearestEntity.Distance or SpeedData.Settings.AlwaysJump then
                                    if LP.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
                                        LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                    end
                                end
                            end
                        end
                    end
                    task.wait()
                until not self.Data.Enabled
            else
                for i,v in SpeedData.Connections do 
                    v:Disconnect()
                end
                table.clear(SpeedData.Connections)
            end
        end
    })

    SpeedData.Toggle.Functions.Settings.Slider({
        Name = "Speed",
        Description = "What speed you want to move at",
        Min = 0,
        Max = 23,
        Default = 23,
        Flag = "SpeedValue",
        Callback = function(self, speed)
            SpeedData.Settings.Speed = speed
        end
    })

    SpeedData.Toggle.Functions.Settings.Slider({
        Name = "Boost Increase",
        Description = "Value to increase when using a speed boost",
        Min = 20,
        Max = 45, 
        Default = 45,
        Flag = "SpeedBoostIncrease",
        Callback = function(self, callback: number)
            SpeedData.Settings.Increase = callback
        end
    })

    local AutoJumpDist, AlwaysJump
    SpeedData.Toggle.Functions.Settings.MiniToggle({
        Name = "Auto Jump",
        Description = "Automatically jumps around enemies",
        Default = true,
        Flag = "SpeedAutoJump",
        Callback = function(self, enabled: boolean)
            SpeedData.Settings.AutoJump = enabled
            task.spawn(function()
                repeat task.wait() until AutoJumpDist and AlwaysJump
                AutoJumpDist.Functions.SetVisiblity(enabled)
                AlwaysJump.Functions.SetVisiblity(enabled)
            end)
        end
    })

    AutoJumpDist = SpeedData.Toggle.Functions.Settings.Slider({
        Name = "Auto Jump Distance",
        Description = "Distance to start auto jumping",
        Min = 1,
        Max = 18,
        Default = 18,
        Hide = true,
        Flag = "SpeedAutoJumpDistance",
        Callback = function(self, callback: number)
            SpeedData.Settings.AutoJumpDistance = callback
        end
    })

    AlwaysJump = SpeedData.Toggle.Functions.Settings.MiniToggle({
        Name = "Always Jump",
        Description = "Always jump no matter being neary a enemy",
        Default = false,
        Flag = "SpeedAlwaysJump",
        Callback = function(self, callback)
            SpeedData.Settings.AlwaysJump = callback
        end
    })

    SpeedData.Toggle.Functions.Settings.MiniToggle({
        Name = "Wall Check",
        Description = "Automatically stops when your walking into walls",
        Flag = "SpeedWallCheck",
        Default = true,
        Callback = function(self, enabled)
            SpeedData.Settings.Wallcheck = enabled
        end
    });

    local DamageBoostSpeed, DamageBoostTime
    SpeedData.Toggle.Functions.Settings.MiniToggle({
        Name = "Damage Boost",
        Description = "Gain some extra speed when you take damage",
        Flag = "SpeedDamageBoost",
        Default = true,
        Callback = function(self, callback)
            SpeedData.Settings.DamageBoost = callback
            task.spawn(function()
                repeat task.wait() until DamageBoostSpeed and DamageBoostTime
                DamageBoostSpeed.Functions.SetVisiblity(callback)
                DamageBoostTime.Functions.SetVisiblity(callback)
            end)
        end
    })

    DamageBoostSpeed = SpeedData.Toggle.Functions.Settings.Slider({
        Name = "Damage Boost Increase",
        Description = "Amount of speed to boost",
        Min = 1,
        Max = 30,
        Default = 25,
        Hide = true,
        Flag = "SpeedDamageBoostIncrease",
        Callback = function(self, callback)
            SpeedData.Settings.DamageBoostAddition = callback
        end
    })

    DamageBoostTime = SpeedData.Toggle.Functions.Settings.Slider({
        Name = "Damage Boost Time",
        Description = "Amount of time the boost runs for",
        Min = 0.3,
        Max = 1.2,
        Decimals = 1,
        Default = 0.5,
        Hide = true,
        Flag = "SpeedDamageBoostTime",
        Callback = function(self, callback)
            SpeedData.Settings.BoostTime = callback
        end
    })
end)();

local FlyData = {
    Settings = {
        Speed = 23,
        BoostIncrease = 25,
        TPDown = false,
        DamageBoost = false,
        DamageBoostSpeed = 45,
        DamageBoostTime = 1,
        DamageBoostCooldown = false,
        CurrentBoost = 0,
        LastHit = os.clock(),
        UseBalloons = false,
        DeflateBalloon = false,
        Vertical = false,
        VerticalValue = 0,
        VericalAmount = 30,
        LastOnGround = os.clock()
    },
    Allowed = true,
    Connections = {}
}

(function()
    FlyData.Toggle = Tabs.Movement.Functions.NewModule({
        Name = "Fly",
        Description = "Lets you fly",
        Icon = "rbxassetid://131835120840758",
        Flag = "Fly",
        Callback = function(self, callback)
            if callback then
                table.insert(FlyData.Connections, GameData.Events.Damage.Event:Connect(function(data)
                    if FlyData.Settings.DamageBoost and not FlyData.Settings.DamageBoostCooldown then
                        if data.Player and data.Player == LP.Character and data.Damager and (data.DamageType ~= GameData.Modules.DamageType.FALL and data.DamageType ~= GameData.Modules.DamageType.VOID) then
                            FlyData.Settings.LastHit = os.clock()
                            FlyData.Settings.CurrentBoost = FlyData.Settings.DamageBoostSpeed
                            task.delay(FlyData.Settings.DamageBoostTime, function()
                                if os.clock() - FlyData.Settings.LastHit >= FlyData.Settings.DamageBoostTime then
                                    FlyData.Settings.CurrentBoost = 0
                                else
                                    FlyData.Settings.DamageBoostCooldown = true
                                    task.delay(0.25, function()
                                        FlyData.Settings.DamageBoostCooldown = false
                                    end)
                                end
                            end)
                        end
                    end
                end))

                FlyData.Settings.LastOnGround = os.clock()
                repeat
                    SpeedData.Allowed = false
                    if Functions.IsAlive() and FlyData.Allowed then
                        local SpeedMultiplier = GetSpeedModifier(FlyData.Settings.BoostIncrease) + FlyData.Settings.CurrentBoost :: number
                        local MoveDir = LP.Character.Humanoid.MoveDirection :: Vector3
                        local UsingBalloon = false
                        local balloons = LP.Character:GetAttribute("InflatedBalloons")
                        local YVelocityDev = FlyData.Settings.VericalAmount * FlyData.Settings.VerticalValue + ((balloons and balloons ~= 0) and 2 * 3 or 0) * (tick() % (2 / 5) < 1 / 5 and -1 or 1) + 3 / 1.8

                        if not balloons or 1 > balloons then
                            if FlyData.Settings.UseBalloons then
                                local balloon = GetItemType("balloon", false, false)
                                if balloon and balloon.Item then
                                    GameData.Controllers.Balloon:inflateBalloon()
                                end
                            end
                            if not balloons or 1 > balloons then
                                if os.clock() - FlyData.Settings.LastOnGround >= 2.5 then
                                    if FlyData.Settings.TPDown then
                                        local RayPrams = RaycastParams.new()
                                        RayPrams.FilterType = Enum.RaycastFilterType.Include
                                        RayPrams.FilterDescendantsInstances = CS:GetTagged("block")
                                        local RAY = WS:Raycast(LP.Character.HumanoidRootPart.Position, -Vector3.new(0,10000,0), RayPrams)
                                        local Pos = LP.Character.HumanoidRootPart.Position :: Vector3
                                        if RAY and RAY.Instance then
                                            LP.Character.HumanoidRootPart.CFrame = CFrame.new(Pos.X, RAY.Position.Y, Pos.Z)
                                            FlyData.Settings.LastOnGround = os.clock()
                                            task.wait(0.05)
                                            local newpos = LP.Character.HumanoidRootPart.Position :: Vector3
                                            LP.Character.HumanoidRootPart.CFrame = CFrame.new(newpos.X, Pos.Y, newpos.Z)
                                        end
                                    end
                                end
                            end
                        end
                        
                        if LP.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
                            FlyData.Settings.LastOnGround = os.clock()
                        end

                        LP.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(MoveDir.X * (FlyData.Settings.Speed + SpeedMultiplier), YVelocityDev, MoveDir.Z * (FlyData.Settings.Speed + SpeedMultiplier))
                        if UsingBalloon then
                            task.wait(0.3)
                        end
                    end

                    task.wait()
                until not self.Data.Enabled
            else
                SpeedData.Allowed = true
                for i,v in FlyData.Connections do
                    v:Disconnect()
                end
                table.clear(FlyData.Connections)

                if FlyData.Settings.DeflateBalloon then
                    local balloons = LP.Character:GetAttribute("InflatedBalloons")
                    if balloons and balloons > 0 then
                        for i = 1, balloons do 
                            GameData.Controllers.Balloon:deflateBalloon()
                        end
                    end
                end
            end
        end
    })

    FlyData.Toggle.Functions.Settings.Slider({
        Name = "Speed",
        Description = "Speed to fly at",
        Min = 0,
        Max = 23,
        Default = 23,
        Flag = "FlySpeed",
        Callback = function(self, callback)
            FlyData.Settings.Speed = callback
        end
    })

    FlyData.Toggle.Functions.Settings.Slider({
        Name = "Speed Increase",
        Description = "Amount of speed to increase with a boost",
        Min = 20,
        Max = 45,
        Default = 45,
        Flag = "FlySpeedIncrease",
        Callback = function(self, callback)
            FlyData.Settings.BoostIncrease = callback
        end
    })

    local VerticalSpeed, VerticalKeybinds = nil, {}

    FlyData.Toggle.Functions.Settings.MiniToggle({
        Name = "Vertical",
        Description = "Lets you move up and down",
        Default = true, 
        Flag = "FlyVertical",
        Callback = function(self, callback)
            FlyData.Settings.Vertical = callback
            task.spawn(function()
                repeat task.wait() until VerticalSpeed and #VerticalKeybinds == 2
                VerticalSpeed.Functions.SetVisiblity(callback)
                for i,v in VerticalKeybinds do
                    v.Functions.SetVisiblity(callback)
                end
            end)
        end
    })

    VerticalSpeed = FlyData.Toggle.Functions.Settings.Slider({
        Name = "Vertical Speed",
        Description = "Speed to move up and down at",
        Min = 10,
        Max = 50,
        Default = 30,
        Flag = "FlyVerticalSpeed",
        Hide = true,
        Callback = function(self, callback)
            FlyData.Settings.VericalAmount = callback
        end
    })

    table.insert(VerticalKeybinds, FlyData.Toggle.Functions.Settings.Keybind({
        Name = "Fly Up Keybind",
        Description = "Keybind to fly up",
        Default = "Space",
        Hide = true,
        Flag = "FlyKeybindUp",
        Callbacks = {
            Began = function()
                if FlyData.Settings.Vertical then
                    FlyData.Settings.VerticalValue = 1
                end
            end,
            End = function()
                FlyData.Settings.VerticalValue = 0
            end
        }
    }))

    table.insert(VerticalKeybinds, FlyData.Toggle.Functions.Settings.Keybind({
        Name = "Fly Down Keybind",
        Description = "Keybind to fly down",
        Default = "LeftShift",
        Hide = true,
        Flag = "FlyKeybindDown",
        Callbacks = {
            Began = function()
                if FlyData.Settings.Vertical then
                    FlyData.Settings.VerticalValue = -1
                end
            end,
            End = function()
                FlyData.Settings.VerticalValue = 0
            end
        }
    }))

    FlyData.Toggle.Functions.Settings.MiniToggle({
        Name = "Inflate Balloons",
        Description = "Inflates balloons if you have any",
        Default = true,
        Flag = "FlyInflateBalloons",
        Callback = function(self, callback)
            FlyData.Settings.UseBalloons = callback
        end
    })

    FlyData.Toggle.Functions.Settings.MiniToggle({
        Name = "Deflate Balloons",
        Description = "Deflate balloons if your using any when you disable",
        Default = true,
        Flag = "FlyDeflateBalloons",
        Callback = function(self, callback)
            FlyData.Settings.DeflateBalloon = callback
        end
    })

    FlyData.Toggle.Functions.Settings.MiniToggle({
        Name = "TP Down",
        Description = "Teleports to the ground if you run out of fly time",
        Default = true,
        Flag = "FlyTPDown",
        Callback = function(self, callback)
            FlyData.Settings.TPDown = callback
        end
    })

    local BoostStuff = {}
    FlyData.Toggle.Functions.Settings.MiniToggle({
        Name = "Damage Boost",
        Description = "Speeds you up when you take damage",
        Flag = "FlyDamageBoost",
        Default = true,
        Callback = function(self, callback)
            FlyData.Settings.DamageBoost = callback
            task.spawn(function()
                for i,v in BoostStuff do
                    v.Functions.SetVisiblity(callback)
                end
            end)
        end
    })

    table.insert(BoostStuff, FlyData.Toggle.Functions.Settings.Slider({
        Name = "Damage Speed Increase",
        Description = "Amount of speed to increase when damage boosting",
        Min = 0,
        Max = 30,
        Default = 25,
        Hide = true,
        Flag = "FlySpeedDamageIncrease",
        Callback = function(self, callback)
            FlyData.Settings.DamageBoostSpeed = callback
        end
    }))

    table.insert(BoostStuff, FlyData.Toggle.Functions.Settings.Slider({
        Name = "Damage Speed Time",
        Description = "Amount of time damage boost for",
        Min = 0.3,
        Max = 1.2,
        Default = 0.5,
        Decimals = 1,
        Hide = true,
        Flag = "FlySpeedDamageTime",
        Callback = function(self, callback)
            FlyData.Settings.DamageBoostTime = callback
        end
    }))
end)();

(function()
    local KillAuraData = {
        Settings = {
            Range = 18,
            Ratio = 0.65,
            MaxAngle = 360,
            Prediction = 15,
            WallCheck = false,
            RandomRatio = false,
            RequireMouseDown = false,
            MouseDown = false,
            HandCheck = false,
            AutomaticallySwitch = false,
            Visuals = {
                Highlight = false,
                HighlightColor = {R = 22, G = 59, B = 228},
                HightLightTransparency = 0.5,
                Highlights = {},
                Particles = false,
                ParticleColor = {Start = {R = 100, G = 150, B = 235}, End = {R = 0, G = 0, B = 140}},
                CustomAnim = false,
                PickedAnimation = "Air"
            }
        },
        anim = {
            pos = nil,
            playing = false,
            oldanim = nil,
            old = Cam.Viewmodel.RightHand.RightWrist.C0,
            main = {
                Night = {
                    {Pos = {X = 0.7, Y = -0.7, Z = 0.65, Angle = CFrame.Angles(math.rad(-70), math.rad(60), math.rad(-70))}, Dur = 0.15},
                    {Pos = {X = 0.5, Y = -0.7, Z = -0.3, Angle = CFrame.Angles(math.rad(-120), math.rad(70), math.rad(-50))}, Dur = 0.15}
                },
                Smooth = {
                    {Pos = {X = -0.01, Y = -0.3, Z = -1.01, Angle = CFrame.Angles(math.rad(-35), math.rad(90), math.rad(-90))}, Dur = 0.45},
                    {Pos = {X = -0.01, Y = -0.3, Z = -1.01, Angle = CFrame.Angles(math.rad(-35), math.rad(70), math.rad(-90))}, Dur = 0.45},
                    {Pos = {X = -0.01, Y = -0.3, Z = 0.4, Angle = CFrame.Angles(math.rad(-35), math.rad(70), math.rad(-90))}, Dur = 0.32},
                },
                Funny = {
                    {Pos = {X = 0.8, Y = 10.7, Z = 3.6, Angle = CFrame.Angles(math.rad(-16), math.rad(60), math.rad(-80))}, Dur = 0.1},
                    {Pos = {X = 5.7, Y = -1.7, Z = 5.6, Angle = CFrame.Angles(math.rad(-16), math.rad(60), math.rad(-80))}, Dur = 0.15},
                    {Pos = {X = 2.95, Y = -5.06, Z = -6.25, Angle = CFrame.Angles(math.rad(-180), math.rad(60), math.rad(-80))}, Dur = 0.15},
                },
                Stand = {
                    {Pos = {X = 0.7, Y = -0.7, Z = 0.6, Angle = CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90))}, Dur = 0.1}
                },
                Air = {
                    {Pos = {X = 1.2, Y = -1.5, Z = -1, Angle = CFrame.Angles(math.rad(305), math.rad(55), math.rad(140))}, Dur = 0.2},
                    {Pos = {X = 1.2, Y = -1.5, Z = -1.2, Angle = CFrame.Angles(math.rad(200), math.rad(55), math.rad(230))}, Dur = 0.15},
                },
                Hit = {
                    {Pos = {X = 0, Y = 0, Z = -0.7, Angle = CFrame.Angles(math.rad(-60), math.rad(50), math.rad(-60))}, Dur = 0.12},
                    {Pos = {X = 0, Y = -0.35, Z = -0.7, Angle = CFrame.Angles(math.rad(-150), math.rad(60), math.rad(15))}, Dur = 0.2},
                },
                Rise = {
                    {Pos = {X = 1, Y = 0, Z = 0, Angle = CFrame.Angles(math.rad(-40), math.rad(40), math.rad(-80))}, Dur = 0.15},
                    {Pos = {X = 1, Y = 0, Z = -0.4, Angle = CFrame.Angles(math.rad(-80), math.rad(40), math.rad(-70))}, Dur = 0.17},
                },
                Moon = {
                    {Pos = {X = 0.85, Y = -0.8, Z = 0.6, Angle = CFrame.Angles(math.rad(-40), math.rad(70), math.rad(-90))}, Dur = 0.15},
                    {Pos = {X = 0.5, Y = -0.6, Z = 0.6, Angle = CFrame.Angles(math.rad(-50), math.rad(50), math.rad(-100))}, Dur = 0.12},
                },
                Lunar = {
                    {Pos = {X = 0.3, Y = 0, Z = -1.5, Angle = CFrame.Angles(math.rad(120), math.rad(120), math.rad(140))}, Dur = 0.2},
                    {Pos = {X = 0, Y = -0.3, Z = -1.7, Angle = CFrame.Angles(math.rad(30), math.rad(120), math.rad(190))}, Dur = 0.2},
                }
            }
        },
        Connections = {}
    }

    KillAuraData.Toggle = Tabs.Combat.Functions.NewModule({
        Name = "KillAura",
        Description = "Automatically attacks enemies near you",
        Icon = "rbxassetid://108945365943475",
        Flag = "KillAura",
        Callback = function(self, callback)
            if callback then
                table.insert(KillAuraData.Connections, UIS.InputBegan:Connect(function(a0: InputObject, a1: boolean)  
                    if a0.UserInputType == Enum.UserInputType.MouseButton1 or a0.UserInputType == Enum.UserInputType.Touch then
                        KillAuraData.Settings.MouseDown = true
                    end
                end))

                table.insert(KillAuraData.Connections, UIS.InputEnded:Connect(function(a0: InputObject, a1: boolean)  
                    if a0.UserInputType == Enum.UserInputType.MouseButton1 or a0.UserInputType == Enum.UserInputType.Touch then
                        KillAuraData.Settings.MouseDown = false
                    end
                end))

                KillAuraData.anim.oldanim = GameData.Controllers.ViewModel.playAnimation
                GameData.Controllers.ViewModel.playAnimation = function(...)
                    local args = {...}
                    if args[2] and (args[2] == 15 or args[2] == 764 or args[2] == 763) and KillAuraData.anim.playing then
                        return 
                    end
                    return KillAuraData.anim.oldanim(...)
                end

                repeat
                    task.wait(0.045)
                    local NearestEntity = GetNearestEntity()
                    if NearestEntity.Entity and KillAuraData.Settings.Range >= NearestEntity.Distance and GameData.Modules.Remotes:Get(HitRemoteName) then
                        local Sword = GetBestSword()
                        if Sword.Sword and Sword.Sword.tool then
                            if KillAuraData.Settings.AutomaticallySwitch then
                                GameData.Modules.Remotes:Get("SetInvItem"):CallServerAsync({
                                    ["hand"] = Sword.Sword.tool
                                })
                            end

                            local CurrentItem = GetInventory().hand 
                            if KillAuraData.Settings.HandCheck then
                                if CurrentItem and CurrentItem.itemType then
                                    local itemMeta = GameData.Modules.ItemMeta[CurrentItem.itemType]
                                    if not itemMeta or not itemMeta.sword then
                                        continue
                                    end
                                else
                                    continue
                                end
                            end
                            if KillAuraData.Settings.RequireMouseDown and not KillAuraData.Settings.MouseDown then continue end

                            local EntityRoot = NearestEntity.EntityData.PrimaryPart
                            if EntityRoot then
                                local EntityPos = EntityRoot.Position
                                if getAngle(LP.Character.HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1), EntityPos, LP.Character.HumanoidRootPart.Position) > KillAuraData.Settings.MaxAngle / 2 * math.pi / 180 then
                                    continue
                                end 
                                if KillAuraData.Settings.WallCheck then
                                    local RPrams = RaycastParams.new()
                                    RPrams.FilterType = Enum.RaycastFilterType.Include
                                    RPrams.FilterDescendantsInstances = CS:GetTagged("block")
                                    local Ray = WS:Raycast(LP.Character.HumanoidRootPart, EntityPos)
                                    if Ray and Ray.Instance then
                                        continue
                                    end
                                end

                                local itemMeta
                                if not CurrentItem or not CurrentItem.tool or not CurrentItem.itemType then
                                    GameData.Modules.Remotes:Get("SetInvItem"):CallServerAsync({
                                        ["hand"] = Sword.Sword.tool
                                    })
                                else
                                    itemMeta = GameData.Modules.ItemMeta[CurrentItem.itemType]
                                    if not itemMeta or not itemMeta.sword then
                                        GameData.Modules.Remotes:Get("SetInvItem"):CallServerAsync({
                                            ["hand"] = Sword.Sword.tool
                                        })
                                    end
                                end

                                local ChargeRatio = KillAuraData.Settings.Ratio
                                if KillAuraData.Settings.RandomRatio then
                                    if math.random(1, 2) == 1 then
                                        ChargeRatio = Random.new():NextNumber(0, 1)
                                    end
                                end

                                task.spawn(function()
                                    if not KillAuraData.Settings.Visuals.Highlights[NearestEntity] and KillAuraData.Settings.Visuals.Highlight then
                                        local Highlight = Instance.new("Part", EntityRoot)
                                        Highlight.Transparency = KillAuraData.Settings.Visuals.HightLightTransparency
                                        Highlight.Anchored = true
                                        Highlight.Material = Enum.Material.SmoothPlastic
                                        Highlight.CanCollide = false
                                        Highlight.CFrame = EntityRoot.CFrame
                                        Highlight.Color = Color3.fromRGB(KillAuraData.Settings.Visuals.HighlightColor.R, KillAuraData.Settings.Visuals.HighlightColor.G, KillAuraData.Settings.Visuals.HighlightColor.B)
                                        Highlight.Size = Vector3.new(4, 6, 4)

                                        for i,v in KillAuraData.Settings.Visuals.Highlights do
                                            v:Destroy()
                                            KillAuraData.Settings.Visuals.Highlights[i] = nil
                                        end
                                        KillAuraData.Settings.Visuals.Highlights[NearestEntity] = Highlight
                                    end
                                end)

                                task.spawn(function()
                                    if KillAuraData.Settings.Visuals.Particles then
                                        local Particle = Instance.new("ParticleEmitter", EntityRoot)
                                        Particle.Size = NumberSequence.new{NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 0.6)}
                                        Particle.Drag = 10
                                        Particle.Speed = NumberRange.new(20, 50)
                                        Particle.SpreadAngle = Vector2.new(360, 360)
                                        Particle.Rate = 10
                                        Particle.Lifetime = NumberRange.new(0.5, 1)
                                        Particle.Rotation = NumberRange.new(1, 360)
                                        Particle.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(KillAuraData.Settings.Visuals.ParticleColor.Start.R, KillAuraData.Settings.Visuals.ParticleColor.Start.G, KillAuraData.Settings.Visuals.ParticleColor.Start.B)), ColorSequenceKeypoint.new(1, Color3.fromRGB(KillAuraData.Settings.Visuals.ParticleColor.End.R, KillAuraData.Settings.Visuals.ParticleColor.End.G, KillAuraData.Settings.Visuals.ParticleColor.End.B))}
                                        Particle.Texture = math.random(1, 2) == 1 and "rbxassetid://134430724029611" or "rbxassetid://102948578222494"
                                        
                                        task.delay(0.3, function()
                                            Particle.Enabled = false
                                            task.wait(0.3)
                                            Particle:Destroy()
                                        end)
                                    else
                                        if ChargeRatio >= 0.4 and GameData.Controllers.Sword:getChargeState() == GameData.Modules.ChargeState.Idle then
                                            GameData.Controllers.Sword:startCharging(Sword.Sword.itemType, 0)
                                        else
                                            GameData.Modules.Animation:playAnimation(LP, GameData.Modules.AnimationTypes.SWORD_SWING)
                                        end
                                    end
                                end)

                                task.spawn(function()
                                    if KillAuraData.Settings.Visuals.CustomAnim then
                                        if not KillAuraData.anim.pos and Cam.Viewmodel.RightHand.RightWrist then
                                            KillAuraData.anim.pos = Cam.Viewmodel.RightHand.RightWrist.C0
                                        end

                                        if not KillAuraData.anim.playing then
                                            KillAuraData.anim.playing = true
                                            for _, v in next, KillAuraData.anim.main[KillAuraData.Settings.Visuals.PickedAnimation] do
                                                TS:Create(Cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(v.Dur), {C0 = KillAuraData.anim.pos * CFrame.new(v.Pos.X, v.Pos.Y, v.Pos.Z) * v.Pos.Angle}):Play()
                                                task.wait(v.Dur)
                                            end
                                            KillAuraData.anim.playing = false
                                        end
                                    end
                                end)

                                local calc, pos = KillAuraData.Settings.Prediction / 30, LP.Character.HumanoidRootPart.Position
                                local selfPos, dir = (((pos - EntityPos).Magnitude - (KillAuraData.Settings.Prediction - (calc + 0.1)) > 0) and ((pos - EntityPos).Magnitude - (KillAuraData.Settings.Prediction - (calc + 0.1))) or 0) * CFrame.lookAt(pos, EntityPos).LookVector + pos, (EntityPos - Cam.CFrame.Position)                            
                                GameData.Modules.Remotes:Get(HitRemoteName):SendToServer({
                                    weapon = Sword.Sword.tool,
                                    entityInstance = NearestEntity.Entity,
                                    chargeRatio = ChargeRatio,
                                    validate = {
                                        raycast = {
                                            cameraPosition = {value = selfPos},
                                            rayDirection = {value = (dir / dir.Magnitude * (NearestEntity.Distance <= 20 and 2 or 1))}
                                        },
                                        targetPosition = {value = EntityPos},
                                        selfPosition = {value = selfPos}
                                    }
                                })

                                if GameData.Controllers.Sword:getChargeState() == GameData.Modules.ChargeState.Charging then
                                    GameData.Controllers.Sword:stopCharging(Sword.Sword.itemType)
                                    GameData.Controllers.Sword:playSwordEffect(itemMeta, ChargeRatio)
                                end

                                if CurrentItem and CurrentItem.tool and CurrentItem.tool ~= Sword.Sword.tool then
                                    if not KillAuraData.Settings.AutomaticallySwitch then
                                        GameData.Modules.Remotes:Get("SetInvItem"):CallServerAsync({
                                            ["hand"] = CurrentItem.tool
                                        })
                                    end
                                end
                            else
                                if KillAuraData.anim.old then
                                    task.spawn(function()
                                        repeat task.wait() until not KillAuraData.anim.playing
                                        TS:Create(Cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.5), {C0 = KillAuraData.anim.old}):Play()
                                    end)
                                end

                                for i,v in KillAuraData.Settings.Visuals.Highlights do
                                    v:Destroy()
                                    KillAuraData.Settings.Visuals.Highlights[i] = nil
                                end
                            end
                        end
                    else
                        if KillAuraData.anim.old then
                            task.spawn(function()
                                repeat task.wait() until not KillAuraData.anim.playing
                                TS:Create(Cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.5), {C0 = KillAuraData.anim.old}):Play()
                            end)
                        end

                        for i,v in KillAuraData.Settings.Visuals.Highlights do
                            v:Destroy()
                            KillAuraData.Settings.Visuals.Highlights[i] = nil
                        end
                    end
                until not self.Data.Enabled
            else
                GameData.Controllers.ViewModel.playAnimation = KillAuraData.anim.oldanim
                if KillAuraData.anim.old then
                    task.spawn(function()
                        repeat task.wait() until not KillAuraData.anim.playing
                        TS:Create(Cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.5), {C0 = KillAuraData.anim.old}):Play()
                    end)
                end

                for i,v in KillAuraData.Settings.Visuals.Highlights do
                    v:Destroy()
                    KillAuraData.Settings.Visuals.Highlights[i] = nil
                end
            end
        end
    })
    
    KillAuraData.Toggle.Functions.Settings.Slider({
        Name = "Range",
        Min = 0,
        Max = 18,
        Default = 18,
        Flag = "KillAuraRange",
        Callback = function(self, callback)
            KillAuraData.Settings.Range = callback
        end
    })

    local ChargeRatio = KillAuraData.Toggle.Functions.Settings.Slider({
        Name = "Charge Ratio",
        Description = "Amount of charge to use on a hit",
        Min = 0,
        Max = 1,
        Default = 0.65,
        Decimals = 2,
        Flag = "KillAuraChargeRatio",
        Hide = true,
        Callback = function(self, callback)
            KillAuraData.Settings.Ratio = callback
        end
    })

    KillAuraData.Toggle.Functions.Settings.MiniToggle({
        Name = "Random Charge",
        Description = "Randomly charges some hits with random charges",
        Default = false,
        Flag = "KillAuraRandomCharge",
        Callback = function(self, callback)
            KillAuraData.Settings.RandomRatio = callback
            ChargeRatio.Functions.SetVisiblity(not callback)
        end
    })

    KillAuraData.Toggle.Functions.Settings.Slider({
        Name = "Max Angle",
        Description = "Max angle you can hit",
        Min = 0,
        Max = 360,
        Default = 360,
        Flag = "KillAuraMaxAngle",
        Callback = function(self, callback)
            KillAuraData.Settings.MaxAngle = callback
        end
    })

    KillAuraData.Toggle.Functions.Settings.Slider({
        Name = "Prediction",
        Description = "Range to check the prediction",
        Min = 0,
        Max = 15,
        Default = 15,
        Decimals = 1,
        Flag = "KillAuraPrediction",
        Callback = function(self, callback)
            KillAuraData.Settings.Prediction = callback
        end
    })

    KillAuraData.Toggle.Functions.Settings.MiniToggle({
        Name = "Wall Check",
        Description = "Stops you hitting players from the other side of walls",
        Default = false,
        Flag = "KillAuraWallCheck",
        Callback = function(self, callback)
            KillAuraData.Settings.WallCheck = callback
        end
    })

    KillAuraData.Toggle.Functions.Settings.MiniToggle({
        Name = "Require Mouse Down",
        Description = "Only hits if your holding your mouse(or screen)",
        Default = false,
        Flag = "KillAuraRequireMouseDown",
        Callback = function(self, callback)
            KillAuraData.Settings.RequireMouseDown = callback
        end
    })

    KillAuraData.Toggle.Functions.Settings.MiniToggle({
        Name = "Hand Check",
        Description = "Only hits if you have a sword in your hand",
        Default = false,
        Flag = "KIllAuraHandCheck",
        Callback = function(self, callback)
            KillAuraData.Settings.HandCheck = callback
        end
    })

    KillAuraData.Toggle.Functions.Settings.MiniToggle({
        Name = "Automatically Switch",
        Description = "Automatically switches to your sword",
        Default = false,
        Flag = "KillAuraAutoSwitch",
        Callback = function(self, callback)
            KillAuraData.Settings.AutomaticallySwitch = callback
        end
    })

    local AnimOptions
    KillAuraData.Toggle.Functions.Settings.MiniToggle({
        Name = "Animation",
        Description = "A custom sword animation when attacking",
        Default = true,
        Flag = "KillAuraAnimation",
        Callback = function(self, callback)
            KillAuraData.Settings.Visuals.CustomAnim = callback
            task.spawn(function()
                repeat task.wait() until AnimOptions
                AnimOptions.Functions.SetVisiblity(callback)
            end)
        end
    })

    AnimOptions = KillAuraData.Toggle.Functions.Settings.Dropdown({
        Name = "Animation",
        Description = "Animation to play",
        Default = "Air",
        Hide = true,
        Options = {"Air", "Night", "Smooth", "Funny", "Stand", "Hit", "Rise", "Moon", "Lunar"},
        Flag = "KillAuraAnimationPick",
        Callback = function(self, value)
            KillAuraData.Settings.Visuals.PickedAnimation = value
        end
    })

    local HighLightOptions = {}
    KillAuraData.Toggle.Functions.Settings.MiniToggle({
        Name = "Highlights",
        Description = "Hightlights the target entity",
        Default = true,
        Flag = "KillAuraHighLights",
        Callback = function(self, callback)
            KillAuraData.Settings.Visuals.Highlight = callback
            task.spawn(function()
                repeat task.wait() until #HighLightOptions == 2
                for i,v in HighLightOptions do 
                    v.Functions.SetVisiblity(callback)
                end
            end)
        end
    })

    table.insert(HighLightOptions, KillAuraData.Toggle.Functions.Settings.TextBox({
        Name = "Highlight Color",
        Description = "Color of the highlight",
        Default = "22, 59, 228",
        Hide = true,
        Flag = "KillAuraHighlightColor",
        Callback = function(self, callback)
            local split = string.split(callback, ',')
            if #split == 3 then
                local v1, v2, v3 = split[1]:gsub(' ', ''), split[2]:gsub(' ', ''), split[3]:gsub(' ', '')
                if tonumber(v1) and tonumber(v2) and tonumber(v3) then
                    KillAuraData.Settings.Visuals.HighlightColor = {R =tonumber(v1), G = tonumber(v2), B = tonumber(v3)}
                end
            end
        end
    }))

    table.insert(HighLightOptions, KillAuraData.Toggle.Functions.Settings.Slider({
        Name = "Hightlight Transparency",
        Description = "How visible highlights are",
        Min = 0,
        Max = 1,
        Decimals = 1,
        Default = 0.5,
        Hide = true,
        Flag = "KillAuraHighLightTransparency",
        Callback = function(self, callback)
            KillAuraData.Settings.Visuals.HightLightTransparency = callback
        end
    }))

    local ParticleColors = {}
    KillAuraData.Toggle.Functions.Settings.MiniToggle({
        Name = "Particles",
        Description = "Makes particles when you attack entities",
        Default = true,
        Flag = "KillAuraParticles",
        Callback = function(self, callback)
            KillAuraData.Settings.Visuals.Particles = callback
            task.spawn(function()
                repeat task.wait() until #ParticleColors == 2
                for i,v in ParticleColors do
                    v.Functions.SetVisiblity(callback)
                end
            end)
        end
    })

    table.insert(ParticleColors, KillAuraData.Toggle.Functions.Settings.TextBox({
        Name = "Start Particle Color",
        Description = "Starting color of the particles",
        Default = "100, 150, 235",
        Flag = "StartKillAuraParticleColor",
        Hide = true,
        Callback = function(self, callback)
            local split = string.split(callback, ',')
            if #split == 3 then
                local v1, v2, v3 = split[1]:gsub(' ', ''), split[2]:gsub(' ', ''), split[3]:gsub(' ', '')
                if tonumber(v1) and tonumber(v2) and tonumber(v3) then
                    KillAuraData.Settings.Visuals.ParticleColor.Start = {R = tonumber(v1), G = tonumber(v2), B = tonumber(v3)}
                end
            end
        end
    }))

    table.insert(ParticleColors, KillAuraData.Toggle.Functions.Settings.TextBox({
        Name = "End Particle Color",
        Description = "Ending color of the particles",
        Default = "0, 0, 140",
        Flag = "EndKillAuraParticleColor",
        Hide = true,
        Callback = function(self, callback)
            local split = string.split(callback, ',')
            if #split == 3 then
                local v1, v2, v3 = split[1]:gsub(' ', ''), split[2]:gsub(' ', ''), split[3]:gsub(' ', '')
                if tonumber(v1) and tonumber(v2) and tonumber(v3) then
                    KillAuraData.Settings.Visuals.ParticleColor.End = {R = tonumber(v1), G = tonumber(v2), B = tonumber(v3)}
                end
            end
        end
    }))
end)();

(function()
    local NoFallData = {
        settings = {
            dangerous = 80,
            velo = 70,
            speed = 90,
            safe = false,
            mode = "Smooth",
            nohit = false
        }
    }
    
    NoFallData.Toggle = Tabs.Player.Functions.NewModule({
        Name = "NoFall",
        Description = "Prevents taking fall damage",
        Icon = "rbxassetid://107094770751573",
        Flag = "NoFall",
        Callback = function(self, callback)
            if callback then
                pcall(function()
                    repeat
                        if Functions.IsAlive() then
                            if NoFallData.settings.mode == "Smooth" then
                                local groundRay = RaycastParams.new()
                                groundRay.FilterType = Enum.RaycastFilterType.Include
                                groundRay.FilterDescendantsInstances = {workspace:WaitForChild("Map")}
                                local ground = WS:Raycast(LP.Character.HumanoidRootPart.Position, Vector3.new(0, -1000, 0), groundRay)
                                if LP.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                                    task.spawn(function()
                                        if ground and LP.Character.HumanoidRootPart.Position.Y - ground.Position.Y >= NoFallData.settings.dangerous and NoFallData.settings.safe then
                                            LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, -NoFallData.settings.speed, 0)
                                        end
                                    end)
                                    LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                                end
                            else
                                if LP.Character.HumanoidRootPart.Velocity.Y <= -NoFallData.settings.velo then
                                    LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, -NoFallData.settings.speed, 0)
                                end
                            end
                        end
                        task.wait()
                    until not self.Data.Enabled
                end)
            end
        end
    })
    local nofallsafe, NoFallVelocity, nofalldangerous, NoFallSpeed
    NoFallData.Toggle.Functions.Settings.Dropdown({
        Name = "Mode",
        Description = "Mode to prevent fall damage.",
        Default = "Smooth",
        Options = {"Smooth", "Slow"},
        Flag = "NoFallMode",
        Callback = function(self, value)
            NoFallData.settings.mode = value
            task.spawn(function()
                repeat task.wait() until NoFallSpeed
                nofallsafe.Functions.SetVisiblity(value == "Smooth")
                nofalldangerous.Functions.SetVisiblity(value == "Smooth")
                NoFallVelocity.Functions.SetVisiblity(value == "Slow")
                NoFallSpeed.Functions.SetVisiblity(value == "Slow")
            end)
        end
    })
    nofallsafe = NoFallData.Toggle.Functions.Settings.MiniToggle({
        Name = "Safe Mode",
        Description = "Lands a bit slower when jumping from a very high point.",
        Flag = "NoFallSafe",
        Default = true,
        Hide = true,
        Callback = function(self, value)
            NoFallData.settings.safe = value
        end
    })
    nofalldangerous = NoFallData.Toggle.Functions.Settings.Slider({
        Name = "Dangerous Position",
        Description = "Height to check for the dangerous position.",
        Min = 50,
        Max = 80,
        Default = 80,
        Hide = true,
        Flag = "NoFallDangerous",
        Callback = function(self, value)
            NoFallData.settings.dangerous = value
        end
    })
    NoFallVelocity = NoFallData.Toggle.Functions.Settings.Slider({
        Name = "Velocity Check",
        Description = "Value to check the velocity when you\"re falling.",
        Min = 20,
        Max = 70,
        Default = 70,
        Hide = true,
        Flag = "NoFallVelocity",
        Callback = function(self, value)
            NoFallData.settings.velo = value
        end
    })
    NoFallSpeed = NoFallData.Toggle.Functions.Settings.Slider({
        Name = "Fall Speed",
        Description = "Speed to fall down.",
        Min = 1,
        Max = 90,
        Default = 90,
        Flag = "NoFallSpeed",
        Hide = true,
        Callback = function(self, value)
            NoFallData.settings.speed = value
        end
    })
end)();

local blockLevels = {
    ceramic = 0,
    wool = 1,
    stone_brick = 2,
    wood_plank_oak = 3, 
    obsidian = 4
}

local GetBlockType = function(block: string)
    if block:find("wool") then
        return "wool"
    end
    return block
end

local GetBlocksAtPos = function(pos, findNearest)
    if findNearest then
        local lastdist, lastbed = math.huge, nil
        for i,v in CS:GetTagged("bed") do
            if v:FindFirstChild("Bed") and v:FindFirstChild("Blanket") then
                local dist = LP:DistanceFromCharacter(v.Position)
                if dist < lastdist then
                    lastdist = dist
                    lastbed = v
                end
            end
        end
        return lastbed, lastdist
    else
        if pos then
            local data = GameData.Modules.BlockEngine:getStore():getBlockAt(pos)
            if data then
                if table.find(CS:GetTags(data), "bed") then
                    return "bed"
                end
                return data
            end
        end
        return false
    end
end

local CountBlocks = function(cf, subvalue, mode, checkup)
    local blocks = {}
    local pos = cf.Position
    local curval = 0
    local newval = pos
    if mode == "y" then
        newval =  (pos - (cf.LookVector * curval)) - subvalue
    elseif mode == "b" then
        newval =  (pos + (cf.LookVector * curval)) - subvalue
    elseif mode == "s1" then
        newval = Vector3.new(pos.X + cf.RightVector.X, pos.Y, pos.Z)
    elseif mode == "s2" then
        newval = Vector3.new((pos.X - cf.RightVector.X), pos.Y, pos.Z)
    end

    local curpos = GameData.Modules.BlockEngine:getBlockPosition(newval)
    local readpos = {}
    local exist = GetBlocksAtPos(curpos)
    repeat 
        exist = GetBlocksAtPos(curpos)
        if exist and not table.find(readpos, curpos) then
            if exist ~= "bed" then
                if not exist:GetAttribute("NoBreak") then
                    table.insert(blocks, exist)
                    if checkup then
                        local upcheck = GameData.Modules.BlockEngine:getBlockPosition(newval + Vector3.new(0,3,0))
                        if not GetBlocksAtPos(upcheck) then
                            break
                        end
                    end
                end
            end
            table.insert(readpos, curpos)
            curval += 3
            if mode == "y" then
                newval = Vector3.new(pos.X, pos.Y + curval, pos.Z)
            elseif mode == "f" then
                newval =  (pos - (cf.LookVector * curval)) - subvalue
            elseif mode == "b" then
                newval =  (pos + (cf.LookVector * curval)) - subvalue
            elseif mode == "s1" then
                newval = Vector3.new((pos.X + cf.RightVector.X)+curval, pos.Y, pos.Z)
            elseif mode == "s2" then
                newval = Vector3.new((pos.X - cf.RightVector.X)-curval, pos.Y, pos.Z)
            end    

            curpos = GameData.Modules.BlockEngine:getBlockPosition(newval)
        else
            break
        end
        task.wait()
    until not curpos or curpos and not exist
    table.clear(readpos)
    return #blocks, blocks
end


local CheckPoint = function(bed, point)
    if bed then
        local blanket = bed:FindFirstChild("Blanket")
        if point == 1 then
            return CountBlocks(bed.CFrame, Vector3.new(0,0,0), "y")
        elseif point == 2 and blanket then
            return CountBlocks(blanket.CFrame, Vector3.new(0,0,0), "y")
        elseif point == 3 then
            return CountBlocks(bed.CFrame, Vector3.new(0,0,0), "f", true)
        elseif point == 4 then
            return CountBlocks(bed.CFrame, Vector3.new(0,0,0), "b", true)
        elseif point == 5 then
            return CountBlocks(bed.CFrame, Vector3.new(0,0,0), "s1", true)
        elseif point == 6 and blanket then
            return CountBlocks(blanket.CFrame, Vector3.new(0,0,0), "s1", true)
        elseif point == 7 then
            return CountBlocks(bed.CFrame, Vector3.new(0,0,0), "s2", true)
        elseif point == 8 and blanket then
            return CountBlocks(blanket.CFrame, Vector3.new(0,0,0), "s2", true)
        end
    end
    return false
end

local FindWeakest = function(bed : Instance)
    local weakest, lastval, lastlevel, lasthealth = nil, math.huge, math.huge, math.huge
    for i = 1,8 do
        local val, blocks = CheckPoint(bed, i)
        if val then
            if lastval > val then
                lastval = val
                weakest = i
            elseif lastval == val then
                if blocks[#blocks] then
                    local data = GameData.Modules.BlockEngine:getStore():getBlockData(GameData.Modules.BlockEngine:getBlockPosition(blocks[#blocks].Position))
                    local health, typeof = blocks[#blocks]:GetAttribute("Health"), GetBlockType(blocks[#blocks].Name)
                    if data then
                        health = data:GetAttribute(GameData.Modules.BlockEngine:getDefaultHealthKey())
                    end
                    if blockLevels[typeof] then
                        if lastlevel > blockLevels[typeof] then
                            lastval = val
                            weakest = i
                            lastlevel = blockLevels[typeof]
                            lasthealth = health
                        else
                            if lasthealth and health and lasthealth > health then
                                lastval = val
                                weakest = i
                                lasthealth = health
                            end
                        end
                    end
                end
            end
        end
    end
    return weakest, lastval
end

local DamageBlock = function(block: Instance)
    local Position = GameData.Modules.BlockEngine:getBlockPosition(block.Position)
    if Position then
        local Response = GameData.Modules.BlockRemotes.Client:Get('DamageBlock'):CallServerAsync({
            blockRef = {blockPosition = Position},
            hitPosition = Position,
            hitNormal = Vector3.yAxis
        })
        local BlockData = GameData.Modules.BlockEngine:getStore():getBlockData(block.Position)
        if BlockData then
            local health = BlockData:GetAttribute(GameData.Modules.BlockEngine:getDefaultHealthKey()) or block:GetAttribute("Health")
            if health then
                local maxHealth = block:GetAttribute("MaxHealth")
                if maxHealth then
                    GameData.Controllers.BlockBreaker:updateHealthbar({blockPosition = Position}, health, maxHealth, 2, block)
                end
            end
        end
        return Response
    end
    return
end

local GetBreakableItems = function()
    local Items = {}
    for i,v in GameData.Modules.ItemMeta do
        if v.breakBlock then
            Items[i] = v
        end
    end
    return Items
end

local CanBreak = function(block: Instance, HandCheck: boolean)
    local teamData = GameData.Modules.PlayerUtil.getGamePlayer(LP)
    local teamId = teamData and teamData:getTeamId()
    
    if block:GetAttribute('NoBreak') or (teamId and block:GetAttribute('Team' .. teamId .. 'NoBreak')) then
        return false
    end

    if HandCheck then
        local Items = GetBreakableItems()
        local Hand = GetInventory().hand
        if Hand then
            for i,v in Items do
                if i == Hand.itemType then
                    return true
                end
            end
        end
    else
        return true
    end

    return false
end


(function()
    local NukerData = {
        Settings = {
            Range = 32,
            Instant = false,
            ItemCheck = false,
            Delay = 0.1
        },
        Misc = {
            TargetBlock = nil,
            ItemsAllowed = {},
            Data = {targetbedspot = nil, bed = nil}
        }
    }

    local failed = tick()
    NukerData.Toggle = Tabs.World.Functions.NewModule({
        Name = "Nuker",
        Description = "Automatically breaks beds",
        Icon = "rbxassetid://112850569913170",
        Flag = "Nuker",
        Callback = function(self, callback)
            if callback then
                repeat
                    local target, proximity = GetBlocksAtPos(nil, true)
                    if target and NukerData.Settings.Range >= proximity and CanBreak(target, NukerData.Settings.ItemCheck) then
                        local bestPoint = FindWeakest(target)
                        local _, blocks = CheckPoint(GetBlocksAtPos(nil, true), bestPoint)
    
                        local primaryTarget = nil
                        if blocks and #blocks > 0 then
                            primaryTarget = blocks[#blocks]
                        end
                        
                        if NukerData.Misc.Data.bed ~= target or not NukerData.Misc.Data.targetbedspot then
                            NukerData.Misc.Data.targetbedspot = GetBlocksAtPos(nil, true)
                            NukerData.Misc.Data.bed = target
                        end
    
                        if primaryTarget then
                            if NukerData.Settings.Instant then
                                for i = 1,15 do
                                    if primaryTarget then
                                        DamageBlock(primaryTarget)
                                    end
                                end
                            end
                            DamageBlock(primaryTarget)
                        else
                            local operation = DamageBlock(NukerData.Misc.Data.targetbedspot)

                            if operation then
                                local result, response = operation:awaitStatus()

                                if result ~= GameData.Modules.Promise.Status.Resolved or response == 'cancelled' then
                                    failed = tick() + 1
                                    local curr = GetBlocksAtPos(nil, true)
                                    if NukerData.Misc.Data.targetbedspot == curr then
                                        NukerData.Misc.Data.targetbedspot = curr.Blanket
                                    else
                                        NukerData.Misc.Data.targetbedspot = curr
                                    end
                                else
                                    if NukerData.Settings.Instant then
                                        for i = 1,15 do 
                                            if NukerData.Misc.Data.targetbedspot then
                                                DamageBlock(NukerData.Misc.Data.targetbedspot)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
    
                    task.wait(NukerData.Settings.Instant and (failed > tick() and 0.1 or 0) or NukerData.Settings.Delay)
                until not self.Data.Enabled
            end
        end
    })

    NukerData.Toggle.Functions.Settings.Slider({
        Name = "Range",
        Description = "How far you start breaking",
        Min = 1,
        Max = 32,
        Default = 32,
        Flag = "NukerRange",
        Callback = function(self, callback)
            NukerData.Settings.Range = callback
        end
    })

    local delay = NukerData.Toggle.Functions.Settings.Slider({
        Name = "Delay",
        Description = "The delay after each hit",
        Min = 0,
        Max = 5,
        Default = 0.1,
        Hide = true,
        Flag = "NukerDelay",
        Callback = function(self, callback)
            NukerData.Settings.Delay = callback
        end
    })

    NukerData.Toggle.Functions.Settings.MiniToggle({
        Name = "Instant",
        Description = "Instantly breaks",
        Default = true,
        Flag = "NukerInstant",
        Callback = function(self, callback)
            NukerData.Settings.Instant = callback
            delay.Functions.SetVisiblity(not callback)
        end
    })

    NukerData.Toggle.Functions.Settings.MiniToggle({
        Name = "Hand Check",
        Description = "Only attacks if you have a item that can break in hand",
        Default = false,
        Flag = "NukerHandCheck",
        Callback = function(self, callback)
            NukerData.Settings.ItemCheck = callback
        end
    })
end)();

(function()
    local infJumpData = {
        Settings = {
            Delay = 0.2
        },
        Misc = {
            Cooldown = false,
            Connection = nil
        }
    }

    infJumpData.Toggle = Tabs.Movement.Functions.NewModule({
        Name = "Infinite Jump",
        Description = "Lets you jump with no limit",
        Flag = "InfiniteJump",
        Icon = "rbxassetid://73148132024514",
        Callback = function(self, callback)
            if callback then
                infJumpData.Misc.Connection = UIS.JumpRequest:Connect(function()
                    if Functions.IsAlive() and not infJumpData.Misc.Cooldown then
                        LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) -- i hate this module
                        if infJumpData.Settings.Delay > 0 then
                            infJumpData.Misc.Cooldown = true
                            task.delay(infJumpData.Settings.Delay, function()
                                infJumpData.Misc.Cooldown = false
                            end)
                        end
                    end
                end)
            else
                if infJumpData.Misc.Connection then
                    infJumpData.Misc.Connection:Disconnect()
                    infJumpData.Misc.Connection = nil
                end
            end
        end
    })
    infJumpData.Toggle.Functions.Settings.Slider({
        Name = "Delay",
        Description = "Delay until you can do another",
        Min = 0,
        Max = 1,
        Default = 0.2,
        Decimals = 1,
        Flag = "InfiniteJumpDelay",
        Callback = function(self, callback)
            infJumpData.Settings.Delay = callback
        end
    })
end)();

local GetBlocks = function(UsePriority: boolean)
    local Wool = GetItemType("wool", true, false)
    if not Wool or not Wool.Item then
        local Priority = {'wool', 'ceramic', 'oak', 'stone', 'tesla', 'tnt', 'obsidian'}
        if UsePriority then
            for i,v in Priority do
                local Block = GetItemType(v, true)
                if Block and Block.Item then
                    return Block 
                end
            end
        else
            local Block = GetItemType(nil, false, "block")
            if Block and Block.Item then
                return Block 
            end
        end
        return
    end
    return Wool
end

local GetPlaceId = function(pos: Vector3)
    if pos then
        local round = GameData.Modules.BlockEngine:getBlockPosition(pos)
        return GameData.Modules.BlockEngine:getStore():getBlockAt(round), round
    end
    return nil, nil
end

local ScaffoldData = {
    Settings = {
        Pos = "Store",
        Corner = "Clamp",
        Extend = 1,
        Down = false,
        DownValue = 4,
        Vec = "Vector",
        Build = "Radius",
        Place = "Optimized",
        Tower = false,
        Boost = 5
    },
    Misc = {
        Blocks = {},
        Pos = Vector3.zero
    }
}

local CheckVec = function(mode: string, pos: Vector3)
    if mode == 'Vector' then
        local x, y, z = pos.X, pos.Y, pos.Z
        for i = 1, #ScaffoldData.Misc.Blocks do
            local offset = ScaffoldData.Misc.Blocks[i]
            return GetPlaceId(Vector3.new(x + offset.X, y + offset.Y, z + offset.Z))
        end
    else
        for i = 1, #ScaffoldData.Misc.Blocks do
            return GetPlaceId(pos + ScaffoldData.Misc.Blocks[i])
        end
    end
    return false
end

local BlockAt = function(mode: string, min: Vector3, max: Vector3)
    local blocks = GameData.Modules.BlockEngine:getStore()
    local list = {}
    local count = 0

    local minX, maxX = math.min(min.X, max.X), math.max(min.X, max.X)
    local minY, maxY = math.min(min.Y, max.Y), math.max(min.Y, max.Y)
    local minZ, maxZ = math.min(min.Z, max.Z), math.max(min.Z, max.Z)

    if mode == 'Store' then
        for x = minX, maxX do
            for y = minY, maxY do
                for z = minZ, maxZ do
                    if blocks:getBlockAt(Vector3.new(x, y, z)) then
                        table.insert(list, Vector3.new(x * 3, y * 3, z * 3))
                    end
                end
            end
        end
    elseif mode == 'Count' then
        for x = minX, maxX do
            for y = minY, maxY do
                for z = minZ, maxZ do
                    local pos = Vector3.new(x, y, z)
                    if blocks:getBlockAt(pos) then
                        count = count + 1
                        list[count] = pos * 3
                    end
                end
            end
        end
    else
        local sizeX = maxX - minX + 1
        local sizeY = maxY - minY + 1
        local total = sizeX * sizeY * (maxZ - minZ + 1)
        
        for i = 0, total - 1 do
            local z = minZ + math.floor(i / (sizeX * sizeY))
            local y = minY + math.floor((i % (sizeX * sizeY)) / sizeX)
            local x = minX + (i % sizeX)
            
            local pos = Vector3.new(x, y, z)
            if blocks:getBlockAt(pos) then
                table.insert(list, pos * 3)
            end
        end
    end
    
    return list
end

local GetCorner = function(poscheck: Vector3, pos: Vector3, mode: string)
    local offset = Vector3.new(3, 3, 3)
    local point = poscheck + (pos - poscheck).Unit * 100
    
    if mode == 'Clamp' then
        return Vector3.new(
            math.clamp(point.X, poscheck.X - offset.X, poscheck.X + offset.X),
            math.clamp(point.Y, poscheck.Y - offset.Y, poscheck.Y + offset.Y),
            math.clamp(point.Z, poscheck.Z - offset.Z, poscheck.Z + offset.Z)
        )
    elseif mode == 'Projection' then
        return Vector3.new(
            math.clamp(point.X, poscheck.X - offset, poscheck.X + offset),
            math.clamp(point.Y, poscheck.Y - offset, poscheck.Y + offset),
            math.clamp(point.Z, poscheck.Z - offset, poscheck.Z + offset)
        )
    else
        local axis = function(value, center)
            return math.clamp(value, center - 3, center + 3)
        end
        
        return Vector3.new(
            axis(point.X, poscheck.X),
            axis(point.Y, poscheck.Y),
            axis(point.Z, poscheck.Z)
        )
    end
end

local GetBuild = function(pos: Vector3, mode: string)
    local radius, dist, point = 21, 60, nil
    local minPos = GameData.Modules.BlockEngine:getBlockPosition(pos - Vector3.new(radius, radius, radius))
    local maxPos = GameData.Modules.BlockEngine:getBlockPosition(pos + Vector3.new(radius, radius, radius))
    local blocks = BlockAt(ScaffoldData.Settings.Pos, minPos, maxPos)

    if mode == 'Radius' then
        radius = Vector3.new(21, 21, 21)
        minPos = GameData.Modules.BlockEngine:getBlockPosition(pos - radius)
        maxPos = GameData.Modules.BlockEngine:getBlockPosition(pos + radius)
        
        for i = 1, #blocks do
            local blockPos = GetCorner(blocks[i], pos, ScaffoldData.Settings.Corner)
            local distance = (pos - blockPos).Magnitude
            
            if distance < dist then
                dist = distance
                point = blockPos
            end
        end
        
        table.clear(blocks)
    elseif mode == 'Square' then
        dist *= 60
        
        for i = 1, #blocks do
            local blockPos = GetCorner(blocks[i], pos, ScaffoldData.Settings.Corner)
            local dx, dy, dz = pos.X - blockPos.X, pos.Y - blockPos.Y, pos.Z - blockPos.Z
            local distSquared = dx*dx + dy*dy + dz*dz
            
            if distSquared < dist then
                dist = distSquared
                point = blockPos
            end
        end
        
        table.clear(blocks)
    else
        dist = math.huge

        for _, blockPos in blocks do
            local cornerPos = GetCorner(blockPos, pos, ScaffoldData.Settings.Corner)
            local distance = (pos - cornerPos).Magnitude

            if distance < dist then
                dist, point = distance, cornerPos
            end
        end

        table.clear(blocks)
    end

    return point
end

local placed = {}
local PlaceBlock = function(pos: Vector3, mode: string)
    local blockPos = GameData.Modules.BlockEngine:getBlockPosition(pos)
    local block = GetBlocks(true)
    if not block then return end
    
    if mode == 'Optimized' then
        if not placed[block] then
            placed[block] = GameData.Modules.BlockPlacer.new(GameData.Modules.BlockEngineClient, block.Item.itemType)
        end
        return placed[block]:placeBlock(blockPos)
    else
        local place = GameData.Modules.BlockPlacer.new(GameData.Modules.BlockEngineClient, block.Item.itemType)
        return place:placeBlock(blockPos)
    end
end

local Diag = function()
    local x = math.abs(LP.Character.Humanoid.MoveDirection.X)
    local z = math.abs(LP.Character.Humanoid.MoveDirection.Z)
    return x > 0.1 and z > 0.1 and math.abs(x - z) < 0.3
end

(function()
    ScaffoldData.Toggle = Tabs.Movement.Functions.NewModule({
        Name = "Scaffold",
        Description = "Places blocks in your path",
        Icon = "rbxassetid://135111727988302",
        Flag = "Scaffold",
        Callback = function(self, callback)
            if callback then
                repeat
                    if Functions.IsAlive() then
                        for i = ScaffoldData.Settings.Extend, 1, -1 do
                            local yPos, dir = LP.Character.HumanoidRootPart.Position.Y - LP.Character.Humanoid.HipHeight - (ScaffoldData.Settings.Down and UIS:IsKeyDown(Enum.KeyCode.LeftShift) and ScaffoldData.Settings.DownValue or 3 / 2), LP.Character.Humanoid.MoveDirection * ScaffoldData.Settings.Extend * i
                            local cf = CFrame.new(LP.Character.HumanoidRootPart.Position) * CFrame.new(dir.X, -LP.Character.HumanoidRootPart.Position.Y + yPos, dir.Z)
                            local pos = Vector3.new(math.round(cf.Position.X / 3) * 3, math.round(cf.Position.Y / 3) * 3, math.round(cf.Position.Z / 3) * 3)
    
                            if Diag() then
                                local hor = (ScaffoldData.Misc.Pos - LP.Character.HumanoidRootPart.Position) * Vector3.new(1, 0, 1)
                                if (hor.X ^ 2 + hor.Z ^ 2) < 6.25 then
                                    pos = ScaffoldData.Misc.Pos
                                end
                            end
    
                            local suc, res = pcall(function()
                                return GetPlaceId(pos)
                            end)
    
                            if suc and not res then
                                local place
                                if CheckVec(ScaffoldData.Settings.Vec, pos * 3) then
                                    place = pos * 3
                                else
                                    place = GetBuild(pos, ScaffoldData.Settings.Build)
                                end
                                if place then
                                    coroutine.wrap(function()
                                        PlaceBlock(place, ScaffoldData.Settings.Place)
                                    end)()
                                end
                            end
    
                            ScaffoldData.Misc.Pos = pos
                        end
    
                        if ScaffoldData.Settings.Tower and UIS:IsKeyDown(Enum.KeyCode.Space) and not UIS:GetFocusedTextBox() then
                            local Velo = LP.Character.HumanoidRootPart.Velocity :: Vector3

                            -- infJumpData.Toggle.Data.Enabled and ScaffoldData.Settings.Boost or
                            LP.Character.HumanoidRootPart.Velocity = Vector3.new(Velo.X, ScaffoldData.Settings.Boost * 6 + 3, Velo.Z)
                        end
                    end
                    task.wait(0.01)
                until not self.Data.Enabled
            end
        end
    })

    local Boost
    ScaffoldData.Toggle.Functions.Settings.MiniToggle({
        Name = 'Tower',
        Description = 'Places blocks above you when space is held.',
        Flag = 'ScaffoldTower',
        Default = true,
        Callback = function(self, value)
            ScaffoldData.Settings.Tower = value
            task.spawn(function()
                repeat task.wait() until Boost
                Boost.Functions.SetVisiblity(value)
            end)
        end
    })
    Boost = ScaffoldData.Toggle.Functions.Settings.Slider({
        Name = 'Boost',
        Description = 'Boost power to apply to your character when Tower is enabled.',
        Min = 2,
        Max = 7,
        Default = 5,
        Flag = 'ScaffoldBoost',
        Hide = true,
        Callback = function(self, value)
            ScaffoldData.Settings.Boost = value
        end
    })
    local ScaffoldDown
    ScaffoldData.Toggle.Functions.Settings.MiniToggle({
        Name = 'Down',
        Description = 'Places blocks below you when left shift is held.',
        Flag = 'ScaffoldDown',
        Default = true,
        Callback = function(self, value)
            ScaffoldData.Settings.Down = value
            task.spawn(function()
                repeat task.wait() until ScaffoldDown
                ScaffoldDown.Functions.SetVisiblity(value)
            end)
        end
    })
    ScaffoldDown = ScaffoldData.Toggle.Functions.Settings.Slider({
        Name = 'Down',
        Description = 'Blocks to place below you.',
        Min = 4,
        Max = 8,
        Default = 4,
        Hide = true,
        Flag = 'ScaffoldDowner',
        Callback = function(self, value)
            ScaffoldData.Settings.DownValue = value
        end
    })
    ScaffoldData.Toggle.Functions.Settings.Slider({
        Name = 'Extend',
        Description = 'Blocks to place in front of you.',
        Min = 1,
        Max = 8,
        Default = 1,
        Flag = 'ScaffoldExtend',
        Callback = function(self, value)
            ScaffoldData.Settings.Extend = value
        end
    })
    ScaffoldData.Toggle.Functions.Settings.Dropdown({
        Name = 'Place',
        Description = 'Mode to place blocks.',
        Options = {'Optimized', 'Fast'},
        Default = 'Optimized',
        Flag = 'ScaffoldPlace',
        Callback = function(self, value)
            ScaffoldData.Settings.Place = value
        end
    })
    ScaffoldData.Toggle.Functions.Settings.Dropdown({
        Name = 'Corner',
        Description = 'Mode to detect the closest corner.',
        Options = {'Clamp', 'Projection', 'Axis'},
        Default = 'Clamp',
        Flag = 'ScaffoldCorner',
        Callback = function(self, value)
            ScaffoldData.Settings.Corner = value
        end
    })
    ScaffoldData.Toggle.Functions.Settings.Dropdown({
        Name = 'Build',
        Description = 'Mode to build around the corner.',
        Options = {'Radius', 'Square', 'Optimized'},
        Default = 'Radius',
        Flag = 'ScaffoldBuild',
        Callback = function(self, value)
            ScaffoldData.Settings.Build = value
        end
    })
    ScaffoldData.Toggle.Functions.Settings.Dropdown({
        Name = 'Offset',
        Description = 'Mode to get the offsets.',
        Options = {'Mathematical', 'Direct'},
        Default = 'Mathematical',
        Flag = 'ScaffoldOffset',
        Callback = function(self, value)
            table.clear(ScaffoldData.Misc.Blocks)
            if value == 'Mathematical' then
                for i = 0, 26 do
                    if i ~= 13 then
                        local x = (i % 3 - 1) * 3
                        local y = (math.floor(i / 3) % 3 - 1) * 3
                        local z = (math.floor(i / 9) - 1) * 3
                        table.insert(ScaffoldData.Misc.Blocks, Vector3.new(x, y, z))
                    end
                end
            else
                local offsets = {-3, 0, 3}
                for i = 1, 27 do
                    local x = offsets[math.floor((i - 1) / 9) % 3 + 1]
                    local y = offsets[math.floor((i - 1) / 3) % 3 + 1]
                    local z = offsets[(i - 1) % 3 + 1]
                    
                    if x ~= 0 or y ~= 0 or z ~= 0 then
                        table.insert(ScaffoldData.Misc.Blocks, Vector3.new(x, y, z))
                    end
                end
            end
        end
    })
    ScaffoldData.Toggle.Functions.Settings.Dropdown({
        Name = 'Check',
        Description = 'Mode to check the vector offsets.',
        Options = {'Vector', 'Store'},
        Default = 'Vector',
        Flag = 'ScaffoldVector',
        Callback = function(self, value)
            ScaffoldData.Settings.Vec = value
        end
    })
    ScaffoldData.Toggle.Functions.Settings.Dropdown({
        Name = 'Position',
        Description = 'Mode to get the blocks\' positions.',
        Options = {'Store', 'Count', 'Size'},
        Default = 'Store',
        Flag = 'ScaffoldPosition',
        Callback = function(self, value)
            ScaffoldData.Settings.Pos = value
        end
    })
end)();

(function()
    local OldSprint
    Tabs.Movement.Functions.NewModule({
        Name = "Sprint",
        Description = "Makes you sprint",
        Flag = "Sprint",
        Icon = "rbxassetid://100924667357776",
        Callback = function(self, callback)
            if callback then
                OldSprint = GameData.Controllers.Sprint.stopSprinting
                GameData.Controllers.Sprint.stopSprinting = function() end
                repeat
                    if not GameData.Controllers.Sprint:isSprinting() then
                        GameData.Controllers.Sprint:startSprinting()
                    end
                    task.wait()
                until not self.Data.Enabled
            else
                if OldSprint then
                    GameData.Controllers.Sprint.stopSprinting = OldSprint
                end
                GameData.Controllers.Sprint:stopSprinting()
            end
        end
    })
end)();

(function()
    local AutoQueueData = {
        Settings = {
            Delay = 0.1
        },
        Misc = {
            Sent = false
        },
        Connections = {}
    }

    AutoQueueData.Toggle = Tabs.Utility.Functions.NewModule({
        Name = "AutoQueue",
        Icon = "rbxassetid://75003635802917",
        Description = "Queues after a match ends",
        Flag = "AutoQueue",
        Callback = function(self, callback)
            if callback then
                table.insert(AutoQueueData.Connections, GameData.Events.Death.Event:Connect(function(t: any)  
                    if t.FinalKill and t.Entity == LP.Character and not AutoQueueData.Misc.Sent then
                        AutoQueueData.Misc.Sent = true
                        task.wait(AutoQueueData.Settings.Delay)
                        GameData.Controllers.Queue:joinQueue(GameData.Modules.Store:getState().Game.queueType)
                    end
                end))
                table.insert(AutoQueueData.Connections, GameData.Modules.Remotes:Get("MatchEndEvent"):Connect(function()
                    if not AutoQueueData.Misc.Sent then
                        AutoQueueData.Misc.Sent = true
                        task.wait(AutoQueueData.Settings.Delay)
                        GameData.Controllers.Queue:joinQueue(GameData.Modules.Store:getState().Game.queueType)
                    end
                end))
            else
                for i,v in AutoQueueData.Connections do
                    v:Disconnect()
                end
                table.clear(AutoQueueData.Connections)
            end
        end
    })

    AutoQueueData.Toggle.Functions.Settings.Slider({
        Name = "Delay",
        Description = "Delay to wait after match ends",
        Min = 0,
        Max = 5,
        Default = 0.1,
        Decimals = 1,
        Flag = "AutoQueueDelay",
        Callback = function(self, callback)
            AutoQueueData.Settings.Delay = callback
        end
    })
end)()

local GetChests = function(Options: {Opened: boolean, PlacedByServer: boolean})
    local Chests = {}
    for i,v in CS:GetTagged("chest") do
        if v:FindFirstChild("ChestFolderValue") and v:FindFirstChild("ChestFolderValue"):IsA("ObjectValue") and v:FindFirstChild("Model") and v.Model:FindFirstChild("RootPart") and v.Model:FindFirstChild("RootPart"):IsA("Part") then
            if v:GetAttribute("Block") and v:GetAttribute("BlockUUID") then
                if Options then
                    if (Options.Opened and not v:GetAttribute("ChestOpened") or not Options.Opened) and (Options.PlacedByServer and v:GetAttribute("ServerPlaced") or not Options.PlacedByServer) then
                        table.insert(Chests, v)
                    end
                else
                    table.insert(Chests, v)
                end
            end
        end
    end
    return Chests
end

local GetNearestChest = function(Options: {Opened: boolean, PlacedByServer: boolean})
    local Chests = GetChests(Options)
    local Chest = {Chest = nil, Distance = math.huge}
    if #Chests > 0 then
        for i,v in Chests do
            local Distance = LP:DistanceFromCharacter(v.Model.RootPart.Position)
            if Chest.Distance > Distance then
                Chest = {Chest = v, Distance = Distance}
            end
        end
    end
    return Chest
end

(function() 
    local ChestStealerData = {
        Settings = {
            Range = 20,
            Delay = 0
        }
    }

    ChestStealerData.Toggle = Tabs.Utility.Functions.NewModule({
        Name = "ChestStealer",
        Description = "Loots chests near you in skywars",
        Icon = "rbxassetid://86996272463051",
        Flag = "ChestStealer",
        Callback = function(self, callback)
            if callback then
                repeat
                    local Chest = GetNearestChest({Opened = true, PlacedByServer = true})
                    if Chest.Chest and ChestStealerData.Settings.Range >= Chest.Distance then
                        task.spawn(function()
                            GameData.Controllers.Chest:openChest(Chest.Chest.ChestFolderValue.Value)
                            GameData.Controllers.Chest:playChestOpenAnimation(Chest.Chest)
                            for i,v in Chest.Chest.ChestFolderValue.Value:GetChildren() do
                                if v:IsA("Accessory") then
                                    task.wait(ChestStealerData.Settings.Delay)
                                    GameData.Modules.Remotes:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(Chest.Chest.ChestFolderValue.Value, v)
                                end
                            end
                            GameData.Modules.Remotes:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(nil)
                        end)
                    end
                    task.wait()
                until not self.Data.Enabled
            end
        end
    })
    
    ChestStealerData.Toggle.Functions.Settings.Slider({
        Name = "Range",
        Description = "Range to start collecting items",
        Min = 1,
        Max = 20,
        Default = 20,
        Flag = "ChestStealerRange",
        Callback = function(self, callback)
            ChestStealerData.Settings.Range = callback
        end
    })

    ChestStealerData.Toggle.Functions.Settings.Slider({
        Name = "Delay",
        Description = "Delay before collecting a item",
        Min = 0,
        Max = 3,
        Default = 0,
        Flag = "ChestStealerDelay",
        Callback = function(self, callback)
            ChestStealerData.Settings.Delay = callback
        end
    })
end)();

local CanConsume = function(item)
    if item then
        local data = GameData.Modules.ItemMeta[item]
        if data and data.consumable then
            return data
        end
    end
    return false
end

(function()
    local autoConsumeData = {
        settings = {
            delay = 1,
            health = 70,
            instant = false
        },
        other = {
            blacklists = {
                'duck_spawn_egg',
                'unstable_portal',
                'smoke_bomb',
                'black_market_upgrade_3'
            }
        }
    }
    
    autoConsumeData.Toggle = Tabs.Utility.Functions.NewModule({
        Name = 'AutoConsume',
        Description = 'Automatically consumes items & potions.',
        Icon = 'rbxassetid://123628760864442',
        Flag = 'AutoConsume',
        Callback = function(self, callback)
            if callback then
                repeat
                    for _, v in GetInventory().items do
                        if CanConsume(v.itemType) and (v.itemType == 'pie' and not LP.Character:GetAttribute('SpeedPieBuff') or v.itemType ~= 'pie') and not v.itemType:find('deploy') and not table.find(autoConsumeData.other.blacklists, v.itemType) then
                            if (v.itemType == 'pie' or v.itemType:find('apple') and LP.Character.Humanoid.Health <= autoConsumeData.settings.health) or v.itemType ~= 'pie' and not v.itemType:find('apple') then
                                GameData.Modules.Remotes:Get("ConsumeItem"):CallServerAsync({
                                    item = v.tool
                                })

                                task.wait(autoConsumeData.settings.instant and 0.01 or autoConsumeData.settings.delay)
                            end
                        end
                    end
                    task.wait()
                until not self.Data.Enabled
            end
        end
    })
    local AutoConsumeTime
    autoConsumeData.Toggle.Functions.Settings.MiniToggle({
        Name = "Instant Consume",
        Description = "Instantly consume items.",
        Flag = "AutoConsumeInstant",
        Default = true,
        Callback = function(self, enabled)
            autoConsumeData.settings.instant = enabled
            task.spawn(function()
                repeat task.wait() until AutoConsumeTime
                AutoConsumeTime.Functions.SetVisiblity(not enabled)
            end)
        end
    })
    AutoConsumeTime = autoConsumeData.Toggle.Functions.Settings.Slider({
        Name = "Consume Time",
        Description = "Time to consume an item.",
        Min = 0.1,
        Max = 2,
        Default = 1,
        Decimals = 1,
        Hide = true,
        Flag = "AutoConsumeTime",
        Callback = function(self, val)
            autoConsumeData.settings.delay = val
        end
    })
    autoConsumeData.Toggle.Functions.Settings.Slider({
        Name = "Consume Apple Health",
        Description = "Health to be at to consume an apple.",
        Min = 1,
        Max = 99,
        Default = 70,
        Flag = "AutoConsumeApple",
        Callback = function(self, val)
            autoConsumeData.settings.health = val
        end
    })
end)()

local GetShops = function(Type: string)
    local Shops = CS:GetTagged("BedwarsItemShop")
    if Type == "upgrade" then
        Shops = CS:GetTagged("TeamUpgradeShopkeeper")
    end
    local ValidShops = {}
    for i,v in Shops do
        if v:IsA("Part") and v:GetAttribute("Id") then
            table.insert(ValidShops, v)
        end
    end
    return ValidShops
end

local GetNearestShop = function(Type: string)
    local AllShops = GetShops(Type)
    local Data = {Shop = nil, Distance = math.huge}
    for i,v in AllShops do
        local Distance = LP:DistanceFromCharacter(v.Position)
        if Data.Distance > Distance then
            Data = {Shop = v, Distance = Distance}
        end
    end
    return Data
end

local PurchaseItem = function(Item: {itemType: string}, Shop: Instance)
    if not Shop then
        Shop = GetNearestShop().Shop
    end

    return GameData.Modules.ShopPurchase(Item, Shop:GetAttribute("Id"))
end

local GetNextSword = function()
    local Sword = GetBestSword().Sword
    if Sword then
        local ShopData = GameData.Modules.Shop.getShopItem(Sword.itemType)
        if ShopData and ShopData.superiorItems and #ShopData.superiorItems > 0 then
            local item = ShopData.superiorItems[1]
            if item then
                local NewShopData = GameData.Modules.Shop.getShopItem(item)
                if NewShopData then
                    return NewShopData
                end
                return item
            end
        end
    end
    return
end

local GetCurrentArmor = function()
    local Armor = ""
    for i,v in GameData.Modules.Store:getState().Bedwars.itemTiersPurchased do
        if tostring(v):find("_chestplate") then
            Armor = v
        end
    end
    return Armor
end

local GetNextArmor = function()
    local Current = GetCurrentArmor()
    for i,v in GameData.Modules.ArmorSets.BedWarsArmor do
        if v[2] and v[2] == Current and GameData.Modules.ArmorSets.BedWarsArmor[i + 1] and GameData.Modules.ArmorSets.BedWarsArmor[i + 1][2] then
            return GameData.Modules.ArmorSets.BedWarsArmor[i + 1]
        end
    end
    return
end

(function()
    local AutoBuyData = {
        Settings = {
            Items = {"Sword", "Armor", "Wool"},
            Range = 18
        }
    }

    AutoBuyData.Toggle = Tabs.Utility.Functions.NewModule({
        Name = "AutoBuy",
        Description = "Buys the next best things when your near the shop",
        Icon = "rbxassetid://130066121162263",
        Flag = "AutoBuy",
        Callback = function(self, callback)
            if callback then
                repeat
                    local Shop = GetNearestShop()
                    if Shop.Shop and AutoBuyData.Settings.Range >= Shop.Distance then
                        if table.find(AutoBuyData.Settings.Items, "Sword") then
                            local NextTier = GetNextSword()
                            if NextTier then
                                local Currency = NextTier.currency
                                local Price = NextTier.price
                                if Currency and Price then
                                    local CurrentCurrency = GetItemType(Currency, false, false)
                                    if CurrentCurrency and CurrentCurrency.Item then
                                        local CurrentAmount = CurrentCurrency.Item.amount
                                        if CurrentAmount and CurrentAmount >= Price then
                                            PurchaseItem(NextTier, Shop.Shop)
                                        end
                                    end
                                end
                            end
                        end

                        if table.find(AutoBuyData.Settings.Items, "Armor") then
                            local NextAmor = GetNextArmor()
                            if NextAmor then
                                local ShopData = GameData.Modules.Shop.getShopItem(NextAmor[2])
                                if ShopData then
                                    local Currency = ShopData.currency
                                    local Price = ShopData.price
                                    if Currency and Price then
                                        local CurrentCurrency = GetItemType(Currency, false, false)
                                        if CurrentCurrency and CurrentCurrency.Item then
                                            local CurrentAmount = CurrentCurrency.Item.amount
                                            if CurrentAmount and CurrentAmount >= Price then
                                                PurchaseItem(ShopData, Shop.Shop)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    if table.find(AutoBuyData.Settings.Items, "Wool") then
                        local ShopData = GameData.Modules.Shop.getShopItem("wool_white")
                        if ShopData then
                            local Currency = ShopData.currency
                            local Price = ShopData.price
                            if Currency and Price then
                                local CurrentCurrency = GetItemType(Currency, false, false)
                                if CurrentCurrency and CurrentCurrency.Item then
                                    local CurrentAmount = CurrentCurrency.Item.amount
                                    if CurrentAmount and CurrentAmount >= Price then
                                        PurchaseItem(ShopData, Shop.Shop)
                                    end
                                end
                            end
                        end
                    end
                    task.wait()
                until not self.Data.Enabled
            end
        end
    })

    AutoBuyData.Toggle.Functions.Settings.Slider({
        Name = "Range",
        Description = "How far from the shop to start buying",
        Min = 1,
        Max = 18,
        Default = 18,
        Flag = "AutoBuyRange",
        Callback = function(self, callback)
            AutoBuyData.Settings.Range = callback
        end
    })

    AutoBuyData.Toggle.Functions.Settings.Dropdown({
        Name = "Items",
        Description = "Items to buy",
        Options = {"Sword", "Armor", "Wool"},
        Default = {"Sword", "Armor", "Wool"},
        SelectLimit = 3,
        Flag = "AutoBuyItems",
        Callback = function(self, callback)
            AutoBuyData.Settings.Items = callback
        end
    })
end)();

local BuyNextTeamUpgrade = function(Diamonds: number, Type: string)
    local Buy = 1
    if GameData.Controllers.TeamUpgrades.currentUpgrades[Type] then
        Buy = GameData.Controllers.TeamUpgrades.currentUpgrades[Type] + 1
    end
    local Meta = GameData.Modules.TeamUpgradeMeta.getTeamUpgradeMeta(Type).tiers
    if Meta[Buy] and Meta[Buy].cost then
        if Diamonds >= Meta[Buy].cost then
            return GameData.Controllers.TeamUpgrades:requestPurchaseTeamUpgrade(Type)
        end
    end
    return
end

(function()
    local AutoUpgradeData = {
        Settings = {
            Range = 18,
            Upgrades = {"Armor", "Damage", "DiamondGen", "TeamGen"}
        }
    }

    AutoUpgradeData.Toggle = Tabs.Utility.Functions.NewModule({
        Name = "AutoUpgrade",
        Description = "Buys team upgrades",
        Icon = "rbxassetid://130066121162263",
        Flag = "AutoUpgrade",
        Callback = function(self, callback)
            if callback then
                repeat
                    local Shop = GetNearestShop("upgrade")
                    if Shop.Shop and AutoUpgradeData.Settings.Range >= Shop.Distance then
                        local TeamCrate = GameData.Controllers.TeamCrate:getTeamCrate()
                        if TeamCrate and TeamCrate:FindFirstChild("ChestFolderValue") then
                            GameData.Controllers.Chest:openChest(TeamCrate.ChestFolderValue.Value)
                        end

                        local Diamonds = 0
                        local CurrentCurrency = GetItemType("diamond", false, false)
                        if CurrentCurrency and CurrentCurrency.Item then
                            local CurrentAmount = CurrentCurrency.Item.amount
                            if CurrentAmount then
                                Diamonds = CurrentAmount
                            end
                        end

                        if table.find(AutoUpgradeData.Settings.Upgrades, "Damage") then
                            BuyNextTeamUpgrade(Diamonds, "DAMAGE")
                        end

                        if table.find(AutoUpgradeData.Settings.Upgrades, "Armor") then
                            BuyNextTeamUpgrade(Diamonds, "ARMOR")
                        end

                        if table.find(AutoUpgradeData.Settings.Upgrades, "TeamGen") then
                            BuyNextTeamUpgrade(Diamonds, "TEAM_GENERATOR")
                        end

                        if table.find(AutoUpgradeData.Settings.Upgrades, "DiamondGen") then
                            BuyNextTeamUpgrade(Diamonds, "DIAMOND_GENERATOR")
                        end

                        GameData.Modules.Remotes:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(nil)
                    end
                    task.wait()
                until not self.Data.Enabled
            end
        end
    })

    AutoUpgradeData.Toggle.Functions.Settings.Slider({
        Name = "Range",
        Description = "Distance from upgrade shop to buy",
        Min = 1,
        Max = 18,
        Default = 18,
        Flag = "AutoUpgradeRange",
        Callback = function(self, callback)
            AutoUpgradeData.Settings.Range = callback
        end
    })

    AutoUpgradeData.Toggle.Functions.Settings.Dropdown({
        Name = "Upgrades",
        Description = "Upgrades to buy",
        Options = {"Damage", "Armor", "TeamGen", "DiamondGen"},
        Default = {"Damage", "Armor"},
        SelectLimit = 3,
        Flag = "AutoUpgradeUpgrades",
        Callback = function(self, callback)
            AutoUpgradeData.Settings.Upgrades = callback
        end
    })
end)()

local FireProjectile = function(Tool: {tool: any | Instance, itemType: string}, Position: Vector3, Velocity: Vector3)
    if Functions.IsAlive() then
        return GameData.Modules.Remotes:Get("ProjectileFire"):CallServerAsync(
            Tool.tool,
            Tool.itemType,
            Tool.itemType,
            LP.Character.HumanoidRootPart.Position,
            Position,
            Velocity,
            HttpService:GenerateGUID(),
            {
                shotId = HttpService:GenerateGUID(),
                drawDurationSec = 1,
            },
            WS:GetServerTimeNow()
        )
    end
    return
end

(function()
    local LongJumpData = {
        Settings = {
            Speed = 70,
            Timer = 1.2
        },
        Connections = {},
    }

    LongJumpData.Toggle = Tabs.Movement.Functions.NewModule({
        Name = "LongJump",
        Description = "Jump further at speeds using a fireball",
        Flag = "LongJump",
        Icon = "rbxassetid://94454897188777",
        Callback = function(self, callback)
            if callback then
                if not Functions.IsAlive() then
                    task.wait(0.3)
                    Functions.Notify("You cant use this while your dead", 2.5)
                    self.Functions.Toggle(false, false, false, true, true)
                    return
                end

                SpeedData.Allowed = false
                FlyData.Allowed = false
                LP.Character.HumanoidRootPart.Anchored = true
                local Fireball = GetItemType("fireball", false, false)
                if not Fireball or not Fireball.Item or not Fireball.Item.tool then
                    task.wait(0.3)
                    Functions.Notify("You need a fireball to use this", 2.5)
                    self.Functions.Toggle(false, false, false, true, true)
                    return
                end

                local RayPrams = RaycastParams.new()
                RayPrams.FilterType = Enum.RaycastFilterType.Include
                RayPrams.FilterDescendantsInstances = CS:GetTagged("block")
                local Ground = WS:Raycast(LP.Character.HumanoidRootPart.Position, Vector3.new(0, -1000, 0), RayPrams)
                if not Ground or Ground and LP:DistanceFromCharacter(Ground.Position) > 5 then
                    task.wait(0.3)
                    Functions.Notify("Your not on ground, disabled longjump", 2.5)
                    self.Functions.Toggle(false, false, false, true, true)
                    return
                end

                local CurrentItem = GetInventory().hand
                GameData.Modules.Remotes:Get("SetInvItem"):CallServerAsync({
                    ["hand"] = Fireball.Item.tool
                })

                local CanRun = false
                LongJumpData.Connections.ConnectionD = GameData.Events.Damage.Event:Connect(function(Damage: {Player: Instance, DamageType: number})  
                    if Damage.Player == LP.Character and Damage.DamageType == GameData.Modules.DamageType.TNT then
                        CanRun = true
                        LongJumpData.Connections.ConnectionD:Disconnect()
                    end
                end)
                FireProjectile(Fireball.Item, LP.Character.PrimaryPart.Position - Vector3.new(0, 2, 0), Vector3.new(0, -40, 0))
                repeat task.wait() until CanRun
                
                if CurrentItem and CurrentItem.tool then
                    GameData.Modules.Remotes:Get("SetInvItem"):CallServerAsync({
                        ["hand"] = CurrentItem.tool
                    })
                end

                local start = os.clock()

                LongJumpData.Connections.Main = RS.Heartbeat:Connect(function(dt)
                    if not self.Data.Enabled or (os.clock() - start >= LongJumpData.Settings.Timer) then 
                        if self.Data.Enabled then
                            self.Functions.Toggle(false, false, false, true, true)
                        end
                        return 
                    end

                    LP.Character.PrimaryPart.CFrame += LP.Character.PrimaryPart.CFrame.LookVector * dt * LongJumpData.Settings.Speed
                end)
            else
                for i,v in LongJumpData.Connections do v:Disconnect() end
                table.clear(LongJumpData.Connections)

                FlyData.Allowed = true
                if not FlyData.Toggle.Data.Enabled then
                    SpeedData.Allowed = true
                end
                LP.Character.HumanoidRootPart.Anchored = false
            end
        end
    })

    LongJumpData.Toggle.Functions.Settings.Slider({
        Name = "Speed",
        Description = "How fast you go",
        Min = 40,
        Max = 70,
        Default = 70,
        Flag = "LongJumpSpeed",
        Callback = function(self, callback)
            LongJumpData.Settings.Speed = callback
        end
    })

    LongJumpData.Toggle.Functions.Settings.Slider({
        Name = "Timer",
        Description = "How long you jump for",
        Min = 0.1,
        Max = 1.5,
        Default = 1.2,
        Decimals = 1,
        Flag = "LongJumpTimer",
        Callback = function(self, callback)
            LongJumpData.Settings.Timer = callback
        end
    })
end)()

local getnearestorb = function()
    local d = {distance = math.huge, orb = nil}
    for i,v in CS:GetTagged("treeOrb") do
        if v:GetAttribute("TreeOrbSecret") and v:FindFirstChild("treeOrb") and v:FindFirstChild("Spirit") then
            local dist = LP:DistanceFromCharacter(v.Spirit.Position)
            if d.distance > dist then
                d = {distance = dist, orb = v}
            end
        end
    end
    return d
end

local getnearestspirit = function()
    local d = {spirit = nil, distance = math.huge}
    for i,v in CS:GetTagged("EvelynnSoul") do
        if v:FindFirstChild("bigball") and v:GetAttribute("SpiritSecret") then
            local dist = LP:DistanceFromCharacter(v.bigball.Position)
            if d.distance > dist then
                d = {spirit = v, distance = dist}
            end
        end
    end
    return d
end

local getnearestmetal = function()
    local d = {metal = nil, distance = math.huge}
    for i,v in CS:GetTagged("hidden-metal-prompt") do
        if v:FindFirstChild("hidden-metal-prompt") and v:FindFirstChild("hidden-metal-prompt"):IsA("ProximityPrompt") and v:FindFirstChild("hidden-metal-prompt").ActionText == "Collect" and v:GetAttribute("Id") and v:FindFirstChild("Part") then
            local dist = LP:DistanceFromCharacter(v.Part.Position)
            if d.distance > dist then
                d = {metal = v, distance = dist}
            end
        end
    end
    return d
end

(function() 
    local AutoKit = {
        Settings = {
            Kit = "Eldertree",
            KitRanges = {
                Eldertree = 18,
                MetalDetector = 8
            }
        }
    }
    
    local autokit = Tabs.Utility.Functions.NewModule({
        Name = "AutoKit",
        Description = "Automatically uses your kits ability",
        Icon = "rbxassetid://80238190157458",
        Flag = "AutoKit",
        Callback = function(self, callback)
            if callback then
                repeat
                    if AutoKit.Settings.Kit == "Eldertree" then
                        local orb = getnearestorb()
                        if orb.orb and AutoKit.Settings.KitRanges.Eldertree >= orb.distance then
                            if GameData.Modules.Remotes:Get("ConsumeTreeOrb"):CallServer({treeOrbSecret = orb.orb:GetAttribute("TreeOrbSecret")}) then
                                orb.orb:Destroy()
                                GameData.Modules.Animation:playAnimation(LP, GameData.Modules.AnimationTypes.PUNCH)
                                GameData.Controllers.ViewModel:playAnimation(GameData.Modules.AnimationTypes.FP_USE_ITEM)
                            end
                        end
                    elseif AutoKit.Settings.Kit == "Evelynn" then
                        local spirit = getnearestspirit()
                        if spirit.spirit then
                            GameData.Controllers.SpiritAssasin:useSpirit(LP, spirit.spirit)
                        end
                    elseif AutoKit.Settings.Kit == "MetalDetector" then
                        local metal = getnearestmetal()
                        if metal.metal and AutoKit.Settings.KitRanges.MetalDetector >= metal.distance then
                            GameData.Modules.Animation:playAnimation(LP, GameData.Modules.AnimationTypes.SHOVEL_DIG)
                            GameData.Modules.Remotes:Get("CollectCollectableEntity"):SendToServer({
                                ["id"] = metal.metal:GetAttribute("Id")
                            })
                        end
                    end
                    task.wait()
                until not self.Data.Enabled
            end
        end
    })
    
    autokit.Functions.Settings.Dropdown({
        Name = "Kit",
        Description = "What kit to use",
        Default = "Eldertree",
        Options = {"Eldertree", "Evelynn", "MetalDetector"},
        Flag = "AutoKitKit",
        Callback = function(self, value)
            AutoKit.Settings.Kit = value
            for i,v in AutoKit.Settings.KitRanges do
                task.spawn(function()
                    repeat task.wait() until autokit.Settings[i.."AutoKitRange"].Functions
                    autokit.Settings[i.."AutoKitRange"].Functions.SetVisiblity(value == i)
                end)
            end
        end
    })
    
    autokit.Functions.Settings.Slider({
        Name = "Range",
        Description = "Range to collect eldertree orbs",
        Min = 1,
        Max = 18,
        Default = 18,
        Hide = true,
        Flag = "EldertreeAutoKitRange",
        Callback = function(self, value)
            AutoKit.Settings.KitRanges.Eldertree = value
        end
    })
    
    autokit.Functions.Settings.Slider({
        Name = "Range",
        Description = "Range to collect metal",
        Min = 1,
        Max = 8,
        Default = 8,
        Hide = true,
        Flag = "MetalDetectorAutoKitRange",
        Callback = function(self, value)
            AutoKit.Settings.KitRanges.MetalDetector = value
        end
    })
end)()
