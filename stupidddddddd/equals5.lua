-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.equals
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.equals
-- Decompile time: 0.50 ms

local Parent_2 = script.Parent.Parent
local Util = require(Parent_2.Util)

local function compare(a1, a2) -- Line: 6
    if type(a1) == "table" and type(a2) == "table" then
        local v1 = #a1
        if #a2 ~= v1 then
            return false
        end
        for i = 1, v1 do
            if a1[i] ~= a2[i] then
                return false
            end
        end
        return true
    end
    return a1 == a2
end

return function(...) -- Line: 44 -- upvalues: Util (val), compare (val)
    if Util.equalObjects(...) then
        return true
    end
    local v1 = select("#", ...)
    local v2 = select(1, ...)
    for i = 2, v1 do
        if not compare(v2, (select(i, ...))) then
            return false
        end
    end
    return true
end