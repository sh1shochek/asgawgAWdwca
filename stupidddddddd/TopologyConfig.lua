-- ReplicatedStorage.MovementV2.Collision.TopologyConfig
-- Script path: ReplicatedStorage.MovementV2.Collision.TopologyConfig
-- Decompile time: 1.52 ms

local Config = require(script.Parent.Parent.Simulation.Config)
local v1 = {}

local function finitePositive(a1) -- Line: 38
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 > 0 then
                v1 = a1 < (1 / 0)
            end
        end
    end
    return v1
end

local function integerAtLeast(a1, a2) -- Line: 42 -- types: a2: number
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 > 0 then
                v1 = a1 < (1 / 0)
            end
        end
    end
    if v1 then
        v1 = false
        if a1 % 1 == 0 then
            v1 = a2 <= a1
        end
    end
    return v1
end

function v1.Resolve(a1, a2) -- Line: 46 -- upvalues: Config (val) -- types: a2: table?
    local Default = a1 or Config.Default
    local v1 = a2 or {}
    local v2 = v1.CellSize or 8
    local v3 = v1.MaxCellsPerRecord or 4096
    local v4 = v1.MaxSweepDistance or 1000
    local v5 = false
    if typeof(v2) == "number" then
        v5 = false
        if v2 == v2 then
            v5 = false
            if v2 > 0 then
                v5 = v2 < (1 / 0)
            end
        end
    end
    assert(v5, "collision cell size must be positive")
    v5 = false
    if typeof(v3) == "number" then
        v5 = false
        if v3 == v3 then
            v5 = false
            if v3 > 0 then
                v5 = v3 < (1 / 0)
            end
        end
    end
    if v5 then
        v5 = false
        if v3 % 1 == 0 then
            v5 = v3 >= 1
        end
    end
    assert(v5, "max cells per collision record must be a positive integer")
    v5 = false
    if typeof(v4) == "number" then
        v5 = false
        if v4 == v4 then
            v5 = false
            if v4 > 0 then
                v5 = v4 < (1 / 0)
            end
        end
    end
    assert(v5, "maximum collision sweep distance must be positive")
    v5 = false
    if 0 < Default.PlayerSizeStanding.X then
        v5 = false
        if 0 < Default.PlayerSizeStanding.Y then
            v5 = 0 < Default.PlayerSizeStanding.Z
        end
    end
    assert(v5)
    v5 = false
    if 0 < Default.PlayerSizeDucking.X then
        v5 = false
        if 0 < Default.PlayerSizeDucking.Y then
            v5 = 0 < Default.PlayerSizeDucking.Z
        end
    end
    assert(v5)
    assert(Default.PlayerSizeDucking.Y <= Default.PlayerSizeStanding.Y, "ducking collision height cannot exceed standing height")
    v5 = false
    if 0 < Default.WalkableFloor then
        v5 = Default.WalkableFloor <= 1
    end
    assert(v5, "walkable-floor normal threshold must be in (0, 1]")
    local GroundProbeStartBump = Default.GroundProbeStartBump
    v5 = false
    if typeof(GroundProbeStartBump) == "number" then
        v5 = false
        if GroundProbeStartBump == GroundProbeStartBump then
            v5 = false
            if GroundProbeStartBump > 0 then
                v5 = GroundProbeStartBump < (1 / 0)
            end
        end
    end
    if v5 then
        v5 = Default.GroundProbeStartBump < v4
    end
    assert(v5, "ground-probe start bump must be positive and below the maximum sweep distance")
    assert(0 <= Default.SurfaceFrictionDefault, "default surface friction cannot be negative")
    return (table.freeze({
        PlaneNormalEpsilon = 0.001,
        PlaneDuplicateDot = 0.9999999,
        ContactEpsilon = 0.0001,
        BroadphasePadding = 0.1,
        FloorContactEpsilon = 0.02,
        FloorSupportContactEpsilon = 0.001,
        FloorTriangleEdgeSlop = 0.06,
        WalkmeshBoundsPadding = 0.05,
        StandingHalfSize = Default.PlayerSizeStanding * 0.5,
        DuckingHalfSize = Default.PlayerSizeDucking * 0.5,
        CellSize = v2,
        MaxCellsPerRecord = v3,
        MaxSweepDistance = v4,
        HitTieDistance = 0.03125 * Default.HammerUnitToStud,
        BrushEpsilon = 0.03125 * Default.HammerUnitToStud,
        SupportEdgeOwnershipTolerance = 0.0625 * Default.HammerUnitToStud,
        FloorStartSolidRecoveryDepth = math.max(0.05, Default.MaxStepHeight + 0.02),
        GroundProbeStartBump = Default.GroundProbeStartBump,
        WalkableFloor = Default.WalkableFloor,
        SurfaceFriction = Default.SurfaceFrictionDefault,
    }))
end

v1.Default = v1.Resolve()
return table.freeze(v1)