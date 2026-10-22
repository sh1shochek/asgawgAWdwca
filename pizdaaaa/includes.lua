-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.includes
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.includes
-- Decompile time: 4.55 ms

-- Decompiled with Potassium's decompiler.

local find = require(script.Parent.find);

return function(p1: table, p2: any, p3: number?) -- Line: 28, Name: includes
    -- upvalues: find (copy)
    return find(p1, p2, p3) ~= nil;
end;