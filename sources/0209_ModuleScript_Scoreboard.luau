-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local Leaderboard = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Leaderboard);

return table.freeze({
    Name = "Scoreboard",
    Group = "Default",
    Category = "UI Keys",

    Callback = function(p1: any, p2: userdata) -- Line: 19, Name: onInput
        -- upvalues: LocalPlayer (copy), Leaderboard (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p1 == Enum.UserInputState.Begin then
            Leaderboard.openFrame();

            return;
        end;

        if p1 == Enum.UserInputState.End then
            Leaderboard.closeFrame();
        end;
    end
});