-- ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.EmitParticles
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.EmitParticles
-- Decompile time: 0.94 ms

local u0 = {}

local function getEmitterConfigs(a1) -- Line: 3 -- upvalues: u0 (val) -- types: a1: userdata
    local v1 = u0[a1]
    if v1 then
        return v1
    end
    local v2 = {}
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            table.insert(v2, {
                Emitter = v,
                Delay = v:GetAttribute("EmitDelay") or 0,
                Count = v:GetAttribute("EmitCount") or 1,
            })
        end
    end
    u0[a1] = v2
    a1.Destroying:Once(function() -- Line: 21 -- upvalues: u0 (upval), a1 (val)
        u0[a1] = nil
    end)
    return v2
end

local function emitParticle(a1) -- Line: 28
    local Emitter = a1.Emitter
    if 0 < a1.Delay then
        task.delay(a1.Delay, function() -- Line: 31 -- upvalues: Emitter (val), a1 (val)
            if Emitter.Parent then
                Emitter:Emit(a1.Count)
            end
        end)
        return
    end
    if Emitter.Parent then
        Emitter:Emit(a1.Count)
    end
end

return function(a1) -- Line: 44 -- upvalues: getEmitterConfigs (val) -- types: a1: userdata
    for i, v in ipairs((getEmitterConfigs(a1))) do
        local Emitter = v.Emitter
        if 0 < v.Delay then
            task.delay(v.Delay, function() -- Line: 31 -- upvalues: Emitter (val), v (val)
                if Emitter.Parent then
                    Emitter:Emit(v.Count)
                end
            end)
        elseif Emitter.Parent then
            Emitter:Emit(v.Count)
        end
    end
end