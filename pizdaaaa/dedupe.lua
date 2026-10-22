-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.dedupe
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.dedupe
-- Decompile time: 5.09 ms

-- Decompiled with Potassium's decompiler.

local fromArray = require(script.Parent.Parent.Set.fromArray);
local toArray = require(script.Parent.Parent.Set.toArray);

return function(p1: table) -- Line: 4, Name: dedupe
    -- upvalues: toArray (copy), fromArray (copy)
    return toArray(fromArray(p1));
end;