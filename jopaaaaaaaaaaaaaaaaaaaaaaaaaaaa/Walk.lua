-- ReplicatedStorage.Controllers.InputController.Actions.Walk
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.Walk
-- Decompile time: 3.22 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local LocalPlayer = Players.LocalPlayer;
local v1 = Enum.ContextActionPriority.High.Value + 1;
LocalPlayer:GetAttributeChangedSignal("IsPlayerChatting"):Connect(function() -- Line: 22
    -- upvalues: LocalPlayer (copy), CharacterController (copy)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        CharacterController.walk(false);
        CharacterController.sprint(false);
    end;
end);

local function setMoveModifier(p2: boolean) -- Line: 33
    -- upvalues: IsSurvivalMode (copy), CharacterController (copy)
    if IsSurvivalMode() then
        CharacterController.sprint(p2);

        return;
    end;

    CharacterController.walk(p2);
end;

local function getMoveModifier() -- Line: 41
    -- upvalues: IsSurvivalMode (copy), CharacterController (copy)
    local v3;

    if IsSurvivalMode() then
        v3 = CharacterController.GetSprintState();
    else
        v3 = CharacterController.GetWalkState();
    end;

    return v3 == true;
end;

return table.freeze({
    Name = "Walk",
    Group = "Default",
    Category = "Movement Keys",
    BindPriority = v1,

    Callback = function(p4: any, p5: userdata) -- Line: 49, Name: onInput
        -- upvalues: LocalPlayer (copy), CharacterResolver (copy), DataController (copy), IsSurvivalMode (copy), CharacterController (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if not CharacterResolver.isAliveCharacter(CharacterResolver.getPlayerCharacter(LocalPlayer)) then
            return;
        end;

        if DataController.Get(LocalPlayer, "Settings.Keyboard/Mouse.Keyboard & Mouse Settings.Walk Mode") == "Toggle" then
            if p4 == Enum.UserInputState.Begin then
                local v6;

                if IsSurvivalMode() then
                    v6 = CharacterController.GetSprintState();
                else
                    v6 = CharacterController.GetWalkState();
                end;

                local v7 = v6 ~= true;

                if IsSurvivalMode() then
                    CharacterController.sprint(v7);

                    return;
                end;

                CharacterController.walk(v7);
            end;
        else
            if p4 == Enum.UserInputState.Begin then
                if IsSurvivalMode() then
                    CharacterController.sprint(true);

                    return;
                end;

                CharacterController.walk(true);

                return;
            end;

            if p4 == Enum.UserInputState.End then
                if IsSurvivalMode() then
                    CharacterController.sprint(false);

                    return;
                end;

                CharacterController.walk(false);
            end;
        end;
    end
});