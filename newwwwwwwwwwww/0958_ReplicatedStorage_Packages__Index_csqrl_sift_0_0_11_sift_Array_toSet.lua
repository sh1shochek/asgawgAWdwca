-- toSet (ModuleScript)
-- full path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.toSet

-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(p1: table) -- Line: 20, Name: toSet
    local v2 = {};

    for _, v in ipairs(p1) do
        v2[v] = true;
    end;

    return v2;
end;