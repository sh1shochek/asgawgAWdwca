-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script.Parent.Parent.Types);
local LocalPlayer = Players.LocalPlayer;
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local v1 = Enum.ContextActionPriority.High.Value + 1;
LocalPlayer:GetAttributeChangedSignal("IsPlayerChatting"):Connect(function() -- Line: 19
    -- upvalues: LocalPlayer (copy), CharacterController (copy)
    if LocalPlayer:GetAttribute("IsPlayerChatting") then
        CharacterController.crouch(false);
    end;
end);

return table.freeze({
    Name = "Crouch",
    Group = "Gameplay",
    Category = "Movement Keys",
    BindPriority = v1,

    Callback = function(p2: any, p3: userdata) -- Line: 28, Name: onInput
        -- upvalues: LocalPlayer (copy), CharacterController (copy)
        if LocalPlayer:GetAttribute("IsPlayerChatting") then
            return;
        end;

        if p2 == Enum.UserInputState.Begin then
            CharacterController.crouch(true);

            return;
        end;

        if p2 == Enum.UserInputState.End then
            CharacterController.crouch(false);
        end;
    end
});