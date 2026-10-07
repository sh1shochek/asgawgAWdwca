-- ReplicatedStorage.MovementV2.Simulation.State
-- Script path: ReplicatedStorage.MovementV2.Simulation.State
-- Decompile time: 2.51 ms

require(script.Parent.Parent.Types)
local Config = require(script.Parent.Config)
local u11 = {}
u11.CanonicalFields = table.freeze({
    "Position",
    "Velocity",
    "LookYaw",
    "VerticalLook",
    "BaseMoveSpeed",
    "MovementMode",
    "Stance",
    "OnGround",
    "GroundNormal",
    "WallNormal",
    "GroundSurfaceFriction",
    "DuckAmount",
    "DuckTimeMsecs",
    "IsDucking",
    "DuckSpeed",
    "DuckCooldownSeconds",
    "Stamina",
    "LastJumpCommandNumber",
    "PreviousButtons",
    "JumpBufferTicksRemaining",
    "JumpHullActive",
    "StuckStepTicks",
    "WeaponMoveSpeed",
    "WeaponScopedMoveSpeed",
    "VelocityModifier",
    "MovementTick",
})

function u11.fieldMask(a1) -- Line: 41 -- upvalues: u11 (val) -- types: a1: string
    local v1 = table.find(u11.CanonicalFields, a1)
    local v2 = ("unknown canonical MovementState field %*"):format(a1)
    assert(v1 ~= nil, v2)
    return (bit32.lshift(1, v1 - 1))
end

function u11.canonicalMismatch(a1, a2) -- Line: 48 -- upvalues: u11 (val)
    local v1 = 0
    local v2 = 0
    for i, j in u11.CanonicalFields do
        if a1[j] ~= a2[j] then
            v1 = v1 + 1
            v2 = bit32.bor(v2, (bit32.lshift(1, i - 1)))
        end
    end
    return v1, v2
end

function u11.mismatchLabel(a1) -- Line: 59 -- upvalues: u11 (val) -- types: a1: number
    if a1 == 0 then
        return "none"
    end
    local v1 = {}
    for i, j in u11.CanonicalFields do
        if bit32.band(a1, (bit32.lshift(1, i - 1))) ~= 0 then
            v1[#v1 + 1] = j
        end
    end
    if #v1 == 0 then
        return (string.format("unknown(0x%X)", a1))
    end
    return (table.concat(v1, ","))
end

function u11.new(a1, a2, a3, a4, a5, a6) -- Line: 72
    -- upvalues: Config (val)
    local DefaultBaseMoveSpeed = a5 or Config.Default.DefaultBaseMoveSpeed
    return {
        Velocity = Vector3.new(0, 0, 0),
        VelocityModifier = 1,
        MovementTick = 0,
        MovementMode = "Walking",
        Stance = "Standing",
        OnGround = false,
        GroundNormal = Vector3.new(0, 1, 0),
        WallNormal = Vector3.new(0, 0, 0),
        GroundSurfaceFriction = 1,
        DuckAmount = 0,
        DuckTimeMsecs = 0,
        IsDucking = false,
        DuckSpeed = 8,
        DuckCooldownSeconds = 0,
        Stamina = 100,
        LastJumpCommandNumber = 4294967295,
        PreviousButtons = 0,
        JumpBufferTicksRemaining = 0,
        JumpHullActive = false,
        StuckStepTicks = 0,
        Position = a1,
        LookYaw = a3 or 0,
        VerticalLook = a4 or 0,
        BaseMoveSpeed = a2 or Config.Default.DefaultBaseMoveSpeed,
        WeaponMoveSpeed = DefaultBaseMoveSpeed,
        WeaponScopedMoveSpeed = a6 or DefaultBaseMoveSpeed,
    }
end

function u11.clone(a1) -- Line: 111
    return {
        Position = a1.Position,
        Velocity = a1.Velocity,
        LookYaw = a1.LookYaw,
        VerticalLook = a1.VerticalLook,
        BaseMoveSpeed = a1.BaseMoveSpeed,
        WeaponMoveSpeed = a1.WeaponMoveSpeed,
        WeaponScopedMoveSpeed = a1.WeaponScopedMoveSpeed,
        VelocityModifier = a1.VelocityModifier,
        MovementTick = a1.MovementTick,
        MovementMode = a1.MovementMode,
        Stance = a1.Stance,
        OnGround = a1.OnGround,
        GroundNormal = a1.GroundNormal,
        WallNormal = a1.WallNormal,
        GroundSurfaceFriction = a1.GroundSurfaceFriction,
        DuckAmount = a1.DuckAmount,
        DuckTimeMsecs = a1.DuckTimeMsecs,
        IsDucking = a1.IsDucking,
        DuckSpeed = a1.DuckSpeed,
        DuckCooldownSeconds = a1.DuckCooldownSeconds,
        Stamina = a1.Stamina,
        LastJumpCommandNumber = a1.LastJumpCommandNumber,
        PreviousButtons = a1.PreviousButtons,
        JumpBufferTicksRemaining = a1.JumpBufferTicksRemaining,
        JumpHullActive = a1.JumpHullActive,
        StuckStepTicks = a1.StuckStepTicks,
    }
end

function u11.cloneInto(a1, a2) -- Line: 143
    table.clear(a1)
    a1.Position = a2.Position
    a1.Velocity = a2.Velocity
    a1.LookYaw = a2.LookYaw
    a1.VerticalLook = a2.VerticalLook
    a1.BaseMoveSpeed = a2.BaseMoveSpeed
    a1.WeaponMoveSpeed = a2.WeaponMoveSpeed
    a1.WeaponScopedMoveSpeed = a2.WeaponScopedMoveSpeed
    a1.VelocityModifier = a2.VelocityModifier
    a1.MovementTick = a2.MovementTick
    a1.MovementMode = a2.MovementMode
    a1.Stance = a2.Stance
    a1.OnGround = a2.OnGround
    a1.GroundNormal = a2.GroundNormal
    a1.WallNormal = a2.WallNormal
    a1.GroundSurfaceFriction = a2.GroundSurfaceFriction
    a1.DuckAmount = a2.DuckAmount
    a1.DuckTimeMsecs = a2.DuckTimeMsecs
    a1.IsDucking = a2.IsDucking
    a1.DuckSpeed = a2.DuckSpeed
    a1.DuckCooldownSeconds = a2.DuckCooldownSeconds
    a1.Stamina = a2.Stamina
    a1.LastJumpCommandNumber = a2.LastJumpCommandNumber
    a1.PreviousButtons = a2.PreviousButtons
    a1.JumpBufferTicksRemaining = a2.JumpBufferTicksRemaining
    a1.JumpHullActive = a2.JumpHullActive
    a1.StuckStepTicks = a2.StuckStepTicks
    return a1
end

function u11.noneSupport() -- Line: 174
    return {
        Kind = 0,
        SourceId = 0,
        Anchor = Vector3.new(0, 0, 0),
        Velocity = Vector3.new(0, 0, 0),
    }
end

function u11.cloneSupport(a1) -- Line: 183
    return {
        Kind = a1.Kind,
        SourceId = a1.SourceId,
        Anchor = a1.Anchor,
        Velocity = a1.Velocity,
    }
end

return table.freeze(u11)