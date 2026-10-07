-- ReplicatedStorage.MovementV2.Client.CommandStream
-- Script path: ReplicatedStorage.MovementV2.Client.CommandStream
-- Decompile time: 5.36 ms

local CommandCodec = require(script.Parent.Parent.CommandCodec)
local Config = require(script.Parent.Parent.Config)
local Mapping = require(script.Parent.Parent.Mapping)
local Serial = require(script.Parent.Parent.Serial)
require(script.Parent.Parent.Types)
local u30 = {}
u30.__index = u30

local function slotIndex(a1, a2) -- Line: 46 -- upvalues: Serial (val) -- types: a2: number
    local _lastSampledCommandNumber = a1._lastSampledCommandNumber
    if _lastSampledCommandNumber == nil then
        return 1
    end
    return (a1._lastSampledSlotIndex - 1 + Serial.deltaUInt32(a2, _lastSampledCommandNumber)) % a1._capacity + 1
end

local function packetCadenceRate(a1) -- Line: 54 -- upvalues: Config (val) -- types: a1: number
    local v1 = 1 / Config.PolicySeconds.CommandPacketPeriod
    local v2 = false
    if v1 % 1 == 0 then
        v2 = v1 > 0
    end
    assert(v2, "command packet period must resolve to an integer rate")
    return (math.min(a1, v1))
end

function u30.new(a1) -- Line: 60 -- upvalues: u30 (val)
    local v1 = setmetatable({_slots = {}}, u30)
    v1:reset(a1)
    return v1
end

function u30:reset(a2) -- Line: 66 -- upvalues: Mapping (val), Config (val), Serial (val)
    local v1, v2 = Mapping.validate(a2)
    assert(v1, v2 or "invalid command mapping")
    local v3 = Config.derive(a2.SimulationHz)
    self._mapping = Mapping.clone(a2)
    self._config = v3
    self._capacity = math.max(v3.CommandHistoryTicks, v3.MaxCommandsPerPacket)
    table.clear(self._slots)
    self._lastSampledCommandNumber = nil
    self._lastSampledSlotIndex = 1
    self._lastPacketedCommandNumber = Serial.UInt32Max
    local SimulationHz = v3.SimulationHz
    local v4 = 1 / Config.PolicySeconds.CommandPacketPeriod
    local v5 = false
    if v4 % 1 == 0 then
        v5 = v4 > 0
    end
    assert(v5, "command packet period must resolve to an integer rate")
    self._packetCadenceRateHz = math.min(SimulationHz, v4)
    self._packetCadencePhase = 0
    self._packetCadenceDue = false
end

function u30.reconfigure(a1, a2) -- Line: 83 -- upvalues: Mapping (val)
    local v1, v2 = Mapping.validate(a2)
    assert(v1, v2 or "invalid command mapping")
    assert(a2.Generation == a1._mapping.Generation, "cannot reconfigure a different command generation")
    assert(a2.SimulationHz == a1._mapping.SimulationHz, "cannot reconfigure the command simulation rate")
    a1._mapping = Mapping.clone(a2)
end

function u30.lastSampledCommandNumber(a1) -- Line: 91
    return a1._lastSampledCommandNumber
end

function u30:pendingNewCommandCount() -- Line: 95 -- upvalues: Serial (val)
    local _lastSampledCommandNumber = self._lastSampledCommandNumber
    if _lastSampledCommandNumber == nil then
        return 0
    end
    return (math.max(Serial.deltaUInt32(_lastSampledCommandNumber, self._lastPacketedCommandNumber), 0))
end

function u30.hasPacketDue(a1, a2) -- Line: 103 -- types: a1: table, a2: boolean?
    if 0 < (a1:pendingNewCommandCount()) then
        local _packetCadenceDue = true
        if a2 ~= true then
            _packetCadenceDue = a1._packetCadenceDue
        end
        return _packetCadenceDue
    end
    local v1 = false
    if a2 == true then
        v1 = a1._lastSampledCommandNumber ~= nil
    end
    return v1
end

function u30:getCommand(a2) -- Line: 111 -- upvalues: Serial (val) -- types: self: table, a2: number
    if not Serial.isUInt32(a2) then
        return nil
    end
    local _slots = self._slots
    local _lastSampledCommandNumber = self._lastSampledCommandNumber
    local v1 = _slots[if _lastSampledCommandNumber ~= nil then (self._lastSampledSlotIndex - 1 + Serial.deltaUInt32(a2, _lastSampledCommandNumber)) % self._capacity + 1 else 1]
    if v1 ~= nil and v1.CommandNumber == a2 then
        return v1
    end
    return nil
end

function u30.sample(a1, a2) -- Line: 123 -- upvalues: Serial (val), CommandCodec (val) -- types: a1: table, a2: table
    local v1
    local v2, v3 = CommandCodec.canonicalizeCommand(
        if a1._lastSampledCommandNumber ~= nil then Serial.addUInt32(a1._lastSampledCommandNumber, 1) else 0,
        a2
    )
    if v2 == nil then
        return nil, v3
    end
    v2.PredictedBaseMoveSpeed = a2.PredictedBaseMoveSpeed
    v2.PredictedWeaponMoveSpeed = a2.PredictedWeaponMoveSpeed
    v2.PredictedWeaponScopedMoveSpeed = a2.PredictedWeaponScopedMoveSpeed
    v2 = table.freeze(v2)
    if a1._capacity < (Serial.deltaUInt32(v1, a1._lastPacketedCommandNumber)) then
        return nil, "UnsentHistoryOverflow"
    end
    local _lastSampledCommandNumber = a1._lastSampledCommandNumber
    local v4 = if _lastSampledCommandNumber ~= nil then (a1._lastSampledSlotIndex - 1 + Serial.deltaUInt32(v1, _lastSampledCommandNumber)) % a1._capacity + 1 else 1
    a1._slots[v4] = v2
    a1._lastSampledCommandNumber = v1
    a1._lastSampledSlotIndex = v4
    a1._packetCadencePhase = a1._packetCadencePhase + a1._packetCadenceRateHz
    if a1._config.SimulationHz <= a1._packetCadencePhase then
        a1._packetCadencePhase = a1._packetCadencePhase - a1._config.SimulationHz
        a1._packetCadenceDue = true
    end
    if v2.WeaponSelectRequestId ~= nil then
        a1._packetCadenceDue = true
    end
    return v2, nil
end

function u30.takePacket(a1, a2, a3) -- Line: 159
    -- upvalues: Serial (val), CommandCodec (val)
    local v1 = a1:pendingNewCommandCount()
    local v2 = false
    if v1 == 0 then
        v2 = false
        if a2 == true then
            v2 = a1._lastSampledCommandNumber ~= nil
        end
    end
    if v1 == 0 and not v2 then
        return nil, nil
    end
    if not a2 and not a1._packetCadenceDue then
        return nil, nil
    end
    local MaxNewCommandsPerPacket = a3 or a1._config.MaxNewCommandsPerPacket
    if type(MaxNewCommandsPerPacket) == "number"
        and MaxNewCommandsPerPacket % 1 == 0
        and not (MaxNewCommandsPerPacket < 1)
        and not (a1._config.MaxNewCommandsPerPacket < MaxNewCommandsPerPacket) then
        local v3, v4, v5
        local v6 = if not v2 then Serial.addUInt32(a1._lastPacketedCommandNumber, 1) else assert(a1._lastSampledCommandNumber)
        local TargetRedundantCommandCount = a1._config.TargetRedundantCommandCount
        while TargetRedundantCommandCount > 0 do
            if a1:getCommand((Serial.addUInt32(v6, -TargetRedundantCommandCount))) ~= nil then
                break
            end
            TargetRedundantCommandCount = TargetRedundantCommandCount - 1
        end
        local v7 = table.create(TargetRedundantCommandCount + (if not v2 then math.min(v1, MaxNewCommandsPerPacket) else 1))
        local v8 = -TargetRedundantCommandCount
        local v9 = v5 - 1
        for i = v8, v9 do
            v4 = a1:getCommand((Serial.addUInt32(v6, i)))
            if v4 == nil then
                return nil, "CommandHistoryGap"
            end
            table.insert(v7, v4)
        end
        v9, v3 = CommandCodec.makePacket(a1._mapping.Generation, v7, v5, a1._config)
        if v9 == nil then
            return nil, v3
        end
        if not v2 then
            a1._lastPacketedCommandNumber = Serial.addUInt32(v6, v5 - 1)
        end
        if a1:pendingNewCommandCount() == 0 then
            a1._packetCadenceDue = false
        end
        return v9, nil
    end
    return nil, "InvalidMaximumNewCommands"
end

function u30.buildRecoveryPacketsAfter(a1, a2, a3) -- Line: 217
    -- upvalues: Serial (val), CommandCodec (val)
    local _lastSampledCommandNumber, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
    if not Serial.isUInt32(a2) then
        return nil, "InvalidAcknowledgedCommand"
    end
    if a3 == nil then
        _lastSampledCommandNumber = a1._lastSampledCommandNumber
        if _lastSampledCommandNumber == nil then
            return (table.freeze({})), nil
        end
        v9 = Serial.deltaUInt32(_lastSampledCommandNumber, a2)
        if v9 <= 0 then
            return (table.freeze({})), nil
        end
        if a1._capacity < v9 then
            return nil, "CommandHistoryGap"
        end
        v10 = math.max(1, a1._config.TargetRedundantCommandCount)
        v11 = a3 or math.ceil(v9 / v10)
        v12 = table.create((math.min(v11, (math.ceil(v9 / v10)))))
        v13 = Serial.addUInt32(a2, 1)
        v14 = 0
        v1 = a1
        while v14 < v9 do
            if not (#v12 < v11) then
                break
            end
            v2 = math.min(v10, v9 - v14)
            v3 = math.min(v1._config.TargetRedundantCommandCount, v14)
            v4 = Serial.addUInt32(v13, -v3)
            v5 = table.create(v3 + v2)
            v6 = v3 + v2 - 1
            for j = 0, v6 do
                v8 = v1:getCommand((Serial.addUInt32(v4, j)))
                if v8 == nil then
                    return nil, "CommandHistoryGap"
                end
                table.insert(v5, v8)
            end
            v6, v7 = CommandCodec.makePacket(v1._mapping.Generation, v5, v2, v1._config)
            if v6 == nil then
                return nil, v7
            end
            table.insert(v12, v6)
            v14 = v14 + v2
            v13 = Serial.addUInt32(v13, v2)
        end
        return (table.freeze(v12)), nil
    end
    if type(a3) == "number" and a3 % 1 == 0 and not (a3 < 1) and a3 ~= (1 / 0) then
        _lastSampledCommandNumber = a1._lastSampledCommandNumber
        if _lastSampledCommandNumber == nil then
            return (table.freeze({})), nil
        end
        v9 = Serial.deltaUInt32(_lastSampledCommandNumber, a2)
        if v9 <= 0 then
            return (table.freeze({})), nil
        end
        if a1._capacity < v9 then
            return nil, "CommandHistoryGap"
        end
        v10 = math.max(1, a1._config.TargetRedundantCommandCount)
        v11 = a3 or math.ceil(v9 / v10)
        v12 = table.create((math.min(v11, (math.ceil(v9 / v10)))))
        v13 = Serial.addUInt32(a2, 1)
        v14 = 0
        v1 = a1
        while v14 < v9 do
            if not (#v12 < v11) then
                break
            end
            v2 = math.min(v10, v9 - v14)
            v3 = math.min(v1._config.TargetRedundantCommandCount, v14)
            v4 = Serial.addUInt32(v13, -v3)
            v5 = table.create(v3 + v2)
            v6 = v3 + v2 - 1
            for i = 0, v6 do
                v8 = v1:getCommand((Serial.addUInt32(v4, i)))
                if v8 == nil then
                    return nil, "CommandHistoryGap"
                end
                table.insert(v5, v8)
            end
            v6, v7 = CommandCodec.makePacket(v1._mapping.Generation, v5, v2, v1._config)
            if v6 == nil then
                return nil, v7
            end
            table.insert(v12, v6)
            v14 = v14 + v2
            v13 = Serial.addUInt32(v13, v2)
        end
        return (table.freeze(v12)), nil
    end
    return nil, "InvalidMaximumPackets"
end

return table.freeze(u30)