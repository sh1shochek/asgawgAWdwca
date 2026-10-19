-- isSuperset (ModuleScript)
-- full path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.isSuperset

-- Decompiled with Potassium's decompiler.

local isSubset = require(script.Parent.isSubset);

return function(p1: table, p2: table) -- Line: 21, Name: isSuperset
    -- upvalues: isSubset (copy)
    return isSubset(p2, p1);
end;