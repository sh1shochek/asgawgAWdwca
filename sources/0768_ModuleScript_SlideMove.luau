-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.ProvenTypes);
local ProvenMath = require(script.Parent.Parent.ProvenMath);
local Trace = require(script.Parent.Trace);
local TraceRules = require(script.Parent.TraceRules);
local v1 = {};
local line = Trace.line;
local vector = Trace.vector;
local magnitudeSq = ProvenMath.magnitudeSq;
local isPointTestBlocked = TraceRules.isPointTestBlocked;
local getTraceClipNormal = TraceRules.getTraceClipNormal;
local getWallConstraintNormal = TraceRules.getWallConstraintNormal;
local isDynamicWallContactRecord = TraceRules.isDynamicWallContactRecord;
local isFloorSupportTrace = TraceRules.isFloorSupportTrace;
local u2 = {
    ignoreDynamicPlayerAabbs = true
};

local function warmStartStaticWallContact(p3: vector, p4: vector, p5: vector?, p6: any, p7: any, p8: string) -- Line: 39
    -- upvalues: getWallConstraintNormal (copy), isDynamicWallContactRecord (copy), getTraceClipNormal (copy), ProvenMath (copy)
    if typeof(p5) ~= "Vector3" or p5.Magnitude <= 1e-6 then
        return p4, nil, nil;
    end;

    local v9 = getWallConstraintNormal(p5, p7);

    if v9.Magnitude <= 1e-6 or v9.Y >= p7.WalkableFloor then
        return p4, nil, nil;
    end;

    local Unit = v9.Unit;
    local v10 = p6:Sweep(p3, p3 - Unit * 0.005, p8);
    local v11 = nil;
    local v12 = nil;

    if v10.startSolid or v10.allSolid then
        v11 = "probeEmbedded";
    elseif v10.fraction >= 1 then
        v11 = "wallOutsideRetentionDistance";
    elseif v10.normal.Y >= p7.WalkableFloor then
        v11 = "walkableProbe";
    elseif isDynamicWallContactRecord(v10.hullRecord) then
        v11 = "dynamicWall";
    elseif v10.hullRecord.surfaceVelocity == nil or v10.hullRecord.surfaceVelocity.Magnitude <= p7.PositionSnapEpsilon then
        v12 = getWallConstraintNormal(getTraceClipNormal(v10, p7), p7);

        if v12.Magnitude <= 1e-6 then
            v11 = "invalidProbeNormal";
        else
            v12 = v12.Unit;

            if v12:Dot(Unit) < 0.995 then
                v11 = "wallNormalMismatch";
            end;
        end;
    else
        v11 = "movingWall";
    end;

    local v13;

    if v12 == nil then
        v13 = nil;
    else
        v13 = p4:Dot(v12);
    end;

    if (v11 == nil and (v13 ~= nil and p7.VelocityEpsilon < v13) and "clearlySeparating" or v11) == nil and (v12 ~= nil and v13 ~= nil) then
        return ProvenMath.clipVelocity(p4, v12, p7.Overbounce), v12, v10;
    end;

    return p4, nil, nil;
end;

local function constrainVelocityAgainstClipPlanes(p14: vector, p15: table, p16: number, p17: any) -- Line: 100
    -- upvalues: ProvenMath (copy)
    for i = 1, p16 do
        local v18 = ProvenMath.clipVelocity(p14, p15[i], p17.Overbounce);
        local v19 = i;
        local v20 = true;

        for i2 = 1, p16 do
            if i2 ~= v19 and v18:Dot(p15[i2]) < 0 then
                v20 = false;
                break;
            end;

            local _ = i2;
        end;

        if v20 then
            return v18;
        end;
    end;

    if p16 == 2 then
        local v21 = p15[1]:Cross(p15[2]);

        if v21.Magnitude > 0 then
            local Unit = v21.Unit;

            return Unit * p14:Dot(Unit);
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

local function isPlayerEscapePathClear(p22: vector, p23: vector, p24: string, p25: any, p26: any) -- Line: 134
    -- upvalues: u2 (copy), isPointTestBlocked (copy)
    if isPointTestBlocked((p25:Sweep(p22, p23, p24, u2))) then
        return false;
    end;

    return (p23.Y >= p22.Y - p26.PositionSnapEpsilon or not isPointTestBlocked((p25:FloorSupportSweep(p22, p23, p24, p26.WalkableFloor)))) and true or false;
end;

local function escapeOverlappingBrushes(p27: vector, p28: number, p29: vector, p30: string, p31: any) -- Line: 159
    -- upvalues: isPointTestBlocked (copy)
    for i = 1, 6 do
        if p29.Y < 0 then
            return nil;
        end;

        local _ = i;
        local v32 = nil;

        for i2 = 1, 32 do
            local v33 = p27 + p29 * (i2 * 0.02);
            local v34 = p31:PointTest(v33, p30);

            if not isPointTestBlocked(v34) then
                return v33;
            end;

            local hullRecord = v34.hullRecord;

            if hullRecord == nil or (hullRecord.buildMode == "dynamicPlayerAabb" or hullRecord.allowsPlayerDepenetration == false) then
                return nil;
            end;

            if hullRecord.sourceId ~= p28 then
                p28 = hullRecord.sourceId;

                if v34.normal.Magnitude > 1e-6 then
                    p29 = v34.normal.Unit;
                    v32 = v33;
                else
                    v32 = v33;
                    p29 = Vector3.new(0, 1, 0);
                end;

                break;
            end;

            local _ = i2;
        end;

        if v32 == nil then
            return nil;
        end;

        p27 = v32;
    end;

    return nil;
end;

v1.WALL_CONTACT_SEPARATION = 0.001;
v1.WALL_RECOVERY_SEPARATION = 0.02;

function v1.tryPlayerMove(p35: vector, p36: vector, p37: number, p38: any, p39: any, p40: string, p41: boolean?, p42: table?, p43: string?, p44: vector?) -- Line: 283
    -- upvalues: warmStartStaticWallContact (copy), vector (copy), line (copy), magnitudeSq (copy), isFloorSupportTrace (copy), getTraceClipNormal (copy), ProvenMath (copy), isPointTestBlocked (copy), constrainVelocityAgainstClipPlanes (copy)
    local v45 = false;
    local v46 = nil;
    local v47 = p42 or table.create(p39.MaxClipPlanes);
    table.clear(v47);
    local v48 = 0;
    local v49 = 0;
    local v50 = p39.PositionSnapEpsilon * p39.PositionSnapEpsilon;
    local v51, v52, v53 = warmStartStaticWallContact(p35, p36, p44, p38, p39, p40);
    vector("proven.tryPlayerMove.warmStart", p35, v51, 0, 0, line(1));
    local v54, v55, v56;

    if v52 == nil then
        v54 = p36;
        v55 = false;
        v53 = nil;
        v56 = nil;
    else
        v56 = v53;
        v54 = v51;
        p36 = v54;
        local v57 = v54;
        v54 = p36;
        v57 = p36;
        v55 = true;
    end;

    local v58 = 0;
    local v59 = 0;
    local v60 = 0;
    local v61;

    while true do
        if v58 >= 4 then
            v61 = v53;
            break;
        end;

        v58 = v58 + 1;

        if magnitudeSq(v51) <= v50 or p37 <= 0 then
            v61 = v53;
            break;
        end;

        local v62 = v51 * p37;

        if magnitudeSq(v62) <= v50 then
            v61 = v53;
            break;
        end;

        if p41 == true then
            v61 = p38:SweepWithFloorSupport(p35, p35 + v62, p40);
        else
            v61 = p38:Sweep(p35, p35 + v62, p40);
        end;

        if p41 == true and (isFloorSupportTrace(v61) and (v61.startSolid or v61.allSolid)) and v51:Dot(v61.normal) > p39.PositionSnapEpsilon then
            v61 = p38:Sweep(p35, p35 + v62, p40);
        end;

        if p43 ~= nil and (p43 == "ground" or v51.Y > p39.VelocityEpsilon) and (v61.fraction > 0.0001 and p38.CanonicalizeExpandedBlockCornerTrace ~= nil) then
            p38:CanonicalizeExpandedBlockCornerTrace(v61, v62, p40, p43);
        end;

        if v61.fraction > 0 and v61.fraction < 0.0001 then
            v61.fraction = 0;
        end;

        v49 = v49 + v61.fraction;
        vector("proven.tryPlayerMove.sweepResult", v61.endPos, v51, v61.fraction, v61.hullRecord == nil and 0 or (v61.hullRecord.sourceId or 0), line(1));

        if not v61.allSolid then
            if v61.fraction > 0 then
                p35 = v61.endPos;
                table.clear(v47);
                p36 = v51;
                v48 = 0;
            end;

            vector("proven.tryPlayerMove.positionAdvance", p35, v51, v61.fraction, 0, line(1));

            if v61.fraction >= 1 then
                v61 = v53;
            else
                v45 = true;
                p37 = math.max(0, p37 - p37 * v61.fraction);

                if v61.normal.Y < p39.WalkableFloor then
                    v56 = v61;
                    v55 = true;
                else
                    v46 = v61;
                end;

                local v63 = getTraceClipNormal(v61, p39);

                if magnitudeSq(v63) > v50 then
                    if v61.fraction == 0 and (not v61.startSolid and v61.normal.Y < p39.WalkableFloor) then
                        p35 = p35 + v63 * 0.001;
                    end;

                    if v61.fraction == 0 and (not v61.startSolid and v51:Dot(v63) >= -p39.VelocityEpsilon) then
                        v51 = ProvenMath.clipVelocity(v51, v63, p39.Overbounce);
                        vector("proven.tryPlayerMove.grazingClip", p35, v51, v61.fraction, 0, line(1));

                        if v59 < 2 then
                            v59 = v59 + 1;
                            v58 = v58 - 1;
                            p36 = v51;
                        else
                            p36 = v51;
                        end;
                    else
                        if p39.MaxClipPlanes <= v48 then
                            v51 = Vector3.new(0, 0, 0);
                            break;
                        end;

                        v48 = v48 + 1;
                        v47[v48] = v63;
                        v51 = constrainVelocityAgainstClipPlanes(p36, v47, v48, p39);
                        vector("proven.tryPlayerMove.clipPlanes", p35, v51, v61.fraction, v48, line(1));

                        if magnitudeSq(v51) <= v50 or v51:Dot(v54) <= 0 then
                            v51 = Vector3.new(0, 0, 0);
                            break;
                        end;
                    end;

                    v53 = v61;
                end;

                v51 = Vector3.new(0, 0, 0);
            end;

            break;
        end;

        if v61.normal.Y >= p39.WalkableFloor then
            v46 = v61;
            v61 = v56;

            return p35, Vector3.new(0, 0, 0), true, v55, v61, v61, v46;
        end;

        v55 = true;
        local v64 = getTraceClipNormal(v61, p39);
        local v65 = p35 + v64 * 0.02;
        v51 = ProvenMath.clipVelocity(v51, v64, p39.Overbounce);

        if (v60 >= 1 and "recoveryBudgetExhausted" or (magnitudeSq(v64) <= v50 and "invalidNormal" or (isPointTestBlocked(p38:PointTest(v65, p40)) and "queryPositionBlocked" or (magnitudeSq(v51) <= v50 and "recoveredVelocityTooSmall" or (v51:Dot(v54) <= 0 and "recoveredVelocityReversed" or nil))))) ~= nil then
            return p35, Vector3.new(0, 0, 0), true, v55, v61, v61, v46;
        end;

        v60 = v60 + 1;
        vector("proven.tryPlayerMove.allSolidRecovery", v65, v51, v61.fraction, 0, line(1));
        p36 = v51;
        v56 = v61;
        p35 = v65;
        v45 = true;
        v53 = v61;
    end;

    local v66 = v49 == 0 and Vector3.new(0, 0, 0) or v51;
    vector("proven.tryPlayerMove.final", p35, v66, v49, v48, line(1));

    return p35, v66, v45, v55, v61, v56, v46;
end;

function v1.escapeStartSolid(p67: vector, p68: string, p69: any) -- Line: 206
    -- upvalues: isPlayerEscapePathClear (copy), escapeOverlappingBrushes (copy)
    local v70 = p69:PointTest(p67, p68);

    if not (v70.startSolid or v70.allSolid) then
        return nil;
    end;

    local hullRecord = v70.hullRecord;

    if hullRecord ~= nil and hullRecord.allowsPlayerDepenetration == false then
        return nil;
    end;

    local normal = v70.normal;
    local v71 = normal.Magnitude <= 1e-6 and Vector3.new(0, 1, 0) or normal.Unit;
    local Config = p69.Config;
    local v72;

    if hullRecord == nil then
        v72 = false;
    else
        v72 = hullRecord.buildMode == "dynamicPlayerAabb";
    end;

    local v73;

    if hullRecord == nil then
        v73 = nil;
    else
        v73 = hullRecord.sourceId;
    end;

    local v74;

    if v72 then
        v74 = math.abs(v71.Y) < Config.WalkableFloor;
    else
        v74 = v72;
    end;

    local v75 = 0;

    for i = 1, 32 do
        local v76 = i * 0.02;
        local v77 = p67 + v71 * v76;
        local v78 = p69:PointTest(v77, p68);
        local v79 = not (v78.startSolid or v78.allSolid) and (not v72 or isPlayerEscapePathClear(p67, v77, p68, p69, Config));

        if v79 then
            if not v74 then
                return v77;
            end;

            while v76 - v75 > Config.PositionSnapEpsilon do
                local v80 = (v75 + v76) * 0.5;
                local v81 = p67 + v71 * v80;
                local v82 = p69:PointTest(v81, p68);
                local v83 = not (v82.startSolid or v82.allSolid) and isPlayerEscapePathClear(p67, v81, p68, p69, Config);

                if not v83 then
                    v81 = v77;
                    v75 = v80;
                    v80 = v76;
                end;

                v77 = v81;
                v76 = v80;
            end;

            return v77;
        end;

        v75 = v76;
        local _ = i;
    end;

    if v71.Y < 0.9 then
        for i = 1, 32 do
            local v84 = p67 + Vector3.new(0, i * 0.02, 0);
            local v85 = p69:PointTest(v84, p68);
            local v86 = not (v85.startSolid or v85.allSolid) and (not v72 or isPlayerEscapePathClear(p67, v84, p68, p69, Config));

            if v86 then
                return v84;
            end;

            local _ = i;
        end;
    end;

    if v72 or v73 == nil then
        return nil;
    end;

    return escapeOverlappingBrushes(p67, v73, v71, p68, p69);
end;

return table.freeze(v1);