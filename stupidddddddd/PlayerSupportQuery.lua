-- ReplicatedStorage.MovementV2.Simulation.PlayerSupportQuery
-- Script path: ReplicatedStorage.MovementV2.Simulation.PlayerSupportQuery
-- Decompile time: 2.15 ms

local Enums = require(script.Parent.Parent.Enums)
require(script.Parent.Parent.Types)
require(script.Parent.Config)
require(script.Parent.Types)
local u22 = {}
u22.__index = u22

local function halfSize(a1, a2) -- Line: 29
    local PlayerSizeDucking = if a1 ~= "Ducking" then a2.PlayerSizeStanding else a2.PlayerSizeDucking
    return PlayerSizeDucking * 0.5
end

local function playerGround(a1, a2, a3, a4) -- Line: 33 -- upvalues: Enums (val) -- types: a2: vector, a4: number
    local Position = a1.Motion.Position
    local Stance = a1.Motion.Stance
    if Position ~= nil and Stance ~= nil then
        local Config = a1.Config
        local PlayerSizeDucking = if a3 ~= "Ducking" then Config.PlayerSizeStanding else Config.PlayerSizeDucking
        local v1 = PlayerSizeDucking * 0.5
        local Config_2 = a1.Config
        local PlayerSizeDucking_2 = if Stance ~= "Ducking" then Config_2.PlayerSizeStanding else Config_2.PlayerSizeDucking
        local v2 = PlayerSizeDucking_2 * 0.5
        local PositionSnapEpsilon = a1.Config.PositionSnapEpsilon
        local v3 = a2 - Position
        local v4 = math.abs(v3.X)
        if not (v1.X + v2.X <= v4) then
            v4 = math.abs(v3.Z)
            if not (v1.Z + v2.Z <= v4) then
                v4 = Position.Y + v2.Y
                local v5 = a2.Y - v1.Y - v4
                if not (v5 < -((a1.Config.GroundProbeStartBump or 0) + PositionSnapEpsilon))
                    and not (a4 + PositionSnapEpsilon < v5) then
                    local v6 = Vector3.new(a2.X, v4 + v1.Y, a2.Z)
                    local Velocity = a1.Motion.Velocity
                    return {
                        Normal = Vector3.new(0, 1, 0),
                        Position = v6,
                        SurfaceFriction = a1.Config.SurfaceFrictionDefault,
                        Support = {
                            Kind = Enums.SupportKind.Player,
                            SourceId = a1.Support.SourceId,
                            Anchor = v6 - Position,
                            Velocity = Vector3.new(Velocity.X, 0, Velocity.Z),
                        },
                    }
                end
                return nil
            end
        end
        return nil
    end
    return nil
end

function u22.FindPlayerGround(a1, a2, a3, a4) -- Line: 73
    -- upvalues: playerGround (val)
    return (playerGround(a1, a2, a3, a4))
end

function u22.new(a1, a2, a3, a4) -- Line: 77 -- upvalues: Enums (val), u22 (val)
    local v1 = false
    if a2.Kind == Enums.SupportKind.Player then
        v1 = a2.SourceId ~= 0
    end
    assert(v1, "player support query requires player ground")
    v1 = false
    if a3.Kind == a2.Kind then
        v1 = a3.SourceId == a2.SourceId
    end
    assert(v1, "player support motion identity mismatch")
    return (setmetatable({Base = a1, Support = a2, Motion = a3, Config = a4}, u22))
end

function u22:Sweep(a2, a3, a4, a5, a6, a7) -- Line: 99
    -- upvalues: 
    return self.Base:Sweep(a2, a3, a4, a5, a6, a7)
end

function u22:SweepWithFloorSupport(a2, a3, a4, a5, a6, a7) -- Line: 110
    -- upvalues: 
    return self.Base:SweepWithFloorSupport(a2, a3, a4, a5, a6, a7)
end

function u22:SweepDetailed(a2, a3, a4, a5, a6, a7) -- Line: 128
    -- upvalues: 
    return self.Base:SweepDetailed(a2, a3, a4, a5, a6, a7)
end

function u22:SweepWithFloorSupportDetailed(a2, a3, a4, a5, a6, a7) -- Line: 146
    -- upvalues: 
    return self.Base:SweepWithFloorSupportDetailed(a2, a3, a4, a5, a6, a7)
end

function u22:IsClear(a2, a3, a4) -- Line: 164 -- types: self: table, a2: vector, a4: number
    return self.Base:IsClear(a2, a3, a4)
end

function u22:CanMove(a2, a3, a4, a5, a6, a7) -- Line: 168
    -- upvalues: 
    return self.Base:CanMove(a2, a3, a4, a5, a6, a7)
end

function u22:FindGround(a2, a3, a4, a5, a6) -- Line: 179
    -- upvalues: playerGround (val)
    local v1 = playerGround(self, a2, a3, a4)
    if v1 ~= nil then
        return v1
    end
    return self.Base:FindGround(a2, a3, a4, a5, a6)
end

function u22.FindLadder(a1, a2, a3, a4, a5) -- Line: 193 -- types: a1: table, a2: vector, a4: number, a5: number
    local FindLadder = a1.Base.FindLadder
    if FindLadder == nil then
        return nil
    end
    return (FindLadder(a1.Base, a2, a3, a4, a5))
end

function u22.SetMovementBounds(a1, a2, a3) -- Line: 203 -- types: a1: table, a2: vector, a3: vector
    local SetMovementBounds = a1.Base.SetMovementBounds
    if SetMovementBounds ~= nil then
        SetMovementBounds(a1.Base, a2, a3)
    end
end

return table.freeze(u22)