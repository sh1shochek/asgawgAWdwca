-- Decompiled with Potassium's decompiler.

local Style = require(script.Parent.Parent.Style);

return function(p1: table, u2: function) -- Line: 15
    -- upvalues: Style (copy)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Argument [string]";
    TextLabel.Size = UDim2.new(1, 0, 0, 16);
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json");
    TextLabel.Text = p1.PropertyText;
    TextLabel.TextColor3 = Style.COLOR_WHITE;
    TextLabel.TextSize = 12;
    TextLabel.TextStrokeTransparency = 0.75;
    TextLabel.TextWrapped = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.AutomaticSize = Enum.AutomaticSize.Y;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.LayoutOrder = 1;
    TextLabel.AutoLocalize = false;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "Value [TextBox]";
    TextBox.Position = UDim2.fromScale(0.5, 0);
    TextBox.Size = UDim2.fromScale(0.5, 1);
    TextBox.ClearTextOnFocus = false;
    TextBox.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json");
    TextBox.PlaceholderText = p1.Default or "string";
    TextBox.Text = p1.Value or "";
    TextBox.TextColor3 = Style.COLOR_WHITE;
    TextBox.TextSize = 12;
    TextBox.TextWrapped = true;
    TextBox.AutomaticSize = Enum.AutomaticSize.Y;
    TextBox.BackgroundColor3 = Style.BACKGROUND_DARK;
    TextBox.BorderSizePixel = 0;
    TextBox.AutoLocalize = false;
    TextBox.Parent = TextLabel;
    local u3 = TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 49
        -- upvalues: u2 (copy), TextBox (copy)
        u2(TextBox.Text);
    end);
    TextLabel.Parent = p1.Parent;

    return function() -- Line: 55
        -- upvalues: TextLabel (copy), u3 (copy)
        TextLabel:Destroy();
        u3:Disconnect();
    end;
end;