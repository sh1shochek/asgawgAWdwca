-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.equalsDeep
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.equalsDeep
-- Decompile time: 0.61 ms

local compareDeep
local Parent = script.Parent.Parent
local Util = require(Parent.Util)
require(Parent.Types)

function compareDeep(a1, a2) -- Line: 7 -- upvalues: compareDeep (val)
    if type(a1) == "table" and type(a2) == "table" then
        for k, v in pairs(a1) do
            if not compareDeep(v, a2[k]) then
                return false
            end
        end
        for k2, i in pairs(a2) do
            if not compareDeep(i, a1[k2]) then
                return false
            end
        end
        return true
    end
    return a1 == a2
end

return function(...) -- Line: 45 -- upvalues: Util (val), compareDeep (val)
    if Util.equalObjects(...) then
        return true
    end
    local v1 = select("#", ...)
    local v2 = select(1, ...)
    for i = 2, v1 do
        if not compareDeep(v2, (select(i, ...))) then
            return false
        end
    end
    return true
end