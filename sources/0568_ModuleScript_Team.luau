-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Color3_fromRGB_ret = Color3.fromRGB(36, 41, 47);
local Color3_fromRGB_ret2 = Color3.fromRGB(89, 79, 50);
local Color3_fromRGB_ret3 = Color3.fromRGB(135, 155, 177);
local u2 = nil;
local u3 = nil;

local function getPlateColor() -- Line: 38
    -- upvalues: LocalPlayer (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy)
    if LocalPlayer:GetAttribute("Team") == "Terrorists" then
        return Color3_fromRGB_ret2;
    end;

    return Color3_fromRGB_ret;
end;

local function applyPreferenceColorToFrame(p4) -- Line: 44
    -- upvalues: u2 (ref)
    u2.Team.Outline.ImageColor3 = p4;
    u2.Line1.ImageColor3 = p4;
    u2.Line2.ImageColor3 = p4;
end;

local function applyTeamPresentation() -- Line: 62
    -- upvalues: GetPreferenceColor (copy), u2 (ref), LocalPlayer (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy)
    local v5 = GetPreferenceColor();
    u2.Team.Outline.ImageColor3 = v5;
    u2.Line1.ImageColor3 = v5;
    u2.Line2.ImageColor3 = v5;
    local Attribute = LocalPlayer:GetAttribute("Team");
    u2.Team.Team.CT.Visible = Attribute == "Counter-Terrorists";
    u2.Team.Team.T.Visible = Attribute == "Terrorists";
    local Team = u2.Team.Team;
    local v6;

    if LocalPlayer:GetAttribute("Team") == "Terrorists" then
        v6 = Color3_fromRGB_ret2;
    else
        v6 = Color3_fromRGB_ret;
    end;

    Team.ImageColor3 = v6;
end;

local function applyPreferenceColorToCard(p7: any, p8) -- Line: 73
    p7.Amount.TextColor3 = p8;
    p7.ImageColor3 = p8;

    for _, v in p7:QueryDescendants("UIStroke, ImageLabel") do
        if v:IsA("UIStroke") then
            v.Color = p8;
        else
            v.ImageColor3 = p8;
        end;
    end;
end;

local function tweenKillHighlight(p9: any, p10: number, p11) -- Line: 86
    -- upvalues: TweenService (copy), u2 (ref)
    local TweenInfo_new_ret = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    TweenService:Create(p9.Animation, TweenInfo_new_ret, {
        ImageTransparency = p10
    }):Play();
    TweenService:Create(u2.Team.Team, TweenInfo_new_ret, {
        ImageColor3 = p11
    }):Play();
end;

function u1.createAnimationFrame(p12) -- Line: 95
    -- upvalues: LocalPlayer (copy), u2 (ref), ReplicatedStorage (copy), applyPreferenceColorToCard (copy), GetPreferenceColor (copy), TweenService (copy), tweenKillHighlight (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy)
    local Attribute = LocalPlayer:GetAttribute("Team");

    if not Attribute or Attribute == "Spectators" then
        return;
    end;

    local v13 = #u2.Cards:GetChildren() + 1;

    if v13 > 5 then
        return;
    end;

    local v14 = Attribute == "Counter-Terrorists" and ReplicatedStorage.Assets.UI.Team.CTCard;

    if not v14 then
        if Attribute == "Terrorists" then
            v14 = ReplicatedStorage.Assets.UI.Team.TCard;
        else
            v14 = false;
        end;
    end;

    local u15 = v14:Clone();
    u15.Amount.Text = tostring(v13);
    u15.Position = UDim2.fromScale(0.5, 1);
    u15.Name = tostring(v13);
    u15.Animation.ImageTransparency = 1;
    u15.Animation.Visible = false;
    u15.Parent = u2.Cards;
    u15.Rotation = -10;
    u15.Visible = true;
    applyPreferenceColorToCard(u15, GetPreferenceColor());

    for _, child in u2.Cards:GetChildren() do
        local v16 = tonumber(child.Name) - math.floor((v13 + 1) / 2);
        local v17 = v13 == 1 and 0 or (v16 * 0.2617993877991494 or 0);
        local v18 = v13 >= 3 and (child.Name == "1" and 0.75 or (child.Name == "2" and 0.75 or 0.85)) or 0.85;
        local v19 = v13 >= 3 and (child.Name == "1" and 0.25 or (child.Name == "2" and 0.125 or 0.05)) or 0.05;
        TweenService:Create(child, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(math.sin(v17) * v18 + 0.5, math.cos(v17) * v19 + 0.45),
            Rotation = math.deg(v17)
        }):Play();
    end;

    tweenKillHighlight(u15, 0.2, Color3_fromRGB_ret3);
    task.delay(0.5, function() -- Line: 142
        -- upvalues: u15 (copy), tweenKillHighlight (ref), LocalPlayer (ref), Color3_fromRGB_ret2 (ref), Color3_fromRGB_ret (ref)
        if not (u15 and u15:FindFirstChild("Animation")) then
            return;
        end;

        local v20;

        if LocalPlayer:GetAttribute("Team") == "Terrorists" then
            v20 = Color3_fromRGB_ret2;
        else
            v20 = Color3_fromRGB_ret;
        end;

        tweenKillHighlight(u15, 1, v20);
    end);
end;

function u1.OpenFrame() -- Line: 152
    -- upvalues: u3 (ref), u2 (ref), GetPreferenceColor (copy), LocalPlayer (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy)
    u3.Gameplay.Bottom.Middle.Spectate.Visible = false;
    u2.Cards.Visible = true;
    u2.Visible = true;
    local v21 = GetPreferenceColor();
    u2.Team.Outline.ImageColor3 = v21;
    u2.Line1.ImageColor3 = v21;
    u2.Line2.ImageColor3 = v21;
    local Attribute = LocalPlayer:GetAttribute("Team");
    u2.Team.Team.CT.Visible = Attribute == "Counter-Terrorists";
    u2.Team.Team.T.Visible = Attribute == "Terrorists";
    local Team = u2.Team.Team;
    local v22;

    if LocalPlayer:GetAttribute("Team") == "Terrorists" then
        v22 = Color3_fromRGB_ret2;
    else
        v22 = Color3_fromRGB_ret;
    end;

    Team.ImageColor3 = v22;
end;

function u1.CloseFrame() -- Line: 159
    -- upvalues: u2 (ref)
    u2.Cards:ClearAllChildren();
    u2.Cards.Visible = false;
    u2.Visible = false;
end;

function u1.Initialize(p23, p24) -- Line: 168
    -- upvalues: u3 (ref), u2 (ref), GetPreferenceColor (copy), LocalPlayer (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy), applyPreferenceColorToCard (copy), DataController (copy)
    u3 = p23;
    u2 = p24;

    local function refreshTeamColors() -- Line: 179
        -- upvalues: GetPreferenceColor (ref), u2 (ref), LocalPlayer (ref), Color3_fromRGB_ret2 (ref), Color3_fromRGB_ret (ref), applyPreferenceColorToCard (ref)
        local v25 = GetPreferenceColor();
        u2.Team.Outline.ImageColor3 = v25;
        u2.Line1.ImageColor3 = v25;
        u2.Line2.ImageColor3 = v25;
        local Attribute = LocalPlayer:GetAttribute("Team");
        u2.Team.Team.CT.Visible = Attribute == "Counter-Terrorists";
        u2.Team.Team.T.Visible = Attribute == "Terrorists";
        local Team = u2.Team.Team;
        local v26;

        if LocalPlayer:GetAttribute("Team") == "Terrorists" then
            v26 = Color3_fromRGB_ret2;
        else
            v26 = Color3_fromRGB_ret;
        end;

        Team.ImageColor3 = v26;
        local v27 = GetPreferenceColor();

        for _, child in u2.Cards:GetChildren() do
            if child:IsA("ImageLabel") and (child:FindFirstChild("Amount") and (child:FindFirstChild("Skull1") and (child:FindFirstChild("Skull2") and child:FindFirstChild("Animation")))) then
                applyPreferenceColorToCard(child, v27);
            end;
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshTeamColors);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(refreshTeamColors);
end;

function u1.Start() -- Line: 205
    -- upvalues: LocalPlayer (copy), u1 (copy), Remotes (copy), u2 (ref)
    LocalPlayer.CharacterAdded:Connect(u1.OpenFrame);
    LocalPlayer.CharacterRemoving:Connect(u1.CloseFrame);

    if LocalPlayer.Character and not LocalPlayer:GetAttribute("IsSpectating") then
        u1.OpenFrame();
    else
        u1.CloseFrame();
    end;

    Remotes.UI.UIPlayerKilled.Listen(function(p28) -- Line: 225
        -- upvalues: u2 (ref), LocalPlayer (ref), u1 (ref)
        if u2.Visible and LocalPlayer.UserId == tonumber(p28.Killer) then
            u1.createAnimationFrame(p28);
        end;
    end);
end;

return u1;