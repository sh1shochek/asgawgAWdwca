-- ReplicatedStorage.Interface.Screens.Menu.UseItemFrame.Actions
-- Script path: ReplicatedStorage.Interface.Screens.Menu.UseItemFrame.Actions
-- Decompile time: 0.39 ms

local v1 = {}
game:GetService("ReplicatedStorage")
require(script.Types)
local AttachCharm = require(script.AttachCharm)
local u14 = {}

function v1.Register(a1) -- Line: 27 -- upvalues: u14 (val)
    if u14[a1.ActionType] then
        warn((("[Actions] Action \"%*\" is already registered"):format(a1.ActionType)))
        return
    end
    u14[a1.ActionType] = a1
end

function v1.Get(a1) -- Line: 38 -- upvalues: u14 (val) -- types: a1: string
    return u14[a1]
end

function v1.InitializeAll() -- Line: 45 -- upvalues: u14 (val)
    for k, v in pairs(u14) do
        if v.Initialize then
            v.Initialize()
        end
    end
end

v1.Register(AttachCharm)
return v1