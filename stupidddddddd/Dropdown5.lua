-- ReplicatedStorage.Interface.Screens.Menu.Settings.Templates.Dropdown
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Settings.Templates.Dropdown
-- Decompile time: 2.70 ms

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script.Parent.Parent.Types)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages)
local u32 = Color3.fromRGB(255, 255, 255)
local u37 = Color3.fromRGB(255, 201, 14)

local function AnimateButton(a1, a2) -- Line: 30 -- upvalues: u37 (val), u32 (val) -- types: a1: userdata, a2: boolean
    a1.TextColor3 = if not a2 then u32 else u37
end

return function(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11) -- Line: 37
    -- upvalues: Janitor (val), u32 (val), GuiService (val)
    local u13 = Janitor.new()
    local u14 = a6
    a5:SetAttribute("IsDropdown", true)
    a5.LayoutOrder = a4
    a5.Left.Label.Text = a2.DisplayName or a1
    a5.Name = a1
    local DropdownContent = a5.Right.Dropdown.DropdownContent
    local Scroll = DropdownContent.Scroll
    local Scale = DropdownContent.Size.Y.Scale
    a5.Right.Dropdown.Container.Left.Title.Text = u14
    DropdownContent.Active = false
    DropdownContent.Visible = false
    Scroll.Visible = false

    local function ClearOptions() -- Line: 73 -- upvalues: u13 (val), Scroll (val)
        u13:Cleanup()
        for i, v in ipairs(Scroll:GetChildren()) do
            if v:IsA("TextButton") then
                v:Destroy()
            end
        end
    end

    local u42 = Janitor.new()
    u42:Add(a5, "Destroy")
    u42:Add(ClearOptions)
    u42:Add(a5.Right.Dropdown.MouseButton1Click:Connect(function() -- Line: 88
        -- upvalues: a10 (val), Scroll (val), a5 (val), ClearOptions (val), a2 (val), a9 (val), u32 (upval), u13 (val)
        -- upvalues: GuiService (upval), u14 (ref), DropdownContent (val), a11 (val), a7 (val), a8 (val), a1 (val)
        -- upvalues: Scale (val)
        local v1
        local v2 = a10()
        local v3 = not Scroll.Visible
        if v2 and v2 ~= Scroll then
            v2.Visible = false
            local Parent = v2.Parent
            if Parent then
                Parent.Visible = false
            end
            for i, v in ipairs(v2:GetChildren()) do
                if v:IsA("TextButton") then
                    v:Destroy()
                end
            end
        end
        for i2, i3 in ipairs(a5.Parent:GetChildren()) do
            if i3:GetAttribute("IsDropdown") then
                v1 = if not v3 then 15 else if i3.Name ~= a5.Name then 15 else 125
                i3.ZIndex = v1
            end
        end
        ClearOptions()
        if v3 and a2.Enums then
            local v4
            local v5 = math.min(#a2.Enums, 7)
            for i4, j in ipairs(a2.Enums) do
                local u98 = a9:WaitForChild("OptionTemplate"):Clone()
                u98.Size = UDim2.fromScale(1, 1 / v5)
                u98.Name = ("Option_%*"):format(j)
                u98.Frame.TextButton.Text = j
                u98.LayoutOrder = i4
                u98.Visible = true
                u98.Parent = Scroll
                if a5.Right.Dropdown.Container.Left.Title.Text == j then
                    u120 = true
                else
                    local u120 = false
                end
                v4 = if not u120 then 1 else 0.3
                u98.Frame.BackgroundTransparency = v4
                u98.TextColor3 = u32
                u13:Add(u98.MouseEnter:Connect(function() -- Line: 143 -- upvalues: u98 (val), u120 (val)
                    local v1 = if not u120 then 0.65 else 0.3
                    u98.Frame.BackgroundTransparency = v1
                end), "Disconnect", (("Option_%*_1"):format(j)))
                u13:Add(u98.MouseLeave:Connect(function() -- Line: 148 -- upvalues: u98 (val), u120 (val)
                    local v1 = if not u120 then 1 else 0.3
                    u98.Frame.BackgroundTransparency = v1
                end), "Disconnect", (("Option_%*_2"):format(j)))
                u13:Add(u98.MouseButton1Click:Connect(function() -- Line: 153
                    -- upvalues: GuiService (upval), Scroll (upval), u14 (upval), j (val), a5 (upval)
                    -- upvalues: DropdownContent (upval), a11 (upval), a7 (upval), a8 (upval), a1 (upval)
                    -- upvalues: ClearOptions (upval)
                    local v1 = false
                    if GuiService.SelectedObject ~= nil then
                        local v2 = Scroll
                        v1 = GuiService.SelectedObject:IsDescendantOf(v2)
                    end
                    a5.Right.Dropdown.Container.Left.Title.Text = j
                    Scroll.Visible = false
                    DropdownContent.Visible = false
                    a11(nil)
                    a7(a8, a1, j)
                    ClearOptions()
                    local Dropdown = a5.Right.Dropdown
                    if v1 and Dropdown:IsDescendantOf(game) then
                        GuiService.SelectedObject = Dropdown
                    end
                end), "Disconnect", (("Option_%*_3"):format(j)))
                u13:Add(u98, "Destroy")
            end
            DropdownContent.Size = UDim2.new(DropdownContent.Size.X, UDim.new(Scale * v5 / 7, 0))
            DropdownContent.Visible = true
            Scroll.Visible = true
            a11(Scroll)
            return
        end
        Scroll.Visible = false
        DropdownContent.Visible = false
        a11(nil)
    end), "Disconnect")
    a5.Parent = a3
    return function() -- Line: 197 -- upvalues: u13 (val), u42 (val)
        u13:Cleanup()
        u42:Cleanup()
    end
end