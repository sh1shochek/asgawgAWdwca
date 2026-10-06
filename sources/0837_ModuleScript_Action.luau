-- Decompiled with Potassium's decompiler.

local Signal = require(script.Parent.Signal);
local u1 = {
    internal = {
        Registry = {}
    },
    interface = {
        ActionAdded = Signal.new(),
        ActionRemoved = Signal.new()
    }
};

function u1.interface.new(p2: string, p3: string?, p4: function, p5: table) -- Line: 34
    -- upvalues: u1 (copy)
    local v6 = type(p2) == "string";
    local v7 = `Expected parameter #1 'name' to be a string, got {type(p2)}`;
    assert(v6, v7);

    if p3 ~= nil then
        local v8 = type(p3) == "string";
        local v9 = `Expected parameter #2 'description' to be a string, got {type(p3)}`;
        assert(v8, v9);
    end;

    local v10 = type(p4) == "function";
    local v11 = `Expected parameter #3 'action' to be a string, got {type(p4)}`;
    assert(v10, v11);

    if u1.internal.Registry[p2] then
        u1.interface:UnregisterAction(p2);
    end;

    u1.internal.Registry[p2] = {
        Name = p2,
        Description = p3,
        Action = p4,
        Arguments = p5
    };
    u1.interface.ActionAdded:Fire(p2);
end;

function u1.interface.GetDefinition(p12: table, p13: string) -- Line: 60
    -- upvalues: u1 (copy)
    local v14 = u1.internal.Registry[p13];
    local v15 = `Action '{p13}' doesn't exist in the registry!`;
    assert(v14, v15);

    return {
        Name = p13,
        Description = v14.Description,
        Arguments = v14.Arguments
    };
end;

function u1.interface.GetAll(p16) -- Line: 75
    -- upvalues: u1 (copy)
    local v17 = {};

    for _, v in u1.internal.Registry do
        table.insert(v17, {
            Name = v.Name,
            Description = v.Description,
            Arguments = v.Arguments
        });
    end;

    return v17;
end;

function u1.interface.Execute(p18: table, p19: string, p20: table?) -- Line: 101
    -- upvalues: u1 (copy)
    local v21 = p20 or {};
    local v22 = u1.internal.Registry[p19];
    local v23 = `Action definition doesn't exist for action '{p19}'`;
    assert(v22, v23);

    if v22.Arguments then
        for i, v in v22.Arguments do
            local v24 = v21[i];

            if v.Optional and not v24 then
                v21[i] = v.Default;
            else
                local v25 = typeof(v24);

                if v25 == "Instance" then
                    v25 = v24.ClassName;
                end;

                local v26 = v.Type == v25;
                local v27 = `Action argument #{i} doesn't match the definition, got '{v25}' expected '{v.Type}'`;
                assert(v26, v27);
            end;
        end;
    end;

    return v22.Action(table.unpack(v21));
end;

function u1.interface.UnregisterAction(p28: table, p29: string) -- Line: 132
    -- upvalues: u1 (copy)
    u1.internal.Registry[p29] = nil;
    u1.interface.ActionRemoved:Fire(p29);
end;

return u1.interface;