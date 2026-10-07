-- ReplicatedStorage.Packages.DebugTools.Server.Module
-- Script path: ReplicatedStorage.Packages.DebugTools.Server.Module
-- Decompile time: 0.57 ms

local Shared = script.Parent.Parent.Shared
local Signal = require(Shared.Signal)
local u7 = {internal = {Modules = {}}, prototype = {}}
u7.interface = {ModuleAdded = Signal.new()}

function u7.prototype.Init(a1) end

function u7.interface.new(a1) -- Line: 18 -- upvalues: u7 (val) -- types: a1: string
    local v1 = ("Expected parameter #1 'name' to be a string, got %*"):format((type(a1)))
    assert(type(a1) == "string", v1)
    local v2 = {Name = a1}
    v1 = {__index = u7.prototype}
    local u22 = setmetatable(v2, v1)
    task.defer(function() -- Line: 27 -- upvalues: u7 (upval), a1 (val), u22 (val)
        table.insert(u7.internal.Modules, a1)
        u22:Init()
        u7.interface.ModuleAdded:Fire(u22)
    end)
    return u22
end

function u7.interface.getAllModules() -- Line: 38 -- upvalues: u7 (val)
    return table.clone(u7.internal.Modules)
end

return u7.interface