-- ReplicatedStorage.MovementV2.Simulation.ProvenSimulator.AirMove
-- Script path: ReplicatedStorage.MovementV2.Simulation.ProvenSimulator.AirMove
-- Decompile time: 4.47 ms

require(script.Parent.Parent.ProvenTypes)
local ProvenMath = require(script.Parent.Parent.ProvenMath)
local Trace = require(script.Parent.Trace)
local TraceRules = require(script.Parent.TraceRules)
local SlideMove = require(script.Parent.SlideMove)
local Duck = require(script.Parent.Duck)
local v1 = {}
local line = Trace.line
local vector = Trace.vector
local clampHorizontal = ProvenMath.clampHorizontal
local tryPlayerMove = SlideMove.tryPlayerMove
local getUncrouchClearance = Duck.getUncrouchClearance
local GROUND_PROBE_START_BUMP = TraceRules.GROUND_PROBE_START_BUMP
local isPointTestBlocked = TraceRules.isPointTestBlocked
local getTraceClipNormal = TraceRules.getTraceClipNormal
local isDynamicPlayerSupportTrace = TraceRules.isDynamicPlayerSupportTrace
local getResolvedSupportPosition = TraceRules.getResolvedSupportPosition
local isWalkableGround = TraceRules.isWalkableGround

local function tryAirLedgeAssist(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) -- Line: 29
    -- upvalues: getTraceClipNormal (val), isPointTestBlocked (val), tryPlayerMove (val), GROUND_PROBE_START_BUMP (val)
    -- upvalues: isWalkableGround (val), isDynamicPlayerSupportTrace (val), getResolvedSupportPosition (val)
    -- upvalues: getUncrouchClearance (val)
    local AutoJumpLedgeAssistHeight = a5.AutoJumpLedgeAssistHeight
    local AutoJumpLedgeAssistLiftSpeed = a5.AutoJumpLedgeAssistLiftSpeed
    if not (AutoJumpLedgeAssistHeight <= a5.PositionSnapEpsilon)
        and not (AutoJumpLedgeAssistLiftSpeed <= a5.PositionSnapEpsilon)
        and a10
        and a11 ~= nil
        and not (a5.WalkableFloor <= a11.normal.Y) then
        if a5.GroundClearVelocity < (math.abs(a2.Y)) then
            return a8, a9, false
        end
        local v1 = Vector3.new(a2.X, 0, a2.Z)
        if v1.Magnitude <= a5.VelocityEpsilon then
            return a8, a9, false
        end
        local v2 = getTraceClipNormal(a11, a5)
        local v3 = Vector3.new(v2.X, 0, v2.Z)
        if v3.Magnitude <= a5.PositionSnapEpsilon then
            return a8, a9, false
        end
        local Unit = v3.Unit
        local v4 = v1:Dot(Unit)
        if -a5.VelocityEpsilon <= v4 then
            return a8, a9, false
        end
        local v5 = a4:Sweep(a1, a1 + (Vector3.new(0, AutoJumpLedgeAssistHeight, 0)), a6)
        if not v5.startSolid and not v5.allSolid and not (v5.fraction < 1 - a5.PositionSnapEpsilon) then
            local v6 = isPointTestBlocked
            if not v6(a4:PointTest(v5.endPos, a6)) then
                v6 = tryPlayerMove(v5.endPos, a2, a3, a4, a5, a6, false, a12, "risingAir")
                local v7 = -(a8 - a1):Dot(Unit)
                if -(v6 - a1):Dot(Unit) <= v7 + a5.PositionSnapEpsilon then
                    return a8, a9, false
                end
                local v8 = a1 + a2 * a3
                local v9 = v6 - Vector3.new(0, AutoJumpLedgeAssistHeight + math.abs(a2.Y * a3) + a5.GroundProbeDistance + GROUND_PROBE_START_BUMP, 0)
                local v10 = a4:SupportSweep(v6, v9, a6, a5.WalkableFloor)
                if not isWalkableGround(v10, a5) and v10.normal.Y < a5.WalkableFloor then
                    v10 = a4:WalkableSupportSweep(v6, v9, a6, a5.WalkableFloor)
                end
                if isWalkableGround(v10, a5) and not isDynamicPlayerSupportTrace(v10) then
                    local v11 = getResolvedSupportPosition(v10, v6)
                    local v12 = v11.Y - v8.Y
                    if not (v12 <= a5.PositionSnapEpsilon)
                        and not (AutoJumpLedgeAssistHeight + a5.PositionSnapEpsilon < v12) then
                        if isPointTestBlocked(a4:PointTest(v11, a6)) then
                            return a8, a9, false
                        end
                        if a7 and getUncrouchClearance(v11, a4, a5) then
                            return a8, a9, false
                        end
                        local v13 = (math.clamp(v12 / AutoJumpLedgeAssistHeight, 0, 1)) * 0.35 + 0.65
                        local v14 = a4:Sweep(
                            a8,
                            a8 + (Vector3.new(0, math.min(v12 + a5.PositionSnapEpsilon, AutoJumpLedgeAssistLiftSpeed * v13 * a3), 0)),
                            a6
                        )
                        if not v14.startSolid
                            and not v14.allSolid
                            and not (v14.fraction < 1 - a5.PositionSnapEpsilon) then
                            local v15 = isPointTestBlocked
                            if not v15(a4:PointTest(v14.endPos, a6)) then
                                v15 = Vector3.new(a2.X, 0, a2.Z)
                                return v14.endPos, v15, true
                            end
                        end
                        return a8, a9, false
                    end
                    return a8, a9, false
                end
                return a8, a9, false
            end
        end
        return a8, a9, false
    end
    return a8, a9, false
end

function v1.airMove(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13) -- Line: 157
    -- upvalues: ProvenMath (val), vector (val), line (val), clampHorizontal (val), tryPlayerMove (val)
    -- upvalues: tryAirLedgeAssist (val)
    local v1 = a2
    if a7.PositionSnapEpsilon < a4 then
        v1 = if not (0 < a7.BunnyHopAirAccelerate) then ProvenMath.airAccelerate(v1, a3, a4, a7.AirAccelerate, a7.AirSpeedCap, a5, a11) else if not (a7.PositionSnapEpsilon < a7.BunnyHopAirSpeedCap) then ProvenMath.airAccelerate(v1, a3, a4, a7.AirAccelerate, a7.AirSpeedCap, a5, a11) else ProvenMath.legacyBunnyHopAirAccelerate(v1, a3, a4, a7.BunnyHopAirAccelerate, a7.BunnyHopAirSpeedCap, a5)
        vector("proven.airMove.accelerate", a1, v1, a4, 0, line(1))
    end
    if 0 < a7.BunnyHopSpeedCap then
        v1 = clampHorizontal(v1, a7.BunnyHopSpeedCap)
    end
    local v2, v3, v4, v5, v6, v7 = tryPlayerMove(a1, v1, a5, a6, a7, a8, true, a13, "risingAir", a12)
    if a9 then
        local v8, v9 = tryAirLedgeAssist(a1, v1, a5, a6, a7, a8, a10, v2, v3, v5, v7, a13)
        v2 = v8
        v3 = v9
    end
    vector("proven.airMove.final", v2, v3, 0, if not v4 then 0 else 1, line(1))
    return v2, v3, v4, v5, v6
end

return table.freeze(v1)