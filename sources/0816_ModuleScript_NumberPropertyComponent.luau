-- Decompiled with Potassium's decompiler.

local Style = require(script.Parent.Parent.Style);

return function(p1: table, u2: function) -- Line: 15
    -- upvalues: Style (copy)
    local u3 = p1.Value or 0;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Argument [number]";
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
    TextBox.PlaceholderText = p1.Default and (tostring(p1.Default) or "number") or "number";
    TextBox.Text = tostring(u3);
    TextBox.TextColor3 = Style.COLOR_WHITE;
    TextBox.TextSize = 12;
    TextBox.TextWrapped = true;
    TextBox.AutomaticSize = Enum.AutomaticSize.Y;
    TextBox.BackgroundColor3 = Style.BACKGROUND_DARK;
    TextBox.BorderSizePixel = 0;
    TextBox.AutoLocalize = false;
    TextBox.Parent = TextLabel;
    local u5 = TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 51
        -- upvalues: TextBox (copy), u3 (ref), u2 (copy)
        local v4 = tonumber(TextBox.Text);

        if not v4 then
            TextBox.Text = tostring(u3);

            return;
        end;

        u3 = v4;
        u2(v4);
    end);
    TextLabel.Parent = p1.Parent;

    return function() -- Line: 65
        -- upvalues: TextLabel (copy), u5 (copy)
        TextLabel:Destroy();
        u5:Disconnect();
    end;
end;