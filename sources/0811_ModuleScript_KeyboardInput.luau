-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local Parent = script.Parent.Parent.Parent;

if not require(Parent.Parent.Shared.Constants).DEFAULT_WIDGETS_ENABLED then
    return nil;
end;

local Widget = require(Parent.Widget);
local u1 = {
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.Backspace] = "<-",
    [Enum.KeyCode.BackSlash] = "|",
    [Enum.KeyCode.Slash] = "/",
    [Enum.KeyCode.Comma] = ".",
    [Enum.KeyCode.Period] = ",",
    [Enum.KeyCode.Quote] = "\'",
    [Enum.KeyCode.Semicolon] = ";",
    [Enum.KeyCode.RightBracket] = "]",
    [Enum.KeyCode.LeftBracket] = "[",
    [Enum.KeyCode.Backquote] = "`",
    [Enum.KeyCode.Minus] = "-",
    [Enum.KeyCode.Equals] = "=",
    [Enum.KeyCode.LeftShift] = "LS",
    [Enum.KeyCode.LeftAlt] = "LA",
    [Enum.KeyCode.LeftControl] = "LC",
    [Enum.KeyCode.RightShift] = "RS",
    [Enum.KeyCode.RightAlt] = "RA",
    [Enum.KeyCode.RightControl] = "RC",
    [Enum.KeyCode.Space] = "⬆️"
};

local function createKeyVisual(p2) -- Line: 51
    -- upvalues: u1 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Key";
    Frame.Size = UDim2.fromOffset(32, 32);
    Frame.BackgroundColor3 = Color3.fromRGB(49, 47, 40);
    Frame.BorderSizePixel = 0;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "KeyLabel";
    TextLabel.AutoLocalize = false;
    TextLabel.Size = UDim2.fromScale(1, 1);
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Text = u1[p2] or tostring(p2.Name);
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.TextSize = 24;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.LayoutOrder = 1;
    TextLabel.Parent = Frame;

    return Frame;
end;

Widget.new("Keyboard Input", function(p3: userdata) -- Line: 78
    -- upvalues: UserInputService (copy), createKeyVisual (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "MinimalContent";
    Frame.AnchorPoint = Vector2.new(0, 1);
    Frame.Position = UDim2.new(0, 8, 1, -88);
    Frame.Size = UDim2.fromOffset(48, 48);
    Frame.AutomaticSize = Enum.AutomaticSize.X;
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Content";
    Frame2.Size = UDim2.fromOffset(48, 48);
    Frame2.AutomaticSize = Enum.AutomaticSize.XY;
    Frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    Frame2.BackgroundTransparency = 0.5;
    Frame2.Visible = false;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0, 8);
    UIPadding.PaddingLeft = UDim.new(0, 8);
    UIPadding.PaddingRight = UDim.new(0, 8);
    UIPadding.PaddingTop = UDim.new(0, 8);
    UIPadding.Parent = Frame2;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.Parent = Frame2;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.Padding = UDim.new(0, 2);
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame2;
    Frame2.Parent = Frame;
    Frame.Parent = p3;
    local u4 = 0;
    local u7 = UserInputService.InputBegan:Connect(function(p5: userdata) -- Line: 122
        -- upvalues: createKeyVisual (ref), Frame2 (copy), u4 (ref)
        if p5.KeyCode == Enum.KeyCode.Unknown then
            return;
        end;

        local u6 = createKeyVisual(p5.KeyCode);
        u6.Parent = Frame2;
        u4 = u4 + 1;
        Frame2.Visible = true;
        task.delay(1.7, function() -- Line: 133
            -- upvalues: u6 (copy), u4 (ref), Frame2 (ref)
            u6:Destroy();
            u4 = u4 - 1;

            if u4 <= 0 and Frame2 then
                Frame2.Visible = false;
            end;
        end);
    end);

    return function() -- Line: 145
        -- upvalues: Frame (ref), u7 (ref)
        Frame:Destroy();
        Frame = nil;
        u7:Disconnect();
        u7 = nil;
    end;
end);

return nil;