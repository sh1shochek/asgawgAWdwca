-- Decompiled with Potassium's decompiler.

local Style = require(script.Parent.Parent.Style);
local DropdownPopup = require(script.Parent.DropdownPopup);

return function(u1: table, u2: function) -- Line: 17
    -- upvalues: Style (copy), DropdownPopup (copy)
    local Value = u1.Value;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Dropdown";
    TextLabel.Size = UDim2.new(1, 0, 0, 16);
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json");
    TextLabel.Text = u1.PropertyText;
    TextLabel.TextColor3 = Style.COLOR_WHITE;
    TextLabel.TextSize = 12;
    TextLabel.TextStrokeTransparency = 0.75;
    TextLabel.TextWrapped = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.AutomaticSize = Enum.AutomaticSize.Y;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.LayoutOrder = 4;
    TextLabel.AutoLocalize = false;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Dropdown Click Detector";
    TextButton.Position = UDim2.fromScale(0.5, 0);
    TextButton.Size = UDim2.fromScale(0.5, 1);
    TextButton.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json");
    TextButton.Text = tostring(Value);
    TextButton.TextColor3 = Style.COLOR_WHITE;
    TextButton.TextSize = 12;
    TextButton.TextWrapped = true;
    TextButton.AutoButtonColor = false;
    TextButton.AutomaticSize = Enum.AutomaticSize.Y;
    TextButton.BackgroundColor3 = Style.BACKGROUND_DARK;
    TextButton.BorderSizePixel = 0;
    TextButton.AutoLocalize = false;
    TextButton.Parent = TextLabel;
    local u3 = false;
    local u6 = TextButton.Activated:Connect(function() -- Line: 53
        -- upvalues: u3 (ref), u1 (copy), Value (ref), DropdownPopup (ref), TextButton (copy), u2 (copy)
        if u3 or #u1.Options <= 1 then
            return;
        end;

        u3 = true;
        local table_clone_ret = table.clone(u1.Options);
        table.remove(table_clone_ret, table.find(table_clone_ret, Value));
        local v4 = DropdownPopup.new(TextButton, table_clone_ret, u1.Value);
        v4.EntrySelected:Connect(function(p5: string) -- Line: 63
            -- upvalues: Value (ref), TextButton (ref), u2 (ref)
            if p5 == Value then
                return;
            end;

            Value = p5;
            TextButton.Text = p5;
            u2(p5);
        end);
        v4.Closed:Connect(function() -- Line: 73
            -- upvalues: u3 (ref)
            u3 = false;
        end);
    end);
    TextLabel.Parent = u1.Parent;

    return function() -- Line: 80
        -- upvalues: TextLabel (copy), u6 (copy)
        TextLabel:Destroy();
        u6:Disconnect();
    end;
end;