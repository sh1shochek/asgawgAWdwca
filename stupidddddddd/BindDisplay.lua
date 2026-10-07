-- ReplicatedStorage.Interface.Screens.Menu.Settings.BindDisplay
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Settings.BindDisplay
-- Decompile time: 1.31 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetBindIcon = require(ReplicatedStorage.Components.Common.GetBindIcon)
local KeybindParser = require(ReplicatedStorage.Controllers.InputController.KeybindParser)
local u20 = Color3.fromRGB(255, 90, 90)
local u25 = Color3.fromRGB(255, 255, 255)

function u0.GetTextBox(a1) -- Line: 25 -- types: a1: userdata
    local TextBox = a1:FindFirstChild("TextBox", true)
    if TextBox and TextBox:IsA("TextBox") then
        return TextBox
    end
    return nil
end

function u0.GetIcon(a1) -- Line: 30 -- types: a1: userdata
    local Bind = a1:FindFirstChild("Bind", true)
    if Bind and Bind:IsA("ImageLabel") then
        return Bind
    end
    return nil
end

function u0.GetReset(a1) -- Line: 35 -- types: a1: userdata
    local Reset = a1:FindFirstChild("Reset", true)
    if Reset and Reset:IsA("GuiObject") then
        return Reset
    end
    return nil
end

function u0.FormatText(a1) -- Line: 41 -- types: a1: string
    if a1 == "" then
        return ""
    end
    return ((a1:gsub("Enum%.KeyCode%.", "")):gsub("Enum%.UserInputType%.", "")):gsub("Enum%.CustomInputType%.", "")
end

function u0.GetIconImage(a1) -- Line: 50 -- upvalues: KeybindParser (val), GetBindIcon (val) -- types: a1: string
    if a1 == "" then
        return nil
    end
    local v1 = KeybindParser.parse(a1)
    if typeof(v1) ~= "EnumItem" then
        return nil
    end
    return GetBindIcon(v1)
end

function u0.Apply(a1, a2) -- Line: 65 -- upvalues: u0 (val), u25 (val) -- types: a1: userdata, a2: string
    local v1 = u0.GetTextBox(a1)
    if not v1 then
        return
    end
    local v2 = a2 == ""
    local v3 = u0.GetIconImage(a2)
    local v4 = u0.GetIcon(a1)
    if v4 then
        v4.Image = v3 or ""
        v4.ImageColor3 = u25
        v4.Visible = v3 ~= nil
    end
    local v5 = false
    if v4 ~= nil then
        v5 = v3 ~= nil
    end
    v1.TextEditable = false
    v1.Active = true
    v1.PlaceholderText = if not v2 then "" else "None"
    v1.Text = if v2 then "" else if not v5 then u0.FormatText(a2) else ""
    local v6 = u0.GetReset(a1)
    if v6 then
        v6.Visible = not v2
    end
end

function u0.HideIcon(a1) -- Line: 97 -- upvalues: u0 (val) -- types: a1: userdata
    local v1 = u0.GetIcon(a1)
    if v1 then
        v1.Visible = false
    end
end

function u0.SetConflict(a1, a2) -- Line: 105
    -- upvalues: u0 (val), u20 (val), u25 (val)
    local v1 = u0.GetIcon(a1)
    if v1 then
        v1.ImageColor3 = if not a2 then u25 else u20
    end
end

return u0