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

local function readVector(p2: buffer, p3: number) -- Line: 116
    local buffer_readf32_ret = buffer.readf32(p2, p3);
    local buffer_readf32_ret2 = buffer.readf32(p2, p3 + 4);
    local buffer_readf32_ret3 = buffer.readf32(p2, p3 + 8);

    return Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
end;

local function readTriangle(p4: any, p5: number) -- Line: 124
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

local function segmentIntersectsBounds(p12: vector, p13: number, p14: number, p15: number, p16: vector, p17: vector, p18: number) -- Line: 142
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

local function segmentEdgesFraction(p26: vector, p27: vector, p28: vector, p29: vector, p30: vector, p31: number?) -- Line: 193
    local v32 = p27:Cross(p30);
    local v33 = p29:Dot(v32);

    if math.abs(v33) <= 1e-7 then
        return nil;
    end;

    local v34 = 1 / v33;
    local v35 = p26 - p28;
    local v36 = v35:Dot(v32) * v34;
    local v37 = p31 or -1e-7;

    if v36 < v37 or 1 - v37 < v36 then
        return nil;
    end;

    local v38 = v35:Cross(p29);
    local v39 = p27:Dot(v38) * v34;

    if v39 < v37 or v36 + v39 > 1 - v37 then
        return nil;
    end;

    local v40 = p30:Dot(v38) * v34;

    if v40 >= 1e-7 and v40 <= 0.9999999 then
        return v40;
    end;

    return nil;
end;

local function segmentTriangleFraction(p41: vector, p42: vector, p43: vector, p44: vector, p45: vector) -- Line: 222
    -- upvalues: segmentEdgesFraction (copy)
    return segmentEdgesFraction(p41, p42, p43, p44 - p43, p45 - p43);
end;

function u1.new(p46: string, p47: string?, p48: function?) -- Line: 226
    -- upvalues: StaticOcclusionCodec (copy), u1 (copy)
    local v49 = StaticOcclusionCodec.decode(p46, p48);

    if p47 ~= nil and v49.fingerprint ~= p47 then
        error("PVBVH1 fingerprint does not match the expected visibility geometry");
    end;

    local v50 = {
        PlaneMarkToken = 0,
        Data = v49,
        SamplePacketIds = {},
        SamplePackets = {},
        Stack = table.create((math.max(v49.nodeCount, 8))),
        TriangleCacheIds = table.create(4096, 0),
        TriangleCacheA = table.create(4096),
        TriangleCacheFirstEdge = table.create(4096),
        TriangleCacheSecondEdge = table.create(4096),
        PlaneMarks = buffer.create(math.max(v49.planeCount, 1) * 4),
        CandidatePlanes = table.create(v49.planeCount),
        ChildReferences = table.create(8),
        ChildDepths = table.create(8),
        ViewerProjectionScratch = buffer.create(48960),
        TargetProjectionScratch = buffer.create(48960),
        VolumePairMarks = buffer.create(65025),
        BatchProjectionScratch = buffer.create(48960),
        BatchVolumePairMarks = buffer.create(65025)
    };

    return setmetatable(v50, u1);
end;

function u1.GetFingerprint(p51) -- Line: 258
    return p51.Data.fingerprint;
end;

function u1.InstallProofs(u52: any, u53: string, u54: function?) -- Line: 263
    u52.Proofs = nil;
    local success, result = pcall(function() -- Line: 269
        -- upvalues: u53 (copy), u52 (copy), u54 (copy)
        return require(script.Parent.ExactOcclusionProofs).new(u53, u52.Data, u54);
    end);

    if not success then
        return false, tostring(result);
    end;

    u52.Proofs = result;

    return true, nil;
end;

local function querySegment(p55: any, p56: vector, p57: vector, p58: table?, p59: boolean, p60: number?, p61: number?) -- Line: 280
    -- upvalues: NODE_SIZE (copy), segmentIntersectsBounds (copy), LEAF_SIZE (copy), readTriangle (copy), segmentEdgesFraction (copy)
    local v62 = p57 - p56;

    if v62:Dot(v62) <= 1e-7 then
        return false, nil, nil, nil;
    end;

    local v63 = math.abs(v62.X) <= 1e-7 and 0 or 1 / v62.X;
    local v64 = math.abs(v62.Y) <= 1e-7 and 0 or 1 / v62.Y;
    local v65 = math.abs(v62.Z) <= 1e-7 and 0 or 1 / v62.Z;
    local Data = p55.Data;
    local buffer2 = Data.buffer;
    local Stack = p55.Stack;
    Stack[1] = p61 or Data.rootNode;
    local v66 = 1;
    local v67 = 0;
    local v68 = 1;
    local v69 = nil;
    local v70 = nil;

    while v66 > 0 do
        if p60 and (v67 % 32 == 0 and p60 <= os.clock()) then
            return false, nil, nil, nil, false;
        end;

        v67 = v67 + 1;
        local v71 = Stack[v66];
        v66 = v66 - 1;

        if p58 then
            p58.nodes = p58.nodes + 1;
        end;

        local v72 = Data.nodeOffset + (v71 - 1) * NODE_SIZE;

        for i = 1, 8 do
            local buffer_readi32_ret = buffer.readi32(buffer2, v72 + 192 + (i - 1) * 4);
            local v73;

            if buffer_readi32_ret == 0 then
                v73 = i;
            else
                local v74 = v72 + (i - 1) * 24;
                local buffer_readf32_ret = buffer.readf32(buffer2, v74);
                local buffer_readf32_ret2 = buffer.readf32(buffer2, v74 + 4);
                local buffer_readf32_ret3 = buffer.readf32(buffer2, v74 + 8);
                local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
                local v75 = v74 + 12;
                local buffer_readf32_ret4 = buffer.readf32(buffer2, v75);
                local buffer_readf32_ret5 = buffer.readf32(buffer2, v75 + 4);
                local buffer_readf32_ret6 = buffer.readf32(buffer2, v75 + 8);

                if segmentIntersectsBounds(p56, v63, v64, v65, Vector3_new_ret, Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6), v68) then
                    if buffer_readi32_ret > 0 then
                        v66 = v66 + 1;
                        Stack[v66] = buffer_readi32_ret;
                        v73 = i;
                    else
                        local v76 = Data.leafOffset + (-buffer_readi32_ret - 1) * LEAF_SIZE;
                        local buffer_readu32_ret = buffer.readu32(buffer2, v76);
                        v73 = i;

                        for i2 = buffer_readu32_ret, buffer_readu32_ret + buffer.readu16(buffer2, v76 + 4) - 1 do
                            if p58 then
                                p58.triangles = p58.triangles + 1;
                            end;

                            local v77, v78, v79, v80 = readTriangle(Data, i2);
                            local v81 = segmentEdgesFraction(p56, v62, v77, v78 - v77, v79 - v77);
                            local v82;

                            if v81 == nil or v81 >= v68 then
                                v82 = i2;
                            else
                                if not p59 then
                                    p55.LastHitNode = v71;

                                    return true, v80, i2, v81;
                                end;

                                v70 = v80;
                                v69 = i2;
                                v82 = v69;
                                v68 = v81;
                                local v83 = v69;
                                v69 = v82;
                                v83 = v82;
                                v82 = v69;
                            end;
                        end;
                    end;
                else
                    v73 = i;
                end;
            end;
        end;
    end;

    local v84 = v69 ~= nil;

    if v69 == nil then
        return v84, v70, v69, nil;
    end;

    return v84, v70, v69, v68;
end;

function u1.SegmentBlocked(p85: any, p86: vector, p87: vector, p88: table?, p89: number?, p90: number?) -- Line: 357
    -- upvalues: querySegment (copy)
    if p90 and (p90 >= 1 and (p90 <= p85.Data.nodeCount and (p90 % 1 == 0 and p90 ~= p85.Data.rootNode))) then
        local v91, v92, v93, _, v94 = querySegment(p85, p86, p87, p88, false, p89, p90);

        if v94 == false then
            return false, nil, nil, false;
        end;

        if v91 then
            return true, v92, v93, true;
        end;
    end;

    local v95, v96, v97, _, v98 = querySegment(p85, p86, p87, p88, false, p89);

    return v95, v96, v97, v98 ~= false;
end;

local function boxMaxAlong(p99: vector, p100: vector, p101: vector, p102: vector) -- Line: 380
    local v103;

    if p99.X >= 0 then
        v103 = p102.X;
    else
        v103 = p101.X;
    end;

    local v104;

    if p99.Y >= 0 then
        v104 = p102.Y;
    else
        v104 = p101.Y;
    end;

    local v105;

    if p99.Z >= 0 then
        v105 = p102.Z;
    else
        v105 = p101.Z;
    end;

    return (v103 - p100.X) * p99.X + (v104 - p100.Y) * p99.Y + (v105 - p100.Z) * p99.Z;
end;

function u1.VisitFrustumTriangles(p106: any, p107: vector, p108: table, p109: vector, p110: number, p111: number, p112: function, p113: number, p114: number?) -- Line: 388
    -- upvalues: LEAF_SIZE (copy), NODE_SIZE (copy), boxMaxAlong (copy)
    local Data = p106.Data;
    local buffer2 = Data.buffer;
    local Stack = p106.Stack;
    local ChildReferences = p106.ChildReferences;
    local ChildDepths = p106.ChildDepths;
    Stack[1] = Data.rootNode;
    local v115 = -p109;
    local v116 = 1;
    local v117 = 0;
    local v118 = 0;

    while true do
        local v119;

        while true do
            if v116 <= 0 then
                return false, true;
            end;

            if p114 and (v117 % 32 == 0 and p114 <= os.clock()) then
                return false, false;
            end;

            v117 = v117 + 1;
            v119 = Stack[v116];
            v116 = v116 - 1;

            if v119 >= 0 then
                break;
            end;

            local v120 = Data.leafOffset + (-v119 - 1) * LEAF_SIZE;
            local buffer_readu32_ret = buffer.readu32(buffer2, v120);
            local buffer_readu16_ret = buffer.readu16(buffer2, v120 + 4);
            v118 = v118 + buffer_readu16_ret;

            if p113 < v118 then
                return false, false;
            end;

            for i = buffer_readu32_ret, buffer_readu32_ret + buffer_readu16_ret - 1 do
                if p112(i) then
                    return true, true;
                end;

                local _ = i;
            end;
        end;

        local v121 = Data.nodeOffset + (v119 - 1) * NODE_SIZE;
        local v122 = 0;

        for i = 1, 8 do
            local buffer_readi32_ret = buffer.readi32(buffer2, v121 + 192 + (i - 1) * 4);
            local v123;

            if buffer_readi32_ret == 0 then
                v123 = i;
            else
                local v124 = v121 + (i - 1) * 24;
                local buffer_readf32_ret = buffer.readf32(buffer2, v124);
                local buffer_readf32_ret2 = buffer.readf32(buffer2, v124 + 4);
                local buffer_readf32_ret3 = buffer.readf32(buffer2, v124 + 8);
                local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
                local v125 = v124 + 12;
                local buffer_readf32_ret4 = buffer.readf32(buffer2, v125);
                local buffer_readf32_ret5 = buffer.readf32(buffer2, v125 + 4);
                local buffer_readf32_ret6 = buffer.readf32(buffer2, v125 + 8);
                local Vector3_new_ret2 = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
                local v126 = -boxMaxAlong(v115, p107, Vector3_new_ret, Vector3_new_ret2);

                if boxMaxAlong(p109, p107, Vector3_new_ret, Vector3_new_ret2) < p110 or p111 < v126 then
                    v123 = i;
                else
                    v123 = i;
                    local v127 = false;

                    for _, v in p108 do
                        if boxMaxAlong(v, p107, Vector3_new_ret, Vector3_new_ret2) < 0 then
                            v127 = true;
                            break;
                        end;
                    end;

                    if not v127 then
                        local v128 = v122 + 1;
                        v122 = v128;

                        while v128 > 1 and ChildDepths[v128 - 1] < v126 do
                            ChildDepths[v128] = ChildDepths[v128 - 1];
                            ChildReferences[v128] = ChildReferences[v128 - 1];
                            v128 = v128 - 1;
                        end;

                        ChildDepths[v128] = v126;
                        ChildReferences[v128] = buffer_readi32_ret;
                    end;
                end;
            end;
        end;

        for i = 1, v122 do
            v116 = v116 + 1;
            Stack[v116] = ChildReferences[i];
            local _ = i;
        end;
    end;
end;

function u1.TriangleVertices(p129: any, p130: number) -- Line: 475
    -- upvalues: readTriangle (copy)
    local v131 = (p130 - 1) % 4096 + 1;

    if p129.TriangleCacheIds[v131] ~= p130 then
        local v132, v133, v134 = readTriangle(p129.Data, p130);
        p129.TriangleCacheIds[v131] = p130;
        p129.TriangleCacheA[v131] = v132;
        p129.TriangleCacheFirstEdge[v131] = v133 - v132;
        p129.TriangleCacheSecondEdge[v131] = v134 - v132;
    end;

    local v135 = p129.TriangleCacheA[v131];

    return v135, v135 + p129.TriangleCacheFirstEdge[v131], v135 + p129.TriangleCacheSecondEdge[v131];
end;

function u1.NearestSegmentHit(p136: any, p137: vector, p138: vector) -- Line: 492
    -- upvalues: querySegment (copy)
    local _, _, _, v139 = querySegment(p136, p137, p138, nil, true);

    return v139;
end;

function u1.TriangleBlocksSegment(p140: any, p141: number, p142: vector, p143: vector) -- Line: 502
    -- upvalues: readTriangle (copy), segmentEdgesFraction (copy)
    local Data = p140.Data;

    if p141 < 1 or Data.triangleCount < p141 then
        return false;
    end;

    local v144 = p143 - p142;

    if v144:Dot(v144) <= 1e-7 then
        return false;
    end;

    local v145 = (p141 - 1) % 4096 + 1;

    if p140.TriangleCacheIds[v145] ~= p141 then
        local v146, v147, v148 = readTriangle(Data, p141);
        p140.TriangleCacheIds[v145] = p141;
        p140.TriangleCacheA[v145] = v146;
        p140.TriangleCacheFirstEdge[v145] = v147 - v146;
        p140.TriangleCacheSecondEdge[v145] = v148 - v146;
    end;

    return segmentEdgesFraction(p142, v144, p140.TriangleCacheA[v145], p140.TriangleCacheFirstEdge[v145], p140.TriangleCacheSecondEdge[v145]) ~= nil;
end;

function u1.ProveTriangleBuffer(p149: any, p150: buffer, p151: number, p152: number, p153: number, p154: number, p155: number) -- Line: 534
    -- upvalues: readTriangle (copy), segmentEdgesFraction (copy)
    if p153 == 0 or (p155 < 4 or (p151 < 1 or p149.Data.triangleCount < p151)) then
        return false;
    end;

    local v156, v157, v158 = readTriangle(p149.Data, p151);
    local v159 = v157 - v156;
    local v160 = v158 - v156;

    for i = 0, p153 - 1 do
        local v161 = p152 + i * 12;
        local buffer_readf32_ret = buffer.readf32(p150, v161);
        local buffer_readf32_ret2 = buffer.readf32(p150, v161 + 4);
        local buffer_readf32_ret3 = buffer.readf32(p150, v161 + 8);
        local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
        local _ = i;

        for i2 = 0, p155 - 1 do
            local v162 = p154 + i2 * 12;
            local buffer_readf32_ret4 = buffer.readf32(p150, v162);
            local buffer_readf32_ret5 = buffer.readf32(p150, v162 + 4);
            local buffer_readf32_ret6 = buffer.readf32(p150, v162 + 8);

            if segmentEdgesFraction(Vector3_new_ret, Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6) - Vector3_new_ret, v156, v159, v160, 0.00001) == nil then
                return false;
            end;

            local _ = i2;
        end;
    end;

    return true;
end;

local function rectangleCoverage(p163: any, p164: number, p165: number, p166: number, p167: number, p168: number, p169: number, p170: table?) -- Line: 560
    -- upvalues: RECT_SIZE (copy)
    local v171 = p166 - 0.01;
    local v172 = p167 + 0.01;
    local v173 = p168 - 0.01;
    local v174 = p169 + 0.01;
    local buffer2 = p163.buffer;

    if p165 == 1 then
        if p170 then
            p170.rectangles = p170.rectangles + 1;
        end;

        local v175 = p163.rectangleOffset + (p164 - 1) * RECT_SIZE;
        local v176 = buffer.readf32(buffer2, v175) + 0.01;
        local v177 = buffer.readf32(buffer2, v175 + 4) - 0.01;
        local v178 = buffer.readf32(buffer2, v175 + 8) + 0.01;
        local v179 = buffer.readf32(buffer2, v175 + 12) - 0.01;
        local v180;

        if v176 <= v171 and (v172 <= v177 and v178 <= v173) then
            v180 = v174 <= v179;
        else
            v180 = false;
        end;

        if v180 then
            return v180, 1;
        end;

        return v180, 0;
    end;

    local v181 = { v171, v172 };
    local v182 = {};

    for i = p164, p164 + p165 - 1 do
        if p170 then
            p170.rectangles = p170.rectangles + 1;
        end;

        local v183 = p163.rectangleOffset + (i - 1) * RECT_SIZE;
        local v184 = buffer.readf32(buffer2, v183) + 0.01;
        local v185 = buffer.readf32(buffer2, v183 + 4) - 0.01;
        local v186 = buffer.readf32(buffer2, v183 + 8) + 0.01;
        local v187 = buffer.readf32(buffer2, v183 + 12) - 0.01;
        local v188;

        if v184 <= v172 and (v171 <= v185 and (v186 <= v174 and v173 <= v187)) then
            v182[#v182 + 1] = {
                minimumU = v184,
                maximumU = v185,
                minimumV = v186,
                maximumV = v187,
                primitive = buffer.readu32(buffer2, v183 + 16)
            };
            v181[#v181 + 1] = math.max(v184, v171);
            v181[#v181 + 1] = math.min(v185, v172);
            v188 = i;
        else
            v188 = i;
        end;
    end;

    if #v182 == 0 then
        return false, 0;
    end;

    table.sort(v181);
    local v189 = {};

    for i = 1, #v181 - 1 do
        local v190 = v181[i];
        local v191 = v181[i + 1];
        local v192;

        if v191 - v190 <= 1e-7 then
            v192 = i;
        else
            local v193 = (v190 + v191) * 0.5;
            v192 = i;
            local v194 = {};

            for _, v in v182 do
                if v.minimumU <= v193 and v193 <= v.maximumU then
                    v194[#v194 + 1] = v;
                end;
            end;

            table.sort(v194, function(p195, p196) -- Line: 637
                if p195.minimumV == p196.minimumV then
                    return p195.maximumV > p196.maximumV;
                end;

                return p195.minimumV < p196.minimumV;
            end);
            local v197 = v173;

            for _, v in v194 do
                if v.minimumV > v173 + 1e-7 then
                    return false, 0;
                end;

                if v173 < v.maximumV then
                    v173 = v.maximumV;
                    v189[v.primitive] = true;
                end;

                if v174 <= v173 then
                    break;
                end;
            end;

            if v173 < v174 then
                return false, 0;
            end;

            v173 = v197;
        end;
    end;

    local v198 = 0;

    for _ in v189 do
        v198 = v198 + 1;
    end;

    return true, v198;
end;

local function planeCovers(p199: any, p200: number, p201: table, p202: table, p203: table?) -- Line: 667
    -- upvalues: PLANE_SIZE (copy), rectangleCoverage (copy)
    local buffer2 = p199.buffer;
    local v204 = p199.planeOffset + (p200 - 1) * PLANE_SIZE;
    local buffer_readf32_ret = buffer.readf32(buffer2, v204);
    local buffer_readf32_ret2 = buffer.readf32(buffer2, v204 + 4);
    local buffer_readf32_ret3 = buffer.readf32(buffer2, v204 + 8);
    local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local v205 = v204 + 12;
    local buffer_readf32_ret4 = buffer.readf32(buffer2, v205);
    local buffer_readf32_ret5 = buffer.readf32(buffer2, v205 + 4);
    local buffer_readf32_ret6 = buffer.readf32(buffer2, v205 + 8);
    local Vector3_new_ret2 = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
    local v206 = v204 + 24;
    local buffer_readf32_ret7 = buffer.readf32(buffer2, v206);
    local buffer_readf32_ret8 = buffer.readf32(buffer2, v206 + 4);
    local buffer_readf32_ret9 = buffer.readf32(buffer2, v206 + 8);
    local Vector3_new_ret3 = Vector3.new(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);
    local v207 = v204 + 36;
    local buffer_readf32_ret10 = buffer.readf32(buffer2, v207);
    local buffer_readf32_ret11 = buffer.readf32(buffer2, v207 + 4);
    local buffer_readf32_ret12 = buffer.readf32(buffer2, v207 + 8);
    local Vector3_new_ret4 = Vector3.new(buffer_readf32_ret10, buffer_readf32_ret11, buffer_readf32_ret12);
    local buffer_readu32_ret = buffer.readu32(buffer2, v204 + 48);
    local buffer_readu16_ret = buffer.readu16(buffer2, v204 + 52);
    local v208 = 0;

    for _, v in p202 do
        local v209 = (v - Vector3_new_ret):Dot(Vector3_new_ret4);

        if math.abs(v209) <= 0.01 then
            return false, 0;
        end;

        local v210 = v209 > 0 and 1 or -1;

        if v208 == 0 then
            v208 = v210;
        elseif v210 ~= v208 then
            return false, 0;
        end;
    end;

    if v208 == 0 then
        return false, 0;
    end;

    local v211 = (1 / 0);
    local v212 = (-1 / 0);
    local v213 = (1 / 0);
    local v214 = (-1 / 0);

    for _, v in p201 do
        local v215 = (v - Vector3_new_ret):Dot(Vector3_new_ret4);

        if math.abs(v215) <= 0.01 or (v215 > 0 and 1 or -1) == v208 then
            return false, 0;
        end;

        local v216 = v;

        for _, v2 in p202 do
            local v217 = (v2 - Vector3_new_ret):Dot(Vector3_new_ret4) - v215;

            if math.abs(v217) <= 1e-7 then
                return false, 0;
            end;

            local v218 = -v215 / v217;

            if v218 <= 0 or v218 >= 1 then
                return false, 0;
            end;

            local v219 = v216:Lerp(v2, v218) - Vector3_new_ret;
            local v220 = v219:Dot(Vector3_new_ret2);
            local v221 = v219:Dot(Vector3_new_ret3);
            v211 = math.min(v211, v220);
            v214 = math.max(v214, v220);
            v213 = math.min(v213, v221);
            v212 = math.max(v212, v221);
        end;
    end;

    return rectangleCoverage(p199, buffer_readu32_ret, buffer_readu16_ret, v211, v214, v213, v212, p203);
end;

local function projectFootprintBuffer(p222: buffer, p223: vector, p224: vector, p225: vector, p226: vector, p227: number, p228: number, p229: number, p230: number, p231: buffer, p232: buffer) -- Line: 733
    if p228 > 255 or p230 > 255 then
        return false, 0, 0, 0, 0;
    end;

    local v233 = 0;

    for i = 0, p230 - 1 do
        local v234 = p229 + i * 12;
        local buffer_readf32_ret = buffer.readf32(p222, v234);
        local buffer_readf32_ret2 = buffer.readf32(p222, v234 + 4);
        local buffer_readf32_ret3 = buffer.readf32(p222, v234 + 8);
        local v235 = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3) - p223;
        local v236 = v235:Dot(p226);

        if math.abs(v236) <= 0.01 then
            return false, 0, 0, 0, 0;
        end;

        local v237 = v236 > 0 and 1 or -1;

        if v233 == 0 then
            v233 = v237;
        elseif v237 ~= v233 then
            return false, 0, 0, 0, 0;
        end;

        local v238 = i * 24;
        buffer.writef64(p232, v238, v236);
        local v239 = v235:Dot(p224);
        buffer.writef64(p232, v238 + 8, v239);
        local v240 = v235:Dot(p225);
        buffer.writef64(p232, v238 + 16, v240);
        local _ = i;
    end;

    if v233 == 0 then
        return false, 0, 0, 0, 0;
    end;

    for i = 0, p228 - 1 do
        local v241 = p227 + i * 12;
        local buffer_readf32_ret = buffer.readf32(p222, v241);
        local buffer_readf32_ret2 = buffer.readf32(p222, v241 + 4);
        local buffer_readf32_ret3 = buffer.readf32(p222, v241 + 8);
        local v242 = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3) - p223;
        local v243 = v242:Dot(p226);

        if math.abs(v243) <= 0.01 or (v243 > 0 and 1 or -1) == v233 then
            return false, 0, 0, 0, 0;
        end;

        local v244 = i * 24;
        buffer.writef64(p231, v244, v243);
        local v245 = v242:Dot(p224);
        buffer.writef64(p231, v244 + 8, v245);
        local v246 = v242:Dot(p225);
        buffer.writef64(p231, v244 + 16, v246);
        local _ = i;
    end;

    local v247 = (-1 / 0);
    local v248 = (1 / 0);
    local v249 = (-1 / 0);
    local v250 = (1 / 0);

    for i = 0, p228 - 1 do
        local v251 = i * 24;
        local buffer_readf64_ret = buffer.readf64(p231, v251);
        local buffer_readf64_ret2 = buffer.readf64(p231, v251 + 8);
        local buffer_readf64_ret3 = buffer.readf64(p231, v251 + 16);
        local _ = i;

        for i2 = 0, p230 - 1 do
            local v252 = i2 * 24;
            local v253 = buffer.readf64(p232, v252) - buffer_readf64_ret;

            if math.abs(v253) <= 1e-7 then
                return false, 0, 0, 0, 0;
            end;

            local v254 = -buffer_readf64_ret / v253;

            if v254 <= 0 or v254 >= 1 then
                return false, 0, 0, 0, 0;
            end;

            local buffer_readf64_ret4 = buffer.readf64(p232, v252 + 8);
            local buffer_readf64_ret5 = buffer.readf64(p232, v252 + 16);
            local v255 = buffer_readf64_ret2 + (buffer_readf64_ret4 - buffer_readf64_ret2) * v254;
            local v256 = buffer_readf64_ret3 + (buffer_readf64_ret5 - buffer_readf64_ret3) * v254;
            v248 = math.min(v248, v255);
            v249 = math.max(v249, v255);
            v250 = math.min(v250, v256);
            v247 = math.max(v247, v256);
            local _ = i2;
        end;
    end;

    return true, v248, v249, v250, v247;
end;

local function planeCoversBuffer(p257: any, p258: number, p259: buffer, p260: number, p261: number, p262: number, p263: number, p264: buffer, p265: buffer, p266: table?) -- Line: 820
    -- upvalues: PLANE_SIZE (copy), projectFootprintBuffer (copy), rectangleCoverage (copy)
    local buffer2 = p257.buffer;
    local v267 = p257.planeOffset + (p258 - 1) * PLANE_SIZE;
    local buffer_readf32_ret = buffer.readf32(buffer2, v267);
    local buffer_readf32_ret2 = buffer.readf32(buffer2, v267 + 4);
    local buffer_readf32_ret3 = buffer.readf32(buffer2, v267 + 8);
    local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local v268 = v267 + 12;
    local buffer_readf32_ret4 = buffer.readf32(buffer2, v268);
    local buffer_readf32_ret5 = buffer.readf32(buffer2, v268 + 4);
    local buffer_readf32_ret6 = buffer.readf32(buffer2, v268 + 8);
    local Vector3_new_ret2 = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
    local v269 = v267 + 24;
    local buffer_readf32_ret7 = buffer.readf32(buffer2, v269);
    local buffer_readf32_ret8 = buffer.readf32(buffer2, v269 + 4);
    local buffer_readf32_ret9 = buffer.readf32(buffer2, v269 + 8);
    local Vector3_new_ret3 = Vector3.new(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);
    local v270 = v267 + 36;
    local buffer_readf32_ret10 = buffer.readf32(buffer2, v270);
    local buffer_readf32_ret11 = buffer.readf32(buffer2, v270 + 4);
    local buffer_readf32_ret12 = buffer.readf32(buffer2, v270 + 8);
    local Vector3_new_ret4 = Vector3.new(buffer_readf32_ret10, buffer_readf32_ret11, buffer_readf32_ret12);
    local buffer_readu32_ret = buffer.readu32(buffer2, v267 + 48);
    local buffer_readu16_ret = buffer.readu16(buffer2, v267 + 52);
    local v271, v272, v273, v274, v275 = projectFootprintBuffer(p259, Vector3_new_ret, Vector3_new_ret2, Vector3_new_ret3, Vector3_new_ret4, p260, p261, p262, p263, p264, p265);

    if v271 then
        return rectangleCoverage(p257, buffer_readu32_ret, buffer_readu16_ret, v272, v273, v274, v275, p266);
    end;

    return false, 0;
end;

local function projectBufferPoints(p276: any, p277: number, p278: buffer, p279: number, p280: number, p281: buffer, p282: number?) -- Line: 859
    -- upvalues: PLANE_SIZE (copy)
    if p280 > 2040 then
        return false;
    end;

    local buffer2 = p276.buffer;
    local v283 = p276.planeOffset + (p277 - 1) * PLANE_SIZE;
    local buffer_readf32_ret = buffer.readf32(buffer2, v283);
    local buffer_readf32_ret2 = buffer.readf32(buffer2, v283 + 4);
    local buffer_readf32_ret3 = buffer.readf32(buffer2, v283 + 8);
    local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local v284 = v283 + 12;
    local buffer_readf32_ret4 = buffer.readf32(buffer2, v284);
    local buffer_readf32_ret5 = buffer.readf32(buffer2, v284 + 4);
    local buffer_readf32_ret6 = buffer.readf32(buffer2, v284 + 8);
    local Vector3_new_ret2 = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
    local v285 = v283 + 24;
    local buffer_readf32_ret7 = buffer.readf32(buffer2, v285);
    local buffer_readf32_ret8 = buffer.readf32(buffer2, v285 + 4);
    local buffer_readf32_ret9 = buffer.readf32(buffer2, v285 + 8);
    local Vector3_new_ret3 = Vector3.new(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);
    local v286 = v283 + 36;
    local buffer_readf32_ret10 = buffer.readf32(buffer2, v286);
    local buffer_readf32_ret11 = buffer.readf32(buffer2, v286 + 4);
    local buffer_readf32_ret12 = buffer.readf32(buffer2, v286 + 8);
    local Vector3_new_ret4 = Vector3.new(buffer_readf32_ret10, buffer_readf32_ret11, buffer_readf32_ret12);
    local v287 = p282 or 0;

    for i = 0, p280 - 1 do
        local v288 = p279 + i * 12;
        local buffer_readf32_ret13 = buffer.readf32(p278, v288);
        local buffer_readf32_ret14 = buffer.readf32(p278, v288 + 4);
        local buffer_readf32_ret15 = buffer.readf32(p278, v288 + 8);
        local v289 = Vector3.new(buffer_readf32_ret13, buffer_readf32_ret14, buffer_readf32_ret15) - Vector3_new_ret;
        local v290 = (v287 + i) * 24;
        local v291 = v289:Dot(Vector3_new_ret4);
        buffer.writef64(p281, v290, v291);
        local v292 = v289:Dot(Vector3_new_ret2);
        buffer.writef64(p281, v290 + 8, v292);
        local v293 = v289:Dot(Vector3_new_ret3);
        buffer.writef64(p281, v290 + 16, v293);
        local _ = i;
    end;

    return true;
end;

local function projectedVolumePairCoverage(p294: any, p295: number, p296: buffer, p297: number, p298: number, p299: buffer, p300: number, p301: number, p302: table?) -- Line: 888
    -- upvalues: PLANE_SIZE (copy), RECT_SIZE (copy), rectangleCoverage (copy)
    local v303 = 0;

    for i = p300, p300 + p301 - 1 do
        local buffer_readf64_ret = buffer.readf64(p299, i * 24);

        if math.abs(buffer_readf64_ret) <= 0.01 then
            return false, 0;
        end;

        local v304 = buffer_readf64_ret > 0 and 1 or -1;
        local v305;

        if v303 == 0 then
            v303 = v304;
            v305 = i;
        else
            if v304 ~= v303 then
                return false, 0;
            end;

            v305 = i;
        end;
    end;

    if v303 == 0 then
        return false, 0;
    end;

    for i = p297, p297 + p298 - 1 do
        local buffer_readf64_ret = buffer.readf64(p296, i * 24);

        if math.abs(buffer_readf64_ret) <= 0.01 or (buffer_readf64_ret > 0 and 1 or -1) == v303 then
            return false, 0;
        end;

        local _ = i;
    end;

    local buffer2 = p294.buffer;
    local v306 = p294.planeOffset + (p295 - 1) * PLANE_SIZE;
    local buffer_readu32_ret = buffer.readu32(buffer2, v306 + 48);
    local buffer_readu16_ret = buffer.readu16(buffer2, v306 + 52);

    if buffer_readu16_ret == 1 then
        local v307 = p294.rectangleOffset + (buffer_readu32_ret - 1) * RECT_SIZE;
        local v308 = buffer.readf32(buffer2, v307) + 0.02;
        local v309 = buffer.readf32(buffer2, v307 + 4) - 0.02;
        local v310 = buffer.readf32(buffer2, v307 + 8) + 0.02;
        local v311 = buffer.readf32(buffer2, v307 + 12) - 0.02;
        local v312 = p297 * 24;
        local v313 = p300 * 24;
        local buffer_readf64_ret = buffer.readf64(p296, v312);
        local v314 = buffer.readf64(p299, v313) - buffer_readf64_ret;

        if math.abs(v314) <= 1e-7 then
            return false, 0;
        end;

        local v315 = -buffer_readf64_ret / v314;

        if v315 <= 0 or v315 >= 1 then
            return false, 0;
        end;

        local buffer_readf64_ret2 = buffer.readf64(p296, v312 + 8);
        local buffer_readf64_ret3 = buffer.readf64(p296, v312 + 16);
        local v316 = buffer_readf64_ret2 + (buffer.readf64(p299, v313 + 8) - buffer_readf64_ret2) * v315;
        local v317 = buffer_readf64_ret3 + (buffer.readf64(p299, v313 + 16) - buffer_readf64_ret3) * v315;

        if v316 < v308 or (v309 < v316 or (v317 < v310 or v311 < v317)) then
            return false, 0;
        end;

        local v318 = (1 / 0);
        local v319 = (-1 / 0);
        local v320 = (1 / 0);
        local v321 = (-1 / 0);

        for i = p297, p297 + p298 - 1 do
            local v322 = i * 24;
            local buffer_readf64_ret4 = buffer.readf64(p296, v322 + 8);
            local buffer_readf64_ret5 = buffer.readf64(p296, v322 + 16);
            v318 = math.min(v318, buffer_readf64_ret4);
            v319 = math.max(v319, buffer_readf64_ret4);
            v320 = math.min(v320, buffer_readf64_ret5);
            v321 = math.max(v321, buffer_readf64_ret5);
            local _ = i;
        end;

        for i = p300, p300 + p301 - 1 do
            local v323 = i * 24;
            local buffer_readf64_ret4 = buffer.readf64(p299, v323 + 8);
            local buffer_readf64_ret5 = buffer.readf64(p299, v323 + 16);
            v318 = math.min(v318, buffer_readf64_ret4);
            v319 = math.max(v319, buffer_readf64_ret4);
            v320 = math.min(v320, buffer_readf64_ret5);
            v321 = math.max(v321, buffer_readf64_ret5);
            local _ = i;
        end;

        if v308 <= v318 and (v319 <= v309 and (v310 <= v320 and v321 <= v311)) then
            if p302 then
                p302.rectangles = p302.rectangles + 1;
            end;

            return true, 1;
        end;
    end;

    local v324 = (-1 / 0);
    local v325 = (1 / 0);
    local v326 = (-1 / 0);
    local v327 = (1 / 0);

    for i = p297, p297 + p298 - 1 do
        local v328 = i * 24;
        local buffer_readf64_ret = buffer.readf64(p296, v328);
        local buffer_readf64_ret2 = buffer.readf64(p296, v328 + 8);
        local buffer_readf64_ret3 = buffer.readf64(p296, v328 + 16);
        local _ = i;

        for i2 = p300, p300 + p301 - 1 do
            local v329 = i2 * 24;
            local v330 = buffer.readf64(p299, v329) - buffer_readf64_ret;

            if math.abs(v330) <= 1e-7 then
                return false, 0;
            end;

            local v331 = -buffer_readf64_ret / v330;

            if v331 <= 0 or v331 >= 1 then
                return false, 0;
            end;

            local buffer_readf64_ret4 = buffer.readf64(p299, v329 + 8);
            local buffer_readf64_ret5 = buffer.readf64(p299, v329 + 16);
            local v332 = buffer_readf64_ret2 + (buffer_readf64_ret4 - buffer_readf64_ret2) * v331;
            local v333 = buffer_readf64_ret3 + (buffer_readf64_ret5 - buffer_readf64_ret3) * v331;
            v325 = math.min(v325, v332);
            v326 = math.max(v326, v332);
            v327 = math.min(v327, v333);
            v324 = math.max(v324, v333);
            local _ = i2;
        end;
    end;

    return rectangleCoverage(p294, buffer_readu32_ret, buffer_readu16_ret, v325, v326, v327, v324, p302);
end;

local function nextPlaneMark(p334) -- Line: 1028
    local v335 = p334.PlaneMarkToken + 1;

    if v335 >= 4294967295 then
        buffer.fill(p334.PlaneMarks, 0, 0);
        v335 = 1;
    end;

    p334.PlaneMarkToken = v335;

    return v335;
end;

local function markPlane(p336: any, p337: number, p338: number) -- Line: 1038
    local v339 = (p337 - 1) * 4;

    if buffer.readu32(p336.PlaneMarks, v339) == p338 then
        return false;
    end;

    buffer.writeu32(p336.PlaneMarks, v339, p338);

    return true;
end;

function u1.ProveProjectedOccluded(p340: any, p341: table, p342: table, p343: number?, p344: table?) -- Line: 1047
    -- upvalues: planeCovers (copy)
    if #p341 == 0 or #p342 < 4 then
        return false, nil, 0;
    end;

    local Data = p340.Data;

    if p343 ~= nil and (p343 >= 1 and p343 <= Data.planeCount) then
        if p344 then
            p344.planes = p344.planes + 1;
        end;

        local v345, v346 = planeCovers(Data, p343, p341, p342, p344);

        if v345 then
            return true, p343, v346;
        end;
    end;

    for i = 1, Data.planeCount do
        local v347;

        if i == p343 then
            v347 = i;
        else
            if p344 then
                p344.planes = p344.planes + 1;
            end;

            local v348, v349 = planeCovers(Data, i, p341, p342, p344);

            if v348 then
                return true, i, v349;
            end;

            v347 = i;
        end;
    end;

    return false, nil, 0;
end;

local function findCertificate(p350: any, p351: number) -- Line: 1082
    -- upvalues: CERTIFICATE_SIZE (copy)
    local buffer2 = p350.buffer;
    local certificateCount = p350.certificateCount;
    local v352 = 1;

    while v352 <= certificateCount do
        local math_floor_ret = math.floor((v352 + certificateCount) * 0.5);
        local v353 = p350.certificateOffset + (math_floor_ret - 1) * CERTIFICATE_SIZE;
        local buffer_readu32_ret = buffer.readu32(buffer2, v353);

        if buffer_readu32_ret == p351 then
            return buffer.readu32(buffer2, v353 + 4), buffer.readu16(buffer2, v353 + 8);
        end;

        if buffer_readu32_ret < p351 then
            v352 = math_floor_ret + 1;
        else
            certificateCount = math_floor_ret - 1;
        end;
    end;

    return nil, nil;
end;

local function beginCandidatePlanes(p354: any, p355: number?) -- Line: 1101
    local CandidatePlanes = p354.CandidatePlanes;
    table.clear(CandidatePlanes);
    local v356 = p354.PlaneMarkToken + 1;

    if v356 >= 4294967295 then
        buffer.fill(p354.PlaneMarks, 0, 0);
        v356 = 1;
    end;

    p354.PlaneMarkToken = v356;

    if p355 ~= nil and (p355 >= 1 and p355 <= p354.Data.planeCount) then
        local v357 = (p355 - 1) * 4;

        if buffer.readu32(p354.PlaneMarks, v357) ~= v356 then
            buffer.writeu32(p354.PlaneMarks, v357, v356);
        end;

        CandidatePlanes[1] = p355;
    end;

    return v356, CandidatePlanes;
end;

local function appendCertificatePlanes(p358: any, p359: number, p360: table, p361: number, p362: number) -- Line: 1113
    -- upvalues: findCertificate (copy), CANDIDATE_SIZE (copy)
    local Data = p358.Data;
    local math_min_ret = math.min(p361, p362);
    local math_max_ret = math.max(p361, p362);
    local bit32_lshift_ret = bit32.lshift(math_min_ret, 16);
    local v363, v364 = findCertificate(Data, (bit32.bor(bit32_lshift_ret, math_max_ret)));

    if v363 == nil or v364 == nil then
        return;
    end;

    for i = v363, v363 + v364 - 1 do
        local buffer_readu16_ret = buffer.readu16(Data.buffer, Data.candidateOffset + (i - 1) * CANDIDATE_SIZE);
        local v365 = (buffer_readu16_ret - 1) * 4;
        local v366;

        if buffer.readu32(p358.PlaneMarks, v365) == p359 then
            v366 = false;
        else
            buffer.writeu32(p358.PlaneMarks, v365, p359);
            v366 = true;
        end;

        local v367;

        if v366 then
            p360[#p360 + 1] = buffer_readu16_ret;
            v367 = i;
        else
            v367 = i;
        end;
    end;
end;

local function candidatePlanesForCells(p368: any, p369: table, p370: table, p371: number?) -- Line: 1133
    -- upvalues: appendCertificatePlanes (copy)
    local CandidatePlanes = p368.CandidatePlanes;
    table.clear(CandidatePlanes);
    local v372 = p368.PlaneMarkToken + 1;

    if v372 >= 4294967295 then
        buffer.fill(p368.PlaneMarks, 0, 0);
        v372 = 1;
    end;

    p368.PlaneMarkToken = v372;

    if p371 ~= nil and (p371 >= 1 and p371 <= p368.Data.planeCount) then
        local v373 = (p371 - 1) * 4;

        if buffer.readu32(p368.PlaneMarks, v373) ~= v372 then
            buffer.writeu32(p368.PlaneMarks, v373, v372);
        end;

        CandidatePlanes[1] = p371;
    end;

    for _, v in p369 do
        local v374 = v;

        for _, v2 in p370 do
            appendCertificatePlanes(p368, v372, CandidatePlanes, v374, v2);
        end;
    end;

    return CandidatePlanes;
end;

local function candidatePlanesForCellBuffer(p375: any, p376: buffer, p377: number, p378: number, p379: number, p380: number, p381: number?) -- Line: 1148
    -- upvalues: appendCertificatePlanes (copy)
    local CandidatePlanes = p375.CandidatePlanes;
    table.clear(CandidatePlanes);
    local v382 = p375.PlaneMarkToken + 1;

    if v382 >= 4294967295 then
        buffer.fill(p375.PlaneMarks, 0, 0);
        v382 = 1;
    end;

    p375.PlaneMarkToken = v382;

    if p381 ~= nil and (p381 >= 1 and p381 <= p375.Data.planeCount) then
        local v383 = (p381 - 1) * 4;

        if buffer.readu32(p375.PlaneMarks, v383) ~= v382 then
            buffer.writeu32(p375.PlaneMarks, v383, v382);
        end;

        CandidatePlanes[1] = p381;
    end;

    for i = 0, p378 - 1 do
        local buffer_readu16_ret = buffer.readu16(p376, p377 + i * 2);
        local _ = i;

        for i2 = 0, p380 - 1 do
            appendCertificatePlanes(p375, v382, CandidatePlanes, buffer_readu16_ret, (buffer.readu16(p376, p379 + i2 * 2)));
            local _ = i2;
        end;
    end;

    return CandidatePlanes;
end;

function u1.ProveProjectedOccludedForCells(p384: any, p385: table, p386: table, p387: table, p388: table, p389: number?, p390: table?) -- Line: 1168
    -- upvalues: planeCovers (copy), findCertificate (copy), CANDIDATE_SIZE (copy)
    if #p387 == 0 or (#p388 < 4 or (#p385 == 0 or #p386 == 0)) then
        return false, nil, 0;
    end;

    local Data = p384.Data;

    if p389 ~= nil and (p389 >= 1 and p389 <= Data.planeCount) then
        if p390 then
            p390.planes = p390.planes + 1;
        end;

        local v391, v392 = planeCovers(Data, p389, p387, p388, p390);

        if v391 then
            return true, p389, v392;
        end;
    end;

    local v393 = p384.PlaneMarkToken + 1;

    if v393 >= 4294967295 then
        buffer.fill(p384.PlaneMarks, 0, 0);
        v393 = 1;
    end;

    p384.PlaneMarkToken = v393;

    if p389 ~= nil then
        local v394 = (p389 - 1) * 4;

        if buffer.readu32(p384.PlaneMarks, v394) ~= v393 then
            buffer.writeu32(p384.PlaneMarks, v394, v393);
        end;
    end;

    for _, v in p385 do
        local v395 = v;

        for _, v2 in p386 do
            local math_min_ret = math.min(v395, v2);
            local math_max_ret = math.max(v395, v2);
            local bit32_lshift_ret = bit32.lshift(math_min_ret, 16);
            local v396, v397 = findCertificate(Data, (bit32.bor(bit32_lshift_ret, math_max_ret)));

            if v396 ~= nil and v397 ~= nil then
                for i = v396, v396 + v397 - 1 do
                    local buffer_readu16_ret = buffer.readu16(Data.buffer, Data.candidateOffset + (i - 1) * CANDIDATE_SIZE);
                    local v398 = (buffer_readu16_ret - 1) * 4;
                    local v399;

                    if buffer.readu32(p384.PlaneMarks, v398) == v393 then
                        v399 = false;
                    else
                        buffer.writeu32(p384.PlaneMarks, v398, v393);
                        v399 = true;
                    end;

                    local v400;

                    if v399 then
                        if p390 then
                            p390.planes = p390.planes + 1;
                        end;

                        local v401, v402 = planeCovers(Data, buffer_readu16_ret, p387, p388, p390);

                        if v401 then
                            return true, buffer_readu16_ret, v402;
                        end;

                        v400 = i;
                    else
                        v400 = i;
                    end;
                end;
            end;
        end;
    end;

    return false, nil, 0;
end;

function u1.ProveProjectedOccludedForVolumeGroups(p403: any, p404: table, p405: table, p406: table, p407: table, p408: number?, p409: table?) -- Line: 1220
    -- upvalues: candidatePlanesForCells (copy), planeCovers (copy)
    if #p406 == 0 or #p407 == 0 then
        return false, nil, 0;
    end;

    local v410 = candidatePlanesForCells(p403, p404, p405, p408);

    if #v410 == 0 then
        return false, nil, 0;
    end;

    local v411 = 0;
    local v412 = nil;

    for _, v in p406 do
        local v413 = v;

        for _, v2 in p407 do
            local v414 = v2;
            local v415 = 0;
            local v416 = nil;
            local v417 = false;

            for _, v3 in v410 do
                if p409 then
                    p409.planes = p409.planes + 1;
                end;

                local v418, v419 = planeCovers(p403.Data, v3, v413, v414, p409);

                if v418 then
                    v415 = v419;
                    v416 = v3;
                    v417 = true;
                    break;
                end;
            end;

            if not v417 then
                return false, nil, 0;
            end;

            if v412 ~= nil then
                v416 = v412;
            end;

            v411 = v411 + v415;
            v412 = v416;
        end;
    end;

    return true, v412, v411;
end;

function u1.ProveProjectedOccludedForVolumeGroupBuffer(p420: any, p421: buffer, p422: number, p423: number, p424: number, p425: number, p426: number, p427: number, p428: number, p429: number, p430: number?, p431: table?) -- Line: 1268
    -- upvalues: candidatePlanesForCellBuffer (copy), projectBufferPoints (copy), projectedVolumePairCoverage (copy)
    if p423 == 0 or (p425 == 0 or (p427 == 0 or p429 == 0)) then
        return false, nil, 0;
    end;

    local v432 = candidatePlanesForCellBuffer(p420, p421, p422, p423, p424, p425, p430);

    if #v432 == 0 then
        return false, nil, 0;
    end;

    if p427 > 255 or p429 > 255 then
        return false, nil, 0;
    end;

    local v433 = p427 * p429;
    local VolumePairMarks = p420.VolumePairMarks;
    buffer.fill(VolumePairMarks, 0, 0, v433);
    local v434 = nil;
    local v435 = 0;

    for _, v in v432 do
        if not (projectBufferPoints(p420.Data, v, p421, p426, p427 * 8, p420.ViewerProjectionScratch) and projectBufferPoints(p420.Data, v, p421, p428, p429 * 8, p420.TargetProjectionScratch)) then
            return false, nil, 0;
        end;

        local v436;

        if p427 > 1 then
            v436 = v;

            for i = 0, p429 - 1 do
                local v437 = i;
                local v438 = 0;

                for i2 = 0, p427 - 1 do
                    local v439;

                    if buffer.readu8(VolumePairMarks, i2 * p429 + v437) == 0 then
                        v438 = v438 + 1;
                        v439 = i2;
                    else
                        v439 = i2;
                    end;
                end;

                if v438 ~= 0 then
                    if p431 then
                        p431.planes = p431.planes + 1;
                    end;

                    local v440, v441 = projectedVolumePairCoverage(p420.Data, v436, p420.ViewerProjectionScratch, 0, p427 * 8, p420.TargetProjectionScratch, v437 * 8, 8, p431);

                    if v440 then
                        for i2 = 0, p427 - 1 do
                            local v442 = i2 * p429 + v437;
                            local v443;

                            if buffer.readu8(VolumePairMarks, v442) == 0 then
                                buffer.writeu8(VolumePairMarks, v442, 1);
                                v433 = v433 - 1;
                                v443 = i2;
                            else
                                v443 = i2;
                            end;
                        end;

                        v435 = v435 + v441 * v438;
                        v434 = v434 or v436;
                    end;
                end;
            end;

            if v433 == 0 then
                return true, v434, v435;
            end;
        else
            v436 = v;
        end;

        for i = 0, p427 - 1 do
            local v444 = i;

            for i2 = 0, p429 - 1 do
                local v445 = v444 * p429 + i2;
                local v446;

                if buffer.readu8(VolumePairMarks, v445) == 0 then
                    if p431 then
                        p431.planes = p431.planes + 1;
                    end;

                    local v447, v448 = projectedVolumePairCoverage(p420.Data, v436, p420.ViewerProjectionScratch, v444 * 8, 8, p420.TargetProjectionScratch, i2 * 8, 8, p431);

                    if v447 then
                        buffer.writeu8(VolumePairMarks, v445, 1);
                        v433 = v433 - 1;
                        v435 = v435 + v448;
                        v446 = i2;
                        v434 = v434 or v436;
                    else
                        v446 = i2;
                    end;
                else
                    v446 = i2;
                end;
            end;
        end;

        if v433 == 0 then
            return true, v434, v435;
        end;
    end;

    return false, nil, 0;
end;

local function ensureBatchScratch(p449: any, p450: number, p451: number) -- Line: 1405
    local v452 = math.max(p450, 1) * 24;

    if buffer.len(p449.BatchProjectionScratch) < v452 then
        p449.BatchProjectionScratch = buffer.create(v452);
    end;

    if buffer.len(p449.BatchVolumePairMarks) < math.max(p451, 1) then
        p449.BatchVolumePairMarks = buffer.create((math.max(p451, 1)));
    end;
end;

function u1.ProveProjectedOccludedActorBatchBuffer(u453: any, u454: buffer, p455: table, p456: table, p457: table?) -- Line: 1416
    -- upvalues: candidatePlanesForCellBuffer (copy), ensureBatchScratch (copy), projectBufferPoints (copy), projectedVolumePairCoverage (copy)
    local table_create_ret = table.create(#p455);
    local v458 = 0;

    for i, v in p455 do
        local v459 = {
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
            ViewerProjectionIndex = v458
        };
        local v460 = v458 + v.ViewerPointCount;
        v459.TargetProjectionIndex = v460;
        local v461 = v460 + v.TargetPointCount;
        v459.FallbackViewerProjectionIndex = v461;
        local v462 = v461 + v.FallbackViewerCount * 8;
        v459.FallbackTargetProjectionIndex = v462;
        v458 = v462 + v.FallbackTargetCount * 8;
        table_create_ret[i] = v459;
    end;

    local table_create_ret2 = table.create(#p456);
    local v463 = 0;
    local v464 = {};
    local v465 = {};
    local v466 = {};

    for i, v in p456 do
        local v467 = table_create_ret[v.ViewerActor];
        local v468 = table_create_ret[v.TargetActor];
        local v469 = {};
        local v470 = 0;
        local v471, v472;

        if v467 == nil or v468 == nil then
            v471 = i;
            v472 = v;
        else
            local v473;

            if v.Fallback then
                if v467.FallbackViewerCount > 0 then
                    v473 = v468.FallbackTargetCount > 0;
                else
                    v473 = false;
                end;
            elseif v467.ViewerPointCount > 0 then
                v473 = v468.TargetPointCount >= 4;
            else
                v473 = false;
            end;

            if v473 and (v467.CellCount > 0 and v468.CellCount > 0) then
                v472 = v;
                v471 = i;

                for _, v2 in candidatePlanesForCellBuffer(u453, u454, v467.CellsOffset, v467.CellCount, v468.CellsOffset, v468.CellCount, v.PreferredPlane) do
                    v469[#v469 + 1] = v2;
                    local v474 = v464[v2];

                    if v474 == nil then
                        v474 = {};
                        v464[v2] = v474;
                    end;

                    v474[#v474 + 1] = v471;

                    if not v465[v2] then
                        v465[v2] = true;
                        v466[#v466 + 1] = v2;
                    end;
                end;
            else
                v471 = i;
                v472 = v;
            end;

            if v472.Fallback then
                v470 = v467.FallbackViewerCount * v468.FallbackTargetCount;
            end;
        end;

        table_create_ret2[v471] = {
            FirstPlane = nil,
            ProofLeaves = 0,
            Proved = false,
            Tests = 0,
            Query = v472,
            Planes = v469,
            MarkOffset = v463,
            RemainingPairs = v470
        };
        v463 = v463 + v470;
    end;

    ensureBatchScratch(u453, v458, v463);
    local BatchProjectionScratch = u453.BatchProjectionScratch;
    local BatchVolumePairMarks = u453.BatchVolumePairMarks;

    if v463 > 0 then
        buffer.fill(BatchVolumePairMarks, 0, 0, v463);
    end;

    local table_create_ret3 = table.create(#p455, 0);
    local table_create_ret4 = table.create(#p455, 0);
    local table_create_ret5 = table.create(#p455, 0);
    local table_create_ret6 = table.create(#p455, 0);
    local u475 = 0;

    local function ensureProjected(p476: number, p477: number, p478: number, p479: number, p480: number, p481: table) -- Line: 1520
        -- upvalues: projectBufferPoints (ref), u453 (copy), u454 (copy), BatchProjectionScratch (copy), u475 (ref)
        if p481[p476] == p477 then
            return true;
        end;

        if not projectBufferPoints(u453.Data, p477, u454, p478, p479, BatchProjectionScratch, p480) then
            return false;
        end;

        p481[p476] = p477;
        u475 = u475 + 1;

        return true;
    end;

    local v482 = 0;

    for _, v in table_create_ret2 do
        local Query = v.Query;
        local PreferredPlane = Query.PreferredPlane;

        if PreferredPlane ~= nil and not (Query.Fallback or (v.Proved or v.Planes[1] ~= PreferredPlane)) then
            local v483 = table_create_ret[Query.ViewerActor];
            local v484 = table_create_ret[Query.TargetActor];

            if v483 ~= nil and v484 ~= nil then
                local ViewerActor = Query.ViewerActor;
                local ViewerPointsOffset = v483.ViewerPointsOffset;
                local ViewerPointCount = v483.ViewerPointCount;
                local ViewerProjectionIndex = v483.ViewerProjectionIndex;
                local v485;

                if table_create_ret3[ViewerActor] == PreferredPlane then
                    v485 = true;
                elseif projectBufferPoints(u453.Data, PreferredPlane, u454, ViewerPointsOffset, ViewerPointCount, BatchProjectionScratch, ViewerProjectionIndex) then
                    table_create_ret3[ViewerActor] = PreferredPlane;
                    u475 = u475 + 1;
                    v485 = true;
                else
                    v485 = false;
                end;

                if v485 then
                    local TargetActor = Query.TargetActor;
                    local TargetPointsOffset = v484.TargetPointsOffset;
                    local TargetPointCount = v484.TargetPointCount;
                    local TargetProjectionIndex = v484.TargetProjectionIndex;
                    local v486;

                    if table_create_ret4[TargetActor] == PreferredPlane then
                        v486 = true;
                    elseif projectBufferPoints(u453.Data, PreferredPlane, u454, TargetPointsOffset, TargetPointCount, BatchProjectionScratch, TargetProjectionIndex) then
                        table_create_ret4[TargetActor] = PreferredPlane;
                        u475 = u475 + 1;
                        v486 = true;
                    else
                        v486 = false;
                    end;

                    if v486 then
                        if p457 then
                            p457.planes = p457.planes + 1;
                        end;

                        v482 = v482 + 1;
                        v.Tests = v.Tests + 1;
                        local v487, v488 = projectedVolumePairCoverage(u453.Data, PreferredPlane, BatchProjectionScratch, v483.ViewerProjectionIndex, v483.ViewerPointCount, BatchProjectionScratch, v484.TargetProjectionIndex, v484.TargetPointCount, p457);

                        if v487 then
                            v.Proved = true;
                            v.FirstPlane = PreferredPlane;
                            v.ProofLeaves = v488;
                        end;
                    end;
                end;
            end;
        end;
    end;

    for _, v in v466 do
        local v489 = v464[v];

        if v489 ~= nil then
            local v490 = v;

            for _, v2 in v489 do
                local v491 = table_create_ret2[v2];

                if not v491.Proved and v491.Tests < 24 then
                    local Query = v491.Query;
                    local v492 = table_create_ret[Query.ViewerActor];
                    local v493 = table_create_ret[Query.TargetActor];

                    if v492 ~= nil and (v493 ~= nil and (Query.PreferredPlane ~= v490 or (v491.Tests <= 0 or Query.Fallback))) then
                        if p457 then
                            p457.planes = p457.planes + 1;
                        end;

                        v491.Tests = v491.Tests + 1;

                        if Query.Fallback then
                            local ViewerActor = Query.ViewerActor;
                            local ViewerPointsOffset = v492.ViewerPointsOffset;
                            local ViewerPointCount = v492.ViewerPointCount;
                            local ViewerProjectionIndex = v492.ViewerProjectionIndex;
                            local v494;

                            if table_create_ret3[ViewerActor] == v490 then
                                v494 = true;
                            elseif projectBufferPoints(u453.Data, v490, u454, ViewerPointsOffset, ViewerPointCount, BatchProjectionScratch, ViewerProjectionIndex) then
                                table_create_ret3[ViewerActor] = v490;
                                u475 = u475 + 1;
                                v494 = true;
                            else
                                v494 = false;
                            end;

                            if v494 then
                                local TargetActor = Query.TargetActor;
                                local FallbackTargetOffset = v493.FallbackTargetOffset;
                                local v495 = v493.FallbackTargetCount * 8;
                                local FallbackTargetProjectionIndex = v493.FallbackTargetProjectionIndex;
                                local v496;

                                if table_create_ret6[TargetActor] == v490 then
                                    v496 = true;
                                elseif projectBufferPoints(u453.Data, v490, u454, FallbackTargetOffset, v495, BatchProjectionScratch, FallbackTargetProjectionIndex) then
                                    table_create_ret6[TargetActor] = v490;
                                    u475 = u475 + 1;
                                    v496 = true;
                                else
                                    v496 = false;
                                end;

                                if v496 then
                                    local FallbackViewerCount = v492.FallbackViewerCount;
                                    local FallbackTargetCount = v493.FallbackTargetCount;

                                    if FallbackViewerCount > 1 then
                                        for i = 0, FallbackTargetCount - 1 do
                                            local v497 = i;
                                            local v498 = 0;

                                            for i2 = 0, FallbackViewerCount - 1 do
                                                local v499;

                                                if buffer.readu8(BatchVolumePairMarks, v491.MarkOffset + i2 * FallbackTargetCount + v497) == 0 then
                                                    v498 = v498 + 1;
                                                    v499 = i2;
                                                else
                                                    v499 = i2;
                                                end;
                                            end;

                                            if v498 ~= 0 then
                                                v482 = v482 + 1;
                                                local v500, v501 = projectedVolumePairCoverage(u453.Data, v490, BatchProjectionScratch, v492.ViewerProjectionIndex, v492.ViewerPointCount, BatchProjectionScratch, v493.FallbackTargetProjectionIndex + v497 * 8, 8, p457);

                                                if v500 then
                                                    for i2 = 0, FallbackViewerCount - 1 do
                                                        local v502 = v491.MarkOffset + i2 * FallbackTargetCount + v497;
                                                        local v503;

                                                        if buffer.readu8(BatchVolumePairMarks, v502) == 0 then
                                                            buffer.writeu8(BatchVolumePairMarks, v502, 1);
                                                            v491.RemainingPairs = v491.RemainingPairs - 1;
                                                            v503 = i2;
                                                        else
                                                            v503 = i2;
                                                        end;
                                                    end;

                                                    v491.FirstPlane = v491.FirstPlane or v490;
                                                    v491.ProofLeaves = v491.ProofLeaves + v501 * v498;
                                                end;
                                            end;
                                        end;
                                    end;

                                    if v491.RemainingPairs > 0 then
                                        local ViewerActor2 = Query.ViewerActor;
                                        local FallbackViewerOffset = v492.FallbackViewerOffset;
                                        local v504 = FallbackViewerCount * 8;
                                        local FallbackViewerProjectionIndex = v492.FallbackViewerProjectionIndex;
                                        local v505;

                                        if table_create_ret5[ViewerActor2] == v490 then
                                            v505 = true;
                                        elseif projectBufferPoints(u453.Data, v490, u454, FallbackViewerOffset, v504, BatchProjectionScratch, FallbackViewerProjectionIndex) then
                                            table_create_ret5[ViewerActor2] = v490;
                                            u475 = u475 + 1;
                                            v505 = true;
                                        else
                                            v505 = false;
                                        end;

                                        if v505 then
                                            for i = 0, FallbackViewerCount - 1 do
                                                local v506 = i;

                                                for i2 = 0, FallbackTargetCount - 1 do
                                                    local v507 = v491.MarkOffset + v506 * FallbackTargetCount + i2;
                                                    local v508;

                                                    if buffer.readu8(BatchVolumePairMarks, v507) == 0 then
                                                        v482 = v482 + 1;
                                                        local v509, v510 = projectedVolumePairCoverage(u453.Data, v490, BatchProjectionScratch, v492.FallbackViewerProjectionIndex + v506 * 8, 8, BatchProjectionScratch, v493.FallbackTargetProjectionIndex + i2 * 8, 8, p457);

                                                        if v509 then
                                                            buffer.writeu8(BatchVolumePairMarks, v507, 1);
                                                            v491.RemainingPairs = v491.RemainingPairs - 1;
                                                            v491.FirstPlane = v491.FirstPlane or v490;
                                                            v491.ProofLeaves = v491.ProofLeaves + v510;
                                                            v508 = i2;
                                                        else
                                                            v508 = i2;
                                                        end;
                                                    else
                                                        v508 = i2;
                                                    end;
                                                end;
                                            end;

                                            if v491.RemainingPairs == 0 then
                                                v491.Proved = true;
                                            end;
                                        end;
                                    elseif v491.RemainingPairs == 0 then
                                        v491.Proved = true;
                                    end;
                                end;
                            end;
                        else
                            local ViewerActor = Query.ViewerActor;
                            local ViewerPointsOffset = v492.ViewerPointsOffset;
                            local ViewerPointCount = v492.ViewerPointCount;
                            local ViewerProjectionIndex = v492.ViewerProjectionIndex;
                            local v511;

                            if table_create_ret3[ViewerActor] == v490 then
                                v511 = true;
                            elseif projectBufferPoints(u453.Data, v490, u454, ViewerPointsOffset, ViewerPointCount, BatchProjectionScratch, ViewerProjectionIndex) then
                                table_create_ret3[ViewerActor] = v490;
                                u475 = u475 + 1;
                                v511 = true;
                            else
                                v511 = false;
                            end;

                            if v511 then
                                local TargetActor = Query.TargetActor;
                                local TargetPointsOffset = v493.TargetPointsOffset;
                                local TargetPointCount = v493.TargetPointCount;
                                local TargetProjectionIndex = v493.TargetProjectionIndex;
                                local v512;

                                if table_create_ret4[TargetActor] == v490 then
                                    v512 = true;
                                elseif projectBufferPoints(u453.Data, v490, u454, TargetPointsOffset, TargetPointCount, BatchProjectionScratch, TargetProjectionIndex) then
                                    table_create_ret4[TargetActor] = v490;
                                    u475 = u475 + 1;
                                    v512 = true;
                                else
                                    v512 = false;
                                end;

                                if v512 then
                                    v482 = v482 + 1;
                                    local v513, v514 = projectedVolumePairCoverage(u453.Data, v490, BatchProjectionScratch, v492.ViewerProjectionIndex, v492.ViewerPointCount, BatchProjectionScratch, v493.TargetProjectionIndex, v493.TargetPointCount, p457);

                                    if v513 then
                                        v491.Proved = true;
                                        v491.FirstPlane = v490;
                                        v491.ProofLeaves = v514;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local table_create_ret7 = table.create(#p456);

    for i, v in table_create_ret2 do
        local v515 = {
            Proved = v.Proved,
            PlaneIndex = v.FirstPlane,
            ProofLeaves = not v.Proved and 0 or v.ProofLeaves
        };
        v515.UsedFallback = v.Proved and v.Query.Fallback;
        table_create_ret7[i] = v515;
    end;

    return table_create_ret7, u475, v482;
end;

function u1.ProvePlaneBuffer(p516: any, p517: buffer, p518: number, p519: number, p520: number, p521: number, p522: number, p523: table?) -- Line: 1789
    -- upvalues: planeCoversBuffer (copy)
    local Data = p516.Data;

    if p520 == 0 or (p522 < 4 or (p518 < 1 or (Data.planeCount < p518 or p518 ~= math.floor(p518)))) then
        return false, 0;
    end;

    if p523 then
        p523.planes = p523.planes + 1;
    end;

    return planeCoversBuffer(Data, p518, p517, p519, p520, p521, p522, p516.ViewerProjectionScratch, p516.TargetProjectionScratch, p523);
end;

function u1.ProveRectangleBuffer(p524: any, p525: buffer, p526: vector, p527: vector, p528: vector, p529: vector, p530: number, p531: number, p532: number, p533: number, p534: number, p535: number) -- Line: 1827
    -- upvalues: projectFootprintBuffer (copy)
    if p533 == 0 or p535 < 4 then
        return false;
    end;

    local v536 = p530 - 0.02;
    local v537 = p531 - 0.02;

    if v536 <= 0 or v537 <= 0 then
        return false;
    end;

    local v538, v539, v540, v541, v542 = projectFootprintBuffer(p525, p526, p527, p528, p529, p532, p533, p534, p535, p524.ViewerProjectionScratch, p524.TargetProjectionScratch);

    if v538 then
        if -v536 <= v539 and (v540 <= v536 and -v537 <= v541) then
            v538 = v542 <= v537;
        else
            v538 = false;
        end;
    end;

    return v538;
end;

function u1.ProveProjectedOccludedForCellBuffer(p543: any, p544: buffer, p545: number, p546: number, p547: number, p548: number, p549: number, p550: number, p551: number, p552: number, p553: number?, p554: table?, p555: number?) -- Line: 1866
    -- upvalues: planeCoversBuffer (copy), findCertificate (copy), CANDIDATE_SIZE (copy)
    if p550 == 0 or (p552 < 4 or (p546 == 0 or p548 == 0)) then
        return false, nil, 0;
    end;

    local Data = p543.Data;
    local v556 = p555 or (1 / 0);

    if p553 ~= nil and (p553 >= 1 and p553 <= Data.planeCount) then
        if p554 then
            p554.planes = p554.planes + 1;
        end;

        v556 = v556 - 1;
        local v557, v558 = planeCoversBuffer(Data, p553, p544, p549, p550, p551, p552, p543.ViewerProjectionScratch, p543.TargetProjectionScratch, p554);

        if v557 then
            return true, p553, v558;
        end;
    end;

    local v559 = p543.PlaneMarkToken + 1;

    if v559 >= 4294967295 then
        buffer.fill(p543.PlaneMarks, 0, 0);
        v559 = 1;
    end;

    p543.PlaneMarkToken = v559;

    if p553 ~= nil and (p553 >= 1 and p553 <= Data.planeCount) then
        local v560 = (p553 - 1) * 4;

        if buffer.readu32(p543.PlaneMarks, v560) ~= v559 then
            buffer.writeu32(p543.PlaneMarks, v560, v559);
        end;
    end;

    for i = 0, p546 - 1 do
        local buffer_readu16_ret = buffer.readu16(p544, p545 + i * 2);
        local _ = i;

        for i2 = 0, p548 - 1 do
            local buffer_readu16_ret2 = buffer.readu16(p544, p547 + i2 * 2);
            local math_min_ret = math.min(buffer_readu16_ret, buffer_readu16_ret2);
            local math_max_ret = math.max(buffer_readu16_ret, buffer_readu16_ret2);
            local bit32_lshift_ret = bit32.lshift(math_min_ret, 16);
            local v561, v562 = findCertificate(Data, (bit32.bor(bit32_lshift_ret, math_max_ret)));
            local v563;

            if v561 == nil or v562 == nil then
                v563 = i2;
            else
                v563 = i2;

                for i3 = v561, v561 + v562 - 1 do
                    local buffer_readu16_ret3 = buffer.readu16(Data.buffer, Data.candidateOffset + (i3 - 1) * CANDIDATE_SIZE);
                    local v564 = (buffer_readu16_ret3 - 1) * 4;
                    local v565;

                    if buffer.readu32(p543.PlaneMarks, v564) == v559 then
                        v565 = false;
                    else
                        buffer.writeu32(p543.PlaneMarks, v564, v559);
                        v565 = true;
                    end;

                    local v566;

                    if v565 then
                        if v556 <= 0 then
                            return false, nil, 0;
                        end;

                        v556 = v556 - 1;

                        if p554 then
                            p554.planes = p554.planes + 1;
                        end;

                        local v567, v568 = planeCoversBuffer(Data, buffer_readu16_ret3, p544, p549, p550, p551, p552, p543.ViewerProjectionScratch, p543.TargetProjectionScratch, p554);

                        if v567 then
                            return true, buffer_readu16_ret3, v568;
                        end;

                        v566 = i3;
                    else
                        v566 = i3;
                    end;
                end;
            end;
        end;
    end;

    return false, nil, 0;
end;

function u1.PairKey(p569: number, p570: number) -- Line: 29
    local math_min_ret = math.min(p569, p570);
    local math_max_ret = math.max(p569, p570);
    local bit32_lshift_ret = bit32.lshift(math_min_ret, 16);

    return bit32.bor(bit32_lshift_ret, math_max_ret);
end;

function u1.SamplePacket(p571: any, p572: number) -- Line: 1956
    -- upvalues: readTriangle (copy)
    if p572 < 1 or (p571.Data.triangleCount < p572 or p572 % 1 ~= 0) then
        return nil;
    end;

    local v573 = (p572 - 1) % 4096 + 1;

    if p571.SamplePacketIds[v573] == p572 then
        return p571.SamplePackets[v573];
    end;

    local v574, v575, v576 = readTriangle(p571.Data, p572);
    local table_freeze_ret = table.freeze({ v574, v575 - v574, v576 - v574 });
    p571.SamplePacketIds[v573] = p572;
    p571.SamplePackets[v573] = table_freeze_ret;

    return table_freeze_ret;
end;

return table.freeze(u1);