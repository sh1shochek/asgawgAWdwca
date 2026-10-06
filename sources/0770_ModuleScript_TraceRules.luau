-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.ProvenTypes);
local v1 = {
    GROUND_PROBE_START_BUMP = 0.03
};

local function getWallClipNormal(p2: vector, p3: any) -- Line: 24
    if p2.Y >= p3.WalkableFloor then
        return p2;
    end;

    if math.abs(p2.Y) > 0.0001 then
        return p2;
    end;

    local Vector3_new_ret = Vector3.new(p2.X, 0, p2.Z);

    if Vector3_new_ret.Magnitude <= 1e-6 then
        return p2;
    end;

    return Vector3_new_ret.Unit;
end;

local function getTraceCylinderAxis(p4) -- Line: 40
    if p4 then
        p4 = p4.hullRecord;
    end;

    if not p4 or p4.sourceShape ~= "Cylinder" then
        return nil;
    end;

    local sourceCFrame = p4.sourceCFrame;

    if typeof(sourceCFrame) == "CFrame" then
        return sourceCFrame.RightVector;
    end;

    return nil;
end;

local function isCylinderWalkableGroundTrace(p5, p6) -- Line: 151
    if not (p5 and (p5.fraction < 1 and p5.normal.Y >= p6.WalkableFloor)) then
        return false;
    end;

    local hullRecord = p5.hullRecord;

    if hullRecord == nil or hullRecord.sourceShape ~= "Cylinder" then
        return true;
    end;

    local v7;

    if p5 then
        v7 = p5.hullRecord;
    else
        v7 = p5;
    end;

    local v8;

    if v7 and v7.sourceShape == "Cylinder" then
        local sourceCFrame = v7.sourceCFrame;

        if typeof(sourceCFrame) == "CFrame" then
            v8 = sourceCFrame.RightVector;
        else
            v8 = nil;
        end;
    else
        v8 = nil;
    end;

    if v8 == nil or v8.Magnitude <= 1e-6 then
        return false;
    end;

    local Unit = v8.Unit;

    if math.abs(Unit.Y) < p6.WalkableFloor then
        return true;
    end;

    local v9 = p5.normal:Dot(Unit);

    return math.abs(v9) >= 0.85;
end;

function v1.getTraceNormalY(p10: any, p11: number) -- Line: 14
    if p10 == nil then
        return p11;
    end;

    return p10.normal.Y;
end;

function v1.isPointTestBlocked(p12) -- Line: 19
    return p12.startSolid or p12.allSolid or p12.fraction ~= 1;
end;

function v1.getTraceClipNormal(p13, p14) -- Line: 52
    local normal = p13.normal;

    if normal.Y < p14.WalkableFloor then
        if normal.Y >= p14.WalkableFloor then
            return normal;
        end;

        if math.abs(normal.Y) > 0.0001 then
            return normal;
        end;

        local Vector3_new_ret = Vector3.new(normal.X, 0, normal.Z);

        if Vector3_new_ret.Magnitude <= 1e-6 then
            return normal;
        end;

        normal = Vector3_new_ret.Unit;
    end;

    return normal;
end;

function v1.getWallConstraintNormal(p15: vector, p16: any) -- Line: 61
    if p15.Y < p16.WalkableFloor then
        if p15.Y >= p16.WalkableFloor then
            return p15;
        end;

        if math.abs(p15.Y) > 0.0001 then
            return p15;
        end;

        local Vector3_new_ret = Vector3.new(p15.X, 0, p15.Z);

        if Vector3_new_ret.Magnitude <= 1e-6 then
            return p15;
        end;

        p15 = Vector3_new_ret.Unit;
    end;

    return p15;
end;

function v1.getTraceSurfaceVelocity(p17) -- Line: 70
    local hullRecord = p17.hullRecord;

    return not hullRecord and Vector3.new(0, 0, 0) or hullRecord.surfaceVelocity;
end;

function v1.getTraceSurfaceFriction(p18, p19) -- Line: 75
    local hullRecord = p18.hullRecord;

    if hullRecord then
        return hullRecord.surfaceFriction;
    end;

    return p19.SurfaceFrictionDefault;
end;

function v1.getImpactWallConstraintNormal(p20, p21) -- Line: 80
    if not p20 or p20.normal.Y >= p21.WalkableFloor then
        return Vector3.new(0, 0, 0);
    end;

    local normal = p20.normal;

    if normal.Y < p21.WalkableFloor and (normal.Y < p21.WalkableFloor and math.abs(normal.Y) <= 0.0001) then
        local Vector3_new_ret = Vector3.new(normal.X, 0, normal.Z);

        if Vector3_new_ret.Magnitude > 1e-6 then
            normal = Vector3_new_ret.Unit;
        end;
    end;

    if normal.Y < p21.WalkableFloor then
        if normal.Y >= p21.WalkableFloor then
            return normal;
        end;

        if math.abs(normal.Y) > 0.0001 then
            return normal;
        end;

        local Vector3_new_ret = Vector3.new(normal.X, 0, normal.Z);

        if Vector3_new_ret.Magnitude <= 1e-6 then
            return normal;
        end;

        normal = Vector3_new_ret.Unit;
    end;

    return normal;
end;

function v1.isDynamicWallContactRecord(p22) -- Line: 88
    if p22 == nil then
        return true;
    end;

    local buildMode = p22.buildMode;
    local v23;

    if typeof(buildMode) == "string" then
        v23 = string.sub(buildMode, 1, 7) == "dynamic";
    else
        v23 = false;
    end;

    return v23;
end;

function v1.isFloorSupportTrace(p24) -- Line: 96
    if p24 then
        p24 = p24.hullRecord;
    end;

    if not p24 then
        return false;
    end;

    if p24.isFloorSupport == true then
        return true;
    end;

    local buildMode = p24.buildMode;

    return (buildMode == "floorGridCell" or (buildMode == "floorGridPatch" or buildMode == "walkMeshTriangle")) and true or buildMode == "walkMeshCell";
end;

function v1.isDynamicPlayerSupportTrace(p25) -- Line: 113
    local v26;

    if p25 == nil then
        v26 = nil;
    else
        v26 = p25.hullRecord;
    end;

    local v27;

    if v26 == nil then
        v27 = false;
    else
        v27 = v26.buildMode == "dynamicPlayerAabb";
    end;

    return v27;
end;

function v1.isRecoverableFloorSupportTrace(p28: any, p29: any, p30: number) -- Line: 118
    local v31;

    if p28 then
        v31 = p28.hullRecord;
    else
        v31 = p28;
    end;

    local v32;

    if v31 then
        if v31.isFloorSupport == true then
            v32 = true;
        else
            local buildMode = v31.buildMode;
            v32 = (buildMode == "floorGridCell" or (buildMode == "floorGridPatch" or buildMode == "walkMeshTriangle")) and true or buildMode == "walkMeshCell";
        end;
    else
        v32 = false;
    end;

    if not v32 or p28.normal.Y < p29.WalkableFloor then
        return false;
    end;

    local floorPenetrationDepth = p28.floorPenetrationDepth;

    if typeof(floorPenetrationDepth) == "number" then
        return floorPenetrationDepth <= p30;
    end;

    return false;
end;

function v1.getResolvedSupportPosition(p33: any, p34: vector) -- Line: 135
    if not p33 then
        return p34;
    end;

    local v35;

    if p33 then
        v35 = p33.hullRecord;
    else
        v35 = p33;
    end;

    local v36;

    if v35 then
        if v35.isFloorSupport == true then
            v36 = true;
        else
            local buildMode = v35.buildMode;
            v36 = (buildMode == "floorGridCell" or (buildMode == "floorGridPatch" or buildMode == "walkMeshTriangle")) and true or buildMode == "walkMeshCell";
        end;
    else
        v36 = false;
    end;

    if v36 then
        return p33.endPos;
    end;

    if p33.startSolid or p33.allSolid then
        return p34;
    end;

    return p33.endPos;
end;

function v1.isWalkableGround(p37, p38) -- Line: 175
    -- upvalues: isCylinderWalkableGroundTrace (copy)
    return isCylinderWalkableGroundTrace(p37, p38);
end;

function v1.getTraceGroundNormal(p39) -- Line: 180
    if p39 == nil or p39.normal.Magnitude <= 1e-6 then
        return nil;
    end;

    return p39.normal;
end;

function v1.getTraceMinkowskiPlaneKind(p40) -- Line: 189
    if p40 == nil then
        return nil;
    end;

    return p40.minkowskiPlaneKind;
end;

function v1.isRampPrimitiveHullRecord(p41) -- Line: 193
    local v42;

    if p41 == nil then
        v42 = false;
    else
        v42 = p41.buildMode == "primitiveLocalHullPlanes" and (p41.sourceShape == "Wedge" or p41.sourceShape == "CornerWedge") and true or p41.buildMode == "authoredHullPlanes";
    end;

    return v42;
end;

function v1.getLandingSnapDistance(p43: vector, p44: any) -- Line: 204
    if not p44 then
        return (1 / 0);
    end;

    local v45 = p43 - p44.endPos;
    local v46;

    if p44 == nil or p44.normal.Magnitude <= 1e-6 then
        v46 = nil;
    else
        v46 = p44.normal;
    end;

    if v46 then
        return math.max(0, v45:Dot(v46.Unit));
    end;

    return math.max(0, v45.Y);
end;

function v1.shouldRejectAirLanding(p47: vector, p48: vector?, p49: number, p50: number, p51: number) -- Line: 219
    if not p48 or p48.Magnitude <= 1e-6 then
        return p51 < p47.Y;
    end;

    local v52 = p47:Dot(p48.Unit);

    if p49 <= p50 then
        return p51 < v52;
    end;

    return -p51 < v52;
end;

function v1.supportTraceMatchesPosition(p53: any, p54: vector, p55: any) -- Line: 238
    -- upvalues: isCylinderWalkableGroundTrace (copy)
    if not isCylinderWalkableGroundTrace(p53, p55) then
        return false;
    end;

    local v56;

    if p53 then
        local v57;

        if p53 then
            v57 = p53.hullRecord;
        else
            v57 = p53;
        end;

        local v58;

        if v57 then
            if v57.isFloorSupport == true then
                v58 = true;
            else
                local buildMode = v57.buildMode;
                v58 = (buildMode == "floorGridCell" or (buildMode == "floorGridPatch" or buildMode == "walkMeshTriangle")) and true or buildMode == "walkMeshCell";
            end;
        else
            v58 = false;
        end;

        if v58 then
            v56 = p53.endPos;
        elseif p53.startSolid or p53.allSolid then
            v56 = p54;
        else
            v56 = p53.endPos;
        end;
    else
        v56 = p54;
    end;

    local v59 = v56.X - p54.X;
    local v60 = v56.Y - p54.Y;
    local v61 = v56.Z - p54.Z;

    return p55.PositionSnapEpsilon * p55.PositionSnapEpsilon >= v59 * v59 + v60 * v60 + v61 * v61;
end;

return table.freeze(v1);