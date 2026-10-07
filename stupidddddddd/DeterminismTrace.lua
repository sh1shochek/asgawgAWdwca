-- ReplicatedStorage.MovementV2.Simulation.DeterminismTrace
-- Script path: ReplicatedStorage.MovementV2.Simulation.DeterminismTrace
-- Decompile time: 25.61 ms

local u0 = {}
local u3 = buffer.create(4)
local u4 = {}
u4.__index = u4
local u5 = {}
local u6 = {}
local u18 = table.freeze({
    [0] = "unknown",
    "ReplicatedStorage.MovementV2.Simulation.ProvenSimulator",
    "ReplicatedStorage.MovementV2.Simulation.ProvenCollisionAdapter",
    "ReplicatedStorage.MovementV2.Simulation.PlayerContacts",
    "ReplicatedStorage.MovementV2.Simulation",
    "ReplicatedStorage.MovementV2.Client.PlayerContactAdapter",
    "ServerScriptService.MovementV2.AuthorityRuntime",
    "ReplicatedStorage.MovementV2.Client.Runtime",
})

local function sourceId(a1) -- Line: 115 -- upvalues: u6 (val) -- types: a1: string
    local v1
    local v2 = u6[a1]
    if v2 ~= nil then
        return v2
    end
    u6[a1] = if string.find(a1, "ProvenSimulator", 1, true) == nil then if string.find(a1, "ProvenCollisionAdapter", 1, true) == nil then if string.find(a1, "PlayerContacts", 1, true) == nil then if string.find(a1, "Client.PlayerContactAdapter", 1, true) == nil then if string.find(a1, "AuthorityRuntime", 1, true) == nil then if string.find(a1, "Client.Runtime", 1, true) == nil then if string.find(a1, "MovementV2.Simulation", 1, true) == nil then 0 else 4 else 7 else 6 else 5 else 3 else 2 else 1
    return v1
end

local function finite(a1) -- Line: 137
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 > (-1 / 0) then
                v1 = a1 < (1 / 0)
            end
        end
    end
    return v1
end

local function mix(a1, a2) -- Line: 141 -- types: a1: number, a2: number
    return (bit32.band(bit32.lrotate(bit32.bxor(a1, a2), 5) + 2654435769, 4294967295))
end

local function floatWord(a1) -- Line: 145 -- upvalues: u3 (val)
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 > (-1 / 0) then
                v1 = a1 < (1 / 0)
            end
        end
    end
    local v2 = if not v1 then 0 else a1
    buffer.writef32(u3, 0, v2)
    return (buffer.readu32(u3, 0))
end

local function boolWord(a1) -- Line: 151
    if a1 == true then
        return 1
    end
    return 0
end

local function stringWord(a1) -- Line: 155
    if typeof(a1) ~= "string" then
        return 0
    end
    local v1 = 2166136261
    local v2 = #a1
    for i = 1, v2 do
        v1 = bit32.band(bit32.lrotate(bit32.bxor(v1, (string.byte(a1, i))), 5) + 2654435769, 4294967295)
    end
    return v1
end

local function vectorHash(a1, a2) -- Line: 166 -- upvalues: u3 (val) -- types: a1: number
    if typeof(a2) ~= "Vector3" then
        return (bit32.band(bit32.lrotate(bit32.bxor(a1, 0), 5) + 2654435769, 4294967295))
    end
    local X = a2.X
    local v1 = false
    if typeof(X) == "number" then
        v1 = false
        if X == X then
            v1 = false
            if X > (-1 / 0) then
                v1 = X < (1 / 0)
            end
        end
    end
    local v2 = if not v1 then 0 else X
    buffer.writef32(u3, 0, v2)
    local v3 = bit32.band(bit32.lrotate(bit32.bxor(a1, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local Y = a2.Y
    v1 = false
    if typeof(Y) == "number" then
        v1 = false
        if Y == Y then
            v1 = false
            if Y > (-1 / 0) then
                v1 = Y < (1 / 0)
            end
        end
    end
    v2 = if not v1 then 0 else Y
    buffer.writef32(u3, 0, v2)
    local v4 = bit32.band(bit32.lrotate(bit32.bxor(v3, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local Z = a2.Z
    local v5 = false
    if typeof(Z) == "number" then
        v5 = false
        if Z == Z then
            v5 = false
            if Z > (-1 / 0) then
                v5 = Z < (1 / 0)
            end
        end
    end
    v1 = if not v5 then 0 else Z
    buffer.writef32(u3, 0, v1)
    return (bit32.band(bit32.lrotate(bit32.bxor(v4, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295))
end

local function vector2Hash(a1, a2) -- Line: 175 -- upvalues: u3 (val) -- types: a1: number
    if typeof(a2) ~= "Vector2" then
        return (bit32.band(bit32.lrotate(bit32.bxor(a1, 0), 5) + 2654435769, 4294967295))
    end
    local X = a2.X
    local v1 = false
    if typeof(X) == "number" then
        v1 = false
        if X == X then
            v1 = false
            if X > (-1 / 0) then
                v1 = X < (1 / 0)
            end
        end
    end
    local v2 = if not v1 then 0 else X
    buffer.writef32(u3, 0, v2)
    local v3 = bit32.band(bit32.lrotate(bit32.bxor(a1, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local Y = a2.Y
    local v4 = false
    if typeof(Y) == "number" then
        v4 = false
        if Y == Y then
            v4 = false
            if Y > (-1 / 0) then
                v4 = Y < (1 / 0)
            end
        end
    end
    v1 = if not v4 then 0 else Y
    buffer.writef32(u3, 0, v1)
    return (bit32.band(bit32.lrotate(bit32.bxor(v3, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295))
end

local function registerSite(a1, a2) -- Line: 183 -- upvalues: u5 (val) -- types: a1: string, a2: string
    local v1, v2
    if typeof(a1) == "string" then
        v2 = 2166136261
        local v3 = #a1
        for i = 1, v3 do
            v2 = bit32.band(bit32.lrotate(bit32.bxor(v2, (string.byte(a1, i))), 5) + 2654435769, 4294967295)
        end
        v1 = v2
    else
        v1 = 0
    end
    v2 = u5[v1]
    if v2 == nil then
        u5[v1] = (table.freeze({Label = a1, Source = a2}))
        return v1
    end
    if v2.Label ~= a1 then
        error((("MovementV2 determinism trace site collision: %* / %*"):format(v2.Label, a1)))
    end
    return v1
end

local function stateHash(a1) -- Line: 197 -- upvalues: vectorHash (val), u3 (val)
    local v1
    local v2 = vectorHash(vectorHash(2166136261, a1.Position), a1.Velocity)
    local LookYaw = a1.LookYaw
    local v3 = false
    if typeof(LookYaw) == "number" then
        v3 = false
        if LookYaw == LookYaw then
            v3 = false
            if LookYaw > (-1 / 0) then
                v3 = LookYaw < (1 / 0)
            end
        end
    end
    local v4 = if not v3 then 0 else LookYaw
    buffer.writef32(u3, 0, v4)
    local v5 = bit32.band(bit32.lrotate(bit32.bxor(v2, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local VerticalLook = a1.VerticalLook
    v3 = false
    if typeof(VerticalLook) == "number" then
        v3 = false
        if VerticalLook == VerticalLook then
            v3 = false
            if VerticalLook > (-1 / 0) then
                v3 = VerticalLook < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else VerticalLook
    buffer.writef32(u3, 0, v4)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local Tick = a1.Tick
    v3 = false
    if typeof(Tick) == "number" then
        v3 = false
        if Tick == Tick then
            v3 = false
            if Tick > (-1 / 0) then
                v3 = Tick < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else Tick
    buffer.writef32(u3, 0, v4)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, if a1.OnGround ~= true then 0 else 1), 5) + 2654435769, 4294967295)
    v2 = vectorHash(vectorHash(
        bit32.band(bit32.lrotate(bit32.bxor(v5, if a1.GroundSupportIsDynamicPlayer ~= true then 0 else 1), 5) + 2654435769, 4294967295),
        a1.GroundNormal
    ), a1.WallNormal)
    local GroundSurfaceFriction = a1.GroundSurfaceFriction
    v3 = false
    if typeof(GroundSurfaceFriction) == "number" then
        v3 = false
        if GroundSurfaceFriction == GroundSurfaceFriction then
            v3 = false
            if GroundSurfaceFriction > (-1 / 0) then
                v3 = GroundSurfaceFriction < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else GroundSurfaceFriction
    buffer.writef32(u3, 0, v4)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v2, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local DuckAmount = a1.DuckAmount
    v3 = false
    if typeof(DuckAmount) == "number" then
        v3 = false
        if DuckAmount == DuckAmount then
            v3 = false
            if DuckAmount > (-1 / 0) then
                v3 = DuckAmount < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else DuckAmount
    buffer.writef32(u3, 0, v4)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local DuckTimeMsecs = a1.DuckTimeMsecs
    v3 = false
    if typeof(DuckTimeMsecs) == "number" then
        v3 = false
        if DuckTimeMsecs == DuckTimeMsecs then
            v3 = false
            if DuckTimeMsecs > (-1 / 0) then
                v3 = DuckTimeMsecs < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else DuckTimeMsecs
    buffer.writef32(u3, 0, v4)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, if a1.IsDucking ~= true then 0 else 1), 5) + 2654435769, 4294967295)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, if a1.DuckHeld ~= true then 0 else 1), 5) + 2654435769, 4294967295)
    local DuckFatigueLevel = a1.DuckFatigueLevel or a1.DuckSpeed
    v3 = false
    if typeof(DuckFatigueLevel) == "number" then
        v3 = false
        if DuckFatigueLevel == DuckFatigueLevel then
            v3 = false
            if DuckFatigueLevel > (-1 / 0) then
                v3 = DuckFatigueLevel < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else DuckFatigueLevel
    buffer.writef32(u3, 0, v4)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local DuckFatigueTimerMsecs = a1.DuckFatigueTimerMsecs or a1.DuckCooldownSeconds
    v3 = false
    if typeof(DuckFatigueTimerMsecs) == "number" then
        v3 = false
        if DuckFatigueTimerMsecs == DuckFatigueTimerMsecs then
            v3 = false
            if DuckFatigueTimerMsecs > (-1 / 0) then
                v3 = DuckFatigueTimerMsecs < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else DuckFatigueTimerMsecs
    buffer.writef32(u3, 0, v4)
    v2 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local MovementType = a1.MovementType or a1.MovementMode
    if typeof(MovementType) == "string" then
        v4 = 2166136261
        v3 = #MovementType
        for i = 1, v3 do
            v4 = bit32.band(bit32.lrotate(bit32.bxor(v4, (string.byte(MovementType, i))), 5) + 2654435769, 4294967295)
        end
        v1 = v4
    else
        v1 = 0
    end
    v2 = bit32.band(bit32.lrotate(bit32.bxor(v2, v1), 5) + 2654435769, 4294967295)
    local Stance = a1.Stance
    if typeof(Stance) == "string" then
        v4 = 2166136261
        v3 = #Stance
        for j = 1, v3 do
            v4 = bit32.band(bit32.lrotate(bit32.bxor(v4, (string.byte(Stance, j))), 5) + 2654435769, 4294967295)
        end
        v1 = v4
    else
        v1 = 0
    end
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v2, v1), 5) + 2654435769, 4294967295)
    local Stamina = a1.Stamina
    v3 = false
    if typeof(Stamina) == "number" then
        v3 = false
        if Stamina == Stamina then
            v3 = false
            if Stamina > (-1 / 0) then
                v3 = Stamina < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else Stamina
    buffer.writef32(u3, 0, v4)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local LastJumpTick = a1.LastJumpTick or a1.LastJumpCommandNumber
    v3 = false
    if typeof(LastJumpTick) == "number" then
        v3 = false
        if LastJumpTick == LastJumpTick then
            v3 = false
            if LastJumpTick > (-1 / 0) then
                v3 = LastJumpTick < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else LastJumpTick
    buffer.writef32(u3, 0, v4)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, if a1.JumpHeld ~= true then 0 else 1), 5) + 2654435769, 4294967295)
    local PreviousButtons = a1.PreviousButtons
    v3 = false
    if typeof(PreviousButtons) == "number" then
        v3 = false
        if PreviousButtons == PreviousButtons then
            v3 = false
            if PreviousButtons > (-1 / 0) then
                v3 = PreviousButtons < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else PreviousButtons
    buffer.writef32(u3, 0, v4)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local JumpBufferTicksRemaining = a1.JumpBufferTicksRemaining
    v3 = false
    if typeof(JumpBufferTicksRemaining) == "number" then
        v3 = false
        if JumpBufferTicksRemaining == JumpBufferTicksRemaining then
            v3 = false
            if JumpBufferTicksRemaining > (-1 / 0) then
                v3 = JumpBufferTicksRemaining < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else JumpBufferTicksRemaining
    buffer.writef32(u3, 0, v4)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, if a1.JumpHullActive ~= true then 0 else 1), 5) + 2654435769, 4294967295)
    local StuckStepTicks = a1.StuckStepTicks
    v3 = false
    if typeof(StuckStepTicks) == "number" then
        v3 = false
        if StuckStepTicks == StuckStepTicks then
            v3 = false
            if StuckStepTicks > (-1 / 0) then
                v3 = StuckStepTicks < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else StuckStepTicks
    buffer.writef32(u3, 0, v4)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local BaseMoveSpeed = a1.BaseMoveSpeed
    v3 = false
    if typeof(BaseMoveSpeed) == "number" then
        v3 = false
        if BaseMoveSpeed == BaseMoveSpeed then
            v3 = false
            if BaseMoveSpeed > (-1 / 0) then
                v3 = BaseMoveSpeed < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else BaseMoveSpeed
    buffer.writef32(u3, 0, v4)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local WeaponMoveSpeed = a1.WeaponMoveSpeed
    v3 = false
    if typeof(WeaponMoveSpeed) == "number" then
        v3 = false
        if WeaponMoveSpeed == WeaponMoveSpeed then
            v3 = false
            if WeaponMoveSpeed > (-1 / 0) then
                v3 = WeaponMoveSpeed < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else WeaponMoveSpeed
    buffer.writef32(u3, 0, v4)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local WeaponScopedMoveSpeed = a1.WeaponScopedMoveSpeed
    v3 = false
    if typeof(WeaponScopedMoveSpeed) == "number" then
        v3 = false
        if WeaponScopedMoveSpeed == WeaponScopedMoveSpeed then
            v3 = false
            if WeaponScopedMoveSpeed > (-1 / 0) then
                v3 = WeaponScopedMoveSpeed < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else WeaponScopedMoveSpeed
    buffer.writef32(u3, 0, v4)
    v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local VelocityModifier = a1.VelocityModifier
    v3 = false
    if typeof(VelocityModifier) == "number" then
        v3 = false
        if VelocityModifier == VelocityModifier then
            v3 = false
            if VelocityModifier > (-1 / 0) then
                v3 = VelocityModifier < (1 / 0)
            end
        end
    end
    v4 = if not v3 then 0 else VelocityModifier
    buffer.writef32(u3, 0, v4)
    return (bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295))
end

local function auxiliaryHash(a1, a2) -- Line: 231 -- upvalues: u3 (val), vectorHash (val)
    local v1, v2, v3
    local v4 = 2166136261
    if a1 ~= nil then
        local Kind = a1.Kind
        v3 = false
        if typeof(Kind) == "number" then
            v3 = false
            if Kind == Kind then
                v3 = false
                if Kind > (-1 / 0) then
                    v3 = Kind < (1 / 0)
                end
            end
        end
        v2 = if not v3 then 0 else Kind
        buffer.writef32(u3, 0, v2)
        v1 = bit32.band(bit32.lrotate(bit32.bxor(v4, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
        local SourceId = a1.SourceId
        v3 = false
        if typeof(SourceId) == "number" then
            v3 = false
            if SourceId == SourceId then
                v3 = false
                if SourceId > (-1 / 0) then
                    v3 = SourceId < (1 / 0)
                end
            end
        end
        v2 = if not v3 then 0 else SourceId
        buffer.writef32(u3, 0, v2)
        v4 = vectorHash(
            vectorHash(bit32.band(bit32.lrotate(bit32.bxor(v1, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295), a1.Anchor),
            a1.Velocity
        )
    end
    if a2 ~= nil then
        local CommandNumber = a2.CommandNumber
        v3 = false
        if typeof(CommandNumber) == "number" then
            v3 = false
            if CommandNumber == CommandNumber then
                v3 = false
                if CommandNumber > (-1 / 0) then
                    v3 = CommandNumber < (1 / 0)
                end
            end
        end
        v2 = if not v3 then 0 else CommandNumber
        buffer.writef32(u3, 0, v2)
        local v5 = bit32.band(bit32.lrotate(bit32.bxor(v4, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
        local Move = a2.Move
        if typeof(Move) == "Vector2" then
            local X = Move.X
            local v6 = false
            if typeof(X) == "number" then
                v6 = false
                if X == X then
                    v6 = false
                    if X > (-1 / 0) then
                        v6 = X < (1 / 0)
                    end
                end
            end
            local v7 = if not v6 then 0 else X
            buffer.writef32(u3, 0, v7)
            v5 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
            local Y = Move.Y
            v6 = false
            if typeof(Y) == "number" then
                v6 = false
                if Y == Y then
                    v6 = false
                    if Y > (-1 / 0) then
                        v6 = Y < (1 / 0)
                    end
                end
            end
            v7 = if not v6 then 0 else Y
            buffer.writef32(u3, 0, v7)
            v4 = bit32.band(bit32.lrotate(bit32.bxor(v5, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
        else
            v4 = bit32.band(bit32.lrotate(bit32.bxor(v5, 0), 5) + 2654435769, 4294967295)
        end
        local LookYaw = a2.LookYaw
        v3 = false
        if typeof(LookYaw) == "number" then
            v3 = false
            if LookYaw == LookYaw then
                v3 = false
                if LookYaw > (-1 / 0) then
                    v3 = LookYaw < (1 / 0)
                end
            end
        end
        v2 = if not v3 then 0 else LookYaw
        buffer.writef32(u3, 0, v2)
        v1 = bit32.band(bit32.lrotate(bit32.bxor(v4, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
        local VerticalLook = a2.VerticalLook
        v3 = false
        if typeof(VerticalLook) == "number" then
            v3 = false
            if VerticalLook == VerticalLook then
                v3 = false
                if VerticalLook > (-1 / 0) then
                    v3 = VerticalLook < (1 / 0)
                end
            end
        end
        v2 = if not v3 then 0 else VerticalLook
        buffer.writef32(u3, 0, v2)
        v1 = bit32.band(bit32.lrotate(bit32.bxor(v1, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
        local Buttons = a2.Buttons
        v3 = false
        if typeof(Buttons) == "number" then
            v3 = false
            if Buttons == Buttons then
                v3 = false
                if Buttons > (-1 / 0) then
                    v3 = Buttons < (1 / 0)
                end
            end
        end
        v2 = if not v3 then 0 else Buttons
        buffer.writef32(u3, 0, v2)
        v1 = bit32.band(bit32.lrotate(bit32.bxor(v1, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
        local Kind_2 = a2.Kind
        v3 = false
        if typeof(Kind_2) == "number" then
            v3 = false
            if Kind_2 == Kind_2 then
                v3 = false
                if Kind_2 > (-1 / 0) then
                    v3 = Kind_2 < (1 / 0)
                end
            end
        end
        v2 = if not v3 then 0 else Kind_2
        buffer.writef32(u3, 0, v2)
        v1 = bit32.band(bit32.lrotate(bit32.bxor(v1, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
        local SourceId_2 = a2.SourceId
        v3 = false
        if typeof(SourceId_2) == "number" then
            v3 = false
            if SourceId_2 == SourceId_2 then
                v3 = false
                if SourceId_2 > (-1 / 0) then
                    v3 = SourceId_2 < (1 / 0)
                end
            end
        end
        v2 = if not v3 then 0 else SourceId_2
        buffer.writef32(u3, 0, v2)
        v1 = bit32.band(bit32.lrotate(bit32.bxor(v1, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
        local Revision = a2.Revision
        v3 = false
        if typeof(Revision) == "number" then
            v3 = false
            if Revision == Revision then
                v3 = false
                if Revision > (-1 / 0) then
                    v3 = Revision < (1 / 0)
                end
            end
        end
        v2 = if not v3 then 0 else Revision
        buffer.writef32(u3, 0, v2)
        v4 = vectorHash(
            vectorHash(bit32.band(bit32.lrotate(bit32.bxor(v1, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295), a2.Delta),
            a2.Velocity
        )
    end
    return v4
end

local function eventFlags(a1, a2) -- Line: 254
    local v1 = 0
    if a1.OnGround == true then
        v1 = bit32.bor(v1, 1)
    end
    if a1.Stance == "Ducking" or 0.999 <= a1.DuckAmount then
        v1 = bit32.bor(v1, 2)
    end
    if a1.MovementMode == "Ladder" or a1.MovementType == "Ladder" then
        v1 = bit32.bor(v1, 4)
    end
    if a1.JumpHullActive == true then
        v1 = bit32.bor(v1, 8)
    end
    if a1.IsDucking == true then
        v1 = bit32.bor(v1, 16)
    end
    if a2 ~= nil and a2.Kind ~= nil and a2.Kind ~= 0 then
        v1 = bit32.bor(v1, 32)
    end
    return v1
end

local function writeEvent(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) -- Line: 277
    -- upvalues: 
    if 128 <= a1.Count then
        a1.Overflow = true
        return
    end
    local v1 = a1.BaseOffset + 16 + a1.Count * 48
    local Buffer = a1.Buffer
    local v2 = v1 + 0
    buffer.writeu32(Buffer, v2, a2)
    v2 = v1 + 4
    local v3 = math.clamp(a4, 0, 65535)
    buffer.writeu16(Buffer, v2, v3)
    v2 = v1 + 6
    v3 = bit32.bor(a5, (bit32.lshift(a3, 2)))
    buffer.writeu8(Buffer, v2, v3)
    v2 = v1 + 7
    buffer.writeu8(Buffer, v2, a6)
    v2 = v1 + 8
    buffer.writeu32(Buffer, v2, a7)
    v2 = v1 + 12
    buffer.writeu32(Buffer, v2, a8)
    v2 = v1 + 16
    local X = a9.X
    buffer.writef32(Buffer, v2, X)
    v2 = v1 + 16 + 4
    local Y = a9.Y
    buffer.writef32(Buffer, v2, Y)
    v2 = v1 + 16 + 8
    local Z = a9.Z
    buffer.writef32(Buffer, v2, Z)
    v2 = v1 + 28
    local X_2 = a10.X
    buffer.writef32(Buffer, v2, X_2)
    v2 = v1 + 28 + 4
    local Y_2 = a10.Y
    buffer.writef32(Buffer, v2, Y_2)
    v2 = v1 + 28 + 8
    local Z_2 = a10.Z
    buffer.writef32(Buffer, v2, Z_2)
    v2 = v1 + 40
    local v4 = false
    if typeof(a11) == "number" then
        v4 = false
        if a11 == a11 then
            v4 = false
            if a11 > (-1 / 0) then
                v4 = a11 < (1 / 0)
            end
        end
    end
    v3 = if not v4 then 0 else a11
    buffer.writef32(Buffer, v2, v3)
    v2 = v1 + 44
    v3 = bit32.band(a12, 4294967295)
    buffer.writeu32(Buffer, v2, v3)
    a1.Count = a1.Count + 1
end

function u0.checkpoint(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 314
    -- upvalues: writeEvent (val), registerSite (val), sourceId (val), eventFlags (val), stateHash (val)
    -- upvalues: auxiliaryHash (val)
    local v1, v2
    if a1 == nil then
        return
    end
    if a7 == nil or a8 == nil then
        local v3, v4 = debug.info(a6 or 2, "sl")
        v1 = v3
        v2 = v4
    else
        v1 = a7
        v2 = a8
    end
    local Position_2 = if typeof(a3.Position) ~= "Vector3" then Vector3.new(0, 0, 0) else a3.Position
    local Velocity_2 = if typeof(a3.Velocity) ~= "Vector3" then Vector3.new(0, 0, 0) else a3.Velocity
    writeEvent(
        a1,
        registerSite(a2, v1),
        sourceId(v1),
        v2,
        1,
        eventFlags(a3, a4),
        stateHash(a3),
        auxiliaryHash(a4, a5),
        Position_2,
        Velocity_2,
        a3.DuckAmount or 0,
        if a4 == nil then 0 else if typeof(a4.SourceId) ~= "number" then 0 else a4.SourceId
    )
end

function u0.vector(a1, a2, a3, a4, a5, a6, a7, a8, a9) -- Line: 351
    -- upvalues: vectorHash (val), writeEvent (val), registerSite (val), sourceId (val), u3 (val)
    local v1, v2, v3
    if a1 == nil then
        return
    end
    if a8 == nil or a9 == nil then
        local v4
        v2, v4 = debug.info(a7 or 2, "sl")
        v3 = v2
        v1 = v4
    else
        v3 = a8
        v1 = a9
    end
    v2 = vectorHash(vectorHash(2166136261, a3), a4)
    local v5 = registerSite(a2, v3)
    local v6 = sourceId(v3)
    local v7 = false
    if typeof(a5) == "number" then
        v7 = false
        if a5 == a5 then
            v7 = false
            if a5 > (-1 / 0) then
                v7 = a5 < (1 / 0)
            end
        end
    end
    local v8 = if not v7 then 0 else a5
    buffer.writef32(u3, 0, v8)
    local v9 = bit32.band(bit32.lrotate(bit32.bxor(2166136261, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    v7 = false
    if typeof(a6) == "number" then
        v7 = false
        if a6 == a6 then
            v7 = false
            if a6 > (-1 / 0) then
                v7 = a6 < (1 / 0)
            end
        end
    end
    v8 = if not v7 then 0 else a6
    buffer.writef32(u3, 0, v8)
    writeEvent(
        a1,
        v5,
        v6,
        v1,
        1,
        0,
        v2,
        bit32.band(bit32.lrotate(bit32.bxor(v9, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295),
        a3,
        a4,
        a5 or 0,
        a6 or 0
    )
end

function u0.collision(a1, a2, a3, a4, a5, a6) -- Line: 388
    -- upvalues: vectorHash (val), u3 (val), writeEvent (val), registerSite (val), sourceId (val)
    if a1 == nil then
        return
    end
    local v1, v2 = debug.info(a6 or 2, "sl")
    local v3 = 0
    if a5.startSolid == true or a5.StartSolid == true then
        v3 = bit32.bor(v3, 64)
    end
    if a5.allSolid == true or a5.AllSolid == true then
        v3 = bit32.bor(v3, 128)
    end
    local fraction = a5.fraction or a5.Fraction or 1
    local endPos = a5.endPos or a5.ResolvedPosition or a3:Lerp(a4, fraction)
    local normal = a5.normal or a5.Normal or Vector3.new(0, 0, 0)
    local hullRecord = a5.hullRecord
    local SourceId = a5.SourceId or hullRecord and hullRecord.sourceId or 0
    local v4 = vectorHash(2166136261, normal)
    local v5 = false
    if typeof(fraction) == "number" then
        v5 = false
        if fraction == fraction then
            v5 = false
            if fraction > (-1 / 0) then
                v5 = fraction < (1 / 0)
            end
        end
    end
    local v6 = if not v5 then 0 else fraction
    buffer.writef32(u3, 0, v6)
    v6 = bit32.band(
        bit32.lrotate(bit32.bxor(bit32.band(bit32.lrotate(bit32.bxor(v4, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295), v3), 5) + 2654435769,
        4294967295
    )
    v5 = false
    if typeof(SourceId) == "number" then
        v5 = false
        if SourceId == SourceId then
            v5 = false
            if SourceId > (-1 / 0) then
                v5 = SourceId < (1 / 0)
            end
        end
    end
    v6 = if not v5 then 0 else SourceId
    buffer.writef32(u3, 0, v6)
    v6 = bit32.band(bit32.lrotate(bit32.bxor(v6, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local PlaneId = a5.PlaneId or a5.planeNum
    local v7 = false
    if typeof(PlaneId) == "number" then
        v7 = false
        if PlaneId == PlaneId then
            v7 = false
            if PlaneId > (-1 / 0) then
                v7 = PlaneId < (1 / 0)
            end
        end
    end
    v5 = if not v7 then 0 else PlaneId
    buffer.writef32(u3, 0, v5)
    v6 = bit32.band(bit32.lrotate(bit32.bxor(v6, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local Kind = a5.Kind or hullRecord and hullRecord.kind
    v7 = false
    if typeof(Kind) == "number" then
        v7 = false
        if Kind == Kind then
            v7 = false
            if Kind > (-1 / 0) then
                v7 = Kind < (1 / 0)
            end
        end
    end
    v5 = if not v7 then 0 else Kind
    buffer.writef32(u3, 0, v5)
    v4 = bit32.band(bit32.lrotate(bit32.bxor(v6, (buffer.readu32(u3, 0))), 5) + 2654435769, 4294967295)
    local v8 = vectorHash(vectorHash(2166136261, a3), a4)
    writeEvent(a1, registerSite(a2, v1), sourceId(v1), v2, 2, v3, v8, v4, endPos, normal, fraction, SourceId)
end

local function resetRecorder(a1, a2, a3, a4) -- Line: 435 -- types: a1: table, a2: number, a3: number, a4: number
    a1.Count = 0
    a1.Overflow = false
    local Buffer = a1.Buffer
    local BaseOffset = a1.BaseOffset
    buffer.writeu8(Buffer, BaseOffset, 2)
    local v1 = BaseOffset + 1
    buffer.writeu8(Buffer, v1, 0)
    v1 = BaseOffset + 2
    buffer.writeu8(Buffer, v1, 0)
    v1 = BaseOffset + 3
    buffer.writeu8(Buffer, v1, 0)
    v1 = BaseOffset + 4
    buffer.writeu16(Buffer, v1, a2)
    v1 = BaseOffset + 6
    buffer.writeu16(Buffer, v1, 0)
    v1 = BaseOffset + 8
    buffer.writeu32(Buffer, v1, a3)
    v1 = BaseOffset + 12
    buffer.writeu32(Buffer, v1, a4)
end

function u4.new(a1) -- Line: 450 -- upvalues: u4 (val) -- types: a1: number
    local v1
    local v2 = false
    if a1 % 1 == 0 then
        v2 = a1 > 0
    end
    assert(v2, "determinism trace capacity must be positive")
    local v3 = table.create(a1)
    v2 = buffer.create(a1 * 6160)
    for i = 1, a1 do
        v1 = {Count = 0, Overflow = false, Buffer = v2, BaseOffset = (i - 1) * 6160}
        v3[i] = {Generation = 0, CommandNumber = 0, ServerTick = 0, Recorder = v1}
    end
    return (setmetatable({Capacity = a1, Slots = v3}, u4))
end

function u4.clear(a1) -- Line: 474
    for i, j in a1.Slots do
        j.Generation = 0
        j.CommandNumber = 0
        j.ServerTick = 0
        j.Recorder.Count = 0
        j.Recorder.Overflow = false
    end
end

function u4.begin(a1, a2, a3, a4) -- Line: 484 -- types: a1: table, a2: number, a3: number, a4: number
    local v1 = a1.Slots[a3 % a1.Capacity + 1]
    v1.Generation = a2
    v1.CommandNumber = a3
    v1.ServerTick = a4
    local Recorder = v1.Recorder
    Recorder.Count = 0
    Recorder.Overflow = false
    local Buffer = Recorder.Buffer
    local BaseOffset = Recorder.BaseOffset
    buffer.writeu8(Buffer, BaseOffset, 2)
    local v2 = BaseOffset + 1
    buffer.writeu8(Buffer, v2, 0)
    v2 = BaseOffset + 2
    buffer.writeu8(Buffer, v2, 0)
    v2 = BaseOffset + 3
    buffer.writeu8(Buffer, v2, 0)
    v2 = BaseOffset + 4
    buffer.writeu16(Buffer, v2, a2)
    v2 = BaseOffset + 6
    buffer.writeu16(Buffer, v2, 0)
    v2 = BaseOffset + 8
    buffer.writeu32(Buffer, v2, a3)
    v2 = BaseOffset + 12
    buffer.writeu32(Buffer, v2, a4)
    return v1.Recorder
end

function u4.finish(a1, a2) -- Line: 493 -- types: a1: table, a2: table
    local v1 = if not a2.Overflow then 0 else 1
    local Buffer = a2.Buffer
    local v2 = a2.BaseOffset + 1
    buffer.writeu8(Buffer, v2, v1)
    local Buffer_2 = a2.Buffer
    v2 = a2.BaseOffset + 2
    local Count = a2.Count
    buffer.writeu8(Buffer_2, v2, Count)
end

local function cloneUsed(a1, a2) -- Line: 499 -- types: a1: buffer, a2: number?
    local v1 = a2 or 0
    local v2 = v1 + 2
    local v3 = buffer.readu8(a1, v2) * 48 + 16
    v2 = buffer.create(v3)
    buffer.copy(v2, 0, a1, v1, v3)
    return v2
end

function u4.get(a1, a2, a3, a4) -- Line: 508 -- types: a1: table, a2: number, a3: number, a4: number
    local v1 = a1.Slots[a3 % a1.Capacity + 1]
    if v1.Generation == a2 and v1.CommandNumber == a3 and v1.ServerTick == a4 then
        local Buffer = v1.Recorder.Buffer
        local v2 = v1.Recorder.BaseOffset or 0
        local v3 = v2 + 2
        local v4 = buffer.readu8(Buffer, v3) * 48 + 16
        local v5 = buffer.create(v4)
        buffer.copy(v5, 0, Buffer, v2, v4)
        return v5
    end
    return nil
end

function u0.encodeRequest(a1, a2, a3) -- Line: 516 -- types: a1: number, a2: number, a3: number
    local v1 = buffer.create(12)
    buffer.writeu8(v1, 0, 2)
    buffer.writeu8(v1, 1, 0)
    buffer.writeu16(v1, 2, a1)
    buffer.writeu32(v1, 4, a2)
    buffer.writeu32(v1, 8, a3)
    return v1
end

function u0.decodeRequest(a1) -- Line: 526
    if typeof(a1) == "buffer" and buffer.len(a1) == 12 and buffer.readu8(a1, 0) == 2 then
        return (buffer.readu16(a1, 2)), (buffer.readu32(a1, 4)), (buffer.readu32(a1, 8))
    end
    return nil, nil, nil
end

function u0.unavailable(a1, a2, a3) -- Line: 533 -- types: a1: number, a2: number, a3: number
    local v1 = buffer.create(16)
    buffer.writeu8(v1, 0, 2)
    buffer.writeu8(v1, 1, 2)
    buffer.writeu8(v1, 2, 0)
    buffer.writeu16(v1, 4, a1)
    buffer.writeu32(v1, 8, a2)
    buffer.writeu32(v1, 12, a3)
    return v1
end

function u0.identity(a1) -- Line: 544
    if typeof(a1) == "buffer" then
        local v1 = buffer.len(a1)
        if not (v1 < 16) and buffer.readu8(a1, 0) == 2 then
            v1 = buffer.readu8(a1, 2)
            if not (v1 > 128) and (buffer.len(a1)) == v1 * 48 + 16 then
                return (buffer.readu16(a1, 4)), (buffer.readu32(a1, 8)), (buffer.readu32(a1, 12)), bit32.band(buffer.readu8(a1, 1), 2) ~= 0
            end
            return nil, nil, nil, nil
        end
    end
    return nil, nil, nil, nil
end

local function readEvent(a1, a2) -- Line: 558 -- types: a1: buffer, a2: number
    local v1 = (a2 - 1) * 48 + 16
    local v2 = v1 + 6
    local v3 = buffer.readu8(a1, v2)
    local v4 = {}
    local v5 = v1 + 0
    v4.SiteId = buffer.readu32(a1, v5)
    v4.SourceId = bit32.rshift(v3, 2)
    v5 = v1 + 4
    v4.Line = buffer.readu16(a1, v5)
    v4.Kind = bit32.band(v3, 3)
    v5 = v1 + 7
    v4.Flags = buffer.readu8(a1, v5)
    v5 = v1 + 8
    v4.StateHash = buffer.readu32(a1, v5)
    v5 = v1 + 12
    v4.AuxHash = buffer.readu32(a1, v5)
    local v6 = v1 + 16
    local v7 = buffer.readf32(a1, v6)
    local v8 = v1 + 16 + 4
    v5 = buffer.readf32(a1, v8)
    local v9 = v1 + 16 + 8
    v4.Position = Vector3.new(v7, v5, (buffer.readf32(a1, v9)))
    v6 = v1 + 28
    v7 = buffer.readf32(a1, v6)
    v8 = v1 + 28 + 4
    v5 = buffer.readf32(a1, v8)
    v9 = v1 + 28 + 8
    v4.Velocity = Vector3.new(v7, v5, (buffer.readf32(a1, v9)))
    v5 = v1 + 40
    v4.Scalar = buffer.readf32(a1, v5)
    v5 = v1 + 44
    v4.ObjectId = buffer.readu32(a1, v5)
    return v4
end

local function eventClass(a1, a2) -- Line: 584 -- types: a1: table, a2: table
    if a1.SiteId == a2.SiteId and a1.Kind == a2.Kind then
        if a1.Position ~= a2.Position then
            return "Position"
        end
        if a1.Velocity ~= a2.Velocity then
            if a1.Kind == 2 then
                return "CollisionNormal"
            end
            return "Velocity"
        end
        if a1.Flags ~= a2.Flags then
            return "StateFlags"
        end
        if a1.Scalar ~= a2.Scalar then
            if a1.Kind == 2 then
                return "CollisionFraction"
            end
            return "ScalarState"
        end
        if a1.ObjectId ~= a2.ObjectId then
            if a1.Kind == 2 then
                return "CollisionSource"
            end
            return "SupportSource"
        end
        if a1.StateHash ~= a2.StateHash then
            if a1.Kind == 2 then
                return "CollisionQueryInput"
            end
            return "HiddenState"
        end
        if a1.AuxHash == a2.AuxHash then
            return nil
        end
        if a1.Kind == 2 then
            return "CollisionResult"
        end
        return "InputOrSupport"
    end
    return "ControlFlow"
end

function u0.describe(a1) -- Line: 614 -- upvalues: u0 (val), readEvent (val), u5 (val), u18 (val)
    if u0.identity(a1) ~= nil and typeof(a1) == "buffer" then
        local Label, v1, v2, v3
        local v4 = buffer.readu8(a1, 2)
        local v5 = table.create(v4)
        for i = 1, v4 do
            v1 = readEvent(a1, i)
            v2 = u5[v1.SiteId]
            v3 = {Index = i}
            Label = if v2 == nil then string.format("site-0x%08X", v1.SiteId) else v2.Label
            v3.Label = Label
            v3.Source = if v2 == nil then u18[v1.SourceId] or "unknown" else v2.Source
            v3.Event = v1
            v5[i] = v3
        end
        return v5
    end
    return nil
end

function u0.compare(a1, a2) -- Line: 634
    -- upvalues: u0 (val), readEvent (val), eventClass (val), u5 (val), u18 (val)
    local v1, v2, v3 = u0.identity(a1)
    local v4, v5, v6 = u0.identity(a2)
    if v1 ~= nil and v4 ~= nil and v1 == v4 and v2 == v5 and v3 == v6 then
        local Label, v7, v8, v9, v10, v11
        local v12 = buffer.readu8(a1, 2)
        local v13 = buffer.readu8(a2, 2)
        local v14 = bit32.band(buffer.readu8(a1, 1), 1) ~= 0
        local v15 = bit32.band(buffer.readu8(a2, 1), 1) ~= 0
        local v16 = math.min(v12, v13)
        for i = 1, v16 do
            v7 = readEvent(a1, i)
            v8 = readEvent(a2, i)
            v9 = eventClass(v7, v8)
            if v9 ~= nil then
                v10 = u5[v7.SiteId] or u5[v8.SiteId]
                v11 = {Matched = false, Classification = v9, EventIndex = i}
                Label = if v10 == nil then string.format("site-0x%08X", v7.SiteId) else v10.Label
                v11.Label = Label
                v11.Source = if v10 == nil then "unknown" else v10.Source
                v11.ClientSource = u18[v7.SourceId] or "unknown"
                v11.ServerSource = u18[v8.SourceId] or "unknown"
                v11.Client = v7
                v11.Server = v8
                v11.ClientCount = v12
                v11.ServerCount = v13
                v11.ClientOverflow = v14
                v11.ServerOverflow = v15
                return v11
            end
        end
        if v12 == v13 and v14 == v15 then
            return {
                Matched = true,
                Classification = "NoRecordedDifference",
                Label = "trace-end",
                Source = "MovementV2.Simulation.DeterminismTrace",
                ClientSource = "trace-end",
                ServerSource = "trace-end",
                EventIndex = v16,
                ClientCount = v12,
                ServerCount = v13,
                ClientOverflow = v14,
                ServerOverflow = v15,
            }
        end
        local v17 = v16 + 1
        local v18 = if not (v17 <= v12) then nil else readEvent(a1, v17)
        local v19 = if not (v17 <= v13) then nil else readEvent(a2, v17)
        v7 = v18 or v19
        v8 = if v7 == nil then nil else u5[v7.SiteId]
        v9 = {Matched = false}
        v9.Classification = if v14 then "TraceOverflow" else if not v15 then "ControlFlowLength" else "TraceOverflow"
        v9.EventIndex = v16 + 1
        v9.Label = if v8 == nil then if v7 == nil then "trace-end" else string.format("site-0x%08X", v7.SiteId) else v8.Label
        v9.Source = if v8 == nil then "MovementV2.Simulation.DeterminismTrace" else v8.Source
        v9.ClientSource = if v18 == nil then "trace-end" else u18[v18.SourceId] or "unknown"
        v9.ServerSource = if v19 == nil then "trace-end" else u18[v19.SourceId] or "unknown"
        v9.Client = v18
        v9.Server = v19
        v9.ClientCount = v12
        v9.ServerCount = v13
        v9.ClientOverflow = v14
        v9.ServerOverflow = v15
        return v9
    end
    return nil
end

u0.Ring = u4
u0.MaxEvents = 128
return table.freeze(u0)