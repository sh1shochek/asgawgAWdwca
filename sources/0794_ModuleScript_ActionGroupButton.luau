-- Decompiled with Potassium's decompiler.

local Style = require(script.Parent.Parent.Parent.Parent.Parent.Style);

return function(u1: string, p2: userdata, p3: any, u4: function) -- Line: 6
    -- upvalues: Style (copy)
    local TextButton = Instance.new("TextButton");
    TextButton.Name = `Action Group ({u1})`;
    TextButton.AutoLocalize = false;
    TextButton.Size = UDim2.new(1, 0, 0, 18);
    TextButton.FontFace = Style.FONT_BOLD;
    TextButton.Text = ` {u1}`;
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton.TextSize = 12;
    TextButton.TextStrokeTransparency = 0;
    TextButton.TextXAlignment = Enum.TextXAlignment.Left;
    TextButton.BackgroundColor3 = Style.PRIMARY_DARK;
    TextButton.BorderSizePixel = 0;
    TextButton.Parent = p2;
    local u5 = TextButton.Activated:Connect(function() -- Line: 22
        -- upvalues: u4 (copy)
        u4();
    end);
    local u7 = p3:Observe(function(p6: string) -- Line: 26
        -- upvalues: TextButton (ref), u1 (copy), Style (ref)
        TextButton.BackgroundColor3 = u1 == p6 and Style.PRIMARY_TEXT or Style.PRIMARY_DARK;
    end);

    return function() -- Line: 30
        -- upvalues: u7 (ref), u5 (ref), TextButton (ref)
        u7:Disconnect();
        u7 = nil;
        u5:Disconnect();
        u5 = nil;
        TextButton:Destroy();
        TextButton = nil;
    end;
end;