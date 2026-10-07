-- ReplicatedStorage.MovementV2.Collision.MoverProxyCache
-- Script path: ReplicatedStorage.MovementV2.Collision.MoverProxyCache
-- Decompile time: 14.49 ms

local u0 = {}
u0.__index = u0
u0.ContactMaxRotationRadiansPerSubdivision = 0.008726646259971648
u0.ContactMaxRotationSubdivisions = 16
u0.ContactMaxRotationRadiansPerTick = u0.ContactMaxRotationRadiansPerSubdivision * u0.ContactMaxRotationSubdivisions
local u11 = table.freeze({Vector3.new(1, 0, 0), Vector3.new(0, 1, 0), (Vector3.new(0, 0, 1))})

local function newContactHull() -- Line: 103
    return {
        Center = Vector3.new(0, 0, 0),
        SourceWorldHalf = Vector3.new(0, 0, 0),
        RotationPadding = 0,
        NormalCount = 0,
        Normals = table.create(30, (Vector3.new(0, 0, 0))),
        SourceSupports = table.create(30, 0),
    }
end

local function newContactProxy() -- Line: 114 -- upvalues: u0 (val), newContactHull (val)
    local v1
    local v2 = table.create(u0.ContactMaxRotationSubdivisions)
    local ContactMaxRotationSubdivisions = u0.ContactMaxRotationSubdivisions
    for i = 1, ContactMaxRotationSubdivisions do
        v1 = {
            TimeStart = 0,
            TimeEnd = 0,
            ReferenceCenter = Vector3.new(0, 0, 0),
            Hull = newContactHull(),
        }
        v2[i] = v1
    end
    return {
        SubstepCount = 0,
        ScratchCount = 0,
        StartHull = newContactHull(),
        EndHull = newContactHull(),
        Substeps = v2,
        ScratchDirections = table.create(30, (Vector3.new(0, 0, 0))),
    }
end

local function directionLess(a1, a2) -- Line: 138 -- types: a1: vector, a2: vector
    if a1.X ~= a2.X then
        return a1.X < a2.X
    end
    if a1.Y ~= a2.Y then
        return a1.Y < a2.Y
    end
    return a1.Z < a2.Z
end

local function appendDirection(a1, a2, a3) -- Line: 148 -- types: a1: table, a2: vector
    local Magnitude = a2.Magnitude
    if Magnitude <= a3.PlaneNormalEpsilon then
        return
    end
    local v1 = a2 / Magnitude
    local ScratchCount = a1.ScratchCount
    for i = 1, ScratchCount do
        if a3.PlaneDuplicateDot <= (a1.ScratchDirections[i]:Dot(v1)) then
            return
        end
    end
    local v2 = a1.ScratchCount + 1
    assert(v2 <= 30, "mover contact SAT direction capacity exceeded")
    a1.ScratchDirections[v2] = v1
    a1.ScratchCount = v2
end

local function appendBothDirections(a1, a2, a3) -- Line: 165
    -- upvalues: appendDirection (val)
    appendDirection(a1, a2, a3)
    appendDirection(a1, -a2, a3)
end

local function sortScratchDirections(a1) -- Line: 170 -- types: a1: table
    local v1, v2, v3
    local v4 = a1
    for i = 2, a1.ScratchCount do
        v1 = v4.ScratchDirections[i]
        v2 = i
        while v2 > 1 do
            v3 = v4.ScratchDirections[v2 - 1]
            if not (if v1.X == v3.X then if v1.Y == v3.Y then v1.Z < v3.Z else v1.Y < v3.Y else v1.X < v3.X) then
                break
            end
            v4.ScratchDirections[v2] = v4.ScratchDirections[v2 - 1]
            v2 = v2 - 1
        end
        v4.ScratchDirections[v2] = v1
    end
end

local function prepareHull(a1, a2, a3, a4, a5, a6) -- Line: 183
    -- upvalues: u11 (val), appendDirection (val), sortScratchDirections (val)
    local SourceSupports, v1, v2, v3, v4
    a1.ScratchCount = 0
    for i, j in u11 do
        appendDirection(a1, j, a6)
        appendDirection(a1, -j, a6)
    end
    local RightVector = a4.RightVector
    local UpVector = a4.UpVector
    local LookVector = a4.LookVector
    appendDirection(a1, RightVector, a6)
    appendDirection(a1, -RightVector, a6)
    for k, n in u11 do
        v2 = RightVector:Cross(n)
        appendDirection(a1, v2, a6)
        appendDirection(a1, -v2, a6)
    end
    appendDirection(a1, UpVector, a6)
    appendDirection(a1, -UpVector, a6)
    for m, i5 in u11 do
        v2 = UpVector:Cross(i5)
        appendDirection(a1, v2, a6)
        appendDirection(a1, -v2, a6)
    end
    appendDirection(a1, LookVector, a6)
    appendDirection(a1, -LookVector, a6)
    for i6, i7 in u11 do
        v2 = LookVector:Cross(i7)
        appendDirection(a1, v2, a6)
        appendDirection(a1, -v2, a6)
    end
    sortScratchDirections(a1)
    local v5 = a3.Size * 0.5
    local ScratchCount = a1.ScratchCount
    for i8 = 1, ScratchCount do
        v1 = a1.ScratchDirections[i8]
        a2.Normals[i8] = v1
        SourceSupports = a2.SourceSupports
        v3 = (math.abs((v1:Dot(RightVector)))) * v5.X + (math.abs((v1:Dot(UpVector)))) * v5.Y
        v4 = math.abs((v1:Dot(LookVector)))
        SourceSupports[i8] = v3 + v4 * v5.Z
    end
    a2.NormalCount = a1.ScratchCount
    a2.Center = a4.Position
    a2.RotationPadding = a5
    a2.SourceWorldHalf = Vector3.new(
        (math.abs(RightVector.X)) * v5.X + (math.abs(UpVector.X)) * v5.Y + (math.abs(LookVector.X)) * v5.Z,
        (math.abs(RightVector.Y)) * v5.X + (math.abs(UpVector.Y)) * v5.Y + (math.abs(LookVector.Y)) * v5.Z,
        (math.abs(RightVector.Z)) * v5.X + (math.abs(UpVector.Z)) * v5.Y + (math.abs(LookVector.Z)) * v5.Z
    )
end

local function playerHalfSize(a1, a2) -- Line: 236 -- types: a2: string
    if a2 == "Standing" then
        return a1.StandingHalfSize
    end
    if a2 == "Ducking" then
        return a1.DuckingHalfSize
    end
    error("contact mover body has an invalid stance", 3)
end

function u0.ContactQueryBounds(a1, a2, a3, a4) -- Line: 247 -- types: a1: userdata, a2: userdata, a3: vector
    local v1 = math.max(a4.StandingHalfSize.Magnitude, a4.DuckingHalfSize.Magnitude)
    local v2 = (math.max(a4.ContactEpsilon, a4.BrushEpsilon)) + a4.BroadphasePadding
    local v3 = (a3 * 0.5).Magnitude + v1 + v2
    local v4 = Vector3.new(v3, v3, v3)
    local Position = a1.Position
    local Position_2 = a2.Position
    return Vector3.new(math.min(Position.X, Position_2.X), math.min(Position.Y, Position_2.Y), (math.min(Position.Z, Position_2.Z))) - v4, Vector3.new(math.max(Position.X, Position_2.X), math.max(Position.Y, Position_2.Y), (math.max(Position.Z, Position_2.Z))) + v4
end

local function planeDistance(a1, a2, a3) -- Line: 272 -- types: a1: table, a2: number, a3: vector
    local v1 = a1.Normals[a2]
    return (a1.Center:Dot(v1)) + a1.SourceSupports[a2] + (math.abs(v1.X)) * a3.X + (math.abs(v1.Y)) * a3.Y + (math.abs(v1.Z)) * a3.Z + a1.RotationPadding
end

local function containsHull(a1, a2, a3, a4) -- Line: 282
    -- upvalues: planeDistance (val)
    local v1
    local v2 = math.max(a4.ContactEpsilon, a4.BrushEpsilon)
    local NormalCount = a1.NormalCount
    for i = 1, NormalCount do
        v1 = (a2:Dot(a1.Normals[i])) - planeDistance(a1, i, a3)
        if -v2 <= v1 then
            return false
        end
    end
    return true
end

local function maximumHullDistance(a1, a2, a3) -- Line: 293
    -- upvalues: planeDistance (val)
    local v1, v2
    local v3 = (-1 / 0)
    local v4 = Vector3.new(0, 1, 0)
    local NormalCount = a1.NormalCount
    local v5, v6, v7 = a1, a2, a3
    for i = 1, NormalCount do
        v1 = v5.Normals[i]
        v2 = (v6:Dot(v1)) - planeDistance(v5, i, v7)
        if v3 < v2 then
            v3 = v2
            v4 = v1
        end
    end
    return v3, v4
end

local function pointSegmentDistanceSquared(a1, a2, a3) -- Line: 307 -- types: a1: vector, a2: vector, a3: vector
    local v1 = a3 - a2
    local v2 = v1:Dot(v1)
    if v2 <= 1e-18 then
        local v3 = a1 - a2
        return v3:Dot(v3)
    end
    local v4 = a1 - (a2 + v1 * math.clamp((a1 - a2):Dot(v1) / v2, 0, 1))
    return v4:Dot(v4)
end

local function couldReachAnyBody(a1, a2, a3) -- Line: 320
    -- upvalues: pointSegmentDistanceSquared (val)
    local BoundingRadius, Stance, StandingHalfSize, v1
    local Position = a1.PreviousCFrame.Position
    local Position_2 = a1.CFrame.Position
    local v2 = (math.max(a3.ContactEpsilon, a3.BrushEpsilon)) + a3.BroadphasePadding
    local v3 = nil
    local v4 = nil
    local v5, v6 = a1, a3
    for i, j in a2, v3, v4 do
        BoundingRadius = v5.BoundingRadius
        Stance = j.Stance
        if Stance == "Standing" then
            StandingHalfSize = v6.StandingHalfSize
        elseif Stance ~= "Ducking" then
            error("contact mover body has an invalid stance", 3)
            StandingHalfSize = nil
        else
            StandingHalfSize = v6.DuckingHalfSize
        end
        v1 = BoundingRadius + StandingHalfSize.Magnitude + v2
        if (pointSegmentDistanceSquared(j.Position, Position, Position_2)) <= v1 * v1 then
            return true
        end
    end
    return false
end

local function boundsOverlapHull(a1, a2, a3, a4, a5) -- Line: 333
    -- upvalues: 
    local v1 = a1.RotationPadding + a5
    local v2 = a1.SourceWorldHalf + a4 + Vector3.new(v1, v1, v1)
    local v3 = a1.Center - v2
    local v4 = a1.Center + v2
    local v5 = false
    if (math.min(a2.X, a3.X)) <= v4.X then
        v5 = false
        if v3.X <= (math.max(a2.X, a3.X)) then
            v5 = false
            if (math.min(a2.Y, a3.Y)) <= v4.Y then
                v5 = false
                if v3.Y <= (math.max(a2.Y, a3.Y)) then
                    v5 = false
                    if (math.min(a2.Z, a3.Z)) <= v4.Z then
                        v5 = v3.Z <= (math.max(a2.Z, a3.Z))
                    end
                end
            end
        end
    end
    return v5
end

local function sweepHull(a1, a2, a3, a4, a5, a6) -- Line: 353
    -- upvalues: boundsOverlapHull (val), planeDistance (val)
    local v1, v2, v3, v4, v5, v6, v7, v8
    if not boundsOverlapHull(a1, a2, a3, a4, a5.BroadphasePadding) then
        return nil, Vector3.new(0, 1, 0), false, false, 0
    end
    local v9 = a3 - a2
    local Magnitude = v9.Magnitude
    local v10 = -1
    local v11 = 1
    local v12 = false
    local v13 = false
    local v14 = (-1 / 0)
    local v15 = (-1 / 0)
    local v16 = Vector3.new(0, 1, 0)
    local v17 = (1 / 0)
    local v18 = false
    local v19 = Vector3.new(0, 1, 0)
    local v20 = (1 / 0)
    local NormalCount = a1.NormalCount
    local v21, v22, v23 = a1, a2, a4
    for i = 1, NormalCount do
        v4 = v21.Normals[i]
        v5 = (v22:Dot(v4)) - planeDistance(v21, i, v23)
        v6 = v5 + v9:Dot(v4)
        if v14 + a5.BrushEpsilon < v5 or (math.abs(v5 - v14)) <= a5.BrushEpsilon and i < v17 then
            v16 = v4
            v17 = i
        end
        v14 = math.max(v14, v5)
        v15 = math.max(v15, v6)
        v12 = v12 or v5 > 0
        v7 = v13 or v6 > 0
        v13 = v7
        if v5 > 0 and v6 > 0 then
            return nil, Vector3.new(0, 1, 0), false, false, 0
        end
        if v5 > 0 or v6 > 0 then
            if not (v6 < v5) then
                v11 = math.min(v11, (math.min(1, (v5 + a5.BrushEpsilon) / (v5 - v6))))
            else
                v7 = math.max(0, (v5 - a5.BrushEpsilon) / (v5 - v6))
                v8 = math.abs(v7 - v10) * Magnitude
                if not v18 then
                    v19 = v4
                    v20 = i
                elseif not (a5.BrushEpsilon < v8) then
                    if v8 <= a5.BrushEpsilon and i < v20 then
                        v19 = v4
                        v20 = i
                    end
                elseif v10 < v7 or v8 <= a5.BrushEpsilon and i < v20 then
                    v19 = v4
                    v20 = i
                end
                v10 = math.max(v10, v7)
                v18 = true
            end
        end
    end
    if v12 then
        if v18 and not (v10 < 0) and not (v11 <= v10) then
            return (math.max(0, v10)), v19, false, false, v20
        end
        return nil, Vector3.new(0, 1, 0), false, false, 0
    end
    if not v13 and a6 ~= true then
        v1 = 0
        v2 = v16
        v3 = true
        v4 = not v13 and v15 < v14
        if v17 < (1 / 0) then
            return v1, v2, v3, v4, v17
        end
        return v1, v2, v3, v4, 0
    end
    if v14 < v15 and a5.ContactEpsilon < Magnitude and 0.25 < (v9.Unit:Dot(v16)) then
        return nil, Vector3.new(0, 1, 0), false, false, 0
    end
    v1 = 0
    v2 = v16
    v3 = true
    v4 = not v13 and v15 < v14
    if v17 < (1 / 0) then
        return v1, v2, v3, v4, v17
    end
    return v1, v2, v3, v4, 0
end

local function prepareContactProxy(a1, a2, a3) -- Line: 440
    -- upvalues: u0 (val), prepareHull (val)
    local v1, v2, v3, v4, v5
    if a1.PreviousPose == a2.PreviousCFrame and a1.Pose == a2.CFrame and a1.Size == a2.Size and a1.Config == a3 then
        return
    end
    local v6 = math.abs(a2.RotationAngle)
    if u0.ContactMaxRotationRadiansPerTick + 1e-09 < v6 then
        error(string.format(
            "contact mover %d rotates %.4f degrees in one tick; authored maximum is %.4f",
            a2.Id,
            math.deg(v6),
            (math.deg(u0.ContactMaxRotationRadiansPerTick))
        ), 3)
    end
    local v7 = math.max(1, (math.ceil(v6 / u0.ContactMaxRotationRadiansPerSubdivision - 1e-12)))
    assert(v7 <= u0.ContactMaxRotationSubdivisions, "contact mover subdivision capacity exceeded")
    a1.SubstepCount = v7
    prepareHull(a1, a1.StartHull, a2, a2.PreviousCFrame, 0, a3)
    prepareHull(a1, a1.EndHull, a2, a2.CFrame, 0, a3)
    for i = 1, v7 do
        v4 = (i - 1) / v7
        v5 = i / v7
        v1 = a2.PreviousCFrame:Lerp(a2.CFrame, (v4 + v5) * 0.5)
        v2 = v6 / v7
        v3 = a1.Substeps[i]
        v3.TimeStart = v4
        v3.TimeEnd = v5
        v3.ReferenceCenter = v1.Position
        prepareHull(a1, v3.Hull, a2, v1, a2.BoundingRadius * 2 * math.sin(v2 * 0.25), a3)
    end
    a1.PreviousPose = a2.PreviousCFrame
    a1.Pose = a2.CFrame
    a1.Size = a2.Size
    a1.Config = a3
end

function u0.new() -- Line: 495 -- upvalues: u0 (val)
    return (setmetatable({
        _activeBank = 0,
        _banks = {{EndpointsById = {}}, {EndpointsById = {}}},
        _contactById = {},
        _endpointScratch = {ScratchCount = 0, ScratchDirections = table.create(30, (Vector3.new(0, 0, 0)))},
    }, u0))
end

function u0.BeginComposition(a1) -- Line: 510
    a1._activeBank = if a1._activeBank ~= 1 then 1 else 2
end

function u0:ReserveMover(a2) -- Line: 514 -- upvalues: newContactHull (val) -- types: a2: number
    local v1 = false
    if a2 % 1 == 0 then
        v1 = a2 > 0
    end
    assert(v1, "mover ID must be a positive integer")
    if self._banks[1].EndpointsById[a2] ~= nil then
        assert(self._banks[2].EndpointsById[a2] ~= nil, "mover endpoint proxy banks diverged")
        return
    end
    for i, j in self._banks do
        j.EndpointsById[a2] = {Hull = newContactHull()}
    end
end

function u0.ReserveContactMover(a1, a2) -- Line: 531 -- upvalues: newContactProxy (val) -- types: a2: number
    a1:ReserveMover(a2)
    if a1._contactById[a2] == nil then
        a1._contactById[a2] = (newContactProxy())
    end
end

function u0.BindEndpoint(a1, a2, a3) -- Line: 538 -- upvalues: prepareHull (val) -- types: a2: table
    assert(a1._activeBank ~= 0, "mover proxy cache composition was not begun")
    local v1 = a1._banks[a1._activeBank].EndpointsById[a2.Id]
    if v1 == nil then
        error(string.format("mover %d endpoint proxy was not reserved at registration", a2.Id), 2)
    end
    if v1.Pose ~= a2.CFrame or v1.Size ~= a2.Size or v1.Config ~= a3 then
        prepareHull(a1._endpointScratch, v1.Hull, a2, a2.CFrame, 0, a3)
        v1.Pose = a2.CFrame
        v1.Size = a2.Size
        v1.Config = a3
    end
    v1.Record = a2
    return v1
end

function u0.SweepEndpoint(a1, a2, a3, a4, a5) -- Line: 554
    -- upvalues: sweepHull (val)
    local StandingHalfSize
    local Hull = a1.Hull
    if a4 == "Standing" then
        StandingHalfSize = a5.StandingHalfSize
    elseif a4 ~= "Ducking" then
        error("contact mover body has an invalid stance", 3)
        StandingHalfSize = nil
    else
        StandingHalfSize = a5.DuckingHalfSize
    end
    return sweepHull(Hull, a2, a3, StandingHalfSize, a5, true)
end

function u0.ContainsEndpoint(a1, a2, a3, a4) -- Line: 565
    -- upvalues: containsHull (val)
    local StandingHalfSize
    local Hull = a1.Hull
    if a3 == "Standing" then
        StandingHalfSize = a4.StandingHalfSize
    elseif a3 ~= "Ducking" then
        error("contact mover body has an invalid stance", 3)
        StandingHalfSize = nil
    else
        StandingHalfSize = a4.DuckingHalfSize
    end
    return (containsHull(Hull, a2, StandingHalfSize, a4))
end

function u0.PenetratesEndpoint(a1, a2, a3, a4) -- Line: 575
    -- upvalues: planeDistance (val)
    local StandingHalfSize
    local Hull = a1.Hull
    if a3 == "Standing" then
        StandingHalfSize = a4.StandingHalfSize
    elseif a3 ~= "Ducking" then
        error("contact mover body has an invalid stance", 3)
        StandingHalfSize = nil
    else
        StandingHalfSize = a4.DuckingHalfSize
    end
    local NormalCount = Hull.NormalCount
    for i = 1, NormalCount do
        if 0 < (a2:Dot(Hull.Normals[i])) - planeDistance(Hull, i, StandingHalfSize) then
            return false
        end
    end
    return true
end

function u0.PushExitDistances(a1, a2, a3, a4, a5, a6) -- Line: 592
    -- upvalues: planeDistance (val)
    local StandingHalfSize, v1, v2, v3
    local Hull = a1.Hull
    if a4 == "Standing" then
        StandingHalfSize = a5.StandingHalfSize
    elseif a4 ~= "Ducking" then
        error("contact mover body has an invalid stance", 3)
        StandingHalfSize = nil
    else
        StandingHalfSize = a5.DuckingHalfSize
    end
    local v4 = (1 / 0)
    local v5 = (1 / 0)
    local NormalCount = Hull.NormalCount
    local v6, v7, v8, v9 = a2, a3, a5, a6
    for i = 1, NormalCount do
        v1 = Hull.Normals[i]
        v2 = (v6:Dot(v1)) - planeDistance(Hull, i, StandingHalfSize)
        if v2 > 0 then
            return nil, (1 / 0)
        end
        v3 = v7:Dot(v1)
        if v8.PlaneNormalEpsilon < v3 then
            v4 = math.min(v4, (v9 - v2) / v3)
        elseif v3 < -v8.PlaneNormalEpsilon then
            v5 = math.min(v5, (v9 - v2) / -v3)
        end
    end
    return v4, v5
end

function u0.Retire(a1, a2) -- Line: 619 -- types: a2: number
    for i, j in a1._banks do
        j.EndpointsById[a2] = nil
    end
    a1._contactById[a2] = nil
end

function u0.Reset(a1) -- Line: 626
    for i, j in a1._banks do
        table.clear(j.EndpointsById)
    end
    table.clear(a1._contactById)
    a1._endpointScratch.ScratchCount = 0
    a1._activeBank = 0
end

function u0.FindEarliestStationaryContact(a1, a2, a3, a4) -- Line: 636
    -- upvalues: couldReachAnyBody (val), prepareContactProxy (val), pointSegmentDistanceSquared (val)
    -- upvalues: maximumHullDistance (val), sweepHull (val)
    local BoundingRadius, Stance, Stance_2, StandingHalfSize, StandingHalfSize_2, SubstepCount, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
    if #a3 == 0 then
        return nil, nil, nil
    end
    local v13 = a1._contactById[a2.Id]
    if v13 == nil then
        error(string.format("contact mover %d was not reserved at registration", a2.Id), 2)
    end
    if not couldReachAnyBody(a2, a3, a4) then
        return nil, nil, nil
    end
    prepareContactProxy(v13, a2, a4)
    local v14 = nil
    local v15 = nil
    local v16 = nil
    local Position = a2.PreviousCFrame.Position
    local Position_2 = a2.CFrame.Position
    local v17 = (math.max(a4.ContactEpsilon, a4.BrushEpsilon)) + a4.BroadphasePadding
    local v18 = nil
    local v19 = nil
    local v20, v21 = a2, a4
    for i, j in a3, v18, v19 do
        BoundingRadius = v20.BoundingRadius
        Stance = j.Stance
        if Stance == "Standing" then
            StandingHalfSize = v21.StandingHalfSize
        elseif Stance ~= "Ducking" then
            error("contact mover body has an invalid stance", 3)
            StandingHalfSize = nil
        else
            StandingHalfSize = v21.DuckingHalfSize
        end
        v1 = BoundingRadius + StandingHalfSize.Magnitude + v17
        v2 = pointSegmentDistanceSquared(j.Position, Position, Position_2)
        if not (v1 * v1 < v2) then
            v2 = j.Id or i
            Stance_2 = j.Stance
            if Stance_2 == "Standing" then
                StandingHalfSize_2 = v21.StandingHalfSize
            elseif Stance_2 ~= "Ducking" then
                error("contact mover body has an invalid stance", 3)
                StandingHalfSize_2 = nil
            else
                StandingHalfSize_2 = v21.DuckingHalfSize
            end
            v3 = math.max(v21.ContactEpsilon, v21.BrushEpsilon)
            v4, v5 = maximumHullDistance(v13.StartHull, j.Position, StandingHalfSize_2)
            if not (v4 <= v3) then
                SubstepCount = v13.SubstepCount
                for k = 1, SubstepCount do
                    v7 = v13.Substeps[k]
                    if v14 ~= nil and v14 <= v7.TimeStart then
                        break
                    end
                    v8 = v20.PreviousCFrame.Position:Lerp(v20.CFrame.Position, v7.TimeStart)
                    v9 = v20.PreviousCFrame.Position:Lerp(v20.CFrame.Position, v7.TimeEnd)
                    v10, v11 = sweepHull(v7.Hull, j.Position - v8 + v7.ReferenceCenter, j.Position - v9 + v7.ReferenceCenter, StandingHalfSize_2, v21)
                    if v10 ~= nil then
                        v12 = v7.TimeStart + (v7.TimeEnd - v7.TimeStart) * v10
                        if v14 == nil or v12 < v14 then
                            v14 = v12
                            v15 = v11
                            v16 = v2
                        end
                        if not (v12 <= 0) then
                            break
                        end
                        return 0, v11, v2
                    end
                end
            else
                v6 = maximumHullDistance(v13.EndHull, j.Position, StandingHalfSize_2)
                if not (v4 + v3 < v6) then
                    return 0, v5, v2
                end
            end
        end
    end
    return v14, v15, v16
end

return u0