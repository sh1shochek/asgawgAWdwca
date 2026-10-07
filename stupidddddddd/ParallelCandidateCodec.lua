-- ReplicatedStorage.Visibility.ParallelCandidateCodec
-- Script path: ReplicatedStorage.Visibility.ParallelCandidateCodec
-- Decompile time: 10.10 ms

local u0 = {
    STATUS_INCONCLUSIVE = 0,
    STATUS_PROVED = 1,
    STATUS_ERROR = 2,
    STATUS_PROVED_FALLBACK = 3,
    PAIR_KIND_PRIMARY = 0,
    PAIR_KIND_FALLBACK = 1,
}

local function checkedCount(a1, a2) -- Line: 40 -- types: a1: table, a2: string
    local v1 = #a1
    if v1 > 255 then
        error((("parallel certificate %* count exceeds %*"):format(a2, 255)))
    end
    return v1
end

local function checkedNumericCount(a1) -- Line: 48 -- types: a1: number
    if a1 < 0 or a1 > 255 or a1 ~= math.floor(a1) then
        error("parallel certificate job count is invalid")
    end
    return a1
end

local function checkedVolumeCount(a1, a2) -- Line: 55 -- types: a1: table?, a2: string
    if a1 == nil then
        return 0
    end
    local v1 = #a1
    if v1 > 255 then
        error((("parallel certificate %* count exceeds %*"):format(a2, 255)))
    end
    for i, j in a1 do
        if #j ~= 8 then
            error((("parallel certificate %* must contain eight box vertices"):format(a2)))
        end
    end
    return v1
end

local function jobDataSizeFromCounts(a1, a2, a3, a4) -- Line: 68
    -- upvalues: 
    return (a1 + a2) * 2 + (a3 + a4) * 12
end

local function jobDataSize(a1) -- Line: 77 -- upvalues: checkedVolumeCount (val) -- types: a1: table
    local v1 = #a1.viewerCells
    if v1 > 255 then
        error((("parallel certificate viewer cell count exceeds %*"):format(255)))
    end
    local v2 = #a1.targetCells
    if v2 > 255 then
        error((("parallel certificate target cell count exceeds %*"):format(255)))
    end
    local v3 = #a1.viewerOrigins
    if v3 > 255 then
        error((("parallel certificate viewer origin count exceeds %*"):format(255)))
    end
    local v4 = #a1.targetPoints
    if v4 > 255 then
        error((("parallel certificate target point count exceeds %*"):format(255)))
    end
    return (v1 + v2) * 2 + (v3 + v4) * 12 + ((checkedVolumeCount(a1.fallbackViewerVolumes, "fallback viewer volume")) + checkedVolumeCount(a1.fallbackTargetVolumes, "fallback target volume")) * 8 * 12
end

local function writeVector(a1, a2, a3) -- Line: 89 -- types: a1: buffer, a2: number, a3: vector
    local X = a3.X
    buffer.writef32(a1, a2, X)
    local v1 = a2 + 4
    local Y = a3.Y
    buffer.writef32(a1, v1, Y)
    v1 = a2 + 8
    local Z = a3.Z
    buffer.writef32(a1, v1, Z)
end

function u0.jobSize(a1, a2, a3, a4, a5, a6) -- Line: 95
    -- upvalues: 
    if a1 < 0 or a1 > 255 or a1 ~= math.floor(a1) then
        error("parallel certificate job count is invalid")
    end
    if a2 < 0 or a2 > 255 or a2 ~= math.floor(a2) then
        error("parallel certificate job count is invalid")
    end
    if a3 < 0 or a3 > 255 or a3 ~= math.floor(a3) then
        error("parallel certificate job count is invalid")
    end
    if a4 < 0 or a4 > 255 or a4 ~= math.floor(a4) then
        error("parallel certificate job count is invalid")
    end
    local v1 = a5 or 0
    if v1 < 0 or v1 > 255 or v1 ~= math.floor(v1) then
        error("parallel certificate job count is invalid")
    end
    local v2 = a6 or 0
    if v2 < 0 or v2 > 255 or v2 ~= math.floor(v2) then
        error("parallel certificate job count is invalid")
    end
    return (a1 + a2) * 2 + (a3 + a4) * 12 + 16 + (v1 + v2) * 8 * 12
end

function u0.createJobBatch(a1, a2, a3, a4) -- Line: 114 -- types: a1: number, a2: number, a3: number, a4: number
    if a3 < 0 or a3 > 65535 or a3 ~= math.floor(a3) then
        error("parallel certificate batch job count is invalid")
    end
    if a4 < 0 or a4 ~= math.floor(a4) then
        error("parallel certificate batch byte count is invalid")
    end
    local v1 = buffer.create(a4 + 16)
    buffer.writeu32(v1, 0, 826494790)
    buffer.writeu16(v1, 4, 2)
    buffer.writeu16(v1, 6, a3)
    buffer.writeu32(v1, 8, a1)
    buffer.writeu32(v1, 12, a2)
    return v1
end

function u0.writeJob(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) -- Line: 135
    -- upvalues: checkedVolumeCount (val)
    local X, X_2, X_3, X_4, Y, Y_2, Y_3, Y_4, Z, Z_2, Z_3, Z_4, v1, v2
    local v3 = #a5
    if v3 > 255 then
        error((("parallel certificate viewer cell count exceeds %*"):format(255)))
    end
    local v4 = #a6
    if v4 > 255 then
        error((("parallel certificate target cell count exceeds %*"):format(255)))
    end
    local v5 = #a7
    if v5 > 255 then
        error((("parallel certificate viewer origin count exceeds %*"):format(255)))
    end
    local v6 = #a8
    if v6 > 255 then
        error((("parallel certificate target point count exceeds %*"):format(255)))
    end
    local v7 = checkedVolumeCount(a9, "fallback viewer volume")
    local v8 = checkedVolumeCount(a10, "fallback target volume")
    local v9 = (v3 + v4) * 2 + (v5 + v6) * 12 + (v7 + v8) * 8 * 12
    if a2 < 16 then
        error("parallel certificate job write exceeds its batch")
    else
        local v10 = a2 + 16 + v9
        if buffer.len(a1) < v10 then
            error("parallel certificate job write exceeds its batch")
        end
    end
    buffer.writeu32(a1, a2, a3)
    local v11 = a2 + 4
    buffer.writeu16(a1, v11, a4 or 0)
    v11 = a2 + 6
    buffer.writeu8(a1, v11, v3)
    v11 = a2 + 7
    buffer.writeu8(a1, v11, v4)
    v11 = a2 + 8
    buffer.writeu8(a1, v11, v5)
    v11 = a2 + 9
    buffer.writeu8(a1, v11, v6)
    v11 = a2 + 10
    buffer.writeu16(a1, v11, v9)
    v11 = a2 + 12
    local v12 = bit32.bor(v7, (bit32.lshift(v8, 8)))
    buffer.writeu32(a1, v11, v12)
    local v13 = a2 + 16
    for i, j in a5 do
        buffer.writeu16(a1, v13, j)
        v13 = v13 + 2
    end
    for k, n in a6 do
        buffer.writeu16(a1, v13, n)
        v13 = v13 + 2
    end
    for m, i5 in a7 do
        X_4 = i5.X
        buffer.writef32(a1, v13, X_4)
        v1 = v13 + 4
        Y_4 = i5.Y
        buffer.writef32(a1, v1, Y_4)
        v1 = v13 + 8
        Z_4 = i5.Z
        buffer.writef32(a1, v1, Z_4)
        v13 = v13 + 12
    end
    for i6, i7 in a8 do
        X_3 = i7.X
        buffer.writef32(a1, v13, X_3)
        v1 = v13 + 4
        Y_3 = i7.Y
        buffer.writef32(a1, v1, Y_3)
        v1 = v13 + 8
        Z_3 = i7.Z
        buffer.writef32(a1, v1, Z_3)
        v13 = v13 + 12
    end
    local v14 = nil
    v11 = nil
    for i8, i9 in a9 or {}, v14, v11 do
        for i10, i11 in i9 do
            X_2 = i11.X
            buffer.writef32(v15, v13, X_2)
            v2 = v13 + 4
            Y_2 = i11.Y
            buffer.writef32(v15, v2, Y_2)
            v2 = v13 + 8
            Z_2 = i11.Z
            buffer.writef32(v15, v2, Z_2)
            v13 = v13 + 12
        end
    end
    v14 = nil
    v11 = nil
    for i12, i13 in a10 or {}, v14, v11 do
        for i14, i15 in i13 do
            X = i15.X
            buffer.writef32(v15, v13, X)
            v2 = v13 + 4
            Y = i15.Y
            buffer.writef32(v15, v2, Y)
            v2 = v13 + 8
            Z = i15.Z
            buffer.writef32(v15, v2, Z)
            v13 = v13 + 12
        end
    end
    return v13
end

function u0.encodeBatch(a1, a2, a3) -- Line: 198
    -- upvalues: jobDataSize (val), u0 (val)
    if #a3 > 65535 then
        error("parallel certificate batch exceeds 65535 jobs")
    end
    local v1 = 0
    for i, j in a3 do
        v1 = v1 + (jobDataSize(j) + 16)
    end
    local v2 = u0.createJobBatch(a1, a2, #a3, v1)
    local v3 = 16
    for k, n in a3 do
        v3 = u0.writeJob(
            v2,
            v3,
            n.jobId,
            n.preferredPlane,
            n.viewerCells,
            n.targetCells,
            n.viewerOrigins,
            n.targetPoints,
            n.fallbackViewerVolumes,
            n.fallbackTargetVolumes
        )
    end
    assert(v3 == buffer.len(v2), "parallel certificate encoder size drift")
    return v2
end

function u0.readBatchHeader(a1) -- Line: 226 -- types: a1: buffer
    if (buffer.len(a1)) < 16 or buffer.readu32(a1, 0) ~= 826494790 then
        error("parallel certificate job magic is invalid")
    end
    if buffer.readu16(a1, 4) ~= 2 then
        error("parallel certificate job version is unsupported")
    end
    return (buffer.readu32(a1, 8)), (buffer.readu32(a1, 12)), (buffer.readu16(a1, 6))
end

function u0.readJob(a1, a2) -- Line: 237 -- types: a1: buffer, a2: number
    local v1, v2
    if a2 < 16 then
        error("parallel certificate job header is truncated")
    else
        v2 = a2 + 16
        if buffer.len(a1) < v2 then
            error("parallel certificate job header is truncated")
        end
    end
    v2 = buffer.readu32(a1, a2)
    local v3 = a2 + 4
    local v4 = buffer.readu16(a1, v3)
    local v5 = a2 + 6
    local v6 = buffer.readu8(a1, v5)
    local v7 = a2 + 7
    v3 = buffer.readu8(a1, v7)
    local v8 = a2 + 8
    v5 = buffer.readu8(a1, v8)
    local v9 = a2 + 9
    v7 = buffer.readu8(a1, v9)
    local v10 = a2 + 10
    v8 = buffer.readu16(a1, v10)
    local v11 = a2 + 12
    v9 = buffer.readu32(a1, v11)
    if bit32.band(v9, 4294901760) ~= 0 then
        error("parallel certificate fallback metadata is malformed")
    end
    v10 = bit32.band(v9, 255)
    v11 = bit32.band(bit32.rshift(v9, 8), 255)
    local v12 = a2 + 16
    local v13 = (v6 + v3) * 2 + (v5 + v7) * 12 + (v10 + v11) * 8 * 12
    if v8 ~= v13 then
        error("parallel certificate job payload is malformed")
    else
        v1 = v12 + v13
        if buffer.len(a1) < v1 then
            error("parallel certificate job payload is malformed")
        end
    end
    v1 = v12 + v6 * 2
    local v14 = v1 + v3 * 2
    local v15 = v14 + v5 * 12
    local v16 = v15 + v7 * 12
    local v17 = v16 + v10 * 8 * 12
    local v18 = v17 + v11 * 8 * 12
    return v2, if v4 ~= 0 then v4 else nil, v12, v6, v1, v3, v14, v5, v15, v7, v16, v10, v17, v11, v18
end

local function actorDataSizeFromCounts(a1, a2, a3, a4, a5) -- Line: 305
    -- upvalues: 
    return a1 * 2 + (a2 + a3) * 12 + (a4 + a5) * 8 * 12
end

function u0.actorRecordSize(a1, a2, a3, a4, a5) -- Line: 317
    -- upvalues: 
    if a1 < 0 or a1 > 255 or a1 ~= math.floor(a1) then
        error("parallel certificate job count is invalid")
    end
    if a2 < 0 or a2 > 255 or a2 ~= math.floor(a2) then
        error("parallel certificate job count is invalid")
    end
    if a3 < 0 or a3 > 255 or a3 ~= math.floor(a3) then
        error("parallel certificate job count is invalid")
    end
    local v1 = a4 or 0
    if v1 < 0 or v1 > 255 or v1 ~= math.floor(v1) then
        error("parallel certificate job count is invalid")
    end
    local v2 = a5 or 0
    if v2 < 0 or v2 > 255 or v2 ~= math.floor(v2) then
        error("parallel certificate job count is invalid")
    end
    return a1 * 2 + (a2 + a3) * 12 + (v1 + v2) * 8 * 12 + 12
end

function u0.createActorBatch(a1, a2, a3, a4, a5) -- Line: 333
    -- upvalues: 
    if a3 < 0 or a3 > 64 or a3 ~= math.floor(a3) then
        error((("parallel certificate actor count must be between 0 and %*"):format(64)))
    end
    if a4 < 0 or a4 > 65535 or a4 ~= math.floor(a4) then
        error("parallel certificate actor-pair count is invalid")
    end
    if a5 < 0 or a5 ~= math.floor(a5) then
        error("parallel certificate actor byte count is invalid")
    end
    local v1 = buffer.create(a5 + 24 + a4 * 12)
    buffer.writeu32(v1, 0, 826363718)
    buffer.writeu16(v1, 4, 1)
    buffer.writeu16(v1, 6, a3)
    buffer.writeu16(v1, 8, a4)
    buffer.writeu16(v1, 10, 0)
    buffer.writeu32(v1, 12, a1)
    buffer.writeu32(v1, 16, a2)
    buffer.writeu32(v1, 20, a5)
    return v1
end

function u0.writeActor(a1, a2, a3, a4, a5, a6, a7) -- Line: 361
    -- upvalues: checkedVolumeCount (val)
    local X, X_2, X_3, X_4, Y, Y_2, Y_3, Y_4, Z, Z_2, Z_3, Z_4, v1, v2
    local v3 = #a3
    if v3 > 255 then
        error((("parallel certificate actor cell count exceeds %*"):format(255)))
    end
    local v4 = #a4
    if v4 > 255 then
        error((("parallel certificate actor viewer point count exceeds %*"):format(255)))
    end
    local v5 = #a5
    if v5 > 255 then
        error((("parallel certificate actor target point count exceeds %*"):format(255)))
    end
    local v6 = checkedVolumeCount(a6, "actor fallback viewer volume")
    local v7 = checkedVolumeCount(a7, "actor fallback target volume")
    local v8 = v3 * 2 + (v4 + v5) * 12 + (v6 + v7) * 8 * 12
    if a2 < 24 then
        error("parallel certificate actor write exceeds its batch")
    else
        local v9 = a2 + 12 + v8
        if buffer.len(a1) < v9 then
            error("parallel certificate actor write exceeds its batch")
        end
    end
    buffer.writeu8(a1, a2, v3)
    local v10 = a2 + 1
    buffer.writeu8(a1, v10, v4)
    v10 = a2 + 2
    buffer.writeu8(a1, v10, v5)
    v10 = a2 + 3
    buffer.writeu8(a1, v10, v6)
    v10 = a2 + 4
    buffer.writeu8(a1, v10, v7)
    v10 = a2 + 5
    buffer.writeu8(a1, v10, 0)
    v10 = a2 + 6
    buffer.writeu16(a1, v10, 0)
    v10 = a2 + 8
    buffer.writeu32(a1, v10, v8)
    local v11 = a2 + 12
    for i, j in a3 do
        buffer.writeu16(a1, v11, j)
        v11 = v11 + 2
    end
    for k, n in a4 do
        X_4 = n.X
        buffer.writef32(a1, v11, X_4)
        v1 = v11 + 4
        Y_4 = n.Y
        buffer.writef32(a1, v1, Y_4)
        v1 = v11 + 8
        Z_4 = n.Z
        buffer.writef32(a1, v1, Z_4)
        v11 = v11 + 12
    end
    for m, i5 in a5 do
        X_3 = i5.X
        buffer.writef32(a1, v11, X_3)
        v1 = v11 + 4
        Y_3 = i5.Y
        buffer.writef32(a1, v1, Y_3)
        v1 = v11 + 8
        Z_3 = i5.Z
        buffer.writef32(a1, v1, Z_3)
        v11 = v11 + 12
    end
    local v12 = nil
    v10 = nil
    for i6, i7 in a6 or {}, v12, v10 do
        for i8, i9 in i7 do
            X_2 = i9.X
            buffer.writef32(v13, v11, X_2)
            v2 = v11 + 4
            Y_2 = i9.Y
            buffer.writef32(v13, v2, Y_2)
            v2 = v11 + 8
            Z_2 = i9.Z
            buffer.writef32(v13, v2, Z_2)
            v11 = v11 + 12
        end
    end
    v12 = nil
    v10 = nil
    for i10, i11 in a7 or {}, v12, v10 do
        for i12, i13 in i11 do
            X = i13.X
            buffer.writef32(v13, v11, X)
            v2 = v11 + 4
            Y = i13.Y
            buffer.writef32(v13, v2, Y)
            v2 = v11 + 8
            Z = i13.Z
            buffer.writef32(v13, v2, Z)
            v11 = v11 + 12
        end
    end
    return v11
end

function u0.writeActorPair(a1, a2, a3, a4, a5, a6, a7) -- Line: 416
    -- upvalues: u0 (val)
    if a4 < 1 or a4 > 64 or a5 < 1 or a5 > 64 then
        error("parallel certificate actor-pair index is invalid")
    end
    if a6 ~= u0.PAIR_KIND_PRIMARY and a6 ~= u0.PAIR_KIND_FALLBACK then
        error("parallel certificate actor-pair kind is invalid")
    end
    if a2 < 24 then
        error("parallel certificate actor-pair write exceeds its batch")
    else
        local v1 = a2 + 12
        if buffer.len(a1) < v1 then
            error("parallel certificate actor-pair write exceeds its batch")
        end
    end
    buffer.writeu32(a1, a2, a3)
    local v2 = a2 + 4
    buffer.writeu16(a1, v2, a7 or 0)
    v2 = a2 + 6
    local v3 = a4 - 1
    buffer.writeu8(a1, v2, v3)
    v2 = a2 + 7
    v3 = a5 - 1
    buffer.writeu8(a1, v2, v3)
    v2 = a2 + 8
    buffer.writeu8(a1, v2, a6)
    v2 = a2 + 9
    buffer.writeu8(a1, v2, 0)
    v2 = a2 + 10
    buffer.writeu16(a1, v2, 0)
    return a2 + 12
end

function u0.readActorBatchHeader(a1) -- Line: 452 -- types: a1: buffer
    if (buffer.len(a1)) < 24 or buffer.readu32(a1, 0) ~= 826363718 then
        error("parallel certificate actor-batch magic is invalid")
    end
    if buffer.readu16(a1, 4) ~= 1 then
        error("parallel certificate actor-batch version is unsupported")
    end
    local v1 = buffer.readu16(a1, 6)
    local v2 = buffer.readu16(a1, 8)
    local v3 = buffer.readu32(a1, 20)
    local v4 = v3 + 24
    if v1 > 64 or v4 + v2 * 12 ~= buffer.len(a1) then
        error("parallel certificate actor-batch size is invalid")
    end
    return (buffer.readu32(a1, 12)), (buffer.readu32(a1, 16)), v1, v2, v3, v4
end

function u0.readActor(a1, a2) -- Line: 469 -- types: a1: buffer, a2: number
    local v1, v2
    if a2 < 24 then
        error("parallel certificate actor header is truncated")
    else
        v2 = a2 + 12
        if buffer.len(a1) < v2 then
            error("parallel certificate actor header is truncated")
        end
    end
    v2 = buffer.readu8(a1, a2)
    local v3 = a2 + 1
    local v4 = buffer.readu8(a1, v3)
    local v5 = a2 + 2
    local v6 = buffer.readu8(a1, v5)
    local v7 = a2 + 3
    v3 = buffer.readu8(a1, v7)
    local v8 = a2 + 4
    v5 = buffer.readu8(a1, v8)
    local v9 = a2 + 8
    v7 = buffer.readu32(a1, v9)
    v8 = v2 * 2 + (v4 + v6) * 12 + (v3 + v5) * 8 * 12
    v9 = a2 + 12
    if v7 ~= v8 then
        error("parallel certificate actor payload is malformed")
    else
        v1 = v9 + v7
        if buffer.len(a1) < v1 then
            error("parallel certificate actor payload is malformed")
        end
    end
    v1 = v9 + v2 * 2
    local v10 = v1 + v4 * 12
    local v11 = v10 + v6 * 12
    local v12 = v11 + v3 * 8 * 12
    return v9, v2, v1, v4, v10, v6, v11, v3, v12, v5, v12 + v5 * 8 * 12
end

function u0.readActorPair(a1, a2, a3) -- Line: 518 -- types: a1: buffer, a2: number, a3: number
    local v1
    local v2 = a2 + (a3 - 1) * 12
    if a3 < 1 then
        error("parallel certificate actor-pair index is out of range")
    else
        v1 = v2 + 12
        if buffer.len(a1) < v1 then
            error("parallel certificate actor-pair index is out of range")
        end
    end
    local v3 = v2 + 4
    v1 = buffer.readu16(a1, v3)
    local v4 = buffer.readu32(a1, v2)
    local v5 = v2 + 6
    v3 = buffer.readu8(a1, v5) + 1
    local v6 = v2 + 7
    local v7 = buffer.readu8(a1, v6) + 1
    v6 = v2 + 8
    local v8 = buffer.readu8(a1, v6)
    if v1 == 0 then
        return v4, v3, v7, v8, nil
    end
    return v4, v3, v7, v8, v1
end

function u0.createResultBatch(a1, a2, a3) -- Line: 535 -- types: a1: number, a2: number, a3: number
    if a3 < 0 or a3 > 65535 then
        error("parallel certificate result count is invalid")
    end
    local v1 = buffer.create(a3 * 12 + 16)
    buffer.writeu32(v1, 0, 827477830)
    buffer.writeu16(v1, 4, 2)
    buffer.writeu16(v1, 6, a3)
    buffer.writeu32(v1, 8, a1)
    buffer.writeu32(v1, 12, a2)
    return v1
end

function u0.writeResult(a1, a2, a3, a4, a5, a6) -- Line: 548
    -- upvalues: 
    local v1 = (a2 - 1) * 12 + 16
    if a2 < 1 then
        error("parallel certificate result index is out of range")
    else
        local v2 = v1 + 12
        if buffer.len(a1) < v2 then
            error("parallel certificate result index is out of range")
        end
    end
    buffer.writeu32(a1, v1, a3)
    local v3 = v1 + 4
    buffer.writeu16(a1, v3, a5 or 0)
    v3 = v1 + 6
    local v4 = math.clamp(math.floor(a6), 0, 65535)
    buffer.writeu16(a1, v3, v4)
    v3 = v1 + 8
    buffer.writeu8(a1, v3, a4)
end

function u0.readResultHeader(a1) -- Line: 566 -- types: a1: buffer
    if (buffer.len(a1)) < 16 or buffer.readu32(a1, 0) ~= 827477830 then
        error("parallel certificate result magic is invalid")
    end
    if buffer.readu16(a1, 4) ~= 2 then
        error("parallel certificate result version is unsupported")
    end
    local v1 = buffer.readu16(a1, 6)
    if (buffer.len(a1)) ~= v1 * 12 + 16 then
        error("parallel certificate result size is invalid")
    end
    return (buffer.readu32(a1, 8)), (buffer.readu32(a1, 12)), v1
end

function u0.readResult(a1, a2) -- Line: 580 -- types: a1: buffer, a2: number
    local v1
    local v2 = (a2 - 1) * 12 + 16
    if a2 < 1 then
        error("parallel certificate result index is out of range")
    else
        v1 = v2 + 12
        if buffer.len(a1) < v1 then
            error("parallel certificate result index is out of range")
        end
    end
    local v3 = v2 + 4
    v1 = buffer.readu16(a1, v3)
    local v4 = buffer.readu32(a1, v2)
    local v5 = v2 + 8
    v3 = buffer.readu8(a1, v5)
    local v6 = if v1 ~= 0 then v1 else nil
    local v7 = v2 + 6
    return v4, v3, v6, (buffer.readu16(a1, v7))
end

u0.HEADER_SIZE = 16
u0.JOB_HEADER_SIZE = 16
u0.RESULT_SIZE = 12
u0.VECTOR_SIZE = 12
u0.MAX_ACTORS = 64
u0.ACTOR_HEADER_SIZE = 24
u0.ACTOR_RECORD_HEADER_SIZE = 12
u0.ACTOR_PAIR_SIZE = 12
return table.freeze(u0)