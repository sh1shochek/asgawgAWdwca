-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);
local toSet = require(script.Parent.toSet);
local toArray = require(script.Parent.Parent.Set.toArray);
local difference = require(script.Parent.Parent.Set.difference);

return function(p1, ...) -- Line: 25, Name: difference
    -- upvalues: toSet (copy), difference (copy), toArray (copy)
    local v2 = toSet(p1);
    local v3 = {};

    for _, v in { ... } do
        if typeof(v) == "table" then
            table.insert(v3, toSet(v));
        end;
    end;

    return toArray((difference(v2, unpack(v3))));
end;