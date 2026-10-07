-- ReplicatedStorage.Interface.Screens.Menu.Settings.Templates.Keybind
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Settings.Templates.Keybind
-- Decompile time: 2.91 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script.Parent.Parent.Types)
local BindDisplay = require(script.Parent.Parent.BindDisplay)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages)
local u29 = {"Computer", "Console"}

local function GetKeybindTextBox(a1) -- Line: 22 -- upvalues: BindDisplay (val) -- types: a1: userdata
    return BindDisplay.GetTextBox(a1)
end

local function GetKeybindReset(a1) -- Line: 26 -- upvalues: BindDisplay (val) -- types: a1: userdata
    local v1 = BindDisplay.GetReset(a1)
    if v1 and v1:IsA("GuiButton") then
        return v1
    end
    return nil
end

return function(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) -- Line: 34
    -- upvalues: Janitor (val), u29 (val), BindDisplay (val)
    local Default, v1, v2, v3, v4, v5
    a5.LayoutOrder = a4
    a5.Left.Label.Text = a2.DisplayName or a1
    a5.Name = a1
    local u202 = Janitor.new()
    u202:Add(a5, "Destroy")
    local u179 = {}
    local v6 = nil
    local v7 = nil
    local v8, v9, v10, v11, v12 = a3, a5, a10, a6, a2
    for i, j in u29, v6, v7 do
        v1 = v11[j]
        if v1 ~= nil then
            u179[j] = v1
        elseif not v12.Default then
            u179[j] = ""
        else
            Default = v12.Default
            v2 = not (typeof(Default) ~= "table") and Default[j] or ""
            u179[j] = v2
        end
    end

    local function UpdateKeybindUI(a1, a2) -- Line: 70
        -- upvalues: BindDisplay (upval)
        BindDisplay.Apply(a1, a2)
    end

    local function SaveKeybinds() -- Line: 75 -- upvalues: a7 (val), a8 (val), a1 (val), u179 (val)
        a7(a8, a1, {Computer = u179.Computer, Console = u179.Console})
    end

    local v13 = nil
    local v14 = nil
    for k, n in u29, v13, v14 do
        local u57 = v9.Right:FindFirstChild(n)
        if u57 then
            v3 = u179[n]
            BindDisplay.Apply(u57, v3)
            local u68 = BindDisplay.GetTextBox(u57)
            if u68 then
                u202:Add(u68.Focused:Connect(function() -- Line: 92 -- upvalues: a9 (val), u68 (val), u179 (val), n (val)
                    a9(u68, u179[n], tick())
                end), "Disconnect")
            end
            v5 = BindDisplay.GetReset(u57)
            v4 = if not v5 then nil else if not v5:IsA("GuiButton") then nil else v5
            if v4 then
                u202:Add(v4.MouseButton1Click:Connect(function() -- Line: 100 -- upvalues: u179 (val), n (val), u57 (val), BindDisplay (upval), a7 (val), a8 (val), a1 (val)
                    u179[n] = ""
                    local v1 = u57
                    local v2 = u179[n]
                    BindDisplay.Apply(v1, v2)
                    a7(a8, a1, {Computer = u179.Computer, Console = u179.Console})
                end), "Disconnect")
            end
            v10(n, u179[n])
        end
    end
    v9.Parent = v8
    return function() -- Line: 115 -- upvalues: u202 (val)
        u202:Cleanup()
    end
end