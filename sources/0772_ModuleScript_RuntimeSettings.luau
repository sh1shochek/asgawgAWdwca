-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");
local Config = require(script.Parent.Config);

return table.freeze({
    getMovementConfig = function(p1: number?) -- Line: 9, Name: getMovementConfig
        -- upvalues: Workspace (copy), Config (copy)
        local Attribute = Workspace:GetAttribute("ServerGamemode");

        if Attribute == "Surf" then
            return Config.resolveServerGamemode(Attribute, p1);
        end;

        local Attribute2 = Workspace:GetAttribute("VIPCompetitiveMovementEnabled");

        if typeof(Attribute2) == "boolean" then
            return Config.resolveServerGamemode(Attribute2 and "Competitive" or "Casual", p1);
        end;

        return Config.resolveServerGamemode(Attribute, p1);
    end
});