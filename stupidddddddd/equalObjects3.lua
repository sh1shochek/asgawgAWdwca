-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Util.equalObjects
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Util.equalObjects
-- Decompile time: 0.22 ms

require(script.Parent.Parent.Types)
return function(...) -- Line: 20
    local v1 = select(1, ...)
    for i = 2, (select("#", ...)) do
        if v1 ~= select(i, ...) then
            return false
        end
    end
    return true
end