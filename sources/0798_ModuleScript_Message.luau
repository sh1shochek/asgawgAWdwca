-- Decompiled with Potassium's decompiler.

local Style = require(script.Parent.Parent.Parent.Parent.Style);
local u1 = {
    INFO = Style.COLOR_WHITE,
    ERROR = Color3.fromRGB(255, 81, 70),
    WARNING = Color3.fromRGB(243, 173, 82)
};
local u2 = {
    internal = {},
    prototype = {},
    interface = {}
};

function u2.internal.createMessageFrame(p3: table, p4: boolean) -- Line: 42
    -- upvalues: Style (copy), u1 (copy)
    local v5 = p4 and Style.COLOR_GREEN or Style.COLOR_BLUE;
    local v6 = p3.ContentType == "WARNING" and true or p3.ContentType == "ERROR";
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Console Message";
    TextButton.AutoLocalize = false;
    TextButton.Size = UDim2.new(1, 0, 0, 12);
    TextButton.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", v6 and Enum.FontWeight.Bold or Enum.FontWeight.Regular);
    TextButton.BackgroundColor3 = v5;
    TextButton.BackgroundTransparency = 0.8;
    TextButton.Text = p3.ContentShort;
    TextButton.TextSize = 12;
    TextButton.TextTruncate = Enum.TextTruncate.AtEnd;
    TextButton.TextXAlignment = Enum.TextXAlignment.Left;
    TextButton.TextColor3 = u1[p3.ContentType];
    TextButton.BorderSizePixel = 0;
    TextButton.AutomaticSize = Enum.AutomaticSize.Y;
    p3.MessageTextButton = TextButton;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Transparency = 0.6;
    UIStroke.Parent = TextButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "More";
    TextLabel.AutoLocalize = false;
    TextLabel.AnchorPoint = Vector2.new(1, 0);
    TextLabel.Position = UDim2.fromScale(1, 0);
    TextLabel.Size = UDim2.fromOffset(0, 12);
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Text = "...";
    TextLabel.TextColor3 = Style.COLOR_WHITE;
    TextLabel.TextSize = 14;
    TextLabel.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.Visible = false;
    TextLabel.Parent = TextButton;
    p3.MoreLabel = TextLabel;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "TextLabel";
    TextLabel2.AutoLocalize = false;
    TextLabel2.AnchorPoint = Vector2.new(1, 0);
    TextLabel2.Position = UDim2.new(1, -24, 0, 0);
    TextLabel2.Size = UDim2.fromScale(0, 1);
    TextLabel2.FontFace = Style.FONT_BOLD;
    TextLabel2.Text = "x1";
    TextLabel2.TextColor3 = Style.COLOR_WHITE;
    TextLabel2.TextSize = 12;
    TextLabel2.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel2.BackgroundColor3 = Style.COLOR_BLACK;
    TextLabel2.BackgroundTransparency = 0.25;
    TextLabel2.BorderSizePixel = 0;
    TextLabel2.Visible = false;
    TextLabel2.Parent = TextButton;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingLeft = UDim.new(0, 2);
    UIPadding.PaddingRight = UDim.new(0, 2);
    UIPadding.Parent = TextLabel2;
    local Frame = Instance.new("Frame");
    Frame.Name = "Frame";
    Frame.AnchorPoint = Vector2.new(1, 0);
    Frame.BackgroundColor3 = v5;
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.new(0, 4, 1, 0);
    Frame.Parent = TextButton;
    p3.CountLabel = TextLabel2;
end;

function u2.prototype.SetParent(p7: table, p8: userdata) -- Line: 125
    p7.MessageTextButton.Parent = p8;
end;

function u2.prototype.Destroy(p9) -- Line: 129
    p9.MessageTextButton:Destroy();
    p9.MessageTextButton = nil;
    p9._TextButtonActivatedConnection:Disconnect();
    p9._TextButtonActivatedConnection = nil;
end;

function u2.prototype.Concatenate(p10: table, p11: string) -- Line: 137
    p10.Content = p10.Content .. p11;
    local v12 = string.find(p10.Content, "\n") or 0;
    p10.ContentShort = v12 > 0 and string.sub(p10.Content, 0, v12 - 1) or p10.Content;
    p10.CanExpand = v12 > 0;
    p10.MoreLabel.Visible = v12 ~= nil;
    p10.MessageTextButton.Text = p10.Expanded and p10.Content or p10.ContentShort;
end;

function u2.prototype.IncreaseCount(p13: table, p14: number?) -- Line: 151
    p13.Amount = p13.Amount + (p14 or 1);
    p13.CountLabel.Visible = true;
    p13.CountLabel.Text = `x{p13.Amount}`;
end;

function u2.prototype.ChangeType(p15: table, p16: string) -- Line: 158
    -- upvalues: u1 (copy), Style (copy)
    p15.ContentType = p16;
    p15.MessageTextButton.BackgroundColor3 = u1[p15.ContentType] or Style.PRIMARY_DARK;
end;

function u2.prototype.Expand(p17) -- Line: 163
    if not p17.CanExpand then
        return;
    end;

    p17.Expanded = not p17.Expanded;
    p17.MessageTextButton.Text = p17.Expanded and p17.Content or p17.ContentShort;
end;

function u2.interface.new(p18: string, p19: string, p20: boolean?, p21: number?) -- Line: 173
    -- upvalues: u2 (copy)
    local v22 = p20 or false;
    local string_find_ret = string.find(p18, "\n");
    local v23;

    if string_find_ret then
        v23 = string.sub(p18, 0, string_find_ret - 1) or p18;
    else
        v23 = p18;
    end;

    local v24 = {
        Expanded = false,
        Amount = 1,
        Content = p18,
        ContentShort = v23,
        ContentType = p19,
        ServerSide = v22,
        CanExpand = string_find_ret ~= nil,
        Timestamp = p21 or os.clock()
    };
    local u25 = setmetatable(v24, {
        __index = u2.prototype
    });
    u2.internal.createMessageFrame(u25, v22);
    u25.MoreLabel.Visible = u25.CanExpand;
    u25._TextButtonActivatedConnection = u25.MessageTextButton.Activated:Connect(function() -- Line: 202
        -- upvalues: u25 (copy)
        u25:Expand();
    end);

    return u25;
end;

return u2.interface;