-- ReplicatedStorage.Shared.Managers.SoundManager.Modifiers.Landing
-- Script path: ReplicatedStorage.Shared.Managers.SoundManager.Modifiers.Landing
-- Decompile time: 6.92 ms

-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.SoundData.Footsteps);
local Pitch = require(script.Parent.Pitch);

return function(p1) -- Line: 8
    -- upvalues: Pitch (copy)
    local u2 = Pitch(p1.LandPitch);
    local u3 = p1.LandVolume or 1;

    return function(p4) -- Line: 12
        -- upvalues: u3 (copy), u2 (copy)
        p4.Volume = p4.Volume * u3;
        u2(p4);
    end;
end;