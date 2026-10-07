-- ReplicatedStorage.Interface.Screens.Menu.Settings.Templates.Number
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Settings.Templates.Number
-- Decompile time: 1.26 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script.Parent.Parent.Types)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages)
return function(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 18
    -- upvalues: Janitor (val)
    a5.Name = a1
    a5.Left.Label.Text = a2.DisplayName or a1
    a5.LayoutOrder = a4
    local u12 = a6
    local u15 = Janitor.new()
    u15:Add(a5, "Destroy")

    local function FormatNumber(a1) -- Line: 39 -- types: a1: number
        return (tostring((math.floor(a1))))
    end

    local function UpdateValue(a1) -- Line: 44 -- upvalues: u12 (ref), a5 (val) -- types: a1: number
        u12 = math.floor(a1)
        a5.Right.Dropdown.Container.Left.Title.Text = tostring((math.floor(u12)))
    end

    u12 = math.floor(u12)
    a5.Right.Dropdown.Container.Left.Title.Text = tostring((math.floor(u12)))
    local Title = a5.Right.Dropdown.Container.Left.Title
    local Dropdown_2 = a5.Right.Dropdown
    u15:Add(Dropdown_2.MouseButton1Click:Connect(function() -- Line: 54 -- upvalues: Title (val)
        Title:CaptureFocus()
    end), "Disconnect")
    u15:Add(Dropdown_2.Activated:Connect(function() -- Line: 57 -- upvalues: Title (val)
        Title:CaptureFocus()
    end), "Disconnect")
    u15:Add(a5.Right.Dropdown.Container.Left.Title.FocusLost:Connect(function() -- Line: 62 -- upvalues: a5 (val), u12 (ref), a7 (val), a8 (val), a1 (val)
        local v1 = tonumber(a5.Right.Dropdown.Container.Left.Title.Text)
        if not v1 then
            a5.Right.Dropdown.Container.Left.Title.Text = tostring((math.floor(u12)))
            return
        end
        u12 = math.floor(v1)
        a5.Right.Dropdown.Container.Left.Title.Text = tostring((math.floor(u12)))
        a7(a8, a1, u12)
    end), "Disconnect")
    a5.Parent = a3
    return function() -- Line: 76 -- upvalues: u15 (val)
        u15:Cleanup()
    end
end