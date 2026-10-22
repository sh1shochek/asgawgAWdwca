-- ReplicatedStorage.GameClient.Gui.MainMenu.Utils.MenuNotification
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.Utils.MenuNotification
-- Decompile time: 4.19 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local TweenService = game:GetService("TweenService");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = false;
local TweenInfo_new_ret = TweenInfo.new(10, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);

function u1.Create(p10, p11, p12) -- Line: 23
    -- upvalues: u9 (ref), u6 (ref), u1 (copy), TweenService (copy), TweenInfo_new_ret (copy)
    if u9 and not u6.FramePriority.MainMenu then
        return;
    end;

    local u13 = u1.template();
    u13.Text = p11;
    u13.TextColor3 = p12 or u13.TextColor3;
    u13.Visible = true;
    TweenService:Create(u13, TweenInfo_new_ret, {
        TextTransparency = 1,
        Position = u13.Position - UDim2.fromScale(0, 15)
    }):Play();
    task.delay(5, function() -- Line: 36
        -- upvalues: u13 (ref)
        u13:Destroy();
        u13 = nil;
    end);
end;

function u1.Init(p14, p15) -- Line: 43
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u9 (ref), u1 (copy)
    u2 = p14:GetModule("Maid").new();
    u3 = p14:GetModule("Gui");
    u4 = p14:GetModule("Network");
    u5 = p14:GetModule("Settings");
    u6 = p14:GetModule("BindsController");
    u5:AddConnection("Game", "HUD & UI", "Hide Menu Notifications In Game", function(p16) -- Line: 50
        -- upvalues: u9 (ref)
        u9 = p16;
    end);
    u4.Gui.MenuNotification.On(function(p17) -- Line: 54
        -- upvalues: u1 (ref)
        if not p17 then
            return;
        end;

        local Message = p17.Message;

        if not Message then
            return;
        end;

        u1:Create(Message, p17.Color);
    end);
end;

function u1.Start(p18) -- Line: 70
    -- upvalues: u1 (copy)
    u1.new();
    u1:Create("Game Loaded Successfully", Color3.fromRGB(78, 140, 255));
end;

function u1.new() -- Line: 85
    -- upvalues: u7 (ref), u8 (ref), u3 (ref)
    u7 = Instance.new("Frame");
    u7.Name = "Notification";
    u7.AnchorPoint = Vector2.new(0.5, 1);
    u7.BackgroundTransparency = 1;
    u7.Position = UDim2.fromScale(0.5, 0.9);
    u7.Size = UDim2.fromScale(0.5, 0.02);
    u8 = Instance.new("Folder");
    u8.Name = "Folder";
    u8.Parent = u7;
    u7.Parent = u3.Handler;
end;

function u1.template() -- Line: 100
    -- upvalues: u8 (ref)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Size = UDim2.fromScale(1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.1;
    TextLabel.Position = UDim2.fromScale(0.5, 6.5);
    TextLabel.ZIndex = 1000;
    TextLabel.Parent = u8;
    TextLabel.Visible = false;

    return TextLabel;
end;

return u1;