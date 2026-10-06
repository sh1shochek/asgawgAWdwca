-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local LocalPlayer = Players.LocalPlayer;

return table.freeze({
    Name = "Jump",
    Group = "Gameplay",
    Category = "Movement Keys",
    BindPriority = Enum.ContextActionPriority.High.Value + 1,

    Callback = function(p1: any, p2: userdata) -- Line: 21, Name: onInput
        -- upvalues: LocalPlayer (copy), CharacterController (copy)
        if p1 ~= Enum.UserInputState.Begin then
            if p1 == Enum.UserInputState.End or p1 == Enum.UserInputState.Cancel then
                if p2.UserInputType == Enum.UserInputType.MouseWheel then
                    return;
                end;

                CharacterController.jump(false);
            end;

            return;
        end;

        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p2.UserInputType == Enum.UserInputType.MouseWheel then
            CharacterController.jump();

            return;
        end;

        CharacterController.jump(true);
    end
});