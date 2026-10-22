-- ReplicatedStorage.Shared.Managers.SoundManager.Modifiers.Footstep
-- Script path: ReplicatedStorage.Shared.Managers.SoundManager.Modifiers.Footstep
-- Decompile time: 7.35 ms

-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.SoundData);
require(script.Parent.Parent.SoundData.Footsteps);
local Pitch = require(script.Parent.Pitch);

local function PickWave(p1: table, p2: number) -- Line: 16
    local v3 = math.floor((#p1 - p2) / 2) + 1;

    if v3 < 1 then
        return p1[math.random(#p1)];
    end;

    return p1[p2 + 2 * (math.random(v3) - 1)];
end;

return function(p4: any, p5: boolean) -- Line: 26
    -- upvalues: Pitch (copy)
    local u6 = p5 and 2 or 1;
    local u7 = Pitch(p4.Pitch);
    local u8 = p4.Volume or 1;

    return function(p9: any, p10: string, p11: any) -- Line: 31
        -- upvalues: u6 (copy), u8 (copy), u7 (copy)
        local Wave = p11.Wave;
        local v12 = u6;
        local v13 = math.floor((#Wave - v12) / 2) + 1;
        local v14;

        if v13 < 1 then
            v14 = Wave[math.random(#Wave)];
        else
            v14 = Wave[v12 + 2 * (math.random(v13) - 1)];
        end;

        p9.SoundId = v14;
        p9.Volume = p9.Volume * u8;
        u7(p9);
    end;
end;