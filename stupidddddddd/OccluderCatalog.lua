-- ReplicatedStorage.Visibility.OBJGeometry.OccluderCatalog
-- Script path: ReplicatedStorage.Visibility.OBJGeometry.OccluderCatalog
-- Decompile time: 7.03 ms

local Constants = require(script.Parent.Constants)
local GeometryFingerprint = require(script.Parent.GeometryFingerprint)
local MaterialService = game:GetService("MaterialService")
local v1 = {}
local u18 = table.freeze({
    barriers = true,
    pvscells = true,
    pvsvolumes = true,
    pvsstaticocclusion = true,
    pvsvisibilitygeometry = true,
})
local u27 = table.freeze({
    [Enum.Material.Neon] = true,
    [Enum.Material.Glass] = true,
    [Enum.Material.ForceField] = true,
})

local function hasTrueAttribute(a1, a2) -- Line: 41 -- types: a1: userdata, a2: string
    return a1:GetAttribute(a2) == true
end

local function hasMarkerOnPath(a1, a2, a3, a4) -- Line: 45
    -- upvalues: 
    local Parent = a2
    local v1 = a3
    while Parent ~= nil do
        if not (Parent:GetAttribute(v1) == true) and not v2(Parent, v1) then
            if Parent == v3 then
                break
            end
            Parent = Parent.Parent
            continue
        end
        return true
    end
    return false
end

local function hasDynamicTagOnPath(a1, a2, a3) -- Line: 59
    -- upvalues: Constants (val)
    local Parent = a2
    while Parent ~= nil do
        for i, j in Constants.DYNAMIC_TAGS do
            if v1(Parent, j) then
                return true
            end
        end
        if Parent == v2 then
            break
        end
        Parent = Parent.Parent
    end
    return false
end

local function collectParts(a1) -- Line: 75 -- types: a1: userdata
    local v1 = {}
    if a1:IsA("BasePart") then
        table.insert(v1, a1)
    end
    for i, j in a1:GetDescendants() do
        if j:IsA("BasePart") then
            table.insert(v1, j)
        end
    end
    return v1
end

local function isInReservedSubtree(a1, a2) -- Line: 88 -- upvalues: u18 (val) -- types: a1: userdata, a2: userdata
    local v1
    local Parent = a2
    while Parent ~= nil do
        v1 = string.lower(Parent.Name)
        if u18[v1] ~= true and string.sub(v1, 1, 24) ~= "__pvsvisibilityobjstage_" then
            if Parent == a1 then
                break
            end
            Parent = Parent.Parent
            continue
        end
        return true
    end
    return false
end

local function stableInstancePath(a1, a2) -- Line: 106 -- types: a1: userdata, a2: userdata
    local v1 = {}
    local Parent = a2
    while Parent ~= nil do
        table.insert(v1, 1, (("%*:%*"):format(Parent.ClassName, Parent.Name)))
        if Parent == a1 then
            break
        end
        Parent = Parent.Parent
    end
    return table.concat(v1, "/")
end

local function contentSourceName(a1) -- Line: 119
    local success, result = pcall(function() -- Line: 120 -- upvalues: a1 (val)
        return a1.SourceType
    end)
    if success and result ~= nil then
        local success_2, result_2 = pcall(function() -- Line: 126 -- upvalues: result (val)
            return result.Name
        end)
        if success_2 and typeof(result_2) == "string" then
            return result_2
        end
        return string.match(tostring(result), "([%w_]+)$")
    end
    return nil
end

local function meshProviderIssue(a1) -- Line: 135 -- upvalues: contentSourceName (val) -- types: a1: userdata
    local result_3, success_3
    local success, result = pcall(function() -- Line: 137 -- upvalues: a1 (val)
        return a1.MeshContent
    end)
    if not success then
        if true then
            success_3, result_3 = pcall(function() -- Line: 164 -- upvalues: a1 (val)
                return a1.MeshId
            end)
            if success_3 and result_3 ~= nil and tostring(result_3) ~= "" then
                return nil
            end
            return "UnverifiableMeshContent"
        end
        return nil
    end
    if result == nil then
        return "UnverifiableMeshContent"
    end
    local v1 = contentSourceName(result)
    if v1 ~= "Uri" then
        if v1 ~= nil then
            return (("NonUriMeshContent:%*"):format(v1))
        end
        return "UnverifiableMeshContent"
    end
    local success_2, result_2 = pcall(function() -- Line: 146 -- upvalues: result (val)
        return result.Uri
    end)
    if success_2 and typeof(result_2) == "string" and result_2 ~= "" then
        if result_2 ~= nil then
            return nil
        end
        success_3, result_3 = pcall(function() -- Line: 164 -- upvalues: a1 (val)
            return a1.MeshId
        end)
        if success_3 and result_3 ~= nil and tostring(result_3) ~= "" then
            return nil
        end
        return "UnverifiableMeshContent"
    end
    return "UnverifiableMeshContent"
end

local function immutableMeshIssue(a1) -- Line: 174 -- upvalues: meshProviderIssue (val) -- types: a1: userdata
    local v1, v2, v3
    if a1:IsA("MeshPart") then
        v1 = meshProviderIssue(a1)
        if v1 ~= nil then
            return v1
        end
    end
    v1 = 0
    for i, j in a1:GetChildren() do
        if j:IsA("DataModelMesh") then
            v1 = v1 + 1
            if v1 > 1 then
                return "MultipleMeshChildren"
            end
            if not j.Archivable then
                return "NonArchivableMeshChild"
            end
        end
        v2 = j:IsA("FileMesh")
        if j:IsA("SpecialMesh") then
            v2 = j.MeshType == Enum.MeshType.FileMesh
        end
        if v2 then
            v3 = meshProviderIssue(j)
            if v3 ~= nil then
                return v3
            end
        end
    end
    return nil
end

local function alphaTransparencyIssue(a1) -- Line: 206
    -- upvalues: u27 (val), MaterialService (val)
    local result_2, success_2
    for i, j in a1:GetChildren() do
        if j:IsA("SurfaceAppearance") and j.AlphaMode == Enum.AlphaMode.Transparency then
            return "SurfaceAppearanceAlphaTransparency"
        end
    end
    local MaterialVariant = a1.MaterialVariant
    if MaterialVariant == "" and u27[a1.Material] then
        return nil
    end
    if MaterialVariant ~= "" then
        if MaterialVariant ~= "" then
            success_2, result_2 = pcall(MaterialService.GetMaterialVariant, MaterialService, a1.Material, MaterialVariant)
            if not success_2 then
                return "UnverifiableMaterialVariant"
            end
            if result_2 ~= nil and result_2.AlphaMode == Enum.AlphaMode.Transparency then
                return "MaterialVariantAlphaTransparency"
            end
        end
        return nil
    end
    local success, result = pcall(MaterialService.GetBaseMaterialOverride, MaterialService, a1.Material)
    if success and typeof(result) == "string" then
        MaterialVariant = result
        if MaterialVariant ~= "" then
            success_2, result_2 = pcall(MaterialService.GetMaterialVariant, MaterialService, a1.Material, MaterialVariant)
            if not success_2 then
                return "UnverifiableMaterialVariant"
            end
            if result_2 ~= nil and result_2.AlphaMode == Enum.AlphaMode.Transparency then
                return "MaterialVariantAlphaTransparency"
            end
        end
        return nil
    end
    return "UnverifiableMaterialVariant"
end

function v1.build(a1, a2) -- Line: 235
    -- upvalues: collectParts (val), hasMarkerOnPath (val), Constants (val), isInReservedSubtree (val)
    -- upvalues: hasDynamicTagOnPath (val), GeometryFingerprint (val), alphaTransparencyIssue (val)
    -- upvalues: immutableMeshIssue (val), stableInstancePath (val)
    local v1, v2, v3
    local v4 = {}
    local v5 = {}
    local v6 = 0
    local v7 = 0
    local v8 = 0
    local v9 = 0
    local v10, v11 = a1, a2
    for i, j in collectParts(a1) do
        v1 = hasMarkerOnPath(v10, j, Constants.OCCLUDER_MARKER, v11)
        if isInReservedSubtree(v10, j) then
            if v1 then
                v6 = v6 + 1
            end
            v8 = v8 + 1
            v9 = v9 + 1
        elseif v1 then
            v6 = v6 + 1
            if hasMarkerOnPath(v10, j, Constants.IGNORE_MARKER, v11)
                or hasMarkerOnPath(v10, j, Constants.DYNAMIC_MARKER, v11)
                or hasDynamicTagOnPath(v10, j, v11) then
                v8 = v8 + 1
            elseif GeometryFingerprint.supportsPart(j) then
                v2 = alphaTransparencyIssue(j)
                if v2 ~= nil then
                    table.insert(v5, {part = j, reason = v2})
                elseif not j:IsA("MeshPart") then
                    if not j:IsA("MeshPart") or j:FindFirstChildWhichIsA("BaseWrap", true) == nil then
                        v3 = immutableMeshIssue(j)
                        if v3 ~= nil then
                            table.insert(v5, {part = j, reason = v3})
                        elseif not j.Anchored then
                            table.insert(v5, {reason = "NotAnchored", part = j})
                        elseif j.Material == Enum.Material.Glass then
                            table.insert(v5, {reason = "GlassMaterial", part = j})
                        elseif j.Material == Enum.Material.ForceField then
                            table.insert(v5, {reason = "ForceFieldMaterial", part = j})
                        elseif not (Constants.OPAQUE_TRANSPARENCY_LIMIT < j.Transparency) then
                            table.insert(v4, j)
                        else
                            table.insert(v5, {reason = "Transparent", part = j})
                        end
                    else
                        table.insert(v5, {reason = "DeformedMesh", part = j})
                    end
                elseif j:FindFirstChildWhichIsA("Bone", true) ~= nil then
                    table.insert(v5, {reason = "SkinnedMesh", part = j})
                elseif not j:IsA("MeshPart") or j:FindFirstChildWhichIsA("BaseWrap", true) == nil then
                    v3 = immutableMeshIssue(j)
                    if v3 ~= nil then
                        table.insert(v5, {part = j, reason = v3})
                    elseif not j.Anchored then
                        table.insert(v5, {reason = "NotAnchored", part = j})
                    elseif j.Material == Enum.Material.Glass then
                        table.insert(v5, {reason = "GlassMaterial", part = j})
                    elseif j.Material == Enum.Material.ForceField then
                        table.insert(v5, {reason = "ForceFieldMaterial", part = j})
                    elseif not (Constants.OPAQUE_TRANSPARENCY_LIMIT < j.Transparency) then
                        table.insert(v4, j)
                    else
                        table.insert(v5, {reason = "Transparent", part = j})
                    end
                else
                    table.insert(v5, {reason = "DeformedMesh", part = j})
                end
            else
                table.insert(v5, {part = j, reason = ("UnsupportedClass:%*"):format(j.ClassName)})
            end
        else
            v7 = v7 + 1
        end
    end
    local u20 = {}
    for k, n in v4 do
        u20[n] = (stableInstancePath(v10, n))
    end
    for m, i5 in v5 do
        u20[i5.part] = (stableInstancePath(v10, i5.part))
    end
    table.sort(v4, function(a1, a2) -- Line: 317 -- upvalues: u20 (val)
        local v1 = u20[a1]
        local v2 = u20[a2]
        if v1 ~= v2 then
            return v1 < v2
        end
        local Position_2 = a1.Position
        local Position = a2.Position
        if Position_2.X ~= Position.X then
            return Position_2.X < Position.X
        end
        if Position_2.Y ~= Position.Y then
            return Position_2.Y < Position.Y
        end
        if Position_2.Z ~= Position.Z then
            return Position_2.Z < Position.Z
        end
        return (tostring(a1.Size)) < tostring(a2.Size)
    end)
    table.sort(v5, function(a1, a2) -- Line: 335 -- upvalues: u20 (val)
        return u20[a1.part] < u20[a2.part]
    end)
    return {
        root = v10,
        parts = v4,
        rejections = v5,
        explicitPartCount = v6,
        untaggedPartCount = v7,
        excludedPartCount = v8,
        reservedPartCount = v9,
    }
end

function v1.path(a1, a2) -- Line: 350 -- upvalues: stableInstancePath (val) -- types: a1: userdata, a2: userdata
    return stableInstancePath(a1, a2)
end

return table.freeze(v1)