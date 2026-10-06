-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
require(script:WaitForChild("Types"));
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local Participants = require(ReplicatedStorage.Components.Common.Participants);
local UDim2_new_ret = UDim2.new(0.99, 0, 0.18, 0);
local UDim2_new_ret2 = UDim2.new(0.99, 0, 0.068, 0);
local UDim_new_ret = UDim.new(0, 5);
local Color3_fromRGB_ret = Color3.fromRGB(255, 0, 0);
local Color3_fromRGB_ret2 = Color3.fromRGB(165, 183, 212);
local Color3_fromRGB_ret3 = Color3.fromRGB(219, 199, 126);
local Color3_fromRGB_ret4 = Color3.fromRGB(255, 255, 255);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = {};
local u4 = {
    [2] = "got a Multi Kill",
    [3] = "is on a Killing Spree",
    [4] = "is on a Rampage",
    [5] = "is Dominating",
    [6] = "got a M-M-Monster Kill",
    [7] = "is going Ludicrus",
    [8] = "is Unstoppable",
    [9] = "is Godlike"
};
local u5 = { "Weapon", "Headshot", "NoScope", "Smoke", "Wallbang", "Blind", "Jump", "FlashAssist", "Addition", "Assistor", "Enemy" };

local function applyParticipantLabel(p6: any, p7: userdata, p8: any, p9: number) -- Line: 67
    -- upvalues: Participants (copy), LocalPlayer (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy)
    local Attribute = p8:GetAttribute("Team");
    p7.Text = Participants.DisplayName(p8);
    p7.Visible = true;

    if LocalPlayer.UserId == p9 then
        p6.UIStroke.Color = Color3_fromRGB_ret;
    end;

    if Attribute == "Counter-Terrorists" then
        p7.TextColor3 = Color3_fromRGB_ret2;

        return;
    end;

    if Attribute == "Terrorists" then
        p7.TextColor3 = Color3_fromRGB_ret3;
    end;
end;

local function convertTextLabel(p10: any, p11: userdata, p12: number?) -- Line: 83
    -- upvalues: Participants (copy), LocalPlayer (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy)
    if not p12 then
        return;
    end;

    local v13 = Participants.FromKey(p12);

    if v13 and v13.Parent then
        local Attribute = v13:GetAttribute("Team");
        p11.Text = Participants.DisplayName(v13);
        p11.Visible = true;

        if LocalPlayer.UserId == p12 then
            p10.UIStroke.Color = Color3_fromRGB_ret;
        end;

        if Attribute == "Counter-Terrorists" then
            p11.TextColor3 = Color3_fromRGB_ret2;

            return;
        end;

        if Attribute == "Terrorists" then
            p11.TextColor3 = Color3_fromRGB_ret3;
        end;
    else
        p11.Visible = false;
    end;
end;

local function applyContentPadding(p14: userdata) -- Line: 95
    -- upvalues: UDim_new_ret (copy)
    local UIPadding = p14:FindFirstChild("UIPadding");

    if not UIPadding then
        UIPadding = Instance.new("UIPadding");
        UIPadding.Parent = p14;
    end;

    UIPadding.PaddingLeft = UDim_new_ret;
    UIPadding.PaddingRight = UDim_new_ret;
end;

local function scheduleFadeOut(u15) -- Line: 105
    -- upvalues: TweenService (copy), Debris (copy)
    task.delay(5, function() -- Line: 106
        -- upvalues: TweenService (ref), u15 (copy), Debris (ref)
        TweenService:Create(u15, TweenInfo.new(1), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(u15.UIStroke, TweenInfo.new(1), {
            Transparency = 1
        }):Play();
        Debris:AddItem(u15, 1);
    end);
end;

local function createStreakTemplate(p16: number, p17: string) -- Line: 117
    -- upvalues: ReplicatedStorage (copy), u5 (copy), UDim_new_ret (copy), Participants (copy), Debris (copy), LocalPlayer (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret4 (copy), u2 (ref), TweenService (copy)
    local u18 = ReplicatedStorage.Assets.UI.KillFeed.Kill:Clone();
    local Contents = u18.Contents;

    for _, v in ipairs(u5) do
        Contents[v].Visible = false;
    end;

    local UIPadding = Contents:FindFirstChild("UIPadding");

    if not UIPadding then
        UIPadding = Instance.new("UIPadding");
        UIPadding.Parent = Contents;
    end;

    UIPadding.PaddingLeft = UDim_new_ret;
    UIPadding.PaddingRight = UDim_new_ret;
    local Player = Contents.Player;
    local v19 = Participants.FromKey(p16);

    if not (v19 and v19.Parent) then
        Debris:AddItem(u18, 0);

        return;
    end;

    local Attribute = v19:GetAttribute("Team");
    Player.Text = Participants.DisplayName(v19);
    Player.Visible = true;

    if LocalPlayer.UserId == p16 then
        u18.UIStroke.Color = Color3_fromRGB_ret;
    end;

    if Attribute == "Counter-Terrorists" then
        Player.TextColor3 = Color3_fromRGB_ret2;
    elseif Attribute == "Terrorists" then
        Player.TextColor3 = Color3_fromRGB_ret3;
    end;

    local Enemy = Contents.Enemy;
    Enemy.Text = p17;
    Enemy.TextColor3 = Color3_fromRGB_ret4;
    Enemy.Visible = true;
    Player.LayoutOrder = 0;
    Enemy.LayoutOrder = 1;
    u18.Visible = true;
    u18.Parent = u2;
    task.delay(5, function() -- Line: 106
        -- upvalues: TweenService (ref), u18 (copy), Debris (ref)
        TweenService:Create(u18, TweenInfo.new(1), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(u18.UIStroke, TweenInfo.new(1), {
            Transparency = 1
        }):Play();
        Debris:AddItem(u18, 1);
    end);
end;

function u1.createTemplate(p20) -- Line: 157
    -- upvalues: ReplicatedStorage (copy), u2 (ref), UDim_new_ret (copy), Participants (copy), LocalPlayer (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy), TweenService (copy), Debris (copy)
    local v21 = require(ReplicatedStorage.Database.Custom.Weapons[p20.Weapon]);
    u2.Visible = true;
    local u22 = ReplicatedStorage.Assets.UI.KillFeed.Kill:Clone();
    local Contents = u22.Contents;
    local UIPadding = Contents:FindFirstChild("UIPadding");

    if not UIPadding then
        UIPadding = Instance.new("UIPadding");
        UIPadding.Parent = Contents;
    end;

    UIPadding.PaddingLeft = UDim_new_ret;
    UIPadding.PaddingRight = UDim_new_ret;
    local Player = u22.Contents.Player;
    local v23 = tonumber(p20.Killer);

    if v23 then
        local v24 = Participants.FromKey(v23);

        if v24 and v24.Parent then
            local Attribute = v24:GetAttribute("Team");
            Player.Text = Participants.DisplayName(v24);
            Player.Visible = true;

            if LocalPlayer.UserId == v23 then
                u22.UIStroke.Color = Color3_fromRGB_ret;
            end;

            if Attribute == "Counter-Terrorists" then
                Player.TextColor3 = Color3_fromRGB_ret2;
            elseif Attribute == "Terrorists" then
                Player.TextColor3 = Color3_fromRGB_ret3;
            end;
        else
            Player.Visible = false;
        end;
    end;

    local Enemy = u22.Contents.Enemy;
    local v25 = tonumber(p20.Victim);

    if v25 then
        local v26 = Participants.FromKey(v25);

        if v26 and v26.Parent then
            local Attribute = v26:GetAttribute("Team");
            Enemy.Text = Participants.DisplayName(v26);
            Enemy.Visible = true;

            if LocalPlayer.UserId == v25 then
                u22.UIStroke.Color = Color3_fromRGB_ret;
            end;

            if Attribute == "Counter-Terrorists" then
                Enemy.TextColor3 = Color3_fromRGB_ret2;
            elseif Attribute == "Terrorists" then
                Enemy.TextColor3 = Color3_fromRGB_ret3;
            end;
        else
            Enemy.Visible = false;
        end;
    end;

    if p20.Assistor then
        local Assistor = u22.Contents.Assistor;
        local v27 = tonumber(p20.Assistor);

        if v27 then
            local v28 = Participants.FromKey(v27);

            if v28 and v28.Parent then
                local Attribute = v28:GetAttribute("Team");
                Assistor.Text = Participants.DisplayName(v28);
                Assistor.Visible = true;

                if LocalPlayer.UserId == v27 then
                    u22.UIStroke.Color = Color3_fromRGB_ret;
                end;

                if Attribute == "Counter-Terrorists" then
                    Assistor.TextColor3 = Color3_fromRGB_ret2;
                elseif Attribute == "Terrorists" then
                    Assistor.TextColor3 = Color3_fromRGB_ret3;
                end;
            else
                Assistor.Visible = false;
            end;
        end;

        u22.Contents.Addition.Visible = true;
        u22.Contents.FlashAssist.Visible = p20.FlashAssist == true;
    else
        u22.Contents.Assistor.Visible = false;
        u22.Contents.Addition.Visible = false;
        u22.Contents.FlashAssist.Visible = false;
    end;

    u22.Contents.Weapon.Image = v21.ReverseIcon;
    u22.Contents.Headshot.Visible = p20.Headshot;
    u22.Contents.NoScope.Visible = p20.NoScope == true;
    u22.Contents.Smoke.Visible = p20.Smoke == true;
    u22.Contents.Blind.Visible = p20.Blind == true;
    u22.Contents.Wallbang.Visible = p20.Wallbang == true;
    u22.Contents.Jump.Visible = p20.Jump == true;
    u22.Contents:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 189, Name: updateIconSizes
        -- upvalues: u22 (copy)
        local Player2 = u22.Contents.Player;

        if Player2 and Player2.AbsoluteSize.Y > 0 then
            local v29 = Player2.AbsoluteSize.Y * 0.84 * 1.67;
            u22.Contents.Headshot.Size = UDim2.new(0, v29, 0, v29);
            u22.Contents.NoScope.Size = UDim2.new(0, v29 * 0.8333333333333334, 0, v29 * 0.8333333333333334);
            u22.Contents.Smoke.Size = UDim2.new(0, v29 * 1.1111111111111112, 0, v29 * 0.7777777777777778);
            u22.Contents.Wallbang.Size = UDim2.new(0, v29 * 1.1111111111111112, 0, v29 * 1.1111111111111112);
            u22.Contents.Blind.Size = UDim2.new(0, v29 * 0.8333333333333334, 0, v29 * 0.8333333333333334);
            u22.Contents.Jump.Size = UDim2.new(0, v29, 0, v29);
            u22.Contents.FlashAssist.Size = UDim2.new(0, v29, 0, v29);
        end;
    end);
    local Contents2 = u22.Contents;
    local u30 = 0;

    local function placeNext(p31: userdata) -- Line: 213
        -- upvalues: u30 (ref)
        p31.LayoutOrder = u30;
        u30 = u30 + 1;
    end;

    if p20.Blind == true then
        Contents2.Blind.LayoutOrder = u30;
        u30 = u30 + 1;
    end;

    Contents2.Player.LayoutOrder = u30;
    u30 = u30 + 1;

    if p20.Assistor then
        Contents2.Addition.LayoutOrder = u30;
        u30 = u30 + 1;

        if p20.FlashAssist == true then
            Contents2.FlashAssist.LayoutOrder = u30;
            u30 = u30 + 1;
        end;

        Contents2.Assistor.LayoutOrder = u30;
        u30 = u30 + 1;
    end;

    if p20.Jump == true then
        Contents2.Jump.LayoutOrder = u30;
        u30 = u30 + 1;
    end;

    Contents2.Weapon.LayoutOrder = u30;
    u30 = u30 + 1;

    for _, v in ipairs({ "NoScope", "Smoke", "Wallbang", "Headshot" }) do
        if p20[v] == true then
            Contents2[v].LayoutOrder = u30;
            u30 = u30 + 1;
        end;
    end;

    Contents2.Enemy.LayoutOrder = u30;
    u22.Visible = true;
    u22.Parent = u2;
    task.delay(5, function() -- Line: 106
        -- upvalues: TweenService (ref), u22 (copy), Debris (ref)
        TweenService:Create(u22, TweenInfo.new(1), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(u22.UIStroke, TweenInfo.new(1), {
            Transparency = 1
        }):Play();
        Debris:AddItem(u22, 1);
    end);
end;

function u1.Initialize(p32, p33) -- Line: 249
    -- upvalues: u2 (ref), GetUserPlatform (copy), UDim2_new_ret (copy), UDim2_new_ret2 (copy), ReplicatedStorage (copy), Remotes (copy), u1 (copy), u3 (copy), u4 (copy), createStreakTemplate (copy), GameState (copy)
    u2 = p33;
    local v34;

    if table.find(GetUserPlatform(), "Mobile") ~= nil then
        v34 = UDim2_new_ret;
    else
        v34 = UDim2_new_ret2;
    end;

    u2.Position = v34;
    local Kill = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("UI"):WaitForChild("KillFeed"):WaitForChild("Kill");
    Kill.AutoLocalize = false;

    for _, descendant in Kill:GetDescendants() do
        if descendant:IsA("GuiBase2d") then
            descendant.AutoLocalize = false;
        end;
    end;

    Remotes.UI.UIPlayerKilled.Listen(function(p35) -- Line: 265
        -- upvalues: u1 (ref), u3 (ref), u4 (ref), createStreakTemplate (ref)
        u1.createTemplate(p35);

        if workspace:GetAttribute("Gamemode") == "Deathmatch" then
            local Killer = p35.Killer;
            u3[p35.Victim] = 0;
            local v36 = (u3[Killer] or 0) + 1;
            u3[Killer] = v36;
            local v37 = u4[math.min(v36, 9)];

            if v37 then
                createStreakTemplate(tonumber(Killer), v37);
            end;
        end;
    end);
    GameState.ListenToState(function() -- Line: 285
        -- upvalues: u3 (ref)
        table.clear(u3);
    end);
end;

return u1;