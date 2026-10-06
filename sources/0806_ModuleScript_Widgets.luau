-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local Parent = script.Parent.Parent.Parent;
local Tab = require(Parent.Tab);
local Widget = require(Parent.Widget);
local script_WidgetVisual = require(script.WidgetVisual);
local script_WidgetsList = require(script.WidgetsList);
local u1 = {
    internal = {
        DraggedWidgetVisual = false,
        ActiveInputEndedConnection = nil,
        ActiveInputChangedConnection = nil,
        CurrentCameraChangedConnection = nil,
        CurrentViewportSizeChangedConnection = nil,
        WidgetVisuals = {},
        FakeScreen = {}
    }
};

function u1.internal.createWidgetRepresentation(p2: string, p3: userdata) -- Line: 38
    -- upvalues: script_WidgetVisual (copy), u1 (copy)
    local v4 = script_WidgetVisual.new(p2, p3, u1.internal.FakeScreen.ScreenFrame);
    table.insert(u1.internal.WidgetVisuals, {
        WidgetVisual = v4
    });
    u1.internal.listenToWidgetVisualEvents(v4);
end;

function u1.internal.getRegistryWidgetRecord(p5) -- Line: 48
    -- upvalues: u1 (copy)
    for _, v in u1.internal.WidgetVisuals do
        if v.WidgetVisual == p5 then
            return v;
        end;
    end;

    return nil;
end;

function u1.internal.listenToWidgetVisualEvents(u6) -- Line: 58
    -- upvalues: u1 (copy), UserInputService (copy)
    local RegistryWidgetRecord = u1.internal.getRegistryWidgetRecord(u6);

    if not RegistryWidgetRecord then
        return;
    end;

    RegistryWidgetRecord.ActivatedConnection = u6.Activated:Connect(function(u7) -- Line: 64
        -- upvalues: u1 (ref), u6 (copy), UserInputService (ref)
        if u1.internal.DraggedWidgetVisual then
            return;
        end;

        u1.internal.DraggedWidgetVisual = u6;
        u1.internal.ActiveInputChangedConnection = UserInputService.InputChanged:Connect(function(p8: userdata) -- Line: 72
            -- upvalues: u1 (ref), u6 (ref), u7 (copy)
            if p8.UserInputType ~= Enum.UserInputType.MouseMovement and p8.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            local AbsoluteSize = u1.internal.FakeScreen.ScreenFrame.AbsoluteSize;
            local AbsolutePosition = u1.internal.FakeScreen.ScreenFrame.AbsolutePosition;
            local v9 = -(u6.FrameRepresentation.AbsoluteSize * -u6.BoundingInstance.AnchorPoint);
            local v10 = (Vector2.new(p8.Position.X, p8.Position.Y) - AbsolutePosition - u7 + v9) / AbsoluteSize;
            u6.BoundingInstance.Position = UDim2.fromScale(v10.X, v10.Y);
        end);
        u1.internal.ActiveInputEndedConnection = UserInputService.InputEnded:Connect(function(p11: userdata) -- Line: 101
            -- upvalues: u1 (ref)
            if p11.UserInputType ~= Enum.UserInputType.MouseButton1 and p11.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            u1.internal.ActiveInputChangedConnection:Disconnect();
            u1.internal.ActiveInputChangedConnection = nil;
            u1.internal.ActiveInputEndedConnection:Disconnect();
            u1.internal.ActiveInputEndedConnection = nil;
            u1.internal.DraggedWidgetVisual = nil;
        end);
    end);
end;

function u1.internal.listenToCurrentCameraViewportChanges() -- Line: 121
    -- upvalues: u1 (copy)
    if u1.internal.CurrentViewportSizeChangedConnection then
        u1.internal.CurrentViewportSizeChangedConnection:Disconnect();
    end;

    u1.internal.CurrentViewportSizeChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 128
        -- upvalues: u1 (ref)
        local ViewportSize = workspace.CurrentCamera.ViewportSize;

        if not u1.internal.FakeScreen then
            return;
        end;

        u1.internal.FakeScreen.ScreenFrameAspectRatio.AspectRatio = ViewportSize.X / ViewportSize.Y;
    end);
end;

function u1.internal.createWidgetInterface(p12: userdata) -- Line: 139
    -- upvalues: u1 (copy)
    local ViewportSize = workspace.CurrentCamera.ViewportSize;
    local Frame = Instance.new("Frame");
    Frame.Name = "Fake Screen";
    Frame.Position = UDim2.fromScale(0, 0.5);
    Frame.Size = UDim2.fromScale(0.75, 1);
    Frame.AnchorPoint = Vector2.new(0, 0.5);
    Frame.BackgroundColor3 = Color3.fromRGB(79, 88, 105);
    Frame.BorderSizePixel = 0;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = ViewportSize.X / ViewportSize.Y;
    UIAspectRatioConstraint.Parent = Frame;
    Frame.Parent = p12;
    u1.internal.FakeScreen = {
        ScreenFrame = Frame,
        ScreenFrameAspectRatio = UIAspectRatioConstraint,
        AbsoluteSizeChangedConnection = Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 163
            -- upvalues: u1 (ref)
            for _, v in u1.internal.WidgetVisuals do
                v.WidgetVisual:UpdateRepresentation();
            end;
        end)
    };
end;

function u1.internal.MountInterface(p13: table, p14: userdata) -- Line: 171
    -- upvalues: u1 (copy), script_WidgetsList (copy), Widget (copy)
    u1.internal.createWidgetInterface(p14);
    u1.internal.WidgetsListDestructor = script_WidgetsList(p14);

    for i, v in Widget:GetAll() do
        if v.Mounted then
            u1.internal.createWidgetRepresentation(i, v.ScreenGui);
        end;
    end;

    u1.internal.WidgetMountedConnection = Widget.WidgetMounted:Connect(function(p15: string, p16: userdata) -- Line: 183
        -- upvalues: u1 (ref)
        u1.internal.createWidgetRepresentation(p15, p16);
    end);
    u1.internal.WidgetUnmountedConnection = Widget.WidgetUnmounted:Connect(function(p17: string) -- Line: 188
        -- upvalues: u1 (ref)
        for i, v in u1.internal.WidgetVisuals do
            if v.WidgetVisual.WidgetName == p17 then
                v.WidgetVisual:Destroy();
                v.ActivatedConnection:Disconnect();
                v.ActivatedConnection = nil;
                table.remove(u1.internal.WidgetVisuals, i);
            end;
        end;
    end);
    u1.internal.CurrentCameraChangedConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 201
        -- upvalues: u1 (ref)
        u1.internal.listenToCurrentCameraViewportChanges();
    end);
    u1.internal.listenToCurrentCameraViewportChanges();
end;

function u1.internal.UnmountInterface(p18) -- Line: 208
    -- upvalues: u1 (copy)
    u1.internal.WidgetMountedConnection:Disconnect();
    u1.internal.WidgetMountedConnection = nil;
    u1.internal.WidgetUnmountedConnection:Disconnect();
    u1.internal.WidgetUnmountedConnection = nil;
    u1.internal.CurrentCameraChangedConnection:Disconnect();
    u1.internal.CurrentCameraChangedConnection = nil;
    u1.internal.CurrentViewportSizeChangedConnection:Disconnect();
    u1.internal.CurrentViewportSizeChangedConnection = nil;
    u1.internal.FakeScreen.AbsoluteSizeChangedConnection:Disconnect();
    u1.internal.FakeScreen.AbsoluteSizeChangedConnection = nil;
    u1.internal.FakeScreen.ScreenFrame:Destroy();
    u1.internal.FakeScreen = {};
    u1.internal.WidgetsListDestructor();
    u1.internal.WidgetsListDestructor = nil;

    for _, v in u1.internal.WidgetVisuals do
        v.WidgetVisual:Destroy();
    end;

    u1.internal.WidgetVisuals = {};
end;

Tab.new("Widgets", function(p19: userdata) -- Line: 237
    -- upvalues: u1 (copy)
    u1.internal:MountInterface(p19);

    return function() -- Line: 240
        -- upvalues: u1 (ref)
        u1.internal:UnmountInterface();
    end;
end);

return nil;