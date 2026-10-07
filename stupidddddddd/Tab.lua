-- ReplicatedStorage.Packages.DebugTools.Client.Tab
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Tab
-- Decompile time: 0.69 ms

local Shared = script.Parent.Parent.Shared
local Signal = require(Shared.Signal)
local u7 = {internal = {Tabs = {}}}
u7.interface = {TabAdded = Signal.new()}

function u7.interface.new(a1, a2) -- Line: 15 -- upvalues: u7 (val) -- types: a1: string, a2: function
    local v1 = ("Expected parameter #1 'name' to be a string, got %*"):format((type(a1)))
    assert(type(a1) == "string", v1)
    v1 = ("Expected parameter #2 'constructorFunction' to be a function, got %*"):format((type(a2)))
    assert(type(a2) == "function", v1)
    table.insert(u7.internal.Tabs, {Name = a1, CreateFunction = a2})
    u7.interface.TabAdded:Fire(a1)
end

function u7.interface.getTabConstructor(a1) -- Line: 31 -- upvalues: u7 (val) -- types: a1: string
    for i, j in u7.internal.Tabs do
        if j.Name == a1 then
            return j.CreateFunction
        end
    end
    return nil
end

function u7.interface.getAllTabs() -- Line: 41 -- upvalues: u7 (val)
    local v1 = {}
    for i, j in u7.internal.Tabs do
        table.insert(v1, j.Name)
    end
    return v1
end

return u7.interface