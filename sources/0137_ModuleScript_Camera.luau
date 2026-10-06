-- Decompiled with Potassium's decompiler.

local EmitParticles = require(script.Parent.EmitParticles);

return function(p1: userdata, p2: string) -- Line: 6
    -- upvalues: EmitParticles (copy)
    debug.profilebegin("VFX.MuzzleFlash.Camera");
    local v3 = p1:FindFirstChild(p2);

    if not v3 then
        debug.profileend();

        return nil;
    end;

    debug.profilebegin("VFX.MuzzleFlash.Camera.EmitParticles");
    EmitParticles(v3);
    debug.profileend();
    debug.profileend();

    return p1.Position;
end;