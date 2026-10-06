-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Parent = script.Parent.Parent.Parent;

if not require(Parent.Parent.Shared.Constants).DEFAULT_WIDGETS_ENABLED then
    return nil;
end;

require(Parent.Widget).new("Coordinates", function(p1: userdata) -- Line: 16
    -- upvalues: RunService (copy), Players (copy), UserInputService (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Content";
    Frame.AnchorPoint = Vector2.new(0.5, 1);
    Frame.Position = UDim2.new(0.5, 0, 1, -8);
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BackgroundTransparency = 0.5;
    Frame.AutomaticSize = Enum.AutomaticSize.XY;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0, 4);
    UIPadding.PaddingLeft = UDim.new(0, 4);
    UIPadding.PaddingRight = UDim.new(0, 4);
    UIPadding.PaddingTop = UDim.new(0, 4);
    UIPadding.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.Parent = Frame;
    local TextBox = Instance.new("TextBox");
    TextBox.Name = "CoordinatesTextBox";
    TextBox.AutoLocalize = false;
    TextBox.Size = UDim2.fromOffset(0, 14);
    TextBox.BackgroundTransparency = 1;
    TextBox.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextBox.Text = "X: 0.00 Y: 0.00 Z: 0.00";
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextBox.TextSize = 14;
    TextBox.TextTransparency = 0.33;
    TextBox.AutomaticSize = Enum.AutomaticSize.X;
    TextBox.LayoutOrder = 3;
    TextBox.Visible = false;
    TextBox.TextEditable = false;
    TextBox.ClearTextOnFocus = false;
    TextBox.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "CoordinatesLabel";
    TextLabel.AutoLocalize = false;
    TextLabel.Size = UDim2.fromOffset(0, 14);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Text = "X: 0.00 Y: 0.00 Z: 0.00";
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.TextSize = 14;
    TextLabel.TextTransparency = 0.33;
    TextLabel.AutomaticSize = Enum.AutomaticSize.X;
    TextLabel.LayoutOrder = 3;
    TextLabel.Parent = Frame;
    Frame.Parent = p1;
    local u2 = RunService.Heartbeat:Connect(function() -- Line: 72
        -- upvalues: Players (ref), TextLabel (copy), UserInputService (ref), TextBox (copy)
        if not Players.LocalPlayer.Character then
            TextLabel.Text = "No character";

            return;
        end;

        local PrimaryPart = Players.LocalPlayer.Character.PrimaryPart;

        if not PrimaryPart then
            TextLabel.Text = "No character";

            return;
        end;

        if UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) then
            TextBox.Visible = true;
            TextLabel.Visible = false;
        else
            TextBox.Visible = false;
            TextLabel.Visible = true;
        end;

        local Position = PrimaryPart.Position;
        TextBox.Text = `{string.format("%.3f", Position.X)}, {string.format("%.3f", Position.Y)}, {string.format("%.3f", Position.Z)}`;
        TextLabel.Text = `X: {string.format("%.3f", Position.X)} Y: {string.format("%.3f", Position.Y)} Z: {string.format("%.3f", Position.Z)}`;
    end);

    return function() -- Line: 100
        -- upvalues: Frame (ref), u2 (ref)
        Frame:Destroy();
        Frame = nil;
        u2:Disconnect();
        u2 = nil;
    end;
end);

return nil;