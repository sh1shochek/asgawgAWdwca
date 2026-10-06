-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local LocalPlayer = Players.LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors);
local u1 = Colors["Team Color"]["Counter-Terrorists"];

return function() -- Line: 25
    -- upvalues: DataController (copy), LocalPlayer (copy), Colors (copy), u1 (copy)
    local v2 = DataController.Get(LocalPlayer, "Settings.Game.HUD.Color");
    local Attribute = LocalPlayer:GetAttribute("Team");

    return Colors[v2] and Colors[v2][Attribute] or u1;
end;