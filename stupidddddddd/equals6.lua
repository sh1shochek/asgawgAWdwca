-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.equals
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.equals
-- Decompile time: 0.49 ms

local Parent = script.Parent.Parent
local Util = require(Parent.Util)
require(Parent.Types)

local function compare(a1, a2) -- Line: 7
    if type(a1) == "table" and type(a2) == "table" then
        for k, v in pairs(a1) do
            if a2[k] ~= v then
                return false
            end
        end
        for k2, i in pairs(a2) do
            if a1[k2] ~= i then
                return false
            end
        end
        return true
    end
    return a1 == a2
end

return function(...) -- Line: 45 -- upvalues: Util (val), compare (val)
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