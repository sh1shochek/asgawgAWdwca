-- ReplicatedStorage.MovementV2.Simulation.PlayerLanding
-- Script path: ReplicatedStorage.MovementV2.Simulation.PlayerLanding
-- Decompile time: 2.47 ms

require(script.Parent.Parent.Types)
require(script.Parent.Config)
require(script.Parent.DeterminismTrace)
local PlayerContacts = require(script.Parent.PlayerContacts)
require(script.Parent.PlayerHullClearance)
local ProvenCollisionAdapter = require(script.Parent.ProvenCollisionAdapter)
local ProvenSimulator = require(script.Parent.ProvenSimulator)
require(script.Parent.Types)
local u41 = {}

function u41.needsStanding(a1) -- Line: 14
    return a1.JumpHullActive and a1.DuckAmount < 0.999
end

function u41.queryHalfSize(a1, a2) -- Line: 19 -- upvalues: u41 (val)
    if u41.needsStanding(a1) then
        return a2.PlayerSizeStanding * 0.5 + Vector3.new(0, a2.GroundProbeDistance + a2.PositionSnapEpsilon, 0)
    end
    local PlayerSizeDucking = if a1.Stance ~= "Ducking" then a2.PlayerSizeStanding else a2.PlayerSizeDucking
    return PlayerSizeDucking * 0.5
end

function u41.prepare(a1, a2, a3, a4, a5, a6, a7) -- Line: 28
    -- upvalues: u41 (val), PlayerContacts (val), ProvenCollisionAdapter (val), ProvenSimulator (val)
    if u41.needsStanding(a1) and not a1.OnGround and not (a5.VelocityEpsilon < a2.WorldVelocity.Y) then
        local PlayerSizeDucking, v1, v2, v3, v4
        local v5 = a5.PlayerSizeDucking * 0.5
        local v6 = a5.PlayerSizeStanding * 0.5
        local DefaultContactEpsilon = PlayerContacts.DefaultContactEpsilon
        local DefaultSeparationSkin = PlayerContacts.DefaultSeparationSkin
        local v7 = a2.StartPosition.Y - v5.Y
        local v8 = a2.Position.Y - v6.Y
        local v9 = nil
        local v10 = (-1 / 0)
        local v11 = nil
        local v12 = nil
        local v13, v14, v15, v16, v17 = a2, a4, a5, a7, a6
        for i, j in a3, v11, v12 do
            if j.Id ~= v13.Id then
                PlayerSizeDucking = if j.Stance ~= "Ducking" then v15.PlayerSizeStanding else v15.PlayerSizeDucking
                v2 = PlayerSizeDucking * 0.5
                v3 = j.Position.Y + v2.Y
                v4 = v13.Position - j.Position
                if v3 - DefaultContactEpsilon - DefaultSeparationSkin <= v7
                    and v8 <= v3 + v15.GroundProbeDistance + v15.PositionSnapEpsilon
                    and (math.abs(v4.X)) < v6.X + v2.X - DefaultContactEpsilon
                    and (math.abs(v4.Z)) < v6.Z + v2.Z - DefaultContactEpsilon then
                    if v10 < v3 or v3 == v10 and v9 ~= nil and j.Id < v9.Id then
                        v9 = j
                        v10 = v3
                    end
                end
            end
        end
        if v9 == nil then
            return false
        end
        local v18 = Vector3.new(v13.Position.X, v10 + v5.Y + DefaultSeparationSkin, v13.Position.Z)
        if not v14:CanMove(v13.Position, v18, "Ducking", nil, 1, 1) then
            return false
        end
        v12, v1 = ProvenSimulator.checkStandingClearance(v18, ProvenCollisionAdapter.new(v14, v15, nil, v16, nil, v17), v15)
        if v12 then
            return false
        end
        v13.Position = v1
        v13.Stance = "Standing"
        return true
    end
    return false
end

function u41.restoreWorldGround(a1, a2, a3, a4, a5) -- Line: 82
    -- upvalues: ProvenCollisionAdapter (val), ProvenSimulator (val)
    local v1 = ProvenCollisionAdapter.new(a2, a3, a1.Support, a5, nil, a4)
    local v2, v3 = ProvenSimulator.checkStandingClearance(a1.Position, v1, a3)
    if v2 then
        return nil
    end
    local v4 = a2:FindGround(v3, "Standing", a3.GroundProbeDistance, 1, a1.Support)
    if v4 == nil then
        return nil
    end
    local v5 = v1:PointTest(v4.Position, "standing", true)
    if not v5.startSolid and not v5.allSolid then
        return v4
    end
    return nil
end

return table.freeze(u41)