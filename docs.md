<p align="center">
</p>

# Documentations on how to make your own Night custom
# If you still don't understand, you can check Night's games SRC, DM a dev or ask in the Discord.

#  How to make your own game support using Night
> Execute Night, this will make you a night folder in your workspace, goto the folder and make a "Games" folder
> You then make a file named: "placeid.lua" but replace placeid with the games placeid, now in your file 

```lua
local Night = getgenv().Night
local Functions = Night.Assets.Functions
local Tabs = Night.Tabs.Tabs
local Background = Night.Background

```

Then, you can create service variables like this:
```lua
local plrs = Functions.cloneref(game:GetService("Players"))
local rep = Functions.cloneref(game:GetServie("ReplicatedStorage"))
local rs = Functions.cloneref(game:GetService("RunService"))
local tween = Functions.cloneref(game:GetService("TweenService"))
local ws = Functions.cloneref(game:GetService("Workspace"))
local uis = Functions.cloneref(game:GetService("UserInputService"))
local cs = Functions.cloneref(game:GetService("CollectionService"))
local lplr = plrs.LocalPlayer
local character = lplr.Character
local cam = ws.CurrentCamera
```

# And that's it. Now, let's move to a tutorial on how to make modules.

# Toggle
```lua
local ModuleData = { -- module data, I recommend always using it
    Toggle = nil
}

ModuleData.Toggle = Tabs.Player.Functions.NewModule({ -- you can change Players tab to: Combat, Movement, Render, Utility, World
    Name = 'Module',
    Description = 'Description',
    Icon = 'rbxassetid://123456789', -- icon (you can use rbxassetid, getcustomasset or simply leave it blank (but it will have no icon)
    Flag = 'Module', -- flag of the module to save the settings
    Callback = function(self, enabled)
        if enabled then
            -- module start code
            print(self.Data.Enabled) -- true
            self.Functions.Toggle(false, false, false, true, true) -- to toggle a module - enabled: boolean, override: boolean, notify: boolean, save: boolean, updatearraylist: boolean
            repeat

                task.wait()
            until not self.Data.Enabled  -- loop that will run until module is disabled
        else
            -- module stop code
        end
    end
})
```

# Mini Elements/Settings - These all return the self argument
# Mini Toggle
```lua
local minitoggle
minitoggle = ModuleData.Toggle.Functions.Settings.MiniToggle({
    Name = 'Mini Toggle',
    Descritpion = "This is a minitoggle",
    Flag = 'MiniToggle',
    Hide = false, -- this is for if you want this to not be visible on load, you will have to make this visible yourself show further down
    Default = true, -- set default on true or false
    Callback = function(self, enabled)
        ModuleData.MiniToggle = enabled -- value to store the boolean in
        
        print(self == minitoggle) -- true
    end
})
```

# Slider
```lua
ModuleData.Toggle.Functions.Settings.Slider({
    Name = 'Slider',
    Description = "This is a slider",
    Min = 1,
    Max = 100,
    Default = 50,
    Decimals = 1, -- number of decimals (example: 0 for 1, 2, 3; 1 for 1.1, 1.2, 1.3; 2 for 1.11, 1.12, 1.13; and the list goes on)
    Hide = false, -- this is for if you want this to not be visible on load, you will have to make this visible yourself show further down
    Flag = 'Slider',
    Callback = function(self, value)
        ModuleData.Slider = value
    end
})
```

# Dropdown
```lua
ModuleData.Toggle.Functions.Settings.Dropdown({
    Name = 'Dropdown',
    Description = "This is a dropdown"
    Default = 'Option 1',
    Options = {'Option 1', 'Option 2', 'Option 3'}, -- you can add more or less options
    SelectLimit = 1, -- numbers of options that u can select. 1 for 1 option, 2 for 2 options, etc.
    Hide = false, -- this is for if you want this to not be visible on load, you will have to make this visible yourself show further down
    Flag = 'Dropdown',
    Callback = function(self, value)
        ModuleData.Dropdown = value
    end
})
```

# Multi Dropdown
```lua
ModuleData.Toggle.Functions.Settings.Dropdown({
    Name = 'Multi Dropdown',
    Description = "This is a multi option dropdown"
    Default = {'Option 1', 'Option 2'},
    Options = {'Option 1', 'Option 2', 'Option 3'}, -- you can add more or less options
    SelectLimit = 2, -- numbers of options that u can select. 1 for 1 option, 2 for 2 options, etc.
    Hide = false, -- this is for if you want this to not be visible on load, you will have to make this visible yourself show further down
    Flag = 'MultiDropdown',
    Callback = function(self, value)
        ModuleData.MultiDropdown = value
    end
})
```

# Text Box
```lua
local textbox = ModuleData.Toggle.Functions.Settings.TextBox({
    Name = 'Text Box',
    Description = "This is a textbox",
    Default = "Text", -- default value if you want to already place a value for the user
    PlaceHolderText = 'Text', -- what the text will be when the user hasn't placed a text already(not very useful if you have a default value)
    Hide = false, -- this is for if you want this to not be visible on load, you will have to make this visible yourself show further down
    Flag = 'TextBox',
    Callback = function(self, text)
        ModuleData.TextBox = text
    end
})
```

# How to set a slider/dropdown/etc's. visibility to true or false
```lua
ModuleData.Toggle.Functions.Settings.MiniToggle({ -- this works with everything, not only mini toggles
    Name = 'Mini Toggle',
    Description = "This is a mini toggle"
    Default = false,
    Hide = false, -- this is for if you want this to not be visible on load, you will have to make this visible yourself show further down
    Flag = 'MiniToggle',
    Callback = function(self, enabled)
        self.Functions.SetVisiblity(boolean)
        task.spawn(function()
            repeat task.wait() until ModuleData.Toggle.Settings.FlagHere -- replace with the module flag
                ModuleData.Toggle.Settings.FlagHere.Functions.SetVisiblity(enabled) -- boolean
        end)
    end
})
```

# How to send a notification
```lua
-- function for the notification
Functions.Notify = function(text, duration, flag) -- flag isn't necessarily needed
    return Night.Assets.Notifications.Send({
        Description = text,
        Duration = duration,
        Flag = flag -- for if you want to index this
    })
end

local noti = Functions.Notify('Loaded!', 5) -- send the notification
task.wait(2)
noti.Functions.Remove(removeanimation) -- boolean

-- flags
Night.Notifications.Active.Flag.Functions.Remove(removeanimation) -- boolean
```

# Module with slider, textbox, dropdown and minitoggle
```lua
local ModuleData = { -- module data, I recommend always using it
    Enabled = false,
    Toggle = nil,
    MiniToggle = false,
    Slider = 50,
    Dropdown = 'Option 1'
    TextBox = ''
}

ModuleData.Toggle = Tabs.Player.Functions.NewModule({ -- you can change Players tab to: Combat, Movement, Render, Utility, World
    Name = 'Module',
    Description = 'Description',
    Icon = 'rbxassetid://123456789', -- icon (you can use rbxassetid, getcustomasset or simply leave it blank (but it will have no icon)
    Flag = 'Module', -- flag of the module to save the settings
    Callback = function(self, enabled)
        if enabled then
            print(self.Data.Enabled, enabled, self.Data.Enabled == enabled) -- true, true, true
            print(ModuleData.MiniToggle) -- false
            print(ModuleData.Slider) -- 50
            print(ModuleData.Dropdown) -- Option 1
            print(ModuleData.TextBox ~= '' and ModuleData.TextBox or 'nothing') -- selected text or nothing
        else
            print('module toggled off')
        end
    end
})
ModuleData.Toggle.Functions.Settings.MiniToggle({
    Name = 'Mini Toggle',
    Description = "This is a mini toggle",
    Flag = 'MiniToggle',
    Hide = false,
    Default = true, -- set default on true or false
    Callback = function(self, enabled)
        ModuleData.MiniToggle = enabled -- value to store the boolean in
    end
})
ModuleData.Toggle.Functions.Settings.Slider({
    Name = 'Slider',
    Description = "This is a slider",
    Min = 1,
    Max = 100,
    Default = 50,
    Decimals = 1, -- number of decimals (example: 0 for 1, 2, 3; 1 for 1.1, 1.2, 1.3; 2 for 1.11, 1.12, 1.13; and the list goes on)
    Hide = false,
    Flag = 'Slider',
    Callback = function(self, value)
        ModuleData.Slider = value
    end
})
ModuleData.Toggle.Functions.Settings.Dropdown({
    Name = 'Dropdown',
    Description = "This is a dropdown"
    Default = 'Option 1',
    Options = {'Option 1', 'Option 2', 'Option 3'}, -- you can add more or less options
    SelectLimit = 1, -- numbers of options that u can select. 1 for 1 option, 2 for 2 options, etc.
    Hide = false, -- this is for if you want this to not be visible on load, you will have to make this visible yourself show further down
    Flag = 'Dropdown',
    Callback = function(self, value)
        ModuleData.Dropdown = value
    end
})
ModuleData.Toggle.Functions.Settings.TextBox({
    Name = 'Text Box',
    Description = "This is a textbox",
    Default = "Text"
    PlaceHolderText = 'Text', -- what the text will be when the user hasn't placed a text already(not very useful if you have a default value)
    Flag = 'TextBox',
    Callback = function(self, text)
        ModuleData.TextBox = text
    end
})
```
