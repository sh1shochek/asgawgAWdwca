-- Decompiled with Potassium's decompiler.

local StaticOcclusionCodec = require(script.Parent.StaticOcclusionCodec);
local PVSCodec = require(script.Parent.PVSCodec);
local v1 = {};
local table_freeze_ret = table.freeze({ { 1, 3, 4 }, { 1, 4, 2 }, { 5, 6, 8 }, { 5, 8, 7 }, { 1, 5, 7 }, { 1, 7, 3 }, { 2, 4, 8 }, { 2, 8, 6 }, { 1, 2, 6 }, { 1, 6, 5 }, { 3, 7, 8 }, { 3, 8, 4 } });

local function isExactBlock(p2: userdata) -- Line: 81
    local v3 = p2:IsA("Part") and p2.Shape == Enum.PartType.Block;

    return v3;
end;

local function canonicalAxis(p4: vector) -- Line: 85
    local X = p4.X;
    local Y = p4.Y;
    local Z = p4.Z;
    local math_abs_ret = math.abs(X);
    local math_abs_ret2 = math.abs(Y);
    local math_abs_ret3 = math.abs(Z);
    local v5;

    if math_abs_ret2 <= math_abs_ret and math_abs_ret3 <= math_abs_ret then
        v5 = X < 0 and -1 or 1;
    elseif math_abs_ret3 <= math_abs_ret2 then
        v5 = Y < 0 and -1 or 1;
    else
        v5 = Z < 0 and -1 or 1;
    end;

    return p4 * v5;
end;

local function axisKey(p6: vector) -- Line: 94
    return `{string.format("%.9g", p6.X)},{string.format("%.9g", p6.Y)},{string.format("%.9g", p6.Z)}`;
end;

local function verticesForBlock(p7: userdata) -- Line: 98
    local v8 = p7.Size * 0.5;
    local table_create_ret = table.create(8);
    local v9 = 0;

    for _, v in { -v8.X, v8.X } do
        local v10 = v;

        for _, v2 in { -v8.Y, v8.Y } do
            local v11 = v2;

            for _, v3 in { -v8.Z, v8.Z } do
                v9 = v9 + 1;
                table_create_ret[v9] = p7.CFrame:PointToWorldSpace((Vector3.new(v10, v11, v3)));
            end;
        end;
    end;

    return table_create_ret;
end;

local function triangleItem(p12) -- Line: 113
    return {
        triangle = p12,
        minimum = p12.a:Min(p12.b):Min(p12.c),
        maximum = p12.a:Max(p12.b):Max(p12.c),
        centroid = (p12.a + p12.b + p12.c) / 3
    };
end;

local table_freeze_ret2 = table.freeze({ { 1, 3, 4 }, { 1, 4, 2 }, { 2, 4, 6 }, { 2, 6, 5 }, { 1, 5, 6 }, { 1, 6, 3 }, { 1, 2, 5 }, { 3, 6, 4 } });
local table_freeze_ret3 = table.freeze({ { 1, 3, 4 }, { 1, 4, 2 }, { 3, 4, 5 }, { 1, 3, 5 }, { 1, 5, 2 }, { 2, 5, 4 } });

local function verticesForWedge(p13: userdata) -- Line: 146
    local v14 = p13.Size * 0.5;
    local CFrame = p13.CFrame;

    return {
        CFrame:PointToWorldSpace((Vector3.new(-v14.X, -v14.Y, -v14.Z))),
        CFrame:PointToWorldSpace((Vector3.new(-v14.X, -v14.Y, v14.Z))),
        CFrame:PointToWorldSpace((Vector3.new(v14.X, -v14.Y, -v14.Z))),
        CFrame:PointToWorldSpace((Vector3.new(v14.X, -v14.Y, v14.Z))),
        CFrame:PointToWorldSpace((Vector3.new(-v14.X, v14.Y, v14.Z))),
        CFrame:PointToWorldSpace((Vector3.new(v14.X, v14.Y, v14.Z)))
    };
end;

local function verticesForCornerWedge(p15: userdata) -- Line: 159
    local v16 = p15.Size * 0.5;
    local CFrame = p15.CFrame;

    return {
        CFrame:PointToWorldSpace((Vector3.new(-v16.X, -v16.Y, -v16.Z))),
        CFrame:PointToWorldSpace((Vector3.new(-v16.X, -v16.Y, v16.Z))),
        CFrame:PointToWorldSpace((Vector3.new(v16.X, -v16.Y, -v16.Z))),
        CFrame:PointToWorldSpace((Vector3.new(v16.X, -v16.Y, v16.Z))),
        CFrame:PointToWorldSpace((Vector3.new(v16.X, v16.Y, -v16.Z)))
    };
end;

local function cylinderTriangles(p17: userdata, u18: number, u19: table) -- Line: 172
    -- upvalues: triangleItem (copy)
    local v20 = p17.Size * 0.5;
    local math_min_ret = math.min(v20.Y, v20.Z);
    local CFrame = p17.CFrame;
    local table_create_ret = table.create(24);

    for i = 0, 11 do
        local v21 = i / 12 * 3.141592653589793 * 2;
        local v22 = math.cos(v21) * math_min_ret;
        local v23 = math.sin(v21) * math_min_ret;
        table_create_ret[i * 2 + 1] = CFrame:PointToWorldSpace((Vector3.new(-v20.X, v22, v23)));
        table_create_ret[i * 2 + 2] = CFrame:PointToWorldSpace((Vector3.new(v20.X, v22, v23)));
        local _ = i;
    end;

    local function push(p24: vector, p25: vector, p26: vector) -- Line: 184
        -- upvalues: u19 (copy), triangleItem (ref), u18 (copy)
        u19[#u19 + 1] = triangleItem({
            a = p24,
            b = p25,
            c = p26,
            primitive = u18
        });
    end;

    for i = 0, 11 do
        local v27 = (i + 1) % 12;
        local v28 = table_create_ret[i * 2 + 1];
        local v29 = table_create_ret[i * 2 + 2];
        local v30 = table_create_ret[v27 * 2 + 2];
        u19[#u19 + 1] = triangleItem({
            a = v28,
            b = table_create_ret[v27 * 2 + 1],
            c = v30,
            primitive = u18
        });
        u19[#u19 + 1] = triangleItem({
            a = v28,
            b = v30,
            c = v29,
            primitive = u18
        });
        local _ = i;
    end;

    for i = 1, 10 do
        u19[#u19 + 1] = triangleItem({
            a = table_create_ret[1],
            b = table_create_ret[i * 2 + 1],
            c = table_create_ret[(i + 1) * 2 + 1],
            primitive = u18
        });
        u19[#u19 + 1] = triangleItem({
            a = table_create_ret[2],
            b = table_create_ret[(i + 1) * 2 + 2],
            c = table_create_ret[i * 2 + 2],
            primitive = u18
        });
        local _ = i;
    end;
end;

local function meshForPart(p31: userdata) -- Line: 200
    -- upvalues: verticesForWedge (copy), table_freeze_ret2 (copy), verticesForCornerWedge (copy), table_freeze_ret3 (copy)
    if p31:IsA("WedgePart") or p31:IsA("Part") and p31.Shape == Enum.PartType.Wedge then
        return verticesForWedge(p31), table_freeze_ret2;
    end;

    if p31:IsA("CornerWedgePart") or p31:IsA("Part") and p31.Shape == Enum.PartType.CornerWedge then
        return verticesForCornerWedge(p31), table_freeze_ret3;
    end;

    return nil, nil;
end;

local function isCylinder(p32: userdata) -- Line: 210
    local v33 = p32:IsA("Part") and p32.Shape == Enum.PartType.Cylinder;

    return v33;
end;

local function unionBounds(p34: table, p35: number?, p36: number?) -- Line: 214
    local v37 = Vector3.new(inf, inf, inf);
    local v38 = Vector3.new(-inf, -inf, -inf);

    for i = p35 or 1, p36 or #p34 do
        v37 = v37:Min(p34[i].minimum);
        v38 = v38:Max(p34[i].maximum);
        local _ = i;
    end;

    return {
        minimum = v37,
        maximum = v38
    };
end;

local function centroidAxis(p39: table) -- Line: 226
    local v40 = Vector3.new(inf, inf, inf);
    local v41 = Vector3.new(-inf, -inf, -inf);

    for _, v in p39 do
        v40 = v40:Min(v.centroid);
        v41 = v41:Max(v.centroid);
    end;

    local v42 = v41 - v40;

    return v42.X >= v42.Y and v42.X >= v42.Z and "X" or (v42.Y >= v42.Z and "Y" or "Z");
end;

local function buildBVH(p43: table) -- Line: 242
    -- upvalues: centroidAxis (copy), unionBounds (copy)
    local u44 = {};
    local u45 = {};
    local u46 = {};

    local function makeLeaf(p47: table) -- Line: 247
        -- upvalues: u45 (copy), u46 (copy)
        local v48 = #u45 + 1;

        for _, v in p47 do
            u46[#u46 + 1] = v.triangle;
        end;

        u45[v48] = {
            firstTriangle = #u46 + 1,
            triangleCount = #p47
        };

        return -v48;
    end;

    local function buildNode(p49: table) -- Line: 258
        -- upvalues: u44 (copy), centroidAxis (ref), makeLeaf (copy), buildNode (ref), unionBounds (ref)
        local v50 = #u44 + 1;
        u44[v50] = {
            children = {}
        };
        local u51 = centroidAxis(p49);
        table.sort(p49, function(p52, p53) -- Line: 262
            -- upvalues: u51 (copy)
            local v54 = p52.centroid[u51];
            local v55 = p53.centroid[u51];

            if v54 == v55 then
                return p52.triangle.primitive < p53.triangle.primitive;
            end;

            return v54 < v55;
        end);
        local math_ceil_ret = math.ceil(#p49 / 8);
        local math_max_ret = math.max(1, math_ceil_ret);
        local math_min_ret = math.min(8, math_max_ret);
        local v56 = 1;

        for i = 1, math_min_ret do
            local math_ceil_ret2 = math.ceil((#p49 - v56 + 1) / (math_min_ret - i + 1));
            local table_create_ret = table.create(math_ceil_ret2);

            for i2 = v56, v56 + math_ceil_ret2 - 1 do
                table_create_ret[#table_create_ret + 1] = p49[i2];
                local _ = i2;
            end;

            v56 = v56 + math_ceil_ret2;
            local v57;

            if #table_create_ret <= 8 then
                v57 = makeLeaf(table_create_ret);
            else
                v57 = buildNode(table_create_ret);
            end;

            local v58 = unionBounds(table_create_ret);
            u44[v50].children[i] = {
                minimum = v58.minimum,
                maximum = v58.maximum,
                reference = v57
            };
        end;

        return v50;
    end;

    return u44, u45, u46, buildNode(p43);
end;

local function planeForBlock(p59: userdata, p60: number) -- Line: 296
    local Size = p59.Size;
    local v61 = { p59.CFrame.RightVector, p59.CFrame.UpVector, p59.CFrame.ZVector };
    local v62 = { Size.X, Size.Y, Size.Z };
    local v63 = 1;
    local v64 = v62[2] < v62[v63] and 2 or v63;
    local v65 = v62[3] < v62[v64] and 3 or v64;
    local v66 = v65 == 1 and 2 or 1;
    local v67 = v65 == 3 and 2 or 3;
    local v68 = v66 == v67 and 3 or v67;
    local v69 = v61[v65];
    local X = v69.X;
    local Y = v69.Y;
    local Z = v69.Z;
    local math_abs_ret = math.abs(X);
    local math_abs_ret2 = math.abs(Y);
    local math_abs_ret3 = math.abs(Z);
    local v70;

    if math_abs_ret2 <= math_abs_ret and math_abs_ret3 <= math_abs_ret then
        v70 = X < 0 and -1 or 1;
    elseif math_abs_ret3 <= math_abs_ret2 then
        v70 = Y < 0 and -1 or 1;
    else
        v70 = Z < 0 and -1 or 1;
    end;

    local v71 = v69 * v70;
    local v72 = v61[v66];
    local X2 = v72.X;
    local Y2 = v72.Y;
    local Z2 = v72.Z;
    local math_abs_ret4 = math.abs(X2);
    local math_abs_ret5 = math.abs(Y2);
    local math_abs_ret6 = math.abs(Z2);
    local v73;

    if math_abs_ret5 <= math_abs_ret4 and math_abs_ret6 <= math_abs_ret4 then
        v73 = X2 < 0 and -1 or 1;
    elseif math_abs_ret6 <= math_abs_ret5 then
        v73 = Y2 < 0 and -1 or 1;
    else
        v73 = Z2 < 0 and -1 or 1;
    end;

    local v74 = v72 * v73;
    local v75 = v61[v68];
    local X3 = v75.X;
    local Y3 = v75.Y;
    local Z3 = v75.Z;
    local math_abs_ret7 = math.abs(X3);
    local math_abs_ret8 = math.abs(Y3);
    local math_abs_ret9 = math.abs(Z3);
    local v76;

    if math_abs_ret8 <= math_abs_ret7 and math_abs_ret9 <= math_abs_ret7 then
        v76 = X3 < 0 and -1 or 1;
    elseif math_abs_ret9 <= math_abs_ret8 then
        v76 = Y3 < 0 and -1 or 1;
    else
        v76 = Z3 < 0 and -1 or 1;
    end;

    local v77 = v75 * v76;
    local v78 = p59.Position:Dot(v71);
    local v79 = p59.Position:Dot(v74);
    local v80 = p59.Position:Dot(v77);
    local v81 = v62[v66] * 0.5;
    local v82 = v62[v68] * 0.5;

    return `{`{string.format("%.9g", v71.X)},{string.format("%.9g", v71.Y)},{string.format("%.9g", v71.Z)}`}|{`{string.format("%.9g", v74.X)},{string.format("%.9g", v74.Y)},{string.format("%.9g", v74.Z)}`}|{`{string.format("%.9g", v77.X)},{string.format("%.9g", v77.Y)},{string.format("%.9g", v77.Z)}`}|{string.format("%.9g", v78)}`, {
        origin = v71 * v78,
        u = v74,
        v = v77,
        normal = v71,
        rectangles = {}
    }, {
        minimumU = v79 - v81,
        maximumU = v79 + v81,
        minimumV = v80 - v82,
        maximumV = v80 + v82,
        primitive = p60
    };
end;

local function representativePosition(p83) -- Line: 338
    local v84 = (p83.minimum.X + p83.maximum.X) * 0.5;
    local math_min_ret = math.min(p83.minimum.Y + 3, (p83.minimum.Y + p83.maximum.Y) * 0.5);

    return Vector3.new(v84, math_min_ret, (p83.minimum.Z + p83.maximum.Z) * 0.5);
end;

local function buildCertificates(u85: table, u86: table, p87: any, p88: table?) -- Line: 346
    -- upvalues: PVSCodec (copy)
    if p87 == nil or #u85 == 0 then
        return {}, {};
    end;

    local table_create_ret = table.create(#p87.cells);

    for i = 1, #p87.cells do
        table_create_ret[i] = {};
        local _ = i;
    end;

    for _, v in p87.regions do
        table_create_ret[v.cluster][#table_create_ret[v.cluster] + 1] = v;
    end;

    local v89 = {};
    local v90 = {};
    local v91 = 0;
    local v92;

    if p88 == nil then
        v92 = 0;
    else
        local math_floor_ret = math.floor(p88.yieldEveryPairs or 0);
        v92 = math.max(math_floor_ret, 0);
    end;

    local function addSegmentCandidates(p93: vector, p94: vector, p95: table) -- Line: 367
        -- upvalues: u85 (copy), u86 (copy)
        for i, v in u85 do
            local v96 = (p93 - v.origin):Dot(v.normal);
            local v97 = (p94 - v.origin):Dot(v.normal);

            if v96 * v97 < -1e-6 then
                local v98 = -v96 / (v97 - v96);

                if v98 > 0 and v98 < 1 then
                    local v99 = p93:Lerp(p94, v98) - v.origin;
                    local v100 = v99:Dot(v.u);
                    local v101 = v99:Dot(v.v);
                    local v102 = i;

                    for i2 = v.firstRectangle, v.firstRectangle + v.rectangleCount - 1 do
                        local v103 = u86[i2];

                        if v103.minimumU <= v100 and (v100 <= v103.maximumU and (v103.minimumV <= v101 and v101 <= v103.maximumV)) then
                            local math_min_ret = math.min(v100 - v103.minimumU, v103.maximumU - v100, v101 - v103.minimumV, v103.maximumV - v101);
                            p95[v102] = math.max(p95[v102] or (-1 / 0), math_min_ret);
                            break;
                        end;

                        local _ = i2;
                    end;
                end;
            end;
        end;
    end;

    for i = 1, #p87.cells do
        local v104 = i;

        for i2 = i + 1, #p87.cells do
            local v105;

            if PVSCodec.isVisible(p87, v104, i2) then
                v105 = i2;
            else
                v91 = v91 + 1;
                v105 = i2;
                local v106 = {};

                for _, v in table_create_ret[v104] do
                    local v107 = v;

                    for _, v2 in table_create_ret[v105] do
                        local v108 = (v107.minimum.X + v107.maximum.X) * 0.5;
                        local math_min_ret = math.min(v107.minimum.Y + 3, (v107.minimum.Y + v107.maximum.Y) * 0.5);
                        local Vector3_new_ret = Vector3.new(v108, math_min_ret, (v107.minimum.Z + v107.maximum.Z) * 0.5);
                        local v109 = (v2.minimum.X + v2.maximum.X) * 0.5;
                        local math_min_ret2 = math.min(v2.minimum.Y + 3, (v2.minimum.Y + v2.maximum.Y) * 0.5);
                        addSegmentCandidates(Vector3_new_ret, Vector3.new(v109, math_min_ret2, (v2.minimum.Z + v2.maximum.Z) * 0.5), v106);
                    end;
                end;

                local v110 = {};

                for i3, v in v106 do
                    v110[#v110 + 1] = {
                        plane = i3,
                        score = v
                    };
                end;

                table.sort(v110, function(p111, p112) -- Line: 422
                    if p111.score == p112.score then
                        return p111.plane < p112.plane;
                    end;

                    return p111.score > p112.score;
                end);
                local v113 = {};

                for i3 = 1, math.min(#v110, 8) do
                    v113[i3] = v110[i3].plane;
                    local _ = i3;
                end;

                if #v113 > 0 then
                    for _, v in v113 do
                        v90[#v90 + 1] = v;
                    end;

                    local v114 = {};
                    local bit32_lshift_ret = bit32.lshift(v104, 16);
                    v114.pairKey = bit32.bor(bit32_lshift_ret, v105);
                    v114.firstCandidate = #v90 + 1;
                    v114.candidateCount = #v113;
                    v89[#v89 + 1] = v114;
                end;

                if v92 > 0 and v91 % v92 == 0 then
                    if p88 and p88.onCertificateProgress then
                        p88.onCertificateProgress(v91, #v89);
                    end;

                    task.wait();
                end;
            end;
        end;
    end;

    return v89, v90;
end;

function v1.build(p115: table, p116: any, p117: table?) -- Line: 454
    -- upvalues: meshForPart (copy), triangleItem (copy), cylinderTriangles (copy), verticesForBlock (copy), table_freeze_ret (copy), planeForBlock (copy), buildBVH (copy), buildCertificates (copy), StaticOcclusionCodec (copy)
    local v118 = {};
    local v119 = {};
    local v120 = 0;
    local u121 = Vector3.new(inf, inf, inf);
    local u122 = Vector3.new(-inf, -inf, -inf);

    local function includeBounds(p123: vector) -- Line: 465
        -- upvalues: u121 (ref), u122 (ref)
        u121 = u121:Min(p123);
        u122 = u122:Max(p123);
    end;

    for i, v in p115.parts do
        local v124 = v:IsA("Part") and v.Shape == Enum.PartType.Block;

        if v124 then
            v120 = v120 + 1;
            local v125 = verticesForBlock(v);
            local v126 = i;

            for _, v2 in v125 do
                u121 = u121:Min(v2);
                u122 = u122:Max(v2);
            end;

            for _, v2 in table_freeze_ret do
                v118[#v118 + 1] = triangleItem({
                    a = v125[v2[1]],
                    b = v125[v2[2]],
                    c = v125[v2[3]],
                    primitive = v126
                });
            end;

            local v127, v128, v129 = planeForBlock(v, v126);
            local v130 = v119[v127];

            if v130 == nil then
                v119[v127] = v128;
            else
                v128 = v130;
            end;

            v128.rectangles[#v128.rectangles + 1] = v129;
        else
            local v131, v132 = meshForPart(v);

            if v131 == nil or v132 == nil then
                local v133 = v:IsA("Part") and v.Shape == Enum.PartType.Cylinder;

                if v133 then
                    v120 = v120 + 1;
                    cylinderTriangles(v, i, v118);

                    for i2 = #v118 + 1, #v118 do
                        local minimum = v118[i2].minimum;
                        u121 = u121:Min(minimum);
                        u122 = u122:Max(minimum);
                        local maximum = v118[i2].maximum;
                        u121 = u121:Min(maximum);
                        u122 = u122:Max(maximum);
                        local _ = i2;
                    end;
                end;
            else
                v120 = v120 + 1;
                local v134 = i;

                for _, v2 in v131 do
                    u121 = u121:Min(v2);
                    u122 = u122:Max(v2);
                end;

                for _, v2 in v132 do
                    v118[#v118 + 1] = triangleItem({
                        a = v131[v2[1]],
                        b = v131[v2[2]],
                        c = v131[v2[3]],
                        primitive = v134
                    });
                end;
            end;
        end;
    end;

    local v135 = 0;
    local v136;

    if p117 == nil then
        v136 = nil;
    else
        v136 = p117.walkMesh;
    end;

    if v136 ~= nil then
        local v137 = #p115.parts + 1;
        local Vertices = v136.Vertices;

        for _, v in v136.Triangles do
            local v138 = Vertices[v.A];
            local v139 = Vertices[v.B];
            local v140 = Vertices[v.C];

            if v138 ~= nil and (v139 ~= nil and v140 ~= nil) then
                u121 = u121:Min(v138);
                u122 = u122:Max(v138);
                u121 = u121:Min(v139);
                u122 = u122:Max(v139);
                u121 = u121:Min(v140);
                u122 = u122:Max(v140);
                v118[#v118 + 1] = triangleItem({
                    a = v138,
                    b = v139,
                    c = v140,
                    primitive = v137
                });
                v135 = v135 + 1;
            end;
        end;
    end;

    local v141 = {
        nodes = 0,
        leaves = 0,
        planes = 0,
        rectangles = 0,
        encodedBytes = 0,
        certificates = 0,
        candidates = 0,
        inputPrimitives = #p115.parts,
        trianglePrimitives = v120,
        omittedPrimitives = #p115.parts - v120,
        triangles = #v118,
        walkMeshTriangles = v135
    };

    if #v118 == 0 then
        return nil, v141, "NoExactBlockPrimitives";
    end;

    local v142, v143, v144, v145 = buildBVH(v118);
    local v146 = {};

    for i in v119 do
        v146[#v146 + 1] = i;
    end;

    table.sort(v146);
    local v147 = {};
    local v148 = {};

    for _, v in v146 do
        local v149 = v119[v];
        table.sort(v149.rectangles, function(p150, p151) -- Line: 563
            if p150.minimumU ~= p151.minimumU then
                return p150.minimumU < p151.minimumU;
            end;

            if p150.minimumV == p151.minimumV then
                return p150.primitive < p151.primitive;
            end;

            return p150.minimumV < p151.minimumV;
        end);

        for _, v2 in v149.rectangles do
            v147[#v147 + 1] = v2;
        end;

        v148[#v148 + 1] = {
            origin = v149.origin,
            u = v149.u,
            v = v149.v,
            normal = v149.normal,
            firstRectangle = #v147 + 1,
            rectangleCount = #v149.rectangles
        };
    end;

    local v152 = {
        minimum = u121,
        maximum = u122
    };
    local v153, v154 = buildCertificates(v148, v147, p116, p117);
    local v155 = StaticOcclusionCodec.encode({
        fingerprint = p115.fingerprint,
        worldBounds = v152,
        rootNode = v145,
        nodes = v142,
        leaves = v143,
        triangles = v144,
        planes = v148,
        rectangles = v147,
        certificates = v153,
        candidates = v154
    });
    v141.triangles = #v144;
    v141.nodes = #v142;
    v141.leaves = #v143;
    v141.planes = #v148;
    v141.rectangles = #v147;
    v141.encodedBytes = #v155;
    v141.certificates = #v153;
    v141.candidates = #v154;

    return v155, v141, nil;
end;

return table.freeze(v1);