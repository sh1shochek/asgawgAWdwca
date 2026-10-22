-- ReplicatedStorage.Visibility.SilhouetteCoverage
-- Script path: ReplicatedStorage.Visibility.SilhouetteCoverage
-- Decompile time: 16.21 ms

-- Decompiled with Potassium's decompiler.

require(script.Parent.StaticOcclusionRuntime);
local u1 = {};
u1.__index = u1;

local function spanMask(p2: number, p3: number) -- Line: 55
    return bit32.lshift(1, p3 + 1) - bit32.lshift(1, p2);
end;

local function projectFrame(p4: any, p5: vector, p6: table, p7: number) -- Line: 60
    local v8 = Vector3.new(0, 0, 0);

    for i = 1, p7 do
        v8 = v8 + p6[i];
        local _ = i;
    end;

    local v9 = v8 / p7 - p5;

    if v9.Magnitude <= 0.05 then
        return false;
    end;

    local Unit = v9.Unit;
    local v10 = Unit:Cross(Vector3.new(0, 1, 0));

    if v10.Magnitude < 0.0001 then
        v10 = Unit:Cross(Vector3.new(1, 0, 0));
    end;

    local Unit2 = v10.Unit;
    local v11 = Unit2:Cross(Unit);
    local v12 = (1 / 0);
    local v13 = (-1 / 0);
    local v14 = (-1 / 0);
    local v15 = (1 / 0);
    local v16 = (1 / 0);

    for i = 1, p7 do
        local v17 = p6[i] - p5;
        local vector_dot_ret = vector.dot(v17, Unit);

        if vector_dot_ret - 0.75 <= 0.05 then
            return false;
        end;

        v15 = math.min(v15, vector_dot_ret - 0.75);
        local v18 = vector.dot(v17, Unit2) / vector_dot_ret;
        local v19 = vector.dot(v17, v11) / vector_dot_ret;
        local v20 = 0.75 / (vector_dot_ret - 0.75);
        v12 = math.min(v12, v18 - v20);
        v13 = math.max(v13, v18 + v20);
        v16 = math.min(v16, v19 - v20);
        v14 = math.max(v14, v19 + v20);
        local _ = i;
    end;

    p4.Origin = p5;
    p4.Forward = Unit;
    p4.Right = Unit2;
    p4.Up = v11;
    p4.MinX = v12;
    p4.MinY = v16;
    p4.StepX = (v13 - v12) / 16;
    p4.StepY = (v14 - v16) / 16;
    p4.MinNearest = v15;

    return true;
end;

local function fillWindow(p21) -- Line: 110
    local Pending = p21.Pending;
    local RowDepth = p21.RowDepth;

    for i = 1, 16 do
        Pending[i] = 65535;
        RowDepth[i] = p21.MinNearest;
        local _ = i;
    end;

    p21.PendingRows = 16;
    p21.FarDepth = p21.MinNearest;
end;

local function fillSilhouette(p22: any, p23: table, p24: number) -- Line: 121
    local Origin = p22.Origin;
    local Forward = p22.Forward;
    local Right = p22.Right;
    local Up = p22.Up;
    local MinX = p22.MinX;
    local MinY = p22.MinY;
    local StepX = p22.StepX;
    local StepY = p22.StepY;
    local Pending = p22.Pending;
    local RowDepth = p22.RowDepth;
    Pending[1] = 0;
    RowDepth[1] = (1 / 0);
    Pending[2] = 0;
    RowDepth[2] = (1 / 0);
    Pending[3] = 0;
    RowDepth[3] = (1 / 0);
    Pending[4] = 0;
    RowDepth[4] = (1 / 0);
    Pending[5] = 0;
    RowDepth[5] = (1 / 0);
    Pending[6] = 0;
    RowDepth[6] = (1 / 0);
    Pending[7] = 0;
    RowDepth[7] = (1 / 0);
    Pending[8] = 0;
    RowDepth[8] = (1 / 0);
    Pending[9] = 0;
    RowDepth[9] = (1 / 0);
    Pending[10] = 0;
    RowDepth[10] = (1 / 0);
    Pending[11] = 0;
    RowDepth[11] = (1 / 0);
    Pending[12] = 0;
    RowDepth[12] = (1 / 0);
    Pending[13] = 0;
    RowDepth[13] = (1 / 0);
    Pending[14] = 0;
    RowDepth[14] = (1 / 0);
    Pending[15] = 0;
    RowDepth[15] = (1 / 0);
    Pending[16] = 0;
    RowDepth[16] = (1 / 0);

    for i = 1, p24 do
        local v25 = p23[i] - Origin;
        local vector_dot_ret = vector.dot(v25, Forward);
        local v26 = vector.dot(v25, Right) / vector_dot_ret;
        local v27 = vector.dot(v25, Up) / vector_dot_ret;
        local v28 = 0.75 / (vector_dot_ret - 0.75);
        local v29 = vector_dot_ret - 0.75;
        local math_ceil_ret = math.ceil((v27 - v28 - MinY) / StepY - 0.5);
        local math_clamp_ret = math.clamp(math_ceil_ret, 0, 15);
        local math_floor_ret = math.floor((v27 + v28 - MinY) / StepY - 0.5);
        local _ = i;

        for i2 = math_clamp_ret, math.clamp(math_floor_ret, 0, 15) do
            local v30 = MinY + (i2 + 0.5) * StepY - v27;
            local v31 = v28 * v28 - v30 * v30;
            local v32;

            if v31 < 0 then
                v32 = i2;
            else
                local math_sqrt_ret = math.sqrt(v31);
                local math_ceil_ret2 = math.ceil((v26 - math_sqrt_ret - MinX) / StepX - 0.5);
                local math_max_ret = math.max(math_ceil_ret2, 0);
                local math_floor_ret2 = math.floor((v26 + math_sqrt_ret - MinX) / StepX - 0.5);
                local math_min_ret = math.min(math_floor_ret2, 15);

                if math_max_ret <= math_min_ret then
                    local v33 = Pending[i2 + 1];
                    local v34 = bit32.lshift(1, math_min_ret + 1) - bit32.lshift(1, math_max_ret);
                    Pending[i2 + 1] = bit32.bor(v33, v34);
                    RowDepth[i2 + 1] = math.min(RowDepth[i2 + 1], v29);
                    v32 = i2;
                else
                    v32 = i2;
                end;
            end;
        end;

        local math_floor_ret2 = math.floor((v26 - MinX) / StepX);
        local math_clamp_ret2 = math.clamp(math_floor_ret2, 0, 15);
        local math_floor_ret3 = math.floor((v27 - MinY) / StepY);
        local v35 = math.clamp(math_floor_ret3, 0, 15) + 1;
        local v36 = Pending[v35];
        local bit32_lshift_ret = bit32.lshift(1, math_clamp_ret2);
        Pending[v35] = bit32.bor(v36, bit32_lshift_ret);
        RowDepth[v35] = math.min(RowDepth[v35], v29);
    end;

    local v37 = 0;
    local v38 = 0;

    for i = 1, 16 do
        local v39;

        if Pending[i] == 0 then
            v39 = i;
        else
            v37 = v37 + 1;
            v38 = math.max(v38, RowDepth[i]);
            v39 = i;
        end;
    end;

    p22.PendingRows = v37;
    p22.FarDepth = v38;
end;

local function rasterTriangle(p40: any, p41: vector, p42: vector, p43: vector) -- Line: 174
    local Origin = p40.Origin;
    local Forward = p40.Forward;
    local v44 = p41 - Origin;
    local v45 = p42 - Origin;
    local v46 = p43 - Origin;
    local vector_dot_ret = vector.dot(v44, Forward);
    local vector_dot_ret2 = vector.dot(v45, Forward);
    local vector_dot_ret3 = vector.dot(v46, Forward);
    local v47 = vector_dot_ret >= 0.05;
    local v48 = vector_dot_ret2 >= 0.05;
    local v49 = vector_dot_ret3 >= 0.05;

    if not (v47 or (v48 or v49)) then
        return false;
    end;

    local Right = p40.Right;
    local Up = p40.Up;
    local ClipX = p40.ClipX;
    local ClipY = p40.ClipY;
    local ClipW = p40.ClipW;
    local v50 = 0;

    if v47 then
        v50 = v50 + 1;
        ClipX[v50] = vector.dot(v44, Right) / vector_dot_ret;
        ClipY[v50] = vector.dot(v44, Up) / vector_dot_ret;
        ClipW[v50] = 1 / vector_dot_ret;
    end;

    if v47 ~= v48 then
        local v51 = v44 + (p42 - p41) * ((0.05 - vector_dot_ret) / (vector_dot_ret2 - vector_dot_ret));
        v50 = v50 + 1;
        ClipX[v50] = vector.dot(v51, Right) / 0.05;
        ClipY[v50] = vector.dot(v51, Up) / 0.05;
        ClipW[v50] = 20;
    end;

    if v48 then
        v50 = v50 + 1;
        ClipX[v50] = vector.dot(v45, Right) / vector_dot_ret2;
        ClipY[v50] = vector.dot(v45, Up) / vector_dot_ret2;
        ClipW[v50] = 1 / vector_dot_ret2;
    end;

    if v48 ~= v49 then
        local v52 = v45 + (p43 - p42) * ((0.05 - vector_dot_ret2) / (vector_dot_ret3 - vector_dot_ret2));
        v50 = v50 + 1;
        ClipX[v50] = vector.dot(v52, Right) / 0.05;
        ClipY[v50] = vector.dot(v52, Up) / 0.05;
        ClipW[v50] = 20;
    end;

    if v49 then
        v50 = v50 + 1;
        ClipX[v50] = vector.dot(v46, Right) / vector_dot_ret3;
        ClipY[v50] = vector.dot(v46, Up) / vector_dot_ret3;
        ClipW[v50] = 1 / vector_dot_ret3;
    end;

    if v49 ~= v47 then
        local v53 = v46 + (p41 - p43) * ((0.05 - vector_dot_ret3) / (vector_dot_ret - vector_dot_ret3));
        v50 = v50 + 1;
        ClipX[v50] = vector.dot(v53, Right) / 0.05;
        ClipY[v50] = vector.dot(v53, Up) / 0.05;
        ClipW[v50] = 20;
    end;

    local v54 = ClipX[1];
    local v55 = ClipY[1];
    local v56 = ClipW[1];
    local v57 = ClipX[2];
    local v58 = ClipY[2];
    local v59 = ClipX[3];
    local v60 = ClipY[3];
    local v61 = v50 == 4;
    local v62, v63;

    if v61 then
        v62 = ClipX[4];
        v63 = ClipY[4];
    else
        v62 = v54;
        v63 = v55;
    end;

    local MinX = p40.MinX;
    local MinY = p40.MinY;
    local StepX = p40.StepX;
    local StepY = p40.StepY;
    local v64 = StepX * 0.0001;
    local math_min_ret = math.min(v54, v57, v59, v62);
    local math_max_ret = math.max(v54, v57, v59, v62);
    local math_min_ret2 = math.min(v55, v58, v60, v63);
    local math_max_ret2 = math.max(v55, v58, v60, v63);
    local v65 = math_min_ret - 2 * v64;
    local v66 = math_max_ret + 2 * v64;

    if math.floor((v66 - MinX) / StepX - 0.5) < 0 or math.ceil((v65 - MinX) / StepX - 0.5) > 15 then
        return false;
    end;

    local math_ceil_ret = math.ceil((math_min_ret2 - MinY) / StepY - 0.5);
    local math_max_ret3 = math.max(math_ceil_ret, 0);
    local math_floor_ret = math.floor((math_max_ret2 - MinY) / StepY - 0.5);
    local math_min_ret3 = math.min(math_floor_ret, 15);
    local Pending = p40.Pending;
    local RowDepth = p40.RowDepth;

    while math_max_ret3 <= math_min_ret3 and Pending[math_max_ret3 + 1] == 0 do
        math_max_ret3 = math_max_ret3 + 1;
    end;

    while math_max_ret3 <= math_min_ret3 and Pending[math_min_ret3 + 1] == 0 do
        math_min_ret3 = math_min_ret3 - 1;
    end;

    if math_min_ret3 < math_max_ret3 then
        return false;
    end;

    local v67 = (v57 - v54) * (v60 - v55) - (v59 - v54) * (v58 - v55);
    local v68 = ClipW[2];
    local v69 = ClipW[3];
    local v70, v71, v72, v73, v74;

    if v61 then
        v70 = (v59 - v54) * (v63 - v55) - (v62 - v54) * (v60 - v55);

        if math.abs(v70) > math.abs(v67) then
            v68 = ClipW[3];
            v69 = ClipW[4];
            v71 = v62;
            v72 = v60;
            v73 = v59;
            v74 = v63;
        else
            v71 = v59;
            v72 = v58;
            v73 = v57;
            v74 = v60;
            v70 = v67;
        end;
    else
        v71 = v59;
        v72 = v58;
        v73 = v57;
        v74 = v60;
        v70 = v67;
    end;

    if math.abs(v70) < 1e-12 then
        return false;
    end;

    local v75 = v68 - v56;
    local v76 = v69 - v56;
    local v77 = (v75 * (v74 - v55) - v76 * (v72 - v55)) / v70;
    local v78 = ((v73 - v54) * v76 - (v71 - v54) * v75) / v70;
    local v79 = v56 - v77 * v54 - v78 * v55;

    if (v79 + math.max(v77 * v65, v77 * v66) + math.max(v78 * math_min_ret2, v78 * math_max_ret2)) * (p40.FarDepth - 0.02) < 0.9999999 then
        return false;
    end;

    local v80;

    if v61 then
        v80 = v62;
    else
        v80 = v54;
    end;

    local v81;

    if v61 then
        v81 = v63;
    else
        v81 = v55;
    end;

    local math_min_ret4 = math.min(v55, v58);
    local math_max_ret4 = math.max(v55, v58);
    local v82 = v57 - v54;
    local v83 = v58 - v55;
    local math_min_ret5 = math.min(v58, v60);
    local math_max_ret5 = math.max(v58, v60);
    local v84 = v59 - v57;
    local v85 = v60 - v58;
    local math_min_ret6 = math.min(v60, v81);
    local math_max_ret6 = math.max(v60, v81);
    local v86 = v80 - v59;
    local v87 = v81 - v60;
    local v88 = v54 - v62;
    local v89 = v55 - v63;
    local v90, v91;

    if v61 then
        v90 = math.min(v63, v55);
        v91 = math.max(v63, v55);
    else
        v90 = (1 / 0);
        v91 = (-1 / 0);
    end;

    local v92 = false;

    for i = math_max_ret3, math_min_ret3 do
        local v93 = Pending[i + 1];
        local v94;

        if v93 == 0 then
            v94 = i;
        else
            local v95 = MinY + (i + 0.5) * StepY;
            local v96 = (1 / 0);
            local v97 = (-1 / 0);

            if math_min_ret4 <= v95 and v95 <= math_max_ret4 then
                if v83 == 0 then
                    v96 = math.min(v96, v54, v57);
                    v97 = math.max(v97, v54, v57);
                else
                    local v98 = v54 + (v95 - v55) / v83 * v82;
                    v96 = math.min(v96, v98);
                    v97 = math.max(v97, v98);
                end;
            end;

            if math_min_ret5 <= v95 and v95 <= math_max_ret5 then
                if v85 == 0 then
                    v96 = math.min(v96, v57, v59);
                    v97 = math.max(v97, v57, v59);
                else
                    local v99 = v57 + (v95 - v58) / v85 * v84;
                    v96 = math.min(v96, v99);
                    v97 = math.max(v97, v99);
                end;
            end;

            if math_min_ret6 <= v95 and v95 <= math_max_ret6 then
                if v87 == 0 then
                    v96 = math.min(v96, v59, v80);
                    v97 = math.max(v97, v59, v80);
                else
                    local v100 = v59 + (v95 - v60) / v87 * v86;
                    v96 = math.min(v96, v100);
                    v97 = math.max(v97, v100);
                end;
            end;

            if v90 <= v95 and v95 <= v91 then
                if v89 == 0 then
                    v96 = math.min(v96, v62, v54);
                    v97 = math.max(v97, v62, v54);
                else
                    local v101 = v62 + (v95 - v63) / v89 * v88;
                    v96 = math.min(v96, v101);
                    v97 = math.max(v97, v101);
                end;
            end;

            if v97 < v96 then
                v94 = i;
            else
                local v102 = v96 - v64;
                local v103 = v97 + v64;
                local v104 = 1 / (RowDepth[i + 1] - 0.02);
                local v105 = v78 * v95 + v79;
                local v106, v107, v108, v109, v110, v111, v112;

                if math.abs(v77) >= 1e-12 then
                    if v77 > 0 then
                        v102 = math.max(v102, (v104 - v105) / v77);
                    else
                        v103 = math.min(v103, (v104 - v105) / v77);
                    end;

                    v106 = math.ceil((v102 - MinX) / StepX - 0.5);
                    v107 = math.max(v106, 0);
                    v108 = math.floor((v103 - MinX) / StepX - 0.5);
                    v109 = math.min(v108, 15);

                    if v109 < v107 then
                        v94 = i;
                    else
                        v110 = bit32.lshift(1, v109 + 1) - bit32.lshift(1, v107);
                        v111 = bit32.band(v93, v110);

                        if v111 == 0 then
                            v94 = i;
                        else
                            v112 = v93 - v111;
                            Pending[i + 1] = v112;

                            if v112 == 0 then
                                p40.PendingRows = p40.PendingRows - 1;
                            end;

                            v94 = i;
                            v92 = true;
                        end;
                    end;
                end;

                if v105 <= v104 then
                    v94 = i;
                else
                    v106 = math.ceil((v102 - MinX) / StepX - 0.5);
                    v107 = math.max(v106, 0);
                    v108 = math.floor((v103 - MinX) / StepX - 0.5);
                    v109 = math.min(v108, 15);

                    if v109 < v107 then
                        v94 = i;
                    else
                        v110 = bit32.lshift(1, v109 + 1) - bit32.lshift(1, v107);
                        v111 = bit32.band(v93, v110);

                        if v111 == 0 then
                            v94 = i;
                        else
                            v112 = v93 - v111;
                            Pending[i + 1] = v112;

                            if v112 == 0 then
                                p40.PendingRows = p40.PendingRows - 1;
                            end;

                            v94 = i;
                            v92 = true;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v92;
end;

local function sameList(p113: table, p114: table) -- Line: 383
    if #p113 ~= #p114 then
        return false;
    end;

    for i, v in p113 do
        if p114[i] ~= v then
            return false;
        end;
    end;

    return true;
end;

local function proved(p115: any, p116: table?) -- Line: 395
    local Contributors = p115.Contributors;

    if p116 ~= nil then
        local v117;

        if #Contributors == #p116 then
            v117 = true;

            for i, v in Contributors do
                if p116[i] ~= v then
                    v117 = false;
                    break;
                end;
            end;
        else
            v117 = false;
        end;

        if v117 then
            return true, p116;
        end;
    end;

    return true, table.clone(Contributors);
end;

function u1.new() -- Line: 403
    -- upvalues: u1 (copy), rasterTriangle (copy)
    local v118 = {
        PendingRows = 0,
        Origin = Vector3.new(0, 0, 0),
        Forward = Vector3.new(0, 0, 0),
        Right = Vector3.new(0, 0, 0),
        Up = Vector3.new(0, 0, 0),
        MinX = 0,
        MinY = 0,
        StepX = 0,
        StepY = 0,
        MinNearest = 0,
        FarDepth = 0,
        Stamp = 0,
        Static = nil,
        Visit = nil,
        Pending = table.create(16, 0),
        RowDepth = table.create(16, 0),
        Contributors = table.create(96),
        Planes = table.create(4),
        ClipX = table.create(4),
        ClipY = table.create(4),
        ClipW = table.create(4),
        Marks = {}
    };
    local u119 = setmetatable(v118, u1);

    function u119.Visit(p120: number) -- Line: 429
        -- upvalues: u119 (copy), rasterTriangle (ref)
        if u119.Marks[p120] == u119.Stamp then
            return false;
        end;

        u119.Marks[p120] = u119.Stamp;
        local v121, v122, v123 = u119.Static:TriangleVertices(p120);

        if not rasterTriangle(u119, v121, v122, v123) then
            return false;
        end;

        local Contributors = u119.Contributors;

        if #Contributors < 96 then
            Contributors[#Contributors + 1] = p120;
        end;

        return u119.PendingRows == 0;
    end;

    return u119;
end;

function u1.OriginCovered(p124: any, p125: any, p126: vector, p127: table, p128: number, p129: table?, p130: number?, p131: table?) -- Line: 448
    -- upvalues: projectFrame (copy), fillWindow (copy), rasterTriangle (copy), proved (copy), fillSilhouette (copy)
    if p128 == 0 or not projectFrame(p124, p126, p127, p128) then
        return nil, nil;
    end;

    local Contributors = p124.Contributors;
    table.clear(Contributors);

    if p129 ~= nil and #p129 > 0 then
        fillWindow(p124);
        p124.Stamp = p124.Stamp + 1;

        for _, v in p129 do
            if p124.Marks[v] ~= p124.Stamp then
                p124.Marks[v] = p124.Stamp;
                local v132, v133, v134 = p125:TriangleVertices(v);

                if rasterTriangle(p124, v132, v133, v134) then
                    Contributors[#Contributors + 1] = v;

                    if p124.PendingRows == 0 then
                        return proved(p124, p129);
                    end;
                end;
            end;
        end;

        table.clear(Contributors);
    end;

    fillSilhouette(p124, p127, p128);
    p124.Stamp = p124.Stamp + 1;

    for i = 1, 2 do
        local v135;

        if i == 1 then
            v135 = p129;
        else
            v135 = p131;
        end;

        local v136;

        if v135 == nil then
            v136 = i;
        else
            v136 = i;

            for _, v in v135 do
                if p124.Marks[v] ~= p124.Stamp then
                    p124.Marks[v] = p124.Stamp;
                    local v137, v138, v139 = p125:TriangleVertices(v);

                    if rasterTriangle(p124, v137, v138, v139) then
                        if #Contributors < 96 then
                            Contributors[#Contributors + 1] = v;
                        end;

                        if p124.PendingRows == 0 then
                            return proved(p124, p129);
                        end;
                    end;
                end;
            end;
        end;
    end;

    local Pending = p124.Pending;
    local RowDepth = p124.RowDepth;
    local v140 = 16;
    local v141 = 0;
    local v142 = 0;
    local v143 = -1;

    for i = 0, 15 do
        local v144 = Pending[i + 1];
        local v145;

        if v144 == 0 then
            v145 = i;
        else
            v140 = math.min(v140, i);
            v141 = bit32.bor(v141, v144);
            v142 = math.max(v142, RowDepth[i + 1]);
            v143 = i;
            v145 = v143;
            local v146 = v143;
            v143 = v145;
            v146 = v145;
        end;
    end;

    local bit32_countrz_ret = bit32.countrz(v141);
    local v147 = 31 - bit32.countlz(v141);
    local Forward = p124.Forward;
    local Right = p124.Right;
    local Up = p124.Up;
    local v148 = p124.MinX + p124.StepX * (v147 + 1);
    local v149 = p124.MinY + p124.StepY * v140;
    local v150 = p124.MinY + p124.StepY * (v143 + 1);
    local Planes = p124.Planes;
    Planes[1] = Right - Forward * (p124.MinX + p124.StepX * bit32_countrz_ret);
    Planes[2] = Forward * v148 - Right;
    Planes[3] = Up - Forward * v149;
    Planes[4] = Forward * v150 - Up;
    p124.Static = p125;
    local v151, v152 = p125:VisitFrustumTriangles(p126, Planes, Forward, 0.05, v142, p124.Visit, 20000, p130);
    p124.Static = nil;

    if v151 then
        return proved(p124, nil);
    end;

    if v152 then
        return false, nil;
    end;

    return nil, nil;
end;

return table.freeze(u1);