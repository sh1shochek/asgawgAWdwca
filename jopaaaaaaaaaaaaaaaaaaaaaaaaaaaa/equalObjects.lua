-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Util.equalObjects
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Util.equalObjects
-- Decompile time: 3.02 ms

-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(...) -- Line: 20, Name: equalObjects
    local v1 = select(1, ...);

    for i = 2, select("#", ...) do
        if v1 ~= select(i, ...) then
            return false;
        end;

        local _ = i;
    end;

    return true;
end;