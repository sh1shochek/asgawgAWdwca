-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

local function validBounds(p2: table) -- Line: 12
    if #p2 ~= 6 then
        return false;
    end;

    for i = 1, 6 do
        if p2[i] ~= p2[i] or math.abs(p2[i]) == (1 / 0) then
            return false;
        end;

        local _ = i;
    end;

    local v3;

    if p2[1] <= p2[4] and p2[2] <= p2[5] then
        v3 = p2[3] <= p2[6];
    else
        v3 = false;
    end;

    return v3;
end;

local function checksum(p4: buffer, p5: number, p6: function?) -- Line: 26
    local v7 = 5381;

    for i = p5, buffer.len(p4) - 1 do
        if p6 and i % 4096 == 0 then
            p6();
        end;

        v7 = (v7 * 33 + buffer.readu8(p4, i)) % 4294967296;
        local _ = i;
    end;

    return v7;
end;

local function triangle(p8: any, p9: number) -- Line: 36
    local v10;

    if p9 >= 1 then
        v10 = p9 <= p8.triangleCount;
    else
        v10 = false;
    end;

    assert(v10, "invalid proof triangle");
    local v11 = {};

    for i = 0, 2 do
        local buffer_readu32_ret = buffer.readu32(p8.buffer, p8.triangleOffset + (p9 - 1) * 12 + i * 4);
        local v12 = p8.vertexOffset + (buffer_readu32_ret - 1) * 12;
        v11[i + 1] = { buffer.readf32(p8.buffer, v12), buffer.readf32(p8.buffer, v12 + 4), (buffer.readf32(p8.buffer, v12 + 8)) };
        local _ = i;
    end;

    return v11;
end;

local function half(p13: table) -- Line: 47
    for i = 1, 3 do
        local v14;

        if p13[1][i] == p13[2][i] and p13[1][i] == p13[3][i] then
            local v15 = i % 3 + 1;
            local v16 = (i + 1) % 3 + 1;
            v14 = i;
            local v17 = (1 / 0);
            local v18 = (-1 / 0);
            local v19 = (1 / 0);
            local v20 = (-1 / 0);

            for _, v in p13 do
                v17 = math.min(v17, v[v15]);
                v18 = math.max(v18, v[v15]);
                v19 = math.min(v19, v[v16]);
                v20 = math.max(v20, v[v16]);
            end;

            if v18 > v17 and v20 > v19 then
                local v21 = 0;

                for _, v in p13 do
                    if not ((v[v15] == v17 or v[v15] == v18) and (v[v16] == v19 or v[v16] == v20)) then
                        return nil, nil;
                    end;

                    local bit32_lshift_ret = bit32.lshift(1, (v[v15] == v18 and 1 or 0) + (v[v16] == v20 and 2 or 0));
                    v21 = bit32.bor(v21, bit32_lshift_ret);
                end;

                for i2 = 0, 3 do
                    if v21 == 15 - bit32.lshift(1, i2) then
                        return {
                            axis = v14,
                            d = p13[1][v14],
                            u0 = v17,
                            u1 = v18,
                            v0 = v19,
                            v1 = v20
                        }, i2;
                    end;

                    local _ = i2;
                end;
            end;
        else
            v14 = i;
        end;
    end;

    return nil, nil;
end;

local function same(p22: table, p23: table) -- Line: 76
    local v24;

    if p22.axis == p23.axis and (p22.d == p23.d and (p22.u0 == p23.u0 and (p22.u1 == p23.u1 and p22.v0 == p23.v0))) then
        v24 = p22.v1 == p23.v1;
    else
        v24 = false;
    end;

    return v24;
end;

local function join(p25: table, p26: table) -- Line: 79
    local v27;

    if p25.axis == p26.axis then
        v27 = p25.d == p26.d;
    else
        v27 = false;
    end;

    assert(v27, "noncoplanar proof merge");
    local v28;

    if p25.v0 == p26.v0 and (p25.v1 == p26.v1 and p25.u1 >= p26.u0) then
        v28 = p26.u1 >= p25.u0;
    else
        v28 = false;
    end;

    local v29;

    if p25.u0 == p26.u0 and (p25.u1 == p26.u1 and p25.v1 >= p26.v0) then
        v29 = p26.v1 >= p25.v0;
    else
        v29 = false;
    end;

    assert(v28 or v29, "proof merge crosses a gap or nonrectangular union");

    return {
        axis = p25.axis,
        d = p25.d,
        u0 = math.min(p25.u0, p26.u0),
        u1 = math.max(p25.u1, p26.u1),
        v0 = math.min(p25.v0, p26.v0),
        v1 = math.max(p25.v1, p26.v1)
    };
end;

function u1.new(p30: string, p31: any, p32: function?) -- Line: 94
    -- upvalues: checksum (copy), half (copy), triangle (copy), join (copy), u1 (copy)
    assert(p31.version == 3, "proofs require indexed exact geometry");
    local buffer_fromstring_ret = buffer.fromstring(p30);
    local v33;

    if buffer.len(buffer_fromstring_ret) >= 40 and buffer.len(buffer_fromstring_ret) <= 8388608 then
        v33 = buffer.readstring(buffer_fromstring_ret, 0, 8) == "PVSPRF1\0";
    else
        v33 = false;
    end;

    assert(v33, "invalid proof header");
    local v34 = buffer.readu32(buffer_fromstring_ret, 8) == 1;
    assert(v34, "unsupported proof version");
    local v35;

    if buffer.readu32(buffer_fromstring_ret, 12) == buffer.readu32(p31.buffer, 40) then
        v35 = buffer.readu32(buffer_fromstring_ret, 16) == p31.triangleCount;
    else
        v35 = false;
    end;

    assert(v35, "proof geometry mismatch");
    local buffer_readu32_ret = buffer.readu32(buffer_fromstring_ret, 20);
    local buffer_readu32_ret2 = buffer.readu32(buffer_fromstring_ret, 24);
    local buffer_readu32_ret3 = buffer.readu32(buffer_fromstring_ret, 28);
    local buffer_readu32_ret4 = buffer.readu32(buffer_fromstring_ret, 32);
    local v36;

    if buffer_readu32_ret >= 1 and (buffer_readu32_ret <= 512 and (buffer_readu32_ret2 >= 1 and buffer_readu32_ret2 + buffer_readu32_ret3 <= 400000)) then
        v36 = buffer_readu32_ret4 <= buffer_readu32_ret2;
    else
        v36 = false;
    end;

    assert(v36, "proof limits");
    local v37 = buffer.len(buffer_fromstring_ret) == buffer_readu32_ret + 40 + (buffer_readu32_ret2 + buffer_readu32_ret3) * 8 + buffer_readu32_ret4 * 4;
    assert(v37, "proof length mismatch");
    local v38 = buffer.readstring(buffer_fromstring_ret, 40, buffer_readu32_ret) == p31.fingerprint;
    assert(v38, "proof fingerprint mismatch");
    local v39 = checksum(buffer_fromstring_ret, 40, p32) == buffer.readu32(buffer_fromstring_ret, 36);
    assert(v39, "proof checksum mismatch");
    local table_create_ret = table.create(buffer_readu32_ret2 + buffer_readu32_ret3);
    local v40 = buffer_readu32_ret + 40;

    for i = 1, buffer_readu32_ret2 do
        if p32 and i % 128 == 0 then
            p32();
        end;

        local v41, v42 = half((triangle(p31, (buffer.readu32(buffer_fromstring_ret, v40)))));
        local v43, v44 = half((triangle(p31, (buffer.readu32(buffer_fromstring_ret, v40 + 4)))));

        if v41 then
            if v43 then
                if v42 then
                    if v44 then
                        if v41.axis == v43.axis and (v41.d == v43.d and (v41.u0 == v43.u0 and (v41.u1 == v43.u1 and v41.v0 == v43.v0))) then
                            v43 = v41.v1 == v43.v1;
                        else
                            v43 = false;
                        end;

                        if v43 then
                            v43 = bit32.bxor(v42, v44) == 3;
                        end;
                    else
                        v43 = v44;
                    end;
                else
                    v43 = v42;
                end;
            end;
        else
            v43 = v41;
        end;

        assert(v43, "invalid rectangle triangle witnesses");
        table_create_ret[i] = v41;
        v40 = v40 + 8;
        local _ = i;
    end;

    for i = buffer_readu32_ret2 + 1, buffer_readu32_ret2 + buffer_readu32_ret3 do
        if p32 and i % 512 == 0 then
            p32();
        end;

        local buffer_readu32_ret5 = buffer.readu32(buffer_fromstring_ret, v40);
        local buffer_readu32_ret6 = buffer.readu32(buffer_fromstring_ret, v40 + 4);
        local v45;

        if buffer_readu32_ret5 >= 1 and (buffer_readu32_ret5 < i and (buffer_readu32_ret6 >= 1 and buffer_readu32_ret6 < i)) then
            v45 = buffer_readu32_ret5 ~= buffer_readu32_ret6;
        else
            v45 = false;
        end;

        assert(v45, "invalid proof DAG reference");
        table_create_ret[i] = join(table_create_ret[buffer_readu32_ret5], table_create_ret[buffer_readu32_ret6]);
        v40 = v40 + 8;
        local _ = i;
    end;

    local v46 = {};
    local v47 = { {}, {}, {} };
    local v48 = {};
    local v49 = { {}, {}, {} };

    for i = 1, buffer_readu32_ret4 do
        local buffer_readu32_ret5 = buffer.readu32(buffer_fromstring_ret, v40);
        v40 = v40 + 4;
        local v50;

        if buffer_readu32_ret5 >= 1 and buffer_readu32_ret5 <= #table_create_ret then
            v50 = not v46[buffer_readu32_ret5];
        else
            v50 = false;
        end;

        assert(v50, "invalid proof root");
        v46[buffer_readu32_ret5] = true;
        local v51 = table_create_ret[buffer_readu32_ret5];
        local v52 = v47[v51.axis][v51.d];

        if not v52 then
            v52 = {
                axis = v51.axis,
                d = v51.d,
                rects = {},
                id = #v48 + 1,
                u0 = v51.u0,
                u1 = v51.u1,
                v0 = v51.v0,
                v1 = v51.v1
            };
            v48[#v48 + 1] = v52;
            v47[v51.axis][v51.d] = v52;
            table.insert(v49[v51.axis], v52);
        end;

        v52.rects[#v52.rects + 1] = v51;
        v52.u0 = math.min(v52.u0, v51.u0);
        v52.u1 = math.max(v52.u1, v51.u1);
        v52.v0 = math.min(v52.v0, v51.v0);
        v52.v1 = math.max(v52.v1, v51.v1);
        local _ = i;
    end;

    for _, v in v48 do
        table.sort(v.rects, function(p53, p54) -- Line: 157
            return (p53.u1 - p53.u0) * (p53.v1 - p53.v0) > (p54.u1 - p54.u0) * (p54.v1 - p54.v0);
        end);
    end;

    for _, v in v49 do
        table.sort(v, function(p55, p56) -- Line: 162
            return p55.d < p56.d;
        end);
    end;

    return setmetatable({
        Tests = 0,
        Hits = 0,
        Data = p31,
        Planes = v48,
        ByAxis = v47,
        Sorted = v49,
        PatchCount = buffer_readu32_ret4,
        HintIds = {},
        Hints = {}
    }, u1);
end;

local function footprint(p57: table, p58: table, p59: table) -- Line: 179
    local axis = p57.axis;
    local d = p57.d;

    if not (p58[axis + 3] < d - 0.02 and p59[axis] > d + 0.02 or p59[axis + 3] < d - 0.02 and p58[axis] > d + 0.02) then
        return nil, nil, nil, nil;
    end;

    local math_abs_ret = math.abs(p58[axis] - d);
    local math_abs_ret2 = math.abs(p58[axis + 3] - d);
    local math_abs_ret3 = math.abs(p59[axis] - d);
    local math_abs_ret4 = math.abs(p59[axis + 3] - d);
    local v60 = math.min(math_abs_ret, math_abs_ret2) / (math.min(math_abs_ret, math_abs_ret2) + math.max(math_abs_ret3, math_abs_ret4));
    local v61 = math.max(math_abs_ret, math_abs_ret2) / (math.max(math_abs_ret, math_abs_ret2) + math.min(math_abs_ret3, math_abs_ret4));
    local v62 = axis % 3 + 1;
    local v63 = (axis + 1) % 3 + 1;

    return math.min(p58[v62] + (p59[v62] - p58[v62]) * v60, p58[v62] + (p59[v62] - p58[v62]) * v61) - 0.02, math.max(p58[v62 + 3] + (p59[v62 + 3] - p58[v62 + 3]) * v60, p58[v62 + 3] + (p59[v62 + 3] - p58[v62 + 3]) * v61) + 0.02, math.min(p58[v63] + (p59[v63] - p58[v63]) * v60, p58[v63] + (p59[v63] - p58[v63]) * v61) - 0.02, math.max(p58[v63 + 3] + (p59[v63 + 3] - p58[v63 + 3]) * v60, p58[v63 + 3] + (p59[v63 + 3] - p58[v63 + 3]) * v61) + 0.02;
end;

function u1.Covers(p64: any, p65: number, p66: table, p67: table, p68: number?) -- Line: 197
    -- upvalues: validBounds (copy), footprint (copy)
    if not (validBounds(p66) and validBounds(p67)) then
        return false;
    end;

    local v69 = p64.Planes[p65];

    if not v69 then
        return false;
    end;

    p64.Tests = p64.Tests + 1;
    local v70, v71, v72, v73 = footprint(v69, p66, p67);

    if v70 == nil or (v71 == nil or (v72 == nil or (v73 == nil or (v70 < v69.u0 or (v69.u1 < v71 or (v72 < v69.v0 or v69.v1 < v73)))))) then
        return false;
    end;

    local v74 = {
        {
            v70,
            v71,
            v72,
            v73
        }
    };

    for i, v in v69.rects do
        if p68 and (i % 16 == 1 and p68 <= os.clock()) then
            return false;
        end;

        if i > 128 then
            return false;
        end;

        if v.u1 >= v70 and (v71 >= v.u0 and (v.v1 >= v72 and v73 >= v.v0)) then
            if v.u0 <= v70 and (v71 <= v.u1 and (v.v0 <= v72 and v73 <= v.v1)) then
                p64.Hits = p64.Hits + 1;

                return true;
            end;

            local v75 = v;
            v74 = {};

            for _, v2 in v74 do
                local math_max_ret = math.max(v2[1], v75.u0);
                local math_min_ret = math.min(v2[2], v75.u1);
                local math_max_ret2 = math.max(v2[3], v75.v0);
                local math_min_ret2 = math.min(v2[4], v75.v1);

                if math_min_ret <= math_max_ret or math_min_ret2 <= math_max_ret2 then
                    v74[#v74 + 1] = v2;
                else
                    if v2[1] < math_max_ret then
                        v74[#v74 + 1] = {
                            v2[1],
                            math_max_ret,
                            v2[3],
                            v2[4]
                        };
                    end;

                    if math_min_ret < v2[2] then
                        v74[#v74 + 1] = {
                            math_min_ret,
                            v2[2],
                            v2[3],
                            v2[4]
                        };
                    end;

                    if v2[3] < math_max_ret2 then
                        v74[#v74 + 1] = {
                            math_max_ret,
                            math_min_ret,
                            v2[3],
                            math_max_ret2
                        };
                    end;

                    if math_min_ret2 < v2[4] then
                        v74[#v74 + 1] = {
                            math_max_ret,
                            math_min_ret,
                            math_min_ret2,
                            v2[4]
                        };
                    end;
                end;

                if #v74 > 32 then
                    return false;
                end;
            end;

            if #v74 == 0 then
                p64.Hits = p64.Hits + 1;

                return true;
            end;
        end;
    end;

    return false;
end;

function u1.PlaneForTriangle(p76: any, p77: number) -- Line: 258
    -- upvalues: triangle (copy)
    local v78 = (p77 - 1) % 2048 + 1;

    if p76.HintIds[v78] == p77 then
        if p76.Hints[v78] == 0 then
            return nil;
        end;

        return p76.Hints[v78];
    end;

    local v79 = triangle(p76.Data, p77);
    local v80 = nil;

    for i = 1, 3 do
        local v81;

        if v79[1][i] == v79[2][i] and v79[1][i] == v79[3][i] then
            local v82 = p76.ByAxis[i][v79[1][i]];

            if v82 then
                v80 = v82.id;
                break;
            end;

            v81 = i;
        else
            v81 = i;
        end;
    end;

    p76.HintIds[v78] = p77;
    p76.Hints[v78] = v80 or 0;

    return v80;
end;

function u1.Search(u83: any, u84: table, u85: table, p86: table, p87: number, p88: number?, u89: number?, u90: table?) -- Line: 278
    local u91 = {};

    if p88 then
        u91[p88] = true;

        if u90 then
            u90[#u90 + 1] = p88;
        end;
    end;

    local u92 = 0;

    local function test(p93: number) -- Line: 296
        -- upvalues: u89 (copy), u91 (copy), u90 (copy), u92 (ref), u83 (copy), u84 (copy), u85 (copy)
        if u89 and u89 <= os.clock() then
            return false;
        end;

        if u91[p93] then
            return false;
        end;

        u91[p93] = true;

        if u90 then
            u90[#u90 + 1] = p93;
        end;

        u92 = u92 + 1;

        return u83:Covers(p93, u84, u85, u89);
    end;

    for i = p87, 1, -1 do
        local v94 = u83:PlaneForTriangle(p86[i]);
        local v95;

        if v94 then
            local v96;

            if u89 and u89 <= os.clock() or u91[v94] then
                v96 = false;
            else
                u91[v94] = true;

                if u90 then
                    u90[#u90 + 1] = v94;
                end;

                u92 = u92 + 1;
                v96 = u83:Covers(v94, u84, u85, u89);
            end;

            if v96 then
                return v94;
            end;

            v95 = i;
        else
            v95 = i;
        end;
    end;

    for i = 1, 3 do
        local v97 = math.min(u84[i + 3], u85[i + 3]) + 0.02;
        local v98 = math.max(u84[i], u85[i]) - 0.02;
        local v99;

        if v98 <= v97 then
            v99 = i;
        else
            local v100 = u83.Sorted[i];
            local v101 = #v100 + 1;
            local v102 = (v97 + v98) * 0.5;
            v99 = i;
            local v103 = 1;

            while v103 < v101 do
                local v104 = (v103 + v101) // 2;

                if v100[v104].d < v102 then
                    v103 = v104 + 1;
                else
                    v101 = v104;
                end;
            end;

            local v105 = v103 - 1;

            for i2 = 1, 16 do
                if u92 >= 24 then
                    return nil;
                end;

                local v106;

                if i2 % 2 == 1 then
                    v106 = v103;
                else
                    v106 = v105;
                end;

                if i2 % 2 == 1 then
                    v103 = v103 + 1;
                else
                    v105 = v105 - 1;
                end;

                local v107 = v100[v106];
                local v108;

                if v107 and (v97 < v107.d and v107.d < v98) then
                    local id = v107.id;
                    local v109;

                    if u89 and u89 <= os.clock() or u91[id] then
                        v109 = false;
                    else
                        u91[id] = true;

                        if u90 then
                            u90[#u90 + 1] = id;
                        end;

                        u92 = u92 + 1;
                        v109 = u83:Covers(id, u84, u85, u89);
                    end;

                    if v109 then
                        return v107.id;
                    end;

                    v108 = i2;
                else
                    v108 = i2;
                end;
            end;
        end;
    end;

    return nil;
end;

function u1.CoversOrigin(p110: any, p111: vector, p112: table, p113: table, p114: number?, p115: number) -- Line: 353
    local v116 = {
        p111.X,
        p111.Y,
        p111.Z,
        p111.X,
        p111.Y,
        p111.Z
    };

    if p114 and p110:Covers(p114, v116, p112, p115) then
        return p114;
    end;

    for i = 1, math.min(#p113, 8) do
        local v117 = p113[i];

        if v117 ~= p114 and p110:Covers(v117, v116, p112, p115) then
            return v117;
        end;

        local _ = i;
    end;

    return nil;
end;

return table.freeze(u1);