-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CanonicalGeometry = require(script.Parent.CanonicalGeometry);
local HullPoints = require(script.Parent.HullPoints);
local Schema = require(script.Parent.Schema);
local WalkmeshCodec = require(script.Parent.WalkmeshCodec);
local u1 = {};

local function isUInt32(p2) -- Line: 51
    local v3;

    if typeof(p2) == "number" and (p2 % 1 == 0 and p2 >= 0) then
        v3 = p2 <= 4294967295;
    else
        v3 = false;
    end;

    return v3;
end;

local function readUInt32Attribute(p4: userdata, p5: string, p6: boolean) -- Line: 55
    local Attribute = p4:GetAttribute(p5);
    local v7;

    if typeof(Attribute) == "number" and (Attribute % 1 == 0 and Attribute >= 0) then
        v7 = Attribute <= 4294967295;
    else
        v7 = false;
    end;

    if v7 and (not p6 or Attribute ~= 0) then
        return Attribute, nil;
    end;

    return nil, string.format("%s.%s must be %s", p4:GetFullName(), p5, p6 and "a non-zero u32" or "a u32");
end;

local function readBooleanAttribute(p8: userdata, p9: string) -- Line: 69
    local Attribute = p8:GetAttribute(p9);

    if Attribute == nil then
        return false, nil;
    end;

    if typeof(Attribute) == "boolean" then
        return Attribute, nil;
    end;

    return nil, string.format("%s.%s must be a boolean when present", p8:GetFullName(), p9);
end;

local function readManifest(p10: userdata) -- Line: 80
    -- upvalues: Schema (copy)
    if p10:GetAttribute(Schema.Attributes.ManifestVersion) ~= Schema.ManifestVersion then
        return nil, string.format("%s is not committed with collision manifest version %d", p10:GetFullName(), Schema.ManifestVersion);
    end;

    local ManifestEpoch = Schema.Attributes.ManifestEpoch;
    local Attribute = p10:GetAttribute(ManifestEpoch);
    local v11;

    if typeof(Attribute) == "number" and (Attribute % 1 == 0 and Attribute >= 0) then
        v11 = Attribute <= 4294967295;
    else
        v11 = false;
    end;

    local v12;

    if v11 and Attribute ~= 0 then
        v12 = nil;
    else
        v12 = string.format("%s.%s must be %s", p10:GetFullName(), ManifestEpoch, "a non-zero u32");
        Attribute = nil;
    end;

    if Attribute == nil then
        return nil, v12;
    end;

    if Schema.MaxEpoch < Attribute then
        return nil, "collision manifest epoch exceeds the u16 wire range";
    end;

    local ManifestFingerprint = Schema.Attributes.ManifestFingerprint;
    local Attribute2 = p10:GetAttribute(ManifestFingerprint);
    local v13;

    if typeof(Attribute2) == "number" and (Attribute2 % 1 == 0 and Attribute2 >= 0) then
        v13 = Attribute2 <= 4294967295;
    else
        v13 = false;
    end;

    local v14;

    if v13 then
        v14 = nil;
    else
        v14 = string.format("%s.%s must be %s", p10:GetFullName(), ManifestFingerprint, "a u32");
        Attribute2 = nil;
    end;

    if Attribute2 == nil then
        return nil, v14;
    end;

    local ManifestSourceCount = Schema.Attributes.ManifestSourceCount;
    local Attribute3 = p10:GetAttribute(ManifestSourceCount);
    local v15;

    if typeof(Attribute3) == "number" and (Attribute3 % 1 == 0 and Attribute3 >= 0) then
        v15 = Attribute3 <= 4294967295;
    else
        v15 = false;
    end;

    local v16;

    if v15 then
        v16 = nil;
    else
        v16 = string.format("%s.%s must be %s", p10:GetFullName(), ManifestSourceCount, "a u32");
        Attribute3 = nil;
    end;

    if Attribute3 == nil then
        return nil, v16;
    end;

    if Schema.MaxSourceCount < Attribute3 then
        return nil, string.format("collision manifest exceeds the %d-source limit", Schema.MaxSourceCount);
    end;

    local ManifestDestructibleCount = Schema.Attributes.ManifestDestructibleCount;
    local Attribute4 = p10:GetAttribute(ManifestDestructibleCount);
    local v17;

    if typeof(Attribute4) == "number" and (Attribute4 % 1 == 0 and Attribute4 >= 0) then
        v17 = Attribute4 <= 4294967295;
    else
        v17 = false;
    end;

    local v18;

    if v17 then
        v18 = nil;
    else
        v18 = string.format("%s.%s must be %s", p10:GetFullName(), ManifestDestructibleCount, "a u32");
        Attribute4 = nil;
    end;

    if Attribute4 == nil then
        return nil, v18;
    end;

    if Schema.MaxDestructibleCount < Attribute4 or Attribute3 < Attribute4 then
        return nil, "collision manifest has an invalid destructible count";
    end;

    return table.freeze({
        Version = Schema.ManifestVersion,
        Epoch = Attribute,
        Fingerprint = Attribute2,
        SourceCount = Attribute3,
        DestructibleCount = Attribute4
    }), nil;
end;

local function findBarriersRoot(p19: userdata) -- Line: 128
    -- upvalues: Schema (copy)
    if string.lower(p19.Name) == Schema.BarriersNameLower then
        return p19, nil;
    end;

    local v20 = nil;

    for _, child in ipairs(p19:GetChildren()) do
        if string.lower(child.Name) == Schema.BarriersNameLower then
            if v20 ~= nil then
                return nil, string.format("%s has multiple case-insensitive Barriers roots", p19:GetFullName());
            end;

            v20 = child;
        end;
    end;

    return v20, nil;
end;

local function isInside(p21: userdata, p22: userdata?) -- Line: 145
    local v23;

    if p22 == nil then
        v23 = false;
    else
        v23 = p21 == p22 and true or p21:IsDescendantOf(p22);
    end;

    return v23;
end;

local function hasPublishedSourceAttribute(p24: userdata) -- Line: 149
    -- upvalues: Schema (copy)
    return (p24:GetAttribute(Schema.Attributes.SourceId) ~= nil or (p24:GetAttribute(Schema.Attributes.SourceKind) ~= nil or p24:GetAttribute(Schema.Attributes.DestructibleIndex) ~= nil)) and true or p24:GetAttribute(Schema.Attributes.CanonicalGeometry) ~= nil;
end;

local function classify(p25: userdata, p26: userdata?) -- Line: 156
    -- upvalues: CollectionService (copy), Schema (copy)
    local v27 = CollectionService:HasTag(p25, Schema.Tags.Destructible);
    local v28 = CollectionService:HasTag(p25, Schema.Tags.Walkmesh);
    local v29 = p25:IsA("BasePart");

    if v29 then
        if p26 == nil then
            v29 = false;
        else
            v29 = p25 == p26 and true or p25:IsDescendantOf(p26);
        end;
    end;

    if v27 then
        return Schema.SourceKind.Destructible, v27, v28, v29;
    end;

    if v28 then
        return Schema.SourceKind.Walkmesh, v27, v28, v29;
    end;

    if v29 then
        return Schema.SourceKind.Barrier, v27, v28, v29;
    end;

    if p25:IsA("BasePart") and CollectionService:HasTag(p25, Schema.Tags.LadderMetadata) then
        return Schema.SourceKind.Barrier, v27, v28, v29;
    end;

    return nil, v27, v28, v29;
end;

local function getShape(p30: userdata) -- Line: 177
    if p30:IsA("WedgePart") then
        return Enum.PartType.Wedge.Name;
    end;

    if p30:IsA("CornerWedgePart") then
        return Enum.PartType.CornerWedge.Name;
    end;

    if p30:IsA("Part") then
        return p30.Shape.Name;
    end;

    return not p30:IsA("BasePart") and "Walkmesh" or Enum.PartType.Block.Name;
end;

local function sourceFingerprintKey(p31: table) -- Line: 193
    local v32 = p31.Walkmesh == nil and "" or string.format("%08x", p31.Walkmesh.Fingerprint);
    local v33 = {
        tostring(p31.SourceId),
        tostring(p31.Kind),
        p31.Geometry.Descriptor,
        p31.Instance.ClassName,
        p31.Shape,
        p31.Climbable and "1" or "0",
        p31.PreciseCylinder and "1" or "0",
        p31.ConvexGroup or "",
        p31.DisableSeamMerge and "1" or "0",
        tostring(p31.DestructibleIndex or 0),
        v32
    };

    if p31.HullPoints ~= nil then
        v33[#v33 + 1] = p31.HullPoints;
    end;

    return table.concat(v33, "\0");
end;

local function readSource(p34: userdata, p35: number, p36: table, p37: function) -- Line: 217
    -- upvalues: Schema (copy), CanonicalGeometry (copy), getShape (copy), CollectionService (copy), HullPoints (copy), WalkmeshCodec (copy)
    if p35 == Schema.SourceKind.Destructible and not p34:IsA("BasePart") then
        return nil, string.format("%s has the destructible tag but is not a BasePart", p34:GetFullName());
    end;

    if p35 == Schema.SourceKind.Walkmesh and not (p34:IsA("BasePart") or p34:IsA("Model")) then
        return nil, string.format("%s has the walkmesh tag but is not a BasePart or Model", p34:GetFullName());
    end;

    local SourceId = Schema.Attributes.SourceId;
    local Attribute = p34:GetAttribute(SourceId);
    local v38;

    if typeof(Attribute) == "number" and (Attribute % 1 == 0 and Attribute >= 0) then
        v38 = Attribute <= 4294967295;
    else
        v38 = false;
    end;

    local v39;

    if v38 and Attribute ~= 0 then
        v39 = nil;
    else
        v39 = string.format("%s.%s must be %s", p34:GetFullName(), SourceId, "a non-zero u32");
        Attribute = nil;
    end;

    if Attribute == nil then
        return nil, v39;
    end;

    local SourceKind = Schema.Attributes.SourceKind;
    local Attribute2 = p34:GetAttribute(SourceKind);
    local v40;

    if typeof(Attribute2) == "number" and (Attribute2 % 1 == 0 and Attribute2 >= 0) then
        v40 = Attribute2 <= 4294967295;
    else
        v40 = false;
    end;

    local v41;

    if v40 and Attribute2 ~= 0 then
        v41 = nil;
    else
        v41 = string.format("%s.%s must be %s", p34:GetFullName(), SourceKind, "a non-zero u32");
        Attribute2 = nil;
    end;

    if Attribute2 == nil then
        return nil, v41;
    end;

    if Attribute2 ~= p35 then
        return nil, string.format("%s published source kind %d but scans as %s", p34:GetFullName(), Attribute2, Schema.GetSourceKindName(p35) or "unknown");
    end;

    local v42, v43 = CanonicalGeometry.ReadPublished(p34);

    if v42 == nil then
        return nil, v43;
    end;

    if p34:IsA("BasePart") and (v42.Size.X <= 0 or (v42.Size.Y <= 0 or v42.Size.Z <= 0)) then
        return nil, string.format("%s published a non-positive BasePart size", p34:GetFullName());
    end;

    if p34:IsA("Model") and v42.Size ~= Vector3.new(0, 0, 0) then
        return nil, string.format("%s published a non-zero Model size", p34:GetFullName());
    end;

    local v44 = getShape(p34);
    local v45 = nil;
    local Attribute3 = p34:GetAttribute(Schema.Attributes.DestructibleIndex);

    if p35 == Schema.SourceKind.Destructible then
        local v46;

        if typeof(Attribute3) == "number" and (Attribute3 % 1 == 0 and Attribute3 >= 0) then
            v46 = Attribute3 <= 4294967295;
        else
            v46 = false;
        end;

        if not (v46 and (Attribute3 ~= 0 and p36.DestructibleCount >= Attribute3)) then
            return nil, string.format("%s.%s must be in [1, %d]", p34:GetFullName(), Schema.Attributes.DestructibleIndex, p36.DestructibleCount);
        end;
    else
        if Attribute3 ~= nil then
            return nil, string.format("%s has %s but is not a destructible source", p34:GetFullName(), Schema.Attributes.DestructibleIndex);
        end;

        Attribute3 = v45;
    end;

    local Climbable = Schema.Attributes.Climbable;
    local Attribute4 = p34:GetAttribute(Climbable);
    local v47;

    if Attribute4 == nil then
        v47 = nil;
        Attribute4 = false;
    elseif typeof(Attribute4) == "boolean" then
        v47 = nil;
    else
        v47 = string.format("%s.%s must be a boolean when present", p34:GetFullName(), Climbable);
        Attribute4 = nil;
    end;

    if Attribute4 == nil then
        return nil, v47;
    end;

    local v48 = Attribute4 or CollectionService:HasTag(p34, Schema.Tags.LadderMetadata);
    local PreciseCylinder = Schema.Attributes.PreciseCylinder;
    local Attribute5 = p34:GetAttribute(PreciseCylinder);
    local v49;

    if Attribute5 == nil then
        v49 = nil;
        Attribute5 = false;
    elseif typeof(Attribute5) == "boolean" then
        v49 = nil;
    else
        v49 = string.format("%s.%s must be a boolean when present", p34:GetFullName(), PreciseCylinder);
        Attribute5 = nil;
    end;

    if Attribute5 == nil then
        return nil, v49;
    end;

    if Attribute5 and v44 ~= Enum.PartType.Cylinder.Name then
        return nil, string.format("%s has precise-cylinder metadata but is not a Cylinder", p34:GetFullName());
    end;

    local Attribute6 = p34:GetAttribute(Schema.Attributes.ConvexGroup);
    local v50 = nil;

    if typeof(Attribute6) == "string" and Attribute6 ~= "" then
        v50 = Attribute6;
    elseif typeof(Attribute6) == "number" then
        v50 = tostring(Attribute6);
    elseif Attribute6 ~= nil and Attribute6 ~= "" then
        return nil, string.format("%s.%s must be a string or number", p34:GetFullName(), Schema.Attributes.ConvexGroup);
    end;

    local DisableSeamMerge = Schema.Attributes.DisableSeamMerge;
    local Attribute7 = p34:GetAttribute(DisableSeamMerge);
    local v51;

    if Attribute7 == nil then
        v51 = nil;
        Attribute7 = false;
    elseif typeof(Attribute7) == "boolean" then
        v51 = nil;
    else
        v51 = string.format("%s.%s must be a boolean when present", p34:GetFullName(), DisableSeamMerge);
        Attribute7 = nil;
    end;

    if Attribute7 == nil then
        return nil, v51;
    end;

    local Attribute8 = p34:GetAttribute(HullPoints.Attribute);

    if Attribute8 == nil then
        Attribute8 = nil;
    else
        local _, v52 = HullPoints.Decode(Attribute8);

        if v52 ~= nil then
            return nil, string.format("%s.%s: %s", p34:GetFullName(), HullPoints.Attribute, v52);
        end;

        if not p34:IsA("Part") or v44 ~= Enum.PartType.Block.Name then
            return nil, string.format("%s has %s but is not a block Part", p34:GetFullName(), HullPoints.Attribute);
        end;
    end;

    local v53;

    if p35 == Schema.SourceKind.Walkmesh then
        if v48 then
            p37(string.format("%s has ladder/climbable metadata; V2 ignores it on Walkmesh", p34:GetFullName()));
            v48 = false;
        end;

        local v54;
        v53, v54 = WalkmeshCodec.ReadPublished(p34);

        if v53 == nil then
            return nil, v54;
        end;
    else
        v53 = nil;
    end;

    return table.freeze({
        Kind = p35,
        SourceId = Attribute,
        Instance = p34,
        Geometry = v42,
        Shape = v44,
        Climbable = v48,
        PreciseCylinder = Attribute5,
        ConvexGroup = v50,
        DisableSeamMerge = Attribute7,
        HullPoints = Attribute8,
        DestructibleIndex = Attribute3,
        Walkmesh = v53
    }), nil;
end;

function u1.ComputeFingerprint(p55: table) -- Line: 358
    -- upvalues: sourceFingerprintKey (copy), CanonicalGeometry (copy)
    local table_create_ret = table.create(#p55);

    for i, v in ipairs(p55) do
        table_create_ret[i] = sourceFingerprintKey(v);
    end;

    return CanonicalGeometry.HashStrings(table_create_ret);
end;

function u1.ReadPublished(p56: userdata, u57: function?, p58: function?) -- Line: 367
    -- upvalues: readManifest (copy), findBarriersRoot (copy), CollectionService (copy), Schema (copy), classify (copy), hasPublishedSourceAttribute (copy), readSource (copy), u1 (copy)
    local v59 = typeof(p56) == "Instance";
    assert(v59, "map root must be an Instance");
    local v60, v61 = readManifest(p56);

    if v60 == nil then
        return nil, v61;
    end;

    local v62, v63 = findBarriersRoot(p56);

    if v63 ~= nil then
        return nil, v63;
    end;

    local u64 = {};
    local Descendants = p56:GetDescendants();
    local table_create_ret = table.create(#Descendants + 1);
    table_create_ret[1] = p56;

    local function warnCatalog(p65: string) -- Line: 384
        -- upvalues: u64 (copy), u57 (copy)
        u64[#u64 + 1] = p65;

        if u57 ~= nil then
            u57(p65);
        end;
    end;

    for _, v in ipairs(Descendants) do
        table_create_ret[#table_create_ret + 1] = v;
    end;

    local v66 = {};
    local v67 = {};
    local v68 = {};
    local v69 = 0;

    for _, v in ipairs(table_create_ret) do
        if p58 ~= nil then
            p58();
        end;

        if CollectionService:HasTag(v, Schema.Tags.UnsupportedFloorGrid) then
            return nil, string.format("%s uses unsupported CustomFloorGrid authoring; V2 accepts Barrier (including tagged Ladder), Destructible, and Walkmesh", v:GetFullName());
        end;

        local Ignore = Schema.Attributes.Ignore;
        local Attribute = v:GetAttribute(Ignore);
        local v70;

        if Attribute == nil then
            Attribute = false;
            v70 = nil;
        elseif typeof(Attribute) == "boolean" then
            v70 = nil;
        else
            v70 = string.format("%s.%s must be a boolean when present", v:GetFullName(), Ignore);
            Attribute = nil;
        end;

        if Attribute == nil then
            return nil, v70;
        end;

        local v71, v72, v73, _ = classify(v, v62);
        local Attribute2 = v:GetAttribute(Schema.Attributes.Climbable);

        if Attribute2 ~= nil and typeof(Attribute2) ~= "boolean" then
            return nil, string.format("%s.%s must be a boolean when present", v:GetFullName(), Schema.Attributes.Climbable);
        end;

        if Attribute then
            if v72 or (v73 or hasPublishedSourceAttribute(v)) then
                return nil, string.format("%s is both an ignored and published/tagged collision source", v:GetFullName());
            end;
        elseif v71 == nil then
            if hasPublishedSourceAttribute(v) then
                return nil, string.format("%s has V2 source attributes but is not a supported source", v:GetFullName());
            end;

            if Attribute2 == true then
                local string_format_ret = string.format("%s has standalone Climbable metadata but is not under Barriers or tagged Ladder", v:GetFullName());
                u64[#u64 + 1] = string_format_ret;

                if u57 ~= nil then
                    u57(string_format_ret);
                end;
            end;
        else
            if v72 and v73 then
                local string_format_ret = string.format("%s is both Destructible and Walkmesh; Destructible takes precedence", v:GetFullName());
                u64[#u64 + 1] = string_format_ret;

                if u57 ~= nil then
                    u57(string_format_ret);
                end;
            end;

            local v74, v75 = readSource(v, v71, v60, warnCatalog);

            if v74 == nil then
                return nil, v75;
            end;

            if v66[v74.SourceId] ~= nil then
                return nil, string.format("duplicate MovementV2SourceId %d", v74.SourceId);
            end;

            v66[v74.SourceId] = v74;
            v67[#v67 + 1] = v74;

            if v74.DestructibleIndex ~= nil then
                if v68[v74.DestructibleIndex] ~= nil then
                    return nil, string.format("duplicate MovementV2DestructibleIndex %d", v74.DestructibleIndex);
                end;

                v68[v74.DestructibleIndex] = v74;
                v69 = v69 + 1;
            end;
        end;
    end;

    if #v67 ~= v60.SourceCount then
        return nil, string.format("collision manifest declares %d sources but scan found %d", v60.SourceCount, #v67);
    end;

    if v69 ~= v60.DestructibleCount then
        return nil, string.format("collision manifest declares %d destructibles but scan found %d", v60.DestructibleCount, v69);
    end;

    for i = 1, v60.DestructibleCount do
        if v68[i] == nil then
            return nil, string.format("destructible indices are not dense at index %d", i);
        end;

        local _ = i;
    end;

    table.sort(v67, function(p76, p77) -- Line: 504
        return p76.SourceId < p77.SourceId;
    end);
    local v78 = u1.ComputeFingerprint(v67);

    if v78 ~= v60.Fingerprint then
        return nil, string.format("collision manifest fingerprint mismatch: published=%08x computed=%08x", v60.Fingerprint, v78);
    end;

    table.freeze(v67);
    table.freeze(v66);
    table.freeze(v68);
    table.freeze(u64);

    return table.freeze({
        MapRoot = p56,
        BarriersRoot = v62,
        Manifest = v60,
        Sources = v67,
        SourcesById = v66,
        DestructiblesByIndex = v68,
        Warnings = u64
    }), nil;
end;

function u1.FindReplica(p79: number, p80: number) -- Line: 534
    -- upvalues: ReplicatedStorage (copy), Schema (copy)
    local v81 = ReplicatedStorage:FindFirstChild(Schema.ReplicaContainerName);

    if v81 == nil then
        return nil;
    end;

    for _, child in ipairs(v81:GetChildren()) do
        if child:GetAttribute(Schema.Attributes.ManifestVersion) == Schema.ManifestVersion and (child:GetAttribute(Schema.Attributes.ManifestEpoch) == p79 and child:GetAttribute(Schema.Attributes.ManifestFingerprint) == p80) then
            return child;
        end;
    end;

    return nil;
end;

return table.freeze(u1);