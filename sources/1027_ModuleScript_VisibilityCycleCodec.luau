-- Decompiled with Potassium's decompiler.

local u1 = {
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
    STAT_POSE_REPLAYS = 19
};

local function writeVector(p2: buffer, p3: number, p4: vector) -- Line: 118
    buffer.writef32(p2, p3, p4.X);
    buffer.writef32(p2, p3 + 4, p4.Y);
    buffer.writef32(p2, p3 + 8, p4.Z);
end;

function u1.readVector(p5: buffer, p6: number) -- Line: 124
    local buffer_readf32_ret = buffer.readf32(p5, p6);
    local buffer_readf32_ret2 = buffer.readf32(p5, p6 + 4);
    local buffer_readf32_ret3 = buffer.readf32(p5, p6 + 8);

    return Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
end;

local function checkedCount(p7: number, p8: number, p9: string) -- Line: 134
    if p7 < 0 or (p8 < p7 or p7 ~= math.floor(p7)) then
        error((`visibility cycle {p9} count {p7} exceeds {p8}`));
    end;

    return p7;
end;

local function actorRecordSize(p10: table) -- Line: 141
    local v11 = #p10.Cells;

    if v11 < 0 or (v11 > 32 or v11 ~= math.floor(v11)) then
        error((`visibility cycle cell count {v11} exceeds {32}`));
    end;

    local v12 = #p10.Origins;

    if v12 < 0 or (v12 > 32 or v12 ~= math.floor(v12)) then
        error((`visibility cycle origin count {v12} exceeds {32}`));
    end;

    local v13 = #p10.TargetPoints;

    if v13 < 0 or (v13 > 64 or v13 ~= math.floor(v13)) then
        error((`visibility cycle target point count {v13} exceeds {64}`));
    end;

    return v11 * 2 + 40 + v12 * 12 + v13 * 12;
end;

function u1.encodeCapture(p14: table) -- Line: 148
    -- upvalues: u1 (copy)
    local v15 = #p14.Actors;

    if v15 < 0 or (v15 > 64 or v15 ~= math.floor(v15)) then
        error((`visibility cycle actor count {v15} exceeds {64}`));
    end;

    if buffer.len(p14.PairKinds) < v15 * v15 then
        error("visibility cycle pair-kind table is too small");
    end;

    local v16 = 0;

    for _, v in p14.Actors do
        local v17 = #v.Cells;

        if v17 < 0 or (v17 > 32 or v17 ~= math.floor(v17)) then
            error((`visibility cycle cell count {v17} exceeds {32}`));
        end;

        local v18 = #v.Origins;

        if v18 < 0 or (v18 > 32 or v18 ~= math.floor(v18)) then
            error((`visibility cycle origin count {v18} exceeds {32}`));
        end;

        local v19 = #v.TargetPoints;

        if v19 < 0 or (v19 > 64 or v19 ~= math.floor(v19)) then
            error((`visibility cycle target point count {v19} exceeds {64}`));
        end;

        v16 = v16 + (v17 * 2 + 40 + v18 * 12 + v19 * 12);
    end;

    local v20 = v15 * 4;
    local v21 = v20 + 48 + v16;
    local v22 = v21 + v15 * v15;
    local buffer_create_ret = buffer.create(v22);
    buffer.writeu32(buffer_create_ret, 0, 843272006);
    buffer.writeu16(buffer_create_ret, 4, 2);
    buffer.writeu8(buffer_create_ret, 6, v15);
    local v23 = 0;

    if p14.StaticEnabled then
        v23 = v23 + u1.FLAG_STATIC;
    end;

    if p14.DynamicCertificates then
        v23 = v23 + u1.FLAG_DYNAMIC_CERTIFICATES;
    end;

    buffer.writeu8(buffer_create_ret, 7, v23);
    buffer.writeu32(buffer_create_ret, 8, p14.Sequence);
    buffer.writef64(buffer_create_ret, 12, p14.CaptureTime);
    buffer.writeu32(buffer_create_ret, 20, p14.Generation);
    buffer.writef32(buffer_create_ret, 28, p14.CycleBudgetSeconds);
    buffer.writeu32(buffer_create_ret, 36, 48);
    buffer.writeu32(buffer_create_ret, 40, v21);
    buffer.writeu32(buffer_create_ret, 44, v22);
    local v24 = v20 + 48;

    for i, v in p14.Actors do
        buffer.writeu32(buffer_create_ret, (i - 1) * 4 + 48, v24);
        local v25 = #v.Cells;

        if v25 < 0 or (v25 > 32 or v25 ~= math.floor(v25)) then
            error((`visibility cycle cell count {v25} exceeds {32}`));
        end;

        local v26 = #v.Origins;

        if v26 < 0 or (v26 > 32 or v26 ~= math.floor(v26)) then
            error((`visibility cycle origin count {v26} exceeds {32}`));
        end;

        local v27 = #v.TargetPoints;

        if v27 < 0 or (v27 > 64 or v27 ~= math.floor(v27)) then
            error((`visibility cycle target point count {v27} exceeds {64}`));
        end;

        local v28 = v25 * 2 + 40 + v26 * 12 + v27 * 12;
        buffer.writeu32(buffer_create_ret, v24, v.ActorId);
        buffer.writeu32(buffer_create_ret, v24 + 4, v.Generation);
        local v29 = v24 + 8;
        local Position = v.Position;
        buffer.writef32(buffer_create_ret, v29, Position.X);
        buffer.writef32(buffer_create_ret, v29 + 4, Position.Y);
        buffer.writef32(buffer_create_ret, v29 + 8, Position.Z);
        local v30 = v24 + 20;
        local Velocity = v.Velocity;
        buffer.writef32(buffer_create_ret, v30, Velocity.X);
        buffer.writef32(buffer_create_ret, v30 + 4, Velocity.Y);
        buffer.writef32(buffer_create_ret, v30 + 8, Velocity.Z);
        buffer.writeu8(buffer_create_ret, v24 + 32, #v.Cells);
        buffer.writeu8(buffer_create_ret, v24 + 33, #v.Origins);
        buffer.writeu8(buffer_create_ret, v24 + 34, #v.TargetPoints);
        buffer.writeu8(buffer_create_ret, v24 + 35, (not v.Extrapolated and 0 or u1.ACTOR_FLAG_EXTRAPOLATED) + (not v.HullTail and 0 or u1.ACTOR_FLAG_HULL_TAIL));
        buffer.writeu32(buffer_create_ret, v24 + 36, v28);
        local v31 = v24 + 40;
        local v32 = v;

        for _, v2 in v.Cells do
            buffer.writeu16(buffer_create_ret, v31, v2);
            v31 = v31 + 2;
        end;

        for _, v2 in v32.Origins do
            buffer.writef32(buffer_create_ret, v31, v2.X);
            buffer.writef32(buffer_create_ret, v31 + 4, v2.Y);
            buffer.writef32(buffer_create_ret, v31 + 8, v2.Z);
            v31 = v31 + 12;
        end;

        for _, v2 in v32.TargetPoints do
            buffer.writef32(buffer_create_ret, v31, v2.X);
            buffer.writef32(buffer_create_ret, v31 + 4, v2.Y);
            buffer.writef32(buffer_create_ret, v31 + 8, v2.Z);
            v31 = v31 + 12;
        end;

        v24 = v24 + v28;
    end;

    if v24 ~= v21 then
        error("visibility cycle capture actor bytes drifted");
    end;

    buffer.copy(buffer_create_ret, v21, p14.PairKinds, 0, v15 * v15);

    return buffer_create_ret;
end;

function u1.readCaptureHeader(p33: buffer) -- Line: 221
    -- upvalues: u1 (copy)
    if buffer.len(p33) < 48 or buffer.readu32(p33, 0) ~= 843272006 then
        error("visibility cycle capture magic is invalid");
    end;

    if buffer.readu16(p33, 4) ~= 2 then
        error("visibility cycle capture version is unsupported");
    end;

    local buffer_readu8_ret = buffer.readu8(p33, 6);
    local buffer_readu32_ret = buffer.readu32(p33, 40);
    local buffer_readu32_ret2 = buffer.readu32(p33, 44);
    local buffer_readu8_ret2 = buffer.readu8(p33, 7);

    if buffer_readu8_ret > 64 or (buffer_readu32_ret + buffer_readu8_ret * buffer_readu8_ret ~= buffer_readu32_ret2 or (buffer_readu32_ret2 ~= buffer.len(p33) or (buffer.readu32(p33, 24) ~= 0 or buffer.readu32(p33, 32) ~= 0))) then
        error("visibility cycle capture layout is invalid");
    else
        local bit32_bnot_ret = bit32.bnot(u1.FLAG_STATIC + u1.FLAG_DYNAMIC_CERTIFICATES);

        if bit32.band(buffer_readu8_ret2, bit32_bnot_ret) ~= 0 then
            error("visibility cycle capture layout is invalid");
        end;
    end;

    return {
        ActorCount = buffer_readu8_ret,
        Flags = buffer_readu8_ret2,
        Sequence = buffer.readu32(p33, 8),
        CaptureTime = buffer.readf64(p33, 12),
        Generation = buffer.readu32(p33, 20),
        CycleBudgetSeconds = buffer.readf32(p33, 28),
        PairKindOffset = buffer_readu32_ret
    };
end;

function u1.readActor(p34: buffer, p35: number) -- Line: 253
    local buffer_readu32_ret = buffer.readu32(p34, (p35 - 1) * 4 + 48);
    local buffer_readu8_ret = buffer.readu8(p34, buffer_readu32_ret + 32);
    local buffer_readu8_ret2 = buffer.readu8(p34, buffer_readu32_ret + 33);
    local buffer_readu8_ret3 = buffer.readu8(p34, buffer_readu32_ret + 34);
    local buffer_readu32_ret2 = buffer.readu32(p34, buffer_readu32_ret + 36);

    if buffer_readu32_ret2 ~= buffer_readu8_ret * 2 + 40 + buffer_readu8_ret2 * 12 + buffer_readu8_ret3 * 12 or buffer_readu32_ret + buffer_readu32_ret2 > buffer.len(p34) then
        error("visibility cycle actor record is invalid");
    end;

    local v36 = buffer_readu32_ret + 40;
    local v37 = v36 + buffer_readu8_ret * 2;
    local v38 = {
        Offset = buffer_readu32_ret,
        ActorId = buffer.readu32(p34, buffer_readu32_ret),
        Generation = buffer.readu32(p34, buffer_readu32_ret + 4)
    };
    local v39 = buffer_readu32_ret + 8;
    local buffer_readf32_ret = buffer.readf32(p34, v39);
    local buffer_readf32_ret2 = buffer.readf32(p34, v39 + 4);
    local buffer_readf32_ret3 = buffer.readf32(p34, v39 + 8);
    v38.Position = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local v40 = buffer_readu32_ret + 20;
    local buffer_readf32_ret4 = buffer.readf32(p34, v40);
    local buffer_readf32_ret5 = buffer.readf32(p34, v40 + 4);
    local buffer_readf32_ret6 = buffer.readf32(p34, v40 + 8);
    v38.Velocity = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
    v38.CellCount = buffer_readu8_ret;
    v38.OriginCount = buffer_readu8_ret2;
    v38.TargetPointCount = buffer_readu8_ret3;
    v38.Flags = buffer.readu8(p34, buffer_readu32_ret + 35);
    v38.CellsOffset = v36;
    v38.OriginsOffset = v37;
    v38.TargetPointsOffset = v37 + buffer_readu8_ret2 * 12;

    return v38;
end;

function u1.createResult(p41: number, p42: number, p43: number, p44: number, p45: number, p46: number) -- Line: 285
    -- upvalues: u1 (copy)
    if p41 < 0 or (p41 > 64 or p41 ~= math.floor(p41)) then
        error((`visibility cycle result actor count {p41} exceeds {64}`));
    end;

    local buffer_create_ret = buffer.create(p41 + 108 + p41 * p41);
    buffer.writeu32(buffer_create_ret, 0, 844255046);
    buffer.writeu16(buffer_create_ret, 4, 2);
    buffer.writeu8(buffer_create_ret, 6, p41);
    buffer.writeu8(buffer_create_ret, 7, p42);
    buffer.writeu32(buffer_create_ret, 8, p43);
    buffer.writef64(buffer_create_ret, 12, p44);
    buffer.writeu32(buffer_create_ret, 20, p45);
    buffer.writeu8(buffer_create_ret, 24, p46);
    buffer.fill(buffer_create_ret, p41 + 108, u1.RESULT_NOT_OWNED);

    return buffer_create_ret;
end;

function u1.resultMatrixOffset(p47: number) -- Line: 307
    return p47 + 108;
end;

function u1.resultRowsOffset() -- Line: 311
    return 108;
end;

function u1.writeStat(p48: buffer, p49: number, p50: number) -- Line: 315
    local math_floor_ret = math.floor(p50);
    local math_clamp_ret = math.clamp(math_floor_ret, 0, 4294967295);
    buffer.writeu32(p48, p49 * 4 + 28, math_clamp_ret);
end;

function u1.readStat(p51: buffer, p52: number) -- Line: 319
    return buffer.readu32(p51, p52 * 4 + 28);
end;

function u1.readResultHeader(p53: buffer) -- Line: 334
    -- upvalues: u1 (copy)
    if buffer.len(p53) < 108 or buffer.readu32(p53, 0) ~= 844255046 then
        error("visibility cycle result magic is invalid");
    end;

    if buffer.readu16(p53, 4) ~= 2 then
        error("visibility cycle result version is unsupported");
    end;

    local buffer_readu8_ret = buffer.readu8(p53, 6);
    local v54 = u1.resultMatrixOffset(buffer_readu8_ret);

    if buffer_readu8_ret > 64 or v54 + buffer_readu8_ret * buffer_readu8_ret ~= buffer.len(p53) then
        error("visibility cycle result layout is invalid");
    end;

    return {
        ActorCount = buffer_readu8_ret,
        WorkerIndex = buffer.readu8(p53, 7),
        Sequence = buffer.readu32(p53, 8),
        CaptureTime = buffer.readf64(p53, 12),
        Generation = buffer.readu32(p53, 20),
        Status = buffer.readu8(p53, 24),
        RowsOffset = u1.resultRowsOffset(),
        MatrixOffset = v54
    };
end;

u1.PRIMITIVE_SIZE = 64;
u1.PRIMITIVE_KIND_OTHER = 0;
u1.PRIMITIVE_KIND_BLOCK = 1;

function u1.virtualPrimitiveCount(p55: table?, p56: number) -- Line: 365
    local v57 = 0;

    if p55 ~= nil then
        for i in p55 do
            if p56 < i then
                v57 = math.max(v57, i - p56);
            end;
        end;
    end;

    return v57;
end;

function u1.encodePrimitives(p58: table, p59: table?, p60: number?) -- Line: 378
    -- upvalues: u1 (copy)
    local math_floor_ret = math.floor(p60 or 0);
    local math_max_ret = math.max(0, math_floor_ret);
    local buffer_create_ret = buffer.create((#p58 + math_max_ret) * 64);
    local v61 = 0;

    for i, v in p58 do
        local v62 = (i - 1) * 64;
        local v63 = v:IsA("Part") and v.Shape.Name == "Block";

        if not (v63 or p59 ~= nil and p59[i]) then
            v61 = v61 + 1;
        end;

        local v64;

        if v63 then
            v64 = u1.PRIMITIVE_KIND_BLOCK;
        else
            v64 = u1.PRIMITIVE_KIND_OTHER;
        end;

        buffer.writeu8(buffer_create_ret, v62, v64);

        for i2, v2 in { v.CFrame:GetComponents() } do
            buffer.writef32(buffer_create_ret, v62 + i2 * 4, v2);
        end;

        local Size = v.Size;
        buffer.writef32(buffer_create_ret, v62 + 52, Size.X * 0.5);
        buffer.writef32(buffer_create_ret, v62 + 56, Size.Y * 0.5);
        buffer.writef32(buffer_create_ret, v62 + 60, Size.Z * 0.5);
    end;

    for i = #p58 + 1, #p58 + math_max_ret do
        local v65 = (i - 1) * 64;
        buffer.writeu8(buffer_create_ret, v65, u1.PRIMITIVE_KIND_OTHER);
        buffer.writef32(buffer_create_ret, v65 + 4, 0);
        buffer.writef32(buffer_create_ret, v65 + 8, -1000000);
        buffer.writef32(buffer_create_ret, v65 + 12, 0);
        buffer.writef32(buffer_create_ret, v65 + 16, 1);
        buffer.writef32(buffer_create_ret, v65 + 32, 1);
        buffer.writef32(buffer_create_ret, v65 + 48, 1);
        local _ = i;
    end;

    return buffer_create_ret, v61;
end;

return table.freeze(u1);