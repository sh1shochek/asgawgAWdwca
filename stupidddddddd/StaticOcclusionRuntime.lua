-- ReplicatedStorage.Visibility.StaticOcclusionRuntime
-- Script path: ReplicatedStorage.Visibility.StaticOcclusionRuntime
-- Decompile time: 88.32 ms

local StaticOcclusionCodec = require(script.Parent.StaticOcclusionCodec)
local u5 = {}
u5.__index = u5
local NODE_SIZE = StaticOcclusionCodec.NODE_SIZE
local LEAF_SIZE = StaticOcclusionCodec.LEAF_SIZE
local INDEXED_VERSION = StaticOcclusionCodec.INDEXED_VERSION
local VERTEX_SIZE = StaticOcclusionCodec.VERTEX_SIZE
local PLANE_SIZE = StaticOcclusionCodec.PLANE_SIZE
local RECT_SIZE = StaticOcclusionCodec.RECT_SIZE
local CERTIFICATE_SIZE = StaticOcclusionCodec.CERTIFICATE_SIZE
local CANDIDATE_SIZE = StaticOcclusionCodec.CANDIDATE_SIZE

local function readVector(a1, a2) -- Line: 116 -- types: a1: buffer, a2: number
    return (Vector3.new(buffer.readf32(a1, a2), buffer.readf32(a1, a2 + 4), (buffer.readf32(a1, a2 + 8))))
end

local function readTriangle(a1, a2) -- Line: 124
    -- upvalues: INDEXED_VERSION (val), VERTEX_SIZE (val)
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
    local buffer_2 = a1.buffer
    local v11 = a1.triangleOffset + (a2 - 1) * a1.triangleSize
    if a1.version ~= INDEXED_VERSION then
        v6 = buffer.readf32(buffer_2, v11)
        v9 = v11 + 4
        v7 = buffer.readf32(buffer_2, v9)
        v10 = v11 + 8
        v5 = Vector3.new(v6, v7, (buffer.readf32(buffer_2, v10)))
        v7 = v11 + 12
        v9 = buffer.readf32(buffer_2, v7)
        v2 = v7 + 4
        v10 = buffer.readf32(buffer_2, v2)
        v3 = v7 + 8
        v6 = Vector3.new(v9, v10, (buffer.readf32(buffer_2, v3)))
        v8 = v11 + 24
        v10 = buffer.readf32(buffer_2, v8)
        v3 = v8 + 4
        v1 = buffer.readf32(buffer_2, v3)
        v4 = v8 + 8
        v7 = Vector3.new(v10, v1, (buffer.readf32(buffer_2, v4)))
        v10 = v11 + 36
        return v5, v6, v7, (buffer.readu32(buffer_2, v10))
    end
    v5 = buffer.readu32(buffer_2, v11)
    v8 = v11 + 4
    v6 = buffer.readu32(buffer_2, v8)
    v9 = v11 + 8
    v7 = buffer.readu32(buffer_2, v9)
    v9 = a1.vertexOffset + (v5 - 1) * VERTEX_SIZE
    v1 = buffer.readf32(buffer_2, v9)
    v4 = v9 + 4
    v2 = buffer.readf32(buffer_2, v4)
    local v12 = v9 + 8
    v8 = Vector3.new(v1, v2, (buffer.readf32(buffer_2, v12)))
    v10 = a1.vertexOffset + (v6 - 1) * VERTEX_SIZE
    v2 = buffer.readf32(buffer_2, v10)
    v12 = v10 + 4
    v3 = buffer.readf32(buffer_2, v12)
    local v13 = v10 + 8
    v9 = Vector3.new(v2, v3, (buffer.readf32(buffer_2, v13)))
    v1 = a1.vertexOffset + (v7 - 1) * VERTEX_SIZE
    v3 = buffer.readf32(buffer_2, v1)
    v13 = v1 + 4
    v4 = buffer.readf32(buffer_2, v13)
    local v14 = v1 + 8
    return v8, v9, Vector3.new(v3, v4, (buffer.readf32(buffer_2, v14))), 0
end

local function segmentIntersectsBounds(a1, a2, a3, a4, a5, a6, a7) -- Line: 142
    -- upvalues: 
    local v1, v2
    local v3 = 0
    local v4 = a7
    if a2 == 0 then
        if not (a1.X < a5.X) and not (a6.X < a1.X) then
            if a3 == 0 then
                if not (a1.Y < a5.Y) and not (a6.Y < a1.Y) then
                    if a4 == 0 then
                        if not (a1.Z < a5.Z) and not (a6.Z < a1.Z) then
                            return true
                        end
                        return false
                    end
                    v2 = (a5.Z - a1.Z) * a4
                    v1 = (a6.Z - a1.Z) * a4
                    v3 = math.max(v3, (math.min(v2, v1)))
                    if math.min(v4, (math.max(v2, v1))) < v3 then
                        return false
                    end
                    return true
                end
                return false
            end
            v2 = (a5.Y - a1.Y) * a3
            v1 = (a6.Y - a1.Y) * a3
            v3 = math.max(v3, (math.min(v2, v1)))
            v4 = math.min(v4, (math.max(v2, v1)))
            if v4 < v3 then
                return false
            end
            if a4 == 0 then
                if not (a1.Z < a5.Z) and not (a6.Z < a1.Z) then
                    return true
                end
                return false
            end
            v2 = (a5.Z - a1.Z) * a4
            v1 = (a6.Z - a1.Z) * a4
            v3 = math.max(v3, (math.min(v2, v1)))
            if math.min(v4, (math.max(v2, v1))) < v3 then
                return false
            end
            return true
        end
        return false
    end
    v2 = (a5.X - a1.X) * a2
    v1 = (a6.X - a1.X) * a2
    v3 = math.max(v3, (math.min(v2, v1)))
    v4 = math.min(v4, (math.max(v2, v1)))
    if v4 < v3 then
        return false
    end
    if a3 == 0 then
        if not (a1.Y < a5.Y) and not (a6.Y < a1.Y) then
            if a4 == 0 then
                if not (a1.Z < a5.Z) and not (a6.Z < a1.Z) then
                    return true
                end
                return false
            end
            v2 = (a5.Z - a1.Z) * a4
            v1 = (a6.Z - a1.Z) * a4
            v3 = math.max(v3, (math.min(v2, v1)))
            if math.min(v4, (math.max(v2, v1))) < v3 then
                return false
            end
            return true
        end
        return false
    end
    v2 = (a5.Y - a1.Y) * a3
    v1 = (a6.Y - a1.Y) * a3
    v3 = math.max(v3, (math.min(v2, v1)))
    v4 = math.min(v4, (math.max(v2, v1)))
    if v4 < v3 then
        return false
    end
    if a4 == 0 then
        if not (a1.Z < a5.Z) and not (a6.Z < a1.Z) then
            return true
        end
        return false
    end
    v2 = (a5.Z - a1.Z) * a4
    v1 = (a6.Z - a1.Z) * a4
    v3 = math.max(v3, (math.min(v2, v1)))
    if math.min(v4, (math.max(v2, v1))) < v3 then
        return false
    end
    return true
end

local function segmentEdgesFraction(a1, a2, a3, a4, a5, a6) -- Line: 193
    -- upvalues: 
    local v1 = a2:Cross(a5)
    local v2 = a4:Dot(v1)
    if (math.abs(v2)) <= 1e-07 then
        return nil
    end
    local v3 = 1 / v2
    local v4 = a1 - a3
    local v5 = v4:Dot(v1) * v3
    local v6 = a6 or -1e-07
    if not (v5 < v6) and not (1 - v6 < v5) then
        local v7 = v4:Cross(a4)
        local v8 = a2:Dot(v7) * v3
        if not (v8 < v6) then
            local v9 = v5 + v8
            if not (1 - v6 < v9) then
                v9 = a5:Dot(v7) * v3
                if v9 >= 1e-07 and v9 <= 0.9999999 then
                    return v9
                end
                return nil
            end
        end
        return nil
    end
    return nil
end

local function segmentTriangleFraction(a1, a2, a3, a4, a5) -- Line: 222
    -- upvalues: segmentEdgesFraction (val)
    return (segmentEdgesFraction(a1, a2, a3, a4 - a3, a5 - a3))
end

function u5.new(a1, a2, a3) -- Line: 226
    -- upvalues: StaticOcclusionCodec (val), u5 (val)
    local v1 = StaticOcclusionCodec.decode(a1, a3)
    if a2 ~= nil and v1.fingerprint ~= a2 then
        error("PVBVH1 fingerprint does not match the expected visibility geometry")
    end
    return (setmetatable({
        PlaneMarkToken = 0,
        Data = v1,
        SamplePacketIds = {},
        SamplePackets = {},
        Stack = table.create((math.max(v1.nodeCount, 8))),
        TriangleCacheIds = table.create(4096, 0),
        TriangleCacheA = table.create(4096),
        TriangleCacheFirstEdge = table.create(4096),
        TriangleCacheSecondEdge = table.create(4096),
        PlaneMarks = buffer.create(math.max(v1.planeCount, 1) * 4),
        CandidatePlanes = table.create(v1.planeCount),
        ChildReferences = table.create(8),
        ChildDepths = table.create(8),
        ViewerProjectionScratch = buffer.create(48960),
        TargetProjectionScratch = buffer.create(48960),
        VolumePairMarks = buffer.create(65025),
        BatchProjectionScratch = buffer.create(48960),
        BatchVolumePairMarks = buffer.create(65025),
    }, u5))
end

function u5.GetFingerprint(a1) -- Line: 258
    return a1.Data.fingerprint
end

function u5.InstallProofs(a1, a2, a3) -- Line: 263 -- types: a2: string, a3: function?
    a1.Proofs = nil
    local success, result = pcall(function() -- Line: 269 -- upvalues: a2 (val), a1 (val), a3 (val)
        return require(script.Parent.ExactOcclusionProofs).new(a2, a1.Data, a3)
    end)
    if not success then
        return false, (tostring(result))
    end
    a1.Proofs = result
    return true, nil
end

local function querySegment(a1, a2, a3, a4, a5, a6, a7) -- Line: 280
    -- upvalues: NODE_SIZE (val), segmentIntersectsBounds (val), LEAF_SIZE (val), readTriangle (val)
    -- upvalues: segmentEdgesFraction (val)
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22
    local v23 = a3 - a2
    if (v23:Dot(v23)) <= 1e-07 then
        return false, nil, nil, nil
    end
    local v24 = if not ((math.abs(v23.X)) <= 1e-07) then 1 / v23.X else 0
    local v25 = if not ((math.abs(v23.Y)) <= 1e-07) then 1 / v23.Y else 0
    local v26 = if not ((math.abs(v23.Z)) <= 1e-07) then 1 / v23.Z else 0
    local v27 = 1
    local v28 = nil
    local v29 = nil
    local Data = a1.Data
    local buffer_2 = Data.buffer
    local Stack = a1.Stack
    local v30 = 1
    Stack[1] = a7 or Data.rootNode
    local v31 = 0
    local v32 = a6
    while v30 > 0 do
        if v32 and v31 % 32 == 0 and v32 <= os.clock() then
            return false, nil, nil, nil, false
        end
        v31 = v31 + 1
        v3 = Stack[v30]
        v30 = v30 - 1
        if v11 then
            v11.nodes = v11.nodes + 1
        end
        v4 = Data.nodeOffset + (v3 - 1) * NODE_SIZE
        for i = 1, 8 do
            v7 = v4 + 192 + (i - 1) * 4
            v5 = buffer.readi32(buffer_2, v7)
            if v5 ~= 0 then
                v6 = v4 + (i - 1) * 24
                v8 = buffer.readf32(buffer_2, v6)
                v12 = v6 + 4
                v9 = buffer.readf32(buffer_2, v12)
                v13 = v6 + 8
                v7 = Vector3.new(v8, v9, (buffer.readf32(buffer_2, v13)))
                v9 = v6 + 12
                v12 = buffer.readf32(buffer_2, v9)
                v15 = v9 + 4
                v13 = buffer.readf32(buffer_2, v15)
                v16 = v9 + 8
                if segmentIntersectsBounds(v2, v24, v25, v26, v7, Vector3.new(v12, v13, (buffer.readf32(buffer_2, v16))), v27) then
                    if not (v5 > 0) then
                        v10 = Data.leafOffset + (-v5 - 1) * LEAF_SIZE
                        v12 = buffer.readu32(buffer_2, v10)
                        v15 = v10 + 4
                        v14 = v12 + buffer.readu16(buffer_2, v15) - 1
                        for j = v12, v14 do
                            if v11 then
                                v11.triangles = v11.triangles + 1
                            end
                            v17, v18, v19, v20 = readTriangle(Data, j)
                            v21 = segmentEdgesFraction(v2, v23, v17, v18 - v17, v19 - v17)
                            if v21 ~= nil and v21 < v27 then
                                if not v22 then
                                    v1.LastHitNode = v3
                                    return true, v20, j, v21
                                end
                                v27 = v21
                                v28 = v20
                                v29 = j
                            end
                        end
                    else
                        v30 = v30 + 1
                        Stack[v30] = v5
                    end
                end
            end
        end
    end
    v3 = v29 ~= nil
    v4 = v28
    local v33 = v29
    if v29 ~= nil then
        return v3, v4, v33, v27
    end
    return v3, v4, v33, nil
end

function u5.SegmentBlocked(a1, a2, a3, a4, a5, a6) -- Line: 357
    -- upvalues: querySegment (val)
    local v1, v2, v3, v4
    if a6 and a6 >= 1 and a6 <= a1.Data.nodeCount and a6 % 1 == 0 and a6 ~= a1.Data.rootNode then
        v2, v3, v4, _, v1 = querySegment(a1, a2, a3, a4, false, a5, a6)
        if v1 == false then
            return false, nil, nil, false
        end
        if v2 then
            return true, v3, v4, true
        end
    end
    v2, v3, v4, _, v1 = querySegment(a1, a2, a3, a4, false, a5)
    return v2, v3, v4, v1 ~= false
end

local function boxMaxAlong(a1, a2, a3, a4) -- Line: 380 -- types: a1: vector, a2: vector, a3: vector, a4: vector
    local X = if not (0 <= a1.X) then a3.X else a4.X
    local Y = if not (0 <= a1.Y) then a3.Y else a4.Y
    local Z = if not (0 <= a1.Z) then a3.Z else a4.Z
    return (X - a2.X) * a1.X + (Y - a2.Y) * a1.Y + (Z - a2.Z) * a1.Z
end

function u5.VisitFrustumTriangles(a1, a2, a3, a4, a5, a6, a7, a8, a9) -- Line: 388
    -- upvalues: LEAF_SIZE (val), NODE_SIZE (val), boxMaxAlong (val)
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23
    local Data = a1.Data
    local buffer_2 = Data.buffer
    local Stack = a1.Stack
    local ChildReferences = a1.ChildReferences
    local ChildDepths = a1.ChildDepths
    local v24 = 1
    Stack[1] = Data.rootNode
    local v25 = 0
    local v26 = 0
    local v27 = -a4
    local v28 = a9
    while v24 > 0 do
        if v28 and v26 % 32 == 0 and v28 <= os.clock() then
            return false, false
        end
        v26 = v26 + 1
        v2 = Stack[v24]
        v24 = v24 - 1
        if not (v2 < 0) then
            v3 = Data.nodeOffset + (v2 - 1) * NODE_SIZE
            v5 = 0
            for i = 1, 8 do
                v11 = v3 + 192 + (i - 1) * 4
                v9 = buffer.readi32(buffer_2, v11)
                if v9 ~= 0 then
                    v10 = v3 + (i - 1) * 24
                    v12 = buffer.readf32(buffer_2, v10)
                    v16 = v10 + 4
                    v13 = buffer.readf32(buffer_2, v16)
                    v17 = v10 + 8
                    v11 = Vector3.new(v12, v13, (buffer.readf32(buffer_2, v17)))
                    v13 = v10 + 12
                    v16 = buffer.readf32(buffer_2, v13)
                    v18 = v13 + 4
                    v17 = buffer.readf32(buffer_2, v18)
                    v19 = v13 + 8
                    v12 = Vector3.new(v16, v17, (buffer.readf32(buffer_2, v19)))
                    v13 = -boxMaxAlong(v27, v1, v11, v12)
                    if not (boxMaxAlong(v15, v1, v11, v12) < v20) and not (v21 < v13) then
                        v14 = false
                        v16 = v4
                        for j, k in v16 do
                            if (boxMaxAlong(k, v1, v11, v12)) < 0 then
                                v14 = true
                                break
                            end
                        end
                        if not v14 then
                            v5 = v5 + 1
                            v16 = v5
                            while v16 > 1 do
                                if not (ChildDepths[v16 - 1] < v13) then
                                    break
                                end
                                ChildDepths[v16] = ChildDepths[v16 - 1]
                                ChildReferences[v16] = ChildReferences[v16 - 1]
                                v16 = v16 - 1
                            end
                            ChildDepths[v16] = v13
                            ChildReferences[v16] = v9
                        end
                    end
                end
            end
            for n = 1, v5 do
                v24 = v24 + 1
                Stack[v24] = ChildReferences[n]
            end
        else
            v3 = Data.leafOffset + (-v2 - 1) * LEAF_SIZE
            v5 = buffer.readu32(buffer_2, v3)
            v8 = v3 + 4
            v6 = buffer.readu16(buffer_2, v8)
            v25 = v25 + v6
            if v23 < v25 then
                return false, false
            end
            v7 = v5 + v6 - 1
            for m = v5, v7 do
                if v22(m) then
                    return true, true
                end
            end
        end
    end
    return false, true
end

function u5.TriangleVertices(a1, a2) -- Line: 475 -- upvalues: readTriangle (val) -- types: a2: number
    local v1
    local v2 = (a2 - 1) % 4096 + 1
    if a1.TriangleCacheIds[v2] ~= a2 then
        local v3, v4
        v1, v3, v4 = readTriangle(a1.Data, a2)
        a1.TriangleCacheIds[v2] = a2
        a1.TriangleCacheA[v2] = v1
        a1.TriangleCacheFirstEdge[v2] = v3 - v1
        a1.TriangleCacheSecondEdge[v2] = v4 - v1
    end
    v1 = a1.TriangleCacheA[v2]
    return v1, v1 + a1.TriangleCacheFirstEdge[v2], v1 + a1.TriangleCacheSecondEdge[v2]
end

function u5.NearestSegmentHit(a1, a2, a3) -- Line: 492 -- upvalues: querySegment (val) -- types: a2: vector, a3: vector
    local v1
    _, _, _, v1 = querySegment(a1, a2, a3, nil, true)
    return v1
end

function u5.TriangleBlocksSegment(a1, a2, a3, a4) -- Line: 502
    -- upvalues: readTriangle (val), segmentEdgesFraction (val)
    local Data = a1.Data
    if not (a2 < 1) and not (Data.triangleCount < a2) then
        local v1 = a4 - a3
        if (v1:Dot(v1)) <= 1e-07 then
            return false
        end
        local v2 = (a2 - 1) % 4096 + 1
        if a1.TriangleCacheIds[v2] ~= a2 then
            local v3, v4, v5 = readTriangle(Data, a2)
            a1.TriangleCacheIds[v2] = a2
            a1.TriangleCacheA[v2] = v3
            a1.TriangleCacheFirstEdge[v2] = v4 - v3
            a1.TriangleCacheSecondEdge[v2] = v5 - v3
        end
        return segmentEdgesFraction(a3, v1, a1.TriangleCacheA[v2], a1.TriangleCacheFirstEdge[v2], a1.TriangleCacheSecondEdge[v2]) ~= nil
    end
    return false
end

function u5.ProveTriangleBuffer(a1, a2, a3, a4, a5, a6, a7) -- Line: 534
    -- upvalues: readTriangle (val), segmentEdgesFraction (val)
    if a5 ~= 0 and not (a7 < 4) and not (a3 < 1) and not (a1.Data.triangleCount < a3) then
        local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
        local v11, v12, v13 = readTriangle(a1.Data, a3)
        local v14 = v12 - v11
        local v15 = v13 - v11
        local v16 = a5 - 1
        local v17, v18, v19, v20 = a4, a2, a7, a6
        for i = 0, v16 do
            v2 = v17 + i * 12
            v3 = buffer.readf32(v18, v2)
            v6 = v2 + 4
            v4 = buffer.readf32(v18, v6)
            v7 = v2 + 8
            v1 = Vector3.new(v3, v4, (buffer.readf32(v18, v7)))
            v2 = v19 - 1
            for j = 0, v2 do
                v5 = v20 + j * 12
                v7 = buffer.readf32(v18, v5)
                v9 = v5 + 4
                v8 = buffer.readf32(v18, v9)
                v10 = v5 + 8
                if segmentEdgesFraction(v1, (Vector3.new(v7, v8, (buffer.readf32(v18, v10)))) - v1, v11, v14, v15, 1e-05) == nil then
                    return false
                end
            end
        end
        return true
    end
    return false
end

local function rectangleCoverage(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 560
    -- upvalues: RECT_SIZE (val)
    local maximumV, minimumV, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
    local v15 = a4 - 0.01
    local v16 = a5 + 0.01
    local v17 = a6 - 0.01
    local v18 = a7 + 0.01
    local buffer_2 = a1.buffer
    if a3 == 1 then
        if a8 then
            a8.rectangles = a8.rectangles + 1
        end
        v14 = a1.rectangleOffset + (a2 - 1) * RECT_SIZE
        v1 = buffer.readf32(buffer_2, v14) + 0.01
        v4 = v14 + 4
        v2 = buffer.readf32(buffer_2, v4) - 0.01
        v5 = v14 + 8
        v3 = buffer.readf32(buffer_2, v5) + 0.01
        v6 = v14 + 12
        local v19 = buffer.readf32(buffer_2, v6) - 0.01
        v4 = false
        if v1 <= v15 then
            v4 = false
            if v16 <= v2 then
                v4 = false
                if v3 <= v17 then
                    v4 = v18 <= v19
                end
            end
        end
        v5 = v4
        if v4 then
            return v5, 1
        end
        return v5, 0
    end
    v14 = {v15, v16}
    v1 = {}
    v2 = a2 + a3 - 1
    local v20 = a8
    for i = a2, v2 do
        if v20 then
            v20.rectangles = v20.rectangles + 1
        end
        v4 = v21.rectangleOffset + (i - 1) * RECT_SIZE
        v5 = buffer.readf32(buffer_2, v4) + 0.01
        v9 = v4 + 4
        v6 = buffer.readf32(buffer_2, v9) - 0.01
        v10 = v4 + 8
        v7 = buffer.readf32(buffer_2, v10) + 0.01
        v11 = v4 + 12
        v8 = buffer.readf32(buffer_2, v11) - 0.01
        if v5 <= v16 and v15 <= v6 and v7 <= v18 and v17 <= v8 then
            v9 = #v1 + 1
            v10 = {minimumU = v5, maximumU = v6, minimumV = v7, maximumV = v8}
            v13 = v4 + 16
            v10.primitive = buffer.readu32(buffer_2, v13)
            v1[v9] = v10
            v14[#v14 + 1] = (math.max(v5, v15))
            v14[#v14 + 1] = (math.min(v6, v16))
        end
    end
    if #v1 == 0 then
        return false, 0
    end
    table.sort(v14)
    v2 = {}
    v3 = #v14 - 1
    for j = 1, v3 do
        v5 = v14[j]
        v6 = v14[j + 1]
        if not (v6 - v5 <= 1e-07) then
            v7 = (v5 + v6) * 0.5
            v8 = {}
            for k, n in v1 do
                if n.minimumU <= v7 and v7 <= n.maximumU then
                    v8[#v8 + 1] = n
                end
            end
            table.sort(v8, function(a1, a2) -- Line: 637
                if a1.minimumV == a2.minimumV then
                    return a2.maximumV < a1.maximumV
                end
                return a1.minimumV < a2.minimumV
            end)
            maximumV = v17
            v11 = nil
            v12 = nil
            for m, i5 in v8, v11, v12 do
                minimumV = i5.minimumV
                if maximumV + 1e-07 < minimumV then
                    return false, 0
                end
                if maximumV < i5.maximumV then
                    maximumV = i5.maximumV
                    v2[i5.primitive] = true
                end
                if v18 <= maximumV then
                    break
                end
            end
            if maximumV < v18 then
                return false, 0
            end
        end
    end
    v3 = 0
    for i6 in v2 do
        v3 = v3 + 1
    end
    return true, v3
end

local function planeCovers(a1, a2, a3, a4, a5) -- Line: 667
    -- upvalues: PLANE_SIZE (val), rectangleCoverage (val)
    local v1, v2, v3, v4, v5, v6, v7, v8
    local buffer_2 = a1.buffer
    local v9 = a1.planeOffset + (a2 - 1) * PLANE_SIZE
    local v10 = buffer.readf32(buffer_2, v9)
    local v11 = v9 + 4
    local v12 = buffer.readf32(buffer_2, v11)
    local v13 = v9 + 8
    local v14 = Vector3.new(v10, v12, (buffer.readf32(buffer_2, v13)))
    v12 = v9 + 12
    v11 = buffer.readf32(buffer_2, v12)
    local v15 = v12 + 4
    v13 = buffer.readf32(buffer_2, v15)
    local v16 = v12 + 8
    v10 = Vector3.new(v11, v13, (buffer.readf32(buffer_2, v16)))
    local v17 = v9 + 24
    v13 = buffer.readf32(buffer_2, v17)
    v16 = v17 + 4
    local v18 = buffer.readf32(buffer_2, v16)
    local v19 = v17 + 8
    v12 = Vector3.new(v13, v18, (buffer.readf32(buffer_2, v19)))
    v11 = v9 + 36
    v18 = buffer.readf32(buffer_2, v11)
    v19 = v11 + 4
    v15 = buffer.readf32(buffer_2, v19)
    local v20 = v11 + 8
    v17 = Vector3.new(v18, v15, (buffer.readf32(buffer_2, v20)))
    v18 = v9 + 48
    v11 = buffer.readu32(buffer_2, v18)
    v15 = v9 + 52
    v13 = buffer.readu16(buffer_2, v15)
    v18 = 0
    v16 = nil
    v19 = nil
    local v21, v22, v23, v24 = a3, a1, a4, a5
    for i, j in a4, v16, v19 do
        v1 = (j - v14):Dot(v17)
        if (math.abs(v1)) <= 0.01 then
            return false, 0
        end
        v2 = if not (v1 > 0) then -1 else 1
        if v18 == 0 then
            v18 = v2
        elseif v2 ~= v18 then
            return false, 0
        end
    end
    if v18 == 0 then
        return false, 0
    end
    v15 = (1 / 0)
    v16 = (-1 / 0)
    v19 = (1 / 0)
    v20 = (-1 / 0)
    v1 = nil
    v2 = nil
    for k, n in v21, v1, v2 do
        v3 = (n - v14):Dot(v17)
        if not ((math.abs(v3)) <= 0.01) and (if not (v3 > 0) then -1 else 1) ~= v18 then
            for m, i5 in v23 do
                v4 = (i5 - v14):Dot(v17) - v3
                if (math.abs(v4)) <= 1e-07 then
                    return false, 0
                end
                v5 = -v3 / v4
                if not (v5 <= 0) and not (v5 >= 1) then
                    v6 = n:Lerp(i5, v5) - v14
                    v7 = v6:Dot(v10)
                    v8 = v6:Dot(v12)
                    v15 = math.min(v15, v7)
                    v16 = math.max(v16, v7)
                    v19 = math.min(v19, v8)
                    v20 = math.max(v20, v8)
                    continue
                end
                return false, 0
            end
            continue
        end
        return false, 0
    end
    return rectangleCoverage(v22, v11, v13, v15, v16, v19, v20, v24)
end

local function projectFootprintBuffer(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11) -- Line: 733
    -- upvalues: 
    if not (a7 > 255) and not (a9 > 255) then
        local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
        local v13 = 0
        local v14 = a9 - 1
        for i = 0, v14 do
            v1 = a8 + i * 12
            v3 = buffer.readf32(a1, v1)
            v6 = v1 + 4
            v4 = buffer.readf32(a1, v6)
            v7 = v1 + 8
            v1 = Vector3.new(v3, v4, (buffer.readf32(a1, v7))) - a2
            v2 = v1:Dot(a5)
            if (math.abs(v2)) <= 0.01 then
                return false, 0, 0, 0, 0
            end
            v3 = if not (v2 > 0) then -1 else 1
            if v13 == 0 then
                v13 = v3
            elseif v3 ~= v13 then
                return false, 0, 0, 0, 0
            end
            v4 = i * 24
            buffer.writef64(a11, v4, v2)
            v7 = v4 + 8
            v8 = v1:Dot(a3)
            buffer.writef64(a11, v7, v8)
            v7 = v4 + 16
            v8 = v1:Dot(a4)
            buffer.writef64(a11, v7, v8)
        end
        if v13 == 0 then
            return false, 0, 0, 0, 0
        end
        v14 = a7 - 1
        for j = 0, v14 do
            v1 = a6 + j * 12
            v3 = buffer.readf32(a1, v1)
            v6 = v1 + 4
            v4 = buffer.readf32(a1, v6)
            v7 = v1 + 8
            v2 = (Vector3.new(v3, v4, (buffer.readf32(a1, v7))) - a2):Dot(a5)
            if not ((math.abs(v2)) <= 0.01) and (if not (v2 > 0) then -1 else 1) ~= v13 then
                continue
            end
            return false, 0, 0, 0, 0
        end
        v14 = (1 / 0)
        local v15 = (-1 / 0)
        local v16 = (1 / 0)
        local v17 = (-1 / 0)
        v1 = a7 - 1
        for k = 0, v1 do
            v4 = k * 24
            v5 = buffer.readf64(a10, v4)
            v8 = v4 + 8
            v6 = buffer.readf64(a10, v8)
            v9 = v4 + 16
            v7 = buffer.readf64(a10, v9)
            v8 = a9 - 1
            for n = 0, v8 do
                v10 = n * 24
                v11 = buffer.readf64(a11, v10) - v5
                if (math.abs(v11)) <= 1e-07 then
                    return false, 0, 0, 0, 0
                end
                v12 = -v5 / v11
                if not (v12 <= 0) and not (v12 >= 1) then
                    continue
                end
                return false, 0, 0, 0, 0
            end
        end
        return true, v14, v15, v16, v17
    end
    return false, 0, 0, 0, 0
end

local function planeCoversBuffer(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) -- Line: 820
    -- upvalues: PLANE_SIZE (val), projectFootprintBuffer (val), rectangleCoverage (val)
    local buffer_2 = a1.buffer
    local v1 = a1.planeOffset + (a2 - 1) * PLANE_SIZE
    local v2 = buffer.readf32(buffer_2, v1)
    local v3 = v1 + 4
    local v4 = buffer.readf32(buffer_2, v3)
    local v5 = v1 + 8
    local v6 = Vector3.new(v2, v4, (buffer.readf32(buffer_2, v5)))
    v4 = v1 + 12
    v3 = buffer.readf32(buffer_2, v4)
    local v7 = v4 + 4
    v5 = buffer.readf32(buffer_2, v7)
    local v8 = v4 + 8
    v2 = Vector3.new(v3, v5, (buffer.readf32(buffer_2, v8)))
    local v9 = v1 + 24
    v5 = buffer.readf32(buffer_2, v9)
    v8 = v9 + 4
    local v10 = buffer.readf32(buffer_2, v8)
    local v11 = v9 + 8
    v4 = Vector3.new(v5, v10, (buffer.readf32(buffer_2, v11)))
    v3 = v1 + 36
    v10 = buffer.readf32(buffer_2, v3)
    v11 = v3 + 4
    v7 = buffer.readf32(buffer_2, v11)
    local v12 = v3 + 8
    v9 = Vector3.new(v10, v7, (buffer.readf32(buffer_2, v12)))
    v10 = v1 + 48
    v3 = buffer.readu32(buffer_2, v10)
    v7 = v1 + 52
    v5 = buffer.readu16(buffer_2, v7)
    v10, v7, v8, v11, v12 = projectFootprintBuffer(a3, v6, v2, v4, v9, a4, a5, a6, a7, a8, a9)
    if not v10 then
        return false, 0
    end
    return rectangleCoverage(a1, v3, v5, v7, v8, v11, v12, a10)
end

local function projectBufferPoints(a1, a2, a3, a4, a5, a6, a7) -- Line: 859
    -- upvalues: PLANE_SIZE (val)
    local v1, v2, v3, v4
    if a5 > 2040 then
        return false
    end
    local buffer_2 = a1.buffer
    local v5 = a1.planeOffset + (a2 - 1) * PLANE_SIZE
    local v6 = buffer.readf32(buffer_2, v5)
    local v7 = v5 + 4
    local v8 = buffer.readf32(buffer_2, v7)
    local v9 = v5 + 8
    local v10 = Vector3.new(v6, v8, (buffer.readf32(buffer_2, v9)))
    v8 = v5 + 12
    v7 = buffer.readf32(buffer_2, v8)
    local v11 = v8 + 4
    v9 = buffer.readf32(buffer_2, v11)
    local v12 = v8 + 8
    v6 = Vector3.new(v7, v9, (buffer.readf32(buffer_2, v12)))
    local v13 = v5 + 24
    v9 = buffer.readf32(buffer_2, v13)
    v12 = v13 + 4
    local v14 = buffer.readf32(buffer_2, v12)
    local v15 = v13 + 8
    v8 = Vector3.new(v9, v14, (buffer.readf32(buffer_2, v15)))
    v7 = v5 + 36
    v14 = buffer.readf32(buffer_2, v7)
    v15 = v7 + 4
    v11 = buffer.readf32(buffer_2, v15)
    local v16 = v7 + 8
    v13 = Vector3.new(v14, v11, (buffer.readf32(buffer_2, v16)))
    v9 = a5 - 1
    for i = 0, v9 do
        v16 = a4 + i * 12
        v1 = buffer.readf32(a3, v16)
        v3 = v16 + 4
        v2 = buffer.readf32(a3, v3)
        v4 = v16 + 8
        v12 = Vector3.new(v1, v2, (buffer.readf32(a3, v4))) - v10
        v15 = ((a7 or 0) + i) * 24
        v2 = v12:Dot(v13)
        buffer.writef64(a6, v15, v2)
        v1 = v15 + 8
        v2 = v12:Dot(v6)
        buffer.writef64(a6, v1, v2)
        v1 = v15 + 16
        v2 = v12:Dot(v8)
        buffer.writef64(a6, v1, v2)
    end
    return true
end

local function projectedVolumePairCoverage(a1, a2, a3, a4, a5, a6, a7, a8, a9) -- Line: 888
    -- upvalues: PLANE_SIZE (val), RECT_SIZE (val), rectangleCoverage (val)
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15
    local v16 = 0
    local v17 = a7 + a8 - 1
    for i = a7, v17 do
        v3 = i * 24
        v1 = buffer.readf64(a6, v3)
        if (math.abs(v1)) <= 0.01 then
            return false, 0
        end
        v2 = if not (v1 > 0) then -1 else 1
        if v16 == 0 then
            v16 = v2
        elseif v2 ~= v16 then
            return false, 0
        end
    end
    if v16 == 0 then
        return false, 0
    end
    v17 = a4 + a5 - 1
    for j = a4, v17 do
        v3 = j * 24
        v1 = buffer.readf64(a3, v3)
        if not ((math.abs(v1)) <= 0.01) and (if not (v1 > 0) then -1 else 1) ~= v16 then
            continue
        end
        return false, 0
    end
    local buffer_2 = a1.buffer
    local v18 = a1.planeOffset + (a2 - 1) * PLANE_SIZE
    v2 = v18 + 48
    local v19 = buffer.readu32(buffer_2, v2)
    v3 = v18 + 52
    v1 = buffer.readu16(buffer_2, v3)
    if v1 ~= 1 then
        v2 = (1 / 0)
        v3 = (-1 / 0)
        v4 = (1 / 0)
        v5 = (-1 / 0)
        v6 = a4 + a5 - 1
        for i6 = a4, v6 do
            v7 = i6 * 24
            v8 = buffer.readf64(a3, v7)
            v11 = v7 + 8
            v9 = buffer.readf64(a3, v11)
            v12 = v7 + 16
            v10 = buffer.readf64(a3, v12)
            v11 = a7 + a8 - 1
            for i7 = a7, v11 do
                v13 = i7 * 24
                v14 = buffer.readf64(a6, v13) - v8
                if (math.abs(v14)) <= 1e-07 then
                    return false, 0
                end
                v15 = -v8 / v14
                if not (v15 <= 0) and not (v15 >= 1) then
                    continue
                end
                return false, 0
            end
        end
        return rectangleCoverage(a1, v19, v1, v2, v3, v4, v5, a9)
    end
    v2 = a1.rectangleOffset + (v19 - 1) * RECT_SIZE
    v3 = buffer.readf32(buffer_2, v2) + 0.02
    local v20 = v2 + 4
    v4 = buffer.readf32(buffer_2, v20) - 0.02
    local v21 = v2 + 8
    v5 = buffer.readf32(buffer_2, v21) + 0.02
    v7 = v2 + 12
    v6 = buffer.readf32(buffer_2, v7) - 0.02
    v20 = a4 * 24
    v21 = a7 * 24
    v7 = buffer.readf64(a3, v20)
    v9 = buffer.readf64(a6, v21) - v7
    if (math.abs(v9)) <= 1e-07 then
        return false, 0
    end
    v10 = -v7 / v9
    if not (v10 <= 0) and not (v10 >= 1) then
        local v22 = v20 + 8
        v11 = buffer.readf64(a3, v22)
        v13 = v20 + 16
        v12 = buffer.readf64(a3, v13)
        local v23 = v21 + 8
        v22 = v11 + (buffer.readf64(a6, v23) - v11) * v10
        local v24 = v21 + 16
        v13 = v12 + (buffer.readf64(a6, v24) - v12) * v10
        if not (v22 < v3) and not (v4 < v22) and not (v13 < v5) and not (v6 < v13) then
            local v25, v26, v27, v28, v29
            local v30 = (1 / 0)
            v14 = (-1 / 0)
            v15 = (1 / 0)
            v23 = (-1 / 0)
            v24 = a4 + a5 - 1
            for k = a4, v24 do
                v25 = k * 24
                v28 = v25 + 8
                v26 = buffer.readf64(a3, v28)
                v29 = v25 + 16
                v27 = buffer.readf64(a3, v29)
                v30 = math.min(v30, v26)
                v14 = math.max(v14, v26)
                v15 = math.min(v15, v27)
                v23 = math.max(v23, v27)
            end
            v24 = a7 + a8 - 1
            for n = a7, v24 do
                v25 = n * 24
                v28 = v25 + 8
                v26 = buffer.readf64(a6, v28)
                v29 = v25 + 16
                v27 = buffer.readf64(a6, v29)
                v30 = math.min(v30, v26)
                v14 = math.max(v14, v26)
                v15 = math.min(v15, v27)
                v23 = math.max(v23, v27)
            end
            if v3 <= v30 and v14 <= v4 and v5 <= v15 and v23 <= v6 then
                if a9 then
                    a9.rectangles = a9.rectangles + 1
                end
                return true, 1
            end
            v2 = (1 / 0)
            v3 = (-1 / 0)
            v4 = (1 / 0)
            v5 = (-1 / 0)
            v6 = a4 + a5 - 1
            for m = a4, v6 do
                v7 = m * 24
                v8 = buffer.readf64(a3, v7)
                v11 = v7 + 8
                v9 = buffer.readf64(a3, v11)
                v12 = v7 + 16
                v10 = buffer.readf64(a3, v12)
                v11 = a7 + a8 - 1
                for i5 = a7, v11 do
                    v13 = i5 * 24
                    v14 = buffer.readf64(a6, v13) - v8
                    if (math.abs(v14)) <= 1e-07 then
                        return false, 0
                    end
                    v15 = -v8 / v14
                    if not (v15 <= 0) and not (v15 >= 1) then
                        continue
                    end
                    return false, 0
                end
            end
            return rectangleCoverage(a1, v19, v1, v2, v3, v4, v5, a9)
        end
        return false, 0
    end
    return false, 0
end

local function nextPlaneMark(a1) -- Line: 1028
    local v1 = a1.PlaneMarkToken + 1
    if v1 >= 4294967295 then
        buffer.fill(a1.PlaneMarks, 0, 0)
        v1 = 1
    end
    a1.PlaneMarkToken = v1
    return v1
end

local function markPlane(a1, a2, a3) -- Line: 1038 -- types: a2: number, a3: number
    local v1 = (a2 - 1) * 4
    local PlaneMarks = a1.PlaneMarks
    if buffer.readu32(PlaneMarks, v1) == a3 then
        return false
    end
    local PlaneMarks_2 = a1.PlaneMarks
    buffer.writeu32(PlaneMarks_2, v1, a3)
    return true
end

function u5.ProveProjectedOccluded(a1, a2, a3, a4, a5) -- Line: 1047
    -- upvalues: planeCovers (val)
    if #a2 ~= 0 and not (#a3 < 4) then
        local v1, v2
        local Data = a1.Data
        if a4 ~= nil and a4 >= 1 and a4 <= Data.planeCount then
            if a5 then
                a5.planes = a5.planes + 1
            end
            local v3, v4 = planeCovers(Data, a4, a2, a3, a5)
            if v3 then
                return true, a4, v4
            end
        end
        local planeCount = Data.planeCount
        for i = 1, planeCount do
            if i ~= a4 then
                if a5 then
                    a5.planes = a5.planes + 1
                end
                v2, v1 = planeCovers(Data, i, a2, a3, a5)
                if v2 then
                    return true, i, v1
                end
            end
        end
        return false, nil, 0
    end
    return false, nil, 0
end

local function findCertificate(a1, a2) -- Line: 1082 -- upvalues: CERTIFICATE_SIZE (val) -- types: a2: number
    local v1, v2, v3, v4, v5, v6
    local buffer_2 = a1.buffer
    local v7 = 1
    local certificateCount = a1.certificateCount
    local v8, v9 = a1, a2
    while v7 <= certificateCount do
        v3 = math.floor((v7 + certificateCount) * 0.5)
        v4 = v8.certificateOffset + (v3 - 1) * CERTIFICATE_SIZE
        v5 = buffer.readu32(buffer_2, v4)
        if v5 == v9 then
            v1 = v4 + 4
            v6 = buffer.readu32(buffer_2, v1)
            v2 = v4 + 8
            return v6, (buffer.readu16(buffer_2, v2))
        end
        if not (v5 < v9) then
            certificateCount = v3 - 1
        else
            v7 = v3 + 1
        end
    end
    return nil, nil
end

local function beginCandidatePlanes(a1, a2) -- Line: 1101 -- types: a2: number?
    local CandidatePlanes = a1.CandidatePlanes
    table.clear(CandidatePlanes)
    local v1 = a1.PlaneMarkToken + 1
    if v1 >= 4294967295 then
        buffer.fill(a1.PlaneMarks, 0, 0)
        v1 = 1
    end
    a1.PlaneMarkToken = v1
    local Data = a1.Data
    if a2 ~= nil and a2 >= 1 and a2 <= Data.planeCount then
        local v2 = (a2 - 1) * 4
        local PlaneMarks = a1.PlaneMarks
        if buffer.readu32(PlaneMarks, v2) ~= v1 then
            local PlaneMarks_2 = a1.PlaneMarks
            buffer.writeu32(PlaneMarks_2, v2, v1)
        end
        CandidatePlanes[1] = a2
    end
    return v1, CandidatePlanes
end

local function appendCertificatePlanes(a1, a2, a3, a4, a5) -- Line: 1113
    -- upvalues: findCertificate (val), CANDIDATE_SIZE (val)
    local v1
    local Data = a1.Data
    local v2 = findCertificate
    local v3 = math.min(a4, a5)
    local v4 = math.max(a4, a5)
    v2, v1 = v2(Data, (bit32.bor(bit32.lshift(v3, 16), v4)))
    if v2 ~= nil and v1 ~= nil then
        local PlaneMarks, PlaneMarks_2, buffer_2, v5, v6, v7
        local v8 = v2 + v1 - 1
        local v9, v10 = a1, a2
        for i = v2, v8 do
            buffer_2 = Data.buffer
            v7 = Data.candidateOffset + (i - 1) * CANDIDATE_SIZE
            v5 = buffer.readu16(buffer_2, v7)
            v7 = (v5 - 1) * 4
            PlaneMarks = v9.PlaneMarks
            if buffer.readu32(PlaneMarks, v7) ~= v10 then
                PlaneMarks_2 = v9.PlaneMarks
                buffer.writeu32(PlaneMarks_2, v7, v10)
                v6 = true
            else
                v6 = false
            end
            if v6 then
                v11[#v11 + 1] = v5
            end
        end
        return
    end
end

local function candidatePlanesForCells(a1, a2, a3, a4) -- Line: 1133
    -- upvalues: appendCertificatePlanes (val)
    local v1
    local CandidatePlanes = a1.CandidatePlanes
    table.clear(CandidatePlanes)
    local v2 = a1.PlaneMarkToken + 1
    if v2 >= 4294967295 then
        buffer.fill(a1.PlaneMarks, 0, 0)
        v2 = 1
    end
    a1.PlaneMarkToken = v2
    local Data = a1.Data
    if a4 ~= nil and a4 >= 1 and a4 <= Data.planeCount then
        local v3 = (a4 - 1) * 4
        local PlaneMarks = a1.PlaneMarks
        if buffer.readu32(PlaneMarks, v3) ~= v2 then
            local PlaneMarks_2 = a1.PlaneMarks
            buffer.writeu32(PlaneMarks_2, v3, v2)
        end
        CandidatePlanes[1] = a4
    end
    local v4 = v2
    v2 = nil
    local v5 = nil
    for i, j in a2, v2, v5 do
        for k, n in a3 do
            appendCertificatePlanes(v6, v4, CandidatePlanes, j, n)
        end
    end
    return v1
end

local function candidatePlanesForCellBuffer(a1, a2, a3, a4, a5, a6, a7) -- Line: 1148
    -- upvalues: appendCertificatePlanes (val)
    local v1, v2, v3, v4
    local CandidatePlanes = a1.CandidatePlanes
    table.clear(CandidatePlanes)
    local v5 = a1.PlaneMarkToken + 1
    if v5 >= 4294967295 then
        buffer.fill(a1.PlaneMarks, 0, 0)
        v5 = 1
    end
    a1.PlaneMarkToken = v5
    local Data = a1.Data
    if a7 ~= nil and a7 >= 1 and a7 <= Data.planeCount then
        v1 = (a7 - 1) * 4
        local PlaneMarks = a1.PlaneMarks
        if buffer.readu32(PlaneMarks, v1) ~= v5 then
            local PlaneMarks_2 = a1.PlaneMarks
            buffer.writeu32(PlaneMarks_2, v1, v5)
        end
        CandidatePlanes[1] = a7
    end
    local v6 = CandidatePlanes
    local v7 = a4 - 1
    local v8, v9, v10, v11, v12 = a3, a2, a6, a1, a5
    for i = 0, v7 do
        v3 = v8 + i * 2
        v1 = buffer.readu16(v9, v3)
        v2 = v10 - 1
        for j = 0, v2 do
            v4 = v12 + j * 2
            appendCertificatePlanes(v11, v5, v6, v1, (buffer.readu16(v9, v4)))
        end
    end
    return v6
end

function u5.ProveProjectedOccludedForCells(a1, a2, a3, a4, a5, a6, a7) -- Line: 1168
    -- upvalues: planeCovers (val), findCertificate (val), CANDIDATE_SIZE (val)
    if #a4 ~= 0 and not (#a5 < 4) and #a2 ~= 0 and #a3 ~= 0 then
        local PlaneMarks_3, PlaneMarks_4, buffer_2, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
        local Data = a1.Data
        if a6 ~= nil and a6 >= 1 and a6 <= Data.planeCount then
            if a7 then
                a7.planes = a7.planes + 1
            end
            v11, v12 = planeCovers(Data, a6, a4, a5, a7)
            if v11 then
                return true, a6, v12
            end
        end
        v11 = a1.PlaneMarkToken + 1
        if v11 >= 4294967295 then
            buffer.fill(a1.PlaneMarks, 0, 0)
            v11 = 1
        end
        a1.PlaneMarkToken = v11
        if a6 ~= nil then
            v12 = (a6 - 1) * 4
            local PlaneMarks = a1.PlaneMarks
            if buffer.readu32(PlaneMarks, v12) ~= v11 then
                local PlaneMarks_2 = a1.PlaneMarks
                buffer.writeu32(PlaneMarks_2, v12, v11)
            end
        end
        local v13 = nil
        local v14 = nil
        for i, j in a2, v13, v14 do
            v1 = nil
            v2 = nil
            for k, n in a3, v1, v2 do
                v3 = findCertificate
                v6 = math.min(j, n)
                v7 = math.max(j, n)
                v3, v4 = v3(Data, (bit32.bor(bit32.lshift(v6, 16), v7)))
                if v3 ~= nil and v4 ~= nil then
                    v5 = v3 + v4 - 1
                    for m = v3, v5 do
                        buffer_2 = Data.buffer
                        v10 = Data.candidateOffset + (m - 1) * CANDIDATE_SIZE
                        v8 = buffer.readu16(buffer_2, v10)
                        v10 = (v8 - 1) * 4
                        PlaneMarks_3 = a1.PlaneMarks
                        if buffer.readu32(PlaneMarks_3, v10) ~= v11 then
                            PlaneMarks_4 = a1.PlaneMarks
                            buffer.writeu32(PlaneMarks_4, v10, v11)
                            v9 = true
                        else
                            v9 = false
                        end
                        if v9 then
                            if a7 then
                                a7.planes = a7.planes + 1
                            end
                            v9, v10 = planeCovers(Data, v8, a4, a5, a7)
                            if v9 then
                                return true, v8, v10
                            end
                        end
                    end
                end
            end
        end
        return false, nil, 0
    end
    return false, nil, 0
end

function u5.ProveProjectedOccludedForVolumeGroups(a1, a2, a3, a4, a5, a6, a7) -- Line: 1220
    -- upvalues: candidatePlanesForCells (val), planeCovers (val)
    if #a4 ~= 0 and #a5 ~= 0 then
        local v1, v2, v3, v4, v5, v6, v7, v8, v9
        local v10 = candidatePlanesForCells(a1, a2, a3, a6)
        if #v10 == 0 then
            return false, nil, 0
        end
        local v11 = nil
        local v12 = 0
        local v13 = nil
        local v14 = nil
        local v15, v16, v17 = a5, a1, a7
        for i, j in a4, v13, v14 do
            v1 = nil
            v2 = nil
            for k, n in v15, v1, v2 do
                v3 = false
                v4 = nil
                v5 = 0
                v6 = nil
                v7 = nil
                for m, i5 in v10, v6, v7 do
                    if v17 then
                        v17.planes = v17.planes + 1
                    end
                    v8, v9 = planeCovers(v16.Data, i5, j, n, v17)
                    if v8 then
                        v3 = true
                        v4 = i5
                        v5 = v9
                        break
                    end
                end
                if not v3 then
                    return false, nil, 0
                end
                if v11 == nil then
                    v11 = v4
                end
                v12 = v12 + v5
            end
        end
        return true, v11, v12
    end
    return false, nil, 0
end

function u5.ProveProjectedOccludedForVolumeGroupBuffer(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) -- Line: 1268
    -- upvalues: candidatePlanesForCellBuffer (val), projectBufferPoints (val), projectedVolumePairCoverage (val)
    if a4 ~= 0 and a6 ~= 0 and a8 ~= 0 and a10 ~= 0 then
        local v1 = candidatePlanesForCellBuffer(a1, a2, a3, a4, a5, a6, a11)
        if #v1 == 0 then
            return false, nil, 0
        end
        if not (a8 > 255) and not (a10 > 255) then
            local v2, v3, v4, v5, v6, v7, v8, v9
            local v10 = a8 * a10
            local VolumePairMarks = a1.VolumePairMarks
            buffer.fill(VolumePairMarks, 0, 0, v10)
            local v11 = v10
            local v12 = nil
            local v13 = 0
            local v14 = nil
            local v15 = nil
            local v16, v17, v18, v19, v20, v21, v22 = a1, a2, a7, a8, a9, a10, a12
            for i, j in v1, v14, v15 do
                if projectBufferPoints(v16.Data, j, v17, v18, v19 * 8, v16.ViewerProjectionScratch)
                    and projectBufferPoints(v16.Data, j, v17, v20, v21 * 8, v16.TargetProjectionScratch) then
                    if v19 > 1 then
                        v2 = v21 - 1
                        for k = 0, v2 do
                            v3 = 0
                            v4 = v19 - 1
                            for n = 0, v4 do
                                v7 = n * v21 + k
                                if buffer.readu8(VolumePairMarks, v7) == 0 then
                                    v3 = v3 + 1
                                end
                            end
                            if v3 ~= 0 then
                                if v22 then
                                    v22.planes = v22.planes + 1
                                end
                                v4, v5 = projectedVolumePairCoverage(
                                    v16.Data,
                                    j,
                                    v16.ViewerProjectionScratch,
                                    0,
                                    v19 * 8,
                                    v16.TargetProjectionScratch,
                                    k * 8,
                                    8,
                                    v22
                                )
                                if v4 then
                                    v6 = v19 - 1
                                    for m = 0, v6 do
                                        v9 = m * v21 + k
                                        if buffer.readu8(VolumePairMarks, v9) == 0 then
                                            buffer.writeu8(VolumePairMarks, v9, 1)
                                            v11 = v11 - 1
                                        end
                                    end
                                    v12 = v12 or j
                                    v13 = v13 + v5 * v3
                                end
                            end
                        end
                        if v11 == 0 then
                            return true, v12, v13
                        end
                    end
                    v2 = v19 - 1
                    for i5 = 0, v2 do
                        v3 = v21 - 1
                        for i6 = 0, v3 do
                            v6 = i5 * v21 + i6
                            if buffer.readu8(VolumePairMarks, v6) == 0 then
                                if v22 then
                                    v22.planes = v22.planes + 1
                                end
                                v7, v8 = projectedVolumePairCoverage(
                                    v16.Data,
                                    j,
                                    v16.ViewerProjectionScratch,
                                    i5 * 8,
                                    8,
                                    v16.TargetProjectionScratch,
                                    i6 * 8,
                                    8,
                                    v22
                                )
                                if v7 then
                                    buffer.writeu8(VolumePairMarks, v6, 1)
                                    v11 = v11 - 1
                                    v12 = v12 or j
                                    v13 = v13 + v8
                                end
                            end
                        end
                    end
                    if v11 ~= 0 then
                        continue
                    end
                    return true, v12, v13
                end
                return false, nil, 0
            end
            return false, nil, 0
        end
        return false, nil, 0
    end
    return false, nil, 0
end

local function ensureBatchScratch(a1, a2, a3) -- Line: 1405 -- types: a2: number, a3: number
    local v1 = math.max(a2, 1) * 24
    if buffer.len(a1.BatchProjectionScratch) < v1 then
        a1.BatchProjectionScratch = buffer.create(v1)
    end
    if (buffer.len(a1.BatchVolumePairMarks)) < math.max(a3, 1) then
        a1.BatchVolumePairMarks = buffer.create((math.max(a3, 1)))
    end
end

function u5.ProveProjectedOccludedActorBatchBuffer(a1, a2, a3, a4, a5) -- Line: 1416
    -- upvalues: candidatePlanesForCellBuffer (val), ensureBatchScratch (val), projectBufferPoints (val)
    -- upvalues: projectedVolumePairCoverage (val)
    local Data, Data_2, FallbackTargetCount, FallbackTargetOffset, FallbackTargetProjectionIndex, FallbackViewerCount, FallbackViewerOffset, FallbackViewerProjectionIndex, PreferredPlane, Proved, Query, Query_2, TargetActor, TargetActor_2, TargetActor_3, TargetPointCount, TargetPointCount_2, TargetPointsOffset, TargetPointsOffset_2, TargetProjectionIndex, TargetProjectionIndex_2, ViewerActor, ViewerActor_2, ViewerActor_3, ViewerActor_4, ViewerPointCount, ViewerPointCount_2, ViewerPointCount_3, ViewerPointCount_4, ViewerPointsOffset, ViewerPointsOffset_2, ViewerPointsOffset_3, ViewerProjectionIndex, ViewerProjectionIndex_2, ViewerProjectionIndex_3, ViewerProjectionIndex_4, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31
    local v32 = table.create(#a3)
    local v33 = 0
    for i, j in a3 do
        v1 = {
            TargetProjectionIndex = 0,
            FallbackViewerProjectionIndex = 0,
            FallbackTargetProjectionIndex = 0,
            CellsOffset = j.CellsOffset,
            CellCount = j.CellCount,
            ViewerPointsOffset = j.ViewerPointsOffset,
            ViewerPointCount = j.ViewerPointCount,
            TargetPointsOffset = j.TargetPointsOffset,
            TargetPointCount = j.TargetPointCount,
            FallbackViewerOffset = j.FallbackViewerOffset,
            FallbackViewerCount = j.FallbackViewerCount,
            FallbackTargetOffset = j.FallbackTargetOffset,
            FallbackTargetCount = j.FallbackTargetCount,
            ViewerProjectionIndex = v33,
        }
        v33 = v33 + j.ViewerPointCount
        v1.TargetProjectionIndex = v33
        v33 = v33 + j.TargetPointCount
        v1.FallbackViewerProjectionIndex = v33
        v33 = v33 + j.FallbackViewerCount * 8
        v1.FallbackTargetProjectionIndex = v33
        v33 = v33 + j.FallbackTargetCount * 8
        v32[i] = v1
    end
    local v34 = table.create(#a4)
    local v35 = {}
    local v36 = {}
    local v37 = {}
    local v38 = 0
    local v39 = nil
    local v40 = nil
    local v41, v42, v43 = a3, a4, a5
    for k, n in a4, v39, v40 do
        v2 = v32[n.ViewerActor]
        v3 = v32[n.TargetActor]
        v4 = {}
        v5 = 0
        if v2 ~= nil and v3 ~= nil then
            if not n.Fallback then
                v6 = false
                if 0 < v2.ViewerPointCount then
                    v6 = 4 <= v3.TargetPointCount
                end
            else
                v6 = false
                if 0 < v2.FallbackViewerCount then
                    v6 = 0 < v3.FallbackTargetCount
                end
            end
            if v6 and 0 < v2.CellCount and 0 < v3.CellCount then
                v7 = candidatePlanesForCellBuffer(a1, a2, v2.CellsOffset, v2.CellCount, v3.CellsOffset, v3.CellCount, n.PreferredPlane)
                v8 = nil
                v9 = nil
                for m, i5 in v7, v8, v9 do
                    v4[#v4 + 1] = i5
                    v12 = v35[i5]
                    if v12 == nil then
                        v35[i5] = {}
                    end
                    v12[#v12 + 1] = k
                    if not v37[i5] then
                        v37[i5] = true
                        v36[#v36 + 1] = i5
                    end
                end
            end
            if n.Fallback then
                v5 = v2.FallbackViewerCount * v3.FallbackTargetCount
            end
        end
        v34[k] = {
            ProofLeaves = 0,
            Proved = false,
            Tests = 0,
            Query = n,
            Planes = v4,
            MarkOffset = v38,
            RemainingPairs = v5,
        }
        v38 = v38 + v5
    end
    ensureBatchScratch(a1, v33, v38)
    local BatchProjectionScratch = a1.BatchProjectionScratch
    local BatchVolumePairMarks = a1.BatchVolumePairMarks
    if v38 > 0 then
        buffer.fill(BatchVolumePairMarks, 0, 0, v38)
    end
    v40 = table.create(#v41, 0)
    local v44 = table.create(#v41, 0)
    local v45 = table.create(#v41, 0)
    v2 = table.create(#v41, 0)
    local u1137 = 0
    v4 = 0

    local function ensureProjected(a1_2, a2_2, a3, a4, a5, a6) -- Line: 1520
        -- upvalues: projectBufferPoints (upval), a1 (val), a2 (val), BatchProjectionScratch (val), u1137 (ref)
        if a6[a1_2] == a2_2 then
            return true
        end
        if not projectBufferPoints(a1.Data, a2_2, a2, a3, a4, BatchProjectionScratch, a5) then
            return false
        end
        a6[a1_2] = a2_2
        u1137 = u1137 + 1
        return true
    end

    local v46 = nil
    v7 = nil
    for i6, i7 in v34, v46, v7 do
        Query_2 = i7.Query
        PreferredPlane = Query_2.PreferredPlane
        if PreferredPlane ~= nil and not Query_2.Fallback and not i7.Proved and i7.Planes[1] == PreferredPlane then
            v12 = v32[Query_2.ViewerActor]
            v13 = v32[Query_2.TargetActor]
            if v12 ~= nil and v13 ~= nil then
                ViewerActor_4 = Query_2.ViewerActor
                ViewerPointsOffset_3 = v12.ViewerPointsOffset
                ViewerPointCount_4 = v12.ViewerPointCount
                ViewerProjectionIndex_4 = v12.ViewerProjectionIndex
                if v40[ViewerActor_4] == PreferredPlane then
                    v14 = true
                elseif projectBufferPoints(
                    a1.Data,
                    PreferredPlane,
                    a2,
                    ViewerPointsOffset_3,
                    ViewerPointCount_4,
                    BatchProjectionScratch,
                    ViewerProjectionIndex_4
                ) then
                    v40[ViewerActor_4] = PreferredPlane
                    u1137 = u1137 + 1
                    v14 = true
                else
                    v14 = false
                end
                if v14 then
                    TargetActor_3 = Query_2.TargetActor
                    TargetPointsOffset_2 = v13.TargetPointsOffset
                    TargetPointCount_2 = v13.TargetPointCount
                    TargetProjectionIndex_2 = v13.TargetProjectionIndex
                    if v44[TargetActor_3] == PreferredPlane then
                        v14 = true
                    elseif projectBufferPoints(
                        a1.Data,
                        PreferredPlane,
                        a2,
                        TargetPointsOffset_2,
                        TargetPointCount_2,
                        BatchProjectionScratch,
                        TargetProjectionIndex_2
                    ) then
                        v44[TargetActor_3] = PreferredPlane
                        u1137 = u1137 + 1
                        v14 = true
                    else
                        v14 = false
                    end
                    if v14 then
                        if v43 then
                            v43.planes = v43.planes + 1
                        end
                        v4 = v4 + 1
                        i7.Tests = i7.Tests + 1
                        v14, v15 = projectedVolumePairCoverage(
                            a1.Data,
                            PreferredPlane,
                            BatchProjectionScratch,
                            v12.ViewerProjectionIndex,
                            v12.ViewerPointCount,
                            BatchProjectionScratch,
                            v13.TargetProjectionIndex,
                            v13.TargetPointCount,
                            v43
                        )
                        if v14 then
                            i7.Proved = true
                            i7.FirstPlane = PreferredPlane
                            i7.ProofLeaves = v15
                        end
                    end
                end
            end
        end
    end
    v46 = nil
    v7 = nil
    for i8, i9 in v36, v46, v7 do
        v10 = v35[i9]
        if v10 ~= nil then
            v12 = nil
            v13 = nil
            for i10, i11 in v10, v12, v13 do
                v16 = v34[i11]
                if not v16.Proved and not (24 <= v16.Tests) then
                    Query = v16.Query
                    v17 = v32[Query.ViewerActor]
                    v18 = v32[Query.TargetActor]
                    if v17 ~= nil and v18 ~= nil then
                        if Query.PreferredPlane ~= i9 then
                            if v43 then
                                v43.planes = v43.planes + 1
                            end
                            v16.Tests = v16.Tests + 1
                            if Query.Fallback then
                                ViewerActor_2 = Query.ViewerActor
                                ViewerPointsOffset_2 = v17.ViewerPointsOffset
                                ViewerPointCount_2 = v17.ViewerPointCount
                                ViewerProjectionIndex_2 = v17.ViewerProjectionIndex
                                if v40[ViewerActor_2] == i9 then
                                    v19 = true
                                elseif projectBufferPoints(
                                    a1.Data,
                                    i9,
                                    a2,
                                    ViewerPointsOffset_2,
                                    ViewerPointCount_2,
                                    BatchProjectionScratch,
                                    ViewerProjectionIndex_2
                                ) then
                                    v40[ViewerActor_2] = i9
                                    u1137 = u1137 + 1
                                    v19 = true
                                else
                                    v19 = false
                                end
                                if v19 then
                                    TargetActor_2 = Query.TargetActor
                                    FallbackTargetOffset = v18.FallbackTargetOffset
                                    v22 = v18.FallbackTargetCount * 8
                                    FallbackTargetProjectionIndex = v18.FallbackTargetProjectionIndex
                                    if v2[TargetActor_2] == i9 then
                                        v19 = true
                                    elseif projectBufferPoints(
                                        a1.Data,
                                        i9,
                                        a2,
                                        FallbackTargetOffset,
                                        v22,
                                        BatchProjectionScratch,
                                        FallbackTargetProjectionIndex
                                    ) then
                                        v2[TargetActor_2] = i9
                                        u1137 = u1137 + 1
                                        v19 = true
                                    else
                                        v19 = false
                                    end
                                    if v19 then
                                        FallbackViewerCount = v17.FallbackViewerCount
                                        FallbackTargetCount = v18.FallbackTargetCount
                                        if FallbackViewerCount > 1 then
                                            v21 = FallbackTargetCount - 1
                                            for i12 = 0, v21 do
                                                v23 = 0
                                                v24 = FallbackViewerCount - 1
                                                for i13 = 0, v24 do
                                                    v27 = v16.MarkOffset + i13 * FallbackTargetCount + i12
                                                    if buffer.readu8(BatchVolumePairMarks, v27) == 0 then
                                                        v23 = v23 + 1
                                                    end
                                                end
                                                if v23 ~= 0 then
                                                    v4 = v4 + 1
                                                    v24 = projectedVolumePairCoverage
                                                    Data = a1.Data
                                                    ViewerProjectionIndex_3 = v17.ViewerProjectionIndex
                                                    ViewerPointCount_3 = v17.ViewerPointCount
                                                    v30 = v18.FallbackTargetProjectionIndex + i12 * 8
                                                    v24, v25 = v24(
                                                        Data,
                                                        i9,
                                                        BatchProjectionScratch,
                                                        ViewerProjectionIndex_3,
                                                        ViewerPointCount_3,
                                                        BatchProjectionScratch,
                                                        v30,
                                                        8,
                                                        v43
                                                    )
                                                    if v24 then
                                                        v26 = FallbackViewerCount - 1
                                                        for i14 = 0, v26 do
                                                            v29 = v16.MarkOffset + i14 * FallbackTargetCount + i12
                                                            if buffer.readu8(BatchVolumePairMarks, v29) == 0 then
                                                                buffer.writeu8(BatchVolumePairMarks, v29, 1)
                                                                v16.RemainingPairs = v16.RemainingPairs - 1
                                                            end
                                                        end
                                                        v16.FirstPlane = v16.FirstPlane or i9
                                                        v16.ProofLeaves = v16.ProofLeaves + v25 * v23
                                                    end
                                                end
                                            end
                                        end
                                        if 0 < v16.RemainingPairs then
                                            ViewerActor_3 = Query.ViewerActor
                                            FallbackViewerOffset = v17.FallbackViewerOffset
                                            v23 = FallbackViewerCount * 8
                                            FallbackViewerProjectionIndex = v17.FallbackViewerProjectionIndex
                                            if v45[ViewerActor_3] == i9 then
                                                v21 = true
                                            elseif projectBufferPoints(
                                                a1.Data,
                                                i9,
                                                a2,
                                                FallbackViewerOffset,
                                                v23,
                                                BatchProjectionScratch,
                                                FallbackViewerProjectionIndex
                                            ) then
                                                v45[ViewerActor_3] = i9
                                                u1137 = u1137 + 1
                                                v21 = true
                                            else
                                                v21 = false
                                            end
                                            if v21 then
                                                v21 = FallbackViewerCount - 1
                                                for i15 = 0, v21 do
                                                    v23 = FallbackTargetCount - 1
                                                    for i16 = 0, v23 do
                                                        v26 = v16.MarkOffset + i15 * FallbackTargetCount + i16
                                                        if buffer.readu8(BatchVolumePairMarks, v26) == 0 then
                                                            v4 = v4 + 1
                                                            v27 = projectedVolumePairCoverage
                                                            Data_2 = a1.Data
                                                            v30 = v17.FallbackViewerProjectionIndex + i15 * 8
                                                            v31 = v18.FallbackTargetProjectionIndex + i16 * 8
                                                            v27, v28 = v27(
                                                                Data_2,
                                                                i9,
                                                                BatchProjectionScratch,
                                                                v30,
                                                                8,
                                                                BatchProjectionScratch,
                                                                v31,
                                                                8,
                                                                v43
                                                            )
                                                            if v27 then
                                                                buffer.writeu8(BatchVolumePairMarks, v26, 1)
                                                                v16.RemainingPairs = v16.RemainingPairs - 1
                                                                v16.FirstPlane = v16.FirstPlane or i9
                                                                v16.ProofLeaves = v16.ProofLeaves + v28
                                                            end
                                                        end
                                                    end
                                                end
                                                if v16.RemainingPairs == 0 then
                                                    v16.Proved = true
                                                end
                                            end
                                        elseif v16.RemainingPairs == 0 then
                                            v16.Proved = true
                                        end
                                    end
                                end
                            else
                                ViewerActor = Query.ViewerActor
                                ViewerPointsOffset = v17.ViewerPointsOffset
                                ViewerPointCount = v17.ViewerPointCount
                                ViewerProjectionIndex = v17.ViewerProjectionIndex
                                if v40[ViewerActor] == i9 then
                                    v19 = true
                                elseif projectBufferPoints(
                                    a1.Data,
                                    i9,
                                    a2,
                                    ViewerPointsOffset,
                                    ViewerPointCount,
                                    BatchProjectionScratch,
                                    ViewerProjectionIndex
                                ) then
                                    v40[ViewerActor] = i9
                                    u1137 = u1137 + 1
                                    v19 = true
                                else
                                    v19 = false
                                end
                                if v19 then
                                    TargetActor = Query.TargetActor
                                    TargetPointsOffset = v18.TargetPointsOffset
                                    TargetPointCount = v18.TargetPointCount
                                    TargetProjectionIndex = v18.TargetProjectionIndex
                                    if v44[TargetActor] == i9 then
                                        v19 = true
                                    elseif projectBufferPoints(
                                        a1.Data,
                                        i9,
                                        a2,
                                        TargetPointsOffset,
                                        TargetPointCount,
                                        BatchProjectionScratch,
                                        TargetProjectionIndex
                                    ) then
                                        v44[TargetActor] = i9
                                        u1137 = u1137 + 1
                                        v19 = true
                                    else
                                        v19 = false
                                    end
                                    if v19 then
                                        v4 = v4 + 1
                                        v19, v20 = projectedVolumePairCoverage(
                                            a1.Data,
                                            i9,
                                            BatchProjectionScratch,
                                            v17.ViewerProjectionIndex,
                                            v17.ViewerPointCount,
                                            BatchProjectionScratch,
                                            v18.TargetProjectionIndex,
                                            v18.TargetPointCount,
                                            v43
                                        )
                                        if v19 then
                                            v16.Proved = true
                                            v16.FirstPlane = i9
                                            v16.ProofLeaves = v20
                                        end
                                    end
                                end
                            end
                        elseif not (0 < v16.Tests) then
                            if v43 then
                                v43.planes = v43.planes + 1
                            end
                            v16.Tests = v16.Tests + 1
                            if Query.Fallback then
                                ViewerActor_2 = Query.ViewerActor
                                ViewerPointsOffset_2 = v17.ViewerPointsOffset
                                ViewerPointCount_2 = v17.ViewerPointCount
                                ViewerProjectionIndex_2 = v17.ViewerProjectionIndex
                                if v40[ViewerActor_2] == i9 then
                                    v19 = true
                                elseif projectBufferPoints(
                                    a1.Data,
                                    i9,
                                    a2,
                                    ViewerPointsOffset_2,
                                    ViewerPointCount_2,
                                    BatchProjectionScratch,
                                    ViewerProjectionIndex_2
                                ) then
                                    v40[ViewerActor_2] = i9
                                    u1137 = u1137 + 1
                                    v19 = true
                                else
                                    v19 = false
                                end
                                if v19 then
                                    TargetActor_2 = Query.TargetActor
                                    FallbackTargetOffset = v18.FallbackTargetOffset
                                    v22 = v18.FallbackTargetCount * 8
                                    FallbackTargetProjectionIndex = v18.FallbackTargetProjectionIndex
                                    if v2[TargetActor_2] == i9 then
                                        v19 = true
                                    elseif projectBufferPoints(
                                        a1.Data,
                                        i9,
                                        a2,
                                        FallbackTargetOffset,
                                        v22,
                                        BatchProjectionScratch,
                                        FallbackTargetProjectionIndex
                                    ) then
                                        v2[TargetActor_2] = i9
                                        u1137 = u1137 + 1
                                        v19 = true
                                    else
                                        v19 = false
                                    end
                                    if v19 then
                                        FallbackViewerCount = v17.FallbackViewerCount
                                        FallbackTargetCount = v18.FallbackTargetCount
                                        if FallbackViewerCount > 1 then
                                            v21 = FallbackTargetCount - 1
                                            for i17 = 0, v21 do
                                                v23 = 0
                                                v24 = FallbackViewerCount - 1
                                                for i18 = 0, v24 do
                                                    v27 = v16.MarkOffset + i18 * FallbackTargetCount + i17
                                                    if buffer.readu8(BatchVolumePairMarks, v27) == 0 then
                                                        v23 = v23 + 1
                                                    end
                                                end
                                                if v23 ~= 0 then
                                                    v4 = v4 + 1
                                                    v24 = projectedVolumePairCoverage
                                                    Data = a1.Data
                                                    ViewerProjectionIndex_3 = v17.ViewerProjectionIndex
                                                    ViewerPointCount_3 = v17.ViewerPointCount
                                                    v30 = v18.FallbackTargetProjectionIndex + i17 * 8
                                                    v24, v25 = v24(
                                                        Data,
                                                        i9,
                                                        BatchProjectionScratch,
                                                        ViewerProjectionIndex_3,
                                                        ViewerPointCount_3,
                                                        BatchProjectionScratch,
                                                        v30,
                                                        8,
                                                        v43
                                                    )
                                                    if v24 then
                                                        v26 = FallbackViewerCount - 1
                                                        for i19 = 0, v26 do
                                                            v29 = v16.MarkOffset + i19 * FallbackTargetCount + i17
                                                            if buffer.readu8(BatchVolumePairMarks, v29) == 0 then
                                                                buffer.writeu8(BatchVolumePairMarks, v29, 1)
                                                                v16.RemainingPairs = v16.RemainingPairs - 1
                                                            end
                                                        end
                                                        v16.FirstPlane = v16.FirstPlane or i9
                                                        v16.ProofLeaves = v16.ProofLeaves + v25 * v23
                                                    end
                                                end
                                            end
                                        end
                                        if 0 < v16.RemainingPairs then
                                            ViewerActor_3 = Query.ViewerActor
                                            FallbackViewerOffset = v17.FallbackViewerOffset
                                            v23 = FallbackViewerCount * 8
                                            FallbackViewerProjectionIndex = v17.FallbackViewerProjectionIndex
                                            if v45[ViewerActor_3] == i9 then
                                                v21 = true
                                            elseif projectBufferPoints(
                                                a1.Data,
                                                i9,
                                                a2,
                                                FallbackViewerOffset,
                                                v23,
                                                BatchProjectionScratch,
                                                FallbackViewerProjectionIndex
                                            ) then
                                                v45[ViewerActor_3] = i9
                                                u1137 = u1137 + 1
                                                v21 = true
                                            else
                                                v21 = false
                                            end
                                            if v21 then
                                                v21 = FallbackViewerCount - 1
                                                for i20 = 0, v21 do
                                                    v23 = FallbackTargetCount - 1
                                                    for i21 = 0, v23 do
                                                        v26 = v16.MarkOffset + i20 * FallbackTargetCount + i21
                                                        if buffer.readu8(BatchVolumePairMarks, v26) == 0 then
                                                            v4 = v4 + 1
                                                            v27 = projectedVolumePairCoverage
                                                            Data_2 = a1.Data
                                                            v30 = v17.FallbackViewerProjectionIndex + i20 * 8
                                                            v31 = v18.FallbackTargetProjectionIndex + i21 * 8
                                                            v27, v28 = v27(
                                                                Data_2,
                                                                i9,
                                                                BatchProjectionScratch,
                                                                v30,
                                                                8,
                                                                BatchProjectionScratch,
                                                                v31,
                                                                8,
                                                                v43
                                                            )
                                                            if v27 then
                                                                buffer.writeu8(BatchVolumePairMarks, v26, 1)
                                                                v16.RemainingPairs = v16.RemainingPairs - 1
                                                                v16.FirstPlane = v16.FirstPlane or i9
                                                                v16.ProofLeaves = v16.ProofLeaves + v28
                                                            end
                                                        end
                                                    end
                                                end
                                                if v16.RemainingPairs == 0 then
                                                    v16.Proved = true
                                                end
                                            end
                                        elseif v16.RemainingPairs == 0 then
                                            v16.Proved = true
                                        end
                                    end
                                end
                            else
                                ViewerActor = Query.ViewerActor
                                ViewerPointsOffset = v17.ViewerPointsOffset
                                ViewerPointCount = v17.ViewerPointCount
                                ViewerProjectionIndex = v17.ViewerProjectionIndex
                                if v40[ViewerActor] == i9 then
                                    v19 = true
                                elseif projectBufferPoints(
                                    a1.Data,
                                    i9,
                                    a2,
                                    ViewerPointsOffset,
                                    ViewerPointCount,
                                    BatchProjectionScratch,
                                    ViewerProjectionIndex
                                ) then
                                    v40[ViewerActor] = i9
                                    u1137 = u1137 + 1
                                    v19 = true
                                else
                                    v19 = false
                                end
                                if v19 then
                                    TargetActor = Query.TargetActor
                                    TargetPointsOffset = v18.TargetPointsOffset
                                    TargetPointCount = v18.TargetPointCount
                                    TargetProjectionIndex = v18.TargetProjectionIndex
                                    if v44[TargetActor] == i9 then
                                        v19 = true
                                    elseif projectBufferPoints(
                                        a1.Data,
                                        i9,
                                        a2,
                                        TargetPointsOffset,
                                        TargetPointCount,
                                        BatchProjectionScratch,
                                        TargetProjectionIndex
                                    ) then
                                        v44[TargetActor] = i9
                                        u1137 = u1137 + 1
                                        v19 = true
                                    else
                                        v19 = false
                                    end
                                    if v19 then
                                        v4 = v4 + 1
                                        v19, v20 = projectedVolumePairCoverage(
                                            a1.Data,
                                            i9,
                                            BatchProjectionScratch,
                                            v17.ViewerProjectionIndex,
                                            v17.ViewerPointCount,
                                            BatchProjectionScratch,
                                            v18.TargetProjectionIndex,
                                            v18.TargetPointCount,
                                            v43
                                        )
                                        if v19 then
                                            v16.Proved = true
                                            v16.FirstPlane = i9
                                            v16.ProofLeaves = v20
                                        end
                                    end
                                end
                            end
                        elseif Query.Fallback then
                            if v43 then
                                v43.planes = v43.planes + 1
                            end
                            v16.Tests = v16.Tests + 1
                            if Query.Fallback then
                                ViewerActor_2 = Query.ViewerActor
                                ViewerPointsOffset_2 = v17.ViewerPointsOffset
                                ViewerPointCount_2 = v17.ViewerPointCount
                                ViewerProjectionIndex_2 = v17.ViewerProjectionIndex
                                if v40[ViewerActor_2] == i9 then
                                    v19 = true
                                elseif projectBufferPoints(
                                    a1.Data,
                                    i9,
                                    a2,
                                    ViewerPointsOffset_2,
                                    ViewerPointCount_2,
                                    BatchProjectionScratch,
                                    ViewerProjectionIndex_2
                                ) then
                                    v40[ViewerActor_2] = i9
                                    u1137 = u1137 + 1
                                    v19 = true
                                else
                                    v19 = false
                                end
                                if v19 then
                                    TargetActor_2 = Query.TargetActor
                                    FallbackTargetOffset = v18.FallbackTargetOffset
                                    v22 = v18.FallbackTargetCount * 8
                                    FallbackTargetProjectionIndex = v18.FallbackTargetProjectionIndex
                                    if v2[TargetActor_2] == i9 then
                                        v19 = true
                                    elseif projectBufferPoints(
                                        a1.Data,
                                        i9,
                                        a2,
                                        FallbackTargetOffset,
                                        v22,
                                        BatchProjectionScratch,
                                        FallbackTargetProjectionIndex
                                    ) then
                                        v2[TargetActor_2] = i9
                                        u1137 = u1137 + 1
                                        v19 = true
                                    else
                                        v19 = false
                                    end
                                    if v19 then
                                        FallbackViewerCount = v17.FallbackViewerCount
                                        FallbackTargetCount = v18.FallbackTargetCount
                                        if FallbackViewerCount > 1 then
                                            v21 = FallbackTargetCount - 1
                                            for i22 = 0, v21 do
                                                v23 = 0
                                                v24 = FallbackViewerCount - 1
                                                for i23 = 0, v24 do
                                                    v27 = v16.MarkOffset + i23 * FallbackTargetCount + i22
                                                    if buffer.readu8(BatchVolumePairMarks, v27) == 0 then
                                                        v23 = v23 + 1
                                                    end
                                                end
                                                if v23 ~= 0 then
                                                    v4 = v4 + 1
                                                    v24 = projectedVolumePairCoverage
                                                    Data = a1.Data
                                                    ViewerProjectionIndex_3 = v17.ViewerProjectionIndex
                                                    ViewerPointCount_3 = v17.ViewerPointCount
                                                    v30 = v18.FallbackTargetProjectionIndex + i22 * 8
                                                    v24, v25 = v24(
                                                        Data,
                                                        i9,
                                                        BatchProjectionScratch,
                                                        ViewerProjectionIndex_3,
                                                        ViewerPointCount_3,
                                                        BatchProjectionScratch,
                                                        v30,
                                                        8,
                                                        v43
                                                    )
                                                    if v24 then
                                                        v26 = FallbackViewerCount - 1
                                                        for i24 = 0, v26 do
                                                            v29 = v16.MarkOffset + i24 * FallbackTargetCount + i22
                                                            if buffer.readu8(BatchVolumePairMarks, v29) == 0 then
                                                                buffer.writeu8(BatchVolumePairMarks, v29, 1)
                                                                v16.RemainingPairs = v16.RemainingPairs - 1
                                                            end
                                                        end
                                                        v16.FirstPlane = v16.FirstPlane or i9
                                                        v16.ProofLeaves = v16.ProofLeaves + v25 * v23
                                                    end
                                                end
                                            end
                                        end
                                        if 0 < v16.RemainingPairs then
                                            ViewerActor_3 = Query.ViewerActor
                                            FallbackViewerOffset = v17.FallbackViewerOffset
                                            v23 = FallbackViewerCount * 8
                                            FallbackViewerProjectionIndex = v17.FallbackViewerProjectionIndex
                                            if v45[ViewerActor_3] == i9 then
                                                v21 = true
                                            elseif projectBufferPoints(
                                                a1.Data,
                                                i9,
                                                a2,
                                                FallbackViewerOffset,
                                                v23,
                                                BatchProjectionScratch,
                                                FallbackViewerProjectionIndex
                                            ) then
                                                v45[ViewerActor_3] = i9
                                                u1137 = u1137 + 1
                                                v21 = true
                                            else
                                                v21 = false
                                            end
                                            if v21 then
                                                v21 = FallbackViewerCount - 1
                                                for i25 = 0, v21 do
                                                    v23 = FallbackTargetCount - 1
                                                    for i26 = 0, v23 do
                                                        v26 = v16.MarkOffset + i25 * FallbackTargetCount + i26
                                                        if buffer.readu8(BatchVolumePairMarks, v26) == 0 then
                                                            v4 = v4 + 1
                                                            v27 = projectedVolumePairCoverage
                                                            Data_2 = a1.Data
                                                            v30 = v17.FallbackViewerProjectionIndex + i25 * 8
                                                            v31 = v18.FallbackTargetProjectionIndex + i26 * 8
                                                            v27, v28 = v27(
                                                                Data_2,
                                                                i9,
                                                                BatchProjectionScratch,
                                                                v30,
                                                                8,
                                                                BatchProjectionScratch,
                                                                v31,
                                                                8,
                                                                v43
                                                            )
                                                            if v27 then
                                                                buffer.writeu8(BatchVolumePairMarks, v26, 1)
                                                                v16.RemainingPairs = v16.RemainingPairs - 1
                                                                v16.FirstPlane = v16.FirstPlane or i9
                                                                v16.ProofLeaves = v16.ProofLeaves + v28
                                                            end
                                                        end
                                                    end
                                                end
                                                if v16.RemainingPairs == 0 then
                                                    v16.Proved = true
                                                end
                                            end
                                        elseif v16.RemainingPairs == 0 then
                                            v16.Proved = true
                                        end
                                    end
                                end
                            else
                                ViewerActor = Query.ViewerActor
                                ViewerPointsOffset = v17.ViewerPointsOffset
                                ViewerPointCount = v17.ViewerPointCount
                                ViewerProjectionIndex = v17.ViewerProjectionIndex
                                if v40[ViewerActor] == i9 then
                                    v19 = true
                                elseif projectBufferPoints(
                                    a1.Data,
                                    i9,
                                    a2,
                                    ViewerPointsOffset,
                                    ViewerPointCount,
                                    BatchProjectionScratch,
                                    ViewerProjectionIndex
                                ) then
                                    v40[ViewerActor] = i9
                                    u1137 = u1137 + 1
                                    v19 = true
                                else
                                    v19 = false
                                end
                                if v19 then
                                    TargetActor = Query.TargetActor
                                    TargetPointsOffset = v18.TargetPointsOffset
                                    TargetPointCount = v18.TargetPointCount
                                    TargetProjectionIndex = v18.TargetProjectionIndex
                                    if v44[TargetActor] == i9 then
                                        v19 = true
                                    elseif projectBufferPoints(
                                        a1.Data,
                                        i9,
                                        a2,
                                        TargetPointsOffset,
                                        TargetPointCount,
                                        BatchProjectionScratch,
                                        TargetProjectionIndex
                                    ) then
                                        v44[TargetActor] = i9
                                        u1137 = u1137 + 1
                                        v19 = true
                                    else
                                        v19 = false
                                    end
                                    if v19 then
                                        v4 = v4 + 1
                                        v19, v20 = projectedVolumePairCoverage(
                                            a1.Data,
                                            i9,
                                            BatchProjectionScratch,
                                            v17.ViewerProjectionIndex,
                                            v17.ViewerPointCount,
                                            BatchProjectionScratch,
                                            v18.TargetProjectionIndex,
                                            v18.TargetPointCount,
                                            v43
                                        )
                                        if v19 then
                                            v16.Proved = true
                                            v16.FirstPlane = i9
                                            v16.ProofLeaves = v20
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    v6 = table.create(#v42)
    v7 = nil
    v8 = nil
    for i27, i28 in v34, v7, v8 do
        v11 = {
            Proved = i28.Proved,
            PlaneIndex = i28.FirstPlane,
            ProofLeaves = if not i28.Proved then 0 else i28.ProofLeaves,
        }
        Proved = i28.Proved and i28.Query.Fallback
        v11.UsedFallback = Proved
        v6[i27] = v11
    end
    v7 = u1137
    return v6, v7, v4
end

function u5.ProvePlaneBuffer(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 1789
    -- upvalues: planeCoversBuffer (val)
    local Data = a1.Data
    if a5 ~= 0 and not (a7 < 4) and not (a3 < 1) and not (Data.planeCount < a3) and a3 == math.floor(a3) then
        if a8 then
            a8.planes = a8.planes + 1
        end
        return planeCoversBuffer(Data, a3, a2, a4, a5, a6, a7, a1.ViewerProjectionScratch, a1.TargetProjectionScratch, a8)
    end
    return false, 0
end

function u5.ProveRectangleBuffer(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) -- Line: 1827
    -- upvalues: projectFootprintBuffer (val)
    if a10 ~= 0 and not (a12 < 4) then
        local v1 = a7 - 0.02
        local v2 = a8 - 0.02
        if not (v1 <= 0) and not (v2 <= 0) then
            local v3, v4, v5, v6, v7 = projectFootprintBuffer(a2, a3, a4, a5, a6, a9, a10, a11, a12, a1.ViewerProjectionScratch, a1.TargetProjectionScratch)
            local v8 = v3
            if v8 then
                v8 = false
                if -v1 <= v4 then
                    v8 = false
                    if v5 <= v1 then
                        v8 = false
                        if -v2 <= v6 then
                            v8 = v7 <= v2
                        end
                    end
                end
            end
            return v8
        end
        return false
    end
    return false
end

function u5.ProveProjectedOccludedForCellBuffer(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13) -- Line: 1866
    -- upvalues: planeCoversBuffer (val), findCertificate (val), CANDIDATE_SIZE (val)
    if a8 ~= 0 and not (a10 < 4) and a4 ~= 0 and a6 ~= 0 then
        local PlaneMarks_3, PlaneMarks_4, buffer_2, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
        local Data = a1.Data
        local v15 = a13 or (1 / 0)
        if a11 ~= nil and a11 >= 1 and a11 <= Data.planeCount then
            if a12 then
                a12.planes = a12.planes + 1
            end
            v15 = v15 - 1
            v1, v2 = planeCoversBuffer(Data, a11, a2, a7, a8, a9, a10, a1.ViewerProjectionScratch, a1.TargetProjectionScratch, a12)
            if v1 then
                return true, a11, v2
            end
        end
        v1 = a1.PlaneMarkToken + 1
        if v1 >= 4294967295 then
            buffer.fill(a1.PlaneMarks, 0, 0)
            v1 = 1
        end
        a1.PlaneMarkToken = v1
        if a11 ~= nil and a11 >= 1 and a11 <= Data.planeCount then
            v2 = (a11 - 1) * 4
            local PlaneMarks = a1.PlaneMarks
            if buffer.readu32(PlaneMarks, v2) ~= v1 then
                local PlaneMarks_2 = a1.PlaneMarks
                buffer.writeu32(PlaneMarks_2, v2, v1)
            end
        end
        v2 = a4 - 1
        for i = 0, v2 do
            v5 = a3 + i * 2
            v3 = buffer.readu16(a2, v5)
            v4 = a6 - 1
            for j = 0, v4 do
                v8 = a5 + j * 2
                v6 = buffer.readu16(a2, v8)
                v7 = findCertificate
                v10 = math.min(v3, v6)
                v11 = math.max(v3, v6)
                v7, v8 = v7(Data, (bit32.bor(bit32.lshift(v10, 16), v11)))
                if v7 ~= nil and v8 ~= nil then
                    v9 = v7 + v8 - 1
                    for k = v7, v9 do
                        buffer_2 = Data.buffer
                        v14 = Data.candidateOffset + (k - 1) * CANDIDATE_SIZE
                        v12 = buffer.readu16(buffer_2, v14)
                        v14 = (v12 - 1) * 4
                        PlaneMarks_3 = a1.PlaneMarks
                        if buffer.readu32(PlaneMarks_3, v14) ~= v1 then
                            PlaneMarks_4 = a1.PlaneMarks
                            buffer.writeu32(PlaneMarks_4, v14, v1)
                            v13 = true
                        else
                            v13 = false
                        end
                        if v13 then
                            if v15 <= 0 then
                                return false, nil, 0
                            end
                            v15 = v15 - 1
                            if a12 then
                                a12.planes = a12.planes + 1
                            end
                            v13, v14 = planeCoversBuffer(Data, v12, a2, a7, a8, a9, a10, a1.ViewerProjectionScratch, a1.TargetProjectionScratch, a12)
                            if v13 then
                                return true, v12, v14
                            end
                        end
                    end
                end
            end
        end
        return false, nil, 0
    end
    return false, nil, 0
end

function u5.PairKey(a1, a2) -- Line: 29 -- types: a1: number, a2: number
    return (bit32.bor(bit32.lshift(math.min(a1, a2), 16), (math.max(a1, a2))))
end

function u5.SamplePacket(a1, a2) -- Line: 1956 -- upvalues: readTriangle (val) -- types: a2: number
    if not (a2 < 1) and not (a1.Data.triangleCount < a2) and a2 % 1 == 0 then
        local v1 = (a2 - 1) % 4096 + 1
        if a1.SamplePacketIds[v1] == a2 then
            return a1.SamplePackets[v1]
        end
        local v2, v3, v4 = readTriangle(a1.Data, a2)
        local v5 = table.freeze({v2, v3 - v2, v4 - v2})
        a1.SamplePacketIds[v1] = a2
        a1.SamplePackets[v1] = v5
        return v5
    end
    return nil
end

return table.freeze(u5)