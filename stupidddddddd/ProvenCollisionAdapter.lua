-- ReplicatedStorage.MovementV2.Simulation.ProvenCollisionAdapter
-- Script path: ReplicatedStorage.MovementV2.Simulation.ProvenCollisionAdapter
-- Decompile time: 7.72 ms

local Enums = require(script.Parent.Parent.Enums)
require(script.Parent.Parent.Types)
require(script.Parent.PlayerHullClearance)
local DeterminismTrace = require(script.Parent.DeterminismTrace)
local u22 = {}
u22.__index = u22

local function currentStance(a1) -- Line: 13 -- types: a1: string
    if a1 == "crouching" then
        return "Ducking"
    end
    return "Standing"
end

local function newTrace(a1) -- Line: 18
    local TracePool = a1.TracePool
    if TracePool == nil then
        return {}
    end
    local v1 = a1.TracesUsed + 1
    a1.TracesUsed = v1
    local v2 = TracePool[v1]
    if v2 == nil then
        TracePool[v1] = {}
    end
    return v2
end

local function newRecord(a1) -- Line: 33
    local RecordPool = a1.RecordPool
    if RecordPool == nil then
        return {}
    end
    local v1 = a1.RecordsUsed + 1
    a1.RecordsUsed = v1
    local v2 = RecordPool[v1]
    if v2 == nil then
        RecordPool[v1] = {}
    end
    return v2
end

local function writeTrace(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) -- Line: 48
    -- upvalues: 
    a1.fraction = a2
    a1.endPos = a3
    a1.normal = a4
    a1.startSolid = a5
    a1.allSolid = a6
    a1.planeNum = a7
    a1.minkowskiPlaneKind = a8
    a1.hullRecord = a9
    a1.floorPenetrationDepth = a10
    return a1
end

local function emptyTrace(a1, a2) -- Line: 67 -- upvalues: newTrace (val) -- types: a2: vector
    local v1 = newTrace(a1)
    v1.fraction = 1
    v1.endPos = a2
    v1.normal = Vector3.new(0, 0, 0)
    v1.startSolid = false
    v1.allSolid = false
    v1.planeNum = nil
    v1.minkowskiPlaneKind = nil
    v1.hullRecord = nil
    v1.floorPenetrationDepth = nil
    return v1
end

local function minkowskiPlaneKind(a1) -- Line: 71
    if a1.MinkowskiPlaneKind ~= nil then
        return a1.MinkowskiPlaneKind
    end
    if a1.Planes ~= nil and a1.PlaneId ~= nil then
        for i, j in a1.Planes do
            if j.PlaneId == a1.PlaneId then
                return j.MinkowskiPlaneKind
            end
        end
        return nil
    end
    return nil
end

local function hullRecord(a1, a2, a3, a4) -- Line: 87
    -- upvalues: newRecord (val), Enums (val)
    if a2.SourceId == nil then
        return nil
    end
    local RecordType = a2.RecordType
    local Kind = a2.Kind
    local v1 = newRecord(a1)
    v1.sourceId = a2.SourceId
    v1.kind = Kind
    v1.sourceShape = a2.SourceShape
    local BuildMode = a2.BuildMode or (if RecordType ~= "Walkmesh" then if Kind ~= Enums.SupportKind.Mover then if Kind ~= Enums.SupportKind.Player then nil else "dynamicPlayerAabb" else "dynamicMoverObb" else "walkMeshTriangle")
    v1.buildMode = BuildMode
    v1.climbable = a2.Climbable == true
    v1.sourceCFrame = a2.SourceCFrame
    v1.sourceSize = a2.SourceSize
    v1.surfaceVelocity = a3 or Vector3.new(0, 0, 0)
    v1.surfaceFriction = a2.SurfaceFriction or 1
    v1.supportAnchor = a4
    local v2 = true
    if RecordType ~= "Walkmesh" then
        v2 = Kind == Enums.SupportKind.Walkmesh
    end
    v1.isFloorSupport = v2
    v1.allowsPlayerDepenetration = Kind ~= Enums.SupportKind.Mover
    return v1
end

local function fromSweep(a1, a2, a3, a4) -- Line: 114
    -- upvalues: newTrace (val), minkowskiPlaneKind (val), hullRecord (val)
    local v1
    if 1 <= a4.Fraction and not a4.StartSolid and not a4.AllSolid then
        v1 = newTrace(a1)
        v1.fraction = 1
        v1.endPos = a3
        v1.normal = Vector3.new(0, 0, 0)
        v1.startSolid = false
        v1.allSolid = false
        v1.planeNum = nil
        v1.minkowskiPlaneKind = nil
        v1.hullRecord = nil
        v1.floorPenetrationDepth = nil
        return v1
    end
    v1 = math.clamp(a4.Fraction, 0, 1)
    local ResolvedPosition = a4.ResolvedPosition
    local v2 = if typeof(ResolvedPosition) ~= "Vector3" then a2:Lerp(a3, v1) else ResolvedPosition
    local v3 = minkowskiPlaneKind(a4)
    local v4 = hullRecord(a1, a4, a4.SurfaceVelocity, nil)
    local v5 = newTrace(a1)
    local Normal = a4.Normal
    local StartSolid = a4.StartSolid
    local AllSolid = a4.AllSolid
    local PlaneId = a4.PlaneId
    local PenetrationDepth = a4.PenetrationDepth
    v5.fraction = v1
    v5.endPos = v2
    v5.normal = Normal
    v5.startSolid = StartSolid
    v5.allSolid = AllSolid
    v5.planeNum = PlaneId
    v5.minkowskiPlaneKind = v3
    v5.hullRecord = v4
    v5.floorPenetrationDepth = PenetrationDepth
    return v5
end

local u31 = {}

local function fromGround(a1, a2, a3, a4) -- Line: 142
    -- upvalues: newTrace (val), u31 (val), Enums (val), hullRecord (val)
    local v1
    if a4 == nil then
        v1 = newTrace(a1)
        v1.fraction = 1
        v1.endPos = a3
        v1.normal = Vector3.new(0, 0, 0)
        v1.startSolid = false
        v1.allSolid = false
        v1.planeNum = nil
        v1.minkowskiPlaneKind = nil
        v1.hullRecord = nil
        v1.floorPenetrationDepth = nil
        return v1
    end
    v1 = a3 - a2
    local v2 = v1:Dot(v1)
    local v3 = if not (v2 > 1e-12) then 0 else math.clamp((a4.Position - a2):Dot(v1) / v2, 0, 0.999999)
    local Support = a4.Support
    local v4 = u31
    table.clear(v4)
    v4.SourceId = Support.SourceId
    v4.Kind = Support.Kind
    v4.RecordType = if Support.Kind ~= Enums.SupportKind.Walkmesh then "Hull" else "Walkmesh"
    v4.BuildMode = if Support.Kind ~= Enums.SupportKind.Walkmesh then if Support.Kind ~= Enums.SupportKind.Mover then if Support.Kind ~= Enums.SupportKind.Player then nil else "dynamicPlayerAabb" else "dynamicMoverObb" else "walkMeshTriangle"
    v4.SurfaceFriction = a4.SurfaceFriction
    local v5 = hullRecord(a1, v4, Support.Velocity, Support.Anchor)
    local v6 = newTrace(a1)
    local Position = a4.Position
    local Normal = a4.Normal
    v6.fraction = v3
    v6.endPos = Position
    v6.normal = Normal
    v6.startSolid = false
    v6.allSolid = false
    v6.planeNum = nil
    v6.minkowskiPlaneKind = nil
    v6.hullRecord = v5
    v6.floorPenetrationDepth = nil
    return v6
end

local function groundQuery(a1, a2, a3, a4, a5) -- Line: 167
    -- upvalues: fromGround (val), DeterminismTrace (val)
    local v1
    local v2 = a2 - Vector3.new(0, a1.Config.GroundProbeStartBump or 0.03, 0)
    local v3 = math.max(0, v2.Y - a3.Y)
    local GroundBases = a1.GroundBases
    if GroundBases == nil then
        a1.GroundBases = {}
        a1.GroundDistances = {}
        a1.GroundStances = {}
        a1.GroundRecoveries = {}
        a1.GroundResults = {}
        a1.GroundCount = 0
    end
    local GroundDistances = a1.GroundDistances
    local GroundStances = a1.GroundStances
    local GroundRecoveries = a1.GroundRecoveries
    local GroundResults = a1.GroundResults
    local v4 = if a4 ~= "crouching" then "Standing" else "Ducking"
    local v5 = nil
    local v6 = false
    local GroundCount = a1.GroundCount
    local v7, v8, v9, v10 = a5, a1, a2, a3
    for i = 1, GroundCount do
        if GroundBases[i] == v2
            and GroundDistances[i] == v3
            and GroundStances[i] == v4
            and GroundRecoveries[i] == v7 then
            v5 = GroundResults[i]
            v6 = true
            break
        end
    end
    if not v6 then
        v5 = v8.Query:FindGround(v2, v4, v3, 1, if not v7 then nil else v8.RecoverySupport)
        v1 = v8.GroundCount + 1
        v8.GroundCount = v1
        GroundBases[v1] = v2
        GroundDistances[v1] = v3
        GroundStances[v1] = v4
        GroundRecoveries[v1] = v7
        GroundResults[v1] = v5
    end
    if v9.X ~= v9.X or v9.Y ~= v9.Y or v9.Z ~= v9.Z or v10.X ~= v10.X or v10.Y ~= v10.Y or v10.Z ~= v10.Z then
        error(string.format("proven simulator issued a non-finite ground query: %s -> %s", tostring(v9), (tostring(v10))), 2)
    end
    v1 = fromGround(v8, v9, v10, v5)
    DeterminismTrace.collision(v8.Trace, "collision.findGround", v9, v10, v1, 3)
    return v1
end

local function retainedPlayerGroundQuery(a1, a2, a3, a4) -- Line: 238
    -- upvalues: fromGround (val), DeterminismTrace (val)
    local FindPlayerGround = a1.Query.FindPlayerGround
    if FindPlayerGround == nil then
        return nil
    end
    local v1 = a2 - Vector3.new(0, a1.Config.GroundProbeStartBump or 0.03, 0)
    local v2 = math.max(0, v1.Y - a3.Y)
    local v3 = FindPlayerGround(a1.Query, v1, if a4 ~= "crouching" then "Standing" else "Ducking", v2)
    if v3 == nil then
        return nil
    end
    local v4 = fromGround(a1, a2, a3, v3)
    DeterminismTrace.collision(a1.Trace, "collision.findPlayerGround", a2, a3, v4, 3)
    return v4
end

function u22.new(a1, a2, a3, a4, a5, a6) -- Line: 255 -- upvalues: u22 (val) -- types: a5: vector?
    return (setmetatable({
        Query = a1,
        Config = a2,
        RecoverySupport = a3,
        Trace = a4,
        RetainedGroundSurfaceVelocity = a5,
        PlayerStanceProbe = a6,
    }, u22))
end

local u36 = nil

function u22.acquire(a1, a2, a3, a4, a5, a6) -- Line: 276 -- upvalues: u22 (val), u36 (ref) -- types: a5: vector?
    if a4 ~= nil then
        return u22.new(a1, a2, a3, a4, a5, a6)
    end
    local v1 = u36
    if v1 == nil then
        v1 = u22.new(a1, a2, a3, nil, a5, a6)
        v1.TracePool = {}
        v1.RecordPool = {}
        u36 = v1
    end
    v1.Query = a1
    v1.Config = a2
    v1.RecoverySupport = a3
    v1.Trace = nil
    v1.RetainedGroundSurfaceVelocity = a5
    v1.PlayerStanceProbe = a6
    v1.TracesUsed = 0
    v1.RecordsUsed = 0
    v1.SweepCount = 0
    v1.GroundCount = 0
    return v1
end

function u22.GetRetainedGroundSurfaceVelocity(a1) -- Line: 315
    return a1.RetainedGroundSurfaceVelocity
end

function u22.ResolveGroundTrace(a1, a2, a3) -- Line: 320 -- upvalues: Enums (val) -- types: a1: table, a3: vector
    local hullRecord = if a2 ~= nil then a2.hullRecord else nil
    if hullRecord ~= nil and typeof(hullRecord.kind) == "number" and typeof(hullRecord.sourceId) == "number" then
        if hullRecord.kind ~= Enums.SupportKind.None and hullRecord.sourceId ~= 0 then
            local supportAnchor = hullRecord.supportAnchor
            if typeof(supportAnchor) ~= "Vector3" then
                supportAnchor = if hullRecord.kind ~= Enums.SupportKind.Mover then a3 else if typeof(hullRecord.sourceCFrame) ~= "CFrame" then a3 else hullRecord.sourceCFrame:PointToObjectSpace(a3)
            end
            local surfaceVelocity_2 = if typeof(hullRecord.surfaceVelocity) ~= "Vector3" then Vector3.new(0, 0, 0) else hullRecord.surfaceVelocity
            local v1 = {Position = a3, Normal = a2.normal}
            local surfaceFriction = hullRecord.surfaceFriction or a1.Config.SurfaceFrictionDefault
            v1.SurfaceFriction = surfaceFriction
            v1.Support = {
                Kind = hullRecord.kind,
                SourceId = hullRecord.sourceId,
                Anchor = supportAnchor,
                Velocity = surfaceVelocity_2,
            }
            return v1
        end
        return nil
    end
    return nil
end

local function sweepTrace(a1, a2, a3, a4, a5, a6) -- Line: 349
    -- upvalues: newTrace (val), fromSweep (val)
    local v1
    local Query = a1.Query
    local v2 = Query[a2]
    if v2 == nil then
        return (fromSweep(a1, a4, a5, Query[a3](Query, a4, a5, if a6 ~= "crouching" then "Standing" else "Ducking", nil, 1, 1)))
    end
    local v3 = if a6 ~= "crouching" then "Standing" else "Ducking"
    local SweepNames = a1.SweepNames
    if SweepNames == nil then
        a1.SweepNames = {}
        a1.SweepStarts = {}
        a1.SweepFinishes = {}
        a1.SweepStances = {}
        a1.SweepHits = {}
        a1.SweepCount = 0
    end
    local SweepStarts = a1.SweepStarts
    local SweepFinishes = a1.SweepFinishes
    local SweepStances = a1.SweepStances
    local SweepHits = a1.SweepHits
    local v4 = nil
    local v5 = false
    local SweepCount = a1.SweepCount
    local v6, v7, v8, v9 = a2, a4, a5, a1
    for i = 1, SweepCount do
        if SweepNames[i] == v6 and SweepStarts[i] == v7 and SweepFinishes[i] == v8 and SweepStances[i] == v3 then
            v4 = SweepHits[i]
            v5 = true
            break
        end
    end
    if not v5 then
        v4 = v2(Query, v7, v8, v3, nil, 1, 1)
        v1 = v9.SweepCount + 1
        v9.SweepCount = v1
        SweepNames[v1] = v6
        SweepStarts[v1] = v7
        SweepFinishes[v1] = v8
        SweepStances[v1] = v3
        SweepHits[v1] = v4
    end
    if v4 ~= nil then
        return (fromSweep(v9, v7, v8, v4))
    end
    v1 = newTrace(v9)
    v1.fraction = 1
    v1.endPos = v8
    v1.normal = Vector3.new(0, 0, 0)
    v1.startSolid = false
    v1.allSolid = false
    v1.planeNum = nil
    v1.minkowskiPlaneKind = nil
    v1.hullRecord = nil
    v1.floorPenetrationDepth = nil
    return v1
end

function u22:Sweep(a2, a3, a4, a5) -- Line: 399
    -- upvalues: sweepTrace (val), DeterminismTrace (val)
    local v1 = sweepTrace(self, "SweepDetailed", "Sweep", a2, a3, a4)
    DeterminismTrace.collision(self.Trace, "collision.sweep", a2, a3, v1, 3)
    return v1
end

function u22:SweepWithFloorSupport(a2, a3, a4) -- Line: 405
    -- upvalues: sweepTrace (val), DeterminismTrace (val)
    local v1 = sweepTrace(self, "SweepWithFloorSupportDetailed", "SweepWithFloorSupport", a2, a3, a4)
    DeterminismTrace.collision(self.Trace, "collision.sweepWithFloor", a2, a3, v1, 3)
    return v1
end

function u22.SupportSweep(a1, a2, a3, a4, a5, a6) -- Line: 412
    -- upvalues: retainedPlayerGroundQuery (val), groundQuery (val)
    local v1
    local v2 = retainedPlayerGroundQuery(a1, a2, a3, a4)
    if v2 ~= nil then
        return v2
    end
    local v3 = a1:SweepWithFloorSupport(a2, a3, a4)
    if not (v3.fraction < 1) then
        v1 = groundQuery(a1, a2, a3, a4, a6 == true)
        if v1.fraction < 1 then
            return v1
        end
        return v3
    end
    if a5 ~= nil and not (a5 <= v3.normal.Y) then
        v1 = groundQuery(a1, a2, a3, a4, a6 == true)
        if v1.fraction < 1 then
            return v1
        end
        return v3
    end
    return v3
end

function u22.WalkableSupportSweep(a1, a2, a3, a4, a5, a6) -- Line: 434
    -- upvalues: retainedPlayerGroundQuery (val), groundQuery (val)
    local v1 = retainedPlayerGroundQuery(a1, a2, a3, a4)
    if v1 ~= nil then
        return v1
    end
    return (groundQuery(a1, a2, a3, a4, a6 == true))
end

function u22.FloorSupportSweep(a1, a2, a3, a4, a5) -- Line: 448
    -- upvalues: groundQuery (val), newTrace (val)
    local v1 = groundQuery(a1, a2, a3, a4, false)
    local hullRecord = v1.hullRecord
    if hullRecord ~= nil and hullRecord.isFloorSupport == true then
        return v1
    end
    local v2 = newTrace(a1)
    v2.fraction = 1
    v2.endPos = a3
    v2.normal = Vector3.new(0, 0, 0)
    v2.startSolid = false
    v2.allSolid = false
    v2.planeNum = nil
    v2.minkowskiPlaneKind = nil
    v2.hullRecord = nil
    v2.floorPenetrationDepth = nil
    return v2
end

function u22.PointTest(a1, a2, a3, a4) -- Line: 462
    -- upvalues: newTrace (val), hullRecord (val), Enums (val), DeterminismTrace (val)
    local v1 = a1:Sweep(a2, a2, a3)
    local PlayerStanceProbe = a1.PlayerStanceProbe
    if a4 == true and PlayerStanceProbe ~= nil and not v1.startSolid and not v1.allSolid then
        local v2 = PlayerStanceProbe(a2, if a3 ~= "crouching" then "Standing" else "Ducking")
        if v2 ~= nil then
            v1 = newTrace(a1)
            v1.fraction = 1
            v1.endPos = a2
            v1.normal = Vector3.new(0, 0, 0)
            v1.startSolid = false
            v1.allSolid = false
            v1.planeNum = nil
            v1.minkowskiPlaneKind = nil
            v1.hullRecord = nil
            v1.floorPenetrationDepth = nil
            v1.fraction = 0
            v1.startSolid = true
            v1.allSolid = true
            v1.hullRecord = hullRecord(a1, {SourceId = v2, Kind = Enums.SupportKind.Player}, nil, nil)
            DeterminismTrace.collision(a1.Trace, "collision.playerStanceClearance", a2, a2, v1, 3)
        end
        return v1
    end
    return v1
end

function u22.BeginStepBounds(a1, a2, a3, a4, a5) -- Line: 481
    -- upvalues: 
    local Query = a1.Query
    if Query.SetMovementBounds == nil then
        return
    end
    local Config = a1.Config
    local v1 = (a3.Magnitude + a4) * a5 + 1.5
    local v2 = Vector3.new(v1, v1 + (math.max(Config.MaxStepHeight, Config.GroundProbeDistance)), v1)
    Query:SetMovementBounds(a2 - v2, a2 + v2)
end

function u22.HasUniformGroundSurfaces(a1, a2, a3, a4) -- Line: 498
    -- upvalues: 
    return false
end

function u22.HasClimbableNear(a1, a2, a3, a4) -- Line: 506 -- types: a1: table, a2: vector, a3: string, a4: number
    local FindLadder = a1.Query.FindLadder
    local v1 = false
    if FindLadder ~= nil then
        local Query = a1.Query
        v1 = FindLadder(Query, a2, if a3 ~= "crouching" then "Standing" else "Ducking", a4, 1) ~= nil
    end
    return v1
end

function u22.CanonicalizeExpandedBlockCornerTrace(a1, a2, a3, a4) -- Line: 511
    -- upvalues: 
    return a2
end

return (table.freeze(u22))