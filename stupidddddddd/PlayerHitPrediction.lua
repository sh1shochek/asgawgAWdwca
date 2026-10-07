-- ReplicatedStorage.Components.Common.PlayerHitPrediction
-- Script path: ReplicatedStorage.Components.Common.PlayerHitPrediction
-- Decompile time: 0.63 ms

local v1 = {}
local u1 = {}

local function prune(a1) -- Line: 21 -- upvalues: u1 (val) -- types: a1: number
    while u1[1] do
        if not (1 < a1 - u1[1].CreatedAt) then
            break
        end
        table.remove(u1, 1)
    end
end

function v1.Record(a1, a2, a3, a4) -- Line: 27
    -- upvalues: prune (val), u1 (val)
    local v1 = os.clock()
    prune(v1)
    if #u1 >= 64 then
        table.remove(u1, 1)
    end
    u1[#u1 + 1] = {
        ShotSeq = a1,
        VictimUserId = a2,
        HitPartName = a3,
        Position = a4,
        CreatedAt = v1,
    }
end

function v1.Consume(a1, a2, a3, a4) -- Line: 42
    -- upvalues: prune (val), u1 (val)
    prune(os.clock())
    for i, j in u1 do
        if j.ShotSeq == a1 and j.VictimUserId == a2 and j.HitPartName == a3 and (j.Position - a4).Magnitude <= 6 then
            table.remove(u1, i)
            return true
        end
    end
    return false
end

return table.freeze(v1)