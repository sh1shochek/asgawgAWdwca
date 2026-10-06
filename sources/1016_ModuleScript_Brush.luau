-- Decompiled with Potassium's decompiler.

local Winding = require(script.Parent:WaitForChild("Winding"));
local u1 = {};

local function makeSide(p2, p3, p4, p5, p6, p7) -- Line: 13
    -- upvalues: Winding (copy)
    return {
        nx = p2,
        ny = p3,
        nz = p4,
        d = p5,
        w = p6,
        used = p7,
        key = Winding.planeKey(p2, p3, p4, p5)
    };
end;

local function finish(p8) -- Line: 17
    -- upvalues: Winding (copy)
    local v9 = (-1 / 0);
    local v10 = (1 / 0);
    local v11 = (1 / 0);
    local v12 = (1 / 0);
    local v13 = (-1 / 0);
    local v14 = (-1 / 0);
    local v15 = {};

    for _, v in p8.sides do
        local v16, v17, v18, v19, v20, v21 = Winding.bounds(v.w);

        if v16 >= v10 then
            v16 = v10;
        end;

        if v17 >= v11 then
            v17 = v11;
        end;

        if v18 >= v12 then
            v18 = v12;
        end;

        if v13 >= v19 then
            v19 = v13;
        end;

        if v14 >= v20 then
            v20 = v14;
        end;

        if v9 >= v21 then
            v21 = v9;
        end;

        v15[v.key] = true;
        v14 = v20;
        v13 = v19;
        v12 = v18;
        v11 = v17;
        v10 = v16;
        v9 = v21;
    end;

    p8.minX = v10;
    p8.minY = v11;
    p8.minZ = v12;
    p8.maxX = v13;
    p8.maxY = v14;
    p8.maxZ = v9;
    p8.keys = v15;

    return p8;
end;

function u1.fromPlanes(p22, p23, p24, p25) -- Line: 50
    -- upvalues: Winding (copy), finish (copy)
    local v26 = {};

    for i, v in p22 do
        local v27 = Winding.baseForPlane(v[1], v[2], v[3], v[4]);
        local v28 = v;
        local v29 = i;

        for i2, v2 in p22 do
            if i2 ~= v29 and v27 ~= nil then
                v27 = Winding.clip(v27, -v2[1], -v2[2], -v2[3], -v2[4], 0.02);
            end;
        end;

        if v27 ~= nil then
            for i2 = 1, #v27 do
                if math.abs(v27[i2]) > 50000 then
                    return nil;
                end;

                local _ = i2;
            end;

            local v30 = v28[1];
            local v31 = v28[2];
            local v32 = v28[3];
            local v33 = v28[4];
            local v34;

            if p25 == nil then
                v34 = false;
            else
                v34 = p25[v29] == true;
            end;

            v26[#v26 + 1] = {
                nx = v30,
                ny = v31,
                nz = v32,
                d = v33,
                w = v27,
                used = v34,
                key = Winding.planeKey(v30, v31, v32, v33)
            };
        end;
    end;

    if #v26 < 4 then
        return nil;
    end;

    return finish({
        id = p23,
        name = p24,
        sides = v26
    });
end;

function u1.planesFromMesh(p35, p36) -- Line: 76
    -- upvalues: Winding (copy)
    local v37 = 0;
    local v38 = 0;
    local v39 = 0;

    for _, v in p35 do
        v37 = v37 + v[1];
        v38 = v38 + v[2];
        v39 = v39 + v[3];
    end;

    local v40 = v37 / #p35;
    local v41 = v38 / #p35;
    local v42 = v39 / #p35;
    local v43 = {};
    local v44 = {};

    for _, v in p36 do
        local v45 = p35[v[1]];
        local v46 = p35[v[2]];
        local v47 = p35[v[3]];
        local v48, v49, v50, v51 = Winding.planeFromPoints(v45[1], v45[2], v45[3], v46[1], v46[2], v46[3], v47[1], v47[2], v47[3]);

        if v48 ~= nil then
            if v48 * v40 + v49 * v41 + v50 * v42 - v51 > 0 then
                v48 = -v48;
                v49 = -v49;
                v50 = -v50;
                v51 = -v51;
            end;

            local string_format_ret = string.format("%.5f,%.5f,%.5f,%.3f", v48, v49, v50, v51);

            if not v43[string_format_ret] then
                v43[string_format_ret] = true;
                v44[#v44 + 1] = {
                    v48,
                    v49,
                    v50,
                    v51
                };
            end;
        end;
    end;

    return v44;
end;

function u1.range(p52, p53, p54, p55, p56) -- Line: 104
    -- upvalues: Winding (copy)
    local v57 = (-1 / 0);
    local v58 = (1 / 0);

    for _, v in p52.sides do
        local v59, v60 = Winding.range(v.w, p53, p54, p55, p56);

        if v59 >= v58 then
            v59 = v58;
        end;

        if v57 < v60 then
            v58 = v59;
            v57 = v60;
        else
            v58 = v59;
        end;
    end;

    return v58, v57;
end;

function u1.boxRange(p61, p62, p63, p64, p65) -- Line: 119
    local v66;

    if p62 > 0 then
        v66 = p61.minX;
    else
        v66 = p61.maxX;
    end;

    local v67;

    if p63 > 0 then
        v67 = p61.minY;
    else
        v67 = p61.maxY;
    end;

    local v68;

    if p64 > 0 then
        v68 = p61.minZ;
    else
        v68 = p61.maxZ;
    end;

    local v69;

    if p62 > 0 then
        v69 = p61.maxX;
    else
        v69 = p61.minX;
    end;

    local v70;

    if p63 > 0 then
        v70 = p61.maxY;
    else
        v70 = p61.minY;
    end;

    local v71;

    if p64 > 0 then
        v71 = p61.maxZ;
    else
        v71 = p61.minZ;
    end;

    return v66 * p62 + v67 * p63 + v68 * p64 - p65, v69 * p62 + v70 * p63 + v71 * p64 - p65;
end;

function u1.classify(p72, p73, p74, p75, p76) -- Line: 132
    -- upvalues: u1 (copy)
    local v77, v78 = u1.boxRange(p72, p73, p74, p75, p76);

    if v78 <= 0.05 then
        return "back";
    end;

    if v77 >= -0.05 then
        return "front";
    end;

    local v79, v80 = u1.range(p72, p73, p74, p75, p76);

    return v80 <= 0.05 and "back" or (v79 >= -0.05 and "front" or "cross");
end;

function u1.split(p81, p82, p83, p84, p85) -- Line: 149
    -- upvalues: u1 (copy)
    local v86, v87 = u1.range(p81, p82, p83, p84, p85);

    if v87 < 0.05 then
        return nil, p81;
    end;

    if v86 > -0.05 then
        return p81, nil;
    end;

    local v88 = {};
    local v89 = {};

    for i, v in p81.sides do
        v88[i] = {
            v.nx,
            v.ny,
            v.nz,
            v.d
        };
        v89[i] = v.used;
    end;

    local v90 = #v88;
    v88[v90 + 1] = {
        -p82,
        -p83,
        -p84,
        -p85
    };
    v89[v90 + 1] = true;
    local v91 = u1.fromPlanes(v88, p81.id, p81.name, v89);
    v88[v90 + 1] = {
        p82,
        p83,
        p84,
        p85
    };
    local v92 = u1.fromPlanes(v88, p81.id, p81.name, v89);

    local function thin(p93) -- Line: 168
        return (p93 == nil or (p93.maxX - p93.minX < 0.05 or p93.maxY - p93.minY < 0.05)) and true or p93.maxZ - p93.minZ < 0.05;
    end;

    if (v91 == nil or (v91.maxX - v91.minX < 0.05 or v91.maxY - v91.minY < 0.05)) and true or v91.maxZ - v91.minZ < 0.05 then
        v91 = nil;
    end;

    if (v92 == nil or (v92.maxX - v92.minX < 0.05 or v92.maxY - v92.minY < 0.05)) and true or v92.maxZ - v92.minZ < 0.05 then
        v92 = nil;
    end;

    return v91, v92;
end;

function u1.markUsed(p94, p95) -- Line: 184
    for _, v in p94.sides do
        if v.key == p95 then
            v.used = true;
        end;
    end;
end;

return u1;