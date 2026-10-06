-- Decompiled with Potassium's decompiler.

local CommandCodec = require(script.Parent.Parent.CommandCodec);
local Config = require(script.Parent.Parent.Config);
local Enums = require(script.Parent.Parent.Enums);
local Serial = require(script.Parent.Parent.Serial);
require(script.Parent.Parent.Types);
require(script.Parent.Parent.Transport);
require(script.Parent.CommandStream);
local u1 = {};
u1.__index = u1;

local function sendBudget(p2) -- Line: 54
    -- upvalues: Config (copy)
    local v3 = math.min(p2.SimulationHz, 1 / Config.PolicySeconds.CommandPacketPeriod) * 1.375;

    return v3, math.max(8, v3 * 0.25);
end;

function u1.new(p4: table) -- Line: 62
    -- upvalues: u1 (copy)
    return setmetatable({
        _tokens = 0,
        _lastRefillAt = 0,
        _lastRecoverySentAt = 0,
        _acknowledgementAdvancedAt = 0,
        _host = p4,
        _counters = {
            PacketsSent = 0,
            RecoveryPacketsSent = 0,
            BudgetDeferrals = 0
        }
    }, u1);
end;

function u1.resetGeneration(p5) -- Line: 74
    p5._tokens = 0;
    p5._lastRefillAt = 0;
    p5._lastRecoverySentAt = 0;
    p5._lastRecoveryAcknowledgedCommand = nil;
    p5._observedAcknowledgedCommand = nil;
    p5._acknowledgementAdvancedAt = 0;
end;

function u1.resetCounters(p6) -- Line: 83
    local _counters = p6._counters;
    _counters.PacketsSent = 0;
    _counters.RecoveryPacketsSent = 0;
    _counters.BudgetDeferrals = 0;
end;

function u1.fillBudget(p7, p8) -- Line: 91
    -- upvalues: Config (copy)
    if p8 == nil then
        p7._tokens = 0;
        p7._lastRefillAt = 0;

        return;
    end;

    local v9 = math.min(p8.SimulationHz, 1 / Config.PolicySeconds.CommandPacketPeriod) * 1.375 * 0.25;
    p7._tokens = math.max(8, v9);
    p7._lastRefillAt = os.clock();
end;

function u1.counters(p10) -- Line: 102
    return p10._counters;
end;

function u1.lastRecoveryAcknowledgedCommand(p11) -- Line: 106
    return p11._lastRecoveryAcknowledgedCommand;
end;

function u1.onOwnerApplied(p12: table, p13: number) -- Line: 111
    -- upvalues: Serial (copy)
    local _lastRecoveryAcknowledgedCommand = p12._lastRecoveryAcknowledgedCommand;

    if _lastRecoveryAcknowledgedCommand ~= nil and Serial.deltaUInt32(p13, _lastRecoveryAcknowledgedCommand) > 0 then
        p12._lastRecoveryAcknowledgedCommand = nil;
    end;
end;

function u1._refill(p14: table, p15: any, p16: number?) -- Line: 118
    -- upvalues: Config (copy)
    local v17 = math.min(p15.SimulationHz, 1 / Config.PolicySeconds.CommandPacketPeriod) * 1.375;
    local math_max_ret = math.max(8, v17 * 0.25);
    local v18 = p16 or os.clock();
    local _lastRefillAt = p14._lastRefillAt;

    if _lastRefillAt <= 0 then
        p14._tokens = math_max_ret;
        p14._lastRefillAt = v18;

        return p14._tokens, v17, math_max_ret;
    end;

    local v19 = v18 - _lastRefillAt;

    if v19 > 0 then
        p14._tokens = math.min(math_max_ret, p14._tokens + v19 * v17);
        p14._lastRefillAt = v18;
    elseif v19 < 0 then
        p14._lastRefillAt = v18;
    end;

    return p14._tokens, v17, math_max_ret;
end;

function u1.peekBudget(p20: table, p21: any, p22: number) -- Line: 139
    -- upvalues: Config (copy)
    if p21 == nil then
        return 0, 0, 0;
    end;

    local v23 = math.min(p21.SimulationHz, 1 / Config.PolicySeconds.CommandPacketPeriod) * 1.375;
    local math_max_ret = math.max(8, v23 * 0.25);

    if p20._lastRefillAt <= 0 then
        return math_max_ret, v23, math_max_ret;
    end;

    local math_max_ret2 = math.max(p22 - p20._lastRefillAt, 0);

    return math.min(math_max_ret, p20._tokens + math_max_ret2 * v23), v23, math_max_ret;
end;

function u1._tryConsumeToken(p24, p25) -- Line: 151
    local v26 = p24:_refill(p25);

    if v26 < 1 then
        return false;
    end;

    p24._tokens = v26 - 1;

    return true;
end;

function u1._refundToken(p27, p28) -- Line: 160
    local _, _, v29 = p27:_refill(p28);
    p27._tokens = math.min(v29, p27._tokens + 1);
end;

function u1.sendDue(p30: table, p31: any, p32: any, p33: any, p34: boolean?) -- Line: 165
    -- upvalues: CommandCodec (copy)
    if p31 == nil or (p32 == nil or p33 == nil) then
        return;
    end;

    if not p31:hasPacketDue(p34) then
        return;
    end;

    local _counters = p30._counters;
    local math_max_ret = math.max(1, p32.TargetRedundantCommandCount);
    local v35 = p31:pendingNewCommandCount();
    local v36;

    if p34 == true then
        v36 = v35 == 0;
    else
        v36 = false;
    end;

    local v37 = math.max(v35, 1) / math_max_ret;

    for i = 1, math.ceil(v37) + 1 do
        if not p31:hasPacketDue(p34) then
            return;
        end;

        if not p30:_tryConsumeToken(p32) then
            _counters.BudgetDeferrals = _counters.BudgetDeferrals + 1;

            return;
        end;

        local v38 = p31:pendingNewCommandCount();
        local v39, v40 = p31:takePacket(p34, math_max_ret);

        if v39 == nil then
            p30:_refundToken(p32);

            if v40 ~= nil then
                p30._host.Warn((`could not form command packet: {v40}`));
            end;

            return;
        end;

        local v41, v42 = CommandCodec.encode(v39, p32);

        if v41 == nil then
            p30:_refundToken(p32);
            p30._host.Warn((`could not encode command packet: {v42}`));

            return;
        end;

        p33.Commands:FireServer(v41);
        _counters.PacketsSent = _counters.PacketsSent + 1;
        p30._host.OnPacketSent(buffer.len(v41), false);
        local v43 = p31:pendingNewCommandCount();

        if v36 or v43 == 0 then
            return;
        end;

        if v38 <= v43 then
            p30._host.Warn("command packet drain made no forward progress");

            return;
        end;

        local _ = i;
    end;

    p30._host.Warn("command packet drain exceeded its monotonic bound");
end;

function u1.sendRecovery(p44: table, p45: any, p46: any, p47: any, p48: number, p49: number?) -- Line: 221
    -- upvalues: Serial (copy), CommandCodec (copy)
    if p45 == nil or (p46 == nil or p47 == nil) then
        return;
    end;

    local v50 = p45:lastSampledCommandNumber();

    if v50 == nil or Serial.deltaUInt32(v50, p48) <= 0 then
        return;
    end;

    if Serial.deltaUInt32(v50, p48) > math.max(p46.CommandHistoryTicks, p46.MaxCommandsPerPacket) then
        return;
    end;

    local _counters = p44._counters;
    local v51 = p44:_refill(p46);
    local math_floor_ret = math.floor(v51);

    if math_floor_ret < 1 then
        _counters.BudgetDeferrals = _counters.BudgetDeferrals + 1;

        return;
    end;

    local v52, v53 = p45:buildRecoveryPacketsAfter(p48, (math.min(p49 or 5, math_floor_ret)));

    if v52 == nil then
        p44._host.Warn((`could not form command recovery: {v53 or "Unknown"}`));

        return;
    end;

    for i = 1, #v52 do
        if not p44:_tryConsumeToken(p46) then
            _counters.BudgetDeferrals = _counters.BudgetDeferrals + 1;

            return;
        end;

        local v54, v55 = CommandCodec.encode(v52[i], p46);

        if v54 == nil then
            p44:_refundToken(p46);
            p44._host.Warn((`could not encode command recovery: {v55 or "Unknown"}`));

            return;
        end;

        p47.Commands:FireServer(v54);
        _counters.PacketsSent = _counters.PacketsSent + 1;
        _counters.RecoveryPacketsSent = _counters.RecoveryPacketsSent + 1;
        p44._host.OnPacketSent(buffer.len(v54), true);
        local _ = i;
    end;
end;

function u1.recoverStalled(p56: table, p57: any, p58: any, p59: any, p60: any, p61: number, p62: boolean) -- Line: 277
    -- upvalues: Serial (copy), Enums (copy)
    if p57 == nil or (p59 == nil or p58 == nil) then
        return;
    end;

    local os_clock_ret = os.clock();
    local LastProcessedCommand = p57.LastProcessedCommand;

    if p56._observedAcknowledgedCommand ~= LastProcessedCommand then
        p56._observedAcknowledgedCommand = LastProcessedCommand;
        p56._acknowledgementAdvancedAt = os_clock_ret;
    end;

    local v63 = p58:lastSampledCommandNumber();

    if v63 == nil then
        return;
    end;

    if Serial.deltaUInt32(v63, LastProcessedCommand) <= p59.TargetRedundantCommandCount then
        return;
    end;

    local v64;

    if bit32.band(p57.Flags, Enums.OwnerSnapshotFlags.Stalled) == 0 then
        v64 = false;
    else
        v64 = os_clock_ret - p56._acknowledgementAdvancedAt >= p59.TargetRedundantCommandCount * p59.StepSeconds;
    end;

    local v65;

    if p61 > 0 then
        v65 = os_clock_ret - p61 >= 0.2;
    else
        v65 = false;
    end;

    local v66;

    if LastProcessedCommand == Serial.UInt32Max then
        v66 = p58:getCommand(0) ~= nil;
    else
        v66 = false;
    end;

    if not (v64 or (v65 or v66)) then
        return;
    end;

    if os_clock_ret - p56._lastRecoverySentAt < 0.25 then
        return;
    end;

    if p62 then
        return;
    end;

    local RecoveryPacketsSent = p56._counters.RecoveryPacketsSent;
    p56:sendRecovery(p58, p59, p60, LastProcessedCommand, (v64 or v65) and 5 or 1);

    if RecoveryPacketsSent < p56._counters.RecoveryPacketsSent then
        p56._lastRecoverySentAt = os_clock_ret;
        p56._lastRecoveryAcknowledgedCommand = LastProcessedCommand;
    end;
end;

return table.freeze(u1);