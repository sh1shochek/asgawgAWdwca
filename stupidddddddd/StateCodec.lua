-- ReplicatedStorage.MovementV2.StateCodec
-- Script path: ReplicatedStorage.MovementV2.StateCodec
-- Decompile time: 10.32 ms

local Buttons = require(script.Parent.Buttons)
local Enums = require(script.Parent.Enums)
local Quantization = require(script.Parent.Quantization)
require(script.Parent.Types)
local u20 = {Version = 6, WireSize = 91}
local isVector3Within = Quantization.isVector3Within
local writeVector3F32 = Quantization.writeVector3F32
local readVector3F32 = Quantization.readVector3F32

local function numberWithin(a1, a2, a3) -- Line: 34 -- upvalues: Quantization (val) -- types: a2: number, a3: number
    local v1 = Quantization.isFinite(a1)
    if v1 then
        v1 = false
        if a2 <= a1 then
            v1 = a1 <= a3
        end
    end
    return v1
end

function u20.validate(a1) -- Line: 38 -- upvalues: Quantization (val), isVector3Within (val), Buttons (val)
    if typeof(a1) ~= "table" then
        return false, "StateNotTable"
    end
    local MovementTick = a1.MovementTick
    local v1 = Quantization.isFinite(MovementTick)
    if v1 then
        v1 = false
        if MovementTick >= 0 then
            v1 = MovementTick <= 4294967295
        end
    end
    if v1 and a1.MovementTick % 1 == 0 then
        if not isVector3Within(a1.Position, 1000000) then
            return false, "InvalidPosition"
        end
        if not isVector3Within(a1.Velocity, 100000) then
            return false, "InvalidVelocity"
        end
        if not Quantization.isFinite(a1.LookYaw) then
            return false, "InvalidLookYaw"
        end
        local VerticalLook = a1.VerticalLook
        v1 = Quantization.isFinite(VerticalLook)
        if v1 then
            v1 = false
            if VerticalLook >= -1 then
                v1 = VerticalLook <= 1
            end
        end
        if not v1 then
            return false, "InvalidVerticalLook"
        end
        local BaseMoveSpeed = a1.BaseMoveSpeed
        v1 = Quantization.isFinite(BaseMoveSpeed)
        if v1 then
            v1 = false
            if BaseMoveSpeed >= 0 then
                v1 = BaseMoveSpeed <= 10000
            end
        end
        if not v1 then
            return false, "InvalidBaseMoveSpeed"
        end
        local WeaponMoveSpeed = a1.WeaponMoveSpeed
        v1 = Quantization.isFinite(WeaponMoveSpeed)
        if v1 then
            v1 = false
            if WeaponMoveSpeed >= 0 then
                v1 = WeaponMoveSpeed <= 10000
            end
        end
        if not v1 then
            return false, "InvalidWeaponMoveSpeed"
        end
        local WeaponScopedMoveSpeed = a1.WeaponScopedMoveSpeed
        v1 = Quantization.isFinite(WeaponScopedMoveSpeed)
        if v1 then
            v1 = false
            if WeaponScopedMoveSpeed >= 0 then
                v1 = WeaponScopedMoveSpeed <= 10000
            end
        end
        if not v1 then
            return false, "InvalidWeaponScopedMoveSpeed"
        end
        local VelocityModifier = a1.VelocityModifier
        v1 = Quantization.isFinite(VelocityModifier)
        if v1 then
            v1 = false
            if VelocityModifier >= 0 then
                v1 = VelocityModifier <= 1
            end
        end
        if not v1 then
            return false, "InvalidVelocityModifier"
        end
        if a1.MovementMode ~= "Walking" and a1.MovementMode ~= "Ladder" then
            return false, "InvalidMovementMode"
        end
        if a1.Stance ~= "Standing" and a1.Stance ~= "Ducking" then
            return false, "InvalidStance"
        end
        if typeof(a1.OnGround) ~= "boolean" then
            return false, "InvalidOnGround"
        end
        if not isVector3Within(a1.GroundNormal, 2) then
            return false, "InvalidGroundNormal"
        end
        if a1.OnGround and a1.GroundNormal.Magnitude <= 1e-08 then
            return false, "MissingGroundNormal"
        end
        if not isVector3Within(a1.WallNormal, 2) then
            return false, "InvalidWallNormal"
        end
        local GroundSurfaceFriction = a1.GroundSurfaceFriction
        v1 = Quantization.isFinite(GroundSurfaceFriction)
        if v1 then
            v1 = false
            if GroundSurfaceFriction >= 0 then
                v1 = GroundSurfaceFriction <= 100
            end
        end
        if not v1 then
            return false, "InvalidGroundSurfaceFriction"
        end
        local DuckAmount = a1.DuckAmount
        v1 = Quantization.isFinite(DuckAmount)
        if v1 then
            v1 = false
            if DuckAmount >= 0 then
                v1 = DuckAmount <= 1
            end
        end
        if not v1 then
            return false, "InvalidDuckAmount"
        end
        local DuckTimeMsecs = a1.DuckTimeMsecs
        v1 = Quantization.isFinite(DuckTimeMsecs)
        if v1 then
            v1 = false
            if DuckTimeMsecs >= 0 then
                v1 = DuckTimeMsecs <= 60000
            end
        end
        if not v1 then
            return false, "InvalidDuckTimeMsecs"
        end
        if typeof(a1.IsDucking) ~= "boolean" then
            return false, "InvalidIsDucking"
        end
        local DuckSpeed = a1.DuckSpeed
        v1 = Quantization.isFinite(DuckSpeed)
        if v1 then
            v1 = false
            if DuckSpeed >= 0 then
                v1 = DuckSpeed <= 100
            end
        end
        if not v1 then
            return false, "InvalidDuckSpeed"
        end
        local DuckCooldownSeconds = a1.DuckCooldownSeconds
        v1 = Quantization.isFinite(DuckCooldownSeconds)
        if v1 then
            v1 = false
            if DuckCooldownSeconds >= 0 then
                v1 = DuckCooldownSeconds <= 60
            end
        end
        if not v1 then
            return false, "InvalidDuckCooldownSeconds"
        end
        local Stamina = a1.Stamina
        v1 = Quantization.isFinite(Stamina)
        if v1 then
            v1 = false
            if Stamina >= 0 then
                v1 = Stamina <= 10000
            end
        end
        if not v1 then
            return false, "InvalidStamina"
        end
        local LastJumpCommandNumber = a1.LastJumpCommandNumber
        v1 = Quantization.isFinite(LastJumpCommandNumber)
        if v1 then
            v1 = false
            if LastJumpCommandNumber >= 0 then
                v1 = LastJumpCommandNumber <= 4294967295
            end
        end
        if v1 and a1.LastJumpCommandNumber % 1 == 0 then
            if not Buttons.isValid(a1.PreviousButtons) then
                return false, "InvalidPreviousButtons"
            end
            local JumpBufferTicksRemaining = a1.JumpBufferTicksRemaining
            v1 = Quantization.isFinite(JumpBufferTicksRemaining)
            if v1 then
                v1 = false
                if JumpBufferTicksRemaining >= 0 then
                    v1 = JumpBufferTicksRemaining <= 255
                end
            end
            if v1 and a1.JumpBufferTicksRemaining % 1 == 0 then
                if typeof(a1.JumpHullActive) ~= "boolean" then
                    return false, "InvalidJumpHullActive"
                end
                local StuckStepTicks = a1.StuckStepTicks
                v1 = Quantization.isFinite(StuckStepTicks)
                if v1 then
                    v1 = false
                    if StuckStepTicks >= 0 then
                        v1 = StuckStepTicks <= 255
                    end
                end
                if v1 and a1.StuckStepTicks % 1 == 0 then
                    return true, nil
                end
                return false, "InvalidStuckStepTicks"
            end
            return false, "InvalidJumpBufferTicksRemaining"
        end
        return false, "InvalidLastJumpCommandNumber"
    end
    return false, "InvalidMovementTick"
end

local function writeNormal(a1, a2, a3) -- Line: 126
    -- upvalues: Quantization (val)
    local v1, v2, v3 = Quantization.quantizeNormal(a3)
    buffer.writei16(a1, a2, v1)
    local v4 = a2 + 2
    buffer.writei16(a1, v4, v2)
    v4 = a2 + 4
    buffer.writei16(a1, v4, v3)
    return a2 + 6
end

local function readNormal(a1, a2) -- Line: 134 -- upvalues: Quantization (val) -- types: a1: buffer, a2: number
    local dequantizeNormal = Quantization.dequantizeNormal
    local v1 = buffer.readi16(a1, a2)
    local v2 = a2 + 2
    local v3 = buffer.readi16(a1, v2)
    local v4 = a2 + 4
    return (dequantizeNormal(v1, v3, (buffer.readi16(a1, v4)))), a2 + 6
end

function u20.writeValidated(a1, a2, a3) -- Line: 144
    -- upvalues: writeVector3F32 (val), Quantization (val), Enums (val)
    local v1, v2
    local v3 = false
    if a2 % 1 == 0 then
        v3 = a2 >= 0
    end
    assert(v3, "invalid state write offset")
    local v4 = buffer.len(a1)
    assert(a2 + 91 <= v4, "state write exceeds target buffer")
    local v5 = a2
    buffer.writeu8(a1, v5, 6)
    v5 = v5 + 1
    v5 = writeVector3F32(a1, v5, a3.Position)
    v5 = writeVector3F32(a1, v5, a3.Velocity)
    local v6 = Quantization.quantizeYaw(a3.LookYaw)
    buffer.writeu16(a1, v5, v6)
    v5 = v5 + 2
    v6 = Quantization.quantizeSignedUnit(a3.VerticalLook)
    buffer.writei8(a1, v5, v6)
    v5 = v5 + 1
    v3 = 0
    if a3.OnGround then
        v3 = bit32.bor(v3, 1)
    end
    if a3.IsDucking then
        v3 = bit32.bor(v3, 2)
    end
    if a3.JumpHullActive then
        v3 = bit32.bor(v3, 4)
    end
    buffer.writeu8(a1, v5, v3)
    v5 = v5 + 1
    local Ladder = if a3.MovementMode ~= "Ladder" then Enums.MovementMode.Walking else Enums.MovementMode.Ladder
    buffer.writeu8(a1, v5, Ladder)
    v5 = v5 + 1
    local Ducking = if a3.Stance ~= "Ducking" then Enums.Stance.Standing else Enums.Stance.Ducking
    buffer.writeu8(a1, v5, Ducking)
    v4 = v5 + 1
    v6, v1, v2 = Quantization.quantizeNormal(a3.GroundNormal)
    buffer.writei16(a1, v4, v6)
    local v7 = v4 + 2
    buffer.writei16(a1, v7, v1)
    v7 = v4 + 4
    buffer.writei16(a1, v7, v2)
    v4 = v4 + 6
    v6, v1, v2 = Quantization.quantizeNormal(a3.WallNormal)
    buffer.writei16(a1, v4, v6)
    v7 = v4 + 2
    buffer.writei16(a1, v7, v1)
    v7 = v4 + 4
    buffer.writei16(a1, v7, v2)
    v5 = v4 + 6
    local GroundSurfaceFriction = a3.GroundSurfaceFriction
    buffer.writef32(a1, v5, GroundSurfaceFriction)
    v5 = v5 + 4
    local BaseMoveSpeed = a3.BaseMoveSpeed
    buffer.writef32(a1, v5, BaseMoveSpeed)
    v5 = v5 + 4
    v1 = Quantization.quantizeUnitByte(a3.DuckAmount)
    buffer.writeu8(a1, v5, v1)
    v5 = v5 + 1
    local DuckTimeMsecs = a3.DuckTimeMsecs
    buffer.writef32(a1, v5, DuckTimeMsecs)
    v5 = v5 + 4
    local DuckSpeed = a3.DuckSpeed
    buffer.writef32(a1, v5, DuckSpeed)
    v5 = v5 + 4
    local DuckCooldownSeconds = a3.DuckCooldownSeconds
    buffer.writef32(a1, v5, DuckCooldownSeconds)
    v5 = v5 + 4
    local Stamina = a3.Stamina
    buffer.writef32(a1, v5, Stamina)
    v5 = v5 + 4
    local LastJumpCommandNumber = a3.LastJumpCommandNumber
    buffer.writeu32(a1, v5, LastJumpCommandNumber)
    v5 = v5 + 4
    local PreviousButtons = a3.PreviousButtons
    buffer.writeu8(a1, v5, PreviousButtons)
    v5 = v5 + 1
    local JumpBufferTicksRemaining = a3.JumpBufferTicksRemaining
    buffer.writeu8(a1, v5, JumpBufferTicksRemaining)
    v5 = v5 + 1
    local StuckStepTicks = a3.StuckStepTicks
    buffer.writeu8(a1, v5, StuckStepTicks)
    v5 = v5 + 1
    local WeaponMoveSpeed = a3.WeaponMoveSpeed
    buffer.writef32(a1, v5, WeaponMoveSpeed)
    v5 = v5 + 4
    local WeaponScopedMoveSpeed = a3.WeaponScopedMoveSpeed
    buffer.writef32(a1, v5, WeaponScopedMoveSpeed)
    v5 = v5 + 4
    local VelocityModifier = a3.VelocityModifier
    buffer.writef32(a1, v5, VelocityModifier)
    v5 = v5 + 4
    local MovementTick = a3.MovementTick
    buffer.writeu32(a1, v5, MovementTick)
    v5 = v5 + 4
    assert(v5 - a2 == 91, "MovementV2 state wire size drift")
    return v5
end

function u20.encode(a1) -- Line: 214 -- upvalues: u20 (val)
    local v1, v2 = u20.validate(a1)
    if not v1 then
        return nil, v2
    end
    local v3 = buffer.create(91)
    u20.writeValidated(v3, 0, a1)
    return v3, nil
end

function u20.decodeFrom(a1, a2) -- Line: 225
    -- upvalues: readVector3F32 (val), Quantization (val), Enums (val), u20 (val)
    if typeof(a1) ~= "buffer" then
        return nil, nil, "StatePayloadNotBuffer"
    end
    if typeof(a2) == "number" and a2 % 1 == 0 and not (a2 < 0) then
        if (buffer.len(a1)) < a2 + 91 then
            return nil, nil, "StatePayloadSize"
        end
        local v1 = a2
        if buffer.readu8(a1, v1) ~= 6 then
            return nil, nil, "StateVersion"
        end
        v1 = v1 + 1
        local v2, v3 = readVector3F32(a1, v1)
        local v4 = v2
        v2, v3 = readVector3F32(a1, v3)
        local v5 = v2
        v1 = v3
        v2 = Quantization.dequantizeYaw((buffer.readu16(a1, v1)))
        v1 = v1 + 2
        v3 = Quantization.dequantizeSignedUnit((buffer.readi8(a1, v1)))
        v1 = v1 + 1
        local v6 = buffer.readu8(a1, v1)
        v1 = v1 + 1
        if bit32.band(v6, 4294967288) ~= 0 then
            return nil, nil, "InvalidStateFlags"
        end
        local v7 = buffer.readu8(a1, v1)
        v1 = v1 + 1
        if Enums.MovementMode.Ladder < v7 then
            return nil, nil, "InvalidMovementMode"
        end
        local v8 = buffer.readu8(a1, v1)
        v1 = v1 + 1
        if Enums.Stance.Ducking < v8 then
            return nil, nil, "InvalidStance"
        end
        local dequantizeNormal = Quantization.dequantizeNormal
        local v9 = buffer.readi16(a1, v1)
        local v10 = v1 + 2
        local v11 = buffer.readi16(a1, v10)
        local v12 = v1 + 4
        local v13 = (dequantizeNormal(v9, v11, (buffer.readi16(a1, v12))))
        v1 = v1 + 6
        local dequantizeNormal_2 = Quantization.dequantizeNormal
        v9 = buffer.readi16(a1, v1)
        v10 = v1 + 2
        v11 = buffer.readi16(a1, v10)
        v12 = v1 + 4
        local v14 = (dequantizeNormal_2(v9, v11, (buffer.readi16(a1, v12))))
        v1 = v1 + 6
        local v15 = buffer.readf32(a1, v1)
        v1 = v1 + 4
        local v16 = buffer.readf32(a1, v1)
        v1 = v1 + 4
        local v17 = Quantization.dequantizeUnitByte((buffer.readu8(a1, v1)))
        v1 = v1 + 1
        local v18 = buffer.readf32(a1, v1)
        v1 = v1 + 4
        v9 = buffer.readf32(a1, v1)
        v1 = v1 + 4
        v11 = buffer.readf32(a1, v1)
        v1 = v1 + 4
        local v19 = buffer.readf32(a1, v1)
        v1 = v1 + 4
        v10 = buffer.readu32(a1, v1)
        v1 = v1 + 4
        v12 = buffer.readu8(a1, v1)
        v1 = v1 + 1
        local v20 = buffer.readu8(a1, v1)
        v1 = v1 + 1
        local v21 = buffer.readu8(a1, v1)
        v1 = v1 + 1
        local v22 = buffer.readf32(a1, v1)
        v1 = v1 + 4
        local v23 = buffer.readf32(a1, v1)
        v1 = v1 + 4
        local v24 = buffer.readf32(a1, v1)
        v1 = v1 + 4
        local v25 = buffer.readu32(a1, v1)
        v1 = v1 + 4
        assert(v1 - a2 == 91, "MovementV2 state wire size drift")
        local v26 = {
            Position = v4,
            Velocity = v5,
            LookYaw = v2,
            VerticalLook = v3,
            BaseMoveSpeed = v16,
            WeaponMoveSpeed = v22,
            WeaponScopedMoveSpeed = v23,
            VelocityModifier = v24,
            MovementTick = v25,
            MovementMode = if v7 ~= Enums.MovementMode.Ladder then "Walking" else "Ladder",
            Stance = if v8 ~= Enums.Stance.Ducking then "Standing" else "Ducking",
            OnGround = bit32.band(v6, 1) ~= 0,
            GroundNormal = v13,
            WallNormal = v14,
            GroundSurfaceFriction = v15,
            DuckAmount = v17,
            DuckTimeMsecs = v18,
            IsDucking = bit32.band(v6, 2) ~= 0,
            DuckSpeed = v9,
            DuckCooldownSeconds = v11,
            Stamina = v19,
            LastJumpCommandNumber = v10,
            PreviousButtons = v12,
            JumpBufferTicksRemaining = v20,
            JumpHullActive = bit32.band(v6, 4) ~= 0,
            StuckStepTicks = v21,
        }
        local v27, v28 = u20.validate(v26)
        if not v27 then
            return nil, nil, v28
        end
        return v26, v1, nil
    end
    return nil, nil, "InvalidStateOffset"
end

function u20.decode(a1) -- Line: 332 -- upvalues: u20 (val)
    local v1, v2
    if typeof(a1) ~= "buffer" then
        return nil, "StatePayloadNotBuffer"
    end
    if buffer.len(a1) ~= 91 then
        return nil, "StatePayloadSize"
    end
    v1, _, v2 = u20.decodeFrom(a1, 0)
    return v1, v2
end

function u20.canonicalize(a1) -- Line: 343 -- upvalues: u20 (val)
    local v1, v2 = u20.encode(a1)
    if v1 == nil then
        return nil, v2
    end
    return u20.decode(v1)
end

return table.freeze(u20)