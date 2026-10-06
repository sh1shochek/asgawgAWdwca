-- Decompiled with Potassium's decompiler.

local u1 = {};

local function ensureFinite(p2: number, p3: string) -- Line: 42
    if p2 ~= p2 or (p2 == (1 / 0) or p2 == (-1 / 0)) then
        error((`PVSData contains non-finite {p3}`));
    end;

    return p2;
end;

local function expectedRowStride(p4: number) -- Line: 49
    return math.ceil(p4 / 8);
end;

local function cellWorldAABB(p5: table) -- Line: 53
    local v6 = p5.size * 0.5;
    local RightVector = p5.cframe.RightVector;
    local UpVector = p5.cframe.UpVector;
    local LookVector = p5.cframe.LookVector;
    local v7 = math.abs(RightVector.X) * v6.X + math.abs(UpVector.X) * v6.Y + math.abs(LookVector.X) * v6.Z;
    local v8 = math.abs(RightVector.Y) * v6.X + math.abs(UpVector.Y) * v6.Y + math.abs(LookVector.Y) * v6.Z;
    local v9 = math.abs(RightVector.Z) * v6.X + math.abs(UpVector.Z) * v6.Y + math.abs(LookVector.Z) * v6.Z;
    local Vector3_new_ret = Vector3.new(v7, v8, v9);

    return p5.cframe.Position - Vector3_new_ret, p5.cframe.Position + Vector3_new_ret;
end;

local function validateCell(p10: table, p11: number, p12: table) -- Line: 66
    if p10.id < 1 or (p10.id > 65535 or p10.id % 1 ~= 0) then
        error((`PVSData cluster {p11} has an invalid ID`));
    end;

    if p12[p10.id] then
        error((`PVSData contains duplicate cluster ID {p10.id}`));
    end;

    p12[p10.id] = true;
    local size = p10.size;
    local X = size.X;
    local v13 = `cluster {p11} size X`;

    if X ~= X or (X == (1 / 0) or X == (-1 / 0)) then
        error((`PVSData contains non-finite {v13}`));
    end;

    local Y = size.Y;
    local v14 = `cluster {p11} size Y`;

    if Y ~= Y or (Y == (1 / 0) or Y == (-1 / 0)) then
        error((`PVSData contains non-finite {v14}`));
    end;

    local Z = size.Z;
    local v15 = `cluster {p11} size Z`;

    if Z ~= Z or (Z == (1 / 0) or Z == (-1 / 0)) then
        error((`PVSData contains non-finite {v15}`));
    end;

    if size.X <= 0 or (size.Y <= 0 or size.Z <= 0) then
        error((`PVSData cluster {p11} has a non-positive size`));
    end;

    local v16 = { p10.cframe:GetComponents() };

    for i, v in ipairs(v16) do
        local v17 = `cluster {p11} CFrame component {i}`;

        if v ~= v or (v == (1 / 0) or v == (-1 / 0)) then
            error((`PVSData contains non-finite {v17}`));
        end;
    end;
end;

local function validateRegion(p18: table, p19: number, p20: number) -- Line: 89
    if p18.cluster < 1 or (p20 < p18.cluster or p18.cluster % 1 ~= 0) then
        error((`PVSData region {p19} has an invalid cluster`));
    end;

    local X = p18.minimum.X;
    local v21 = `region {p19} minimum X`;

    if X ~= X or (X == (1 / 0) or X == (-1 / 0)) then
        error((`PVSData contains non-finite {v21}`));
    end;

    local Y = p18.minimum.Y;
    local v22 = `region {p19} minimum Y`;

    if Y ~= Y or (Y == (1 / 0) or Y == (-1 / 0)) then
        error((`PVSData contains non-finite {v22}`));
    end;

    local Z = p18.minimum.Z;
    local v23 = `region {p19} minimum Z`;

    if Z ~= Z or (Z == (1 / 0) or Z == (-1 / 0)) then
        error((`PVSData contains non-finite {v23}`));
    end;

    local X2 = p18.maximum.X;
    local v24 = `region {p19} maximum X`;

    if X2 ~= X2 or (X2 == (1 / 0) or X2 == (-1 / 0)) then
        error((`PVSData contains non-finite {v24}`));
    end;

    local Y2 = p18.maximum.Y;
    local v25 = `region {p19} maximum Y`;

    if Y2 ~= Y2 or (Y2 == (1 / 0) or Y2 == (-1 / 0)) then
        error((`PVSData contains non-finite {v25}`));
    end;

    local Z2 = p18.maximum.Z;
    local v26 = `region {p19} maximum Z`;

    if Z2 ~= Z2 or (Z2 == (1 / 0) or Z2 == (-1 / 0)) then
        error((`PVSData contains non-finite {v26}`));
    end;

    local v27 = p18.maximum - p18.minimum;

    if v27.X <= 0 or (v27.Y <= 0 or v27.Z <= 0) then
        error((`PVSData region {p19} has non-positive bounds`));
    end;
end;

local function attachRegionsToCells(p28: table) -- Line: 105
    for _, v in ipairs(p28.cells) do
        v.regions = {};
    end;

    for _, v in ipairs(p28.regions) do
        local regions = p28.cells[v.cluster].regions;
        assert(regions ~= nil);
        regions[#regions + 1] = v;
    end;
end;

local function validateData(p29: table, p30: function?) -- Line: 116
    -- upvalues: validateCell (copy), validateRegion (copy)
    local v31 = #p29.cells;

    if v31 < 1 or v31 > 8192 then
        error((`PVSData cluster count must be between 1 and {8192}`));
    end;

    if #p29.regions < 1 or #p29.regions > 65535 then
        error((`PVSData region count must be between 1 and {65535}`));
    end;

    local math_ceil_ret = math.ceil(v31 / 8);

    if p29.rowStride ~= math_ceil_ret then
        error((`PVSData row stride mismatch: expected {math_ceil_ret}, got {p29.rowStride}`));
    end;

    if #p29.visibleBytes ~= v31 * math_ceil_ret then
        error((`PVSData visibility byte count mismatch: expected {v31 * math_ceil_ret}, got {#p29.visibleBytes}`));
    end;

    local maxDistance = p29.maxDistance;

    if maxDistance ~= maxDistance or (maxDistance == (1 / 0) or maxDistance == (-1 / 0)) then
        error("PVSData contains non-finite maximum distance");
    end;

    local nearDistance = p29.nearDistance;

    if nearDistance ~= nearDistance or (nearDistance == (1 / 0) or nearDistance == (-1 / 0)) then
        error("PVSData contains non-finite near distance");
    end;

    if p29.maxDistance < 0 or p29.nearDistance < 0 then
        error("PVSData distances cannot be negative");
    end;

    if p29.raysPerPair < 1 or (p29.raysPerPair > 255 or p29.raysPerPair % 1 ~= 0) then
        error("PVSData bake quality must be an integer between 1 and 255");
    end;

    local v32 = {};

    for i, v in ipairs(p29.cells) do
        validateCell(v, i, v32);
    end;

    local table_create_ret = table.create(v31, 0);

    for i, v in ipairs(p29.regions) do
        validateRegion(v, i, v31);
        local cluster = v.cluster;
        table_create_ret[cluster] = table_create_ret[cluster] + 1;
    end;

    for i = 1, v31 do
        local v33;

        if table_create_ret[i] == 0 then
            error((`PVSData cluster {i} has no spatial regions`));
            v33 = i;
        else
            v33 = i;
        end;
    end;

    local buffer_fromstring_ret = buffer.fromstring(p29.visibleBytes);
    local v34 = {};
    local v35 = {};

    for i = 1, v31 do
        v34[i] = math.floor((i - 1) / 8);
        v35[i] = bit32.lshift(1, (i - 1) % 8);
        local _ = i;
    end;

    for i = 1, v31 do
        if p30 and i % 32 == 0 then
            p30();
        end;

        local v36 = (i - 1) * math_ceil_ret;
        local v37 = v34[i];
        local v38 = v35[i];
        local buffer_readu8_ret = buffer.readu8(buffer_fromstring_ret, v36 + v37);

        if bit32.band(buffer_readu8_ret, v38) == 0 then
            error((`PVSData cluster {i} is not visible to itself`));
        end;

        local v39 = i;

        for i2 = i + 1, v31 do
            local buffer_readu8_ret2 = buffer.readu8(buffer_fromstring_ret, v36 + v34[i2]);
            local v40 = bit32.band(buffer_readu8_ret2, v35[i2]) ~= 0;
            local buffer_readu8_ret3 = buffer.readu8(buffer_fromstring_ret, (i2 - 1) * math_ceil_ret + v37);
            local v41;

            if v40 == (bit32.band(buffer_readu8_ret3, v38) ~= 0) then
                v41 = i2;
            else
                error((`PVSData visibility is not mutual for clusters {v39} and {i2}`));
                v41 = i2;
            end;
        end;
    end;
end;

function u1.getRowStride(p42: number) -- Line: 183
    local v43;

    if p42 >= 0 then
        v43 = p42 % 1 == 0;
    else
        v43 = false;
    end;

    assert(v43, "cellCount must be a non-negative integer");

    return math.ceil(p42 / 8);
end;

function u1.newVisibilityBuffer(p44: number) -- Line: 188
    local v45;

    if p44 >= 1 and p44 <= 8192 then
        v45 = p44 % 1 == 0;
    else
        v45 = false;
    end;

    assert(v45, "invalid PVS cluster count");

    return buffer.create(p44 * math.ceil(p44 / 8));
end;

function u1.setVisible(p46: buffer, p47: number, p48: number, p49: number) -- Line: 193
    local v50 = (p48 - 1) * p47 + math.floor((p49 - 1) / 8);
    local bit32_lshift_ret = bit32.lshift(1, (p49 - 1) % 8);
    local buffer_readu8_ret = buffer.readu8(p46, v50);
    local bit32_bor_ret = bit32.bor(buffer_readu8_ret, bit32_lshift_ret);
    buffer.writeu8(p46, v50, bit32_bor_ret);
end;

function u1.isVisible(p51: table, p52: number, p53: number) -- Line: 199
    local v54 = #p51.cells;

    if p52 < 1 or (v54 < p52 or (p53 < 1 or v54 < p53)) then
        return false;
    end;

    local v55 = (p52 - 1) * p51.rowStride + math.floor((p53 - 1) / 8) + 1;
    local string_byte_ret = string.byte(p51.visibleBytes, v55);

    if string_byte_ret == nil then
        return false;
    end;

    local bit32_lshift_ret = bit32.lshift(1, (p53 - 1) % 8);

    return bit32.band(string_byte_ret, bit32_lshift_ret) ~= 0;
end;

function u1.regionContainsPoint(p56: table, p57: vector, p58: number?) -- Line: 213
    local math_max_ret = math.max(p58 or 0, 0);
    local v59;

    if p57.X >= p56.minimum.X - math_max_ret and (p57.X <= p56.maximum.X + math_max_ret and (p57.Y >= p56.minimum.Y - math_max_ret and (p57.Y <= p56.maximum.Y + math_max_ret and p57.Z >= p56.minimum.Z - math_max_ret))) then
        v59 = p57.Z <= p56.maximum.Z + math_max_ret;
    else
        v59 = false;
    end;

    return v59;
end;

function u1.findCellIndices(p60: table, p61: vector, p62: number?) -- Line: 223
    -- upvalues: u1 (copy)
    local v63 = {};
    local v64 = {};

    for _, v in ipairs(p60.regions) do
        if not v63[v.cluster] and u1.regionContainsPoint(v, p61, p62) then
            v63[v.cluster] = true;
            v64[#v64 + 1] = v.cluster;
        end;
    end;

    table.sort(v64);

    return v64;
end;

function u1.regionFromCell(p65: table, p66: number) -- Line: 236
    -- upvalues: cellWorldAABB (copy)
    local v67, v68 = cellWorldAABB(p65);

    return {
        cluster = p66,
        minimum = v67,
        maximum = v68
    };
end;

function u1.encode(p69: table) -- Line: 245
    -- upvalues: validateData (copy)
    validateData(p69);
    local v70 = #p69.cells;
    local v71 = #p69.regions;
    local buffer_create_ret = buffer.create(v70 * 62 + 22 + v71 * 26 + #p69.visibleBytes);
    local v72 = 0;
    buffer.writestring(buffer_create_ret, v72, "BLXPVS2");
    local v73 = v72 + 7;
    buffer.writeu16(buffer_create_ret, v73, v70);
    local v74 = v73 + 2;
    buffer.writeu16(buffer_create_ret, v74, p69.rowStride);
    local v75 = v74 + 2;
    buffer.writeu16(buffer_create_ret, v75, v71);
    local v76 = v75 + 2;
    buffer.writef32(buffer_create_ret, v76, p69.maxDistance);
    local v77 = v76 + 4;
    buffer.writef32(buffer_create_ret, v77, p69.nearDistance);
    local v78 = v77 + 4;
    buffer.writeu8(buffer_create_ret, v78, p69.raysPerPair);
    local v79 = v78 + 1;

    for _, v in ipairs(p69.cells) do
        buffer.writeu16(buffer_create_ret, v79, v.id);
        v79 = v79 + 2;
        local v80 = {
            v.cframe:GetComponents(),
            [#v80 + 1] = v.size.X,
            [#v80 + 1] = v.size.Y,
            [#v80 + 1] = v.size.Z
        };

        for _, v2 in ipairs(v80) do
            buffer.writef32(buffer_create_ret, v79, v2);
            v79 = v79 + 4;
        end;
    end;

    for _, v in ipairs(p69.regions) do
        buffer.writeu16(buffer_create_ret, v79, v.cluster);
        v79 = v79 + 2;

        for _, v2 in ipairs({
            v.minimum.X,
            v.minimum.Y,
            v.minimum.Z,
            v.maximum.X,
            v.maximum.Y,
            v.maximum.Z
        }) do
            buffer.writef32(buffer_create_ret, v79, v2);
            v79 = v79 + 4;
        end;
    end;

    buffer.writestring(buffer_create_ret, v79, p69.visibleBytes);

    return buffer.tostring(buffer_create_ret);
end;

function u1.isEncoded(p81) -- Line: 301
    local v82;

    if typeof(p81) == "string" and #p81 >= 7 then
        v82 = string.sub(p81, 1, 7) == "BLXPVS1" and true or string.sub(p81, 1, 7) == "BLXPVS2";
    else
        v82 = false;
    end;

    return v82;
end;

function u1.decode(p83: string, p84: function?) -- Line: 307
    -- upvalues: u1 (copy), validateData (copy), attachRegionsToCells (copy)
    if not u1.isEncoded(p83) then
        error("PVSData does not start with a supported BLXPVS header");
    end;

    local v85 = string.sub(p83, 1, 7) == "BLXPVS2";
    local buffer_fromstring_ret = buffer.fromstring(p83);
    local u86 = 7;
    local u87 = #p83;

    local function ensureCanRead(p88: number, p89: string) -- Line: 318
        -- upvalues: u87 (copy), u86 (ref)
        if u87 - u86 < p88 then
            error((`PVSData ended while reading {p89}`));
        end;
    end;

    local function readu16(p90: string) -- Line: 324
        -- upvalues: u87 (copy), u86 (ref), buffer_fromstring_ret (copy)
        if u87 - u86 < 2 then
            error((`PVSData ended while reading {p90}`));
        end;

        local buffer_readu16_ret = buffer.readu16(buffer_fromstring_ret, u86);
        u86 = u86 + 2;

        return buffer_readu16_ret;
    end;

    local function readu8(p91: string) -- Line: 331
        -- upvalues: u87 (copy), u86 (ref), buffer_fromstring_ret (copy)
        if u87 - u86 < 1 then
            error((`PVSData ended while reading {p91}`));
        end;

        local buffer_readu8_ret = buffer.readu8(buffer_fromstring_ret, u86);
        u86 = u86 + 1;

        return buffer_readu8_ret;
    end;

    local function readf32(p92: string) -- Line: 338
        -- upvalues: u87 (copy), u86 (ref), buffer_fromstring_ret (copy)
        if u87 - u86 < 4 then
            error((`PVSData ended while reading {p92}`));
        end;

        local buffer_readf32_ret = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret ~= buffer_readf32_ret or (buffer_readf32_ret == (1 / 0) or buffer_readf32_ret == (-1 / 0)) then
            error((`PVSData contains non-finite {p92}`));
        end;

        u86 = u86 + 4;

        return buffer_readf32_ret;
    end;

    if u87 - u86 < 2 then
        error("PVSData ended while reading cluster count");
    end;

    local buffer_readu16_ret = buffer.readu16(buffer_fromstring_ret, u86);
    u86 = u86 + 2;

    if buffer_readu16_ret < 1 or buffer_readu16_ret > 8192 then
        error((`PVSData has an invalid cluster count: {buffer_readu16_ret}`));
    end;

    if u87 - u86 < 2 then
        error("PVSData ended while reading row stride");
    end;

    local buffer_readu16_ret2 = buffer.readu16(buffer_fromstring_ret, u86);
    u86 = u86 + 2;
    local v93;

    if v85 then
        if u87 - u86 < 2 then
            error("PVSData ended while reading region count");
        end;

        v93 = buffer.readu16(buffer_fromstring_ret, u86);
        u86 = u86 + 2;
    else
        v93 = buffer_readu16_ret;
    end;

    if v93 < 1 or v93 > 65535 then
        error((`PVSData has an invalid region count: {v93}`));
    end;

    if u87 - u86 < 4 then
        error("PVSData ended while reading maximum distance");
    end;

    local buffer_readf32_ret = buffer.readf32(buffer_fromstring_ret, u86);

    if buffer_readf32_ret ~= buffer_readf32_ret or (buffer_readf32_ret == (1 / 0) or buffer_readf32_ret == (-1 / 0)) then
        error("PVSData contains non-finite maximum distance");
    end;

    u86 = u86 + 4;

    if u87 - u86 < 4 then
        error("PVSData ended while reading near distance");
    end;

    local buffer_readf32_ret2 = buffer.readf32(buffer_fromstring_ret, u86);

    if buffer_readf32_ret2 ~= buffer_readf32_ret2 or (buffer_readf32_ret2 == (1 / 0) or buffer_readf32_ret2 == (-1 / 0)) then
        error("PVSData contains non-finite near distance");
    end;

    u86 = u86 + 4;

    if u87 - u86 < 1 then
        error("PVSData ended while reading bake quality");
    end;

    local buffer_readu8_ret = buffer.readu8(buffer_fromstring_ret, u86);
    u86 = u86 + 1;
    local v94 = (v85 and 22 or 20) + buffer_readu16_ret * 62 + (not v85 and 0 or v93 * 26) + buffer_readu16_ret * buffer_readu16_ret2;

    if u87 ~= v94 then
        error((`PVSData byte count mismatch: expected {v94}, got {u87}`));
    end;

    local table_create_ret = table.create(buffer_readu16_ret);

    for i = 1, buffer_readu16_ret do
        local v95 = `cluster {i} ID`;

        if u87 - u86 < 2 then
            error((`PVSData ended while reading {v95}`));
        end;

        local buffer_readu16_ret3 = buffer.readu16(buffer_fromstring_ret, u86);
        u86 = u86 + 2;
        local v96 = `cluster {i} position X`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v96}`));
        end;

        local buffer_readf32_ret3 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret3 ~= buffer_readf32_ret3 or (buffer_readf32_ret3 == (1 / 0) or buffer_readf32_ret3 == (-1 / 0)) then
            error((`PVSData contains non-finite {v96}`));
        end;

        u86 = u86 + 4;
        local v97 = `cluster {i} position Y`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v97}`));
        end;

        local buffer_readf32_ret4 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret4 ~= buffer_readf32_ret4 or (buffer_readf32_ret4 == (1 / 0) or buffer_readf32_ret4 == (-1 / 0)) then
            error((`PVSData contains non-finite {v97}`));
        end;

        u86 = u86 + 4;
        local v98 = `cluster {i} position Z`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v98}`));
        end;

        local buffer_readf32_ret5 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret5 ~= buffer_readf32_ret5 or (buffer_readf32_ret5 == (1 / 0) or buffer_readf32_ret5 == (-1 / 0)) then
            error((`PVSData contains non-finite {v98}`));
        end;

        u86 = u86 + 4;
        local v99 = `cluster {i} rotation 00`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v99}`));
        end;

        local buffer_readf32_ret6 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret6 ~= buffer_readf32_ret6 or (buffer_readf32_ret6 == (1 / 0) or buffer_readf32_ret6 == (-1 / 0)) then
            error((`PVSData contains non-finite {v99}`));
        end;

        u86 = u86 + 4;
        local v100 = `cluster {i} rotation 01`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v100}`));
        end;

        local buffer_readf32_ret7 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret7 ~= buffer_readf32_ret7 or (buffer_readf32_ret7 == (1 / 0) or buffer_readf32_ret7 == (-1 / 0)) then
            error((`PVSData contains non-finite {v100}`));
        end;

        u86 = u86 + 4;
        local v101 = `cluster {i} rotation 02`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v101}`));
        end;

        local buffer_readf32_ret8 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret8 ~= buffer_readf32_ret8 or (buffer_readf32_ret8 == (1 / 0) or buffer_readf32_ret8 == (-1 / 0)) then
            error((`PVSData contains non-finite {v101}`));
        end;

        u86 = u86 + 4;
        local v102 = `cluster {i} rotation 10`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v102}`));
        end;

        local buffer_readf32_ret9 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret9 ~= buffer_readf32_ret9 or (buffer_readf32_ret9 == (1 / 0) or buffer_readf32_ret9 == (-1 / 0)) then
            error((`PVSData contains non-finite {v102}`));
        end;

        u86 = u86 + 4;
        local v103 = `cluster {i} rotation 11`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v103}`));
        end;

        local buffer_readf32_ret10 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret10 ~= buffer_readf32_ret10 or (buffer_readf32_ret10 == (1 / 0) or buffer_readf32_ret10 == (-1 / 0)) then
            error((`PVSData contains non-finite {v103}`));
        end;

        u86 = u86 + 4;
        local v104 = `cluster {i} rotation 12`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v104}`));
        end;

        local buffer_readf32_ret11 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret11 ~= buffer_readf32_ret11 or (buffer_readf32_ret11 == (1 / 0) or buffer_readf32_ret11 == (-1 / 0)) then
            error((`PVSData contains non-finite {v104}`));
        end;

        u86 = u86 + 4;
        local v105 = `cluster {i} rotation 20`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v105}`));
        end;

        local buffer_readf32_ret12 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret12 ~= buffer_readf32_ret12 or (buffer_readf32_ret12 == (1 / 0) or buffer_readf32_ret12 == (-1 / 0)) then
            error((`PVSData contains non-finite {v105}`));
        end;

        u86 = u86 + 4;
        local v106 = `cluster {i} rotation 21`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v106}`));
        end;

        local buffer_readf32_ret13 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret13 ~= buffer_readf32_ret13 or (buffer_readf32_ret13 == (1 / 0) or buffer_readf32_ret13 == (-1 / 0)) then
            error((`PVSData contains non-finite {v106}`));
        end;

        u86 = u86 + 4;
        local v107 = `cluster {i} rotation 22`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v107}`));
        end;

        local buffer_readf32_ret14 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret14 ~= buffer_readf32_ret14 or (buffer_readf32_ret14 == (1 / 0) or buffer_readf32_ret14 == (-1 / 0)) then
            error((`PVSData contains non-finite {v107}`));
        end;

        u86 = u86 + 4;
        local v108 = `cluster {i} size X`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v108}`));
        end;

        local buffer_readf32_ret15 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret15 ~= buffer_readf32_ret15 or (buffer_readf32_ret15 == (1 / 0) or buffer_readf32_ret15 == (-1 / 0)) then
            error((`PVSData contains non-finite {v108}`));
        end;

        u86 = u86 + 4;
        local v109 = `cluster {i} size Y`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v109}`));
        end;

        local buffer_readf32_ret16 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret16 ~= buffer_readf32_ret16 or (buffer_readf32_ret16 == (1 / 0) or buffer_readf32_ret16 == (-1 / 0)) then
            error((`PVSData contains non-finite {v109}`));
        end;

        u86 = u86 + 4;
        local v110 = `cluster {i} size Z`;

        if u87 - u86 < 4 then
            error((`PVSData ended while reading {v110}`));
        end;

        local buffer_readf32_ret17 = buffer.readf32(buffer_fromstring_ret, u86);

        if buffer_readf32_ret17 ~= buffer_readf32_ret17 or (buffer_readf32_ret17 == (1 / 0) or buffer_readf32_ret17 == (-1 / 0)) then
            error((`PVSData contains non-finite {v110}`));
        end;

        u86 = u86 + 4;
        table_create_ret[i] = {
            id = buffer_readu16_ret3,
            cframe = CFrame.new(buffer_readf32_ret3, buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6, buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9, buffer_readf32_ret10, buffer_readf32_ret11, buffer_readf32_ret12, buffer_readf32_ret13, buffer_readf32_ret14),
            size = Vector3.new(buffer_readf32_ret15, buffer_readf32_ret16, buffer_readf32_ret17)
        };
        local _ = i;
    end;

    local table_create_ret2 = table.create(v93);

    if v85 then
        for i = 1, v93 do
            local v111 = {};
            local v112 = `region {i} cluster`;

            if u87 - u86 < 2 then
                error((`PVSData ended while reading {v112}`));
            end;

            local buffer_readu16_ret3 = buffer.readu16(buffer_fromstring_ret, u86);
            u86 = u86 + 2;
            v111.cluster = buffer_readu16_ret3;
            local v113 = `region {i} minimum X`;

            if u87 - u86 < 4 then
                error((`PVSData ended while reading {v113}`));
            end;

            local buffer_readf32_ret3 = buffer.readf32(buffer_fromstring_ret, u86);

            if buffer_readf32_ret3 ~= buffer_readf32_ret3 or (buffer_readf32_ret3 == (1 / 0) or buffer_readf32_ret3 == (-1 / 0)) then
                error((`PVSData contains non-finite {v113}`));
            end;

            u86 = u86 + 4;
            local v114 = `region {i} minimum Y`;

            if u87 - u86 < 4 then
                error((`PVSData ended while reading {v114}`));
            end;

            local buffer_readf32_ret4 = buffer.readf32(buffer_fromstring_ret, u86);

            if buffer_readf32_ret4 ~= buffer_readf32_ret4 or (buffer_readf32_ret4 == (1 / 0) or buffer_readf32_ret4 == (-1 / 0)) then
                error((`PVSData contains non-finite {v114}`));
            end;

            u86 = u86 + 4;
            local v115 = `region {i} minimum Z`;

            if u87 - u86 < 4 then
                error((`PVSData ended while reading {v115}`));
            end;

            local buffer_readf32_ret5 = buffer.readf32(buffer_fromstring_ret, u86);

            if buffer_readf32_ret5 ~= buffer_readf32_ret5 or (buffer_readf32_ret5 == (1 / 0) or buffer_readf32_ret5 == (-1 / 0)) then
                error((`PVSData contains non-finite {v115}`));
            end;

            u86 = u86 + 4;
            v111.minimum = Vector3.new(buffer_readf32_ret3, buffer_readf32_ret4, buffer_readf32_ret5);
            local v116 = `region {i} maximum X`;

            if u87 - u86 < 4 then
                error((`PVSData ended while reading {v116}`));
            end;

            local buffer_readf32_ret6 = buffer.readf32(buffer_fromstring_ret, u86);

            if buffer_readf32_ret6 ~= buffer_readf32_ret6 or (buffer_readf32_ret6 == (1 / 0) or buffer_readf32_ret6 == (-1 / 0)) then
                error((`PVSData contains non-finite {v116}`));
            end;

            u86 = u86 + 4;
            local v117 = `region {i} maximum Y`;

            if u87 - u86 < 4 then
                error((`PVSData ended while reading {v117}`));
            end;

            local buffer_readf32_ret7 = buffer.readf32(buffer_fromstring_ret, u86);

            if buffer_readf32_ret7 ~= buffer_readf32_ret7 or (buffer_readf32_ret7 == (1 / 0) or buffer_readf32_ret7 == (-1 / 0)) then
                error((`PVSData contains non-finite {v117}`));
            end;

            u86 = u86 + 4;
            local v118 = `region {i} maximum Z`;

            if u87 - u86 < 4 then
                error((`PVSData ended while reading {v118}`));
            end;

            local buffer_readf32_ret8 = buffer.readf32(buffer_fromstring_ret, u86);

            if buffer_readf32_ret8 ~= buffer_readf32_ret8 or (buffer_readf32_ret8 == (1 / 0) or buffer_readf32_ret8 == (-1 / 0)) then
                error((`PVSData contains non-finite {v118}`));
            end;

            u86 = u86 + 4;
            v111.maximum = Vector3.new(buffer_readf32_ret6, buffer_readf32_ret7, buffer_readf32_ret8);
            table_create_ret2[i] = v111;
            local _ = i;
        end;
    else
        for i, v in ipairs(table_create_ret) do
            table_create_ret2[i] = u1.regionFromCell(v, i);
        end;
    end;

    local v119 = buffer_readu16_ret * buffer_readu16_ret2;

    if u87 - u86 < v119 then
        error("PVSData ended while reading visibility rows");
    end;

    local v120 = {
        cells = table_create_ret,
        regions = table_create_ret2,
        rowStride = buffer_readu16_ret2,
        visibleBytes = buffer.readstring(buffer_fromstring_ret, u86, v119),
        maxDistance = buffer_readf32_ret,
        nearDistance = buffer_readf32_ret2,
        raysPerPair = buffer_readu8_ret
    };
    validateData(v120, p84);
    attachRegionsToCells(v120);

    return v120;
end;

return table.freeze(u1);