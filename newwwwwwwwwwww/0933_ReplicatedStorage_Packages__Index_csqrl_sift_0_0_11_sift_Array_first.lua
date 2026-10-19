-- first (ModuleScript)
-- full path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.first

-- Decompiled with Potassium's decompiler.

local at = require(script.Parent.at);

return function(p1: table) -- Line: 19, Name: first
    -- upvalues: at (copy)
    return at(p1, 1);
end;