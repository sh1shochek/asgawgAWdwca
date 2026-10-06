-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local LocalPlayer = Players.LocalPlayer;
local v1 = Enum.ContextActionPriority.High.Value + 1;
LocalPlayer:GetAttributeChangedSignal("IsPlayerChatting"):Connect(function() -- Line: 21
    -- upvalues: LocalPlayer (copy), CharacterController (copy)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        CharacterController.walk(false);
    end;
end);

return table.freeze({
    Name = "Walk",
    Group = "Default",
    Category = "Movement Keys",
    BindPriority = v1,

    Callback = function(p2: any, p3: userdata) -- Line: 30, Name: onInput
        -- upvalues: LocalPlayer (copy), CharacterResolver (copy), DataController (copy), CharacterController (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if not CharacterResolver.isAliveCharacter(CharacterResolver.getPlayerCharacter(LocalPlayer)) then
            return;
        end;

        if DataController.Get(LocalPlayer, "Settings.Keyboard/Mouse.Keyboard & Mouse Settings.Walk Mode") == "Toggle" then
            if p2 == Enum.UserInputState.Begin then
                CharacterController.walk(not CharacterController.GetWalkState());
            end;
        else
            if p2 == Enum.UserInputState.Begin then
                CharacterController.walk(true);

                return;
            end;

            if p2 == Enum.UserInputState.End then
                CharacterController.walk(false);
            end;
        end;
    end
});