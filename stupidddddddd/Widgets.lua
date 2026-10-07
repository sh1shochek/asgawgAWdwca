-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Widgets
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Widgets
-- Decompile time: 2.69 ms

local UserInputService = game:GetService("UserInputService")
local Parent = script.Parent.Parent.Parent
local Tab = require(Parent.Tab)
local Widget = require(Parent.Widget)
local WidgetVisual = require(script.WidgetVisual)
local WidgetsList = require(script.WidgetsList)
local u23 = {internal = {DraggedWidgetVisual = false, WidgetVisuals = {}, FakeScreen = {}}}

function u23.internal.createWidgetRepresentation(a1, a2) -- Line: 38
    -- upvalues: WidgetVisual (val), u23 (val)
    local v1 = WidgetVisual.new(a1, a2, u23.internal.FakeScreen.ScreenFrame)
    table.insert(u23.internal.WidgetVisuals, {WidgetVisual = v1})
    u23.internal.listenToWidgetVisualEvents(v1)
end

function u23.internal.getRegistryWidgetRecord(a1) -- Line: 48 -- upvalues: u23 (val)
    for i, j in u23.internal.WidgetVisuals do
        if j.WidgetVisual == a1 then
            return j
        end
    end
    return nil
end

function u23.internal.listenToWidgetVisualEvents(a1) -- Line: 58 -- upvalues: u23 (val), UserInputService (val)
    local v1 = u23.internal.getRegistryWidgetRecord(a1)
    if not v1 then
        return
    end
    v1.ActivatedConnection = a1.Activated:Connect(function(a1_2) -- Line: 64 -- upvalues: u23 (upval), a1 (val), UserInputService (upval) -- types: a1_2: userdata
        if u23.internal.DraggedWidgetVisual then
            return
        end
        u23.internal.DraggedWidgetVisual = a1
        u23.internal.ActiveInputChangedConnection = UserInputService.InputChanged:Connect(function(a1_3) -- Line: 72 -- upvalues: u23 (upval), a1 (upval), a1_2 (val) -- types: a1_3: userdata
            if a1_3.UserInputType ~= Enum.UserInputType.MouseMovement
                and a1_3.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            local AbsoluteSize = u23.internal.FakeScreen.ScreenFrame.AbsoluteSize
            local AbsolutePosition = u23.internal.FakeScreen.ScreenFrame.AbsolutePosition
            local v1 = -(a1.FrameRepresentation.AbsoluteSize * -a1.BoundingInstance.AnchorPoint)
            local v2 = (Vector2.new(a1_3.Position.X, a1_3.Position.Y) - AbsolutePosition - a1_2 + v1) / AbsoluteSize
            a1.BoundingInstance.Position = UDim2.fromScale(v2.X, v2.Y)
        end)
        u23.internal.ActiveInputEndedConnection = UserInputService.InputEnded:Connect(function(a1) -- Line: 101 -- upvalues: u23 (upval) -- types: a1: userdata
            if a1.UserInputType ~= Enum.UserInputType.MouseButton1
                and a1.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            u23.internal.ActiveInputChangedConnection:Disconnect()
            u23.internal.ActiveInputChangedConnection = nil
            u23.internal.ActiveInputEndedConnection:Disconnect()
            u23.internal.ActiveInputEndedConnection = nil
            u23.internal.DraggedWidgetVisual = nil
        end)
    end)
end

function u23.internal.listenToCurrentCameraViewportChanges() -- Line: 121 -- upvalues: u23 (val)
    if u23.internal.CurrentViewportSizeChangedConnection then
        u23.internal.CurrentViewportSizeChangedConnection:Disconnect()
    end
    u23.internal.CurrentViewportSizeChangedConnection = (workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize")):Connect(function() -- Line: 128 -- upvalues: u23 (upval)
        local ViewportSize = workspace.CurrentCamera.ViewportSize
        if not u23.internal.FakeScreen then
            return
        end
        u23.internal.FakeScreen.ScreenFrameAspectRatio.AspectRatio = ViewportSize.X / ViewportSize.Y
    end)
end

function u23.internal.createWidgetInterface(a1) -- Line: 139 -- upvalues: u23 (val) -- types: a1: userdata
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local Frame = Instance.new("Frame")
    Frame.Name = "Fake Screen"
    Frame.Position = UDim2.fromScale(0, 0.5)
    Frame.Size = UDim2.fromScale(0.75, 1)
    Frame.AnchorPoint = Vector2.new(0, 0.5)
    Frame.BackgroundColor3 = Color3.fromRGB(79, 88, 105)
    Frame.BorderSizePixel = 0
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
    UIAspectRatioConstraint.AspectRatio = ViewportSize.X / ViewportSize.Y
    UIAspectRatioConstraint.Parent = Frame
    Frame.Parent = a1
    u23.internal.FakeScreen = {
        ScreenFrame = Frame,
        ScreenFrameAspectRatio = UIAspectRatioConstraint,
        AbsoluteSizeChangedConnection = (Frame:GetPropertyChangedSignal("AbsoluteSize")):Connect(function() -- Line: 163 -- upvalues: u23 (upval)
            for i, j in u23.internal.WidgetVisuals do
                j.WidgetVisual:UpdateRepresentation()
            end
        end),
    }
end

function u23.internal.MountInterface(a1, a2) -- Line: 171
    -- upvalues: u23 (val), WidgetsList (val), Widget (val)
    u23.internal.createWidgetInterface(a2)
    u23.internal.WidgetsListDestructor = WidgetsList(a2)
    for i, j in Widget:GetAll() do
        if j.Mounted then
            u23.internal.createWidgetRepresentation(i, j.ScreenGui)
        end
    end
    u23.internal.WidgetMountedConnection = Widget.WidgetMounted:Connect(function(a1, a2) -- Line: 183 -- upvalues: u23 (upval) -- types: a1: string, a2: userdata
        u23.internal.createWidgetRepresentation(a1, a2)
    end)
    u23.internal.WidgetUnmountedConnection = Widget.WidgetUnmounted:Connect(function(a1) -- Line: 188 -- upvalues: u23 (upval) -- types: a1: string
        for i, j in u23.internal.WidgetVisuals do
            if j.WidgetVisual.WidgetName == a1 then
                j.WidgetVisual:Destroy()
                j.ActivatedConnection:Disconnect()
                j.ActivatedConnection = nil
                table.remove(u23.internal.WidgetVisuals, i)
            end
        end
    end)
    u23.internal.CurrentCameraChangedConnection = (workspace:GetPropertyChangedSignal("CurrentCamera")):Connect(function() -- Line: 201 -- upvalues: u23 (upval)
        u23.internal.listenToCurrentCameraViewportChanges()
    end)
    u23.internal.listenToCurrentCameraViewportChanges()
end

function u23.internal.UnmountInterface(a1) -- Line: 208 -- upvalues: u23 (val)
    u23.internal.WidgetMountedConnection:Disconnect()
    u23.internal.WidgetMountedConnection = nil
    u23.internal.WidgetUnmountedConnection:Disconnect()
    u23.internal.WidgetUnmountedConnection = nil
    u23.internal.CurrentCameraChangedConnection:Disconnect()
    u23.internal.CurrentCameraChangedConnection = nil
    u23.internal.CurrentViewportSizeChangedConnection:Disconnect()
    u23.internal.CurrentViewportSizeChangedConnection = nil
    u23.internal.FakeScreen.AbsoluteSizeChangedConnection:Disconnect()
    u23.internal.FakeScreen.AbsoluteSizeChangedConnection = nil
    u23.internal.FakeScreen.ScreenFrame:Destroy()
    u23.internal.FakeScreen = {}
    u23.internal.WidgetsListDestructor()
    u23.internal.WidgetsListDestructor = nil
    for i, j in u23.internal.WidgetVisuals do
        j.WidgetVisual:Destroy()
    end
    u23.internal.WidgetVisuals = {}
end

Tab.new("Widgets", function(a1) -- Line: 237 -- upvalues: u23 (val) -- types: a1: userdata
    u23.internal:MountInterface(a1)
    return function() -- Line: 240 -- upvalues: u23 (upval)
        u23.internal:UnmountInterface()
    end
end)
return nil