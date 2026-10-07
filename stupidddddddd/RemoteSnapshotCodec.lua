-- ReplicatedStorage.MovementV2.RemoteSnapshotCodec
-- Script path: ReplicatedStorage.MovementV2.RemoteSnapshotCodec
-- Decompile time: 40.20 ms

local Enums = require(script.Parent.Enums)
local RemoteActorIdentity = require(script.Parent.RemoteActorIdentity)
local Quantization = require(script.Parent.Quantization)
local Serial = require(script.Parent.Serial)
require(script.Parent.Types)
local u25 = {}
local u28 = buffer.create(4)
u25.Version = 6
u25.HeaderSize = 29
u25.MaxRecordsPerPacket = 22
u25.MaxWireSize = 975

local function vectorWithin(a1, a2) -- Line: 79 -- upvalues: Quantization (val) -- types: a2: number
    local v1 = Quantization.isFiniteVector3(a1)
    if v1 then
        v1 = false
        if math.abs(a1.X) <= a2 then
            v1 = false
            if math.abs(a1.Y) <= a2 then
                v1 = math.abs(a1.Z) <= a2
            end
        end
    end
    return v1
end

local function validateSupport(a1, a2) -- Line: 86 -- upvalues: Enums (val), Serial (val)
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 % 1 == 0 then
            v1 = false
            if Enums.SupportKind.None <= a1 then
                v1 = false
                if a1 <= Enums.SupportKind.Max then
                    v1 = Serial.isUInt32(a2) and a1 == Enums.SupportKind.None == (a2 == 0)
                end
            end
        end
    end
    return v1
end

local function canonicalFloat32(a1) -- Line: 95 -- upvalues: u28 (val) -- types: a1: number
    buffer.writef32(u28, 0, a1)
    return (buffer.readf32(u28, 0))
end

local function canonicalVector3(a1) -- Line: 100 -- upvalues: u28 (val) -- types: a1: vector
    buffer.writef32(u28, 0, a1.X)
    local v1 = buffer.readf32(u28, 0)
    buffer.writef32(u28, 0, a1.Y)
    local v2 = buffer.readf32(u28, 0)
    buffer.writef32(u28, 0, a1.Z)
    return (Vector3.new(v1, v2, (buffer.readf32(u28, 0))))
end

local function quantizeVelocity(a1) -- Line: 104 -- types: a1: number
    return (math.clamp(math.round(a1 * 8), -32767, 32767))
end

local function canonicalVelocity(a1) -- Line: 108 -- types: a1: vector
    return (Vector3.new(
        math.clamp(math.round(a1.X * 8), -32767, 32767) / 8,
        math.clamp(math.round(a1.Y * 8), -32767, 32767) / 8,
        (math.clamp(math.round(a1.Z * 8), -32767, 32767)) / 8
    ))
end

function u25.validateActor(a1) -- Line: 116 -- upvalues: Serial (val), Quantization (val), Enums (val)
    if typeof(a1) ~= "table" then
        return false, "ActorNotTable"
    end
    if type(a1.UserId) == "number"
        and a1.UserId % 1 == 0
        and not (a1.UserId < 0)
        and not (9007199254740991 < a1.UserId) then
        if not Serial.isNonZeroUInt16(a1.Generation) then
            return false, "InvalidActorGeneration"
        end
        if Serial.isUInt32(a1.ActorId) and a1.ActorId ~= 0 then
            local Position = a1.Position
            local v1 = Quantization.isFiniteVector3(Position)
            if v1 then
                v1 = false
                if (math.abs(Position.X)) <= 1000000 then
                    v1 = false
                    if (math.abs(Position.Y)) <= 1000000 then
                        v1 = (math.abs(Position.Z)) <= 1000000
                    end
                end
            end
            if not v1 then
                return false, "InvalidActorPosition"
            end
            local Velocity = a1.Velocity
            v1 = Quantization.isFiniteVector3(Velocity)
            if v1 then
                v1 = false
                if (math.abs(Velocity.X)) <= 100000 then
                    v1 = false
                    if (math.abs(Velocity.Y)) <= 100000 then
                        v1 = (math.abs(Velocity.Z)) <= 100000
                    end
                end
            end
            if not v1 then
                return false, "InvalidActorVelocity"
            end
            if not Quantization.isFinite(a1.LookYaw) then
                return false, "InvalidActorLookYaw"
            end
            if Quantization.isFinite(a1.VerticalLook)
                and not (a1.VerticalLook < -1)
                and not (1 < a1.VerticalLook) then
                if a1.MovementMode ~= "Walking" and a1.MovementMode ~= "Ladder" then
                    return false, "InvalidActorMovementMode"
                end
                if a1.Stance ~= "Standing" and a1.Stance ~= "Ducking" then
                    return false, "InvalidActorStance"
                end
                if typeof(a1.OnGround) ~= "boolean" then
                    return false, "InvalidActorOnGround"
                end
                if Quantization.isFinite(a1.DuckAmount) and not (a1.DuckAmount < 0) and not (1 < a1.DuckAmount) then
                    local SupportKind = a1.SupportKind
                    local SupportSourceId = a1.SupportSourceId
                    v1 = false
                    if typeof(SupportKind) == "number" then
                        v1 = false
                        if SupportKind % 1 == 0 then
                            v1 = false
                            if Enums.SupportKind.None <= SupportKind then
                                v1 = false
                                if SupportKind <= Enums.SupportKind.Max then
                                    v1 = Serial.isUInt32(SupportSourceId) and SupportKind == Enums.SupportKind.None == (SupportSourceId == 0)
                                end
                            end
                        end
                    end
                    if not v1 then
                        return false, "InvalidActorSupport"
                    end
                    local OnGround_2 = a1.OnGround
                    if OnGround_2 ~= (a1.SupportKind ~= Enums.SupportKind.None) then
                        return false, "ActorGroundSupportMismatch"
                    end
                    return true, nil
                end
                return false, "InvalidActorDuckAmount"
            end
            return false, "InvalidActorVerticalLook"
        end
        return false, "InvalidActorId"
    end
    return false, "InvalidActorUserId"
end

function u25.canonicalizeActor(a1) -- Line: 167 -- upvalues: u25 (val), u28 (val), Quantization (val)
    local v1, v2 = u25.validateActor(a1)
    if not v1 then
        return nil, v2
    end
    local v3 = {UserId = a1.UserId, ActorId = a1.ActorId, Generation = a1.Generation}
    local Position = a1.Position
    buffer.writef32(u28, 0, Position.X)
    local v4 = buffer.readf32(u28, 0)
    buffer.writef32(u28, 0, Position.Y)
    local v5 = buffer.readf32(u28, 0)
    buffer.writef32(u28, 0, Position.Z)
    v3.Position = Vector3.new(v4, v5, (buffer.readf32(u28, 0)))
    local Velocity = a1.Velocity
    v3.Velocity = Vector3.new(
        math.clamp(math.round(Velocity.X * 8), -32767, 32767) / 8,
        math.clamp(math.round(Velocity.Y * 8), -32767, 32767) / 8,
        (math.clamp(math.round(Velocity.Z * 8), -32767, 32767)) / 8
    )
    v3.LookYaw = Quantization.dequantizeYaw(Quantization.quantizeYaw(a1.LookYaw))
    v3.VerticalLook = Quantization.dequantizeSignedUnit(Quantization.quantizeSignedUnit(a1.VerticalLook))
    v3.MovementMode = a1.MovementMode
    v3.Stance = a1.Stance
    v3.OnGround = a1.OnGround
    v3.DuckAmount = Quantization.dequantizeUnitByte(Quantization.quantizeUnitByte(a1.DuckAmount))
    v3.SupportKind = a1.SupportKind
    v3.SupportSourceId = a1.SupportSourceId
    return v3, nil
end

local function optionalPresent(a1) -- Line: 190
    return a1 ~= nil
end

function u25.validateDelta(a1) -- Line: 194 -- upvalues: Serial (val), Quantization (val), Enums (val)
    local AbsolutePosition, FieldMask, PositionDelta, SupportKind, SupportSourceId, Velocity, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13
    local dispatch = 0
    while true do
        if dispatch < 79 then
            if dispatch < 39 then
                if dispatch < 19 then
                    if dispatch < 9 then
                        if dispatch < 4 then
                            if dispatch < 2 then
                                if not (dispatch < 1) then
                                    return false, "RemoteDeltaNotTable"
                                end
                                dispatch = if typeof(a1) == "table" then 2 else 1
                            else
                                dispatch = if dispatch < 3 then if not Serial.isUInt32(a1.ActorId) then 4 else 3 else if a1.ActorId ~= 0 then 5 else 4
                            end
                        elseif not (dispatch < 6) then
                            dispatch = if dispatch < 7 then if FieldMask % 1 ~= 0 then 9 else 7 else if dispatch < 8 then if FieldMask == 0 then 9 else 8 else if bit32.band(FieldMask, 4294967168) == 0 then 10 else 9
                        elseif dispatch < 5 then
                            return false, "InvalidRemoteDeltaActorId"
                        else
                            FieldMask = a1.FieldMask
                            dispatch = if type(FieldMask) ~= "number" then 9 else 6
                        end
                    elseif dispatch < 14 then
                        if dispatch < 11 then
                            if dispatch < 10 then
                                return false, "InvalidRemoteDeltaFieldMask"
                            else
                                dispatch = if bit32.band(FieldMask, 1) ~= 0 then 12 else 11
                            end
                        elseif not (dispatch < 12) then
                            if not (dispatch < 13) then
                                dispatch = if a1.PositionDelta ~= nil then 15 else 14
                            end
                        end
                    elseif dispatch < 16 then
                        v7 = not (dispatch < 15)
                    elseif dispatch < 17 then
                        dispatch = if a1.AbsolutePosition ~= nil then 18 else 17
                    else
                        v8 = not (dispatch < 18)
                    end
                elseif dispatch < 29 then
                    if dispatch < 24 then
                        if dispatch < 21 then
                            dispatch = if dispatch < 20 then if v6 ~= (v7 or v8) then 22 else 20 else if not v7 then 23 else 21
                        elseif not (dispatch < 22) then
                            if dispatch < 23 then
                                return false, "InvalidRemoteDeltaPositionPresence"
                            end
                        end
                    elseif dispatch < 26 then
                        dispatch = if dispatch < 25 then if not (Quantization.isFiniteVector3(a1.PositionDelta)) then 30 else 25 else if not ((math.abs(PositionDelta.X)) <= 63.998046875) then 30 else 26
                    elseif dispatch < 27 then
                        dispatch = if not ((math.abs(PositionDelta.Y)) <= 63.998046875) then 30 else 27
                    elseif dispatch < 28 then
                        dispatch = if (math.abs(PositionDelta.Z)) <= 63.998046875 then 29 else 28
                    end
                elseif dispatch < 34 then
                    if dispatch < 31 then
                        if dispatch < 30 then end
                    elseif dispatch < 32 then
                        return false, "InvalidRemoteDeltaPosition"
                    else
                        dispatch = if dispatch < 33 then if not v8 then 41 else 33 else if not (Quantization.isFiniteVector3(a1.AbsolutePosition)) then 39 else 34
                    end
                elseif dispatch < 36 then
                    dispatch = if dispatch < 35 then if not ((math.abs(AbsolutePosition.X)) <= 1000000) then 39 else 35 else if not ((math.abs(AbsolutePosition.Y)) <= 1000000) then 39 else 36
                elseif dispatch < 37 then
                    dispatch = if (math.abs(AbsolutePosition.Z)) <= 1000000 then 38 else 37
                else
                    v9 = not (dispatch < 38)
                end
            elseif dispatch < 59 then
                if dispatch < 49 then
                    if dispatch < 44 then
                        if dispatch < 41 then
                            if not (dispatch < 40) then
                                return false, "InvalidRemoteDeltaAbsolutePosition"
                            end
                        elseif dispatch < 42 then
                            dispatch = if bit32.band(FieldMask, 2) ~= 0 then 43 else 42
                        else
                            v9 = not (dispatch < 43)
                        end
                    elseif dispatch < 46 then
                        if dispatch < 45 then
                            dispatch = if a1.Velocity ~= nil then 46 else 45
                        end
                    elseif not (dispatch < 47) then
                        if not (dispatch < 48) then
                            return false, "InvalidRemoteDeltaVelocityPresence"
                        end
                        dispatch = if v9 == v10 then 49 else 48
                    end
                elseif dispatch < 54 then
                    dispatch = if dispatch < 51 then if dispatch < 50 then if not v9 then 58 else 50 else if not (Quantization.isFiniteVector3(a1.Velocity)) then 56 else 51 else if dispatch < 52 then if not ((math.abs(Velocity.X)) <= 100000) then 56 else 52 else if dispatch < 53 then if not ((math.abs(Velocity.Y)) <= 100000) then 56 else 53 else if (math.abs(Velocity.Z)) <= 100000 then 55 else 54
                elseif dispatch < 56 then
                    v10 = not (dispatch < 55)
                elseif not (dispatch < 57) then
                    if dispatch < 58 then
                        return false, "InvalidRemoteDeltaVelocity"
                    else
                        dispatch = if bit32.band(FieldMask, 4) ~= 0 then 60 else 59
                    end
                end
            elseif dispatch < 69 then
                if dispatch < 64 then
                    if dispatch < 61 then
                        v10 = not (dispatch < 60)
                    elseif dispatch < 62 then
                        dispatch = if a1.LookYaw ~= nil then 63 else 62
                    else
                        v11 = not (dispatch < 63)
                    end
                elseif dispatch < 66 then
                    if not (dispatch < 65) then
                        return false, "InvalidRemoteDeltaLookYawPresence"
                    end
                    dispatch = if v10 == v11 then 66 else 65
                elseif not (dispatch < 67) then
                    if not (dispatch < 68) then
                        return false, "InvalidRemoteDeltaLookYaw"
                    end
                    dispatch = if Quantization.isFinite(a1.LookYaw) then 69 else 68
                end
            elseif dispatch < 74 then
                if dispatch < 71 then
                    if dispatch < 70 then
                        dispatch = if bit32.band(FieldMask, 8) ~= 0 then 71 else 70
                    end
                elseif not (dispatch < 72) then
                    if dispatch < 73 then
                        dispatch = if a1.VerticalLook ~= nil then 74 else 73
                    end
                end
            elseif dispatch < 76 then
                if not (dispatch < 75) then
                    dispatch = if v11 == v12 then 77 else 76
                end
            elseif dispatch < 77 then
                return false, "InvalidRemoteDeltaVerticalLookPresence"
            else
                dispatch = if dispatch < 78 then if not v11 then 82 else 78 else if not Quantization.isFinite(a1.VerticalLook) then 81 else 79
            end
        elseif dispatch < 119 then
            if dispatch < 98 then
                if dispatch < 88 then
                    if dispatch < 83 then
                        if dispatch < 81 then
                            dispatch = if dispatch < 80 then if a1.VerticalLook < -1 then 81 else 80 else if not (1 < a1.VerticalLook) then 82 else 81
                        elseif dispatch < 82 then
                            return false, "InvalidRemoteDeltaVerticalLook"
                        else
                            dispatch = if bit32.band(FieldMask, 16) ~= 0 then 84 else 83
                        end
                    elseif dispatch < 85 then
                        v12 = not (dispatch < 84)
                    elseif dispatch < 86 then
                        dispatch = if a1.MovementMode ~= nil then 87 else 86
                    else
                        v13 = not (dispatch < 87)
                    end
                elseif dispatch < 93 then
                    if dispatch < 90 then
                        dispatch = if dispatch < 89 then if not v13 then 96 else 89 else if a1.Stance ~= nil then 91 else 90
                    elseif not (dispatch < 91) then
                        if dispatch < 92 then end
                    end
                elseif dispatch < 95 then
                    if dispatch < 94 then
                        dispatch = if a1.OnGround ~= nil then 95 else 94
                    end
                elseif not (dispatch < 96) then
                    if not (dispatch < 97) then
                        return false, "InvalidRemoteDeltaMovementPresence"
                    end
                    dispatch = if v12 == v13 then 98 else 97
                end
            elseif dispatch < 109 then
                if dispatch < 103 then
                    if dispatch < 100 then
                        dispatch = if dispatch < 99 then if not v12 then 108 else 99 else if a1.MovementMode == "Walking" then 102 else 100
                    elseif dispatch < 101 then
                        dispatch = if a1.MovementMode == "Ladder" then 102 else 101
                    elseif dispatch < 102 then
                        return false, "InvalidRemoteDeltaMovementMode"
                    else
                        dispatch = if a1.Stance == "Standing" then 105 else 103
                    end
                elseif dispatch < 105 then
                    if not (dispatch < 104) then
                        return false, "InvalidRemoteDeltaStance"
                    end
                    dispatch = if a1.Stance == "Ducking" then 105 else 104
                elseif dispatch < 106 then
                    if typeof(a1.OnGround) == "boolean" then end
                elseif dispatch < 108 then
                    return false, "InvalidRemoteDeltaOnGround"
                else
                    dispatch = if a1.MovementMode ~= nil then 111 else 109
                end
            elseif dispatch < 114 then
                if dispatch < 111 then
                    if dispatch < 110 then
                        dispatch = if a1.Stance ~= nil then 111 else 110
                    elseif a1.OnGround == nil then
                    end
                elseif dispatch < 112 then
                    return false, "InvalidRemoteDeltaMovementPresence"
                elseif dispatch < 113 then
                    dispatch = if bit32.band(FieldMask, 32) ~= 0 then 114 else 113
                end
            elseif dispatch < 116 then
                if not (dispatch < 115) then
                    dispatch = if v1.DuckAmount ~= nil then 117 else 116
                end
            elseif not (dispatch < 117) then
                if not (dispatch < 118) then
                    dispatch = if v13 == v2 then 120 else 119
                end
            end
        elseif dispatch < 139 then
            if dispatch < 129 then
                if dispatch < 124 then
                    if not (dispatch < 121) then
                        dispatch = if dispatch < 122 then if not Quantization.isFinite(v1.DuckAmount) then 124 else 122 else if dispatch < 123 then if v1.DuckAmount < 0 then 124 else 123 else if not (1 < v1.DuckAmount) then 125 else 124
                    elseif dispatch < 120 then
                        return false, "InvalidRemoteDeltaDuckPresence"
                    end
                elseif dispatch < 126 then
                    if dispatch < 125 then
                        return false, "InvalidRemoteDeltaDuckAmount"
                    else
                        dispatch = if bit32.band(FieldMask, 64) ~= 0 then 127 else 126
                    end
                elseif not (dispatch < 127) then
                    if not (dispatch < 128) then
                        dispatch = if v1.SupportKind ~= nil then 130 else 129
                    end
                end
            elseif dispatch < 134 then
                if dispatch < 131 then
                    v3 = not (dispatch < 130)
                elseif not (dispatch < 132) then
                    if dispatch < 133 then
                        dispatch = if v1.SupportSourceId ~= nil then 134 else 133
                    end
                end
            elseif dispatch < 136 then
                if not (dispatch < 135) then
                    dispatch = if v2 == v3 then 137 else 136
                end
            elseif dispatch < 137 then
                return false, "InvalidRemoteDeltaSupportPresence"
            elseif not (dispatch < 138) then
                SupportKind = v1.SupportKind
                SupportSourceId = v1.SupportSourceId
                dispatch = if typeof(SupportKind) ~= "number" then 152 else 139
            end
        elseif dispatch < 149 then
            if dispatch < 144 then
                dispatch = if dispatch < 141 then if dispatch < 140 then if SupportKind % 1 ~= 0 then 152 else 140 else if not (Enums.SupportKind.None <= SupportKind) then 152 else 141 else if dispatch < 142 then if not (SupportKind <= Enums.SupportKind.Max) then 152 else 142 else if dispatch < 143 then if not (Serial.isUInt32(SupportSourceId)) then 152 else 143 else if SupportKind == Enums.SupportKind.None then 145 else 144
            elseif dispatch < 146 then
                v4 = not (dispatch < 145)
            elseif dispatch < 147 then
                dispatch = if SupportSourceId == 0 then 148 else 147
            else
                v5 = not (dispatch < 148)
            end
        elseif dispatch < 154 then
            if dispatch < 151 then
                if dispatch < 150 then
                    dispatch = if v4 == v5 then 151 else 150
                end
            elseif not (dispatch < 152) then
                if not (dispatch < 153) then
                    return false, "InvalidRemoteDeltaSupport"
                end
            end
        elseif dispatch < 156 then
            dispatch = if dispatch < 155 then if v2 then 158 else 155 else if v1.SupportKind ~= nil then 157 else 156
        else
            if not (dispatch < 157) then
                if not (dispatch < 158) then
                    return true, nil
                end
                return false, "InvalidRemoteDeltaSupportPresence"
            end
            dispatch = if v1.SupportSourceId == nil then 158 else 157
        end
    end
end

local function quantizedPositionDelta(a1, a2) -- Line: 292 -- types: a1: vector, a2: vector
    local v1 = a1 - a2
    local v2 = math.round(v1.X * 512)
    local v3 = math.round(v1.Y * 512)
    local v4 = math.round(v1.Z * 512)
    if (math.abs(v2)) <= 32767 and (math.abs(v3)) <= 32767 and (math.abs(v4)) <= 32767 then
        return (Vector3.new(v2 / 512, v3 / 512, v4 / 512)), nil
    end
    return nil, a1
end

function u25.deltaFromCanonicalBaseline(a1, a2) -- Line: 307 -- upvalues: quantizedPositionDelta (val), u25 (val)
    if a1.UserId == a2.UserId and a1.ActorId == a2.ActorId and a1.Generation == a2.Generation then
        local v1, v2
        local v3 = {FieldMask = 0, ActorId = a1.ActorId}
        if a1.Position ~= a2.Position then
            v1, v2 = quantizedPositionDelta(a1.Position, a2.Position)
            if v2 ~= nil or v1 ~= Vector3.new(0, 0, 0) then
                v3.FieldMask = bit32.bor(v3.FieldMask, 1)
                v3.PositionDelta = v1
                v3.AbsolutePosition = v2
            end
        end
        if a1.Velocity ~= a2.Velocity then
            v3.FieldMask = bit32.bor(v3.FieldMask, 2)
            v3.Velocity = a1.Velocity
        end
        if a1.LookYaw ~= a2.LookYaw then
            v3.FieldMask = bit32.bor(v3.FieldMask, 4)
            v3.LookYaw = a1.LookYaw
        end
        if a1.VerticalLook ~= a2.VerticalLook then
            v3.FieldMask = bit32.bor(v3.FieldMask, 8)
            v3.VerticalLook = a1.VerticalLook
        end
        if a1.MovementMode ~= a2.MovementMode or a1.Stance ~= a2.Stance or a1.OnGround ~= a2.OnGround then
            v3.FieldMask = bit32.bor(v3.FieldMask, 16)
            v3.MovementMode = a1.MovementMode
            v3.Stance = a1.Stance
            v3.OnGround = a1.OnGround
        end
        if a1.DuckAmount ~= a2.DuckAmount then
            v3.FieldMask = bit32.bor(v3.FieldMask, 32)
            v3.DuckAmount = a1.DuckAmount
        end
        if a1.SupportKind ~= a2.SupportKind or a1.SupportSourceId ~= a2.SupportSourceId then
            v3.FieldMask = bit32.bor(v3.FieldMask, 64)
            v3.SupportKind = a1.SupportKind
            v3.SupportSourceId = a1.SupportSourceId
        end
        if v3.FieldMask == 0 then
            return nil, nil
        end
        v1, v2 = u25.validateDelta(v3)
        if not v1 then
            return nil, v2
        end
        return v3, nil
    end
    return nil, "RemoteDeltaIdentityMismatch"
end

function u25.applyDeltaToCanonicalBaseline(a1, a2, a3) -- Line: 385 -- upvalues: u25 (val) -- types: a3: boolean?
    local v1, v2, v3
    if not a3 then
        v1, v2 = u25.validateDelta(a2)
        if not v1 then
            return nil, v2
        end
    end
    if a2.ActorId ~= a1.ActorId then
        return nil, "RemoteDeltaIdentityMismatch"
    end
    v1 = {
        UserId = a1.UserId,
        ActorId = a1.ActorId,
        Generation = a1.Generation,
        Position = a1.Position,
        Velocity = a1.Velocity,
        LookYaw = a1.LookYaw,
        VerticalLook = a1.VerticalLook,
        MovementMode = a1.MovementMode,
        Stance = a1.Stance,
        OnGround = a1.OnGround,
        DuckAmount = a1.DuckAmount,
        SupportKind = a1.SupportKind,
        SupportSourceId = a1.SupportSourceId,
    }
    if bit32.band(a2.FieldMask, 1) ~= 0 then
        local AbsolutePosition = if a2.AbsolutePosition == nil then a1.Position + assert(a2.PositionDelta) else a2.AbsolutePosition
        v1.Position = AbsolutePosition
    end
    if bit32.band(a2.FieldMask, 2) ~= 0 then
        v1.Velocity = assert(a2.Velocity)
    end
    if bit32.band(a2.FieldMask, 4) ~= 0 then
        v1.LookYaw = assert(a2.LookYaw)
    end
    if bit32.band(a2.FieldMask, 8) ~= 0 then
        v1.VerticalLook = assert(a2.VerticalLook)
    end
    if bit32.band(a2.FieldMask, 16) ~= 0 then
        v1.MovementMode = assert(a2.MovementMode)
        v1.Stance = assert(a2.Stance)
        v1.OnGround = a2.OnGround == true
    end
    if bit32.band(a2.FieldMask, 32) ~= 0 then
        v1.DuckAmount = assert(a2.DuckAmount)
    end
    if bit32.band(a2.FieldMask, 64) ~= 0 then
        v1.SupportKind = assert(a2.SupportKind)
        v1.SupportSourceId = assert(a2.SupportSourceId)
    end
    v2, v3 = u25.validateActor(v1)
    if not v2 then
        return nil, v3
    end
    return v1, nil
end

function u25.validate(a1) -- Line: 449 -- upvalues: Serial (val), u25 (val), RemoteActorIdentity (val)
    if typeof(a1) ~= "table" then
        return false, "RemoteSnapshotNotTable"
    end
    if not Serial.isUInt32(a1.Sequence) then
        return false, "InvalidRemoteSequence"
    end
    if a1.Kind ~= "Baseline" and a1.Kind ~= "Delta" then
        return false, "InvalidRemoteSnapshotKind"
    end
    if not Serial.isUInt32(a1.BaselineSequence) then
        return false, "InvalidRemoteBaselineSequence"
    end
    if a1.Kind == "Baseline" and a1.BaselineSequence ~= a1.Sequence then
        return false, "RemoteBaselineIdentityMismatch"
    end
    if a1.Kind == "Delta" and (Serial.deltaUInt32(a1.Sequence, a1.BaselineSequence)) <= 0 then
        return false, "RemoteDeltaBaselineOrder"
    end
    if not Serial.isUInt32(a1.ServerTick) then
        return false, "InvalidRemoteServerTick"
    end
    if typeof(a1.Topology) == "table"
        and Serial.isNonZeroUInt16(a1.Topology.Epoch)
        and Serial.isUInt32(a1.Topology.Fingerprint)
        and Serial.isUInt32(a1.Topology.DestructibleRevision) then
        if type(a1.ChunkIndex) == "number"
            and a1.ChunkIndex % 1 == 0
            and type(a1.ChunkCount) == "number"
            and a1.ChunkCount % 1 == 0
            and not (a1.ChunkCount < 1)
            and not (255 < a1.ChunkCount)
            and not (a1.ChunkIndex < 0)
            and not (a1.ChunkCount <= a1.ChunkIndex) then
            if type(a1.Actors) == "table" and type(a1.Deltas) == "table" and type(a1.RemovedActorIds) == "table" then
                local ActorId, v1, v2, v3, v4, v5, v6, v7, v8
                local v9 = #a1.Actors + #a1.Deltas + #a1.RemovedActorIds
                if v9 > 22 then
                    return false, "InvalidRemoteActorCount"
                end
                if v9 ~= 0 then
                    if a1.Kind == "Baseline" then
                        v4 = #a1.Deltas
                        if not (v4 > 0) then
                            v4 = #a1.RemovedActorIds
                            if not (v4 > 0) then
                                v4 = {}
                                v5 = nil
                                v6 = nil
                                v7 = nil
                                v1 = a1
                                for i12, i13 in a1.Actors, v6, v7 do
                                    if type(i12) == "number"
                                        and i12 % 1 == 0
                                        and not (i12 < 1)
                                        and not (#v1.Actors < i12) then
                                        v8, v2 = u25.validateActor(i13)
                                        if not v8 then
                                            return false, v2
                                        end
                                        if v5 ~= nil and not RemoteActorIdentity.wireLess(v5, i13) then
                                            return false, "RemoteActorsNotStrictlySorted"
                                        end
                                        if v4[i13.ActorId] then
                                            return false, "DuplicateActorId"
                                        end
                                        v4[i13.ActorId] = true
                                        v5 = i13
                                        continue
                                    end
                                    return false, "RemoteActorsNotDenseArray"
                                end
                                ActorId = 0
                                for i14, i15 in v1.Deltas do
                                    if type(i14) == "number"
                                        and i14 % 1 == 0
                                        and not (i14 < 1)
                                        and not (#v1.Deltas < i14) then
                                        v2, v3 = u25.validateDelta(i15)
                                        if not v2 then
                                            return false, v3
                                        end
                                        if i15.ActorId <= ActorId then
                                            return false, "RemoteDeltasNotStrictlySorted"
                                        end
                                        if v4[i15.ActorId] then
                                            return false, "DuplicateActorId"
                                        end
                                        v4[i15.ActorId] = true
                                        ActorId = i15.ActorId
                                        continue
                                    end
                                    return false, "RemoteDeltasNotDenseArray"
                                end
                                v6 = 0
                                for i16, i17 in v1.RemovedActorIds do
                                    if type(i16) == "number"
                                        and i16 % 1 == 0
                                        and not (i16 < 1)
                                        and not (#v1.RemovedActorIds < i16)
                                        and Serial.isUInt32(i17)
                                        and i17 ~= 0
                                        and not (i17 <= v6) then
                                        if v4[i17] then
                                            return false, "RemoteActorAlsoRemoved"
                                        end
                                        v4[i17] = true
                                        v6 = i17
                                        continue
                                    end
                                    return false, "InvalidRemovedRemoteActorId"
                                end
                                return true, nil
                            end
                        end
                        return false, "RemoteBaselineHasDeltaRecords"
                    end
                    v4 = {}
                    v5 = nil
                    v6 = nil
                    v7 = nil
                    v1 = a1
                    for i18, i19 in a1.Actors, v6, v7 do
                        if type(i18) == "number" and i18 % 1 == 0 and not (i18 < 1) and not (#v1.Actors < i18) then
                            v8, v2 = u25.validateActor(i19)
                            if not v8 then
                                return false, v2
                            end
                            if v5 ~= nil and not RemoteActorIdentity.wireLess(v5, i19) then
                                return false, "RemoteActorsNotStrictlySorted"
                            end
                            if v4[i19.ActorId] then
                                return false, "DuplicateActorId"
                            end
                            v4[i19.ActorId] = true
                            v5 = i19
                            continue
                        end
                        return false, "RemoteActorsNotDenseArray"
                    end
                    ActorId = 0
                    for i20, i21 in v1.Deltas do
                        if type(i20) == "number" and i20 % 1 == 0 and not (i20 < 1) and not (#v1.Deltas < i20) then
                            v2, v3 = u25.validateDelta(i21)
                            if not v2 then
                                return false, v3
                            end
                            if i21.ActorId <= ActorId then
                                return false, "RemoteDeltasNotStrictlySorted"
                            end
                            if v4[i21.ActorId] then
                                return false, "DuplicateActorId"
                            end
                            v4[i21.ActorId] = true
                            ActorId = i21.ActorId
                            continue
                        end
                        return false, "RemoteDeltasNotDenseArray"
                    end
                    v6 = 0
                    for i22, i23 in v1.RemovedActorIds do
                        if type(i22) == "number"
                            and i22 % 1 == 0
                            and not (i22 < 1)
                            and not (#v1.RemovedActorIds < i22)
                            and Serial.isUInt32(i23)
                            and i23 ~= 0
                            and not (i23 <= v6) then
                            if v4[i23] then
                                return false, "RemoteActorAlsoRemoved"
                            end
                            v4[i23] = true
                            v6 = i23
                            continue
                        end
                        return false, "InvalidRemovedRemoteActorId"
                    end
                    return true, nil
                end
                if a1.ChunkIndex == 0 and a1.ChunkCount == 1 then
                    if a1.Kind ~= "Baseline" then
                        v4 = {}
                        v5 = nil
                        v6 = nil
                        v7 = nil
                        v1 = a1
                        for i6, i7 in a1.Actors, v6, v7 do
                            if type(i6) == "number" and i6 % 1 == 0 and not (i6 < 1) and not (#v1.Actors < i6) then
                                v8, v2 = u25.validateActor(i7)
                                if not v8 then
                                    return false, v2
                                end
                                if v5 ~= nil and not RemoteActorIdentity.wireLess(v5, i7) then
                                    return false, "RemoteActorsNotStrictlySorted"
                                end
                                if v4[i7.ActorId] then
                                    return false, "DuplicateActorId"
                                end
                                v4[i7.ActorId] = true
                                v5 = i7
                                continue
                            end
                            return false, "RemoteActorsNotDenseArray"
                        end
                        ActorId = 0
                        for i8, i9 in v1.Deltas do
                            if type(i8) == "number" and i8 % 1 == 0 and not (i8 < 1) and not (#v1.Deltas < i8) then
                                v2, v3 = u25.validateDelta(i9)
                                if not v2 then
                                    return false, v3
                                end
                                if i9.ActorId <= ActorId then
                                    return false, "RemoteDeltasNotStrictlySorted"
                                end
                                if v4[i9.ActorId] then
                                    return false, "DuplicateActorId"
                                end
                                v4[i9.ActorId] = true
                                ActorId = i9.ActorId
                                continue
                            end
                            return false, "RemoteDeltasNotDenseArray"
                        end
                        v6 = 0
                        for i10, i11 in v1.RemovedActorIds do
                            if type(i10) == "number"
                                and i10 % 1 == 0
                                and not (i10 < 1)
                                and not (#v1.RemovedActorIds < i10)
                                and Serial.isUInt32(i11)
                                and i11 ~= 0
                                and not (i11 <= v6) then
                                if v4[i11] then
                                    return false, "RemoteActorAlsoRemoved"
                                end
                                v4[i11] = true
                                v6 = i11
                                continue
                            end
                            return false, "InvalidRemovedRemoteActorId"
                        end
                        return true, nil
                    end
                    v4 = #a1.Deltas
                    if not (v4 > 0) then
                        v4 = #a1.RemovedActorIds
                        if not (v4 > 0) then
                            v4 = {}
                            v5 = nil
                            v6 = nil
                            v7 = nil
                            v1 = a1
                            for i, j in a1.Actors, v6, v7 do
                                if type(i) == "number" and i % 1 == 0 and not (i < 1) and not (#v1.Actors < i) then
                                    v8, v2 = u25.validateActor(j)
                                    if not v8 then
                                        return false, v2
                                    end
                                    if v5 ~= nil and not RemoteActorIdentity.wireLess(v5, j) then
                                        return false, "RemoteActorsNotStrictlySorted"
                                    end
                                    if v4[j.ActorId] then
                                        return false, "DuplicateActorId"
                                    end
                                    v4[j.ActorId] = true
                                    continue
                                end
                                return false, "RemoteActorsNotDenseArray"
                            end
                            ActorId = 0
                            for k, n in v1.Deltas do
                                if type(k) == "number" and k % 1 == 0 and not (k < 1) and not (#v1.Deltas < k) then
                                    v2, v3 = u25.validateDelta(n)
                                    if not v2 then
                                        return false, v3
                                    end
                                    if n.ActorId <= ActorId then
                                        return false, "RemoteDeltasNotStrictlySorted"
                                    end
                                    if v4[n.ActorId] then
                                        return false, "DuplicateActorId"
                                    end
                                    v4[n.ActorId] = true
                                    ActorId = n.ActorId
                                    continue
                                end
                                return false, "RemoteDeltasNotDenseArray"
                            end
                            v6 = 0
                            for m, i5 in v1.RemovedActorIds do
                                if type(m) == "number"
                                    and m % 1 == 0
                                    and not (m < 1)
                                    and not (#v1.RemovedActorIds < m)
                                    and Serial.isUInt32(i5)
                                    and i5 ~= 0
                                    and not (i5 <= v6) then
                                    if v4[i5] then
                                        return false, "RemoteActorAlsoRemoved"
                                    end
                                    v4[i5] = true
                                    continue
                                end
                                return false, "InvalidRemovedRemoteActorId"
                            end
                            return true, nil
                        end
                    end
                    return false, "RemoteBaselineHasDeltaRecords"
                end
                return false, "InvalidEmptyRemoteFrame"
            end
            return false, "InvalidRemoteRecords"
        end
        return false, "InvalidRemoteChunk"
    end
    return false, "InvalidRemoteTopology"
end

local function writeVector3(a1, a2, a3) -- Line: 564 -- types: a1: buffer, a2: number, a3: vector
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

local function readVector3(a1, a2) -- Line: 571 -- types: a1: buffer, a2: number
    local v1 = buffer.readf32(a1, a2)
    local v2 = a2 + 4
    local v3 = buffer.readf32(a1, v2)
    local v4 = a2 + 8
    return (Vector3.new(v1, v3, (buffer.readf32(a1, v4)))), a2 + 12
end

local function writeVelocity(a1, a2, a3) -- Line: 580 -- types: a1: buffer, a2: number, a3: vector
    local v1 = math.clamp(math.round(a3.X * 8), -32767, 32767)
    buffer.writei16(a1, a2, v1)
    local v2 = a2 + 2
    v1 = math.clamp(math.round(a3.Y * 8), -32767, 32767)
    buffer.writei16(a1, v2, v1)
    v2 = a2 + 4
    v1 = math.clamp(math.round(a3.Z * 8), -32767, 32767)
    buffer.writei16(a1, v2, v1)
    return a2 + 6
end

local function readVelocity(a1, a2) -- Line: 587 -- types: a1: buffer, a2: number
    local v1 = buffer.readi16(a1, a2) / 8
    local v2 = a2 + 2
    local v3 = buffer.readi16(a1, v2) / 8
    local v4 = a2 + 4
    return (Vector3.new(v1, v3, (buffer.readi16(a1, v4)) / 8)), a2 + 6
end

local function actorFlags(a1) -- Line: 596
    local v1 = 0
    if a1.OnGround then
        v1 = bit32.bor(v1, 1)
    end
    if a1.MovementMode == "Ladder" then
        v1 = bit32.bor(v1, 2)
    end
    if a1.Stance == "Ducking" then
        v1 = bit32.bor(v1, 4)
    end
    return (bit32.bor(v1, (bit32.lshift(a1.SupportKind, 3))))
end

local function unsignedVarintSize(a1) -- Line: 610 -- types: a1: number
    local v1 = 1
    local v2 = a1
    while v2 >= 128 do
        v2 = math.floor(v2 / 128)
        v1 = v1 + 1
    end
    return v1
end

local function writeUnsignedVarint(a1, a2, a3) -- Line: 619 -- types: a1: buffer, a2: number, a3: number
    local v1, v2, v3
    repeat
        v3 = a3 % 128
        if (math.floor(a3 / 128)) > 0 then
            v3 = v3 + 128
        end
        buffer.writeu8(a1, a2, v3)
        v1 = a2 + 1
    until v2 == 0
    return v1
end

local function readUnsignedVarint(a1, a2, a3, a4) -- Line: 632 -- types: a1: buffer, a2: number, a3: number, a4: number
    local v1, v2, v3, v4
    local v5 = 0
    local v6 = 1
    for i = 1, a3 do
        if buffer.len(a1) <= a2 then
            return nil, a2, "RemoteActorVarintTruncated"
        end
        v4 = buffer.readu8(a1, a2)
        a2 = a2 + 1
        v1 = bit32.band(v4, 127)
        if math.floor((a4 - v5) / v6) < v1 then
            return nil, a2, "RemoteActorVarintOverflow"
        end
        v5 = v5 + v1 * v6
        if v4 < 128 then
            v3 = v5
            v2 = 1
            while v3 >= 128 do
                v3 = math.floor(v3 / 128)
                v2 = v2 + 1
            end
            if v2 ~= i then
                return nil, a2, "RemoteActorVarintNonCanonical"
            end
            return v5, a2, nil
        end
        v6 = v6 * 128
    end
    return nil, a2, "RemoteActorVarintTooLong"
end

local function fullActorWireSize(a1) -- Line: 662 -- upvalues: Enums (val)
    local UserId = a1.UserId
    local v1 = 1
    while UserId >= 128 do
        UserId = math.floor(UserId / 128)
        v1 = v1 + 1
    end
    local ActorId = a1.ActorId
    local v2 = 1
    while ActorId >= 128 do
        ActorId = math.floor(ActorId / 128)
        v2 = v2 + 1
    end
    local v3 = v1 + v2
    local Generation = a1.Generation
    v1 = 1
    while Generation >= 128 do
        Generation = math.floor(Generation / 128)
        v1 = v1 + 1
    end
    local v4 = v3 + v1 + 23
    return v4 + (if a1.SupportKind ~= Enums.SupportKind.None then 4 else 0)
end

local function deltaActorWireSize(a1) -- Line: 670 -- upvalues: Enums (val)
    local ActorId = a1.ActorId
    local v1 = 1
    while ActorId >= 128 do
        ActorId = math.floor(ActorId / 128)
        v1 = v1 + 1
    end
    local v2 = v1 + 1
    if bit32.band(a1.FieldMask, 1) ~= 0 then
        v2 = v2 + (if a1.AbsolutePosition == nil then 6 else 14)
    end
    if bit32.band(a1.FieldMask, 2) ~= 0 then
        v2 = v2 + 6
    end
    if bit32.band(a1.FieldMask, 4) ~= 0 then
        v2 = v2 + 2
    end
    if bit32.band(a1.FieldMask, 8) ~= 0 then
        v2 = v2 + 1
    end
    if bit32.band(a1.FieldMask, 16) ~= 0 then
        v2 = v2 + 1
    end
    if bit32.band(a1.FieldMask, 32) ~= 0 then
        v2 = v2 + 1
    end
    if bit32.band(a1.FieldMask, 64) ~= 0 then
        v2 = v2 + ((if a1.SupportKind ~= Enums.SupportKind.None then 4 else 0) + 1)
    end
    return v2
end

local function writeFullActor(a1, a2, a3) -- Line: 696
    -- upvalues: writeUnsignedVarint (val), Quantization (val), Enums (val)
    local v1 = writeUnsignedVarint(a1, writeUnsignedVarint(a1, writeUnsignedVarint(a1, a2, a3.UserId), a3.ActorId), a3.Generation)
    local Position = a3.Position
    local X = Position.X
    buffer.writef32(a1, v1, X)
    local v2 = v1 + 4
    local Y = Position.Y
    buffer.writef32(a1, v2, Y)
    v2 = v1 + 8
    local Z = Position.Z
    buffer.writef32(a1, v2, Z)
    v1 = v1 + 12
    local Velocity = a3.Velocity
    local v3 = math.clamp(math.round(Velocity.X * 8), -32767, 32767)
    buffer.writei16(a1, v1, v3)
    v2 = v1 + 2
    v3 = math.clamp(math.round(Velocity.Y * 8), -32767, 32767)
    buffer.writei16(a1, v2, v3)
    v2 = v1 + 4
    v3 = math.clamp(math.round(Velocity.Z * 8), -32767, 32767)
    buffer.writei16(a1, v2, v3)
    local v4 = v1 + 6
    local v5 = Quantization.quantizeYaw(a3.LookYaw)
    buffer.writeu16(a1, v4, v5)
    v4 = v4 + 2
    v5 = Quantization.quantizeSignedUnit(a3.VerticalLook)
    buffer.writei8(a1, v4, v5)
    v4 = v4 + 1
    v2 = 0
    if a3.OnGround then
        v2 = bit32.bor(v2, 1)
    end
    if a3.MovementMode == "Ladder" then
        v2 = bit32.bor(v2, 2)
    end
    if a3.Stance == "Ducking" then
        v2 = bit32.bor(v2, 4)
    end
    local v6 = bit32.bor(v2, (bit32.lshift(a3.SupportKind, 3)))
    buffer.writeu8(a1, v4, v6)
    v4 = v4 + 1
    v5 = Quantization.quantizeUnitByte(a3.DuckAmount)
    buffer.writeu8(a1, v4, v5)
    v4 = v4 + 1
    if a3.SupportKind ~= Enums.SupportKind.None then
        local SupportSourceId = a3.SupportSourceId
        buffer.writeu32(a1, v4, SupportSourceId)
        v4 = v4 + 4
    end
    return v4
end

local function writeDeltaActor(a1, a2, a3) -- Line: 717
    -- upvalues: writeUnsignedVarint (val), Quantization (val), Enums (val)
    local v1, v2, v3
    local v4 = writeUnsignedVarint(a1, a2, a3.ActorId)
    local FieldMask = a3.FieldMask
    buffer.writeu8(a1, v4, FieldMask)
    v4 = v4 + 1
    if bit32.band(a3.FieldMask, 1) ~= 0 then
        if a3.AbsolutePosition == nil then
            v1 = assert(a3.PositionDelta)
            v3 = math.round(v1.X * 512)
            buffer.writei16(a1, v4, v3)
            v2 = v4 + 2
            v3 = math.round(v1.Y * 512)
            buffer.writei16(a1, v2, v3)
            v2 = v4 + 4
            v3 = math.round(v1.Z * 512)
            buffer.writei16(a1, v2, v3)
            v4 = v4 + 6
        else
            buffer.writei16(a1, v4, -32768)
            v1 = v4 + 2
            local AbsolutePosition = a3.AbsolutePosition
            local X = AbsolutePosition.X
            buffer.writef32(a1, v1, X)
            v3 = v1 + 4
            local Y = AbsolutePosition.Y
            buffer.writef32(a1, v3, Y)
            v3 = v1 + 8
            local Z = AbsolutePosition.Z
            buffer.writef32(a1, v3, Z)
            v4 = v1 + 12
        end
    end
    if bit32.band(a3.FieldMask, 2) ~= 0 then
        v1 = v4
        local v5 = assert(a3.Velocity)
        local v6 = math.clamp(math.round(v5.X * 8), -32767, 32767)
        buffer.writei16(a1, v1, v6)
        v3 = v1 + 2
        v6 = math.clamp(math.round(v5.Y * 8), -32767, 32767)
        buffer.writei16(a1, v3, v6)
        v3 = v1 + 4
        v6 = math.clamp(math.round(v5.Z * 8), -32767, 32767)
        buffer.writei16(a1, v3, v6)
        v4 = v1 + 6
    end
    if bit32.band(a3.FieldMask, 4) ~= 0 then
        v2 = Quantization.quantizeYaw((assert(a3.LookYaw)))
        buffer.writeu16(a1, v4, v2)
        v4 = v4 + 2
    end
    if bit32.band(a3.FieldMask, 8) ~= 0 then
        v2 = Quantization.quantizeSignedUnit((assert(a3.VerticalLook)))
        buffer.writei8(a1, v4, v2)
        v4 = v4 + 1
    end
    if bit32.band(a3.FieldMask, 16) ~= 0 then
        v1 = 0
        if a3.OnGround == true then
            v1 = bit32.bor(v1, 1)
        end
        if a3.MovementMode == "Ladder" then
            v1 = bit32.bor(v1, 2)
        end
        if a3.Stance == "Ducking" then
            v1 = bit32.bor(v1, 4)
        end
        buffer.writeu8(a1, v4, v1)
        v4 = v4 + 1
    end
    if bit32.band(a3.FieldMask, 32) ~= 0 then
        v2 = Quantization.quantizeUnitByte((assert(a3.DuckAmount)))
        buffer.writeu8(a1, v4, v2)
        v4 = v4 + 1
    end
    if bit32.band(a3.FieldMask, 64) ~= 0 then
        v1 = assert(a3.SupportKind)
        buffer.writeu8(a1, v4, v1)
        v4 = v4 + 1
        if v1 ~= Enums.SupportKind.None then
            v3 = assert(a3.SupportSourceId)
            buffer.writeu32(a1, v4, v3)
            v4 = v4 + 4
        end
    end
    return v4
end

local function encodeValidated(a1) -- Line: 774
    -- upvalues: Enums (val), deltaActorWireSize (val), writeFullActor (val), writeDeltaActor (val)
    -- upvalues: writeUnsignedVarint (val)
    local ActorId, Generation, UserId, v1, v2, v3, v4, v5
    local v6 = 29
    local v7 = nil
    local v8 = nil
    local v9 = a1
    for i, j in a1.Actors, v7, v8 do
        UserId = j.UserId
        v2 = 1
        while UserId >= 128 do
            UserId = math.floor(UserId / 128)
            v2 = v2 + 1
        end
        ActorId = j.ActorId
        v3 = 1
        while ActorId >= 128 do
            ActorId = math.floor(ActorId / 128)
            v3 = v3 + 1
        end
        v1 = v2 + v3
        Generation = j.Generation
        v2 = 1
        while Generation >= 128 do
            Generation = math.floor(Generation / 128)
            v2 = v2 + 1
        end
        v5 = v1 + v2 + 23
        v6 = v6 + (v5 + (if j.SupportKind ~= Enums.SupportKind.None then 4 else 0))
    end
    for k, n in v9.Deltas do
        v6 = v6 + deltaActorWireSize(n)
    end
    v7 = nil
    v8 = nil
    for m, i5 in v9.RemovedActorIds, v7, v8 do
        v5 = i5
        v4 = 1
        while v5 >= 128 do
            v5 = math.floor(v5 / 128)
            v4 = v4 + 1
        end
        v6 = v6 + v4
    end
    local v10 = buffer.create(v6)
    v7 = 0
    buffer.writeu8(v10, v7, 6)
    v7 = v7 + 1
    v4 = if v9.Kind ~= "Baseline" then 1 else 0
    buffer.writeu8(v10, v7, v4)
    v7 = v7 + 1
    local Sequence = v9.Sequence
    buffer.writeu32(v10, v7, Sequence)
    v7 = v7 + 4
    local BaselineSequence = v9.BaselineSequence
    buffer.writeu32(v10, v7, BaselineSequence)
    v7 = v7 + 4
    local ServerTick = v9.ServerTick
    buffer.writeu32(v10, v7, ServerTick)
    v7 = v7 + 4
    local Epoch = v9.Topology.Epoch
    buffer.writeu16(v10, v7, Epoch)
    v7 = v7 + 2
    local Fingerprint = v9.Topology.Fingerprint
    buffer.writeu32(v10, v7, Fingerprint)
    v7 = v7 + 4
    local DestructibleRevision = v9.Topology.DestructibleRevision
    buffer.writeu32(v10, v7, DestructibleRevision)
    v7 = v7 + 4
    local ChunkIndex = v9.ChunkIndex
    buffer.writeu8(v10, v7, ChunkIndex)
    v7 = v7 + 1
    local ChunkCount = v9.ChunkCount
    buffer.writeu8(v10, v7, ChunkCount)
    v7 = v7 + 1
    v4 = #v9.Actors
    buffer.writeu8(v10, v7, v4)
    v7 = v7 + 1
    v4 = #v9.Deltas
    buffer.writeu8(v10, v7, v4)
    v7 = v7 + 1
    v4 = #v9.RemovedActorIds
    buffer.writeu8(v10, v7, v4)
    v7 = v7 + 1
    assert(v7 == 29, "MovementV2 remote header size drift")
    for i6, i7 in v9.Actors do
        v7 = writeFullActor(v10, v7, i7)
    end
    for i8, i9 in v9.Deltas do
        v7 = writeDeltaActor(v10, v7, i9)
    end
    for i10, i11 in v9.RemovedActorIds do
        v7 = writeUnsignedVarint(v10, v7, i11)
    end
    assert(v7 == buffer.len(v10), "MovementV2 remote payload size drift")
    return v10
end

function u25.encodeValidated(a1) -- Line: 828 -- upvalues: encodeValidated (val)
    return (encodeValidated(a1))
end

function u25.encode(a1) -- Line: 832 -- upvalues: u25 (val), encodeValidated (val)
    local v1, v2 = u25.validate(a1)
    if not v1 then
        return nil, v2
    end
    return (encodeValidated(a1)), nil
end

local function readFullActor(a1, a2) -- Line: 840
    -- upvalues: readUnsignedVarint (val), Serial (val), Quantization (val), Enums (val)
    local v1, v2, v3 = readUnsignedVarint(a1, a2, 8, 9007199254740991)
    local v4 = v1
    local v5 = v2
    if v4 == nil then
        return nil, v5, v3
    end
    v1, v2, v3 = readUnsignedVarint(a1, v5, 5, Serial.UInt32Max)
    local v6 = v1
    v5 = v2
    if v6 == nil then
        return nil, v5, v3
    end
    v1, v2, v3 = readUnsignedVarint(a1, v5, 3, Serial.UInt16Max)
    local v7 = v1
    v5 = v2
    if v7 == nil then
        return nil, v5, v3
    end
    if buffer.len(a1) - v5 < 23 then
        return nil, v5, "RemotePayloadSize"
    end
    local v8 = buffer.readf32(a1, v5)
    local v9 = v5 + 4
    local v10 = buffer.readf32(a1, v9)
    local v11 = v5 + 8
    v1 = (Vector3.new(v8, v10, (buffer.readf32(a1, v11))))
    v5 = v5 + 12
    v8 = buffer.readi16(a1, v5) / 8
    v11 = v5 + 2
    v10 = buffer.readi16(a1, v11) / 8
    local v12 = v5 + 4
    v2 = (Vector3.new(v8, v10, (buffer.readi16(a1, v12)) / 8))
    v5 = v5 + 6
    v3 = Quantization.dequantizeYaw((buffer.readu16(a1, v5)))
    v5 = v5 + 2
    local v13 = Quantization.dequantizeSignedUnit((buffer.readi8(a1, v5)))
    v5 = v5 + 1
    local v14 = buffer.readu8(a1, v5)
    v5 = v5 + 1
    if bit32.band(v14, 4294967232) ~= 0 then
        return nil, v5, "InvalidRemoteActorFlags"
    end
    local v15 = Quantization.dequantizeUnitByte((buffer.readu8(a1, v5)))
    v5 = v5 + 1
    v8 = bit32.band(v14, 56) / 8
    if Enums.SupportKind.Max < v8 then
        return nil, v5, "InvalidActorSupport"
    end
    v10 = 0
    if v8 ~= Enums.SupportKind.None then
        if buffer.len(a1) - v5 < 4 then
            return nil, v5, "RemotePayloadSize"
        end
        v10 = buffer.readu32(a1, v5)
        v5 = v5 + 4
    end
    return {
        UserId = v4,
        ActorId = v6,
        Generation = v7,
        Position = v1,
        Velocity = v2,
        LookYaw = v3,
        VerticalLook = v13,
        MovementMode = if bit32.band(v14, 2) == 0 then "Walking" else "Ladder",
        Stance = if bit32.band(v14, 4) == 0 then "Standing" else "Ducking",
        OnGround = bit32.band(v14, 1) ~= 0,
        DuckAmount = v15,
        SupportKind = v8,
        SupportSourceId = v10,
    }, v5, nil
end

local function readDeltaActor(a1, a2) -- Line: 902
    -- upvalues: readUnsignedVarint (val), Serial (val), Quantization (val), Enums (val), u25 (val)
    local v1, v2, v3 = readUnsignedVarint(a1, a2, 5, Serial.UInt32Max)
    local v4 = v1
    local v5 = v2
    if v4 == nil then
        return nil, v5, v3
    end
    if buffer.len(a1) <= v5 then
        return nil, v5, "RemotePayloadSize"
    end
    v1 = buffer.readu8(a1, v5)
    v5 = v5 + 1
    if v1 ~= 0 and bit32.band(v1, 4294967168) == 0 then
        local v6, v7, v8, v9, v10, v11, v12
        v2 = {ActorId = v4, FieldMask = v1}
        if bit32.band(v1, 1) ~= 0 then
            local v13, v14
            if buffer.len(a1) - v5 < 2 then
                return nil, v5, "RemotePayloadSize"
            end
            v3 = buffer.readi16(a1, v5)
            if v3 ~= -32768 then
                if buffer.len(a1) - v5 < 6 then
                    return nil, v5, "RemotePayloadSize"
                end
                v12 = v3 / 512
                v8 = v5 + 2
                v14 = buffer.readi16(a1, v8) / 512
                v13 = v5 + 4
                v2.PositionDelta = Vector3.new(v12, v14, (buffer.readi16(a1, v13)) / 512)
                v5 = v5 + 6
            else
                if buffer.len(a1) - v5 < 14 then
                    return nil, v5, "RemotePayloadSize"
                end
                v6 = v5 + 2
                v8 = buffer.readf32(a1, v6)
                v9 = v6 + 4
                v13 = buffer.readf32(a1, v9)
                v10 = v6 + 8
                v7 = Vector3.new(v8, v13, (buffer.readf32(a1, v10)))
                v14 = v6 + 12
                v2.AbsolutePosition = v7
                v5 = v14
            end
        end
        if bit32.band(v1, 2) ~= 0 then
            if buffer.len(a1) - v5 < 6 then
                return nil, v5, "RemotePayloadSize"
            end
            v7 = buffer.readi16(a1, v5) / 8
            v9 = v5 + 2
            v8 = buffer.readi16(a1, v9) / 8
            v10 = v5 + 4
            v6 = Vector3.new(v7, v8, (buffer.readi16(a1, v10)) / 8)
            v12 = v5 + 6
            v2.Velocity = v6
            v5 = v12
        end
        if bit32.band(v1, 4) ~= 0 then
            if buffer.len(a1) - v5 < 2 then
                return nil, v5, "RemotePayloadSize"
            end
            v2.LookYaw = Quantization.dequantizeYaw((buffer.readu16(a1, v5)))
            v5 = v5 + 2
        end
        if bit32.band(v1, 8) ~= 0 then
            if buffer.len(a1) <= v5 then
                return nil, v5, "RemotePayloadSize"
            end
            v2.VerticalLook = Quantization.dequantizeSignedUnit((buffer.readi8(a1, v5)))
            v5 = v5 + 1
        end
        if bit32.band(v1, 16) ~= 0 then
            if buffer.len(a1) <= v5 then
                return nil, v5, "RemotePayloadSize"
            end
            v3 = buffer.readu8(a1, v5)
            v5 = v5 + 1
            if bit32.band(v3, 4294967288) ~= 0 then
                return nil, v5, "InvalidRemoteDeltaMovementFlags"
            end
            v2.MovementMode = if bit32.band(v3, 2) == 0 then "Walking" else "Ladder"
            v2.Stance = if bit32.band(v3, 4) == 0 then "Standing" else "Ducking"
            v2.OnGround = bit32.band(v3, 1) ~= 0
        end
        if bit32.band(v1, 32) ~= 0 then
            if buffer.len(a1) <= v5 then
                return nil, v5, "RemotePayloadSize"
            end
            v2.DuckAmount = Quantization.dequantizeUnitByte((buffer.readu8(a1, v5)))
            v5 = v5 + 1
        end
        if bit32.band(v1, 64) ~= 0 then
            if buffer.len(a1) <= v5 then
                return nil, v5, "RemotePayloadSize"
            end
            v3 = buffer.readu8(a1, v5)
            v5 = v5 + 1
            if Enums.SupportKind.Max < v3 then
                return nil, v5, "InvalidRemoteDeltaSupport"
            end
            v11 = 0
            if v3 ~= Enums.SupportKind.None then
                if buffer.len(a1) - v5 < 4 then
                    return nil, v5, "RemotePayloadSize"
                end
                v11 = buffer.readu32(a1, v5)
                v5 = v5 + 4
            end
            v2.SupportKind = v3
            v2.SupportSourceId = v11
        end
        v3, v11 = u25.validateDelta(v2)
        if not v3 then
            return nil, v5, v11
        end
        return v2, v5, nil
    end
    return nil, v5, "InvalidRemoteDeltaFieldMask"
end

function u25.decode(a1) -- Line: 1020
    -- upvalues: u25 (val), readFullActor (val), readDeltaActor (val), readUnsignedVarint (val), Serial (val)
    if typeof(a1) ~= "buffer" then
        return nil, "RemotePayloadNotBuffer"
    end
    local v1 = buffer.len(a1)
    if not (v1 < 29) then
        v1 = buffer.len(a1)
        if not (u25.MaxWireSize < v1) then
            v1 = 0
            if buffer.readu8(a1, v1) ~= 6 then
                return nil, "RemoteVersion"
            end
            v1 = v1 + 1
            local v2 = buffer.readu8(a1, v1)
            v1 = v1 + 1
            if v2 > 1 then
                return nil, "InvalidRemoteSnapshotKind"
            end
            local v3 = buffer.readu32(a1, v1)
            v1 = v1 + 4
            local v4 = buffer.readu32(a1, v1)
            v1 = v1 + 4
            local v5 = buffer.readu32(a1, v1)
            v1 = v1 + 4
            local v6 = buffer.readu16(a1, v1)
            v1 = v1 + 2
            local v7 = buffer.readu32(a1, v1)
            v1 = v1 + 4
            local v8 = buffer.readu32(a1, v1)
            v1 = v1 + 4
            local v9 = buffer.readu8(a1, v1)
            v1 = v1 + 1
            local v10 = buffer.readu8(a1, v1)
            v1 = v1 + 1
            local v11 = buffer.readu8(a1, v1)
            v1 = v1 + 1
            local v12 = buffer.readu8(a1, v1)
            v1 = v1 + 1
            local v13 = buffer.readu8(a1, v1)
            v1 = v1 + 1
            if 22 < v11 + v12 + v13 then
                return nil, "InvalidRemoteActorCount"
            end
            local v14 = v11 * 26 + 29 + v12 * 3 + v13
            local v15 = v11 * 43 + 29 + v12 * 36 + v13 * 5
            if not (buffer.len(a1) < v14) and not (v15 < buffer.len(a1)) then
                local v16, v17, v18, v19, v20, v21, v22
                local v23 = table.create(v11)
                for i = 1, v11 do
                    v18, v19, v20 = readFullActor(a1, v1)
                    v16 = v18
                    v1 = v19
                    if v16 == nil then
                        return nil, v20
                    end
                    v23[i] = v16
                end
                local v24 = table.create(v12)
                for j = 1, v12 do
                    v19, v20, v21 = readDeltaActor(a1, v1)
                    v17 = v19
                    v1 = v20
                    if v17 == nil then
                        return nil, v21
                    end
                    v24[j] = v17
                end
                local v25 = table.create(v13)
                for k = 1, v13 do
                    v20, v21, v22 = readUnsignedVarint(a1, v1, 5, Serial.UInt32Max)
                    v18 = v20
                    v1 = v21
                    if v18 == nil then
                        return nil, v22
                    end
                    v25[k] = v18
                end
                if v1 ~= buffer.len(a1) then
                    return nil, "RemotePayloadSize"
                end
                local v26 = {
                    Kind = if v2 ~= 0 then "Delta" else "Baseline",
                    Sequence = v3,
                    BaselineSequence = v4,
                    ServerTick = v5,
                    Topology = {Epoch = v6, Fingerprint = v7, DestructibleRevision = v8},
                    ChunkIndex = v9,
                    ChunkCount = v10,
                    Actors = v23,
                    Deltas = v24,
                    RemovedActorIds = v25,
                }
                v16, v17 = u25.validate(v26)
                if not v16 then
                    return nil, v17
                end
                return v26, nil
            end
            return nil, "RemotePayloadSize"
        end
    end
    return nil, "RemotePayloadSize"
end

return table.freeze(u25)