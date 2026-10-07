-- ReplicatedStorage.MovementV2.Collision.Catalog
-- Script path: ReplicatedStorage.MovementV2.Collision.Catalog
-- Decompile time: 23.38 ms

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CanonicalGeometry = require(script.Parent.CanonicalGeometry)
local HullPoints = require(script.Parent.HullPoints)
local Schema = require(script.Parent.Schema)
local WalkmeshCodec = require(script.Parent.WalkmeshCodec)
local u30 = {}

local function isUInt32(a1) -- Line: 51
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 % 1 == 0 then
            v1 = false
            if a1 >= 0 then
                v1 = a1 <= 4294967295
            end
        end
    end
    return v1
end

local function readUInt32Attribute(a1, a2, a3) -- Line: 55 -- types: a1: userdata, a2: string, a3: boolean
    local format, v1
    local Attribute = a1:GetAttribute(a2)
    local v2 = false
    if typeof(Attribute) == "number" then
        v2 = false
        if Attribute % 1 == 0 then
            v2 = false
            if Attribute >= 0 then
                v2 = Attribute <= 4294967295
            end
        end
    end
    if not v2 then
        format = string.format
        v1 = if not a3 then "a u32" else "a non-zero u32"
        return nil, format("%s.%s must be %s", a1:GetFullName(), a2, v1)
    end
    if a3 and Attribute == 0 then
        format = string.format
        v1 = if not a3 then "a u32" else "a non-zero u32"
        return nil, format("%s.%s must be %s", a1:GetFullName(), a2, v1)
    end
    return Attribute, nil
end

local function readBooleanAttribute(a1, a2) -- Line: 69 -- types: a1: userdata, a2: string
    local Attribute = a1:GetAttribute(a2)
    if Attribute == nil then
        return false, nil
    end
    if typeof(Attribute) ~= "boolean" then
        return nil, string.format("%s.%s must be a boolean when present", a1:GetFullName(), a2)
    end
    return Attribute, nil
end

local function readManifest(a1) -- Line: 80 -- upvalues: Schema (val) -- types: a1: userdata
    local v1, v2, v3, v4, v5, v6
    if (a1:GetAttribute(Schema.Attributes.ManifestVersion)) ~= Schema.ManifestVersion then
        return nil, string.format("%s is not committed with collision manifest version %d", a1:GetFullName(), Schema.ManifestVersion)
    end
    local ManifestEpoch = Schema.Attributes.ManifestEpoch
    local Attribute_2 = a1:GetAttribute(ManifestEpoch)
    local v7 = false
    if typeof(Attribute_2) == "number" then
        v7 = false
        if Attribute_2 % 1 == 0 then
            v7 = false
            if Attribute_2 >= 0 then
                v7 = Attribute_2 <= 4294967295
            end
        end
    end
    if not v7 then
        v1 = nil
        v2 = string.format("%s.%s must be %s", a1:GetFullName(), ManifestEpoch, "a non-zero u32")
    elseif Attribute_2 ~= 0 then
        v1 = Attribute_2
        v2 = nil
    else
        v1 = nil
        v2 = string.format("%s.%s must be %s", a1:GetFullName(), ManifestEpoch, "a non-zero u32")
    end
    if v1 == nil then
        return nil, v2
    end
    if Schema.MaxEpoch < v1 then
        return nil, "collision manifest epoch exceeds the u16 wire range"
    end
    local ManifestFingerprint = Schema.Attributes.ManifestFingerprint
    local Attribute_3 = a1:GetAttribute(ManifestFingerprint)
    local v8 = false
    if typeof(Attribute_3) == "number" then
        v8 = false
        if Attribute_3 % 1 == 0 then
            v8 = false
            if Attribute_3 >= 0 then
                v8 = Attribute_3 <= 4294967295
            end
        end
    end
    if not v8 then
        v3 = nil
        v4 = string.format("%s.%s must be %s", a1:GetFullName(), ManifestFingerprint, "a u32")
    else
        v3 = Attribute_3
        v4 = nil
    end
    if v3 == nil then
        return nil, v4
    end
    local ManifestSourceCount = Schema.Attributes.ManifestSourceCount
    local Attribute_4 = a1:GetAttribute(ManifestSourceCount)
    local v9 = false
    if typeof(Attribute_4) == "number" then
        v9 = false
        if Attribute_4 % 1 == 0 then
            v9 = false
            if Attribute_4 >= 0 then
                v9 = Attribute_4 <= 4294967295
            end
        end
    end
    if not v9 then
        v7 = nil
        v5 = string.format("%s.%s must be %s", a1:GetFullName(), ManifestSourceCount, "a u32")
    else
        v7 = Attribute_4
        v5 = nil
    end
    if v7 == nil then
        return nil, v5
    end
    if Schema.MaxSourceCount < v7 then
        return nil, string.format("collision manifest exceeds the %d-source limit", Schema.MaxSourceCount)
    end
    local ManifestDestructibleCount = Schema.Attributes.ManifestDestructibleCount
    local Attribute_5 = a1:GetAttribute(ManifestDestructibleCount)
    local v10 = false
    if typeof(Attribute_5) == "number" then
        v10 = false
        if Attribute_5 % 1 == 0 then
            v10 = false
            if Attribute_5 >= 0 then
                v10 = Attribute_5 <= 4294967295
            end
        end
    end
    if not v10 then
        v8 = nil
        v6 = string.format("%s.%s must be %s", a1:GetFullName(), ManifestDestructibleCount, "a u32")
    else
        v8 = Attribute_5
        v6 = nil
    end
    if v8 == nil then
        return nil, v6
    end
    if not (Schema.MaxDestructibleCount < v8) and not (v7 < v8) then
        return (table.freeze({
            Version = Schema.ManifestVersion,
            Epoch = v1,
            Fingerprint = v3,
            SourceCount = v7,
            DestructibleCount = v8,
        })), nil
    end
    return nil, "collision manifest has an invalid destructible count"
end

local function findBarriersRoot(a1) -- Line: 128 -- upvalues: Schema (val) -- types: a1: userdata
    if (string.lower(a1.Name)) == Schema.BarriersNameLower then
        return a1, nil
    end
    local v1 = nil
    for i, v in ipairs(a1:GetChildren()) do
        if (string.lower(v.Name)) == Schema.BarriersNameLower then
            if v1 ~= nil then
                return nil, string.format("%s has multiple case-insensitive Barriers roots", a1:GetFullName())
            end
            v1 = v
        end
    end
    return v1, nil
end

local function isInside(a1, a2) -- Line: 145 -- types: a1: userdata, a2: userdata?
    local v1 = false
    if a2 ~= nil then
        v1 = true
        if a1 ~= a2 then
            v1 = a1:IsDescendantOf(a2)
        end
    end
    return v1
end

local function hasPublishedSourceAttribute(a1) -- Line: 149 -- upvalues: Schema (val) -- types: a1: userdata
    local v1 = true
    if a1:GetAttribute(Schema.Attributes.SourceId) == nil then
        v1 = true
        if a1:GetAttribute(Schema.Attributes.SourceKind) == nil then
            v1 = true
            if a1:GetAttribute(Schema.Attributes.DestructibleIndex) == nil then
                v1 = a1:GetAttribute(Schema.Attributes.CanonicalGeometry) ~= nil
            end
        end
    end
    return v1
end

local function classify(a1, a2) -- Line: 156
    -- upvalues: CollectionService (val), Schema (val)
    local v1 = CollectionService:HasTag(a1, Schema.Tags.Destructible)
    local v2 = CollectionService:HasTag(a1, Schema.Tags.Walkmesh)
    local v3 = a1:IsA("BasePart")
    if v3 then
        v3 = false
        if a2 ~= nil then
            v3 = true
            if a1 ~= a2 then
                v3 = a1:IsDescendantOf(a2)
            end
        end
    end
    if v1 then
        return Schema.SourceKind.Destructible, v1, v2, v3
    end
    if v2 then
        return Schema.SourceKind.Walkmesh, v1, v2, v3
    end
    if v3 then
        return Schema.SourceKind.Barrier, v1, v2, v3
    end
    if a1:IsA("BasePart") and CollectionService:HasTag(a1, Schema.Tags.LadderMetadata) then
        return Schema.SourceKind.Barrier, v1, v2, v3
    end
    return nil, v1, v2, v3
end

local function getShape(a1) -- Line: 177 -- types: a1: userdata
    if a1:IsA("WedgePart") then
        return Enum.PartType.Wedge.Name
    end
    if a1:IsA("CornerWedgePart") then
        return Enum.PartType.CornerWedge.Name
    end
    if a1:IsA("Part") then
        return a1.Shape.Name
    end
    if a1:IsA("BasePart") then
        return Enum.PartType.Block.Name
    end
    return "Walkmesh"
end

local function sourceFingerprintKey(a1) -- Line: 193 -- types: a1: table
    local v1 = if a1.Walkmesh == nil then "" else string.format("%08x", a1.Walkmesh.Fingerprint)
    local v2 = {
        tostring(a1.SourceId),
        tostring(a1.Kind),
        a1.Geometry.Descriptor,
        a1.Instance.ClassName,
        a1.Shape,
        if not a1.Climbable then "0" else "1",
        if not a1.PreciseCylinder then "0" else "1",
        a1.ConvexGroup or "",
        if not a1.DisableSeamMerge then "0" else "1",
        tostring(a1.DestructibleIndex or 0),
        v1,
    }
    if a1.HullPoints ~= nil then
        v2[#v2 + 1] = a1.HullPoints
    end
    return table.concat(v2, "\000")
end

local function readSource(a1, a2, a3, a4) -- Line: 217
    -- upvalues: Schema (val), CanonicalGeometry (val), getShape (val), CollectionService (val), HullPoints (val)
    -- upvalues: WalkmeshCodec (val)
    local Attribute, Attribute_2, Attribute_3, Attribute_4, Attribute_5, Attribute_6, Attribute_7, Attribute_9, Climbable, DisableSeamMerge, PreciseCylinder, SourceId, SourceKind, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21
    local dispatch = 0
    while true do
        if dispatch < 51 then
            if dispatch < 25 then
                if dispatch < 12 then
                    if dispatch < 6 then
                        if not (dispatch < 3) then
                            dispatch = if dispatch < 4 then if a2 ~= Schema.SourceKind.Walkmesh then 7 else 4 else if dispatch < 5 then if a1:IsA("BasePart") then 7 else 5 else if a1:IsA("Model") then 7 else 6
                        elseif dispatch < 1 then
                            dispatch = if a2 ~= Schema.SourceKind.Destructible then 3 else 1
                        else
                            if not (dispatch < 2) then
                                return nil, string.format("%s has the destructible tag but is not a BasePart", a1:GetFullName())
                            end
                            dispatch = if a1:IsA("BasePart") then 3 else 2
                        end
                    elseif dispatch < 9 then
                        if dispatch < 7 then
                            return nil, string.format("%s has the walkmesh tag but is not a BasePart or Model", a1:GetFullName())
                        elseif dispatch < 8 then
                            Attribute = a1:GetAttribute(Schema.Attributes.SourceId)
                            dispatch = if typeof(Attribute) ~= "number" then 13 else 8
                        else
                            dispatch = if Attribute % 1 ~= 0 then 13 else 9
                        end
                    elseif dispatch < 10 then
                        dispatch = if not (Attribute >= 0) then 13 else 10
                    elseif dispatch < 11 then
                        dispatch = if Attribute <= 4294967295 then 12 else 11
                    end
                elseif dispatch < 18 then
                    if dispatch < 15 then
                        if not (dispatch < 13) then
                            dispatch = if dispatch < 14 then if not v20 then 15 else 14 else if Attribute ~= 0 then 16 else 15
                        end
                    elseif dispatch < 16 then
                        v17 = string.format("%s.%s must be %s", a1:GetFullName(), SourceId, "a non-zero u32")
                    elseif not (dispatch < 17) then
                        dispatch = if v16 ~= nil then 19 else 18
                    end
                elseif dispatch < 21 then
                    if dispatch < 19 then
                        return nil, v17
                    elseif dispatch < 20 then
                        Attribute_2 = a1:GetAttribute(Schema.Attributes.SourceKind)
                        dispatch = if typeof(Attribute_2) ~= "number" then 25 else 20
                    else
                        dispatch = if Attribute_2 % 1 ~= 0 then 25 else 21
                    end
                elseif dispatch < 23 then
                    dispatch = if dispatch < 22 then if not (Attribute_2 >= 0) then 25 else 22 else if Attribute_2 <= 4294967295 then 24 else 23
                else
                    v1 = not (dispatch < 24)
                end
            elseif dispatch < 38 then
                if dispatch < 31 then
                    if dispatch < 28 then
                        if not (dispatch < 26) then
                            if dispatch < 27 then
                                dispatch = if Attribute_2 ~= 0 then 28 else 27
                            else
                                v19 = string.format("%s.%s must be %s", a1:GetFullName(), SourceKind, "a non-zero u32")
                            end
                        end
                    elseif not (dispatch < 29) then
                        if not (dispatch < 30) then
                            return nil, v19
                        end
                        dispatch = if v18 ~= nil then 31 else 30
                    end
                elseif dispatch < 34 then
                    if dispatch < 32 then
                        dispatch = if v18 == a2 then 33 else 32
                    elseif dispatch < 33 then
                        return nil, string.format(
                            "%s published source kind %d but scans as %s",
                            a1:GetFullName(),
                            v18,
                            Schema.GetSourceKindName(a2) or "unknown"
                        )
                    else
                        v20, v21 = CanonicalGeometry.ReadPublished(a1)
                        dispatch = if v20 ~= nil then 35 else 34
                    end
                elseif not (dispatch < 36) then
                    dispatch = if dispatch < 37 then if v20.Size.X <= 0 then 39 else 37 else if v20.Size.Y <= 0 then 39 else 38
                elseif dispatch < 35 then
                    return nil, v21
                else
                    dispatch = if not a1:IsA("BasePart") then 40 else 36
                end
            elseif dispatch < 44 then
                if dispatch < 41 then
                    if dispatch < 39 then
                        dispatch = if not (v20.Size.Z <= 0) then 40 else 39
                    elseif dispatch < 40 then
                        return nil, string.format("%s published a non-positive BasePart size", a1:GetFullName())
                    else
                        dispatch = if not a1:IsA("Model") then 43 else 41
                    end
                elseif dispatch < 42 then
                    dispatch = if v20.Size == Vector3.new(0, 0, 0) then 43 else 42
                elseif dispatch < 43 then
                    return nil, string.format("%s published a non-zero Model size", a1:GetFullName())
                else
                    v1 = getShape(a1)
                    Attribute_3 = a1:GetAttribute(Schema.Attributes.DestructibleIndex)
                    dispatch = if a2 ~= Schema.SourceKind.Destructible then 55 else 44
                end
            elseif dispatch < 47 then
                dispatch = if dispatch < 45 then if typeof(Attribute_3) ~= "number" then 50 else 45 else if dispatch < 46 then if Attribute_3 % 1 ~= 0 then 50 else 46 else if not (Attribute_3 >= 0) then 50 else 47
            elseif dispatch < 49 then
                if dispatch < 48 then
                    dispatch = if Attribute_3 <= 4294967295 then 49 else 48
                end
            elseif dispatch < 50 then
            end
        elseif dispatch < 77 then
            if dispatch < 64 then
                if dispatch < 57 then
                    if dispatch < 54 then
                        if dispatch < 52 then
                            dispatch = if Attribute_3 == 0 then 53 else 52
                        else
                            if not (dispatch < 53) then
                                return nil, string.format(
                                    "%s.%s must be in [1, %d]",
                                    a1:GetFullName(),
                                    Schema.Attributes.DestructibleIndex,
                                    a3.DestructibleCount
                                )
                            end
                            dispatch = if not (a3.DestructibleCount < Attribute_3) then 54 else 53
                        end
                    elseif not (dispatch < 55) then
                        if not (dispatch < 56) then
                            return nil, string.format(
                                "%s has %s but is not a destructible source",
                                a1:GetFullName(),
                                Schema.Attributes.DestructibleIndex
                            )
                        end
                        dispatch = if Attribute_3 == nil then 57 else 56
                    end
                elseif dispatch < 60 then
                    if dispatch < 58 then
                        Attribute_4 = a1:GetAttribute(Schema.Attributes.Climbable)
                        dispatch = if Attribute_4 ~= nil then 59 else 58
                    elseif not (dispatch < 59) then
                        dispatch = if typeof(Attribute_4) == "boolean" then 61 else 60
                    end
                elseif not (dispatch < 62) then
                    if not (dispatch < 63) then
                        return nil, v4
                    end
                    dispatch = if v3 ~= nil then 64 else 63
                elseif dispatch < 61 then
                    v4 = string.format("%s.%s must be a boolean when present", a1:GetFullName(), Climbable)
                end
            elseif dispatch < 70 then
                if dispatch < 67 then
                    if dispatch < 65 then
                        v5 = CollectionService:HasTag(a1, Schema.Tags.LadderMetadata)
                        Attribute_5 = a1:GetAttribute(Schema.Attributes.PreciseCylinder)
                        dispatch = if Attribute_5 ~= nil then 66 else 65
                    elseif not (dispatch < 66) then
                        dispatch = if typeof(Attribute_5) == "boolean" then 68 else 67
                    end
                elseif dispatch < 68 then
                    v8 = string.format("%s.%s must be a boolean when present", a1:GetFullName(), PreciseCylinder)
                elseif not (dispatch < 69) then
                    dispatch = if v7 ~= nil then 71 else 70
                end
            elseif dispatch < 73 then
                if dispatch < 71 then
                    return nil, v8
                else
                    dispatch = if dispatch < 72 then if not v7 then 74 else 72 else if v1 == Enum.PartType.Cylinder.Name then 74 else 73
                end
            elseif dispatch < 75 then
                if dispatch < 74 then
                    return nil, string.format("%s has precise-cylinder metadata but is not a Cylinder", a1:GetFullName())
                else
                    Attribute_6 = a1:GetAttribute(Schema.Attributes.ConvexGroup)
                    dispatch = if typeof(Attribute_6) ~= "string" then 77 else 75
                end
            elseif dispatch < 76 then
                dispatch = if Attribute_6 == "" then 77 else 76
            end
        elseif dispatch < 90 then
            if dispatch < 83 then
                if dispatch < 80 then
                    if dispatch < 78 then
                        dispatch = if typeof(Attribute_6) ~= "number" then 79 else 78
                    elseif dispatch < 79 then
                        v9 = tostring(Attribute_6)
                    else
                        dispatch = if Attribute_6 == nil then 82 else 80
                    end
                elseif dispatch < 81 then
                    dispatch = if Attribute_6 == "" then 82 else 81
                elseif dispatch < 82 then
                    return nil, string.format("%s.%s must be a string or number", a1:GetFullName(), Schema.Attributes.ConvexGroup)
                else
                    Attribute_7 = a1:GetAttribute(Schema.Attributes.DisableSeamMerge)
                    dispatch = if Attribute_7 ~= nil then 84 else 83
                end
            elseif dispatch < 86 then
                if not (dispatch < 84) then
                    if dispatch < 85 then
                        dispatch = if typeof(Attribute_7) == "boolean" then 86 else 85
                    else
                        v11 = string.format("%s.%s must be a boolean when present", a1:GetFullName(), DisableSeamMerge)
                    end
                end
            elseif dispatch < 88 then
                if not (dispatch < 87) then
                    dispatch = if v10 ~= nil then 89 else 88
                end
            elseif dispatch < 89 then
                return nil, v11
            else
                Attribute_9 = a1:GetAttribute(HullPoints.Attribute)
                dispatch = if Attribute_9 == nil then 96 else 90
            end
        elseif dispatch < 96 then
            if dispatch < 93 then
                if dispatch < 91 then
                    _, v14 = HullPoints.Decode(Attribute_9)
                    dispatch = if v14 == nil then 92 else 91
                elseif dispatch < 92 then
                    return nil, string.format("%s.%s: %s", a1:GetFullName(), HullPoints.Attribute, v14)
                else
                    dispatch = if not a1:IsA("Part") then 94 else 93
                end
            elseif dispatch < 94 then
                dispatch = if v1 == Enum.PartType.Block.Name then 95 else 94
            elseif dispatch < 95 then
                return nil, string.format("%s has %s but is not a block Part", a1:GetFullName(), HullPoints.Attribute)
            end
        elseif dispatch < 99 then
            if dispatch < 97 then
                dispatch = if a2 ~= Schema.SourceKind.Walkmesh then 102 else 97
            elseif not (dispatch < 98) then
                a4(string.format("%s has ladder/climbable metadata; V2 ignores it on Walkmesh", a1:GetFullName()))
            end
        elseif dispatch < 101 then
            if not (dispatch < 100) then
                return nil, v15
            end
            v14, v15 = WalkmeshCodec.ReadPublished(a1)
            dispatch = if v14 ~= nil then 101 else 100
        elseif not (dispatch < 102) then
            return (table.freeze({
                Kind = a2,
                SourceId = v16,
                Instance = a1,
                Geometry = v20,
                Shape = v1,
                Climbable = v6,
                PreciseCylinder = v7,
                ConvexGroup = v9,
                DisableSeamMerge = v10,
                HullPoints = v12,
                DestructibleIndex = v2,
                Walkmesh = v13,
            })), nil
        end
    end
end

function u30.ComputeFingerprint(a1) -- Line: 358
    -- upvalues: sourceFingerprintKey (val), CanonicalGeometry (val)
    local v1 = table.create(#a1)
    for i, v in ipairs(a1) do
        v1[i] = (sourceFingerprintKey(v))
    end
    return CanonicalGeometry.HashStrings(v1)
end

function u30.ReadPublished(a1, a2, a3) -- Line: 367
    -- upvalues: readManifest (val), findBarriersRoot (val), CollectionService (val), Schema (val), classify (val)
    -- upvalues: hasPublishedSourceAttribute (val), readSource (val), u30 (val)
    local Attribute, Attribute_2, Climbable, Ignore, UnsupportedFloorGrid, v1, v2, v3, v4, v5, v6, v7, v8
    assert(typeof(a1) == "Instance", "map root must be an Instance")
    local v9, v10 = readManifest(a1)
    if v9 == nil then
        return nil, v10
    end
    local v11, v12 = findBarriersRoot(a1)
    if v12 ~= nil then
        return nil, v12
    end
    local u393 = {}

    local function warnCatalog(a1) -- Line: 384 -- upvalues: u393 (val), a2 (val) -- types: a1: string
        u393[#u393 + 1] = a1
        if a2 ~= nil then
            a2(a1)
        end
    end

    local Descendants = a1:GetDescendants()
    local v13 = table.create(#Descendants + 1)
    v13[1] = a1
    for i, v in ipairs(Descendants) do
        v13[#v13 + 1] = v
    end
    local v14 = {}
    local v15 = {}
    local v16 = {}
    local v17 = 0
    local v18, v19 = a1, a3
    for i2, i3 in ipairs(v13) do
        if v19 ~= nil then
            v19()
        end
        v1 = CollectionService
        UnsupportedFloorGrid = Schema.Tags.UnsupportedFloorGrid
        if v1:HasTag(i3, UnsupportedFloorGrid) then
            return nil, string.format(
                "%s uses unsupported CustomFloorGrid authoring; V2 accepts Barrier (including tagged Ladder), Destructible, and Walkmesh",
                i3:GetFullName()
            )
        end
        Ignore = Schema.Attributes.Ignore
        Attribute = i3:GetAttribute(Ignore)
        if Attribute == nil then
            v1 = false
            v2 = nil
        elseif typeof(Attribute) == "boolean" then
            v1 = Attribute
            v2 = nil
        else
            v1 = nil
            v2 = string.format("%s.%s must be a boolean when present", i3:GetFullName(), Ignore)
        end
        if v1 == nil then
            return nil, v2
        end
        v3, v4, v5, v6 = classify(i3, v11)
        Climbable = Schema.Attributes.Climbable
        Attribute_2 = i3:GetAttribute(Climbable)
        if Attribute_2 ~= nil and typeof(Attribute_2) ~= "boolean" then
            return nil, string.format("%s.%s must be a boolean when present", i3:GetFullName(), Schema.Attributes.Climbable)
        end
        if v1 then
            if not v4 and not v5 and not hasPublishedSourceAttribute(i3) then
                continue
            end
            return nil, string.format("%s is both an ignored and published/tagged collision source", i3:GetFullName())
        end
        if v3 ~= nil then
            if not v4 then
                if not v5 then
                    if not v4 then end
                elseif not v6 and not v4 then
                end
            elseif v5 then
                v7 = string.format("%s is both Destructible and Walkmesh; Destructible takes precedence", i3:GetFullName())
                u393[#u393 + 1] = v7
                if a2 ~= nil then
                    a2(v7)
                end
            elseif not v5 then
                if not v4 then end
            elseif not v6 and not v4 then
            end
            v7, v8 = readSource(i3, v3, v9, warnCatalog)
            if v7 == nil then
                return nil, v8
            end
            if v15[v7.SourceId] ~= nil then
                return nil, string.format("duplicate MovementV2SourceId %d", v7.SourceId)
            end
            v15[v7.SourceId] = v7
            v14[#v14 + 1] = v7
            if v7.DestructibleIndex ~= nil then
                if v16[v7.DestructibleIndex] ~= nil then
                    return nil, string.format("duplicate MovementV2DestructibleIndex %d", v7.DestructibleIndex)
                end
                v16[v7.DestructibleIndex] = v7
                v17 = v17 + 1
            end
        else
            if hasPublishedSourceAttribute(i3) then
                return nil, string.format("%s has V2 source attributes but is not a supported source", i3:GetFullName())
            end
            if Attribute_2 == true then
                v7 = string.format("%s has standalone Climbable metadata but is not under Barriers or tagged Ladder", i3:GetFullName())
                u393[#u393 + 1] = v7
                if a2 ~= nil then
                    a2(v7)
                end
            end
        end
    end
    if #v14 ~= v9.SourceCount then
        return nil, string.format("collision manifest declares %d sources but scan found %d", v9.SourceCount, #v14)
    end
    if v17 ~= v9.DestructibleCount then
        return nil, string.format("collision manifest declares %d destructibles but scan found %d", v9.DestructibleCount, v17)
    end
    local DestructibleCount = v9.DestructibleCount
    for j = 1, DestructibleCount do
        if v16[j] == nil then
            return nil, string.format("destructible indices are not dense at index %d", j)
        end
    end
    table.sort(v14, function(a1, a2) -- Line: 504
        return a1.SourceId < a2.SourceId
    end)
    local v20 = u30.ComputeFingerprint(v14)
    if v20 ~= v9.Fingerprint then
        return nil, string.format("collision manifest fingerprint mismatch: published=%08x computed=%08x", v9.Fingerprint, v20)
    end
    table.freeze(v14)
    table.freeze(v15)
    table.freeze(v16)
    table.freeze(u393)
    return (table.freeze({
        MapRoot = v18,
        BarriersRoot = v11,
        Manifest = v9,
        Sources = v14,
        SourcesById = v15,
        DestructiblesByIndex = v16,
        Warnings = u393,
    })), nil
end

function u30.FindReplica(a1, a2) -- Line: 534
    -- upvalues: ReplicatedStorage (val), Schema (val)
    local ManifestEpoch, ManifestFingerprint, ManifestVersion
    local v1 = ReplicatedStorage:FindFirstChild(Schema.ReplicaContainerName)
    if v1 == nil then
        return nil
    end
    for i, v in ipairs(v1:GetChildren()) do
        ManifestVersion = Schema.Attributes.ManifestVersion
        if (v:GetAttribute(ManifestVersion)) == Schema.ManifestVersion then
            ManifestEpoch = Schema.Attributes.ManifestEpoch
            if v:GetAttribute(ManifestEpoch) == a1 then
                ManifestFingerprint = Schema.Attributes.ManifestFingerprint
                if v:GetAttribute(ManifestFingerprint) == a2 then
                    return v
                end
            end
        end
    end
    return nil
end

return table.freeze(u30)