-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
local GuiInset = GuiService:GetGuiInset();
local Signal = require(script.Parent.Parent.Parent.Parent.Parent.Shared.Signal);
local u1 = {
    internal = {},
    prototype = {},
    interface = {}
};

function u1.internal.createWidgetRepresentation(p2: any, p3: userdata) -- Line: 17
    local v4 = p2.WidgetScreenGui:GetChildren()[1];
    local TextButton = Instance.new("TextButton");
    TextButton.Name = p2.WidgetName;
    TextButton.AutoLocalize = false;
    TextButton.Size = UDim2.fromOffset(60, 30);
    TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    TextButton.BackgroundTransparency = 0.5;
    TextButton.BorderSizePixel = 0;
    TextButton.Text = "";
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0, 4);
    UICorner.Parent = TextButton;
    p2.FrameRepresentation = TextButton;
    p2.BoundingInstance = v4;
    TextButton.Parent = p3;
end;

function u1.internal.observeWidgetChanges(u5) -- Line: 40
    -- upvalues: GuiInset (copy), UserInputService (copy)
    local FrameRepresentation = u5.FrameRepresentation;
    u5.MouseInteractionConnection = FrameRepresentation.MouseButton1Down:Connect(function() -- Line: 43
        -- upvalues: FrameRepresentation (copy), GuiInset (ref), UserInputService (ref), u5 (copy)
        local v6 = FrameRepresentation.AbsolutePosition + GuiInset;
        local v7 = UserInputService:GetMouseLocation() - v6;
        local Vector2_new_ret = Vector2.new(math.floor(v7.X), (math.floor(v7.Y)));
        u5.Activated:Fire(Vector2_new_ret);
    end);
    u5.AbsolutePositionChangedConnection = u5.BoundingInstance:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- Line: 54
        -- upvalues: u5 (copy)
        u5:UpdateRepresentation();
    end);
    u5.AbsoluteSizeChangedConnection = u5.BoundingInstance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 60
        -- upvalues: u5 (copy)
        u5:UpdateRepresentation();
    end);
    u5:UpdateRepresentation();
end;

function u1.prototype.UpdateRepresentation(p8) -- Line: 67
    -- upvalues: GuiInset (copy)
    local AbsoluteSize = p8.FrameRepresentation.Parent.AbsoluteSize;
    local ViewportSize = workspace.CurrentCamera.ViewportSize;
    local v9 = AbsoluteSize * ((p8.BoundingInstance.AbsolutePosition + GuiInset) / ViewportSize);
    local v10 = AbsoluteSize * (p8.BoundingInstance.AbsoluteSize / ViewportSize);
    p8.FrameRepresentation.Position = UDim2.fromOffset(v9.X, v9.Y);
    p8.FrameRepresentation.Size = UDim2.fromOffset(v10.X, v10.Y);
end;

function u1.prototype.Destroy(p11) -- Line: 83
    p11.MouseInteractionConnection:Disconnect();
    p11.AbsolutePositionChangedConnection:Disconnect();
    p11.AbsoluteSizeChangedConnection:Disconnect();
    p11.FrameRepresentation:Destroy();
    p11.Activated:Destroy();
end;

function u1.interface.new(p12: string, p13: userdata, p14: userdata) -- Line: 92
    -- upvalues: Signal (copy), u1 (copy)
    local v15 = type(p12) == "string";
    local v16 = `Expected parameter #1 'widgetName' to be a string, got {type(p12)}`;
    assert(v15, v16);
    local v17 = {
        WidgetName = p12,
        WidgetScreenGui = p13,
        Activated = Signal.new()
    };
    local v18 = setmetatable(v17, {
        __index = u1.prototype
    });
    u1.internal.createWidgetRepresentation(v18, p14);
    u1.internal.observeWidgetChanges(v18);

    return v18;
end;

return u1.interface;