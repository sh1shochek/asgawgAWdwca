-- ReplicatedStorage.Packages.DebugTools.Shared.Action
-- Script path: ReplicatedStorage.Packages.DebugTools.Shared.Action
-- Decompile time: 1.35 ms

local Signal = require(script.Parent.Signal)
local u5 = {internal = {Registry = {}}}
u5.interface = {ActionAdded = Signal.new(), ActionRemoved = Signal.new()}

function u5.interface.new(a1, a2, a3, a4) -- Line: 34
    -- upvalues: u5 (val)
    local v1 = ("Expected parameter #1 'name' to be a string, got %*"):format((type(a1)))
    assert(type(a1) == "string", v1)
    if a2 ~= nil then
        v1 = ("Expected parameter #2 'description' to be a string, got %*"):format((type(a2)))
        assert(type(a2) == "string", v1)
    end
    v1 = ("Expected parameter #3 'action' to be a string, got %*"):format((type(a3)))
    assert(type(a3) == "function", v1)
    if u5.internal.Registry[a1] then
        u5.interface:UnregisterAction(a1)
    end
    local v2 = {Name = a1, Description = a2, Action = a3, Arguments = a4}
    u5.internal.Registry[a1] = v2
    u5.interface.ActionAdded:Fire(a1)
end

function u5.interface.GetDefinition(a1, a2) -- Line: 60 -- upvalues: u5 (val) -- types: a1: table, a2: string
    local v1 = u5.internal.Registry[a2]
    assert(v1, (("Action '%*' doesn't exist in the registry!"):format(a2)))
    return {Name = a2, Description = v1.Description, Arguments = v1.Arguments}
end

function u5.interface.GetAll(a1) -- Line: 75 -- upvalues: u5 (val)
    local v1 = {}
    for i, j in u5.internal.Registry do
        table.insert(v1, {Name = j.Name, Description = j.Description, Arguments = j.Arguments})
    end
    return v1
end

function u5.interface.Execute(a1, a2, a3) -- Line: 101 -- upvalues: u5 (val) -- types: a1: table, a2: string, a3: table?
    local v1 = a3 or {}
    local v2 = u5.internal.Registry[a2]
    assert(v2, (("Action definition doesn't exist for action '%*'"):format(a2)))
    if v2.Arguments then
        local ClassName, Type, v3, v4
        local v5 = nil
        local v6 = nil
        for i, j in v2.Arguments, v5, v6 do
            v4 = v1[i]
            if not j.Optional or v4 then
                ClassName = typeof(v4)
                if ClassName == "Instance" then
                    ClassName = v4.ClassName
                end
                v3 = j.Type == ClassName
                Type = j.Type
                assert(v3, (("Action argument #%* doesn't match the definition, got '%*' expected '%*'"):format(i, ClassName, Type)))
            else
                v1[i] = j.Default
            end
        end
    end
    return v2.Action(table.unpack(v1))
end

function u5.interface.UnregisterAction(a1, a2) -- Line: 132 -- upvalues: u5 (val) -- types: a1: table, a2: string
    u5.internal.Registry[a2] = nil
    u5.interface.ActionRemoved:Fire(a2)
end

return u5.interface