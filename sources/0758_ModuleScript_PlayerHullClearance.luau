-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);
require(script.Parent.Config);
local PlayerContacts = require(script.Parent.PlayerContacts);
local v1 = {};

local function halfSize(p2, p3) -- Line: 15
    local v4;

    if p2 == "Ducking" then
        v4 = p3.PlayerSizeDucking;
    else
        v4 = p3.PlayerSizeStanding;
    end;

    return v4 * 0.5;
end;

function v1.bounds(p5: vector, p6: any, p7: any) -- Line: 19
    local PlayerSizeStanding = p7.PlayerSizeStanding;
    local PlayerSizeDucking = p7.PlayerSizeDucking;
    local math_max_ret = math.max(PlayerSizeStanding.X, PlayerSizeDucking.X);
    local math_max_ret2 = math.max(PlayerSizeStanding.Y, PlayerSizeDucking.Y);
    local math_max_ret3 = math.max(PlayerSizeStanding.Z, PlayerSizeDucking.Z);
    local v8 = Vector3.new(math_max_ret, math_max_ret2, math_max_ret3) * 0.5;
    local v9;

    if p6 == "Ducking" then
        v9 = p7.PlayerSizeDucking;
    else
        v9 = p7.PlayerSizeStanding;
    end;

    local v10 = v9 * 0.5 + v8;

    return p5 - v10, p5 + v10;
end;

function v1.overlaps(p11: vector, p12: any, p13: vector, p14: any, p15: any) -- Line: 30
    -- upvalues: PlayerContacts (copy)
    local v16;

    if p12 == "Ducking" then
        v16 = p15.PlayerSizeDucking;
    else
        v16 = p15.PlayerSizeStanding;
    end;

    local v17;

    if p14 == "Ducking" then
        v17 = p15.PlayerSizeDucking;
    else
        v17 = p15.PlayerSizeStanding;
    end;

    local v18 = v16 * 0.5 + v17 * 0.5;
    local v19 = p11 - p13;
    local DefaultContactEpsilon = PlayerContacts.DefaultContactEpsilon;
    local v20;

    if math.abs(v19.X) < v18.X - DefaultContactEpsilon and math.abs(v19.Y) < v18.Y - DefaultContactEpsilon then
        v20 = math.abs(v19.Z) < v18.Z - DefaultContactEpsilon;
    else
        v20 = false;
    end;

    return v20;
end;

return table.freeze(v1);