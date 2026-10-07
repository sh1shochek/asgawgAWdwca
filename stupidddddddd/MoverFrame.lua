-- ReplicatedStorage.MovementV2.Collision.MoverFrame
-- Script path: ReplicatedStorage.MovementV2.Collision.MoverFrame
-- Decompile time: 3.91 ms

local Enums = require(script.Parent.Parent.Enums)
local Serial = require(script.Parent.Parent.Serial)
require(script.Parent.Parent.Types)
require(script.Parent.Parent.Simulation.Types)
local u25 = {}

local function isFiniteNumber(a1) -- Line: 43
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

local function isFiniteVector3(a1) -- Line: 47
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

local function isFiniteCFrame(a1) -- Line: 54
    local v1
    if typeof(a1) ~= "CFrame" then
        return false
    end
    local v2 = {a1:GetComponents()}
    local v3 = nil
    local v4 = nil
    for i, j in v2, v3, v4 do
        v1 = false
        if typeof(j) == "number" then
            v1 = false
            if j == j then
                v1 = false
                if j > (-1 / 0) then
                    v1 = j < (1 / 0)
                end
            end
        end
        if not v1 then
            return false
        end
    end
    return true
end

local function angularVelocity(a1, a2, a3) -- Line: 66 -- types: a1: userdata, a2: userdata, a3: number
    local v1, v2 = a1.Rotation:ToObjectSpace(a2.Rotation):ToAxisAngle()
    local v3 = false
    if typeof(v2) == "number" then
        v3 = false
        if v2 == v2 then
            v3 = false
            if v2 > (-1 / 0) then
                v3 = v2 < (1 / 0)
            end
        end
    end
    if v3 and not (v2 <= 1e-09) then
        v3 = a1:VectorToWorldSpace(v1)
        local Magnitude = v3.Magnitude
        if Magnitude <= 1e-09 then
            return Vector3.new(0, 0, 0), 0
        end
        return v3 / Magnitude * (v2 / a3), v2
    end
    return Vector3.new(0, 0, 0), 0
end

local function makeRecord(a1, a2) -- Line: 80
    -- upvalues: Serial (val), isFiniteCFrame (val), angularVelocity (val), Enums (val)
    assert(Serial.isUInt32(a1.Id) and 0 < a1.Id, "mover ID must be a non-zero u32")
    assert(isFiniteCFrame(a1.PreviousCFrame), "mover PreviousCFrame must be finite")
    assert(isFiniteCFrame(a1.CFrame), "mover CFrame must be finite")
    local Size = a1.Size
    local v1 = false
    if typeof(Size) == "Vector3" then
        local X = Size.X
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
            local Y = Size.Y
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
                local Z = Size.Z
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
    if v1 then
        v1 = false
        if 0 < a1.Size.X then
            v1 = false
            if 0 < a1.Size.Y then
                v1 = 0 < a1.Size.Z
            end
        end
    end
    assert(v1, "mover Size must be a finite positive Vector3")
    local v2 = a1.SurfaceFriction or 1
    local v3 = false
    if typeof(v2) == "number" then
        v3 = false
        if v2 == v2 then
            v3 = false
            if v2 > (-1 / 0) then
                v3 = v2 < (1 / 0)
            end
        end
    end
    if v3 then
        v3 = v2 >= 0
    end
    assert(v3, "mover surface friction must be finite and nonnegative")
    v1, v3 = angularVelocity(a1.PreviousCFrame, a1.CFrame, a2)
    return (table.freeze({
        Id = a1.Id,
        Kind = Enums.SupportKind.Mover,
        SourceId = a1.Id,
        PreviousCFrame = a1.PreviousCFrame,
        CFrame = a1.CFrame,
        Size = a1.Size,
        LinearVelocity = (a1.CFrame.Position - a1.PreviousCFrame.Position) / a2,
        AngularVelocity = v1,
        RotationAngle = v3,
        BoundingRadius = (a1.Size * 0.5).Magnitude,
        SurfaceFriction = v2,
        Pushes = a1.Pushes == true,
    }))
end

function u25.Build(a1, a2) -- Line: 111 -- upvalues: makeRecord (val) -- types: a1: number, a2: table
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
        v1 = a1 > 0
    end
    assert(v1, "mover-frame delta time must be finite and positive")
    assert(typeof(a2) == "table", "mover inputs must be a table")
    local v2 = table.create(#a2)
    for i, j in a2 do
        v2[i] = (makeRecord(j, a1))
    end
    table.sort(v2, function(a1, a2) -- Line: 119
        return a1.Id < a2.Id
    end)
    v1 = {}
    local Id_2 = 0
    local v3 = nil
    local v4 = nil
    for k, n in v2, v3, v4 do
        assert(Id_2 < n.Id, (string.format("duplicate mover ID %d", n.Id)))
        Id_2 = n.Id
        v1[n.Id] = n
    end
    table.freeze(v2)
    table.freeze(v1)
    return (table.freeze({Records = v2, ById = v1}))
end

function u25.SampleCFrame(a1, a2) -- Line: 138 -- types: a1: table, a2: number
    local v1 = false
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
    assert(v1, "invalid mover time fraction")
    if a2 <= 0 then
        return a1.PreviousCFrame
    end
    if a2 >= 1 then
        return a1.CFrame
    end
    return a1.PreviousCFrame:Lerp(a1.CFrame, a2)
end

function u25.VelocityAtPoint(a1, a2, a3) -- Line: 150
    -- upvalues: u25 (val)
    local v1 = false
    if typeof(a2) == "Vector3" then
        local X = a2.X
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
            local Y = a2.Y
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
                local Z = a2.Z
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
    assert(v1, "surface point must be a finite Vector3")
    return a1.LinearVelocity + a1.AngularVelocity:Cross(a2 - (u25.SampleCFrame(a1, a3 or 1)).Position)
end

function u25.ResolveSupportMotion(a1, a2) -- Line: 157 -- upvalues: Enums (val), u25 (val) -- types: a1: table
    if a2.Kind == Enums.SupportKind.Mover and a2.SourceId ~= 0 then
        local v1 = a1.ById[a2.SourceId]
        if v1 == nil then
            return nil
        end
        local v2 = v1.PreviousCFrame:PointToWorldSpace(a2.Anchor)
        local v3 = v1.CFrame:PointToWorldSpace(a2.Anchor)
        return {
            Kind = Enums.SupportKind.Mover,
            SourceId = v1.Id,
            Delta = v3 - v2,
            Velocity = u25.VelocityAtPoint(v1, v3, 1),
        }
    end
    return nil
end

return table.freeze(u25)