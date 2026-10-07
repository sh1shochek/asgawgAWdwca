-- ReplicatedStorage.MovementV2.Client.PredictionRing
-- Script path: ReplicatedStorage.MovementV2.Client.PredictionRing
-- Decompile time: 6.75 ms

local CommandCodec = require(script.Parent.Parent.CommandCodec)
local Config = require(script.Parent.Parent.Config)
local Enums = require(script.Parent.Parent.Enums)
local Mapping = require(script.Parent.Parent.Mapping)
local Quantization = require(script.Parent.Parent.Quantization)
local Serial = require(script.Parent.Parent.Serial)
local StateCodec = require(script.Parent.Parent.StateCodec)
require(script.Parent.Parent.Types)
local State = require(script.Parent.Parent.Simulation.State)
local u55 = {}
u55.__index = u55
u55.Dependency = table.freeze({Player = 1, Mover = 2, ValidMask = 3})

local function slotIndex(a1, a2) -- Line: 51 -- upvalues: Serial (val) -- types: a2: number
    local _newestCommandNumber = a1._newestCommandNumber
    if _newestCommandNumber == nil then
        return 1
    end
    return (a1._newestSlotIndex - 1 + Serial.deltaUInt32(a2, _newestCommandNumber)) % a1._capacity + 1
end

local function copyStateInto(a1, a2) -- Line: 59
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
end

local function copySupportInto(a1, a2) -- Line: 88
    a1.Kind = a2.Kind
    a1.SourceId = a2.SourceId
    a1.Anchor = a2.Anchor
    a1.Velocity = a2.Velocity
end

local function newSlot() -- Line: 95 -- upvalues: State (val)
    return {
        Active = false,
        ServerTick = 0,
        TopologyRevision = 0,
        DependencyMask = 0,
        Command = {
            CommandNumber = 0,
            LookYaw = 0,
            VerticalLook = 0,
            Buttons = 0,
            Move = Vector2.zero,
        },
        PostState = State.new((Vector3.new(0, 0, 0))),
        PostSupport = State.noneSupport(),
    }
end

local function createSlots(a1) -- Line: 120 -- upvalues: newSlot (val) -- types: a1: number
    local v1 = table.create(a1)
    for i = 1, a1 do
        v1[i] = (newSlot())
    end
    return v1
end

local function validateSupport(a1) -- Line: 128 -- upvalues: Enums (val), Serial (val), Quantization (val)
    if typeof(a1) ~= "table" then
        return false, "SupportNotTable"
    end
    if type(a1.Kind) == "number"
        and a1.Kind % 1 == 0
        and not (a1.Kind < Enums.SupportKind.None)
        and not (Enums.SupportKind.Max < a1.Kind) then
        if not Serial.isUInt32(a1.SourceId) then
            return false, "InvalidSupportSourceId"
        end
        if a1.Kind == Enums.SupportKind.None ~= (a1.SourceId == 0) then
            return false, "InvalidEmptySupport"
        end
        if Quantization.isFiniteVector3(a1.Anchor) and Quantization.isFiniteVector3(a1.Velocity) then
            return true, nil
        end
        return false, "InvalidSupportVector"
    end
    return false, "InvalidSupportKind"
end

local function validateStoredValues(a1, a2, a3, a4, a5) -- Line: 152
    -- upvalues: Serial (val), u55 (val), StateCodec (val), validateSupport (val)
    if not Serial.isUInt32(a1) then
        return false, "InvalidServerTick"
    end
    if not Serial.isUInt32(a4) then
        return false, "InvalidTopologyRevision"
    end
    if Serial.isUInt32(a5) then
        local v1 = bit32.bnot(u55.Dependency.ValidMask)
        if bit32.band(a5, v1) == 0 then
            local v2
            local v3, v4 = StateCodec.validate(a2)
            if not v3 then
                return false, v4
            end
            v1, v2 = validateSupport(a3)
            if not v1 then
                return false, v2
            end
            return true, nil
        end
    end
    return false, "InvalidPredictionDependencyMask"
end

local function writeSlot(a1, a2, a3, a4, a5, a6, a7) -- Line: 182
    -- upvalues: CommandCodec (val), copyStateInto (val)
    local v1, v2 = CommandCodec.canonicalizeCommandInto(a1.Command, a2.CommandNumber, a2)
    if v1 == nil then
        return false, v2
    end
    copyStateInto(a1.PostState, a4)
    local PostSupport = a1.PostSupport
    PostSupport.Kind = a5.Kind
    PostSupport.SourceId = a5.SourceId
    PostSupport.Anchor = a5.Anchor
    PostSupport.Velocity = a5.Velocity
    a1.ServerTick = a3
    a1.TopologyRevision = a6
    a1.DependencyMask = a7
    a1.Active = true
    return true, nil
end

function u55.new(a1) -- Line: 204 -- upvalues: Mapping (val), Config (val), newSlot (val), u55 (val)
    local v1, v2 = Mapping.validate(a1)
    assert(v1, v2 or "invalid command mapping")
    local PredictionReplayTicks = Config.derive(a1.SimulationHz).PredictionReplayTicks
    local v3 = {_count = 0, _newestSlotIndex = 1, _capacity = PredictionReplayTicks}
    local v4 = table.create(PredictionReplayTicks)
    for i = 1, PredictionReplayTicks do
        v4[i] = (newSlot())
    end
    v3._slots = v4
    return (setmetatable(v3, u55))
end

function u55:clear() -- Line: 216
    for i, j in self._slots do
        j.Active = false
    end
    self._count = 0
    self._newestCommandNumber = nil
    self._newestSlotIndex = 1
end

function u55.reset(a1, a2) -- Line: 225 -- upvalues: Mapping (val), Config (val), newSlot (val)
    local v1, v2 = Mapping.validate(a2)
    assert(v1, v2 or "invalid command mapping")
    local PredictionReplayTicks = Config.derive(a2.SimulationHz).PredictionReplayTicks
    if PredictionReplayTicks ~= a1._capacity then
        a1._capacity = PredictionReplayTicks
        local v3 = table.create(PredictionReplayTicks)
        for i = 1, PredictionReplayTicks do
            v3[i] = (newSlot())
        end
        a1._slots = v3
    end
    a1:clear()
end

function u55.isFull(a1) -- Line: 236
    return a1._capacity <= a1._count
end

function u55.count(a1) -- Line: 240
    return a1._count
end

function u55.capacity(a1) -- Line: 244
    return a1._capacity
end

function u55.newestCommandNumber(a1) -- Line: 248
    return a1._newestCommandNumber
end

function u55:get(a2) -- Line: 252 -- upvalues: Serial (val) -- types: self: table, a2: number
    if not Serial.isUInt32(a2) then
        return nil
    end
    local _slots = self._slots
    local _newestCommandNumber = self._newestCommandNumber
    local v1 = _slots[if _newestCommandNumber ~= nil then (self._newestSlotIndex - 1 + Serial.deltaUInt32(a2, _newestCommandNumber)) % self._capacity + 1 else 1]
    if v1.Active and v1.Command.CommandNumber == a2 then
        return v1
    end
    return nil
end

function u55.anyEntryAtOrAfterServerTick(a1, a2, a3) -- Line: 263
    -- upvalues: Serial (val)
    if not Serial.isUInt32(a2) then
        return false
    end
    for i, j in a1._slots do
        if j.Active and 0 <= (Serial.deltaUInt32(j.ServerTick, a2)) and a3(j) then
            return true
        end
    end
    return false
end

function u55.push(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 275
    -- upvalues: CommandCodec (val), validateStoredValues (val), Serial (val), copyStateInto (val)
    local PostSupport, v1, v2, v3, v4, v5
    local v6, v7 = CommandCodec.validateCommand(a2.CommandNumber, a2)
    if not v6 then
        return false, v7
    end
    local v8 = a8 or 0
    local v9, v10 = validateStoredValues(a3, a4, a5, a6, v8)
    if not v9 then
        return false, v10
    end
    local _newestCommandNumber = a1._newestCommandNumber
    if _newestCommandNumber ~= nil then
        v1 = Serial.deltaUInt32(a2.CommandNumber, _newestCommandNumber)
        if v1 < 0 then
            return false, "CommandOlderThanTail"
        end
        if v1 > 1 then
            return false, "NonSequentialCommand"
        end
    end
    local CommandNumber = a2.CommandNumber
    local _newestCommandNumber_2 = a1._newestCommandNumber
    local v11 = a1._slots[if _newestCommandNumber_2 ~= nil then (a1._newestSlotIndex - 1 + Serial.deltaUInt32(CommandNumber, _newestCommandNumber_2)) % a1._capacity + 1 else 1]
    if v11.Active and v11.Command.CommandNumber ~= a2.CommandNumber then
        if a7 == true then
            v2 = Serial.deltaUInt32(a2.CommandNumber, v11.Command.CommandNumber)
            if v2 == a1._capacity then
                if not v11.Active then
                    a1._count = a1._count + 1
                end
                v4, v5 = CommandCodec.canonicalizeCommandInto(v11.Command, a2.CommandNumber, a2)
                if v4 ~= nil then
                    copyStateInto(v11.PostState, a4)
                    PostSupport = v11.PostSupport
                    PostSupport.Kind = a5.Kind
                    PostSupport.SourceId = a5.SourceId
                    PostSupport.Anchor = a5.Anchor
                    PostSupport.Velocity = a5.Velocity
                    v11.ServerTick = a3
                    v11.TopologyRevision = a6
                    v11.DependencyMask = v8
                    v11.Active = true
                    v2 = true
                    v3 = nil
                else
                    v2 = false
                    v3 = v5
                end
                if not v2 then
                    return false, v3
                end
                if _newestCommandNumber == nil or Serial.isNewerUInt32(a2.CommandNumber, _newestCommandNumber) then
                    a1._newestCommandNumber = a2.CommandNumber
                    a1._newestSlotIndex = v1
                end
                return true, nil
            end
        end
        return false, "PredictionHistoryOverflow"
    end
    if not v11.Active then
        a1._count = a1._count + 1
    end
    v4, v5 = CommandCodec.canonicalizeCommandInto(v11.Command, a2.CommandNumber, a2)
    if v4 ~= nil then
        copyStateInto(v11.PostState, a4)
        PostSupport = v11.PostSupport
        PostSupport.Kind = a5.Kind
        PostSupport.SourceId = a5.SourceId
        PostSupport.Anchor = a5.Anchor
        PostSupport.Velocity = a5.Velocity
        v11.ServerTick = a3
        v11.TopologyRevision = a6
        v11.DependencyMask = v8
        v11.Active = true
        v2 = true
        v3 = nil
    else
        v2 = false
        v3 = v5
    end
    if not v2 then
        return false, v3
    end
    if _newestCommandNumber == nil or Serial.isNewerUInt32(a2.CommandNumber, _newestCommandNumber) then
        a1._newestCommandNumber = a2.CommandNumber
        a1._newestSlotIndex = v1
    end
    return true, nil
end

function u55.replacePrediction(a1, a2, a3, a4, a5, a6, a7) -- Line: 331
    -- upvalues: Serial (val), validateStoredValues (val), copyStateInto (val)
    if not Serial.isUInt32(a2) then
        return false, "InvalidCommandNumber"
    end
    local _slots = a1._slots
    local _newestCommandNumber = a1._newestCommandNumber
    local v1 = _slots[if _newestCommandNumber ~= nil then (a1._newestSlotIndex - 1 + Serial.deltaUInt32(a2, _newestCommandNumber)) % a1._capacity + 1 else 1]
    if v1.Active and v1.Command.CommandNumber == a2 then
        local DependencyMask = a7 or v1.DependencyMask
        local v2, v3 = validateStoredValues(a3, a4, a5, a6, DependencyMask)
        if not v2 then
            return false, v3
        end
        copyStateInto(v1.PostState, a4)
        local PostSupport = v1.PostSupport
        PostSupport.Kind = a5.Kind
        PostSupport.SourceId = a5.SourceId
        PostSupport.Anchor = a5.Anchor
        PostSupport.Velocity = a5.Velocity
        v1.ServerTick = a3
        v1.TopologyRevision = a6
        v1.DependencyMask = DependencyMask
        return true, nil
    end
    return false, "CommandNotBuffered"
end

function u55.entriesAfter(a1, a2, a3) -- Line: 360 -- upvalues: Serial (val) -- types: a1: table, a2: number, a3: table?
    local v1
    local v2 = a3 or {}
    table.clear(v2)
    if not Serial.isUInt32(a2) then
        return v2
    end
    local _newestCommandNumber = a1._newestCommandNumber
    if _newestCommandNumber == nil then
        return v2
    end
    for i = 1, (math.min(math.max(Serial.deltaUInt32(_newestCommandNumber, a2), 0), a1._capacity)) do
        v1 = a1:get((Serial.addUInt32(a2, i)))
        if v1 == nil then
            break
        end
        v2[#v2 + 1] = v1
    end
    return v2
end

function u55.cloneEntry(a1) -- Line: 381 -- upvalues: CommandCodec (val), State (val) -- types: a1: table
    local v1, v2 = CommandCodec.canonicalizeCommand(a1.Command.CommandNumber, a1.Command)
    assert(v1 ~= nil, v2 or "prediction entry command became invalid")
    return {
        Command = v1,
        ServerTick = a1.ServerTick,
        PostState = State.clone(a1.PostState),
        PostSupport = State.cloneSupport(a1.PostSupport),
        TopologyRevision = a1.TopologyRevision,
        DependencyMask = a1.DependencyMask,
    }
end

function u55.shiftServerTicksAfter(a1, a2, a3) -- Line: 394
    -- upvalues: Serial (val)
    if Serial.isUInt32(a2) and type(a3) == "number" and a3 % 1 == 0 then
        local v1
        if a1._capacity < (math.abs(a3)) then
            return false, "PredictionTickShiftTooLarge"
        end
        local _newestCommandNumber = a1._newestCommandNumber
        if _newestCommandNumber == nil then
            return true, nil
        end
        for i = 1, (math.min(math.max(Serial.deltaUInt32(_newestCommandNumber, a2), 0), a1._capacity)) do
            v1 = a1:get((Serial.addUInt32(a2, i)))
            if v1 == nil then
                return false, "PredictionHistoryGap"
            end
            v1.ServerTick = Serial.addUInt32(v1.ServerTick, a3)
        end
        return true, nil
    end
    return false, "InvalidPredictionTickShift"
end

function u55.dropThrough(a1, a2) -- Line: 416 -- upvalues: Serial (val) -- types: a1: table, a2: number
    if not Serial.isUInt32(a2) then
        return 0
    end
    local v1 = 0
    for i, j in a1._slots do
        if j.Active and (Serial.deltaUInt32(j.Command.CommandNumber, a2)) <= 0 then
            j.Active = false
            a1._count = a1._count - 1
            v1 = v1 + 1
        end
    end
    if a1._count == 0 then
        a1._newestCommandNumber = nil
    end
    return v1
end

return table.freeze(u55)