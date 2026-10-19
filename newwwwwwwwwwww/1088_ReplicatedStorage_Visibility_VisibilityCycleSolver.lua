-- VisibilityCycleSolver (ModuleScript)
-- full path: ReplicatedStorage.Visibility.VisibilityCycleSolver

-- Decompiled with Potassium's decompiler.

local OcclusionMath = require(script.Parent.OcclusionMath);
local SilhouetteCoverage = require(script.Parent.SilhouetteCoverage);
require(script.Parent.StaticOcclusionRuntime);
local VisibilityCycleCodec = require(script.Parent.VisibilityCycleCodec);
local u1 = {};
u1.__index = u1;
local PRIMITIVE_SIZE = VisibilityCycleCodec.PRIMITIVE_SIZE;
local VECTOR_SIZE = VisibilityCycleCodec.VECTOR_SIZE;
local RESULT_HIDDEN = VisibilityCycleCodec.RESULT_HIDDEN;
local RESULT_VISIBLE = VisibilityCycleCodec.RESULT_VISIBLE;
local RESULT_UNRESOLVED = VisibilityCycleCodec.RESULT_UNRESOLVED;
local RESULT_SKIPPED = VisibilityCycleCodec.RESULT_SKIPPED;
local PAIR_SKIP = VisibilityCycleCodec.PAIR_SKIP;
local PAIR_PROOF = VisibilityCycleCodec.PAIR_PROOF;
local FLAG_DYNAMIC_CERTIFICATES = VisibilityCycleCodec.FLAG_DYNAMIC_CERTIFICATES;
local ACTOR_FLAG_EXTRAPOLATED = VisibilityCycleCodec.ACTOR_FLAG_EXTRAPOLATED;
local ACTOR_FLAG_HULL_TAIL = VisibilityCycleCodec.ACTOR_FLAG_HULL_TAIL;
local readVector = VisibilityCycleCodec.readVector;

function u1.new(p2: any, p3: buffer?, p4: number?, p5: table?) -- Line: 148
    -- upvalues: PRIMITIVE_SIZE (copy), VisibilityCycleCodec (copy), SilhouetteCoverage (copy), u1 (copy)
    local v6 = p5 or {};
    local v7 = {
        Cycle = 0,
        SearchBudget = 0,
        FaceTestBudget = 0,
        Static = p2,
        Primitives = p3,
        PrimitiveCount = p3 == nil and 0 or buffer.len(p3) // PRIMITIVE_SIZE,
        NonBlockPrimitiveCount = p4 or 0,
        Cache = {},
        SearchBudgetPerCycle = v6.SearchBudgetPerCycle or 12,
        SearchPlanes = v6.SearchPlanes or 8,
        SearchRetryCycles = v6.SearchRetryCycles or 30,
        FaceTestBudgetPerCycle = v6.FaceTestBudgetPerCycle or 192,
        FaceRetryCycles = v6.FaceRetryCycles or 8,
        OriginScratch = table.create(VisibilityCycleCodec.MAX_ORIGINS),
        PointScratch = table.create(VisibilityCycleCodec.MAX_TARGET_POINTS),
        BodyScratch = table.create(VisibilityCycleCodec.MAX_TARGET_POINTS * 2),
        SeedScratch = table.create(192),
        ProvenScratch = table.create(VisibilityCycleCodec.MAX_ORIGINS),
        Coverage = SilhouetteCoverage.new(),
        Stats = {
            PartialProofs = 0,
            Pairs = 0,
            Hidden = 0,
            Visible = 0,
            Unresolved = 0,
            Skipped = 0,
            CertificateHits = 0,
            CertificateSearches = 0,
            CertificateFound = 0,
            Segments = 0,
            BlockerHits = 0,
            BVHQueries = 0,
            BVHHits = 0,
            FallbackRays = 0,
            ClearReplays = 0,
            DynamicHits = 0,
            DynamicFound = 0,
            PoseReplays = 0
        },
        Stack = {}
    };

    return setmetatable(v7, u1);
end;

local function primitiveIsBlock(p8: buffer, p9: number) -- Line: 200
    -- upvalues: PRIMITIVE_SIZE (copy), VisibilityCycleCodec (copy)
    return buffer.readu8(p8, (p9 - 1) * PRIMITIVE_SIZE) == VisibilityCycleCodec.PRIMITIVE_KIND_BLOCK;
end;

local function primitiveBlocksSegment(p10: buffer, p11: number, p12: vector, p13: vector) -- Line: 205
    -- upvalues: PRIMITIVE_SIZE (copy)
    local v14 = (p11 - 1) * PRIMITIVE_SIZE;
    local v15 = p12.X - buffer.readf32(p10, v14 + 4);
    local v16 = p12.Y - buffer.readf32(p10, v14 + 8);
    local v17 = p12.Z - buffer.readf32(p10, v14 + 12);
    local buffer_readf32_ret = buffer.readf32(p10, v14 + 16);
    local buffer_readf32_ret2 = buffer.readf32(p10, v14 + 20);
    local buffer_readf32_ret3 = buffer.readf32(p10, v14 + 24);
    local buffer_readf32_ret4 = buffer.readf32(p10, v14 + 28);
    local buffer_readf32_ret5 = buffer.readf32(p10, v14 + 32);
    local buffer_readf32_ret6 = buffer.readf32(p10, v14 + 36);
    local buffer_readf32_ret7 = buffer.readf32(p10, v14 + 40);
    local buffer_readf32_ret8 = buffer.readf32(p10, v14 + 44);
    local buffer_readf32_ret9 = buffer.readf32(p10, v14 + 48);
    local v18 = buffer.readf32(p10, v14 + 52) + 0.02;
    local v19 = buffer.readf32(p10, v14 + 56) + 0.02;
    local v20 = buffer.readf32(p10, v14 + 60) + 0.02;
    local v21 = buffer_readf32_ret * v15 + buffer_readf32_ret4 * v16 + buffer_readf32_ret7 * v17;
    local v22 = buffer_readf32_ret2 * v15 + buffer_readf32_ret5 * v16 + buffer_readf32_ret8 * v17;
    local v23 = buffer_readf32_ret3 * v15 + buffer_readf32_ret6 * v16 + buffer_readf32_ret9 * v17;
    local v24 = buffer_readf32_ret * p13.X + buffer_readf32_ret4 * p13.Y + buffer_readf32_ret7 * p13.Z;
    local v25 = buffer_readf32_ret2 * p13.X + buffer_readf32_ret5 * p13.Y + buffer_readf32_ret8 * p13.Z;
    local v26 = buffer_readf32_ret3 * p13.X + buffer_readf32_ret6 * p13.Y + buffer_readf32_ret9 * p13.Z;
    local v27 = 0;
    local v28 = 1;

    if math.abs(v24) <= 1e-8 then
        if v18 < math.abs(v21) then
            return false;
        end;
    else
        local v29 = (-v18 - v21) / v24;
        local v30 = (v18 - v21) / v24;

        if v30 >= v29 then
            local v31 = v29;
            v29 = v30;
            v30 = v31;
        end;

        v27 = math.max(v27, v30);
        v28 = math.min(v28, v29);

        if v28 < v27 then
            return false;
        end;
    end;

    if math.abs(v25) <= 1e-8 then
        if v19 < math.abs(v22) then
            return false;
        end;
    else
        local v32 = (-v19 - v22) / v25;
        local v33 = (v19 - v22) / v25;

        if v33 >= v32 then
            local v34 = v32;
            v32 = v33;
            v33 = v34;
        end;

        v27 = math.max(v27, v33);
        v28 = math.min(v28, v32);

        if v28 < v27 then
            return false;
        end;
    end;

    if math.abs(v26) <= 1e-8 then
        return math.abs(v23) <= v20;
    end;

    local v35 = (-v20 - v23) / v26;
    local v36 = (v20 - v23) / v26;

    if v36 >= v35 then
        local v37 = v35;
        v35 = v36;
        v36 = v37;
    end;

    return math.max(v27, v36) <= math.min(v28, v35);
end;

local function rememberRecent(p38: table, p39: number, p40: number, p41: number) -- Line: 282
    for i = p39, 1, -1 do
        if p38[i] == p40 then
            if i < p39 then
                table.remove(p38, i);
                p38[p39] = p40;
            end;

            return p39;
        end;

        local _ = i;
    end;

    if p41 > p39 then
        p38[p39 + 1] = p40;

        return p39 + 1;
    end;

    table.remove(p38, 1);
    p38[p39] = p40;

    return p39;
end;

local function segmentBlocked(p42: any, p43: table, p44: vector, p45: vector, p46: function?) -- Line: 302
    -- upvalues: primitiveBlocksSegment (copy), PRIMITIVE_SIZE (copy), VisibilityCycleCodec (copy), rememberRecent (copy)
    local Stats = p42.Stats;
    Stats.Segments = Stats.Segments + 1;
    local v47 = p45 - p44;
    local Primitives = p42.Primitives;

    if Primitives ~= nil then
        local Blockers = p43.Blockers;

        for i = p43.BlockerCount, 1, -1 do
            local v48 = Blockers[i];

            if primitiveBlocksSegment(Primitives, v48, p44, v47) then
                Stats.BlockerHits = Stats.BlockerHits + 1;

                if i < p43.BlockerCount then
                    table.remove(Blockers, i);
                    Blockers[p43.BlockerCount] = v48;
                end;

                return true, true;
            end;

            local _ = i;
        end;
    end;

    local Static = p42.Static;
    local v49;

    if Static == nil then
        v49 = false;
    else
        local Triangles = p43.Triangles;

        for i = p43.TriangleCount, 1, -1 do
            local v50 = Triangles[i];

            if Static:TriangleBlocksSegment(v50, p44, p45) then
                Stats.BlockerHits = Stats.BlockerHits + 1;

                if i < p43.TriangleCount then
                    table.remove(Triangles, i);
                    Triangles[p43.TriangleCount] = v50;
                end;

                return true, true;
            end;

            local _ = i;
        end;

        v49 = true;
        Stats.BVHQueries = Stats.BVHQueries + 1;
        local v51, v52, v53, v54 = Static:SegmentBlocked(p44, p45, nil, p42.Deadline, p43.NodeHint);

        if v54 == false then
            return false, false;
        end;

        if v51 then
            p43.NodeHint = Static.LastHitNode;
            Stats.BVHHits = Stats.BVHHits + 1;

            if Primitives == nil or (v52 == nil or (v52 < 1 or v52 > p42.PrimitiveCount)) or buffer.readu8(Primitives, (v52 - 1) * PRIMITIVE_SIZE) ~= VisibilityCycleCodec.PRIMITIVE_KIND_BLOCK then
                if v53 ~= nil then
                    p43.TriangleCount = rememberRecent(p43.Triangles, p43.TriangleCount, v53, 8);
                end;
            else
                p43.BlockerCount = rememberRecent(p43.Blockers, p43.BlockerCount, v52, 8);
            end;

            return true, true;
        end;
    end;

    if p46 == nil or p42.NonBlockPrimitiveCount <= 0 and v49 then
        return false, v49;
    end;

    Stats.FallbackRays = Stats.FallbackRays + 1;
    local v55 = p46(p44, p45);

    if v55 == nil then
        return false, v49;
    end;

    return v55, true;
end;

local function pairCache(p56: any, p57: number, p58: number) -- Line: 379
    local v59 = p56.Cache[p57];

    if v59 == nil then
        v59 = {};
        p56.Cache[p57] = v59;
    end;

    local v60 = v59[p58];

    if v60 == nil then
        v60 = {
            BlockerCount = 0,
            TriangleCount = 0,
            SearchAfterCycle = 0,
            FaceSearchAfterCycle = 0,
            FaceFirst = false,
            HiddenAt = (-1 / 0),
            SampleHints = {},
            OriginProofRetry = {},
            OriginProofs = {},
            ProofCandidates = {},
            Blockers = {},
            Triangles = {},
            CoverageTriangles = {}
        };
        v59[p58] = v60;
    end;

    return v60;
end;

local function pruneCache(p61: any, p62: table) -- Line: 407
    for i, v in p61.Cache do
        if p62[i] then
            local v63 = v;

            for i2 in v do
                if not p62[i2] then
                    v63[i2] = nil;
                end;
            end;
        else
            p61.Cache[i] = nil;
        end;
    end;
end;

local function primitiveFace(p64: buffer, p65: number, p66: number, p67: number) -- Line: 422
    -- upvalues: PRIMITIVE_SIZE (copy)
    local v68 = (p65 - 1) * PRIMITIVE_SIZE;
    local buffer_readf32_ret = buffer.readf32(p64, v68 + 4);
    local buffer_readf32_ret2 = buffer.readf32(p64, v68 + 8);
    local buffer_readf32_ret3 = buffer.readf32(p64, v68 + 12);
    local Vector3_new_ret = Vector3.new(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local buffer_readf32_ret4 = buffer.readf32(p64, v68 + 16);
    local buffer_readf32_ret5 = buffer.readf32(p64, v68 + 28);
    local buffer_readf32_ret6 = buffer.readf32(p64, v68 + 40);
    local Vector3_new_ret2 = Vector3.new(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
    local buffer_readf32_ret7 = buffer.readf32(p64, v68 + 20);
    local buffer_readf32_ret8 = buffer.readf32(p64, v68 + 32);
    local buffer_readf32_ret9 = buffer.readf32(p64, v68 + 44);
    local Vector3_new_ret3 = Vector3.new(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);
    local buffer_readf32_ret10 = buffer.readf32(p64, v68 + 24);
    local buffer_readf32_ret11 = buffer.readf32(p64, v68 + 36);
    local buffer_readf32_ret12 = buffer.readf32(p64, v68 + 48);
    local Vector3_new_ret4 = Vector3.new(buffer_readf32_ret10, buffer_readf32_ret11, buffer_readf32_ret12);
    local buffer_readf32_ret13 = buffer.readf32(p64, v68 + 52);
    local buffer_readf32_ret14 = buffer.readf32(p64, v68 + 56);
    local buffer_readf32_ret15 = buffer.readf32(p64, v68 + 60);

    if p66 == 0 then
        return Vector3_new_ret + Vector3_new_ret2 * (p67 * buffer_readf32_ret13), Vector3_new_ret3, Vector3_new_ret4, Vector3_new_ret2 * p67, buffer_readf32_ret14, buffer_readf32_ret15;
    end;

    if p66 == 1 then
        return Vector3_new_ret + Vector3_new_ret3 * (p67 * buffer_readf32_ret14), Vector3_new_ret4, Vector3_new_ret2, Vector3_new_ret3 * p67, buffer_readf32_ret15, buffer_readf32_ret13;
    end;

    return Vector3_new_ret + Vector3_new_ret4 * (p67 * buffer_readf32_ret15), Vector3_new_ret2, Vector3_new_ret3, Vector3_new_ret4 * p67, buffer_readf32_ret13, buffer_readf32_ret14;
end;

local function coverageBody(p69, p70) -- Line: 461
    -- upvalues: ACTOR_FLAG_HULL_TAIL (copy), ACTOR_FLAG_EXTRAPOLATED (copy)
    local TargetPoints = p70.TargetPoints;
    local TargetPointCount = p70.TargetPointCount;
    local v71 = nil;

    if bit32.band(p70.Flags, ACTOR_FLAG_HULL_TAIL) ~= 0 then
        local v72 = bit32.band(p70.Flags, ACTOR_FLAG_EXTRAPOLATED) ~= 0;
        local v73 = v72 and 16 or 8;

        if v73 < TargetPointCount then
            TargetPointCount = TargetPointCount - v73;

            if v72 then
                v71 = TargetPoints[TargetPointCount + 9] - TargetPoints[TargetPointCount + 1];
            end;
        end;
    end;

    local BodyScratch = p69.BodyScratch;
    table.clear(BodyScratch);

    for i = 1, TargetPointCount do
        BodyScratch[i] = TargetPoints[i];
        local _ = i;
    end;

    if v71 ~= nil then
        for i = 1, TargetPointCount do
            BodyScratch[TargetPointCount + i] = TargetPoints[i] + v71;
            local _ = i;
        end;
    end;

    return BodyScratch, #BodyScratch;
end;

local function beginSeeds(p74: any, p75: table) -- Line: 490
    local SeedScratch = p74.SeedScratch;
    table.clear(SeedScratch);

    for i = 1, p75.TriangleCount do
        SeedScratch[i] = p75.Triangles[i];
        local _ = i;
    end;

    return SeedScratch;
end;

local function appendSeeds(p76: table, p77: table) -- Line: 499
    for _, v in p77 do
        if #p76 >= 192 then
            return;
        end;

        p76[#p76 + 1] = v;
    end;
end;

local function coverageBlocks(p78: any, p79: table?, p80: vector, p81: vector, p82: number) -- Line: 510
    return p79 == nil and 0 or p78:FirstBlockingTriangle(p79, p82, p80, p81);
end;

local function proofRange(p83) -- Line: 524
    -- upvalues: ACTOR_FLAG_HULL_TAIL (copy), ACTOR_FLAG_EXTRAPOLATED (copy), VECTOR_SIZE (copy)
    local TargetPointCount = p83.TargetPointCount;

    if bit32.band(p83.Flags, ACTOR_FLAG_HULL_TAIL) ~= 0 then
        local v84 = bit32.band(p83.Flags, ACTOR_FLAG_EXTRAPOLATED) == 0 and 8 or 16;

        if v84 < TargetPointCount then
            return p83.TargetPointsOffset + (TargetPointCount - v84) * VECTOR_SIZE, v84;
        end;
    end;

    return p83.TargetPointsOffset, TargetPointCount;
end;

local function faceCovers(p85: any, p86: buffer, p87: any, p88: any, p89: number, p90: number, p91: number) -- Line: 535
    -- upvalues: primitiveFace (copy), ACTOR_FLAG_HULL_TAIL (copy), ACTOR_FLAG_EXTRAPOLATED (copy), VECTOR_SIZE (copy)
    local Primitives = p85.Primitives;
    local Static = p85.Static;

    if Primitives == nil or (Static == nil or (p89 < 1 or p85.PrimitiveCount < p89)) then
        return false;
    end;

    local v92, v93, v94, v95, v96, v97 = primitiveFace(Primitives, p89, p90, p91);
    local TargetPointCount = p88.TargetPointCount;
    local v98;

    if bit32.band(p88.Flags, ACTOR_FLAG_HULL_TAIL) == 0 then
        v98 = p88.TargetPointsOffset;
    else
        local v99 = bit32.band(p88.Flags, ACTOR_FLAG_EXTRAPOLATED) == 0 and 8 or 16;

        if v99 < TargetPointCount then
            v98 = p88.TargetPointsOffset + (TargetPointCount - v99) * VECTOR_SIZE;
            TargetPointCount = v99;
        else
            v98 = p88.TargetPointsOffset;
        end;
    end;

    return Static:ProveRectangleBuffer(p86, v92, v93, v94, v95, v96, v97, p87.OriginsOffset, p87.OriginCount, v98, TargetPointCount);
end;

local function cachedFaceCovers(p100: any, p101: buffer, p102: any, p103: any, p104: table) -- Line: 566
    -- upvalues: faceCovers (copy)
    return faceCovers(p100, p101, p102, p103, p104.FacePrimitive, p104.FaceAxis, p104.FaceSign);
end;

local function searchBlockFace(p105: any, p106: buffer, p107: any, p108: any, p109: table, p110: number?, p111: number?, p112: number?) -- Line: 585
    -- upvalues: readVector (copy), PRIMITIVE_SIZE (copy), VisibilityCycleCodec (copy), faceCovers (copy)
    local Primitives = p105.Primitives;

    if Primitives == nil then
        return false;
    end;

    local v113 = readVector(p106, p107.OriginsOffset);
    local Blockers = p109.Blockers;
    local v114 = 0;

    for i = p109.BlockerCount, 1, -1 do
        local v115 = Blockers[i];
        local v116;

        if buffer.readu8(Primitives, (v115 - 1) * PRIMITIVE_SIZE) == VisibilityCycleCodec.PRIMITIVE_KIND_BLOCK then
            local v117 = (v115 - 1) * PRIMITIVE_SIZE;
            local v118 = v113.X - buffer.readf32(Primitives, v117 + 4);
            local v119 = v113.Y - buffer.readf32(Primitives, v117 + 8);
            local v120 = v113.Z - buffer.readf32(Primitives, v117 + 12);
            v116 = i;

            for i2 = 0, 2 do
                local v121 = v117 + 16 + i2 * 4;
                local v122 = buffer.readf32(Primitives, v121) * v118 + buffer.readf32(Primitives, v121 + 12) * v119 + buffer.readf32(Primitives, v121 + 24) * v120;
                local buffer_readf32_ret = buffer.readf32(Primitives, v117 + 52 + i2 * 4);
                local v123 = buffer_readf32_ret < v122 and 1 or (v122 < -buffer_readf32_ret and -1 or 0);
                local v124;

                if v123 == 0 or v115 == p110 and (i2 == p111 and v123 == p112) then
                    v124 = i2;
                else
                    if v114 >= 12 or p105.FaceTestBudget <= 0 then
                        return false;
                    end;

                    v114 = v114 + 1;
                    p105.FaceTestBudget = p105.FaceTestBudget - 1;

                    if faceCovers(p105, p106, p107, p108, v115, i2, v123) then
                        p109.FacePrimitive = v115;
                        p109.FaceAxis = i2;
                        p109.FaceSign = v123;

                        return true;
                    end;

                    v124 = i2;
                end;
            end;
        else
            v116 = i;
        end;
    end;

    return false;
end;

local function samplePacketBlocks(p125: any, p126: vector, p127: vector) -- Line: 638
    local v128 = p127 - p126;

    if v128:Dot(v128) <= 1e-7 then
        return false;
    end;

    local v129 = p125[2];
    local v130 = p125[3];
    local v131 = v128:Cross(v130);
    local v132 = v129:Dot(v131);

    if math.abs(v132) <= 1e-7 then
        return false;
    end;

    local v133 = 1 / v132;
    local v134 = p126 - p125[1];
    local v135 = v134:Dot(v131) * v133;

    if v135 < -1e-7 or v135 > 1.0000001 then
        return false;
    end;

    local v136 = v134:Cross(v129);
    local v137 = v128:Dot(v136) * v133;

    if v137 < -1e-7 or v135 + v137 > 1.0000001 then
        return false;
    end;

    local v138 = v130:Dot(v136) * v133;
    local v139;

    if v138 >= 1e-7 then
        v139 = v138 <= 0.9999999;
    else
        v139 = false;
    end;

    return v139;
end;

local function evaluatePair(p140: any, p141: buffer, p142: any, p143: any, p144: any, p145: number, p146: table, p147: function?, p148: boolean, p149: boolean, p150: string, p151: string, p152: number) -- Line: 670
    -- upvalues: RESULT_UNRESOLVED (copy), PAIR_PROOF (copy), faceCovers (copy), RESULT_HIDDEN (copy), ACTOR_FLAG_HULL_TAIL (copy), ACTOR_FLAG_EXTRAPOLATED (copy), VECTOR_SIZE (copy), coverageBody (copy), RESULT_VISIBLE (copy), segmentBlocked (copy), readVector (copy), VisibilityCycleCodec (copy), samplePacketBlocks (copy), searchBlockFace (copy)
    local v153 = 0;
    local v154;

    if p148 then
        v154 = p140.Static;
    else
        v154 = nil;
    end;

    if p143.OriginCount == 0 or p144.TargetPointCount == 0 then
        return RESULT_UNRESOLVED;
    end;

    local v155;

    if v154 == nil then
        v155 = nil;
    else
        v155 = v154.Proofs;
    end;

    local OriginBounds = p143.OriginBounds;
    local TargetBounds = p144.TargetBounds;
    local ProofPlane = p146.ProofPlane;
    local PreferredPlane = p146.PreferredPlane;
    local FacePrimitive = p146.FacePrimitive;
    local v156 = nil;
    local v157;

    if p149 then
        if v154 == nil then
            v157 = false;
        else
            v157 = FacePrimitive ~= nil;
        end;
    else
        v157 = p149;
    end;

    local v158;

    if p145 == PAIR_PROOF and v154 ~= nil then
        v158 = PreferredPlane ~= nil;
    else
        v158 = false;
    end;

    if v157 and p146.FaceFirst then
        if faceCovers(p140, p141, p143, p144, p146.FacePrimitive, p146.FaceAxis, p146.FaceSign) then
            local Stats = p140.Stats;
            Stats.CertificateHits = Stats.CertificateHits + 1;
            local Stats2 = p140.Stats;
            Stats2.DynamicHits = Stats2.DynamicHits + 1;

            return RESULT_HIDDEN;
        end;

        v156 = FacePrimitive;
        v157 = false;
    end;

    if v158 then
        local TargetPointCount = p144.TargetPointCount;
        local v159;

        if bit32.band(p144.Flags, ACTOR_FLAG_HULL_TAIL) == 0 then
            v159 = p144.TargetPointsOffset;
        else
            local v160 = bit32.band(p144.Flags, ACTOR_FLAG_EXTRAPOLATED) == 0 and 8 or 16;

            if v160 < TargetPointCount then
                v159 = p144.TargetPointsOffset + (TargetPointCount - v160) * VECTOR_SIZE;
                TargetPointCount = v160;
            else
                v159 = p144.TargetPointsOffset;
            end;
        end;

        if v154:ProvePlaneBuffer(p141, PreferredPlane, p143.OriginsOffset, p143.OriginCount, v159, TargetPointCount, nil) then
            local Stats = p140.Stats;
            Stats.CertificateHits = Stats.CertificateHits + 1;
            p146.FaceFirst = false;

            return RESULT_HIDDEN;
        end;
    end;

    if v157 then
        if faceCovers(p140, p141, p143, p144, p146.FacePrimitive, p146.FaceAxis, p146.FaceSign) then
            local Stats = p140.Stats;
            Stats.CertificateHits = Stats.CertificateHits + 1;
            local Stats2 = p140.Stats;
            Stats2.DynamicHits = Stats2.DynamicHits + 1;
            p146.FaceFirst = true;

            return RESULT_HIDDEN;
        end;
    else
        FacePrimitive = v156;
    end;

    if not p148 then
        return RESULT_UNRESOLVED;
    end;

    if p146.HiddenViewerPose == p150 and (p146.HiddenTargetPose == p151 and p142.CaptureTime - p146.HiddenAt <= 0.25) then
        local Stats = p140.Stats;
        Stats.PoseReplays = Stats.PoseReplays + 1;

        return RESULT_HIDDEN;
    end;

    p146.HiddenViewerPose = nil;

    if v154 ~= nil and (p140.PrimitiveCount == 0 and (p146.ClearOrigin == nil and p142.CaptureTime - p146.HiddenAt <= 0.5)) then
        local Origins = p143.Origins;
        local v161, v162 = coverageBody(p140, p144);
        local SeedScratch = p140.SeedScratch;
        table.clear(SeedScratch);

        for i = 1, p146.TriangleCount do
            SeedScratch[i] = p146.Triangles[i];
            local _ = i;
        end;

        for i = 1, p143.OriginCount do
            local v163, v164 = p140.Coverage:OriginCovered(v154, Origins[i], v161, v162, p146.CoverageTriangles[i], p152, SeedScratch);

            if v163 ~= true then
                p146.CoverageTriangles[i] = nil;
                p146.HiddenAt = (-1 / 0);

                if v163 == nil and p152 <= os.clock() then
                    return RESULT_UNRESOLVED;
                end;

                p146.CoverageRetryAfter = p140.Cycle + 4;

                return RESULT_VISIBLE;
            end;

            p146.CoverageTriangles[i] = v164;
            local _ = i;

            for _, v in v164 do
                if #SeedScratch >= 192 then
                    break;
                end;

                SeedScratch[#SeedScratch + 1] = v;
            end;
        end;

        local TargetPoints = p144.TargetPoints;

        for i = 1, p143.OriginCount do
            local v165 = p146.CoverageTriangles[i];
            local v166 = i;
            local v167 = 1;

            for i2 = 1, p144.TargetPointCount do
                local v168 = v165 == nil and 0 or v154:FirstBlockingTriangle(v165, v167, Origins[v166], TargetPoints[i2]);
                local v169;

                if v168 == 0 then
                    local v170, v171 = segmentBlocked(p140, p146, Origins[v166], TargetPoints[i2], p147);

                    if not v171 then
                        return RESULT_UNRESOLVED;
                    end;

                    if not v170 then
                        p146.HiddenAt = (-1 / 0);

                        return RESULT_VISIBLE;
                    end;

                    v169 = i2;
                else
                    v169 = i2;
                    v167 = v168;
                end;
            end;
        end;

        p146.HiddenViewerPose = p150;
        p146.HiddenTargetPose = p151;
        p146.HiddenAt = p142.CaptureTime;

        return RESULT_HIDDEN;
    end;

    local ClearOrigin = p146.ClearOrigin;
    local ClearPoint = p146.ClearPoint;

    if ClearOrigin ~= nil and (ClearPoint ~= nil and ClearOrigin < p143.OriginCount) then
        local v172 = readVector(p141, p143.OriginsOffset + ClearOrigin * VECTOR_SIZE);
        local v173;

        if ClearPoint < 0 then
            v173 = p144.Position;
        elseif ClearPoint < p144.TargetPointCount then
            v173 = readVector(p141, p144.TargetPointsOffset + ClearPoint * VECTOR_SIZE);
        else
            v173 = nil;
        end;

        if v173 ~= nil then
            local v174, v175 = segmentBlocked(p140, p146, v172, v173, p147);

            if not v175 then
                return RESULT_UNRESOLVED;
            end;

            if not v174 then
                local Stats = p140.Stats;
                Stats.ClearReplays = Stats.ClearReplays + 1;
                p146.ClearOriginWorld = v172;
                p146.ClearPointWorld = v173;
                p146.ClearTargetRoot = p144.Position;

                return RESULT_VISIBLE;
            end;
        end;

        local ClearOriginWorld = p146.ClearOriginWorld;
        local ClearPointWorld = p146.ClearPointWorld;
        local ClearTargetRoot = p146.ClearTargetRoot;

        if ClearOriginWorld ~= nil and (ClearPointWorld ~= nil and (ClearTargetRoot ~= nil and ((v172 - ClearOriginWorld).Magnitude <= 0.5 and (p144.Position - ClearTargetRoot).Magnitude <= 0.35))) then
            local v176, v177 = segmentBlocked(p140, p146, ClearOriginWorld, ClearPointWorld, p147);

            if not v177 then
                return RESULT_UNRESOLVED;
            end;

            if not v176 then
                local Stats = p140.Stats;
                Stats.ClearReplays = Stats.ClearReplays + 1;

                return RESULT_VISIBLE;
            end;
        end;

        p146.ClearOrigin = nil;
        p146.ClearPoint = nil;
        p146.ClearOriginWorld = nil;
        p146.ClearPointWorld = nil;
        p146.ClearTargetRoot = nil;
    end;

    if p140.Cycle < (p146.CoverageRetryAfter or 0) then
        return RESULT_VISIBLE;
    end;

    if v155 ~= nil and (OriginBounds ~= nil and (TargetBounds ~= nil and (ProofPlane ~= nil and v155:Covers(ProofPlane, OriginBounds, TargetBounds, p152)))) then
        local Stats = p140.Stats;
        Stats.CertificateHits = Stats.CertificateHits + 1;

        return RESULT_HIDDEN;
    end;

    local v178 = p143.Origins[1];
    local v179, v180 = segmentBlocked(p140, p146, v178, p144.Position, p147);

    if not v180 then
        return RESULT_UNRESOLVED;
    end;

    if not v179 then
        p146.ClearOrigin = 0;
        p146.ClearPoint = -1;
        p146.ClearOriginWorld = v178;
        p146.ClearPointWorld = p144.Position;
        p146.ClearTargetRoot = p144.Position;

        return RESULT_VISIBLE;
    end;

    if v155 ~= nil and (OriginBounds ~= nil and (TargetBounds ~= nil and p140.Cycle >= (p146.ProofSearchAfter or 0))) then
        p146.ProofSearchAfter = p140.Cycle + 4;
        local Stats = p140.Stats;
        Stats.CertificateSearches = Stats.CertificateSearches + 1;
        table.clear(p146.ProofCandidates);
        local v181 = v155:Search(OriginBounds, TargetBounds, p146.Triangles, p146.TriangleCount, ProofPlane, p152, p146.ProofCandidates);

        if v181 ~= nil then
            p146.ProofPlane = v181;
            local Stats2 = p140.Stats;
            Stats2.CertificateFound = Stats2.CertificateFound + 1;

            return RESULT_HIDDEN;
        end;
    end;

    local OriginCount = p143.OriginCount;
    local TargetPointCount = p144.TargetPointCount;
    local Origins = p143.Origins;
    local TargetPoints = p144.TargetPoints;
    local ProvenScratch = p140.ProvenScratch;
    table.clear(ProvenScratch);
    local v182 = 0;

    for i = 0, OriginCount - 1 do
        if p152 <= os.clock() then
            local Stats = p140.Stats;
            Stats.Segments = Stats.Segments + v153;
            local Stats2 = p140.Stats;
            Stats2.BlockerHits = Stats2.BlockerHits + v153;

            return RESULT_UNRESOLVED;
        end;

        local v183 = Origins[i + 1];
        local v184, v185, v186, v187, v188, v189, v190, v191, v192, v193, v194, v195, v196;

        if v155 == nil or (TargetBounds == nil or p140.Cycle < (p146.OriginProofRetry[i + 1] or 0)) then
            v184 = i;

            for i2 = 0, TargetPointCount - 1 do
                if v182 >= 32 then
                    if p152 <= os.clock() then
                        v185 = p140.Stats;
                        v185.Segments = v185.Segments + v153;
                        v186 = p140.Stats;
                        v186.BlockerHits = v186.BlockerHits + v153;

                        return RESULT_UNRESOLVED;
                    end;

                    v182 = 0;
                end;

                v182 = v182 + 1;
                v187 = TargetPoints[i2 + 1];
                v188 = v184 * VisibilityCycleCodec.MAX_TARGET_POINTS + i2 + 1;
                v189 = p146.SampleHints[v188];

                if v189 and (v154 and (p140.PrimitiveCount == 0 and samplePacketBlocks(v189, v183, v187))) then
                    v153 = v153 + 1;
                    v190 = true;
                    v191 = true;
                else
                    v191, v190 = segmentBlocked(p140, p146, v183, v187, p147);

                    if v191 and (v154 ~= nil and (p140.PrimitiveCount == 0 and p146.TriangleCount > 0)) then
                        p146.SampleHints[v188] = v154:SamplePacket(p146.Triangles[p146.TriangleCount]);
                    else
                        p146.SampleHints[v188] = nil;
                    end;
                end;

                if not v190 then
                    v192 = p140.Stats;
                    v192.Segments = v192.Segments + v153;
                    v193 = p140.Stats;
                    v193.BlockerHits = v193.BlockerHits + v153;

                    return RESULT_UNRESOLVED;
                end;

                if not v191 then
                    p146.ClearOrigin = v184;
                    p146.ClearPoint = i2;
                    p146.ClearOriginWorld = v183;
                    p146.ClearPointWorld = v187;
                    p146.ClearTargetRoot = p144.Position;
                    v194 = p140.Stats;
                    v194.Segments = v194.Segments + v153;
                    v195 = p140.Stats;
                    v195.BlockerHits = v195.BlockerHits + v153;

                    return RESULT_VISIBLE;
                end;

                v196 = i2;
            end;
        else
            local v197 = v155:CoversOrigin(v183, TargetBounds, p146.ProofCandidates, p146.OriginProofs[i + 1], p152);

            if v197 == nil then
                p146.OriginProofRetry[i + 1] = p140.Cycle + 8;
                v184 = i;

                for i2 = 0, TargetPointCount - 1 do
                    if v182 >= 32 then
                        if p152 <= os.clock() then
                            v185 = p140.Stats;
                            v185.Segments = v185.Segments + v153;
                            v186 = p140.Stats;
                            v186.BlockerHits = v186.BlockerHits + v153;

                            return RESULT_UNRESOLVED;
                        end;

                        v182 = 0;
                    end;

                    v182 = v182 + 1;
                    v187 = TargetPoints[i2 + 1];
                    v188 = v184 * VisibilityCycleCodec.MAX_TARGET_POINTS + i2 + 1;
                    v189 = p146.SampleHints[v188];

                    if v189 and (v154 and (p140.PrimitiveCount == 0 and samplePacketBlocks(v189, v183, v187))) then
                        v153 = v153 + 1;
                        v190 = true;
                        v191 = true;
                    else
                        v191, v190 = segmentBlocked(p140, p146, v183, v187, p147);

                        if v191 and (v154 ~= nil and (p140.PrimitiveCount == 0 and p146.TriangleCount > 0)) then
                            p146.SampleHints[v188] = v154:SamplePacket(p146.Triangles[p146.TriangleCount]);
                        else
                            p146.SampleHints[v188] = nil;
                        end;
                    end;

                    if not v190 then
                        v192 = p140.Stats;
                        v192.Segments = v192.Segments + v153;
                        v193 = p140.Stats;
                        v193.BlockerHits = v193.BlockerHits + v153;

                        return RESULT_UNRESOLVED;
                    end;

                    if not v191 then
                        p146.ClearOrigin = v184;
                        p146.ClearPoint = i2;
                        p146.ClearOriginWorld = v183;
                        p146.ClearPointWorld = v187;
                        p146.ClearTargetRoot = p144.Position;
                        v194 = p140.Stats;
                        v194.Segments = v194.Segments + v153;
                        v195 = p140.Stats;
                        v195.BlockerHits = v195.BlockerHits + v153;

                        return RESULT_VISIBLE;
                    end;

                    v196 = i2;
                end;
            end;

            p146.OriginProofs[i + 1] = v197;
            local Stats = p140.Stats;
            Stats.PartialProofs = Stats.PartialProofs + 1;
            ProvenScratch[i + 1] = true;
            v184 = i;
        end;
    end;

    if v154 ~= nil and p140.PrimitiveCount == 0 then
        local v198, v199 = coverageBody(p140, p144);
        local Coverage = p140.Coverage;
        local SeedScratch = p140.SeedScratch;
        table.clear(SeedScratch);

        for i = 1, p146.TriangleCount do
            SeedScratch[i] = p146.Triangles[i];
            local _ = i;
        end;

        for i = 0, OriginCount - 1 do
            local v200;

            if ProvenScratch[i + 1] then
                v200 = i;
            else
                local v201, v202 = Coverage:OriginCovered(v154, Origins[i + 1], v198, v199, p146.CoverageTriangles[i + 1], p152, SeedScratch);

                if v201 ~= true then
                    p146.CoverageTriangles[i + 1] = nil;
                    local Stats = p140.Stats;
                    Stats.Segments = Stats.Segments + v153;
                    local Stats2 = p140.Stats;
                    Stats2.BlockerHits = Stats2.BlockerHits + v153;

                    if v201 == nil and p152 <= os.clock() then
                        return RESULT_UNRESOLVED;
                    end;

                    p146.CoverageRetryAfter = p140.Cycle + 4;

                    return RESULT_VISIBLE;
                end;

                p146.CoverageTriangles[i + 1] = v202;
                v200 = i;

                for _, v in v202 do
                    if #SeedScratch >= 192 then
                        break;
                    end;

                    SeedScratch[#SeedScratch + 1] = v;
                end;
            end;
        end;
    end;

    if p145 == PAIR_PROOF and (v154 ~= nil and (v154.Data.certificateCount > 0 and (p140.SearchBudget > 0 and (p140.Cycle >= p146.SearchAfterCycle and (p143.CellCount > 0 and p144.CellCount > 0))))) then
        p140.SearchBudget = p140.SearchBudget - 1;
        local Stats = p140.Stats;
        Stats.CertificateSearches = Stats.CertificateSearches + 1;
        p146.SearchAfterCycle = p140.Cycle + p140.SearchRetryCycles;
        local TargetPointCount2 = p144.TargetPointCount;
        local v203;

        if bit32.band(p144.Flags, ACTOR_FLAG_HULL_TAIL) == 0 then
            v203 = p144.TargetPointsOffset;
        else
            local v204 = bit32.band(p144.Flags, ACTOR_FLAG_EXTRAPOLATED) == 0 and 8 or 16;

            if v204 < TargetPointCount2 then
                v203 = p144.TargetPointsOffset + (TargetPointCount2 - v204) * VECTOR_SIZE;
                TargetPointCount2 = v204;
            else
                v203 = p144.TargetPointsOffset;
            end;
        end;

        local v205, v206 = v154:ProveProjectedOccludedForCellBuffer(p141, p143.CellsOffset, p143.CellCount, p144.CellsOffset, p144.CellCount, p143.OriginsOffset, p143.OriginCount, v203, TargetPointCount2, PreferredPlane, nil, p140.SearchPlanes);

        if v205 and v206 ~= nil then
            p146.PreferredPlane = v206;
            local Stats2 = p140.Stats;
            Stats2.CertificateFound = Stats2.CertificateFound + 1;
            local Stats3 = p140.Stats;
            Stats3.Segments = Stats3.Segments + v153;
            local Stats4 = p140.Stats;
            Stats4.BlockerHits = Stats4.BlockerHits + v153;

            return RESULT_HIDDEN;
        end;
    end;

    if p149 and (v154 ~= nil and (p140.FaceTestBudget > 0 and p140.Cycle >= p146.FaceSearchAfterCycle)) then
        if searchBlockFace(p140, p141, p143, p144, p146, FacePrimitive, p146.FaceAxis, p146.FaceSign) then
            local Stats = p140.Stats;
            Stats.DynamicFound = Stats.DynamicFound + 1;
            p146.FaceFirst = true;
        else
            p146.FaceSearchAfterCycle = p140.Cycle + p140.FaceRetryCycles;
        end;
    end;

    p146.HiddenViewerPose = p150;
    p146.HiddenTargetPose = p151;
    p146.HiddenAt = p142.CaptureTime;
    local Stats = p140.Stats;
    Stats.Segments = Stats.Segments + v153;
    local Stats2 = p140.Stats;
    Stats2.BlockerHits = Stats2.BlockerHits + v153;

    return RESULT_HIDDEN;
end;

function u1.FaceCertified(p207: any, p208: buffer, p209: number, p210: number) -- Line: 1070
    -- upvalues: VisibilityCycleCodec (copy), cachedFaceCovers (copy)
    local v211 = p207.Cache[p209];
    local v212;

    if v211 == nil then
        v212 = nil;
    else
        v212 = v211[p210];
    end;

    if v212 == nil or v212.FacePrimitive == nil then
        return false;
    end;

    local v213 = nil;
    local v214 = nil;

    for i = 1, VisibilityCycleCodec.readCaptureHeader(p208).ActorCount do
        local v215 = VisibilityCycleCodec.readActor(p208, i);
        local v216;

        if v215.ActorId == p209 then
            v213 = v215;
            v216 = i;
        elseif v215.ActorId == p210 then
            v214 = v215;
            v216 = i;
        else
            v216 = i;
        end;
    end;

    if v213 == nil or v214 == nil then
        return false;
    end;

    return cachedFaceCovers(p207, p208, v213, v214, v212);
end;

function u1.Solve(p217: any, u218: buffer, p219: number, p220: number, p221: function?, p222: number?) -- Line: 1098
    -- upvalues: VisibilityCycleCodec (copy), readVector (copy), VECTOR_SIZE (copy), OcclusionMath (copy), pruneCache (copy), FLAG_DYNAMIC_CERTIFICATES (copy), PAIR_SKIP (copy), RESULT_SKIPPED (copy), RESULT_UNRESOLVED (copy), pairCache (copy), evaluatePair (copy), RESULT_HIDDEN (copy), RESULT_VISIBLE (copy)
    local os_clock_ret = os.clock();
    local v223 = VisibilityCycleCodec.readCaptureHeader(u218);
    local ActorCount = v223.ActorCount;
    local v224 = os_clock_ret + math.max(v223.CycleBudgetSeconds, 0.0005);
    p217.Deadline = v224;
    local v225 = VisibilityCycleCodec.createResult(ActorCount, p219, v223.Sequence, v223.CaptureTime, v223.Generation, 0);
    local Stats = p217.Stats;

    for i in Stats do
        Stats[i] = 0;
    end;

    p217.Cycle = p217.Cycle + 1;
    p217.SearchBudget = p217.SearchBudgetPerCycle;
    p217.FaceTestBudget = p217.FaceTestBudgetPerCycle;
    local table_create_ret = table.create(ActorCount);
    local table_create_ret2 = table.create(ActorCount);
    local v226 = {};

    for i = 1, ActorCount do
        local v227 = VisibilityCycleCodec.readActor(u218, i);

        local function decodePoints(p228: number, p229: number, p230: vector?) -- Line: 1132
            -- upvalues: readVector (ref), u218 (copy), VECTOR_SIZE (ref), OcclusionMath (ref)
            local table_create_ret3 = table.create(p229);
            local v231 = p230 or Vector3.new(inf, inf, inf);
            local v232 = p230 or Vector3.new(-inf, -inf, -inf);
            local v233 = true;

            for i2 = 0, p229 - 1 do
                local v234 = readVector(u218, p228 + i2 * VECTOR_SIZE);
                table_create_ret3[i2 + 1] = v234;

                if not OcclusionMath.isFiniteVector(v234) then
                    v233 = false;
                end;

                v231 = v231:Min(v234);
                v232 = v232:Max(v234);
                local _ = i2;
            end;

            if v233 and (OcclusionMath.isFiniteVector(v231) and OcclusionMath.isFiniteVector(v232)) then
                return table_create_ret3, {
                    v231.X,
                    v231.Y,
                    v231.Z,
                    v232.X,
                    v232.Y,
                    v232.Z
                };
            end;

            return table_create_ret3, nil;
        end;

        local v235, v236 = decodePoints(v227.OriginsOffset, v227.OriginCount, nil);
        v227.Origins = v235;
        v227.OriginBounds = v236;
        local v237, v238 = decodePoints(v227.TargetPointsOffset, v227.TargetPointCount, v227.Position);
        v227.TargetPoints = v237;
        v227.TargetBounds = v238;
        table_create_ret[i] = v227;
        v226[v227.ActorId] = true;
        table_create_ret2[i] = buffer.readstring(u218, v227.OriginsOffset, v227.OriginCount * VECTOR_SIZE) .. buffer.readstring(u218, v227.TargetPointsOffset, v227.TargetPointCount * VECTOR_SIZE);
        local _ = i;
    end;

    if p217.Cycle % 64 == 0 then
        pruneCache(p217, v226);
    end;

    local v239 = bit32.band(v223.Flags, VisibilityCycleCodec.FLAG_STATIC) ~= 0;
    local v240 = bit32.band(v223.Flags, FLAG_DYNAMIC_CERTIFICATES) ~= 0;
    local PairKindOffset = v223.PairKindOffset;
    local v241 = VisibilityCycleCodec.resultRowsOffset();
    local v242 = VisibilityCycleCodec.resultMatrixOffset(ActorCount);
    local v243 = ActorCount <= 0 and 0 or v223.Sequence % ActorCount;
    local v244 = false;

    for i = 0, ActorCount - 1 do
        local v245 = (i + v243) % ActorCount + 1;
        local v246 = table_create_ret[v245];
        local v247;

        if v246.ActorId % p220 == p219 - 1 then
            buffer.writeu8(v225, v241 + v245 - 1, 1);
            local v248 = v242 + (v245 - 1) * ActorCount;
            v247 = i;

            for i2 = 1, ActorCount do
                local buffer_readu8_ret = buffer.readu8(u218, PairKindOffset + (v245 - 1) * ActorCount + (i2 - 1));
                local v249;

                if buffer_readu8_ret == PAIR_SKIP or i2 == v245 then
                    Stats.Skipped = Stats.Skipped + 1;
                    buffer.writeu8(v225, v248 + i2 - 1, RESULT_SKIPPED);
                    v249 = i2;
                else
                    Stats.Pairs = Stats.Pairs + 1;

                    if v244 or v224 <= os.clock() then
                        Stats.Unresolved = Stats.Unresolved + 1;
                        buffer.writeu8(v225, v248 + i2 - 1, RESULT_UNRESOLVED);
                        v249 = i2;
                        v244 = true;
                    else
                        local v250 = table_create_ret[i2];
                        local v251 = evaluatePair(p217, u218, v223, v246, v250, buffer_readu8_ret, pairCache(p217, v246.ActorId, v250.ActorId), p221, v239, v240, table_create_ret2[v245], table_create_ret2[i2], v224);

                        if v251 == RESULT_HIDDEN then
                            Stats.Hidden = Stats.Hidden + 1;
                        elseif v251 == RESULT_VISIBLE then
                            Stats.Visible = Stats.Visible + 1;
                        else
                            Stats.Unresolved = Stats.Unresolved + 1;
                            v244 = v224 <= os.clock() and true or v244;
                        end;

                        buffer.writeu8(v225, v248 + i2 - 1, v251);
                        v249 = i2;
                    end;
                end;
            end;
        else
            v247 = i;
        end;
    end;

    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_PAIRS, Stats.Pairs);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_HIDDEN, Stats.Hidden);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_VISIBLE, Stats.Visible);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_UNRESOLVED, Stats.Unresolved);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_SKIPPED, Stats.Skipped);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_CERTIFICATE_HITS, Stats.CertificateHits);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_CLEAR_REPLAYS, Stats.ClearReplays);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_DYNAMIC_HITS, Stats.DynamicHits);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_DYNAMIC_FOUND, Stats.DynamicFound);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_POSE_REPLAYS, Stats.PoseReplays);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_CERTIFICATE_SEARCHES, Stats.CertificateSearches);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_CERTIFICATE_FOUND, Stats.CertificateFound);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_SEGMENTS, Stats.Segments);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_BLOCKER_HITS, Stats.BlockerHits);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_BVH_QUERIES, Stats.BVHQueries);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_BVH_HITS, Stats.BVHHits);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_FALLBACK_RAYS, Stats.FallbackRays);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_DEADLINE, v244 and 1 or 0);
    VisibilityCycleCodec.writeStat(v225, VisibilityCycleCodec.STAT_MICROSECONDS, ((p222 or os.clock()) - os_clock_ret) * 1000000);

    return v225;
end;

return table.freeze(u1);