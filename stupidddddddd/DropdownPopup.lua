-- ReplicatedStorage.Packages.DebugTools.Client.Components.DropdownPopup
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Components.DropdownPopup
-- Decompile time: 1.56 ms

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local GuiInset = GuiService:GetGuiInset()
local Parent = script.Parent.Parent
local Signal = require(Parent.Parent.Shared.Signal)
local Constants = require(Parent.Parent.Shared.Constants)
local Style = require(Parent.Style)
local u34 = {prototype = {}, interface = {}}

function u34.prototype:IsPointInDropdown(a2) -- Line: 19 -- upvalues: GuiInset (val) -- types: self: table, a2: userdata
    local v1 = self.DropdownFrame.AbsolutePosition + GuiInset
    local AbsoluteSize = self.DropdownFrame.AbsoluteSize
    local v2 = a2 - v1
    local v3 = false
    if 0 <= v2.X then
        v3 = false
        if v2.X <= AbsoluteSize.X then
            v3 = false
            if 0 <= v2.Y then
                v3 = v2.Y <= AbsoluteSize.Y
            end
        end
    end
    return v3
end

function u34.prototype:Destroy() -- Line: 31
    self.Closed:Fire()
    self.Closed:Destroy()
    self.ScreenGui:Destroy()
    self.InputEndedConnection:Disconnect()
    self.EntrySelected:Destroy()
    for i, j in self.OptionSelectedConnections do
        j:Disconnect()
    end
end

function u34.interface.new(a1, a2, a3) -- Line: 44
    -- upvalues: Signal (val), GuiInset (val), Constants (val), Style (val), Players (val), u34 (val)
    -- upvalues: UserInputService (val)
    local TextButton
    local u3 = nil
    local u6 = Signal.new()
    local v1 = Signal.new()
    local v2 = a1.AbsolutePosition + GuiInset
    local AbsoluteSize = a1.AbsoluteSize
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Dropdown"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = Constants.DROPDOWN_DISPLAY_ORDER
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.AutomaticSize = Enum.AutomaticSize.Y
    Frame.Position = UDim2.fromOffset(v2.X, v2.Y + AbsoluteSize.Y)
    Frame.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScreenGui
    Instance.new("UIListLayout").Parent = Frame
    local v3 = table.create(#a2)
    for i, j in a2 do
        TextButton = Instance.new("TextButton")
        TextButton.AutoLocalize = false
        TextButton.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
        TextButton.BackgroundColor3 = Style.BACKGROUND_DARK
        TextButton.BorderSizePixel = 0
        TextButton.Text = j
        TextButton.TextColor3 = Style.COLOR_WHITE
        TextButton.FontFace = Style.FONT
        TextButton.TextSize = 12
        TextButton.Parent = Frame
        table.insert(v3, (TextButton.Activated:Connect(function() -- Line: 86 -- upvalues: u6 (val), j (val), u3 (ref)
            u6:Fire(j)
            u3:Destroy()
        end)))
    end
    ScreenGui.Parent = Players.LocalPlayer.PlayerGui
    local v4 = {
        Value = a3,
        Parent = a1,
        Options = a2,
        ScreenGui = ScreenGui,
        DropdownFrame = Frame,
        EntrySelected = u6,
        OptionSelectedConnections = v3,
        Closed = v1,
    }
    local v5 = {__index = u34.prototype}
    u3 = setmetatable(v4, v5)
    task.defer(function() -- Line: 109 -- upvalues: u3 (ref), UserInputService (upval), GuiInset (upval)
        local u0 = true
        u3.InputEndedConnection = UserInputService.InputEnded:Connect(function(a1) -- Line: 111 -- upvalues: GuiInset (upval), u0 (ref), u3 (upval) -- types: a1: userdata
            if a1.UserInputType ~= Enum.UserInputType.MouseButton1 then
                return
            end
            local v1 = (Vector2.new(a1.Position.X, a1.Position.Y)) + GuiInset
            if not u0 and not u3:IsPointInDropdown(v1) then
                u3:Destroy()
            end
            u0 = false
        end)
    end)
    return u3
end

return u34.interface