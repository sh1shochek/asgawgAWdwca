-- Decompiled with Potassium's decompiler.

local CommandCodec = require(script.Parent.Parent.CommandCodec);
local Config = require(script.Parent.Parent.Config);
local Mapping = require(script.Parent.Parent.Mapping);
local Serial = require(script.Parent.Parent.Serial);
require(script.Parent.Parent.Types);
local u1 = {};
u1.__index = u1;

local function slotIndex(p2: any, p3: number) -- Line: 46
    -- upvalues: Serial (copy)
    local _lastSampledCommandNumber = p2._lastSampledCommandNumber;

    return _lastSampledCommandNumber == nil and 1 or (p2._lastSampledSlotIndex - 1 + Serial.deltaUInt32(p3, _lastSampledCommandNumber)) % p2._capacity + 1;
end;

local function packetCadenceRate(p4: number) -- Line: 54
    -- upvalues: Config (copy)
    local v5 = 1 / Config.PolicySeconds.CommandPacketPeriod;
    local v6;

    if v5 % 1 == 0 then
        v6 = v5 > 0;
    else
        v6 = false;
    end;

    assert(v6, "command packet period must resolve to an integer rate");

    return math.min(p4, v5);
end;

function u1.new(p7) -- Line: 60
    -- upvalues: u1 (copy)
    local v8 = setmetatable({
        _slots = {}
    }, u1);
    v8:reset(p7);

    return v8;
end;

function u1.reset(p9, p10) -- Line: 66
    -- upvalues: Mapping (copy), Config (copy), Serial (copy)
    local v11, v12 = Mapping.validate(p10);
    assert(v11, v12 or "invalid command mapping");
    local v13 = Config.derive(p10.SimulationHz);
    p9._mapping = Mapping.clone(p10);
    p9._config = v13;
    p9._capacity = math.max(v13.CommandHistoryTicks, v13.MaxCommandsPerPacket);
    table.clear(p9._slots);
    p9._lastSampledCommandNumber = nil;
    p9._lastSampledSlotIndex = 1;
    p9._lastPacketedCommandNumber = Serial.UInt32Max;
    local SimulationHz = v13.SimulationHz;
    local v14 = 1 / Config.PolicySeconds.CommandPacketPeriod;
    local v15;

    if v14 % 1 == 0 then
        v15 = v14 > 0;
    else
        v15 = false;
    end;

    assert(v15, "command packet period must resolve to an integer rate");
    p9._packetCadenceRateHz = math.min(SimulationHz, v14);
    p9._packetCadencePhase = 0;
    p9._packetCadenceDue = false;
end;

function u1.reconfigure(p16, p17) -- Line: 83
    -- upvalues: Mapping (copy)
    local v18, v19 = Mapping.validate(p17);
    assert(v18, v19 or "invalid command mapping");
    assert(p17.Generation == p16._mapping.Generation, "cannot reconfigure a different command generation");
    assert(p17.SimulationHz == p16._mapping.SimulationHz, "cannot reconfigure the command simulation rate");
    p16._mapping = Mapping.clone(p17);
end;

function u1.lastSampledCommandNumber(p20) -- Line: 91
    return p20._lastSampledCommandNumber;
end;

function u1.pendingNewCommandCount(p21) -- Line: 95
    -- upvalues: Serial (copy)
    local _lastSampledCommandNumber = p21._lastSampledCommandNumber;

    if _lastSampledCommandNumber == nil then
        return 0;
    end;

    local v22 = Serial.deltaUInt32(_lastSampledCommandNumber, p21._lastPacketedCommandNumber);

    return math.max(v22, 0);
end;

function u1.hasPacketDue(p23: table, p24: boolean?) -- Line: 103
    if p23:pendingNewCommandCount() > 0 then
        return p24 == true and true or p23._packetCadenceDue;
    end;

    local v25;

    if p24 == true then
        v25 = p23._lastSampledCommandNumber ~= nil;
    else
        v25 = false;
    end;

    return v25;
end;

function u1.getCommand(p26: table, p27: number) -- Line: 111
    -- upvalues: Serial (copy)
    if not Serial.isUInt32(p27) then
        return nil;
    end;

    local _lastSampledCommandNumber = p26._lastSampledCommandNumber;
    local v28 = p26._slots[_lastSampledCommandNumber == nil and 1 or (p26._lastSampledSlotIndex - 1 + Serial.deltaUInt32(p27, _lastSampledCommandNumber)) % p26._capacity + 1];

    if v28 == nil or v28.CommandNumber ~= p27 then
        return nil;
    end;

    return v28;
end;

function u1.sample(p29: table, p30: table) -- Line: 123
    -- upvalues: Serial (copy), CommandCodec (copy)
    local v31 = p29._lastSampledCommandNumber == nil and 0 or Serial.addUInt32(p29._lastSampledCommandNumber, 1);
    local v32, v33 = CommandCodec.canonicalizeCommand(v31, p30);

    if v32 == nil then
        return nil, v33;
    end;

    v32.PredictedBaseMoveSpeed = p30.PredictedBaseMoveSpeed;
    v32.PredictedWeaponMoveSpeed = p30.PredictedWeaponMoveSpeed;
    v32.PredictedWeaponScopedMoveSpeed = p30.PredictedWeaponScopedMoveSpeed;
    local table_freeze_ret = table.freeze(v32);

    if Serial.deltaUInt32(v31, p29._lastPacketedCommandNumber) > p29._capacity then
        return nil, "UnsentHistoryOverflow";
    end;

    local _lastSampledCommandNumber = p29._lastSampledCommandNumber;
    local v34 = _lastSampledCommandNumber == nil and 1 or (p29._lastSampledSlotIndex - 1 + Serial.deltaUInt32(v31, _lastSampledCommandNumber)) % p29._capacity + 1;
    p29._slots[v34] = table_freeze_ret;
    p29._lastSampledCommandNumber = v31;
    p29._lastSampledSlotIndex = v34;
    p29._packetCadencePhase = p29._packetCadencePhase + p29._packetCadenceRateHz;

    if p29._packetCadencePhase >= p29._config.SimulationHz then
        p29._packetCadencePhase = p29._packetCadencePhase - p29._config.SimulationHz;
        p29._packetCadenceDue = true;
    end;

    if table_freeze_ret.WeaponSelectRequestId ~= nil then
        p29._packetCadenceDue = true;
    end;

    return table_freeze_ret, nil;
end;

function u1.takePacket(p35: table, p36: boolean?, p37: number?) -- Line: 159
    -- upvalues: Serial (copy), CommandCodec (copy)
    local v38 = p35:pendingNewCommandCount();
    local v39;

    if v38 == 0 and p36 == true then
        v39 = p35._lastSampledCommandNumber ~= nil;
    else
        v39 = false;
    end;

    if v38 == 0 and not v39 then
        return nil, nil;
    end;

    if not (p36 or p35._packetCadenceDue) then
        return nil, nil;
    end;

    local v40 = p37 or p35._config.MaxNewCommandsPerPacket;

    if type(v40) ~= "number" or (v40 % 1 ~= 0 or (v40 < 1 or p35._config.MaxNewCommandsPerPacket < v40)) then
        return nil, "InvalidMaximumNewCommands";
    end;

    local v41 = v39 and 1 or math.min(v38, v40);
    local v42;

    if v39 then
        v42 = assert(p35._lastSampledCommandNumber);
    else
        v42 = Serial.addUInt32(p35._lastPacketedCommandNumber, 1);
    end;

    local TargetRedundantCommandCount = p35._config.TargetRedundantCommandCount;

    while TargetRedundantCommandCount > 0 and p35:getCommand((Serial.addUInt32(v42, -TargetRedundantCommandCount))) == nil do
        TargetRedundantCommandCount = TargetRedundantCommandCount - 1;
    end;

    local table_create_ret = table.create(TargetRedundantCommandCount + v41);

    for i = -TargetRedundantCommandCount, v41 - 1 do
        local Command = p35:getCommand((Serial.addUInt32(v42, i)));

        if Command == nil then
            return nil, "CommandHistoryGap";
        end;

        table.insert(table_create_ret, Command);
        local _ = i;
    end;

    local v43, v44 = CommandCodec.makePacket(p35._mapping.Generation, table_create_ret, v41, p35._config);

    if v43 == nil then
        return nil, v44;
    end;

    if not v39 then
        p35._lastPacketedCommandNumber = Serial.addUInt32(v42, v41 - 1);
    end;

    if p35:pendingNewCommandCount() == 0 then
        p35._packetCadenceDue = false;
    end;

    return v43, nil;
end;

function u1.buildRecoveryPacketsAfter(p45: table, p46: number, p47: number?) -- Line: 217
    -- upvalues: Serial (copy), CommandCodec (copy)
    if not Serial.isUInt32(p46) then
        return nil, "InvalidAcknowledgedCommand";
    end;

    if p47 ~= nil and (type(p47) ~= "number" or (p47 % 1 ~= 0 or (p47 < 1 or p47 == (1 / 0)))) then
        return nil, "InvalidMaximumPackets";
    end;

    local _lastSampledCommandNumber = p45._lastSampledCommandNumber;

    if _lastSampledCommandNumber == nil then
        return table.freeze({}), nil;
    end;

    local v48 = Serial.deltaUInt32(_lastSampledCommandNumber, p46);

    if v48 <= 0 then
        return table.freeze({}), nil;
    end;

    if p45._capacity < v48 then
        return nil, "CommandHistoryGap";
    end;

    local math_max_ret = math.max(1, p45._config.TargetRedundantCommandCount);
    local v49 = p47 or math.ceil(v48 / math_max_ret);
    local table_create = table.create;
    local math_ceil_ret = math.ceil(v48 / math_max_ret);
    local v50 = table_create((math.min(v49, math_ceil_ret)));
    local v51 = Serial.addUInt32(p46, 1);
    local v52 = 0;

    while v52 < v48 and #v50 < v49 do
        local math_min_ret = math.min(math_max_ret, v48 - v52);
        local math_min_ret2 = math.min(p45._config.TargetRedundantCommandCount, v52);
        local v53 = Serial.addUInt32(v51, -math_min_ret2);
        local table_create_ret = table.create(math_min_ret2 + math_min_ret);

        for i = 0, math_min_ret2 + math_min_ret - 1 do
            local Command = p45:getCommand((Serial.addUInt32(v53, i)));

            if Command == nil then
                return nil, "CommandHistoryGap";
            end;

            table.insert(table_create_ret, Command);
            local _ = i;
        end;

        local v54, v55 = CommandCodec.makePacket(p45._mapping.Generation, table_create_ret, math_min_ret, p45._config);

        if v54 == nil then
            return nil, v55;
        end;

        table.insert(v50, v54);
        v52 = v52 + math_min_ret;
        v51 = Serial.addUInt32(v51, math_min_ret);
    end;

    return table.freeze(v50), nil;
end;

return table.freeze(u1);