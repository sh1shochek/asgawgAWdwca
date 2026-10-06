-- Decompiled with Potassium's decompiler.

local Config = require(script.Parent.Parent.Simulation.Config);
local v1 = {};

local function finitePositive(p2) -- Line: 38
    local v3;

    if typeof(p2) == "number" and (p2 == p2 and p2 > 0) then
        v3 = p2 < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

local function integerAtLeast(p4: any, p5: number) -- Line: 42
    local v6;

    if typeof(p4) == "number" and (p4 == p4 and p4 > 0) then
        v6 = p4 < (1 / 0);
    else
        v6 = false;
    end;

    if v6 then
        if p4 % 1 == 0 then
            v6 = p5 <= p4;
        else
            v6 = false;
        end;
    end;

    return v6;
end;

function v1.Resolve(p7: any, p8: table?) -- Line: 46
    -- upvalues: Config (copy)
    local v9 = p7 or Config.Default;
    local v10 = p8 or {};
    local v11 = v10.CellSize or 8;
    local v12 = v10.MaxCellsPerRecord or 4096;
    local v13 = v10.MaxSweepDistance or 1000;
    local v14;

    if typeof(v11) == "number" and (v11 == v11 and v11 > 0) then
        v14 = v11 < (1 / 0);
    else
        v14 = false;
    end;

    assert(v14, "collision cell size must be positive");
    local v15;

    if typeof(v12) == "number" and (v12 == v12 and v12 > 0) then
        v15 = v12 < (1 / 0);
    else
        v15 = false;
    end;

    if v15 then
        if v12 % 1 == 0 then
            v15 = v12 >= 1;
        else
            v15 = false;
        end;
    end;

    assert(v15, "max cells per collision record must be a positive integer");
    local v16;

    if typeof(v13) == "number" and (v13 == v13 and v13 > 0) then
        v16 = v13 < (1 / 0);
    else
        v16 = false;
    end;

    assert(v16, "maximum collision sweep distance must be positive");
    local v17;

    if v9.PlayerSizeStanding.X > 0 and v9.PlayerSizeStanding.Y > 0 then
        v17 = v9.PlayerSizeStanding.Z > 0;
    else
        v17 = false;
    end;

    assert(v17);
    local v18;

    if v9.PlayerSizeDucking.X > 0 and v9.PlayerSizeDucking.Y > 0 then
        v18 = v9.PlayerSizeDucking.Z > 0;
    else
        v18 = false;
    end;

    assert(v18);
    assert(v9.PlayerSizeDucking.Y <= v9.PlayerSizeStanding.Y, "ducking collision height cannot exceed standing height");
    local v19;

    if v9.WalkableFloor > 0 then
        v19 = v9.WalkableFloor <= 1;
    else
        v19 = false;
    end;

    assert(v19, "walkable-floor normal threshold must be in (0, 1]");
    local GroundProbeStartBump = v9.GroundProbeStartBump;
    local v20;

    if typeof(GroundProbeStartBump) == "number" and (GroundProbeStartBump == GroundProbeStartBump and GroundProbeStartBump > 0) then
        v20 = GroundProbeStartBump < (1 / 0);
    else
        v20 = false;
    end;

    if v20 then
        v20 = v9.GroundProbeStartBump < v13;
    end;

    assert(v20, "ground-probe start bump must be positive and below the maximum sweep distance");
    assert(v9.SurfaceFrictionDefault >= 0, "default surface friction cannot be negative");

    return table.freeze({
        PlaneNormalEpsilon = 0.001,
        PlaneDuplicateDot = 0.9999999,
        ContactEpsilon = 0.0001,
        BroadphasePadding = 0.1,
        FloorContactEpsilon = 0.02,
        FloorSupportContactEpsilon = 0.001,
        FloorTriangleEdgeSlop = 0.06,
        WalkmeshBoundsPadding = 0.05,
        StandingHalfSize = v9.PlayerSizeStanding * 0.5,
        DuckingHalfSize = v9.PlayerSizeDucking * 0.5,
        CellSize = v11,
        MaxCellsPerRecord = v12,
        MaxSweepDistance = v13,
        HitTieDistance = 0.03125 * v9.HammerUnitToStud,
        BrushEpsilon = 0.03125 * v9.HammerUnitToStud,
        SupportEdgeOwnershipTolerance = 0.0625 * v9.HammerUnitToStud,
        FloorStartSolidRecoveryDepth = math.max(0.05, v9.MaxStepHeight + 0.02),
        GroundProbeStartBump = v9.GroundProbeStartBump,
        WalkableFloor = v9.WalkableFloor,
        SurfaceFriction = v9.SurfaceFrictionDefault
    });
end;

v1.Default = v1.Resolve();

return table.freeze(v1);