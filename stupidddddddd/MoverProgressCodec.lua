-- ReplicatedStorage.MovementV2.MoverProgressCodec
-- Script path: ReplicatedStorage.MovementV2.MoverProgressCodec
-- Decompile time: 4.58 ms

local Serial = require(script.Parent.Serial)
local u5 = {AnchorWireSize = 8}

local function isUInt8(a1) -- Line: 32
    local v1 = false
    if type(a1) == "number" then
        v1 = false
        if a1 % 1 == 0 then
            v1 = false
            if a1 >= 0 then
                v1 = a1 <= 255
            end
        end
    end
    return v1
end

local function isUInt16(a1) -- Line: 36 -- upvalues: Serial (val)
    local v1 = false
    if type(a1) == "number" then
        v1 = false
        if a1 % 1 == 0 then
            v1 = false
            if a1 >= 0 then
                v1 = a1 <= Serial.UInt16Max
            end
        end
    end
    return v1
end

local function isDenseArray(a1, a2, a3) -- Line: 40 -- types: a2: number, a3: boolean?
    if type(a1) == "table" and not (a2 < #a1) then
        if #a1 == 0 and a3 ~= true then
            return false
        end
        for i in a1 do
            if type(i) == "number" and i % 1 == 0 and not (i < 1) and not (#a1 < i) then
                continue
            end
            return false
        end
        return true
    end
    return false
end

function u5.validateStreams(a1) -- Line: 52 -- upvalues: isDenseArray (val), Serial (val)
    local ProgressQ, TickAge, TickAge_2, v1, v2, v3
    if not isDenseArray(a1, 64) then
        return false, "InvalidMoverProgressStreamCount"
    end
    local Id = 0
    local v4 = 0
    local v5 = nil
    local v6 = nil
    for i, j in a1, v5, v6 do
        if type(j) == "table" and Serial.isUInt32(j.Id) and j.Id ~= 0 and not (j.Id <= Id) then
            Id = j.Id
            if not isDenseArray(j.Samples, 255) then
                return false, "InvalidMoverProgressSampleCount"
            end
            v4 = v4 + #j.Samples
            if v4 > 1024 then
                return false, "MoverProgressSampleLimit"
            end
            TickAge_2 = 256
            v1 = nil
            v2 = nil
            for k, n in j.Samples, v1, v2 do
                if type(n) == "table" then
                    TickAge = n.TickAge
                    v3 = false
                    if type(TickAge) == "number" then
                        v3 = false
                        if TickAge % 1 == 0 then
                            v3 = false
                            if TickAge >= 0 then
                                v3 = TickAge <= 255
                            end
                        end
                    end
                    if v3 then
                        if TickAge_2 <= n.TickAge then
                            return false, "MoverProgressSamplesNotChronological"
                        end
                        TickAge_2 = n.TickAge
                        ProgressQ = n.ProgressQ
                        v3 = false
                        if type(ProgressQ) == "number" then
                            v3 = false
                            if ProgressQ % 1 == 0 then
                                v3 = false
                                if ProgressQ >= 0 then
                                    v3 = ProgressQ <= Serial.UInt16Max
                                end
                            end
                        end
                        if v3 then
                            continue
                        end
                        return false, "InvalidMoverProgressValue"
                    end
                end
                return false, "InvalidMoverProgressTickAge"
            end
            continue
        end
        return false, "MoverProgressStreamsNotStrictlySorted"
    end
    return true, nil
end

function u5.streamsWireSize(a1) -- Line: 88 -- upvalues: u5 (val) -- types: a1: table
    local v1, v2 = u5.validateStreams(a1)
    assert(v1, v2)
    local v3 = 0
    for i, j in a1 do
        v3 = v3 + (#j.Samples * 3 + 5)
    end
    return v3
end

function u5.writeStreamsValidated(a1, a2, a3) -- Line: 98 -- types: a1: buffer, a2: number, a3: table
    local Id, ProgressQ, TickAge, v1, v2, v3
    local v4 = nil
    local v5 = nil
    local v6, v7 = a2, a1
    for i, j in a3, v4, v5 do
        Id = j.Id
        buffer.writeu32(v7, v6, Id)
        v1 = v6 + 4
        v2 = #j.Samples
        buffer.writeu8(v7, v1, v2)
        v6 = v6 + 5
        for k, n in j.Samples do
            TickAge = n.TickAge
            buffer.writeu8(v7, v6, TickAge)
            v3 = v6 + 1
            ProgressQ = n.ProgressQ
            buffer.writeu16(v7, v3, ProgressQ)
            v6 = v6 + 3
        end
    end
    return v6
end

function u5.readStreams(a1, a2, a3) -- Line: 112 -- upvalues: u5 (val) -- types: a1: buffer, a2: number, a3: number
    if not (a3 < 1) and not (a3 > 64) then
        local v1, v2, v3, v4, v5, v6
        local v7 = table.create(a3)
        local v8 = 0
        local v9 = a1
        for i = 1, a3 do
            if buffer.len(v9) - a2 < 5 then
                return nil, a2, "MoverProgressPayloadSize"
            end
            v5 = buffer.readu32(v9, a2)
            v2 = a2 + 4
            v6 = buffer.readu8(v9, v2)
            a2 = a2 + 5
            if not (v6 < 1) and not (v6 > 255) then
                v8 = v8 + v6
                if not (v8 > 1024) then
                    v1 = buffer.len(v9) - a2
                    if not (v1 < v6 * 3) then
                        v1 = table.create(v6)
                        for j = 1, v6 do
                            v3 = {TickAge = buffer.readu8(v9, a2)}
                            v4 = a2 + 1
                            v3.ProgressQ = buffer.readu16(v9, v4)
                            v1[j] = v3
                            a2 = a2 + 3
                        end
                        continue
                    end
                end
                return nil, a2, "MoverProgressPayloadSize"
            end
            return nil, a2, "InvalidMoverProgressSampleCount"
        end
        local v10, v11 = u5.validateStreams(v7)
        if not v10 then
            return nil, a2, v11
        end
        return v7, a2, nil
    end
    return nil, a2, "InvalidMoverProgressStreamCount"
end

function u5.validateAnchors(a1, a2) -- Line: 152 -- upvalues: isDenseArray (val), Serial (val) -- types: a2: boolean?
    local CurrentProgressQ, PreviousProgressQ, v1
    if not isDenseArray(a1, 64, a2) then
        return false, "InvalidMoverProgressAnchorCount"
    end
    local Id = 0
    local v2 = nil
    local v3 = nil
    for i, j in a1, v2, v3 do
        if type(j) == "table" and Serial.isUInt32(j.Id) and j.Id ~= 0 and not (j.Id <= Id) then
            Id = j.Id
            PreviousProgressQ = j.PreviousProgressQ
            v1 = false
            if type(PreviousProgressQ) == "number" then
                v1 = false
                if PreviousProgressQ % 1 == 0 then
                    v1 = false
                    if PreviousProgressQ >= 0 then
                        v1 = PreviousProgressQ <= Serial.UInt16Max
                    end
                end
            end
            if v1 then
                CurrentProgressQ = j.CurrentProgressQ
                v1 = false
                if type(CurrentProgressQ) == "number" then
                    v1 = false
                    if CurrentProgressQ % 1 == 0 then
                        v1 = false
                        if CurrentProgressQ >= 0 then
                            v1 = CurrentProgressQ <= Serial.UInt16Max
                        end
                    end
                end
                if v1 then
                    continue
                end
            end
            return false, "InvalidMoverProgressAnchorValue"
        end
        return false, "MoverProgressAnchorsNotStrictlySorted"
    end
    return true, nil
end

function u5.writeAnchorsValidated(a1, a2, a3) -- Line: 169 -- types: a1: buffer, a2: number, a3: table
    local CurrentProgressQ, Id, PreviousProgressQ, v1
    local v2 = a2
    for i, j in a3 do
        Id = j.Id
        buffer.writeu32(a1, v2, Id)
        v1 = v2 + 4
        PreviousProgressQ = j.PreviousProgressQ
        buffer.writeu16(a1, v1, PreviousProgressQ)
        v1 = v2 + 6
        CurrentProgressQ = j.CurrentProgressQ
        buffer.writeu16(a1, v1, CurrentProgressQ)
        v2 = v2 + 8
    end
    return v2
end

function u5.readAnchors(a1, a2, a3) -- Line: 179 -- upvalues: u5 (val) -- types: a1: buffer, a2: number, a3: number
    if not (a3 < 0) and not (a3 > 64) then
        local v1 = buffer.len(a1) - a2
        if not (v1 < a3 * 8) then
            local v2, v3
            v1 = table.create(a3)
            for i = 1, a3 do
                v3 = {Id = buffer.readu32(a1, a2)}
                v2 = a2 + 4
                v3.PreviousProgressQ = buffer.readu16(a1, v2)
                v2 = a2 + 6
                v3.CurrentProgressQ = buffer.readu16(a1, v2)
                v1[i] = v3
                a2 = a2 + 8
            end
            local v4, v5 = u5.validateAnchors(v1, true)
            if not v4 then
                return nil, a2, v5
            end
            return v1, a2, nil
        end
    end
    return nil, a2, "MoverProgressAnchorPayloadSize"
end

return table.freeze(u5)