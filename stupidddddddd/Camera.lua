-- ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Camera
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Camera
-- Decompile time: 0.30 ms

local EmitParticles = require(script.Parent.EmitParticles)
return function(a1, a2) -- Line: 6 -- upvalues: EmitParticles (val) -- types: a1: userdata, a2: string
    debug.profilebegin("VFX.MuzzleFlash.Camera")
    local v1 = a1:FindFirstChild(a2)
    if not v1 then
        debug.profileend()
        return nil
    end
    debug.profilebegin("VFX.MuzzleFlash.Camera.EmitParticles")
    EmitParticles(v1)
    debug.profileend()
    debug.profileend()
    return a1.Position
end