-- ReplicatedStorage.Visibility.VisibilityCycleCodec
-- Script path: ReplicatedStorage.Visibility.VisibilityCycleCodec
-- Decompile time: 8.31 ms

local u0 = {
    MAX_CELLS = 32,
    MAX_ORIGINS = 32,
    MAX_TARGET_POINTS = 64,
    VECTOR_SIZE = 12,
    PAIR_SKIP = 0,
    PAIR_BROAD = 1,
    PAIR_PROOF = 2,
    RESULT_HIDDEN = 0,
    RESULT_VISIBLE = 1,
    RESULT_UNRESOLVED = 2,
    RESULT_SKIPPED = 3,
    RESULT_NOT_OWNED = 255,
    FLAG_STATIC = 2,
    FLAG_DYNAMIC_CERTIFICATES = 4,
    ACTOR_FLAG_EXTRAPOLATED = 1,
    ACTOR_FLAG_HULL_TAIL = 2,
    STAT_PAIRS = 0,
    STAT_HIDDEN = 1,
    STAT_VISIBLE = 2,
    STAT_UNRESOLVED = 3,
    STAT_SKIPPED = 4,
    STAT_CERTIFICATE_HITS = 5,
    STAT_CERTIFICATE_SEARCHES = 6,
    STAT_CERTIFICATE_FOUND = 7,
    STAT_SEGMENTS = 8,
    STAT_BLOCKER_HITS = 9,
    STAT_BVH_QUERIES = 10,
    STAT_BVH_HITS = 11,
    STAT_FALLBACK_RAYS = 12,
    STAT_DEADLINE = 14,
    STAT_MICROSECONDS = 15,
    STAT_CLEAR_REPLAYS = 16,
    STAT_DYNAMIC_HITS = 17,
    STAT_DYNAMIC_FOUND = 18,
    STAT_POSE_REPLAYS = 19,
}

local function writeVector(a1, a2, a3) -- Line: 118 -- types: a1: buffer, a2: number, a3: vector
    local X = a3.X
    buffer.writef32(a1, a2, X)
    local v1 = a2 + 4
    local Y = a3.Y
    buffer.writef32(a1, v1, Y)
    v1 = a2 + 8
    local Z = a3.Z
    buffer.writef32(a1, v1, Z)
end

function u0.readVector(a1, a2) -- Line: 124 -- types: a1: buffer, a2: number
    return (Vector3.new(buffer.readf32(a1, a2), buffer.readf32(a1, a2 + 4), (buffer.readf32(a1, a2 + 8))))
end

local function checkedCount(a1, a2, a3) -- Line: 134 -- types: a1: number, a2: number, a3: string
    if a1 < 0 or a2 < a1 or a1 ~= math.floor(a1) then
        error((("visibility cycle %* count %* exceeds %*"):format(a3, a1, a2)))
    end
    return a1
end

local function actorRecordSize(a1) -- Line: 141 -- types: a1: table
    local v1 = #a1.Cells
    if v1 < 0 or v1 > 32 or v1 ~= math.floor(v1) then
        error((("visibility cycle cell count %* exceeds %*"):format(v1, 32)))
    end
    local v2 = v1 * 2 + 40
    v1 = #a1.Origins
    if v1 < 0 or v1 > 32 or v1 ~= math.floor(v1) then
        error((("visibility cycle origin count %* exceeds %*"):format(v1, 32)))
    end
    local v3 = v2 + v1 * 12
    local v4 = #a1.TargetPoints
    if v4 < 0 or v4 > 64 or v4 ~= math.floor(v4) then
        error((("visibility cycle target point count %* exceeds %*"):format(v4, 64)))
    end
    return v3 + v4 * 12
end

function u0.encodeCapture(a1) -- Line: 148 -- upvalues: u0 (val) -- types: a1: table
    local ActorId, Generation_2, Position, Velocity, X, X_2, X_3, X_4, Y, Y_2, Y_3, Y_4, Z, Z_2, Z_3, Z_4, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
    local v12 = #a1.Actors
    if v12 < 0 or v12 > 64 or v12 ~= math.floor(v12) then
        error((("visibility cycle actor count %* exceeds %*"):format(v12, 64)))
    end
    if (buffer.len(a1.PairKinds)) < v12 * v12 then
        error("visibility cycle pair-kind table is too small")
    end
    local v13 = 0
    local v14 = nil
    local v15 = nil
    for i, j in a1.Actors, v14, v15 do
        v3 = #j.Cells
        if v3 < 0 or v3 > 32 or v3 ~= math.floor(v3) then
            error((("visibility cycle cell count %* exceeds %*"):format(v3, 32)))
        end
        v1 = v3 * 2 + 40
        v3 = #j.Origins
        if v3 < 0 or v3 > 32 or v3 ~= math.floor(v3) then
            error((("visibility cycle origin count %* exceeds %*"):format(v3, 32)))
        end
        v11 = v1 + v3 * 12
        v2 = #j.TargetPoints
        if v2 < 0 or v2 > 64 or v2 ~= math.floor(v2) then
            error((("visibility cycle target point count %* exceeds %*"):format(v2, 64)))
        end
        v13 = v13 + (v11 + v2 * 12)
    end
    local v16 = v12 * 4
    v14 = v16 + 48 + v13
    v15 = v14 + v12 * v12
    local v17 = buffer.create(v15)
    buffer.writeu32(v17, 0, 843272006)
    buffer.writeu16(v17, 4, 2)
    buffer.writeu8(v17, 6, v12)
    local v18 = 0
    if a1.StaticEnabled then
        v18 = v18 + u0.FLAG_STATIC
    end
    if a1.DynamicCertificates then
        v18 = v18 + u0.FLAG_DYNAMIC_CERTIFICATES
    end
    buffer.writeu8(v17, 7, v18)
    local Sequence = a1.Sequence
    buffer.writeu32(v17, 8, Sequence)
    local CaptureTime = a1.CaptureTime
    buffer.writef64(v17, 12, CaptureTime)
    local Generation = a1.Generation
    buffer.writeu32(v17, 20, Generation)
    local CycleBudgetSeconds = a1.CycleBudgetSeconds
    buffer.writef32(v17, 28, CycleBudgetSeconds)
    buffer.writeu32(v17, 36, 48)
    buffer.writeu32(v17, 40, v14)
    buffer.writeu32(v17, 44, v15)
    local v19 = v16 + 48
    v1 = nil
    v2 = nil
    for k, n in a1.Actors, v1, v2 do
        v6 = (k - 1) * 4 + 48
        buffer.writeu32(v17, v6, v19)
        v8 = #n.Cells
        if v8 < 0 or v8 > 32 or v8 ~= math.floor(v8) then
            error((("visibility cycle cell count %* exceeds %*"):format(v8, 32)))
        end
        v6 = v8 * 2 + 40
        v8 = #n.Origins
        if v8 < 0 or v8 > 32 or v8 ~= math.floor(v8) then
            error((("visibility cycle origin count %* exceeds %*"):format(v8, 32)))
        end
        v5 = v6 + v8 * 12
        v7 = #n.TargetPoints
        if v7 < 0 or v7 > 64 or v7 ~= math.floor(v7) then
            error((("visibility cycle target point count %* exceeds %*"):format(v7, 64)))
        end
        v4 = v5 + v7 * 12
        ActorId = n.ActorId
        buffer.writeu32(v17, v19, ActorId)
        v7 = v19 + 4
        Generation_2 = n.Generation
        buffer.writeu32(v17, v7, Generation_2)
        v5 = v19 + 8
        Position = n.Position
        X = Position.X
        buffer.writef32(v17, v5, X)
        v9 = v5 + 4
        Y = Position.Y
        buffer.writef32(v17, v9, Y)
        v9 = v5 + 8
        Z = Position.Z
        buffer.writef32(v17, v9, Z)
        v5 = v19 + 20
        Velocity = n.Velocity
        X_2 = Velocity.X
        buffer.writef32(v17, v5, X_2)
        v9 = v5 + 4
        Y_2 = Velocity.Y
        buffer.writef32(v17, v9, Y_2)
        v9 = v5 + 8
        Z_2 = Velocity.Z
        buffer.writef32(v17, v9, Z_2)
        v7 = v19 + 32
        v8 = #n.Cells
        buffer.writeu8(v17, v7, v8)
        v7 = v19 + 33
        v8 = #n.Origins
        buffer.writeu8(v17, v7, v8)
        v7 = v19 + 34
        v8 = #n.TargetPoints
        buffer.writeu8(v17, v7, v8)
        v7 = v19 + 35
        v8 = (if not n.Extrapolated then 0 else u0.ACTOR_FLAG_EXTRAPOLATED) + (if not n.HullTail then 0 else u0.ACTOR_FLAG_HULL_TAIL)
        buffer.writeu8(v17, v7, v8)
        v7 = v19 + 36
        buffer.writeu32(v17, v7, v4)
        v5 = v19 + 40
        for m, i5 in n.Cells do
            buffer.writeu16(v17, v5, i5)
            v5 = v5 + 2
        end
        for i6, i7 in n.Origins do
            X_4 = i7.X
            buffer.writef32(v17, v5, X_4)
            v10 = v5 + 4
            Y_4 = i7.Y
            buffer.writef32(v17, v10, Y_4)
            v10 = v5 + 8
            Z_4 = i7.Z
            buffer.writef32(v17, v10, Z_4)
            v5 = v5 + 12
        end
        for i8, i9 in n.TargetPoints do
            X_3 = i9.X
            buffer.writef32(v17, v5, X_3)
            v10 = v5 + 4
            Y_3 = i9.Y
            buffer.writef32(v17, v10, Y_3)
            v10 = v5 + 8
            Z_3 = i9.Z
            buffer.writef32(v17, v10, Z_3)
            v5 = v5 + 12
        end
        v19 = v19 + v4
    end
    if v19 ~= v14 then
        error("visibility cycle capture actor bytes drifted")
    end
    buffer.copy(v17, v14, a1.PairKinds, 0, v12 * v12)
    return v17
end

function u0.readCaptureHeader(a1) -- Line: 221 -- upvalues: u0 (val) -- types: a1: buffer
    if (buffer.len(a1)) < 48 or buffer.readu32(a1, 0) ~= 843272006 then
        error("visibility cycle capture magic is invalid")
    end
    if buffer.readu16(a1, 4) ~= 2 then
        error("visibility cycle capture version is unsupported")
    end
    local v1 = buffer.readu8(a1, 6)
    local v2 = buffer.readu32(a1, 40)
    local v3 = buffer.readu32(a1, 44)
    local v4 = buffer.readu8(a1, 7)
    if v1 > 64
        or v2 + v1 * v1 ~= v3
        or v3 ~= buffer.len(a1)
        or buffer.readu32(a1, 24) ~= 0
        or buffer.readu32(a1, 32) ~= 0
        or bit32.band(v4, (bit32.bnot(u0.FLAG_STATIC + u0.FLAG_DYNAMIC_CERTIFICATES))) ~= 0 then
        error("visibility cycle capture layout is invalid")
    end
    return {
        ActorCount = v1,
        Flags = v4,
        Sequence = buffer.readu32(a1, 8),
        CaptureTime = buffer.readf64(a1, 12),
        Generation = buffer.readu32(a1, 20),
        CycleBudgetSeconds = buffer.readf32(a1, 28),
        PairKindOffset = v2,
    }
end

function u0.readActor(a1, a2) -- Line: 253 -- types: a1: buffer, a2: number
    local v1 = (a2 - 1) * 4 + 48
    local v2 = buffer.readu32(a1, v1)
    local v3 = v2 + 32
    local v4 = buffer.readu8(a1, v3)
    local v5 = v2 + 33
    v1 = buffer.readu8(a1, v5)
    local v6 = v2 + 34
    v3 = buffer.readu8(a1, v6)
    local v7 = v2 + 36
    v5 = buffer.readu32(a1, v7)
    v7 = v4 * 2 + 40 + v1 * 12
    if v5 ~= v7 + v3 * 12 then
        error("visibility cycle actor record is invalid")
    else
        v7 = v2 + v5
        if buffer.len(a1) < v7 then
            error("visibility cycle actor record is invalid")
        end
    end
    v7 = v2 + 40
    local v8 = v7 + v4 * 2
    local v9 = {Offset = v2, ActorId = buffer.readu32(a1, v2)}
    local v10 = v2 + 4
    v9.Generation = buffer.readu32(a1, v10)
    local v11 = v2 + 8
    local v12 = buffer.readf32(a1, v11)
    local v13 = v11 + 4
    local v14 = buffer.readf32(a1, v13)
    local v15 = v11 + 8
    v9.Position = Vector3.new(v12, v14, (buffer.readf32(a1, v15)))
    v11 = v2 + 20
    v12 = buffer.readf32(a1, v11)
    v13 = v11 + 4
    v14 = buffer.readf32(a1, v13)
    v15 = v11 + 8
    v9.Velocity = Vector3.new(v12, v14, (buffer.readf32(a1, v15)))
    v9.CellCount = v4
    v9.OriginCount = v1
    v9.TargetPointCount = v3
    v10 = v2 + 35
    v9.Flags = buffer.readu8(a1, v10)
    v9.CellsOffset = v7
    v9.OriginsOffset = v8
    v9.TargetPointsOffset = v8 + v1 * 12
    return v9
end

function u0.createResult(a1, a2, a3, a4, a5, a6) -- Line: 285
    -- upvalues: u0 (val)
    if a1 < 0 or a1 > 64 or a1 ~= math.floor(a1) then
        error((("visibility cycle result actor count %* exceeds %*"):format(a1, 64)))
    end
    local v1 = buffer.create(a1 + 108 + a1 * a1)
    buffer.writeu32(v1, 0, 844255046)
    buffer.writeu16(v1, 4, 2)
    buffer.writeu8(v1, 6, a1)
    buffer.writeu8(v1, 7, a2)
    buffer.writeu32(v1, 8, a3)
    buffer.writef64(v1, 12, a4)
    buffer.writeu32(v1, 20, a5)
    buffer.writeu8(v1, 24, a6)
    buffer.fill(v1, a1 + 108, u0.RESULT_NOT_OWNED)
    return v1
end

function u0.resultMatrixOffset(a1) -- Line: 307 -- types: a1: number
    return a1 + 108
end

function u0.resultRowsOffset() -- Line: 311
    return 108
end

function u0.writeStat(a1, a2, a3) -- Line: 315 -- types: a1: buffer, a2: number, a3: number
    local v1 = a2 * 4 + 28
    local v2 = math.clamp(math.floor(a3), 0, 4294967295)
    buffer.writeu32(a1, v1, v2)
end

function u0.readStat(a1, a2) -- Line: 319 -- types: a1: buffer, a2: number
    return (buffer.readu32(a1, a2 * 4 + 28))
end

function u0.readResultHeader(a1) -- Line: 334 -- upvalues: u0 (val) -- types: a1: buffer
    if (buffer.len(a1)) < 108 or buffer.readu32(a1, 0) ~= 844255046 then
        error("visibility cycle result magic is invalid")
    end
    if buffer.readu16(a1, 4) ~= 2 then
        error("visibility cycle result version is unsupported")
    end
    local v1 = buffer.readu8(a1, 6)
    local v2 = u0.resultMatrixOffset(v1)
    if v1 > 64 or v2 + v1 * v1 ~= buffer.len(a1) then
        error("visibility cycle result layout is invalid")
    end
    return {
        ActorCount = v1,
        WorkerIndex = buffer.readu8(a1, 7),
        Sequence = buffer.readu32(a1, 8),
        CaptureTime = buffer.readf64(a1, 12),
        Generation = buffer.readu32(a1, 20),
        Status = buffer.readu8(a1, 24),
        RowsOffset = u0.resultRowsOffset(),
        MatrixOffset = v2,
    }
end

u0.PRIMITIVE_SIZE = 64
u0.PRIMITIVE_KIND_OTHER = 0
u0.PRIMITIVE_KIND_BLOCK = 1

function u0.virtualPrimitiveCount(a1, a2) -- Line: 365 -- types: a1: table?, a2: number
    local v1 = 0
    if a1 ~= nil then
        for i in a1 do
            if a2 < i then
                v1 = math.max(v1, i - a2)
            end
        end
    end
    return v1
end

function u0.encodePrimitives(a1, a2, a3) -- Line: 378 -- upvalues: u0 (val) -- types: a1: table, a2: table?, a3: number?
    local PRIMITIVE_KIND_BLOCK, PRIMITIVE_KIND_OTHER, Size, v1, v2, v3, v4, v5, v6
    local v7 = math.max(0, (math.floor(a3 or 0)))
    local v8 = buffer.create((#a1 + v7) * 64)
    local v9 = 0
    local v10 = nil
    local v11 = nil
    local v12 = a1
    for i, j in a1, v10, v11 do
        v1 = (i - 1) * 64
        v2 = j:IsA("Part") and j.Shape.Name == "Block"
        if not v2 then
            if v13 == nil or not v13[i] then
                v9 = v9 + 1
            end
        end
        PRIMITIVE_KIND_BLOCK = if not v2 then u0.PRIMITIVE_KIND_OTHER else u0.PRIMITIVE_KIND_BLOCK
        buffer.writeu8(v8, v1, PRIMITIVE_KIND_BLOCK)
        for k, n in {j.CFrame:GetComponents()} do
            v5 = v1 + k * 4
            buffer.writef32(v8, v5, n)
        end
        Size = j.Size
        v3 = v1 + 52
        v4 = Size.X * 0.5
        buffer.writef32(v8, v3, v4)
        v3 = v1 + 56
        v4 = Size.Y * 0.5
        buffer.writef32(v8, v3, v4)
        v3 = v1 + 60
        v4 = Size.Z * 0.5
        buffer.writef32(v8, v3, v4)
    end
    v11 = #v12 + 1
    local v14 = #v12 + v7
    for m = v11, v14 do
        v6 = (m - 1) * 64
        PRIMITIVE_KIND_OTHER = u0.PRIMITIVE_KIND_OTHER
        buffer.writeu8(v8, v6, PRIMITIVE_KIND_OTHER)
        v2 = v6 + 4
        buffer.writef32(v8, v2, 0)
        v2 = v6 + 8
        buffer.writef32(v8, v2, -1000000)
        v2 = v6 + 12
        buffer.writef32(v8, v2, 0)
        v2 = v6 + 16
        buffer.writef32(v8, v2, 1)
        v2 = v6 + 32
        buffer.writef32(v8, v2, 1)
        v2 = v6 + 48
        buffer.writef32(v8, v2, 1)
    end
    return v8, v9
end

return table.freeze(u0)