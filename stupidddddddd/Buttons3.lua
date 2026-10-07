-- ReplicatedStorage.MovementV2.Buttons
-- Script path: ReplicatedStorage.MovementV2.Buttons
-- Decompile time: 0.44 ms

local u0 = {
    Jump = 1,
    Duck = 2,
    Walk = 4,
    Scoped = 8,
    ValidMask = 15,
}

function u0.isValid(a1) -- Line: 13 -- upvalues: u0 (val)
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 % 1 == 0 then
            v1 = false
            if a1 >= 0 then
                v1 = false
                if a1 <= 255 then
                    v1 = bit32.band(a1, (bit32.bnot(u0.ValidMask))) == 0
                end
            end
        end
    end
    return v1
end

function u0.has(a1, a2) -- Line: 21 -- types: a1: number, a2: number
    return bit32.band(a1, a2) ~= 0
end

function u0.with(a1, a2, a3) -- Line: 25 -- types: a1: number, a2: number, a3: boolean
    if a3 then
        return (bit32.bor(a1, a2))
    end
    return (bit32.band(a1, (bit32.bnot(a2))))
end

return table.freeze(u0)