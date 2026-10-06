-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local ViewmodelHand = require(ReplicatedStorage.Shared.ViewmodelHand);
require(script.Parent.Parent.Types);

return table.freeze({
    Name = "Switch Viewmodel Left/Right Hand",
    Group = "Gameplay",
    Category = "Weapon Keys",

    Callback = function(p1) -- Line: 12, Name: Callback
        -- upvalues: Players (copy), SpectateController (copy), ViewmodelHand (copy)
        if p1 ~= Enum.UserInputState.Begin then
            return;
        end;

        if Players.LocalPlayer:GetAttribute("IsPlayerChatting") or SpectateController.IsSpectatingNow() then
            return;
        end;

        ViewmodelHand.Toggle();
    end
});