-- Decompiled with Potassium's decompiler.

require(script.Parent.StaticOcclusionRuntime);
local u1 = {};
u1.__index = u1;

local function spanMask(p2: number, p3: number) -- Line: 50
    return bit32.lshift(1, p3 + 1) - bit32.lshift(1, p2);
end;

local function projectFrame(p4: any, p5: vector, p6: table, p7: number) -- Line: 55
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
    local v12 = (-1 / 0);
    local v13 = (1 / 0);
    local v14 = (-1 / 0);
    local v15 = (1 / 0);
    local v16 = (1 / 0);

    for i = 1, p7 do
        local v17 = p6[i] - p5;
        local v18 = v17:Dot(Unit);

        if v18 - 0.75 <= 0.05 then
            return false;
        end;

        v16 = math.min(v16, v18 - 0.75);
        local v19 = v17:Dot(Unit2) / v18;
        local v20 = v17:Dot(v11) / v18;
        local v21 = 0.75 / (v18 - 0.75);
        v13 = math.min(v13, v19 - v21);
        v14 = math.max(v14, v19 + v21);
        v15 = math.min(v15, v20 - v21);
        v12 = math.max(v12, v20 + v21);
        local _ = i;
    end;

    p4.Origin = p5;
    p4.Forward = Unit;
    p4.Right = Unit2;
    p4.Up = v11;
    p4.MinX = v13;
    p4.MinY = v15;
    p4.StepX = (v14 - v13) / 16;
    p4.StepY = (v12 - v15) / 16;
    p4.MinNearest = v16;

    return true;
end;

local function fillWindow(p22) -- Line: 103
    local Pending = p22.Pending;
    local RowDepth = p22.RowDepth;

    for i = 1, 16 do
        Pending[i] = 65535;
        RowDepth[i] = p22.MinNearest;
        local _ = i;
    end;

    p22.PendingRows = 16;
end;

local function fillSilhouette(p23: any, p24: table, p25: number) -- Line: 113
    local Origin = p23.Origin;
    local Forward = p23.Forward;
    local Right = p23.Right;
    local Up = p23.Up;
    local MinX = p23.MinX;
    local MinY = p23.MinY;
    local StepX = p23.StepX;
    local StepY = p23.StepY;
    local Pending = p23.Pending;
    local RowDepth = p23.RowDepth;
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

    for i = 1, p25 do
        local v26 = p24[i] - Origin;
        local v27 = v26:Dot(Forward);
        local v28 = v26:Dot(Right) / v27;
        local v29 = v26:Dot(Up) / v27;
        local v30 = 0.75 / (v27 - 0.75);
        local v31 = v27 - 0.75;
        local math_ceil_ret = math.ceil((v29 - v30 - MinY) / StepY - 0.5);
        local math_clamp_ret = math.clamp(math_ceil_ret, 0, 15);
        local math_floor_ret = math.floor((v29 + v30 - MinY) / StepY - 0.5);
        local _ = i;

        for i2 = math_clamp_ret, math.clamp(math_floor_ret, 0, 15) do
            local v32 = MinY + (i2 + 0.5) * StepY - v29;
            local v33 = v30 * v30 - v32 * v32;
            local v34;

            if v33 < 0 then
                v34 = i2;
            else
                local math_sqrt_ret = math.sqrt(v33);
                local math_ceil_ret2 = math.ceil((v28 - math_sqrt_ret - MinX) / StepX - 0.5);
                local math_max_ret = math.max(math_ceil_ret2, 0);
                local math_floor_ret2 = math.floor((v28 + math_sqrt_ret - MinX) / StepX - 0.5);
                local math_min_ret = math.min(math_floor_ret2, 15);

                if math_max_ret <= math_min_ret then
                    local v35 = Pending[i2 + 1];
                    local v36 = bit32.lshift(1, math_min_ret + 1) - bit32.lshift(1, math_max_ret);
                    Pending[i2 + 1] = bit32.bor(v35, v36);
                    RowDepth[i2 + 1] = math.min(RowDepth[i2 + 1], v31);
                    v34 = i2;
                else
                    v34 = i2;
                end;
            end;
        end;

        local math_floor_ret2 = math.floor((v28 - MinX) / StepX);
        local math_clamp_ret2 = math.clamp(math_floor_ret2, 0, 15);
        local math_floor_ret3 = math.floor((v29 - MinY) / StepY);
        local v37 = math.clamp(math_floor_ret3, 0, 15) + 1;
        local v38 = Pending[v37];
        local bit32_lshift_ret = bit32.lshift(1, math_clamp_ret2);
        Pending[v37] = bit32.bor(v38, bit32_lshift_ret);
        RowDepth[v37] = math.min(RowDepth[v37], v31);
    end;

    local v39 = 0;

    for i = 1, 16 do
        local v40;

        if Pending[i] == 0 then
            v40 = i;
        else
            v39 = v39 + 1;
            v40 = i;
        end;
    end;

    p23.PendingRows = v39;
end;

local function rasterTriangle(p41: any, p42: vector, p43: vector, p44: vector) -- Line: 160
    local Origin = p41.Origin;
    local Forward = p41.Forward;
    local Right = p41.Right;
    local Up = p41.Up;
    local ClipX = p41.ClipX;
    local ClipY = p41.ClipY;
    local ClipW = p41.ClipW;
    local v45 = 0;

    for i = 1, 3 do
        local v46;

        if i == 1 then
            v46 = p42;
        elseif i == 2 then
            v46 = p43;
        else
            v46 = p44;
        end;

        local v47;

        if i == 1 then
            v47 = p43;
        elseif i == 2 then
            v47 = p44;
        else
            v47 = p42;
        end;

        local v48 = v46 - Origin;
        local v49 = v48:Dot(Forward);
        local v50 = (v47 - Origin):Dot(Forward);
        local v51 = v49 >= 0.05;

        if v51 then
            v45 = v45 + 1;
            ClipX[v45] = v48:Dot(Right) / v49;
            ClipY[v45] = v48:Dot(Up) / v49;
            ClipW[v45] = 1 / v49;
        end;

        local v52;

        if v51 == (v50 >= 0.05) then
            v52 = i;
        else
            local v53 = v48 + (v47 - v46) * ((0.05 - v49) / (v50 - v49));
            v45 = v45 + 1;
            ClipX[v45] = v53:Dot(Right) / 0.05;
            ClipY[v45] = v53:Dot(Up) / 0.05;
            ClipW[v45] = 20;
            v52 = i;
        end;
    end;

    if v45 < 3 then
        return false;
    end;

    local v54 = ClipX[1];
    local v55 = ClipY[1];
    local v56 = ClipW[1];
    local v57 = 2;
    local v58 = 3;
    local v59 = (ClipX[2] - v54) * (ClipY[3] - v55) - (ClipX[3] - v54) * (ClipY[2] - v55);
    local v60;

    if v45 == 4 then
        v60 = (ClipX[3] - v54) * (ClipY[4] - v55) - (ClipX[4] - v54) * (ClipY[3] - v55);

        if math.abs(v60) > math.abs(v59) then
            v58 = 4;
            v57 = 3;
        else
            v60 = v59;
        end;
    else
        v60 = v59;
    end;

    if math.abs(v60) < 1e-12 then
        return false;
    end;

    local v61 = ClipW[v57] - v56;
    local v62 = ClipW[v58] - v56;
    local v63 = (v61 * (ClipY[v58] - v55) - v62 * (ClipY[v57] - v55)) / v60;
    local v64 = ((ClipX[v57] - v54) * v62 - (ClipX[v58] - v54) * v61) / v60;
    local v65 = v56 - v63 * v54 - v64 * v55;
    local v66 = (1 / 0);
    local v67 = (-1 / 0);

    for i = 1, v45 do
        v66 = math.min(v66, ClipY[i]);
        v67 = math.max(v67, ClipY[i]);
        local _ = i;
    end;

    local MinX = p41.MinX;
    local MinY = p41.MinY;
    local StepX = p41.StepX;
    local StepY = p41.StepY;
    local v68 = StepX * 0.0001;
    local math_ceil_ret = math.ceil((v66 - MinY) / StepY - 0.5);
    local math_max_ret = math.max(math_ceil_ret, 0);
    local math_floor_ret = math.floor((v67 - MinY) / StepY - 0.5);
    local math_min_ret = math.min(math_floor_ret, 15);
    local Pending = p41.Pending;
    local RowDepth = p41.RowDepth;
    local v69 = false;

    for i = math_max_ret, math_min_ret do
        local v70 = Pending[i + 1];
        local v71;

        if v70 == 0 then
            v71 = i;
        else
            local v72 = MinY + (i + 0.5) * StepY;
            v71 = i;
            local v73 = (1 / 0);
            local v74 = (-1 / 0);

            for i2 = 1, v45 do
                local v75 = i2 == v45 and 1 or i2 + 1;
                local v76 = ClipY[i2];
                local v77 = ClipY[v75];
                local v78;

                if v76 <= v72 and v72 <= v77 or v77 <= v72 and v72 <= v76 then
                    local v79 = ClipX[i2];
                    local v80 = ClipX[v75];

                    if v76 == v77 then
                        v73 = math.min(v73, v79, v80);
                        v74 = math.max(v74, v79, v80);
                        v78 = i2;
                    else
                        local v81 = v79 + (v72 - v76) / (v77 - v76) * (v80 - v79);
                        v73 = math.min(v73, v81);
                        v74 = math.max(v74, v81);
                        v78 = i2;
                    end;
                else
                    v78 = i2;
                end;
            end;

            if v74 >= v73 then
                local v82 = v73 - v68;
                local v83 = v74 + v68;
                local v84 = 1 / (RowDepth[v71 + 1] - 0.02);
                local v85 = v64 * v72 + v65;
                local v86, v87, v88, v89, v90, v91, v92;

                if math.abs(v63) >= 1e-12 then
                    if v63 > 0 then
                        v82 = math.max(v82, (v84 - v85) / v63);
                    else
                        v83 = math.min(v83, (v84 - v85) / v63);
                    end;

                    v86 = math.ceil((v82 - MinX) / StepX - 0.5);
                    v87 = math.max(v86, 0);
                    v88 = math.floor((v83 - MinX) / StepX - 0.5);
                    v89 = math.min(v88, 15);

                    if v89 >= v87 then
                        v90 = bit32.lshift(1, v89 + 1) - bit32.lshift(1, v87);
                        v91 = bit32.band(v70, v90);

                        if v91 ~= 0 then
                            v92 = v70 - v91;
                            Pending[v71 + 1] = v92;

                            if v92 == 0 then
                                p41.PendingRows = p41.PendingRows - 1;
                            end;

                            v69 = true;
                        end;
                    end;
                end;

                if v85 > v84 then
                    v86 = math.ceil((v82 - MinX) / StepX - 0.5);
                    v87 = math.max(v86, 0);
                    v88 = math.floor((v83 - MinX) / StepX - 0.5);
                    v89 = math.min(v88, 15);

                    if v89 >= v87 then
                        v90 = bit32.lshift(1, v89 + 1) - bit32.lshift(1, v87);
                        v91 = bit32.band(v70, v90);

                        if v91 ~= 0 then
                            v92 = v70 - v91;
                            Pending[v71 + 1] = v92;

                            if v92 == 0 then
                                p41.PendingRows = p41.PendingRows - 1;
                            end;

                            v69 = true;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v69;
end;

local function sameList(p93: table, p94: table) -- Line: 276
    if #p93 ~= #p94 then
        return false;
    end;

    for i, v in p93 do
        if p94[i] ~= v then
            return false;
        end;
    end;

    return true;
end;

local function proved(p95: any, p96: table?) -- Line: 288
    local Contributors = p95.Contributors;

    if p96 ~= nil then
        local v97;

        if #Contributors == #p96 then
            v97 = true;

            for i, v in Contributors do
                if p96[i] ~= v then
                    v97 = false;
                    break;
                end;
            end;
        else
            v97 = false;
        end;

        if v97 then
            return true, p96;
        end;
    end;

    return true, table.clone(Contributors);
end;

function u1.new() -- Line: 296
    -- upvalues: u1 (copy), rasterTriangle (copy)
    local v98 = {
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
        Static = nil,
        Visit = nil,
        Pending = table.create(16, 0),
        RowDepth = table.create(16, 0),
        Contributors = table.create(96),
        Planes = table.create(4),
        ClipX = table.create(4),
        ClipY = table.create(4),
        ClipW = table.create(4)
    };
    local u99 = setmetatable(v98, u1);

    function u99.Visit(p100: number) -- Line: 319
        -- upvalues: u99 (copy), rasterTriangle (ref)
        local v101, v102, v103 = u99.Static:TriangleVertices(p100);

        if not rasterTriangle(u99, v101, v102, v103) then
            return false;
        end;

        local Contributors = u99.Contributors;

        if #Contributors < 96 then
            Contributors[#Contributors + 1] = p100;
        end;

        return u99.PendingRows == 0;
    end;

    return u99;
end;

function u1.OriginCovered(p104: any, p105: any, p106: vector, p107: table, p108: number, p109: table?, p110: number?, p111: table?) -- Line: 334
    -- upvalues: projectFrame (copy), fillWindow (copy), rasterTriangle (copy), proved (copy), fillSilhouette (copy)
    if p108 == 0 or not projectFrame(p104, p106, p107, p108) then
        return nil, nil;
    end;

    local Contributors = p104.Contributors;
    table.clear(Contributors);

    if p109 ~= nil and #p109 > 0 then
        fillWindow(p104);

        for _, v in p109 do
            local v112, v113, v114 = p105:TriangleVertices(v);

            if rasterTriangle(p104, v112, v113, v114) then
                Contributors[#Contributors + 1] = v;

                if p104.PendingRows == 0 then
                    return proved(p104, p109);
                end;
            end;
        end;

        table.clear(Contributors);
    end;

    fillSilhouette(p104, p107, p108);

    for i = 1, 2 do
        local v115;

        if i == 1 then
            v115 = p109;
        else
            v115 = p111;
        end;

        local v116;

        if v115 == nil then
            v116 = i;
        else
            v116 = i;

            for _, v in v115 do
                local v117, v118, v119 = p105:TriangleVertices(v);

                if rasterTriangle(p104, v117, v118, v119) then
                    if #Contributors < 96 then
                        Contributors[#Contributors + 1] = v;
                    end;

                    if p104.PendingRows == 0 then
                        return proved(p104, p109);
                    end;
                end;
            end;
        end;
    end;

    local Pending = p104.Pending;
    local RowDepth = p104.RowDepth;
    local v120 = 16;
    local v121 = 0;
    local v122 = 0;
    local v123 = -1;

    for i = 0, 15 do
        local v124 = Pending[i + 1];
        local v125;

        if v124 == 0 then
            v125 = i;
        else
            v120 = math.min(v120, i);
            v121 = bit32.bor(v121, v124);
            v122 = math.max(v122, RowDepth[i + 1]);
            v123 = i;
            v125 = v123;
            local v126 = v123;
            v123 = v125;
            v126 = v125;
        end;
    end;

    local bit32_countrz_ret = bit32.countrz(v121);
    local v127 = 31 - bit32.countlz(v121);
    local Forward = p104.Forward;
    local Right = p104.Right;
    local Up = p104.Up;
    local v128 = p104.MinX + p104.StepX * (v127 + 1);
    local v129 = p104.MinY + p104.StepY * v120;
    local v130 = p104.MinY + p104.StepY * (v123 + 1);
    local Planes = p104.Planes;
    Planes[1] = Right - Forward * (p104.MinX + p104.StepX * bit32_countrz_ret);
    Planes[2] = Forward * v128 - Right;
    Planes[3] = Up - Forward * v129;
    Planes[4] = Forward * v130 - Up;
    p104.Static = p105;
    local v131, v132 = p105:VisitFrustumTriangles(p106, Planes, Forward, 0.05, v122, p104.Visit, 20000, p110);
    p104.Static = nil;

    if v131 then
        return proved(p104, nil);
    end;

    if v132 then
        return false, nil;
    end;

    return nil, nil;
end;

return table.freeze(u1);