-- ReplicatedStorage.Visibility.StaticOcclusionRuntime
-- Script path: ReplicatedStorage.Visibility.StaticOcclusionRuntime
-- Decompile time: 48.09 ms

-- Decompiled with Potassium's decompiler.

local StaticOcclusionCodec = require(script.Parent.StaticOcclusionCodec);
local u1 = {};
u1.__index = u1;
local NODE_SIZE = StaticOcclusionCodec.NODE_SIZE;
local LEAF_SIZE = StaticOcclusionCodec.LEAF_SIZE;
local INDEXED_VERSION = StaticOcclusionCodec.INDEXED_VERSION;
local VERTEX_SIZE = StaticOcclusionCodec.VERTEX_SIZE;
local PLANE_SIZE = StaticOcclusionCodec.PLANE_SIZE;
local RECT_SIZE = StaticOcclusionCodec.RECT_SIZE;
local CERTIFICATE_SIZE = StaticOcclusionCodec.CERTIFICATE_SIZE;
local CANDIDATE_SIZE = StaticOcclusionCodec.CANDIDATE_SIZE;

local function readVector(p2: buffer, p3: number) -- Line: 119
    local buffer_readf32_ret = buffer.readf32(p2, p3);
    local buffer_readf32_ret2 = buffer.readf32(p2, p3 + 4);
    local buffer_readf32_ret3 = buffer.readf32(p2, p3 + 8);

    return Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
end;

local function readTriangle(p4: any, p5: number) -- Line: 127
    -- upvalues: INDEXED_VERSION (copy), VERTEX_SIZE (copy)
    local buffer2 = p4.buffer;
    local v6 = p4.triangleOffset + (p5 - 1) * p4.triangleSize;

    if p4.version ~= INDEXED_VERSION then
        local buffer_readf32_ret = buffer.readf32(buffer2, v6);
        local buffer_readf32_ret2 = buffer.readf32(buffer2, v6 + 4);
        local buffer_readf32_ret3 = buffer.readf32(buffer2, v6 + 8);
        local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
        local v7 = v6 + 12;
        local buffer_readf32_ret4 = buffer.readf32(buffer2, v7);
        local buffer_readf32_ret5 = buffer.readf32(buffer2, v7 + 4);
        local buffer_readf32_ret6 = buffer.readf32(buffer2, v7 + 8);
        local Vector3_new_ret2 = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
        local v8 = v6 + 24;
        local buffer_readf32_ret7 = buffer.readf32(buffer2, v8);
        local buffer_readf32_ret8 = buffer.readf32(buffer2, v8 + 4);
        local buffer_readf32_ret9 = buffer.readf32(buffer2, v8 + 8);

        return Vector3_new_ret, Vector3_new_ret2, Vector3.new(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9), buffer.readu32(buffer2, v6 + 36);
    end;

    local buffer_readu32_ret = buffer.readu32(buffer2, v6);
    local buffer_readu32_ret2 = buffer.readu32(buffer2, v6 + 4);
    local buffer_readu32_ret3 = buffer.readu32(buffer2, v6 + 8);
    local v9 = p4.vertexOffset + (buffer_readu32_ret - 1) * VERTEX_SIZE;
    local buffer_readf32_ret = buffer.readf32(buffer2, v9);
    local buffer_readf32_ret2 = buffer.readf32(buffer2, v9 + 4);
    local buffer_readf32_ret3 = buffer.readf32(buffer2, v9 + 8);
    local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local v10 = p4.vertexOffset + (buffer_readu32_ret2 - 1) * VERTEX_SIZE;
    local buffer_readf32_ret4 = buffer.readf32(buffer2, v10);
    local buffer_readf32_ret5 = buffer.readf32(buffer2, v10 + 4);
    local buffer_readf32_ret6 = buffer.readf32(buffer2, v10 + 8);
    local Vector3_new_ret2 = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
    local v11 = p4.vertexOffset + (buffer_readu32_ret3 - 1) * VERTEX_SIZE;
    local buffer_readf32_ret7 = buffer.readf32(buffer2, v11);
    local buffer_readf32_ret8 = buffer.readf32(buffer2, v11 + 4);
    local buffer_readf32_ret9 = buffer.readf32(buffer2, v11 + 8);

    return Vector3_new_ret, Vector3_new_ret2, Vector3.new(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9), 0;
end;

local function segmentIntersectsBounds(p12: vector, p13: number, p14: number, p15: number, p16: vector, p17: vector, p18: number) -- Line: 145
    local v19 = 0;

    if p13 == 0 then
        if p12.X < p16.X or p12.X > p17.X then
            return false;
        end;
    else
        local v20 = (p16.X - p12.X) * p13;
        local v21 = (p17.X - p12.X) * p13;
        local math_min_ret = math.min(v20, v21);
        v19 = math.max(v19, math_min_ret);
        local math_max_ret = math.max(v20, v21);
        p18 = math.min(p18, math_max_ret);

        if p18 < v19 then
            return false;
        end;
    end;

    if p14 == 0 then
        if p12.Y < p16.Y or p12.Y > p17.Y then
            return false;
        end;
    else
        local v22 = (p16.Y - p12.Y) * p14;
        local v23 = (p17.Y - p12.Y) * p14;
        local math_min_ret = math.min(v22, v23);
        v19 = math.max(v19, math_min_ret);
        local math_max_ret = math.max(v22, v23);
        p18 = math.min(p18, math_max_ret);

        if p18 < v19 then
            return false;
        end;
    end;

    if p15 == 0 then
        if p12.Z < p16.Z or p12.Z > p17.Z then
            return false;
        end;
    else
        local v24 = (p16.Z - p12.Z) * p15;
        local v25 = (p17.Z - p12.Z) * p15;
        local math_min_ret = math.min(v24, v25);
        local math_max_ret = math.max(v19, math_min_ret);
        local math_max_ret2 = math.max(v24, v25);

        if math.min(p18, math_max_ret2) < math_max_ret then
            return false;
        end;
    end;

    return true;
end;

local function segmentIntersectsBox(p26: number, p27: number, p28: number, p29: number, p30: number, p31: number, p32: buffer, p33: number, p34: number) -- Line: 197
    local v35 = 0;
    local buffer_readf32_ret = buffer.readf32(p32, p33);
    local buffer_readf32_ret2 = buffer.readf32(p32, p33 + 12);

    if p29 == 0 then
        if p26 < buffer_readf32_ret or buffer_readf32_ret2 < p26 then
            return false;
        end;
    else
        local v36 = (buffer_readf32_ret - p26) * p29;
        local v37 = (buffer_readf32_ret2 - p26) * p29;
        local math_min_ret = math.min(v36, v37);
        v35 = math.max(v35, math_min_ret);
        local math_max_ret = math.max(v36, v37);
        p34 = math.min(p34, math_max_ret);

        if p34 < v35 then
            return false;
        end;
    end;

    local buffer_readf32_ret3 = buffer.readf32(p32, p33 + 4);
    local buffer_readf32_ret4 = buffer.readf32(p32, p33 + 16);

    if p30 == 0 then
        if p27 < buffer_readf32_ret3 or buffer_readf32_ret4 < p27 then
            return false;
        end;
    else
        local v38 = (buffer_readf32_ret3 - p27) * p30;
        local v39 = (buffer_readf32_ret4 - p27) * p30;
        local math_min_ret = math.min(v38, v39);
        v35 = math.max(v35, math_min_ret);
        local math_max_ret = math.max(v38, v39);
        p34 = math.min(p34, math_max_ret);

        if p34 < v35 then
            return false;
        end;
    end;

    local buffer_readf32_ret5 = buffer.readf32(p32, p33 + 8);
    local buffer_readf32_ret6 = buffer.readf32(p32, p33 + 20);

    if p31 == 0 then
        if p28 < buffer_readf32_ret5 or buffer_readf32_ret6 < p28 then
            return false;
        end;
    else
        local v40 = (buffer_readf32_ret5 - p28) * p31;
        local v41 = (buffer_readf32_ret6 - p28) * p31;
        local math_min_ret = math.min(v40, v41);
        local math_max_ret = math.max(v35, math_min_ret);
        local math_max_ret2 = math.max(v40, v41);

        if math.min(p34, math_max_ret2) < math_max_ret then
            return false;
        end;
    end;

    return true;
end;

local function segmentEdgesFraction(p42: vector, p43: vector, p44: vector, p45: vector, p46: vector, p47: number?) -- Line: 255
    local v48 = p43:Cross(p46);
    local v49 = p45:Dot(v48);

    if math.abs(v49) <= 1e-7 then
        return nil;
    end;

    local v50 = 1 / v49;
    local v51 = p42 - p44;
    local v52 = v51:Dot(v48) * v50;
    local v53 = p47 or -1e-7;

    if v52 < v53 or 1 - v53 < v52 then
        return nil;
    end;

    local v54 = v51:Cross(p45);
    local v55 = p43:Dot(v54) * v50;

    if v55 < v53 or v52 + v55 > 1 - v53 then
        return nil;
    end;

    local v56 = p46:Dot(v54) * v50;

    if v56 >= 1e-7 and v56 <= 0.9999999 then
        return v56;
    end;

    return nil;
end;

local function segmentTriangleFraction(p57: vector, p58: vector, p59: vector, p60: vector, p61: vector) -- Line: 284
    -- upvalues: segmentEdgesFraction (copy)
    return segmentEdgesFraction(p57, p58, p59, p60 - p59, p61 - p59);
end;

function u1.new(p62: string, p63: string?, p64: function?) -- Line: 288
    -- upvalues: StaticOcclusionCodec (copy), u1 (copy)
    local v65 = StaticOcclusionCodec.decode(p62, p64);

    if p63 ~= nil and v65.fingerprint ~= p63 then
        error("PVBVH1 fingerprint does not match the expected visibility geometry");
    end;

    local v66 = {
        PlaneMarkToken = 0,
        Data = v65,
        SamplePacketIds = {},
        SamplePackets = {},
        Stack = table.create((math.max(v65.nodeCount, 8))),
        TriangleCacheIds = table.create(4096, 0),
        TriangleCacheA = table.create(4096),
        TriangleCacheFirstEdge = table.create(4096),
        TriangleCacheSecondEdge = table.create(4096),
        PlaneMarks = buffer.create(math.max(v65.planeCount, 1) * 4),
        CandidatePlanes = table.create(v65.planeCount),
        ChildReferences = table.create(8),
        ChildDepths = table.create(8),
        PlaneX = table.create(8),
        PlaneY = table.create(8),
        PlaneZ = table.create(8),
        ViewerProjectionScratch = buffer.create(48960),
        TargetProjectionScratch = buffer.create(48960),
        VolumePairMarks = buffer.create(65025),
        BatchProjectionScratch = buffer.create(48960),
        BatchVolumePairMarks = buffer.create(65025)
    };

    return setmetatable(v66, u1);
end;

function u1.GetFingerprint(p67) -- Line: 323
    return p67.Data.fingerprint;
end;

function u1.InstallProofs(u68: any, u69: string, u70: function?) -- Line: 328
    u68.Proofs = nil;
    local success, result = pcall(function() -- Line: 334
        -- upvalues: u69 (copy), u68 (copy), u70 (copy)
        return require(script.Parent.ExactOcclusionProofs).new(u69, u68.Data, u70);
    end);

    if not success then
        return false, tostring(result);
    end;

    u68.Proofs = result;

    return true, nil;
end;

local function querySegment(p71: any, p72: vector, p73: vector, p74: table?, p75: boolean, p76: number?, p77: number?) -- Line: 345
    -- upvalues: NODE_SIZE (copy), segmentIntersectsBox (copy), LEAF_SIZE (copy), readTriangle (copy), segmentEdgesFraction (copy)
    local v78 = p73 - p72;

    if v78:Dot(v78) <= 1e-7 then
        return false, nil, nil, nil;
    end;

    local v79 = math.abs(v78.X) <= 1e-7 and 0 or 1 / v78.X;
    local v80 = math.abs(v78.Y) <= 1e-7 and 0 or 1 / v78.Y;
    local v81 = math.abs(v78.Z) <= 1e-7 and 0 or 1 / v78.Z;
    local Data = p71.Data;
    local buffer2 = Data.buffer;
    local Stack = p71.Stack;
    Stack[1] = p77 or Data.rootNode;
    local X = p72.X;
    local Y = p72.Y;
    local Z = p72.Z;
    local nodeOffset = Data.nodeOffset;
    local leafOffset = Data.leafOffset;
    local v82 = 1;
    local v83 = 0;
    local v84 = 1;
    local v85 = nil;
    local v86 = nil;

    while v82 > 0 do
        if p76 and (v83 % 32 == 0 and p76 <= os.clock()) then
            return false, nil, nil, nil, false;
        end;

        v83 = v83 + 1;
        local v87 = Stack[v82];
        v82 = v82 - 1;

        if p74 then
            p74.nodes = p74.nodes + 1;
        end;

        local v88 = nodeOffset + (v87 - 1) * NODE_SIZE;

        for i = 1, 8 do
            local buffer_readi32_ret = buffer.readi32(buffer2, v88 + 192 + (i - 1) * 4);
            local v89;

            if buffer_readi32_ret == 0 or not segmentIntersectsBox(X, Y, Z, v79, v80, v81, buffer2, v88 + (i - 1) * 24, v84) then
                v89 = i;
            elseif buffer_readi32_ret > 0 then
                v82 = v82 + 1;
                Stack[v82] = buffer_readi32_ret;
                v89 = i;
            else
                local v90 = leafOffset + (-buffer_readi32_ret - 1) * LEAF_SIZE;
                local buffer_readu32_ret = buffer.readu32(buffer2, v90);
                v89 = i;

                for i2 = buffer_readu32_ret, buffer_readu32_ret + buffer.readu16(buffer2, v90 + 4) - 1 do
                    if p74 then
                        p74.triangles = p74.triangles + 1;
                    end;

                    local v91, v92, v93, v94 = readTriangle(Data, i2);
                    local v95 = segmentEdgesFraction(p72, v78, v91, v92 - v91, v93 - v91);
                    local v96;

                    if v95 == nil or v95 >= v84 then
                        v96 = i2;
                    else
                        if not p75 then
                            p71.LastHitNode = v87;

                            return true, v94, i2, v95;
                        end;

                        v86 = v94;
                        v85 = i2;
                        v96 = v85;
                        v84 = v95;
                        local v97 = v85;
                        v85 = v96;
                        v97 = v96;
                        v96 = v85;
                    end;
                end;
            end;
        end;
    end;

    local v98 = v85 ~= nil;

    if v85 == nil then
        return v98, v86, v85, nil;
    end;

    return v98, v86, v85, v84;
end;

function u1.SegmentBlocked(p99: any, p100: vector, p101: vector, p102: table?, p103: number?, p104: number?) -- Line: 433
    -- upvalues: querySegment (copy)
    if p104 and (p104 >= 1 and (p104 <= p99.Data.nodeCount and (p104 % 1 == 0 and p104 ~= p99.Data.rootNode))) then
        local v105, v106, v107, _, v108 = querySegment(p99, p100, p101, p102, false, p103, p104);

        if v108 == false then
            return false, nil, nil, false;
        end;

        if v105 then
            return true, v106, v107, true;
        end;
    end;

    local v109, v110, v111, _, v112 = querySegment(p99, p100, p101, p102, false, p103);

    return v109, v110, v111, v112 ~= false;
end;

local function boxMaxAlong(p113: vector, p114: vector, p115: vector, p116: vector) -- Line: 456
    local v117;

    if p113.X >= 0 then
        v117 = p116.X;
    else
        v117 = p115.X;
    end;

    local v118;

    if p113.Y >= 0 then
        v118 = p116.Y;
    else
        v118 = p115.Y;
    end;

    local v119;

    if p113.Z >= 0 then
        v119 = p116.Z;
    else
        v119 = p115.Z;
    end;

    return (v117 - p114.X) * p113.X + (v118 - p114.Y) * p113.Y + (v119 - p114.Z) * p113.Z;
end;

function u1.VisitFrustumTriangles(p120: any, p121: vector, p122: table, p123: vector, p124: number, p125: number, p126: function, p127: number, p128: number?) -- Line: 464
    -- upvalues: LEAF_SIZE (copy), NODE_SIZE (copy)
    local Data = p120.Data;
    local buffer2 = Data.buffer;
    local Stack = p120.Stack;
    local ChildReferences = p120.ChildReferences;
    local ChildDepths = p120.ChildDepths;
    Stack[1] = Data.rootNode;
    local v129 = -p123;
    local X = p121.X;
    local Y = p121.Y;
    local Z = p121.Z;
    local X2 = p123.X;
    local Y2 = p123.Y;
    local Z2 = p123.Z;
    local X3 = v129.X;
    local Y3 = v129.Y;
    local Z3 = v129.Z;
    local v130 = #p122;
    local PlaneX = p120.PlaneX;
    local PlaneY = p120.PlaneY;
    local PlaneZ = p120.PlaneZ;
    local v131 = 1;
    local v132 = 0;
    local v133 = 0;

    for i = 1, v130 do
        local v134 = p122[i];
        local Y4 = v134.Y;
        local Z4 = v134.Z;
        PlaneX[i] = v134.X;
        PlaneY[i] = Y4;
        PlaneZ[i] = Z4;
        local _ = i;
    end;

    local leafOffset = Data.leafOffset;
    local nodeOffset = Data.nodeOffset;

    while true do
        local v135;

        while true do
            if v131 <= 0 then
                return false, true;
            end;

            if p128 and (v132 % 32 == 0 and p128 <= os.clock()) then
                return false, false;
            end;

            v132 = v132 + 1;
            v135 = Stack[v131];
            v131 = v131 - 1;

            if v135 >= 0 then
                break;
            end;

            local v136 = leafOffset + (-v135 - 1) * LEAF_SIZE;
            local buffer_readu32_ret = buffer.readu32(buffer2, v136);
            local buffer_readu16_ret = buffer.readu16(buffer2, v136 + 4);
            v133 = v133 + buffer_readu16_ret;

            if p127 < v133 then
                return false, false;
            end;

            for i = buffer_readu32_ret, buffer_readu32_ret + buffer_readu16_ret - 1 do
                if p126(i) then
                    return true, true;
                end;

                local _ = i;
            end;
        end;

        local v137 = nodeOffset + (v135 - 1) * NODE_SIZE;
        local v138 = 0;

        for i = 1, 8 do
            local buffer_readi32_ret = buffer.readi32(buffer2, v137 + 192 + (i - 1) * 4);
            local v139;

            if buffer_readi32_ret == 0 then
                v139 = i;
            else
                local v140 = v137 + (i - 1) * 24;
                local buffer_readf32_ret = buffer.readf32(buffer2, v140);
                local buffer_readf32_ret2 = buffer.readf32(buffer2, v140 + 4);
                local buffer_readf32_ret3 = buffer.readf32(buffer2, v140 + 8);
                local buffer_readf32_ret4 = buffer.readf32(buffer2, v140 + 12);
                local buffer_readf32_ret5 = buffer.readf32(buffer2, v140 + 16);
                local buffer_readf32_ret6 = buffer.readf32(buffer2, v140 + 20);
                local v141;

                if X3 >= 0 then
                    v141 = buffer_readf32_ret4;
                else
                    v141 = buffer_readf32_ret;
                end;

                local v142;

                if Y3 >= 0 then
                    v142 = buffer_readf32_ret5;
                else
                    v142 = buffer_readf32_ret2;
                end;

                local v143;

                if Z3 >= 0 then
                    v143 = buffer_readf32_ret6;
                else
                    v143 = buffer_readf32_ret3;
                end;

                local v144 = -((v141 - X) * X3 + (v142 - Y) * Y3 + (v143 - Z) * Z3);

                if p125 < v144 then
                    v139 = i;
                else
                    local v145;

                    if X2 >= 0 then
                        v145 = buffer_readf32_ret4;
                    else
                        v145 = buffer_readf32_ret;
                    end;

                    local v146;

                    if Y2 >= 0 then
                        v146 = buffer_readf32_ret5;
                    else
                        v146 = buffer_readf32_ret2;
                    end;

                    local v147;

                    if Z2 >= 0 then
                        v147 = buffer_readf32_ret6;
                    else
                        v147 = buffer_readf32_ret3;
                    end;

                    if (v145 - X) * X2 + (v146 - Y) * Y2 + (v147 - Z) * Z2 < p124 then
                        v139 = i;
                    else
                        v139 = i;
                        local v148 = false;

                        for i2 = 1, v130 do
                            local v149 = PlaneX[i2];
                            local v150 = PlaneY[i2];
                            local v151 = PlaneZ[i2];
                            local v152;

                            if v149 >= 0 then
                                v152 = buffer_readf32_ret4;
                            else
                                v152 = buffer_readf32_ret;
                            end;

                            local v153;

                            if v150 >= 0 then
                                v153 = buffer_readf32_ret5;
                            else
                                v153 = buffer_readf32_ret2;
                            end;

                            local v154;

                            if v151 >= 0 then
                                v154 = buffer_readf32_ret6;
                            else
                                v154 = buffer_readf32_ret3;
                            end;

                            if (v152 - X) * v149 + (v153 - Y) * v150 + (v154 - Z) * v151 < 0 then
                                v148 = true;
                                break;
                            end;

                            local _ = i2;
                        end;

                        if not v148 then
                            local v155 = v138 + 1;
                            v138 = v155;

                            while v155 > 1 and ChildDepths[v155 - 1] < v144 do
                                ChildDepths[v155] = ChildDepths[v155 - 1];
                                ChildReferences[v155] = ChildReferences[v155 - 1];
                                v155 = v155 - 1;
                            end;

                            ChildDepths[v155] = v144;
                            ChildReferences[v155] = buffer_readi32_ret;
                        end;
                    end;
                end;
            end;
        end;

        for i = 1, v138 do
            v131 = v131 + 1;
            Stack[v131] = ChildReferences[i];
            local _ = i;
        end;
    end;
end;

function u1.TriangleVertices(p156: any, p157: number) -- Line: 582
    -- upvalues: readTriangle (copy)
    local v158 = (p157 - 1) % 4096 + 1;

    if p156.TriangleCacheIds[v158] ~= p157 then
        local v159, v160, v161 = readTriangle(p156.Data, p157);
        p156.TriangleCacheIds[v158] = p157;
        p156.TriangleCacheA[v158] = v159;
        p156.TriangleCacheFirstEdge[v158] = v160 - v159;
        p156.TriangleCacheSecondEdge[v158] = v161 - v159;
    end;

    local v162 = p156.TriangleCacheA[v158];

    return v162, v162 + p156.TriangleCacheFirstEdge[v158], v162 + p156.TriangleCacheSecondEdge[v158];
end;

function u1.NearestSegmentHit(p163: any, p164: vector, p165: vector) -- Line: 601
    -- upvalues: querySegment (copy)
    local _, _, _, v166 = querySegment(p163, p164, p165, nil, true);

    return v166;
end;

function u1.TriangleBlocksSegment(p167: any, p168: number, p169: vector, p170: vector) -- Line: 611
    -- upvalues: readTriangle (copy), segmentEdgesFraction (copy)
    local Data = p167.Data;

    if p168 < 1 or Data.triangleCount < p168 then
        return false;
    end;

    local v171 = p170 - p169;

    if v171:Dot(v171) <= 1e-7 then
        return false;
    end;

    local v172 = (p168 - 1) % 4096 + 1;

    if p167.TriangleCacheIds[v172] ~= p168 then
        local v173, v174, v175 = readTriangle(Data, p168);
        p167.TriangleCacheIds[v172] = p168;
        p167.TriangleCacheA[v172] = v173;
        p167.TriangleCacheFirstEdge[v172] = v174 - v173;
        p167.TriangleCacheSecondEdge[v172] = v175 - v173;
    end;

    return segmentEdgesFraction(p169, v171, p167.TriangleCacheA[v172], p167.TriangleCacheFirstEdge[v172], p167.TriangleCacheSecondEdge[v172]) ~= nil;
end;

function u1.FirstBlockingTriangle(p176: any, p177: table, p178: number, p179: vector, p180: vector) -- Line: 643
    -- upvalues: readTriangle (copy), segmentEdgesFraction (copy)
    local v181 = #p177;

    if v181 == 0 then
        return 0;
    end;

    local v182 = (p178 < 1 or v181 < p178) and 1 or p178;
    local v183 = p180 - p179;

    if v183:Dot(v183) <= 1e-7 then
        return 0;
    end;

    local Data = p176.Data;
    local triangleCount = Data.triangleCount;
    local TriangleCacheIds = p176.TriangleCacheIds;
    local TriangleCacheA = p176.TriangleCacheA;
    local TriangleCacheFirstEdge = p176.TriangleCacheFirstEdge;
    local TriangleCacheSecondEdge = p176.TriangleCacheSecondEdge;

    for i = 1, v181 do
        local v184 = p177[v182];

        if v184 >= 1 and v184 <= triangleCount then
            local v185 = (v184 - 1) % 4096 + 1;

            if TriangleCacheIds[v185] ~= v184 then
                local v186, v187, v188 = readTriangle(Data, v184);
                TriangleCacheIds[v185] = v184;
                TriangleCacheA[v185] = v186;
                TriangleCacheFirstEdge[v185] = v187 - v186;
                TriangleCacheSecondEdge[v185] = v188 - v186;
            end;

            if segmentEdgesFraction(p179, v183, TriangleCacheA[v185], TriangleCacheFirstEdge[v185], TriangleCacheSecondEdge[v185]) ~= nil then
                return v182;
            end;
        end;

        local v189;

        if v182 == v181 then
            v189 = i;
            v182 = 1;
        else
            v182 = v182 + 1;
            v189 = i;
        end;
    end;

    return 0;
end;

function u1.ProveTriangleBuffer(p190: any, p191: buffer, p192: number, p193: number, p194: number, p195: number, p196: number) -- Line: 687
    -- upvalues: readTriangle (copy), segmentEdgesFraction (copy)
    if p194 == 0 or (p196 < 4 or (p192 < 1 or p190.Data.triangleCount < p192)) then
        return false;
    end;

    local v197, v198, v199 = readTriangle(p190.Data, p192);
    local v200 = v198 - v197;
    local v201 = v199 - v197;

    for i = 0, p194 - 1 do
        local v202 = p193 + i * 12;
        local buffer_readf32_ret = buffer.readf32(p191, v202);
        local buffer_readf32_ret2 = buffer.readf32(p191, v202 + 4);
        local buffer_readf32_ret3 = buffer.readf32(p191, v202 + 8);
        local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
        local _ = i;

        for i2 = 0, p196 - 1 do
            local v203 = p195 + i2 * 12;
            local buffer_readf32_ret4 = buffer.readf32(p191, v203);
            local buffer_readf32_ret5 = buffer.readf32(p191, v203 + 4);
            local buffer_readf32_ret6 = buffer.readf32(p191, v203 + 8);

            if segmentEdgesFraction(Vector3_new_ret, Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6) - Vector3_new_ret, v197, v200, v201, 0.00001) == nil then
                return false;
            end;

            local _ = i2;
        end;
    end;

    return true;
end;

local function rectangleCoverage(p204: any, p205: number, p206: number, p207: number, p208: number, p209: number, p210: number, p211: table?) -- Line: 713
    -- upvalues: RECT_SIZE (copy)
    local v212 = p207 - 0.01;
    local v213 = p208 + 0.01;
    local v214 = p209 - 0.01;
    local v215 = p210 + 0.01;
    local buffer2 = p204.buffer;

    if p206 == 1 then
        if p211 then
            p211.rectangles = p211.rectangles + 1;
        end;

        local v216 = p204.rectangleOffset + (p205 - 1) * RECT_SIZE;
        local v217 = buffer.readf32(buffer2, v216) + 0.01;
        local v218 = buffer.readf32(buffer2, v216 + 4) - 0.01;
        local v219 = buffer.readf32(buffer2, v216 + 8) + 0.01;
        local v220 = buffer.readf32(buffer2, v216 + 12) - 0.01;
        local v221;

        if v217 <= v212 and (v213 <= v218 and v219 <= v214) then
            v221 = v215 <= v220;
        else
            v221 = false;
        end;

        if v221 then
            return v221, 1;
        end;

        return v221, 0;
    end;

    local v222 = {};
    local v223 = { v212, v213 };

    for i = p205, p205 + p206 - 1 do
        if p211 then
            p211.rectangles = p211.rectangles + 1;
        end;

        local v224 = p204.rectangleOffset + (i - 1) * RECT_SIZE;
        local v225 = buffer.readf32(buffer2, v224) + 0.01;
        local v226 = buffer.readf32(buffer2, v224 + 4) - 0.01;
        local v227 = buffer.readf32(buffer2, v224 + 8) + 0.01;
        local v228 = buffer.readf32(buffer2, v224 + 12) - 0.01;
        local v229;

        if v225 <= v213 and (v212 <= v226 and (v227 <= v215 and v214 <= v228)) then
            v222[#v222 + 1] = {
                minimumU = v225,
                maximumU = v226,
                minimumV = v227,
                maximumV = v228,
                primitive = buffer.readu32(buffer2, v224 + 16)
            };
            v223[#v223 + 1] = math.max(v225, v212);
            v223[#v223 + 1] = math.min(v226, v213);
            v229 = i;
        else
            v229 = i;
        end;
    end;

    if #v222 == 0 then
        return false, 0;
    end;

    table.sort(v223);
    local v230 = {};

    for i = 1, #v223 - 1 do
        local v231 = v223[i];
        local v232 = v223[i + 1];
        local v233;

        if v232 - v231 <= 1e-7 then
            v233 = i;
        else
            local v234 = (v231 + v232) * 0.5;
            v233 = i;
            local v235 = {};

            for _, v in v222 do
                if v.minimumU <= v234 and v234 <= v.maximumU then
                    v235[#v235 + 1] = v;
                end;
            end;

            table.sort(v235, function(p236, p237) -- Line: 790
                if p236.minimumV == p237.minimumV then
                    return p236.maximumV > p237.maximumV;
                end;

                return p236.minimumV < p237.minimumV;
            end);
            local v238 = v214;

            for _, v in v235 do
                if v.minimumV > v214 + 1e-7 then
                    return false, 0;
                end;

                if v214 < v.maximumV then
                    v214 = v.maximumV;
                    v230[v.primitive] = true;
                end;

                if v215 <= v214 then
                    break;
                end;
            end;

            if v214 < v215 then
                return false, 0;
            end;

            v214 = v238;
        end;
    end;

    local v239 = 0;

    for _ in v230 do
        v239 = v239 + 1;
    end;

    return true, v239;
end;

local function planeCovers(p240: any, p241: number, p242: table, p243: table, p244: table?) -- Line: 820
    -- upvalues: PLANE_SIZE (copy), rectangleCoverage (copy)
    local buffer2 = p240.buffer;
    local v245 = p240.planeOffset + (p241 - 1) * PLANE_SIZE;
    local buffer_readf32_ret = buffer.readf32(buffer2, v245);
    local buffer_readf32_ret2 = buffer.readf32(buffer2, v245 + 4);
    local buffer_readf32_ret3 = buffer.readf32(buffer2, v245 + 8);
    local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local v246 = v245 + 12;
    local buffer_readf32_ret4 = buffer.readf32(buffer2, v246);
    local buffer_readf32_ret5 = buffer.readf32(buffer2, v246 + 4);
    local buffer_readf32_ret6 = buffer.readf32(buffer2, v246 + 8);
    local Vector3_new_ret2 = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
    local v247 = v245 + 24;
    local buffer_readf32_ret7 = buffer.readf32(buffer2, v247);
    local buffer_readf32_ret8 = buffer.readf32(buffer2, v247 + 4);
    local buffer_readf32_ret9 = buffer.readf32(buffer2, v247 + 8);
    local Vector3_new_ret3 = Vector3.new(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);
    local v248 = v245 + 36;
    local buffer_readf32_ret10 = buffer.readf32(buffer2, v248);
    local buffer_readf32_ret11 = buffer.readf32(buffer2, v248 + 4);
    local buffer_readf32_ret12 = buffer.readf32(buffer2, v248 + 8);
    local Vector3_new_ret4 = Vector3.new(buffer_readf32_ret10, buffer_readf32_ret11, buffer_readf32_ret12);
    local buffer_readu32_ret = buffer.readu32(buffer2, v245 + 48);
    local buffer_readu16_ret = buffer.readu16(buffer2, v245 + 52);
    local v249 = 0;

    for _, v in p243 do
        local v250 = (v - Vector3_new_ret):Dot(Vector3_new_ret4);

        if math.abs(v250) <= 0.01 then
            return false, 0;
        end;

        local v251 = v250 > 0 and 1 or -1;

        if v249 == 0 then
            v249 = v251;
        elseif v251 ~= v249 then
            return false, 0;
        end;
    end;

    if v249 == 0 then
        return false, 0;
    end;

    local v252 = (1 / 0);
    local v253 = (-1 / 0);
    local v254 = (1 / 0);
    local v255 = (-1 / 0);

    for _, v in p242 do
        local v256 = (v - Vector3_new_ret):Dot(Vector3_new_ret4);

        if math.abs(v256) <= 0.01 or (v256 > 0 and 1 or -1) == v249 then
            return false, 0;
        end;

        local v257 = v;

        for _, v2 in p243 do
            local v258 = (v2 - Vector3_new_ret):Dot(Vector3_new_ret4) - v256;

            if math.abs(v258) <= 1e-7 then
                return false, 0;
            end;

            local v259 = -v256 / v258;

            if v259 <= 0 or v259 >= 1 then
                return false, 0;
            end;

            local v260 = v257:Lerp(v2, v259) - Vector3_new_ret;
            local v261 = v260:Dot(Vector3_new_ret2);
            local v262 = v260:Dot(Vector3_new_ret3);
            v254 = math.min(v254, v261);
            v255 = math.max(v255, v261);
            v252 = math.min(v252, v262);
            v253 = math.max(v253, v262);
        end;
    end;

    return rectangleCoverage(p240, buffer_readu32_ret, buffer_readu16_ret, v254, v255, v252, v253, p244);
end;

local function projectFootprintBuffer(p263: buffer, p264: vector, p265: vector, p266: vector, p267: vector, p268: number, p269: number, p270: number, p271: number, p272: buffer, p273: buffer) -- Line: 886
    if p269 > 255 or p271 > 255 then
        return false, 0, 0, 0, 0;
    end;

    local v274 = 0;

    for i = 0, p271 - 1 do
        local v275 = p270 + i * 12;
        local buffer_readf32_ret = buffer.readf32(p263, v275);
        local buffer_readf32_ret2 = buffer.readf32(p263, v275 + 4);
        local buffer_readf32_ret3 = buffer.readf32(p263, v275 + 8);
        local v276 = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3) - p264;
        local v277 = v276:Dot(p267);

        if math.abs(v277) <= 0.01 then
            return false, 0, 0, 0, 0;
        end;

        local v278 = v277 > 0 and 1 or -1;

        if v274 == 0 then
            v274 = v278;
        elseif v278 ~= v274 then
            return false, 0, 0, 0, 0;
        end;

        local v279 = i * 24;
        buffer.writef64(p273, v279, v277);
        local v280 = v276:Dot(p265);
        buffer.writef64(p273, v279 + 8, v280);
        local v281 = v276:Dot(p266);
        buffer.writef64(p273, v279 + 16, v281);
        local _ = i;
    end;

    if v274 == 0 then
        return false, 0, 0, 0, 0;
    end;

    for i = 0, p269 - 1 do
        local v282 = p268 + i * 12;
        local buffer_readf32_ret = buffer.readf32(p263, v282);
        local buffer_readf32_ret2 = buffer.readf32(p263, v282 + 4);
        local buffer_readf32_ret3 = buffer.readf32(p263, v282 + 8);
        local v283 = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3) - p264;
        local v284 = v283:Dot(p267);

        if math.abs(v284) <= 0.01 or (v284 > 0 and 1 or -1) == v274 then
            return false, 0, 0, 0, 0;
        end;

        local v285 = i * 24;
        buffer.writef64(p272, v285, v284);
        local v286 = v283:Dot(p265);
        buffer.writef64(p272, v285 + 8, v286);
        local v287 = v283:Dot(p266);
        buffer.writef64(p272, v285 + 16, v287);
        local _ = i;
    end;

    local v288 = (-1 / 0);
    local v289 = (1 / 0);
    local v290 = (-1 / 0);
    local v291 = (1 / 0);

    for i = 0, p269 - 1 do
        local v292 = i * 24;
        local buffer_readf64_ret = buffer.readf64(p272, v292);
        local buffer_readf64_ret2 = buffer.readf64(p272, v292 + 8);
        local buffer_readf64_ret3 = buffer.readf64(p272, v292 + 16);
        local _ = i;

        for i2 = 0, p271 - 1 do
            local v293 = i2 * 24;
            local v294 = buffer.readf64(p273, v293) - buffer_readf64_ret;

            if math.abs(v294) <= 1e-7 then
                return false, 0, 0, 0, 0;
            end;

            local v295 = -buffer_readf64_ret / v294;

            if v295 <= 0 or v295 >= 1 then
                return false, 0, 0, 0, 0;
            end;

            local buffer_readf64_ret4 = buffer.readf64(p273, v293 + 8);
            local buffer_readf64_ret5 = buffer.readf64(p273, v293 + 16);
            local v296 = buffer_readf64_ret2 + (buffer_readf64_ret4 - buffer_readf64_ret2) * v295;
            local v297 = buffer_readf64_ret3 + (buffer_readf64_ret5 - buffer_readf64_ret3) * v295;
            v289 = math.min(v289, v296);
            v290 = math.max(v290, v296);
            v291 = math.min(v291, v297);
            v288 = math.max(v288, v297);
            local _ = i2;
        end;
    end;

    return true, v289, v290, v291, v288;
end;

local function planeCoversBuffer(p298: any, p299: number, p300: buffer, p301: number, p302: number, p303: number, p304: number, p305: buffer, p306: buffer, p307: table?) -- Line: 973
    -- upvalues: PLANE_SIZE (copy), projectFootprintBuffer (copy), rectangleCoverage (copy)
    local buffer2 = p298.buffer;
    local v308 = p298.planeOffset + (p299 - 1) * PLANE_SIZE;
    local buffer_readf32_ret = buffer.readf32(buffer2, v308);
    local buffer_readf32_ret2 = buffer.readf32(buffer2, v308 + 4);
    local buffer_readf32_ret3 = buffer.readf32(buffer2, v308 + 8);
    local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local v309 = v308 + 12;
    local buffer_readf32_ret4 = buffer.readf32(buffer2, v309);
    local buffer_readf32_ret5 = buffer.readf32(buffer2, v309 + 4);
    local buffer_readf32_ret6 = buffer.readf32(buffer2, v309 + 8);
    local Vector3_new_ret2 = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
    local v310 = v308 + 24;
    local buffer_readf32_ret7 = buffer.readf32(buffer2, v310);
    local buffer_readf32_ret8 = buffer.readf32(buffer2, v310 + 4);
    local buffer_readf32_ret9 = buffer.readf32(buffer2, v310 + 8);
    local Vector3_new_ret3 = Vector3.new(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);
    local v311 = v308 + 36;
    local buffer_readf32_ret10 = buffer.readf32(buffer2, v311);
    local buffer_readf32_ret11 = buffer.readf32(buffer2, v311 + 4);
    local buffer_readf32_ret12 = buffer.readf32(buffer2, v311 + 8);
    local Vector3_new_ret4 = Vector3.new(buffer_readf32_ret10, buffer_readf32_ret11, buffer_readf32_ret12);
    local buffer_readu32_ret = buffer.readu32(buffer2, v308 + 48);
    local buffer_readu16_ret = buffer.readu16(buffer2, v308 + 52);
    local v312, v313, v314, v315, v316 = projectFootprintBuffer(p300, Vector3_new_ret, Vector3_new_ret2, Vector3_new_ret3, Vector3_new_ret4, p301, p302, p303, p304, p305, p306);

    if v312 then
        return rectangleCoverage(p298, buffer_readu32_ret, buffer_readu16_ret, v313, v314, v315, v316, p307);
    end;

    return false, 0;
end;

local function projectBufferPoints(p317: any, p318: number, p319: buffer, p320: number, p321: number, p322: buffer, p323: number?) -- Line: 1012
    -- upvalues: PLANE_SIZE (copy)
    if p321 > 2040 then
        return false;
    end;

    local buffer2 = p317.buffer;
    local v324 = p317.planeOffset + (p318 - 1) * PLANE_SIZE;
    local buffer_readf32_ret = buffer.readf32(buffer2, v324);
    local buffer_readf32_ret2 = buffer.readf32(buffer2, v324 + 4);
    local buffer_readf32_ret3 = buffer.readf32(buffer2, v324 + 8);
    local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local v325 = v324 + 12;
    local buffer_readf32_ret4 = buffer.readf32(buffer2, v325);
    local buffer_readf32_ret5 = buffer.readf32(buffer2, v325 + 4);
    local buffer_readf32_ret6 = buffer.readf32(buffer2, v325 + 8);
    local Vector3_new_ret2 = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
    local v326 = v324 + 24;
    local buffer_readf32_ret7 = buffer.readf32(buffer2, v326);
    local buffer_readf32_ret8 = buffer.readf32(buffer2, v326 + 4);
    local buffer_readf32_ret9 = buffer.readf32(buffer2, v326 + 8);
    local Vector3_new_ret3 = Vector3.new(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);
    local v327 = v324 + 36;
    local buffer_readf32_ret10 = buffer.readf32(buffer2, v327);
    local buffer_readf32_ret11 = buffer.readf32(buffer2, v327 + 4);
    local buffer_readf32_ret12 = buffer.readf32(buffer2, v327 + 8);
    local Vector3_new_ret4 = Vector3.new(buffer_readf32_ret10, buffer_readf32_ret11, buffer_readf32_ret12);
    local v328 = p323 or 0;

    for i = 0, p321 - 1 do
        local v329 = p320 + i * 12;
        local buffer_readf32_ret13 = buffer.readf32(p319, v329);
        local buffer_readf32_ret14 = buffer.readf32(p319, v329 + 4);
        local buffer_readf32_ret15 = buffer.readf32(p319, v329 + 8);
        local v330 = Vector3.new(buffer_readf32_ret13, buffer_readf32_ret14, buffer_readf32_ret15) - Vector3_new_ret;
        local v331 = (v328 + i) * 24;
        local v332 = v330:Dot(Vector3_new_ret4);
        buffer.writef64(p322, v331, v332);
        local v333 = v330:Dot(Vector3_new_ret2);
        buffer.writef64(p322, v331 + 8, v333);
        local v334 = v330:Dot(Vector3_new_ret3);
        buffer.writef64(p322, v331 + 16, v334);
        local _ = i;
    end;

    return true;
end;

local function projectedVolumePairCoverage(p335: any, p336: number, p337: buffer, p338: number, p339: number, p340: buffer, p341: number, p342: number, p343: table?) -- Line: 1041
    -- upvalues: PLANE_SIZE (copy), RECT_SIZE (copy), rectangleCoverage (copy)
    local v344 = 0;

    for i = p341, p341 + p342 - 1 do
        local buffer_readf64_ret = buffer.readf64(p340, i * 24);

        if math.abs(buffer_readf64_ret) <= 0.01 then
            return false, 0;
        end;

        local v345 = buffer_readf64_ret > 0 and 1 or -1;
        local v346;

        if v344 == 0 then
            v344 = v345;
            v346 = i;
        else
            if v345 ~= v344 then
                return false, 0;
            end;

            v346 = i;
        end;
    end;

    if v344 == 0 then
        return false, 0;
    end;

    for i = p338, p338 + p339 - 1 do
        local buffer_readf64_ret = buffer.readf64(p337, i * 24);

        if math.abs(buffer_readf64_ret) <= 0.01 or (buffer_readf64_ret > 0 and 1 or -1) == v344 then
            return false, 0;
        end;

        local _ = i;
    end;

    local buffer2 = p335.buffer;
    local v347 = p335.planeOffset + (p336 - 1) * PLANE_SIZE;
    local buffer_readu32_ret = buffer.readu32(buffer2, v347 + 48);
    local buffer_readu16_ret = buffer.readu16(buffer2, v347 + 52);

    if buffer_readu16_ret == 1 then
        local v348 = p335.rectangleOffset + (buffer_readu32_ret - 1) * RECT_SIZE;
        local v349 = buffer.readf32(buffer2, v348) + 0.02;
        local v350 = buffer.readf32(buffer2, v348 + 4) - 0.02;
        local v351 = buffer.readf32(buffer2, v348 + 8) + 0.02;
        local v352 = buffer.readf32(buffer2, v348 + 12) - 0.02;
        local v353 = p338 * 24;
        local v354 = p341 * 24;
        local buffer_readf64_ret = buffer.readf64(p337, v353);
        local v355 = buffer.readf64(p340, v354) - buffer_readf64_ret;

        if math.abs(v355) <= 1e-7 then
            return false, 0;
        end;

        local v356 = -buffer_readf64_ret / v355;

        if v356 <= 0 or v356 >= 1 then
            return false, 0;
        end;

        local buffer_readf64_ret2 = buffer.readf64(p337, v353 + 8);
        local buffer_readf64_ret3 = buffer.readf64(p337, v353 + 16);
        local v357 = buffer_readf64_ret2 + (buffer.readf64(p340, v354 + 8) - buffer_readf64_ret2) * v356;
        local v358 = buffer_readf64_ret3 + (buffer.readf64(p340, v354 + 16) - buffer_readf64_ret3) * v356;

        if v357 < v349 or (v350 < v357 or (v358 < v351 or v352 < v358)) then
            return false, 0;
        end;

        local v359 = (1 / 0);
        local v360 = (-1 / 0);
        local v361 = (1 / 0);
        local v362 = (-1 / 0);

        for i = p338, p338 + p339 - 1 do
            local v363 = i * 24;
            local buffer_readf64_ret4 = buffer.readf64(p337, v363 + 8);
            local buffer_readf64_ret5 = buffer.readf64(p337, v363 + 16);
            v359 = math.min(v359, buffer_readf64_ret4);
            v360 = math.max(v360, buffer_readf64_ret4);
            v361 = math.min(v361, buffer_readf64_ret5);
            v362 = math.max(v362, buffer_readf64_ret5);
            local _ = i;
        end;

        for i = p341, p341 + p342 - 1 do
            local v364 = i * 24;
            local buffer_readf64_ret4 = buffer.readf64(p340, v364 + 8);
            local buffer_readf64_ret5 = buffer.readf64(p340, v364 + 16);
            v359 = math.min(v359, buffer_readf64_ret4);
            v360 = math.max(v360, buffer_readf64_ret4);
            v361 = math.min(v361, buffer_readf64_ret5);
            v362 = math.max(v362, buffer_readf64_ret5);
            local _ = i;
        end;

        if v349 <= v359 and (v360 <= v350 and (v351 <= v361 and v362 <= v352)) then
            if p343 then
                p343.rectangles = p343.rectangles + 1;
            end;

            return true, 1;
        end;
    end;

    local v365 = (1 / 0);
    local v366 = (-1 / 0);
    local v367 = (-1 / 0);
    local v368 = (1 / 0);

    for i = p338, p338 + p339 - 1 do
        local v369 = i * 24;
        local buffer_readf64_ret = buffer.readf64(p337, v369);
        local buffer_readf64_ret2 = buffer.readf64(p337, v369 + 8);
        local buffer_readf64_ret3 = buffer.readf64(p337, v369 + 16);
        local _ = i;

        for i2 = p341, p341 + p342 - 1 do
            local v370 = i2 * 24;
            local v371 = buffer.readf64(p340, v370) - buffer_readf64_ret;

            if math.abs(v371) <= 1e-7 then
                return false, 0;
            end;

            local v372 = -buffer_readf64_ret / v371;

            if v372 <= 0 or v372 >= 1 then
                return false, 0;
            end;

            local buffer_readf64_ret4 = buffer.readf64(p340, v370 + 8);
            local buffer_readf64_ret5 = buffer.readf64(p340, v370 + 16);
            local v373 = buffer_readf64_ret2 + (buffer_readf64_ret4 - buffer_readf64_ret2) * v372;
            local v374 = buffer_readf64_ret3 + (buffer_readf64_ret5 - buffer_readf64_ret3) * v372;
            v365 = math.min(v365, v373);
            v366 = math.max(v366, v373);
            v368 = math.min(v368, v374);
            v367 = math.max(v367, v374);
            local _ = i2;
        end;
    end;

    return rectangleCoverage(p335, buffer_readu32_ret, buffer_readu16_ret, v365, v366, v368, v367, p343);
end;

local function nextPlaneMark(p375) -- Line: 1181
    local v376 = p375.PlaneMarkToken + 1;

    if v376 >= 4294967295 then
        buffer.fill(p375.PlaneMarks, 0, 0);
        v376 = 1;
    end;

    p375.PlaneMarkToken = v376;

    return v376;
end;

local function markPlane(p377: any, p378: number, p379: number) -- Line: 1191
    local v380 = (p378 - 1) * 4;

    if buffer.readu32(p377.PlaneMarks, v380) == p379 then
        return false;
    end;

    buffer.writeu32(p377.PlaneMarks, v380, p379);

    return true;
end;

function u1.ProveProjectedOccluded(p381: any, p382: table, p383: table, p384: number?, p385: table?) -- Line: 1200
    -- upvalues: planeCovers (copy)
    if #p382 == 0 or #p383 < 4 then
        return false, nil, 0;
    end;

    local Data = p381.Data;

    if p384 ~= nil and (p384 >= 1 and p384 <= Data.planeCount) then
        if p385 then
            p385.planes = p385.planes + 1;
        end;

        local v386, v387 = planeCovers(Data, p384, p382, p383, p385);

        if v386 then
            return true, p384, v387;
        end;
    end;

    for i = 1, Data.planeCount do
        local v388;

        if i == p384 then
            v388 = i;
        else
            if p385 then
                p385.planes = p385.planes + 1;
            end;

            local v389, v390 = planeCovers(Data, i, p382, p383, p385);

            if v389 then
                return true, i, v390;
            end;

            v388 = i;
        end;
    end;

    return false, nil, 0;
end;

local function findCertificate(p391: any, p392: number) -- Line: 1235
    -- upvalues: CERTIFICATE_SIZE (copy)
    local buffer2 = p391.buffer;
    local certificateCount = p391.certificateCount;
    local v393 = 1;

    while v393 <= certificateCount do
        local math_floor_ret = math.floor((v393 + certificateCount) * 0.5);
        local v394 = p391.certificateOffset + (math_floor_ret - 1) * CERTIFICATE_SIZE;
        local buffer_readu32_ret = buffer.readu32(buffer2, v394);

        if buffer_readu32_ret == p392 then
            return buffer.readu32(buffer2, v394 + 4), buffer.readu16(buffer2, v394 + 8);
        end;

        if buffer_readu32_ret < p392 then
            v393 = math_floor_ret + 1;
        else
            certificateCount = math_floor_ret - 1;
        end;
    end;

    return nil, nil;
end;

local function beginCandidatePlanes(p395: any, p396: number?) -- Line: 1254
    local CandidatePlanes = p395.CandidatePlanes;
    table.clear(CandidatePlanes);
    local v397 = p395.PlaneMarkToken + 1;

    if v397 >= 4294967295 then
        buffer.fill(p395.PlaneMarks, 0, 0);
        v397 = 1;
    end;

    p395.PlaneMarkToken = v397;

    if p396 ~= nil and (p396 >= 1 and p396 <= p395.Data.planeCount) then
        local v398 = (p396 - 1) * 4;

        if buffer.readu32(p395.PlaneMarks, v398) ~= v397 then
            buffer.writeu32(p395.PlaneMarks, v398, v397);
        end;

        CandidatePlanes[1] = p396;
    end;

    return v397, CandidatePlanes;
end;

local function appendCertificatePlanes(p399: any, p400: number, p401: table, p402: number, p403: number) -- Line: 1266
    -- upvalues: findCertificate (copy), CANDIDATE_SIZE (copy)
    local Data = p399.Data;
    local math_min_ret = math.min(p402, p403);
    local math_max_ret = math.max(p402, p403);
    local bit32_lshift_ret = bit32.lshift(math_min_ret, 16);
    local v404, v405 = findCertificate(Data, (bit32.bor(bit32_lshift_ret, math_max_ret)));

    if v404 == nil or v405 == nil then
        return;
    end;

    for i = v404, v404 + v405 - 1 do
        local buffer_readu16_ret = buffer.readu16(Data.buffer, Data.candidateOffset + (i - 1) * CANDIDATE_SIZE);
        local v406 = (buffer_readu16_ret - 1) * 4;
        local v407;

        if buffer.readu32(p399.PlaneMarks, v406) == p400 then
            v407 = false;
        else
            buffer.writeu32(p399.PlaneMarks, v406, p400);
            v407 = true;
        end;

        local v408;

        if v407 then
            p401[#p401 + 1] = buffer_readu16_ret;
            v408 = i;
        else
            v408 = i;
        end;
    end;
end;

local function candidatePlanesForCells(p409: any, p410: table, p411: table, p412: number?) -- Line: 1286
    -- upvalues: appendCertificatePlanes (copy)
    local CandidatePlanes = p409.CandidatePlanes;
    table.clear(CandidatePlanes);
    local v413 = p409.PlaneMarkToken + 1;

    if v413 >= 4294967295 then
        buffer.fill(p409.PlaneMarks, 0, 0);
        v413 = 1;
    end;

    p409.PlaneMarkToken = v413;

    if p412 ~= nil and (p412 >= 1 and p412 <= p409.Data.planeCount) then
        local v414 = (p412 - 1) * 4;

        if buffer.readu32(p409.PlaneMarks, v414) ~= v413 then
            buffer.writeu32(p409.PlaneMarks, v414, v413);
        end;

        CandidatePlanes[1] = p412;
    end;

    for _, v in p410 do
        local v415 = v;

        for _, v2 in p411 do
            appendCertificatePlanes(p409, v413, CandidatePlanes, v415, v2);
        end;
    end;

    return CandidatePlanes;
end;

local function candidatePlanesForCellBuffer(p416: any, p417: buffer, p418: number, p419: number, p420: number, p421: number, p422: number?) -- Line: 1301
    -- upvalues: appendCertificatePlanes (copy)
    local CandidatePlanes = p416.CandidatePlanes;
    table.clear(CandidatePlanes);
    local v423 = p416.PlaneMarkToken + 1;

    if v423 >= 4294967295 then
        buffer.fill(p416.PlaneMarks, 0, 0);
        v423 = 1;
    end;

    p416.PlaneMarkToken = v423;

    if p422 ~= nil and (p422 >= 1 and p422 <= p416.Data.planeCount) then
        local v424 = (p422 - 1) * 4;

        if buffer.readu32(p416.PlaneMarks, v424) ~= v423 then
            buffer.writeu32(p416.PlaneMarks, v424, v423);
        end;

        CandidatePlanes[1] = p422;
    end;

    for i = 0, p419 - 1 do
        local buffer_readu16_ret = buffer.readu16(p417, p418 + i * 2);
        local _ = i;

        for i2 = 0, p421 - 1 do
            appendCertificatePlanes(p416, v423, CandidatePlanes, buffer_readu16_ret, (buffer.readu16(p417, p420 + i2 * 2)));
            local _ = i2;
        end;
    end;

    return CandidatePlanes;
end;

function u1.ProveProjectedOccludedForCells(p425: any, p426: table, p427: table, p428: table, p429: table, p430: number?, p431: table?) -- Line: 1321
    -- upvalues: planeCovers (copy), findCertificate (copy), CANDIDATE_SIZE (copy)
    if #p428 == 0 or (#p429 < 4 or (#p426 == 0 or #p427 == 0)) then
        return false, nil, 0;
    end;

    local Data = p425.Data;

    if p430 ~= nil and (p430 >= 1 and p430 <= Data.planeCount) then
        if p431 then
            p431.planes = p431.planes + 1;
        end;

        local v432, v433 = planeCovers(Data, p430, p428, p429, p431);

        if v432 then
            return true, p430, v433;
        end;
    end;

    local v434 = p425.PlaneMarkToken + 1;

    if v434 >= 4294967295 then
        buffer.fill(p425.PlaneMarks, 0, 0);
        v434 = 1;
    end;

    p425.PlaneMarkToken = v434;

    if p430 ~= nil then
        local v435 = (p430 - 1) * 4;

        if buffer.readu32(p425.PlaneMarks, v435) ~= v434 then
            buffer.writeu32(p425.PlaneMarks, v435, v434);
        end;
    end;

    for _, v in p426 do
        local v436 = v;

        for _, v2 in p427 do
            local math_min_ret = math.min(v436, v2);
            local math_max_ret = math.max(v436, v2);
            local bit32_lshift_ret = bit32.lshift(math_min_ret, 16);
            local v437, v438 = findCertificate(Data, (bit32.bor(bit32_lshift_ret, math_max_ret)));

            if v437 ~= nil and v438 ~= nil then
                for i = v437, v437 + v438 - 1 do
                    local buffer_readu16_ret = buffer.readu16(Data.buffer, Data.candidateOffset + (i - 1) * CANDIDATE_SIZE);
                    local v439 = (buffer_readu16_ret - 1) * 4;
                    local v440;

                    if buffer.readu32(p425.PlaneMarks, v439) == v434 then
                        v440 = false;
                    else
                        buffer.writeu32(p425.PlaneMarks, v439, v434);
                        v440 = true;
                    end;

                    local v441;

                    if v440 then
                        if p431 then
                            p431.planes = p431.planes + 1;
                        end;

                        local v442, v443 = planeCovers(Data, buffer_readu16_ret, p428, p429, p431);

                        if v442 then
                            return true, buffer_readu16_ret, v443;
                        end;

                        v441 = i;
                    else
                        v441 = i;
                    end;
                end;
            end;
        end;
    end;

    return false, nil, 0;
end;

function u1.ProveProjectedOccludedForVolumeGroups(p444: any, p445: table, p446: table, p447: table, p448: table, p449: number?, p450: table?) -- Line: 1373
    -- upvalues: candidatePlanesForCells (copy), planeCovers (copy)
    if #p447 == 0 or #p448 == 0 then
        return false, nil, 0;
    end;

    local v451 = candidatePlanesForCells(p444, p445, p446, p449);

    if #v451 == 0 then
        return false, nil, 0;
    end;

    local v452 = 0;
    local v453 = nil;

    for _, v in p447 do
        local v454 = v;

        for _, v2 in p448 do
            local v455 = v2;
            local v456 = 0;
            local v457 = nil;
            local v458 = false;

            for _, v3 in v451 do
                if p450 then
                    p450.planes = p450.planes + 1;
                end;

                local v459, v460 = planeCovers(p444.Data, v3, v454, v455, p450);

                if v459 then
                    v456 = v460;
                    v457 = v3;
                    v458 = true;
                    break;
                end;
            end;

            if not v458 then
                return false, nil, 0;
            end;

            if v453 ~= nil then
                v457 = v453;
            end;

            v452 = v452 + v456;
            v453 = v457;
        end;
    end;

    return true, v453, v452;
end;

function u1.ProveProjectedOccludedForVolumeGroupBuffer(p461: any, p462: buffer, p463: number, p464: number, p465: number, p466: number, p467: number, p468: number, p469: number, p470: number, p471: number?, p472: table?) -- Line: 1421
    -- upvalues: candidatePlanesForCellBuffer (copy), projectBufferPoints (copy), projectedVolumePairCoverage (copy)
    if p464 == 0 or (p466 == 0 or (p468 == 0 or p470 == 0)) then
        return false, nil, 0;
    end;

    local v473 = candidatePlanesForCellBuffer(p461, p462, p463, p464, p465, p466, p471);

    if #v473 == 0 then
        return false, nil, 0;
    end;

    if p468 > 255 or p470 > 255 then
        return false, nil, 0;
    end;

    local v474 = p468 * p470;
    local VolumePairMarks = p461.VolumePairMarks;
    buffer.fill(VolumePairMarks, 0, 0, v474);
    local v475 = nil;
    local v476 = 0;

    for _, v in v473 do
        if not (projectBufferPoints(p461.Data, v, p462, p467, p468 * 8, p461.ViewerProjectionScratch) and projectBufferPoints(p461.Data, v, p462, p469, p470 * 8, p461.TargetProjectionScratch)) then
            return false, nil, 0;
        end;

        local v477;

        if p468 > 1 then
            v477 = v;

            for i = 0, p470 - 1 do
                local v478 = i;
                local v479 = 0;

                for i2 = 0, p468 - 1 do
                    local v480;

                    if buffer.readu8(VolumePairMarks, i2 * p470 + v478) == 0 then
                        v479 = v479 + 1;
                        v480 = i2;
                    else
                        v480 = i2;
                    end;
                end;

                if v479 ~= 0 then
                    if p472 then
                        p472.planes = p472.planes + 1;
                    end;

                    local v481, v482 = projectedVolumePairCoverage(p461.Data, v477, p461.ViewerProjectionScratch, 0, p468 * 8, p461.TargetProjectionScratch, v478 * 8, 8, p472);

                    if v481 then
                        for i2 = 0, p468 - 1 do
                            local v483 = i2 * p470 + v478;
                            local v484;

                            if buffer.readu8(VolumePairMarks, v483) == 0 then
                                buffer.writeu8(VolumePairMarks, v483, 1);
                                v474 = v474 - 1;
                                v484 = i2;
                            else
                                v484 = i2;
                            end;
                        end;

                        v476 = v476 + v482 * v479;
                        v475 = v475 or v477;
                    end;
                end;
            end;

            if v474 == 0 then
                return true, v475, v476;
            end;
        else
            v477 = v;
        end;

        for i = 0, p468 - 1 do
            local v485 = i;

            for i2 = 0, p470 - 1 do
                local v486 = v485 * p470 + i2;
                local v487;

                if buffer.readu8(VolumePairMarks, v486) == 0 then
                    if p472 then
                        p472.planes = p472.planes + 1;
                    end;

                    local v488, v489 = projectedVolumePairCoverage(p461.Data, v477, p461.ViewerProjectionScratch, v485 * 8, 8, p461.TargetProjectionScratch, i2 * 8, 8, p472);

                    if v488 then
                        buffer.writeu8(VolumePairMarks, v486, 1);
                        v474 = v474 - 1;
                        v476 = v476 + v489;
                        v487 = i2;
                        v475 = v475 or v477;
                    else
                        v487 = i2;
                    end;
                else
                    v487 = i2;
                end;
            end;
        end;

        if v474 == 0 then
            return true, v475, v476;
        end;
    end;

    return false, nil, 0;
end;

local function ensureBatchScratch(p490: any, p491: number, p492: number) -- Line: 1558
    local v493 = math.max(p491, 1) * 24;

    if buffer.len(p490.BatchProjectionScratch) < v493 then
        p490.BatchProjectionScratch = buffer.create(v493);
    end;

    if buffer.len(p490.BatchVolumePairMarks) < math.max(p492, 1) then
        p490.BatchVolumePairMarks = buffer.create((math.max(p492, 1)));
    end;
end;

function u1.ProveProjectedOccludedActorBatchBuffer(u494: any, u495: buffer, p496: table, p497: table, p498: table?) -- Line: 1569
    -- upvalues: candidatePlanesForCellBuffer (copy), ensureBatchScratch (copy), projectBufferPoints (copy), projectedVolumePairCoverage (copy)
    local table_create_ret = table.create(#p496);
    local v499 = 0;

    for i, v in p496 do
        local v500 = {
            TargetProjectionIndex = 0,
            FallbackViewerProjectionIndex = 0,
            FallbackTargetProjectionIndex = 0,
            CellsOffset = v.CellsOffset,
            CellCount = v.CellCount,
            ViewerPointsOffset = v.ViewerPointsOffset,
            ViewerPointCount = v.ViewerPointCount,
            TargetPointsOffset = v.TargetPointsOffset,
            TargetPointCount = v.TargetPointCount,
            FallbackViewerOffset = v.FallbackViewerOffset,
            FallbackViewerCount = v.FallbackViewerCount,
            FallbackTargetOffset = v.FallbackTargetOffset,
            FallbackTargetCount = v.FallbackTargetCount,
            ViewerProjectionIndex = v499
        };
        local v501 = v499 + v.ViewerPointCount;
        v500.TargetProjectionIndex = v501;
        local v502 = v501 + v.TargetPointCount;
        v500.FallbackViewerProjectionIndex = v502;
        local v503 = v502 + v.FallbackViewerCount * 8;
        v500.FallbackTargetProjectionIndex = v503;
        v499 = v503 + v.FallbackTargetCount * 8;
        table_create_ret[i] = v500;
    end;

    local table_create_ret2 = table.create(#p497);
    local v504 = 0;
    local v505 = {};
    local v506 = {};
    local v507 = {};

    for i, v in p497 do
        local v508 = table_create_ret[v.ViewerActor];
        local v509 = table_create_ret[v.TargetActor];
        local v510 = {};
        local v511 = 0;
        local v512, v513;

        if v508 == nil or v509 == nil then
            v512 = i;
            v513 = v;
        else
            local v514;

            if v.Fallback then
                if v508.FallbackViewerCount > 0 then
                    v514 = v509.FallbackTargetCount > 0;
                else
                    v514 = false;
                end;
            elseif v508.ViewerPointCount > 0 then
                v514 = v509.TargetPointCount >= 4;
            else
                v514 = false;
            end;

            if v514 and (v508.CellCount > 0 and v509.CellCount > 0) then
                v513 = v;
                v512 = i;

                for _, v2 in candidatePlanesForCellBuffer(u494, u495, v508.CellsOffset, v508.CellCount, v509.CellsOffset, v509.CellCount, v.PreferredPlane) do
                    v510[#v510 + 1] = v2;
                    local v515 = v505[v2];

                    if v515 == nil then
                        v515 = {};
                        v505[v2] = v515;
                    end;

                    v515[#v515 + 1] = v512;

                    if not v507[v2] then
                        v507[v2] = true;
                        v506[#v506 + 1] = v2;
                    end;
                end;
            else
                v512 = i;
                v513 = v;
            end;

            if v513.Fallback then
                v511 = v508.FallbackViewerCount * v509.FallbackTargetCount;
            end;
        end;

        table_create_ret2[v512] = {
            FirstPlane = nil,
            ProofLeaves = 0,
            Proved = false,
            Tests = 0,
            Query = v513,
            Planes = v510,
            MarkOffset = v504,
            RemainingPairs = v511
        };
        v504 = v504 + v511;
    end;

    ensureBatchScratch(u494, v499, v504);
    local BatchProjectionScratch = u494.BatchProjectionScratch;
    local BatchVolumePairMarks = u494.BatchVolumePairMarks;

    if v504 > 0 then
        buffer.fill(BatchVolumePairMarks, 0, 0, v504);
    end;

    local table_create_ret3 = table.create(#p496, 0);
    local table_create_ret4 = table.create(#p496, 0);
    local table_create_ret5 = table.create(#p496, 0);
    local table_create_ret6 = table.create(#p496, 0);
    local u516 = 0;

    local function ensureProjected(p517: number, p518: number, p519: number, p520: number, p521: number, p522: table) -- Line: 1673
        -- upvalues: projectBufferPoints (ref), u494 (copy), u495 (copy), BatchProjectionScratch (copy), u516 (ref)
        if p522[p517] == p518 then
            return true;
        end;

        if not projectBufferPoints(u494.Data, p518, u495, p519, p520, BatchProjectionScratch, p521) then
            return false;
        end;

        p522[p517] = p518;
        u516 = u516 + 1;

        return true;
    end;

    local v523 = 0;

    for _, v in table_create_ret2 do
        local Query = v.Query;
        local PreferredPlane = Query.PreferredPlane;

        if PreferredPlane ~= nil and not (Query.Fallback or (v.Proved or v.Planes[1] ~= PreferredPlane)) then
            local v524 = table_create_ret[Query.ViewerActor];
            local v525 = table_create_ret[Query.TargetActor];

            if v524 ~= nil and v525 ~= nil then
                local ViewerActor = Query.ViewerActor;
                local ViewerPointsOffset = v524.ViewerPointsOffset;
                local ViewerPointCount = v524.ViewerPointCount;
                local ViewerProjectionIndex = v524.ViewerProjectionIndex;
                local v526;

                if table_create_ret3[ViewerActor] == PreferredPlane then
                    v526 = true;
                elseif projectBufferPoints(u494.Data, PreferredPlane, u495, ViewerPointsOffset, ViewerPointCount, BatchProjectionScratch, ViewerProjectionIndex) then
                    table_create_ret3[ViewerActor] = PreferredPlane;
                    u516 = u516 + 1;
                    v526 = true;
                else
                    v526 = false;
                end;

                if v526 then
                    local TargetActor = Query.TargetActor;
                    local TargetPointsOffset = v525.TargetPointsOffset;
                    local TargetPointCount = v525.TargetPointCount;
                    local TargetProjectionIndex = v525.TargetProjectionIndex;
                    local v527;

                    if table_create_ret4[TargetActor] == PreferredPlane then
                        v527 = true;
                    elseif projectBufferPoints(u494.Data, PreferredPlane, u495, TargetPointsOffset, TargetPointCount, BatchProjectionScratch, TargetProjectionIndex) then
                        table_create_ret4[TargetActor] = PreferredPlane;
                        u516 = u516 + 1;
                        v527 = true;
                    else
                        v527 = false;
                    end;

                    if v527 then
                        if p498 then
                            p498.planes = p498.planes + 1;
                        end;

                        v523 = v523 + 1;
                        v.Tests = v.Tests + 1;
                        local v528, v529 = projectedVolumePairCoverage(u494.Data, PreferredPlane, BatchProjectionScratch, v524.ViewerProjectionIndex, v524.ViewerPointCount, BatchProjectionScratch, v525.TargetProjectionIndex, v525.TargetPointCount, p498);

                        if v528 then
                            v.Proved = true;
                            v.FirstPlane = PreferredPlane;
                            v.ProofLeaves = v529;
                        end;
                    end;
                end;
            end;
        end;
    end;

    for _, v in v506 do
        local v530 = v505[v];

        if v530 ~= nil then
            local v531 = v;

            for _, v2 in v530 do
                local v532 = table_create_ret2[v2];

                if not v532.Proved and v532.Tests < 24 then
                    local Query = v532.Query;
                    local v533 = table_create_ret[Query.ViewerActor];
                    local v534 = table_create_ret[Query.TargetActor];

                    if v533 ~= nil and (v534 ~= nil and (Query.PreferredPlane ~= v531 or (v532.Tests <= 0 or Query.Fallback))) then
                        if p498 then
                            p498.planes = p498.planes + 1;
                        end;

                        v532.Tests = v532.Tests + 1;

                        if Query.Fallback then
                            local ViewerActor = Query.ViewerActor;
                            local ViewerPointsOffset = v533.ViewerPointsOffset;
                            local ViewerPointCount = v533.ViewerPointCount;
                            local ViewerProjectionIndex = v533.ViewerProjectionIndex;
                            local v535;

                            if table_create_ret3[ViewerActor] == v531 then
                                v535 = true;
                            elseif projectBufferPoints(u494.Data, v531, u495, ViewerPointsOffset, ViewerPointCount, BatchProjectionScratch, ViewerProjectionIndex) then
                                table_create_ret3[ViewerActor] = v531;
                                u516 = u516 + 1;
                                v535 = true;
                            else
                                v535 = false;
                            end;

                            if v535 then
                                local TargetActor = Query.TargetActor;
                                local FallbackTargetOffset = v534.FallbackTargetOffset;
                                local v536 = v534.FallbackTargetCount * 8;
                                local FallbackTargetProjectionIndex = v534.FallbackTargetProjectionIndex;
                                local v537;

                                if table_create_ret6[TargetActor] == v531 then
                                    v537 = true;
                                elseif projectBufferPoints(u494.Data, v531, u495, FallbackTargetOffset, v536, BatchProjectionScratch, FallbackTargetProjectionIndex) then
                                    table_create_ret6[TargetActor] = v531;
                                    u516 = u516 + 1;
                                    v537 = true;
                                else
                                    v537 = false;
                                end;

                                if v537 then
                                    local FallbackViewerCount = v533.FallbackViewerCount;
                                    local FallbackTargetCount = v534.FallbackTargetCount;

                                    if FallbackViewerCount > 1 then
                                        for i = 0, FallbackTargetCount - 1 do
                                            local v538 = i;
                                            local v539 = 0;

                                            for i2 = 0, FallbackViewerCount - 1 do
                                                local v540;

                                                if buffer.readu8(BatchVolumePairMarks, v532.MarkOffset + i2 * FallbackTargetCount + v538) == 0 then
                                                    v539 = v539 + 1;
                                                    v540 = i2;
                                                else
                                                    v540 = i2;
                                                end;
                                            end;

                                            if v539 ~= 0 then
                                                v523 = v523 + 1;
                                                local v541, v542 = projectedVolumePairCoverage(u494.Data, v531, BatchProjectionScratch, v533.ViewerProjectionIndex, v533.ViewerPointCount, BatchProjectionScratch, v534.FallbackTargetProjectionIndex + v538 * 8, 8, p498);

                                                if v541 then
                                                    for i2 = 0, FallbackViewerCount - 1 do
                                                        local v543 = v532.MarkOffset + i2 * FallbackTargetCount + v538;
                                                        local v544;

                                                        if buffer.readu8(BatchVolumePairMarks, v543) == 0 then
                                                            buffer.writeu8(BatchVolumePairMarks, v543, 1);
                                                            v532.RemainingPairs = v532.RemainingPairs - 1;
                                                            v544 = i2;
                                                        else
                                                            v544 = i2;
                                                        end;
                                                    end;

                                                    v532.FirstPlane = v532.FirstPlane or v531;
                                                    v532.ProofLeaves = v532.ProofLeaves + v542 * v539;
                                                end;
                                            end;
                                        end;
                                    end;

                                    if v532.RemainingPairs > 0 then
                                        local ViewerActor2 = Query.ViewerActor;
                                        local FallbackViewerOffset = v533.FallbackViewerOffset;
                                        local v545 = FallbackViewerCount * 8;
                                        local FallbackViewerProjectionIndex = v533.FallbackViewerProjectionIndex;
                                        local v546;

                                        if table_create_ret5[ViewerActor2] == v531 then
                                            v546 = true;
                                        elseif projectBufferPoints(u494.Data, v531, u495, FallbackViewerOffset, v545, BatchProjectionScratch, FallbackViewerProjectionIndex) then
                                            table_create_ret5[ViewerActor2] = v531;
                                            u516 = u516 + 1;
                                            v546 = true;
                                        else
                                            v546 = false;
                                        end;

                                        if v546 then
                                            for i = 0, FallbackViewerCount - 1 do
                                                local v547 = i;

                                                for i2 = 0, FallbackTargetCount - 1 do
                                                    local v548 = v532.MarkOffset + v547 * FallbackTargetCount + i2;
                                                    local v549;

                                                    if buffer.readu8(BatchVolumePairMarks, v548) == 0 then
                                                        v523 = v523 + 1;
                                                        local v550, v551 = projectedVolumePairCoverage(u494.Data, v531, BatchProjectionScratch, v533.FallbackViewerProjectionIndex + v547 * 8, 8, BatchProjectionScratch, v534.FallbackTargetProjectionIndex + i2 * 8, 8, p498);

                                                        if v550 then
                                                            buffer.writeu8(BatchVolumePairMarks, v548, 1);
                                                            v532.RemainingPairs = v532.RemainingPairs - 1;
                                                            v532.FirstPlane = v532.FirstPlane or v531;
                                                            v532.ProofLeaves = v532.ProofLeaves + v551;
                                                            v549 = i2;
                                                        else
                                                            v549 = i2;
                                                        end;
                                                    else
                                                        v549 = i2;
                                                    end;
                                                end;
                                            end;

                                            if v532.RemainingPairs == 0 then
                                                v532.Proved = true;
                                            end;
                                        end;
                                    elseif v532.RemainingPairs == 0 then
                                        v532.Proved = true;
                                    end;
                                end;
                            end;
                        else
                            local ViewerActor = Query.ViewerActor;
                            local ViewerPointsOffset = v533.ViewerPointsOffset;
                            local ViewerPointCount = v533.ViewerPointCount;
                            local ViewerProjectionIndex = v533.ViewerProjectionIndex;
                            local v552;

                            if table_create_ret3[ViewerActor] == v531 then
                                v552 = true;
                            elseif projectBufferPoints(u494.Data, v531, u495, ViewerPointsOffset, ViewerPointCount, BatchProjectionScratch, ViewerProjectionIndex) then
                                table_create_ret3[ViewerActor] = v531;
                                u516 = u516 + 1;
                                v552 = true;
                            else
                                v552 = false;
                            end;

                            if v552 then
                                local TargetActor = Query.TargetActor;
                                local TargetPointsOffset = v534.TargetPointsOffset;
                                local TargetPointCount = v534.TargetPointCount;
                                local TargetProjectionIndex = v534.TargetProjectionIndex;
                                local v553;

                                if table_create_ret4[TargetActor] == v531 then
                                    v553 = true;
                                elseif projectBufferPoints(u494.Data, v531, u495, TargetPointsOffset, TargetPointCount, BatchProjectionScratch, TargetProjectionIndex) then
                                    table_create_ret4[TargetActor] = v531;
                                    u516 = u516 + 1;
                                    v553 = true;
                                else
                                    v553 = false;
                                end;

                                if v553 then
                                    v523 = v523 + 1;
                                    local v554, v555 = projectedVolumePairCoverage(u494.Data, v531, BatchProjectionScratch, v533.ViewerProjectionIndex, v533.ViewerPointCount, BatchProjectionScratch, v534.TargetProjectionIndex, v534.TargetPointCount, p498);

                                    if v554 then
                                        v532.Proved = true;
                                        v532.FirstPlane = v531;
                                        v532.ProofLeaves = v555;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local table_create_ret7 = table.create(#p497);

    for i, v in table_create_ret2 do
        local v556 = {
            Proved = v.Proved,
            PlaneIndex = v.FirstPlane,
            ProofLeaves = not v.Proved and 0 or v.ProofLeaves
        };
        v556.UsedFallback = v.Proved and v.Query.Fallback;
        table_create_ret7[i] = v556;
    end;

    return table_create_ret7, u516, v523;
end;

function u1.ProvePlaneBuffer(p557: any, p558: buffer, p559: number, p560: number, p561: number, p562: number, p563: number, p564: table?) -- Line: 1942
    -- upvalues: planeCoversBuffer (copy)
    local Data = p557.Data;

    if p561 == 0 or (p563 < 4 or (p559 < 1 or (Data.planeCount < p559 or p559 ~= math.floor(p559)))) then
        return false, 0;
    end;

    if p564 then
        p564.planes = p564.planes + 1;
    end;

    return planeCoversBuffer(Data, p559, p558, p560, p561, p562, p563, p557.ViewerProjectionScratch, p557.TargetProjectionScratch, p564);
end;

function u1.ProveRectangleBuffer(p565: any, p566: buffer, p567: vector, p568: vector, p569: vector, p570: vector, p571: number, p572: number, p573: number, p574: number, p575: number, p576: number) -- Line: 1980
    -- upvalues: projectFootprintBuffer (copy)
    if p574 == 0 or p576 < 4 then
        return false;
    end;

    local v577 = p571 - 0.02;
    local v578 = p572 - 0.02;

    if v577 <= 0 or v578 <= 0 then
        return false;
    end;

    local v579, v580, v581, v582, v583 = projectFootprintBuffer(p566, p567, p568, p569, p570, p573, p574, p575, p576, p565.ViewerProjectionScratch, p565.TargetProjectionScratch);

    if v579 then
        if -v577 <= v580 and (v581 <= v577 and -v578 <= v582) then
            v579 = v583 <= v578;
        else
            v579 = false;
        end;
    end;

    return v579;
end;

function u1.ProveProjectedOccludedForCellBuffer(p584: any, p585: buffer, p586: number, p587: number, p588: number, p589: number, p590: number, p591: number, p592: number, p593: number, p594: number?, p595: table?, p596: number?) -- Line: 2019
    -- upvalues: planeCoversBuffer (copy), findCertificate (copy), CANDIDATE_SIZE (copy)
    if p591 == 0 or (p593 < 4 or (p587 == 0 or p589 == 0)) then
        return false, nil, 0;
    end;

    local Data = p584.Data;
    local v597 = p596 or (1 / 0);

    if p594 ~= nil and (p594 >= 1 and p594 <= Data.planeCount) then
        if p595 then
            p595.planes = p595.planes + 1;
        end;

        v597 = v597 - 1;
        local v598, v599 = planeCoversBuffer(Data, p594, p585, p590, p591, p592, p593, p584.ViewerProjectionScratch, p584.TargetProjectionScratch, p595);

        if v598 then
            return true, p594, v599;
        end;
    end;

    local v600 = p584.PlaneMarkToken + 1;

    if v600 >= 4294967295 then
        buffer.fill(p584.PlaneMarks, 0, 0);
        v600 = 1;
    end;

    p584.PlaneMarkToken = v600;

    if p594 ~= nil and (p594 >= 1 and p594 <= Data.planeCount) then
        local v601 = (p594 - 1) * 4;

        if buffer.readu32(p584.PlaneMarks, v601) ~= v600 then
            buffer.writeu32(p584.PlaneMarks, v601, v600);
        end;
    end;

    for i = 0, p587 - 1 do
        local buffer_readu16_ret = buffer.readu16(p585, p586 + i * 2);
        local _ = i;

        for i2 = 0, p589 - 1 do
            local buffer_readu16_ret2 = buffer.readu16(p585, p588 + i2 * 2);
            local math_min_ret = math.min(buffer_readu16_ret, buffer_readu16_ret2);
            local math_max_ret = math.max(buffer_readu16_ret, buffer_readu16_ret2);
            local bit32_lshift_ret = bit32.lshift(math_min_ret, 16);
            local v602, v603 = findCertificate(Data, (bit32.bor(bit32_lshift_ret, math_max_ret)));
            local v604;

            if v602 == nil or v603 == nil then
                v604 = i2;
            else
                v604 = i2;

                for i3 = v602, v602 + v603 - 1 do
                    local buffer_readu16_ret3 = buffer.readu16(Data.buffer, Data.candidateOffset + (i3 - 1) * CANDIDATE_SIZE);
                    local v605 = (buffer_readu16_ret3 - 1) * 4;
                    local v606;

                    if buffer.readu32(p584.PlaneMarks, v605) == v600 then
                        v606 = false;
                    else
                        buffer.writeu32(p584.PlaneMarks, v605, v600);
                        v606 = true;
                    end;

                    local v607;

                    if v606 then
                        if v597 <= 0 then
                            return false, nil, 0;
                        end;

                        v597 = v597 - 1;

                        if p595 then
                            p595.planes = p595.planes + 1;
                        end;

                        local v608, v609 = planeCoversBuffer(Data, buffer_readu16_ret3, p585, p590, p591, p592, p593, p584.ViewerProjectionScratch, p584.TargetProjectionScratch, p595);

                        if v608 then
                            return true, buffer_readu16_ret3, v609;
                        end;

                        v607 = i3;
                    else
                        v607 = i3;
                    end;
                end;
            end;
        end;
    end;

    return false, nil, 0;
end;

function u1.PairKey(p610: number, p611: number) -- Line: 29
    local math_min_ret = math.min(p610, p611);
    local math_max_ret = math.max(p610, p611);
    local bit32_lshift_ret = bit32.lshift(math_min_ret, 16);

    return bit32.bor(bit32_lshift_ret, math_max_ret);
end;

function u1.SamplePacket(p612: any, p613: number) -- Line: 2109
    -- upvalues: readTriangle (copy)
    if p613 < 1 or (p612.Data.triangleCount < p613 or p613 % 1 ~= 0) then
        return nil;
    end;

    local v614 = (p613 - 1) % 4096 + 1;

    if p612.SamplePacketIds[v614] == p613 then
        return p612.SamplePackets[v614];
    end;

    local v615, v616, v617 = readTriangle(p612.Data, p613);
    local table_freeze_ret = table.freeze({ v615, v616 - v615, v617 - v615 });
    p612.SamplePacketIds[v614] = p613;
    p612.SamplePackets[v614] = table_freeze_ret;

    return table_freeze_ret;
end;

return table.freeze(u1);