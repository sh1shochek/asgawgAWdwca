-- ReplicatedStorage.GameClient.Gui.HUD
-- Script path: ReplicatedStorage.GameClient.Gui.HUD
-- Decompile time: 6.68 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = 1;
local u10 = 1;

function u1.HudEdge() -- Line: 25
    -- upvalues: u8 (ref), u3 (ref), u9 (ref), u10 (ref)
    if u8.Visible then
        u3.Size = UDim2.fromScale(1, 1);

        return;
    end;

    u3.Size = UDim2.fromScale(u9, u10);
end;

function u1.Hide() -- Line: 35
    -- upvalues: u4 (ref), u3 (ref)
    if u4.Visible then
        return;
    end;

    u3.Visible = not u3.Visible;
end;

local u11 = nil;
local u12 = nil;

function u1.Init(p13) -- Line: 47
    -- upvalues: u2 (ref), u6 (ref), u11 (ref), u12 (ref), u7 (ref), u4 (ref), u3 (ref)
    u2 = p13:GetModule("Gui");
    u6 = p13:GetModule("CameraController");
    u11 = p13:GetModule("GetUserPlatform");
    u12 = u11() == "Mobile";
    u7 = u2.Handler;
    u4 = u7.MainMenu;
    u3 = u7.HUD;

    if u12 then
        for _, v in ipairs({ {
                Name = "Down",
                Scale = 1.15
            }, {
                Name = "Radar",
                Scale = 1.15
            }, {
                Name = "Topbar",
                Scale = 1.15
            }, {
                Name = "TopbarSec",
                Scale = 1.15
            }, {
                Name = "Money",
                Scale = 1.2
            }, {
                Name = "Inventory",
                Scale = 1.15
            }, {
                Name = "Killfeed",
                Scale = 1.15
            }, {
                Name = "BombDefuse",
                Scale = 1.15
            }, {
                Name = "Scoreboard",
                Scale = 1.12
            }, {
                Name = "CasualScoreboard",
                Scale = 1.12
            } }) do
            local v14 = u3:FindFirstChild(v.Name);

            if v14 and v14:IsA("GuiObject") then
                local v15 = v14:FindFirstChild("MobileHUDScale") or v14:FindFirstChildWhichIsA("UIScale");

                if v15 and v15.Parent == v14 then
                    v15.Scale = v.Scale;
                else
                    local UIScale = Instance.new("UIScale");
                    UIScale.Name = "MobileHUDScale";
                    UIScale.Scale = v.Scale;
                    UIScale.Parent = v14;
                end;
            end;
        end;
    end;
end;

function u1.Start(p16) -- Line: 87
    -- upvalues: u5 (ref), u2 (ref), u8 (ref), u3 (ref), u9 (ref), u10 (ref), u1 (copy), u6 (ref)
    u5 = u2.GetComponent("Settings");
    u8 = u3.Buymenu;
    local v17 = u5:GetPlayerSettings().Game["HUD & UI"];
    u9 = v17["HUD Edges Vertical"];
    u10 = v17["HUD Edges Horizontal"];
    u1.HudEdge(u9, u10);
    u5:AddConnection("Game", "HUD & UI", "HUD Edges Vertical", function(p18) -- Line: 97
        -- upvalues: u9 (ref), u1 (ref), u10 (ref)
        u9 = p18;
        u1.HudEdge(u9, u10);
    end);
    u5:AddConnection("Game", "HUD & UI", "HUD Edges Horizontal", function(p19) -- Line: 101
        -- upvalues: u10 (ref), u1 (ref), u9 (ref)
        u10 = p19;
        u1.HudEdge(u9, u10);
    end);
    u6.SetScretchAmount(u5:GetPlayerSettings().Game.Gameplay["Camera Aspect Ratio"]);
    u5:AddConnection("Game", "Gameplay", "Camera Aspect Ratio", function(p20) -- Line: 107
        -- upvalues: u6 (ref)
        u6.SetScretchAmount(p20);
    end);
    u1.new();
end;

function u1.new() -- Line: 114
    -- upvalues: u3 (ref), u7 (ref)
    if u3:FindFirstChild("Vignette") then
        return;
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = "Vignette";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = Color3.new();
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(1, 1);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Rotation = 90;
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.800455, 1), NumberSequenceKeypoint.new(1, 0.75) });
    UIGradient.Parent = Frame;
    Frame.Parent = u7;
    u3:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 138
        -- upvalues: Frame (copy), u3 (ref)
        Frame.Visible = u3.Visible;
    end);
end;

return u1;