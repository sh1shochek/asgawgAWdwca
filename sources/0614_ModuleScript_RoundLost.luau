-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;

function v1.Initialize(p3, p4) -- Line: 25
    -- upvalues: u2 (ref), GameState (copy), Remotes (copy), LocalPlayer (copy)
    u2 = p4;
    GameState.ListenToState(function(p5, p6) -- Line: 29
        -- upvalues: u2 (ref)
        if p5 == "Intermission" and p6 == "Buy Period" or p6 == "Round In Progress" then
            u2.Visible = false;
        end;
    end);
    Remotes.UI.RoundWinner.Listen(function(p7) -- Line: 36
        -- upvalues: LocalPlayer (ref), u2 (ref)
        if LocalPlayer:GetAttribute("Team") ~= p7 then
            u2.Visible = true;
        end;
    end);
end;

return v1;