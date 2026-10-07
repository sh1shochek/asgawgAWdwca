-- ReplicatedStorage.MovementV2.Collision.CompositeWorld
-- Script path: ReplicatedStorage.MovementV2.Collision.CompositeWorld
-- Decompile time: 11.24 ms

local Enums = require(script.Parent.Parent.Enums)
require(script.Parent.Parent.Simulation.Types)
local Geometry = require(script.Parent.Geometry)
local MoverFrame = require(script.Parent.MoverFrame)
local MoverProxyCache = require(script.Parent.MoverProxyCache)
require(script.Parent.TopologyConfig)
require(script.Parent.World)
local u38 = {}
u38.__index = u38

local function isFiniteNumber(a1) -- Line: 68
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 > (-1 / 0) then
                v1 = a1 < (1 / 0)
            end
        end
    end
    return v1
end

local function assertPosition(a1, a2) -- Line: 72 -- upvalues: Geometry (val) -- types: a1: vector, a2: string
    if not Geometry.IsFiniteVector3(a1) then
        error(string.format("%s must be a finite Vector3", a2))
    end
end

local function assertTimeFraction(a1) -- Line: 78 -- types: a1: number
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 > (-1 / 0) then
                v1 = a1 < (1 / 0)
            end
        end
    end
    if v1 then
        v1 = false
        if a1 >= 0 then
            v1 = a1 <= 1
        end
    end
    assert(v1, "collision time fraction must be normalized")
end

local function assertTimeInterval(a1, a2) -- Line: 85 -- types: a1: number, a2: number
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 > (-1 / 0) then
                v1 = a1 < (1 / 0)
            end
        end
    end
    if v1 then
        v1 = false
        if a1 >= 0 then
            v1 = a1 <= 1
        end
    end
    assert(v1, "collision time fraction must be normalized")
    v1 = false
    if typeof(a2) == "number" then
        v1 = false
        if a2 == a2 then
            v1 = false
            if a2 > (-1 / 0) then
                v1 = a2 < (1 / 0)
            end
        end
    end
    if v1 then
        v1 = false
        if a2 >= 0 then
            v1 = a2 <= 1
        end
    end
    assert(v1, "collision time fraction must be normalized")
    assert(a1 <= a2, "collision time interval is reversed")
end

local function identityLess(a1, a2) -- Line: 91 -- types: a1: table, a2: table
    if a1.SourceId ~= a2.SourceId then
        return a1.SourceId < a2.SourceId
    end
    if a1.Kind ~= a2.Kind then
        return a1.Kind < a2.Kind
    end
    if a1.ElementId ~= a2.ElementId then
        return a1.ElementId < a2.ElementId
    end
    return a1.PlaneId < a2.PlaneId
end

local function shouldReplace(a1, a2, a3) -- Line: 104 -- types: a1: table?, a2: table, a3: vector
    if a1 == nil then
        return true
    end
    if a2.StartSolid ~= a1.StartSolid then
        return a2.StartSolid
    end
    if 1e-09 < (math.abs(a2.Fraction - a1.Fraction)) then
        return a2.Fraction < a1.Fraction
    end
    local v1 = -a3:Dot(a2.Normal)
    local v2 = -a3:Dot(a1.Normal)
    if 1e-09 < (math.abs(v1 - v2)) then
        return v2 < v1
    end
    if a2.SourceId ~= a1.SourceId then
        return a2.SourceId < a1.SourceId
    end
    if a2.Kind ~= a1.Kind then
        return a2.Kind < a1.Kind
    end
    if a2.ElementId ~= a1.ElementId then
        return a2.ElementId < a1.ElementId
    end
    return a2.PlaneId < a1.PlaneId
end

local function endpointDetailed(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 122
    -- upvalues: Enums (val), MoverFrame (val)
    local Record = a1.Record
    local v1 = math.clamp(a4, 0, 1)
    return {
        ElementId = 0,
        SourceShape = "Block",
        RecordType = "Hull",
        BuildMode = "dynamicMoverObb",
        Fraction = v1,
        Normal = a5,
        StartSolid = a6,
        AllSolid = a7,
        PlaneId = a8,
        SourceId = Record.Id,
        Kind = Enums.SupportKind.Mover,
        SurfaceFriction = Record.SurfaceFriction,
        SurfaceVelocity = MoverFrame.VelocityAtPoint(Record, a2:Lerp(a3, v1), 1),
        SourceCFrame = Record.CFrame,
        SourceSize = Record.Size,
    }
end

local function staticDetailed(a1) -- Line: 155
    return {
        SurfaceVelocity = Vector3.new(0, 0, 0),
        Fraction = a1.Fraction,
        Normal = a1.Normal,
        StartSolid = a1.StartSolid,
        AllSolid = a1.AllSolid,
        PlaneId = a1.PlaneId,
        SourceId = a1.SourceId,
        Kind = a1.Kind,
        DestructibleIndex = a1.DestructibleIndex,
        ElementId = a1.ElementId,
        SurfaceFriction = a1.SurfaceFriction,
        ResolvedPosition = a1.ResolvedPosition,
        PenetrationDepth = a1.PenetrationDepth,
        SourceShape = a1.SourceShape,
        MinkowskiPlaneKind = a1.MinkowskiPlaneKind,
        RecordType = a1.RecordType,
        Climbable = a1.Climbable,
        BuildMode = a1.BuildMode,
        SourceCFrame = a1.SourceCFrame,
        SourceSize = a1.SourceSize,
        Planes = a1.Planes,
    }
end

local function sweepResult(a1) -- Line: 182 -- types: a1: table?
    if a1 == nil then
        return {Fraction = 1, Normal = Vector3.new(0, 1, 0), StartSolid = false, AllSolid = false}
    end
    return {
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
        SurfaceVelocity = a1.SurfaceVelocity,
        ResolvedPosition = a1.ResolvedPosition,
        PenetrationDepth = a1.PenetrationDepth,
    }
end

local function ignoredMover(a1, a2) -- Line: 214 -- upvalues: Enums (val)
    local v1 = false
    if a2 ~= nil then
        v1 = false
        if a2.Kind == Enums.SupportKind.Mover then
            v1 = a2.SourceId == a1.Id
        end
    end
    return v1
end

local function assertCurrentPoseInterval(a1, a2) -- Line: 220 -- types: a1: number, a2: number
    local v1 = false
    if a1 == 1 then
        v1 = a2 == 1
    end
    assert(v1, "mover collision supports only the committed current-pose time fraction 1")
end

function u38.new(a1, a2, a3) -- Line: 227 -- upvalues: u38 (val) -- types: a3: table
    assert(table.isfrozen(a1), "static collision world must be immutable")
    assert(table.isfrozen(a2) and table.isfrozen(a2.Records) and table.isfrozen(a2.ById), "mover frame must be immutable")
    for i, j in a2.Records do
        assert(table.isfrozen(j), "mover frame contains a mutable record")
    end
    local v1 = false
    if a3 ~= nil then
        v1 = a3.Cache ~= nil
    end
    assert(v1, "mover world requires an instance-owned proxy cache")
    local Cache = a3.Cache
    Cache:BeginComposition()
    v1 = table.create(#a2.Records)
    for k, n in a2.Records do
        v1[k] = (Cache:BindEndpoint(n, a1.Topology.Config))
    end
    table.freeze(v1)
    return (table.freeze((setmetatable({Static = a1, Movers = a2, EndpointMovers = v1, Config = a1.Topology.Config}, u38))))
end

function u38:SweepMoversDetailed(a2, a3, a4, a5, a6, a7) -- Line: 252
    -- upvalues: Geometry (val), Enums (val), MoverProxyCache (val), endpointDetailed (val), shouldReplace (val)
    local v1, v2, v3, v4, v5, v6
    if not Geometry.IsFiniteVector3(a2) then
        error(string.format("%s must be a finite Vector3", "mover sweep start"))
    end
    if not Geometry.IsFiniteVector3(a3) then
        error(string.format("%s must be a finite Vector3", "mover sweep end"))
    end
    local v7 = false
    if typeof(a6) == "number" then
        v7 = false
        if a6 == a6 then
            v7 = false
            if a6 > (-1 / 0) then
                v7 = a6 < (1 / 0)
            end
        end
    end
    if v7 then
        v7 = false
        if a6 >= 0 then
            v7 = a6 <= 1
        end
    end
    assert(v7, "collision time fraction must be normalized")
    v7 = false
    if typeof(a7) == "number" then
        v7 = false
        if a7 == a7 then
            v7 = false
            if a7 > (-1 / 0) then
                v7 = a7 < (1 / 0)
            end
        end
    end
    if v7 then
        v7 = false
        if a7 >= 0 then
            v7 = a7 <= 1
        end
    end
    assert(v7, "collision time fraction must be normalized")
    assert(a6 <= a7, "collision time interval is reversed")
    v7 = false
    if a6 == 1 then
        v7 = a7 == 1
    end
    assert(v7, "mover collision supports only the committed current-pose time fraction 1")
    local v8 = a3 - a2
    v7 = nil
    local v9 = nil
    local v10 = nil
    local v11 = a5
    for i, j in self.EndpointMovers, v9, v10 do
        v1 = false
        if v11 ~= nil then
            v1 = false
            if v11.Kind == Enums.SupportKind.Mover then
                v1 = v11.SourceId == j.Record.Id
            end
        end
        if not v1 then
            v1, v2, v3, v4, v5 = MoverProxyCache.SweepEndpoint(j, v12, v13, v14, v15.Config)
            if v1 ~= nil then
                v6 = endpointDetailed(j, v12, v13, v1, v2, v3, v4, v5)
                if shouldReplace(v7, v6, v8) then
                    v7 = v6
                end
            end
        end
    end
    return v7
end

function u38:SweepDetailed(a2, a3, a4, a5, a6, a7) -- Line: 284
    -- upvalues: Geometry (val), staticDetailed (val), shouldReplace (val)
    if not Geometry.IsFiniteVector3(a2) then
        error(string.format("%s must be a finite Vector3", "composite sweep start"))
    end
    if not Geometry.IsFiniteVector3(a3) then
        error(string.format("%s must be a finite Vector3", "composite sweep end"))
    end
    local v1 = false
    if typeof(a6) == "number" then
        v1 = false
        if a6 == a6 then
            v1 = false
            if a6 > (-1 / 0) then
                v1 = a6 < (1 / 0)
            end
        end
    end
    if v1 then
        v1 = false
        if a6 >= 0 then
            v1 = a6 <= 1
        end
    end
    assert(v1, "collision time fraction must be normalized")
    v1 = false
    if typeof(a7) == "number" then
        v1 = false
        if a7 == a7 then
            v1 = false
            if a7 > (-1 / 0) then
                v1 = a7 < (1 / 0)
            end
        end
    end
    if v1 then
        v1 = false
        if a7 >= 0 then
            v1 = a7 <= 1
        end
    end
    assert(v1, "collision time fraction must be normalized")
    assert(a6 <= a7, "collision time interval is reversed")
    local v2 = a3 - a2
    v1 = self.Static:SweepDetailed(a2, a3, a4, a5, a6, a7)
    local v3 = if v1 == nil then nil else staticDetailed(v1)
    local v4 = self:SweepMoversDetailed(a2, a3, a4, a5, a6, a7)
    if v4 ~= nil and shouldReplace(v3, v4, v2) then
        v3 = v4
    end
    return v3
end

function u38.Sweep(a1, a2, a3, a4, a5, a6, a7) -- Line: 308
    -- upvalues: sweepResult (val)
    return (sweepResult(a1:SweepDetailed(a2, a3, a4, a5, a6, a7)))
end

function u38:SweepWithFloorSupportDetailed(a2, a3, a4, a5, a6, a7) -- Line: 322
    -- upvalues: Geometry (val), staticDetailed (val), shouldReplace (val)
    if not Geometry.IsFiniteVector3(a2) then
        error(string.format("%s must be a finite Vector3", "composite floor sweep start"))
    end
    if not Geometry.IsFiniteVector3(a3) then
        error(string.format("%s must be a finite Vector3", "composite floor sweep end"))
    end
    local v1 = false
    if typeof(a6) == "number" then
        v1 = false
        if a6 == a6 then
            v1 = false
            if a6 > (-1 / 0) then
                v1 = a6 < (1 / 0)
            end
        end
    end
    if v1 then
        v1 = false
        if a6 >= 0 then
            v1 = a6 <= 1
        end
    end
    assert(v1, "collision time fraction must be normalized")
    v1 = false
    if typeof(a7) == "number" then
        v1 = false
        if a7 == a7 then
            v1 = false
            if a7 > (-1 / 0) then
                v1 = a7 < (1 / 0)
            end
        end
    end
    if v1 then
        v1 = false
        if a7 >= 0 then
            v1 = a7 <= 1
        end
    end
    assert(v1, "collision time fraction must be normalized")
    assert(a6 <= a7, "collision time interval is reversed")
    local v2 = a3 - a2
    v1 = self.Static:SweepWithFloorSupportDetailed(a2, a3, a4, a5, a6, a7)
    local v3 = if v1 == nil then nil else staticDetailed(v1)
    local v4 = self:SweepMoversDetailed(a2, a3, a4, a5, a6, a7)
    if v4 ~= nil and shouldReplace(v3, v4, v2) then
        v3 = v4
    end
    return v3
end

function u38.SweepWithFloorSupport(a1, a2, a3, a4, a5, a6, a7) -- Line: 352
    -- upvalues: sweepResult (val)
    return (sweepResult(a1:SweepWithFloorSupportDetailed(a2, a3, a4, a5, a6, a7)))
end

local function moversAreClear(a1, a2, a3) -- Line: 373 -- upvalues: MoverProxyCache (val) -- types: a2: vector
    for i, j in a1.EndpointMovers do
        if MoverProxyCache.ContainsEndpoint(j, a2, a3, a1.Config) then
            return false
        end
    end
    return true
end

function u38:IsClear(a2, a3, a4) -- Line: 382
    -- upvalues: Geometry (val), moversAreClear (val)
    if not Geometry.IsFiniteVector3(a2) then
        error(string.format("%s must be a finite Vector3", "composite clearance position"))
    end
    local v1 = false
    if typeof(a4) == "number" then
        v1 = false
        if a4 == a4 then
            v1 = false
            if a4 > (-1 / 0) then
                v1 = a4 < (1 / 0)
            end
        end
    end
    if v1 then
        v1 = false
        if a4 >= 0 then
            v1 = a4 <= 1
        end
    end
    assert(v1, "collision time fraction must be normalized")
    v1 = false
    if a4 == 1 then
        v1 = a4 == 1
    end
    assert(v1, "mover collision supports only the committed current-pose time fraction 1")
    return self.Static:IsClear(a2, a3, a4) and moversAreClear(self, a2, a3)
end

function u38.CanMove(a1, a2, a3, a4, a5, a6, a7) -- Line: 389
    -- upvalues: Geometry (val), shouldReplace (val)
    local v1
    if not Geometry.IsFiniteVector3(a2) then
        error(string.format("%s must be a finite Vector3", "composite sweep start"))
    end
    if not Geometry.IsFiniteVector3(a3) then
        error(string.format("%s must be a finite Vector3", "composite sweep end"))
    end
    local v2 = false
    if typeof(a6) == "number" then
        v2 = false
        if a6 == a6 then
            v2 = false
            if a6 > (-1 / 0) then
                v2 = a6 < (1 / 0)
            end
        end
    end
    if v2 then
        v2 = false
        if a6 >= 0 then
            v2 = a6 <= 1
        end
    end
    assert(v2, "collision time fraction must be normalized")
    v2 = false
    if typeof(a7) == "number" then
        v2 = false
        if a7 == a7 then
            v2 = false
            if a7 > (-1 / 0) then
                v2 = a7 < (1 / 0)
            end
        end
    end
    if v2 then
        v2 = false
        if a7 >= 0 then
            v2 = a7 <= 1
        end
    end
    assert(v2, "collision time fraction must be normalized")
    assert(a6 <= a7, "collision time interval is reversed")
    local v3 = a1.Static:SweepDetailed(a2, a3, a4, a5, a6, a7)
    v2 = a1:SweepMoversDetailed(a2, a3, a4, a5, a6, a7)
    local v4 = v3
    if v2 ~= nil and shouldReplace(v3, v2, a3 - a2) then
        v4 = v2
    end
    if v4 == nil then
        v1 = a1:IsClear(a3, a4, a7)
    else
        v1 = not v4.StartSolid
        if v1 then
            v1 = false
            if 1 <= v4.Fraction then
                v1 = a1:IsClear(a3, a4, a7)
            end
        end
    end
    return v1
end

local function groundIdentityLess(a1, a2, a3) -- Line: 414 -- types: a1: number, a2: number
    if a2 ~= a3.Support.SourceId then
        return a2 < a3.Support.SourceId
    end
    return a1 < a3.Support.Kind
end

function u38:FindGround(a2, a3, a4, a5, a6) -- Line: 421
    -- upvalues: Geometry (val), MoverProxyCache (val), Enums (val), MoverFrame (val), moversAreClear (val)
    local Id, Mover, Record, v1, v2, v3, v4, v5, v6
    if not Geometry.IsFiniteVector3(a2) then
        error(string.format("%s must be a finite Vector3", "composite ground position"))
    end
    local v7 = false
    if typeof(a5) == "number" then
        v7 = false
        if a5 == a5 then
            v7 = false
            if a5 > (-1 / 0) then
                v7 = a5 < (1 / 0)
            end
        end
    end
    if v7 then
        v7 = false
        if a5 >= 0 then
            v7 = a5 <= 1
        end
    end
    assert(v7, "collision time fraction must be normalized")
    v7 = false
    if a5 == 1 then
        v7 = a5 == 1
    end
    assert(v7, "mover collision supports only the committed current-pose time fraction 1")
    v7 = false
    if typeof(a4) == "number" then
        v7 = false
        if a4 == a4 then
            v7 = false
            if a4 > (-1 / 0) then
                v7 = a4 < (1 / 0)
            end
        end
    end
    if v7 then
        v7 = false
        if a4 >= 0 then
            v7 = a4 <= self.Config.MaxSweepDistance
        end
    end
    assert(v7, "invalid ground distance")
    local v8 = self.Static:FindGround(a2, a3, a4, a5, a6)
    v7 = v8
    local v9 = if v7 == nil then (1 / 0) else a2.Y - v7.Position.Y
    local v10 = a2 + Vector3.new(0, math.min(self.Config.GroundProbeStartBump, self.Config.MaxSweepDistance - a4), 0)
    local v11 = a2 - Vector3.new(0, math.min(a4 + self.Config.ContactEpsilon, self.Config.MaxSweepDistance), 0)
    local EndpointMovers = self.EndpointMovers
    local v12 = nil
    local v13 = nil
    local v14, v15, v16, v17 = self, a3, a5, a2
    for i, j in EndpointMovers, v12, v13 do
        v1, v2, v3 = MoverProxyCache.SweepEndpoint(j, v10, v11, v15, v14.Config)
        if v1 ~= nil and not v3 and not (v2.Y < v14.Config.WalkableFloor) then
            v4 = v10:Lerp(v11, v1)
            v5 = v17.Y - v4.Y
            Record = j.Record
            v6 = true
            if v7 ~= nil then
                v6 = v5 < v9 - v14.Config.HitTieDistance
            end
            if not v6 and v7 ~= nil and (math.abs(v5 - v9)) <= v14.Config.HitTieDistance then
                if not (1e-09 < (math.abs(v2.Y - v7.Normal.Y))) then
                    Mover = Enums.SupportKind.Mover
                    Id = Record.Id
                    v6 = if Id == v7.Support.SourceId then Mover < v7.Support.Kind else Id < v7.Support.SourceId
                else
                    v6 = v7.Normal.Y < v2.Y
                end
            end
            if v6 then
                v7 = {
                    Position = v4,
                    Normal = v2,
                    SurfaceFriction = Record.SurfaceFriction,
                    Support = {
                        Kind = Enums.SupportKind.Mover,
                        SourceId = Record.Id,
                        Anchor = Record.CFrame:PointToObjectSpace(v4),
                        Velocity = MoverFrame.VelocityAtPoint(Record, v4, 1),
                    },
                }
            end
        end
    end
    if v7 ~= nil then
        if v7 ~= v8 and not v14.Static:IsClear(v7.Position, v15, v16) then
            return nil
        end
        if not moversAreClear(v14, v7.Position, v15) then
            return nil
        end
    end
    return v7
end

function u38:FindLadder(a2, a3, a4, a5) -- Line: 488 -- types: a2: vector, a4: number, a5: number
    local v1 = false
    if a5 == 1 then
        v1 = a5 == 1
    end
    assert(v1, "mover collision supports only the committed current-pose time fraction 1")
    return self.Static:FindLadder(a2, a3, a4, a5)
end

function u38.FindMoverPush(a1, a2, a3, a4, a5) -- Line: 501
    -- upvalues: Geometry (val), MoverProxyCache (val)
    local Magnitude_2, Record, v1, v2, v3, v4, v5, v6
    if not Geometry.IsFiniteVector3(a2) then
        error(string.format("%s must be a finite Vector3", "mover push position"))
    end
    local DuckingHalfSize = if a3 ~= "Ducking" then a1.Config.StandingHalfSize else a1.Config.DuckingHalfSize
    for i, j in a1.EndpointMovers do
        Record = j.Record
        if not (Record.Id <= a4) and Record.Pushes and Record.PreviousCFrame ~= Record.CFrame then
            v1 = Record.BoundingRadius + DuckingHalfSize.Magnitude
            v2 = a2 - Record.CFrame.Position
            v3 = v2:Dot(v2)
            if not (v1 * v1 < v3) then
                v3 = (Record.CFrame * Record.PreviousCFrame:Inverse()):PointToWorldSpace(a2) - a2
                Magnitude_2 = v3.Magnitude
                if not (Magnitude_2 <= a1.Config.ContactEpsilon) then
                    v4 = v3 / Magnitude_2
                    v5, v6 = MoverProxyCache.PushExitDistances(j, a2, v4, a3, a1.Config, a5)
                    if v5 ~= nil and v5 ~= (1 / 0) and not (v6 < v5) then
                        return Record.Id, v4 * math.max(Magnitude_2, v5)
                    end
                end
            end
        end
    end
    return nil, (Vector3.new(0, 0, 0))
end

function u38.PenetratesMover(a1, a2, a3, a4) -- Line: 536
    -- upvalues: MoverProxyCache (val)
    for i, j in a1.EndpointMovers do
        if j.Record.Id == a2 then
            return MoverProxyCache.PenetratesEndpoint(j, a3, a4, a1.Config)
        end
    end
    return false
end

function u38:SetMovementBounds(a2, a3) -- Line: 545 -- types: a2: vector, a3: vector
    self.Static:SetMovementBounds(a2, a3)
end

function u38:ClearMovementBounds() -- Line: 549
    self.Static:ClearMovementBounds()
end

return table.freeze(u38)