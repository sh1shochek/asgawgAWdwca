-- ReplicatedStorage.MovementV2.RemoteActorIdentity
-- Script path: ReplicatedStorage.MovementV2.RemoteActorIdentity
-- Decompile time: 0.36 ms

return table.freeze({
    key = function(a1) -- Line: 8 -- types: a1: table
        if a1.UserId == 0 then
            return (("bot:%*"):format(a1.ActorId))
        end
        return a1.UserId
    end,
    keyLess = function(a1, a2) -- Line: 12
        if type(a1) == "number" then
            if type(a2) == "number" then
                return a1 < a2
            end
            return true
        end
        if type(a2) == "number" then
            return false
        end
        return a1 < a2
    end,
    wireLess = function(a1, a2) -- Line: 19 -- types: a1: table, a2: table
        if a1.UserId == 0 and a2.UserId == 0 then
            return a1.ActorId < a2.ActorId
        end
        return a1.UserId < a2.UserId
    end,
})