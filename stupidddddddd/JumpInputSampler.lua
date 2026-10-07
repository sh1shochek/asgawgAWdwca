-- ReplicatedStorage.MovementV2.JumpInputSampler
-- Script path: ReplicatedStorage.MovementV2.JumpInputSampler
-- Decompile time: 0.20 ms

return table.freeze({
    sample = function(a1, a2, a3) -- Line: 7 -- types: a1: boolean, a2: boolean, a3: boolean
        if a1 then
            return true, false, false
        end
        if a3 then
            return false, a2, false
        end
        if a2 then
            return true, false, true
        end
        return false, false, false
    end,
})