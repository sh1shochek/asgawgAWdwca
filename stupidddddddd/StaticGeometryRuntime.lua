-- ReplicatedStorage.Visibility.StaticGeometryRuntime
-- Script path: ReplicatedStorage.Visibility.StaticGeometryRuntime
-- Decompile time: 12.81 ms

local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")
local BarrierGeometry = require(script.Parent.BarrierGeometry)
local Constants = require(script.Parent.OBJGeometry.Constants)
local GeometryFingerprint = require(script.Parent.OBJGeometry.GeometryFingerprint)
local OccluderCatalog = require(script.Parent.OBJGeometry.OccluderCatalog)
local StaticOcclusionCodec = require(script.Parent.StaticOcclusionCodec)
local StaticOcclusionRuntime = require(script.Parent.StaticOcclusionRuntime)
local StaticOcclusionStorage = require(script.Parent.StaticOcclusionStorage)
local u48 = {}
u48.__index = u48
local NEGATIVE_AUTHORITY = Constants.NEGATIVE_AUTHORITY
local GEOMETRY_VERSION = Constants.GEOMETRY_VERSION

local function isFinite(a1) -- Line: 27 -- types: a1: number
    local v1 = false
    if a1 == a1 then
        v1 = false
        if a1 > (-1 / 0) then
            v1 = a1 < (1 / 0)
        end
    end
    return v1
end

local function isFiniteVector(a1) -- Line: 31 -- types: a1: vector
    local X = a1.X
    local v1 = false
    if X == X then
        v1 = false
        if X > (-1 / 0) then
            v1 = X < (1 / 0)
        end
    end
    if v1 then
        local Y = a1.Y
        v1 = false
        if Y == Y then
            v1 = false
            if Y > (-1 / 0) then
                v1 = Y < (1 / 0)
            end
        end
        if v1 then
            local Z = a1.Z
            v1 = false
            if Z == Z then
                v1 = false
                if Z > (-1 / 0) then
                    v1 = Z < (1 / 0)
                end
            end
        end
    end
    return v1
end

local function vectorsClose(a1, a2, a3) -- Line: 35 -- types: a1: vector, a2: vector, a3: number
    local v1 = false
    if math.abs(a1.X - a2.X) <= a3 then
        v1 = false
        if math.abs(a1.Y - a2.Y) <= a3 then
            v1 = math.abs(a1.Z - a2.Z) <= a3
        end
    end
    return v1
end

local function exactFingerprintBindsExport(a1, a2) -- Line: 41 -- types: a1: string, a2: string
    local v1, v2 = string.match(a1, "^VGEOM1:([%da-fA-F]+):([%da-fA-F]+)$")
    local v3 = false
    if v1 ~= nil then
        v3 = false
        if v2 ~= nil then
            v3 = false
            if #v1 == 16 then
                v3 = false
                if #v2 == 64 then
                    v3 = (string.lower(v1)) == string.lower(a2)
                end
            end
        end
    end
    return v3
end

local function validateLiveGeometryRecipe(a1, a2) -- Line: 51
    -- upvalues: Constants (val), exactFingerprintBindsExport (val), OccluderCatalog (val), CollectionService (val)
    -- upvalues: GeometryFingerprint (val)
    if (a1:GetAttribute("PVSVisibilityExportVersion")) ~= Constants.EXPORT_VERSION then
        return "UnsupportedPVSVisibilityExportVersion"
    end
    if (a1:GetAttribute("PVSVisibilityExportTransform")) ~= Constants.EXPORT_TRANSFORM then
        return "UnsupportedPVSVisibilityExportTransform"
    end
    local Attribute_3 = a1:GetAttribute("PVSVisibilityExportFingerprint")
    local Attribute_4 = a1:GetAttribute("PVSVisibilityGeometryExportFingerprint")
    local Attribute_5 = a1:GetAttribute("PVSVisibilityExportExpectedParts")
    local Attribute_6 = a1:GetAttribute("PVSVisibilityExportBoundsMin")
    local Attribute_7 = a1:GetAttribute("PVSVisibilityExportBoundsMax")
    if typeof(Attribute_3) == "string" and #Attribute_3 ~= 0 then
        if typeof(Attribute_4) == "string" and #Attribute_4 ~= 0 then
            if typeof(Attribute_5) == "number"
                and not (Attribute_5 < 1)
                and Attribute_5 % 1 == 0
                and typeof(Attribute_6) == "Vector3"
                and typeof(Attribute_7) == "Vector3" then
                local X = Attribute_6.X
                local v1 = false
                if X == X then
                    v1 = false
                    if X > (-1 / 0) then
                        v1 = X < (1 / 0)
                    end
                end
                if v1 then
                    local Y = Attribute_6.Y
                    v1 = false
                    if Y == Y then
                        v1 = false
                        if Y > (-1 / 0) then
                            v1 = Y < (1 / 0)
                        end
                    end
                    if v1 then
                        local Z = Attribute_6.Z
                        v1 = false
                        if Z == Z then
                            v1 = false
                            if Z > (-1 / 0) then
                                v1 = Z < (1 / 0)
                            end
                        end
                    end
                end
                if v1 then
                    local X_2 = Attribute_7.X
                    v1 = false
                    if X_2 == X_2 then
                        v1 = false
                        if X_2 > (-1 / 0) then
                            v1 = X_2 < (1 / 0)
                        end
                    end
                    if v1 then
                        local Y_2 = Attribute_7.Y
                        v1 = false
                        if Y_2 == Y_2 then
                            v1 = false
                            if Y_2 > (-1 / 0) then
                                v1 = Y_2 < (1 / 0)
                            end
                        end
                        if v1 then
                            local Z_2 = Attribute_7.Z
                            v1 = false
                            if Z_2 == Z_2 then
                                v1 = false
                                if Z_2 > (-1 / 0) then
                                    v1 = Z_2 < (1 / 0)
                                end
                            end
                        end
                    end
                    if v1 then
                        if (string.lower(Attribute_3)) ~= string.lower(Attribute_4) then
                            return "PVSVisibilityGeometryExportFingerprintMismatch"
                        end
                        if not exactFingerprintBindsExport(a2, Attribute_4) then
                            return "PVSVisibilityGeometryBindingMismatch"
                        end
                        local success, result = pcall(function() -- Line: 87 -- upvalues: OccluderCatalog (upval), a1 (val), CollectionService (upval)
                            return OccluderCatalog.build(a1, function(a1, a2) -- Line: 88 -- upvalues: CollectionService (upval) -- types: a1: userdata, a2: string
                                return CollectionService:HasTag(a1, a2)
                            end)
                        end)
                        if not success then
                            return (("PVSVisibilityCatalogError:%*"):format((tostring(result))))
                        end
                        if #result.rejections > 0 then
                            return (("InvalidPVSVisibilityOccluderCatalog:%*"):format(#result.rejections))
                        end
                        if #result.parts == 0 then
                            return "EmptyPVSVisibilityOccluderCatalog"
                        end
                        local success_2, result_2 = pcall(GeometryFingerprint.compute, a1, result.parts)
                        if not success_2 then
                            return (("PVSVisibilityFingerprintError:%*"):format((tostring(result_2))))
                        end
                        if (string.lower(result_2.fingerprint)) ~= string.lower(Attribute_3) then
                            return "StalePVSVisibilityGeometryFingerprint"
                        end
                        if result_2.partCount ~= Attribute_5 then
                            return "StalePVSVisibilityGeometryPartCount"
                        end
                        local minimum = result_2.minimum
                        local BOUNDS_TOLERANCE = Constants.BOUNDS_TOLERANCE
                        local v2 = false
                        if math.abs(minimum.X - Attribute_6.X) <= BOUNDS_TOLERANCE then
                            v2 = false
                            if math.abs(minimum.Y - Attribute_6.Y) <= BOUNDS_TOLERANCE then
                                v2 = math.abs(minimum.Z - Attribute_6.Z) <= BOUNDS_TOLERANCE
                            end
                        end
                        if v2 then
                            local maximum = result_2.maximum
                            local BOUNDS_TOLERANCE_2 = Constants.BOUNDS_TOLERANCE
                            v2 = false
                            if math.abs(maximum.X - Attribute_7.X) <= BOUNDS_TOLERANCE_2 then
                                v2 = false
                                if math.abs(maximum.Y - Attribute_7.Y) <= BOUNDS_TOLERANCE_2 then
                                    v2 = math.abs(maximum.Z - Attribute_7.Z) <= BOUNDS_TOLERANCE_2
                                end
                            end
                            if v2 then
                                return nil
                            end
                        end
                        return "StalePVSVisibilityGeometryBounds"
                    end
                end
            end
            return "InvalidPVSVisibilityExportManifest"
        end
        return "MissingPVSVisibilityGeometryExportFingerprint"
    end
    return "MissingPVSVisibilityExportFingerprint"
end

function u48.new(a1, a2) -- Line: 145 -- upvalues: u48 (val) -- types: a1: userdata, a2: userdata?
    local v1 = {
        ExactGeometryDeclared = false,
        ExactGeometryComplete = false,
        MapRoot = a1,
        StorageRoot = a2 or a1,
    }
    local v2 = setmetatable(v1, u48)
    v2:Refresh()
    return v2
end

function u48:Refresh() -- Line: 156
    -- upvalues: Workspace (val), NEGATIVE_AUTHORITY (val), GEOMETRY_VERSION (val), validateLiveGeometryRecipe (val)
    -- upvalues: StaticOcclusionStorage (val), StaticOcclusionRuntime (val), StaticOcclusionCodec (val)
    -- upvalues: BarrierGeometry (val)
    local v1, v2
    self.Catalog = nil
    self.RaycastParams = nil
    self.Fingerprint = nil
    self.LoadError = nil
    self.StaticOcclusion = nil
    self.EncodedStaticOcclusion = nil
    self.EncodedProofs = nil
    self.ProofError = nil
    self.StaticOcclusionError = nil
    self.ExactGeometryDeclared = false
    self.ExactGeometryComplete = false
    self.ExactGeometryFingerprint = nil
    self.ExactGeometryError = nil
    if self.MapRoot ~= Workspace and not self.MapRoot:IsDescendantOf(Workspace) then
        self.LoadError = "MapNotInWorkspace"
        return false
    end
    local Attribute = self.MapRoot:GetAttribute("PVSNegativeAuthority")
    local Attribute_2 = self.MapRoot:GetAttribute("PVSVisibilityGeometryVersion")
    local Attribute_3 = self.MapRoot:GetAttribute("PVSVisibilityGeometryComplete")
    local Attribute_4 = self.MapRoot:GetAttribute("PVSVisibilityGeometryFingerprint")
    local v3 = true
    if Attribute == nil then
        v3 = true
        if Attribute_2 == nil then
            v3 = true
            if Attribute_3 == nil then
                v3 = Attribute_4 ~= nil
            end
        end
    end
    self.ExactGeometryDeclared = v3
    if self.ExactGeometryDeclared then
        if Attribute ~= NEGATIVE_AUTHORITY then
            self.ExactGeometryError = "UnsupportedPVSNegativeAuthority"
        elseif Attribute_2 ~= GEOMETRY_VERSION then
            self.ExactGeometryError = "UnsupportedPVSVisibilityGeometryVersion"
        elseif Attribute_3 ~= true then
            self.ExactGeometryError = "IncompletePVSVisibilityGeometry"
        elseif typeof(Attribute_4) ~= "string" then
            self.ExactGeometryError = "MissingPVSVisibilityGeometryFingerprint"
        elseif #Attribute_4 ~= 0 then
            self.ExactGeometryFingerprint = Attribute_4
        else
            self.ExactGeometryError = "MissingPVSVisibilityGeometryFingerprint"
        end
    end
    if not self.ExactGeometryDeclared then
        local success_3, result_3, v4 = pcall(BarrierGeometry.collect, self.MapRoot)
        if not success_3 or result_3 == nil then
            self.LoadError = if not success_3 then ("BarrierCatalogError:%*"):format((tostring(result_3))) else v4 or "MissingBarrierCatalog"
        else
            local Attribute_5 = self.MapRoot:GetAttribute("PVSBarrierFingerprint")
            if typeof(Attribute_5) ~= "string" then
                self.Catalog = result_3
            elseif result_3.fingerprint ~= Attribute_5 then
                self.LoadError = "StaleBarrierGeometry"
            else
                self.Catalog = result_3
            end
        end
        local Catalog = self.Catalog
        if Catalog == nil then
            return false
        end
        self.RaycastParams = BarrierGeometry.buildRaycastParams(Catalog)
        self.Fingerprint = Catalog.fingerprint
        v2, v1 = StaticOcclusionStorage.read(self.StorageRoot, Catalog.fingerprint)
        if v2 ~= nil then
            local success_4, result_4 = pcall(StaticOcclusionRuntime.new, v2, Catalog.fingerprint)
            if not success_4 then
                self.StaticOcclusionError = tostring(result_4)
            else
                self.StaticOcclusion = result_4
                self.EncodedStaticOcclusion = v2
            end
        else
            self.StaticOcclusionError = v1
        end
        return true
    end
    local ExactGeometryFingerprint = self.ExactGeometryFingerprint
    if self.ExactGeometryError == nil and ExactGeometryFingerprint ~= nil then
        local v5 = validateLiveGeometryRecipe(self.MapRoot, ExactGeometryFingerprint)
        if v5 ~= nil then
            self.LoadError = v5
            self.StaticOcclusionError = v5
            self.ExactGeometryError = v5
            return false
        end
        local u77 = os.clock()

        local function startupCheckpoint() -- Line: 213 -- upvalues: u77 (ref)
            if 0.008 <= os.clock() - u77 then
                task.wait()
                u77 = os.clock()
            end
        end

        v2, v1 = StaticOcclusionStorage.read(self.StorageRoot, ExactGeometryFingerprint, startupCheckpoint)
        if v2 == nil then
            self.LoadError = v1 or "MissingExactPVSStaticOcclusion"
            self.StaticOcclusionError = self.LoadError
            self.ExactGeometryError = self.LoadError
            return false
        end
        local success, result = pcall(StaticOcclusionRuntime.new, v2, ExactGeometryFingerprint, startupCheckpoint)
        if not success then
            self.LoadError = ("ExactPVSStaticOcclusionError:%*"):format((tostring(result)))
            self.StaticOcclusionError = self.LoadError
            self.ExactGeometryError = self.LoadError
            return false
        end
        local v6, v7 = StaticOcclusionCodec.validateExactGeometry(result.Data)
        if not v6 then
            self.LoadError = v7 or "InvalidExactPVBVHProfile"
            self.StaticOcclusionError = self.LoadError
            self.ExactGeometryError = self.LoadError
            return false
        end
        self.StaticOcclusion = result
        self.EncodedStaticOcclusion = v2
        local success_2, result_2, v8 = pcall(StaticOcclusionStorage.readProofs, self.StorageRoot, ExactGeometryFingerprint, startupCheckpoint)
        if not success_2 then
            v8 = tostring(result_2)
            result_2 = nil
        end
        self.ProofError = v8
        if result_2 ~= nil then
            local v9, v10 = result:InstallProofs(result_2, startupCheckpoint)
            if not v9 then
                self.ProofError = v10
            else
                self.EncodedProofs = result_2
            end
        end
        self.Fingerprint = ExactGeometryFingerprint
        self.ExactGeometryComplete = true
        self.LoadError = nil
        return true
    end
    self.LoadError = self.ExactGeometryError or "InvalidPVSVisibilityGeometryContract"
    self.StaticOcclusionError = self.LoadError
    return false
end

function u48.IsReady(a1) -- Line: 301
    return a1.ExactGeometryComplete or a1.RaycastParams ~= nil
end

function u48.GetLoadError(a1) -- Line: 305
    return a1.LoadError
end

function u48.GetFingerprint(a1) -- Line: 309
    return a1.Fingerprint
end

function u48.GetStaticOcclusion(a1) -- Line: 313
    return a1.StaticOcclusion
end

function u48.GetEncodedStaticOcclusion(a1) -- Line: 319
    return a1.EncodedStaticOcclusion
end

function u48.GetStaticOcclusionError(a1) -- Line: 323
    return a1.StaticOcclusionError
end

function u48.IsExactGeometryComplete(a1) -- Line: 327
    return a1.ExactGeometryComplete
end

function u48:RaycastSegment(a2, a3) -- Line: 332 -- upvalues: Workspace (val) -- types: a2: vector, a3: vector
    if self.ExactGeometryDeclared then
        return nil, false
    end
    local RaycastParams = self.RaycastParams
    if RaycastParams ~= nil then
        local X = a2.X
        local v1 = false
        if X == X then
            v1 = false
            if X > (-1 / 0) then
                v1 = X < (1 / 0)
            end
        end
        if v1 then
            local Y = a2.Y
            v1 = false
            if Y == Y then
                v1 = false
                if Y > (-1 / 0) then
                    v1 = Y < (1 / 0)
                end
            end
            if v1 then
                local Z = a2.Z
                v1 = false
                if Z == Z then
                    v1 = false
                    if Z > (-1 / 0) then
                        v1 = Z < (1 / 0)
                    end
                end
            end
        end
        if v1 then
            local X_2 = a3.X
            v1 = false
            if X_2 == X_2 then
                v1 = false
                if X_2 > (-1 / 0) then
                    v1 = X_2 < (1 / 0)
                end
            end
            if v1 then
                local Y_2 = a3.Y
                v1 = false
                if Y_2 == Y_2 then
                    v1 = false
                    if Y_2 > (-1 / 0) then
                        v1 = Y_2 < (1 / 0)
                    end
                end
                if v1 then
                    local Z_2 = a3.Z
                    v1 = false
                    if Z_2 == Z_2 then
                        v1 = false
                        if Z_2 > (-1 / 0) then
                            v1 = Z_2 < (1 / 0)
                        end
                    end
                end
            end
            if v1 then
                v1 = a3 - a2
                if v1.Magnitude <= 0.001 then
                    return nil, true
                end
                local success, result = pcall(Workspace.Raycast, Workspace, a2, v1, RaycastParams)
                if not success then
                    return nil, false
                end
                return result, true
            end
        end
    end
    return nil, false
end

function u48:SegmentBlocked(a2, a3) -- Line: 358 -- types: a2: vector, a3: vector
    local X = a2.X
    local v1 = false
    if X == X then
        v1 = false
        if X > (-1 / 0) then
            v1 = X < (1 / 0)
        end
    end
    if v1 then
        local Y = a2.Y
        v1 = false
        if Y == Y then
            v1 = false
            if Y > (-1 / 0) then
                v1 = Y < (1 / 0)
            end
        end
        if v1 then
            local Z = a2.Z
            v1 = false
            if Z == Z then
                v1 = false
                if Z > (-1 / 0) then
                    v1 = Z < (1 / 0)
                end
            end
        end
    end
    if v1 then
        local X_2 = a3.X
        v1 = false
        if X_2 == X_2 then
            v1 = false
            if X_2 > (-1 / 0) then
                v1 = X_2 < (1 / 0)
            end
        end
        if v1 then
            local Y_2 = a3.Y
            v1 = false
            if Y_2 == Y_2 then
                v1 = false
                if Y_2 > (-1 / 0) then
                    v1 = Y_2 < (1 / 0)
                end
            end
            if v1 then
                local Z_2 = a3.Z
                v1 = false
                if Z_2 == Z_2 then
                    v1 = false
                    if Z_2 > (-1 / 0) then
                        v1 = Z_2 < (1 / 0)
                    end
                end
            end
        end
        if v1 then
            local StaticOcclusion = self.StaticOcclusion
            local Catalog = self.Catalog
            local v2 = false
            if self.ExactGeometryDeclared then
                if self.ExactGeometryComplete and StaticOcclusion ~= nil then
                    local success, result = pcall(StaticOcclusion.SegmentBlocked, StaticOcclusion, a2, a3, nil)
                    if not success then
                        return false, false, nil, true, false
                    end
                    return result == true, true, nil, true, false
                end
                return false, false, nil, false, false
            end
            if StaticOcclusion ~= nil and Catalog ~= nil then
                v2 = true
                local success_2, result_2, v3 = pcall(StaticOcclusion.SegmentBlocked, StaticOcclusion, a2, a3, nil)
                if success_2 and result_2 == true then
                    return true, true, if typeof(v3) ~= "number" then nil else Catalog.parts[v3], true, false
                end
            end
            local v4, v5 = self:RaycastSegment(a2, a3)
            local Instance = if v4 == nil then nil else if not v4.Instance:IsA("BasePart") then nil else v4.Instance
            return v5 and v4 ~= nil, v5, Instance, v2, true
        end
    end
    return false, false, nil, false, false
end

function u48.ClipOrigin(a1, a2, a3, a4) -- Line: 394 -- types: a2: vector, a3: vector, a4: number?
    local v1, v2
    if not a1.ExactGeometryDeclared then
        local v3
        local v4 = a3 - a2
        if v4.Magnitude <= 0.001 then
            return a3
        end
        v1, v3 = a1:SegmentBlocked(a2, a3)
        if v3 and v1 then
            local v5, v6, v7, v8
            local v9 = math.clamp(a4 or 0.25, 0, 16)
            if not (v9 <= 0) then
                v8, v2 = a1:RaycastSegment(a2, a3)
                if v2 and v8 ~= nil then
                    return a2 + v4.Unit * math.max(v8.Distance - v9, 0)
                end
                return a3
            end
            v8 = a2
            v2 = a3
            local v10, v11 = a2, a1
            for i = 1, 8 do
                v5 = (v8 + v2) * 0.5
                v6, v7 = v11:SegmentBlocked(v10, v5)
                if not v7 then
                    return a3
                end
                if v6 then
                    v2 = v5
                else
                    v8 = v5
                end
            end
            return v8
        end
        return a3
    end
    local StaticOcclusion = a1.StaticOcclusion
    if a1.ExactGeometryComplete and StaticOcclusion ~= nil then
        local X = a2.X
        v1 = false
        if X == X then
            v1 = false
            if X > (-1 / 0) then
                v1 = X < (1 / 0)
            end
        end
        if v1 then
            local Y = a2.Y
            v1 = false
            if Y == Y then
                v1 = false
                if Y > (-1 / 0) then
                    v1 = Y < (1 / 0)
                end
            end
            if v1 then
                local Z = a2.Z
                v1 = false
                if Z == Z then
                    v1 = false
                    if Z > (-1 / 0) then
                        v1 = Z < (1 / 0)
                    end
                end
            end
        end
        if v1 then
            local X_2 = a3.X
            v1 = false
            if X_2 == X_2 then
                v1 = false
                if X_2 > (-1 / 0) then
                    v1 = X_2 < (1 / 0)
                end
            end
            if v1 then
                local Y_2 = a3.Y
                v1 = false
                if Y_2 == Y_2 then
                    v1 = false
                    if Y_2 > (-1 / 0) then
                        v1 = Y_2 < (1 / 0)
                    end
                end
                if v1 then
                    local Z_2 = a3.Z
                    v1 = false
                    if Z_2 == Z_2 then
                        v1 = false
                        if Z_2 > (-1 / 0) then
                            v1 = Z_2 < (1 / 0)
                        end
                    end
                end
            end
            if v1 then
                v1 = a3 - a2
                local Magnitude = v1.Magnitude
                if Magnitude <= 0.001 then
                    return a3
                end
                local success, result = pcall(StaticOcclusion.NearestSegmentHit, StaticOcclusion, a2, a3)
                if success and result ~= nil then
                    v2 = math.clamp((math.ceil(result / 0.9999999 * 256) - 1) / 256, 0, 1)
                    local v12 = math.clamp(a4 or 0.25, 0, 16)
                    return a2 + v1.Unit * math.max(Magnitude * v2 - v12, 0)
                end
                return a3
            end
        end
    end
    return a3
end

return table.freeze(u48)