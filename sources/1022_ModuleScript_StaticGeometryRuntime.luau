-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Workspace = game:GetService("Workspace");
local BarrierGeometry = require(script.Parent.BarrierGeometry);
local Constants = require(script.Parent.OBJGeometry.Constants);
local GeometryFingerprint = require(script.Parent.OBJGeometry.GeometryFingerprint);
local OccluderCatalog = require(script.Parent.OBJGeometry.OccluderCatalog);
local StaticOcclusionCodec = require(script.Parent.StaticOcclusionCodec);
local StaticOcclusionRuntime = require(script.Parent.StaticOcclusionRuntime);
local StaticOcclusionStorage = require(script.Parent.StaticOcclusionStorage);
local u1 = {};
u1.__index = u1;
local NEGATIVE_AUTHORITY = Constants.NEGATIVE_AUTHORITY;
local GEOMETRY_VERSION = Constants.GEOMETRY_VERSION;

local function isFinite(p2: number) -- Line: 27
    local v3;

    if p2 == p2 and p2 > (-1 / 0) then
        v3 = p2 < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

local function isFiniteVector(p4: vector) -- Line: 31
    local X = p4.X;
    local v5;

    if X == X and X > (-1 / 0) then
        v5 = X < (1 / 0);
    else
        v5 = false;
    end;

    if v5 then
        local Y = p4.Y;

        if Y == Y and Y > (-1 / 0) then
            v5 = Y < (1 / 0);
        else
            v5 = false;
        end;

        if v5 then
            local Z = p4.Z;

            if Z == Z and Z > (-1 / 0) then
                v5 = Z < (1 / 0);
            else
                v5 = false;
            end;
        end;
    end;

    return v5;
end;

local function vectorsClose(p6: vector, p7: vector, p8: number) -- Line: 35
    local v9;

    if math.abs(p6.X - p7.X) <= p8 and math.abs(p6.Y - p7.Y) <= p8 then
        v9 = math.abs(p6.Z - p7.Z) <= p8;
    else
        v9 = false;
    end;

    return v9;
end;

local function exactFingerprintBindsExport(p10: string, p11: string) -- Line: 41
    local string_match_ret, v12 = string.match(p10, "^VGEOM1:([%da-fA-F]+):([%da-fA-F]+)$");
    local v13;

    if string_match_ret == nil or (v12 == nil or (#string_match_ret ~= 16 or #v12 ~= 64)) then
        v13 = false;
    else
        v13 = string.lower(string_match_ret) == string.lower(p11);
    end;

    return v13;
end;

local function validateLiveGeometryRecipe(u14: userdata, p15: string) -- Line: 51
    -- upvalues: Constants (copy), exactFingerprintBindsExport (copy), OccluderCatalog (copy), CollectionService (copy), GeometryFingerprint (copy)
    if u14:GetAttribute("PVSVisibilityExportVersion") ~= Constants.EXPORT_VERSION then
        return "UnsupportedPVSVisibilityExportVersion";
    end;

    if u14:GetAttribute("PVSVisibilityExportTransform") ~= Constants.EXPORT_TRANSFORM then
        return "UnsupportedPVSVisibilityExportTransform";
    end;

    local Attribute = u14:GetAttribute("PVSVisibilityExportFingerprint");
    local Attribute2 = u14:GetAttribute("PVSVisibilityGeometryExportFingerprint");
    local Attribute3 = u14:GetAttribute("PVSVisibilityExportExpectedParts");
    local Attribute4 = u14:GetAttribute("PVSVisibilityExportBoundsMin");
    local Attribute5 = u14:GetAttribute("PVSVisibilityExportBoundsMax");

    if typeof(Attribute) ~= "string" or #Attribute == 0 then
        return "MissingPVSVisibilityExportFingerprint";
    end;

    if typeof(Attribute2) ~= "string" or #Attribute2 == 0 then
        return "MissingPVSVisibilityGeometryExportFingerprint";
    end;

    if typeof(Attribute3) == "number" and (Attribute3 >= 1 and (Attribute3 % 1 == 0 and (typeof(Attribute4) == "Vector3" and typeof(Attribute5) == "Vector3"))) then
        local X = Attribute4.X;
        local v16;

        if X == X and X > (-1 / 0) then
            v16 = X < (1 / 0);
        else
            v16 = false;
        end;

        if v16 then
            local Y = Attribute4.Y;

            if Y == Y and Y > (-1 / 0) then
                v16 = Y < (1 / 0);
            else
                v16 = false;
            end;

            if v16 then
                local Z = Attribute4.Z;

                if Z == Z and Z > (-1 / 0) then
                    v16 = Z < (1 / 0);
                else
                    v16 = false;
                end;
            end;
        end;

        if v16 then
            local X2 = Attribute5.X;
            local v17;

            if X2 == X2 and X2 > (-1 / 0) then
                v17 = X2 < (1 / 0);
            else
                v17 = false;
            end;

            if v17 then
                local Y = Attribute5.Y;

                if Y == Y and Y > (-1 / 0) then
                    v17 = Y < (1 / 0);
                else
                    v17 = false;
                end;

                if v17 then
                    local Z = Attribute5.Z;

                    if Z == Z and Z > (-1 / 0) then
                        v17 = Z < (1 / 0);
                    else
                        v17 = false;
                    end;
                end;
            end;

            if v17 then
                if string.lower(Attribute) ~= string.lower(Attribute2) then
                    return "PVSVisibilityGeometryExportFingerprintMismatch";
                end;

                if not exactFingerprintBindsExport(p15, Attribute2) then
                    return "PVSVisibilityGeometryBindingMismatch";
                end;

                local success, result = pcall(function() -- Line: 87
                    -- upvalues: OccluderCatalog (ref), u14 (copy), CollectionService (ref)
                    return OccluderCatalog.build(u14, function(p18: userdata, p19: string) -- Line: 88
                        -- upvalues: CollectionService (ref)
                        return CollectionService:HasTag(p18, p19);
                    end);
                end);

                if not success then
                    return `PVSVisibilityCatalogError:{tostring(result)}`;
                end;

                if #result.rejections > 0 then
                    return `InvalidPVSVisibilityOccluderCatalog:{#result.rejections}`;
                end;

                if #result.parts == 0 then
                    return "EmptyPVSVisibilityOccluderCatalog";
                end;

                local success2, result2 = pcall(GeometryFingerprint.compute, u14, result.parts);

                if not success2 then
                    return `PVSVisibilityFingerprintError:{tostring(result2)}`;
                end;

                if string.lower(result2.fingerprint) ~= string.lower(Attribute) then
                    return "StalePVSVisibilityGeometryFingerprint";
                end;

                if result2.partCount ~= Attribute3 then
                    return "StalePVSVisibilityGeometryPartCount";
                end;

                local minimum = result2.minimum;
                local BOUNDS_TOLERANCE = Constants.BOUNDS_TOLERANCE;
                local v20;

                if math.abs(minimum.X - Attribute4.X) <= BOUNDS_TOLERANCE and math.abs(minimum.Y - Attribute4.Y) <= BOUNDS_TOLERANCE then
                    v20 = math.abs(minimum.Z - Attribute4.Z) <= BOUNDS_TOLERANCE;
                else
                    v20 = false;
                end;

                if v20 then
                    local maximum = result2.maximum;
                    local BOUNDS_TOLERANCE2 = Constants.BOUNDS_TOLERANCE;
                    local v21;

                    if math.abs(maximum.X - Attribute5.X) <= BOUNDS_TOLERANCE2 and math.abs(maximum.Y - Attribute5.Y) <= BOUNDS_TOLERANCE2 then
                        v21 = math.abs(maximum.Z - Attribute5.Z) <= BOUNDS_TOLERANCE2;
                    else
                        v21 = false;
                    end;

                    if v21 then
                        return nil;
                    end;
                end;

                return "StalePVSVisibilityGeometryBounds";
            end;
        end;
    end;

    return "InvalidPVSVisibilityExportManifest";
end;

function u1.new(p22: userdata, p23: userdata?) -- Line: 145
    -- upvalues: u1 (copy)
    local v24 = setmetatable({
        ExactGeometryDeclared = false,
        ExactGeometryComplete = false,
        MapRoot = p22,
        StorageRoot = p23 or p22
    }, u1);
    v24:Refresh();

    return v24;
end;

function u1.Refresh(p25) -- Line: 156
    -- upvalues: Workspace (copy), NEGATIVE_AUTHORITY (copy), GEOMETRY_VERSION (copy), validateLiveGeometryRecipe (copy), StaticOcclusionStorage (copy), StaticOcclusionRuntime (copy), StaticOcclusionCodec (copy), BarrierGeometry (copy)
    p25.Catalog = nil;
    p25.RaycastParams = nil;
    p25.Fingerprint = nil;
    p25.LoadError = nil;
    p25.StaticOcclusion = nil;
    p25.EncodedStaticOcclusion = nil;
    p25.EncodedProofs = nil;
    p25.ProofError = nil;
    p25.StaticOcclusionError = nil;
    p25.ExactGeometryDeclared = false;
    p25.ExactGeometryComplete = false;
    p25.ExactGeometryFingerprint = nil;
    p25.ExactGeometryError = nil;

    if p25.MapRoot ~= Workspace and not p25.MapRoot:IsDescendantOf(Workspace) then
        p25.LoadError = "MapNotInWorkspace";

        return false;
    end;

    local Attribute = p25.MapRoot:GetAttribute("PVSNegativeAuthority");
    local Attribute2 = p25.MapRoot:GetAttribute("PVSVisibilityGeometryVersion");
    local Attribute3 = p25.MapRoot:GetAttribute("PVSVisibilityGeometryComplete");
    local Attribute4 = p25.MapRoot:GetAttribute("PVSVisibilityGeometryFingerprint");
    p25.ExactGeometryDeclared = (Attribute ~= nil or (Attribute2 ~= nil or Attribute3 ~= nil)) and true or Attribute4 ~= nil;

    if p25.ExactGeometryDeclared then
        if Attribute == NEGATIVE_AUTHORITY then
            if Attribute2 == GEOMETRY_VERSION then
                if Attribute3 == true then
                    if typeof(Attribute4) == "string" and #Attribute4 ~= 0 then
                        p25.ExactGeometryFingerprint = Attribute4;
                    else
                        p25.ExactGeometryError = "MissingPVSVisibilityGeometryFingerprint";
                    end;
                else
                    p25.ExactGeometryError = "IncompletePVSVisibilityGeometry";
                end;
            else
                p25.ExactGeometryError = "UnsupportedPVSVisibilityGeometryVersion";
            end;
        else
            p25.ExactGeometryError = "UnsupportedPVSNegativeAuthority";
        end;
    end;

    if not p25.ExactGeometryDeclared then
        local v26, v27, v28 = pcall(BarrierGeometry.collect, p25.MapRoot);

        if v26 and v27 ~= nil then
            local Attribute5 = p25.MapRoot:GetAttribute("PVSBarrierFingerprint");

            if typeof(Attribute5) == "string" and v27.fingerprint ~= Attribute5 then
                p25.LoadError = "StaleBarrierGeometry";
            else
                p25.Catalog = v27;
            end;
        else
            p25.LoadError = v26 and (v28 or "MissingBarrierCatalog") or `BarrierCatalogError:{tostring(v27)}`;
        end;

        local Catalog = p25.Catalog;

        if Catalog == nil then
            return false;
        end;

        p25.RaycastParams = BarrierGeometry.buildRaycastParams(Catalog);
        p25.Fingerprint = Catalog.fingerprint;
        local v29, v30 = StaticOcclusionStorage.read(p25.StorageRoot, Catalog.fingerprint);

        if v29 == nil then
            p25.StaticOcclusionError = v30;
        else
            local success, result = pcall(StaticOcclusionRuntime.new, v29, Catalog.fingerprint);

            if success then
                p25.StaticOcclusion = result;
                p25.EncodedStaticOcclusion = v29;
            else
                p25.StaticOcclusionError = tostring(result);
            end;
        end;

        return true;
    end;

    local ExactGeometryFingerprint = p25.ExactGeometryFingerprint;

    if p25.ExactGeometryError ~= nil or ExactGeometryFingerprint == nil then
        p25.LoadError = p25.ExactGeometryError or "InvalidPVSVisibilityGeometryContract";
        p25.StaticOcclusionError = p25.LoadError;

        return false;
    end;

    local v31 = validateLiveGeometryRecipe(p25.MapRoot, ExactGeometryFingerprint);

    if v31 ~= nil then
        p25.LoadError = v31;
        p25.StaticOcclusionError = v31;
        p25.ExactGeometryError = v31;

        return false;
    end;

    local os_clock_ret = os.clock();

    local function startupCheckpoint() -- Line: 213
        -- upvalues: os_clock_ret (ref)
        if os.clock() - os_clock_ret >= 0.008 then
            task.wait();
            os_clock_ret = os.clock();
        end;
    end;

    local v32, v33 = StaticOcclusionStorage.read(p25.StorageRoot, ExactGeometryFingerprint, startupCheckpoint);

    if v32 == nil then
        p25.LoadError = v33 or "MissingExactPVSStaticOcclusion";
        p25.StaticOcclusionError = p25.LoadError;
        p25.ExactGeometryError = p25.LoadError;

        return false;
    end;

    local success, result = pcall(StaticOcclusionRuntime.new, v32, ExactGeometryFingerprint, startupCheckpoint);

    if not success then
        p25.LoadError = `ExactPVSStaticOcclusionError:{tostring(result)}`;
        p25.StaticOcclusionError = p25.LoadError;
        p25.ExactGeometryError = p25.LoadError;

        return false;
    end;

    local v34, v35 = StaticOcclusionCodec.validateExactGeometry(result.Data);

    if not v34 then
        p25.LoadError = v35 or "InvalidExactPVBVHProfile";
        p25.StaticOcclusionError = p25.LoadError;
        p25.ExactGeometryError = p25.LoadError;

        return false;
    end;

    p25.StaticOcclusion = result;
    p25.EncodedStaticOcclusion = v32;
    local v36, v37, v38 = pcall(StaticOcclusionStorage.readProofs, p25.StorageRoot, ExactGeometryFingerprint, startupCheckpoint);

    if not v36 then
        v38 = tostring(v37);
        v37 = nil;
    end;

    p25.ProofError = v38;

    if v37 ~= nil then
        local v39, v40 = result:InstallProofs(v37, startupCheckpoint);

        if v39 then
            p25.EncodedProofs = v37;
        else
            p25.ProofError = v40;
        end;
    end;

    p25.Fingerprint = ExactGeometryFingerprint;
    p25.ExactGeometryComplete = true;
    p25.LoadError = nil;

    return true;
end;

function u1.IsReady(p41) -- Line: 301
    return p41.ExactGeometryComplete or p41.RaycastParams ~= nil;
end;

function u1.GetLoadError(p42) -- Line: 305
    return p42.LoadError;
end;

function u1.GetFingerprint(p43) -- Line: 309
    return p43.Fingerprint;
end;

function u1.GetStaticOcclusion(p44) -- Line: 313
    return p44.StaticOcclusion;
end;

function u1.GetEncodedStaticOcclusion(p45) -- Line: 319
    return p45.EncodedStaticOcclusion;
end;

function u1.GetStaticOcclusionError(p46) -- Line: 323
    return p46.StaticOcclusionError;
end;

function u1.IsExactGeometryComplete(p47) -- Line: 327
    return p47.ExactGeometryComplete;
end;

function u1.RaycastSegment(p48: any, p49: vector, p50: vector) -- Line: 332
    -- upvalues: Workspace (copy)
    if p48.ExactGeometryDeclared then
        return nil, false;
    end;

    local RaycastParams = p48.RaycastParams;

    if RaycastParams ~= nil then
        local X = p49.X;
        local v51;

        if X == X and X > (-1 / 0) then
            v51 = X < (1 / 0);
        else
            v51 = false;
        end;

        if v51 then
            local Y = p49.Y;

            if Y == Y and Y > (-1 / 0) then
                v51 = Y < (1 / 0);
            else
                v51 = false;
            end;

            if v51 then
                local Z = p49.Z;

                if Z == Z and Z > (-1 / 0) then
                    v51 = Z < (1 / 0);
                else
                    v51 = false;
                end;
            end;
        end;

        if v51 then
            local X2 = p50.X;
            local v52;

            if X2 == X2 and X2 > (-1 / 0) then
                v52 = X2 < (1 / 0);
            else
                v52 = false;
            end;

            if v52 then
                local Y = p50.Y;

                if Y == Y and Y > (-1 / 0) then
                    v52 = Y < (1 / 0);
                else
                    v52 = false;
                end;

                if v52 then
                    local Z = p50.Z;

                    if Z == Z and Z > (-1 / 0) then
                        v52 = Z < (1 / 0);
                    else
                        v52 = false;
                    end;
                end;
            end;

            if v52 then
                local v53 = p50 - p49;

                if v53.Magnitude <= 0.001 then
                    return nil, true;
                end;

                local success, result = pcall(Workspace.Raycast, Workspace, p49, v53, RaycastParams);

                if success then
                    return result, true;
                end;

                return nil, false;
            end;
        end;
    end;

    return nil, false;
end;

function u1.SegmentBlocked(p54: any, p55: vector, p56: vector) -- Line: 358
    local X = p55.X;
    local v57;

    if X == X and X > (-1 / 0) then
        v57 = X < (1 / 0);
    else
        v57 = false;
    end;

    if v57 then
        local Y = p55.Y;

        if Y == Y and Y > (-1 / 0) then
            v57 = Y < (1 / 0);
        else
            v57 = false;
        end;

        if v57 then
            local Z = p55.Z;

            if Z == Z and Z > (-1 / 0) then
                v57 = Z < (1 / 0);
            else
                v57 = false;
            end;
        end;
    end;

    if v57 then
        local X2 = p56.X;
        local v58;

        if X2 == X2 and X2 > (-1 / 0) then
            v58 = X2 < (1 / 0);
        else
            v58 = false;
        end;

        if v58 then
            local Y = p56.Y;

            if Y == Y and Y > (-1 / 0) then
                v58 = Y < (1 / 0);
            else
                v58 = false;
            end;

            if v58 then
                local Z = p56.Z;

                if Z == Z and Z > (-1 / 0) then
                    v58 = Z < (1 / 0);
                else
                    v58 = false;
                end;
            end;
        end;

        if v58 then
            local StaticOcclusion = p54.StaticOcclusion;
            local Catalog = p54.Catalog;
            local v59 = false;

            if p54.ExactGeometryDeclared then
                if not p54.ExactGeometryComplete or StaticOcclusion == nil then
                    return false, false, nil, false, false;
                end;

                local success, result = pcall(StaticOcclusion.SegmentBlocked, StaticOcclusion, p55, p56, nil);

                if success then
                    return result == true, true, nil, true, false;
                end;

                return false, false, nil, true, false;
            end;

            if StaticOcclusion ~= nil and Catalog ~= nil then
                local v60, v61, v62 = pcall(StaticOcclusion.SegmentBlocked, StaticOcclusion, p55, p56, nil);

                if v60 and v61 == true then
                    local v63;

                    if typeof(v62) == "number" then
                        v63 = Catalog.parts[v62];
                    else
                        v63 = nil;
                    end;

                    return true, true, v63, true, false;
                end;

                v59 = true;
            end;

            local v64, v65 = p54:RaycastSegment(p55, p56);
            local v66;

            if v64 == nil or not v64.Instance:IsA("BasePart") then
                v66 = nil;
            else
                v66 = v64.Instance;
            end;

            local v67;

            if v65 then
                v67 = v64 ~= nil;
            else
                v67 = v65;
            end;

            return v67, v65, v66, v59, true;
        end;
    end;

    return false, false, nil, false, false;
end;

function u1.ClipOrigin(p68: any, p69: vector, p70: vector, p71: number?) -- Line: 394
    if p68.ExactGeometryDeclared then
        local StaticOcclusion = p68.StaticOcclusion;

        if p68.ExactGeometryComplete and StaticOcclusion ~= nil then
            local X = p69.X;
            local v72;

            if X == X and X > (-1 / 0) then
                v72 = X < (1 / 0);
            else
                v72 = false;
            end;

            if v72 then
                local Y = p69.Y;

                if Y == Y and Y > (-1 / 0) then
                    v72 = Y < (1 / 0);
                else
                    v72 = false;
                end;

                if v72 then
                    local Z = p69.Z;

                    if Z == Z and Z > (-1 / 0) then
                        v72 = Z < (1 / 0);
                    else
                        v72 = false;
                    end;
                end;
            end;

            if v72 then
                local X2 = p70.X;
                local v73;

                if X2 == X2 and X2 > (-1 / 0) then
                    v73 = X2 < (1 / 0);
                else
                    v73 = false;
                end;

                if v73 then
                    local Y = p70.Y;

                    if Y == Y and Y > (-1 / 0) then
                        v73 = Y < (1 / 0);
                    else
                        v73 = false;
                    end;

                    if v73 then
                        local Z = p70.Z;

                        if Z == Z and Z > (-1 / 0) then
                            v73 = Z < (1 / 0);
                        else
                            v73 = false;
                        end;
                    end;
                end;

                if v73 then
                    local v74 = p70 - p69;
                    local Magnitude = v74.Magnitude;

                    if Magnitude <= 0.001 then
                        return p70;
                    end;

                    local success, result = pcall(StaticOcclusion.NearestSegmentHit, StaticOcclusion, p69, p70);

                    if not success or result == nil then
                        return p70;
                    end;

                    local v75 = (math.ceil(result / 0.9999999 * 256) - 1) / 256;
                    local math_clamp_ret = math.clamp(v75, 0, 1);
                    local math_clamp_ret2 = math.clamp(p71 or 0.25, 0, 16);

                    return p69 + v74.Unit * math.max(Magnitude * math_clamp_ret - math_clamp_ret2, 0);
                end;
            end;
        end;

        return p70;
    end;

    local v76 = p70 - p69;

    if v76.Magnitude <= 0.001 then
        return p70;
    end;

    local v77, v78 = p68:SegmentBlocked(p69, p70);

    if not (v78 and v77) then
        return p70;
    end;

    local math_clamp_ret = math.clamp(p71 or 0.25, 0, 16);

    if math_clamp_ret > 0 then
        local v79, v80 = p68:RaycastSegment(p69, p70);

        if v80 and v79 ~= nil then
            return p69 + v76.Unit * math.max(v79.Distance - math_clamp_ret, 0);
        end;

        return p70;
    end;

    local v81 = p70;
    local v82 = p69;

    for i = 1, 8 do
        local v83 = (p69 + p70) * 0.5;
        local v84, v85 = p68:SegmentBlocked(v82, v83);

        if not v85 then
            return v81;
        end;

        local v86;

        if v84 then
            p70 = v83;
            v86 = i;
        else
            p69 = v83;
            v86 = i;
        end;
    end;

    return p69;
end;

return table.freeze(u1);