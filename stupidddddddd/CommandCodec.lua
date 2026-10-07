-- ReplicatedStorage.MovementV2.CommandCodec
-- Script path: ReplicatedStorage.MovementV2.CommandCodec
-- Decompile time: 14.96 ms

local Buttons = require(script.Parent.Buttons)
local Config = require(script.Parent.Config)
local Quantization = require(script.Parent.Quantization)
local Serial = require(script.Parent.Serial)
require(script.Parent.Types)
local u25 = {
    Version = 5,
    HeaderSize = 10,
    CommandSize = 6,
    MaxDeltaCommandSize = 7,
    MaxWeaponSelectionSize = 200,
}

local function resolveConfig(a1) -- Line: 41 -- upvalues: Config (val)
    return a1 or Config.Default
end

function u25.validateCommand(a1, a2) -- Line: 45 -- upvalues: Serial (val), Quantization (val), Buttons (val)
    if not Serial.isUInt32(a1) then
        return false, "InvalidCommandNumber"
    end
    if typeof(a2) ~= "table" then
        return false, "CommandNotTable"
    end
    if not Quantization.isFiniteVector2(a2.Move) then
        return false, "InvalidMove"
    end
    if not Quantization.isFinite(a2.LookYaw) then
        return false, "InvalidLookYaw"
    end
    if not Quantization.isFinite(a2.VerticalLook) then
        return false, "InvalidVerticalLook"
    end
    if not Buttons.isValid(a2.Buttons) then
        return false, "InvalidButtons"
    end
    local WeaponSelectRequestId = a2.WeaponSelectRequestId
    local WeaponSelectIdentifier = a2.WeaponSelectIdentifier
    local GrenadeThrowIdentifier = a2.GrenadeThrowIdentifier
    local GrenadeThrowAnimation = a2.GrenadeThrowAnimation
    if WeaponSelectRequestId == nil
        and WeaponSelectIdentifier == nil
        and GrenadeThrowIdentifier == nil
        and GrenadeThrowAnimation == nil then
        return true, nil
    end
    if Serial.isUInt32(WeaponSelectRequestId)
        and WeaponSelectRequestId ~= 0
        and typeof(WeaponSelectIdentifier) == "string"
        and not (#WeaponSelectIdentifier > 96) then
        local v1 = true
        if GrenadeThrowIdentifier == nil then
            v1 = GrenadeThrowAnimation ~= nil
        end
        if not v1 then
            if #WeaponSelectIdentifier < 1 then
                return false, "InvalidWeaponSelection"
            end
            return true, nil
        end
        if type(GrenadeThrowIdentifier) == "string"
            and not (#GrenadeThrowIdentifier < 1)
            and not (#GrenadeThrowIdentifier > 96) then
            if GrenadeThrowAnimation ~= "Far" and GrenadeThrowAnimation ~= "Near" then
                return false, "InvalidGrenadeThrowSelection"
            end
            return true, nil
        end
        return false, "InvalidGrenadeThrowSelection"
    end
    return false, "InvalidWeaponSelection"
end

function u25.canonicalizeCommandInto(a1, a2, a3) -- Line: 94 -- upvalues: u25 (val), Quantization (val)
    if typeof(a1) == "table" and not table.isfrozen(a1) then
        local v1, v2 = u25.validateCommand(a2, a3)
        if not v1 then
            return nil, v2
        end
        local v3 = Quantization.canonicalMove(a3.Move)
        local v4 = Quantization.quantizeSignedUnit(v3.X)
        local v5 = Quantization.quantizeSignedUnit(v3.Y)
        local v6 = Quantization.canonicalMove((Vector2.new(Quantization.dequantizeSignedUnit(v4), Quantization.dequantizeSignedUnit(v5))))
        a1.CommandNumber = a2
        a1.Move = v6
        a1.LookYaw = Quantization.dequantizeYaw(Quantization.quantizeYaw(a3.LookYaw))
        a1.VerticalLook = Quantization.dequantizeSignedUnit(Quantization.quantizeSignedUnit(a3.VerticalLook))
        a1.Buttons = a3.Buttons
        a1.WeaponSelectRequestId = a3.WeaponSelectRequestId
        a1.WeaponSelectIdentifier = a3.WeaponSelectIdentifier
        a1.GrenadeThrowIdentifier = a3.GrenadeThrowIdentifier
        a1.GrenadeThrowAnimation = a3.GrenadeThrowAnimation
        a1.PredictedBaseMoveSpeed = a3.PredictedBaseMoveSpeed
        a1.PredictedWeaponMoveSpeed = a3.PredictedWeaponMoveSpeed
        a1.PredictedWeaponScopedMoveSpeed = a3.PredictedWeaponScopedMoveSpeed
        return a1, nil
    end
    return nil, "InvalidCanonicalCommandTarget"
end

function u25.canonicalizeCommand(a1, a2) -- Line: 125 -- upvalues: u25 (val)
    return u25.canonicalizeCommandInto({}, a1, a2)
end

function u25.validatePacket(a1, a2) -- Line: 129 -- upvalues: Config (val), Serial (val), u25 (val)
    local Default = a2 or Config.Default
    if typeof(a1) ~= "table" then
        return false, "PacketNotTable"
    end
    if not Serial.isNonZeroUInt16(a1.Generation) then
        return false, "InvalidGeneration"
    end
    if not Serial.isUInt32(a1.FirstCommandNumber) then
        return false, "InvalidFirstCommandNumber"
    end
    if typeof(a1.RedundantCommandCount) == "number"
        and a1.RedundantCommandCount % 1 == 0
        and not (a1.RedundantCommandCount < 0)
        and not (Default.TargetRedundantCommandCount < a1.RedundantCommandCount) then
        if typeof(a1.NewCommandCount) == "number"
            and a1.NewCommandCount % 1 == 0
            and not (a1.NewCommandCount < 1)
            and not (Default.MaxNewCommandsPerPacket < a1.NewCommandCount) then
            if typeof(a1.Commands) ~= "table" then
                return false, "CommandsNotTable"
            end
            local v1 = a1.RedundantCommandCount + a1.NewCommandCount
            if v1 == #a1.Commands and not (Default.MaxCommandsPerPacket < v1) and not (v1 > 255) then
                local v2, v3, v4, v5
                for i = 1, v1 do
                    v3 = Serial.addUInt32(a1.FirstCommandNumber, i - 1)
                    v4 = a1.Commands[i]
                    if typeof(v4) == "table" and v4.CommandNumber == v3 then
                        v5, v2 = u25.validateCommand(v3, v4)
                        if v5 then
                            continue
                        end
                        return false, v2
                    end
                    return false, "NonSequentialCommands"
                end
                return true, nil
            end
            return false, "CommandCountMismatch"
        end
        return false, "InvalidNewCommandCount"
    end
    return false, "InvalidRedundantCommandCount"
end

function u25.makePacket(a1, a2, a3, a4) -- Line: 180 -- upvalues: Serial (val), u25 (val)
    if typeof(a2) == "table" and #a2 ~= 0 then
        if typeof(a3) == "number" and a3 % 1 == 0 then
            local v1 = a2[1]
            if typeof(v1) == "table" and Serial.isUInt32(v1.CommandNumber) then
                local v2 = {
                    Generation = a1,
                    FirstCommandNumber = v1.CommandNumber,
                    RedundantCommandCount = #a2 - a3,
                    NewCommandCount = a3,
                    Commands = a2,
                }
                local v3, v4 = u25.validatePacket(v2, a4)
                if not v3 then
                    return nil, v4
                end
                return v2, nil
            end
            return nil, "InvalidFirstCommandNumber"
        end
        return nil, "InvalidNewCommandCount"
    end
    return nil, "CommandsNotTable"
end

local function commandFields(a1) -- Line: 211 -- upvalues: Quantization (val)
    local v1 = Quantization.canonicalMove(a1.Move)
    return (Quantization.quantizeSignedUnit(v1.X)), (Quantization.quantizeSignedUnit(v1.Y)), (Quantization.quantizeYaw(a1.LookYaw)), (Quantization.quantizeSignedUnit(a1.VerticalLook)), a1.Buttons
end

local function changedFieldMask(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) -- Line: 220
    -- upvalues: 
    local v1 = 0
    if a1 ~= a6 then
        v1 = bit32.bor(v1, 1)
    end
    if a2 ~= a7 then
        v1 = bit32.bor(v1, 2)
    end
    if a3 ~= a8 then
        v1 = bit32.bor(v1, 4)
    end
    if a4 ~= a9 then
        v1 = bit32.bor(v1, 8)
    end
    if a5 ~= a10 then
        v1 = bit32.bor(v1, 16)
    end
    return v1
end

local function changedFieldWireSize(a1) -- Line: 251 -- types: a1: number
    local v1 = 0
    if bit32.band(a1, 1) ~= 0 then
        v1 = v1 + 1
    end
    if bit32.band(a1, 2) ~= 0 then
        v1 = v1 + 1
    end
    if bit32.band(a1, 4) ~= 0 then
        v1 = v1 + 2
    end
    if bit32.band(a1, 8) ~= 0 then
        v1 = v1 + 1
    end
    if bit32.band(a1, 16) ~= 0 then
        v1 = v1 + 1
    end
    return v1
end

local function writeFullCommand(a1, a2, a3, a4, a5, a6, a7) -- Line: 271
    -- upvalues: 
    buffer.writei8(a1, a2, a3)
    local v1 = a2 + 1
    buffer.writei8(a1, v1, a4)
    v1 = a2 + 2
    buffer.writeu16(a1, v1, a5)
    v1 = a2 + 4
    buffer.writei8(a1, v1, a6)
    v1 = a2 + 5
    buffer.writeu8(a1, v1, a7)
    return a2 + 6
end

local function writeChangedFields(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 288
    -- upvalues: 
    if bit32.band(a3, 1) ~= 0 then
        buffer.writei8(a1, a2, a4)
        a2 = a2 + 1
    end
    if bit32.band(a3, 2) ~= 0 then
        buffer.writei8(a1, a2, a5)
        a2 = a2 + 1
    end
    if bit32.band(a3, 4) ~= 0 then
        buffer.writeu16(a1, a2, a6)
        a2 = a2 + 2
    end
    if bit32.band(a3, 8) ~= 0 then
        buffer.writei8(a1, a2, a7)
        a2 = a2 + 1
    end
    if bit32.band(a3, 16) ~= 0 then
        buffer.writeu8(a1, a2, a8)
        a2 = a2 + 1
    end
    return a2
end

function u25.encode(a1, a2) -- Line: 321 -- upvalues: u25 (val), Quantization (val), writeChangedFields (val)
    local Buttons_2, Buttons_3, GrenadeThrowAnimation, GrenadeThrowIdentifier, GrenadeThrowIdentifier_2, WeaponSelectIdentifier, WeaponSelectIdentifier_2, WeaponSelectRequestId, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
    local v12, v13 = u25.validatePacket(a1, a2)
    if not v12 then
        return nil, v13
    end
    local v14 = a1.RedundantCommandCount + a1.NewCommandCount
    local v15 = a1.Commands[1]
    local v16 = Quantization.canonicalMove(v15.Move)
    local v17 = Quantization.quantizeSignedUnit(v16.X)
    local v18 = Quantization.quantizeSignedUnit(v16.Y)
    local v19 = Quantization.quantizeYaw(v15.LookYaw)
    local v20 = Quantization.quantizeSignedUnit(v15.VerticalLook)
    local Buttons = v15.Buttons
    v15 = 0
    v16 = 16
    for i = 2, v14 do
        v6 = a1.Commands[i]
        v7 = Quantization.canonicalMove(v6.Move)
        v1 = Quantization.quantizeSignedUnit(v7.X)
        v2 = Quantization.quantizeSignedUnit(v7.Y)
        v3 = Quantization.quantizeYaw(v6.LookYaw)
        v4 = Quantization.quantizeSignedUnit(v6.VerticalLook)
        Buttons_2 = v6.Buttons
        v6 = 0
        if v1 ~= v17 then
            v6 = bit32.bor(v6, 1)
        end
        if v2 ~= v18 then
            v6 = bit32.bor(v6, 2)
        end
        if v3 ~= v19 then
            v6 = bit32.bor(v6, 4)
        end
        if v4 ~= v20 then
            v6 = bit32.bor(v6, 8)
        end
        if Buttons_2 ~= Buttons then
            v6 = bit32.bor(v6, 16)
        end
        v8 = 0
        if bit32.band(v6, 1) ~= 0 then
            v8 = v8 + 1
        end
        if bit32.band(v6, 2) ~= 0 then
            v8 = v8 + 1
        end
        if bit32.band(v6, 4) ~= 0 then
            v8 = v8 + 2
        end
        if bit32.band(v6, 8) ~= 0 then
            v8 = v8 + 1
        end
        if bit32.band(v6, 16) ~= 0 then
            v8 = v8 + 1
        end
        v16 = v16 + (v8 + 1)
        v17 = v1
        v18 = v2
        v19 = v3
        v20 = v4
    end
    local v21 = nil
    local v22 = nil
    for j, k in a1.Commands, v21, v22 do
        WeaponSelectIdentifier_2 = k.WeaponSelectIdentifier
        if WeaponSelectIdentifier_2 ~= nil then
            GrenadeThrowIdentifier_2 = k.GrenadeThrowIdentifier
            v5 = if GrenadeThrowIdentifier_2 == nil then 0 else #GrenadeThrowIdentifier_2
            v15 = v15 + 1
            v16 = v16 + (#WeaponSelectIdentifier_2 + 8 + v5)
        end
    end
    local v23 = buffer.create(v16)
    buffer.writeu8(v23, 0, 5)
    local Generation = a1.Generation
    buffer.writeu16(v23, 1, Generation)
    local FirstCommandNumber = a1.FirstCommandNumber
    buffer.writeu32(v23, 3, FirstCommandNumber)
    local NewCommandCount = a1.NewCommandCount
    buffer.writeu8(v23, 7, NewCommandCount)
    local RedundantCommandCount = a1.RedundantCommandCount
    buffer.writeu8(v23, 8, RedundantCommandCount)
    buffer.writeu8(v23, 9, v15)
    v4 = a1.Commands[1]
    v5 = Quantization.canonicalMove(v4.Move)
    v17 = (Quantization.quantizeSignedUnit(v5.X))
    v18 = (Quantization.quantizeSignedUnit(v5.Y))
    v19 = (Quantization.quantizeYaw(v4.LookYaw))
    v20 = (Quantization.quantizeSignedUnit(v4.VerticalLook))
    local v24 = v4.Buttons
    buffer.writei8(v23, 10, v17)
    buffer.writei8(v23, 11, v18)
    buffer.writeu16(v23, 12, v19)
    buffer.writei8(v23, 14, v20)
    buffer.writeu8(v23, 15, v24)
    v21 = 16
    for n = 2, v14 do
        v8 = a1.Commands[n]
        v9 = Quantization.canonicalMove(v8.Move)
        v3 = Quantization.quantizeSignedUnit(v9.X)
        v4 = Quantization.quantizeSignedUnit(v9.Y)
        v5 = Quantization.quantizeYaw(v8.LookYaw)
        v6 = Quantization.quantizeSignedUnit(v8.VerticalLook)
        Buttons_3 = v8.Buttons
        v8 = 0
        if v3 ~= v17 then
            v8 = bit32.bor(v8, 1)
        end
        if v4 ~= v18 then
            v8 = bit32.bor(v8, 2)
        end
        if v5 ~= v19 then
            v8 = bit32.bor(v8, 4)
        end
        if v6 ~= v20 then
            v8 = bit32.bor(v8, 8)
        end
        if Buttons_3 ~= v24 then
            v8 = bit32.bor(v8, 16)
        end
        buffer.writeu8(v23, v21, v8)
        v21 = writeChangedFields(v23, v21 + 1, v8, v3, v4, v5, v6, Buttons_3)
    end
    v1 = nil
    v2 = nil
    for m, i5 in a1.Commands, v1, v2 do
        WeaponSelectIdentifier = i5.WeaponSelectIdentifier
        if WeaponSelectIdentifier ~= nil then
            GrenadeThrowIdentifier = i5.GrenadeThrowIdentifier
            GrenadeThrowAnimation = i5.GrenadeThrowAnimation
            v8 = if GrenadeThrowIdentifier == nil then 0 else #GrenadeThrowIdentifier
            v9 = if GrenadeThrowAnimation ~= "Far" then if GrenadeThrowAnimation ~= "Near" then 0 else 2 else 1
            v11 = m - 1
            buffer.writeu8(v23, v21, v11)
            v10 = v21 + 1
            WeaponSelectRequestId = i5.WeaponSelectRequestId
            buffer.writeu32(v23, v10, WeaponSelectRequestId)
            v10 = v21 + 5
            v11 = #WeaponSelectIdentifier
            buffer.writeu8(v23, v10, v11)
            v10 = v21 + 6
            buffer.writeu8(v23, v10, v8)
            v10 = v21 + 7
            buffer.writeu8(v23, v10, v9)
            buffer.writestring(v23, v21 + 8, WeaponSelectIdentifier)
            if GrenadeThrowIdentifier ~= nil then
                buffer.writestring(v23, v21 + 8 + #WeaponSelectIdentifier, GrenadeThrowIdentifier)
            end
            v21 = v21 + (#WeaponSelectIdentifier + 8 + v8)
        end
    end
    assert(v21 == buffer.len(v23), "MovementV2 command wire size drift")
    return v23, nil
end

function u25.decode(a1, a2) -- Line: 425 -- upvalues: Config (val), Serial (val), Quantization (val), Buttons (val)
    local Default = a2 or Config.Default
    if typeof(a1) ~= "buffer" then
        return nil, "CommandPayloadNotBuffer"
    end
    local v1 = buffer.len(a1)
    if v1 < 10 then
        return nil, "CommandPayloadTruncated"
    end
    if buffer.readu8(a1, 0) ~= 5 then
        return nil, "CommandVersion"
    end
    local v2 = buffer.readu16(a1, 1)
    local v3 = buffer.readu32(a1, 3)
    local v4 = buffer.readu8(a1, 7)
    local v5 = buffer.readu8(a1, 8)
    local v6 = buffer.readu8(a1, 9)
    local v7 = v4 + v5
    if not Serial.isNonZeroUInt16(v2) then
        return nil, "InvalidGeneration"
    end
    if not (v4 < 1) and not (Default.MaxNewCommandsPerPacket < v4) then
        if Default.TargetRedundantCommandCount < v5 then
            return nil, "InvalidRedundantCommandCount"
        end
        if Default.MaxCommandsPerPacket < v7 then
            return nil, "CommandCountTooLarge"
        end
        if v7 < v6 then
            return nil, "InvalidWeaponSelectionCount"
        end
        local v8 = math.max(0, v7 - 1) * 1 + 16 + v6 * 8
        local v9 = math.max(0, v7 - 1) * 7 + 16 + v6 * 200
        if not (v1 < v8) and not (v9 < v1) then
            local v10, v11, v12, v13, v14, v15, v16, v17, v18
            local v19 = table.create(v7)
            local v20 = 10
            local v21 = buffer.readi8(a1, v20)
            local v22 = v20 + 1
            local v23 = buffer.readi8(a1, v22)
            local v24 = v20 + 2
            local v25 = buffer.readu16(a1, v24)
            local v26 = v20 + 4
            v22 = buffer.readi8(a1, v26)
            local v27 = v20 + 5
            v24 = buffer.readu8(a1, v27)
            v20 = v20 + 6
            local v28 = a1
            for i = 1, v7 do
                if i > 1 then
                    if v1 - v20 < 1 then
                        return nil, "CommandPayloadSize"
                    end
                    v10 = buffer.readu8(v28, v20)
                    v20 = v20 + 1
                    if bit32.band(v10, 4294967264) ~= 0 then
                        return nil, "InvalidCommandDeltaMask"
                    end
                    v11 = 0
                    if bit32.band(v10, 1) ~= 0 then
                        v11 = v11 + 1
                    end
                    if bit32.band(v10, 2) ~= 0 then
                        v11 = v11 + 1
                    end
                    if bit32.band(v10, 4) ~= 0 then
                        v11 = v11 + 2
                    end
                    if bit32.band(v10, 8) ~= 0 then
                        v11 = v11 + 1
                    end
                    if bit32.band(v10, 16) ~= 0 then
                        v11 = v11 + 1
                    end
                    if v1 - v20 < v11 then
                        return nil, "CommandPayloadSize"
                    end
                    if bit32.band(v10, 1) ~= 0 then
                        v21 = buffer.readi8(v28, v20)
                        v20 = v20 + 1
                    end
                    if bit32.band(v10, 2) ~= 0 then
                        v23 = buffer.readi8(v28, v20)
                        v20 = v20 + 1
                    end
                    if bit32.band(v10, 4) ~= 0 then
                        v25 = buffer.readu16(v28, v20)
                        v20 = v20 + 2
                    end
                    if bit32.band(v10, 8) ~= 0 then
                        v22 = buffer.readi8(v28, v20)
                        v20 = v20 + 1
                    end
                    if bit32.band(v10, 16) ~= 0 then
                        v24 = buffer.readu8(v28, v20)
                        v20 = v20 + 1
                    end
                end
                v10 = Quantization.canonicalMove((Vector2.new(Quantization.dequantizeSignedUnit(v21), Quantization.dequantizeSignedUnit(v23))))
                if not Buttons.isValid(v24) then
                    return nil, "InvalidButtons"
                end
                v11 = {
                    CommandNumber = Serial.addUInt32(v3, i - 1),
                    Move = v10,
                    LookYaw = Quantization.dequantizeYaw(v25),
                    VerticalLook = Quantization.dequantizeSignedUnit(v22),
                    Buttons = v24,
                }
                v19[i] = v11
            end
            v26 = {}
            for j = 1, v6 do
                if v1 - v20 < 8 then
                    return nil, "CommandPayloadSize"
                end
                v11 = buffer.readu8(v28, v20) + 1
                v14 = v20 + 1
                v12 = buffer.readu32(v28, v14)
                v15 = v20 + 5
                v13 = buffer.readu8(v28, v15)
                v16 = v20 + 6
                v14 = buffer.readu8(v28, v16)
                v17 = v20 + 7
                v15 = buffer.readu8(v28, v17)
                v16 = v20 + 8 + v13 + v14
                v17 = true
                if v15 == 0 then
                    v17 = v14 ~= 0
                end
                if not (v7 < v11) and v26[v11] ~= true and v12 ~= 0 and not (v13 > 96) and not (v14 > 96) then
                    if not v17 and v13 < 1 then
                        return nil, "InvalidWeaponSelection"
                    end
                    if v17 and v14 < 1 then
                        return nil, "InvalidWeaponSelection"
                    end
                    if v17 and v15 ~= 1 and v15 ~= 2 then
                        return nil, "InvalidWeaponSelection"
                    end
                    if not (v1 < v16) then
                        v18 = v19[v11]
                        v18.WeaponSelectRequestId = v12
                        v18.WeaponSelectIdentifier = buffer.readstring(v28, v20 + 8, v13)
                        if v17 then
                            v18.GrenadeThrowIdentifier = buffer.readstring(v28, v20 + 8 + v13, v14)
                            v18.GrenadeThrowAnimation = if v15 ~= 1 then "Near" else "Far"
                        end
                        continue
                    end
                end
                return nil, "InvalidWeaponSelection"
            end
            if v20 ~= v1 then
                return nil, "CommandPayloadSize"
            end
            for k, n in v19 do
                table.freeze(n)
            end
            table.freeze(v19)
            return (table.freeze({
                Generation = v2,
                FirstCommandNumber = v3,
                RedundantCommandCount = v5,
                NewCommandCount = v4,
                Commands = v19,
            })), nil
        end
        return nil, "CommandPayloadSize"
    end
    return nil, "InvalidNewCommandCount"
end

return table.freeze(u25)