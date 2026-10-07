-- ReplicatedStorage.MovementV2.Client.CommandState
-- Script path: ReplicatedStorage.MovementV2.Client.CommandState
-- Decompile time: 1.03 ms

local Enums = require(script.Parent.Parent.Enums)
local Serial = require(script.Parent.Parent.Serial)
local Config = require(script.Parent.Parent.Simulation.Config)
local State = require(script.Parent.Parent.Simulation.State)
require(script.Parent.Parent.Types)
local v1 = {}

local function finiteSpeed(a1) -- Line: 16
    local v1 = false
    if type(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = (math.abs(a1)) < (1 / 0)
        end
    end
    return v1
end

function v1.forCommand(a1, a2, a3, a4, a5, a6) -- Line: 20
    -- upvalues: Enums (val), Config (val), State (val)
    local PredictedWeaponMoveSpeed = a2.PredictedWeaponMoveSpeed or a1.WeaponMoveSpeed
    local PredictedWeaponScopedMoveSpeed = a2.PredictedWeaponScopedMoveSpeed or a1.WeaponScopedMoveSpeed
    local PredictedBaseMoveSpeed = if a5 then nil else a2.PredictedBaseMoveSpeed
    if PredictedBaseMoveSpeed == nil and a4 ~= nil then
        PredictedBaseMoveSpeed = a4(
            a1.BaseMoveSpeed,
            a3,
            PredictedWeaponMoveSpeed,
            PredictedWeaponScopedMoveSpeed,
            Enums.Buttons.has(a2.Buttons, Enums.Buttons.Scoped)
        )
    end
    local v1 = false
    if type(PredictedBaseMoveSpeed) == "number" then
        v1 = false
        if PredictedBaseMoveSpeed == PredictedBaseMoveSpeed then
            v1 = (math.abs(PredictedBaseMoveSpeed)) < (1 / 0)
        end
    end
    if not v1 then
        PredictedBaseMoveSpeed = a1.BaseMoveSpeed
    end
    local v2 = math.clamp(PredictedBaseMoveSpeed, 0, Config.Default.MaxBaseMoveSpeed)
    if a6 then
        v2 = 0
    end
    if v2 == a1.BaseMoveSpeed
        and PredictedWeaponMoveSpeed == a1.WeaponMoveSpeed
        and PredictedWeaponScopedMoveSpeed == a1.WeaponScopedMoveSpeed then
        return a1
    end
    v1 = State.clone(a1)
    v1.BaseMoveSpeed = v2
    v1.WeaponMoveSpeed = math.clamp(PredictedWeaponMoveSpeed, 0, Config.Default.MaxBaseMoveSpeed)
    v1.WeaponScopedMoveSpeed = math.clamp(PredictedWeaponScopedMoveSpeed, 0, Config.Default.MaxBaseMoveSpeed)
    return v1
end

function v1.serverTimeAtTick(a1, a2, a3) -- Line: 61 -- upvalues: Serial (val) -- types: a2: number, a3: number
    return a1.ServerTime + Serial.deltaUInt32(a2, a1.ServerTick) * a3
end

return table.freeze(v1)