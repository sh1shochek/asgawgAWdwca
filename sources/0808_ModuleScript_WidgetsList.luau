-- Decompiled with Potassium's decompiler.

local Widget = require(script.Parent.Parent.Parent.Parent.Widget);
local Color3_fromRGB_ret = Color3.fromRGB(183, 241, 77);
local Color3_fromRGB_ret2 = Color3.fromRGB(132, 156, 137);
local Color3_fromRGB_ret3 = Color3.fromRGB(241, 77, 77);
local Color3_fromRGB_ret4 = Color3.fromRGB(147, 115, 137);

local function createWidgetButton(u1: string, p2: userdata) -- Line: 11
    -- upvalues: Widget (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret3 (copy)
    local v3 = Widget:IsVisible(u1);
    local TextButton = Instance.new("TextButton");
    TextButton.Name = u1;
    TextButton.AutoLocalize = false;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextButton.Text = ` {u1}`;
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton.TextSize = 12;
    TextButton.TextStrokeTransparency = 0;
    TextButton.TextXAlignment = Enum.TextXAlignment.Left;
    TextButton.BackgroundColor3 = v3 and Color3_fromRGB_ret2 or Color3_fromRGB_ret4;
    TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0);
    TextButton.BorderSizePixel = 0;
    TextButton.Size = UDim2.new(1, 0, 0, 18);
    local u4 = TextButton.Activated:Connect(function() -- Line: 29
        -- upvalues: Widget (ref), u1 (copy)
        Widget:SwitchVisibility(u1);
    end);
    local Frame = Instance.new("Frame");
    Frame.Name = "Frame";
    Frame.AnchorPoint = Vector2.new(0, 0.5);
    Frame.BackgroundColor3 = v3 and Color3_fromRGB_ret or Color3_fromRGB_ret3;
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.new(1, -12, 0.5, 0);
    Frame.Size = UDim2.new(0, 100, 0.3, 0);
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(81, 88, 104);
    UIStroke.Parent = Frame;
    Frame.Parent = TextButton;
    TextButton.Parent = p2;
    local u6 = Widget.WidgetMounted:Connect(function(p5: string) -- Line: 60
        -- upvalues: u1 (copy), Frame (copy), TextButton (ref)
        if p5 ~= u1 then
            return;
        end;

        Frame.BackgroundColor3 = Color3.fromRGB(183, 241, 77);
        TextButton.BackgroundColor3 = Color3.fromRGB(132, 156, 137);
    end);
    local u8 = Widget.WidgetUnmounted:Connect(function(p7: string) -- Line: 69
        -- upvalues: u1 (copy), Frame (copy), TextButton (ref)
        if p7 ~= u1 then
            return;
        end;

        Frame.BackgroundColor3 = Color3.fromRGB(241, 77, 77);
        TextButton.BackgroundColor3 = Color3.fromRGB(147, 115, 137);
    end);

    return function() -- Line: 78
        -- upvalues: u4 (ref), u6 (ref), u8 (ref), TextButton (ref)
        u4:Disconnect();
        u4 = nil;
        u6:Disconnect();
        u6 = nil;
        u8:Disconnect();
        u8 = nil;
        TextButton:Destroy();
        TextButton = nil;
    end;
end;

return function(p9: userdata) -- Line: 93
    -- upvalues: Widget (copy), createWidgetButton (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Widgets List";
    Frame.AnchorPoint = Vector2.new(1, 0);
    Frame.BackgroundColor3 = Color3.fromRGB(172, 195, 245);
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(1, 0);
    Frame.Size = UDim2.fromScale(0.25, 1);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Gradient";
    Frame2.AnchorPoint = Vector2.new(1, 0);
    Frame2.Size = UDim2.fromScale(0.05, 1);
    Frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    Frame2.BackgroundTransparency = 0.8;
    Frame2.BorderSizePixel = 0;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) });
    UIGradient.Parent = Frame2;
    Frame2.Parent = Frame;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "ScrollingFrame";
    ScrollingFrame.Size = UDim2.fromScale(1, 1);
    ScrollingFrame.CanvasSize = UDim2.new();
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0);
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BorderSizePixel = 0;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.Padding = UDim.new(0, 2);
    UIListLayout.SortOrder = Enum.SortOrder.Name;
    UIListLayout.Parent = ScrollingFrame;
    ScrollingFrame.Parent = Frame;
    Frame.Parent = p9;
    local u10 = {};

    for i in Widget:GetAll() do
        local v11 = createWidgetButton(i, ScrollingFrame);
        table.insert(u10, v11);
    end;

    local u14 = Widget.WidgetAdded:Connect(function(p12) -- Line: 145
        -- upvalues: u10 (copy), createWidgetButton (ref), ScrollingFrame (copy)
        local v13 = createWidgetButton(p12, ScrollingFrame);
        table.insert(u10, v13);
    end);

    return function() -- Line: 149
        -- upvalues: u10 (copy), u14 (ref), Frame (ref)
        for _, v in u10 do
            v();
        end;

        u14:Disconnect();
        u14 = nil;
        Frame:Destroy();
        Frame = nil;
    end;
end;