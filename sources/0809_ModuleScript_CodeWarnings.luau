-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Parent = script.Parent.Parent.Parent;

if not require(Parent.Parent.Shared.Constants).DEFAULT_WIDGETS_ENABLED then
    return nil;
end;

local Console = require(Parent.Builtin.Tabs.Console);
local Widget = require(Parent.Widget);
local Style = require(Parent.Style);
local u1 = {
    internal = {
        ContentFrame = nil,
        OnScreenMessages = {}
    }
};

function u1.internal.createOutputLabel() -- Line: 32
    -- upvalues: Style (copy)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "OutputLabel";
    TextLabel.AutoLocalize = false;
    TextLabel.FontFace = Style.FONT_BOLD;
    TextLabel.TextColor3 = Color3.fromRGB(255, 81, 70);
    TextLabel.TextSize = 14;
    TextLabel.TextStrokeTransparency = 0.5;
    TextLabel.TextWrapped = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
    TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    TextLabel.BackgroundTransparency = 0.5;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0, 4);
    UIPadding.PaddingLeft = UDim.new(0, 8);
    UIPadding.PaddingRight = UDim.new(0, 8);
    UIPadding.PaddingTop = UDim.new(0, 4);
    UIPadding.Parent = TextLabel;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.Parent = TextLabel;
    local UISizeConstraint = Instance.new("UISizeConstraint");
    UISizeConstraint.Name = "UISizeConstraint";
    UISizeConstraint.MaxSize = Vector2.new(500, (1 / 0));
    UISizeConstraint.Parent = TextLabel;

    return TextLabel;
end;

function u1.internal.getLatestMessageData() -- Line: 66
    -- upvalues: u1 (copy)
    local v2 = #u1.internal.OnScreenMessages;

    if v2 ~= 0 then
        return u1.internal.OnScreenMessages[v2];
    end;
end;

function u1.internal.addMessage(p3: string, p4: string) -- Line: 75
    -- upvalues: u1 (copy), Style (copy)
    local LatestMessageData = u1.internal.getLatestMessageData();

    if LatestMessageData and (LatestMessageData.Message == p3 and LatestMessageData.Type == p4) then
        LatestMessageData.Amount = LatestMessageData.Amount + 1;
        LatestMessageData.Lifetime = 6;
        local v5 = LatestMessageData.Amount < 99 and (tostring(LatestMessageData.Amount) or "99+") or "99+";
        LatestMessageData.TextLabel.Text = `(x{v5}) {LatestMessageData.Message}`;

        return;
    end;

    local v6 = u1.internal.createOutputLabel();
    v6.Text = p3;

    if p4 == "WARNING" then
        v6.TextColor3 = Style.COLOR_ORANGE;
    elseif p4 == "ERROR" then
        v6.TextColor3 = Style.COLOR_RED;
    end;

    v6.Parent = u1.internal.ContentFrame;
    table.insert(u1.internal.OnScreenMessages, {
        Amount = 1,
        Lifetime = 6,
        Message = p3,
        Type = p4,
        TextLabel = v6
    });
end;

RunService.Heartbeat:Connect(function(p7: number) -- Line: 106
    -- upvalues: u1 (copy)
    for i, v in u1.internal.OnScreenMessages do
        v.Lifetime = v.Lifetime - p7;

        if v.Lifetime <= 0 then
            v.TextLabel:Destroy();
            table.remove(u1.internal.OnScreenMessages, i);
        end;
    end;
end);
Widget.new("Code Warnings", function(p8: userdata) -- Line: 119
    -- upvalues: u1 (copy), Console (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Content";
    Frame.Position = UDim2.new(0, 8, 0, 48);
    Frame.Size = UDim2.fromOffset(32, 32);
    Frame.BackgroundTransparency = 1;
    Frame.AutomaticSize = Enum.AutomaticSize.XY;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.Padding = UDim.new(0, 4);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame;
    Frame.Parent = p8;
    u1.internal.ContentFrame = Frame;
    local u11 = Console.MessageAdded:Connect(function(p9: string, p10: string) -- Line: 137
        -- upvalues: u1 (ref)
        if p10 == "INFO" then
            return;
        end;

        u1.internal.addMessage(p9, p10);
    end);

    return function() -- Line: 145
        -- upvalues: u1 (ref), u11 (copy), Frame (copy)
        for _, v in u1.internal.OnScreenMessages do
            v.TextLabel:Destroy();
        end;

        u1.internal.OnScreenMessages = {};
        u11:Disconnect();
        Frame:Destroy();
    end;
end);

return nil;