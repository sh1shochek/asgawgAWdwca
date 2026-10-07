-- ReplicatedStorage.Interface.Screens.Menu.Settings.Templates.Toggle
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Settings.Templates.Toggle
-- Decompile time: 1.39 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script.Parent.Parent.Types)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages)
local u27 = Color3.fromRGB(77, 77, 77)
local u32 = Color3.fromRGB(255, 255, 255)
local u33 = {"1", "2"}
return function(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 27
    -- upvalues: Janitor (val), u33 (val), u32 (val), u27 (val)
    local v1
    a5.Name = a1
    a5.Left.Label.Text = a2.DisplayName or a1
    a5.LayoutOrder = a4
    local u12 = a6
    local u15 = Janitor.new()
    u15:Add(a5, "Destroy")
    local Switch = a5.Right.Switch
    local Selection = Switch.Selection
    local Title = Selection.Title
    local Frame = Selection:FindFirstChild("Frame")

    local function UpdateToggleVisual(a1) -- Line: 54
        -- upvalues: Title (val), Frame (val), u33 (upval), u32 (upval), u27 (upval)
        local v1
        Title.Text = if not a1 then "OFF" else "ON"
        if not Frame then
            return
        end
        for i, v in ipairs(u33) do
            v1 = Frame:FindFirstChild(v)
            if v1 and v1:IsA("GuiObject") then
                v1.BackgroundColor3 = if not (i == 2 == a1) then u27 else u32
            end
        end
    end

    UpdateToggleVisual(u12)

    local function SetEnabled(a1_2) -- Line: 73
        -- upvalues: u12 (ref), UpdateToggleVisual (val), a7 (val), a8 (val), a1 (val)
        if a1_2 == u12 then
            return
        end
        u12 = a1_2
        UpdateToggleVisual(u12)
        a7(a8, a1, u12)
    end

    local function Toggle() -- Line: 84 -- upvalues: u12 (ref), UpdateToggleVisual (val), a7 (val), a8 (val), a1 (val)
        local v1 = not u12
        if v1 == u12 then
            return
        end
        u12 = v1
        UpdateToggleVisual(u12)
        a7(a8, a1, u12)
    end

    u15:Add(Switch.MouseButton1Click:Connect(Toggle), "Disconnect")
    for i, j in {"Left", "Right"} do
        v1 = Switch:FindFirstChild(j)
        if v1 and v1:IsA("GuiButton") then
            u15:Add(v1.MouseButton1Click:Connect(Toggle), "Disconnect")
        end
    end
    a5.Parent = a3
    return function() -- Line: 100 -- upvalues: u15 (val)
        u15:Cleanup()
    end
end