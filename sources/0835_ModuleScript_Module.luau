-- Decompiled with Potassium's decompiler.

local u1 = {
    internal = {
        Modules = {}
    },
    prototype = {},
    interface = {
        ModuleAdded = require(script.Parent.Parent.Shared.Signal).new()
    }
};

function u1.prototype.Init(p2) -- Line: 16
end;

function u1.interface.new(u3: string) -- Line: 18
    -- upvalues: u1 (copy)
    local v4 = type(u3) == "string";
    local v5 = `Expected parameter #1 'name' to be a string, got {type(u3)}`;
    assert(v4, v5);
    local u6 = setmetatable({
        Name = u3
    }, {
        __index = u1.prototype
    });
    task.defer(function() -- Line: 27
        -- upvalues: u1 (ref), u3 (copy), u6 (copy)
        table.insert(u1.internal.Modules, u3);
        u6:Init();
        u1.interface.ModuleAdded:Fire(u6);
    end);

    return u6;
end;

function u1.interface.getAllModules() -- Line: 38
    -- upvalues: u1 (copy)
    return table.clone(u1.internal.Modules);
end;

return u1.interface;