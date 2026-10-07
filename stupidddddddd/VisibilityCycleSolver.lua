-- ReplicatedStorage.Visibility.VisibilityCycleSolver
-- Script path: ReplicatedStorage.Visibility.VisibilityCycleSolver
-- Decompile time: 43.15 ms

local OcclusionMath = require(script.Parent.OcclusionMath)
local SilhouetteCoverage = require(script.Parent.SilhouetteCoverage)
require(script.Parent.StaticOcclusionRuntime)
local VisibilityCycleCodec = require(script.Parent.VisibilityCycleCodec)
local u20 = {}
u20.__index = u20
local PRIMITIVE_SIZE = VisibilityCycleCodec.PRIMITIVE_SIZE
local VECTOR_SIZE = VisibilityCycleCodec.VECTOR_SIZE
local RESULT_HIDDEN = VisibilityCycleCodec.RESULT_HIDDEN
local RESULT_VISIBLE = VisibilityCycleCodec.RESULT_VISIBLE
local RESULT_UNRESOLVED = VisibilityCycleCodec.RESULT_UNRESOLVED
local RESULT_SKIPPED = VisibilityCycleCodec.RESULT_SKIPPED
local PAIR_SKIP = VisibilityCycleCodec.PAIR_SKIP
local PAIR_PROOF = VisibilityCycleCodec.PAIR_PROOF
local FLAG_DYNAMIC_CERTIFICATES = VisibilityCycleCodec.FLAG_DYNAMIC_CERTIFICATES
local ACTOR_FLAG_EXTRAPOLATED = VisibilityCycleCodec.ACTOR_FLAG_EXTRAPOLATED
local ACTOR_FLAG_HULL_TAIL = VisibilityCycleCodec.ACTOR_FLAG_HULL_TAIL
local readVector = VisibilityCycleCodec.readVector

function u20.new(a1, a2, a3, a4) -- Line: 148
    -- upvalues: PRIMITIVE_SIZE (val), VisibilityCycleCodec (val), SilhouetteCoverage (val), u20 (val)
    local v1 = a4 or {}
    return (setmetatable({
        Cycle = 0,
        SearchBudget = 0,
        FaceTestBudget = 0,
        Static = a1,
        Primitives = a2,
        PrimitiveCount = if a2 ~= nil then (buffer.len(a2)) // PRIMITIVE_SIZE else 0,
        NonBlockPrimitiveCount = a3 or 0,
        Cache = {},
        SearchBudgetPerCycle = v1.SearchBudgetPerCycle or 12,
        SearchPlanes = v1.SearchPlanes or 8,
        SearchRetryCycles = v1.SearchRetryCycles or 30,
        FaceTestBudgetPerCycle = v1.FaceTestBudgetPerCycle or 192,
        FaceRetryCycles = v1.FaceRetryCycles or 8,
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
            PoseReplays = 0,
        },
        Stack = {},
    }, u20))
end

local function primitiveIsBlock(a1, a2) -- Line: 200
    -- upvalues: PRIMITIVE_SIZE (val), VisibilityCycleCodec (val)
    local v1 = (a2 - 1) * PRIMITIVE_SIZE
    return (buffer.readu8(a1, v1)) == VisibilityCycleCodec.PRIMITIVE_KIND_BLOCK
end

local function primitiveBlocksSegment(a1, a2, a3, a4) -- Line: 205
    -- upvalues: PRIMITIVE_SIZE (val)
    local v1, v2
    local v3 = (a2 - 1) * PRIMITIVE_SIZE
    local X = a3.X
    local v4 = v3 + 4
    local v5 = X - buffer.readf32(a1, v4)
    local Y = a3.Y
    local v6 = v3 + 8
    local v7 = Y - buffer.readf32(a1, v6)
    local Z = a3.Z
    local v8 = v3 + 12
    local v9 = Z - buffer.readf32(a1, v8)
    v6 = v3 + 16
    local v10 = buffer.readf32(a1, v6)
    v8 = v3 + 20
    v4 = buffer.readf32(a1, v8)
    local v11 = v3 + 24
    v6 = buffer.readf32(a1, v11)
    local v12 = v3 + 28
    v8 = buffer.readf32(a1, v12)
    local v13 = v3 + 32
    v11 = buffer.readf32(a1, v13)
    local v14 = v3 + 36
    v12 = buffer.readf32(a1, v14)
    local v15 = v3 + 40
    v13 = buffer.readf32(a1, v15)
    local v16 = v3 + 44
    v14 = buffer.readf32(a1, v16)
    local v17 = v3 + 48
    v15 = buffer.readf32(a1, v17)
    local v18 = v3 + 52
    v16 = buffer.readf32(a1, v18) + 0.02
    local v19 = v3 + 56
    v17 = buffer.readf32(a1, v19) + 0.02
    local v20 = v3 + 60
    local v21 = buffer.readf32(a1, v20) + 0.02
    v18 = v10 * v5 + v8 * v7 + v13 * v9
    v19 = v4 * v5 + v11 * v7 + v14 * v9
    v20 = v6 * v5 + v12 * v7 + v15 * v9
    local v22 = v10 * a4.X + v8 * a4.Y + v13 * a4.Z
    local v23 = v4 * a4.X + v11 * a4.Y + v14 * a4.Z
    local v24 = v6 * a4.X + v12 * a4.Y + v15 * a4.Z
    local v25 = 0
    local v26 = 1
    local v27 = math.abs(v22)
    if v27 <= 1e-08 then
        if v16 < math.abs(v18) then
            return false
        end
        v27 = math.abs(v23)
        if v27 <= 1e-08 then
            if v17 < math.abs(v19) then
                return false
            end
            if (math.abs(v24)) <= 1e-08 then
                return math.abs(v20) <= v21
            end
            v27 = (-v21 - v20) / v24
            v1 = (v21 - v20) / v24
            if v1 < v27 then
                v2 = v1
                v1 = v27
                v27 = v2
            end
            v25 = math.max(v25, v27)
            return v25 <= math.min(v26, v1)
        end
        v27 = (-v17 - v19) / v23
        v1 = (v17 - v19) / v23
        if v1 < v27 then
            v2 = v1
            v1 = v27
            v27 = v2
        end
        v25 = math.max(v25, v27)
        v26 = math.min(v26, v1)
        if v26 < v25 then
            return false
        end
        if (math.abs(v24)) <= 1e-08 then
            return math.abs(v20) <= v21
        end
        v27 = (-v21 - v20) / v24
        v1 = (v21 - v20) / v24
        if v1 < v27 then
            v2 = v1
            v1 = v27
            v27 = v2
        end
        v25 = math.max(v25, v27)
        return v25 <= math.min(v26, v1)
    end
    v27 = (-v16 - v18) / v22
    v1 = (v16 - v18) / v22
    if v1 < v27 then
        v2 = v1
        v1 = v27
        v27 = v2
    end
    v25 = math.max(v25, v27)
    v26 = math.min(v26, v1)
    if v26 < v25 then
        return false
    end
    v27 = math.abs(v23)
    if v27 <= 1e-08 then
        if v17 < math.abs(v19) then
            return false
        end
        if (math.abs(v24)) <= 1e-08 then
            return math.abs(v20) <= v21
        end
        v27 = (-v21 - v20) / v24
        v1 = (v21 - v20) / v24
        if v1 < v27 then
            v2 = v1
            v1 = v27
            v27 = v2
        end
        v25 = math.max(v25, v27)
        return v25 <= math.min(v26, v1)
    end
    v27 = (-v17 - v19) / v23
    v1 = (v17 - v19) / v23
    if v1 < v27 then
        v2 = v1
        v1 = v27
        v27 = v2
    end
    v25 = math.max(v25, v27)
    v26 = math.min(v26, v1)
    if v26 < v25 then
        return false
    end
    if (math.abs(v24)) <= 1e-08 then
        return math.abs(v20) <= v21
    end
    v27 = (-v21 - v20) / v24
    v1 = (v21 - v20) / v24
    if v1 < v27 then
        v2 = v1
        v1 = v27
        v27 = v2
    end
    v25 = math.max(v25, v27)
    return v25 <= math.min(v26, v1)
end

local function rememberRecent(a1, a2, a3, a4) -- Line: 282 -- types: a1: table, a2: number, a3: number, a4: number
    for i = a2, 1, -1 do
        if a1[i] == a3 then
            if i < a2 then
                table.remove(a1, i)
                a1[a2] = a3
            end
            return a2
        end
    end
    if not (a4 <= a2) then
        a1[a2 + 1] = a3
        return a2 + 1
    end
    table.remove(a1, 1)
    a1[a2] = a3
    return a2
end

local function segmentBlocked(a1, a2, a3, a4, a5) -- Line: 302
    -- upvalues: primitiveBlocksSegment (val), PRIMITIVE_SIZE (val), VisibilityCycleCodec (val), rememberRecent (val)
    local v1
    local Stats = a1.Stats
    Stats.Segments = Stats.Segments + 1
    local v2 = a4 - a3
    local Primitives = a1.Primitives
    if Primitives ~= nil then
        local Blockers = a2.Blockers
        for i = a2.BlockerCount, 1, -1 do
            v1 = Blockers[i]
            if primitiveBlocksSegment(Primitives, v1, a3, v2) then
                Stats.BlockerHits = Stats.BlockerHits + 1
                if i < a2.BlockerCount then
                    table.remove(Blockers, i)
                    Blockers[a2.BlockerCount] = v1
                end
                return true, true
            end
        end
    end
    local Static = a1.Static
    local v3 = false
    if Static ~= nil then
        local v4, v5, v6
        local Triangles = a2.Triangles
        for j = a2.TriangleCount, 1, -1 do
            v6 = Triangles[j]
            if Static:TriangleBlocksSegment(v6, a3, a4) then
                Stats.BlockerHits = Stats.BlockerHits + 1
                if j < a2.TriangleCount then
                    table.remove(Triangles, j)
                    Triangles[a2.TriangleCount] = v6
                end
                return true, true
            end
        end
        v3 = true
        Stats.BVHQueries = Stats.BVHQueries + 1
        v4, v1, v5, v6 = Static:SegmentBlocked(a3, a4, nil, a1.Deadline, a2.NodeHint)
        if v6 == false then
            return false, false
        end
        if v4 then
            a2.NodeHint = Static.LastHitNode
            Stats.BVHHits = Stats.BVHHits + 1
            if Primitives == nil or v1 == nil or not (v1 >= 1) then
                if v5 ~= nil then
                    a2.TriangleCount = rememberRecent(a2.Triangles, a2.TriangleCount, v5, 8)
                end
            elseif v1 <= a1.PrimitiveCount then
                local v7 = (v1 - 1) * PRIMITIVE_SIZE
                if (buffer.readu8(Primitives, v7)) == VisibilityCycleCodec.PRIMITIVE_KIND_BLOCK then
                    a2.BlockerCount = rememberRecent(a2.Blockers, a2.BlockerCount, v1, 8)
                elseif v5 ~= nil then
                    a2.TriangleCount = rememberRecent(a2.Triangles, a2.TriangleCount, v5, 8)
                end
            elseif v5 ~= nil then
                a2.TriangleCount = rememberRecent(a2.Triangles, a2.TriangleCount, v5, 8)
            end
            return true, true
        end
    end
    if a5 == nil then
        return false, v3
    end
    if not (0 < a1.NonBlockPrimitiveCount) and v3 then
        return false, v3
    end
    Stats.FallbackRays = Stats.FallbackRays + 1
    local v8 = a5(a3, a4)
    if v8 == nil then
        return false, v3
    end
    return v8, true
end

local function pairCache(a1, a2, a3) -- Line: 379 -- types: a2: number, a3: number
    local v1 = a1.Cache[a2]
    if v1 == nil then
        a1.Cache[a2] = {}
    end
    local v2 = v1[a3]
    if v2 == nil then
        v1[a3] = {
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
            CoverageTriangles = {},
        }
    end
    return v2
end

local function pruneCache(a1, a2) -- Line: 407 -- types: a2: table
    local Cache = a1.Cache
    local v1 = nil
    local v2 = nil
    local v3, v4 = a2, a1
    for i, j in Cache, v1, v2 do
        if v3[i] then
            for k in j do
                if not v3[k] then
                    j[k] = nil
                end
            end
        else
            v4.Cache[i] = nil
        end
    end
end

local function primitiveFace(a1, a2, a3, a4) -- Line: 422
    -- upvalues: PRIMITIVE_SIZE (val)
    local v1 = (a2 - 1) * PRIMITIVE_SIZE
    local v2 = v1 + 4
    local v3 = buffer.readf32(a1, v2)
    local v4 = v1 + 8
    local v5 = buffer.readf32(a1, v4)
    local v6 = v1 + 12
    local v7 = Vector3.new(v3, v5, (buffer.readf32(a1, v6)))
    v4 = v1 + 16
    v5 = buffer.readf32(a1, v4)
    v6 = v1 + 28
    v2 = buffer.readf32(a1, v6)
    local v8 = v1 + 40
    v3 = Vector3.new(v5, v2, (buffer.readf32(a1, v8)))
    v6 = v1 + 20
    v2 = buffer.readf32(a1, v6)
    v8 = v1 + 32
    v4 = buffer.readf32(a1, v8)
    local v9 = v1 + 44
    v5 = Vector3.new(v2, v4, (buffer.readf32(a1, v9)))
    v8 = v1 + 24
    v4 = buffer.readf32(a1, v8)
    v9 = v1 + 36
    v6 = buffer.readf32(a1, v9)
    local v10 = v1 + 48
    v2 = Vector3.new(v4, v6, (buffer.readf32(a1, v10)))
    v8 = v1 + 52
    v4 = buffer.readf32(a1, v8)
    v9 = v1 + 56
    v6 = buffer.readf32(a1, v9)
    v10 = v1 + 60
    v8 = buffer.readf32(a1, v10)
    if a3 == 0 then
        return v7 + v3 * (a4 * v4), v5, v2, v3 * a4, v6, v8
    end
    if a3 == 1 then
        return v7 + v5 * (a4 * v6), v2, v3, v5 * a4, v8, v4
    end
    return v7 + v2 * (a4 * v8), v3, v5, v2 * a4, v4, v6
end

local function coverageBody(a1, a2) -- Line: 461 -- upvalues: ACTOR_FLAG_HULL_TAIL (val), ACTOR_FLAG_EXTRAPOLATED (val)
    local TargetPoints = a2.TargetPoints
    local TargetPointCount = a2.TargetPointCount
    local v1 = TargetPointCount
    local v2 = nil
    if bit32.band(a2.Flags, ACTOR_FLAG_HULL_TAIL) ~= 0 then
        local v3 = if not (bit32.band(a2.Flags, ACTOR_FLAG_EXTRAPOLATED) ~= 0) then 8 else 16
        if v3 < TargetPointCount then
            local v4
            v1 = TargetPointCount - v3
            if v4 then
                v2 = TargetPoints[v1 + 9] - TargetPoints[v1 + 1]
            end
        end
    end
    local BodyScratch = a1.BodyScratch
    table.clear(BodyScratch)
    for i = 1, v1 do
        BodyScratch[i] = TargetPoints[i]
    end
    if v2 ~= nil then
        for j = 1, v1 do
            BodyScratch[v1 + j] = TargetPoints[j] + v2
        end
    end
    return BodyScratch, #BodyScratch
end

local function beginSeeds(a1, a2) -- Line: 490 -- types: a2: table
    local SeedScratch = a1.SeedScratch
    table.clear(SeedScratch)
    local TriangleCount = a2.TriangleCount
    for i = 1, TriangleCount do
        SeedScratch[i] = a2.Triangles[i]
    end
    return SeedScratch
end

local function appendSeeds(a1, a2) -- Line: 499 -- types: a1: table, a2: table
    for i, j in a2 do
        if #a1 >= 192 then
            return
        end
        a1[#a1 + 1] = j
    end
end

local function coverageBlocks(a1, a2, a3, a4) -- Line: 509 -- types: a2: table?, a3: vector, a4: vector
    if a2 == nil then
        return false
    end
    for i, j in a2 do
        if a1:TriangleBlocksSegment(j, a3, a4) then
            return true
        end
    end
    return false
end

local function proofRange(a1) -- Line: 527
    -- upvalues: ACTOR_FLAG_HULL_TAIL (val), ACTOR_FLAG_EXTRAPOLATED (val), VECTOR_SIZE (val)
    local TargetPointCount = a1.TargetPointCount
    if bit32.band(a1.Flags, ACTOR_FLAG_HULL_TAIL) ~= 0 then
        local v1 = if bit32.band(a1.Flags, ACTOR_FLAG_EXTRAPOLATED) == 0 then 8 else 16
        if v1 < TargetPointCount then
            return a1.TargetPointsOffset + (TargetPointCount - v1) * VECTOR_SIZE, v1
        end
    end
    return a1.TargetPointsOffset, TargetPointCount
end

local function faceCovers(a1, a2, a3, a4, a5, a6, a7) -- Line: 538
    -- upvalues: primitiveFace (val), ACTOR_FLAG_HULL_TAIL (val), ACTOR_FLAG_EXTRAPOLATED (val), VECTOR_SIZE (val)
    local Primitives = a1.Primitives
    local Static = a1.Static
    if Primitives ~= nil and Static ~= nil and not (a5 < 1) and not (a1.PrimitiveCount < a5) then
        local TargetPointsOffset, v1
        local v2, v3, v4, v5, v6, v7 = primitiveFace(Primitives, a5, a6, a7)
        local TargetPointCount = a4.TargetPointCount
        if bit32.band(a4.Flags, ACTOR_FLAG_HULL_TAIL) == 0 then
            TargetPointsOffset = a4.TargetPointsOffset
            v1 = TargetPointCount
        else
            local v8 = if bit32.band(a4.Flags, ACTOR_FLAG_EXTRAPOLATED) == 0 then 8 else 16
            if not (v8 < TargetPointCount) then
                TargetPointsOffset = a4.TargetPointsOffset
                v1 = TargetPointCount
            else
                TargetPointsOffset = a4.TargetPointsOffset + (TargetPointCount - v8) * VECTOR_SIZE
                v1 = v8
            end
        end
        return Static:ProveRectangleBuffer(a2, v2, v3, v4, v5, v6, v7, a3.OriginsOffset, a3.OriginCount, TargetPointsOffset, v1)
    end
    return false
end

local function cachedFaceCovers(a1, a2, a3, a4, a5) -- Line: 569
    -- upvalues: faceCovers (val)
    return faceCovers(a1, a2, a3, a4, a5.FacePrimitive, a5.FaceAxis, a5.FaceSign)
end

local function searchBlockFace(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 588
    -- upvalues: readVector (val), PRIMITIVE_SIZE (val), VisibilityCycleCodec (val), faceCovers (val)
    local X, Y, Z, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22
    local Primitives = a1.Primitives
    if Primitives == nil then
        return false
    end
    local v23 = readVector(a2, a3.OriginsOffset)
    local v24 = 0
    for i = a5.BlockerCount, 1, -1 do
        v3 = a5.Blockers[i]
        v7 = (v3 - 1) * PRIMITIVE_SIZE
        v4 = (buffer.readu8(Primitives, v7)) == VisibilityCycleCodec.PRIMITIVE_KIND_BLOCK
        if v4 then
            v4 = (v3 - 1) * PRIMITIVE_SIZE
            X = v23.X
            v9 = v4 + 4
            v5 = X - buffer.readf32(Primitives, v9)
            Y = v23.Y
            v10 = v4 + 8
            v6 = Y - buffer.readf32(Primitives, v10)
            Z = v23.Z
            v11 = v4 + 12
            v7 = Z - buffer.readf32(Primitives, v11)
            for j = 0, 2 do
                v11 = v4 + 16 + j * 4
                v14 = buffer.readf32(Primitives, v11) * v5
                v18 = v11 + 12
                v13 = v14 + buffer.readf32(Primitives, v18) * v6
                v16 = v11 + 24
                v12 = v13 + buffer.readf32(Primitives, v16) * v7
                v15 = v4 + 52 + j * 4
                v13 = buffer.readf32(Primitives, v15)
                v14 = if not (v13 < v12) then if not (v12 < -v13) then 0 else -1 else 1
                if v14 ~= 0 then
                    if v3 == v20 and j == v21 and v14 == v22 then
                        continue
                    end
                    if not (v24 >= 12) and not (v1.FaceTestBudget <= 0) then
                        v24 = v24 + 1
                        v1.FaceTestBudget = v1.FaceTestBudget - 1
                        if not faceCovers(v1, v2, v8, v17, v3, j, v14) then
                            continue
                        end
                        v19.FacePrimitive = v3
                        v19.FaceAxis = j
                        v19.FaceSign = v14
                        return true
                    end
                    return false
                end
            end
        end
    end
    return false
end

local function samplePacketBlocks(a1, a2, a3) -- Line: 641 -- types: a2: vector, a3: vector
    local v1 = a3 - a2
    if (v1:Dot(v1)) <= 1e-07 then
        return false
    end
    local v2 = a1[2]
    local v3 = a1[3]
    local v4 = v1:Cross(v3)
    local v5 = v2:Dot(v4)
    if (math.abs(v5)) <= 1e-07 then
        return false
    end
    local v6 = 1 / v5
    local v7 = a2 - a1[1]
    local v8 = v7:Dot(v4) * v6
    if not (v8 < -1e-07) and not (v8 > 1.0000001) then
        local v9 = v7:Cross(v2)
        local v10 = v1:Dot(v9) * v6
        if not (v10 < -1e-07) and not (1.0000001 < v8 + v10) then
            local v11 = v3:Dot(v9) * v6
            local v12 = false
            if v11 >= 1e-07 then
                v12 = v11 <= 0.9999999
            end
            return v12
        end
        return false
    end
    return false
end

local function evaluatePair(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13) -- Line: 673
    -- upvalues: RESULT_UNRESOLVED (val), PAIR_PROOF (val), faceCovers (val), RESULT_HIDDEN (val)
    -- upvalues: ACTOR_FLAG_HULL_TAIL (val), ACTOR_FLAG_EXTRAPOLATED (val), VECTOR_SIZE (val), coverageBody (val)
    -- upvalues: RESULT_VISIBLE (val), coverageBlocks (val), segmentBlocked (val), readVector (val)
    -- upvalues: VisibilityCycleCodec (val), samplePacketBlocks (val), searchBlockFace (val)
    local v1 = 0
    local Static = if not a9 then nil else a1.Static
    if a4.OriginCount ~= 0 and a5.TargetPointCount ~= 0 then
        local Cycle_2, Stats_12, Stats_13, Stats_14, Stats_15, Stats_16, Stats_17, Stats_18, Stats_19, Stats_20, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31
        local Proofs = if Static == nil then nil else Static.Proofs
        local OriginBounds = a4.OriginBounds
        local TargetBounds = a5.TargetBounds
        local ProofPlane = a7.ProofPlane
        local PreferredPlane = a7.PreferredPlane
        local FacePrimitive = a7.FacePrimitive
        local v32 = nil
        local v33 = a10
        if v33 then
            v33 = false
            if Static ~= nil then
                v33 = FacePrimitive ~= nil
            end
        end
        local v34 = false
        if a6 == PAIR_PROOF then
            v34 = false
            if Static ~= nil then
                v34 = PreferredPlane ~= nil
            end
        end
        if v33 and a7.FaceFirst then
            if faceCovers(a1, a2, a4, a5, a7.FacePrimitive, a7.FaceAxis, a7.FaceSign) then
                local Stats = a1.Stats
                Stats.CertificateHits = Stats.CertificateHits + 1
                local Stats_2 = a1.Stats
                Stats_2.DynamicHits = Stats_2.DynamicHits + 1
                return RESULT_HIDDEN
            end
            v32 = FacePrimitive
            v33 = false
        end
        if v34 then
            local TargetPointsOffset
            local TargetPointCount = a5.TargetPointCount
            if bit32.band(a5.Flags, ACTOR_FLAG_HULL_TAIL) == 0 then
                TargetPointsOffset = a5.TargetPointsOffset
                v8 = TargetPointCount
            else
                v10 = if bit32.band(a5.Flags, ACTOR_FLAG_EXTRAPOLATED) == 0 then 8 else 16
                if not (v10 < TargetPointCount) then
                    TargetPointsOffset = a5.TargetPointsOffset
                    v8 = TargetPointCount
                else
                    TargetPointsOffset = a5.TargetPointsOffset + (TargetPointCount - v10) * VECTOR_SIZE
                    v8 = v10
                end
            end
            if Static:ProvePlaneBuffer(a2, PreferredPlane, a4.OriginsOffset, a4.OriginCount, TargetPointsOffset, v8, nil) then
                local Stats_3 = a1.Stats
                Stats_3.CertificateHits = Stats_3.CertificateHits + 1
                a7.FaceFirst = false
                return RESULT_HIDDEN
            end
        end
        if v33 then
            if faceCovers(a1, a2, a4, a5, a7.FacePrimitive, a7.FaceAxis, a7.FaceSign) then
                local Stats_4 = a1.Stats
                Stats_4.CertificateHits = Stats_4.CertificateHits + 1
                local Stats_5 = a1.Stats
                Stats_5.DynamicHits = Stats_5.DynamicHits + 1
                a7.FaceFirst = true
                return RESULT_HIDDEN
            end
            v32 = FacePrimitive
        end
        if not a9 then
            return RESULT_UNRESOLVED
        end
        if a7.HiddenViewerPose == a11 and a7.HiddenTargetPose == a12 and a3.CaptureTime - a7.HiddenAt <= 0.25 then
            local Stats_6 = a1.Stats
            Stats_6.PoseReplays = Stats_6.PoseReplays + 1
            return RESULT_HIDDEN
        end
        a7.HiddenViewerPose = nil
        if Static ~= nil
            and a1.PrimitiveCount == 0
            and a7.ClearOrigin == nil
            and a3.CaptureTime - a7.HiddenAt <= 0.5 then
            local TargetPointCount_2
            local Origins = a4.Origins
            v8, v9 = coverageBody(a1, a5)
            local SeedScratch = a1.SeedScratch
            table.clear(SeedScratch)
            local TriangleCount = a7.TriangleCount
            for i = 1, TriangleCount do
                SeedScratch[i] = a7.Triangles[i]
            end
            local OriginCount_2 = a4.OriginCount
            v2, v29, v6 = a1, a7, a13
            for j = 1, OriginCount_2 do
                v14, v15 = v2.Coverage:OriginCovered(Static, Origins[j], v8, v9, v29.CoverageTriangles[j], v6, SeedScratch)
                if v14 ~= true then
                    v29.CoverageTriangles[j] = nil
                    v29.HiddenAt = (-1 / 0)
                    if v14 == nil and v6 <= os.clock() then
                        return RESULT_UNRESOLVED
                    end
                    v29.CoverageRetryAfter = v2.Cycle + 4
                    return RESULT_VISIBLE
                end
                v29.CoverageTriangles[j] = v15
                for k, n in v15 do
                    if #SeedScratch >= 192 then
                        break
                    end
                    SeedScratch[#SeedScratch + 1] = n
                end
            end
            local TargetPoints = v20.TargetPoints
            local OriginCount_3 = v13.OriginCount
            for m = 1, OriginCount_3 do
                v15 = v29.CoverageTriangles[m]
                TargetPointCount_2 = v20.TargetPointCount
                for i5 = 1, TargetPointCount_2 do
                    if not coverageBlocks(Static, v15, Origins[m], TargetPoints[i5]) then
                        v16, v17 = segmentBlocked(v2, v29, Origins[m], TargetPoints[i5], v30)
                        if not v17 then
                            return RESULT_UNRESOLVED
                        end
                        if not v16 then
                            v29.HiddenAt = (-1 / 0)
                            return RESULT_VISIBLE
                        end
                    end
                end
            end
            v29.HiddenViewerPose = v4
            v29.HiddenTargetPose = v5
            v29.HiddenAt = v7.CaptureTime
            return RESULT_HIDDEN
        end
        local ClearOrigin = a7.ClearOrigin
        local ClearPoint = a7.ClearPoint
        if ClearOrigin ~= nil and ClearPoint ~= nil and ClearOrigin < a4.OriginCount then
            v9 = readVector(a2, a4.OriginsOffset + ClearOrigin * VECTOR_SIZE)
            local Position = if not (ClearPoint < 0) then if not (ClearPoint < a5.TargetPointCount) then nil else readVector(a2, a5.TargetPointsOffset + ClearPoint * VECTOR_SIZE) else a5.Position
            if Position ~= nil then
                v11, v12 = segmentBlocked(a1, a7, v9, Position, a8)
                if not v12 then
                    return RESULT_UNRESOLVED
                end
                if not v11 then
                    local Stats_7 = a1.Stats
                    Stats_7.ClearReplays = Stats_7.ClearReplays + 1
                    a7.ClearOriginWorld = v9
                    a7.ClearPointWorld = Position
                    a7.ClearTargetRoot = a5.Position
                    return RESULT_VISIBLE
                end
            end
            local ClearOriginWorld = a7.ClearOriginWorld
            local ClearPointWorld = a7.ClearPointWorld
            local ClearTargetRoot = a7.ClearTargetRoot
            if ClearOriginWorld ~= nil
                and ClearPointWorld ~= nil
                and ClearTargetRoot ~= nil
                and (v9 - ClearOriginWorld).Magnitude <= 0.5
                and (a5.Position - ClearTargetRoot).Magnitude <= 0.35 then
                v14, v15 = segmentBlocked(a1, a7, ClearOriginWorld, ClearPointWorld, a8)
                if not v15 then
                    return RESULT_UNRESOLVED
                end
                if not v14 then
                    local Stats_8 = a1.Stats
                    Stats_8.ClearReplays = Stats_8.ClearReplays + 1
                    return RESULT_VISIBLE
                end
            end
            a7.ClearOrigin = nil
            a7.ClearPoint = nil
            a7.ClearOriginWorld = nil
            a7.ClearPointWorld = nil
            a7.ClearTargetRoot = nil
        end
        if a1.Cycle < (a7.CoverageRetryAfter or 0) then
            return RESULT_VISIBLE
        end
        if Proofs ~= nil
            and OriginBounds ~= nil
            and TargetBounds ~= nil
            and ProofPlane ~= nil
            and Proofs:Covers(ProofPlane, OriginBounds, TargetBounds, a13) then
            local Stats_9 = a1.Stats
            Stats_9.CertificateHits = Stats_9.CertificateHits + 1
            return RESULT_HIDDEN
        end
        v9 = a4.Origins[1]
        v10, v11 = segmentBlocked(a1, a7, v9, a5.Position, a8)
        if not v11 then
            return RESULT_UNRESOLVED
        end
        if not v10 then
            a7.ClearOrigin = 0
            a7.ClearPoint = -1
            a7.ClearOriginWorld = v9
            a7.ClearPointWorld = a5.Position
            a7.ClearTargetRoot = a5.Position
            return RESULT_VISIBLE
        end
        if Proofs ~= nil and OriginBounds ~= nil and TargetBounds ~= nil then
            local Cycle = a1.Cycle
            if (a7.ProofSearchAfter or 0) <= Cycle then
                a7.ProofSearchAfter = a1.Cycle + 4
                local Stats_10 = a1.Stats
                Stats_10.CertificateSearches = Stats_10.CertificateSearches + 1
                table.clear(a7.ProofCandidates)
                v12 = Proofs:Search(OriginBounds, TargetBounds, a7.Triangles, a7.TriangleCount, ProofPlane, a13, a7.ProofCandidates)
                if v12 ~= nil then
                    a7.ProofPlane = v12
                    local Stats_11 = a1.Stats
                    Stats_11.CertificateFound = Stats_11.CertificateFound + 1
                    return RESULT_HIDDEN
                end
            end
        end
        local OriginCount_4 = a4.OriginCount
        local TargetPointCount_3 = a5.TargetPointCount
        local Origins_2 = a4.Origins
        local TargetPoints_2 = a5.TargetPoints
        local v35 = 0
        local ProvenScratch = a1.ProvenScratch
        table.clear(ProvenScratch)
        local v36 = OriginCount_4 - 1
        v6, v2, v29, v20, v30, v28, v13, v3, v31, v4, v5, v7 = a13, a1, a7, a5, a8, a6, a4, a2, a10, a11, a12, a3
        for i6 = 0, v36 do
            if v6 <= os.clock() then
                Stats_12 = v2.Stats
                Stats_12.Segments = Stats_12.Segments + v1
                Stats_13 = v2.Stats
                Stats_13.BlockerHits = Stats_13.BlockerHits + v1
                return RESULT_UNRESOLVED
            end
            v18 = Origins_2[i6 + 1]
            if Proofs ~= nil and TargetBounds ~= nil then
                Cycle_2 = v2.Cycle
                if (v29.OriginProofRetry[i6 + 1] or 0) <= Cycle_2 then
                    v19 = Proofs:CoversOrigin(v18, TargetBounds, v29.ProofCandidates, v29.OriginProofs[i6 + 1], v6)
                    if v19 ~= nil then
                        v29.OriginProofs[i6 + 1] = v19
                        Stats_14 = v2.Stats
                        Stats_14.PartialProofs = Stats_14.PartialProofs + 1
                        ProvenScratch[i6 + 1] = true
                        continue
                    end
                    v29.OriginProofRetry[i6 + 1] = v2.Cycle + 8
                end
            end
            v19 = TargetPointCount_3 - 1
            for i7 = 0, v19 do
                if v35 >= 32 then
                    v35 = 0
                    if v6 <= os.clock() then
                        Stats_15 = v2.Stats
                        Stats_15.Segments = Stats_15.Segments + v1
                        Stats_16 = v2.Stats
                        Stats_16.BlockerHits = Stats_16.BlockerHits + v1
                        return RESULT_UNRESOLVED
                    end
                end
                v35 = v35 + 1
                v21 = TargetPoints_2[i7 + 1]
                v22 = i6 * VisibilityCycleCodec.MAX_TARGET_POINTS + i7 + 1
                v23 = v29.SampleHints[v22]
                if not v23 or not Static or v2.PrimitiveCount ~= 0 or not samplePacketBlocks(v23, v18, v21) then
                    v26, v27 = segmentBlocked(v2, v29, v18, v21, v30)
                    v25 = v27
                    if not v26 or Static == nil or v2.PrimitiveCount ~= 0 or not (0 < v29.TriangleCount) then
                        v29.SampleHints[v22] = nil
                    else
                        v29.SampleHints[v22] = (Static:SamplePacket(v29.Triangles[v29.TriangleCount]))
                    end
                else
                    v1 = v1 + 1
                    v24 = true
                    v25 = true
                end
                if not v25 then
                    Stats_17 = v2.Stats
                    Stats_17.Segments = Stats_17.Segments + v1
                    Stats_18 = v2.Stats
                    Stats_18.BlockerHits = Stats_18.BlockerHits + v1
                    return RESULT_UNRESOLVED
                end
                if not v24 then
                    v29.ClearOrigin = i6
                    v29.ClearPoint = i7
                    v29.ClearOriginWorld = v18
                    v29.ClearPointWorld = v21
                    v29.ClearTargetRoot = v20.Position
                    Stats_19 = v2.Stats
                    Stats_19.Segments = Stats_19.Segments + v1
                    Stats_20 = v2.Stats
                    Stats_20.BlockerHits = Stats_20.BlockerHits + v1
                    return RESULT_VISIBLE
                end
            end
        end
        if Static ~= nil and v2.PrimitiveCount == 0 then
            local Stats_21, Stats_22
            v36, v16 = coverageBody(v2, v20)
            local Coverage_2 = v2.Coverage
            local SeedScratch_2 = v2.SeedScratch
            table.clear(SeedScratch_2)
            local TriangleCount_4 = v29.TriangleCount
            for i8 = 1, TriangleCount_4 do
                SeedScratch_2[i8] = v29.Triangles[i8]
            end
            v19 = OriginCount_4 - 1
            for i9 = 0, v19 do
                if not ProvenScratch[i9 + 1] then
                    v21, v22 = Coverage_2:OriginCovered(Static, Origins_2[i9 + 1], v36, v16, v29.CoverageTriangles[i9 + 1], v6, SeedScratch_2)
                    if v21 ~= true then
                        v29.CoverageTriangles[i9 + 1] = nil
                        Stats_21 = v2.Stats
                        Stats_21.Segments = Stats_21.Segments + v1
                        Stats_22 = v2.Stats
                        Stats_22.BlockerHits = Stats_22.BlockerHits + v1
                        if v21 == nil and v6 <= os.clock() then
                            return RESULT_UNRESOLVED
                        end
                        v29.CoverageRetryAfter = v2.Cycle + 4
                        return RESULT_VISIBLE
                    end
                    v29.CoverageTriangles[i9 + 1] = v22
                    for i10, i11 in v22 do
                        if #SeedScratch_2 >= 192 then
                            break
                        end
                        SeedScratch_2[#SeedScratch_2 + 1] = i11
                    end
                end
            end
        end
        if v28 == PAIR_PROOF
            and Static ~= nil
            and 0 < Static.Data.certificateCount
            and 0 < v2.SearchBudget
            and v29.SearchAfterCycle <= v2.Cycle
            and 0 < v13.CellCount
            and 0 < v20.CellCount then
            local TargetPointsOffset_2
            v2.SearchBudget = v2.SearchBudget - 1
            local Stats_23 = v2.Stats
            Stats_23.CertificateSearches = Stats_23.CertificateSearches + 1
            v29.SearchAfterCycle = v2.Cycle + v2.SearchRetryCycles
            local TargetPointCount_4 = v20.TargetPointCount
            if bit32.band(v20.Flags, ACTOR_FLAG_HULL_TAIL) == 0 then
                TargetPointsOffset_2 = v20.TargetPointsOffset
                v16 = TargetPointCount_4
            else
                v18 = if bit32.band(v20.Flags, ACTOR_FLAG_EXTRAPOLATED) == 0 then 8 else 16
                if not (v18 < TargetPointCount_4) then
                    TargetPointsOffset_2 = v20.TargetPointsOffset
                    v16 = TargetPointCount_4
                else
                    TargetPointsOffset_2 = v20.TargetPointsOffset + (TargetPointCount_4 - v18) * VECTOR_SIZE
                    v16 = v18
                end
            end
            v17, v18 = Static:ProveProjectedOccludedForCellBuffer(
                v3,
                v13.CellsOffset,
                v13.CellCount,
                v20.CellsOffset,
                v20.CellCount,
                v13.OriginsOffset,
                v13.OriginCount,
                TargetPointsOffset_2,
                v16,
                PreferredPlane,
                nil,
                v2.SearchPlanes
            )
            if v17 and v18 ~= nil then
                v29.PreferredPlane = v18
                local Stats_24 = v2.Stats
                Stats_24.CertificateFound = Stats_24.CertificateFound + 1
                local Stats_25 = v2.Stats
                Stats_25.Segments = Stats_25.Segments + v1
                local Stats_26 = v2.Stats
                Stats_26.BlockerHits = Stats_26.BlockerHits + v1
                return RESULT_HIDDEN
            end
        end
        if v31 and Static ~= nil and 0 < v2.FaceTestBudget and v29.FaceSearchAfterCycle <= v2.Cycle then
            if not searchBlockFace(v2, v3, v13, v20, v29, v32, v29.FaceAxis, v29.FaceSign) then
                v29.FaceSearchAfterCycle = v2.Cycle + v2.FaceRetryCycles
            else
                local Stats_27 = v2.Stats
                Stats_27.DynamicFound = Stats_27.DynamicFound + 1
                v29.FaceFirst = true
            end
        end
        v29.HiddenViewerPose = v4
        v29.HiddenTargetPose = v5
        v29.HiddenAt = v7.CaptureTime
        local Stats_28 = v2.Stats
        Stats_28.Segments = Stats_28.Segments + v1
        local Stats_29 = v2.Stats
        Stats_29.BlockerHits = Stats_29.BlockerHits + v1
        return RESULT_HIDDEN
    end
    return RESULT_UNRESOLVED
end

function u20.FaceCertified(a1, a2, a3, a4) -- Line: 1070
    -- upvalues: VisibilityCycleCodec (val), cachedFaceCovers (val)
    local v1 = a1.Cache[a3]
    local v2 = if v1 == nil then nil else v1[a4]
    if v2 ~= nil and v2.FacePrimitive ~= nil then
        local v3
        local v4 = nil
        local v5 = nil
        local ActorCount = (VisibilityCycleCodec.readCaptureHeader(a2)).ActorCount
        local v6, v7, v8 = a2, a3, a4
        for i = 1, ActorCount do
            v3 = VisibilityCycleCodec.readActor(v6, i)
            if v3.ActorId == v7 then
                v4 = v3
            elseif v3.ActorId == v8 then
                v5 = v3
            end
        end
        if v4 ~= nil and v5 ~= nil then
            local v9
            return cachedFaceCovers(v9, v6, v4, v5, v2)
        end
        return false
    end
    return false
end

function u20.Solve(a1, a2, a3, a4, a5, a6) -- Line: 1098
    -- upvalues: VisibilityCycleCodec (val), readVector (val), VECTOR_SIZE (val), OcclusionMath (val), pruneCache (val)
    -- upvalues: FLAG_DYNAMIC_CERTIFICATES (val), PAIR_SKIP (val), RESULT_SKIPPED (val), RESULT_UNRESOLVED (val)
    -- upvalues: pairCache (val), evaluatePair (val), RESULT_HIDDEN (val), RESULT_VISIBLE (val)
    local decodePoints, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
    local v13 = os.clock()
    local v14 = VisibilityCycleCodec.readCaptureHeader(a2)
    local ActorCount = v14.ActorCount
    local v15 = v13 + math.max(v14.CycleBudgetSeconds, 0.0005)
    a1.Deadline = v15
    local v16 = VisibilityCycleCodec.createResult(ActorCount, a3, v14.Sequence, v14.CaptureTime, v14.Generation, 0)
    local Stats = a1.Stats
    for i in Stats do
        Stats[i] = 0
    end
    a1.Cycle = a1.Cycle + 1
    a1.SearchBudget = a1.SearchBudgetPerCycle
    a1.FaceTestBudget = a1.FaceTestBudgetPerCycle
    local v17 = table.create(ActorCount)
    local v18 = table.create(ActorCount)
    local v19 = {}
    for j = 1, ActorCount do
        v1 = VisibilityCycleCodec.readActor(a2, j)

        function decodePoints(a1, a2_2, a3) -- Line: 1132
            -- upvalues: readVector (upval), a2 (val), VECTOR_SIZE (upval), OcclusionMath (upval)
            local v1
            local v2 = table.create(a2_2)
            local v3 = a3 or Vector3.new((1 / 0), (1 / 0), (1 / 0))
            local v4 = a3 or Vector3.new((-1 / 0), (-1 / 0), (-1 / 0))
            local v5 = true
            local v6 = a2_2 - 1
            for i = 0, v6 do
                v1 = readVector(a2, a1 + i * VECTOR_SIZE)
                v2[i + 1] = v1
                if not OcclusionMath.isFiniteVector(v1) then
                    v5 = false
                end
                v3 = v3:Min(v1)
                v4 = v4:Max(v1)
            end
            v6 = v2
            if v5 and OcclusionMath.isFiniteVector(v3) and OcclusionMath.isFiniteVector(v4) then
                return v6, {v3.X, v3.Y, v3.Z, v4.X, v4.Y, v4.Z}
            end
            return v6, nil
        end

        v2, v3 = decodePoints(v1.OriginsOffset, v1.OriginCount, nil)
        v1.Origins = v2
        v1.OriginBounds = v3
        v2, v3 = decodePoints(v1.TargetPointsOffset, v1.TargetPointCount, v1.Position)
        v1.TargetPoints = v2
        v1.TargetBounds = v3
        v17[j] = v1
        v19[v1.ActorId] = true
        v3 = buffer.readstring(a2, v1.OriginsOffset, v1.OriginCount * VECTOR_SIZE)
        v18[j] = v3 .. buffer.readstring(a2, v1.TargetPointsOffset, v1.TargetPointCount * VECTOR_SIZE)
    end
    if a1.Cycle % 64 == 0 then
        pruneCache(a1, v19)
    end
    local v20 = bit32.band(v14.Flags, VisibilityCycleCodec.FLAG_STATIC) ~= 0
    local v21 = bit32.band(v14.Flags, FLAG_DYNAMIC_CERTIFICATES) ~= 0
    local PairKindOffset = v14.PairKindOffset
    v1 = VisibilityCycleCodec.resultRowsOffset()
    local v22 = VisibilityCycleCodec.resultMatrixOffset(ActorCount)
    v2 = false
    v3 = if not (ActorCount > 0) then 0 else v14.Sequence % ActorCount
    local v23 = ActorCount - 1
    local v24, v25, v26, v27, v28 = a4, a3, a1, a5, a6
    for k = 0, v23 do
        v4 = (k + v3) % ActorCount + 1
        v5 = v17[v4]
        v6 = v5.ActorId % v24
        if v6 == v25 - 1 then
            v7 = v1 + v4 - 1
            buffer.writeu8(v16, v7, 1)
            v6 = v22 + (v4 - 1) * ActorCount
            for n = 1, ActorCount do
                v10 = PairKindOffset + (v4 - 1) * ActorCount + (n - 1)
                v8 = buffer.readu8(a2, v10)
                if v8 == PAIR_SKIP then
                    Stats.Skipped = Stats.Skipped + 1
                    v11 = v6 + n - 1
                    buffer.writeu8(v16, v11, RESULT_SKIPPED)
                elseif n ~= v4 then
                    Stats.Pairs = Stats.Pairs + 1
                    if v2 then
                        v2 = true
                        Stats.Unresolved = Stats.Unresolved + 1
                        v11 = v6 + n - 1
                        buffer.writeu8(v16, v11, RESULT_UNRESOLVED)
                    elseif not (v15 <= os.clock()) then
                        v9 = v17[n]
                        v11 = evaluatePair(v26, a2, v14, v5, v9, v8, pairCache(v26, v5.ActorId, v9.ActorId), v27, v20, v21, v18[v4], v18[n], v15)
                        if v11 == RESULT_HIDDEN then
                            Stats.Hidden = Stats.Hidden + 1
                        elseif v11 ~= RESULT_VISIBLE then
                            Stats.Unresolved = Stats.Unresolved + 1
                            if v15 <= os.clock() then
                                v2 = true
                            end
                        else
                            Stats.Visible = Stats.Visible + 1
                        end
                        v12 = v6 + n - 1
                        buffer.writeu8(v16, v12, v11)
                    else
                        v2 = true
                        Stats.Unresolved = Stats.Unresolved + 1
                        v11 = v6 + n - 1
                        buffer.writeu8(v16, v11, RESULT_UNRESOLVED)
                    end
                else
                    Stats.Skipped = Stats.Skipped + 1
                    v11 = v6 + n - 1
                    buffer.writeu8(v16, v11, RESULT_SKIPPED)
                end
            end
        end
    end
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_PAIRS, Stats.Pairs)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_HIDDEN, Stats.Hidden)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_VISIBLE, Stats.Visible)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_UNRESOLVED, Stats.Unresolved)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_SKIPPED, Stats.Skipped)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_CERTIFICATE_HITS, Stats.CertificateHits)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_CLEAR_REPLAYS, Stats.ClearReplays)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_DYNAMIC_HITS, Stats.DynamicHits)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_DYNAMIC_FOUND, Stats.DynamicFound)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_POSE_REPLAYS, Stats.PoseReplays)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_CERTIFICATE_SEARCHES, Stats.CertificateSearches)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_CERTIFICATE_FOUND, Stats.CertificateFound)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_SEGMENTS, Stats.Segments)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_BLOCKER_HITS, Stats.BlockerHits)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_BVH_QUERIES, Stats.BVHQueries)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_BVH_HITS, Stats.BVHHits)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_FALLBACK_RAYS, Stats.FallbackRays)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_DEADLINE, if not v2 then 0 else 1)
    VisibilityCycleCodec.writeStat(v16, VisibilityCycleCodec.STAT_MICROSECONDS, ((v28 or os.clock()) - v13) * 1000000)
    return v16
end

return table.freeze(u20)