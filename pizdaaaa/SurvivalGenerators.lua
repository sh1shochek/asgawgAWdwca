-- ReplicatedStorage.Interface.Screens.Gameplay.Top.SurvivalGenerators
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Top.SurvivalGenerators
-- Decompile time: 6.81 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local GeneratorController = require(ReplicatedStorage.Controllers.GeneratorController);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(165, 183, 212);
local Color3_fromRGB_ret3 = Color3.fromRGB(214, 41, 41);
local Color3_fromRGB_ret4 = Color3.fromRGB(230, 238, 255);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = {};

local function applyHudColor(p5) -- Line: 56
    -- upvalues: GetPreferenceColor (copy)
    local v6 = GetPreferenceColor();
    p5.Letter.UIStroke.Color = v6;
    p5.Panel.UIStroke.Color = v6;
end;

local function applyHudColorToRows() -- Line: 62
    -- upvalues: u4 (copy), GetPreferenceColor (copy)
    for _, v in u4 do
        local Frame = v.Frame;
        local v7 = GetPreferenceColor();
        Frame.Letter.UIStroke.Color = v7;
        Frame.Panel.UIStroke.Color = v7;
    end;
end;

local function createRow(p8: string) -- Line: 68
    -- upvalues: ReplicatedStorage (copy), GetPreferenceColor (copy), u3 (ref), u4 (copy)
    local v9 = ReplicatedStorage.Assets.UI.Survival.GeneratorTemplate:Clone();
    v9.Name = p8;
    v9.LayoutOrder = string.byte(p8) or 0;
    v9.Letter.Text = p8;
    local v10 = GetPreferenceColor();
    v9.Letter.UIStroke.Color = v10;
    v9.Panel.UIStroke.Color = v10;
    v9.Parent = u3;
    local v11 = {
        Destroyed = false,
        Frame = v9
    };
    u4[p8] = v11;

    return v11;
end;

local function applyRow(p12) -- Line: 81
    -- upvalues: u4 (copy), createRow (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret4 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    local v13 = u4[p12.Key] or createRow(p12.Key);
    local Frame = v13.Frame;
    local Destroyed = p12.Destroyed;
    local v14 = p12.MaxHealth <= 0 and 0 or math.clamp(p12.Health / p12.MaxHealth, 0, 1);
    v13.Destroyed = Destroyed;
    Frame.Panel.Track.Bar.Size = UDim2.fromScale(v14, 1);
    local v15;

    if Destroyed or v14 <= 0.25 then
        v15 = Color3_fromRGB_ret3;
    else
        v15 = Color3_fromRGB_ret4;
    end;

    Frame.Panel.Track.Bar.BackgroundColor3 = v15;
    Frame.Panel.Amount.Text = Destroyed and "OFFLINE" or `{math.floor(v14 * 100 + 0.5)}%`;
    local v16;

    if Destroyed then
        v16 = Color3_fromRGB_ret3;
    else
        v16 = Color3_fromRGB_ret;
    end;

    Frame.Panel.Amount.TextColor3 = v16;
    local v17;

    if Destroyed then
        v17 = Color3_fromRGB_ret3;
    else
        v17 = Color3_fromRGB_ret2;
    end;

    Frame.Letter.TextColor3 = v17;
end;

local function updateFrameVisibility() -- Line: 94
    -- upvalues: u3 (ref), u2 (ref), IsSurvivalMode (copy), u4 (copy)
    if not (u3 and u2) then
        return;
    end;

    local TeamSelection = u2.Gameplay.Middle.TeamSelection;
    local v18 = IsSurvivalMode();

    if v18 then
        if next(u4) == nil then
            v18 = false;
        else
            v18 = not TeamSelection.Visible;
        end;
    end;

    u3.Visible = v18;
end;

local function onGeneratorState(p19) -- Line: 102
    -- upvalues: u4 (copy), applyRow (copy), u3 (ref), u2 (ref), IsSurvivalMode (copy)
    if p19.Key == "" then
        for i, v in u4 do
            v.Frame:Destroy();
            u4[i] = nil;
        end;
    else
        applyRow(p19);
    end;

    if u3 then
        if not u2 then
            return;
        end;

        local TeamSelection = u2.Gameplay.Middle.TeamSelection;
        local v20 = IsSurvivalMode();

        if v20 then
            if next(u4) == nil then
                v20 = false;
            else
                v20 = not TeamSelection.Visible;
            end;
        end;

        u3.Visible = v20;
    end;
end;

function v1.Initialize(p21: userdata, p22: userdata) -- Line: 118
    -- upvalues: u2 (ref), u3 (ref), updateFrameVisibility (copy), IsSurvivalMode (copy), u4 (copy)
    u2 = p21;
    u3 = p22;
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(updateFrameVisibility);
    u2.Gameplay.Middle.TeamSelection:GetPropertyChangedSignal("Visible"):Connect(updateFrameVisibility);

    if u3 then
        if not u2 then
            return;
        end;

        local TeamSelection = u2.Gameplay.Middle.TeamSelection;
        local v23 = IsSurvivalMode();

        if v23 then
            if next(u4) == nil then
                v23 = false;
            else
                v23 = not TeamSelection.Visible;
            end;
        end;

        u3.Visible = v23;
    end;
end;

function v1.Start() -- Line: 126
    -- upvalues: GeneratorController (copy), onGeneratorState (copy), DataController (copy), LocalPlayer (copy), u4 (copy), GetPreferenceColor (copy), applyHudColorToRows (copy)
    GeneratorController.Bind(onGeneratorState);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 129
        -- upvalues: u4 (ref), GetPreferenceColor (ref)
        for _, v in u4 do
            local Frame = v.Frame;
            local v24 = GetPreferenceColor();
            Frame.Letter.UIStroke.Color = v24;
            Frame.Panel.UIStroke.Color = v24;
        end;

        return nil;
    end);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(applyHudColorToRows);
end;

return v1;