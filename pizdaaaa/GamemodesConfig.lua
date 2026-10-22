-- ReplicatedStorage.Shared.Data.GamemodesConfig
-- Script path: ReplicatedStorage.Shared.Data.GamemodesConfig
-- Decompile time: 12.34 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {};
local u3 = nil;
local u4 = nil;

local function Resolve(p5: string, p6: string) -- Line: 15
    -- upvalues: u2 (copy)
    local v7 = u2[p5];

    if not v7 then
        return nil, nil, `unknown gamemode: {p5}`;
    end;

    if not p6 or p6 == "" then
        return nil, nil, "empty path";
    end;

    local string_split_ret = string.split(p6, ".");

    for i = 1, #string_split_ret - 1 do
        local v8 = string_split_ret[i];
        v7 = v7[tonumber(v8) or v8];

        if typeof(v7) ~= "table" then
            return nil, nil, `unknown path: {p6}`;
        end;

        local _ = i;
    end;

    local v9 = string_split_ret[#string_split_ret];
    local v10 = tonumber(v9) or v9;

    if v7[v10] == nil then
        return nil, nil, `unknown path: {p6}`;
    end;

    return v7, v10;
end;

function v1.Get(p11: string) -- Line: 51
    -- upvalues: u2 (copy)
    return u2[p11];
end;

function v1.GetAll() -- Line: 55
    -- upvalues: u2 (copy)
    return u2;
end;

function v1.GetValue(p12: string, p13: string) -- Line: 59
    -- upvalues: Resolve (copy)
    local v14, v15, v16 = Resolve(p12, p13);

    if v14 then
        return v14[v15];
    end;

    return nil, v16;
end;

function v1.Set(p17: string, p18: string, p19: any) -- Line: 70
    -- upvalues: Resolve (copy), u4 (ref)
    local v20, v21, v22 = Resolve(p17, p18);

    if not v20 then
        return false, v22;
    end;

    local v23 = v20[v21];

    if typeof(v23) == "table" then
        return false, `{p18} is a table, not a value`;
    end;

    if typeof(p19) == "string" and typeof(v23) ~= "string" then
        p19 = u4.Coerce(v23, p19);
    end;

    if p19 == nil or typeof(p19) ~= typeof(v23) then
        return false, `{p18} expects {typeof(v23)}`;
    end;

    v20[v21] = p19;

    return true;
end;

function v1.Init(p24) -- Line: 98
    -- upvalues: u3 (ref), u4 (ref), u2 (copy)
    u3 = p24:GetModule("Enums");
    u4 = p24:GetModule("GameConfiguration");

    for _, child in ipairs(script:GetChildren()) do
        u2[child.Name] = require(child)(u3);
    end;
end;

return v1;