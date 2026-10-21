-- ReplicatedStorage.Interface.Screens.Gameplay.Top.SurvivalCandies
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Top.SurvivalCandies
-- Decompile time: 3.01 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local HalloweenEvent = require(ReplicatedStorage.Interface.Screens.Menu.HalloweenEvent);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;

local function updateFrameVisibility() -- Line: 44
    -- upvalues: u3 (ref), u2 (ref), IsSurvivalMode (copy)
    if not (u3 and u2) then
        return;
    end;

    local TeamSelection = u2.Gameplay.Middle.TeamSelection;
    local v4 = IsSurvivalMode() and not TeamSelection.Visible;
    u3.Visible = v4;
end;

local function applyHudColor() -- Line: 53
    -- upvalues: GetPreferenceColor (copy), u3 (ref)
    local v5 = GetPreferenceColor();
    u3.Icon.UIStroke.Color = v5;
    u3.Panel.UIStroke.Color = v5;
end;

function v1.Initialize(p6: userdata, p7: userdata) -- Line: 62
    -- upvalues: u2 (ref), u3 (ref), updateFrameVisibility (copy), IsSurvivalMode (copy)
    u2 = p6;
    u3 = p7;
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(updateFrameVisibility);
    u2.Gameplay.Middle.TeamSelection:GetPropertyChangedSignal("Visible"):Connect(updateFrameVisibility);

    if u3 then
        if not u2 then
            return;
        end;

        local TeamSelection = u2.Gameplay.Middle.TeamSelection;
        local v8 = IsSurvivalMode() and not TeamSelection.Visible;
        u3.Visible = v8;
    end;
end;

function v1.Start() -- Line: 70
    -- upvalues: HalloweenEvent (copy), u3 (ref), GetPreferenceColor (copy), DataController (copy), LocalPlayer (copy), applyHudColor (copy)
    HalloweenEvent.BindCandyLabel(u3.Panel.Amount);
    local v9 = GetPreferenceColor();
    u3.Icon.UIStroke.Color = v9;
    u3.Panel.UIStroke.Color = v9;
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 74
        -- upvalues: GetPreferenceColor (ref), u3 (ref)
        local v10 = GetPreferenceColor();
        u3.Icon.UIStroke.Color = v10;
        u3.Panel.UIStroke.Color = v10;

        return nil;
    end);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(applyHudColor);
end;

return v1;