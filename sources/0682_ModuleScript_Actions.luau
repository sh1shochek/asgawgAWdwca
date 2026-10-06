-- Decompiled with Potassium's decompiler.

local v1 = {};
game:GetService("ReplicatedStorage");
require(script.Types);
local script_AttachCharm = require(script.AttachCharm);
local u2 = {};

function v1.Register(p3) -- Line: 27
    -- upvalues: u2 (copy)
    if u2[p3.ActionType] then
        warn((`[Actions] Action "{p3.ActionType}" is already registered`));

        return;
    end;

    u2[p3.ActionType] = p3;
end;

function v1.Get(p4: string) -- Line: 38
    -- upvalues: u2 (copy)
    return u2[p4];
end;

function v1.InitializeAll() -- Line: 45
    -- upvalues: u2 (copy)
    for _, v in pairs(u2) do
        if v.Initialize then
            v.Initialize();
        end;
    end;
end;

v1.Register(script_AttachCharm);

return v1;