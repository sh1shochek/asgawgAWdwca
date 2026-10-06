-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ActionTemplates = require(script.Parent.Parent.ActionTemplates);
local LocalPlayer = Players.LocalPlayer;

return ActionTemplates.chat("Team Message", function() -- Line: 9
    -- upvalues: LocalPlayer (copy)
    local Attribute = LocalPlayer:GetAttribute("Team");

    return (not Attribute or Attribute == "Spectators") and 1 or 0;
end);