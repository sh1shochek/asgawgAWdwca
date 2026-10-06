-- Decompiled with Potassium's decompiler.

local Constants = require(script.Parent.Constants);
local GeometryFingerprint = require(script.Parent.GeometryFingerprint);
local MaterialService = game:GetService("MaterialService");
local v1 = {};
local table_freeze_ret = table.freeze({
    barriers = true,
    pvscells = true,
    pvsvolumes = true,
    pvsstaticocclusion = true,
    pvsvisibilitygeometry = true
});
local table_freeze_ret2 = table.freeze({
    [Enum.Material.Neon] = true,
    [Enum.Material.Glass] = true,
    [Enum.Material.ForceField] = true
});

local function hasTrueAttribute(p2: userdata, p3: string) -- Line: 41
    return p2:GetAttribute(p3) == true;
end;

local function hasMarkerOnPath(p4: userdata, p5: userdata, p6: string, p7: function) -- Line: 45
    while p5 ~= nil do
        if p5:GetAttribute(p6) == true or p7(p5, p6) then
            return true;
        end;

        if p5 == p4 then
            break;
        end;

        p5 = p5.Parent;
    end;

    return false;
end;

local function hasDynamicTagOnPath(p8: userdata, p9: userdata, p10: function) -- Line: 59
    -- upvalues: Constants (copy)
    while p9 ~= nil do
        for _, v in Constants.DYNAMIC_TAGS do
            if p10(p9, v) then
                return true;
            end;
        end;

        if p9 == p8 then
            break;
        end;

        p9 = p9.Parent;
    end;

    return false;
end;

local function collectParts(p11: userdata) -- Line: 75
    local v12 = {};

    if p11:IsA("BasePart") then
        table.insert(v12, p11);
    end;

    for _, descendant in p11:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(v12, descendant);
        end;
    end;

    return v12;
end;

local function isInReservedSubtree(p13: userdata, p14: userdata) -- Line: 88
    -- upvalues: table_freeze_ret (copy)
    while p14 ~= nil do
        local string_lower_ret = string.lower(p14.Name);

        if table_freeze_ret[string_lower_ret] == true or string.sub(string_lower_ret, 1, 24) == "__pvsvisibilityobjstage_" then
            return true;
        end;

        if p14 == p13 then
            break;
        end;

        p14 = p14.Parent;
    end;

    return false;
end;

local function stableInstancePath(p15: userdata, p16: userdata) -- Line: 106
    local v17 = {};

    while p16 ~= nil do
        local v18 = `{p16.ClassName}:{p16.Name}`;
        table.insert(v17, 1, v18);

        if p16 == p15 then
            break;
        end;

        p16 = p16.Parent;
    end;

    return table.concat(v17, "/");
end;

local function contentSourceName(u19) -- Line: 119
    local success, result = pcall(function() -- Line: 120
        -- upvalues: u19 (copy)
        return u19.SourceType;
    end);

    if not success or result == nil then
        return nil;
    end;

    local success2, result2 = pcall(function() -- Line: 126
        -- upvalues: result (copy)
        return result.Name;
    end);

    if success2 and typeof(result2) == "string" then
        return result2;
    end;

    return string.match(tostring(result), "([%w_]+)$");
end;

local function meshProviderIssue(u20: userdata) -- Line: 135
    -- upvalues: contentSourceName (copy)
    local success, result = pcall(function() -- Line: 137
        -- upvalues: u20 (copy)
        return u20.MeshContent;
    end);
    local v21;

    if success then
        if result == nil then
            return "UnverifiableMeshContent";
        end;

        local v22 = contentSourceName(result);

        if v22 ~= "Uri" then
            return v22 == nil and "UnverifiableMeshContent" or `NonUriMeshContent:{v22}`;
        end;

        local v23;
        v23, v21 = pcall(function() -- Line: 146
            -- upvalues: result (copy)
            return result.Uri;
        end);

        if not (v23 and (typeof(v21) == "string" and v21 ~= "")) then
            return "UnverifiableMeshContent";
        end;
    else
        v21 = nil;
    end;

    if v21 == nil then
        local success2, result2 = pcall(function() -- Line: 164
            -- upvalues: u20 (copy)
            return u20.MeshId;
        end);

        if not (success2 and (result2 ~= nil and tostring(result2) ~= "")) then
            return "UnverifiableMeshContent";
        end;
    end;

    return nil;
end;

local function immutableMeshIssue(p24: userdata) -- Line: 174
    -- upvalues: meshProviderIssue (copy)
    if p24:IsA("MeshPart") then
        local v25 = meshProviderIssue(p24);

        if v25 ~= nil then
            return v25;
        end;
    end;

    local v26 = 0;

    for _, child in p24:GetChildren() do
        if child:IsA("DataModelMesh") then
            v26 = v26 + 1;

            if v26 > 1 then
                return "MultipleMeshChildren";
            end;

            if not child.Archivable then
                return "NonArchivableMeshChild";
            end;
        end;

        local v27 = child:IsA("FileMesh");

        if child:IsA("SpecialMesh") then
            v27 = child.MeshType == Enum.MeshType.FileMesh;
        end;

        if v27 then
            local v28 = meshProviderIssue(child);

            if v28 ~= nil then
                return v28;
            end;
        end;
    end;

    return nil;
end;

local function alphaTransparencyIssue(p29: userdata) -- Line: 206
    -- upvalues: table_freeze_ret2 (copy), MaterialService (copy)
    for _, child in p29:GetChildren() do
        if child:IsA("SurfaceAppearance") and child.AlphaMode == Enum.AlphaMode.Transparency then
            return "SurfaceAppearanceAlphaTransparency";
        end;
    end;

    local MaterialVariant = p29.MaterialVariant;

    if MaterialVariant == "" and table_freeze_ret2[p29.Material] then
        return nil;
    end;

    if MaterialVariant == "" then
        local v30;
        v30, MaterialVariant = pcall(MaterialService.GetBaseMaterialOverride, MaterialService, p29.Material);

        if not v30 or typeof(MaterialVariant) ~= "string" then
            return "UnverifiableMaterialVariant";
        end;
    end;

    if MaterialVariant ~= "" then
        local success, result = pcall(MaterialService.GetMaterialVariant, MaterialService, p29.Material, MaterialVariant);

        if not success then
            return "UnverifiableMaterialVariant";
        end;

        if result ~= nil and result.AlphaMode == Enum.AlphaMode.Transparency then
            return "MaterialVariantAlphaTransparency";
        end;
    end;

    return nil;
end;

function v1.build(p31: userdata, p32: function) -- Line: 235
    -- upvalues: collectParts (copy), hasMarkerOnPath (copy), Constants (copy), isInReservedSubtree (copy), hasDynamicTagOnPath (copy), GeometryFingerprint (copy), alphaTransparencyIssue (copy), immutableMeshIssue (copy), stableInstancePath (copy)
    local v33 = {};
    local v34 = {};
    local v35 = 0;
    local v36 = 0;
    local v37 = 0;
    local v38 = 0;

    for _, v in collectParts(p31) do
        local v39 = hasMarkerOnPath(p31, v, Constants.OCCLUDER_MARKER, p32);

        if isInReservedSubtree(p31, v) then
            if v39 then
                v35 = v35 + 1;
            end;

            v36 = v36 + 1;
            v37 = v37 + 1;
        elseif v39 then
            v35 = v35 + 1;

            if hasMarkerOnPath(p31, v, Constants.IGNORE_MARKER, p32) or (hasMarkerOnPath(p31, v, Constants.DYNAMIC_MARKER, p32) or hasDynamicTagOnPath(p31, v, p32)) then
                v36 = v36 + 1;
            elseif GeometryFingerprint.supportsPart(v) then
                local v40 = alphaTransparencyIssue(v);

                if v40 == nil then
                    if v:IsA("MeshPart") and v:FindFirstChildWhichIsA("Bone", true) ~= nil then
                        table.insert(v33, {
                            reason = "SkinnedMesh",
                            part = v
                        });
                    elseif v:IsA("MeshPart") and v:FindFirstChildWhichIsA("BaseWrap", true) ~= nil then
                        table.insert(v33, {
                            reason = "DeformedMesh",
                            part = v
                        });
                    else
                        local v41 = immutableMeshIssue(v);

                        if v41 == nil then
                            if v.Anchored then
                                if v.Material == Enum.Material.Glass then
                                    table.insert(v33, {
                                        reason = "GlassMaterial",
                                        part = v
                                    });
                                elseif v.Material == Enum.Material.ForceField then
                                    table.insert(v33, {
                                        reason = "ForceFieldMaterial",
                                        part = v
                                    });
                                elseif v.Transparency > Constants.OPAQUE_TRANSPARENCY_LIMIT then
                                    table.insert(v33, {
                                        reason = "Transparent",
                                        part = v
                                    });
                                else
                                    table.insert(v34, v);
                                end;
                            else
                                table.insert(v33, {
                                    reason = "NotAnchored",
                                    part = v
                                });
                            end;
                        else
                            table.insert(v33, {
                                part = v,
                                reason = v41
                            });
                        end;
                    end;
                else
                    table.insert(v33, {
                        part = v,
                        reason = v40
                    });
                end;
            else
                local v42 = {
                    part = v,
                    reason = `UnsupportedClass:{v.ClassName}`
                };
                table.insert(v33, v42);
            end;
        else
            v38 = v38 + 1;
        end;
    end;

    local u43 = {};

    for _, v in v34 do
        u43[v] = stableInstancePath(p31, v);
    end;

    for _, v in v33 do
        u43[v.part] = stableInstancePath(p31, v.part);
    end;

    table.sort(v34, function(p44, p45) -- Line: 317
        -- upvalues: u43 (copy)
        local v46 = u43[p44];
        local v47 = u43[p45];

        if v46 ~= v47 then
            return v46 < v47;
        end;

        local Position = p44.Position;
        local Position2 = p45.Position;

        if Position.X ~= Position2.X then
            return Position.X < Position2.X;
        end;

        if Position.Y ~= Position2.Y then
            return Position.Y < Position2.Y;
        end;

        if Position.Z == Position2.Z then
            return tostring(p44.Size) < tostring(p45.Size);
        end;

        return Position.Z < Position2.Z;
    end);
    table.sort(v33, function(p48, p49) -- Line: 335
        -- upvalues: u43 (copy)
        return u43[p48.part] < u43[p49.part];
    end);

    return {
        root = p31,
        parts = v34,
        rejections = v33,
        explicitPartCount = v35,
        untaggedPartCount = v38,
        excludedPartCount = v36,
        reservedPartCount = v37
    };
end;

function v1.path(p50: userdata, p51: userdata) -- Line: 350
    -- upvalues: stableInstancePath (copy)
    return stableInstancePath(p50, p51);
end;

return table.freeze(v1);