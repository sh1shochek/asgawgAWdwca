-- ReplicatedStorage.MovementV2.Collision.BrushHullBuilder
-- Script path: ReplicatedStorage.MovementV2.Collision.BrushHullBuilder
-- Decompile time: 18.07 ms

local CollectionService = game:GetService("CollectionService")
local QuickHull = require(script.Parent.QuickHull)
local HullPoints = require(script.Parent.HullPoints)
local CanonicalGeometry = require(script.Parent.CanonicalGeometry)
local u23 = setmetatable({}, {__mode = "k"})
local u27 = setmetatable({}, {__mode = "k"})
local u28 = {}

function u28.Get(a1) -- Line: 15 -- upvalues: u23 (val), CanonicalGeometry (val) -- types: a1: userdata
    local v1 = u23[a1]
    if v1 ~= nil then
        return v1
    end
    local v2, v3 = CanonicalGeometry.ReadPublished(a1)
    assert(v2 ~= nil, v3)
    local v4 = {CFrame = v2.CFrame, Size = v2.Size}
    u23[a1] = v4
    return v4
end

function u28.GetCFrame(a1) -- Line: 30 -- upvalues: u28 (val) -- types: a1: userdata
    return u28.Get(a1).CFrame
end

local v1 = {}
local u32 = {}
u32[1] = (Vector3.new(0.5, 0.5, 0.5))
u32[2] = (Vector3.new(0.5, 0.5, -0.5))
u32[3] = (Vector3.new(-0.5, 0.5, 0.5))
u32[4] = (Vector3.new(-0.5, 0.5, -0.5))
u32[5] = (Vector3.new(0.5, -0.5, 0.5))
u32[6] = (Vector3.new(0.5, -0.5, -0.5))
u32[7] = (Vector3.new(-0.5, -0.5, 0.5))
u32[8] = (Vector3.new(-0.5, -0.5, -0.5))
local u41 = {}
u41[1] = (Vector3.new(0.5, -0.5, -0.5))
u41[2] = (Vector3.new(-0.5, -0.5, -0.5))
u41[3] = (Vector3.new(0.5, -0.5, 0.5))
u41[4] = (Vector3.new(-0.5, -0.5, 0.5))
u41[5] = (Vector3.new(0.5, 0.5, 0.5))
u41[6] = (Vector3.new(-0.5, 0.5, 0.5))
local u48 = {}
u48[1] = (Vector3.new(0.5, 0.5, -0.5))
u48[2] = (Vector3.new(0.5, -0.5, 0.5))
u48[3] = (Vector3.new(-0.5, -0.5, 0.5))
u48[4] = (Vector3.new(0.5, -0.5, -0.5))
u48[5] = (Vector3.new(-0.5, -0.5, -0.5))

local function quantizeVectorKey(a1) -- Line: 81 -- types: a1: vector
    return string.format("%d|%d|%d", math.round(a1.X * 10000), math.round(a1.Y * 10000), (math.round(a1.Z * 10000)))
end

local function findShapeForInstance(a1) -- Line: 90 -- types: a1: userdata
    if a1:IsA("WedgePart") then
        return Enum.PartType.Wedge
    end
    if a1:IsA("CornerWedgePart") then
        return Enum.PartType.CornerWedge
    end
    if a1:IsA("Part") then
        return a1.Shape
    end
    return Enum.PartType.Block
end

local function isClimbableInstance(a1) -- Line: 103 -- upvalues: CollectionService (val) -- types: a1: userdata
    local v1 = true
    if a1:GetAttribute("Climbable") ~= true then
        v1 = CollectionService:HasTag(a1, "Ladder")
    end
    return v1
end

local function getSurfaceFriction(a1) -- Line: 107 -- types: a1: userdata
    return 1
end

local function isMergeEligibleShape(a1) -- Line: 111
    local v1 = true
    if a1 ~= Enum.PartType.Block then
        v1 = true
        if a1 ~= Enum.PartType.Wedge then
            v1 = a1 == Enum.PartType.CornerWedge
        end
    end
    return v1
end

local function getCylinderCollisionRadius(a1) -- Line: 115 -- types: a1: vector
    return math.min(a1.Y, a1.Z) * 0.5
end

local function generateLocalPointsForPrimitive(a1, a2) -- Line: 120
    -- upvalues: HullPoints (val), findShapeForInstance (val), u41 (val), u48 (val), u32 (val)
    local v1, v2, v3, v4, v5, v6, v7, v8
    local v9 = HullPoints.Read(a1)
    if v9 ~= nil then
        return v9
    end
    local v10 = findShapeForInstance(a1)
    if v10 == Enum.PartType.Wedge then
        v6 = {}
        for i4, m in ipairs(u41) do
            table.insert(v6, m * a2)
        end
        return v6
    end
    if v10 == Enum.PartType.CornerWedge then
        v6 = {}
        for i3, n in ipairs(u48) do
            table.insert(v6, n * a2)
        end
        return v6
    end
    if v10 == Enum.PartType.Cylinder then
        local v11, v12
        v6 = a2.X * 0.5
        v7 = math.min(a2.Y, a2.Z) * 0.5
        local v13 = if a1:GetAttribute("PreciseMovementCylinder") ~= true then 12 else 32
        local v14 = {}
        local v15 = v13 - 1
        for k = 0, v15 do
            v2 = k / v13 * 3.141592653589793 * 2
            v11 = math.cos(v2) * v7
            v12 = math.sin(v2) * v7
            table.insert(v14, (Vector3.new(-v6, v11, v12)))
            table.insert(v14, (Vector3.new(v6, v11, v12)))
        end
        return v14
    end
    if v10 ~= Enum.PartType.Ball then
        v6 = {}
        for i, v in ipairs(u32) do
            table.insert(v6, v * a2)
        end
        return v6
    end
    v6 = math.min(a2.X, a2.Y, a2.Z) * 0.5
    v7 = {
        Vector3.new(v6, 0, 0),
        Vector3.new(-v6, 0, 0),
        Vector3.new(0, v6, 0),
        Vector3.new(0, -v6, 0),
        Vector3.new(0, 0, v6),
        (Vector3.new(0, 0, -v6)),
    }
    for i2 = 1, 8 do
        v8 = i2 / 9 * 3.141592653589793
        v1 = math.sin(v8) * v6
        v2 = math.cos(v8) * v6
        for j = 0, 15 do
            v3 = j / 16 * 3.141592653589793 * 2
            v4 = math.cos(v3) * v1
            v5 = math.sin(v3) * v1
            table.insert(v7, (Vector3.new(v2, v4, v5)))
            table.insert(v7, (Vector3.new(-v2, v4, v5)))
        end
    end
    return v7
end

local function addUniquePoint(a1, a2, a3) -- Line: 193 -- types: a1: table, a2: table, a3: vector
    local v1 = math.round(a3.Y * 10000)
    local v2 = math.round(a3.Z * 10000)
    local v3 = math.abs(v1)
    if not (v3 >= 67108864) then
        v3 = math.abs(v2)
        if not (v3 >= 67108864) then
            v3 = math.round(a3.X * 10000)
            local v4 = a2[v3]
            if v4 == nil then
                a2[v3] = {}
            end
            local v5 = v1 * 134217728 + v2
            if v4[v5] then
                return
            end
            v4[v5] = true
            table.insert(a1, a3)
            return
        end
    end
    v3 = string.format("%d|%d|%d", math.round(a3.X * 10000), math.round(a3.Y * 10000), (math.round(a3.Z * 10000)))
    if a2[v3] then
        return
    end
    a2[v3] = true
    table.insert(a1, a3)
end

local function buildExpandedPoints(a1, a2, a3, a4) -- Line: 219
    -- upvalues: generateLocalPointsForPrimitive (val), u32 (val), addUniquePoint (val)
    local v1
    local v2 = {}
    local v3 = {}
    for i, v in ipairs((generateLocalPointsForPrimitive(a1, a3))) do
        v1 = a2:PointToWorldSpace(v)
        for i2, i3 in ipairs(u32) do
            addUniquePoint(v2, v3, v1 + i3 * v4)
        end
    end
    return v2
end

local function buildExpandedPointsForInstances(a1, a2) -- Line: 239
    -- upvalues: u28 (val), generateLocalPointsForPrimitive (val), u32 (val), addUniquePoint (val)
    local v1, v2
    local v3 = {}
    local v4 = {}
    for i, v in ipairs(a1) do
        v2 = u28.Get(v)
        for i2, i3 in ipairs((generateLocalPointsForPrimitive(v, v2.Size))) do
            v1 = v2.CFrame:PointToWorldSpace(i3)
            for i4, j in ipairs(u32) do
                addUniquePoint(v3, v4, v1 + j * a2)
            end
        end
    end
    return v3
end

local function buildWorldPointsForInstances(a1) -- Line: 257
    -- upvalues: u28 (val), generateLocalPointsForPrimitive (val), addUniquePoint (val)
    local v1
    local v2 = {}
    local v3 = {}
    for i, v in ipairs(a1) do
        v1 = u28.Get(v)
        for i2, i3 in ipairs((generateLocalPointsForPrimitive(v, v1.Size))) do
            addUniquePoint(v2, v3, v1.CFrame:PointToWorldSpace(i3))
        end
    end
    return v2
end

local function buildWorldPointsFromLocalPoints(a1, a2) -- Line: 272 -- types: a1: userdata, a2: table
    local v1 = table.create(#a2)
    for i, v in ipairs(a2) do
        v1[i] = (a1:PointToWorldSpace(v))
    end
    return v1
end

local function findPointBounds(a1) -- Line: 280 -- types: a1: table
    local v1 = Vector3.new((1 / 0), (1 / 0), (1 / 0))
    local v2 = Vector3.new((-1 / 0), (-1 / 0), (-1 / 0))
    for i, v in ipairs(a1) do
        v1 = Vector3.new(math.min(v1.X, v.X), math.min(v1.Y, v.Y), (math.min(v1.Z, v.Z)))
        v2 = Vector3.new(math.max(v2.X, v.X), math.max(v2.Y, v.Y), (math.max(v2.Z, v.Z)))
    end
    return v1, v2
end

local function buildWorldAabb(a1, a2) -- Line: 294 -- upvalues: u32 (val) -- types: a1: userdata, a2: vector
    local v1
    local v2 = Vector3.new((1 / 0), (1 / 0), (1 / 0))
    local v3 = Vector3.new((-1 / 0), (-1 / 0), (-1 / 0))
    for i, v in ipairs(u32) do
        v1 = a1:PointToWorldSpace(v * a2)
        v2 = Vector3.new(math.min(v2.X, v1.X), math.min(v2.Y, v1.Y), (math.min(v2.Z, v1.Z)))
        v3 = Vector3.new(math.max(v3.X, v1.X), math.max(v3.Y, v1.Y), (math.max(v3.Z, v1.Z)))
    end
    return v2, v3
end

local function buildWorldAabbCornerPoints(a1, a2) -- Line: 315 -- types: a1: vector, a2: vector
    return {
        Vector3.new(a1.X, a1.Y, a1.Z),
        Vector3.new(a1.X, a1.Y, a2.Z),
        Vector3.new(a1.X, a2.Y, a1.Z),
        Vector3.new(a1.X, a2.Y, a2.Z),
        Vector3.new(a2.X, a1.Y, a1.Z),
        Vector3.new(a2.X, a1.Y, a2.Z),
        Vector3.new(a2.X, a2.Y, a1.Z),
        (Vector3.new(a2.X, a2.Y, a2.Z)),
    }
end

local function planeMatches(a1, a2, a3) -- Line: 328 -- types: a2: vector, a3: number
    local v1 = false
    if (a1.n - a2).Magnitude <= 0.001 then
        v1 = (math.abs(a1.ed - a3)) <= 0.001
    end
    return v1
end

local function addPlane(a1, a2, a3, a4, a5) -- Line: 333 -- types: a2: vector, a3: number, a4: number, a5: string?
    local v1
    local v2, v3, v4, v5, v6 = a2, a3, a4, a5, a1
    for i, v in ipairs(a1) do
        v1 = false
        if (v.n - v2).Magnitude <= 0.001 then
            v1 = (math.abs(v.ed - v3)) <= 0.001
        end
        if v1 then
            return false
        end
    end
    table.insert(v6, {n = v2, ed = v3, planeNum = v4, minkowskiPlaneKind = v5})
    return true
end

local function buildAabbPlanes(a1, a2) -- Line: 349 -- upvalues: findPointBounds (val) -- types: a1: table, a2: number
    local v1, v2 = findPointBounds(a1)
    local u6 = {}

    local function pushPlane(a1, a2_2) -- Line: 352 -- upvalues: a2 (ref), u6 (val) -- types: a1: vector, a2_2: number
        a2 = a2 + 1
        table.insert(u6, {n = a1, ed = a2_2, planeNum = a2})
    end

    local X = v2.X
    a2 = a2 + 1
    table.insert(u6, {n = Vector3.new(1, 0, 0), ed = X, planeNum = a2})
    local v3 = -v1.X
    a2 = a2 + 1
    table.insert(u6, {n = Vector3.new(-1, -0, -0), ed = v3, planeNum = a2})
    local Y = v2.Y
    a2 = a2 + 1
    table.insert(u6, {n = Vector3.new(0, 1, 0), ed = Y, planeNum = a2})
    v3 = -v1.Y
    a2 = a2 + 1
    table.insert(u6, {n = Vector3.new(-0, -1, -0), ed = v3, planeNum = a2})
    local Z = v2.Z
    a2 = a2 + 1
    table.insert(u6, {n = Vector3.new(0, 0, 1), ed = Z, planeNum = a2})
    v3 = -v1.Z
    a2 = a2 + 1
    table.insert(u6, {n = Vector3.new(-0, -0, -1), ed = v3, planeNum = a2})
    local v4 = a2
    return u6, v4
end

local function buildPlanesForPoints(a1, a2) -- Line: 371
    -- upvalues: QuickHull (val), addPlane (val)
    local Unit, v1
    assert(#a1 >= 4, "A convex movement hull requires at least four points")
    local v2 = QuickHull.GenerateHull(a1)
    assert(#v2 > 0, "QuickHull returned no triangles")
    local v3 = {}
    local v4 = a2
    for i, v in ipairs(v2) do
        v1 = (v[1] - v[2]):Cross(v[1] - v[3])
        if 0.001 < v1.Magnitude then
            Unit = v1.Unit
            if addPlane(v3, Unit, v[1]:Dot(Unit), v4 + 1) then
                v4 = v4 + 1
                v3[#v3].planeNum = v4
            end
        end
    end
    assert(#v3 > 0, "QuickHull returned no usable planes")
    return v3, v4
end

local function isAxisAlignedBlockPart(a1, a2, a3) -- Line: 395 -- types: a1: userdata, a3: userdata
    if a2 == Enum.PartType.Block and a1:IsA("Part") then
        for i, v in ipairs({a3.RightVector, a3.UpVector, a3.LookVector}) do
            if (math.max(math.abs(v.X), math.abs(v.Y), (math.abs(v.Z)))) < 0.999999 then
                return false
            end
        end
        return true
    end
    return false
end

local function rawHullRecord(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 411
    -- upvalues: 
    return {
        buildMode = a1,
        sourceShape = a2,
        sourceCFrame = a3.CFrame,
        sourceSize = a3.Size,
        surfaceFriction = a4,
        hull = a5,
        points = a6,
        aabbMin = a7,
        aabbMax = a8,
    }
end

local function buildAxisAlignedBlockHullRecord(a1, a2, a3, a4) -- Line: 434
    -- upvalues: buildWorldAabb (val), buildAabbPlanes (val), buildWorldAabbCornerPoints (val)
    local v1, v2 = buildWorldAabb(a2.CFrame, a2.Size)
    local v3 = a3 * 0.5
    v1 = v1 - v3
    v2 = v2 + v3
    local v4, v5 = buildAabbPlanes({v1, v2}, a4)
    return {
        buildMode = "primitiveAabbPlanes",
        sourceShape = Enum.PartType.Block.Name,
        sourceCFrame = a2.CFrame,
        sourceSize = a2.Size,
        surfaceFriction = 1,
        hull = v4,
        points = buildWorldAabbCornerPoints(v1, v2),
        aabbMin = v1,
        aabbMax = v2,
    }, v5
end

local u76 = {}
u76[1] = (Vector3.new(1, 0, 0))
u76[2] = (Vector3.new(0, 1, 0))
u76[3] = (Vector3.new(0, 0, 1))

local function buildOrientedBlockPlanes(a1, a2, a3, a4) -- Line: 460
    -- upvalues: addPlane (val), u76 (val)
    local v1
    local Position = a1.Position
    local v2 = a2 * 0.5
    local u6 = {}
    local v3 = {direction = a1.RightVector, halfSpan = v2.X}
    local v4 = {direction = a1.UpVector, halfSpan = v2.Y}
    local v5 = {direction = a1.LookVector, halfSpan = v2.Z}
    u6[1] = v3
    u6[2] = v4
    u6[3] = v5
    local u74 = {}

    local function pushPlane(a1, a2) -- Line: 475
        -- upvalues: Position (val), a3 (val), u6 (val), addPlane (upval), u74 (val), a4 (ref)
        if a1.Magnitude <= a2 then
            return
        end
        local Unit = a1.Unit
        local v1 = (Unit:Dot(Position)) + (math.abs(Unit.X)) * a3.X + (math.abs(Unit.Y)) * a3.Y + (math.abs(Unit.Z)) * a3.Z
        for i, v in ipairs(u6) do
            v1 = v1 + (math.abs((Unit:Dot(v.direction)))) * v.halfSpan
        end
        if addPlane(u74, Unit, v1, a4 + 1) then
            a4 = a4 + 1
        end
    end

    for i, v in ipairs(u6) do
        pushPlane(v.direction, 0.001)
        pushPlane(-v.direction, 0.001)
    end
    for i2, i3 in ipairs(u76) do
        pushPlane(i3, 0.001)
        pushPlane(-i3, 0.001)
    end
    for i4, j in ipairs(u6) do
        for i5, k in ipairs(u76) do
            v1 = j.direction:Cross(k)
            pushPlane(v1, 0.02)
            pushPlane(-v1, 0.02)
        end
    end
    local v6 = a4
    return u74, v6
end

local function buildLocalFaceNormals(a1) -- Line: 513 -- upvalues: QuickHull (val) -- types: a1: table
    local Unit, v1, v2
    local v3 = {}
    for i, v in ipairs((QuickHull.GenerateHull(a1))) do
        v1 = (v[1] - v[2]):Cross(v[1] - v[3])
        if 0.001 < v1.Magnitude then
            Unit = v1.Unit
            v2 = true
            for i2, i3 in ipairs(v3) do
                if (i3 - Unit).Magnitude <= 0.001 then
                    v2 = false
                    break
                end
            end
            if v2 then
                table.insert(v3, Unit)
            end
        end
    end
    return v3
end

local function getLocalFaceNormals(a1, a2, a3) -- Line: 535
    -- upvalues: u27 (val), buildLocalFaceNormals (val)
    local v1
    local v2 = u27[a2]
    if v2 == nil then
        u27[a2] = {}
    end
    local v3 = v2[a1]
    if v3 ~= nil then
        v1 = #v3.Points
        if v1 == #a3 then
            v1 = true
            for i, v in ipairs(a3) do
                if v3.Points[i] ~= v then
                    v1 = false
                    break
                end
            end
            if v1 then
                return v3.Normals
            end
        end
    end
    v1 = buildLocalFaceNormals(a3)
    v2[a1] = {Points = table.clone(a3), Normals = v1}
    return v1
end

local function buildLocalHullMinkowskiPlanes(a1, a2, a3, a4, a5, a6) -- Line: 559
    -- upvalues: addPlane (val), u76 (val)
    local v1, v2, v3, v4, v5
    local u132 = {}

    local function pushPlane(a1, a2, a3_2) -- Line: 568
        -- upvalues: a3 (val), a4 (val), addPlane (upval), u132 (val), a5 (ref)
        if a1.Magnitude <= a2 then
            return
        end
        local Unit = a1.Unit
        local v1 = (-1 / 0)
        for i, v in ipairs(a3) do
            v1 = math.max(v1, (v:Dot(Unit)))
        end
        v1 = v1 + ((math.abs(Unit.X)) * a4.X + (math.abs(Unit.Y)) * a4.Y + (math.abs(Unit.Z)) * a4.Z)
        if addPlane(u132, Unit, v1, a5 + 1, a3_2) then
            a5 = a5 + 1
        end
    end

    for i, v in ipairs(a6) do
        pushPlane(a1:VectorToWorldSpace(v), 0.001, "sourceFace")
    end
    for i2, i3 in ipairs(u76) do
        pushPlane(i3, 0.001, "playerAxis")
        pushPlane(-i3, 0.001, "playerAxis")
    end
    local v6 = #a6
    local v7, v8 = a6, a1
    for j = 1, v6 do
        v2 = j + 1
        v1 = #v7
        for k = v2, v1 do
            v3 = v7[j]:Cross(v7[k])
            if 0.02 < v3.Magnitude then
                v4 = v8:VectorToWorldSpace(v3.Unit)
                for i4, n in ipairs(u76) do
                    v5 = v4:Cross(n)
                    pushPlane(v5, 0.02, "edgeBevel")
                    pushPlane(-v5, 0.02, "edgeBevel")
                end
            end
        end
    end
    local v9 = a5
    return u132, v9
end

local function buildLocalPrimitiveHullRecord(a1, a2, a3, a4, a5, a6) -- Line: 610
    -- upvalues: generateLocalPointsForPrimitive (val), buildWorldPointsFromLocalPoints (val)
    -- upvalues: buildLocalHullMinkowskiPlanes (val), getLocalFaceNormals (val), buildExpandedPoints (val)
    -- upvalues: findPointBounds (val)
    local v1 = generateLocalPointsForPrimitive(a1, a2.Size)
    local v2, v3 = buildLocalHullMinkowskiPlanes(
        a2.CFrame,
        v1,
        buildWorldPointsFromLocalPoints(a2.CFrame, v1),
        a4 * 0.5,
        a5,
        (getLocalFaceNormals("Primitive", a1, v1))
    )
    local v4 = buildExpandedPoints(a1, a2.CFrame, a2.Size, a4)
    local v5, v6 = findPointBounds(v4)
    return {
        buildMode = if not a6 then if a3 ~= Enum.PartType.Cylinder then "primitiveLocalHullPlanes" else "polygonCylinderLocalHullPlanes" else "authoredHullPlanes",
        sourceShape = if not a6 then a3.Name else "Hull",
        sourceCFrame = a2.CFrame,
        sourceSize = a2.Size,
        surfaceFriction = 1,
        hull = v2,
        points = v4,
        aabbMin = v5,
        aabbMax = v6,
    }, v3
end

local function buildOrientedBlockHullRecord(a1, a2, a3, a4) -- Line: 646
    -- upvalues: buildOrientedBlockPlanes (val), buildExpandedPoints (val), findPointBounds (val)
    local v1, v2 = buildOrientedBlockPlanes(a2.CFrame, a2.Size, a3 * 0.5, a4)
    local v3 = buildExpandedPoints(a1, a2.CFrame, a2.Size, a3)
    local v4, v5 = findPointBounds(v3)
    return {
        buildMode = "primitiveBlockPlanes",
        sourceShape = Enum.PartType.Block.Name,
        sourceCFrame = a2.CFrame,
        sourceSize = a2.Size,
        surfaceFriction = 1,
        hull = v1,
        points = v3,
        aabbMin = v4,
        aabbMax = v5,
    }, v2
end

function v1.BuildHullRecord(a1, a2, a3) -- Line: 663
    -- upvalues: findShapeForInstance (val), u28 (val), HullPoints (val), buildLocalPrimitiveHullRecord (val)
    -- upvalues: isAxisAlignedBlockPart (val), buildAxisAlignedBlockHullRecord (val), buildOrientedBlockHullRecord (val)
    -- upvalues: buildExpandedPoints (val), buildPlanesForPoints (val), findPointBounds (val)
    local v1 = findShapeForInstance(a1)
    local v2 = u28.Get(a1)
    if HullPoints.Read(a1) ~= nil then
        return buildLocalPrimitiveHullRecord(a1, v2, v1, a2, a3, true)
    end
    if isAxisAlignedBlockPart(a1, v1, v2.CFrame) then
        return buildAxisAlignedBlockHullRecord(a1, v2, a2, a3)
    end
    if v1 == Enum.PartType.Block then
        return buildOrientedBlockHullRecord(a1, v2, a2, a3)
    end
    if v1 ~= Enum.PartType.Cylinder and v1 ~= Enum.PartType.Wedge and v1 ~= Enum.PartType.CornerWedge then
        local v3 = buildExpandedPoints(a1, v2.CFrame, v2.Size, a2)
        local v4, v5 = buildPlanesForPoints(v3, a3)
        local v6, v7 = findPointBounds(v3)
        return {
            buildMode = "primitiveQuickHull",
            sourceShape = v1.Name,
            sourceCFrame = v2.CFrame,
            sourceSize = v2.Size,
            surfaceFriction = 1,
            hull = v4,
            points = v3,
            aabbMin = v6,
            aabbMax = v7,
        }, v5
    end
    return buildLocalPrimitiveHullRecord(a1, v2, v1, a2, a3)
end

function v1.BuildMergedHullRecord(a1, a2, a3) -- Line: 696
    -- upvalues: u28 (val), buildWorldPointsForInstances (val), buildLocalHullMinkowskiPlanes (val)
    -- upvalues: getLocalFaceNormals (val), buildExpandedPointsForInstances (val), findPointBounds (val)
    assert(#a1 >= 2, "A merged movement hull requires at least two parts")
    local v1 = a1[1]
    local v2 = u28.Get(v1)
    local CFrame = v2.CFrame
    local v3 = buildWorldPointsForInstances(a1)
    local v4 = table.create(#v3)
    for i, v in ipairs(v3) do
        v4[i] = (CFrame:PointToObjectSpace(v))
    end
    local v5, v6 = buildLocalHullMinkowskiPlanes(CFrame, v4, v3, a2 * 0.5, a3, (getLocalFaceNormals("Merged", v1, v4)))
    local v7 = buildExpandedPointsForInstances(a1, a2)
    local v8, v9 = findPointBounds(v7)
    return {
        buildMode = "mergedLocalHullPlanes",
        sourceShape = "Merged",
        sourceCFrame = v2.CFrame,
        sourceSize = v2.Size,
        surfaceFriction = 1,
        hull = v5,
        points = v7,
        aabbMin = v8,
        aabbMax = v9,
    }, v6
end

local function aabbsTouch(a1, a2, a3, a4) -- Line: 730 -- types: a1: vector, a2: vector, a3: vector, a4: vector
    local v1 = false
    if a1.X <= a4.X + 0.05 then
        v1 = false
        if a3.X <= a2.X + 0.05 then
            v1 = false
            if a1.Y <= a4.Y + 0.05 then
                v1 = false
                if a3.Y <= a2.Y + 0.05 then
                    v1 = false
                    if a1.Z <= a4.Z + 0.05 then
                        v1 = a3.Z <= a2.Z + 0.05
                    end
                end
            end
        end
    end
    return v1
end

local function hasCompatibleOrientation(a1, a2) -- Line: 739 -- upvalues: u28 (val) -- types: a1: userdata, a2: userdata
    local v1 = u28.GetCFrame(a1)
    local v2 = u28.GetCFrame(a2)
    local v3 = false
    if 0.999 <= (v1.RightVector:Dot(v2.RightVector)) then
        v3 = false
        if 0.999 <= (v1.UpVector:Dot(v2.UpVector)) then
            v3 = 0.999 <= (v1.LookVector:Dot(v2.LookVector))
        end
    end
    return v3
end

local function componentContainsRampShape(a1) -- Line: 747 -- upvalues: findShapeForInstance (val) -- types: a1: table
    local v1
    for i, v in ipairs(a1) do
        v1 = findShapeForInstance(v)
        if v1 ~= Enum.PartType.Wedge and v1 ~= Enum.PartType.CornerWedge then
            continue
        end
        return true
    end
    return false
end

local function componentIsNarrowStrip(a1) -- Line: 758 -- upvalues: u28 (val) -- types: a1: table
    local v1, v2
    local v3 = u28.GetCFrame(a1[1])
    local v4 = (1 / 0)
    local v5 = (-1 / 0)
    local v6 = (1 / 0)
    local v7 = (-1 / 0)
    local v8 = 0
    local v9 = 0
    for i, v in ipairs(a1) do
        v1 = u28.Get(v)
        v2 = v3:PointToObjectSpace(v1.CFrame.Position)
        v4 = math.min(v4, v2.X)
        v5 = math.max(v5, v2.X)
        v6 = math.min(v6, v2.Z)
        v7 = math.max(v7, v2.Z)
        v8 = v8 + v1.Size.X
        v9 = v9 + v1.Size.Z
    end
    local v10 = v8 / math.max(#a1, 1)
    local v11 = v9 / math.max(#a1, 1)
    local v12 = math.max(0.05, v10 * 0.6)
    local v13 = math.max(0.05, v11 * 0.6)
    local v14 = true
    if not (v5 - v4 <= v12) then
        v14 = v7 - v6 <= v13
    end
    return v14
end

local function getExplicitConvexGroupId(a1) -- Line: 786 -- types: a1: userdata
    local Attribute = a1:GetAttribute("MovementConvexGroup")
    if typeof(Attribute) == "string" and Attribute ~= "" then
        return Attribute
    end
    if typeof(Attribute) == "number" then
        return (tostring(Attribute))
    end
    return nil
end

function v1.FindMergedPartGroups(a1) -- Line: 798
    -- upvalues: findShapeForInstance (val), CollectionService (val), HullPoints (val), u28 (val), buildWorldAabb (val)
    -- upvalues: hasCompatibleOrientation (val), aabbsTouch (val), componentContainsRampShape (val)
    -- upvalues: componentIsNarrowStrip (val)
    local Attribute, Parent, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
    local v12 = {}
    local v13 = {}
    local v14 = {}
    local v15 = {}
    local v16 = {}
    local v17 = #a1 <= 512
    for i, v in ipairs(a1) do
        v1 = findShapeForInstance(v)
        v2 = true
        if v1 ~= Enum.PartType.Block then
            v2 = true
            if v1 ~= Enum.PartType.Wedge then
                v2 = v1 == Enum.PartType.CornerWedge
            end
        end
        if v2 then
            v2 = true
            if v:GetAttribute("Climbable") ~= true then
                v2 = CollectionService:HasTag(v, "Ladder")
            end
            if not v2 and v:GetAttribute("DisableMovementSeamMerge") ~= true and HullPoints.Read(v) == nil then
                v2 = u28.Get(v)
                v3, v4 = buildWorldAabb(v2.CFrame, v2.Size)
                v16[v] = {minPoint = v3, maxPoint = v4}
                Attribute = v:GetAttribute("MovementConvexGroup")
                v5 = if typeof(Attribute) ~= "string" then if typeof(Attribute) ~= "number" then nil else tostring(Attribute) else if Attribute == "" then if typeof(Attribute) ~= "number" then nil else tostring(Attribute) else Attribute
                if v5 == nil then
                    Parent = v.Parent
                    if Parent ~= nil and v17 then
                        v7 = v15[Parent]
                        if v7 == nil then
                            v15[Parent] = {}
                        end
                        v7[#v7 + 1] = v
                    end
                else
                    v6 = v14[v5]
                    if v6 == nil then
                        v14[v5] = {}
                    end
                    v6[#v6 + 1] = v
                end
            end
        end
    end
    for k, i2 in pairs(v14) do
        if #i2 >= 2 then
            v12[#v12 + 1] = i2
            for i3, j in ipairs(i2) do
                v13[j] = true
            end
        end
    end
    for k2, k3 in pairs(v15) do
        v1 = {}
        for i4, n in ipairs(k3) do
            if not v1[n] and not v13[n] then
                v7 = {}
                v8 = {n}
                v1[n] = true
                while #v8 > 0 do
                    v9 = v8[#v8]
                    v8[#v8] = nil
                    v7[#v7 + 1] = v9
                    v10 = v16[v9]
                    if v10 ~= nil then
                        for i5, m in ipairs(k3) do
                            if not v1[m] and not v13[m] and m ~= v9 then
                                v11 = v16[m]
                                if v11 ~= nil
                                    and hasCompatibleOrientation(v9, m)
                                    and aabbsTouch(v10.minPoint, v10.maxPoint, v11.minPoint, v11.maxPoint) then
                                    v1[m] = true
                                    v8[#v8 + 1] = m
                                end
                            end
                        end
                    end
                end
                if #v7 >= 2 and #v7 <= 8 and componentContainsRampShape(v7) and componentIsNarrowStrip(v7) then
                    v12[#v12 + 1] = v7
                    for i6, i52 in ipairs(v7) do
                        v13[i52] = true
                    end
                end
            end
        end
    end
    return v12
end

return v1