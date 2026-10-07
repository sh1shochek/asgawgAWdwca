-- ReplicatedStorage.MovementV2.Client.DiagnosticOutput
-- Script path: ReplicatedStorage.MovementV2.Client.DiagnosticOutput
-- Decompile time: 2.37 ms

local DiagnosticProtocol = require(script.Parent.Parent.DiagnosticProtocol)
local u6 = {}
u6.__index = u6

local function splitLine(a1) -- Line: 30 -- types: a1: string
    local v1, v2
    if a1 == "" then
        return {""}
    end
    local u3 = {}
    local u4 = 1
    if pcall(function() -- Line: 38 -- upvalues: a1 (val), u4 (ref), u3 (val)
        local v10, v3, v4, v5, v6, v8, v9
        for i in utf8.codes(a1) do
            v5 = i - u4
            if v5 >= 512 then
                v5 = u3
                v6 = #u3 + 1
                v8 = a1
                v9 = u4
                v10 = i - 1
                v5[v6] = (string.sub(v8, v9, v10))
                u4 = i
            end
        end
        return
    end) then
        u3[#u3 + 1] = (string.sub(a1, u4))
        return u3
    end
    table.clear(u3)
    local v3 = #a1
    for i = 1, v3, 512 do
        v2 = #u3 + 1
        v1 = i + 512 - 1
        u3[v2] = (string.sub(a1, i, v1))
    end
    return u3
end

local function appendDetailRecords(a1, a2, a3, a4) -- Line: 59
    -- upvalues: splitLine (val)
    local v1, v2, v3
    local v4 = string.split(a4, "\n")
    local v5 = #v4
    local v6 = nil
    local v7 = nil
    for i, j in v4, v6, v7 do
        v1 = j
        if string.sub(v1, -1) == "\r" then
            v1 = string.sub(v1, 1, -2)
        end
        v2 = splitLine(v1)
        v3 = #v2
        for k, n in v2 do
            v8[#v8 + 1] = (string.format("[MovementV2.DiagnosticDetail] incident=%s section=%s line=%d/%d part=%d/%d data=%s", v9, v10, i, v5, k, v3, n))
        end
    end
end

local function advanceQueueHead(a1, a2, a3) -- Line: 85 -- types: a1: table, a2: number, a3: number
    local v1 = a2 + 1
    if #a1 < v1 then
        table.clear(a1)
        return a1, 1
    end
    if not (a3 <= v1) then
        return a1, v1
    end
    local v2 = {}
    local v3 = #a1
    for i = v1, v3 do
        v2[#v2 + 1] = a1[i]
    end
    return v2, 1
end

function u6.new() -- Line: 100 -- upvalues: u6 (val)
    return (setmetatable({
        _deliveryHead = 1,
        _deliveriesDropped = 0,
        _recordHead = 1,
        _nextOutputAt = 0,
        _deliveries = {},
        _records = {},
    }, u6))
end

function u6.clear(a1) -- Line: 111
    table.clear(a1._deliveries)
    a1._deliveryHead = 1
    a1._deliveriesDropped = 0
    table.clear(a1._records)
    a1._recordHead = 1
    a1._nextOutputAt = 0
end

function u6.queue(a1, a2) -- Line: 120
    local _deliveries = a1._deliveries
    if 128 <= #_deliveries - a1._deliveryHead + 1 then
        a1._deliveriesDropped = a1._deliveriesDropped + 1
        return
    end
    _deliveries[#_deliveries + 1] = a2
end

function u6:_stage(a2) -- Line: 130 -- upvalues: appendDetailRecords (val)
    local v1 = {}
    appendDetailRecords(v1, a2.CorrelationId, "CLIENT", a2.ClientLog)
    appendDetailRecords(v1, a2.CorrelationId, "SERVER", a2.ServerLog)
    local _records = self._records
    local v2 = 2048 - math.max(#_records - self._recordHead + 1, 0)
    local v3 = math.min(#v1, (math.max(v2 - 1, 0)))
    if v2 > 0 then
        _records[#_records + 1] = (string.format(
            "[MovementV2.Diagnostic] incident=%s kind=%s reporter=%s display=%s userId=%d receivedServerTime=%.6f detailRecords=%d queued=%d dropped=%d deliveryQueueDropped=%d",
            a2.CorrelationId,
            a2.Kind,
            a2.ReporterName,
            a2.ReporterDisplayName,
            a2.ReporterUserId,
            a2.ReceivedServerTime,
            #v1,
            v3,
            #v1 - v3,
            self._deliveriesDropped
        ))
        self._deliveriesDropped = 0
    end
    for i = 1, v3 do
        _records[#_records + 1] = v1[i]
    end
end

function u6.drain(a1) -- Line: 162 -- upvalues: advanceQueueHead (val), DiagnosticProtocol (val)
    local v1
    if #a1._records - a1._recordHead + 1 < 1536 then
        local _deliveries = a1._deliveries
        local v2 = _deliveries[a1._deliveryHead]
        if v2 ~= nil then
            local v3
            a1:_stage(v2)
            v3, v1 = advanceQueueHead(_deliveries, a1._deliveryHead, 64)
            a1._deliveries = v3
            a1._deliveryHead = v1
        end
    end
    local v4 = os.clock()
    if v4 < a1._nextOutputAt then
        return
    end
    local _records = a1._records
    local _recordHead = a1._recordHead
    v1 = _records[_recordHead]
    if v1 == nil then
        return
    end
    DiagnosticProtocol.output(v1)
    a1._nextOutputAt = v4 + 0.03333333333333333
    local v5, v6 = advanceQueueHead(_records, _recordHead, 128)
    a1._records = v5
    a1._recordHead = v6
end

return table.freeze(u6)