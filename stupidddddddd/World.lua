-- ReplicatedStorage.MovementV2.Collision.World
-- Script path: ReplicatedStorage.MovementV2.Collision.World
-- Decompile time: 15.04 ms

local DestructibleFrame = require(script.Parent.DestructibleFrame)
local Geometry = require(script.Parent.Geometry)
require(script.Parent.TopologyBuilder)
require(script.Parent.Parent.Simulation.Types)
local u22 = {}
u22.__index = u22

local function stanceTopology(a1, a2) -- Line: 76
    if a2 == "Standing" then
        return a1.Standing
    end
    if a2 == "Ducking" then
        return a1.Ducking
    end
    error(string.format("unsupported collision stance %s", (tostring(a2))), 3)
end

local function gridCandidates(a1, a2, a3, a4) -- Line: 85 -- types: a3: vector, a4: vector
    local Scratch = a1.Scratch
    local v1 = Scratch.Stamp + 1
    if v1 >= 2147483647 then
        table.clear(Scratch.Seen)
        v1 = 1
    end
    Scratch.Stamp = v1
    a2.Grid:QueryInto(a3, a4, a2.Records, Scratch.Indices, Scratch.Seen, v1, Scratch.Sources, Scratch.Cursors)
    return Scratch.Indices
end

local function queryCandidates(a1, a2, a3, a4) -- Line: 112 -- types: a3: vector, a4: vector
    local Scratch = a1.Scratch
    local BoundsMin = Scratch.BoundsMin
    local BoundsMax = Scratch.BoundsMax
    if BoundsMin ~= nil
        and BoundsMax ~= nil
        and not (a3.X < BoundsMin.X)
        and not (a3.Y < BoundsMin.Y)
        and not (a3.Z < BoundsMin.Z)
        and not (BoundsMax.X < a4.X)
        and not (BoundsMax.Y < a4.Y)
        and not (BoundsMax.Z < a4.Z) then
        local AabbMax, AabbMin, v1
        local v2 = Scratch.BoundsLists[a2]
        if v2 == nil then
            local clone = table.clone
            local Scratch_2 = a1.Scratch
            local v3 = Scratch_2.Stamp + 1
            if v3 >= 2147483647 then
                table.clear(Scratch_2.Seen)
                v3 = 1
            end
            Scratch_2.Stamp = v3
            a2.Grid:QueryInto(BoundsMin, BoundsMax, a2.Records, Scratch_2.Indices, Scratch_2.Seen, v3, Scratch_2.Sources, Scratch_2.Cursors)
            v2 = clone(Scratch_2.Indices)
            Scratch.BoundsLists[a2] = v2
        end
        local Indices_2 = Scratch.Indices
        table.clear(Indices_2)
        local v4 = 0
        for i, j in v2 do
            v1 = a2.Records[j]
            AabbMin = v1.AabbMin
            AabbMax = v1.AabbMax
            if a3.X <= AabbMax.X
                and AabbMin.X <= a4.X
                and a3.Y <= AabbMax.Y
                and AabbMin.Y <= a4.Y
                and a3.Z <= AabbMax.Z
                and AabbMin.Z <= a4.Z then
                v4 = v4 + 1
                Indices_2[v4] = j
            end
        end
        return Indices_2
    end
    local Scratch_3 = a1.Scratch
    local v5 = Scratch_3.Stamp + 1
    if v5 >= 2147483647 then
        table.clear(Scratch_3.Seen)
        v5 = 1
    end
    Scratch_3.Stamp = v5
    a2.Grid:QueryInto(a3, a4, a2.Records, Scratch_3.Indices, Scratch_3.Seen, v5, Scratch_3.Sources, Scratch_3.Cursors)
    return Scratch_3.Indices
end

local function recordIsActive(a1, a2) -- Line: 161 -- upvalues: DestructibleFrame (val)
    local DestructibleIndex = a2.DestructibleIndex
    local v1 = true
    if DestructibleIndex ~= nil then
        v1 = DestructibleFrame.IsActive(a1, DestructibleIndex)
    end
    return v1
end

local function recordIsIgnored(a1, a2) -- Line: 166
    local v1 = false
    if a2 ~= nil then
        v1 = false
        if a2.Kind == a1.Kind then
            v1 = a2.SourceId == a1.SourceId
        end
    end
    return v1
end

local function assertPosition(a1, a2) -- Line: 170 -- upvalues: Geometry (val) -- types: a1: vector, a2: string
    if not Geometry.IsFiniteVector3(a1) then
        error(string.format("%s must be a finite Vector3", a2))
    end
end

local function assertTimeFraction(a1) -- Line: 177 -- types: a1: number
    local v1 = false
    if a1 == a1 then
        v1 = false
        if a1 >= 0 then
            v1 = a1 <= 1
        end
    end
    assert(v1, "collision time fraction must be normalized")
end

local function assertTimeInterval(a1, a2) -- Line: 184 -- types: a1: number, a2: number
    local v1 = false
    if a1 == a1 then
        v1 = false
        if a1 >= 0 then
            v1 = a1 <= 1
        end
    end
    assert(v1, "collision time fraction must be normalized")
    v1 = false
    if a2 == a2 then
        v1 = false
        if a2 >= 0 then
            v1 = a2 <= 1
        end
    end
    assert(v1, "collision time fraction must be normalized")
    assert(a1 <= a2, "collision time interval is reversed")
end

local function replaceNarrow(a1, a2, a3, a4, a5, a6) -- Line: 191 -- types: a5: number, a6: number
    if a1 ~= nil and a2 ~= nil then
        if a4.StartSolid ~= a2.StartSolid then
            return a4.StartSolid
        end
        if a6 < math.abs(a4.Fraction - a2.Fraction) * a5 then
            return a4.Fraction < a2.Fraction
        end
        if a3.SourceId ~= a1.SourceId then
            return a3.SourceId < a1.SourceId
        end
        if a3.Kind ~= a1.Kind then
            return a3.Kind < a1.Kind
        end
        if a3.ElementId ~= a1.ElementId then
            return a3.ElementId < a1.ElementId
        end
        if a4.PlaneId ~= a2.PlaneId then
            return a4.PlaneId < a2.PlaneId
        end
        if a4.Normal.X ~= a2.Normal.X then
            return a4.Normal.X < a2.Normal.X
        end
        if a4.Normal.Y ~= a2.Normal.Y then
            return a4.Normal.Y < a2.Normal.Y
        end
        return a4.Normal.Z < a2.Normal.Z
    end
    return true
end

local function detailed(a1, a2) -- Line: 231
    local SourceShape = nil
    local MinkowskiPlaneKind = nil
    if a1.RecordType == "Hull" then
        SourceShape = a1.SourceShape
        for i, j in a1.Planes do
            if j.PlaneId == a2.PlaneId then
                MinkowskiPlaneKind = j.MinkowskiPlaneKind
                break
            end
        end
    end
    return {
        Fraction = a2.Fraction,
        Normal = a2.Normal,
        StartSolid = a2.StartSolid,
        AllSolid = a2.AllSolid,
        PlaneId = a2.PlaneId,
        SourceId = a1.SourceId,
        Kind = a1.Kind,
        DestructibleIndex = a1.DestructibleIndex,
        ElementId = a1.ElementId,
        SurfaceFriction = a1.SurfaceFriction,
        ResolvedPosition = a2.ResolvedPosition,
        PenetrationDepth = a2.PenetrationDepth,
        SourceShape = SourceShape,
        MinkowskiPlaneKind = MinkowskiPlaneKind,
        RecordType = a1.RecordType,
        Climbable = if a1.RecordType ~= "Hull" then false else a1.Climbable,
        BuildMode = if a1.RecordType ~= "Hull" then "walkMeshTriangle" else a1.BuildMode,
        SourceCFrame = if a1.RecordType ~= "Hull" then nil else a1.SourceCFrame,
        SourceSize = if a1.RecordType ~= "Hull" then nil else a1.SourceSize,
        Planes = if a1.RecordType ~= "Hull" then nil else a1.Planes,
    }
end

local u36 = setmetatable({}, {__mode = "k"})

function u22.new(a1, a2) -- Line: 270 -- upvalues: DestructibleFrame (val), u36 (val), u22 (val)
    assert(table.isfrozen(a1), "collision topology must be immutable")
    assert(
        table.isfrozen(a1.Config) and table.isfrozen(a1.Stats) and table.isfrozen(a1.Standing) and table.isfrozen(a1.Standing.Records) and table.isfrozen(a1.Standing.Grid) and table.isfrozen(a1.Ducking) and table.isfrozen(a1.Ducking.Records) and table.isfrozen(a1.Ducking.Grid),
        "collision topology contains mutable stance data"
    )
    assert(table.isfrozen(a2), "destructible frame must be immutable")
    local v1, v2 = DestructibleFrame.Validate(a2.Epoch, a2.Revision, a2.Count, a2.ActiveBits)
    assert(v1, v2)
    local v3 = false
    if 1 <= a2.Epoch then
        v3 = a2.Epoch <= 65535
    end
    assert(v3, "destructible-frame epoch must fit non-zero u16")
    assert(a2.Epoch == a1.Epoch, "destructible frame belongs to a different topology epoch")
    assert(a2.Count == a1.DestructibleCount, "destructible frame has the wrong source count")
    local v4 = u36[a1]
    if v4 == nil then
        u36[a1] = {
            Stamp = 0,
            RegionCount = 0,
            Indices = {},
            Seen = {},
            Sources = {},
            Cursors = {},
            BoundsLists = {},
            Regions = {},
        }
    end
    return (table.freeze((setmetatable({Topology = a1, Destructibles = a2, Scratch = v4}, u22))))
end

local u38 = {}

function u22.SetMovementBounds(a1, a2, a3) -- Line: 324 -- upvalues: Geometry (val) -- types: a2: vector, a3: vector
    local Lists_2, Max_2, Min_2
    if not Geometry.IsFiniteVector3(a2) then
        error(string.format("%s must be a finite Vector3", "movement bounds minimum"))
    end
    if not Geometry.IsFiniteVector3(a3) then
        error(string.format("%s must be a finite Vector3", "movement bounds maximum"))
    end
    local Scratch = a1.Scratch
    local Regions = Scratch.Regions
    local v1 = math.floor(a2.X / 1)
    local v2 = math.floor(a2.Y / 1)
    local v3 = math.floor(a2.Z / 1)
    local v4 = v1 + 32768 + (v2 + 32768) * 65536 + (v3 + 32768) * 65536 * 65536
    local v5 = Regions[v4]
    if v5 == nil then
        if 512 <= Scratch.RegionCount then
            table.clear(Regions)
            Scratch.RegionCount = 0
        end
        if v5 == nil then
            Scratch.RegionCount = Scratch.RegionCount + 1
        end
        v5 = {
            Min = Vector3.new(v1 * 1, v2 * 1, v3 * 1),
            Max = a3 + Vector3.new(1, 1, 1),
            Lists = {},
        }
        Regions[v4] = v5
        Min_2 = v5.Min
        Max_2 = v5.Max
        Lists_2 = v5.Lists
        Scratch.BoundsMin = Min_2
        Scratch.BoundsMax = Max_2
        Scratch.BoundsLists = Lists_2
        return
    end
    local Min = v5.Min
    local Max = v5.Max
    if Min.X <= a2.X then
        if Min.Y <= a2.Y then
            if Min.Z <= a2.Z then
                if a3.X <= Max.X then
                    if a3.Y <= Max.Y then
                        if a3.Z <= Max.Z then
                            local Lists = v5.Lists
                            Scratch.BoundsMin = Min
                            Scratch.BoundsMax = Max
                            Scratch.BoundsLists = Lists
                            return
                        end
                    end
                end
            end
        end
    end
    if v5 == nil then
        Scratch.RegionCount = Scratch.RegionCount + 1
    end
    v5 = {
        Min = Vector3.new(v1 * 1, v2 * 1, v3 * 1),
        Max = a3 + Vector3.new(1, 1, 1),
        Lists = {},
    }
    Regions[v4] = v5
    Min_2 = v5.Min
    Max_2 = v5.Max
    Lists_2 = v5.Lists
    Scratch.BoundsMin = Min_2
    Scratch.BoundsMax = Max_2
    Scratch.BoundsLists = Lists_2
end

function u22.ClearMovementBounds(a1) -- Line: 366 -- upvalues: u38 (val)
    local Scratch = a1.Scratch
    Scratch.BoundsMin = nil
    Scratch.BoundsMax = nil
    Scratch.BoundsLists = u38
end

local function sweepDetailed(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 374
    -- upvalues: Geometry (val), queryCandidates (val), DestructibleFrame (val), replaceNarrow (val), detailed (val)
    local DestructibleIndex, Destructibles, Standing, v1, v2
    if not Geometry.IsFiniteVector3(a2) then
        error(string.format("%s must be a finite Vector3", "sweep start"))
    end
    if not Geometry.IsFiniteVector3(a3) then
        error(string.format("%s must be a finite Vector3", "sweep end"))
    end
    local v3 = false
    if a6 == a6 then
        v3 = false
        if a6 >= 0 then
            v3 = a6 <= 1
        end
    end
    assert(v3, "collision time fraction must be normalized")
    v3 = false
    if a7 == a7 then
        v3 = false
        if a7 >= 0 then
            v3 = a7 <= 1
        end
    end
    assert(v3, "collision time fraction must be normalized")
    assert(a6 <= a7, "collision time interval is reversed")
    local Magnitude = (a3 - a2).Magnitude
    local Config = a1.Topology.Config
    assert(Magnitude <= Config.MaxSweepDistance, "collision sweep exceeds the configured maximum distance")
    local Topology = a1.Topology
    if a4 == "Standing" then
        Standing = Topology.Standing
    elseif a4 ~= "Ducking" then
        error(string.format("unsupported collision stance %s", (tostring(a4))), 3)
        Standing = nil
    else
        Standing = Topology.Ducking
    end
    local v4, v5 = Geometry.SegmentBounds(a2, a3, Config.BroadphasePadding)
    local v6 = nil
    local v7 = nil
    local v8 = (queryCandidates(a1, Standing, v4, v5))
    local v9 = nil
    local v10 = nil
    local v11 = a5
    for i, j in v8, v9, v10 do
        v1 = Standing.Records[j]
        v2 = false
        if v11 ~= nil then
            v2 = false
            if v11.Kind == v1.Kind then
                v2 = v11.SourceId == v1.SourceId
            end
        end
        if not v2 then
            Destructibles = v12.Destructibles
            DestructibleIndex = v1.DestructibleIndex
            v2 = true
            if DestructibleIndex ~= nil then
                v2 = DestructibleFrame.IsActive(Destructibles, DestructibleIndex)
            end
            if v2 then
                if v1.RecordType ~= "Walkmesh" or v13 then
                    v2 = if v1.RecordType ~= "Hull" then Geometry.SweepTriangle(v1, v14, v15, Config) else Geometry.SweepConvex(v1, v14, v15, Config)
                    if v2 ~= nil and replaceNarrow(v6, v7, v1, v2, Magnitude, Config.HitTieDistance) then
                        v6 = v1
                        v7 = v2
                    end
                end
            end
        end
    end
    if v6 and v7 then
        return (detailed(v6, v7))
    end
    return nil
end

function u22.SweepDetailed(a1, a2, a3, a4, a5, a6, a7) -- Line: 414
    -- upvalues: sweepDetailed (val)
    return (sweepDetailed(a1, a2, a3, a4, a5, a6, a7, false))
end

function u22.SweepWithFloorSupportDetailed(a1, a2, a3, a4, a5, a6, a7) -- Line: 435
    -- upvalues: sweepDetailed (val)
    return (sweepDetailed(a1, a2, a3, a4, a5, a6, a7, true))
end

local function sweepResult(a1) -- Line: 457 -- types: a1: table?
    if a1 == nil then
        return {Fraction = 1, Normal = Vector3.new(0, 1, 0), StartSolid = false, AllSolid = false}
    end
    return {
        SurfaceVelocity = Vector3.new(0, 0, 0),
        Fraction = a1.Fraction,
        Normal = a1.Normal,
        StartSolid = a1.StartSolid,
        AllSolid = a1.AllSolid,
        SourceId = a1.SourceId,
        Kind = a1.Kind,
        SourceShape = a1.SourceShape,
        MinkowskiPlaneKind = a1.MinkowskiPlaneKind,
        RecordType = a1.RecordType,
        Climbable = a1.Climbable,
        BuildMode = a1.BuildMode,
        SourceCFrame = a1.SourceCFrame,
        SourceSize = a1.SourceSize,
        Planes = a1.Planes,
        PlaneId = a1.PlaneId,
        SurfaceFriction = a1.SurfaceFriction,
        ResolvedPosition = a1.ResolvedPosition,
        PenetrationDepth = a1.PenetrationDepth,
    }
end

function u22.Sweep(a1, a2, a3, a4, a5, a6, a7) -- Line: 489
    -- upvalues: sweepResult (val)
    return (sweepResult(a1:SweepDetailed(a2, a3, a4, a5, a6, a7)))
end

function u22.SweepWithFloorSupport(a1, a2, a3, a4, a5, a6, a7) -- Line: 503
    -- upvalues: sweepResult (val)
    return (sweepResult(a1:SweepWithFloorSupportDetailed(a2, a3, a4, a5, a6, a7)))
end

function u22:IsClear(a2, a3, a4) -- Line: 524
    -- upvalues: Geometry (val), queryCandidates (val), DestructibleFrame (val)
    local DestructibleIndex, Destructibles, Standing, v1, v2
    if not Geometry.IsFiniteVector3(a2) then
        error(string.format("%s must be a finite Vector3", "clearance position"))
    end
    local v3 = false
    if a4 == a4 then
        v3 = false
        if a4 >= 0 then
            v3 = a4 <= 1
        end
    end
    assert(v3, "collision time fraction must be normalized")
    local Config = self.Topology.Config
    local Topology = self.Topology
    if a3 == "Standing" then
        Standing = Topology.Standing
    elseif a3 ~= "Ducking" then
        error(string.format("unsupported collision stance %s", (tostring(a3))), 3)
        Standing = nil
    else
        Standing = Topology.Ducking
    end
    local v4 = Vector3.new(Config.BroadphasePadding, Config.BroadphasePadding, Config.BroadphasePadding)
    local v5 = queryCandidates(self, Standing, a2 - v4, a2 + v4)
    local v6 = nil
    local v7 = nil
    local v8, v9 = self, a2
    for i, j in v5, v6, v7 do
        v1 = Standing.Records[j]
        if v1.RecordType == "Hull" then
            Destructibles = v8.Destructibles
            DestructibleIndex = v1.DestructibleIndex
            v2 = true
            if DestructibleIndex ~= nil then
                v2 = DestructibleFrame.IsActive(Destructibles, DestructibleIndex)
            end
            if v2 and Geometry.ContainsConvex(v1, v9, Config.ContactEpsilon) then
                return false
            end
        end
    end
    return true
end

function u22.CanMove(a1, a2, a3, a4, a5, a6, a7) -- Line: 545 -- types: a2: vector, a3: vector, a6: number, a7: number
    local v1
    local v2 = a1:SweepDetailed(a2, a3, a4, a5, a6, a7)
    if v2 == nil then
        v1 = a1:IsClear(a3, a4, a7)
    else
        v1 = not v2.StartSolid
        if v1 then
            v1 = false
            if 1 <= v2.Fraction then
                v1 = a1:IsClear(a3, a4, a7)
            end
        end
    end
    return v1
end

local function groundWinner(a1, a2, a3, a4, a5, a6) -- Line: 561
    -- upvalues: Geometry (val), queryCandidates (val), DestructibleFrame (val), replaceNarrow (val)
    local DestructibleIndex, Destructibles, Y, v1, v2
    local Magnitude = (a5 - a4).Magnitude
    local v3, v4 = Geometry.SegmentBounds(a4, a5, a3.BroadphasePadding)
    local v5 = nil
    local v6 = nil
    local v7 = (queryCandidates(a1, a2, v3, v4))
    local v8 = nil
    local v9 = nil
    local v10, v11 = a2, a1
    for i, j in v7, v8, v9 do
        v1 = v10.Records[j]
        Destructibles = v11.Destructibles
        DestructibleIndex = v1.DestructibleIndex
        v2 = true
        if DestructibleIndex ~= nil then
            v2 = DestructibleFrame.IsActive(Destructibles, DestructibleIndex)
        end
        if v2 then
            v2 = if v1.RecordType ~= "Hull" then Geometry.SweepTriangleSupport(v1, v12, v13, v14) else Geometry.SweepConvexSupport(v1, v12, v13, v14.WalkableFloor, v15, v14)
            if v2 ~= nil then
                Y = v2.Normal.Y
                if v14.WalkableFloor <= Y and replaceNarrow(v5, v6, v1, v2, Magnitude, v14.HitTieDistance) then
                    v5 = v1
                    v6 = v2
                end
            end
        end
    end
    return v5, v6
end

function u22.FindGround(a1, a2, a3, a4, a5, a6) -- Line: 600
    -- upvalues: Geometry (val), groundWinner (val)
    local Standing
    if not Geometry.IsFiniteVector3(a2) then
        error(string.format("%s must be a finite Vector3", "ground-query position"))
    end
    local v1 = false
    if a5 == a5 then
        v1 = false
        if a5 >= 0 then
            v1 = a5 <= 1
        end
    end
    assert(v1, "collision time fraction must be normalized")
    v1 = false
    if a4 == a4 then
        v1 = false
        if a4 >= 0 then
            v1 = a4 <= a1.Topology.Config.MaxSweepDistance
        end
    end
    assert(v1, "invalid ground distance")
    local Config = a1.Topology.Config
    local Topology = a1.Topology
    if a3 == "Standing" then
        Standing = Topology.Standing
    elseif a3 ~= "Ducking" then
        error(string.format("unsupported collision stance %s", (tostring(a3))), 3)
        Standing = nil
    else
        Standing = Topology.Ducking
    end
    local v2 = math.min(Config.GroundProbeStartBump, Config.MaxSweepDistance - a4)
    local v3 = a2 + Vector3.new(0, v2, 0)
    local v4 = a2 - Vector3.new(0, a4, 0)
    local v5, v6 = groundWinner(a1, Standing, Config, v3, v4, a6 ~= nil)
    if v6 ~= nil and v6.StartSolid and v6.ResolvedPosition == nil then
        local v7
        local v8 = math.max(v2, a4, Config.FloorStartSolidRecoveryDepth - Config.FloorContactEpsilon)
        local v9 = a2 + Vector3.new(0, v8, 0)
        local v10 = a1:SweepDetailed(a2, v9, a3, nil, a5, a5)
        local v11 = (if v10 == nil then v9 else if not v10.StartSolid then a2:Lerp(v9, v10.Fraction) else a2) - Vector3.new(0, a4 + v8, 0)
        local v12, v13 = groundWinner(a1, Standing, Config, v7, v11, false)
        if v13 ~= nil and not v13.AllSolid then
            v5 = v12
            v6 = v13
            v3 = v7
            v4 = v11
        end
    end
    if v6 ~= nil and v5 ~= nil then
        local ResolvedPosition = v6.ResolvedPosition or (if not v6.StartSolid then v3:Lerp(v4, v6.Fraction) else a2)
        if not a1:IsClear(ResolvedPosition, a3, a5) then
            return nil
        end
        return {
            Position = ResolvedPosition,
            Normal = v6.Normal,
            SurfaceFriction = v5.SurfaceFriction,
            Support = {
                Velocity = Vector3.new(0, 0, 0),
                Kind = v5.Kind,
                SourceId = v5.SourceId,
                Anchor = ResolvedPosition,
            },
        }
    end
    return nil
end

local u54 = setmetatable({}, {__mode = "k"})

local function climbableIndices(a1) -- Line: 664 -- upvalues: u54 (val)
    local v1 = u54[a1]
    if v1 == nil then
        v1 = {}
        for i, j in a1.Records do
            if j.RecordType == "Hull" and j.Climbable then
                v1[#v1 + 1] = i
            end
        end
        u54[a1] = v1
    end
    return v1
end

local function ladderFaceContains(a1, a2, a3) -- Line: 678 -- types: a2: vector, a3: number
    for i, j in a1.Planes do
        if a3 < (a2:Dot(j.Normal)) - j.Distance then
            return false
        end
    end
    return true
end

function u22.FindLadder(a1, a2, a3, a4, a5) -- Line: 687
    -- upvalues: Geometry (val), climbableIndices (val), DestructibleFrame (val), ladderFaceContains (val)
    local AabbMax, AabbMin, DestructibleIndex, Destructibles, Standing, v1, v2, v3, v4, v5, v6
    if not Geometry.IsFiniteVector3(a2) then
        error(string.format("%s must be a finite Vector3", "ladder-query position"))
    end
    local v7 = false
    if a5 == a5 then
        v7 = false
        if a5 >= 0 then
            v7 = a5 <= 1
        end
    end
    assert(v7, "collision time fraction must be normalized")
    v7 = false
    if a4 == a4 then
        v7 = false
        if a4 >= 0 then
            v7 = a4 <= a1.Topology.Config.MaxSweepDistance
        end
    end
    assert(v7, "invalid ladder distance")
    local Config = a1.Topology.Config
    local Topology = a1.Topology
    if a3 == "Standing" then
        Standing = Topology.Standing
    elseif a3 ~= "Ducking" then
        error(string.format("unsupported collision stance %s", (tostring(a3))), 3)
        Standing = nil
    else
        Standing = Topology.Ducking
    end
    if a1.Topology.HasClimbable == false then
        return nil
    end
    local v8 = Vector3.new(a4, a4, a4)
    local v9 = a2 - v8
    local v10 = a2 + v8
    local v11 = (1 / 0)
    local v12 = nil
    local v13 = nil
    local v14, v15, v16 = a1, a2, a4
    for i, j in climbableIndices(Standing) do
        v1 = Standing.Records[j]
        AabbMin = v1.AabbMin
        AabbMax = v1.AabbMax
        if not (AabbMax.X < v9.X)
            and not (v10.X < AabbMin.X)
            and not (AabbMax.Y < v9.Y)
            and not (v10.Y < AabbMin.Y)
            and not (AabbMax.Z < v9.Z)
            and not (v10.Z < AabbMin.Z) then
            Destructibles = v14.Destructibles
            DestructibleIndex = v1.DestructibleIndex
            v2 = true
            if DestructibleIndex ~= nil then
                v2 = DestructibleFrame.IsActive(Destructibles, DestructibleIndex)
            end
            if v2 then
                v3 = nil
                v4 = nil
                for k, n in v1.LadderPlanes, v3, v4 do
                    v5 = math.abs(n.Normal.Y)
                    if not (Config.WalkableFloor <= v5) then
                        v5 = (v15:Dot(n.Normal)) - n.Distance
                        if not (v5 < -Config.ContactEpsilon)
                            and not (v16 + Config.ContactEpsilon < v5)
                            and ladderFaceContains(v1, v15 - n.Normal * v5, Config.ContactEpsilon) then
                            v6 = math.max(v5, 0)
                            if v6 < v11 - Config.HitTieDistance then
                                v12 = v1
                                v13 = n
                            elseif (math.abs(v6 - v11)) <= Config.HitTieDistance then
                                if v12 == nil
                                    or v1.SourceId < v12.SourceId
                                    or v1.SourceId == v12.SourceId and v13 ~= nil and n.PlaneId < v13.PlaneId then
                                    v12 = v1
                                    v13 = n
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if v12 ~= nil and v13 ~= nil then
        return {
            Velocity = Vector3.new(0, 0, 0),
            Normal = v13.Normal,
            SourceId = v12.SourceId,
            Kind = v12.Kind,
        }
    end
    return nil
end

return table.freeze(u22)