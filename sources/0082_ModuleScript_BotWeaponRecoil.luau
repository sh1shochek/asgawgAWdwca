-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Spring = require(ReplicatedStorage.Shared.Spring);
local GetWeaponProperties = require(script.Parent.GetWeaponProperties);
local u1 = {};
u1.__index = u1;

function u1.new(p2: string) -- Line: 9
    -- upvalues: GetWeaponProperties (copy), Spring (copy), u1 (copy)
    local v3 = GetWeaponProperties(p2);
    local v4;

    if v3 then
        v4 = v3.Recoil;
    else
        v4 = v3;
    end;

    if not v4 or type(v4.Pattern) ~= "function" then
        return nil;
    end;

    local v5 = {
        PatternTime = 0,
        RecoveryTime = 0,
        Properties = v3,
        Pattern = v4.Pattern(v3),
        Spring = Spring.new(v4.Damper, v4.Speed, Vector2.zero),
        Value = Vector2.zero
    };

    return setmetatable(v5, u1);
end;

function u1.Step(p6: table, p7: number) -- Line: 25
    local v8 = not p6.LastUpdate and 0 or math.max(0, p7 - p6.LastUpdate);
    local v9;

    if p6.LastShot then
        v9 = p6.LastShot + p6.Properties.FireRate;
    else
        v9 = p7;
    end;

    local v10 = p7 - math.max(p6.LastUpdate or p7, v9);
    local math_max_ret = math.max(0, v10);
    local RecoverySpeed = p6.Properties.Recoil.RecoverySpeed;

    if math_max_ret > 0 then
        local Magnitude = p6.Value.Magnitude;
        local v11;

        if Magnitude > 0 then
            v11 = p6.Value * math.max(0, 1 - RecoverySpeed * math_max_ret / Magnitude);
        else
            v11 = p6.Value;
        end;

        p6.Value = v11;
        p6.PatternTime = math.max(0, p6.PatternTime - p6.RecoveryTime * RecoverySpeed * math_max_ret);
    end;

    p6.Spring:setGoal(p6.Value);
    p6.Spring:update(v8);
    p6.LastUpdate = p7;

    return p6.Spring:getPosition() * math.rad(p6.Properties.Recoil.Scale) * p6.Properties.Recoil.CameraScale;
end;

function u1.OnShot(p12: table, p13: number) -- Line: 41
    p12:Step(p13);
    p12.LastShot = p13;
    p12.PatternTime = p12.PatternTime + p12.Properties.FireRate;
    p12.RecoveryTime = p12.PatternTime;
    p12.Value = p12.Pattern(p12.PatternTime);
    p12.Spring:setGoal(p12.Value);
end;

return table.freeze(u1);