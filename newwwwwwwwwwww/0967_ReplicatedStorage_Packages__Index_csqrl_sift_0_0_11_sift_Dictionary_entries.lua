-- entries (ModuleScript)
-- full path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.entries

-- Decompiled with Potassium's decompiler.

return function(p1: table) -- Line: 17, Name: entries
    local v2 = {};

    for i, v in pairs(p1) do
        table.insert(v2, { i, v });
    end;

    return v2;
end;