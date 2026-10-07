-- ReplicatedStorage.MovementV2.BotCombatCodec
-- Script path: ReplicatedStorage.MovementV2.BotCombatCodec
-- Decompile time: 5.76 ms

local Serial = require(script.Parent.Serial)
local u5 = {}
local u8 = table.freeze({
    Shoot = 1,
    Reload = 2,
    StartThrow = 3,
    Throw = 4,
    CancelThrow = 5,
})
local u16 = table.freeze({"Shoot", "Reload", "StartThrow", "Throw", "CancelThrow"})
u5.Version = 1
u5.MaxEvents = 8
u5.MaxWireSize = 674
u5.MaxEventAgeSeconds = 0.75

local function finite(a1) -- Line: 31
    local v1 = false
    if type(a1) == "number" then
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

function u5.validateEvent(a1) -- Line: 35 -- upvalues: Serial (val), u8 (val)
    if type(a1) == "table"
        and Serial.isUInt32(a1.ActorId)
        and a1.ActorId ~= 0
        and Serial.isNonZeroUInt16(a1.Generation)
        and Serial.isUInt32(a1.WeaponRevision)
        and Serial.isUInt32(a1.Sequence) then
        local ServerTime = a1.ServerTime
        local v1 = false
        if type(ServerTime) == "number" then
            v1 = false
            if ServerTime == ServerTime then
                v1 = false
                if ServerTime > (-1 / 0) then
                    v1 = ServerTime < (1 / 0)
                end
            end
        end
        if v1 and not (a1.ServerTime < 0) and type(a1.WeaponName) == "string" then
            v1 = #a1.WeaponName
            if not (v1 < 1) then
                v1 = #a1.WeaponName
                if not (v1 > 48) then
                    if a1.Kind ~= "Shoot" then
                        v1 = false
                        if u8[a1.Kind] ~= nil then
                            v1 = a1.Target == nil
                        end
                        return v1
                    end
                    local Target = a1.Target
                    local v2 = false
                    if a1.Kind == "Shoot" then
                        v2 = false
                        if typeof(Target) == "Vector3" then
                            local X = Target.X
                            v2 = false
                            if type(X) == "number" then
                                v2 = false
                                if X == X then
                                    v2 = false
                                    if X > (-1 / 0) then
                                        v2 = X < (1 / 0)
                                    end
                                end
                            end
                            if v2 then
                                local Y = Target.Y
                                v2 = false
                                if type(Y) == "number" then
                                    v2 = false
                                    if Y == Y then
                                        v2 = false
                                        if Y > (-1 / 0) then
                                            v2 = Y < (1 / 0)
                                        end
                                    end
                                end
                                if v2 then
                                    local Z = Target.Z
                                    v2 = false
                                    if type(Z) == "number" then
                                        v2 = false
                                        if Z == Z then
                                            v2 = false
                                            if Z > (-1 / 0) then
                                                v2 = Z < (1 / 0)
                                            end
                                        end
                                    end
                                    if v2 then
                                        v2 = false
                                        if (math.abs(Target.X)) <= 1000000 then
                                            v2 = false
                                            if (math.abs(Target.Y)) <= 1000000 then
                                                v2 = (math.abs(Target.Z)) <= 1000000
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return v2
                end
            end
        end
    end
    return false
end

function u5.encode(a1) -- Line: 65 -- upvalues: u5 (val), u8 (val) -- types: a1: table
    if type(a1) == "table" and not (#a1 < 1) and not (#a1 > 8) then
        local ActorId, Generation, Sequence, ServerTime, Target, WeaponRevision, X, Y, Z, v1, v2, v3
        local v4 = 2
        local v5 = 0
        local v6 = nil
        local v7 = nil
        local v8 = a1
        for i, j in a1, v6, v7 do
            if type(i) == "number" and i % 1 == 0 and not (i < 1) and not (#v8 < i) and u5.validateEvent(j) then
                v5 = v5 + 1
                v3 = #j.WeaponName + 24
                v4 = v4 + (v3 + (if j.Kind ~= "Shoot" then 0 else 12))
                continue
            end
            return nil, "InvalidEvent"
        end
        if v5 ~= #v8 then
            return nil, "EventsNotDense"
        end
        local v9 = buffer.create(v4)
        buffer.writeu8(v9, 0, 1)
        local v10 = #v8
        buffer.writeu8(v9, 1, v10)
        v6 = 2
        for k, n in v8 do
            ActorId = n.ActorId
            buffer.writeu32(v9, v6, ActorId)
            v1 = v6 + 4
            Generation = n.Generation
            buffer.writeu16(v9, v1, Generation)
            v1 = v6 + 6
            WeaponRevision = n.WeaponRevision
            buffer.writeu32(v9, v1, WeaponRevision)
            v1 = v6 + 10
            Sequence = n.Sequence
            buffer.writeu32(v9, v1, Sequence)
            v1 = v6 + 14
            ServerTime = n.ServerTime
            buffer.writef64(v9, v1, ServerTime)
            v1 = v6 + 22
            v2 = u8[n.Kind]
            buffer.writeu8(v9, v1, v2)
            v1 = v6 + 23
            v2 = #n.WeaponName
            buffer.writeu8(v9, v1, v2)
            v6 = v6 + 24
            buffer.writestring(v9, v6, n.WeaponName)
            v6 = v6 + #n.WeaponName
            if n.Kind == "Shoot" then
                Target = n.Target
                X = Target.X
                buffer.writef32(v9, v6, X)
                v2 = v6 + 4
                Y = Target.Y
                buffer.writef32(v9, v2, Y)
                v2 = v6 + 8
                Z = Target.Z
                buffer.writef32(v9, v2, Z)
                v6 = v6 + 12
            end
        end
        return v9, nil
    end
    return nil, "InvalidEventCount"
end

function u5.decode(a1) -- Line: 112 -- upvalues: u5 (val), u16 (val)
    if typeof(a1) ~= "buffer" then
        return nil, "PayloadNotBuffer"
    end
    local v1 = buffer.len(a1)
    if not (v1 < 2) and not (u5.MaxWireSize < v1) then
        if buffer.readu8(a1, 0) ~= 1 then
            return nil, "VersionMismatch"
        end
        local v2 = buffer.readu8(a1, 1)
        if not (v2 < 1) and not (v2 > 8) then
            local v3, v4, v5, v6, v7, v8, v9, v10
            local v11 = table.create(v2)
            local v12 = 2
            local v13 = a1
            for i = 1, v2 do
                if v1 < v12 + 24 then
                    return nil, "TruncatedEvent"
                end
                v3 = v12 + 22
                v9 = buffer.readu8(v13, v3)
                v4 = v12 + 23
                v10 = buffer.readu8(v13, v4)
                if u16[v9] ~= nil and not (v10 < 1) and not (v10 > 48) then
                    v4 = v12 + 24 + v10
                    v5 = if v9 ~= 1 then 0 else 12
                    if not (v1 < v4 + v5) then
                        v3 = {ActorId = buffer.readu32(v13, v12)}
                        v6 = v12 + 4
                        v3.Generation = buffer.readu16(v13, v6)
                        v6 = v12 + 6
                        v3.WeaponRevision = buffer.readu32(v13, v6)
                        v6 = v12 + 10
                        v3.Sequence = buffer.readu32(v13, v6)
                        v6 = v12 + 14
                        v3.ServerTime = buffer.readf64(v13, v6)
                        v3.Kind = u16[v9]
                        v3.WeaponName = buffer.readstring(v13, v12 + 24, v10)
                        v12 = v12 + (v10 + 24)
                        if v9 == 1 then
                            v5 = buffer.readf32(v13, v12)
                            v7 = v12 + 4
                            v6 = buffer.readf32(v13, v7)
                            v8 = v12 + 8
                            v3.Target = Vector3.new(v5, v6, (buffer.readf32(v13, v8)))
                            v12 = v12 + 12
                        end
                        if u5.validateEvent(v3) then
                            continue
                        end
                        return nil, "InvalidEvent"
                    end
                end
                return nil, "InvalidEventBody"
            end
            if v12 ~= v1 then
                return nil, "TrailingBytes"
            end
            return v11, nil
        end
        return nil, "InvalidEventCount"
    end
    return nil, "InvalidPayloadSize"
end

function u5.canPresent(a1, a2, a3, a4, a5) -- Line: 173
    -- upvalues: u5 (val), Serial (val)
    local v1 = a3
    if v1 then
        v1 = false
        if a2 ~= nil then
            v1 = not a2.Dead
            if v1 then
                v1 = false
                if 0 < a2.Health then
                    v1 = false
                    if a1.ActorId == a2.ActorId then
                        v1 = false
                        if a1.Generation == a2.Generation then
                            v1 = false
                            if a1.WeaponName == a2.WeaponName then
                                v1 = false
                                if a1.WeaponRevision == a2.WeaponRevision then
                                    v1 = false
                                    if type(a5) == "number" then
                                        v1 = false
                                        if a5 == a5 then
                                            v1 = false
                                            if a5 > (-1 / 0) then
                                                v1 = a5 < (1 / 0)
                                            end
                                        end
                                    end
                                    if v1 then
                                        v1 = false
                                        if -0.25 <= a5 - a1.ServerTime then
                                            v1 = false
                                            if a5 - a1.ServerTime <= u5.MaxEventAgeSeconds then
                                                v1 = true
                                                if a4 ~= nil then
                                                    v1 = Serial.isNewerUInt32(a1.Sequence, a4)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return v1
end

return table.freeze(u5)