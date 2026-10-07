-- ReplicatedStorage.Visibility.OBJGeometry.GeometryFingerprint
-- Script path: ReplicatedStorage.Visibility.OBJGeometry.GeometryFingerprint
-- Decompile time: 3.77 ms

local Constants = require(script.Parent.Constants)
local u5 = {}

function u5.supportsPart(a1) -- Line: 20 -- types: a1: userdata
    return a1:IsA("Part") or a1:IsA("WedgePart") or a1:IsA("CornerWedgePart") or a1:IsA("MeshPart") or a1:IsA("TrussPart") or a1:IsA("UnionOperation")
end

local function canonicalNumber(a1, a2) -- Line: 29 -- types: a1: number, a2: number?
    local v1 = math.round(a1 / (a2 or 0.0001))
    if v1 == 0 then
        v1 = 0
    end
    return string.format("%d", v1)
end

local function vectorRecord(a1) -- Line: 38 -- upvalues: canonicalNumber (val) -- types: a1: vector
    local concat = table.concat
    local v1 = {}
    local v2 = math.round(a1.X / 0.0001)
    if v2 == 0 then
        v2 = 0
    end
    local v3 = string.format("%d", v2)
    local v4 = math.round(a1.Y / 0.0001)
    if v4 == 0 then
        v4 = 0
    end
    v1[1] = v3
    v1[2] = (string.format("%d", v4))
    v1[3] = canonicalNumber(a1.Z)
    return concat(v1, ",")
end

local function cframeRecord(a1) -- Line: 42 -- types: a1: userdata
    local v1, v2
    local v3 = {a1:GetComponents()}
    local v4 = table.create(#v3)
    local v5 = nil
    local v6 = nil
    for i, j in v3, v5, v6 do
        v2 = if not (i <= 3) then 1e-06 else 0.0001
        v1 = math.round(j / (v2 or 0.0001))
        if v1 == 0 then
            v1 = 0
        end
        v4[i] = (string.format("%d", v1))
    end
    return table.concat(v4, ",")
end

local function lengthPrefixed(a1) -- Line: 51 -- types: a1: string
    return (("%*:%*"):format(#a1, a1))
end

local function assertInsideRoot(a1, a2) -- Line: 55 -- types: a1: userdata, a2: userdata
    local v1 = true
    if a2 ~= a1 then
        v1 = a2:IsDescendantOf(a1)
    end
    assert(v1, "Visibility geometry is outside the selected map root")
end

local function propertyString(a1, a2) -- Line: 59
    -- upvalues: vectorRecord (val), cframeRecord (val), canonicalNumber (val)
    local success, result = pcall(function() -- Line: 60 -- upvalues: a1 (val), a2 (val)
        return a1[a2]
    end)
    if success and result ~= nil then
        if typeof(result) == "Vector3" then
            return vectorRecord(result)
        end
        if typeof(result) == "CFrame" then
            return cframeRecord(result)
        end
        if typeof(result) == "number" then
            return canonicalNumber(result)
        end
        return (tostring(result))
    end
    return ""
end

local function meshChildrenRecord(a1) -- Line: 76 -- upvalues: propertyString (val) -- types: a1: userdata
    local v1 = {}
    for i, j in a1:GetChildren() do
        if j:IsA("DataModelMesh") then
            table.insert(v1, (table.concat({
                j.ClassName,
                propertyString(j, "MeshType"),
                propertyString(j, "MeshId"),
                propertyString(j, "MeshContent"),
                propertyString(j, "Scale"),
                (propertyString(j, "Offset")),
            }, "|")))
        end
    end
    table.sort(v1)
    return table.concat(v1, ";")
end

local function unionRecord(a1) -- Line: 95 -- upvalues: propertyString (val) -- types: a1: userdata
    return table.concat({
        "UnionOperationV2",
        ("MeshSize=%*"):format((propertyString(a1, "MeshSize"))),
        ("RenderFidelity=%*"):format((propertyString(a1, "RenderFidelity"))),
        ("SmoothingAngle=%*"):format((propertyString(a1, "SmoothingAngle"))),
        (("TriangleCount=%*"):format((propertyString(a1, "TriangleCount")))),
    }, "|")
end

local function partRecord(a1, a2) -- Line: 106
    -- upvalues: u5 (val), propertyString (val), unionRecord (val), cframeRecord (val), vectorRecord (val)
    -- upvalues: meshChildrenRecord (val)
    assert(u5.supportsPart(a2), (("Unsupported visibility geometry class %*"):format(a2.ClassName)))
    local v1 = ""
    if a2:IsA("TrussPart") then
        v1 = propertyString(a2, "Style")
    elseif a2:IsA("Part") then
        v1 = tostring(a2.Shape)
    elseif a2:IsA("MeshPart") then
        v1 = table.concat({
            propertyString(a2, "MeshId"),
            propertyString(a2, "MeshContent"),
            propertyString(a2, "MeshSize"),
            propertyString(a2, "RenderFidelity"),
            (propertyString(a2, "DoubleSided")),
        }, "|")
    elseif a2:IsA("UnionOperation") then
        v1 = unionRecord(a2)
    end
    local v2 = true
    if a2 ~= a1 then
        v2 = a2:IsDescendantOf(a1)
    end
    assert(v2, "Visibility geometry is outside the selected map root")
    local concat_2 = table.concat
    v2 = {}
    local ClassName_2 = a2.ClassName
    local v3 = ("%*:%*"):format(#ClassName_2, ClassName_2)
    local v4 = cframeRecord(a2.CFrame)
    local v5 = vectorRecord(a2.Size)
    local v6 = ("%*:%*"):format(#v1, v1)
    local v7 = meshChildrenRecord(a2)
    local v8 = #v7
    v2[1] = "PVSOCCLUDER2"
    v2[2] = v3
    v2[3] = v4
    v2[4] = v5
    v2[5] = v6
    v2[6] = (("%*:%*"):format(v8, v7))
    return concat_2(v2, "|")
end

local function worldBounds(a1) -- Line: 137 -- types: a1: userdata
    local v1 = a1.Size * 0.5
    local CFrame = a1.CFrame
    local RightVector = CFrame.RightVector
    local UpVector = CFrame.UpVector
    local LookVector = CFrame.LookVector
    local v2 = Vector3.new(
        (math.abs(RightVector.X)) * v1.X + (math.abs(UpVector.X)) * v1.Y + (math.abs(LookVector.X)) * v1.Z,
        (math.abs(RightVector.Y)) * v1.X + (math.abs(UpVector.Y)) * v1.Y + (math.abs(LookVector.Y)) * v1.Z,
        (math.abs(RightVector.Z)) * v1.X + (math.abs(UpVector.Z)) * v1.Y + (math.abs(LookVector.Z)) * v1.Z
    )
    return CFrame.Position - v2, CFrame.Position + v2
end

function u5.hashStrings(a1) -- Line: 151 -- types: a1: table
    local v1, v2, v3
    local v4 = 5381
    local v5 = 2166136261
    local v6 = nil
    local v7 = nil
    for i, j in a1, v6, v7 do
        v2 = ("%*:%*"):format(#j, j)
        v3 = #v2
        for k = 1, v3 do
            v1 = string.byte(v2, k)
            v4 = (v4 * 33 + v1) % 4294967296
            v5 = (v5 * 65599 + v1) % 4294967296
        end
    end
    return string.format("%08x%08x", v4, v5)
end

function u5.compute(a1, a2) -- Line: 165
    -- upvalues: partRecord (val), worldBounds (val), Constants (val), u5 (val)
    local v1, v2
    assert(#a2 > 0, "Cannot fingerprint an empty visibility catalog")
    local v3 = table.create(#a2 + 1)
    local v4 = Vector3.new((1 / 0), (1 / 0), (1 / 0))
    local v5 = Vector3.new((-1 / 0), (-1 / 0), (-1 / 0))
    for i, j in a2 do
        table.insert(v3, (partRecord(a1, j)))
        v1, v2 = worldBounds(j)
        v4 = v4:Min(v1)
        v5 = v5:Max(v2)
    end
    table.sort(v3)
    table.insert(
        v3,
        1,
        (("PVSVisibilityExportVersion=%*|Transform=%*|PartCount=%*"):format(Constants.EXPORT_VERSION, Constants.EXPORT_TRANSFORM, #a2))
    )
    return {
        fingerprint = u5.hashStrings(v3),
        minimum = v4,
        maximum = v5,
        partCount = #a2,
        records = v3,
    }
end

return table.freeze(u5)