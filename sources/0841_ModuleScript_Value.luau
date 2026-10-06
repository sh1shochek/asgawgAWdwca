-- Decompiled with Potassium's decompiler.

local Signal = require(script.Parent.Signal);
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 6
    -- upvalues: Signal (copy), u1 (copy)
    local v4 = {
        _value = p2,
        _changed = Signal.new(),

        __tostring = function(p3) -- Line: 10, Name: __tostring
            return "Value<" .. p3._value .. ">";
        end
    };

    return setmetatable(v4, u1);
end;

function u1.Observe(p5: table, p6: function) -- Line: 18
    p6(p5._value);

    return p5._changed:Connect(p6);
end;

function u1.Subscribe(p7: table, p8: function) -- Line: 23
    return p7._changed:Connect(p8);
end;

function u1.Set(p9: table, p10: any, p11: boolean?) -- Line: 27
    if not p11 and p10 == p9._value then
        return;
    end;

    p9._value = p10;
    p9._changed:Fire(p10);
end;

function u1.Get(p12) -- Line: 36
    return p12._value;
end;

function u1.Destroy(p13) -- Line: 40
    p13._changed:Destroy();
end;

return u1;