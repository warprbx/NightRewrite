<p align="center">
</p>

# Documentations on how to make your own Night custom

> [!WARNING]
> If you want to add custom modules to an already supported game by Night, ignore the first 2 steps

#  How to make your own game support using Night
> First, add the script below at the top of your custom (make sure the file's name has the id of the game you want to add support for):

```lua
local function GetNight()
    local env = getgenv()
    assert(type(env) == 'table', string.format(
        'Expected global environment to be table, got %s',
        type(env)
    ))

    local framework = {
        instance = env.Night,
        validate = function(self)
            assert(self.instance, 'Night framework not found in global environment')

            assert(type(self.instance) == 'table', string.format(
                'Invalid Night framework structure: expected table, got %s',
                type(self.instance)
            ))

            assert(self.instance.Assets and type(self.instance.Assets) == 'table', 'Night framework missing or invalid Assets component')
            assert(self.instance.Assets.Functions and type(self.instance.Assets.Functions) == 'table', 'Night framework missing or invalid Assets.Functions component')

            assert(self.instance.Tabs and type(self.instance.Tabs) == 'table', 'Night framework missing or invalid Tabs component')
            assert(self.instance.Tabs.Tabs and type(self.instance.Tabs.Tabs) == 'table', 'Night framework missing or invalid Tabs.Tabs component')

            assert(self.instance.Background and type(self.instance.Background) == 'table', 'Night framework missing or invalid Background component')

            return self.instance
        end
    }

    return framework:validate()
end

local Night = GetNight()
local Functions = Night.Assets.Functions
local Tabs = Night.Tabs.Tabs
local Background = Night.Background

Functions.GetService = function(name)
    assert(type(name) == 'string', string.format(
        'Expected service name to be string, got %s',
        type(name)
    ))

    local suc, res = pcall(function()
        local srv = game:GetService(name)
        if not srv or not srv:IsA('Instance') then
            Functions.Notify('Invalid service instance for: ' .. name, 5)
        end
        return srv
    end)

    if not suc then
        Functions.Notify(string.format(
            'Failed to get service "%s": %s',
            name,
            tostring(res)
        ), 5)
    end

    local clone = Functions.cloneref(res)
    assert(clone, string.format(
        'Failed to clone service reference: %s',
        name
    ))

    return clone
end
```

Then, you can create service variables like this:
```lua
local plrs = Functions.GetService('Players')
local rep = Functions.GetService('ReplicatedStorage')
local rs = Functions.GetService('RunService')
local tween = Functions.GetService('TweenService')
local ws = Functions.GetService('Workspace')
local uis = Functions.GetService('UserInputService')
local cs = Functions.GetService('CollectionService')
local lplr = plrs.LocalPlayer
local character = lplr.Character
local cam = ws.CurrentCamera
```

# And that's it. Now, let's move to a tutorial on how to make modules.

# Toggle
```lua
local ModuleData = { -- module data, I recommend always using it
    Enabled = false,
    Toggle = nil
}

ModuleData.Toggle = Tabs.Player.Functions.NewModule({ -- you can change Players tab to: Combat, Movement, Render, Utility, World
    Name = 'Module',
    Description = 'Description',
    Icon = 'rbxassetid://123456789', -- icon (you can use rbxassetid, getcustomasset or simply leave it blank (but it will have no icon)
    Flag = 'Module', -- flag of the module to save the settings
    Callback = function(self, enabled)
        ModuleData.Enabled = enabled
        if ModuleData.Enabled then
            -- module start code
        else
            -- module stop code
        end
    end
})
```

# Mini Toggle
```lua
ModuleData.Toggle.Functions.Settings.MiniToggle({
    Name = 'Mini Toggle',
    Flag = 'MiniToggle',
    Default = true, -- set default on true or false
    Callback = function(self, enabled)
        ModuleData.MiniToggle = enabled -- value to store the boolean in
    end
})
```

# Slider
```lua
ModuleData.Toggle.Functions.Settings.Slider({
    Name = 'Slider',
    Min = 1,
    Max = 100,
    Default = 50,
    Decimals = 1, -- number of decimals (example: 0 for 1, 2, 3; 1 for 1.1, 1.2, 1.3; 2 for 1.11, 1.12, 1.13; and the list goes on)
    Flag = 'Slider',
    Callback = function(self, value)
        ModuleData.Slider = value
    end
})
```

# Dropdown
```lua
ModuleData.Toggle.Functions.Settings.ToggleList({
    Divide = 'Dropdown',
    Default = 'Option 1',
    Options = {'Option 1', 'Option 2', 'Option 3'}, -- you can add more or less options
    SelectLimit = 1, -- numbers of options that u can select. 1 for 1 option, 2 for 2 options, etc.
    Flag = 'Dropdown',
    Tab = false, -- set to false to not create a custom tab for it. use "Tab = true", or just remove Tab, if you have a long dropdown
    Callback = function(self, value)
        ModuleData.Dropdown = value
    end
})
```

# Text Box
```lua
ModuleData.Toggle.Functions.Settings.TextBox({
    Name = 'Text Box',
    PlaceHolderText = 'Text', -- what the text will be when the user hasn't placed a text already
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
    Flag = 'MiniToggle',
    Callback = function(self, enabled)
        task.spawn(function()
            repeat task.wait() until ModuleData.FlagHere -- replace with the module flag
            if not enabled then
                ModuleData.FlagHere.Functions.SetVisiblity(false)
            else
                ModuleData.FlagHere.Functions.SetVisiblity(true)
            end
        end)
    end
})
```

# How to send a notification
```lua
-- function for the notification
Functions.Notify = function(text, duration, flag) -- flag isn't necessarily needed
    Night.Assets.Notifications.Send({
        Description = text,
        Duration = duration,
        Flag = flag
    })
end

Functions.Notify('Loaded!', 5) -- send the notification
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
        ModuleData.Enabled = enabled
        if ModuleData.Enabled then
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
    Flag = 'MiniToggle',
    Default = true, -- set default on true or false
    Callback = function(self, enabled)
        ModuleData.MiniToggle = enabled -- value to store the boolean in
    end
})
ModuleData.Toggle.Functions.Settings.Slider({
    Name = 'Slider',
    Min = 1,
    Max = 100,
    Default = 50,
    Decimals = 1, -- number of decimals (example: 0 for 1, 2, 3; 1 for 1.1, 1.2, 1.3; 2 for 1.11, 1.12, 1.13; and the list goes on)
    Flag = 'Slider',
    Callback = function(self, value)
        ModuleData.Slider = value
    end
})
ModuleData.Toggle.Functions.Settings.ToggleList({
    Divide = 'Dropdown',
    Default = 'Option 1',
    Options = {'Option 1', 'Option 2', 'Option 3'}, -- you can add more or less options
    SelectLimit = 1, -- numbers of options that u can select. 1 for 1 option, 2 for 2 options, etc.
    Flag = 'Dropdown',
    Tab = false, -- set to false to not create a custom tab for it. use "Tab = true", or just remove Tab, if you have a long dropdown
    Callback = function(self, value)
        ModuleData.Dropdown = value
    end
})
ModuleData.Toggle.Functions.Settings.TextBox({
    Name = 'Text Box',
    PlaceHolderText = 'Text', -- what the text will be when the user hasn't placed a text already
    Flag = 'TextBox',
    Callback = function(self, text)
        ModuleData.TextBox = text
    end
})
```

# If you still don't understand, you can check Night's games SRC.
