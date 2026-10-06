-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Parent = script.Parent.Parent.Parent;

if not require(Parent.Parent.Shared.Constants).DEFAULT_WIDGETS_ENABLED then
    return nil;
end;

local Style = require(Parent.Style);
local Widget = require(Parent.Widget);
local Performance = require(Parent.Builtin.Tabs.Performance);
Widget.new("Place Stats", function(p1: userdata) -- Line: 16
    -- upvalues: Style (copy), RunService (copy), Performance (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Content";
    Frame.AnchorPoint = Vector2.new(0, 1);
    Frame.Position = UDim2.new(0, 8, 1, -8);
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BackgroundTransparency = 0.5;
    Frame.AutomaticSize = Enum.AutomaticSize.XY;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "FPSLabel";
    TextLabel.AutoLocalize = false;
    TextLabel.Size = UDim2.fromOffset(0, 24);
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Text = "FPS: 0";
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.TextSize = 24;
    TextLabel.TextTransparency = 0.33;
    TextLabel.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.LayoutOrder = 1;
    TextLabel.Parent = Frame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0, 8);
    UIPadding.PaddingLeft = UDim.new(0, 8);
    UIPadding.PaddingRight = UDim.new(0, 8);
    UIPadding.PaddingTop = UDim.new(0, 8);
    UIPadding.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "FPSCapLabel";
    TextLabel2.AutoLocalize = false;
    TextLabel2.Size = UDim2.fromOffset(0, 14);
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextLabel2.Text = "FPS Cap: 0";
    TextLabel2.TextColor3 = Style.COLOR_RED;
    TextLabel2.TextSize = 14;
    TextLabel2.TextTransparency = 0.33;
    TextLabel2.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.LayoutOrder = 2;
    TextLabel2.Parent = Frame;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "PhysicsFPSLabel";
    TextLabel3.AutoLocalize = false;
    TextLabel3.Size = UDim2.fromOffset(0, 14);
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextLabel3.Text = "Physics FPS: 0";
    TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel3.TextSize = 14;
    TextLabel3.TextTransparency = 0.33;
    TextLabel3.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.LayoutOrder = 3;
    TextLabel3.Parent = Frame;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "PlaceVersionLabel";
    TextLabel4.AutoLocalize = false;
    TextLabel4.Size = UDim2.fromOffset(0, 14);
    TextLabel4.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextLabel4.Text = `Version: {game.PlaceVersion}`;
    TextLabel4.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel4.TextSize = 14;
    TextLabel4.TextTransparency = 0.33;
    TextLabel4.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.LayoutOrder = 4;
    TextLabel4.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.Padding = UDim.new(0, 2);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame;
    Frame.Parent = p1;
    local u2 = {};
    local os_clock_ret = os.clock();
    local u5 = RunService.Heartbeat:Connect(function() -- Line: 104
        -- upvalues: u2 (copy), os_clock_ret (copy), Performance (ref), TextLabel2 (copy), TextLabel (copy), TextLabel3 (copy)
        local os_clock_ret2 = os.clock();

        for i = #u2, 1, -1 do
            local v3;

            if u2[i] >= os_clock_ret2 - 1 then
                v3 = u2[i] or nil;
            else
                v3 = nil;
            end;

            u2[i + 1] = v3;
            local _ = i;
        end;

        u2[1] = os_clock_ret2;
        local v4 = os.clock() - os_clock_ret >= 1 and #u2 or #u2 / (os.clock() - os_clock_ret);
        local math_floor_ret = math.floor(v4);
        local FPSCap = Performance:GetFPSCap();
        TextLabel2.Visible = FPSCap > 0;
        TextLabel2.Text = `FPS Cap: {FPSCap}`;
        TextLabel.Text = `FPS: {math_floor_ret}`;
        local RealPhysicsFPS = workspace:GetRealPhysicsFPS();
        TextLabel3.Text = `Physics FPS: {math.floor(RealPhysicsFPS)}`;
    end);

    return function() -- Line: 129
        -- upvalues: Frame (ref), u5 (ref)
        Frame:Destroy();
        Frame = nil;
        u5:Disconnect();
        u5 = nil;
    end;
end);

return nil;