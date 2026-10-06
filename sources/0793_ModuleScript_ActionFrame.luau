-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local Parent = script.Parent.Parent.Parent.Parent.Parent;
local Action = require(Parent.Parent.Shared.Action);
local Console = require(Parent.Builtin.Tabs.Console);
local Style = require(Parent.Style);
local ActionArgument = require(script.Parent.ActionArgument);

return function(u1: table, p2: userdata, p3: number?) -- Line: 21
    -- upvalues: Style (copy), ActionArgument (copy), TweenService (copy), Action (copy), Console (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = u1.RawName;
    Frame.Size = UDim2.fromScale(1, 0);
    Frame.AutomaticSize = Enum.AutomaticSize.Y;
    Frame.BackgroundColor3 = Style.BACKGROUND;
    Frame.BorderSizePixel = 0;
    Frame.LayoutOrder = p3 or 0;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Header";
    TextLabel.AutoLocalize = false;
    TextLabel.Size = UDim2.new(1, 0, 0, 16);
    TextLabel.FontFace = Style.FONT_BOLD;
    TextLabel.Text = u1.Name;
    TextLabel.TextColor3 = Style.COLOR_WHITE;
    TextLabel.TextSize = 16;
    TextLabel.TextStrokeTransparency = 0.5;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.LayoutOrder = -2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Side";
    TextLabel2.AutoLocalize = false;
    TextLabel2.Size = UDim2.new(1, 0, 0, 14);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.BorderSizePixel = 0;
    TextLabel2.FontFace = Style.FONT;
    TextLabel2.Text = u1.ServerAction and "Server" or "Client";
    TextLabel2.TextColor3 = u1.ServerAction and Style.COLOR_RED or Style.COLOR_GREEN;
    TextLabel2.TextSize = 12;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel2.BackgroundColor3 = Style.COLOR_WHITE;
    TextLabel2.Parent = TextLabel;
    TextLabel.Parent = Frame;

    if u1.Description then
        local TextLabel3 = Instance.new("TextLabel");
        TextLabel3.Name = "Description";
        TextLabel3.AutoLocalize = false;
        TextLabel3.AutomaticSize = Enum.AutomaticSize.Y;
        TextLabel3.Position = UDim2.fromOffset(0, 14);
        TextLabel3.Size = UDim2.new(1, 0, 0, 12);
        TextLabel3.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json");
        TextLabel3.Text = u1.Description;
        TextLabel3.TextColor3 = Style.TAB_NORMAL_TEXT;
        TextLabel3.TextSize = 12;
        TextLabel3.TextStrokeTransparency = 0.75;
        TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel3.TextWrapped = true;
        TextLabel3.BackgroundTransparency = 1;
        TextLabel3.BorderSizePixel = 0;
        TextLabel3.LayoutOrder = -1;
        TextLabel3.Parent = Frame;
    end;

    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0, 4);
    UIPadding.PaddingLeft = UDim.new(0, 4);
    UIPadding.PaddingRight = UDim.new(0, 4);
    UIPadding.PaddingTop = UDim.new(0, 4);
    UIPadding.Parent = Frame;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Execute";
    TextButton.AutoLocalize = false;
    TextButton.AnchorPoint = Vector2.new(1, 0);
    TextButton.Position = UDim2.new(1, 0, 0, 30);
    TextButton.Size = UDim2.new(1, 0, 0, 14);
    TextButton.FontFace = Style.FONT;
    TextButton.Text = "Execute";
    TextButton.TextColor3 = Style.PRIMARY_TEXT;
    TextButton.TextSize = 12;
    TextButton.BackgroundColor3 = Style.PRIMARY;
    TextButton.BorderSizePixel = 0;
    TextButton.LayoutOrder = 100;
    TextButton.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.Padding = UDim.new(0, 4);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame;
    Frame.Parent = p2;
    local u4 = {};
    local u5 = {};

    if u1.Arguments then
        for i, v in u1.Arguments do
            u4[i] = v.Default;
            v.Index = i;
            table.insert(u5, ActionArgument(Frame, v, function(p6) -- Line: 122
                -- upvalues: u4 (copy), i (copy)
                u4[i] = p6;
            end));
        end;
    end;

    local function flashActionFrame(p7) -- Line: 129
        -- upvalues: Frame (copy), TweenService (ref), Style (ref)
        Frame.BorderColor3 = p7;
        Frame.BorderSizePixel = 3;
        TweenService:Create(Frame, TweenInfo.new(0.7, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
            BorderSizePixel = 0,
            BorderColor3 = Style.BACKGROUND
        }):Play();
    end;

    local u10 = TextButton.Activated:Connect(function() -- Line: 138
        -- upvalues: Action (ref), u1 (copy), u4 (copy), flashActionFrame (copy), Style (ref), Console (ref)
        local v8 = Action:Execute(u1.RawName, u4);
        local v9 = v8 == nil and true or v8;

        if v9 == true then
            flashActionFrame(Style.COLOR_GREEN);

            return;
        end;

        if v9 then
            if typeof(v9) == "string" then
                flashActionFrame(Style.COLOR_ORANGE);
                Console:AddMessage(`Action '{u1.RawName}' outcome: {v9}`, Enum.MessageType.MessageInfo, false);
            end;

            return;
        end;

        flashActionFrame(Style.COLOR_RED);
    end);

    return function() -- Line: 160
        -- upvalues: Frame (copy), u10 (copy), u5 (copy)
        Frame:Destroy();
        u10:Disconnect();

        for _, v in u5 do
            v();
        end;
    end;
end;