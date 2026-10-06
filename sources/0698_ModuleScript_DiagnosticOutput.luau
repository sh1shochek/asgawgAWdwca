-- Decompiled with Potassium's decompiler.

local DiagnosticProtocol = require(script.Parent.Parent.DiagnosticProtocol);
local u1 = {};
u1.__index = u1;

local function splitLine(u2: string) -- Line: 30
    if u2 == "" then
        return { "" };
    end;

    local u3 = {};
    local u4 = 1;

    if pcall(function() -- Line: 38
        -- upvalues: u2 (copy), u4 (ref), u3 (copy)
        for i in utf8.codes(u2) do
            if i - u4 >= 512 then
                u3[#u3 + 1] = string.sub(u2, u4, i - 1);
                u4 = i;
            end;
        end;
    end) then
        u3[#u3 + 1] = string.sub(u2, u4);

        return u3;
    end;

    table.clear(u3);

    for i = 1, #u2, 512 do
        u3[#u3 + 1] = string.sub(u2, i, i + 512 - 1);
        local _ = i;
    end;

    return u3;
end;

local function appendDetailRecords(p5: table, p6: string, p7: string, p8: string) -- Line: 59
    -- upvalues: splitLine (copy)
    local string_split_ret = string.split(p8, "\n");
    local v9 = #string_split_ret;

    for i, v in string_split_ret do
        local v10;

        if string.sub(v, -1) == "\r" then
            v10 = string.sub(v, 1, -2);
        else
            v10 = v;
        end;

        local v11 = splitLine(v10);
        local v12 = #v11;
        local v13 = i;

        for i2, v2 in v11 do
            p5[#p5 + 1] = string.format("[MovementV2.DiagnosticDetail] incident=%s section=%s line=%d/%d part=%d/%d data=%s", p6, p7, v13, v9, i2, v12, v2);
        end;
    end;
end;

local function advanceQueueHead(p14: table, p15: number, p16: number) -- Line: 85
    local v17 = p15 + 1;

    if #p14 < v17 then
        table.clear(p14);

        return p14, 1;
    end;

    if p16 > v17 then
        return p14, v17;
    end;

    local v18 = {};

    for i = v17, #p14 do
        v18[#v18 + 1] = p14[i];
        local _ = i;
    end;

    return v18, 1;
end;

function u1.new() -- Line: 100
    -- upvalues: u1 (copy)
    return setmetatable({
        _deliveryHead = 1,
        _deliveriesDropped = 0,
        _recordHead = 1,
        _nextOutputAt = 0,
        _deliveries = {},
        _records = {}
    }, u1);
end;

function u1.clear(p19) -- Line: 111
    table.clear(p19._deliveries);
    p19._deliveryHead = 1;
    p19._deliveriesDropped = 0;
    table.clear(p19._records);
    p19._recordHead = 1;
    p19._nextOutputAt = 0;
end;

function u1.queue(p20, p21) -- Line: 120
    local _deliveries = p20._deliveries;

    if #_deliveries - p20._deliveryHead + 1 >= 128 then
        p20._deliveriesDropped = p20._deliveriesDropped + 1;

        return;
    end;

    _deliveries[#_deliveries + 1] = p21;
end;

function u1._stage(p22, p23) -- Line: 130
    -- upvalues: appendDetailRecords (copy)
    local v24 = {};
    appendDetailRecords(v24, p23.CorrelationId, "CLIENT", p23.ClientLog);
    appendDetailRecords(v24, p23.CorrelationId, "SERVER", p23.ServerLog);
    local _records = p22._records;
    local v25 = 2048 - math.max(#_records - p22._recordHead + 1, 0);
    local math_max_ret = math.max(v25 - 1, 0);
    local math_min_ret = math.min(#v24, math_max_ret);

    if v25 > 0 then
        _records[#_records + 1] = string.format("[MovementV2.Diagnostic] incident=%s kind=%s reporter=%s display=%s userId=%d receivedServerTime=%.6f detailRecords=%d queued=%d dropped=%d deliveryQueueDropped=%d", p23.CorrelationId, p23.Kind, p23.ReporterName, p23.ReporterDisplayName, p23.ReporterUserId, p23.ReceivedServerTime, #v24, math_min_ret, #v24 - math_min_ret, p22._deliveriesDropped);
        p22._deliveriesDropped = 0;
    end;

    for i = 1, math_min_ret do
        _records[#_records + 1] = v24[i];
        local _ = i;
    end;
end;

function u1.drain(p26) -- Line: 162
    -- upvalues: advanceQueueHead (copy), DiagnosticProtocol (copy)
    if #p26._records - p26._recordHead + 1 < 1536 then
        local _deliveries = p26._deliveries;
        local v27 = _deliveries[p26._deliveryHead];

        if v27 ~= nil then
            p26:_stage(v27);
            local v28, v29 = advanceQueueHead(_deliveries, p26._deliveryHead, 64);
            p26._deliveries = v28;
            p26._deliveryHead = v29;
        end;
    end;

    local os_clock_ret = os.clock();

    if os_clock_ret < p26._nextOutputAt then
        return;
    end;

    local _records = p26._records;
    local _recordHead = p26._recordHead;
    local v30 = _records[_recordHead];

    if v30 == nil then
        return;
    end;

    DiagnosticProtocol.output(v30);
    p26._nextOutputAt = os_clock_ret + 0.03333333333333333;
    local v31, v32 = advanceQueueHead(_records, _recordHead, 128);
    p26._records = v31;
    p26._recordHead = v32;
end;

return table.freeze(u1);