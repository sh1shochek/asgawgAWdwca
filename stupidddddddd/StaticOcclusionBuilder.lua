-- ReplicatedStorage.Visibility.StaticOcclusionBuilder
-- Script path: ReplicatedStorage.Visibility.StaticOcclusionBuilder
-- Decompile time: 17.90 ms

local StaticOcclusionCodec = require(script.Parent.StaticOcclusionCodec)
local PVSCodec = require(script.Parent.PVSCodec)
local v1 = {}
local u61 = table.freeze({
    {1, 3, 4},
    {1, 4, 2},
    {5, 6, 8},
    {5, 8, 7},
    {1, 5, 7},
    {1, 7, 3},
    {2, 4, 8},
    {2, 8, 6},
    {1, 2, 6},
    {1, 6, 5},
    {3, 7, 8},
    {3, 8, 4},
})

local function isExactBlock(a1) -- Line: 81 -- types: a1: userdata
    return a1:IsA("Part") and a1.Shape == Enum.PartType.Block
end

local function canonicalAxis(a1) -- Line: 85 -- types: a1: vector
    local X = a1.X
    local Y = a1.Y
    local Z = a1.Z
    local v1 = math.abs(X)
    local v2 = math.abs(Y)
    local v3 = math.abs(Z)
    return a1 * (if not (v2 <= v1) then if not (v3 <= v2) then if not (Z < 0) then 1 else -1 else if not (Y < 0) then 1 else -1 else if not (v3 <= v1) then if not (v3 <= v2) then if not (Z < 0) then 1 else -1 else if not (Y < 0) then 1 else -1 else if not (X < 0) then 1 else -1)
end

local function axisKey(a1) -- Line: 94 -- types: a1: vector
    return (("%*,%*,%*"):format(string.format("%.9g", a1.X), string.format("%.9g", a1.Y), (string.format("%.9g", a1.Z))))
end

local function verticesForBlock(a1) -- Line: 98 -- types: a1: userdata
    local v1, v2, v3
    local v4 = a1.Size * 0.5
    local v5 = table.create(8)
    local v6 = 0
    local v7 = {-v4.X, v4.X}
    local v8 = nil
    local v9 = nil
    for i, j in v7, v8, v9 do
        v3 = {-v4.Y, v4.Y}
        v1 = nil
        v2 = nil
        for k, n in v3, v1, v2 do
            for m, i5 in {-v4.Z, v4.Z} do
                v6 = v6 + 1
                v5[v6] = (a1.CFrame:PointToWorldSpace((Vector3.new(j, n, i5))))
            end
        end
    end
    return v5
end

local function triangleItem(a1) -- Line: 113
    return {
        triangle = a1,
        minimum = (a1.a:Min(a1.b)):Min(a1.c),
        maximum = (a1.a:Max(a1.b)):Max(a1.c),
        centroid = (a1.a + a1.b + a1.c) / 3,
    }
end

local u101 = table.freeze({{1, 3, 4}, {1, 4, 2}, {2, 4, 6}, {2, 6, 5}, {1, 5, 6}, {1, 6, 3}, {1, 2, 5}, {3, 6, 4}})
local u128 = table.freeze({{1, 3, 4}, {1, 4, 2}, {3, 4, 5}, {1, 3, 5}, {1, 5, 2}, {2, 5, 4}})

local function verticesForWedge(a1) -- Line: 146 -- types: a1: userdata
    local v1 = a1.Size * 0.5
    local CFrame = a1.CFrame
    return {
        CFrame:PointToWorldSpace((Vector3.new(-v1.X, -v1.Y, -v1.Z))),
        CFrame:PointToWorldSpace((Vector3.new(-v1.X, -v1.Y, v1.Z))),
        CFrame:PointToWorldSpace((Vector3.new(v1.X, -v1.Y, -v1.Z))),
        CFrame:PointToWorldSpace((Vector3.new(v1.X, -v1.Y, v1.Z))),
        CFrame:PointToWorldSpace((Vector3.new(-v1.X, v1.Y, v1.Z))),
        (CFrame:PointToWorldSpace((Vector3.new(v1.X, v1.Y, v1.Z)))),
    }
end

local function verticesForCornerWedge(a1) -- Line: 159 -- types: a1: userdata
    local v1 = a1.Size * 0.5
    local CFrame = a1.CFrame
    return {
        CFrame:PointToWorldSpace((Vector3.new(-v1.X, -v1.Y, -v1.Z))),
        CFrame:PointToWorldSpace((Vector3.new(-v1.X, -v1.Y, v1.Z))),
        CFrame:PointToWorldSpace((Vector3.new(v1.X, -v1.Y, -v1.Z))),
        CFrame:PointToWorldSpace((Vector3.new(v1.X, -v1.Y, v1.Z))),
        (CFrame:PointToWorldSpace((Vector3.new(v1.X, v1.Y, -v1.Z)))),
    }
end

local function cylinderTriangles(a1, a2, a3) -- Line: 172
    -- upvalues: triangleItem (val)
    local v1, v2, v3, v4, v5, v6
    local v7 = a1.Size * 0.5
    local v8 = math.min(v7.Y, v7.Z)
    local CFrame = a1.CFrame
    local v9 = table.create(24)
    for i = 0, 11 do
        v1 = i / 12 * 3.141592653589793 * 2
        v2 = math.cos(v1) * v8
        v3 = math.sin(v1) * v8
        v4 = i * 2 + 1
        v9[v4] = (CFrame:PointToWorldSpace((Vector3.new(-v7.X, v2, v3))))
        v4 = i * 2 + 2
        v9[v4] = (CFrame:PointToWorldSpace((Vector3.new(v7.X, v2, v3))))
    end

    local function push(a1, a2_2, a3_2) -- Line: 184
        -- upvalues: a3 (val), triangleItem (upval), a2 (val)
        local v1 = a3
        local v2 = #a3 + 1
        v1[v2] = (triangleItem({a = a1, b = a2_2, c = a3_2, primitive = a2}))
    end

    for j = 0, 11 do
        v2 = (j + 1) % 12
        v3 = v9[j * 2 + 1]
        v4 = v9[j * 2 + 2]
        v5 = v9[v2 * 2 + 1]
        v6 = v9[v2 * 2 + 2]
        a3[#a3 + 1] = (triangleItem({a = v3, b = v5, c = v6, primitive = a2}))
        a3[#a3 + 1] = (triangleItem({a = v3, b = v6, c = v4, primitive = a2}))
    end
    for k = 1, 10 do
        v2 = v9[1]
        v3 = v9[k * 2 + 1]
        v4 = v9[(k + 1) * 2 + 1]
        a3[#a3 + 1] = (triangleItem({a = v2, b = v3, c = v4, primitive = a2}))
        v2 = v9[2]
        v3 = v9[(k + 1) * 2 + 2]
        v4 = v9[k * 2 + 2]
        a3[#a3 + 1] = (triangleItem({a = v2, b = v3, c = v4, primitive = a2}))
    end
end

local function meshForPart(a1) -- Line: 200
    -- upvalues: verticesForWedge (val), u101 (val), verticesForCornerWedge (val), u128 (val)
    if a1:IsA("WedgePart") then
        return (verticesForWedge(a1)), u101
    end
    if a1:IsA("Part") and a1.Shape == Enum.PartType.Wedge then
        return (verticesForWedge(a1)), u101
    end
    if a1:IsA("CornerWedgePart") then
        return (verticesForCornerWedge(a1)), u128
    end
    if a1:IsA("Part") and a1.Shape == Enum.PartType.CornerWedge then
        return (verticesForCornerWedge(a1)), u128
    end
    return nil, nil
end

local function isCylinder(a1) -- Line: 210 -- types: a1: userdata
    return a1:IsA("Part") and a1.Shape == Enum.PartType.Cylinder
end

local function unionBounds(a1, a2, a3) -- Line: 214 -- types: a1: table, a2: number?, a3: number?
    local v1 = a3 or #a1
    local v2 = Vector3.new((1 / 0), (1 / 0), (1 / 0))
    local v3 = Vector3.new((-1 / 0), (-1 / 0), (-1 / 0))
    for i = a2 or 1, v1 do
        v2 = v2:Min(a1[i].minimum)
        v3 = v3:Max(a1[i].maximum)
    end
    return {minimum = v2, maximum = v3}
end

local function centroidAxis(a1) -- Line: 226 -- types: a1: table
    local v1 = Vector3.new((1 / 0), (1 / 0), (1 / 0))
    local v2 = Vector3.new((-1 / 0), (-1 / 0), (-1 / 0))
    for i, j in a1 do
        v1 = v1:Min(j.centroid)
        v2 = v2:Max(j.centroid)
    end
    local v3 = v2 - v1
    if v3.Y <= v3.X and v3.Z <= v3.X then
        return "X"
    end
    if v3.Z <= v3.Y then
        return "Y"
    end
    return "Z"
end

local function buildBVH(a1) -- Line: 242 -- upvalues: centroidAxis (val), unionBounds (val) -- types: a1: table
    local buildNode
    local u1 = {}
    local u2 = {}
    local u3 = {}

    local function makeLeaf(a1) -- Line: 247 -- upvalues: u2 (val), u3 (val) -- types: a1: table
        local v1, v2
        local v3 = #u2 + 1
        local v4 = #u3 + 1
        for i, j in a1 do
            v1 = u3
            v2 = #u3 + 1
            v1[v2] = j.triangle
        end
        u2[v3] = {firstTriangle = v4, triangleCount = #a1}
        return -v3
    end

    function buildNode(a1) -- Line: 258
        -- upvalues: u1 (val), centroidAxis (upval), makeLeaf (val), buildNode (ref), unionBounds (upval)
        local children, v1, v2, v3, v4, v5
        local v6 = #u1 + 1
        u1[v6] = {children = {}}
        local u9 = centroidAxis(a1)
        table.sort(a1, function(a1, a2) -- Line: 262 -- upvalues: u9 (val)
            local v1 = a1.centroid[u9]
            local v2 = a2.centroid[u9]
            if v1 == v2 then
                return a1.triangle.primitive < a2.triangle.primitive
            end
            return v1 < v2
        end)
        local v7 = math.min(8, (math.max(1, (math.ceil(#a1 / 8)))))
        local v8 = 1
        local v9 = a1
        for i = 1, v7 do
            v1 = math.ceil((#v9 - v8 + 1) / (v7 - i + 1))
            v2 = table.create(v1)
            v3 = v8 + v1 - 1
            for j = v8, v3 do
                v2[#v2 + 1] = v9[j]
            end
            v8 = v8 + v1
            v3 = if not (#v2 <= 8) then buildNode(v2) else makeLeaf(v2)
            v4 = unionBounds(v2)
            children = u1[v6].children
            v5 = {minimum = v4.minimum, maximum = v4.maximum, reference = v3}
            children[i] = v5
        end
        return v6
    end

    return u1, u2, u3, (buildNode(a1))
end

local function planeForBlock(a1, a2) -- Line: 296 -- types: a1: userdata, a2: number
    local Size = a1.Size
    local v1 = {a1.CFrame.RightVector, a1.CFrame.UpVector, a1.CFrame.ZVector}
    local v2 = {Size.X, Size.Y, Size.Z}
    local v3 = 1
    if v2[2] < v2[v3] then
        v3 = 2
    end
    if v2[3] < v2[v3] then
        v3 = 3
    end
    local v4 = if v3 ~= 1 then 1 else 2
    local v5 = if v3 ~= 3 then 3 else 2
    if v4 == v5 then
        v5 = 3
    end
    local v6 = v1[v3]
    local X = v6.X
    local Y = v6.Y
    local Z_2 = v6.Z
    local v7 = math.abs(X)
    local v8 = math.abs(Y)
    local v9 = math.abs(Z_2)
    local v10 = v6 * (if not (v8 <= v7) then if not (v9 <= v8) then if not (Z_2 < 0) then 1 else -1 else if not (Y < 0) then 1 else -1 else if not (v9 <= v7) then if not (v9 <= v8) then if not (Z_2 < 0) then 1 else -1 else if not (Y < 0) then 1 else -1 else if not (X < 0) then 1 else -1)
    local v11 = v1[v4]
    local X_2 = v11.X
    local Y_2 = v11.Y
    local Z_3 = v11.Z
    v8 = math.abs(X_2)
    v9 = math.abs(Y_2)
    local v12 = math.abs(Z_3)
    v6 = v11 * (if not (v9 <= v8) then if not (v12 <= v9) then if not (Z_3 < 0) then 1 else -1 else if not (Y_2 < 0) then 1 else -1 else if not (v12 <= v8) then if not (v12 <= v9) then if not (Z_3 < 0) then 1 else -1 else if not (Y_2 < 0) then 1 else -1 else if not (X_2 < 0) then 1 else -1)
    local v13 = v1[v5]
    local X_3 = v13.X
    local Y_3 = v13.Y
    local Z_4 = v13.Z
    v9 = math.abs(X_3)
    v12 = math.abs(Y_3)
    local v14 = math.abs(Z_4)
    v11 = v13 * (if not (v12 <= v9) then if not (v14 <= v12) then if not (Z_4 < 0) then 1 else -1 else if not (Y_3 < 0) then 1 else -1 else if not (v14 <= v9) then if not (v14 <= v12) then if not (Z_4 < 0) then 1 else -1 else if not (Y_3 < 0) then 1 else -1 else if not (X_3 < 0) then 1 else -1)
    v13 = a1.Position:Dot(v10)
    local v15 = a1.Position:Dot(v6)
    v7 = a1.Position:Dot(v11)
    v8 = v2[v4] * 0.5
    v9 = v2[v5] * 0.5
    return (("%*|%*|%*|%*"):format(
        ("%*,%*,%*"):format(string.format("%.9g", v10.X), string.format("%.9g", v10.Y), (string.format("%.9g", v10.Z))),
        ("%*,%*,%*"):format(string.format("%.9g", v6.X), string.format("%.9g", v6.Y), (string.format("%.9g", v6.Z))),
        ("%*,%*,%*"):format(string.format("%.9g", v11.X), string.format("%.9g", v11.Y), (string.format("%.9g", v11.Z))),
        (string.format("%.9g", v13))
    )), {
        origin = v10 * v13,
        u = v6,
        v = v11,
        normal = v10,
        rectangles = {},
    }, {
        minimumU = v15 - v8,
        maximumU = v15 + v8,
        minimumV = v7 - v9,
        maximumV = v7 + v9,
        primitive = a2,
    }
end

local function representativePosition(a1) -- Line: 338
    return (Vector3.new(
        (a1.minimum.X + a1.maximum.X) * 0.5,
        math.min(a1.minimum.Y + 3, (a1.minimum.Y + a1.maximum.Y) * 0.5),
        (a1.minimum.Z + a1.maximum.Z) * 0.5
    ))
end

local function buildCertificates(a1, a2, a3, a4) -- Line: 346
    -- upvalues: PVSCodec (val)
    if a3 ~= nil and #a1 ~= 0 then
        local v1, v2, v3, v4, v5, v6, v7
        local v8 = table.create(#a3.cells)
        local v9 = #a3.cells
        for i = 1, v9 do
            v8[i] = {}
        end
        for j, k in a3.regions do
            v1 = v8[k.cluster]
            v1[#v8[k.cluster] + 1] = k
        end
        v9 = {}
        local v10 = {}
        local v11 = 0
        local v12 = if a4 ~= nil then math.max(math.floor(a4.yieldEveryPairs or 0), 0) else 0

        local function addSegmentCandidates(a1_2, a2_2, a3) -- Line: 367
            -- upvalues: a1 (val), a2 (val)
            local firstRectangle, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
            local v11 = nil
            local v12 = nil
            local v13, v14, v15 = a1_2, a2_2, a3
            for i, j in a1, v11, v12 do
                v9 = (v13 - j.origin):Dot(j.normal)
                v10 = (v14 - j.origin):Dot(j.normal)
                if not (-1e-06 <= v9 * v10) then
                    v1 = -v9 / (v10 - v9)
                    if not (v1 <= 0) and not (v1 >= 1) then
                        v2 = (v13:Lerp(v14, v1)) - j.origin
                        v3 = v2:Dot(j.u)
                        v4 = v2:Dot(j.v)
                        firstRectangle = j.firstRectangle
                        v5 = j.firstRectangle + j.rectangleCount - 1
                        for k = firstRectangle, v5 do
                            v6 = a2[k]
                            if v6.minimumU <= v3
                                and v3 <= v6.maximumU
                                and v6.minimumV <= v4
                                and v4 <= v6.maximumV then
                                v7 = math.min(v3 - v6.minimumU, v6.maximumU - v3, v4 - v6.minimumV, v6.maximumV - v4)
                                v8 = v15[i] or (-1 / 0)
                                v15[i] = (math.max(v8, v7))
                                break
                            end
                        end
                    end
                end
            end
        end

        v1 = #a3.cells
        for n = 1, v1 do
            v3 = n + 1
            v2 = #a3.cells
            for m = v3, v2 do
                if not PVSCodec.isVisible(a3, n, m) then
                    v11 = v11 + 1
                    v4 = {}
                    v5 = v8[n]
                    v6 = nil
                    v7 = nil
                    for i5, i6 in v5, v6, v7 do
                        for i7, i8 in v8[m] do
                            addSegmentCandidates(Vector3.new(
                                (i6.minimum.X + i6.maximum.X) * 0.5,
                                math.min(i6.minimum.Y + 3, (i6.minimum.Y + i6.maximum.Y) * 0.5),
                                (i6.minimum.Z + i6.maximum.Z) * 0.5
                            ), Vector3.new(
                                (i8.minimum.X + i8.maximum.X) * 0.5,
                                math.min(i8.minimum.Y + 3, (i8.minimum.Y + i8.maximum.Y) * 0.5),
                                (i8.minimum.Z + i8.maximum.Z) * 0.5
                            ), v4)
                        end
                    end
                    v5 = {}
                    for i9, i10 in v4 do
                        v5[#v5 + 1] = {plane = i9, score = i10}
                    end
                    table.sort(v5, function(a1, a2) -- Line: 422
                        if a1.score == a2.score then
                            return a1.plane < a2.plane
                        end
                        return a2.score < a1.score
                    end)
                    v6 = {}
                    v7 = math.min(#v5, 8)
                    for i11 = 1, v7 do
                        v6[i11] = v5[i11].plane
                    end
                    if #v6 > 0 then
                        v7 = #v10 + 1
                        for i12, i13 in v6 do
                            v10[#v10 + 1] = i13
                        end
                        v9[#v9 + 1] = {
                            pairKey = bit32.bor(bit32.lshift(n, 16), m),
                            firstCandidate = v7,
                            candidateCount = #v6,
                        }
                    end
                    if v12 > 0 and v11 % v12 == 0 then
                        if a4 and a4.onCertificateProgress then
                            a4.onCertificateProgress(v11, #v9)
                        end
                        task.wait()
                    end
                end
            end
        end
        return v9, v10
    end
    return {}, {}
end

function v1.build(a1, a2, a3) -- Line: 454
    -- upvalues: meshForPart (val), triangleItem (val), cylinderTriangles (val), verticesForBlock (val), u61 (val)
    -- upvalues: planeForBlock (val), buildBVH (val), buildCertificates (val), StaticOcclusionCodec (val)
    local maximum, minimum, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
    local v13 = {}
    local v14 = {}
    local v15 = 0
    local u530 = Vector3.new((1 / 0), (1 / 0), (1 / 0))
    local u535 = Vector3.new((-1 / 0), (-1 / 0), (-1 / 0))

    local function includeBounds(a1) -- Line: 465 -- upvalues: u530 (ref), u535 (ref) -- types: a1: vector
        u530 = u530:Min(a1)
        u535 = u535:Max(a1)
    end

    local v16 = nil
    local v17 = nil
    local v18 = a3
    for i, j in a1.parts, v16, v17 do
        v5 = j:IsA("Part") and j.Shape == Enum.PartType.Block
        if v5 then
            v15 = v15 + 1
            v5 = verticesForBlock(j)
            for k, n in v5 do
                u530 = u530:Min(n)
                u535 = u535:Max(n)
            end
            for m, i5 in u61 do
                v13[#v13 + 1] = (triangleItem({a = v5[i5[1]], b = v5[i5[2]], c = v5[i5[3]], primitive = i}))
            end
            v6, v7, v8 = planeForBlock(j, i)
            v9 = v14[v6]
            if v9 == nil then
                v14[v6] = v7
            end
            v9.rectangles[#v9.rectangles + 1] = v8
        else
            v5, v6 = meshForPart(j)
            if v5 == nil then
                v7 = j:IsA("Part") and j.Shape == Enum.PartType.Cylinder
                if v7 then
                    v15 = v15 + 1
                    v7 = #v13 + 1
                    cylinderTriangles(j, i, v13)
                    v8 = #v13
                    for i6 = v7, v8 do
                        minimum = v13[i6].minimum
                        u530 = u530:Min(minimum)
                        u535 = u535:Max(minimum)
                        maximum = v13[i6].maximum
                        u530 = u530:Min(maximum)
                        u535 = u535:Max(maximum)
                    end
                end
            elseif v6 == nil then
                v7 = j:IsA("Part") and j.Shape == Enum.PartType.Cylinder
                if v7 then
                    v15 = v15 + 1
                    v7 = #v13 + 1
                    cylinderTriangles(j, i, v13)
                    v8 = #v13
                    for i7 = v7, v8 do
                        minimum = v13[i7].minimum
                        u530 = u530:Min(minimum)
                        u535 = u535:Max(minimum)
                        maximum = v13[i7].maximum
                        u530 = u530:Min(maximum)
                        u535 = u535:Max(maximum)
                    end
                end
            else
                v15 = v15 + 1
                for i8, i9 in v5 do
                    u530 = u530:Min(i9)
                    u535 = u535:Max(i9)
                end
                for i10, i11 in v6 do
                    v13[#v13 + 1] = (triangleItem({
                        a = v5[i11[1]],
                        b = v5[i11[2]],
                        c = v5[i11[3]],
                        primitive = i,
                    }))
                end
            end
        end
    end
    local v19 = 0
    local walkMesh = if v18 == nil then nil else v18.walkMesh
    if walkMesh ~= nil then
        local v20
        v17 = #v1.parts + 1
        local Vertices = walkMesh.Vertices
        for i12, i13 in walkMesh.Triangles do
            v9 = Vertices[i13.A]
            v20 = Vertices[i13.B]
            v10 = Vertices[i13.C]
            if v9 ~= nil and v20 ~= nil and v10 ~= nil then
                u530 = u530:Min(v9)
                u535 = u535:Max(v9)
                u530 = u530:Min(v20)
                u535 = u535:Max(v20)
                u530 = u530:Min(v10)
                u535 = u535:Max(v10)
                v13[#v13 + 1] = (triangleItem({a = v9, b = v20, c = v10, primitive = v17}))
                v19 = v19 + 1
            end
        end
    end
    v17 = {
        nodes = 0,
        leaves = 0,
        planes = 0,
        rectangles = 0,
        encodedBytes = 0,
        certificates = 0,
        candidates = 0,
    }
    v17.inputPrimitives = #v1.parts
    v17.trianglePrimitives = v15
    v17.omittedPrimitives = #v1.parts - v15
    v17.triangles = #v13
    v17.walkMeshTriangles = v19
    if #v13 == 0 then
        return nil, v17, "NoExactBlockPrimitives"
    end
    v3, v4, v5, v6 = buildBVH(v13)
    v7 = {}
    for i14 in v14 do
        v7[#v7 + 1] = i14
    end
    table.sort(v7)
    v8 = {}
    v9 = {}
    v10 = nil
    local v21 = nil
    for i15, i16 in v7, v10, v21 do
        v11 = v14[i16]
        table.sort(v11.rectangles, function(a1, a2) -- Line: 563
            if a1.minimumU ~= a2.minimumU then
                return a1.minimumU < a2.minimumU
            end
            if a1.minimumV == a2.minimumV then
                return a1.primitive < a2.primitive
            end
            return a1.minimumV < a2.minimumV
        end)
        v12 = #v9 + 1
        for i17, i18 in v11.rectangles do
            v9[#v9 + 1] = i18
        end
        v8[#v8 + 1] = {
            origin = v11.origin,
            u = v11.u,
            v = v11.v,
            normal = v11.normal,
            firstRectangle = v12,
            rectangleCount = #v11.rectangles,
        }
    end
    v10, v21 = buildCertificates(v8, v9, v2, v18)
    local v22 = StaticOcclusionCodec.encode({
        fingerprint = v1.fingerprint,
        worldBounds = {minimum = u530, maximum = u535},
        rootNode = v6,
        nodes = v3,
        leaves = v4,
        triangles = v5,
        planes = v8,
        rectangles = v9,
        certificates = v10,
        candidates = v21,
    })
    v17.triangles = #v5
    v17.nodes = #v3
    v17.leaves = #v4
    v17.planes = #v8
    v17.rectangles = #v9
    v17.encodedBytes = #v22
    v17.certificates = #v10
    v17.candidates = #v21
    return v22, v17, nil
end

return table.freeze(v1)