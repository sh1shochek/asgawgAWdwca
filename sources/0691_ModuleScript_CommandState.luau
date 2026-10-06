-- Decompiled with Potassium's decompiler.

local Enums = require(script.Parent.Parent.Enums);
local Serial = require(script.Parent.Parent.Serial);
local Config = require(script.Parent.Parent.Simulation.Config);
local State = require(script.Parent.Parent.Simulation.State);
require(script.Parent.Parent.Types);
local v1 = {};

local function finiteSpeed(p2) -- Line: 16
    local v3;

    if type(p2) == "number" and p2 == p2 then
        v3 = math.abs(p2) < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

function v1.forCommand(p4: any, p5: any, p6: number, p7: function?, p8: boolean, p9: boolean?) -- Line: 20
    -- upvalues: Enums (copy), Config (copy), State (copy)
    local v10 = p5.PredictedWeaponMoveSpeed or p4.WeaponMoveSpeed;
    local v11 = p5.PredictedWeaponScopedMoveSpeed or p4.WeaponScopedMoveSpeed;
    local v12;

    if p8 then
        v12 = nil;
    else
        v12 = p5.PredictedBaseMoveSpeed;
    end;

    if v12 == nil and p7 ~= nil then
        v12 = p7(p4.BaseMoveSpeed, p6, v10, v11, Enums.Buttons.has(p5.Buttons, Enums.Buttons.Scoped));
    end;

    local v13;

    if type(v12) == "number" and v12 == v12 then
        v13 = math.abs(v12) < (1 / 0);
    else
        v13 = false;
    end;

    if not v13 then
        v12 = p4.BaseMoveSpeed;
    end;

    local v14 = p9 and 0 or math.clamp(v12, 0, Config.Default.MaxBaseMoveSpeed);

    if v14 == p4.BaseMoveSpeed and (v10 == p4.WeaponMoveSpeed and v11 == p4.WeaponScopedMoveSpeed) then
        return p4;
    end;

    local v15 = State.clone(p4);
    v15.BaseMoveSpeed = v14;
    v15.WeaponMoveSpeed = math.clamp(v10, 0, Config.Default.MaxBaseMoveSpeed);
    v15.WeaponScopedMoveSpeed = math.clamp(v11, 0, Config.Default.MaxBaseMoveSpeed);

    return v15;
end;

function v1.serverTimeAtTick(p16: any, p17: number, p18: number) -- Line: 61
    -- upvalues: Serial (copy)
    return p16.ServerTime + Serial.deltaUInt32(p17, p16.ServerTick) * p18;
end;

return table.freeze(v1);