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

local function coverageBlocks(p78: any, p79: table?, p80: vector, p81: vector) -- Line: 509
    if p79 == nil then
        return false;
    end;

    for _, v in p79 do
        if p78:TriangleBlocksSegment(v, p80, p81) then
            return true;
        end;
    end;

    return false;
end;

local function proofRange(p82) -- Line: 527
    -- upvalues: ACTOR_FLAG_HULL_TAIL (copy), ACTOR_FLAG_EXTRAPOLATED (copy), VECTOR_SIZE (copy)
    local TargetPointCount = p82.TargetPointCount;

    if bit32.band(p82.Flags, ACTOR_FLAG_HULL_TAIL) ~= 0 then
        local v83 = bit32.band(p82.Flags, ACTOR_FLAG_EXTRAPOLATED) == 0 and 8 or 16;

        if v83 < TargetPointCount then
            return p82.TargetPointsOffset + (TargetPointCount - v83) * VECTOR_SIZE, v83;
        end;
    end;

    return p82.TargetPointsOffset, TargetPointCount;
end;

local function faceCovers(p84: any, p85: buffer, p86: any, p87: any, p88: number, p89: number, p90: number) -- Line: 538
    -- upvalues: primitiveFace (copy), ACTOR_FLAG_HULL_TAIL (copy), ACTOR_FLAG_EXTRAPOLATED (copy), VECTOR_SIZE (copy)
    local Primitives = p84.Primitives;
    local Static = p84.Static;

    if Primitives == nil or (Static == nil or (p88 < 1 or p84.PrimitiveCount < p88)) then
        return false;
    end;

    local v91, v92, v93, v94, v95, v96 = primitiveFace(Primitives, p88, p89, p90);
    local TargetPointCount = p87.TargetPointCount;
    local v97;

    if bit32.band(p87.Flags, ACTOR_FLAG_HULL_TAIL) == 0 then
        v97 = p87.TargetPointsOffset;
    else
        local v98 = bit32.band(p87.Flags, ACTOR_FLAG_EXTRAPOLATED) == 0 and 8 or 16;

        if v98 < TargetPointCount then
            v97 = p87.TargetPointsOffset + (TargetPointCount - v98) * VECTOR_SIZE;
            TargetPointCount = v98;
        else
            v97 = p87.TargetPointsOffset;
        end;
    end;

    return Static:ProveRectangleBuffer(p85, v91, v92, v93, v94, v95, v96, p86.OriginsOffset, p86.OriginCount, v97, TargetPointCount);
end;

local function cachedFaceCovers(p99: any, p100: buffer, p101: any, p102: any, p103: table) -- Line: 569
    -- upvalues: faceCovers (copy)
    return faceCovers(p99, p100, p101, p102, p103.FacePrimitive, p103.FaceAxis, p103.FaceSign);
end;

local function searchBlockFace(p104: any, p105: buffer, p106: any, p107: any, p108: table, p109: number?, p110: number?, p111: number?) -- Line: 588
    -- upvalues: readVector (copy), PRIMITIVE_SIZE (copy), VisibilityCycleCodec (copy), faceCovers (copy)
    local Primitives = p104.Primitives;

    if Primitives == nil then
        return false;
    end;

    local v112 = readVector(p105, p106.OriginsOffset);
    local Blockers = p108.Blockers;
    local v113 = 0;

    for i = p108.BlockerCount, 1, -1 do
        local v114 = Blockers[i];
        local v115;

        if buffer.readu8(Primitives, (v114 - 1) * PRIMITIVE_SIZE) == VisibilityCycleCodec.PRIMITIVE_KIND_BLOCK then
            local v116 = (v114 - 1) * PRIMITIVE_SIZE;
            local v117 = v112.X - buffer.readf32(Primitives, v116 + 4);
            local v118 = v112.Y - buffer.readf32(Primitives, v116 + 8);
            local v119 = v112.Z - buffer.readf32(Primitives, v116 + 12);
            v115 = i;

            for i2 = 0, 2 do
                local v120 = v116 + 16 + i2 * 4;
                local v121 = buffer.readf32(Primitives, v120) * v117 + buffer.readf32(Primitives, v120 + 12) * v118 + buffer.readf32(Primitives, v120 + 24) * v119;
                local buffer_readf32_ret = buffer.readf32(Primitives, v116 + 52 + i2 * 4);
                local v122 = buffer_readf32_ret < v121 and 1 or (v121 < -buffer_readf32_ret and -1 or 0);
                local v123;

                if v122 == 0 or v114 == p109 and (i2 == p110 and v122 == p111) then
                    v123 = i2;
                else
                    if v113 >= 12 or p104.FaceTestBudget <= 0 then
                        return false;
                    end;

                    v113 = v113 + 1;
                    p104.FaceTestBudget = p104.FaceTestBudget - 1;

                    if faceCovers(p104, p105, p106, p107, v114, i2, v122) then
                        p108.FacePrimitive = v114;
                        p108.FaceAxis = i2;
                        p108.FaceSign = v122;

                        return true;
                    end;

                    v123 = i2;
                end;
            end;
        else
            v115 = i;
        end;
    end;

    return false;
end;

local function samplePacketBlocks(p124: any, p125: vector, p126: vector) -- Line: 641
    local v127 = p126 - p125;

    if v127:Dot(v127) <= 1e-7 then
        return false;
    end;

    local v128 = p124[2];
    local v129 = p124[3];
    local v130 = v127:Cross(v129);
    local v131 = v128:Dot(v130);

    if math.abs(v131) <= 1e-7 then
        return false;
    end;

    local v132 = 1 / v131;
    local v133 = p125 - p124[1];
    local v134 = v133:Dot(v130) * v132;

    if v134 < -1e-7 or v134 > 1.0000001 then
        return false;
    end;

    local v135 = v133:Cross(v128);
    local v136 = v127:Dot(v135) * v132;

    if v136 < -1e-7 or v134 + v136 > 1.0000001 then
        return false;
    end;

    local v137 = v129:Dot(v135) * v132;
    local v138;

    if v137 >= 1e-7 then
        v138 = v137 <= 0.9999999;
    else
        v138 = false;
    end;

    return v138;
end;

local function evaluatePair(p139: any, p140: buffer, p141: any, p142: any, p143: any, p144: number, p145: table, p146: function?, p147: boolean, p148: boolean, p149: string, p150: string, p151: number) -- Line: 673
    -- upvalues: RESULT_UNRESOLVED (copy), PAIR_PROOF (copy), faceCovers (copy), RESULT_HIDDEN (copy), ACTOR_FLAG_HULL_TAIL (copy), ACTOR_FLAG_EXTRAPOLATED (copy), VECTOR_SIZE (copy), coverageBody (copy), RESULT_VISIBLE (copy), coverageBlocks (copy), segmentBlocked (copy), readVector (copy), VisibilityCycleCodec (copy), samplePacketBlocks (copy), searchBlockFace (copy)
    local v152 = 0;
    local v153;

    if p147 then
        v153 = p139.Static;
    else
        v153 = nil;
    end;

    if p142.OriginCount == 0 or p143.TargetPointCount == 0 then
        return RESULT_UNRESOLVED;
    end;

    local v154;

    if v153 == nil then
        v154 = nil;
    else
        v154 = v153.Proofs;
    end;

    local OriginBounds = p142.OriginBounds;
    local TargetBounds = p143.TargetBounds;
    local ProofPlane = p145.ProofPlane;
    local PreferredPlane = p145.PreferredPlane;
    local FacePrimitive = p145.FacePrimitive;
    local v155 = nil;
    local v156;

    if p148 then
        if v153 == nil then
            v156 = false;
        else
            v156 = FacePrimitive ~= nil;
        end;
    else
        v156 = p148;
    end;

    local v157;

    if p144 == PAIR_PROOF and v153 ~= nil then
        v157 = PreferredPlane ~= nil;
    else
        v157 = false;
    end;

    if v156 and p145.FaceFirst then
        if faceCovers(p139, p140, p142, p143, p145.FacePrimitive, p145.FaceAxis, p145.FaceSign) then
            local Stats = p139.Stats;
            Stats.CertificateHits = Stats.CertificateHits + 1;
            local Stats2 = p139.Stats;
            Stats2.DynamicHits = Stats2.DynamicHits + 1;

            return RESULT_HIDDEN;
        end;

        v155 = FacePrimitive;
        v156 = false;
    end;

    if v157 then
        local TargetPointCount = p143.TargetPointCount;
        local v158;

        if bit32.band(p143.Flags, ACTOR_FLAG_HULL_TAIL) == 0 then
            v158 = p143.TargetPointsOffset;
        else
            local v159 = bit32.band(p143.Flags, ACTOR_FLAG_EXTRAPOLATED) == 0 and 8 or 16;

            if v159 < TargetPointCount then
                v158 = p143.TargetPointsOffset + (TargetPointCount - v159) * VECTOR_SIZE;
                TargetPointCount = v159;
            else
                v158 = p143.TargetPointsOffset;
            end;
        end;

        if v153:ProvePlaneBuffer(p140, PreferredPlane, p142.OriginsOffset, p142.OriginCount, v158, TargetPointCount, nil) then
            local Stats = p139.Stats;
            Stats.CertificateHits = Stats.CertificateHits + 1;
            p145.FaceFirst = false;

            return RESULT_HIDDEN;
        end;
    end;

    if v156 then
        if faceCovers(p139, p140, p142, p143, p145.FacePrimitive, p145.FaceAxis, p145.FaceSign) then
            local Stats = p139.Stats;
            Stats.CertificateHits = Stats.CertificateHits + 1;
            local Stats2 = p139.Stats;
            Stats2.DynamicHits = Stats2.DynamicHits + 1;
            p145.FaceFirst = true;

            return RESULT_HIDDEN;
        end;
    else
        FacePrimitive = v155;
    end;

    if not p147 then
        return RESULT_UNRESOLVED;
    end;

    if p145.HiddenViewerPose == p149 and (p145.HiddenTargetPose == p150 and p141.CaptureTime - p145.HiddenAt <= 0.25) then
        local Stats = p139.Stats;
        Stats.PoseReplays = Stats.PoseReplays + 1;

        return RESULT_HIDDEN;
    end;

    p145.HiddenViewerPose = nil;

    if v153 ~= nil and (p139.PrimitiveCount == 0 and (p145.ClearOrigin == nil and p141.CaptureTime - p145.HiddenAt <= 0.5)) then
        local Origins = p142.Origins;
        local v160, v161 = coverageBody(p139, p143);
        local SeedScratch = p139.SeedScratch;
        table.clear(SeedScratch);

        for i = 1, p145.TriangleCount do
            SeedScratch[i] = p145.Triangles[i];
            local _ = i;
        end;

        for i = 1, p142.OriginCount do
            local v162, v163 = p139.Coverage:OriginCovered(v153, Origins[i], v160, v161, p145.CoverageTriangles[i], p151, SeedScratch);

            if v162 ~= true then
                p145.CoverageTriangles[i] = nil;
                p145.HiddenAt = (-1 / 0);

                if v162 == nil and p151 <= os.clock() then
                    return RESULT_UNRESOLVED;
                end;

                p145.CoverageRetryAfter = p139.Cycle + 4;

                return RESULT_VISIBLE;
            end;

            p145.CoverageTriangles[i] = v163;
            local _ = i;

            for _, v in v163 do
                if #SeedScratch >= 192 then
                    break;
                end;

                SeedScratch[#SeedScratch + 1] = v;
            end;
        end;

        local TargetPoints = p143.TargetPoints;

        for i = 1, p142.OriginCount do
            local v164 = p145.CoverageTriangles[i];
            local v165 = i;

            for i2 = 1, p143.TargetPointCount do
                local v166;

                if coverageBlocks(v153, v164, Origins[v165], TargetPoints[i2]) then
                    v166 = i2;
                else
                    local v167, v168 = segmentBlocked(p139, p145, Origins[v165], TargetPoints[i2], p146);

                    if not v168 then
                        return RESULT_UNRESOLVED;
                    end;

                    if not v167 then
                        p145.HiddenAt = (-1 / 0);

                        return RESULT_VISIBLE;
                    end;

                    v166 = i2;
                end;
            end;
        end;

        p145.HiddenViewerPose = p149;
        p145.HiddenTargetPose = p150;
        p145.HiddenAt = p141.CaptureTime;

        return RESULT_HIDDEN;
    end;

    local ClearOrigin = p145.ClearOrigin;
    local ClearPoint = p145.ClearPoint;

    if ClearOrigin ~= nil and (ClearPoint ~= nil and ClearOrigin < p142.OriginCount) then
        local v169 = readVector(p140, p142.OriginsOffset + ClearOrigin * VECTOR_SIZE);
        local v170;

        if ClearPoint < 0 then
            v170 = p143.Position;
        elseif ClearPoint < p143.TargetPointCount then
            v170 = readVector(p140, p143.TargetPointsOffset + ClearPoint * VECTOR_SIZE);
        else
            v170 = nil;
        end;

        if v170 ~= nil then
            local v171, v172 = segmentBlocked(p139, p145, v169, v170, p146);

            if not v172 then
                return RESULT_UNRESOLVED;
            end;

            if not v171 then
                local Stats = p139.Stats;
                Stats.ClearReplays = Stats.ClearReplays + 1;
                p145.ClearOriginWorld = v169;
                p145.ClearPointWorld = v170;
                p145.ClearTargetRoot = p143.Position;

                return RESULT_VISIBLE;
            end;
        end;

        local ClearOriginWorld = p145.ClearOriginWorld;
        local ClearPointWorld = p145.ClearPointWorld;
        local ClearTargetRoot = p145.ClearTargetRoot;

        if ClearOriginWorld ~= nil and (ClearPointWorld ~= nil and (ClearTargetRoot ~= nil and ((v169 - ClearOriginWorld).Magnitude <= 0.5 and (p143.Position - ClearTargetRoot).Magnitude <= 0.35))) then
            local v173, v174 = segmentBlocked(p139, p145, ClearOriginWorld, ClearPointWorld, p146);

            if not v174 then
                return RESULT_UNRESOLVED;
            end;

            if not v173 then
                local Stats = p139.Stats;
                Stats.ClearReplays = Stats.ClearReplays + 1;

                return RESULT_VISIBLE;
            end;
        end;

        p145.ClearOrigin = nil;
        p145.ClearPoint = nil;
        p145.ClearOriginWorld = nil;
        p145.ClearPointWorld = nil;
        p145.ClearTargetRoot = nil;
    end;

    if p139.Cycle < (p145.CoverageRetryAfter or 0) then
        return RESULT_VISIBLE;
    end;

    if v154 ~= nil and (OriginBounds ~= nil and (TargetBounds ~= nil and (ProofPlane ~= nil and v154:Covers(ProofPlane, OriginBounds, TargetBounds, p151)))) then
        local Stats = p139.Stats;
        Stats.CertificateHits = Stats.CertificateHits + 1;

        return RESULT_HIDDEN;
    end;

    local v175 = p142.Origins[1];
    local v176, v177 = segmentBlocked(p139, p145, v175, p143.Position, p146);

    if not v177 then
        return RESULT_UNRESOLVED;
    end;

    if not v176 then
        p145.ClearOrigin = 0;
        p145.ClearPoint = -1;
        p145.ClearOriginWorld = v175;
        p145.ClearPointWorld = p143.Position;
        p145.ClearTargetRoot = p143.Position;

        return RESULT_VISIBLE;
    end;

    if v154 ~= nil and (OriginBounds ~= nil and (TargetBounds ~= nil and p139.Cycle >= (p145.ProofSearchAfter or 0))) then
        p145.ProofSearchAfter = p139.Cycle + 4;
        local Stats = p139.Stats;
        Stats.CertificateSearches = Stats.CertificateSearches + 1;
        table.clear(p145.ProofCandidates);
        local v178 = v154:Search(OriginBounds, TargetBounds, p145.Triangles, p145.TriangleCount, ProofPlane, p151, p145.ProofCandidates);

        if v178 ~= nil then
            p145.ProofPlane = v178;
            local Stats2 = p139.Stats;
            Stats2.CertificateFound = Stats2.CertificateFound + 1;

            return RESULT_HIDDEN;
        end;
    end;

    local OriginCount = p142.OriginCount;
    local TargetPointCount = p143.TargetPointCount;
    local Origins = p142.Origins;
    local TargetPoints = p143.TargetPoints;
    local ProvenScratch = p139.ProvenScratch;
    table.clear(ProvenScratch);
    local v179 = 0;

    for i = 0, OriginCount - 1 do
        if p151 <= os.clock() then
            local Stats = p139.Stats;
            Stats.Segments = Stats.Segments + v152;
            local Stats2 = p139.Stats;
            Stats2.BlockerHits = Stats2.BlockerHits + v152;

            return RESULT_UNRESOLVED;
        end;

        local v180 = Origins[i + 1];
        local v181, v182, v183, v184, v185, v186, v187, v188, v189, v190, v191, v192, v193;

        if v154 == nil or (TargetBounds == nil or p139.Cycle < (p145.OriginProofRetry[i + 1] or 0)) then
            v181 = i;

            for i2 = 0, TargetPointCount - 1 do
                if v179 >= 32 then
                    if p151 <= os.clock() then
                        v182 = p139.Stats;
                        v182.Segments = v182.Segments + v152;
                        v183 = p139.Stats;
                        v183.BlockerHits = v183.BlockerHits + v152;

                        return RESULT_UNRESOLVED;
                    end;

                    v179 = 0;
                end;

                v179 = v179 + 1;
                v184 = TargetPoints[i2 + 1];
                v185 = v181 * VisibilityCycleCodec.MAX_TARGET_POINTS + i2 + 1;
                v186 = p145.SampleHints[v185];

                if v186 and (v153 and (p139.PrimitiveCount == 0 and samplePacketBlocks(v186, v180, v184))) then
                    v152 = v152 + 1;
                    v187 = true;
                    v188 = true;
                else
                    v188, v187 = segmentBlocked(p139, p145, v180, v184, p146);

                    if v188 and (v153 ~= nil and (p139.PrimitiveCount == 0 and p145.TriangleCount > 0)) then
                        p145.SampleHints[v185] = v153:SamplePacket(p145.Triangles[p145.TriangleCount]);
                    else
                        p145.SampleHints[v185] = nil;
                    end;
                end;

                if not v187 then
                    v189 = p139.Stats;
                    v189.Segments = v189.Segments + v152;
                    v190 = p139.Stats;
                    v190.BlockerHits = v190.BlockerHits + v152;

                    return RESULT_UNRESOLVED;
                end;

                if not v188 then
                    p145.ClearOrigin = v181;
                    p145.ClearPoint = i2;
                    p145.ClearOriginWorld = v180;
                    p145.ClearPointWorld = v184;
                    p145.ClearTargetRoot = p143.Position;
                    v191 = p139.Stats;
                    v191.Segments = v191.Segments + v152;
                    v192 = p139.Stats;
                    v192.BlockerHits = v192.BlockerHits + v152;

                    return RESULT_VISIBLE;
                end;

                v193 = i2;
            end;
        else
            local v194 = v154:CoversOrigin(v180, TargetBounds, p145.ProofCandidates, p145.OriginProofs[i + 1], p151);

            if v194 == nil then
                p145.OriginProofRetry[i + 1] = p139.Cycle + 8;
                v181 = i;

                for i2 = 0, TargetPointCount - 1 do
                    if v179 >= 32 then
                        if p151 <= os.clock() then
                            v182 = p139.Stats;
                            v182.Segments = v182.Segments + v152;
                            v183 = p139.Stats;
                            v183.BlockerHits = v183.BlockerHits + v152;

                            return RESULT_UNRESOLVED;
                        end;

                        v179 = 0;
                    end;

                    v179 = v179 + 1;
                    v184 = TargetPoints[i2 + 1];
                    v185 = v181 * VisibilityCycleCodec.MAX_TARGET_POINTS + i2 + 1;
                    v186 = p145.SampleHints[v185];

                    if v186 and (v153 and (p139.PrimitiveCount == 0 and samplePacketBlocks(v186, v180, v184))) then
                        v152 = v152 + 1;
                        v187 = true;
                        v188 = true;
                    else
                        v188, v187 = segmentBlocked(p139, p145, v180, v184, p146);

                        if v188 and (v153 ~= nil and (p139.PrimitiveCount == 0 and p145.TriangleCount > 0)) then
                            p145.SampleHints[v185] = v153:SamplePacket(p145.Triangles[p145.TriangleCount]);
                        else
                            p145.SampleHints[v185] = nil;
                        end;
                    end;

                    if not v187 then
                        v189 = p139.Stats;
                        v189.Segments = v189.Segments + v152;
                        v190 = p139.Stats;
                        v190.BlockerHits = v190.BlockerHits + v152;

                        return RESULT_UNRESOLVED;
                    end;

                    if not v188 then
                        p145.ClearOrigin = v181;
                        p145.ClearPoint = i2;
                        p145.ClearOriginWorld = v180;
                        p145.ClearPointWorld = v184;
                        p145.ClearTargetRoot = p143.Position;
                        v191 = p139.Stats;
                        v191.Segments = v191.Segments + v152;
                        v192 = p139.Stats;
                        v192.BlockerHits = v192.BlockerHits + v152;

                        return RESULT_VISIBLE;
                    end;

                    v193 = i2;
                end;
            end;

            p145.OriginProofs[i + 1] = v194;
            local Stats = p139.Stats;
            Stats.PartialProofs = Stats.PartialProofs + 1;
            ProvenScratch[i + 1] = true;
            v181 = i;
        end;
    end;

    if v153 ~= nil and p139.PrimitiveCount == 0 then
        local v195, v196 = coverageBody(p139, p143);
        local Coverage = p139.Coverage;
        local SeedScratch = p139.SeedScratch;
        table.clear(SeedScratch);

        for i = 1, p145.TriangleCount do
            SeedScratch[i] = p145.Triangles[i];
            local _ = i;
        end;

        for i = 0, OriginCount - 1 do
            local v197;

            if ProvenScratch[i + 1] then
                v197 = i;
            else
                local v198, v199 = Coverage:OriginCovered(v153, Origins[i + 1], v195, v196, p145.CoverageTriangles[i + 1], p151, SeedScratch);

                if v198 ~= true then
                    p145.CoverageTriangles[i + 1] = nil;
                    local Stats = p139.Stats;
                    Stats.Segments = Stats.Segments + v152;
                    local Stats2 = p139.Stats;
                    Stats2.BlockerHits = Stats2.BlockerHits + v152;

                    if v198 == nil and p151 <= os.clock() then
                        return RESULT_UNRESOLVED;
                    end;

                    p145.CoverageRetryAfter = p139.Cycle + 4;

                    return RESULT_VISIBLE;
                end;

                p145.CoverageTriangles[i + 1] = v199;
                v197 = i;

                for _, v in v199 do
                    if #SeedScratch >= 192 then
                        break;
                    end;

                    SeedScratch[#SeedScratch + 1] = v;
                end;
            end;
        end;
    end;

    if p144 == PAIR_PROOF and (v153 ~= nil and (v153.Data.certificateCount > 0 and (p139.SearchBudget > 0 and (p139.Cycle >= p145.SearchAfterCycle and (p142.CellCount > 0 and p143.CellCount > 0))))) then
        p139.SearchBudget = p139.SearchBudget - 1;
        local Stats = p139.Stats;
        Stats.CertificateSearches = Stats.CertificateSearches + 1;
        p145.SearchAfterCycle = p139.Cycle + p139.SearchRetryCycles;
        local TargetPointCount2 = p143.TargetPointCount;
        local v200;

        if bit32.band(p143.Flags, ACTOR_FLAG_HULL_TAIL) == 0 then
            v200 = p143.TargetPointsOffset;
        else
            local v201 = bit32.band(p143.Flags, ACTOR_FLAG_EXTRAPOLATED) == 0 and 8 or 16;

            if v201 < TargetPointCount2 then
                v200 = p143.TargetPointsOffset + (TargetPointCount2 - v201) * VECTOR_SIZE;
                TargetPointCount2 = v201;
            else
                v200 = p143.TargetPointsOffset;
            end;
        end;

        local v202, v203 = v153:ProveProjectedOccludedForCellBuffer(p140, p142.CellsOffset, p142.CellCount, p143.CellsOffset, p143.CellCount, p142.OriginsOffset, p142.OriginCount, v200, TargetPointCount2, PreferredPlane, nil, p139.SearchPlanes);

        if v202 and v203 ~= nil then
            p145.PreferredPlane = v203;
            local Stats2 = p139.Stats;
            Stats2.CertificateFound = Stats2.CertificateFound + 1;
            local Stats3 = p139.Stats;
            Stats3.Segments = Stats3.Segments + v152;
            local Stats4 = p139.Stats;
            Stats4.BlockerHits = Stats4.BlockerHits + v152;

            return RESULT_HIDDEN;
        end;
    end;

    if p148 and (v153 ~= nil and (p139.FaceTestBudget > 0 and p139.Cycle >= p145.FaceSearchAfterCycle)) then
        if searchBlockFace(p139, p140, p142, p143, p145, FacePrimitive, p145.FaceAxis, p145.FaceSign) then
            local Stats = p139.Stats;
            Stats.DynamicFound = Stats.DynamicFound + 1;
            p145.FaceFirst = true;
        else
            p145.FaceSearchAfterCycle = p139.Cycle + p139.FaceRetryCycles;
        end;
    end;

    p145.HiddenViewerPose = p149;
    p145.HiddenTargetPose = p150;
    p145.HiddenAt = p141.CaptureTime;
    local Stats = p139.Stats;
    Stats.Segments = Stats.Segments + v152;
    local Stats2 = p139.Stats;
    Stats2.BlockerHits = Stats2.BlockerHits + v152;

    return RESULT_HIDDEN;
end;

function u1.FaceCertified(p204: any, p205: buffer, p206: number, p207: number) -- Line: 1070
    -- upvalues: VisibilityCycleCodec (copy), cachedFaceCovers (copy)
    local v208 = p204.Cache[p206];
    local v209;

    if v208 == nil then
        v209 = nil;
    else
        v209 = v208[p207];
    end;

    if v209 == nil or v209.FacePrimitive == nil then
        return false;
    end;

    local v210 = nil;
    local v211 = nil;

    for i = 1, VisibilityCycleCodec.readCaptureHeader(p205).ActorCount do
        local v212 = VisibilityCycleCodec.readActor(p205, i);
        local v213;

        if v212.ActorId == p206 then
            v210 = v212;
            v213 = i;
        elseif v212.ActorId == p207 then
            v211 = v212;
            v213 = i;
        else
            v213 = i;
        end;
    end;

    if v210 == nil or v211 == nil then
        return false;
    end;

    return cachedFaceCovers(p204, p205, v210, v211, v209);
end;

function u1.Solve(p214: any, u215: buffer, p216: number, p217: number, p218: function?, p219: number?) -- Line: 1098
    -- upvalues: VisibilityCycleCodec (copy), readVector (copy), VECTOR_SIZE (copy), OcclusionMath (copy), pruneCache (copy), FLAG_DYNAMIC_CERTIFICATES (copy), PAIR_SKIP (copy), RESULT_SKIPPED (copy), RESULT_UNRESOLVED (copy), pairCache (copy), evaluatePair (copy), RESULT_HIDDEN (copy), RESULT_VISIBLE (copy)
    local os_clock_ret = os.clock();
    local v220 = VisibilityCycleCodec.readCaptureHeader(u215);
    local ActorCount = v220.ActorCount;
    local v221 = os_clock_ret + math.max(v220.CycleBudgetSeconds, 0.0005);
    p214.Deadline = v221;
    local v222 = VisibilityCycleCodec.createResult(ActorCount, p216, v220.Sequence, v220.CaptureTime, v220.Generation, 0);
    local Stats = p214.Stats;

    for i in Stats do
        Stats[i] = 0;
    end;

    p214.Cycle = p214.Cycle + 1;
    p214.SearchBudget = p214.SearchBudgetPerCycle;
    p214.FaceTestBudget = p214.FaceTestBudgetPerCycle;
    local table_create_ret = table.create(ActorCount);
    local table_create_ret2 = table.create(ActorCount);
    local v223 = {};

    for i = 1, ActorCount do
        local v224 = VisibilityCycleCodec.readActor(u215, i);

        local function decodePoints(p225: number, p226: number, p227: vector?) -- Line: 1132
            -- upvalues: readVector (ref), u215 (copy), VECTOR_SIZE (ref), OcclusionMath (ref)
            local table_create_ret3 = table.create(p226);
            local v228 = p227 or Vector3.new(inf, inf, inf);
            local v229 = p227 or Vector3.new(-inf, -inf, -inf);
            local v230 = true;

            for i2 = 0, p226 - 1 do
                local v231 = readVector(u215, p225 + i2 * VECTOR_SIZE);
                table_create_ret3[i2 + 1] = v231;

                if not OcclusionMath.isFiniteVector(v231) then
                    v230 = false;
                end;

                v228 = v228:Min(v231);
                v229 = v229:Max(v231);
                local _ = i2;
            end;

            if v230 and (OcclusionMath.isFiniteVector(v228) and OcclusionMath.isFiniteVector(v229)) then
                return table_create_ret3, {
                    v228.X,
                    v228.Y,
                    v228.Z,
                    v229.X,
                    v229.Y,
                    v229.Z
                };
            end;

            return table_create_ret3, nil;
        end;

        local v232, v233 = decodePoints(v224.OriginsOffset, v224.OriginCount, nil);
        v224.Origins = v232;
        v224.OriginBounds = v233;
        local v234, v235 = decodePoints(v224.TargetPointsOffset, v224.TargetPointCount, v224.Position);
        v224.TargetPoints = v234;
        v224.TargetBounds = v235;
        table_create_ret[i] = v224;
        v223[v224.ActorId] = true;
        table_create_ret2[i] = buffer.readstring(u215, v224.OriginsOffset, v224.OriginCount * VECTOR_SIZE) .. buffer.readstring(u215, v224.TargetPointsOffset, v224.TargetPointCount * VECTOR_SIZE);
        local _ = i;
    end;

    if p214.Cycle % 64 == 0 then
        pruneCache(p214, v223);
    end;

    local v236 = bit32.band(v220.Flags, VisibilityCycleCodec.FLAG_STATIC) ~= 0;
    local v237 = bit32.band(v220.Flags, FLAG_DYNAMIC_CERTIFICATES) ~= 0;
    local PairKindOffset = v220.PairKindOffset;
    local v238 = VisibilityCycleCodec.resultRowsOffset();
    local v239 = VisibilityCycleCodec.resultMatrixOffset(ActorCount);
    local v240 = ActorCount <= 0 and 0 or v220.Sequence % ActorCount;
    local v241 = false;

    for i = 0, ActorCount - 1 do
        local v242 = (i + v240) % ActorCount + 1;
        local v243 = table_create_ret[v242];
        local v244;

        if v243.ActorId % p217 == p216 - 1 then
            buffer.writeu8(v222, v238 + v242 - 1, 1);
            local v245 = v239 + (v242 - 1) * ActorCount;
            v244 = i;

            for i2 = 1, ActorCount do
                local buffer_readu8_ret = buffer.readu8(u215, PairKindOffset + (v242 - 1) * ActorCount + (i2 - 1));
                local v246;

                if buffer_readu8_ret == PAIR_SKIP or i2 == v242 then
                    Stats.Skipped = Stats.Skipped + 1;
                    buffer.writeu8(v222, v245 + i2 - 1, RESULT_SKIPPED);
                    v246 = i2;
                else
                    Stats.Pairs = Stats.Pairs + 1;

                    if v241 or v221 <= os.clock() then
                        Stats.Unresolved = Stats.Unresolved + 1;
                        buffer.writeu8(v222, v245 + i2 - 1, RESULT_UNRESOLVED);
                        v246 = i2;
                        v241 = true;
                    else
                        local v247 = table_create_ret[i2];
                        local v248 = evaluatePair(p214, u215, v220, v243, v247, buffer_readu8_ret, pairCache(p214, v243.ActorId, v247.ActorId), p218, v236, v237, table_create_ret2[v242], table_create_ret2[i2], v221);

                        if v248 == RESULT_HIDDEN then
                            Stats.Hidden = Stats.Hidden + 1;
                        elseif v248 == RESULT_VISIBLE then
                            Stats.Visible = Stats.Visible + 1;
                        else
                            Stats.Unresolved = Stats.Unresolved + 1;
                            v241 = v221 <= os.clock() and true or v241;
                        end;

                        buffer.writeu8(v222, v245 + i2 - 1, v248);
                        v246 = i2;
                    end;
                end;
            end;
        else
            v244 = i;
        end;
    end;

    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_PAIRS, Stats.Pairs);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_HIDDEN, Stats.Hidden);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_VISIBLE, Stats.Visible);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_UNRESOLVED, Stats.Unresolved);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_SKIPPED, Stats.Skipped);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_CERTIFICATE_HITS, Stats.CertificateHits);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_CLEAR_REPLAYS, Stats.ClearReplays);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_DYNAMIC_HITS, Stats.DynamicHits);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_DYNAMIC_FOUND, Stats.DynamicFound);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_POSE_REPLAYS, Stats.PoseReplays);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_CERTIFICATE_SEARCHES, Stats.CertificateSearches);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_CERTIFICATE_FOUND, Stats.CertificateFound);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_SEGMENTS, Stats.Segments);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_BLOCKER_HITS, Stats.BlockerHits);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_BVH_QUERIES, Stats.BVHQueries);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_BVH_HITS, Stats.BVHHits);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_FALLBACK_RAYS, Stats.FallbackRays);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_DEADLINE, v241 and 1 or 0);
    VisibilityCycleCodec.writeStat(v222, VisibilityCycleCodec.STAT_MICROSECONDS, ((p219 or os.clock()) - os_clock_ret) * 1000000);

    return v222;
end;

return table.freeze(u1);