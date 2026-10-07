-- ReplicatedStorage.Visibility.BarrierGeometry
-- Script path: ReplicatedStorage.Visibility.BarrierGeometry
-- Decompile time: 2.55 ms

local CollectionService = game:GetService("CollectionService")
local v1 = {}
local u13 = table.freeze({"BreakableDoor", "BreakableGlass", "Garage", "Market Window", "Vent"})

local function findBarrierRoot(a1) -- Line: 28 -- types: a1: userdata
    local Barriers = a1:FindFirstChild("Barriers")
    if Barriers then
        return Barriers
    end
    return a1:FindFirstChild("Barriers", true)
end

local function shouldIgnore(a1, a2) -- Line: 36
    -- upvalues: u13 (val), CollectionService (val)
    local Parent = a1
    while Parent do
        if Parent:GetAttribute("PVSIgnore") == true then
            return true
        end
        for i, v in ipairs(u13) do
            if CollectionService:HasTag(Parent, v) then
                return true
            end
        end
        if Parent == v1 then
            break
        end
        Parent = Parent.Parent
    end
    return false
end

local function supportedKind(a1) -- Line: 55 -- types: a1: userdata
    if a1:IsA("WedgePart") then
        return "Wedge"
    end
    if a1:IsA("CornerWedgePart") then
        return "CornerWedge"
    end
    if a1:IsA("Part") then
        if a1.Shape == Enum.PartType.Block then
            return "Block"
        end
        if a1.Shape == Enum.PartType.Cylinder then
            return "Cylinder"
        end
        if a1.Shape == Enum.PartType.Ball then
            return "Ball"
        end
        if a1.Shape == Enum.PartType.Wedge then
            return "Wedge"
        end
        if a1.Shape == Enum.PartType.CornerWedge then
            return "CornerWedge"
        end
    end
    return nil
end

local function relativePath(a1, a2) -- Line: 78 -- types: a1: userdata, a2: userdata
    local v1 = {}
    local Parent = a1
    while Parent do
        if Parent == a2 then
            break
        end
        table.insert(v1, 1, Parent.Name)
        Parent = Parent.Parent
    end
    return table.concat(v1, "/")
end

local function geometryKey(a1, a2, a3) -- Line: 88
    -- upvalues: relativePath (val)
    local v1 = {a1.CFrame:GetComponents()}
    local v2 = table.create(#v1 + 3)
    for i, v in ipairs(v1) do
        v2[#v2 + 1] = (string.format("%.9g", v))
    end
    v2[#v2 + 1] = (string.format("%.9g", a1.Size.X))
    v2[#v2 + 1] = (string.format("%.9g", a1.Size.Y))
    v2[#v2 + 1] = (string.format("%.9g", a1.Size.Z))
    return (("%*|%*|%*"):format(relativePath(a1, a2), a3, (table.concat(v2, ","))))
end

local function fingerprint(a1) -- Line: 101 -- types: a1: table
    local v1
    local v2 = 5381
    for i, v in ipairs(a1) do
        v1 = #v
        for i2 = 1, v1 do
            v2 = bit32.band(v2 * 33 + string.byte(v, i2), 4294967295)
        end
        v2 = bit32.band(v2 * 33 + 10, 4294967295)
    end
    return string.format("BPR1-%08x-%d", v2, #a1)
end

function v1.collect(a1) -- Line: 112
    -- upvalues: shouldIgnore (val), supportedKind (val), geometryKey (val), relativePath (val), fingerprint (val)
    local v1
    local Barriers = a1:FindFirstChild("Barriers")
    local u11 = if not Barriers then a1:FindFirstChild("Barriers", true) else Barriers
    if u11 == nil then
        return nil, "MissingBarriers"
    end
    local v2 = {}
    local v3 = {}
    local v4 = {}
    local v5 = 0
    local v6 = 0
    local v7 = 0
    local v8 = 0
    local v9 = {}
    if u11:IsA("BasePart") then
        v9[#v9 + 1] = u11
    end
    for i, v in ipairs(u11:GetDescendants()) do
        if v:IsA("BasePart") then
            v9[#v9 + 1] = v
        end
    end
    for i2, i3 in ipairs(v9) do
        v5 = v5 + 1
        if not shouldIgnore(i3, u11) then
            v1 = supportedKind(i3)
            if v1 == nil then
                v7 = v7 + 1
                v4[i3.ClassName] = (v4[i3.ClassName] or 0) + 1
            elseif i3.CanQuery then
                v2[#v2 + 1] = i3
                v3[#v3 + 1] = (geometryKey(i3, u11, v1))
            else
                v8 = v8 + 1
            end
        else
            v6 = v6 + 1
        end
    end
    if #v2 == 0 then
        return nil, "NoSupportedBarrierPrimitives"
    end
    table.sort(v2, function(a1, a2) -- Line: 162 -- upvalues: relativePath (upval), u11 (val)
        return (relativePath(a1, u11)) < relativePath(a2, u11)
    end)
    table.sort(v3)
    return {
        root = u11,
        parts = v2,
        fingerprint = fingerprint(v3),
        totalParts = v5,
        ignoredParts = v6,
        unsupportedParts = v7,
        unqueryableParts = v8,
        unsupportedClasses = v4,
    }, nil
end

function v1.buildRaycastParams(a1) -- Line: 179 -- types: a1: table
    local v1 = RaycastParams.new()
    v1.FilterType = Enum.RaycastFilterType.Include
    v1.FilterDescendantsInstances = a1.parts
    v1.IgnoreWater = true
    v1.RespectCanCollide = false
    return v1
end

function v1.describeUnsupported(a1) -- Line: 189 -- types: a1: table
    local v1 = {}
    for k, v in pairs(a1.unsupportedClasses) do
        v1[#v1 + 1] = (("%*=%*"):format(k, v))
    end
    table.sort(v1)
    return table.concat(v1, ", ")
end

return table.freeze(v1)