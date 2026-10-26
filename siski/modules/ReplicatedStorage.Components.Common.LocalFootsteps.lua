-- ReplicatedStorage.Components.Common.LocalFootsteps
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = 0;
local u3 = 0.3;
local u4 = 0;
local u5 = (-1 / 0);
local os_clock_ret = os.clock();

local function advance(p6: number) -- Line: 23
    -- upvalues: os_clock_ret (ref), u4 (ref), u2 (ref), u3 (ref)
    local v7 = p6 - os_clock_ret;
    os_clock_ret = p6;
    local math_clamp_ret = math.clamp(u4, -3 * v7, 3 * v7);
    u4 = u4 - math_clamp_ret;
    u2 = (u2 + v7 / u3 + math_clamp_ret) % 2;
end;

function v1.step() -- Line: 32
    -- upvalues: os_clock_ret (ref), u4 (ref), u2 (ref), u3 (ref), u5 (ref)
    local os_clock_ret2 = os.clock();
    local v8 = os_clock_ret2 - os_clock_ret;
    os_clock_ret = os_clock_ret2;
    local math_clamp_ret = math.clamp(u4, -3 * v8, 3 * v8);
    u4 = u4 - math_clamp_ret;
    u2 = (u2 + v8 / u3 + math_clamp_ret) % 2;
    local v9 = os_clock_ret2 - u5;
    u5 = os_clock_ret2;

    if v9 >= 0.15 and v9 <= 0.9 then
        u3 = u3 + (v9 - u3) * 0.5;
    end;

    u4 = math.round(u2) - u2;
end;

function v1.getPhase() -- Line: 44
    -- upvalues: os_clock_ret (ref), u4 (ref), u2 (ref), u3 (ref)
    local os_clock_ret2 = os.clock();
    local v10 = os_clock_ret2 - os_clock_ret;
    os_clock_ret = os_clock_ret2;
    local math_clamp_ret = math.clamp(u4, -3 * v10, 3 * v10);
    u4 = u4 - math_clamp_ret;
    u2 = (u2 + v10 / u3 + math_clamp_ret) % 2;

    return u2;
end;

function v1.isStepping(p11: number) -- Line: 50
    -- upvalues: u5 (ref), u3 (ref)
    return os.clock() - u5 < u3 * p11;
end;

return table.freeze(v1);