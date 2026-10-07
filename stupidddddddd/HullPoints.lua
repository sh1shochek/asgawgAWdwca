-- ReplicatedStorage.MovementV2.Collision.HullPoints
-- Script path: ReplicatedStorage.MovementV2.Collision.HullPoints
-- Decompile time: 1.20 ms

local u0 = {Attribute = "MovementHullPoints", MinPoints = 4, MaxPoints = 256}
local u4 = {}

local function isFinite(a1) -- Line: 13 -- types: a1: number?
    local v1 = false
    if a1 ~= nil then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 > (-1 / 0) then
                v1 = a1 < (1 / 0)
            end
        end
    end
    return v1
end

function u0.Decode(a1) -- Line: 17 -- upvalues: u4 (val), u0 (val)
    local v1, v2, v3, v4, v5
    if typeof(a1) ~= "string" then
        return nil, "hull points must be a string"
    end
    local v6 = u4[a1]
    if v6 ~= nil then
        return v6, nil
    end
    local v7 = {}
    for i, j in string.split(a1, ";") do
        v4 = string.split(j, ",")
        v5 = tonumber(v4[1])
        v1 = tonumber(v4[2])
        v2 = tonumber(v4[3])
        if #v4 == 3 then
            v3 = false
            if v5 ~= nil then
                v3 = false
                if v5 == v5 then
                    v3 = false
                    if v5 > (-1 / 0) then
                        v3 = v5 < (1 / 0)
                    end
                end
            end
            if v3 then
                v3 = false
                if v1 ~= nil then
                    v3 = false
                    if v1 == v1 then
                        v3 = false
                        if v1 > (-1 / 0) then
                            v3 = v1 < (1 / 0)
                        end
                    end
                end
                if v3 then
                    v3 = false
                    if v2 ~= nil then
                        v3 = false
                        if v2 == v2 then
                            v3 = false
                            if v2 > (-1 / 0) then
                                v3 = v2 < (1 / 0)
                            end
                        end
                    end
                    if v3 then
                        v7[#v7 + 1] = (Vector3.new(v5, v1, v2))
                        continue
                    end
                end
            end
        end
        return nil, "hull points must be finite x,y,z triples"
    end
    if not (#v7 < u0.MinPoints) and not (u0.MaxPoints < #v7) then
        table.freeze(v7)
        u4[a1] = v7
        return v7, nil
    end
    return nil, string.format("hull points need %d-%d points", u0.MinPoints, u0.MaxPoints)
end

function u0.Read(a1) -- Line: 43 -- upvalues: u0 (val) -- types: a1: userdata
    local Attribute_2 = a1:GetAttribute(u0.Attribute)
    if Attribute_2 == nil then
        return nil
    end
    return (u0.Decode(Attribute_2))
end

return table.freeze(u0)