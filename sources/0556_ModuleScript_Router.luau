-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
require(ReplicatedStorage.Shared.Promise);
local u2 = {};

local function waitForRouter(p3: string, p4: number) -- Line: 23
    -- upvalues: u2 (copy)
    local v5 = 0;

    while u2[p3] == nil and v5 <= p4 do
        v5 = v5 + task.wait();
    end;

    return u2[p3];
end;

function v1.broadcastRouter(p6: string, ...) -- Line: 34
    -- upvalues: u2 (copy), Profiler (copy)
    local v7 = 0;

    while u2[p6] == nil and v7 <= 1 do
        v7 = v7 + task.wait();
    end;

    local v8 = u2[p6];

    if v8 then
        return Profiler.scope(`Router.{p6}`, v8, ...);
    end;

    warn((`{p6} is not cached in local copy.`));
end;

function v1.observerRouter(p9: string, p10: function) -- Line: 45
    -- upvalues: u2 (copy)
    if u2[p9] then
        warn((`{p9} already has a router cached in local copy.`));

        return;
    end;

    u2[p9] = p10;
end;

return v1;