-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Constants = require(script.Parent.Parent.Shared.Constants);
local v1 = {
    internal = {},
    interface = {}
};

function v1.interface.isLocalPlayerAuthorized() -- Line: 10
    -- upvalues: RunService (copy), Players (copy), Constants (copy)
    return RunService:IsStudio() and true or Players.LocalPlayer:GetRankInGroup(Constants.GROUP_ID) >= Constants.GROUP_RANK;
end;

return v1.interface;