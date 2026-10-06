-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);
local toSet = require(script.Parent.toSet);
local toArray = require(script.Parent.Parent.Set.toArray);
local differenceSymmetric = require(script.Parent.Parent.Set.differenceSymmetric);

return function(p1, ...) -- Line: 25, Name: differenceSymmetric
    -- upvalues: toSet (copy), differenceSymmetric (copy), toArray (copy)
    local v2 = toSet(p1);
    local v3 = {};

    for _, v in { ... } do
        if typeof(v) == "table" then
            table.insert(v3, toSet(v));
        end;
    end;

    return toArray((differenceSymmetric(v2, unpack(v3))));
end;