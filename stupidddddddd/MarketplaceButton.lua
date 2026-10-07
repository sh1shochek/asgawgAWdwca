-- ReplicatedStorage.Components.Common.MarketplaceButton
-- Script path: ReplicatedStorage.Components.Common.MarketplaceButton
-- Decompile time: 3.95 ms

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Router = require(ReplicatedStorage.Database.Security.Router)
local u22 = table.freeze({hoverSizeMultiplier = 1.1})
local Out = Enum.EasingDirection.Out
local Quad = Enum.EasingStyle.Quad
local u25 = {}
u25.__index = u25

local function isPointInGui(a1, a2) -- Line: 18 -- types: a1: userdata, a2: userdata
    local AbsolutePosition = a1.AbsolutePosition
    local AbsoluteSize = a1.AbsoluteSize
    local v1 = false
    if AbsolutePosition.X <= a2.X then
        v1 = false
        if a2.X <= AbsolutePosition.X + AbsoluteSize.X then
            v1 = false
            if AbsolutePosition.Y <= a2.Y then
                v1 = a2.Y <= AbsolutePosition.Y + AbsoluteSize.Y
            end
        end
    end
    return v1
end

local function isGuiVisible(a1) -- Line: 28 -- types: a1: userdata
    local Parent = a1
    while Parent do
        if Parent:IsA("GuiObject") and not Parent.Visible then
            return false
        end
        if Parent:IsA("LayerCollector") and not Parent.Enabled then
            return false
        end
        Parent = Parent.Parent
    end
    return true
end

function u25.new(a1, a2) -- Line: 45
    -- upvalues: u22 (val), u25 (val), Out (val), Quad (val), isGuiVisible (val), UserInputService (val), Router (val)
    -- upvalues: Players (val)
    local u7 = table.clone(a2 or {})
    for i, j in u22 do
        if u7[i] == nil then
            u7[i] = j
        end
    end
    local v1 = {_isHovering = false, Instance = a1}
    local u22_2 = setmetatable(v1, u25)
    local Attribute = a1:GetAttribute("OriginalSize")
    if not Attribute then
        Attribute = a1.Size
    end
    if a1:GetAttribute("OriginalSize") then
        a1.Size = Attribute
    else
        a1:SetAttribute("OriginalSize", Attribute)
    end
    local hoverSizeMultiplier = u7.hoverSizeMultiplier
    if hoverSizeMultiplier then
        hoverSizeMultiplier = UDim2.new(
            Attribute.X.Scale * u7.hoverSizeMultiplier,
            Attribute.X.Offset * u7.hoverSizeMultiplier,
            Attribute.Y.Scale * u7.hoverSizeMultiplier,
            Attribute.Y.Offset * u7.hoverSizeMultiplier
        )
    end
    u22_2._originalSize = Attribute
    u22_2._hasHoverSize = hoverSizeMultiplier ~= nil

    local function tweenSize(a1_2, a2, a3) -- Line: 75
        -- upvalues: a1 (val), Out (upval), Quad (upval)
        local v1 = 0.15 * (a3 or 1)
        a1:TweenSize(a1_2, Out, Quad, v1, true, a2)
    end

    local function shouldRestoreHoverState() -- Line: 80
        -- upvalues: u22_2 (val), a1 (val), isGuiVisible (upval), UserInputService (upval)
        if u22_2._isHovering then
            local v1 = a1
            local v2 = game
            if v1:IsDescendantOf(v2) and isGuiVisible(a1) then
                local MouseLocation = UserInputService:GetMouseLocation()
                v2 = a1
                local v3 = Vector2.new(MouseLocation.X, MouseLocation.Y)
                local AbsolutePosition = v2.AbsolutePosition
                local AbsoluteSize = v2.AbsoluteSize
                local v4 = false
                if AbsolutePosition.X <= v3.X then
                    v4 = false
                    if v3.X <= AbsolutePosition.X + AbsoluteSize.X then
                        v4 = false
                        if AbsolutePosition.Y <= v3.Y then
                            v4 = v3.Y <= AbsolutePosition.Y + AbsoluteSize.Y
                        end
                    end
                end
                return v4
            end
        end
        return false
    end

    if hoverSizeMultiplier or u7.onMouseEnter then
        u22_2._mouseEnter = a1.MouseEnter:Connect(function(a1_2, a2) -- Line: 90
            -- upvalues: u22_2 (val), hoverSizeMultiplier (val), a1 (val), Out (upval), Quad (upval), u7 (val)
            -- upvalues: Router (upval)
            u22_2._isHovering = true
            if hoverSizeMultiplier then
                a1:TweenSize(hoverSizeMultiplier, Out, Quad, 0.15, true, nil)
            end
            if u7.onMouseEnter then
                u7.onMouseEnter(a1_2, a2)
            end
            Router.broadcastRouter("RunInterfaceSound", "Button Hover")
        end)
    end
    if hoverSizeMultiplier or u7.onMouseLeave then
        u22_2._mouseLeave = a1.MouseLeave:Connect(function(a1_2, a2) -- Line: 103
            -- upvalues: u22_2 (val), hoverSizeMultiplier (val), Attribute (val), a1 (val), Out (upval), Quad (upval)
            -- upvalues: u7 (val)
            u22_2._isHovering = false
            if hoverSizeMultiplier then
                a1:TweenSize(Attribute, Out, Quad, 0.15, true, nil)
            end
            if u7.onMouseLeave then
                u7.onMouseLeave(a1_2, a2)
            end
        end)
    end
    if u7.onActivated then
        u22_2._activated = a1.Activated:Connect(function() -- Line: 115
            -- upvalues: Router (upval), hoverSizeMultiplier (val), Attribute (val), u22_2 (val)
            -- upvalues: shouldRestoreHoverState (val), a1 (val), Out (upval), Quad (upval), Players (upval), u7 (val)
            Router.broadcastRouter("RunInterfaceSound", "Button Click")
            if hoverSizeMultiplier then
                a1:TweenSize(Attribute, Out, Quad, 0.075, true, function() -- Line: 119
                    -- upvalues: u22_2 (upval), shouldRestoreHoverState (upval), hoverSizeMultiplier (upval), a1 (upval)
                    -- upvalues: Out (upval), Quad (upval)
                    u22_2._isHovering = shouldRestoreHoverState()
                    if u22_2._isHovering then
                        a1:TweenSize(hoverSizeMultiplier, Out, Quad, 0.075, true, nil)
                    end
                end)
            end
            local FullName = a1:GetFullName()
            if FullName:find("GlobalMarketPlace")
                and not FullName:find("Close")
                and not FullName:find("Pin")
                and not FullName:find("Top")
                and not Players.LocalPlayer:GetAttribute("PinVerified") then
                return
            end
            u7.onActivated()
        end)
    end
    u22_2._destroying = a1.Destroying:Once(function() -- Line: 136 -- upvalues: u22_2 (val)
        u22_2:Destroy()
    end)
    return u22_2
end

function u25:Destroy() -- Line: 143 -- types: self: table
    local v1
    if self._hasHoverSize then
        self.Instance.Size = self._originalSize
    end
    for i, j in {"_mouseEnter", "_mouseLeave", "_activated", "_destroying"} do
        v1 = self[j]
        if v1 then
            v1:Disconnect()
        end
    end
end

return u25