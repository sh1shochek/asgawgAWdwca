-- ReplicatedStorage.MovementV2.Simulation.PlayerContacts
-- Script path: ReplicatedStorage.MovementV2.Simulation.PlayerContacts
-- Decompile time: 23.37 ms

local Enums = require(script.Parent.Parent.Enums)
local Serial = require(script.Parent.Parent.Serial)
require(script.Parent.Parent.Types)
local Config = require(script.Parent.Config)
local DeterminismTrace = require(script.Parent.DeterminismTrace)
local u28 = {DefaultIterations = 4, DefaultContactEpsilon = 0.002, DefaultSeparationSkin = 0.0005}

function u28.newScratch() -- Line: 75
    return {
        HalfSizes = {},
        PairA = {},
        PairB = {},
        Deltas = {},
        Counts = {},
        Contacts = {},
        SupportTopById = {},
        SupportLowerById = {},
        SupportAnchorById = {},
        BodiesById = {},
        SupportsById = {},
    }
end

local function isFiniteNumber(a1) -- Line: 96
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

local function isFiniteVector3(a1) -- Line: 100
    local v1 = false
    if typeof(a1) == "Vector3" then
        local X = a1.X
        v1 = false
        if typeof(X) == "number" then
            v1 = false
            if X == X then
                v1 = false
                if X > (-1 / 0) then
                    v1 = X < (1 / 0)
                end
            end
        end
        if v1 then
            local Y = a1.Y
            v1 = false
            if typeof(Y) == "number" then
                v1 = false
                if Y == Y then
                    v1 = false
                    if Y > (-1 / 0) then
                        v1 = Y < (1 / 0)
                    end
                end
            end
            if v1 then
                local Z = a1.Z
                v1 = false
                if typeof(Z) == "number" then
                    v1 = false
                    if Z == Z then
                        v1 = false
                        if Z > (-1 / 0) then
                            v1 = Z < (1 / 0)
                        end
                    end
                end
            end
        end
    end
    return v1
end

local function traceFor(a1, a2) -- Line: 107 -- types: a1: table, a2: number
    if a1.TraceBodyId == a2 then
        return a1.TraceRecorder
    end
    local TraceRecordersById = a1.TraceRecordersById
    if TraceRecordersById ~= nil then
        return TraceRecordersById[a2]
    end
    return nil
end

local function traceBody(a1, a2, a3, a4, a5) -- Line: 115
    -- upvalues: DeterminismTrace (val)
    local TraceRecorder
    local Id = a3.Id
    if a1.TraceBodyId ~= Id then
        local TraceRecordersById = a1.TraceRecordersById
        TraceRecorder = if TraceRecordersById == nil then nil else TraceRecordersById[Id]
    else
        TraceRecorder = a1.TraceRecorder
    end
    if TraceRecorder == nil then
        return
    end
    DeterminismTrace.vector(
        TraceRecorder,
        a2,
        a3.Position,
        a3.WorldVelocity,
        a4,
        a5,
        nil,
        "ReplicatedStorage.MovementV2.Simulation.PlayerContacts",
        debug.info(2, "l")
    )
end

local function halfSize(a1, a2) -- Line: 133 -- types: a1: table
    local PlayerSizeDucking = if a1.Stance ~= "Ducking" then a2.PlayerSizeStanding else a2.PlayerSizeDucking
    return PlayerSizeDucking * 0.5
end

function u28.toWorldVelocity(a1, a2) -- Line: 137 -- upvalues: Enums (val) -- types: a1: vector
    if a2.Kind == Enums.SupportKind.None then
        return a1
    end
    return a1 + a2.Velocity
end

function u28.carryDelta(a1, a2, a3, a4) -- Line: 142 -- types: a1: vector, a2: vector, a3: number, a4: number
    return a1 / math.max(1, a4) - a2 * a3
end

function u28.fromWorldVelocity(a1, a2) -- Line: 152 -- upvalues: Enums (val) -- types: a1: vector
    if a2.Kind == Enums.SupportKind.None then
        return a1
    end
    return a1 - a2.Velocity
end

local function validateBodies(a1) -- Line: 156 -- upvalues: Serial (val) -- types: a1: table
    local Position, StartPosition, WorldVelocity, X, X_2, X_3, Y, Y_2, Y_3, Z, Z_2, Z_3, v1
    local Id = 0
    local v2 = 0
    local v3 = nil
    local v4 = nil
    for i, j in a1, v3, v4 do
        assert(Serial.isUInt32(j.Id) and 0 < j.Id, "player contact body ID must be a non-zero u32")
        assert(Id < j.Id, "player contact bodies must be strictly sorted by ID")
        StartPosition = j.StartPosition
        v1 = false
        if typeof(StartPosition) == "Vector3" then
            X = StartPosition.X
            v1 = false
            if typeof(X) == "number" then
                v1 = false
                if X == X then
                    v1 = false
                    if X > (-1 / 0) then
                        v1 = X < (1 / 0)
                    end
                end
            end
            if v1 then
                Y = StartPosition.Y
                v1 = false
                if typeof(Y) == "number" then
                    v1 = false
                    if Y == Y then
                        v1 = false
                        if Y > (-1 / 0) then
                            v1 = Y < (1 / 0)
                        end
                    end
                end
                if v1 then
                    Z = StartPosition.Z
                    v1 = false
                    if typeof(Z) == "number" then
                        v1 = false
                        if Z == Z then
                            v1 = false
                            if Z > (-1 / 0) then
                                v1 = Z < (1 / 0)
                            end
                        end
                    end
                end
            end
        end
        assert(v1, "invalid player contact start position")
        Position = j.Position
        v1 = false
        if typeof(Position) == "Vector3" then
            X_2 = Position.X
            v1 = false
            if typeof(X_2) == "number" then
                v1 = false
                if X_2 == X_2 then
                    v1 = false
                    if X_2 > (-1 / 0) then
                        v1 = X_2 < (1 / 0)
                    end
                end
            end
            if v1 then
                Y_2 = Position.Y
                v1 = false
                if typeof(Y_2) == "number" then
                    v1 = false
                    if Y_2 == Y_2 then
                        v1 = false
                        if Y_2 > (-1 / 0) then
                            v1 = Y_2 < (1 / 0)
                        end
                    end
                end
                if v1 then
                    Z_2 = Position.Z
                    v1 = false
                    if typeof(Z_2) == "number" then
                        v1 = false
                        if Z_2 == Z_2 then
                            v1 = false
                            if Z_2 > (-1 / 0) then
                                v1 = Z_2 < (1 / 0)
                            end
                        end
                    end
                end
            end
        end
        assert(v1, "invalid player contact position")
        WorldVelocity = j.WorldVelocity
        v1 = false
        if typeof(WorldVelocity) == "Vector3" then
            X_3 = WorldVelocity.X
            v1 = false
            if typeof(X_3) == "number" then
                v1 = false
                if X_3 == X_3 then
                    v1 = false
                    if X_3 > (-1 / 0) then
                        v1 = X_3 < (1 / 0)
                    end
                end
            end
            if v1 then
                Y_3 = WorldVelocity.Y
                v1 = false
                if typeof(Y_3) == "number" then
                    v1 = false
                    if Y_3 == Y_3 then
                        v1 = false
                        if Y_3 > (-1 / 0) then
                            v1 = Y_3 < (1 / 0)
                        end
                    end
                end
                if v1 then
                    Z_3 = WorldVelocity.Z
                    v1 = false
                    if typeof(Z_3) == "number" then
                        v1 = false
                        if Z_3 == Z_3 then
                            v1 = false
                            if Z_3 > (-1 / 0) then
                                v1 = Z_3 < (1 / 0)
                            end
                        end
                    end
                end
            end
        end
        assert(v1, "invalid player contact velocity")
        v1 = true
        if j.Stance ~= "Standing" then
            v1 = j.Stance == "Ducking"
        end
        assert(v1, "invalid player contact stance")
        assert(typeof(j.OwnsMotion) == "boolean", "invalid player contact motion ownership")
        if j.OwnsMotion then
            v2 = v2 + 1
        end
        Id = j.Id
    end
    assert(v2 <= 1, "player contact solve may write only one moving body")
end

local function axisComponent(a1, a2) -- Line: 175 -- types: a1: vector, a2: number
    if a2 == 1 then
        return a1.X
    end
    if a2 == 2 then
        return a1.Y
    end
    return a1.Z
end

local function axisVector(a1) -- Line: 185 -- types: a1: number
    if a1 == 1 then
        return (Vector3.new(1, 0, 0))
    end
    if a1 == 2 then
        return (Vector3.new(0, 1, 0))
    end
    return (Vector3.new(0, 0, 1))
end

local function axisPriority(a1) -- Line: 195 -- types: a1: number
    if a1 == 2 then
        return 1
    end
    if a1 == 1 then
        return 2
    end
    return 3
end

local function sweptPair(a1, a2, a3, a4) -- Line: 201 -- types: a1: table, a2: table, a3: vector, a4: number
    local v1 = math.min(a1.StartPosition.X, a1.Position.X)
    local v2 = math.max(a2.StartPosition.X, a2.Position.X)
    if not (v2 + a3.X < v1) then
        v1 = math.min(a2.StartPosition.X, a2.Position.X)
        v2 = math.max(a1.StartPosition.X, a1.Position.X)
        if not (v2 + a3.X < v1) then
            v1 = math.min(a1.StartPosition.Y, a1.Position.Y)
            v2 = math.max(a2.StartPosition.Y, a2.Position.Y)
            if not (v2 + a3.Y < v1) then
                v1 = math.min(a2.StartPosition.Y, a2.Position.Y)
                v2 = math.max(a1.StartPosition.Y, a1.Position.Y)
                if not (v2 + a3.Y < v1) then
                    v1 = math.min(a1.StartPosition.Z, a1.Position.Z)
                    v2 = math.max(a2.StartPosition.Z, a2.Position.Z)
                    if not (v2 + a3.Z < v1) then
                        v1 = math.min(a2.StartPosition.Z, a2.Position.Z)
                        v2 = math.max(a1.StartPosition.Z, a1.Position.Z)
                        if not (v2 + a3.Z < v1) then
                            local X_10, X_11, X_12, v3, v4, v5, v6, v7, v8, v9, v10, v11
                            v1 = a1.StartPosition - a2.StartPosition
                            if (math.abs(v1.X)) < a3.X and (math.abs(v1.Y)) < a3.Y and (math.abs(v1.Z)) < a3.Z then
                                return nil, nil
                            end
                            local v12 = a1.Position - a1.StartPosition - (a2.Position - a2.StartPosition)
                            v2 = 0
                            local v13 = 1
                            local v14 = 0
                            local v15 = 1
                            local v16 = Vector3.new(0, 0, 0)
                            local v17 = 0
                            for i = 1, 3 do
                                X_10 = if i ~= 1 then if i ~= 2 then v1.Z else v1.Y else v1.X
                                X_11 = if i ~= 1 then if i ~= 2 then v12.Z else v12.Y else v12.X
                                v3 = math.max((if i ~= 1 then if i ~= 2 then v5.Z else v5.Y else v5.X) - v11, 0)
                                if (math.abs(X_11)) <= 1e-09 then
                                    if not (X_10 < -X_12) and not (X_12 < X_10) then
                                        if not (X_10 <= -v3) and not (v3 <= X_10) then
                                            continue
                                        end
                                        return nil, nil
                                    end
                                    return nil, nil
                                end
                                v4 = (-X_12 - X_10) / X_11
                                v6 = (X_12 - X_10) / X_11
                                v7 = math.min(v4, v6)
                                v8 = math.max(v4, v6)
                                if v2 + 1e-09 < v7 then
                                    v2 = math.max(v7, 0)
                                    v16 = (if i ~= 1 then if i ~= 2 then Vector3.new(0, 0, 1) else Vector3.new(0, 1, 0) else Vector3.new(1, 0, 0)) * (if not (X_11 > 0) then 1 else -1)
                                elseif (math.abs(v7 - v2)) <= 1e-09 then
                                    if v17 == 0
                                        or (if i ~= 2 then if i ~= 1 then 3 else 2 else 1) < (if v17 ~= 2 then if v17 ~= 1 then 3 else 2 else 1) then
                                        v2 = math.max(v7, 0)
                                        v16 = (if i ~= 1 then if i ~= 2 then Vector3.new(0, 0, 1) else Vector3.new(0, 1, 0) else Vector3.new(1, 0, 0)) * (if not (X_11 > 0) then 1 else -1)
                                    end
                                end
                                v13 = math.min(v13, v8)
                                v9 = (-v3 - X_10) / X_11
                                v10 = (v3 - X_10) / X_11
                                v14 = math.max(v14, (math.min(v9, v10)))
                                v15 = math.min(v15, (math.max(v9, v10)))
                                if not (v13 < v2) and not (v15 <= v14) then
                                    continue
                                end
                                return nil, nil
                            end
                            local v18 = math.max(v14, 0)
                            local v19 = math.min(v15, 1)
                            if not (v19 <= v18)
                                and not (v19 <= 0)
                                and not (v18 >= 1)
                                and not (v2 >= 1)
                                and v16 ~= Vector3.new(0, 0, 0) then
                                return v2, v16
                            end
                            return nil, nil
                        end
                    end
                end
            end
        end
    end
    return nil, nil
end

local function overlapContact(a1, a2, a3, a4) -- Line: 284 -- types: a1: table, a2: table, a3: vector, a4: number
    local v1 = a1.Position - a2.Position
    local v2 = a3.X - math.abs(v1.X)
    local v3 = a3.Y - math.abs(v1.Y)
    local v4 = a3.Z - math.abs(v1.Z)
    if not (v2 < -a4) and not (v3 < -a4) and not (v4 < -a4) then
        local v5 = 2
        local v6 = v3
        if v2 < v6 - a4 then
            v5 = 1
            v6 = v2
        end
        if v4 < v6 - a4 then
            v5 = 3
            v6 = v4
        end
        if v5 == 2 then
            if v2 <= 0 or v4 <= 0 then
                if not (v2 <= v4) then
                    v5 = 3
                    v6 = v4
                else
                    v5 = 1
                    v6 = v2
                end
            end
        end
        local X_3 = if v5 ~= 1 then if v5 ~= 2 then v1.Z else v1.Y else v1.X
        local v7 = if not (X_3 > 0) then if not (X_3 < 0) then if not (a1.Id < a2.Id) then 1 else -1 else -1 else 1
        return (if v5 ~= 1 then if v5 ~= 2 then Vector3.new(0, 0, 1) else Vector3.new(0, 1, 0) else Vector3.new(1, 0, 0)) * v7, v6
    end
    return nil, nil
end

local function accumulateMoverCorrection(a1, a2, a3, a4, a5, a6) -- Line: 318
    -- upvalues: 
    local v1
    if a4 <= 0 then
        return
    end
    if (if not a1.OwnsMotion then if not a2.OwnsMotion then nil else a2 else a1) == nil then
        return
    end
    local v2 = if v1 ~= a1 then -a3 else a3
    local v3 = math.max(-(v1.Position - v1.StartPosition):Dot(v2), 0)
    if v3 <= 1e-09 then
        return
    end
    local v4 = v2 * math.min(a4, v3)
    local v5 = a5[v1.Id] or Vector3.new(0, 0, 0)
    local Id = v1.Id
    local v6 = math.abs(v4.X)
    local X_3 = if not (math.abs(v5.X) < v6) then v5.X else v4.X
    local v7 = math.abs(v4.Y)
    local Y_3 = if not (math.abs(v5.Y) < v7) then v5.Y else v4.Y
    local v8 = math.abs(v4.Z)
    a5[Id] = (Vector3.new(X_3, Y_3, if not (math.abs(v5.Z) < v8) then v5.Z else v4.Z))
    a6[v1.Id] = (a6[v1.Id] or 0) + 1
end

local function applyCorrections(a1, a2, a3, a4, a5, a6) -- Line: 352
    -- upvalues: DeterminismTrace (val)
    local Id, Position, TraceRecorder, TraceRecordersById, X, v1, v2, v3, v4, v5, v6, v7
    local v8 = 0
    local v9 = nil
    local v10 = nil
    local v11, v12, v13, v14, v15 = a2, a3, a4, a5, a6
    for i, j in a1, v9, v10 do
        v1 = v11[j.Id]
        if v1 ~= nil then
            v2 = v12[j.Id] or 1
            v3 = j.Position + v1
            assert(typeof(if v13 ~= nil then v13(j, v3) else true) == "boolean", "player contact CanOccupy must return a boolean")
            if not v4 then
                for k = 1, 3 do
                    X = if k ~= 1 then if k ~= 2 then v1.Z else v1.Y else v1.X
                    if X ~= 0 then
                        Position = j.Position
                        v6 = Position + (if k ~= 1 then if k ~= 2 then Vector3.new(0, 0, 1) else Vector3.new(0, 1, 0) else Vector3.new(1, 0, 0)) * X
                        v7 = assert(v13)(j, v6)
                        assert(typeof(v7) == "boolean", "player contact CanOccupy must return a boolean")
                        if not v7 then
                            v8 = v8 + 1
                        else
                            j.Position = v6
                        end
                    end
                end
            else
                j.Position = v3
            end
            v5 = if not v4 then 0 else 1
            Id = j.Id
            if v14.TraceBodyId ~= Id then
                TraceRecordersById = v14.TraceRecordersById
                TraceRecorder = if TraceRecordersById == nil then nil else TraceRecordersById[Id]
            else
                TraceRecorder = v14.TraceRecorder
            end
            if TraceRecorder ~= nil then
                DeterminismTrace.vector(
                    TraceRecorder,
                    v15,
                    j.Position,
                    j.WorldVelocity,
                    v5,
                    v2,
                    nil,
                    "ReplicatedStorage.MovementV2.Simulation.PlayerContacts",
                    debug.info(2, "l")
                )
            end
        end
    end
    return v8
end

local function removeInwardVelocity(a1, a2, a3, a4) -- Line: 393
    -- upvalues: DeterminismTrace (val)
    local v1 = a1.WorldVelocity:Dot(a3)
    if a1.OwnsMotion and v1 < 0 then
        local TraceRecorder
        a1.WorldVelocity = a1.WorldVelocity - a3 * v1
        local Id = a2.Id
        local Id_2 = a1.Id
        if a4.TraceBodyId ~= Id_2 then
            local TraceRecordersById = a4.TraceRecordersById
            TraceRecorder = if TraceRecordersById == nil then nil else TraceRecordersById[Id_2]
        else
            TraceRecorder = a4.TraceRecorder
        end
        if TraceRecorder ~= nil then
            DeterminismTrace.vector(
                TraceRecorder,
                "playerContacts.velocityClip",
                a1.Position,
                a1.WorldVelocity,
                v1,
                Id,
                nil,
                "ReplicatedStorage.MovementV2.Simulation.PlayerContacts",
                debug.info(2, "l")
            )
        end
    end
    local v2 = a2.WorldVelocity:Dot(a3)
    if a2.OwnsMotion and v2 > 0 then
        local TraceRecorder_2
        a2.WorldVelocity = a2.WorldVelocity - a3 * v2
        local Id_3 = a1.Id
        local Id_4 = a2.Id
        if a4.TraceBodyId ~= Id_4 then
            local TraceRecordersById_2 = a4.TraceRecordersById
            TraceRecorder_2 = if TraceRecordersById_2 == nil then nil else TraceRecordersById_2[Id_4]
        else
            TraceRecorder_2 = a4.TraceRecorder
        end
        if TraceRecorder_2 == nil then
            return
        end
        DeterminismTrace.vector(
            TraceRecorder_2,
            "playerContacts.velocityClip",
            a2.Position,
            a2.WorldVelocity,
            v2,
            Id_3,
            nil,
            "ReplicatedStorage.MovementV2.Simulation.PlayerContacts",
            debug.info(2, "l")
        )
    end
end

function u28.solve(a1, a2) -- Line: 407
    -- upvalues: validateBodies (val), Config (val), u28 (val), DeterminismTrace (val), sweptPair (val)
    -- upvalues: accumulateMoverCorrection (val), applyCorrections (val), overlapContact (val)
    -- upvalues: removeInwardVelocity (val), Enums (val)
    local Id, Id_2, Id_3, Id_4, PlayerSizeDucking, TraceRecorder, TraceRecorder_2, TraceRecorder_3, TraceRecordersById, TraceRecordersById_2, TraceRecordersById_3, WorldVelocity, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
    validateBodies(a1)
    local v15 = a2 or {}
    local Config_2 = v15.Config or Config.Default
    local Iterations = v15.Iterations or u28.DefaultIterations
    local ContactEpsilon = v15.ContactEpsilon or u28.DefaultContactEpsilon
    local SeparationSkin = v15.SeparationSkin or u28.DefaultSeparationSkin
    local Scratch = v15.Scratch or u28.newScratch()
    local v16 = false
    if Iterations % 1 == 0 then
        v16 = false
        if Iterations >= 1 then
            v16 = Iterations <= 8
        end
    end
    assert(v16, "invalid player contact iteration count")
    v16 = false
    if typeof(ContactEpsilon) == "number" then
        v16 = false
        if ContactEpsilon == ContactEpsilon then
            v16 = false
            if ContactEpsilon > (-1 / 0) then
                v16 = ContactEpsilon < (1 / 0)
            end
        end
    end
    if v16 then
        v16 = false
        if ContactEpsilon >= 0 then
            v16 = ContactEpsilon <= 0.1
        end
    end
    assert(v16, "invalid player contact epsilon")
    v16 = false
    if typeof(SeparationSkin) == "number" then
        v16 = false
        if SeparationSkin == SeparationSkin then
            v16 = false
            if SeparationSkin > (-1 / 0) then
                v16 = SeparationSkin < (1 / 0)
            end
        end
    end
    if v16 then
        v16 = false
        if SeparationSkin >= 0 then
            v16 = SeparationSkin <= 0.1
        end
    end
    assert(v16, "invalid player separation skin")
    local HalfSizes = Scratch.HalfSizes
    v16 = nil
    table.clear(HalfSizes)
    local v17 = nil
    local v18 = nil
    local v19 = a1
    for i, j in a1, v17, v18 do
        Id_3 = j.Id
        PlayerSizeDucking = if j.Stance ~= "Ducking" then Config_2.PlayerSizeStanding else Config_2.PlayerSizeDucking
        HalfSizes[Id_3] = PlayerSizeDucking * 0.5
        if j.OwnsMotion then
            v16 = j
        end
        v2 = if not j.OwnsMotion then 0 else 1
        Id_4 = j.Id
        if v15.TraceBodyId ~= Id_4 then
            TraceRecordersById_3 = v15.TraceRecordersById
            TraceRecorder_3 = if TraceRecordersById_3 == nil then nil else TraceRecordersById_3[Id_4]
        else
            TraceRecorder_3 = v15.TraceRecorder
        end
        if TraceRecorder_3 ~= nil then
            DeterminismTrace.vector(
                TraceRecorder_3,
                "playerContacts.input",
                j.Position,
                j.WorldVelocity,
                v2,
                0,
                nil,
                "ReplicatedStorage.MovementV2.Simulation.PlayerContacts",
                debug.info(2, "l")
            )
        end
    end
    local PairA = Scratch.PairA
    local PairB = Scratch.PairB
    table.clear(PairA)
    table.clear(PairB)
    if v16 ~= nil then
        local v20
        v1 = nil
        local v21 = nil
        for k, n in v19, v1, v21 do
            if n ~= v16 then
                v20 = #PairA + 1
                PairA[v20] = if not (n.Id < v16.Id) then v16 else n
                PairB[v20] = if not (n.Id < v16.Id) then n else v16
            end
        end
    end
    v1 = 0
    local Deltas = Scratch.Deltas
    local Counts = Scratch.Counts
    table.clear(Deltas)
    table.clear(Counts)
    for m, i5 in PairA do
        v3 = PairB[m]
        v4 = HalfSizes[i5.Id] + HalfSizes[v3.Id]
        v5, v6 = sweptPair(i5, v3, v4, (math.max(SeparationSkin, 1e-07)))
        if v5 ~= nil and v6 ~= nil then
            v8 = -(i5.Position - i5.StartPosition - (v3.Position - v3.StartPosition)):Dot(v6) * (1 - v5)
            if v8 > 0 then
                accumulateMoverCorrection(i5, v3, v6, v8 + SeparationSkin, Deltas, Counts)
                v1 = v1 + 1
            end
        end
    end
    v18 = 0 + applyCorrections(v19, Deltas, Counts, v15.CanOccupy, v15, "playerContacts.sweptCorrection")
    for i6 = 1, Iterations do
        table.clear(Deltas)
        table.clear(Counts)
        for i7, i8 in PairA do
            v6 = PairB[i7]
            v7 = overlapContact
            v10 = HalfSizes[i8.Id] + HalfSizes[v6.Id]
            v7, v8 = v7(i8, v6, v10, ContactEpsilon)
            if v7 ~= nil and v8 ~= nil and v8 > 0 then
                accumulateMoverCorrection(i8, v6, v7, v8 + SeparationSkin, Deltas, Counts)
            end
        end
        if next(Deltas) == nil then
            break
        end
        v18 = v18 + applyCorrections(v19, Deltas, Counts, v15.CanOccupy, v15, "playerContacts.overlapCorrection")
    end
    local v22 = v15.CollectContacts ~= false
    local Contacts = Scratch.Contacts
    local SupportTopById = Scratch.SupportTopById
    local SupportLowerById = Scratch.SupportLowerById
    local SupportAnchorById = Scratch.SupportAnchorById
    table.clear(Contacts)
    table.clear(SupportTopById)
    table.clear(SupportLowerById)
    table.clear(SupportAnchorById)
    v4 = nil
    v5 = nil
    for i9, i10 in PairA, v4, v5 do
        v8 = PairB[i9]
        v9 = overlapContact
        v12 = HalfSizes[i10.Id] + HalfSizes[v8.Id]
        v9, v10 = v9(i10, v8, v12, ContactEpsilon)
        if v9 ~= nil and v10 ~= nil then
            if v22 then
                Contacts[#Contacts + 1] = {
                    A = i10.Id,
                    B = v8.Id,
                    Normal = v9,
                    Penetration = math.max(v10, 0),
                }
            end
            removeInwardVelocity(i10, v8, v9, v15)
            v11 = math.abs(v9.Y)
            if not (v11 <= 0.5) then
                v11 = if not (0 < v9.Y) then v8 else i10
                v12 = if not (0 < v9.Y) then i10 else v8
                v13 = v12.Position.Y + HalfSizes[v12.Id].Y
                if not (v11.Position.Y - HalfSizes[v11.Id].Y < v13 - ContactEpsilon - SeparationSkin) then
                    v14 = v11.WorldVelocity.Y - v12.WorldVelocity.Y
                    if not (Config_2.GroundClearVelocity < v14) then
                        v14 = SupportTopById[v11.Id]
                        if v14 == nil
                            or v14 < v13
                            or v13 == v14 and v12.Id < (SupportLowerById[v11.Id] or (1 / 0)) then
                            SupportTopById[v11.Id] = v13
                            SupportLowerById[v11.Id] = v12.Id
                            SupportAnchorById[v11.Id] = v11.Position - v12.Position
                        end
                    end
                end
            end
        end
    end
    local BodiesById = Scratch.BodiesById
    table.clear(BodiesById)
    for i11, i12 in v19 do
        BodiesById[i12.Id] = i12
    end
    local SupportsById = Scratch.SupportsById
    table.clear(SupportsById)
    v6 = nil
    v7 = nil
    for i13, i14 in SupportLowerById, v6, v7 do
        WorldVelocity = assert(BodiesById[i14]).WorldVelocity
        v12 = {
            Kind = Enums.SupportKind.Player,
            SourceId = i14,
            Anchor = assert(SupportAnchorById[i13]),
            Velocity = Vector3.new(WorldVelocity.X, 0, WorldVelocity.Z),
        }
        SupportsById[i13] = v12
        v12 = assert(BodiesById[i13])
        Id_2 = v12.Id
        if v15.TraceBodyId ~= Id_2 then
            TraceRecordersById_2 = v15.TraceRecordersById
            TraceRecorder_2 = if TraceRecordersById_2 == nil then nil else TraceRecordersById_2[Id_2]
        else
            TraceRecorder_2 = v15.TraceRecorder
        end
        if TraceRecorder_2 ~= nil then
            DeterminismTrace.vector(
                TraceRecorder_2,
                "playerContacts.support",
                v12.Position,
                v12.WorldVelocity,
                0,
                i14,
                nil,
                "ReplicatedStorage.MovementV2.Simulation.PlayerContacts",
                debug.info(2, "l")
            )
        end
    end
    v6 = nil
    v7 = nil
    for i15, i16 in v19, v6, v7 do
        v11 = SupportLowerById[i16.Id] or 0
        Id = i16.Id
        if v15.TraceBodyId ~= Id then
            TraceRecordersById = v15.TraceRecordersById
            TraceRecorder = if TraceRecordersById == nil then nil else TraceRecordersById[Id]
        else
            TraceRecorder = v15.TraceRecorder
        end
        if TraceRecorder ~= nil then
            DeterminismTrace.vector(
                TraceRecorder,
                "playerContacts.final",
                i16.Position,
                i16.WorldVelocity,
                v18,
                v11,
                nil,
                "ReplicatedStorage.MovementV2.Simulation.PlayerContacts",
                debug.info(2, "l")
            )
        end
    end
    return {
        Contacts = Contacts,
        SupportsById = SupportsById,
        UnresolvedCount = v18,
        SweptContactCount = v1,
    }
end

return table.freeze(u28)