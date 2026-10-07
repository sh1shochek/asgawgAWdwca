-- ReplicatedStorage.Database.Security.Router
-- Script path: ReplicatedStorage.Database.Security.Router
-- Decompile time: 0.66 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
require(ReplicatedStorage.Shared.Promise)
local u19 = {}

local function waitForRouter(a1, a2) -- Line: 23 -- upvalues: u19 (val) -- types: a1: string, a2: number
    local v1 = 0
    while u19[a1] == nil do
        if not (v1 <= a2) then
            break
        end
        v1 = v1 + task.wait()
    end
    return u19[a1]
end

function v1.broadcastRouter(a1, ...) -- Line: 34 -- upvalues: u19 (val), Profiler (val) -- types: a1: string
    local v1 = 0
    while u19[a1] == nil do
        if not (v1 <= 1) then
            break
        end
        v1 = v1 + task.wait()
    end
    local v2 = u19[a1]
    if v2 then
        return Profiler.scope(("Router.%*"):format(a1), v2, ...)
    end
    warn((("%* is not cached in local copy."):format(a1)))
end

function v1.observerRouter(a1, a2) -- Line: 45 -- upvalues: u19 (val) -- types: a1: string, a2: function
    if u19[a1] then
        warn((("%* already has a router cached in local copy."):format(a1)))
        return
    end
    u19[a1] = a2
end

return v1