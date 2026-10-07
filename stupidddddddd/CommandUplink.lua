-- ReplicatedStorage.MovementV2.Client.CommandUplink
-- Script path: ReplicatedStorage.MovementV2.Client.CommandUplink
-- Decompile time: 5.39 ms

local CommandCodec = require(script.Parent.Parent.CommandCodec)
local Config = require(script.Parent.Parent.Config)
local Enums = require(script.Parent.Parent.Enums)
local Serial = require(script.Parent.Parent.Serial)
require(script.Parent.Parent.Types)
require(script.Parent.Parent.Transport)
require(script.Parent.CommandStream)
local u41 = {}
u41.__index = u41

local function sendBudget(a1) -- Line: 54 -- upvalues: Config (val)
    local v1 = math.min(a1.SimulationHz, 1 / Config.PolicySeconds.CommandPacketPeriod) * 1.375
    return v1, (math.max(8, v1 * 0.25))
end

function u41.new(a1) -- Line: 62 -- upvalues: u41 (val) -- types: a1: table
    return (setmetatable({
        _tokens = 0,
        _lastRefillAt = 0,
        _lastRecoverySentAt = 0,
        _acknowledgementAdvancedAt = 0,
        _host = a1,
        _counters = {PacketsSent = 0, RecoveryPacketsSent = 0, BudgetDeferrals = 0},
    }, u41))
end

function u41.resetGeneration(a1) -- Line: 74
    a1._tokens = 0
    a1._lastRefillAt = 0
    a1._lastRecoverySentAt = 0
    a1._lastRecoveryAcknowledgedCommand = nil
    a1._observedAcknowledgedCommand = nil
    a1._acknowledgementAdvancedAt = 0
end

function u41.resetCounters(a1) -- Line: 83
    local _counters = a1._counters
    _counters.PacketsSent = 0
    _counters.RecoveryPacketsSent = 0
    _counters.BudgetDeferrals = 0
end

function u41.fillBudget(a1, a2) -- Line: 91 -- upvalues: Config (val)
    if a2 == nil then
        a1._tokens = 0
        a1._lastRefillAt = 0
        return
    end
    a1._tokens = math.max(8, math.min(a2.SimulationHz, 1 / Config.PolicySeconds.CommandPacketPeriod) * 1.375 * 0.25)
    a1._lastRefillAt = os.clock()
end

function u41.counters(a1) -- Line: 102
    return a1._counters
end

function u41.lastRecoveryAcknowledgedCommand(a1) -- Line: 106
    return a1._lastRecoveryAcknowledgedCommand
end

function u41.onOwnerApplied(a1, a2) -- Line: 111 -- upvalues: Serial (val) -- types: a1: table, a2: number
    local _lastRecoveryAcknowledgedCommand = a1._lastRecoveryAcknowledgedCommand
    if _lastRecoveryAcknowledgedCommand ~= nil and 0 < (Serial.deltaUInt32(a2, _lastRecoveryAcknowledgedCommand)) then
        a1._lastRecoveryAcknowledgedCommand = nil
    end
end

function u41:_refill(a2, a3) -- Line: 118 -- upvalues: Config (val) -- types: self: table, a3: number?
    local v1 = math.min(a2.SimulationHz, 1 / Config.PolicySeconds.CommandPacketPeriod) * 1.375
    local v2 = v1
    local v3 = math.max(8, v1 * 0.25)
    local v4 = a3 or os.clock()
    local _lastRefillAt = self._lastRefillAt
    if _lastRefillAt <= 0 then
        self._tokens = v3
        self._lastRefillAt = v4
        return self._tokens, v2, v3
    end
    v1 = v4 - _lastRefillAt
    if v1 > 0 then
        self._tokens = math.min(v3, self._tokens + v1 * v2)
        self._lastRefillAt = v4
    elseif v1 < 0 then
        self._lastRefillAt = v4
    end
    return self._tokens, v2, v3
end

function u41.peekBudget(a1, a2, a3) -- Line: 139 -- upvalues: Config (val) -- types: a1: table, a3: number
    if a2 == nil then
        return 0, 0, 0
    end
    local v1 = math.min(a2.SimulationHz, 1 / Config.PolicySeconds.CommandPacketPeriod) * 1.375
    local v2 = v1
    local v3 = math.max(8, v1 * 0.25)
    if a1._lastRefillAt <= 0 then
        return v3, v2, v3
    end
    return (math.min(v3, a1._tokens + (math.max(a3 - a1._lastRefillAt, 0)) * v2)), v2, v3
end

function u41:_tryConsumeToken(a2) -- Line: 151
    local v1 = self:_refill(a2)
    if v1 < 1 then
        return false
    end
    self._tokens = v1 - 1
    return true
end

function u41:_refundToken(a2) -- Line: 160
    local v1
    _, _, v1 = self:_refill(a2)
    self._tokens = math.min(v1, self._tokens + 1)
end

function u41.sendDue(a1, a2, a3, a4, a5) -- Line: 165 -- upvalues: CommandCodec (val) -- types: a1: table, a5: boolean?
    if a2 ~= nil and a3 ~= nil and a4 ~= nil then
        local v1, v2, v3, v4, v5, v6
        if not a2:hasPacketDue(a5) then
            return
        end
        local _counters = a1._counters
        local v7 = math.max(1, a3.TargetRedundantCommandCount)
        local v8 = a2:pendingNewCommandCount()
        local v9 = false
        if a5 == true then
            v9 = v8 == 0
        end
        for i = 1, math.ceil((math.max(v8, 1)) / v7) + 1 do
            if not a2:hasPacketDue(a5) then
                return
            end
            if not a1:_tryConsumeToken(a3) then
                _counters.BudgetDeferrals = _counters.BudgetDeferrals + 1
                return
            end
            v1 = a2:pendingNewCommandCount()
            v2, v3 = a2:takePacket(a5, v7)
            if v2 == nil then
                a1:_refundToken(a3)
                if v3 ~= nil then
                    a1._host.Warn((("could not form command packet: %*"):format(v3)))
                end
                return
            end
            v4, v5 = CommandCodec.encode(v2, a3)
            if v4 == nil then
                a1:_refundToken(a3)
                a1._host.Warn((("could not encode command packet: %*"):format(v5)))
                return
            end
            a4.Commands:FireServer(v4)
            _counters.PacketsSent = _counters.PacketsSent + 1
            a1._host.OnPacketSent(buffer.len(v4), false)
            v6 = a2:pendingNewCommandCount()
            if not v9 and v6 ~= 0 then
                if not (v1 <= v6) then
                    continue
                end
                a1._host.Warn("command packet drain made no forward progress")
                return
            end
            return
        end
        a1._host.Warn("command packet drain exceeded its monotonic bound")
        return
    end
end

function u41:sendRecovery(a2, a3, a4, a5, a6) -- Line: 221
    -- upvalues: Serial (val), CommandCodec (val)
    if a2 ~= nil and a3 ~= nil and a4 ~= nil then
        local v1 = a2:lastSampledCommandNumber()
        if v1 ~= nil then
            local v2 = Serial.deltaUInt32(v1, a5)
            if not (v2 <= 0) then
                local v3, v4
                v2 = Serial.deltaUInt32(v1, a5)
                if math.max(a3.CommandHistoryTicks, a3.MaxCommandsPerPacket) < v2 then
                    return
                end
                local _counters = self._counters
                local v5 = math.floor((self:_refill(a3)))
                if v5 < 1 then
                    _counters.BudgetDeferrals = _counters.BudgetDeferrals + 1
                    return
                end
                local v6, v7 = a2:buildRecoveryPacketsAfter(a5, (math.min(a6 or 5, v5)))
                if v6 == nil then
                    self._host.Warn((("could not form command recovery: %*"):format(v7 or "Unknown")))
                    return
                end
                local v8 = #v6
                for i = 1, v8 do
                    if not self:_tryConsumeToken(a3) then
                        _counters.BudgetDeferrals = _counters.BudgetDeferrals + 1
                        return
                    end
                    v3, v4 = CommandCodec.encode(v6[i], a3)
                    if v3 == nil then
                        self:_refundToken(a3)
                        self._host.Warn((("could not encode command recovery: %*"):format(v4 or "Unknown")))
                        return
                    end
                    a4.Commands:FireServer(v3)
                    _counters.PacketsSent = _counters.PacketsSent + 1
                    _counters.RecoveryPacketsSent = _counters.RecoveryPacketsSent + 1
                    self._host.OnPacketSent(buffer.len(v3), true)
                end
                return
            end
        end
        return
    end
end

function u41.recoverStalled(a1, a2, a3, a4, a5, a6, a7) -- Line: 277
    -- upvalues: Serial (val), Enums (val)
    if a2 ~= nil and a4 ~= nil and a3 ~= nil then
        local v1
        local v2 = os.clock()
        local LastProcessedCommand = a2.LastProcessedCommand
        if a1._observedAcknowledgedCommand ~= LastProcessedCommand then
            a1._observedAcknowledgedCommand = LastProcessedCommand
            a1._acknowledgementAdvancedAt = v2
        end
        local v3 = a3:lastSampledCommandNumber()
        if v3 == nil then
            return
        end
        if (Serial.deltaUInt32(v3, LastProcessedCommand)) <= a4.TargetRedundantCommandCount then
            return
        end
        local v4 = false
        if bit32.band(a2.Flags, Enums.OwnerSnapshotFlags.Stalled) ~= 0 then
            v1 = v2 - a1._acknowledgementAdvancedAt
            v4 = a4.TargetRedundantCommandCount * a4.StepSeconds <= v1
        end
        v1 = false
        if a6 > 0 then
            v1 = 0.2 <= v2 - a6
        end
        local v5 = false
        if LastProcessedCommand == Serial.UInt32Max then
            v5 = a3:getCommand(0) ~= nil
        end
        if not v4 and not v1 and not v5 then
            return
        end
        if v2 - a1._lastRecoverySentAt < 0.25 or a7 then
            return
        end
        local RecoveryPacketsSent = a1._counters.RecoveryPacketsSent
        a1:sendRecovery(a3, a4, a5, LastProcessedCommand, if v4 then 5 else if not v1 then 1 else 5)
        if RecoveryPacketsSent < a1._counters.RecoveryPacketsSent then
            a1._lastRecoverySentAt = v2
            a1._lastRecoveryAcknowledgedCommand = LastProcessedCommand
        end
        return
    end
end

return table.freeze(u41)