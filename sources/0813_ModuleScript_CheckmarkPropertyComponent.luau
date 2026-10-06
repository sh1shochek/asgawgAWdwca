-- Decompiled with Potassium's decompiler.

local Style = require(script.Parent.Parent.Style);

return function(p1: table, u2: function) -- Line: 14
    -- upvalues: Style (copy)
    local Value = p1.Value;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Argument [boolean]";
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json");
    TextLabel.Text = p1.PropertyText or "";
    TextLabel.TextColor3 = Style.COLOR_WHITE;
    TextLabel.TextSize = 12;
    TextLabel.TextStrokeTransparency = 0.75;
    TextLabel.TextWrapped = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.AutomaticSize = Enum.AutomaticSize.Y;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.LayoutOrder = 1;
    TextLabel.Size = UDim2.new(1, 0, 0, 16);
    TextLabel.AutoLocalize = false;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Checkmark Click Detector";
    TextButton.AnchorPoint = Vector2.new(1, 0);
    TextButton.Position = UDim2.fromScale(1, 0);
    TextButton.Size = UDim2.fromScale(0.1, 1);
    TextButton.Text = "";
    TextButton.TextSize = 12;
    TextButton.TextWrapped = true;
    TextButton.AutoButtonColor = false;
    TextButton.AutomaticSize = Enum.AutomaticSize.Y;
    TextButton.BackgroundColor3 = Style.BACKGROUND_DARK;
    TextButton.BorderSizePixel = 0;
    TextButton.AutoLocalize = false;
    TextButton.Parent = TextLabel;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.Parent = TextButton;
    local Frame = Instance.new("Frame");
    Frame.Name = "Value [TextBox]";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(0.75, 0.75);
    Frame.BackgroundColor3 = Style.PRIMARY;
    Frame.BorderSizePixel = 0;
    Frame.Visible = Value;
    Frame.Parent = TextButton;
    TextLabel.Parent = p1.Parent;
    local u3 = TextButton.Activated:Connect(function() -- Line: 64
        -- upvalues: Value (ref), Frame (copy), u2 (copy)
        Value = not Value;
        Frame.Visible = Value;
        u2(Value);
    end);

    return function() -- Line: 71
        -- upvalues: TextLabel (copy), u3 (copy)
        TextLabel:Destroy();
        u3:Disconnect();
    end;
end;