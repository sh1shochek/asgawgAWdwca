-- ReplicatedStorage.Components.Common.CanUseWeapon
-- Script path: ReplicatedStorage.Components.Common.CanUseWeapon
-- Decompile time: 5.45 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SurvivalDowned = require(ReplicatedStorage.Components.Common.SurvivalDowned);

return function(p1: userdata?, p2: string?) -- Line: 8
    -- upvalues: SurvivalDowned (copy)
    local v3;

    if p1 == nil or (p1:GetAttribute("IsPlantingBomb") == true or (p1:GetAttribute("IsDefusingBomb") == true or p1:GetAttribute("IsRescuingHostage") == true)) then
        v3 = false;
    else
        v3 = SurvivalDowned.CanUseSlot(p1, p2);
    end;

    return v3;
end;