-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration);
local CharacterActions = require(ReplicatedStorage.Database.Components.CharacterActions);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local LocalPlayer = Players.LocalPlayer;

return function(p1: string) -- Line: 15
    -- upvalues: CharacterActions (copy), CharacterGeneration (copy), LocalPlayer (copy), Remotes (copy)
    local v2 = CharacterActions.ToId(p1);

    if not v2 then
        return;
    end;

    local v3 = CharacterGeneration.Get(LocalPlayer.Character);

    if v3 == nil then
        return;
    end;

    Remotes.Character.Action.Send({
        UserId = 0,
        Generation = v3,
        ActionId = v2
    });
end;