-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.update
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.update
-- Decompile time: 0.42 ms

local Parent_2 = script.Parent.Parent
local Util = require(Parent_2.Util)
local copy = require(script.Parent.copy)

local function call(a1, a2) -- Line: 10 -- types: a1: function, a2: number
    if type(a1) == "function" then
        return a1(a2)
    end
end

return function(a1, a2, a3, a4) -- Line: 44
    -- upvalues: copy (val), Util (val)
    local v1 = #a1
    local v2 = copy(a1)
    if a2 < 1 then
        a2 = a2 + v1
    end
    local returned = if type(a3) ~= "function" then Util.func.returned else a3
    if v2[a2] ~= nil then
        v2[a2] = (returned(v2[a2], a2))
        return v2
    end
    v2[a2] = if type(a4) ~= "function" then nil else a4(a2)
    return v2
end