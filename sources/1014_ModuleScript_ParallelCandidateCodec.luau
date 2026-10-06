-- Decompiled with Potassium's decompiler.

local u1 = {
    STATUS_INCONCLUSIVE = 0,
    STATUS_PROVED = 1,
    STATUS_ERROR = 2,
    STATUS_PROVED_FALLBACK = 3,
    PAIR_KIND_PRIMARY = 0,
    PAIR_KIND_FALLBACK = 1
};

local function checkedCount(p2: table, p3: string) -- Line: 40
    local v4 = #p2;

    if v4 > 255 then
        error((`parallel certificate {p3} count exceeds {255}`));
    end;

    return v4;
end;

local function checkedNumericCount(p5: number) -- Line: 48
    if p5 < 0 or (p5 > 255 or p5 ~= math.floor(p5)) then
        error("parallel certificate job count is invalid");
    end;

    return p5;
end;

local function checkedVolumeCount(p6: table?, p7: string) -- Line: 55
    if p6 == nil then
        return 0;
    end;

    local v8 = #p6;

    if v8 > 255 then
        error((`parallel certificate {p7} count exceeds {255}`));
    end;

    for _, v in p6 do
        if #v ~= 8 then
            error((`parallel certificate {p7} must contain eight box vertices`));
        end;
    end;

    return v8;
end;

local function jobDataSizeFromCounts(p9: number, p10: number, p11: number, p12: number) -- Line: 68
    return (p9 + p10) * 2 + (p11 + p12) * 12;
end;

local function jobDataSize(p13: table) -- Line: 77
    -- upvalues: checkedVolumeCount (copy)
    local v14 = #p13.viewerCells;

    if v14 > 255 then
        error((`parallel certificate viewer cell count exceeds {255}`));
    end;

    local v15 = #p13.targetCells;

    if v15 > 255 then
        error((`parallel certificate target cell count exceeds {255}`));
    end;

    local v16 = #p13.viewerOrigins;

    if v16 > 255 then
        error((`parallel certificate viewer origin count exceeds {255}`));
    end;

    local v17 = #p13.targetPoints;

    if v17 > 255 then
        error((`parallel certificate target point count exceeds {255}`));
    end;

    return (v14 + v15) * 2 + (v16 + v17) * 12 + (checkedVolumeCount(p13.fallbackViewerVolumes, "fallback viewer volume") + checkedVolumeCount(p13.fallbackTargetVolumes, "fallback target volume")) * 8 * 12;
end;

local function writeVector(p18: buffer, p19: number, p20: vector) -- Line: 89
    buffer.writef32(p18, p19, p20.X);
    buffer.writef32(p18, p19 + 4, p20.Y);
    buffer.writef32(p18, p19 + 8, p20.Z);
end;

function u1.jobSize(p21: number, p22: number, p23: number, p24: number, p25: number?, p26: number?) -- Line: 95
    if p21 < 0 or (p21 > 255 or p21 ~= math.floor(p21)) then
        error("parallel certificate job count is invalid");
    end;

    if p22 < 0 or (p22 > 255 or p22 ~= math.floor(p22)) then
        error("parallel certificate job count is invalid");
    end;

    if p23 < 0 or (p23 > 255 or p23 ~= math.floor(p23)) then
        error("parallel certificate job count is invalid");
    end;

    if p24 < 0 or (p24 > 255 or p24 ~= math.floor(p24)) then
        error("parallel certificate job count is invalid");
    end;

    local v27 = p25 or 0;

    if v27 < 0 or (v27 > 255 or v27 ~= math.floor(v27)) then
        error("parallel certificate job count is invalid");
    end;

    local v28 = p26 or 0;

    if v28 < 0 or (v28 > 255 or v28 ~= math.floor(v28)) then
        error("parallel certificate job count is invalid");
    end;

    return (p21 + p22) * 2 + (p23 + p24) * 12 + 16 + (v27 + v28) * 8 * 12;
end;

function u1.createJobBatch(p29: number, p30: number, p31: number, p32: number) -- Line: 114
    if p31 < 0 or (p31 > 65535 or p31 ~= math.floor(p31)) then
        error("parallel certificate batch job count is invalid");
    end;

    if p32 < 0 or p32 ~= math.floor(p32) then
        error("parallel certificate batch byte count is invalid");
    end;

    local buffer_create_ret = buffer.create(p32 + 16);
    buffer.writeu32(buffer_create_ret, 0, 826494790);
    buffer.writeu16(buffer_create_ret, 4, 2);
    buffer.writeu16(buffer_create_ret, 6, p31);
    buffer.writeu32(buffer_create_ret, 8, p29);
    buffer.writeu32(buffer_create_ret, 12, p30);

    return buffer_create_ret;
end;

function u1.writeJob(p33: buffer, p34: number, p35: number, p36: number?, p37: table, p38: table, p39: table, p40: table, p41: table?, p42: table?) -- Line: 135
    -- upvalues: checkedVolumeCount (copy)
    local v43 = #p37;

    if v43 > 255 then
        error((`parallel certificate viewer cell count exceeds {255}`));
    end;

    local v44 = #p38;

    if v44 > 255 then
        error((`parallel certificate target cell count exceeds {255}`));
    end;

    local v45 = #p39;

    if v45 > 255 then
        error((`parallel certificate viewer origin count exceeds {255}`));
    end;

    local v46 = #p40;

    if v46 > 255 then
        error((`parallel certificate target point count exceeds {255}`));
    end;

    local v47 = checkedVolumeCount(p41, "fallback viewer volume");
    local v48 = checkedVolumeCount(p42, "fallback target volume");
    local v49 = (v43 + v44) * 2 + (v45 + v46) * 12 + (v47 + v48) * 8 * 12;

    if p34 < 16 or p34 + 16 + v49 > buffer.len(p33) then
        error("parallel certificate job write exceeds its batch");
    end;

    buffer.writeu32(p33, p34, p35);
    buffer.writeu16(p33, p34 + 4, p36 or 0);
    buffer.writeu8(p33, p34 + 6, v43);
    buffer.writeu8(p33, p34 + 7, v44);
    buffer.writeu8(p33, p34 + 8, v45);
    buffer.writeu8(p33, p34 + 9, v46);
    buffer.writeu16(p33, p34 + 10, v49);
    local bit32_lshift_ret = bit32.lshift(v48, 8);
    local bit32_bor_ret = bit32.bor(v47, bit32_lshift_ret);
    buffer.writeu32(p33, p34 + 12, bit32_bor_ret);
    local v50 = p34 + 16;

    for _, v in p37 do
        buffer.writeu16(p33, v50, v);
        v50 = v50 + 2;
    end;

    for _, v in p38 do
        buffer.writeu16(p33, v50, v);
        v50 = v50 + 2;
    end;

    for _, v in p39 do
        buffer.writef32(p33, v50, v.X);
        buffer.writef32(p33, v50 + 4, v.Y);
        buffer.writef32(p33, v50 + 8, v.Z);
        v50 = v50 + 12;
    end;

    for _, v in p40 do
        buffer.writef32(p33, v50, v.X);
        buffer.writef32(p33, v50 + 4, v.Y);
        buffer.writef32(p33, v50 + 8, v.Z);
        v50 = v50 + 12;
    end;

    for _, v in p41 or {} do
        for _, v2 in v do
            buffer.writef32(p33, v50, v2.X);
            buffer.writef32(p33, v50 + 4, v2.Y);
            buffer.writef32(p33, v50 + 8, v2.Z);
            v50 = v50 + 12;
        end;
    end;

    for _, v in p42 or {} do
        for _, v2 in v do
            buffer.writef32(p33, v50, v2.X);
            buffer.writef32(p33, v50 + 4, v2.Y);
            buffer.writef32(p33, v50 + 8, v2.Z);
            v50 = v50 + 12;
        end;
    end;

    return v50;
end;

function u1.encodeBatch(p51: number, p52: number, p53: table) -- Line: 198
    -- upvalues: jobDataSize (copy), u1 (copy)
    if #p53 > 65535 then
        error("parallel certificate batch exceeds 65535 jobs");
    end;

    local v54 = 0;

    for _, v in p53 do
        v54 = v54 + (jobDataSize(v) + 16);
    end;

    local v55 = u1.createJobBatch(p51, p52, #p53, v54);
    local v56 = 16;

    for _, v in p53 do
        v56 = u1.writeJob(v55, v56, v.jobId, v.preferredPlane, v.viewerCells, v.targetCells, v.viewerOrigins, v.targetPoints, v.fallbackViewerVolumes, v.fallbackTargetVolumes);
    end;

    local v57 = v56 == buffer.len(v55);
    assert(v57, "parallel certificate encoder size drift");

    return v55;
end;

function u1.readBatchHeader(p58: buffer) -- Line: 226
    if buffer.len(p58) < 16 or buffer.readu32(p58, 0) ~= 826494790 then
        error("parallel certificate job magic is invalid");
    end;

    if buffer.readu16(p58, 4) ~= 2 then
        error("parallel certificate job version is unsupported");
    end;

    return buffer.readu32(p58, 8), buffer.readu32(p58, 12), buffer.readu16(p58, 6);
end;

function u1.readJob(p59: buffer, p60: number) -- Line: 237
    if p60 < 16 or p60 + 16 > buffer.len(p59) then
        error("parallel certificate job header is truncated");
    end;

    local buffer_readu32_ret = buffer.readu32(p59, p60);
    local buffer_readu16_ret = buffer.readu16(p59, p60 + 4);
    local buffer_readu8_ret = buffer.readu8(p59, p60 + 6);
    local buffer_readu8_ret2 = buffer.readu8(p59, p60 + 7);
    local buffer_readu8_ret3 = buffer.readu8(p59, p60 + 8);
    local buffer_readu8_ret4 = buffer.readu8(p59, p60 + 9);
    local buffer_readu16_ret2 = buffer.readu16(p59, p60 + 10);
    local buffer_readu32_ret2 = buffer.readu32(p59, p60 + 12);

    if bit32.band(buffer_readu32_ret2, 4294901760) ~= 0 then
        error("parallel certificate fallback metadata is malformed");
    end;

    local bit32_band_ret = bit32.band(buffer_readu32_ret2, 255);
    local bit32_rshift_ret = bit32.rshift(buffer_readu32_ret2, 8);
    local bit32_band_ret2 = bit32.band(bit32_rshift_ret, 255);
    local v61 = p60 + 16;
    local v62 = (buffer_readu8_ret + buffer_readu8_ret2) * 2 + (buffer_readu8_ret3 + buffer_readu8_ret4) * 12 + (bit32_band_ret + bit32_band_ret2) * 8 * 12;

    if buffer_readu16_ret2 ~= v62 or v61 + v62 > buffer.len(p59) then
        error("parallel certificate job payload is malformed");
    end;

    local v63 = v61 + buffer_readu8_ret * 2;
    local v64 = v63 + buffer_readu8_ret2 * 2;
    local v65 = v64 + buffer_readu8_ret3 * 12;
    local v66 = v65 + buffer_readu8_ret4 * 12;
    local v67 = v66 + bit32_band_ret * 8 * 12;

    if buffer_readu16_ret == 0 then
        buffer_readu16_ret = nil;
    end;

    return buffer_readu32_ret, buffer_readu16_ret, v61, buffer_readu8_ret, v63, buffer_readu8_ret2, v64, buffer_readu8_ret3, v65, buffer_readu8_ret4, v66, bit32_band_ret, v67, bit32_band_ret2, v67 + bit32_band_ret2 * 8 * 12;
end;

local function actorDataSizeFromCounts(p68: number, p69: number, p70: number, p71: number, p72: number) -- Line: 305
    return p68 * 2 + (p69 + p70) * 12 + (p71 + p72) * 8 * 12;
end;

function u1.actorRecordSize(p73: number, p74: number, p75: number, p76: number?, p77: number?) -- Line: 317
    if p73 < 0 or (p73 > 255 or p73 ~= math.floor(p73)) then
        error("parallel certificate job count is invalid");
    end;

    if p74 < 0 or (p74 > 255 or p74 ~= math.floor(p74)) then
        error("parallel certificate job count is invalid");
    end;

    if p75 < 0 or (p75 > 255 or p75 ~= math.floor(p75)) then
        error("parallel certificate job count is invalid");
    end;

    local v78 = p76 or 0;

    if v78 < 0 or (v78 > 255 or v78 ~= math.floor(v78)) then
        error("parallel certificate job count is invalid");
    end;

    local v79 = p77 or 0;

    if v79 < 0 or (v79 > 255 or v79 ~= math.floor(v79)) then
        error("parallel certificate job count is invalid");
    end;

    return p73 * 2 + (p74 + p75) * 12 + (v78 + v79) * 8 * 12 + 12;
end;

function u1.createActorBatch(p80: number, p81: number, p82: number, p83: number, p84: number) -- Line: 333
    if p82 < 0 or (p82 > 64 or p82 ~= math.floor(p82)) then
        error((`parallel certificate actor count must be between 0 and {64}`));
    end;

    if p83 < 0 or (p83 > 65535 or p83 ~= math.floor(p83)) then
        error("parallel certificate actor-pair count is invalid");
    end;

    if p84 < 0 or p84 ~= math.floor(p84) then
        error("parallel certificate actor byte count is invalid");
    end;

    local buffer_create_ret = buffer.create(p84 + 24 + p83 * 12);
    buffer.writeu32(buffer_create_ret, 0, 826363718);
    buffer.writeu16(buffer_create_ret, 4, 1);
    buffer.writeu16(buffer_create_ret, 6, p82);
    buffer.writeu16(buffer_create_ret, 8, p83);
    buffer.writeu16(buffer_create_ret, 10, 0);
    buffer.writeu32(buffer_create_ret, 12, p80);
    buffer.writeu32(buffer_create_ret, 16, p81);
    buffer.writeu32(buffer_create_ret, 20, p84);

    return buffer_create_ret;
end;

function u1.writeActor(p85: buffer, p86: number, p87: table, p88: table, p89: table, p90: table?, p91: table?) -- Line: 361
    -- upvalues: checkedVolumeCount (copy)
    local v92 = #p87;

    if v92 > 255 then
        error((`parallel certificate actor cell count exceeds {255}`));
    end;

    local v93 = #p88;

    if v93 > 255 then
        error((`parallel certificate actor viewer point count exceeds {255}`));
    end;

    local v94 = #p89;

    if v94 > 255 then
        error((`parallel certificate actor target point count exceeds {255}`));
    end;

    local v95 = checkedVolumeCount(p90, "actor fallback viewer volume");
    local v96 = checkedVolumeCount(p91, "actor fallback target volume");
    local v97 = v92 * 2 + (v93 + v94) * 12 + (v95 + v96) * 8 * 12;

    if p86 < 24 or p86 + 12 + v97 > buffer.len(p85) then
        error("parallel certificate actor write exceeds its batch");
    end;

    buffer.writeu8(p85, p86, v92);
    buffer.writeu8(p85, p86 + 1, v93);
    buffer.writeu8(p85, p86 + 2, v94);
    buffer.writeu8(p85, p86 + 3, v95);
    buffer.writeu8(p85, p86 + 4, v96);
    buffer.writeu8(p85, p86 + 5, 0);
    buffer.writeu16(p85, p86 + 6, 0);
    buffer.writeu32(p85, p86 + 8, v97);
    local v98 = p86 + 12;

    for _, v in p87 do
        buffer.writeu16(p85, v98, v);
        v98 = v98 + 2;
    end;

    for _, v in p88 do
        buffer.writef32(p85, v98, v.X);
        buffer.writef32(p85, v98 + 4, v.Y);
        buffer.writef32(p85, v98 + 8, v.Z);
        v98 = v98 + 12;
    end;

    for _, v in p89 do
        buffer.writef32(p85, v98, v.X);
        buffer.writef32(p85, v98 + 4, v.Y);
        buffer.writef32(p85, v98 + 8, v.Z);
        v98 = v98 + 12;
    end;

    for _, v in p90 or {} do
        for _, v2 in v do
            buffer.writef32(p85, v98, v2.X);
            buffer.writef32(p85, v98 + 4, v2.Y);
            buffer.writef32(p85, v98 + 8, v2.Z);
            v98 = v98 + 12;
        end;
    end;

    for _, v in p91 or {} do
        for _, v2 in v do
            buffer.writef32(p85, v98, v2.X);
            buffer.writef32(p85, v98 + 4, v2.Y);
            buffer.writef32(p85, v98 + 8, v2.Z);
            v98 = v98 + 12;
        end;
    end;

    return v98;
end;

function u1.writeActorPair(p99: buffer, p100: number, p101: number, p102: number, p103: number, p104: number, p105: number?) -- Line: 416
    -- upvalues: u1 (copy)
    if p102 < 1 or (p102 > 64 or (p103 < 1 or p103 > 64)) then
        error("parallel certificate actor-pair index is invalid");
    end;

    if p104 ~= u1.PAIR_KIND_PRIMARY and p104 ~= u1.PAIR_KIND_FALLBACK then
        error("parallel certificate actor-pair kind is invalid");
    end;

    if p100 < 24 or p100 + 12 > buffer.len(p99) then
        error("parallel certificate actor-pair write exceeds its batch");
    end;

    buffer.writeu32(p99, p100, p101);
    buffer.writeu16(p99, p100 + 4, p105 or 0);
    buffer.writeu8(p99, p100 + 6, p102 - 1);
    buffer.writeu8(p99, p100 + 7, p103 - 1);
    buffer.writeu8(p99, p100 + 8, p104);
    buffer.writeu8(p99, p100 + 9, 0);
    buffer.writeu16(p99, p100 + 10, 0);

    return p100 + 12;
end;

function u1.readActorBatchHeader(p106: buffer) -- Line: 452
    if buffer.len(p106) < 24 or buffer.readu32(p106, 0) ~= 826363718 then
        error("parallel certificate actor-batch magic is invalid");
    end;

    if buffer.readu16(p106, 4) ~= 1 then
        error("parallel certificate actor-batch version is unsupported");
    end;

    local buffer_readu16_ret = buffer.readu16(p106, 6);
    local buffer_readu16_ret2 = buffer.readu16(p106, 8);
    local buffer_readu32_ret = buffer.readu32(p106, 20);
    local v107 = buffer_readu32_ret + 24;

    if buffer_readu16_ret > 64 or v107 + buffer_readu16_ret2 * 12 ~= buffer.len(p106) then
        error("parallel certificate actor-batch size is invalid");
    end;

    return buffer.readu32(p106, 12), buffer.readu32(p106, 16), buffer_readu16_ret, buffer_readu16_ret2, buffer_readu32_ret, v107;
end;

function u1.readActor(p108: buffer, p109: number) -- Line: 469
    if p109 < 24 or p109 + 12 > buffer.len(p108) then
        error("parallel certificate actor header is truncated");
    end;

    local buffer_readu8_ret = buffer.readu8(p108, p109);
    local buffer_readu8_ret2 = buffer.readu8(p108, p109 + 1);
    local buffer_readu8_ret3 = buffer.readu8(p108, p109 + 2);
    local buffer_readu8_ret4 = buffer.readu8(p108, p109 + 3);
    local buffer_readu8_ret5 = buffer.readu8(p108, p109 + 4);
    local buffer_readu32_ret = buffer.readu32(p108, p109 + 8);
    local v110 = p109 + 12;

    if buffer_readu32_ret ~= buffer_readu8_ret * 2 + (buffer_readu8_ret2 + buffer_readu8_ret3) * 12 + (buffer_readu8_ret4 + buffer_readu8_ret5) * 8 * 12 or v110 + buffer_readu32_ret > buffer.len(p108) then
        error("parallel certificate actor payload is malformed");
    end;

    local v111 = v110 + buffer_readu8_ret * 2;
    local v112 = v111 + buffer_readu8_ret2 * 12;
    local v113 = v112 + buffer_readu8_ret3 * 12;
    local v114 = v113 + buffer_readu8_ret4 * 8 * 12;

    return v110, buffer_readu8_ret, v111, buffer_readu8_ret2, v112, buffer_readu8_ret3, v113, buffer_readu8_ret4, v114, buffer_readu8_ret5, v114 + buffer_readu8_ret5 * 8 * 12;
end;

function u1.readActorPair(p115: buffer, p116: number, p117: number) -- Line: 518
    local v118 = p116 + (p117 - 1) * 12;

    if p117 < 1 or v118 + 12 > buffer.len(p115) then
        error("parallel certificate actor-pair index is out of range");
    end;

    local buffer_readu16_ret = buffer.readu16(p115, v118 + 4);
    local buffer_readu32_ret = buffer.readu32(p115, v118);
    local v119 = buffer.readu8(p115, v118 + 6) + 1;
    local v120 = buffer.readu8(p115, v118 + 7) + 1;
    local buffer_readu8_ret = buffer.readu8(p115, v118 + 8);

    if buffer_readu16_ret == 0 then
        return buffer_readu32_ret, v119, v120, buffer_readu8_ret, nil;
    end;

    return buffer_readu32_ret, v119, v120, buffer_readu8_ret, buffer_readu16_ret;
end;

function u1.createResultBatch(p121: number, p122: number, p123: number) -- Line: 535
    if p123 < 0 or p123 > 65535 then
        error("parallel certificate result count is invalid");
    end;

    local buffer_create_ret = buffer.create(p123 * 12 + 16);
    buffer.writeu32(buffer_create_ret, 0, 827477830);
    buffer.writeu16(buffer_create_ret, 4, 2);
    buffer.writeu16(buffer_create_ret, 6, p123);
    buffer.writeu32(buffer_create_ret, 8, p121);
    buffer.writeu32(buffer_create_ret, 12, p122);

    return buffer_create_ret;
end;

function u1.writeResult(p124: buffer, p125: number, p126: number, p127: number, p128: number?, p129: number) -- Line: 548
    local v130 = (p125 - 1) * 12 + 16;

    if p125 < 1 or v130 + 12 > buffer.len(p124) then
        error("parallel certificate result index is out of range");
    end;

    buffer.writeu32(p124, v130, p126);
    buffer.writeu16(p124, v130 + 4, p128 or 0);
    local math_floor_ret = math.floor(p129);
    local math_clamp_ret = math.clamp(math_floor_ret, 0, 65535);
    buffer.writeu16(p124, v130 + 6, math_clamp_ret);
    buffer.writeu8(p124, v130 + 8, p127);
end;

function u1.readResultHeader(p131: buffer) -- Line: 566
    if buffer.len(p131) < 16 or buffer.readu32(p131, 0) ~= 827477830 then
        error("parallel certificate result magic is invalid");
    end;

    if buffer.readu16(p131, 4) ~= 2 then
        error("parallel certificate result version is unsupported");
    end;

    local buffer_readu16_ret = buffer.readu16(p131, 6);

    if buffer.len(p131) ~= buffer_readu16_ret * 12 + 16 then
        error("parallel certificate result size is invalid");
    end;

    return buffer.readu32(p131, 8), buffer.readu32(p131, 12), buffer_readu16_ret;
end;

function u1.readResult(p132: buffer, p133: number) -- Line: 580
    local v134 = (p133 - 1) * 12 + 16;

    if p133 < 1 or v134 + 12 > buffer.len(p132) then
        error("parallel certificate result index is out of range");
    end;

    local buffer_readu16_ret = buffer.readu16(p132, v134 + 4);
    local buffer_readu32_ret = buffer.readu32(p132, v134);
    local buffer_readu8_ret = buffer.readu8(p132, v134 + 8);

    if buffer_readu16_ret == 0 then
        buffer_readu16_ret = nil;
    end;

    return buffer_readu32_ret, buffer_readu8_ret, buffer_readu16_ret, buffer.readu16(p132, v134 + 6);
end;

u1.HEADER_SIZE = 16;
u1.JOB_HEADER_SIZE = 16;
u1.RESULT_SIZE = 12;
u1.VECTOR_SIZE = 12;
u1.MAX_ACTORS = 64;
u1.ACTOR_HEADER_SIZE = 24;
u1.ACTOR_RECORD_HEADER_SIZE = 12;
u1.ACTOR_PAIR_SIZE = 12;

return table.freeze(u1);