if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Night = getgenv().Night
local Assets = Night.Assets
local Functions = Assets.Functions :: {
    cloneref: (service: Instance) -> Instance, 
    IsAlive: (Player: Player) -> boolean,
    Notify: (Description: string, Duration: number, Flag: string | any) -> {Functions: {Remove: (RemoveAnimation: boolean) -> nil}},
    gethui: () -> CoreGui | PlayerGui
}

local Noti = Assets.Notifications :: {Send: ({Description: string, Duration: number, Flag: string}) -> any}
local Tabs = Night.Tabs.Tabs :: {
    Combat: {
        Functions: {NewModule: (
            {Name: string, Description: string, Icon: string | any, Default: boolean | false, Button: boolean | false, Flag: string, Callback: (self: {Data: {Enabled: boolean}}, Callback: boolean) -> any}
        ) -> {
            Data: {Enabled: boolean},
            Functions: {
                Settings: {
                    Slider: ({Name: string, Description: string, ToolTip: string, Min: number, Max: number, Default: number, Decimals: number, DoubleValue: boolean, Flag: string, Hide: boolean, Callback: (self: {}, Callback: number) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    TextBox: ({Name: string, PlaceHolderText: string, Description: string, ToolTip: string, Flag: string, Default: string, Hide: boolean, Callback: (self: {}, Callback: string) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    MiniToggle: ({Name: string, Description: string, ToolTip: string, Default: boolean, Flag: string, Hide: boolean, Callback: (self: {Enabled: boolean}, Callback: boolean) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Dropdown: ({Name: string, Description: string, ToolTip: string, SelectLimit: number, Options: {},  Default: string | {}, Flag: string, Hide: boolean, Callback: (self: {}, Callback: string | {}) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Button: ({Name: string, Description: string, ToolTip: string, Flag: string, Hide: boolean, Callback: (self: {}, Callback: boolean) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Keybind: ({Name: string, Description: string, Default: string, ToolTip: string, Hide: boolean, Flag: string, Callbacks: {Began: () -> (), End: () -> (), Changed: () -> ()}, Mobile: {Text: string, Default: boolean, Visible: boolean}}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},   
                }
            }
        }}
    }, Movement: {
        Functions: {NewModule: (
            {Name: string, Description: string, Icon: string | any, Default: boolean | false, Button: boolean | false, Flag: string, Callback: (self: {Data: {Enabled: boolean}}, Callback: boolean) -> any}
        ) -> {
            Data: {Enabled: boolean},
            Functions: {
                Settings: {
                    Slider: ({Name: string, Description: string, ToolTip: string, Min: number, Max: number, Default: number, Decimals: number, DoubleValue: boolean, Flag: string, Hide: boolean, Callback: (self: {}, Callback: number) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    TextBox: ({Name: string, PlaceHolderText: string, Description: string, ToolTip: string, Flag: string, Default: string, Hide: boolean, Callback: (self: {}, Callback: string) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    MiniToggle: ({Name: string, Description: string, ToolTip: string, Default: boolean, Flag: string, Hide: boolean, Callback: (self: {Enabled: boolean}, Callback: boolean) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Dropdown: ({Name: string, Description: string, ToolTip: string, SelectLimit: number, Options: {},  Default: string | {}, Flag: string, Hide: boolean, Callback: (self: {}, Callback: string | {}) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Button: ({Name: string, Description: string, ToolTip: string, Flag: string, Hide: boolean, Callback: (self: {}, Callback: boolean) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Keybind: ({Name: string, Description: string, Default: string, ToolTip: string, Hide: boolean, Flag: string, Callbacks: {Began: () -> (), End: () -> (), Changed: () -> ()}, Mobile: {Text: string, Default: boolean, Visible: boolean}}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},   
                }
            }
        }}
    }, Render: {
        Functions: {NewModule: (
            {Name: string, Description: string, Icon: string | any, Default: boolean | false, Button: boolean | false, Flag: string, Callback: (self: {Data: {Enabled: boolean}}, Callback: boolean) -> any}
        ) -> {
            Data: {Enabled: boolean},
            Functions: {
                Settings: {
                    Slider: ({Name: string, Description: string, ToolTip: string, Min: number, Max: number, Default: number, Decimals: number, DoubleValue: boolean, Flag: string, Hide: boolean, Callback: (self: {}, Callback: number) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    TextBox: ({Name: string, PlaceHolderText: string, Description: string, ToolTip: string, Flag: string, Default: string, Hide: boolean, Callback: (self: {}, Callback: string) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    MiniToggle: ({Name: string, Description: string, ToolTip: string, Default: boolean, Flag: string, Hide: boolean, Callback: (self: {Enabled: boolean}, Callback: boolean) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Dropdown: ({Name: string, Description: string, ToolTip: string, SelectLimit: number, Options: {},  Default: string | {}, Flag: string, Hide: boolean, Callback: (self: {}, Callback: string | {}) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Button: ({Name: string, Description: string, ToolTip: string, Flag: string, Hide: boolean, Callback: (self: {}, Callback: boolean) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Keybind: ({Name: string, Description: string, Default: string, ToolTip: string, Hide: boolean, Flag: string, Callbacks: {Began: () -> (), End: () -> (), Changed: () -> ()}, Mobile: {Text: string, Default: boolean, Visible: boolean}}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},   
                }
            }
        }}
    }, Player: {
        Functions: {NewModule: (
            {Name: string, Description: string, Icon: string | any, Default: boolean | false, Button: boolean | false, Flag: string, Callback: (self: {Data: {Enabled: boolean}}, Callback: boolean) -> any}
        ) -> {
            Data: {Enabled: boolean},
            Functions: {
                Settings: {
                    Slider: ({Name: string, Description: string, ToolTip: string, Min: number, Max: number, Default: number, Decimals: number, DoubleValue: boolean, Flag: string, Hide: boolean, Callback: (self: {}, Callback: number) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    TextBox: ({Name: string, PlaceHolderText: string, Description: string, ToolTip: string, Flag: string, Default: string, Hide: boolean, Callback: (self: {}, Callback: string) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    MiniToggle: ({Name: string, Description: string, ToolTip: string, Default: boolean, Flag: string, Hide: boolean, Callback: (self: {Enabled: boolean}, Callback: boolean) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Dropdown: ({Name: string, Description: string, ToolTip: string, SelectLimit: number, Options: {},  Default: string | {}, Flag: string, Hide: boolean, Callback: (self: {}, Callback: string | {}) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Button: ({Name: string, Description: string, ToolTip: string, Flag: string, Hide: boolean, Callback: (self: {}, Callback: boolean) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Keybind: ({Name: string, Description: string, Default: string, ToolTip: string, Hide: boolean, Flag: string, Callbacks: {Began: () -> (), End: () -> (), Changed: () -> ()}, Mobile: {Text: string, Default: boolean, Visible: boolean}}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},   
                }
            }
        }}
    }, World: {
        Functions: {NewModule: (
            {Name: string, Description: string, Icon: string | any, Default: boolean | false, Button: boolean | false, Flag: string, Callback: (self: {Data: {Enabled: boolean}}, Callback: boolean) -> any}
        ) -> {
            Data: {Enabled: boolean},
            Functions: {
                Settings: {
                    Slider: ({Name: string, Description: string, ToolTip: string, Min: number, Max: number, Default: number, Decimals: number, DoubleValue: boolean, Flag: string, Hide: boolean, Callback: (self: {}, Callback: number) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    TextBox: ({Name: string, PlaceHolderText: string, Description: string, ToolTip: string, Flag: string, Default: string, Hide: boolean, Callback: (self: {}, Callback: string) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    MiniToggle: ({Name: string, Description: string, ToolTip: string, Default: boolean, Flag: string, Hide: boolean, Callback: (self: {Enabled: boolean}, Callback: boolean) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Dropdown: ({Name: string, Description: string, ToolTip: string, SelectLimit: number, Options: {},  Default: string | {}, Flag: string, Hide: boolean, Callback: (self: {}, Callback: string | {}) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Button: ({Name: string, Description: string, ToolTip: string, Flag: string, Hide: boolean, Callback: (self: {}, Callback: boolean) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Keybind: ({Name: string, Description: string, Default: string, ToolTip: string, Hide: boolean, Flag: string, Callbacks: {Began: () -> (), End: () -> (), Changed: () -> ()}, Mobile: {Text: string, Default: boolean, Visible: boolean}}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},   
                }
            }
        }}
    }, Utility: {
        Functions: {NewModule: (
            {Name: string, Description: string, Icon: string | any, Default: boolean | false, Button: boolean | false, Flag: string, Callback: (self: {Data: {Enabled: boolean}}, Callback: boolean) -> any}
        ) -> {
            Data: {Enabled: boolean},
            Functions: {
                Settings: {
                    Slider: ({Name: string, Description: string, ToolTip: string, Min: number, Max: number, Default: number, Decimals: number, DoubleValue: boolean, Flag: string, Hide: boolean, Callback: (self: {}, Callback: number) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    TextBox: ({Name: string, PlaceHolderText: string, Description: string, ToolTip: string, Flag: string, Default: string, Hide: boolean, Callback: (self: {}, Callback: string) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    MiniToggle: ({Name: string, Description: string, ToolTip: string, Default: boolean, Flag: string, Hide: boolean, Callback: (self: {Enabled: boolean}, Callback: boolean) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Dropdown: ({Name: string, Description: string, ToolTip: string, SelectLimit: number, Options: {},  Default: string | {}, Flag: string, Hide: boolean, Callback: (self: {}, Callback: string | {}) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Button: ({Name: string, Description: string, ToolTip: string, Flag: string, Hide: boolean, Callback: (self: {}, Callback: boolean) -> any}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},
                    Keybind: ({Name: string, Description: string, Default: string, ToolTip: string, Hide: boolean, Flag: string, Callbacks: {Began: () -> (), End: () -> (), Changed: () -> ()}, Mobile: {Text: string, Default: boolean, Visible: boolean}}) -> {Functions: {SetVisiblity: (visible: boolean) -> any}},   
                }
            }
        }}
    }
}

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
local PG = Functions.cloneref(LP:WaitForChild("PlayerGui")) :: PlayerGui

Functions.Notify = function(Description: string, Duration: number, Flag: string | any)
    if Description == nil or not tonumber(Duration) then return "Failed to send, make sure you have a description and a valid duration" end
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
repeat task.wait() until Knit and Cam:FindFirstChild("Viewmodel") and WS:FindFirstChild("Map")

local GameData = {
    Controllers = {
        Balloon = Knit.Controllers.BalloonController,
        BlockBreaker = Knit.Controllers.BlockBreakController.blockBreaker,
        Chest = Knit.Controllers.ChestController,
        Dao = Knit.Controllers.DaoController,
        Place = Knit.Controllers.BlockPlacementController,
        Queue = Knit.Controllers.QueueController,
        SetInvItem = Knit.Controllers.SetInvItem,
        SpiritAssasin = Knit.Controllers.SpiritAssassinController,
        Sprint = Knit.Controllers.SprintController,
        Sword = Knit.Controllers.SwordController,
        TeamCrate = Knit.Controllers.TeamCrateController,
        TeamUpgrades = Knit.Controllers.TeamUpgradeController,
        ViewModel = Knit.Controllers.ViewmodelController,
        Wind = Knit.Controllers.WindWalkerController
    },
    Modules = {
        Animation = require(Rep.TS.animation["animation-util"]).GameAnimationUtil,
        AnimationTypes = require(Rep.TS.animation["animation-type"]).AnimationType,
        App = require(Rep.rbxts_include.node_modules["@easy-games"]["game-core"].out.client.controllers["app-controller"]).AppController,
        ArmorSets = require(Rep.TS.games.bedwars["bedwars-armor-set"]),
        BlockEngine = require(Rep.rbxts_include.node_modules["@easy-games"]["block-engine"].out).BlockEngine,
        BlockEngineClient = require(LP.PlayerScripts.TS.lib["block-engine"]["client-block-engine"]).ClientBlockEngine,
        BlockPlacer = require(Rep.rbxts_include.node_modules["@easy-games"]["block-engine"].out.client.placement["block-placer"]).BlockPlacer,
        BlockRemotes = require(Rep.rbxts_include.node_modules["@easy-games"]["block-engine"].out.shared.remotes).BlockEngineRemotes,
        ChargeState = require(Rep.TS.combat["charge-state"]).ChargeState,
        DamageType = require(Rep.TS.damage["damage-type"]).DamageType,
        Inventory = require(Rep.TS.inventory["inventory-util"]).InventoryUtil,
        ItemMeta = require(Rep.TS.item["item-meta"]).items,
        Knockback = require(Rep.TS.damage["knockback-util"]).KnockbackUtil,
        Network = require(LP.PlayerScripts.TS.lib.network),
        PlayerUtil = require(Rep.TS.player["player-util"]).GamePlayerUtil,
        Projectile = require(LP.PlayerScripts.TS.controllers.global.combat.projectile["projectile-controller"]).ProjectileController,
        ProjMeta = require(Rep.TS.projectile['projectile-meta']).ProjectileMeta,
        Promise = require(KnitPath.src.Knit.Util.Promise),
        Remotes = require(Rep.TS.remotes).default.Client,
        Shop = require(Rep.TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop,
        ShopPurchase = require(LP.PlayerScripts.TS.controllers.global.shop.api["purchase-item"]).shopPurchaseItem,
        Sound = require(Rep.rbxts_include.node_modules["@easy-games"]["game-core"].out).SoundManager,
        Store = require(LP.PlayerScripts.TS.ui.store).ClientStore,
        SyncEvents = require(LP.PlayerScripts.TS["client-sync-events"]).ClientSyncEvents,
        TeamUpgradeMeta = require(Rep.TS.games.bedwars["team-upgrade"]["team-upgrade-meta"]),
        UI = require(Rep.rbxts_include.node_modules["@easy-games"]["game-core"].out).UILayers
    },
    Remotes = {Set = Rep.rbxts_include.node_modules['@rbxts'].net.out._NetManaged.SetInvItem},
    Events = {
        Damage = Instance.new("BindableEvent"),
        Death = Instance.new("BindableEvent")
    },
    GameEvents = {}
}

repeat task.wait() until GameData.Modules.Store:getState().Game and GameData.Modules.Store:getState().Game.matchState

local OnUninject = Assets.Main.OnUninject :: BindableEvent
table.insert(Night.Connections, OnUninject.Event:Connect(function()
    for _, v in GameData.Events do
        v:Destroy()
    end
    for _, v in GameData.GameEvents do
        if typeof(v) == "function" then
            v()
        elseif typeof(v) == "RBXScriptConnection" then
            v:Disconnect()
        end
    end
    table.clear(GameData.GameEvents)
    table.clear(GameData.Events)
end))

local Materials = {}
for _, v in next, Enum.Material:GetEnumItems() do
    table.insert(Materials, v.Name)
end

local Hit = GameData.Controllers.Sword.sendServerRequest
local SwordServerRequestConstants = debug.getconstants(Hit)
local find = table.find(SwordServerRequestConstants, "Client")
local HitRemoteName = SwordServerRequestConstants[find + 1]
if find and SwordServerRequestConstants[find + 1] then
    HitRemoteName = SwordServerRequestConstants[find + 1]
else
    for i, v in SwordServerRequestConstants do
        if v == "Client" then
            HitRemoteName = SwordServerRequestConstants[i + 1]
            return
        end
    end

    for _, v in SwordServerRequestConstants do
        if v == "SwordHit" then
            HitRemoteName = v
            return
        end
    end
end

if not HitRemoteName then
    Functions.Notify("Failed to get the hit remote, due to how bad your executor is. Find supported executors in our server: https://discord.gg/PvhQnTWaHy (invite copied to clipboard).", 15)
    if setclipboard then
        setclipboard("https://discord.gg/PvhQnTWaHy")
    elseif toclipboard then
        toclipboard("https://discord.gg/PvhQnTWaHy")
    end
    return
end

local oldWind, speedOrb = GameData.Controllers.Wind.updateJump, 0
GameData.Controllers.Wind.updateJump = function(self, orb, ...)
    if Functions.IsAlive() then
        speedOrb = orb or 0
    end
    return oldWind(self, orb, ...)
end

local GetSpeedModifier = function(val: number)
    local speed, add = 0, false

	if Functions.IsAlive() then 
		local boost = LP.Character:GetAttribute("SpeedBoost")
		if boost and boost > 1 then 
            speed += val * (boost - 1)
            add = true
		end

		if LP.Character:GetAttribute("SpeedPieBuff") then
			speed += add and 3 or val - 17
            add = true
		end

        local name = WS[LP.Name]
        if name and name:FindFirstChild("speed_boots_left") and name:FindFirstChild("speed_boots_right") then 
            speed += add and 15 or val
            add = true
        end

        if LP.Character:GetAttribute("GrimReaperChannel") then 
            speed += add and 12 or val - 1
            add = true
        end

		if speedOrb ~= 0 then 
			speed += add and 16 or val + 1
		end
	end

	return speed
end

local GetMatchState = function()
    return GameData.Modules.Store:getState().Game.matchState
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
    for _, v in CS:GetTagged("entity") do
        Entities[v] = {
            PrimaryPart = v.PrimaryPart,
            Player = Plrs:GetPlayerFromCharacter(v),
            Health = v:GetAttribute("Health") or 0,
            Humanoid = v:FindFirstChild("Humanoid")
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
            if sword.damage > Sword.Damage then
                Sword = {Sword = v, Damage = sword.damage}
            end
        end
    end
    return Sword
end

local GetColor = function(input: string)
	local split = string.split(input, ",")
	if #split == 3 then
		local r, g, b = tonumber(split[1]), tonumber(split[2]), tonumber(split[3])
		if r and g and b then
			return {R = r, G = g, B = b}
		end
	end
    return {R = 0, G = 0, B = 0}
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

local CreateTimerUi = function(Options: {StartTime: number, Color: {R: number, G: number, B: number}})
    local Data = {
        StartTime = Options.StartTime or 2.5,
        Functions = {}
    }

    local FlyUI = Instance.new("ScreenGui", Functions.gethui())

    local BG = Instance.new("Frame", FlyUI)
    BG.Size = UDim2.fromOffset(260, 80)
    BG.Position = UDim2.new(0.5, -130, 0.55, 0)
    BG.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    BG.BorderSizePixel = 0    
    Instance.new("UICorner", BG).CornerRadius = UDim.new(0, 14)

    local TimeText = Instance.new("TextLabel", BG)
    TimeText.Size = UDim2.fromScale(1, 0.4)
    TimeText.Position = UDim2.fromScale(0, 0.1)
    TimeText.Text = tostring(Data.StartTime)
    TimeText.Font = Enum.Font.GothamBold
    TimeText.TextSize = 22
    TimeText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TimeText.BackgroundTransparency = 1
        
    local PB_BG = Instance.new("Frame", BG)
    PB_BG.Size = UDim2.new(1, -30, 0.25, 0)
    PB_BG.Position = UDim2.new(0, 15, 0.65, 0)
    PB_BG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    PB_BG.BorderSizePixel = 0
    Instance.new("UICorner", PB_BG).CornerRadius = UDim.new(0, 12)

    local PB = Instance.new("Frame", PB_BG)
    PB.Size = UDim2.fromScale(1, 1)
    PB.BackgroundColor3 = Color3.fromRGB(Options.Color.R, Options.Color.G, Options.Color.B)
    PB.BorderSizePixel = 0
    Instance.new("UICorner", PB).CornerRadius = UDim.new(0, 12)

    Data.Functions.Update = function(Time: number, Size: UDim2)
        if setthreadidentity then
            pcall(setthreadidentity, 8)
        end

        TimeText.Text = string.format("%.1f", Time)
        PB.Size = Size
    end

    Data.Functions.Destroy = function()
        if setthreadidentity then
            pcall(setthreadidentity, 8)
        end

        FlyUI:Destroy()
    end

    return Data
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
        Callback = function(self, callback)
            if callback then
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
                for _, v in SpeedData.Connections do 
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
        Name = "Speed Increase",
        Description = "Value to increase when using a speed boost",
        Min = 20,
        Max = 23, 
        Default = 23,
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
        Default = 23,
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
        VericalAmount = 50,
        LastOnGround = os.clock(),
        FlyTimer = false,
        UIColor = {R = 210, G = 210, B = 210}
    },
    FlyUi = nil,
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

                if Night.Mobile then
                    pcall(function()
                        local jumpButton = PG.TouchGui.TouchControlFrame.JumpButton
                        table.insert(FlyData.Connections, jumpButton:GetPropertyChangedSignal("ImageRectOffset"):Connect(function()
                            FlyData.Settings.VerticalValue = jumpButton.ImageRectOffset.X == 146 and 1 or 0
                        end))
                    end)
                end

                if FlyData.Settings.FlyTimer and not FlyData.FlyUi then
                    FlyData.FlyUi = CreateTimerUi({StartTime = 2.5, Color = FlyData.Settings.UIColor})
                end

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
                                if os.clock() - FlyData.Settings.LastOnGround >= 2 then
                                    if FlyData.Settings.TPDown then
                                        local FlyRay = RaycastParams.new()
                                        FlyRay.FilterType = Enum.RaycastFilterType.Include
                                        FlyRay.FilterDescendantsInstances = CS:GetTagged("block")
                                        local RAY = WS:Raycast(LP.Character.HumanoidRootPart.Position, -Vector3.new(0, 1000, 0), FlyRay)
                                        local OldPos = LP.Character.HumanoidRootPart.Position.Y :: Vector3
                                        if RAY and RAY.Instance then
                                            LP.Character.HumanoidRootPart.CFrame = CFrame.lookAlong(Vector3.new(LP.Character.HumanoidRootPart.Position.X, RAY.Position.Y + LP.Character.Humanoid.HipHeight, LP.Character.HumanoidRootPart.Position.Z), LP.Character.HumanoidRootPart.CFrame.LookVector)
                                            FlyData.Settings.LastOnGround = os.clock()
                                            task.wait(0.05)
                                            LP.Character.HumanoidRootPart.CFrame = CFrame.lookAlong(Vector3.new(LP.Character.HumanoidRootPart.Position.X, OldPos, LP.Character.HumanoidRootPart.Position.Z), LP.Character.HumanoidRootPart.CFrame.LookVector)
                                        end
                                    end
                                end
                            end
                        end
                        
                        if LP.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
                            FlyData.Settings.LastOnGround = os.clock()
                            if FlyData.FlyUi then
                                FlyData.FlyUi.Functions.Update(2.5, UDim2.fromScale(1, 1))
                            end
                        else
                            if FlyData.FlyUi then
                                local elapsed = os.clock() - FlyData.Settings.LastOnGround  
                                local time = 2.5 - elapsed
                                FlyData.FlyUi.Functions.Update(time, UDim2.fromScale(math.max(time, 0) / 2.5, 1))
                            end
                        end

                        LP.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(MoveDir.X * (FlyData.Settings.Speed + SpeedMultiplier), YVelocityDev, MoveDir.Z * (FlyData.Settings.Speed + SpeedMultiplier))
                        if UsingBalloon then
                            task.wait(0.3)
                        end
                    end

                    task.wait()
                until not self.Data.Enabled
            else
                if FlyData.FlyUi then
                    FlyData.FlyUi.Functions.Destroy()
                    FlyData.FlyUi = nil
                end
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
        Max = 23,
        Default = 23,
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
        Max = 150,
        Default = 50,
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

    local FlyColor
    FlyData.Toggle.Functions.Settings.MiniToggle({
        Name = "Timer UI",
        Description = "A UI to show how long you have left in the air",
        Default = true,
        Flag = "FlyTimerUI",
        Callback = function(self, callback)
            FlyData.Settings.FlyTimer = callback
            if FlyData.Toggle.Data.Enabled then
                if FlyData.Settings.FlyTimer and not FlyData.FlyUi then
                    FlyData.FlyUi = CreateTimerUi({StartTime = 2.5})
                end
            else
                if FlyData.FlyUi then
                    FlyData.FlyUi.Functions.Destroy()
                    FlyData.FlyUi = nil
                end
            end
            task.spawn(function()
                repeat task.wait() until FlyColor
                FlyColor.Functions.SetVisiblity(callback)
            end)
        end
    })

    FlyColor = FlyData.Toggle.Functions.Settings.TextBox({
        Name = "UI Color",
        Description = "Color of the UI",
        Default = "210, 210, 210",
        Hide = true,
        Flag = "FlyUIColor",
        Callback = function(self, callback)
            local color = GetColor(callback)
            if color then
                FlyData.Settings.UIColor = color
            end
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
        Min = 1,
        Max = 30,
        Default = 23,
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
end)()

local KillAuraData = {
    Settings = {
        Range = 18,
        ChargeTime = 0.4,
        MaxAngle = 360,
        Prediction = 15,
        WallCheck = false,
        LastSwingTimeEnabled = false,
        RequireMouseDown = false,
        MouseDown = false,
        HandCheck = false,
        Swing = false,
        OnSwingDelay = false,
        SwingDelay = 0,
        Delay = 0,
        AutomaticallySwitch = false,
        Visuals = {
            Highlights = {},
            Highlight = false,
            Particles = false,
            CustomAnim = false,
            PickedAnimation = "Air",
            Material = "Air",
            ParticleRate = 15,
            HightLightTransparency = 0.5,
            HighlightColor = {R = 250, G = 250, B = 250},
            ParticleColor = {Start = {R = 255, G = 255, B = 255}, End = {R = 0, G = 0, B = 0}},
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
    Connections = {},
    Attacking = false
}

(function()
    KillAuraData.Toggle = Tabs.Combat.Functions.NewModule({
        Name = "KillAura",
        Description = "Automatically attacks enemies near you",
        Icon = "rbxassetid://108945365943475",
        Flag = "KillAura",
        Callback = function(self, callback)
            if callback then
                repeat task.wait() until GetMatchState() ~= 0

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

                local Timer = 0
                repeat
                    task.wait(0.0025)
                    local NearestEntity = GetNearestEntity()
                    if NearestEntity.Entity and KillAuraData.Settings.Range >= NearestEntity.Distance and GameData.Modules.Remotes:Get(HitRemoteName) then
                        KillAuraData.Attacking = true
                        local Sword = GetBestSword()
                        if Sword.Sword and Sword.Sword.tool then
                            local CurrentItem = GetInventory().hand 
                            if CurrentItem and CurrentItem.itemType then
                                local itemMeta = GameData.Modules.ItemMeta[CurrentItem.itemType]
                                if not itemMeta or not itemMeta.sword then
                                    if KillAuraData.Settings.AutomaticallySwitch then
                                        GameData.Remotes.Set:InvokeServer({hand = Sword.Sword.tool})
                                    else
                                        if KillAuraData.Settings.HandCheck then continue end
                                    end
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
                                    local Ray = WS:Raycast(EntityPos, LP.Character.HumanoidRootPart.Position - EntityPos, RPrams)
                                    if Ray and Ray.Instance and WS:FindFirstChild("Map") and  Ray.Instance:IsDescendantOf(WS:FindFirstChild("Map")) then
                                        continue
                                    end
                                end

                                local itemMeta
                                if not CurrentItem or not CurrentItem.tool or not CurrentItem.itemType then
                                    GameData.Remotes.Set:InvokeServer({hand = Sword.Sword.tool})
                                else
                                    itemMeta = GameData.Modules.ItemMeta[CurrentItem.itemType]
                                    if not itemMeta or not itemMeta.sword then
                                        GameData.Remotes.Set:InvokeServer({hand = Sword.Sword.tool})
                                    end
                                end

                                task.spawn(function()
                                    if not KillAuraData.Settings.Visuals.Highlights[NearestEntity] and KillAuraData.Settings.Visuals.Highlight then
                                        local Highlight = Instance.new("Part", EntityRoot)
                                        Highlight.Transparency = KillAuraData.Settings.Visuals.HightLightTransparency
                                        Highlight.Anchored = true
                                        Highlight.Material = Enum.Material[KillAuraData.Settings.Visuals.Material]
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
                                        Particle.Rate = KillAuraData.Settings.Visuals.ParticleRate
                                        Particle.Lifetime = NumberRange.new(0.5, 1)
                                        Particle.Rotation = NumberRange.new(1, 360)
                                        Particle.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(KillAuraData.Settings.Visuals.ParticleColor.Start.R, KillAuraData.Settings.Visuals.ParticleColor.Start.G, KillAuraData.Settings.Visuals.ParticleColor.Start.B)), ColorSequenceKeypoint.new(1, Color3.fromRGB(KillAuraData.Settings.Visuals.ParticleColor.End.R, KillAuraData.Settings.Visuals.ParticleColor.End.G, KillAuraData.Settings.Visuals.ParticleColor.End.B))}
                                        Particle.Texture = math.random(1, 2) == 1 and "rbxassetid://134430724029611" or "rbxassetid://102948578222494"
                                        
                                        task.delay(0.3, function()
                                            Particle.Enabled = false
                                            task.wait(0.3)
                                            Particle:Destroy()
                                        end)
                                    end
                                end)

                                task.spawn(function()
                                    if KillAuraData.Settings.Swing and not KillAuraData.Settings.OnSwingDelay then 
                                        GameData.Modules.Animation:playAnimation(LP, GameData.Modules.AnimationTypes.SWORD_SWING)
                                        GameData.Controllers.ViewModel:playAnimation(GameData.Modules.AnimationTypes.FP_SWING_SWORD)
                                        if KillAuraData.Settings.SwingDelay > 0 then
                                            KillAuraData.Settings.OnSwingDelay = true
                                            task.delay(KillAuraData.Settings.SwingDelay, function()
                                                KillAuraData.Settings.OnSwingDelay = false
                                            end)
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

                                local lastswing = Random.new():NextNumber(3, 40)
                                if KillAuraData.Settings.LastSwingTimeEnabled then
                                    lastswing = GameData.Controllers.Sword.lastSwingServerTimeDelta
                                end

                                if (tick() - Timer) < (KillAuraData.Settings.ChargeTime >= 0.1 and KillAuraData.Settings.ChargeTime - 0.1 or KillAuraData.Settings.ChargeTime) then continue end

                                local calc = KillAuraData.Settings.Prediction / 30
                                local selfPos, dir = (((LP.Character.HumanoidRootPart.Position - EntityPos).Magnitude - (KillAuraData.Settings.Prediction - (calc + 0.05)) > 0) and ((LP.Character.HumanoidRootPart.Position - EntityPos).Magnitude - (KillAuraData.Settings.Prediction - (calc + 0.1))) or 0) * CFrame.lookAt(LP.Character.HumanoidRootPart.Position, EntityPos).LookVector + LP.Character.HumanoidRootPart.Position, (EntityPos - Cam.CFrame.Position)
                                GameData.Modules.Remotes:Get(HitRemoteName):SendToServer({
                                    weapon = Sword.Sword.tool,
                                    entityInstance = NearestEntity.Entity,
                                    chargedAttack = {chargeRatio = 0},
                                    lastSwingServerTimeDelta = lastswing,
                                    validate = {
                                        raycast = {
                                            cameraPosition = {value = selfPos},
                                            rayDirection = {value = (dir / dir.Magnitude * (NearestEntity.Distance <= 20 and 2 or 1))}
                                        },
                                        targetPosition = {value = EntityPos},
                                        selfPosition = {value = selfPos}
                                    }
                                })

                                Timer = tick()
                                GameData.Controllers.Sword.lastSwingServerTimeDelta = WS:GetServerTimeNow() -  GameData.Controllers.Sword.lastSwingServerTime
                                GameData.Controllers.Sword.lastSwingServerTime = WS:GetServerTimeNow()
                                
                                if CurrentItem and CurrentItem.tool and CurrentItem.tool ~= Sword.Sword.tool then
                                    if not KillAuraData.Settings.AutomaticallySwitch then
                                        GameData.Remotes.Set:InvokeServer({hand = CurrentItem.tool})
                                    end
                                end

                                task.wait(KillAuraData.Settings.Delay)
                            else
                                if KillAuraData.anim.old then
                                    task.spawn(function()
                                        repeat task.wait() until not KillAuraData.anim.playing
                                        TS:Create(Cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.5), {C0 = KillAuraData.anim.old}):Play()
                                    end)
                                end

                                for i, v in KillAuraData.Settings.Visuals.Highlights do
                                    v:Destroy()
                                    KillAuraData.Settings.Visuals.Highlights[i] = nil
                                end
                            end
                        end
                    else
                        KillAuraData.Attacking = false
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
        Description = "Range to start attacking",
        Min = 0,
        Max = 20,
        Default = 20,
        Flag = "KillAuraRange",
        Callback = function(self, callback)
            KillAuraData.Settings.Range = callback
        end
    })

    KillAuraData.Toggle.Functions.Settings.Slider({
        Name = "Charge Time",
        Description = "Time to charge before attacking",
        Min = 0,
        Decimals = 1,
        Max = 0.7,
        Default = 0.5,
        Flag = "KillAuraChargeTime",
        Callback = function(self, callback)
            KillAuraData.Settings.ChargeTime = callback
        end
    })

    KillAuraData.Toggle.Functions.Settings.MiniToggle({
        Name = "Use LastSwing",
        Description = "Uses real last swing time, does less damage",
        Default = false,
        Flag = "KillAuraUseLastSwing",
        Callback = function(self, callback)
            KillAuraData.Settings.LastSwingTimeEnabled = callback
        end
    })

    local KillAuraSwingDelay
    KillAuraData.Toggle.Functions.Settings.MiniToggle({
        Name = "Swing",
        Description = "Swings your sword near enemys",
        Default = true,
        Flag = "KillAuraSwing",
        Callback = function(self, callback)
            KillAuraData.Settings.Swing = callback
            task.spawn(function()
                repeat task.wait() until KillAuraSwingDelay
                KillAuraSwingDelay.Functions.SetVisiblity(callback)
            end)
        end
    })

    KillAuraSwingDelay = KillAuraData.Toggle.Functions.Settings.Slider({
        Name = "Swing Delay",
        Description = "Delay until another swing takes place",
        Min = 0,
        Decimals = 1,
        Max = 0.5,
        Default = 0,
        Hide = true,
        Flag = "KillAuraSwingDelay",
        Callback = function(self, callback)
            KillAuraData.Settings.SwingDelay = callback
        end
    })

    KillAuraData.Toggle.Functions.Settings.Slider({
        Name = "Delay",
        Description = "Delay after every hit",
        Min = 0,
        Decimals = 1,
        Max = 0.5,
        Default = 0,
        Flag = "KillAuraDelay",
        Callback = function(self, callback)
            KillAuraData.Settings.Delay = callback
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
                repeat task.wait() until #HighLightOptions == 3
                for i,v in HighLightOptions do 
                    v.Functions.SetVisiblity(callback)
                end
            end)
        end
    })

    table.insert(HighLightOptions, KillAuraData.Toggle.Functions.Settings.Dropdown({
        Name = "Highlight Material",
        Description = "Material of the highlight",
        Default = "SmoothPlastic",
        Options = Materials,
        Flag = "KillAuraMaterial",
        Callback = function(self, value)
            KillAuraData.Settings.Visuals.Material = value
        end
    }))

    table.insert(HighLightOptions, KillAuraData.Toggle.Functions.Settings.TextBox({
        Name = "Highlight Color",
        Description = "Color of the highlight",
        Default = "250, 250, 250",
        Hide = true,
        Flag = "KillAuraHighlightColor",
        Callback = function(self, callback)
            local color = GetColor(callback)
            if color then
                KillAuraData.Settings.Visuals.HighlightColor = color
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
                repeat task.wait() until #ParticleColors == 3
                for i,v in ParticleColors do
                    v.Functions.SetVisiblity(callback)
                end
            end)
        end
    })

    table.insert(ParticleColors, KillAuraData.Toggle.Functions.Settings.Slider({
        Name = "Particles Rate",
        Description = "How many particles are made per second",
        Min = 1,
        Max = 20,
        Default = 15,
        Hide = true,
        Flag = "KillAuraParticleRate",
        Callback = function(self, callback)
            KillAuraData.Settings.Visuals.ParticleRate = callback
        end
    }))

    table.insert(ParticleColors, KillAuraData.Toggle.Functions.Settings.TextBox({
        Name = "Start Particles Color",
        Description = "Starting color of the particles",
        Default = "255, 255, 255",
        Flag = "StartKillAuraParticleColor",
        Hide = true,
        Callback = function(self, callback)
            local color = GetColor(callback)
            if color then
                KillAuraData.Settings.Visuals.ParticleColor.Start = color
            end
        end
    }))

    table.insert(ParticleColors, KillAuraData.Toggle.Functions.Settings.TextBox({
        Name = "End Particles Color",
        Description = "Ending color of the particles",
        Default = "0, 0, 0",
        Flag = "EndKillAuraParticleColor",
        Hide = true,
        Callback = function(self, callback)
            local color = GetColor(callback)
            if color then
                KillAuraData.Settings.Visuals.ParticleColor.End = color
            end
        end
    }))
end)()

local GroundRay = RaycastParams.new()
GroundRay.FilterType = Enum.RaycastFilterType.Include
GroundRay.FilterDescendantsInstances = {WS:WaitForChild("Map")}

(function()
    local NoFallData = {
        Settings = {
            Limit = 80,
            Boost = 85,
            Dangerous = 80,
            Velo = 70,
            Speed = 90,
            Safe = false,
            Mode = "Physics"
        },
        Connect = nil
    }

    local Power = 0
    local Physics = function(DT)
        LP.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(LP.Character.HumanoidRootPart.AssemblyLinearVelocity.X, -NoFallData.Settings.Boost, LP.Character.HumanoidRootPart.AssemblyLinearVelocity.Z)
        LP.Character.HumanoidRootPart.CFrame += Vector3.new(0, DT * Power, 0)
        Power -= DT * WS.Gravity
    end

    NoFallData.Toggle = Tabs.Player.Functions.NewModule({
        Name = "NoFall",
        Description = "Prevents taking fall damage",
        Icon = "rbxassetid://107094770751573",
        Flag = "NoFall",
        Callback = function(self, callback)
            if callback then
                NoFallData.Connect = RS.PreSimulation:Connect(function(DT)
                    if not self.Data.Enabled or not Functions.IsAlive() then return end

                    if NoFallData.Settings.Mode == "Physics" then
                        if LP.Character.HumanoidRootPart.AssemblyLinearVelocity.Y >= -NoFallData.Settings.Limit then
                            Power = 0
                            return
                        end

                        local FallRay = RaycastParams.new()
                        FallRay.FilterDescendantsInstances = {LP.Character, Cam}
                        FallRay.CollisionGroup = LP.Character.HumanoidRootPart.CollisionGroup
                        FallRay.FilterType = Enum.RaycastFilterType.Exclude

                        local _, Size = LP.Character:GetBoundingBox()
                        local Direction = Vector3.new(0, -(Size.Y / 2), 0)

                        local Raycast = WS:Raycast(LP.Character.HumanoidRootPart.Position, Direction, FallRay)
                        if not Raycast then
                            Physics(DT)
                        else
                            Power = 0
                        end
                    elseif NoFallData.Settings.Mode == "Smooth" then
                        local Ground = WS:Raycast(LP.Character.HumanoidRootPart.Position, Vector3.new(0, -1000, 0), GroundRay)
                        if LP.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                            task.spawn(function()
                                if Ground and LP.Character.HumanoidRootPart.Position.Y - Ground.Position.Y >= NoFallData.Settings.Dangerous and NoFallData.Settings.Safe then
                                    LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, -NoFallData.Settings.Speed, 0)
                                end
                            end)
                            LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                        end
                    else
                        if LP.Character.HumanoidRootPart.Velocity.Y <= -NoFallData.Settings.Velo then
                            LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, -NoFallData.Settings.Speed, 0)
                        end
                    end
                end)
            else
                if NoFallData.Connect then
                    NoFallData.Connect:Disconnect()
                    NoFallData.Connect = nil
                end
            end
        end
    })

    local NoFallLimit, NoFallBoost, NoFallSafe, NoFallDangerous, NoFallVelocity, NoFallSpeed
    NoFallData.Toggle.Functions.Settings.Dropdown({
        Name = "Mode",
        Description = "Mode to prevent fall damage",
        Default = "Physics",
        Options = {"Physics", "Smooth", "Slow"},
        Flag = "NoFallMode",
        Callback = function(self, value)
            NoFallData.Settings.Mode = value
            task.spawn(function()
                repeat task.wait() until NoFallLimit and NoFallBoost and NoFallSafe and NoFallDangerous and NoFallVelocity and NoFallSpeed
                NoFallLimit.Functions.SetVisiblity(value == "Physics")
                NoFallBoost.Functions.SetVisiblity(value == "Physics")
                NoFallSafe.Functions.SetVisiblity(value == "Smooth")
                NoFallDangerous.Functions.SetVisiblity(value == "Smooth")
                NoFallVelocity.Functions.SetVisiblity(value == "Slow")
                NoFallSpeed.Functions.SetVisiblity(value == "Slow")
            end)
        end
    })

    NoFallLimit = NoFallData.Toggle.Functions.Settings.Slider({
        Name = "Limit",
        Description = "Limit to apply the no fall",
        Min = 70,
        Max = 90,
        Default = 80,
        Hide = true,
        Flag = "NoFallLimit",
        Callback = function(self, value)
            NoFallData.Settings.Limit = value
        end
    })

    NoFallBoost = NoFallData.Toggle.Functions.Settings.Slider({
        Name = "Boost",
        Description = "Power to boost the physics",
        Min = 80,
        Max = 100,
        Default = 85,
        Hide = true,
        Flag = "NoFallBoost",
        Callback = function(self, value)
            NoFallData.Settings.Boost = value
        end
    })

    NoFallSafe = NoFallData.Toggle.Functions.Settings.MiniToggle({
        Name = "Safe Mode",
        Description = "Lands a bit slower when jumping from a very high point",
        Flag = "NoFallSafe",
        Default = true,
        Hide = true,
        Callback = function(self, value)
            NoFallData.Settings.Safe = value
        end
    })

    NoFallDangerous = NoFallData.Toggle.Functions.Settings.Slider({
        Name = "Dangerous Position",
        Description = "Height to check for the dangerous position",
        Min = 50,
        Max = 80,
        Default = 80,
        Hide = true,
        Flag = "NoFallDangerous",
        Callback = function(self, value)
            NoFallData.Settings.Dangerous = value
        end
    })

    NoFallVelocity = NoFallData.Toggle.Functions.Settings.Slider({
        Name = "Velocity Check",
        Description = "Value to check the velocity when you're falling",
        Min = 20,
        Max = 70,
        Default = 70,
        Hide = true,
        Flag = "NoFallVelocity",
        Callback = function(self, value)
            NoFallData.Settings.Velo = value
        end
    })

    NoFallSpeed = NoFallData.Toggle.Functions.Settings.Slider({
        Name = "Fall Speed",
        Description = "Speed to fall down",
        Min = 1,
        Max = 90,
        Default = 90,
        Flag = "NoFallSpeed",
        Hide = true,
        Callback = function(self, value)
            NoFallData.Settings.Speed = value
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

local DamageBlock = function(block)
    local Position = GameData.Modules.BlockEngine:getBlockPosition(block.Position)
    if Position then
        local Response = GameData.Modules.BlockRemotes.Client:Get("DamageBlock"):CallServerAsync({
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
    
    if block:GetAttribute("NoBreak") or (teamId and block:GetAttribute("Team" .. teamId .. "NoBreak")) then
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

                                if result ~= GameData.Modules.Promise.Status.Resolved or response == "cancelled" then
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

    local NukerDelay
    NukerData.Toggle.Functions.Settings.MiniToggle({
        Name = "Instant",
        Description = "Instantly breaks",
        Default = true,
        Flag = "NukerInstant",
        Callback = function(self, callback)
            NukerData.Settings.Instant = callback
            task.spawn(function()
                repeat task.wait() until NukerDelay
                NukerDelay.Functions.SetVisiblity(not callback)
            end)
        end
    })

    NukerDelay = NukerData.Toggle.Functions.Settings.Slider({
        Name = "Delay",
        Description = "Delay after each hit",
        Min = 0,
        Max = 1,
        Default = 0.1,
        Flag = "NukerDelay",
        Callback = function(self, callback)
            NukerData.Settings.Delay = callback
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
        Name = "InfiniteJump",
        Description = "Lets you jump with no limit",
        Flag = "InfiniteJump",
        Icon = "rbxassetid://73148132024514",
        Callback = function(self, callback)
            if callback then
                infJumpData.Misc.Connection = UIS.JumpRequest:Connect(function()
                    if Functions.IsAlive() and not infJumpData.Misc.Cooldown then
                        LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
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
        local Priority = {"wool", "ceramic", "oak", "stone", "tesla", "tnt", "obsidian"}
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
    if mode == "Vector" then
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

    if mode == "Store" then
        for x = minX, maxX do
            for y = minY, maxY do
                for z = minZ, maxZ do
                    if blocks:getBlockAt(Vector3.new(x, y, z)) then
                        table.insert(list, Vector3.new(x * 3, y * 3, z * 3))
                    end
                end
            end
        end
    elseif mode == "Count" then
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
    
    if mode == "Clamp" then
        return Vector3.new(
            math.clamp(point.X, poscheck.X - offset.X, poscheck.X + offset.X),
            math.clamp(point.Y, poscheck.Y - offset.Y, poscheck.Y + offset.Y),
            math.clamp(point.Z, poscheck.Z - offset.Z, poscheck.Z + offset.Z)
        )
    elseif mode == "Projection" then
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

    if mode == "Radius" then
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
    elseif mode == "Square" then
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
    
    if mode == "Optimized" then
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
        Name = "Tower",
        Description = "Places blocks above you when space is held",
        Flag = "ScaffoldTower",
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
        Name = "Boost",
        Description = "Boost power to apply to your character when Tower is enabled",
        Min = 2,
        Max = 7,
        Default = 5,
        Flag = "ScaffoldBoost",
        Hide = true,
        Callback = function(self, value)
            ScaffoldData.Settings.Boost = value
        end
    })
    local ScaffoldDown
    ScaffoldData.Toggle.Functions.Settings.MiniToggle({
        Name = "Down",
        Description = "Places blocks below you when left shift is held",
        Flag = "ScaffoldDown",
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
        Name = "Down",
        Description = "Blocks to place below you",
        Min = 4,
        Max = 8,
        Default = 4,
        Hide = true,
        Flag = "ScaffoldDowner",
        Callback = function(self, value)
            ScaffoldData.Settings.DownValue = value
        end
    })
    ScaffoldData.Toggle.Functions.Settings.Slider({
        Name = "Extend",
        Description = "Blocks to place in front of you",
        Min = 1,
        Max = 8,
        Default = 1,
        Flag = "ScaffoldExtend",
        Callback = function(self, value)
            ScaffoldData.Settings.Extend = value
        end
    })
    ScaffoldData.Toggle.Functions.Settings.Dropdown({
        Name = "Place",
        Description = "Mode to place blocks",
        Options = {"Optimized", "Fast"},
        Default = "Optimized",
        Flag = "ScaffoldPlace",
        Callback = function(self, value)
            ScaffoldData.Settings.Place = value
        end
    })
    ScaffoldData.Toggle.Functions.Settings.Dropdown({
        Name = "Corner",
        Description = "Mode to detect the closest corner",
        Options = {"Clamp", "Projection", "Axis"},
        Default = "Clamp",
        Flag = "ScaffoldCorner",
        Callback = function(self, value)
            ScaffoldData.Settings.Corner = value
        end
    })
    ScaffoldData.Toggle.Functions.Settings.Dropdown({
        Name = "Build",
        Description = "Mode to build around the corner",
        Options = {"Radius", "Square", "Optimized"},
        Default = "Radius",
        Flag = "ScaffoldBuild",
        Callback = function(self, value)
            ScaffoldData.Settings.Build = value
        end
    })
    ScaffoldData.Toggle.Functions.Settings.Dropdown({
        Name = "Offset",
        Description = "Mode to get the offsets",
        Options = {"Mathematical", "Direct"},
        Default = "Mathematical",
        Flag = "ScaffoldOffset",
        Callback = function(self, value)
            table.clear(ScaffoldData.Misc.Blocks)
            if value == "Mathematical" then
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
        Name = "Check",
        Description = "Mode to check the vector offsets",
        Options = {"Vector", "Store"},
        Default = "Vector",
        Flag = "ScaffoldVector",
        Callback = function(self, value)
            ScaffoldData.Settings.Vec = value
        end
    })
    ScaffoldData.Toggle.Functions.Settings.Dropdown({
        Name = "Position",
        Description = "Mode to get the blocks\" positions",
        Options = {"Store", "Count", "Size"},
        Default = "Store",
        Flag = "ScaffoldPosition",
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
                    if Options.PlacedByServer and v:GetAttribute("ServerPlaced") or not Options.PlacedByServer then
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
        },
        Delay = {}
    }

    ChestStealerData.Toggle = Tabs.World.Functions.NewModule({
        Name = "ChestStealer",
        Description = "Loots chests near you in skywars",
        Icon = "rbxassetid://86996272463051",
        Flag = "ChestStealer",
        Callback = function(self, callback)
            if callback then
                repeat
                    local Chest = GetNearestChest({Opened = true, PlacedByServer = true})
                    if Chest.Chest and ChestStealerData.Settings.Range >= Chest.Distance and (ChestStealerData.Delay[Chest.Chest] or 0) < tick() then
                        task.spawn(function()
                            ChestStealerData.Delay[Chest.Chest] = tick() + math.max(ChestStealerData.Settings.Delay, 2e-1)
                            for _, v in Chest.Chest.ChestFolderValue.Value:GetChildren() do
                                if v:IsA("Accessory") then
                                    task.wait(ChestStealerData.Settings.Delay)
                                    GameData.Modules.Remotes:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(Chest.Chest.ChestFolderValue.Value, v)
                                end
                            end
                            GameData.Modules.Remotes:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(nil)
                        end)
                    end
                    task.wait(ChestStealerData.Settings.Delay)
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
                "duck_spawn_egg",
                "unstable_portal",
                "smoke_bomb",
                "black_market_upgrade_3"
            }
        }
    }
    
    autoConsumeData.Toggle = Tabs.Utility.Functions.NewModule({
        Name = "AutoConsume",
        Description = "Automatically consumes items & potions",
        Icon = "rbxassetid://123628760864442",
        Flag = "AutoConsume",
        Callback = function(self, callback)
            if callback then
                repeat
                    for _, v in GetInventory().items do
                        if CanConsume(v.itemType) and (v.itemType == "pie" and not LP.Character:GetAttribute("SpeedPieBuff") or v.itemType ~= "pie") and not v.itemType:find("deploy") and not table.find(autoConsumeData.other.blacklists, v.itemType) then
                            if (v.itemType == "pie" or v.itemType:find("apple") and LP.Character.Humanoid.Health <= autoConsumeData.settings.health) or v.itemType ~= "pie" and not v.itemType:find("apple") then
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
        Description = "Instantly consume items",
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
        Description = "Time to consume an item",
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
        Description = "Health to be at to consume an apple",
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
    if Current ~= "" then
        for i,v in GameData.Modules.ArmorSets.BedwarsArmorChestPlates do
            if v == Current and GameData.Modules.ArmorSets.BedwarsArmorChestPlates[i + 1] then
                return GameData.Modules.ArmorSets.BedwarsArmorChestPlates[i + 1]
            end
        end
    else
        for i,v in GameData.Modules.ArmorSets.BedWarsArmor do
            if v[2] then
                return v[2]
            end
        end
    end
    return "leather_chestplate"
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
                                local ShopData = GameData.Modules.Shop.getShopItem(NextAmor)
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
                pcall(function()
                    repeat
                        local Shop = GetNearestShop("upgrade")
                        if Shop.Shop and AutoUpgradeData.Settings.Range >= Shop.Distance then
                            local TeamCrate = pcall(function() return GameData.Controllers.TeamCrate:getTeamCrate() end)
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
                end)
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
            Speed = 60,
            Timer = 1.5,
            Height = 8,
            NoStrafe = false,
            Cam = false,
            Disable = false,
            CombatCheck = false,
            WallCheck = false,
            Mode = "Velocity"
        },
        Connections = {}
    }

    LongJumpData.Toggle = Tabs.Movement.Functions.NewModule({
        Name = "LongJump",
        Description = "Makes you jump far, fast, using a fireball",
        Icon = "rbxassetid://94454897188777",
        Flag = "LongJump",
        Callback = function(self, callback)
            if callback then
                if not Functions.IsAlive() then
                    task.wait(0.3)
                    Functions.Notify("You can't use this while you're dead", 2.5)
                    self.Functions.Toggle(false, false, false, true, true)
                    return
                end

                SpeedData.Allowed, FlyData.Allowed = false, false

                local Fireball = GetItemType("fireball", false, false)
                if not Fireball or not Fireball.Item or not Fireball.Item.tool then
                    task.wait(0.3)
                    Functions.Notify("You need a fireball to use this", 2.5)
                    self.Functions.Toggle(false, false, false, true, true)
                    return
                end

                local RayParams = RaycastParams.new()
                RayParams.FilterType = Enum.RaycastFilterType.Include
                RayParams.FilterDescendantsInstances = CS:GetTagged("block")

                local Ground = WS:Raycast(LP.Character.HumanoidRootPart.Position, Vector3.new(0, -1000, 0), RayParams)
                if not Ground or (Ground and LP:DistanceFromCharacter(Ground.Position) > 5) then
                    task.wait(0.3)
                    Functions.Notify("You're not on ground, disabled LongJump", 2.5)
                    self.Functions.Toggle(false, false, false, true, true)
                    return
                end

                local CurrentItem = GetInventory().hand
                GameData.Remotes.Set:InvokeServer({hand = Fireball.Item.tool})

                local CanRun = false
                LongJumpData.Connections.Damage = GameData.Events.Damage.Event:Connect(function(Damage: {Player: Instance, DamageType: number})
                    if Damage.Player == LP.Character and Damage.DamageType == GameData.Modules.DamageType.TNT then
                        task.wait(0.1)
                        CanRun = true
                        LongJumpData.Connections.Damage:Disconnect()
                    end
                end)

                FireProjectile(Fireball.Item, LP.Character.PrimaryPart.Position - Vector3.new(0, 2, 0), Vector3.new(0, -40, 0))

                repeat task.wait() until CanRun

                if CurrentItem and CurrentItem.tool then
                    GameData.Remotes.Set:InvokeServer({hand = CurrentItem.tool})
                end

                local Velocity = LongJumpData.Settings.Height + 5
                local LookVector = LP.Character.PrimaryPart.CFrame.LookVector
                local StartTime = os.clock()
                local Boosted = false

                task.spawn(function()
                    repeat
                        task.wait()
                        Velocity -= 0.1
                        LP.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, Velocity, 0)
                    until not self.Data.Enabled
                end)

				LongJumpData.Connections.Heartbeat = RS.PreSimulation:Connect(function(DT)
                    if not self.Data.Enabled or (os.clock() - StartTime >= LongJumpData.Settings.Timer) or not Functions.IsAlive() then
                        if self.Data.Enabled then
                            self.Functions.Toggle(false, false, false, true, true)
                        end
                        return
                    end

                    if LongJumpData.Settings.Cam then
                        LookVector = Cam.CFrame.LookVector
                    end

                    local MoveDirection = LongJumpData.Settings.NoStrafe and LookVector or LP.Character.PrimaryPart.CFrame.LookVector
                    local Speed = LongJumpData.Settings.CombatCheck and KillAuraData.Attacking and (LongJumpData.Settings.Speed / 2) or LongJumpData.Settings.Speed

                    local RayParams = RaycastParams.new()
                    RayParams.FilterType = Enum.RaycastFilterType.Exclude
                    RayParams.FilterDescendantsInstances = {LP.Character}

                    local LJVelocity = function()
                        if LongJumpData.Settings.Mode == "Velocity" then
                            LP.Character.HumanoidRootPart.AssemblyLinearVelocity = (MoveDirection * (Speed + GetSpeedModifier(23))) + Vector3.new(0, LP.Character.HumanoidRootPart.AssemblyLinearVelocity.Y, 0)
                            if LP.Character.Humanoid.FloorMaterial == Enum.Material.Air then
                                if not Boosted then
                                    LP.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(LP.Character.HumanoidRootPart.AssemblyLinearVelocity.X, LongJumpData.Settings.Height + 5, LP.Character.HumanoidRootPart.AssemblyLinearVelocity.Z)
                                    Boosted = true
                                else
                                    LP.Character.HumanoidRootPart.AssemblyLinearVelocity += Vector3.new(0, DT * (WS.Gravity - (LongJumpData.Settings.Height + 14)), 0)
                                end
                            else
                                LP.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(LP.Character.HumanoidRootPart.AssemblyLinearVelocity.X, LongJumpData.Settings.Height + 5, LP.Character.HumanoidRootPart.AssemblyLinearVelocity.Z)
                            end
                        else
                            LP.Character.PrimaryPart.CFrame += MoveDirection * DT * Speed
                        end
                    end

                    local WallHit = WS:Raycast(LP.Character.PrimaryPart.Position, MoveDirection * (Speed * DT + 1), RayParams)
                    if LongJumpData.Settings.WallCheck then
                        if not WallHit then
                            LJVelocity()
                        end
                    else
                        LJVelocity()
                    end
				end)
            else
                for _, Connection in next, LongJumpData.Connections do
                    Connection:Disconnect()
                end
                table.clear(LongJumpData.Connections)

                FlyData.Allowed = true
                if not FlyData.Toggle.Data.Enabled then
                    SpeedData.Allowed = true
                end
                LP.Character.HumanoidRootPart.Anchored = false
            end
        end
    })

    LongJumpData.Toggle.Functions.Settings.Dropdown({
        Name = "Mode",
        Description = "Mode to boost your character's speed",
        Default = "Velocity",
        Options = {"Velocity", "CFrame"},
        Flag = "LongJumpMode",
        Callback = function(self, value)
            LongJumpData.Settings.Mode = value
        end
    })

    LongJumpData.Toggle.Functions.Settings.Slider({
        Name = "Speed",
        Description = "How fast to go",
        Min = 1,
        Max = 70,
        Default = 60,
        Flag = "LongJumpSpeed",
        Callback = function(self, Value)
            LongJumpData.Settings.Speed = Value
        end
    })

    LongJumpData.Toggle.Functions.Settings.Slider({
        Name = "Timer",
        Description = "How long you jump for",
        Min = 0.1,
        Max = 2,
        Default = 1.5,
        Decimals = 1,
        Flag = "LongJumpTimer",
        Callback = function(self, Value)
            LongJumpData.Settings.Timer = Value
        end
    })

    LongJumpData.Toggle.Functions.Settings.MiniToggle({
        Name = "Combat Check",
        Description = "Slows down when you're in combat",
        Flag = "LongJumpCombatCheck",
        Default = true,
        Callback = function(self, Value)
            LongJumpData.Settings.CombatCheck = Value
        end
    })

    LongJumpData.Toggle.Functions.Settings.MiniToggle({
        Name = "Wall Check",
        Description = "Slows down when you hit a wall",
        Flag = "LongJumpWallCheck",
        Default = true,
        Callback = function(self, Value)
            LongJumpData.Settings.WallCheck = Value
        end
    })

    LongJumpData.Toggle.Functions.Settings.MiniToggle({
        Name = "No Strafe",
        Description = "Disables strafing to prevent lagbacks",
        Flag = "LongJumpNoStrafe",
        Default = true,
        Callback = function(self, Value)
            LongJumpData.Settings.NoStrafe = Value
        end
    })

    LongJumpData.Toggle.Functions.Settings.MiniToggle({
        Name = "Camera Direction",
        Description = "Uses camera direction instead of strafe direction",
        Flag = "LongJumpCameraDirection",
        Callback = function(self, Value)
            LongJumpData.Settings.Cam = Value
        end
    })

    LongJumpData.Toggle.Functions.Settings.Slider({
        Name = "Height",
        Description = "Height to start at which slowly decreases",
        Min = 1,
        Max = 15,
        Default = 8,
        Flag = "LongJumpHeight",
        Callback = function(self, Value)
            LongJumpData.Settings.Height = Value
        end
    })
end)()

local GetNearestOrb = function()
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

local GetNearestSpirit = function()
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

local GetNearestMetal = function()
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
    
    AutoKit.Toggle = Tabs.Utility.Functions.NewModule({
        Name = "AutoKit",
        Description = "Automatically uses your kit's ability",
        Icon = "rbxassetid://126871982066452",
        Flag = "AutoKit",
        Callback = function(self, callback)
            if callback then
                repeat
                    if AutoKit.Settings.Kit == "Eldertree" then
                        local orb = GetNearestOrb()
                        if orb.orb and AutoKit.Settings.KitRanges.Eldertree >= orb.distance then
                            if GameData.Modules.Remotes:Get("ConsumeTreeOrb"):CallServer({treeOrbSecret = orb.orb:GetAttribute("TreeOrbSecret")}) then
                                orb.orb:Destroy()
                                GameData.Modules.Animation:playAnimation(LP, GameData.Modules.AnimationTypes.PUNCH)
                                GameData.Controllers.ViewModel:playAnimation(GameData.Modules.AnimationTypes.FP_USE_ITEM)
                            end
                        end
                    elseif AutoKit.Settings.Kit == "Evelynn" then
                        local spirit = GetNearestSpirit()
                        if spirit.spirit then
                            GameData.Controllers.SpiritAssasin:useSpirit(LP, spirit.spirit)
                        end
                    elseif AutoKit.Settings.Kit == "MetalDetector" then
                        local metal = GetNearestMetal()
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
    
    AutoKit.Toggle.Functions.Settings.Dropdown({
        Name = "Kit",
        Description = "What kit to use",
        Default = "Eldertree",
        Options = {"Eldertree", "Evelynn", "MetalDetector"},
        Flag = "AutoKitKit",
        Callback = function(self, value)
            AutoKit.Settings.Kit = value
            for i, v in AutoKit.Settings.KitRanges do
                task.spawn(function()
                    repeat task.wait() until AutoKit.Toggle.Settings[i.."AutoKitRange"].Functions
                    AutoKit.Toggle.Settings[i.."AutoKitRange"].Functions.SetVisiblity(value == i)
                end)
            end
        end
    })
    
    AutoKit.Toggle.Functions.Settings.Slider({
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
    
    AutoKit.Toggle.Functions.Settings.Slider({
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
end)();

(function()
    local NoSlow = {
        Settings = {
            Speed = false,
            Allow = false
        },
        Old = nil
    }

    NoSlow.Toggle = Tabs.Movement.Functions.NewModule({
        Name = "NoSlow",
        Description = "Prevents items from slowing you down",
        Icon = "rbxassetid://89310006048659",
        Flag = "NoSlow",
        Callback = function(self, callback)
            local modifier = GameData.Controllers.Sprint:getMovementStatusModifier()
            if callback and hookfunction then
                NoSlow.Old = hookfunction(modifier.addModifier, function(self, tab)
                    if tab.moveSpeedMultiplier and tab.blockSprint then
                        tab.moveSpeedMultiplier = NoSlow.Settings.Speed and 1 or 0.35
                        tab.blockSprint = not NoSlow.Settings.Allow
                    end
                    return NoSlow.Old(self, tab)
                end)
            else
                if NoSlow.Old and hookfunction then
                    hookfunction(modifier.addModifier, NoSlow.Old)
                    NoSlow.Old = nil
                end
            end
        end
    })

    NoSlow.Toggle.Functions.Settings.MiniToggle({
        Name = "Speed",
        Description = "Modifies the speed multiplier",
        Default = true,
        Flag = "NoSlowSpeed",
        Callback = function(self, callback)
            NoSlow.Settings.Speed = callback
        end
    })

    NoSlow.Toggle.Functions.Settings.MiniToggle({
        Name = "Allow Sprint",
        Description = "Allows sprinting while holding items",
        Default = true,
        Flag = "NoSlowAllowSprint",
        Callback = function(self, callback)
            NoSlow.Settings.Allow = callback
        end
    })
end)();

(function()
    local BanShield = {
        Settings = {Mode = "Hook"},
        Hook = nil,
        Old = nil
    }

    BanShield.Toggle = Tabs.Utility.Functions.NewModule({
        Name = "BanShield",
        Description = "Protects you against some remotes & detections",
        Icon = "rbxassetid://109973937066813",
        Flag = "BanShield",
        Callback = function(self, callback)
            if callback then
                if BanShield.Settings.Mode == "Hook" then
                    if not BanShield.Hook then
                        BanShield.Hook = hookmetamethod(game, "__namecall", function(self, ...)
                            if table.find({"reportPerformanceMetrics", "AnalyticsReportEvent"}, self.Name) and self.Data.Enabled then
                                return
                            end
                            return BanShield.Hook(self, ...)
                        end)
                    end
                else
                    local BanShieldRaw: table = getrawmetatable(game)
                    setreadonly(BanShieldRaw, false)

                    local OldBanShield = BanShieldRaw.__namecall
                    BanShieldRaw.__namecall = newcclosure(function(self, ...)
                        local Method: string = getnamecallmethod()
                        local Args: {any} = {...}

                        if (Method == "FireServer" or Method == "InvokeServer" or Method == "FireClient" or Method == "InvokeClient") and self.Data.Enabled then
                            local Name: string = self.Name
                            local TargetMethods: {[string]: boolean} = {
                                reportPerformanceMetrics = true,
                                AnalyticsReportEvent = true
                            }

                            local success, data = pcall(function()
                                return self.Data and self.Data.Enabled
                            end)

                            if TargetMethods[Name] and success and data then
                                return
                            end
                        end

                        return OldBanShield(self, unpack(Args))
                    end)

                    setreadonly(BanShieldRaw, true)
                end

                BanShield.Old = GameData.Modules.Remotes.Get
                GameData.Modules.Remotes.Get = function(kanye, item: string, ...)
                    if item:lower():find("detection") then
                        return {SendToServer = function() end}
                    end
                    return BanShield.Old(kanye, item, ...)
                end
            else
                GameData.Modules.Remotes.Get = BanShield.Old
            end
        end
    })
    BanShield.Toggle.Functions.Settings.Dropdown({
        Name = "Mode",
        Description = "Mode to block remotes",
        Default = "Hook",
        Options = {"Hook", "Raw"},
        Flag = "BanShieldMode",
        Callback = function(self, value)
            BanShield.Settings.Mode = value
        end
    })
end)()

local AntiHit = {
    Settings = {
        Range = 23,
        Height = 100,
        Up = 0.25,
        Down = 0.1,
        Trans = 0,
        UpModifier = 0.5,
        DownModifier = 0.5,
        Material = "Snow",
        Dynamic = false,
        Color = {R = 250, G = 250, B = 250}
    },
    Clone = nil,
    Connect = nil
}

local DestroyClone = function()
    if AntiHit.Connect then
        AntiHit.Connect:Disconnect()
        AntiHit.Connect = nil
    end

    if AntiHit.Clone and AntiHit.Clone.Parent then
        AntiHit.Clone:Destroy()
        AntiHit.Clone = nil
    end

    Cam.CameraSubject = LP.Character.Humanoid
end

(function()
    AntiHit.Toggle = Tabs.Player.Functions.NewModule({
        Name = "AntiHit",
        Description = "Makes it harder for others to hit you",
        Icon = "rbxassetid://80691470589875",
        Flag = "AntiHit",
        Callback = function(self, callback)
            if callback then
                repeat task.wait() until GetMatchState() ~= 0

                repeat
                    AntiHit.Clone = nil
                    AntiHit.Connect = nil

                    local target = GetNearestEntity()
                    if target.Entity and target.Distance <= AntiHit.Settings.Range and Functions.IsAlive() then
                        DestroyClone()

                        LP.Character.Archivable = true
                        AntiHit.Clone = LP.Character:Clone()
                        AntiHit.Clone.Parent = WS
                        Cam.CameraSubject = AntiHit.Clone.Humanoid
                
                        for _, v in next, AntiHit.Clone:GetChildren() do
                            if v:IsA("Accessory") then
                                v.Handle.Transparency = 1
                            elseif string.lower(v.ClassName):find("part") then
                                v.Transparency = v.Name == "HumanoidRootPart" and AntiHit.Settings.Trans or 1
                
                                if v.Name == "HumanoidRootPart" then
                                    v.Material = Enum.Material[AntiHit.Settings.Material]
                                    v.Color = Color3.fromRGB(AntiHit.Settings.Color.R, AntiHit.Settings.Color.G, AntiHit.Settings.Color.B)
                                end
                
                                if v.Name == "Head" then
                                    v:ClearAllChildren()
                                end
                            end
                        end
                
                        local root = LP.Character.HumanoidRootPart
                        local cloneRoot = AntiHit.Clone.HumanoidRootPart
                        root.CFrame += Vector3.new(0, AntiHit.Settings.Height, 0)
                
                        AntiHit.Connect = RS.Heartbeat:Connect(function()
                            if cloneRoot then
                                cloneRoot.Position = Vector3.new(root.Position.X, cloneRoot.Position.Y, root.Position.Z)
                            else
                                DestroyClone()
                            end
                        end)

                        local Health = LP.Character.Humanoid.Health or 100
                        local TargetHealth = target.EntityData and target.EntityData.Health or 100

                        local GoUp = AntiHit.Settings.Up
                        local GoDown = AntiHit.Settings.Down

                        if AntiHit.Settings.Dynamic then
                            local diff: number = Health - TargetHealth
                            if math.abs(diff) <= 5 then
                                GoUp = AntiHit.Settings.Up
                                GoDown = AntiHit.Settings.Down
                            else
                                if diff > 0 then
                                    GoDown = AntiHit.Settings.Down + 0.2
                                    GoUp = math.max(AntiHit.Settings.Up - 0.1, 0.1)
                                else
                                    GoDown = math.max(AntiHit.Settings.Down - 0.1, 0.1)
                                    GoUp = math.max(AntiHit.Settings.Up + 0.2, 0.3)
                                end
                            end
                        end
                        
                        task.wait(GoUp)
                        root.CFrame = cloneRoot.CFrame
                        DestroyClone()

                        task.wait(GoDown + 0.05)
                    elseif not Functions.IsAlive() then
                        repeat task.wait() until Functions.IsAlive()
                        task.wait(0.4)
                    end

                    task.wait()
                until not self.Data.Enabled
            else
                DestroyClone()
            end
        end
    })

    AntiHit.Toggle.Functions.Settings.Slider({
        Name = "Range",
        Description = "Range to detect the player",
        Min = 1,
        Max = 18,
        Default = 18,
        Flag = "AntiHitRange",
        Callback = function(self, value)
            AntiHit.Settings.Range = value
        end
    })

    local AntiHitUp, AntiHitDown
    AntiHit.Toggle.Functions.Settings.MiniToggle({
        Name = "Dynamic",
        Description = "Adjust time based on health difference",
        Default = true,
        Flag = "AntiHitDynamic",
        Callback = function(self, value)
            AntiHit.Settings.Dynamic = value
            task.spawn(function()
                repeat task.wait() until AntiHitUp and AntiHitDown
                AntiHitUp.Functions.SetVisiblity(value)
                AntiHitDown.Functions.SetVisiblity(value)
            end)
        end
    })

    AntiHitUp = AntiHit.Toggle.Functions.Settings.Slider({
        Name = "Up Modifier",
        Description = "Adjusts how much more/less time you stay up based on health difference",
        Min = 0,
        Max = 2,
        Default = 0.5,
        Decimals = 2,
        Hide = true,
        Flag = "AntiHitUpModifier",
        Callback = function(self, value)
            AntiHit.Settings.UpModifier = value
        end
    })
    
    AntiHitDown = AntiHit.Toggle.Functions.Settings.Slider({
        Name = "Down Modifier",
        Description = "Adjusts how much more/less time you stay down based on health difference",
        Min = 0,
        Max = 2,
        Default = 0.5,
        Decimals = 2,
        Hide = true,
        Flag = "AntiHitDownModifier",
        Callback = function(self, value)
            AntiHit.Settings.DownModifier = value
        end
    })

    AntiHit.Toggle.Functions.Settings.Slider({
        Name = "Height",
        Description = "Height to teleport up",
        Min = -100,
        Max = 200,
        Default = 100,
        Flag = "AntiHitHeight",
        Callback = function(self, value)
            AntiHit.Settings.Height = value
        end
    })

    AntiHit.Toggle.Functions.Settings.Slider({
        Name = "Stay Up",
        Description = "Time to stay up",
        Min = 0.1,
        Max = 0.5,
        Default = 0.2,
        Decimals = 1,
        Flag = "AntiHitStayUp",
        Callback = function(self, value)
            AntiHit.Settings.Up = value
        end
    })

    AntiHit.Toggle.Functions.Settings.Slider({
        Name = "Stay Down",
        Description = "Time to stay down",
        Min = 0.1,
        Max = 0.5,
        Default = 0.1,
        Decimals = 1,
        Flag = "AntiHitStayDown",
        Callback = function(self, value)
            AntiHit.Settings.Down = value
        end
    })

    AntiHit.Toggle.Functions.Settings.Slider({
        Name = "Transparency",
        Description = "Transparency of the clone part",
        Min = 0,
        Max = 1,
        Default = 0,
        Decimals = 1,
        Flag = "AntiHitTrans",
        Callback = function(self, value)
            AntiHit.Settings.Trans = value
        end
    })

    AntiHit.Toggle.Functions.Settings.Dropdown({
        Name = "Material",
        Description = "Material of the clone part",
        Default = "Snow",
        Options = Materials,
        Flag = "AntiHitMaterial",
        Callback = function(self, value)
            AntiHit.Settings.Material = value
        end
    })
    
    AntiHit.Toggle.Functions.Settings.TextBox({
        Name = "Color",
        Description = "Color to highlight the player",
        Default = "250, 250, 250",
        Flag = "AntiHitColor",
        Callback = function(self, callback)
            local color = GetColor(callback)
            if color then
                AntiHit.Settings.Color = color
            end
        end
    })
end)()

local Phase = {
    Settings = {
        Blocks = 10,
        Delay = 0
    },
    Enabled = false,
    Connect = nil,
    Delay = tick()
}

local PhaseRay, BlockRay = RaycastParams.new(), RaycastParams.new()
PhaseRay.RespectCanCollide, BlockRay.FilterType = true, Enum.RaycastFilterType.Include
PhaseRay.FilterType = Enum.RaycastFilterType.Include

local Blocks = CS:GetTagged("block")
BlockRay.FilterDescendantsInstances = Blocks

local StoreBlock = function(block, action)
    if action == "add" then
        table.insert(Blocks, block)
    elseif action == "remove" then
        local idx = table.find(Blocks, block)
        if idx then table.remove(Blocks, idx) end
    end
    BlockRay.FilterDescendantsInstances = Blocks
end

CS:GetInstanceAddedSignal("block"):Connect(function(v) StoreBlock(v, "add") end)
CS:GetInstanceRemovedSignal("block"):Connect(function(v) StoreBlock(v, "remove") end)
PhaseRay.FilterDescendantsInstances = {Blocks, WS:FindFirstChild("SpectatorPlatform"), CS:GetTagged("spawn-cage")}

local PhaseOver = OverlapParams.new()
PhaseOver.RespectCanCollide = true

local GetPoint = function(point)
    PhaseOver.AddToFilter(PhaseOver, {LP.Character, Cam})
    local parts = WS:GetPartBoundsInBox(CFrame.new(point), Vector3.new(1, 2, 1), PhaseOver)
    return #parts == 0
end

local GetPhaseRay = function()
    return WS:Raycast(LP.Character.Head.Position, LP.Character.Humanoid.MoveDirection * 12e-1, PhaseRay)
end

local GetPhaseDir = function(ray)
    return (ray.Normal.Z ~= 0 or not ray.Instance:GetAttribute("GreedyBlock")) and "Z" or "X"
end

local IsRay = function(ray)
    return ray.Instance.Size[GetPhaseDir(ray)] <= Phase.Settings.Blocks and ray.Instance.CanCollide and ray.Normal.Y == 0
end

local CalcPhase = function(ray)
    return LP.Character.HumanoidRootPart.CFrame + ray.Normal * (-(ray.Instance.Size[GetPhaseDir(ray)]) - LP.Character.HumanoidRootPart.Size.X / 15e-1)
end

local MainPhase = function(dest)
    if GetPoint(dest.Position) then
        Phase.Delay = tick() + Phase.Settings.Delay
        LP.Character.HumanoidRootPart.CFrame = dest
    end
end

(function()
    Phase.Toggle = Tabs.Movement.Functions.NewModule({
        Name = "Phase",
        Description = "Allows you to walk through walls",
        Icon = "rbxassetid://77429376996366",
        Flag = "Phase",
        Callback = function(self, callback)
            Phase.Enabled = callback
            if callback then
                Phase.Connect = RS.Heartbeat:Connect(function()
                    if Functions.IsAlive() and LP.Character.Humanoid.MoveDirection ~= Vector3.zero and UIS:IsKeyDown(Enum.KeyCode.LeftShift) and tick() >= Phase.Delay and self.Data.Enabled then
                        local Wall = GetPhaseRay()
                        if Wall and IsRay(Wall) then
                            MainPhase(CalcPhase(Wall))
                        end
                    end
                end)
            else
                if Phase.Connect then
                    Phase.Connect:Disconnect()
                    Phase.Connect = nil
                end
            end
        end
    })

    Phase.Toggle.Functions.Settings.Slider({
        Name = "Blocks",
        Description = "Amount of blocks to phase through",
        Min = 3,
        Max = 10,
        Default = 10,
        Flag = "PhaseBlocks",
        Callback = function(self, value)
            Phase.Settings.Blocks = value
        end
    })

    Phase.Toggle.Functions.Settings.Slider({
        Name = "Delay",
        Description = "Time to delay the phasing process",
        Min = 0,
        Max = 1,
        Default = 0,
        Decimals = 1,
        Flag = "PhaseDelay",
        Callback = function(self, value)
            Phase.Settings.Delay = value
        end
    })
end)()

local SpiderData = {
    Settings = {
        Speed = 50,
        Dist = 2,
        AntiSuff = false,
        Mode = "Smooth"
    },
    Ray = nil
}

local SpiderRay = RaycastParams.new()
SpiderRay.RespectCanCollide = true
SpiderRay:AddToFilter({LP.Character, Cam})

local AntiSuff = function(bool, ray)
    if bool and SpiderData.Settings.AntiSuff and not ray then
        local hrp = LP.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
        SpiderRay.CollisionGroup = hrp.CollisionGroup
    end
end

local Spider = function(bool, ray, dt)
    if bool and ray and ray.Normal.Y == 0 and not (UIS:IsKeyDown(Enum.KeyCode.LeftShift) and Phase.Enabled) then
        local hrp = LP.Character.HumanoidRootPart
        if SpiderData.Settings.Mode == "Smooth" then
            hrp.Velocity = Vector3.new(0, SpiderData.Settings.Speed, 0)
        else
            hrp.CFrame += Vector3.new(0, SpiderData.Settings.Speed * dt, 0)
        end
    end
end

(function()
    SpiderData.Toggle = Tabs.Movement.Functions.NewModule({
        Name = "Spider",
        Description = "Allows you to climb walls",
        Icon = "rbxassetid://112116747329423",
        Flag = "Spider",
        Callback = function(self, callback)
            if callback then
                SpiderData.Connect = RS.PreSimulation:Connect(function(delta)
                    if Functions.IsAlive() then
                        local ray = WS:Raycast(
                            LP.Character.HumanoidRootPart.Position - Vector3.new(0, LP.Character.Humanoid.HipHeight - 0.5, 0),
                            LP.Character.Humanoid.MoveDirection * (SpiderData.Settings.Dist + 0.5),
                            SpiderRay
                        )
                        Spider(SpiderData.Ray, ray, delta)
                        SpiderData.Ray = ray
                        AntiSuff(SpiderData.Ray, ray)
                    end
                end)
            else
                if SpiderData.Connect then
                    SpiderData.Connect:Disconnect()
                    SpiderData.Connect = nil
                end
            end
        end
    })

    SpiderData.Toggle.Functions.Settings.Dropdown({
        Name = "Mode",
        Description = "Mode to climb walls",
        Default = "Smooth",
        Options = {"Smooth", "Teleport"},
        Flag = "SpiderMode",
        Callback = function(self, value)
            SpiderData.Settings.Mode = value
        end
    })

    SpiderData.Toggle.Functions.Settings.Slider({
        Name = "Speed",
        Description = "How fast to climb walls",
        Min = 10,
        Max = 100,
        Default = 50,
        Flag = "SpiderSpeed",
        Callback = function(self, value)
            SpiderData.Settings.Speed = value
        end
    })

    SpiderData.Toggle.Functions.Settings.Slider({
        Name = "Distance",
        Description = "Distance to check for the walls",
        Min = 1,
        Max = 3,
        Default = 2,
        Decimals = 1,
        Flag = "SpiderDistance",
        Callback = function(self, value)
            SpiderData.Settings.Dist = value
        end
    })

    SpiderData.Toggle.Functions.Settings.MiniToggle({
        Name = "Anti Suffocation",
        Description = "Prevents suffocation by climbing at a safe distance",
        Flag = "SpiderAntiSuffocation",
        Default = true,
        Callback = function(self, value)
            SpiderData.Settings.AntiSuff = value
        end
    })
end)();

(function()
    local ChestESP = {
        Settings = {
            Items = {"emerald", "speed"},
            Color = {R = 0, G = 0, B = 0},
            Trans = 0.5,
            Corner = 6
        },
        Connect = {}
    }

    local ChestESPFolder: Folder = Instance.new("Folder", PG)
    ChestESPFolder.Name = "ChestESP"

    local MainESP = function(v)
        local chest = v:FindFirstChild("ChestFolderValue") and v.ChestFolderValue.Value
        if not chest then return end

        local billboard = Instance.new("BillboardGui", ChestESPFolder)
        billboard.Name, billboard.Adornee = "ChestESP", v
        billboard.StudsOffsetWorldSpace, billboard.Size = Vector3.new(0, 5, 0), UDim2.fromOffset(35, 35)
        billboard.AlwaysOnTop, billboard.ClipsDescendants = true, false

        local frame = Instance.new("Frame", billboard)
        frame.Size = UDim2.fromScale(1, 1)
        frame.BackgroundColor3, frame.BackgroundTransparency = Color3.fromRGB(ChestESP.Settings.Color.R, ChestESP.Settings.Color.G, ChestESP.Settings.Color.B), ChestESP.Settings.Trans
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, ChestESP.Settings.Corner)

        local layout = Instance.new("UIListLayout", frame)
        layout.FillDirection, layout.Padding = Enum.FillDirection.Vertical, UDim.new(0, 5)
        layout.VerticalAlignment, layout.HorizontalAlignment = Enum.VerticalAlignment.Center, Enum.HorizontalAlignment.Center
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            local width = layout.AbsoluteContentSize.X + 5
            if width < 35 then
                width = 35
            end
            billboard.Size = UDim2.fromOffset(width, layout.AbsoluteContentSize.Y + 5)
        end)

        local Update = function()
            local val = billboard.Adornee:FindFirstChild("ChestFolderValue") and billboard.Adornee.ChestFolderValue.Value:GetChildren()
            if not val then billboard.Enabled = false; return end

            for _, v in billboard.Frame:GetChildren() do
                if v:IsA("ImageLabel") then v:Destroy() end
            end
            billboard.Enabled = false

            local found = {}
            for _, item in val do
                local name, match = item.Name, nil
                for _, v in next, ChestESP.Settings.Items do
                    if string.find(string.lower(name), string.lower(v)) then
                        match = v
                        break
                    end
                end
                
                if not found[name] and (match or table.find(ChestESP.Settings.Items, name)) then
                    found[name], billboard.Enabled = true, true
                    local new = Instance.new("ImageLabel", billboard.Frame)
                    new.Size, new.BackgroundTransparency, new.Image = UDim2.fromOffset(27, 27), 1, GameData.Modules.ItemMeta[name].image
                end
            end
        end

        for _, v in {chest.ChildAdded, chest.ChildRemoved} do
            table.insert(ChestESP.Connect, v:Connect(function(item)
                for _, v in next, ChestESP.Settings.Items do
                    if string.find(string.lower(item.Name), string.lower(v)) then
                        Update()
                        return
                    end
                end
            end))
        end
        task.spawn(Update)
    end

    ChestESP.Toggle = Tabs.Render.Functions.NewModule({
        Name = "ChestESP",
        Description = "Shows chests that contain important items",
        Icon = "rbxassetid://134858697735956",
        Flag = "ChestESP",
        Callback = function(self, callback)
            if callback then
                table.insert(ChestESP.Connect, CS:GetInstanceAddedSignal("chest"):Connect(MainESP))
                for _, v in CS:GetTagged("chest") do
                    task.spawn(function()
                        MainESP(v)
                    end)
                end
            else
                for _, v in ChestESP.Connect do v:Disconnect() end
                ChestESP.Connect = {}
                for _, v in ChestESPFolder:GetChildren() do v:Destroy() end
            end
        end
    })

    ChestESP.Toggle.Functions.Settings.TextBox({
        Name = "Items",
        Description = "Items to show (separated by commas and space)",
        Default = "emerald, speed",
        Flag = "ChestESPItems",
        Callback = function(self, callback)
            local items = {}
            for item in string.gmatch(callback, "([^,]+)") do
                table.insert(items, item:match("^%s*(.-)%s*$"))
            end
            ChestESP.Settings.Items = items
        end
    })

    ChestESP.Toggle.Functions.Settings.TextBox({
        Name = "Color",
        Description = "Color of the background",
        Default = "250, 250, 250",
        Flag = "ChestESPColor",
        Callback = function(self, callback)
            local color = GetColor(callback)
            if color then
                ChestESP.Settings.Color = color
            end
        end
    })

    ChestESP.Toggle.Functions.Settings.Slider({
        Name = "Transparency",
        Description = "Transparency of the background",
        Min = 0,
        Max = 1,
        Default = 0.5,
        Decimals = 1,
        Flag = "ChestESPTransparency",
        Callback = function(self, value)
            ChestESP.Settings.Trans = value
        end
    })

    ChestESP.Toggle.Functions.Settings.Slider({
        Name = "Corner Radius",
        Description = "Corner radius of the background",
        Min = 0,
        Max = 10,
        Default = 6,
        Decimals = 0,
        Flag = "ChestESPCornerRadius",
        Callback = function(self, value)
            ChestESP.Settings.Corner = value
        end
    })
end)()

local Aim = function(start, speed, gravity, pos, velo, prediction, height, params)
    local eps = 1/1000000000
    local getVal = function(d) return math.abs(d) < eps end
    local getNrRoot = function(x) return x^(1/3) * (x < 0 and -1 or 1) end

    local getPrediction = function(a, b, c)
        local half_b, constant = b / (2 * a), c / a
        local discriminant = half_b * half_b - constant

        if getVal(discriminant) then
            return -half_b
        elseif discriminant > 0 then
            local sqrt_discriminant = math.sqrt(discriminant)
            return sqrt_discriminant - half_b, -sqrt_discriminant - half_b
        end
        return 0
    end

    local getSqrt = function(a, b, c, d)
        local root0, root1, root2
        local numRoots, sub
        local A, B, C = b / a, c / a, d / a
        local sqA = A * A
        local p, q = (1/3) * (-(1/3) * sqA + B), 0.5 * ((2/27) * A * sqA - (1/3) * A * B + C)
        local cbP = p * p * p
        local discriminant = q * q + cbP

        if getVal(discriminant) then
            if getVal(q) then
                root0, numRoots = 0, 1
            else
                local u = getNrRoot(-q)
                root0, root1, numRoots = 2 * u, -u, 2
            end
        elseif discriminant < 0 then
            local phi = (1/3) * math.acos(-q / math.sqrt(-cbP))
            local t = 2 * math.sqrt(-p)
            root0, root1, root2 = t * math.cos(phi), -t * math.cos(phi + math.pi/3), -t * math.cos(phi - math.pi/3)
            numRoots = 3
        else
            local sqrtDiscriminant = math.sqrt(discriminant)
            local u, v = getNrRoot(sqrtDiscriminant - q), -getNrRoot(sqrtDiscriminant + q)
            root0, numRoots = u + v, 1
        end

        sub = (1/3) * A
        if numRoots > 0 then root0 = root0 - sub end
        if numRoots > 1 then root1 = root1 - sub end
        if numRoots > 2 then root2 = root2 - sub end

        return root0, root1, root2
    end

    local getNewPred = function(a, b, c, d, e)
        local root0, root1, root2, root3
        local coeffs = {}
        local z, u, v, sub
        local A, B, C, D = b / a, c / a, d / a, e / a
        local sqA = A * A
        local p, q, r = -0.375 * sqA + B, 0.125 * sqA * A - 0.5 * A * B + C, -(3/256) * sqA * sqA + 0.0625 * sqA * B - 0.25 * A * C + D
        local numRoots

        if getVal(r) then
            coeffs[3], coeffs[2], coeffs[1], coeffs[0] = q, p, 0, 1
            local results = {getSqrt(coeffs[0], coeffs[1], coeffs[2], coeffs[3])}
            numRoots = #results
            root0, root1, root2 = results[1], results[2], results[3]
        else
            coeffs[3], coeffs[2], coeffs[1], coeffs[0] = 0.5 * r * p - 0.125 * q * q, -r, -0.5 * p, 1
            root0, root1, root2 = getSqrt(coeffs[0], coeffs[1], coeffs[2], coeffs[3])
            z = root0

            u, v = z * z - r, 2 * z - p
            u = getVal(u) and 0 or (u > 0 and math.sqrt(u) or nil)
            v = getVal(v) and 0 or (v > 0 and math.sqrt(v) or nil)
            if not u or not v then return end

            coeffs[2], coeffs[1], coeffs[0] = z - u, q < 0 and -v or v, 1
            local results = {getPrediction(coeffs[0], coeffs[1], coeffs[2])}
            numRoots = #results
            root0, root1 = results[1], results[2]

            coeffs[2], coeffs[1], coeffs[0] = z + u, q < 0 and v or -v, 1
            if numRoots < 4 then
                local results1 = {getPrediction(coeffs[0], coeffs[1], coeffs[2])}
                if numRoots == 0 then
                    root0, root1 = results1[1], results1[2]
                elseif numRoots == 1 then
                    root1, root2 = results1[1], results1[2]
                elseif numRoots == 2 then
                    root2, root3 = results1[1], results1[2]
                end
                numRoots = numRoots + #results1
            end
        end

        sub = 0.25 * A
        if numRoots > 0 then root0 = root0 - sub end
        if numRoots > 1 then root1 = root1 - sub end
        if numRoots > 2 then root2 = root2 - sub end
        if numRoots > 3 then root3 = root3 - sub end

        return {root3, root2, root1, root0}
    end

    local displacement = pos - start
    local velX, velY, velZ = velo.X, velo.Y, velo.Z
    local dispX, dispY, dispZ = displacement.X, displacement.Y, displacement.Z
    local halfGravity = -0.5 * gravity

    if math.abs(velY) > 0.01 and prediction and prediction > 0 then
        local estTime = displacement.Magnitude / speed
        for _ = 1, 100 do
            velY = velY - (0.5 * prediction) * estTime
            local velocity = velo * 0.016
            local ray = WS.Raycast(WS, Vector3.new(pos.X, pos.Y, pos.Z), Vector3.new(velocity.X, (velY * estTime) - height, velocity.Z), params)
            if ray then
                local newTarget = ray.Position + Vector3.new(0, height, 0)
                estTime = estTime - math.sqrt(((pos - newTarget).Magnitude * 2) / prediction)
                pos = newTarget
                dispY = (pos - start).Y
                velY = 0
                break
            else
                break
            end
        end
    end

    local solutions = getNewPred(
        halfGravity * halfGravity,
        -2 * velY * halfGravity,
        velY * velY - 2 * dispY * halfGravity - speed * speed + velX * velX + velZ * velZ,
        2 * dispY * velY + 2 * dispX * velX + 2 * dispZ * velZ,
        dispY * dispY + dispX * dispX + dispZ * dispZ
    )

    if solutions then
        local posRoots = {}
        for _, v in next, solutions do
            if v > 0 then
                table.insert(posRoots, v)
            end
        end
        if posRoots[1] then
            local t = posRoots[1]
            local d = (dispX + velX * t) / t
            local e = (dispY + velY * t - halfGravity * t * t) / t
            local f = (dispZ + velZ * t) / t
            return start + Vector3.new(d, e, f)
        end
        return 0
    elseif gravity == 0 then
        local t = displacement.Magnitude / speed
        local d = (dispX + velX * t) / t
        local e = (dispY + velY * t - halfGravity * t * t) / t
        local f = (dispZ + velZ * t) / t
        return start + Vector3.new(d, e, f)
    end
    return 0
end

(function()
    local ProjectileAimbot = {
        Settings = {
            Visibility = 0,
            Size = 90,
            Thickness = 2,
            Filled = false,
            Other = false,
            Color = {R = 255, G = 0, B = 0}
        },
        Circle = nil,
        Old = nil
    }

    ProjectileAimbot.Toggle = Tabs.Combat.Functions.NewModule({
        Name = "ProjectileAimbot",
        Description = "Silently adjusts your aim towards the enemy",
        Icon = "rbxassetid://78975297266093",
        Flag = "ProjectileAimbot",
        Callback = function(self, callback)
            if callback then
                task.spawn(function()
                    repeat 
                        if Drawing then
                            local vec = Vector2.new(0, 0)
                            if LP:GetMouse() and Cam then
                                local pos = Cam:WorldToScreenPoint(LP:GetMouse().Hit.Position)
                                if pos then
                                    vec = Vector2.new(pos.X, pos.Y + (ProjectileAimbot.Settings.Size / 2))
                                end
                            end

                            if not ProjectileAimbot.Circle then
                                ProjectileAimbot.Circle = Drawing.new("Circle")
                            else
                                ProjectileAimbot.Circle.Radius = ProjectileAimbot.Settings.Size
                                ProjectileAimbot.Circle.Color = Color3.fromRGB(ProjectileAimbot.Settings.Color.R, ProjectileAimbot.Settings.Color.G, ProjectileAimbot.Settings.Color.B)
                                ProjectileAimbot.Circle.Filled = ProjectileAimbot.Settings.Filled
                                ProjectileAimbot.Circle.Thickness = ProjectileAimbot.Settings.Thickness
                                ProjectileAimbot.Circle.Transparency = ProjectileAimbot.Settings.Visibility
                                ProjectileAimbot.Circle.Visible = true
                                ProjectileAimbot.Circle.Position = vec
                            end
                        end
                        task.wait()
                    until not self.Data.Enabled
                end)

                ProjectileAimbot.Old = GameData.Modules.Projectile.calculateImportantLaunchValues
                GameData.Modules.Projectile.calculateImportantLaunchValues = function(proj, data, line, start, pos)
                    local launch = pos or proj:getLaunchPosition(start)

                    for _, player in next, Plrs:GetPlayers() do
                        if Functions.IsAlive(player) and Functions.IsAlive() and player.Team ~= LP.Team then
                            local screenPos, onScreen = Cam:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
                            if onScreen and (ProjectileAimbot.Circle.Position - Vector2.new(screenPos.X, screenPos.Y)).Magnitude <= (ProjectileAimbot.Settings.Size + 25) then
                                local calc = Aim(CFrame.new(launch + data.fromPositionOffset, player.Character.HumanoidRootPart.Position).Position, data:getProjectileMeta().launchVelocity, data:getProjectileMeta().gravitationalAcceleration * data.gravityMultiplier, player.Character.HumanoidRootPart.Position, player.Character.HumanoidRootPart.Velocity, WS.Gravity * (player.Character:GetAttribute("InflatedBalloons") and 0.3 or 1), player.Character.Humanoid.HipHeight, GroundRay)

                                if (not ProjectileAimbot.Settings.Other and not data.projectile:find("arrow")) or not launch or not calc then
                                    return ProjectileAimbot.Old(proj, data, line, start, pos)
                                end
                                
                                return {initialVelocity = CFrame.new(launch, calc).LookVector * data:getProjectileMeta().launchVelocity, positionFrom = launch + data.fromPositionOffset, deltaT = data:getProjectileMeta().predictionLifetimeSec or data:getProjectileMeta().lifetimeSec, gravitationalAcceleration = data:getProjectileMeta().gravitationalAcceleration * data.gravityMultiplier}
                            end
                        end
                    end

                    return ProjectileAimbot.Old(proj, data, line, start, pos)
                end
            else
                GameData.Modules.Projectile.calculateImportantLaunchValues = ProjectileAimbot.Old
                if ProjectileAimbot.Circle then 
                    ProjectileAimbot.Circle:Destroy()
                    ProjectileAimbot.Circle = nil
                end
            end
        end
    })

    ProjectileAimbot.Toggle.Functions.Settings.MiniToggle({
        Name = "Other Projectiles",
        Description = "Applies aimbot to all projectiles",
        Flag = "ProjAimbotOtherProjectiles",
        Callback = function(self, value)
            ProjectileAimbot.Settings.Other = value
        end
    })

    ProjectileAimbot.Toggle.Functions.Settings.MiniToggle({
        Name = "Filled FOV",
        Description = "Fills the FOV circle",
        Flag = "ProjAimbotFovFilled",
        Callback = function(self, value)
            ProjectileAimbot.Settings.Filled = value
        end
    })

    ProjectileAimbot.Toggle.Functions.Settings.Slider({
        Name = "FOV Visibility",
        Description = "Changes the visibility of your FOV circle",
        Min = 0,
        Max = 1,
        Default = 0,
        Decimals = 1,
        Flag = "ProjAimbotFovVisibility",
        Callback = function(self, value)
            ProjectileAimbot.Settings.Visibility = value
            if ProjectileAimbot.Circle then
                ProjectileAimbot.Circle.Transparency = value
            end
        end
    })

    ProjectileAimbot.Toggle.Functions.Settings.Slider({
        Name = "FOV Size",
        Description = "Changes the size of your FOV circle",
        Min = 0,
        Max = 360,
        Default = 90,
        Flag = "ProjAimbotFovSize",
        Callback = function(self, value)
            ProjectileAimbot.Settings.Size = value
            if ProjectileAimbot.Circle then
                ProjectileAimbot.Circle.Radius = value
            end
        end
    })

    ProjectileAimbot.Toggle.Functions.Settings.Slider({
        Name = "FOV Thickness",
        Description = "Changes the thickness of your FOV circle",
        Min = 0,
        Max = 12,
        Default = 2,
        Flag = "ProjAimbotFovThickness",
        Callback = function(self, value)
            ProjectileAimbot.Settings.Thickness = value
            if ProjectileAimbot.Circle then
                ProjectileAimbot.Circle.Thickness = value
            end
        end
    })

    ProjectileAimbot.Toggle.Functions.Settings.TextBox({
        Name = "FOV Color",
        Description = "Changes the color of your FOV circle",
        Default = "255, 0, 0",
        Flag = "ProjAimbotFovColor",
        Callback = function(self, value)
            local color = GetColor(value)
            if color then
                ProjectileAimbot.Settings.Color = color
            end
        end
    })
end)();

(function()
    local ProjectileAura = {
        Settings = {
            Range = 30,
            Speed = 100,
            Power = 50,
            Delay = 0.1,
            TP = false
        }
    }

	local DelayMap = {}
	local GetAmmo = function(Check)
		if not Check.ammoItemTypes then return nil end
		local Inv = GetInventory().items
		for i = 1, #Inv do
			local Obj = Inv[i]
			for j = 1, #Check.ammoItemTypes do
				if Obj.itemType == Check.ammoItemTypes[j] then
					return Check.ammoItemTypes[j]
				end
			end
		end
		return nil
	end

	local ProjNames = {arrow = true, snowball = true}
	local GetTools = function()
		local Found = {}
		local Inv = GetInventory().items
		for i = 1, #Inv do
			local It = Inv[i]
			local Data = GameData.Modules.ItemMeta[It.itemType]
			local Src = Data and Data.projectileSource
			if Src then
				local Ammo = GetAmmo(Src)
				if Ammo and ProjNames[Ammo] then
					Found[#Found + 1] = {
						Item = It,
						Ammo = Ammo,
						Proj = Src.projectileType(Ammo),
						Meta = Src
					}
				end
			end
		end
		return Found
	end

    local CheckProj = function(Bool, Obj)
        if not Bool then
            DelayMap[Obj.Item.itemType] = tick()
        else
            local Sounds = Obj.Meta.launchSound
            if Sounds and #Sounds > 0 then
                GameData.Modules.Sound:playSound(Sounds[1])
            end
        end
    end

	ProjectileAura.Toggle = Tabs.Combat.Functions.NewModule({
		Name = "ProjectileAura",
		Description = "Automatically fires at targets using projectiles",
		Icon = "rbxassetid://96350496887596",
		Flag = "ProjectileAura",
		Callback = function(self, callback)
			if callback then
				repeat
					local Target = GetNearestEntity()
					if Target.Entity and Target.Distance <= ProjectileAura.Settings.Range and Functions.IsAlive() and not KillAuraData.Attacking then
						local Pos = LP.Character.HumanoidRootPart.Position
						local Tools = GetTools()
                        for i = 1, #Tools do
                            local Obj = Tools[i]
                            if (DelayMap[Obj.Item.itemType] or 0) < tick() then
                                local ProjData = GameData.Modules.ProjMeta[Obj.Proj]
                                local AimPos = Aim(Pos, ProjData.launchVelocity, ProjData.gravitationalAcceleration or 196.2, Target.EntityData.PrimaryPart.Position, Target.EntityData.PrimaryPart.Velocity, WS.Gravity, Target.EntityData.Humanoid.HipHeight, GroundRay)
                                if AimPos then
                                    GameData.Remotes.Set:InvokeServer({hand = Obj.Item.tool})

                                    task.spawn(function()
                                        local Args = {
                                            Obj.Item.tool,
                                            Obj.Ammo,
                                            Obj.Proj,
                                            CFrame.new(Pos, AimPos).Position,
                                            Pos,
                                            (CFrame.new(Pos, AimPos)).LookVector * ProjData.launchVelocity,
                                            HttpService:GenerateGUID(true),
                                            {drawDurationSec = ProjectileAura.Settings.Speed / 100, shotId = HttpService:GenerateGUID(false)},
                                            WS:GetServerTimeNow() - (math.pow(10, -2) * ((ProjectileAura.Settings.Power - 5) / 2))
                                        }

                                        if not ProjectileAura.Settings.TP then
                                            GameData.Modules.Projectile:createLocalProjectile(Obj.Meta, Obj.Ammo, Obj.Proj, CFrame.new(Pos, AimPos).Position, HttpService:GenerateGUID(true), (CFrame.new(Pos, AimPos)).LookVector * ProjData.launchVelocity, {drawDurationSeconds = 1})
                                        end

                                        local Fired = Rep.rbxts_include.node_modules["@rbxts"].net.out._NetManaged.ProjectileFire:InvokeServer(Args[1], Args[2], Args[3], Args[4], Args[5], Args[6], Args[7], Args[8], Args[9], Args[10])
                                        CheckProj(Fired, Obj)
                                    end)

                                    DelayMap[Obj.Item.itemType] = tick() + Obj.Meta.fireDelaySec
                                    task.wait(ProjectileAura.Settings.Delay / 2)
                                end
                            end
                        end
                    end
                    task.wait(ProjectileAura.Settings.Delay)
                until not self.Data.Enabled
            end
		end
	})

    ProjectileAura.Toggle.Functions.Settings.MiniToggle({
        Name = "Teleport",
        Description = "Teleports the projectile",
        Default = true,
        Flag = "ProjectileAuraTP",
        Callback = function(self, value)
            ProjectileAura.Settings.TP = value
        end
    })

    ProjectileAura.Toggle.Functions.Settings.Slider({
        Name = "Range",
        Description = "Range to detect the player",
        Min = 1,
        Max = 50,
        Default = 30,
        Flag = "ProjectileAuraRange",
        Callback = function(self, value)
            ProjectileAura.Settings.Range = value
        end
    })

    ProjectileAura.Toggle.Functions.Settings.Slider({
        Name = "Speed",
        Description = "How fast to launch the projectile",
        Min = 1,
        Max = 100,
        Default = 100,
        Flag = "ProjectileAuraSpeed",
        Callback = function(self, value)
            ProjectileAura.Settings.Speed = value
        end
    })

    ProjectileAura.Toggle.Functions.Settings.Slider({
        Name = "Power",
        Description = "Power to launch the projectile",
        Min = 1,
        Max = 100,
        Default = 50,
        Flag = "ProjectileAuraPower",
        Callback = function(self, value)
            ProjectileAura.Settings.Power = value
        end
    })

    ProjectileAura.Toggle.Functions.Settings.Slider({
        Name = "Delay",
        Description = "Delay between each projectile",
        Min = 0,
        Max = 1,
        Default = 0.1,
        Flag = "ProjectileAuraDelay",
        Callback = function(self, value)
            ProjectileAura.Settings.Delay = value
        end
    })
end)();

(function()
    local VelocityData = {
        Settings = {Knockback = 0},
        Old = GameData.Modules.Knockback.applyKnockback
    }

    VelocityData.Toggle = Tabs.Player.Functions.NewModule({
        Name = "Velocity",
        Description = "Changes how much knockback you take",
        Icon = "rbxassetid://80062062896103",
        Flag = "Velocity",
        Callback = function(self, callback)
            if callback then
                VelocityData.OldApplyKnockback = GameData.Modules.Knockback.applyKnockback
                GameData.Modules.Knockback.applyKnockback = function(...)
                    local args = {...}
                    args[2] = VelocityData.Settings.Knockback
                    return VelocityData.OldApplyKnockback(table.unpack(args))
                end
            else
                GameData.Modules.Knockback.applyKnockback = VelocityData.OldApplyKnockback
            end
        end
    })
    
    VelocityData.Toggle.Functions.Settings.Slider({
        Name = "Knockback",
        Description = "How much knockback you take",
        Flag = "Knockback",
        Min = 0,
        Max = 100,
        Default = 0,
        Callback = function(self, callback)
            VelocityData.Settings.Knockback = callback
        end
    })
end)();

(function()
    Tabs.Movement.Functions.NewModule({
        Name = "Desync",
        Description = "Makes your server movement delayed",
        Icon = "rbxassetid://127506391973510",
        Flag = "Desync",
        Callback = function(self, callback)
            if callback and setfflag then
                setfflag("S2PhysicsSenderRate", "2")
            end
        end
    })
end)()

local GetYPos = function()
    local pos = math.huge
    for _, block in next, Blocks do
        local ray = WS:Raycast(block.Position + Vector3.new(0, 1000, 0), Vector3.new(0, -1000, 0), BlockRay)
        if ray and ray.Position.Y < pos then
            pos = ray.Position.Y - 7
        end
    end
    return pos
end

local MakeWater = function(mode, bool)
    local Terrain = workspace.Terrain
            
    Terrain:FillBlock(
        CFrame.new(LP.Character.HumanoidRootPart.Position.X, GetYPos(), LP.Character.HumanoidRootPart.Position.Z),
        Vector3.new(5000, 0.01, 5000),
        Enum.Material[mode]
    )

    Terrain.WaterColor = Color3.fromRGB(10, 70, 80)
    Terrain.WaterReflectance = 0.7
    Terrain.WaterTransparency = 0.25
    Terrain.WaterWaveSize = 0.13
    Terrain.WaterWaveSpeed = 8 
    
    if LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, bool)
    end
end

(function()
    local AntiVoid = {
        Settings = {
            Loop = 20,
            Add = 8,
            Del = 0.4,
            Times = 3,
            Power = 10,
            Jumps = 7,
            Visible = 0.6,
            Water = false,
            Mode = "Launch",
            Smooth = "Accurate",
            Material = "ForceField",
            Color = {R = 0, G = 0, B = 140}
        },
        Connect = nil,
        Part = nil,
        Bounce = false,
        Position = 0
    }

    AntiVoid.Toggle = Tabs.World.Functions.NewModule({
        Name = "AntiVoid",
        Description = "Prevents you from falling into the void",
        Icon = "rbxassetid://76137296972317",
        Flag = "AntiVoid",
        Callback = function(self, callback)
            if callback then
                AntiVoid.Part = Instance.new("Part", WS)
                AntiVoid.Part.Size = Vector3.new(2000, 0.5, 2000)
                AntiVoid.Part.Color = Color3.fromRGB(AntiVoid.Settings.Color.R, AntiVoid.Settings.Color.G, AntiVoid.Settings.Color.B)
                AntiVoid.Part.Material = Enum.Material[AntiVoid.Settings.Material]
                AntiVoid.Part.Transparency = 1 - AntiVoid.Settings.Visible
                AntiVoid.Part.CanCollide = AntiVoid.Settings.Mode ~= "Launch"
                AntiVoid.Part.Position = Vector3.new(0, GetYPos(), 0)
                AntiVoid.Part.Anchored = true

                AntiVoid.Position = Functions.IsAlive() and LP.Character.HumanoidRootPart.Position.Y + 10
                task.spawn(function()
                    repeat task.wait() until Functions.IsAlive()

                    if AntiVoid.Settings.Water then
                        MakeWater("Water", false)
                    end

                    repeat
                        AntiVoid.Part.Color = Color3.fromRGB(AntiVoid.Settings.Color.R, AntiVoid.Settings.Color.G, AntiVoid.Settings.Color.B)
                        AntiVoid.Part.Material = Enum.Material[AntiVoid.Settings.Material]
                        AntiVoid.Part.Transparency = AntiVoid.Settings.Water and 1 or 1 - AntiVoid.Settings.Visible
                        AntiVoid.Part.CanCollide = AntiVoid.Settings.Mode ~= "Launch"

                        if Functions.IsAlive() and LP.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
                            AntiVoid.Position = LP.Character.HumanoidRootPart.Position.Y
                        end

                        task.wait(0.1)
                    until not self.Data.Enabled
                end)

                AntiVoid.Bounce = false
                AntiVoid.Connect = AntiVoid.Part.Touched:connect(function(void)
                    if Functions.IsAlive() and void.Parent == LP.Character and not AntiVoid.Bounce and not FlyData.Toggle.Data.Enabled then
                        AntiVoid.Bounce = true
                        if AntiVoid.Settings.Mode == "Launch" then
                            for i = 1, AntiVoid.Settings.Loop do
                                task.wait(AntiVoid.Settings.Del / 10)
                                LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, i * (AntiVoid.Position - LP.Character.HumanoidRootPart.Position.Y + AntiVoid.Settings.Add), 0)
                            end
                        elseif AntiVoid.Settings.Mode == "Teleport" then
                            local Grav = WS.Gravity
                            WS.Gravity = 0

                            LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            for _ = 1, AntiVoid.Settings.Times do
                                LP.Character.HumanoidRootPart.CFrame += Vector3.new(0, AntiVoid.Settings.Power, 0)
                                task.wait(AntiVoid.Settings.Times / 20)
                            end

                            WS.Gravity = Grav
                        else
                            for _ = 1, AntiVoid.Settings.Jumps do
                                LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                task.wait(0.1)
                            end
                        end
                        AntiVoid.Bounce = false
                    end
                end)
            else
                if AntiVoid.Part then
                    AntiVoid.Part:Destroy()
                    AntiVoid.Part = nil
                end

                if AntiVoid.Connect then
                    AntiVoid.Connect:Disconnect()
                    AntiVoid.Connect = nil
                end

                repeat task.wait() until Functions.IsAlive()
                MakeWater("Air", true)
            end
        end
    })

    local AntiVoidLaunch, AntiVoidTP, AntiVoidJump = {}, {}, nil
    AntiVoid.Toggle.Functions.Settings.Dropdown({
        Name = "Mode",
        Description = "Mode to prevent you from falling into the void",
        Default = "Launch",
        Options = {"Launch", "Teleport", "Jump"},
        Flag = "AntiVoidMode",
        Callback = function(self, value)
            AntiVoid.Settings.Mode = value
            task.spawn(function()
                repeat task.wait() until #AntiVoidLaunch == 3 and #AntiVoidTP == 2 and AntiVoidJump
                for _, v in next, AntiVoidLaunch do v.Functions.SetVisiblity(value == "Launch") end
                for _, v in next, AntiVoidTP do v.Functions.SetVisiblity(value == "Teleport") end
                AntiVoidJump.Functions.SetVisiblity(value == "Jump")
            end)
        end
    })

    table.insert(AntiVoidLaunch, AntiVoid.Toggle.Functions.Settings.Slider({
        Name = "Loop",
        Description = "How long should the loop repeat to launch you",
        Min = 5,
        Max = 40,
        Default = 20,
        Flag = "AntiVoidLoop",
        Callback = function(self, value)
            AntiVoid.Settings.Loop = value
        end
    }))

    table.insert(AntiVoidLaunch, AntiVoid.Toggle.Functions.Settings.Slider({
        Name = "Add",
        Description = "Height to add to the accurate launch",
        Min = 5,
        Max = 15,
        Default = 8,
        Flag = "AntiVoidAdd",
        Callback = function(self, value)
            AntiVoid.Settings.Add = value
        end
    }))

    table.insert(AntiVoidLaunch, AntiVoid.Toggle.Functions.Settings.Slider({
        Name = "Delay",
        Description = "Delay between launches",
        Min = 0.1,
        Max = 0.6,
        Default = 0.4,
        Decimals = 2,
        Flag = "AntiVoidDelay",
        Callback = function(self, value)
            AntiVoid.Settings.Del = value
        end
    }))

    table.insert(AntiVoidTP, AntiVoid.Toggle.Functions.Settings.Slider({
        Name = "Times",
        Description = "Amount of times to teleport you",
        Min = 1,
        Max = 5,
        Default = 3,
        Flag = "AntiVoidTimes",
        Callback = function(self, value)
            AntiVoid.Settings.Times = value
        end
    }))

    table.insert(AntiVoidTP, AntiVoid.Toggle.Functions.Settings.Slider({
        Name = "Power",
        Description = "Power of the teleportation process",
        Min = 5,
        Max = 15,
        Default = 10,
        Flag = "AntiVoidPower",
        Callback = function(self, value)
            AntiVoid.Settings.Power = value
        end
    }))

    AntiVoidJump = AntiVoid.Toggle.Functions.Settings.Slider({
        Name = "Jumps",
        Description = "How many times to jump",
        Min = 3,
        Max = 15,
        Default = 7,
        Flag = "AntiVoidJumps",
        Callback = function(self, value)
            AntiVoid.Settings.Jumps = value
        end
    })

    AntiVoid.Toggle.Functions.Settings.MiniToggle({
        Name = "Water",
        Description = "Replaces the AntiVoid part with water",
        Flag = "AntiVoidWater",
        Default = true,
        Callback = function(self, value)
            AntiVoid.Settings.Water = value
        end
    })

    AntiVoid.Toggle.Functions.Settings.Slider({
        Name = "Visibility",
        Description = "How visible should the AntiVoid part be",
        Min = 0,
        Max = 1,
        Default = 0.5,
        Decimals = 2,
        Flag = "AntiVoidVisibility",
        Callback = function(self, value)
            AntiVoid.Settings.Visible = value
        end
    })

    AntiVoid.Toggle.Functions.Settings.Dropdown({
        Name = "Material",
        Description = "Material of the AntiVoid part",
        Default = "ForceField",
        Options = Materials,
        Flag = "AntiVoidMaterial",
        Callback = function(self, value)
            AntiVoid.Settings.Material = value
        end
    })

    AntiVoid.Toggle.Functions.Settings.TextBox({
        Name = "Color",
        Description = "Color to highlight the AntiVoid part",
        Default = "100, 100, 100",
        Flag = "AntiVoidColor",
        Callback = function(self, value)
            local color = GetColor(value)
            if color then
                AntiVoid.Settings.Color = color
            end
        end
    })
end)();

(function()
    local AutoClicker = {
        Settings = {
            Blocks = 30,
            CPS = 30,
            Mode = "Simple",
            BlocksEnabled = false
        },
        Enabled = false,
        Running = false,
        Connect = {}
    }

    local AutoClick = function()
        if AutoClicker.Running then
            AutoClicker.Running = false
            task.wait()
        end
        AutoClicker.Running = true

        task.spawn(function()
            repeat
                local Time = 0
                if not GameData.Modules.App:isLayerOpen(GameData.Modules.UI.MAIN) then
                    local CPS = AutoClicker.Settings.CPS
                    if AutoClicker.Settings.Mode == "Random" then
                        CPS = math.random(1, 50)
                    end

                    local CurrentItem = GetInventory().hand
                    local Count = AutoClicker.Settings.Mode == "Burst" and 3 or 1

                    if CurrentItem and CurrentItem.itemType then
                        local Item = GameData.Modules.ItemMeta[CurrentItem.itemType]
                        if Item then
                            if Item.sword and not GameData.Controllers.Dao.chargingMaid then
                                for _ = 1, Count do
                                    GameData.Controllers.Sword:swingSwordAtMouse(0)
                                    Time = 1 / CPS
                                end
                            elseif Item.block and AutoClicker.Settings.BlocksEnabled then
                                local Mouse = GameData.Controllers.Place.blockPlacer and GameData.Controllers.Place.blockPlacer.clientManager:getBlockSelector():getMouseInfo(0)
                                if Mouse then
                                    for _ = 1, Count do
                                        task.spawn(function()
                                            GameData.Controllers.Place.blockPlacer:placeBlock(Mouse.placementPosition)
                                        end)
                                    end
                                    Time = AutoClicker.Settings.Mode == "Simple" and AutoClicker.Settings.Blocks or CPS
                                end
                            end
                        end
                    end
                end
                task.wait(Time)
            until not AutoClicker.Running or not AutoClicker.Enabled
        end)
    end

    AutoClicker.Toggle = Tabs.Combat.Functions.NewModule({
        Name = "AutoClicker",
        Description = "Automatically clicks for you",
        Icon = "rbxassetid://114020023156214",
        Flag = "AutoClicker",
        Callback = function(self, callback)
            AutoClicker.Enabled = callback
            if callback then
                table.insert(AutoClicker.Connect, UIS.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        AutoClick()
                    end
                end))

                table.insert(AutoClicker.Connect, UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        AutoClicker.Running = false
                    end
                end))
            else
                AutoClicker.Running = false
                for _, v in next, AutoClicker.Connect do
                    v:Disconnect()
                end
                AutoClicker.Connect = {}
            end
        end
    })

    AutoClicker.Toggle.Functions.Settings.Dropdown({
        Name = "Mode",
        Description = "Changes the way it clicks",
        Options = {"Simple", "Burst", "Random"},
        Default = "Simple",
        Flag = "AutoClickerMode",
        Callback = function(self, value)
            AutoClicker.Settings.Mode = value
        end
    })

    local BlocksCPS
    AutoClicker.Toggle.Functions.Settings.MiniToggle({
        Name = "Blocks",
        Description = "Places blocks when you click",
        Flag = "AutoClickerBlocks",
        Default = true,
        Callback = function(self, value)
            AutoClicker.Settings.BlocksEnabled = value
            task.spawn(function()
                repeat task.wait() until BlocksCPS
                BlocksCPS.Functions.SetVisiblity(value)
            end)
        end
    })

    BlocksCPS = AutoClicker.Toggle.Functions.Settings.Slider({
        Name = "Blocks CPS",
        Description = "How many times you want to place blocks each second",
        Min = 1,
        Max = 50,
        Default = 30,
        Hide = true,
        Flag = "AutoClickerBlocksCPS",
        Callback = function(self, value)
            AutoClicker.Settings.Blocks = value
        end
    })

    AutoClicker.Toggle.Functions.Settings.Slider({
        Name = "Hit CPS",
        Description = "How many times you want to swing your sword each second",
        Min = 1,
        Max = 50,
        Default = 20,
        Flag = "AutoClickerHitCPS",
        Callback = function(self, value)
            AutoClicker.Settings.CPS = value
        end
    })
end)();

(function()
    local AutoVoidDrop = {
        Settings = {
            Items = {"emerald", "diamond", "gold", "iron"},
            Position = 70,
            Delay = 0.1,
            Owl = false
        }
    }

    AutoVoidDrop.Toggle = Tabs.World.Functions.NewModule({
        Name = "AutoVoidDrop",
        Description = "Automatically drops items when falling into the void",
        Icon = "rbxassetid://109744104816615",
        Flag = "AutoVoidDrop",
        Callback = function(self, callback)
            if callback then
                repeat task.wait() until GetMatchState() ~= 0

                local Loop
                local VoidDrop = function()
                    if Loop then
                        task.cancel(Loop)
                        Loop = nil
                    end

                    Loop = task.spawn(function()
                        repeat
                            if Functions.IsAlive() and (LP.Character:GetAttribute('InflatedBalloons') or 0) <= 0 and LP.Character.HumanoidRootPart.Position.Y < (GetYPos() - AutoVoidDrop.Settings.Position) then
                                if (AutoVoidDrop.Settings.Owl and not LP.Character.HumanoidRootPart:FindFirstChild('OwlLiftForce')) or not AutoVoidDrop.Settings.Owl then
                                    for _, v in AutoVoidDrop.Settings.Items do
                                        local Item = GetItemType(v, false, false)
                                        if Item then
                                            Rep.rbxts_include.node_modules["@rbxts"].net.out._NetManaged.DropItem:InvokeServer({
                                                item = Item.Item.tool,
                                                amount = Item.Item.amount
                                            })
                                        end
                                    end
                                end
                            end
                            task.wait(AutoVoidDrop.Settings.Delay)
                        until not self.Data.Enabled
                    end)
                end

                LP.CharacterAdded:Connect(VoidDrop)
                VoidDrop()
            else
                if Loop then
                    task.cancel(Loop)
                    Loop = nil
                end
            end
        end
    })

    AutoVoidDrop.Toggle.Functions.Settings.TextBox({
        Name = "Items",
        Description = "Items to drop, in order (separated by commas and space)",
        Default = "emerald, diamond, gold, iron",
        Flag = "AutoVoidDropItems",
        Callback = function(self, callback)
            local items = {}
            for item in string.gmatch(callback, "([^,]+)") do
                table.insert(items, item:match("^%s*(.-)%s*$"))
            end
            AutoVoidDrop.Settings.Items = items
        end
    })

    AutoVoidDrop.Toggle.Functions.Settings.Slider({
        Name = "Position",
        Description = "Position to drop the items at",
        Min = 1,
        Max = 70,
        Default = 70,
        Flag = "AutoVoidDropPosition",
        Callback = function(self, value)
            AutoVoidDrop.Settings.Position = value
        end
    })

    AutoVoidDrop.Toggle.Functions.Settings.Slider({
        Name = "Delay",
        Description = "Delay to check position",
        Min = 0,
        Max = 1,
        Default = 0.1,
        Flag = "AutoVoidDropDelay",
        Callback = function(self, value)
            AutoVoidDrop.Settings.Delay = value
        end
    })

    AutoVoidDrop.Toggle.Functions.Settings.MiniToggle({
        Name = "Owl",
        Description = "Doesn't drop items if you're being picked up by an owl",
        Flag = "AutoVoidDropOwl",
        Default = true,
        Callback = function(self, value)
            AutoVoidDrop.Settings.Owl = value
        end
    })
end)();

(function()
    local FastBreak = {Settings = {Speed = 0.24}}

    FastBreak.Toggle = Tabs.World.Functions.NewModule({
        Name = "FastBreak",
        Description = "Modifies the break cooldown",
        Icon = "rbxassetid://126920895734081",
        Flag = "FastBreak",
        Callback = function(self, callback)
            if callback then
                repeat
                    GameData.Controllers.BlockBreaker.cooldown = FastBreak.Settings.Speed
					task.wait(0.1)
				until not self.Data.Enabled
			else
				GameData.Controllers.BlockBreaker.cooldown = 0.3
            end
        end
    })
    
    FastBreak.Toggle.Functions.Settings.Slider({
        Name = "Speed",
        Description = "How fast to break",
        Flag = "FastBreakSpeed",
        Min = 0,
        Max = 0.3,
        Default = 0.24,
        Decimals = 2,
        Callback = function(self, callback)
            FastBreak.Settings.Speed = callback
        end
    })
end)();

(function()
    local FarBreak = {Settings = {Range = 20}}

    FarBreak.Toggle = Tabs.World.Functions.NewModule({
        Name = "FarBreak",
        Description = "Modifies the break range",
        Icon = "rbxassetid://112327880375749",
        Flag = "FarBreak",
        Callback = function(self, callback)
            if callback then
                repeat
                    GameData.Controllers.BlockBreaker.range = FarBreak.Settings.Range
					task.wait(0.1)
				until not self.Data.Enabled
			else
				GameData.Controllers.BlockBreaker.range = 18
            end
        end
    })
    
    FarBreak.Toggle.Functions.Settings.Slider({
        Name = "Range",
        Description = "How far to break",
        Flag = "FarBreakRange",
        Min = 0,
        Max = 30,
        Default = 30,
        Callback = function(self, callback)
            FarBreak.Settings.Range = callback
        end
    })
end)();
