-- ReplicatedStorage.Visibility.PVSRuntime
-- Script path: ReplicatedStorage.Visibility.PVSRuntime
-- Decompile time: 9.04 ms

local PVSCodec = require(script.Parent.PVSCodec)
local Constants = require(script.Parent.OBJGeometry.Constants)
local StaticGeometryRuntime = require(script.Parent.StaticGeometryRuntime)
local u16 = {}
u16.__index = u16
local MATRIX_POLICY = Constants.MATRIX_POLICY
local AUDITED_MATRIX_POLICY = Constants.AUDITED_MATRIX_POLICY

local function bucketKey(a1, a2, a3) -- Line: 22 -- types: a1: number, a2: number, a3: number
    return ((a1 + 65536) * 131072 + (a2 + 65536)) * 131072 + (a3 + 65536)
end

local function buildSpatialBuckets(a1, a2) -- Line: 31 -- types: a2: number
    local v1, v2
    local v3 = {}
    local v4 = a2
    for i, v in ipairs(a1.regions) do
        for i2 = (math.floor(v.minimum.X / v4)), (math.floor(v.maximum.X / v4)) do
            for j = (math.floor(v.minimum.Y / v4)), (math.floor(v.maximum.Y / v4)) do
                for k = (math.floor(v.minimum.Z / v4)), (math.floor(v.maximum.Z / v4)) do
                    v1 = ((i2 + 65536) * 131072 + (j + 65536)) * 131072 + (k + 65536)
                    v2 = v3[v1]
                    if v2 == nil then
                        v3[v1] = {}
                    end
                    v2[#v2 + 1] = i
                end
            end
        end
    end
    return v3
end

function u16.new(a1, a2) -- Line: 70
    -- upvalues: StaticGeometryRuntime (val), u16 (val)
    local v1 = {
        TrustedNegatives = false,
        SnapCacheCount = 0,
        SpatialBucketSize = 64,
        SelectionPadding = 8,
        MapRoot = a1,
        StorageRoot = a2 or a1,
        SpatialBuckets = {},
        SnapCaches = {},
        SnapInterned = {},
        StaticGeometry = StaticGeometryRuntime.new(a1, a2),
    }
    local v2 = setmetatable(v1, u16)
    v2:Refresh(true)
    return v2
end

function u16:Refresh(a2) -- Line: 89
    -- upvalues: PVSCodec (val), MATRIX_POLICY (val), AUDITED_MATRIX_POLICY (val), buildSpatialBuckets (val)
    local v1, v2, v3
    self.Data = nil
    self.DecodeError = nil
    self.TrustedNegatives = false
    self.SpatialBuckets = {}
    self.SnapCaches = {}
    self.SnapCacheCount = 0
    self.SnapInterned = {}
    local v4 = if not a2 then self.StaticGeometry:Refresh() else self.StaticGeometry:IsReady()
    local Attribute = self.MapRoot:GetAttribute("PVSSelectionPadding")
    if typeof(Attribute) ~= "number" or Attribute ~= Attribute then
        self.SelectionPadding = 8
    else
        self.SelectionPadding = math.clamp(Attribute, 0, 512)
    end
    self.VerticalSelectionPadding = nil
    local Attribute_2 = self.MapRoot:GetAttribute("PVSLayerHeight")
    if typeof(Attribute_2) == "number" and Attribute_2 >= 1 and Attribute_2 <= 64 then
        self.VerticalSelectionPadding = 0.25
    end
    local Attribute_3 = self.MapRoot:GetAttribute("PVSAdaptiveCellSize")
    if typeof(Attribute_3) == "number" and Attribute_3 >= 1 and Attribute_3 <= 64 then
        self.VerticalSelectionPadding = 0.25
    end
    local Attribute_4 = self.StorageRoot:GetAttribute("PVSData")
    if typeof(Attribute_4) ~= "string" then
        self.DecodeError = "MissingPVSData"
        return false
    end
    local u70 = os.clock()
    local success, result = pcall(PVSCodec.decode, Attribute_4, function() -- Line: 123 -- upvalues: u70 (ref)
        if 0.008 <= os.clock() - u70 then
            task.wait()
            u70 = os.clock()
        end
    end)
    if not success then
        self.DecodeError = tostring(result)
        return false
    end
    local Attribute_5 = self.MapRoot:GetAttribute("PVSBarrierFingerprint")
    local Attribute_6 = self.MapRoot:GetAttribute("PVSBakerVersion")
    if typeof(Attribute_6) == "number" and Attribute_6 >= 19 then
        local Attribute_7 = self.MapRoot:GetAttribute("PVSMatrixPolicy")
        if Attribute_7 ~= MATRIX_POLICY and Attribute_7 ~= AUDITED_MATRIX_POLICY then
            self.DecodeError = "UnsupportedPVSMatrixPolicy"
            return false
        end
        if self.MapRoot:GetAttribute("PVSMatrixMutual") ~= true then
            self.DecodeError = "MissingMutualVisibilityGuarantee"
            return false
        end
    end
    if self.StaticGeometry:IsExactGeometryComplete() then
        v1 = self
        v1.Data = result
        v2 = false
        if (v1.MapRoot:GetAttribute("PVSMatrixPolicy")) == AUDITED_MATRIX_POLICY then
            v2 = false
            if v1.MapRoot:GetAttribute("PVSMatrixMutual") == true then
                v2 = v1.StaticGeometry:IsExactGeometryComplete()
            end
        end
        v1.TrustedNegatives = v2
        v2 = if not (#result.regions > 2048) then 64 else 8
        while true do
            v3 = 0
            for m, i5 in result.regions do
                v3 = v3 + ((math.floor(i5.maximum.X / v2)) - math.floor(i5.minimum.X / v2) + 1) * ((math.floor(i5.maximum.Y / v2)) - math.floor(i5.minimum.Y / v2) + 1) * ((math.floor(i5.maximum.Z / v2)) - math.floor(i5.minimum.Z / v2) + 1)
            end
            if v3 <= math.max(#result.regions * 16, 65536) then
                break
            end
            v2 = v2 * 2
        end
        v1.SpatialBucketSize = v2
        v1.SpatialBuckets = buildSpatialBuckets(result, v2)
        return true
    end
    if typeof(Attribute_5) == "string" then
        if not v4 then
            self.DecodeError = ("BarrierFingerprintError:%*"):format((self.StaticGeometry:GetLoadError()) or "Unavailable")
            return false
        end
        v1 = self
        v1.Data = result
        v2 = false
        if (v1.MapRoot:GetAttribute("PVSMatrixPolicy")) == AUDITED_MATRIX_POLICY then
            v2 = false
            if v1.MapRoot:GetAttribute("PVSMatrixMutual") == true then
                v2 = v1.StaticGeometry:IsExactGeometryComplete()
            end
        end
        v1.TrustedNegatives = v2
        v2 = if not (#result.regions > 2048) then 64 else 8
        while true do
            v3 = 0
            for k, n in result.regions do
                v3 = v3 + ((math.floor(n.maximum.X / v2)) - math.floor(n.minimum.X / v2) + 1) * ((math.floor(n.maximum.Y / v2)) - math.floor(n.minimum.Y / v2) + 1) * ((math.floor(n.maximum.Z / v2)) - math.floor(n.minimum.Z / v2) + 1)
            end
            if v3 <= math.max(#result.regions * 16, 65536) then
                break
            end
            v2 = v2 * 2
        end
        v1.SpatialBucketSize = v2
        v1.SpatialBuckets = buildSpatialBuckets(result, v2)
        return true
    end
    if typeof(Attribute_6) == "number" then
        if Attribute_6 >= 14 then
            self.DecodeError = "MissingBarrierFingerprint"
            return false
        end
    end
    v1 = self
    v1.Data = result
    v2 = false
    if (v1.MapRoot:GetAttribute("PVSMatrixPolicy")) == AUDITED_MATRIX_POLICY then
        v2 = false
        if v1.MapRoot:GetAttribute("PVSMatrixMutual") == true then
            v2 = v1.StaticGeometry:IsExactGeometryComplete()
        end
    end
    v1.TrustedNegatives = v2
    v2 = if not (#result.regions > 2048) then 64 else 8
    while true do
        v3 = 0
        for i, j in result.regions do
            v3 = v3 + ((math.floor(j.maximum.X / v2)) - math.floor(j.minimum.X / v2) + 1) * ((math.floor(j.maximum.Y / v2)) - math.floor(j.minimum.Y / v2) + 1) * ((math.floor(j.maximum.Z / v2)) - math.floor(j.minimum.Z / v2) + 1)
        end
        if v3 <= math.max(#result.regions * 16, 65536) then
            break
        end
        v2 = v2 * 2
    end
    v1.SpatialBucketSize = v2
    v1.SpatialBuckets = buildSpatialBuckets(result, v2)
    return true
end

function u16:IsReady() -- Line: 186
    return self.Data ~= nil
end

function u16.TrustsNegatives(a1) -- Line: 190
    local TrustedNegatives = false
    if a1.Data ~= nil then
        TrustedNegatives = a1.TrustedNegatives
    end
    return TrustedNegatives
end

function u16.GetDecodeError(a1) -- Line: 194
    return a1.DecodeError
end

function u16.GetStaticGeometry(a1) -- Line: 198
    return a1.StaticGeometry
end

function u16.ClipStaticOrigin(a1, a2, a3, a4) -- Line: 202 -- types: a2: vector, a3: vector, a4: number?
    return a1.StaticGeometry:ClipOrigin(a2, a3, a4)
end

function u16:FindCells(a2, a3, a4, a5) -- Line: 207 -- types: a2: vector, a3: number?, a4: number?, a5: number?
    local X_4, Y_4, Z_4, v1, v2, v3, v4, v5, v6
    local Data = self.Data
    if Data == nil then
        return {}
    end
    local v7 = math.clamp(if a3 ~= nil then a3 else self.SelectionPadding, 0, 512)
    local v8 = if self.VerticalSelectionPadding == nil then v7 else math.min(v7, self.VerticalSelectionPadding)
    v7 = v7 + math.max(a4 or 0, 0)
    v8 = v8 + math.max(a5 or 0, 0)
    local SpatialBucketSize = self.SpatialBucketSize
    local v9 = math.floor((a2.X - v7) / SpatialBucketSize)
    local v10 = math.floor((a2.X + v7) / SpatialBucketSize)
    local v11 = math.floor((a2.Y - v8) / SpatialBucketSize)
    local v12 = math.floor((a2.Y + v8) / SpatialBucketSize)
    local v13 = math.floor((a2.Z - v7) / SpatialBucketSize)
    local v14 = math.floor((a2.Z + v7) / SpatialBucketSize)
    local v15 = (v10 - v9 + 1) * (v12 - v11 + 1) * (v14 - v13 + 1)
    if #Data.regions < v15 then
        local X_3, Y_3, Z_3
        v15 = {}
        v1 = {}
        for i5, i6 in Data.regions do
            if not v15[i6.cluster] then
                X_3 = a2.X
                if i6.minimum.X - v7 <= X_3 and a2.X <= i6.maximum.X + v7 then
                    Y_3 = a2.Y
                    if i6.minimum.Y - v8 <= Y_3 and a2.Y <= i6.maximum.Y + v8 then
                        Z_3 = a2.Z
                        if i6.minimum.Z - v7 <= Z_3 and a2.Z <= i6.maximum.Z + v7 then
                            v15[i6.cluster] = true
                            v1[#v1 + 1] = i6.cluster
                        end
                    end
                end
            end
        end
        table.sort(v1)
        return v1
    end
    v15 = {}
    v1 = {}
    local v16 = {}
    local v17, v18 = self, a2
    for i = v9, v10 do
        for j = v11, v12 do
            for k = v13, v14 do
                v2 = v17.SpatialBuckets[((i + 65536) * 131072 + (j + 65536)) * 131072 + (k + 65536)]
                if v2 ~= nil then
                    v3 = nil
                    v4 = nil
                    for n, m in v2, v3, v4 do
                        if not v15[m] then
                            v15[m] = true
                            v5 = Data.regions[m]
                            v6 = false
                            X_4 = v18.X
                            if v5.minimum.X - v7 <= X_4 then
                                v6 = false
                                if v18.X <= v5.maximum.X + v7 then
                                    v6 = false
                                    Y_4 = v18.Y
                                    if v5.minimum.Y - v8 <= Y_4 then
                                        v6 = false
                                        if v18.Y <= v5.maximum.Y + v8 then
                                            v6 = false
                                            Z_4 = v18.Z
                                            if v5.minimum.Z - v7 <= Z_4 then
                                                v6 = v18.Z <= v5.maximum.Z + v7
                                            end
                                        end
                                    end
                                end
                            end
                            if not v1[v5.cluster] and v6 then
                                v1[v5.cluster] = true
                                v16[#v16 + 1] = v5.cluster
                            end
                        end
                    end
                end
            end
        end
    end
    table.sort(v16)
    return v16
end

function u16.SnapKey(a1, a2) -- Line: 286 -- types: a2: vector
    local v1 = math.floor(a2.X / 1)
    local v2 = math.floor(a2.Y / 0.5)
    local v3 = math.floor(a2.Z / 1)
    if not (65536 <= (math.max(math.abs(v1), math.abs(v2), (math.abs(v3)))))
        and v1 == v1
        and v2 == v2
        and v3 == v3 then
        return ((v1 + 65536) * 131072 + (v2 + 65536)) * 131072 + (v3 + 65536)
    end
    return nil
end

function u16.SnapCells(a1, a2, a3) -- Line: 297 -- types: a2: vector, a3: number?
    local v1
    local v2 = a1:SnapKey(a2)
    if v2 == nil then
        return a1:FindCells(a2, a3, 1, 0.5)
    end
    local v3 = a1.SnapCaches[if a3 ~= nil then a3 else -1]
    if v3 == nil then
        a1.SnapCaches[v1] = {}
    end
    local v4 = v3[v2]
    if v4 ~= nil then
        return v4
    end
    if 65536 <= a1.SnapCacheCount then
        table.clear(a1.SnapCaches)
        table.clear(a1.SnapInterned)
        a1.SnapCacheCount = 0
        a1.SnapCaches[v1] = {}
    end
    v4 = a1:FindCells(
        Vector3.new((math.floor(a2.X / 1) + 0.5) * 1, (math.floor(a2.Y / 0.5) + 0.5) * 0.5, ((math.floor(a2.Z / 1)) + 0.5) * 1),
        a3,
        0.5,
        0.25
    )
    local v5 = table.concat(v4, ",")
    local v6 = a1.SnapInterned[v5]
    if v6 == nil then
        v6 = table.freeze(v4)
        a1.SnapInterned[v5] = v6
    end
    v4 = v6
    v3[v2] = v4
    a1.SnapCacheCount = a1.SnapCacheCount + 1
    return v4
end

local function validCells(a1, a2) -- Line: 338 -- types: a1: table, a2: number
    for i, j in a1 do
        if j == j and j % 1 == 0 and not (j < 1) and not (a2 < j) then
            continue
        end
        return false
    end
    return true
end

function u16:CouldCellsSee(a2, a3) -- Line: 347
    -- upvalues: validCells (val), PVSCodec (val)
    local Data = self.Data
    if Data ~= nil and #a2 ~= 0 and #a3 ~= 0 then
        if validCells(a2, #Data.cells) and validCells(a3, #Data.cells) then
            for i, v in ipairs(a2) do
                for i2, i3 in ipairs(a3) do
                    if PVSCodec.isVisible(Data, v, i3) then
                        return true
                    end
                end
            end
            return false
        end
        return true
    end
    return true
end

function u16.ClassifyCells(a1, a2, a3) -- Line: 368 -- types: a2: table, a3: table
    if a1:CouldCellsSee(a2, a3) then
        return "VisibleWithoutRuntimeProof"
    end
    return "NeedsRuntimeOcclusionProof"
end

return table.freeze(u16)