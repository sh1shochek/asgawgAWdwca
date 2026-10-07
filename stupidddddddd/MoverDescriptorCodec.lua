-- ReplicatedStorage.MovementV2.MoverDescriptorCodec
-- Script path: ReplicatedStorage.MovementV2.MoverDescriptorCodec
-- Decompile time: 7.58 ms

local MoverTrajectory = require(script.Parent.MoverTrajectory)
local u5 = {DescriptorWireSize = 193, MaxDescriptorCount = 64}

local function fitsF32(a1) -- Line: 18 -- types: a1: number
    local v1 = false
    if a1 == a1 then
        v1 = false
        if a1 >= -3.402823466e+38 then
            v1 = a1 <= 3.402823466e+38
        end
    end
    return v1
end

local function vectorFitsF32(a1) -- Line: 22 -- types: a1: vector
    local X = a1.X
    local v1 = false
    if X == X then
        v1 = false
        if X >= -3.402823466e+38 then
            v1 = X <= 3.402823466e+38
        end
    end
    if v1 then
        local Y = a1.Y
        v1 = false
        if Y == Y then
            v1 = false
            if Y >= -3.402823466e+38 then
                v1 = Y <= 3.402823466e+38
            end
        end
        if v1 then
            local Z = a1.Z
            v1 = false
            if Z == Z then
                v1 = false
                if Z >= -3.402823466e+38 then
                    v1 = Z <= 3.402823466e+38
                end
            end
        end
    end
    return v1
end

local function cframeFitsF32(a1) -- Line: 26 -- types: a1: userdata
    local v1
    local v2 = {a1:GetComponents()}
    local v3 = nil
    local v4 = nil
    for i, j in v2, v3, v4 do
        v1 = false
        if j == j then
            v1 = false
            if j >= -3.402823466e+38 then
                v1 = j <= 3.402823466e+38
            end
        end
        if not v1 then
            return false
        end
    end
    return true
end

function u5.validateList(a1, a2) -- Line: 35
    -- upvalues: MoverTrajectory (val), cframeFitsF32 (val)
    if type(a1) == "table" and not (#a1 > 64) then
        local DurationSeconds, Size, SurfaceFriction, X, Y, Z, v1, v2, v3
        if #a1 == 0 and a2 ~= true then
            return false, "InvalidMoverDescriptorCount"
        end
        local v4 = nil
        local v5 = nil
        for i, j in a1, v4, v5 do
            if type(i) == "number" and i % 1 == 0 and not (i < 1) and not (#a1 < i) then
                v1, v2 = MoverTrajectory.Validate(j)
                if not v1 then
                    return false, v2
                end
                Size = j.Size
                X = Size.X
                v3 = false
                if X == X then
                    v3 = false
                    if X >= -3.402823466e+38 then
                        v3 = X <= 3.402823466e+38
                    end
                end
                if v3 then
                    Y = Size.Y
                    v3 = false
                    if Y == Y then
                        v3 = false
                        if Y >= -3.402823466e+38 then
                            v3 = Y <= 3.402823466e+38
                        end
                    end
                    if v3 then
                        Z = Size.Z
                        v3 = false
                        if Z == Z then
                            v3 = false
                            if Z >= -3.402823466e+38 then
                                v3 = Z <= 3.402823466e+38
                            end
                        end
                    end
                end
                if v3 and cframeFitsF32(j.CollisionOffset) then
                    SurfaceFriction = j.SurfaceFriction
                    v3 = false
                    if SurfaceFriction == SurfaceFriction then
                        v3 = false
                        if SurfaceFriction >= -3.402823466e+38 then
                            v3 = SurfaceFriction <= 3.402823466e+38
                        end
                    end
                    if v3 and cframeFitsF32(j.StartPose) and cframeFitsF32(j.TargetPose) then
                        DurationSeconds = j.DurationSeconds
                        v3 = false
                        if DurationSeconds == DurationSeconds then
                            v3 = false
                            if DurationSeconds >= -3.402823466e+38 then
                                v3 = DurationSeconds <= 3.402823466e+38
                            end
                        end
                        if v3 then
                            continue
                        end
                    end
                end
                return false, "MoverDescriptorOutsideWireRange"
            end
            return false, "MoverDescriptorsNotDense"
        end
        return true, nil
    end
    return false, "InvalidMoverDescriptorCount"
end

local function writeVector3(a1, a2, a3) -- Line: 61 -- types: a1: buffer, a2: number, a3: vector
    local X = a3.X
    buffer.writef32(a1, a2, X)
    local v1 = a2 + 4
    local Y = a3.Y
    buffer.writef32(a1, v1, Y)
    v1 = a2 + 8
    local Z = a3.Z
    buffer.writef32(a1, v1, Z)
    return a2 + 12
end

local function readVector3(a1, a2) -- Line: 68 -- types: a1: buffer, a2: number
    local v1 = buffer.readf32(a1, a2)
    local v2 = a2 + 4
    local v3 = buffer.readf32(a1, v2)
    local v4 = a2 + 8
    return (Vector3.new(v1, v3, (buffer.readf32(a1, v4)))), a2 + 12
end

local function writeCFrame(a1, a2, a3) -- Line: 77 -- types: a1: buffer, a2: number, a3: userdata
    local v1 = {a3:GetComponents()}
    local v2 = a2
    for i, j in v1 do
        buffer.writef32(a1, v2, j)
        v2 = v2 + 4
    end
    return v2
end

local function readCFrame(a1, a2) -- Line: 85 -- types: a1: buffer, a2: number
    local v1 = table.create(12)
    for i = 1, 12 do
        v1[i] = (buffer.readf32(a1, a2))
        a2 = a2 + 4
    end
    return (CFrame.new(table.unpack(v1))), a2
end

function u5.writeValidated(a1, a2, a3) -- Line: 94 -- types: a1: buffer, a2: number, a3: table
    local DurationSeconds, DurationTicks, EffectiveTick, Id, Revision, Size, StartServerTime, StartTick, SurfaceFriction, X, Y, Z, v1, v2, v3, v4
    local v5 = nil
    local v6 = nil
    local v7, v8 = a2, a1
    for i, j in a3, v5, v6 do
        v3 = v7
        Id = j.Id
        buffer.writeu32(v8, v7, Id)
        v7 = v7 + 4
        Revision = j.Revision
        buffer.writeu32(v8, v7, Revision)
        v7 = v7 + 4
        v4 = 0
        if j.Moving then
            v4 = bit32.bor(v4, 1)
        end
        if j.Active then
            v4 = bit32.bor(v4, 2)
        end
        if j.Behavior == "Pusher" then
            v4 = bit32.bor(v4, 4)
        end
        buffer.writeu8(v8, v7, v4)
        v1 = v7 + 1
        Size = j.Size
        X = Size.X
        buffer.writef32(v8, v1, X)
        v2 = v1 + 4
        Y = Size.Y
        buffer.writef32(v8, v2, Y)
        v2 = v1 + 8
        Z = Size.Z
        buffer.writef32(v8, v2, Z)
        v7 = v1 + 12
        for k, n in {j.CollisionOffset:GetComponents()} do
            buffer.writef32(v8, v7, n)
            v7 = v7 + 4
        end
        SurfaceFriction = j.SurfaceFriction
        buffer.writef32(v8, v7, SurfaceFriction)
        v7 = v7 + 4
        for m, i5 in {j.StartPose:GetComponents()} do
            buffer.writef32(v8, v7, i5)
            v7 = v7 + 4
        end
        for i6, i7 in {j.TargetPose:GetComponents()} do
            buffer.writef32(v8, v7, i7)
            v7 = v7 + 4
        end
        EffectiveTick = j.EffectiveTick
        buffer.writeu32(v8, v7, EffectiveTick)
        v7 = v7 + 4
        StartTick = j.StartTick
        buffer.writeu32(v8, v7, StartTick)
        v7 = v7 + 4
        DurationTicks = j.DurationTicks
        buffer.writeu32(v8, v7, DurationTicks)
        v7 = v7 + 4
        StartServerTime = j.StartServerTime
        buffer.writef64(v8, v7, StartServerTime)
        v7 = v7 + 8
        DurationSeconds = j.DurationSeconds
        buffer.writef32(v8, v7, DurationSeconds)
        v7 = v7 + 4
        assert(v7 - v3 == 193, "mover descriptor wire size drift")
    end
    return v7
end

function u5.readList(a1, a2, a3) -- Line: 134
    -- upvalues: readCFrame (val), u5 (val)
    if not (a3 < 0) and not (a3 > 64) then
        local v1 = buffer.len(a1) - a2
        if v1 == a3 * 193 then
            local v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18
            v1 = table.create(a3)
            local v19 = a1
            for i = 1, a3 do
                v17 = buffer.readu32(v19, a2)
                v2 = a2 + 4
                v18 = buffer.readu32(v19, v2)
                v2 = v2 + 4
                v3 = buffer.readu8(v19, v2)
                v2 = v2 + 1
                if bit32.band(v3, 4294967288) ~= 0 then
                    return nil, v2, "InvalidMoverDescriptorFlags"
                end
                v12 = buffer.readf32(v19, v2)
                v15 = v2 + 4
                v13 = buffer.readf32(v19, v15)
                v16 = v2 + 8
                v4 = (Vector3.new(v12, v13, (buffer.readf32(v19, v16))))
                v2 = v2 + 12
                v8, v9 = readCFrame(v19, v2)
                v5 = v8
                v2 = v9
                v8 = buffer.readf32(v19, v2)
                v2 = v2 + 4
                v9, v10 = readCFrame(v19, v2)
                v6 = v9
                v9, v10 = readCFrame(v19, v10)
                v7 = v9
                v2 = v10
                v9 = buffer.readu32(v19, v2)
                v2 = v2 + 4
                v10 = buffer.readu32(v19, v2)
                v2 = v2 + 4
                v11 = buffer.readu32(v19, v2)
                v2 = v2 + 4
                v12 = buffer.readf64(v19, v2)
                v2 = v2 + 8
                v13 = buffer.readf32(v19, v2)
                assert(v2 + 4 - a2 == 193, "mover descriptor wire size drift")
                v14 = {
                    Id = v17,
                    Size = v4,
                    CollisionOffset = v5,
                    SurfaceFriction = v8,
                    StartPose = v6,
                    TargetPose = v7,
                    EffectiveTick = v9,
                    StartTick = v10,
                    DurationTicks = v11,
                    StartServerTime = v12,
                    DurationSeconds = v13,
                    Moving = bit32.band(v3, 1) ~= 0,
                    Active = bit32.band(v3, 2) ~= 0,
                    Behavior = if bit32.band(v3, 4) == 0 then "StopOnBlock" else "Pusher",
                    Revision = v18,
                }
                v1[i] = v14
            end
            local v20, v21 = u5.validateList(v1, true)
            if not v20 then
                return nil, a2, v21
            end
            return v1, a2, nil
        end
    end
    return nil, a2, "MoverDescriptorPayloadSize"
end

function u5.canonicalize(a1) -- Line: 194 -- upvalues: u5 (val)
    local v1, v2
    local v3 = {a1}
    local v4, v5 = u5.validateList(v3)
    if not v4 then
        return nil, v5
    end
    local v6 = buffer.create(193)
    u5.writeValidated(v6, 0, v3)
    v1, _, v2 = u5.readList(v6, 0, 1)
    if v1 == nil then
        return nil, v2
    end
    return v1[1], nil
end

return table.freeze(u5)