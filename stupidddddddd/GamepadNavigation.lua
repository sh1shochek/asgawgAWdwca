-- ReplicatedStorage.Interface.GamepadNavigation
-- Script path: ReplicatedStorage.Interface.GamepadNavigation
-- Decompile time: 24.02 ms

local u0 = {}
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local u36 = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true,
}
local u53 = {
    [Enum.UserInputType.Keyboard] = true,
    [Enum.UserInputType.MouseMovement] = true,
    [Enum.UserInputType.MouseButton1] = true,
    [Enum.UserInputType.MouseButton2] = true,
    [Enum.UserInputType.MouseButton3] = true,
    [Enum.UserInputType.MouseWheel] = true,
    [Enum.UserInputType.Touch] = true,
}
u0.NO_FALLBACK_ATTRIBUTE = "GamepadNavigationNoFallback"
local u71 = Enum.ContextActionPriority.High.Value + 1000
local Thumbstick2 = Enum.KeyCode.Thumbstick2
local u73 = {}
u73[Enum.KeyCode.DPadUp] = (Vector2.new(0, -1))
u73[Enum.KeyCode.DPadDown] = (Vector2.new(0, 1))
u73[Enum.KeyCode.DPadLeft] = (Vector2.new(-1, 0))
u73[Enum.KeyCode.DPadRight] = (Vector2.new(1, 0))
local u94 = false
local u95 = false
local u96 = false
local u97 = nil
local u98 = 0
local u99 = 0
local zero = Vector2.zero
local u101 = nil
local u102 = "Y"
local zero_2 = Vector2.zero
local u104 = 0
local u105 = nil
local u106 = 0

local function isGamepadInput(a1) -- Line: 128 -- upvalues: u36 (val)
    return u36[a1] == true
end

local function isEffectivelyVisible(a1) -- Line: 134 -- upvalues: LocalPlayer (val) -- types: a1: userdata
    local Parent = a1
    while Parent do
        if Parent:IsA("GuiObject") and not Parent.Visible then
            return false
        end
        if Parent:IsA("LayerCollector") then
            return Parent.Enabled and Parent:IsDescendantOf(LocalPlayer)
        end
        Parent = Parent.Parent
    end
    return false
end

local function isUsable(a1) -- Line: 149 -- upvalues: isEffectivelyVisible (val) -- types: a1: userdata?
    if a1 and a1.Parent and a1:IsA("GuiObject") then
        if a1.Selectable and a1.Interactable then
            local AbsoluteSize = a1.AbsoluteSize
            local v1 = false
            if 1 < AbsoluteSize.X then
                v1 = false
                if 1 < AbsoluteSize.Y then
                    v1 = isEffectivelyVisible(a1)
                end
            end
            return v1
        end
        return false
    end
    return false
end

local function isWithin(a1, a2) -- Line: 162 -- types: a1: userdata?, a2: userdata
    local v1 = false
    if a1 ~= nil then
        v1 = true
        if a1 ~= a2 then
            v1 = a1:IsDescendantOf(a2)
        end
    end
    return v1
end

local function getNavigatedSelection() -- Line: 169 -- upvalues: GuiService (val), isUsable (val)
    local SelectedObject = GuiService.SelectedObject
    if isUsable(SelectedObject) then
        return SelectedObject
    end
    return nil
end

local function isMenuUp() -- Line: 176 -- upvalues: MenuState (val), isEffectivelyVisible (val)
    local v1 = MenuState.GetMenuFrame()
    local v2 = false
    if v1 ~= nil then
        v2 = isEffectivelyVisible(v1)
    end
    return v2
end

local function getSelectionBehavior(a1, a2) -- Line: 183 -- types: a1: userdata, a2: userdata
    if a2.X < 0 then
        return a1.SelectionBehaviorLeft
    end
    if 0 < a2.X then
        return a1.SelectionBehaviorRight
    end
    if a2.Y < 0 then
        return a1.SelectionBehaviorUp
    end
    return a1.SelectionBehaviorDown
end

local function isTrappingGroup(a1, a2) -- Line: 196 -- types: a1: userdata, a2: userdata?
    if not a1.SelectionGroup then
        return false
    end
    if a2 then
        local SelectionBehaviorLeft = if not (a2.X < 0) then if not (0 < a2.X) then if not (a2.Y < 0) then a1.SelectionBehaviorDown else a1.SelectionBehaviorUp else a1.SelectionBehaviorRight else a1.SelectionBehaviorLeft
        return SelectionBehaviorLeft == Enum.SelectionBehavior.Stop
    end
    local v1 = true
    if a1.SelectionBehaviorUp ~= Enum.SelectionBehavior.Stop then
        v1 = true
        if a1.SelectionBehaviorDown ~= Enum.SelectionBehavior.Stop then
            v1 = true
            if a1.SelectionBehaviorLeft ~= Enum.SelectionBehavior.Stop then
                v1 = a1.SelectionBehaviorRight == Enum.SelectionBehavior.Stop
            end
        end
    end
    return v1
end

local function getLayer(a1, a2) -- Line: 212
    -- upvalues: MenuState (val), isTrappingGroup (val)
    local v1 = MenuState.GetMenuFrame()
    local Parent = a1.Parent
    while Parent do
        if Parent:IsA("LayerCollector") then
            return Parent
        end
        if Parent:IsA("GuiObject") then
            if isTrappingGroup(Parent, a2) then
                return Parent
            end
            if v1 and Parent.Parent == v1 then
                return Parent
            end
        end
        Parent = Parent.Parent
    end
    return nil
end

local function isFallbackDisabled(a1) -- Line: 234 -- types: a1: userdata
    local Parent = a1
    while Parent do
        if Parent:IsA("LayerCollector") then
            break
        end
        if Parent:GetAttribute("GamepadNavigationNoFallback") == true then
            return true
        end
        Parent = Parent.Parent
    end
    local v1 = false
    if Parent ~= nil then
        v1 = Parent:GetAttribute("GamepadNavigationNoFallback") == true
    end
    return v1
end

local function scrollIntoView(a1) -- Line: 252 -- types: a1: userdata
    local AbsolutePosition, AbsoluteWindowSize, CanvasPosition, X, X_2, X_3, Y_2, Y_3, Y_4, shift, v1, v2, v3, v4, v5
    local Parent = a1.Parent
    local v6 = a1
    while Parent do
        if Parent:IsA("LayerCollector") then
            break
        end
        if Parent:IsA("ScrollingFrame") then
            AbsolutePosition = Parent.AbsolutePosition
            AbsoluteWindowSize = Parent.AbsoluteWindowSize
            v2 = v6.AbsolutePosition - AbsolutePosition
            v3 = v2 + v6.AbsoluteSize

            function shift(a1, a2, a3) -- Line: 263 -- types: a1: number, a2: number, a3: number
                if a1 < 0 then
                    return a1
                end
                if a3 < a2 then
                    return (math.min(a2 - a3, a1))
                end
                return 0
            end

            X = v2.X
            X_2 = v3.X
            X_3 = AbsoluteWindowSize.X
            v4 = if X < 0 then X else if not (X_3 < X_2) then 0 else math.min(X_2 - X_3, X)
            Y_2 = v2.Y
            Y_3 = v3.Y
            Y_4 = AbsoluteWindowSize.Y
            v5 = if Y_2 < 0 then Y_2 else if not (Y_4 < Y_3) then 0 else math.min(Y_3 - Y_4, Y_2)
            if v4 ~= 0 or v5 ~= 0 then
                CanvasPosition = Parent.CanvasPosition
                v1 = Parent.AbsoluteCanvasSize - AbsoluteWindowSize
                Parent.CanvasPosition = Vector2.new(
                    math.clamp(CanvasPosition.X + v4, 0, (math.max(0, v1.X))),
                    (math.clamp(CanvasPosition.Y + v5, 0, (math.max(0, v1.Y))))
                )
            end
        end
        Parent = Parent.Parent
    end
end

local function setSelection(a1) -- Line: 291 -- upvalues: scrollIntoView (val), GuiService (val) -- types: a1: userdata?
    if a1 then
        scrollIntoView(a1)
    end
    if GuiService.SelectedObject == a1 then
        return true
    end
    return pcall(function() -- Line: 298 -- upvalues: GuiService (upval), a1 (val)
        GuiService.SelectedObject = a1
        return
    end) and GuiService.SelectedObject == a1
end

local function getNextSelectionProperty(a1) -- Line: 307 -- types: a1: userdata
    if a1.X ~= 0 then
        if a1.X < 0 then
            return "NextSelectionLeft"
        end
        return "NextSelectionRight"
    end
    if a1.Y < 0 then
        return "NextSelectionUp"
    end
    return "NextSelectionDown"
end

local function navigateFallback(a1, a2) -- Line: 317
    -- upvalues: GuiService (val), isUsable (val), UserInputService (val), isFallbackDisabled (val), u98 (ref)
    -- upvalues: u101 (ref), u99 (ref), u0 (val), getLayer (val), scrollIntoView (val)
    local SelectedObject = GuiService.SelectedObject
    local u8 = if not isUsable(SelectedObject) then nil else SelectedObject
    if u8 and not GuiService.MenuIsOpen and not UserInputService:GetFocusedTextBox() then
        if u8[if a1.X == 0 then if not (a1.Y < 0) then "NextSelectionDown" else "NextSelectionUp" else if not (a1.X < 0) then "NextSelectionRight" else "NextSelectionLeft"] == nil
            and not isFallbackDisabled(u8) then
            local u33 = os.clock()
            task.delay(0.06, function() -- Line: 327
                -- upvalues: GuiService (upval), u8 (val), u98 (upval), a2 (val), u101 (upval), u99 (upval), u33 (val)
                -- upvalues: u0 (upval), getLayer (upval), a1 (val), isUsable (upval), scrollIntoView (upval)
                if GuiService.SelectedObject == u8 then
                    local v1 = u98
                    if not (a2 - 0.05 <= v1) and not GuiService.MenuIsOpen and not u101 then
                        v1 = u99
                        if not (u33 < v1) and u0.IsGamepadActive() then
                            local v2, v3, v4
                            v1 = getLayer(u8, a1)
                            if not v1 then
                                return
                            end
                            local v5 = u8.AbsolutePosition + u8.AbsoluteSize / 2
                            u83 = nil
                            local v6 = (1 / 0)
                            for i, j in v1:GetDescendants() do
                                if j ~= u8 and j:IsA("GuiObject") and not j:IsA("ScrollingFrame") and isUsable(j) then
                                    v4 = j.AbsolutePosition + j.AbsoluteSize / 2 - v5
                                    v2 = v4:Dot(a1)
                                    if not (v2 <= 1) then
                                        v3 = v2 + (v4 - a1 * v2).Magnitude * 2
                                        if v3 < v6 then
                                            local u83 = j
                                        end
                                    end
                                end
                            end
                            if u83 then
                                if u83 then
                                    scrollIntoView(u83)
                                end
                                if GuiService.SelectedObject == u83 then
                                    return
                                end
                                if pcall(function() -- Line: 298 -- upvalues: GuiService (upval), u83 (val)
                                        GuiService.SelectedObject = u83
                                        return
                                    end)
                                    and GuiService.SelectedObject == u83 then end
                            end
                            return
                        end
                    end
                end
            end)
            return
        end
        return
    end
end

local function refreshCameraStickHold() -- Line: 387
    -- upvalues: MenuState (val), isEffectivelyVisible (val), u95 (ref), ContextActionService (val), GuiService (val)
    -- upvalues: isUsable (val), u101 (ref), u71 (val), Thumbstick2 (val)
    local v1 = MenuState.GetMenuFrame()
    local v2 = false
    if v1 ~= nil then
        v2 = isEffectivelyVisible(v1)
    end
    if v2 == u95 then
        return
    end
    u95 = v2
    if not v2 then
        ContextActionService:UnbindAction("GamepadNavigationMenuCameraStick")
        return
    end
    ContextActionService:BindActionAtPriority("GamepadNavigationMenuCameraStick", function(a1, a2, a3) -- Line: 401 -- upvalues: GuiService (upval), isUsable (upval), u101 (upval) -- types: a3: userdata
        if a2 ~= Enum.UserInputState.End
            and a2 ~= Enum.UserInputState.Cancel
            and not (a3.Position.Magnitude < 0.1) then
            local SelectedObject = GuiService.SelectedObject
            if (if not isUsable(SelectedObject) then nil else SelectedObject) == nil and not u101 then
                return Enum.ContextActionResult.Pass
            end
            return Enum.ContextActionResult.Sink
        end
        return Enum.ContextActionResult.Pass
    end, false, u71, Thumbstick2)
end

local function getMaxCanvas(a1, a2) -- Line: 421 -- types: a1: userdata, a2: string
    local AbsoluteCanvasSize = a1.AbsoluteCanvasSize
    local AbsoluteWindowSize = a1.AbsoluteWindowSize
    return (math.max(0, if a2 ~= "X" then AbsoluteCanvasSize.Y - AbsoluteWindowSize.Y else AbsoluteCanvasSize.X - AbsoluteWindowSize.X))
end

local function canScrollAlong(a1, a2) -- Line: 429
    -- upvalues: isEffectivelyVisible (val)
    local ScrollingDirection = a1.ScrollingDirection
    local v1 = true
    if ScrollingDirection ~= Enum.ScrollingDirection.XY then
        v1 = ScrollingDirection == (if a2 ~= "X" then Enum.ScrollingDirection.Y else Enum.ScrollingDirection.X)
    end
    local ScrollingEnabled = a1.ScrollingEnabled
    if ScrollingEnabled then
        ScrollingEnabled = v1
        if ScrollingEnabled then
            ScrollingEnabled = false
            local AbsoluteCanvasSize = a1.AbsoluteCanvasSize
            local AbsoluteWindowSize = a1.AbsoluteWindowSize
            local v2 = if a2 ~= "X" then AbsoluteCanvasSize.Y - AbsoluteWindowSize.Y else AbsoluteCanvasSize.X - AbsoluteWindowSize.X
            if 1 < math.max(0, v2) then
                ScrollingEnabled = isEffectivelyVisible(a1)
            end
        end
    end
    return ScrollingEnabled
end

local function getStickAxis() -- Line: 439 -- upvalues: zero (ref)
    local v1 = math.abs(zero.X)
    local v2 = math.abs(zero.Y)
    if v2 > 0.3 and v1 <= v2 then
        return "Y"
    end
    if v1 > 0.3 and v2 < v1 then
        return "X"
    end
    return nil
end

local function findTallestList(a1) -- Line: 451 -- upvalues: canScrollAlong (val) -- types: a1: userdata
    local v1 = nil
    for i, j in a1:GetDescendants() do
        if j:IsA("ScrollingFrame") and canScrollAlong(j, "Y") then
            if not v1 or v1.AbsoluteWindowSize.Y < j.AbsoluteWindowSize.Y then
                v1 = j
            end
        end
    end
    return v1
end

local function getOpenScreenOutside(a1) -- Line: 468
    -- upvalues: MenuState (val), isEffectivelyVisible (val)
    local v1 = MenuState.GetMenuFrame()
    local v2 = MenuState.GetCurrentScreen()
    if v1 and v2 then
        local v3 = false
        if a1 ~= nil then
            v3 = true
            if a1 ~= v1 then
                v3 = a1:IsDescendantOf(v1)
            end
        end
        if v3 then
            v3 = v1:FindFirstChild(v2)
            if v3 and v3:IsA("GuiObject") and isEffectivelyVisible(v3) then
                local v4 = false
                if a1 ~= nil then
                    v4 = true
                    if a1 ~= v3 then
                        v4 = a1:IsDescendantOf(v3)
                    end
                end
                if not v4 then
                    return v3
                end
            end
            return nil
        end
    end
    return nil
end

local function getStickScrollFrame(a1) -- Line: 484
    -- upvalues: GuiService (val), isUsable (val), canScrollAlong (val), isFallbackDisabled (val), getLayer (val)
    -- upvalues: findTallestList (val), getOpenScreenOutside (val)
    local v1
    local SelectedObject = GuiService.SelectedObject
    if not (if not isUsable(SelectedObject) then nil else SelectedObject) then
        return nil
    end
    local Parent = v1.Parent
    local v2 = a1
    while Parent do
        if Parent:IsA("LayerCollector") then
            break
        end
        if Parent:IsA("ScrollingFrame") and canScrollAlong(Parent, v2) then
            return Parent
        end
        Parent = Parent.Parent
    end
    if v2 ~= "X" and not isFallbackDisabled(v1) then
        local v3 = getLayer(v1)
        local v4 = v3 and findTallestList(v3)
        if v4 then
            return v4
        end
        local v5 = getOpenScreenOutside(v1)
        return v5 and findTallestList(v5)
    end
    return nil
end

local function canStartStickScroll() -- Line: 517
    -- upvalues: u0 (val), GuiService (val), isUsable (val), UserInputService (val), MenuState (val)
    local v1 = u0.IsGamepadActive()
    if v1 then
        v1 = false
        local SelectedObject = GuiService.SelectedObject
        if (if not isUsable(SelectedObject) then nil else SelectedObject) ~= nil then
            v1 = not GuiService.MenuIsOpen and not UserInputService:GetFocusedTextBox() and not MenuState.IsInspectActive() and not MenuState.IsCaseSceneActive()
        end
    end
    return v1
end

local function isInView(a1, a2) -- Line: 529 -- types: a1: userdata, a2: userdata
    local AbsolutePosition = a2.AbsolutePosition
    local v1 = AbsolutePosition + a2.AbsoluteWindowSize
    local AbsolutePosition_2 = a1.AbsolutePosition
    local v2 = AbsolutePosition_2 + a1.AbsoluteSize
    local v3 = false
    local X = AbsolutePosition_2.X
    if AbsolutePosition.X - 1 <= X then
        v3 = false
        local Y = AbsolutePosition_2.Y
        if AbsolutePosition.Y - 1 <= Y then
            v3 = false
            if v2.X <= v1.X + 1 then
                v3 = v2.Y <= v1.Y + 1
            end
        end
    end
    return v3
end

local function findButtonInView(a1, a2, a3) -- Line: 544
    -- upvalues: isUsable (val)
    local AbsolutePosition, AbsolutePosition_2, Magnitude, X, Y, v1, v2, v3, v4
    local v5 = a1.AbsolutePosition + a1.AbsoluteWindowSize / 2
    local v6 = v5
    if a2 then
        v4 = false
        if a2 ~= nil then
            v4 = true
            if a2 ~= a1 then
                v4 = a2:IsDescendantOf(a1)
            end
        end
        if v4 then
            v4 = a2.AbsolutePosition + a2.AbsoluteSize / 2
            v6 = if a3 ~= "Y" then Vector2.new(v5.X, v4.Y) else Vector2.new(v4.X, v5.Y)
        end
    end
    v4 = nil
    local v7 = (1 / 0)
    for i, j in a1:GetDescendants() do
        if j:IsA("GuiObject") and not j:IsA("ScrollingFrame") and not j:IsA("TextBox") and isUsable(j) then
            AbsolutePosition = a1.AbsolutePosition
            v2 = AbsolutePosition + a1.AbsoluteWindowSize
            AbsolutePosition_2 = j.AbsolutePosition
            v3 = AbsolutePosition_2 + j.AbsoluteSize
            v1 = false
            X = AbsolutePosition_2.X
            if AbsolutePosition.X - 1 <= X then
                v1 = false
                Y = AbsolutePosition_2.Y
                if AbsolutePosition.Y - 1 <= Y then
                    v1 = false
                    if v3.X <= v2.X + 1 then
                        v1 = v3.Y <= v2.Y + 1
                    end
                end
            end
            if v1 then
                Magnitude = (j.AbsolutePosition + j.AbsoluteSize / 2 - v6).Magnitude
                if Magnitude < v7 then
                    v4 = j
                end
            end
        end
    end
    return v4
end

local function startStickScroll(a1, a2) -- Line: 576
    -- upvalues: u101 (ref), u102 (ref), zero_2 (ref), u104 (ref), GuiService (val), ContextActionService (val)
    -- upvalues: u71 (val)
    u101 = a1
    u102 = a2
    zero_2 = a1.CanvasPosition
    u104 = os.clock()
    GuiService.GuiNavigationEnabled = false
    local v1 = ContextActionService
    local v2 = u71
    local Thumbstick1 = Enum.KeyCode.Thumbstick1
    local ButtonA = Enum.KeyCode.ButtonA
    v1:BindActionAtPriority("GamepadNavigationStickScrollSink", function() -- Line: 583
        return Enum.ContextActionResult.Sink
    end, false, v2, Thumbstick1, ButtonA)
end

local function stopStickScroll() -- Line: 590
    -- upvalues: u101 (ref), GuiService (val), ContextActionService (val), u0 (val), u99 (ref), u104 (ref), zero_2 (ref)
    -- upvalues: isUsable (val), findButtonInView (val), u102 (ref), scrollIntoView (val)
    local v1 = u101
    u101 = nil
    GuiService.GuiNavigationEnabled = true
    ContextActionService:UnbindAction("GamepadNavigationStickScrollSink")
    if not v1 then
        return
    end
    if u0.IsGamepadActive() then
        local v2 = u99
        if not (u104 < v2) and not ((v1.CanvasPosition - zero_2).Magnitude < 1) then
            local SelectedObject = GuiService.SelectedObject
            v2 = if not isUsable(SelectedObject) then nil else SelectedObject
            if v2 then
                local v3 = false
                if v2 ~= nil then
                    v3 = true
                    if v2 ~= v1 then
                        v3 = v2:IsDescendantOf(v1)
                    end
                end
                if v3 then
                    local AbsolutePosition = v1.AbsolutePosition
                    local v4 = AbsolutePosition + v1.AbsoluteWindowSize
                    local AbsolutePosition_2 = v2.AbsolutePosition
                    local v5 = AbsolutePosition_2 + v2.AbsoluteSize
                    v3 = false
                    local X = AbsolutePosition_2.X
                    if AbsolutePosition.X - 1 <= X then
                        v3 = false
                        local Y = AbsolutePosition_2.Y
                        if AbsolutePosition.Y - 1 <= Y then
                            v3 = false
                            if v5.X <= v4.X + 1 then
                                v3 = v5.Y <= v4.Y + 1
                            end
                        end
                    end
                    if v3 then
                        return
                    end
                end
            end
            local u69 = findButtonInView(v1, v2, u102)
            if u69 then
                u99 = os.clock()
                if u69 then
                    scrollIntoView(u69)
                end
                if GuiService.SelectedObject == u69 then
                    return
                end
                if pcall(function() -- Line: 298 -- upvalues: GuiService (upval), u69 (val)
                        GuiService.SelectedObject = u69
                        return
                    end)
                    and GuiService.SelectedObject == u69 then end
            end
            return
        end
    end
end

local function updateStickScroll(a1) -- Line: 624
    -- upvalues: u101 (ref), u102 (ref), u0 (val), GuiService (val), MenuState (val), canScrollAlong (val), zero (ref)
    -- upvalues: stopStickScroll (val)
    local u1 = u101
    if not u1 then
        return
    end
    local u2 = u102
    local success, result = pcall(function() -- Line: 633
        -- upvalues: u0 (upval), GuiService (upval), MenuState (upval), canScrollAlong (upval), u1 (val), u2 (val)
        return u0.IsGamepadActive() and not GuiService.MenuIsOpen and not MenuState.IsInspectActive() and canScrollAlong(u1, u2)
    end)
    local v1 = math.abs(zero.X)
    local v2 = math.abs(zero.Y)
    if (if not (v2 > 0.3) then if not (v1 > 0.3) then nil else if not (v2 < v1) then nil else "X" else if not (v1 <= v2) then if not (v1 > 0.3) then nil else if not (v2 < v1) then nil else "X" else "Y") == u2
        and success
        and result then
        local Y_2
        v1 = math.clamp((math.abs(if u2 ~= "Y" then zero.X else zero.Y) - 0.3) / 0.7, 0, 1)
        local AbsoluteWindowSize = u1.AbsoluteWindowSize
        local v3 = math.sign(Y_2) * v1 * v1 * 1.6
        local Y_3 = if u2 ~= "Y" then AbsoluteWindowSize.X else AbsoluteWindowSize.Y
        local v4 = v3 * Y_3 * a1
        local CanvasPosition = u1.CanvasPosition
        local AbsoluteCanvasSize = u1.AbsoluteCanvasSize
        local AbsoluteWindowSize_2 = u1.AbsoluteWindowSize
        v3 = math.max(0, if u2 ~= "X" then AbsoluteCanvasSize.Y - AbsoluteWindowSize_2.Y else AbsoluteCanvasSize.X - AbsoluteWindowSize_2.X)
        local v5 = if u2 ~= "Y" then Vector2.new(math.clamp(CanvasPosition.X + v4, 0, v3), CanvasPosition.Y) else Vector2.new(CanvasPosition.X, (math.clamp(CanvasPosition.Y - v4, 0, v3)))
        u1.CanvasPosition = v5
        return
    end
    stopStickScroll()
end

function u0.IsGamepadActive() -- Line: 664 -- upvalues: UserInputService (val), u36 (val), u53 (val)
    local LastInputType = UserInputService:GetLastInputType()
    if u36[LastInputType] == true then
        return true
    end
    return not u53[LastInputType] and UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
end

u0.IsUsable = isUsable
u0.ScrollIntoView = scrollIntoView

function u0.FindFirstSelectable(a1) -- Line: 680 -- upvalues: isUsable (val) -- types: a1: userdata
    local AbsolutePosition, v1
    local v2 = nil
    local v3 = (1 / 0)
    for i, j in a1:GetDescendants() do
        if j:IsA("GuiObject") and not j:IsA("ScrollingFrame") and isUsable(j) then
            AbsolutePosition = j.AbsolutePosition
            v1 = math.floor(AbsolutePosition.Y / 8) * 100000 + AbsolutePosition.X
            if j:IsA("TextBox") then
                v1 = v1 + 1000000000
            end
            if v1 < v3 then
                v2 = j
            end
        end
    end
    return v2
end

function u0.Focus(a1) -- Line: 706
    -- upvalues: u0 (val), isUsable (val), u99 (ref), scrollIntoView (val), GuiService (val)
    if a1 and u0.IsGamepadActive() then
        local u16 = if not isUsable(a1) then u0.FindFirstSelectable(a1) else if a1:IsA("ScrollingFrame") then u0.FindFirstSelectable(a1) else a1
        if not u16 then
            return false
        end
        u99 = os.clock()
        if u16 then
            scrollIntoView(u16)
        end
        if GuiService.SelectedObject == u16 then
            return true
        end
        return pcall(function() -- Line: 298 -- upvalues: GuiService (upval), u16 (val)
            GuiService.SelectedObject = u16
            return
        end) and GuiService.SelectedObject == u16
    end
    return false
end

function u0.TrapPopup(a1, a2) -- Line: 730
    -- upvalues: GuiService (val), u0 (val), isUsable (val)
    a1.SelectionGroup = true
    a1.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
    a1.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
    a1.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
    a1.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
    local u7 = nil

    local function onVisibilityChanged() -- Line: 739
        -- upvalues: a1 (val), GuiService (upval), u7 (ref), a2 (val), u0 (upval), isUsable (upval)
        local v1, v2
        if a1.Visible and a1.Parent then
            local v3
            local SelectedObject = GuiService.SelectedObject
            if not SelectedObject then
                v3 = nil
            else
                v2 = a1
                v1 = false
                if SelectedObject ~= nil then
                    v1 = true
                    if SelectedObject ~= v2 then
                        v1 = SelectedObject:IsDescendantOf(v2)
                    end
                end
                v3 = if v1 then nil else SelectedObject
            end
            u7 = v3
            task.defer(function() -- Line: 744 -- upvalues: a1 (upval), GuiService (upval), a2 (upval), u0 (upval)
                if a1.Visible and a1.Parent then
                    local SelectedObject = GuiService.SelectedObject
                    local v1 = a1
                    local v2 = false
                    if SelectedObject ~= nil then
                        v2 = true
                        if SelectedObject ~= v1 then
                            v2 = SelectedObject:IsDescendantOf(v1)
                        end
                    end
                    if not v2 then
                        v2 = a2 and a2()
                        if not v2 or not u0.Focus(v2) then
                            u0.Focus(a1)
                        end
                    end
                end
            end)
            return
        end
        local v4 = u7
        u7 = nil
        local SelectedObject_2 = GuiService.SelectedObject
        if SelectedObject_2 ~= nil then
            v2 = a1
            v1 = false
            if SelectedObject_2 ~= nil then
                v1 = true
                if SelectedObject_2 ~= v2 then
                    v1 = SelectedObject_2:IsDescendantOf(v2)
                end
            end
            if v1 then
                if isUsable(v4) then
                    u0.Focus(v4)
                end
            elseif not isUsable(SelectedObject_2) and isUsable(v4) then
                u0.Focus(v4)
            end
        elseif isUsable(v4) then
            u0.Focus(v4)
        end
    end

    ;(a1:GetPropertyChangedSignal("Visible")):Connect(onVisibilityChanged)
    a1.AncestryChanged:Connect(function() -- Line: 766 -- upvalues: a1 (val), u7 (ref), onVisibilityChanged (val)
        if a1.Parent == nil and u7 then
            task.defer(onVisibilityChanged)
        end
    end)
    if a1.Visible then
        onVisibilityChanged()
    end
end

function u0.Initialize() -- Line: 779
    -- upvalues: u94 (ref), UserInputService (val), u73 (val), u36 (val), navigateFallback (val), GuiService (val)
    -- upvalues: u98 (ref), u96 (ref), u97 (ref), Thumbstick2 (val), zero (ref), u105 (ref), u101 (ref), u106 (ref)
    -- upvalues: canStartStickScroll (val), getStickScrollFrame (val), startStickScroll (val), RunService (val)
    -- upvalues: updateStickScroll (val), refreshCameraStickHold (val)
    if u94 then
        return
    end
    u94 = true
    UserInputService.InputBegan:Connect(function(a1) -- Line: 785 -- upvalues: u73 (upval), u36 (upval), navigateFallback (upval) -- types: a1: userdata
        local v1 = u73[a1.KeyCode]
        if v1 then
            local UserInputType = a1.UserInputType
            if u36[UserInputType] == true then
                navigateFallback(v1, os.clock())
            end
        end
    end)
    ;(GuiService:GetPropertyChangedSignal("SelectedObject")):Connect(function() -- Line: 792 -- upvalues: u98 (upval)
        u98 = os.clock()
    end)
    UserInputService.InputChanged:Connect(function(a1) -- Line: 796
        -- upvalues: u96 (upval), u97 (upval), navigateFallback (upval), Thumbstick2 (upval), zero (upval), u105 (upval)
        -- upvalues: u101 (upval), u106 (upval), canStartStickScroll (upval), getStickScrollFrame (upval)
        -- upvalues: startStickScroll (upval)
        local v1, v2, v3
        if a1.KeyCode == Enum.KeyCode.Thumbstick1 then
            v1 = Vector2.new(a1.Position.X, a1.Position.Y)
            if v1.Magnitude <= 0.2 then
                u96 = false
                u97 = nil
                return
            end
            v2 = u97 or os.clock()
            u97 = v2
            if not u96 and 0.8 <= v1.Magnitude then
                u96 = true
                v3 = navigateFallback
                local v4 = math.abs(v1.X)
                v3(if not (math.abs(v1.Y) < v4) then Vector2.new(0, -math.sign(v1.Y)) else Vector2.new(math.sign(v1.X), 0), v2)
            end
            return
        end
        if a1.KeyCode ~= Thumbstick2 then
            return
        end
        zero = Vector2.new(a1.Position.X, a1.Position.Y)
        v2 = math.abs(zero.X)
        v3 = math.abs(zero.Y)
        if not (if not (v3 > 0.3) then if not (v2 > 0.3) then nil else if not (v3 < v2) then nil else "X" else if not (v2 <= v3) then if not (v2 > 0.3) then nil else if not (v3 < v2) then nil else "X" else "Y") then
            u105 = nil
            return
        end
        if not u101 then
            if v1 == u105 then
                v2 = os.clock() - u106
                if v2 > 0.25 and canStartStickScroll() then
                    v2 = os.clock()
                    u105 = v1
                    u106 = v2
                    v2 = getStickScrollFrame(v1)
                    if v2 then
                        startStickScroll(v2, v1)
                    end
                end
            elseif canStartStickScroll() then
                v2 = os.clock()
                u105 = v1
                u106 = v2
                v2 = getStickScrollFrame(v1)
                if v2 then
                    startStickScroll(v2, v1)
                end
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(a1) -- Line: 842
        -- upvalues: u96 (upval), u97 (upval), Thumbstick2 (upval), zero (upval), u105 (upval)
        if a1.KeyCode == Enum.KeyCode.Thumbstick1 then
            u96 = false
            u97 = nil
            return
        end
        if a1.KeyCode == Thumbstick2 then
            zero = Vector2.zero
            u105 = nil
        end
    end)
    UserInputService.GamepadDisconnected:Connect(function() -- Line: 852 -- upvalues: zero (upval), u105 (upval), u96 (upval), u97 (upval)
        zero = Vector2.zero
        u105 = nil
        u96 = false
        u97 = nil
    end)
    RunService.RenderStepped:Connect(updateStickScroll)
    task.spawn(function() -- Line: 863 -- upvalues: refreshCameraStickHold (upval)
        while true do
            refreshCameraStickHold()
            task.wait(0.25)
        end
    end)
end

return u0