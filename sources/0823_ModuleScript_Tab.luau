-- Decompiled with Potassium's decompiler.

local u1 = {
    internal = {
        Tabs = {}
    },
    interface = {
        TabAdded = require(script.Parent.Parent.Shared.Signal).new()
    }
};

function u1.interface.new(p2: string, p3: function) -- Line: 15
    -- upvalues: u1 (copy)
    local v4 = type(p2) == "string";
    local v5 = `Expected parameter #1 'name' to be a string, got {type(p2)}`;
    assert(v4, v5);
    local v6 = type(p3) == "function";
    local v7 = `Expected parameter #2 'constructorFunction' to be a function, got {type(p3)}`;
    assert(v6, v7);
    table.insert(u1.internal.Tabs, {
        Name = p2,
        CreateFunction = p3
    });
    u1.interface.TabAdded:Fire(p2);
end;

function u1.interface.getTabConstructor(p8: string) -- Line: 31
    -- upvalues: u1 (copy)
    for _, v in u1.internal.Tabs do
        if v.Name == p8 then
            return v.CreateFunction;
        end;
    end;

    return nil;
end;

function u1.interface.getAllTabs() -- Line: 41
    -- upvalues: u1 (copy)
    local v9 = {};

    for _, v in u1.internal.Tabs do
        table.insert(v9, v.Name);
    end;

    return v9;
end;

return u1.interface;