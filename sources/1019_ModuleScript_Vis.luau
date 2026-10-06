-- Decompiled with Potassium's decompiler.

local Winding = require(script.Parent:WaitForChild("Winding"));
local v29 = {
    bsSet = function(p1, p2) -- Line: 11, Name: bsSet
        local v3 = (p2 - 1) // 32 * 4;
        local buffer_readu32_ret = buffer.readu32(p1, v3);
        local bit32_lshift_ret = bit32.lshift(1, (p2 - 1) % 32);
        local bit32_bor_ret = bit32.bor(buffer_readu32_ret, bit32_lshift_ret);
        buffer.writeu32(p1, v3, bit32_bor_ret);
    end,

    bsTest = function(p4, p5) -- Line: 16, Name: bsTest
        local buffer_readu32_ret = buffer.readu32(p4, (p5 - 1) // 32 * 4);
        local bit32_lshift_ret = bit32.lshift(1, (p5 - 1) % 32);

        return bit32.band(buffer_readu32_ret, bit32_lshift_ret) ~= 0;
    end,

    bsCount = function(p6) -- Line: 21, Name: bsCount
        local v7 = 0;

        for i = 0, buffer.len(p6) - 4, 4 do
            local buffer_readu32_ret = buffer.readu32(p6, i);
            local _ = i;

            while buffer_readu32_ret ~= 0 do
                buffer_readu32_ret = bit32.band(buffer_readu32_ret, buffer_readu32_ret - 1);
                v7 = v7 + 1;
            end;
        end;

        return v7;
    end,

    prepare = function(p8, p9, p10) -- Line: 36, Name: prepare
        -- upvalues: Winding (copy)
        local v11 = {};

        for _, v in p9 do
            if v.air then
                v11[#v11 + 1] = v;
                v.airIndex = #v11;
            end;
        end;

        local u12 = {};
        local u13 = {};

        for i = 1, #v11 do
            u12[i] = {};
            local _ = i;
        end;

        local function add(p14, p15, p16, p17, p18, p19, p20) -- Line: 49
            -- upvalues: Winding (ref), u13 (copy), u12 (copy)
            local v21, v22, v23, v24, v25, v26 = Winding.bounds(p20);
            local v27 = {
                done = false,
                id = #u13 + 1,
                from = p14.airIndex,
                leaf = p15.airIndex,
                nx = p16,
                ny = p17,
                nz = p18,
                d = p19,
                w = p20,
                minX = v21,
                minY = v22,
                minZ = v23,
                maxX = v24,
                maxY = v25,
                maxZ = v26
            };
            u13[v27.id] = v27;
            local v28 = u12[p14.airIndex];
            v28[#v28 + 1] = v27;
        end;

        for i, v in p8 do
            if p10 ~= nil and i % 32 == 0 then
                p10();
            end;

            local plane = v.plane;
            add(v.front, v.back, -plane[1], -plane[2], -plane[3], -plane[4], v.w);
            add(v.back, v.front, plane[1], plane[2], plane[3], plane[4], v.w);
        end;

        return {
            portals = u13,
            leafPortals = u12,
            airLeaves = v11,
            leafWords = (#v11 + 31) // 32
        };
    end
};

local function boxRange(p30, p31, p32, p33, p34) -- Line: 84
    local v35;

    if p31 > 0 then
        v35 = p30.minX;
    else
        v35 = p30.maxX;
    end;

    local v36;

    if p32 > 0 then
        v36 = p30.minY;
    else
        v36 = p30.maxY;
    end;

    local v37;

    if p33 > 0 then
        v37 = p30.minZ;
    else
        v37 = p30.maxZ;
    end;

    local v38;

    if p31 > 0 then
        v38 = p30.maxX;
    else
        v38 = p30.minX;
    end;

    local v39;

    if p32 > 0 then
        v39 = p30.maxY;
    else
        v39 = p30.minY;
    end;

    local v40;

    if p33 > 0 then
        v40 = p30.maxZ;
    else
        v40 = p30.minZ;
    end;

    return v35 * p31 + v36 * p32 + v37 * p33 - p34, v38 * p31 + v39 * p32 + v40 * p33 - p34;
end;

function v29.basePortalVis(p41, p42, p43, p44, p45) -- Line: 97
    -- upvalues: boxRange (copy), Winding (copy)
    local portals = p41.portals;
    local v46 = #portals;
    local v47 = (v46 + 31) // 32;
    p41.portalWords = v47;

    for i = p43 or 1, p44 or v46 do
        local v48 = portals[i];

        if p45 ~= nil then
            p45();
        end;

        local buffer_create_ret = buffer.create(v47 * 4);
        local nx = v48.nx;
        local ny = v48.ny;
        local nz = v48.nz;
        local d = v48.d;
        local v49 = i;

        for i2, v in portals do
            if i2 ~= v49 then
                local _, v50 = boxRange(v, nx, ny, nz, d);

                if v50 > 0.05 then
                    local _, v51 = Winding.range(v.w, nx, ny, nz, d);

                    if v51 > 0.05 and (boxRange(v48, v.nx, v.ny, v.nz, v.d) < -0.05 and Winding.range(v48.w, v.nx, v.ny, v.nz, v.d) < -0.05) then
                        local v52 = (i2 - 1) // 32 * 4;
                        local buffer_readu32_ret = buffer.readu32(buffer_create_ret, v52);
                        local bit32_lshift_ret = bit32.lshift(1, (i2 - 1) % 32);
                        local bit32_bor_ret = bit32.bor(buffer_readu32_ret, bit32_lshift_ret);
                        buffer.writeu32(buffer_create_ret, v52, bit32_bor_ret);
                    end;
                end;
            end;
        end;

        v48.front = buffer_create_ret;

        if p42 ~= nil and v49 % 1000 == 0 then
            p42(v49, v46);
        end;
    end;
end;

function v29.simpleFlood(p53, p54) -- Line: 139
    local leafWords = p53.leafWords;
    local leafPortals = p53.leafPortals;
    local v55 = 0;

    for i, v in p53.portals do
        if p54 ~= nil and i % 8 == 0 then
            p54();
        end;

        local buffer_create_ret = buffer.create(leafWords * 4);
        local v56 = { v.leaf };
        local v57 = v;
        local v58 = 0;

        while #v56 > 0 do
            local table_remove_ret = table.remove(v56);
            local buffer_readu32_ret = buffer.readu32(buffer_create_ret, (table_remove_ret - 1) // 32 * 4);
            local bit32_lshift_ret = bit32.lshift(1, (table_remove_ret - 1) % 32);

            if bit32.band(buffer_readu32_ret, bit32_lshift_ret) == 0 then
                local v59 = (table_remove_ret - 1) // 32 * 4;
                local buffer_readu32_ret2 = buffer.readu32(buffer_create_ret, v59);
                local bit32_lshift_ret2 = bit32.lshift(1, (table_remove_ret - 1) % 32);
                local bit32_bor_ret = bit32.bor(buffer_readu32_ret2, bit32_lshift_ret2);
                buffer.writeu32(buffer_create_ret, v59, bit32_bor_ret);
                v58 = v58 + 1;

                for _, v2 in leafPortals[table_remove_ret] do
                    local id = v2.id;
                    local buffer_readu32_ret3 = buffer.readu32(v57.front, (id - 1) // 32 * 4);
                    local bit32_lshift_ret3 = bit32.lshift(1, (id - 1) % 32);

                    if bit32.band(buffer_readu32_ret3, bit32_lshift_ret3) ~= 0 then
                        local leaf = v2.leaf;
                        local buffer_readu32_ret4 = buffer.readu32(buffer_create_ret, (leaf - 1) // 32 * 4);
                        local bit32_lshift_ret4 = bit32.lshift(1, (leaf - 1) % 32);

                        if bit32.band(buffer_readu32_ret4, bit32_lshift_ret4) == 0 then
                            v56[#v56 + 1] = v2.leaf;
                        end;
                    end;
                end;
            end;
        end;

        v57.mightsee = buffer_create_ret;
        v57.numMightsee = v58;
        v55 = v55 + v58;
    end;

    return v55 / #p53.portals;
end;

local function clipToSeparators(p60, p61, p62, p63) -- Line: 170
    -- upvalues: Winding (copy)
    local v64 = #p60 // 3;
    local v65 = #p61 // 3;

    for i = 1, v64 do
        local v66 = i % v64 + 1;
        local v67 = p60[i * 3 - 2];
        local v68 = p60[i * 3 - 1];
        local v69 = p60[i * 3];
        local v70 = p60[v66 * 3 - 2] - v67;
        local v71 = p60[v66 * 3 - 1] - v68;
        local v72 = p60[v66 * 3] - v69;
        local v73 = i;

        for i2 = 1, v65 do
            local v74 = p61[i2 * 3 - 2];
            local v75 = p61[i2 * 3 - 1];
            local v76 = p61[i2 * 3];
            local v77 = v74 - v67;
            local v78 = v75 - v68;
            local v79 = v76 - v69;
            local v80 = v71 * v79 - v72 * v78;
            local v81 = v72 * v77 - v70 * v79;
            local v82 = v70 * v78 - v71 * v77;
            local math_sqrt_ret = math.sqrt(v80 * v80 + v81 * v81 + v82 * v82);
            local v83;

            if math_sqrt_ret < 0.05 then
                v83 = i2;
            else
                local v84 = v80 / math_sqrt_ret;
                local v85 = v81 / math_sqrt_ret;
                local v86 = v82 / math_sqrt_ret;
                local v87 = v74 * v84 + v75 * v85 + v76 * v86;
                v83 = i2;
                local v88 = nil;

                for i3 = 1, v64 do
                    local v89;

                    if i3 == v73 or i3 == v66 then
                        v89 = i3;
                    else
                        local v90 = p60[i3 * 3 - 2] * v84 + p60[i3 * 3 - 1] * v85 + p60[i3 * 3] * v86 - v87;

                        if v90 < -0.05 then
                            v88 = false;
                            break;
                        end;

                        if v90 > 0.05 then
                            v88 = true;
                            break;
                        end;

                        v89 = i3;
                    end;
                end;

                if v88 ~= nil then
                    if v88 then
                        v84 = -v84;
                        v85 = -v85;
                        v86 = -v86;
                        v87 = -v87;
                    end;

                    local v91 = true;
                    local v92 = 0;

                    for i3 = 1, v65 do
                        local v93;

                        if i3 == v83 then
                            v93 = i3;
                        else
                            local v94 = p61[i3 * 3 - 2] * v84 + p61[i3 * 3 - 1] * v85 + p61[i3 * 3] * v86 - v87;

                            if v94 < -0.05 then
                                v91 = false;
                                break;
                            end;

                            if v94 > 0.05 then
                                v92 = v92 + 1;
                                v93 = i3;
                            else
                                v93 = i3;
                            end;
                        end;
                    end;

                    if v91 and v92 ~= 0 then
                        if p63 then
                            v84 = -v84;
                            v85 = -v85;
                            v86 = -v86;
                            v87 = -v87;
                        end;

                        p62 = Winding.clip(p62, v84, v85, v86, v87, 0.05);

                        if p62 == nil then
                            return nil;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return p62;
end;

function v29.portalFlow(p95, p96, p97) -- Line: 236
    -- upvalues: Winding (copy), clipToSeparators (copy)
    local leafWords = p95.leafWords;
    local leafPortals = p95.leafPortals;
    local buffer_create_ret = buffer.create(leafWords * 4);
    local u98 = {
        pass = nil,
        portal = p96,
        source = p96.w,
        nx = p96.nx,
        ny = p96.ny,
        nz = p96.nz,
        d = p96.d,
        mightsee = p96.mightsee
    };
    local u99 = {
        portalTests = 0,
        portalPasses = 0,
        budgeted = false
    };
    local u100 = p97 or (1 / 0);

    local function flow(p101, p102) -- Line: 253
        -- upvalues: buffer_create_ret (ref), u99 (copy), u100 (copy), leafPortals (copy), leafWords (copy), Winding (ref), u98 (copy), flow (copy), clipToSeparators (ref)
        local v103 = buffer_create_ret;
        local v104 = (p101 - 1) // 32 * 4;
        local buffer_readu32_ret = buffer.readu32(v103, v104);
        local bit32_lshift_ret = bit32.lshift(1, (p101 - 1) % 32);
        local bit32_bor_ret = bit32.bor(buffer_readu32_ret, bit32_lshift_ret);
        buffer.writeu32(v103, v104, bit32_bor_ret);

        if u100 < u99.portalPasses then
            u99.budgeted = true;

            return;
        end;

        for _, v in leafPortals[p101] do
            if u99.budgeted then
                return;
            end;

            local leaf = v.leaf;
            local buffer_readu32_ret2 = buffer.readu32(p102.mightsee, (leaf - 1) // 32 * 4);
            local bit32_lshift_ret2 = bit32.lshift(1, (leaf - 1) % 32);

            if bit32.band(buffer_readu32_ret2, bit32_lshift_ret2) ~= 0 then
                local v105;

                if v.done then
                    v105 = v.leafvis;
                else
                    v105 = v.mightsee;
                end;

                local buffer_create_ret2 = buffer.create(leafWords * 4);
                local v106 = v;
                local v107 = false;

                for i = 0, leafWords * 4 - 4, 4 do
                    local buffer_readu32_ret3 = buffer.readu32(p102.mightsee, i);
                    local buffer_readu32_ret4 = buffer.readu32(v105, i);
                    local bit32_band_ret = bit32.band(buffer_readu32_ret3, buffer_readu32_ret4);
                    buffer.writeu32(buffer_create_ret2, i, bit32_band_ret);
                    local buffer_readu32_ret5 = buffer.readu32(buffer_create_ret, i);
                    local bit32_bnot_ret = bit32.bnot(buffer_readu32_ret5);
                    local v108;

                    if bit32.band(bit32_band_ret, bit32_bnot_ret) == 0 then
                        v108 = i;
                    else
                        v108 = i;
                        v107 = true;
                    end;
                end;

                if v107 and (v106.nx * p102.nx + v106.ny * p102.ny + v106.nz * p102.nz >= -0.9999 or math.abs(v106.d + p102.d) >= 0.05) then
                    local v109 = u99;
                    v109.portalTests = v109.portalTests + 1;
                    local v110 = Winding.clip(v106.w, u98.nx, u98.ny, u98.nz, u98.d, 0.05);

                    if v110 ~= nil then
                        local v111 = {
                            portal = v106,
                            nx = v106.nx,
                            ny = v106.ny,
                            nz = v106.nz,
                            d = v106.d,
                            mightsee = buffer_create_ret2
                        };

                        if p102.pass == nil then
                            v111.source = p102.source;
                            v111.pass = v110;
                            local v112 = u99;
                            v112.portalPasses = v112.portalPasses + 1;
                            flow(v106.leaf, v111);
                        else
                            local v113 = Winding.clip(v110, p102.nx, p102.ny, p102.nz, p102.d, 0.05);

                            if v113 ~= nil then
                                local v114 = Winding.clip(p102.source, -v106.nx, -v106.ny, -v106.nz, -v106.d, 0.05);

                                if v114 ~= nil then
                                    local v115 = clipToSeparators(v114, p102.pass, v113, false);

                                    if v115 ~= nil then
                                        local v116 = clipToSeparators(p102.pass, v114, v115, true);

                                        if v116 ~= nil then
                                            v111.source = v114;
                                            v111.pass = v116;
                                            local v117 = u99;
                                            v117.portalPasses = v117.portalPasses + 1;
                                            flow(v106.leaf, v111);
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    flow(p96.leaf, u98);

    if u99.budgeted then
        buffer_create_ret = buffer.create(leafWords * 4);
        buffer.copy(buffer_create_ret, 0, p96.mightsee);
    end;

    p96.leafvis = buffer_create_ret;
    p96.done = true;

    return u99;
end;

function v29.floodCells(u118, p119, p120, p121) -- Line: 331
    -- upvalues: Winding (copy), clipToSeparators (copy)
    local leafWords = u118.leafWords;
    local leafPortals = u118.leafPortals;
    local u122 = {};
    local u123 = {};
    local v124 = {};

    for i = 1, #u118.airLeaves do
        u122[i] = {};
        local _ = i;
    end;

    for _, v in p119 do
        local v125 = u122[v.leaf];
        v125[#v125 + 1] = v;

        if u123[v.cell] == nil then
            u123[v.cell] = {};
            v124[#v124 + 1] = v.cell;
        end;

        local v126 = u123[v.cell];
        v126[#v126 + 1] = v;
    end;

    table.sort(v124);
    local v127 = p120.shardIndex or 1;
    local v128 = p120.shardCount or 1;
    local u129 = p120.budget or (1 / 0);
    local u130 = p120.yieldEvery or 0;
    local yield = p120.yield;
    local v131;

    if p120.cells == nil then
        v131 = nil;
    else
        v131 = {};

        for _, v in p120.cells do
            v131[v] = true;
        end;
    end;

    local function coplanar(p132, p133, p134, p135, p136, p137, p138, p139) -- Line: 365
        local v140;

        if p132 * p136 + p133 * p137 + p134 * p138 > 0.9999 then
            v140 = math.abs(p135 - p139) < 0.05;
        else
            v140 = false;
        end;

        return v140;
    end;

    local u141 = {
        floods = 0,
        passes = 0,
        budgeted = 0,
        interior = 0
    };
    local v142 = {};

    for i, v in v124 do
        local u143, u144, u145, u146, v147, v148, v149, v150, v151, v152, u153, u154, v155, v156, v157, v158, v159, v160, v161, v162, v163, v164, v165, v166, v167, v168, v169, v170, v171, v172, v173, v174, v175, v176, v177, v178, v179, v180, v181, v182, v183, v184, v185, v186, v187;

        if v131 == nil then
            if (i - 1) % v128 == v127 - 1 then
                u143 = buffer.create(leafWords * 4);
                u144 = v;
                u145 = {};
                u146 = {
                    [v] = true
                };

                for i2 = 1, #u118.airLeaves do
                    v147 = i2;
                    v148 = 0;

                    for _, v2 in u122[i2] do
                        if v2.cell ~= u144 then
                            v148 = v148 + 1;
                        end;
                    end;

                    u145[v147] = v148;

                    if v148 > 0 then
                        v149 = (v147 - 1) // 32 * 4;
                        v150 = buffer.readu32(u143, v149);
                        v151 = bit32.lshift(1, (v147 - 1) % 32);
                        v152 = bit32.bor(v150, v151);
                        buffer.writeu32(u143, v149, v152);
                    end;
                end;

                u153 = function(p188) -- Line: 393, Name: mark
                    -- upvalues: u146 (copy), u118 (copy), u145 (copy), u122 (copy), u143 (copy)
                    if u146[p188.cell] then
                        return;
                    end;

                    u146[p188.cell] = true;

                    for i2 = 1, #u118.airLeaves do
                        local v189 = u145[i2];
                        local v190;

                        if v189 > 0 then
                            v190 = i2;
                            local v191 = 0;

                            for _, v2 in u122[i2] do
                                if v2.cell == p188.cell then
                                    v191 = v191 + 1;
                                end;
                            end;

                            if v191 > 0 then
                                u145[v190] = v189 - v191;

                                if v189 - v191 == 0 then
                                    local v192 = (v190 - 1) // 32 * 4;
                                    local buffer_readu32_ret = buffer.readu32(u143, v192);
                                    local bit32_lshift_ret = bit32.lshift(1, (v190 - 1) % 32);
                                    local bit32_bnot_ret = bit32.bnot(bit32_lshift_ret);
                                    local bit32_band_ret = bit32.band(buffer_readu32_ret, bit32_bnot_ret);
                                    buffer.writeu32(u143, v192, bit32_band_ret);
                                end;
                            end;
                        else
                            v190 = i2;
                        end;
                    end;
                end;

                u154 = function(p193, p194, p195) -- Line: 422, Name: reachable
                    -- upvalues: Winding (ref), clipToSeparators (ref)
                    for _, v2 in p193.faces do
                        local w = v2.w;
                        local _, v196 = Winding.range(w, p195.nx, p195.ny, p195.nz, p195.d);

                        if v196 > 0.05 then
                            if p194.pass == nil then
                                return true;
                            end;

                            local v197 = Winding.clip(w, p195.nx, p195.ny, p195.nz, p195.d, 0.05);

                            if v197 ~= nil then
                                local v198 = Winding.clip(v197, p194.nx, p194.ny, p194.nz, p194.d, 0.05);

                                if v198 ~= nil then
                                    local v199 = clipToSeparators(p194.source, p194.pass, v198, false);

                                    if v199 ~= nil and clipToSeparators(p194.pass, p194.source, v199, true) ~= nil then
                                        return true;
                                    end;
                                end;
                            end;
                        end;
                    end;

                    return false;
                end;

                v155 = function(p200, u201) -- Line: 452, Name: floodFace
                    -- upvalues: leafWords (copy), u122 (copy), u146 (copy), u154 (copy), u153 (copy), u129 (copy), leafPortals (copy), u143 (copy), Winding (ref), clipToSeparators (ref), u130 (copy), yield (copy), u141 (copy), u118 (copy)
                    local buffer_create_ret = buffer.create(leafWords * 4);
                    local u202 = {
                        passes = 0,
                        budgeted = false
                    };

                    local function u219(p203, p204) -- Line: 455
                        -- upvalues: buffer_create_ret (copy), u122 (ref), u146 (ref), u154 (ref), u201 (copy), u153 (ref), u202 (copy), u129 (ref), leafPortals (ref), leafWords (ref), u143 (ref), Winding (ref), u219 (copy), clipToSeparators (ref), u130 (ref), yield (ref)
                        local v205 = buffer_create_ret;
                        local v206 = (p203 - 1) // 32 * 4;
                        local buffer_readu32_ret = buffer.readu32(v205, v206);
                        local bit32_lshift_ret = bit32.lshift(1, (p203 - 1) % 32);
                        local bit32_bor_ret = bit32.bor(buffer_readu32_ret, bit32_lshift_ret);
                        buffer.writeu32(v205, v206, bit32_bor_ret);

                        for _, v2 in u122[p203] do
                            if not u146[v2.cell] and u154(v2, p204, u201) then
                                u153(v2);
                            end;
                        end;

                        if u129 < u202.passes then
                            u202.budgeted = true;

                            return;
                        end;

                        for _, v2 in leafPortals[p203] do
                            if u202.budgeted then
                                return;
                            end;

                            local leaf = v2.leaf;
                            local buffer_readu32_ret2 = buffer.readu32(p204.mightsee, (leaf - 1) // 32 * 4);
                            local bit32_lshift_ret2 = bit32.lshift(1, (leaf - 1) % 32);

                            if bit32.band(buffer_readu32_ret2, bit32_lshift_ret2) ~= 0 then
                                local v207;

                                if v2.done then
                                    v207 = v2.leafvis;
                                else
                                    v207 = v2.mightsee;
                                end;

                                local buffer_create_ret2 = buffer.create(leafWords * 4);
                                local v208 = v2;
                                local v209 = false;

                                for i2 = 0, leafWords * 4 - 4, 4 do
                                    local buffer_readu32_ret3 = buffer.readu32(p204.mightsee, i2);
                                    local buffer_readu32_ret4 = buffer.readu32(v207, i2);
                                    local bit32_band_ret = bit32.band(buffer_readu32_ret3, buffer_readu32_ret4);
                                    buffer.writeu32(buffer_create_ret2, i2, bit32_band_ret);
                                    local buffer_readu32_ret5 = buffer.readu32(buffer_create_ret, i2);
                                    local bit32_bnot_ret = bit32.bnot(buffer_readu32_ret5);
                                    local buffer_readu32_ret6 = buffer.readu32(u143, i2);
                                    local bit32_bor_ret2 = bit32.bor(bit32_bnot_ret, buffer_readu32_ret6);
                                    local v210;

                                    if bit32.band(bit32_band_ret, bit32_bor_ret2) == 0 then
                                        v210 = i2;
                                    else
                                        v210 = i2;
                                        v209 = true;
                                    end;
                                end;

                                if v209 and (v208.nx * p204.nx + v208.ny * p204.ny + v208.nz * p204.nz >= -0.9999 or math.abs(v208.d + p204.d) >= 0.05) then
                                    local v211 = Winding.clip(v208.w, u201.nx, u201.ny, u201.nz, u201.d, 0.05);

                                    if v211 ~= nil then
                                        local v212 = {
                                            portal = v208,
                                            nx = v208.nx,
                                            ny = v208.ny,
                                            nz = v208.nz,
                                            d = v208.d,
                                            mightsee = buffer_create_ret2
                                        };

                                        if p204.pass == nil then
                                            v212.source = p204.source;
                                            v212.pass = v211;
                                            local v213 = u202;
                                            v213.passes = v213.passes + 1;
                                            u219(v208.leaf, v212);
                                        else
                                            local v214 = Winding.clip(v211, p204.nx, p204.ny, p204.nz, p204.d, 0.05);

                                            if v214 ~= nil then
                                                local v215 = Winding.clip(p204.source, -v208.nx, -v208.ny, -v208.nz, -v208.d, 0.05);

                                                if v215 ~= nil then
                                                    local v216 = clipToSeparators(v215, p204.pass, v214, false);

                                                    if v216 ~= nil then
                                                        local v217 = clipToSeparators(p204.pass, v215, v216, true);

                                                        if v217 ~= nil then
                                                            v212.source = v215;
                                                            v212.pass = v217;
                                                            local v218 = u202;
                                                            v218.passes = v218.passes + 1;

                                                            if u130 > 0 and (u202.passes % u130 == 0 and yield ~= nil) then
                                                                yield();
                                                            end;

                                                            u219(v208.leaf, v212);
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;

                    u219(p200, u201);
                    local v220 = u141;
                    v220.floods = v220.floods + 1;
                    local v221 = u141;
                    v221.passes = v221.passes + u202.passes;

                    if u202.budgeted then
                        local v222 = u141;
                        v222.budgeted = v222.budgeted + 1;

                        for i2 = 1, #u118.airLeaves do
                            local buffer_readu32_ret = buffer.readu32(u201.mightsee, (i2 - 1) // 32 * 4);
                            local bit32_lshift_ret = bit32.lshift(1, (i2 - 1) % 32);
                            local v223;

                            if bit32.band(buffer_readu32_ret, bit32_lshift_ret) ~= 0 then
                                v223 = i2;

                                for _, v2 in u122[i2] do
                                    if not u146[v2.cell] then
                                        u153(v2);
                                    end;
                                end;
                            else
                                v223 = i2;
                            end;
                        end;
                    end;
                end;

                v156 = function(p224, p225) -- Line: 549, Name: interiorFace
                    -- upvalues: u123 (copy), u144 (copy), Winding (ref)
                    for _, v2 in u123[u144] do
                        if v2 ~= p225 then
                            for _, v3 in v2.faces do
                                if p224.nx * v3.nx + p224.ny * v3.ny + p224.nz * v3.nz <= -0.9999 and (math.abs(p224.d + v3.d) <= 0.01 and Winding.contains(v3.w, v3.nx, v3.ny, v3.nz, p224.w, 0.01)) then
                                    return true;
                                end;
                            end;
                        end;
                    end;

                    return false;
                end;

                for i2, v2 in u123[u144] do
                    v157 = v2;

                    for _, v3 in u122[v2.leaf] do
                        if not u146[v3.cell] then
                            u153(v3);
                        end;
                    end;

                    v158 = u118.airLeaves[v157.leaf];

                    for _, v3 in v157.faces do
                        if v156(v3, v157) then
                            u141.interior = u141.interior + 1;
                        else
                            v159 = v3;
                            v160 = {};

                            for _, v4 in leafPortals[v157.leaf] do
                                v161 = v159.nx;
                                v162 = v159.ny;
                                v163 = v159.nz;
                                v164 = v159.d;
                                v165 = v4.nx;
                                v166 = v4.ny;
                                v167 = v4.nz;
                                v168 = v4.d;

                                if v161 * v165 + v162 * v166 + v163 * v167 > 0.9999 then
                                    v169 = math.abs(v164 - v168) < 0.05;
                                else
                                    v169 = false;
                                end;

                                if v169 then
                                    v160[#v160 + 1] = v4;
                                end;
                            end;

                            v170 = false;

                            for _, v4 in v158.planes do
                                v171 = v159.nx;
                                v172 = v159.ny;
                                v173 = v159.nz;
                                v174 = v159.d;
                                v175 = v4[1];
                                v176 = v4[2];
                                v177 = v4[3];
                                v178 = v4[4];

                                if v171 * v175 + v172 * v176 + v173 * v177 > 0.9999 then
                                    v179 = math.abs(v174 - v178) < 0.05;
                                else
                                    v179 = false;
                                end;

                                if v179 then
                                    v170 = true;
                                    break;
                                end;
                            end;

                            if not v170 or #v160 ~= 0 then
                                if #v160 > 0 then
                                    for _, v4 in v160 do
                                        v155(v4.leaf, {
                                            pass = nil,
                                            source = v159.w,
                                            nx = v159.nx,
                                            ny = v159.ny,
                                            nz = v159.nz,
                                            d = v159.d,
                                            mightsee = v4.mightsee
                                        });
                                    end;
                                else
                                    v180 = buffer.create(leafWords * 4);

                                    for _, v4 in leafPortals[v157.leaf] do
                                        v181, v182 = Winding.range(v4.w, v159.nx, v159.ny, v159.nz, v159.d);

                                        if v182 > 0.05 then
                                            v183 = v4;

                                            for i3 = 0, leafWords * 4 - 4, 4 do
                                                v184 = buffer.readu32(v180, i3);
                                                v185 = buffer.readu32(v183.mightsee, i3);
                                                v186 = bit32.bor(v184, v185);
                                                buffer.writeu32(v180, i3, v186);
                                                v187 = i3;
                                            end;
                                        end;
                                    end;

                                    v155(v157.leaf, {
                                        pass = nil,
                                        source = v159.w,
                                        nx = v159.nx,
                                        ny = v159.ny,
                                        nz = v159.nz,
                                        d = v159.d,
                                        mightsee = v180
                                    });
                                end;
                            end;
                        end;
                    end;
                end;

                v142[u144] = u146;

                if p121 ~= nil then
                    p121(u144, #v124, u141);
                end;
            end;
        elseif v131[v] then
            u143 = buffer.create(leafWords * 4);
            u144 = v;
            u145 = {};
            u146 = {
                [v] = true
            };

            for i2 = 1, #u118.airLeaves do
                v147 = i2;
                v148 = 0;

                for _, v2 in u122[i2] do
                    if v2.cell ~= u144 then
                        v148 = v148 + 1;
                    end;
                end;

                u145[v147] = v148;

                if v148 > 0 then
                    v149 = (v147 - 1) // 32 * 4;
                    v150 = buffer.readu32(u143, v149);
                    v151 = bit32.lshift(1, (v147 - 1) % 32);
                    v152 = bit32.bor(v150, v151);
                    buffer.writeu32(u143, v149, v152);
                end;
            end;

            u153 = function(p188) -- Line: 393, Name: mark
                -- upvalues: u146 (copy), u118 (copy), u145 (copy), u122 (copy), u143 (copy)
                if u146[p188.cell] then
                    return;
                end;

                u146[p188.cell] = true;

                for i2 = 1, #u118.airLeaves do
                    local v189 = u145[i2];
                    local v190;

                    if v189 > 0 then
                        v190 = i2;
                        local v191 = 0;

                        for _, v2 in u122[i2] do
                            if v2.cell == p188.cell then
                                v191 = v191 + 1;
                            end;
                        end;

                        if v191 > 0 then
                            u145[v190] = v189 - v191;

                            if v189 - v191 == 0 then
                                local v192 = (v190 - 1) // 32 * 4;
                                local buffer_readu32_ret = buffer.readu32(u143, v192);
                                local bit32_lshift_ret = bit32.lshift(1, (v190 - 1) % 32);
                                local bit32_bnot_ret = bit32.bnot(bit32_lshift_ret);
                                local bit32_band_ret = bit32.band(buffer_readu32_ret, bit32_bnot_ret);
                                buffer.writeu32(u143, v192, bit32_band_ret);
                            end;
                        end;
                    else
                        v190 = i2;
                    end;
                end;
            end;

            u154 = function(p193, p194, p195) -- Line: 422, Name: reachable
                -- upvalues: Winding (ref), clipToSeparators (ref)
                for _, v2 in p193.faces do
                    local w = v2.w;
                    local _, v196 = Winding.range(w, p195.nx, p195.ny, p195.nz, p195.d);

                    if v196 > 0.05 then
                        if p194.pass == nil then
                            return true;
                        end;

                        local v197 = Winding.clip(w, p195.nx, p195.ny, p195.nz, p195.d, 0.05);

                        if v197 ~= nil then
                            local v198 = Winding.clip(v197, p194.nx, p194.ny, p194.nz, p194.d, 0.05);

                            if v198 ~= nil then
                                local v199 = clipToSeparators(p194.source, p194.pass, v198, false);

                                if v199 ~= nil and clipToSeparators(p194.pass, p194.source, v199, true) ~= nil then
                                    return true;
                                end;
                            end;
                        end;
                    end;
                end;

                return false;
            end;

            v155 = function(p200, u201) -- Line: 452, Name: floodFace
                -- upvalues: leafWords (copy), u122 (copy), u146 (copy), u154 (copy), u153 (copy), u129 (copy), leafPortals (copy), u143 (copy), Winding (ref), clipToSeparators (ref), u130 (copy), yield (copy), u141 (copy), u118 (copy)
                local buffer_create_ret = buffer.create(leafWords * 4);
                local u202 = {
                    passes = 0,
                    budgeted = false
                };

                local function u219(p203, p204) -- Line: 455
                    -- upvalues: buffer_create_ret (copy), u122 (ref), u146 (ref), u154 (ref), u201 (copy), u153 (ref), u202 (copy), u129 (ref), leafPortals (ref), leafWords (ref), u143 (ref), Winding (ref), u219 (copy), clipToSeparators (ref), u130 (ref), yield (ref)
                    local v205 = buffer_create_ret;
                    local v206 = (p203 - 1) // 32 * 4;
                    local buffer_readu32_ret = buffer.readu32(v205, v206);
                    local bit32_lshift_ret = bit32.lshift(1, (p203 - 1) % 32);
                    local bit32_bor_ret = bit32.bor(buffer_readu32_ret, bit32_lshift_ret);
                    buffer.writeu32(v205, v206, bit32_bor_ret);

                    for _, v2 in u122[p203] do
                        if not u146[v2.cell] and u154(v2, p204, u201) then
                            u153(v2);
                        end;
                    end;

                    if u129 < u202.passes then
                        u202.budgeted = true;

                        return;
                    end;

                    for _, v2 in leafPortals[p203] do
                        if u202.budgeted then
                            return;
                        end;

                        local leaf = v2.leaf;
                        local buffer_readu32_ret2 = buffer.readu32(p204.mightsee, (leaf - 1) // 32 * 4);
                        local bit32_lshift_ret2 = bit32.lshift(1, (leaf - 1) % 32);

                        if bit32.band(buffer_readu32_ret2, bit32_lshift_ret2) ~= 0 then
                            local v207;

                            if v2.done then
                                v207 = v2.leafvis;
                            else
                                v207 = v2.mightsee;
                            end;

                            local buffer_create_ret2 = buffer.create(leafWords * 4);
                            local v208 = v2;
                            local v209 = false;

                            for i2 = 0, leafWords * 4 - 4, 4 do
                                local buffer_readu32_ret3 = buffer.readu32(p204.mightsee, i2);
                                local buffer_readu32_ret4 = buffer.readu32(v207, i2);
                                local bit32_band_ret = bit32.band(buffer_readu32_ret3, buffer_readu32_ret4);
                                buffer.writeu32(buffer_create_ret2, i2, bit32_band_ret);
                                local buffer_readu32_ret5 = buffer.readu32(buffer_create_ret, i2);
                                local bit32_bnot_ret = bit32.bnot(buffer_readu32_ret5);
                                local buffer_readu32_ret6 = buffer.readu32(u143, i2);
                                local bit32_bor_ret2 = bit32.bor(bit32_bnot_ret, buffer_readu32_ret6);
                                local v210;

                                if bit32.band(bit32_band_ret, bit32_bor_ret2) == 0 then
                                    v210 = i2;
                                else
                                    v210 = i2;
                                    v209 = true;
                                end;
                            end;

                            if v209 and (v208.nx * p204.nx + v208.ny * p204.ny + v208.nz * p204.nz >= -0.9999 or math.abs(v208.d + p204.d) >= 0.05) then
                                local v211 = Winding.clip(v208.w, u201.nx, u201.ny, u201.nz, u201.d, 0.05);

                                if v211 ~= nil then
                                    local v212 = {
                                        portal = v208,
                                        nx = v208.nx,
                                        ny = v208.ny,
                                        nz = v208.nz,
                                        d = v208.d,
                                        mightsee = buffer_create_ret2
                                    };

                                    if p204.pass == nil then
                                        v212.source = p204.source;
                                        v212.pass = v211;
                                        local v213 = u202;
                                        v213.passes = v213.passes + 1;
                                        u219(v208.leaf, v212);
                                    else
                                        local v214 = Winding.clip(v211, p204.nx, p204.ny, p204.nz, p204.d, 0.05);

                                        if v214 ~= nil then
                                            local v215 = Winding.clip(p204.source, -v208.nx, -v208.ny, -v208.nz, -v208.d, 0.05);

                                            if v215 ~= nil then
                                                local v216 = clipToSeparators(v215, p204.pass, v214, false);

                                                if v216 ~= nil then
                                                    local v217 = clipToSeparators(p204.pass, v215, v216, true);

                                                    if v217 ~= nil then
                                                        v212.source = v215;
                                                        v212.pass = v217;
                                                        local v218 = u202;
                                                        v218.passes = v218.passes + 1;

                                                        if u130 > 0 and (u202.passes % u130 == 0 and yield ~= nil) then
                                                            yield();
                                                        end;

                                                        u219(v208.leaf, v212);
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;

                u219(p200, u201);
                local v220 = u141;
                v220.floods = v220.floods + 1;
                local v221 = u141;
                v221.passes = v221.passes + u202.passes;

                if u202.budgeted then
                    local v222 = u141;
                    v222.budgeted = v222.budgeted + 1;

                    for i2 = 1, #u118.airLeaves do
                        local buffer_readu32_ret = buffer.readu32(u201.mightsee, (i2 - 1) // 32 * 4);
                        local bit32_lshift_ret = bit32.lshift(1, (i2 - 1) % 32);
                        local v223;

                        if bit32.band(buffer_readu32_ret, bit32_lshift_ret) ~= 0 then
                            v223 = i2;

                            for _, v2 in u122[i2] do
                                if not u146[v2.cell] then
                                    u153(v2);
                                end;
                            end;
                        else
                            v223 = i2;
                        end;
                    end;
                end;
            end;

            v156 = function(p224, p225) -- Line: 549, Name: interiorFace
                -- upvalues: u123 (copy), u144 (copy), Winding (ref)
                for _, v2 in u123[u144] do
                    if v2 ~= p225 then
                        for _, v3 in v2.faces do
                            if p224.nx * v3.nx + p224.ny * v3.ny + p224.nz * v3.nz <= -0.9999 and (math.abs(p224.d + v3.d) <= 0.01 and Winding.contains(v3.w, v3.nx, v3.ny, v3.nz, p224.w, 0.01)) then
                                return true;
                            end;
                        end;
                    end;
                end;

                return false;
            end;

            for i2, v2 in u123[u144] do
                v157 = v2;

                for _, v3 in u122[v2.leaf] do
                    if not u146[v3.cell] then
                        u153(v3);
                    end;
                end;

                v158 = u118.airLeaves[v157.leaf];

                for _, v3 in v157.faces do
                    if v156(v3, v157) then
                        u141.interior = u141.interior + 1;
                    else
                        v159 = v3;
                        v160 = {};

                        for _, v4 in leafPortals[v157.leaf] do
                            v161 = v159.nx;
                            v162 = v159.ny;
                            v163 = v159.nz;
                            v164 = v159.d;
                            v165 = v4.nx;
                            v166 = v4.ny;
                            v167 = v4.nz;
                            v168 = v4.d;

                            if v161 * v165 + v162 * v166 + v163 * v167 > 0.9999 then
                                v169 = math.abs(v164 - v168) < 0.05;
                            else
                                v169 = false;
                            end;

                            if v169 then
                                v160[#v160 + 1] = v4;
                            end;
                        end;

                        v170 = false;

                        for _, v4 in v158.planes do
                            v171 = v159.nx;
                            v172 = v159.ny;
                            v173 = v159.nz;
                            v174 = v159.d;
                            v175 = v4[1];
                            v176 = v4[2];
                            v177 = v4[3];
                            v178 = v4[4];

                            if v171 * v175 + v172 * v176 + v173 * v177 > 0.9999 then
                                v179 = math.abs(v174 - v178) < 0.05;
                            else
                                v179 = false;
                            end;

                            if v179 then
                                v170 = true;
                                break;
                            end;
                        end;

                        if not v170 or #v160 ~= 0 then
                            if #v160 > 0 then
                                for _, v4 in v160 do
                                    v155(v4.leaf, {
                                        pass = nil,
                                        source = v159.w,
                                        nx = v159.nx,
                                        ny = v159.ny,
                                        nz = v159.nz,
                                        d = v159.d,
                                        mightsee = v4.mightsee
                                    });
                                end;
                            else
                                v180 = buffer.create(leafWords * 4);

                                for _, v4 in leafPortals[v157.leaf] do
                                    v181, v182 = Winding.range(v4.w, v159.nx, v159.ny, v159.nz, v159.d);

                                    if v182 > 0.05 then
                                        v183 = v4;

                                        for i3 = 0, leafWords * 4 - 4, 4 do
                                            v184 = buffer.readu32(v180, i3);
                                            v185 = buffer.readu32(v183.mightsee, i3);
                                            v186 = bit32.bor(v184, v185);
                                            buffer.writeu32(v180, i3, v186);
                                            v187 = i3;
                                        end;
                                    end;
                                end;

                                v155(v157.leaf, {
                                    pass = nil,
                                    source = v159.w,
                                    nx = v159.nx,
                                    ny = v159.ny,
                                    nz = v159.nz,
                                    d = v159.d,
                                    mightsee = v180
                                });
                            end;
                        end;
                    end;
                end;
            end;

            v142[u144] = u146;

            if p121 ~= nil then
                p121(u144, #v124, u141);
            end;
        end;
    end;

    return v142, u141;
end;

function v29.floodOrder(p226) -- Line: 649
    local table_clone_ret = table.clone(p226.portals);
    table.sort(table_clone_ret, function(p227, p228) -- Line: 651
        if p227.numMightsee == p228.numMightsee then
            return p227.id < p228.id;
        end;

        return p227.numMightsee < p228.numMightsee;
    end);

    return table_clone_ret;
end;

return v29;