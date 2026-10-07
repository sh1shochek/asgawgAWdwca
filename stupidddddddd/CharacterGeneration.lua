-- ReplicatedStorage.Components.Common.CharacterGeneration
-- Script path: ReplicatedStorage.Components.Common.CharacterGeneration
-- Decompile time: 0.57 ms

local u0 = {AttributeName = "CharacterGeneration", MaxValue = 65535}

function u0.IsValid(a1) -- Line: 8 -- upvalues: u0 (val)
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 % 1 == 0 then
            v1 = false
            if a1 >= 1 then
                v1 = a1 <= u0.MaxValue
            end
        end
    end
    return v1
end

function u0.Get(a1) -- Line: 15 -- upvalues: u0 (val) -- types: a1: userdata?
    if a1 == nil then
        return nil
    end
    local Attribute = a1:GetAttribute(u0.AttributeName)
    if u0.IsValid(Attribute) then
        return Attribute
    end
    return nil
end

function u0.Set(a1, a2) -- Line: 23 -- upvalues: u0 (val) -- types: a1: userdata, a2: number
    assert(u0.IsValid(a2), "character generation must be a non-zero u16")
    a1:SetAttribute(u0.AttributeName, a2)
end

function u0.Next(a1) -- Line: 28 -- upvalues: u0 (val) -- types: a1: number?
    if u0.IsValid(a1) and a1 ~= u0.MaxValue then
        return a1 + 1
    end
    return 1
end

function u0.Matches(a1, a2) -- Line: 35 -- upvalues: u0 (val) -- types: a1: userdata?, a2: number
    return u0.Get(a1) == a2
end

return table.freeze(u0)