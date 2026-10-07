-- Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.BaseOcclusion
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.BaseOcclusion
-- Decompile time: 0.39 ms

local u0 = {}
u0.__index = u0
local v1 = {
    __call = function(a1, ...) -- Line: 10 -- upvalues: u0 (val)
        return u0.new(...)
    end,
}
setmetatable(u0, v1)

function u0.new() -- Line: 15 -- upvalues: u0 (val)
    return (setmetatable({}, u0))
end

function u0.CharacterAdded(a1, a2, a3) end

function u0.CharacterRemoving(a1, a2, a3) end

function u0.OnCameraSubjectChanged(a1, a2) end

function u0.GetOcclusionMode(a1) -- Line: 32
    warn("BaseOcclusion GetOcclusionMode must be overridden by derived classes")
    return nil
end

function u0.Enable(a1, a2) -- Line: 38 -- types: a1: table, a2: boolean
    warn("BaseOcclusion Enable must be overridden by derived classes")
end

function u0.Update(a1, a2, a3, a4) -- Line: 42 -- types: a1: table, a2: number, a3: userdata, a4: userdata
    warn("BaseOcclusion Update must be overridden by derived classes")
    return a3, a4
end

return u0