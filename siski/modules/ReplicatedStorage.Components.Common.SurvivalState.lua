-- ReplicatedStorage.Components.Common.SurvivalState
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {
    WAVE_ATTRIBUTE = "SurvivalWave",
    WAVES_ATTRIBUTE = "SurvivalWaves",
    RESUPPLY_ATTRIBUTE = "SurvivalResupply",
    WAVE_STARTED_ATTRIBUTE = "SurvivalWaveStartedAt",
    FLAMING_WAVE_ATTRIBUTE = "SurvivalFlamingWave"
};

function u1.GetWave() -- Line: 21
    -- upvalues: u1 (copy)
    local Attribute = workspace:GetAttribute(u1.WAVE_ATTRIBUTE);

    return typeof(Attribute) ~= "number" and 0 or Attribute;
end;

function u1.GetWaveCount() -- Line: 26
    -- upvalues: u1 (copy)
    local Attribute = workspace:GetAttribute(u1.WAVES_ATTRIBUTE);

    return typeof(Attribute) ~= "number" and 0 or Attribute;
end;

function u1.IsResupply() -- Line: 31
    -- upvalues: u1 (copy)
    return workspace:GetAttribute(u1.RESUPPLY_ATTRIBUTE) == true;
end;

function u1.IsFlamingWave() -- Line: 35
    -- upvalues: u1 (copy)
    return workspace:GetAttribute(u1.FLAMING_WAVE_ATTRIBUTE) == true;
end;

function u1.GetWaveElapsed() -- Line: 40
    -- upvalues: u1 (copy)
    local Attribute = workspace:GetAttribute(u1.WAVE_STARTED_ATTRIBUTE);

    if typeof(Attribute) ~= "number" then
        return nil;
    end;

    local v2 = workspace:GetServerTimeNow() - Attribute;

    return math.max(v2, 0);
end;

return table.freeze(u1);