-- ReplicatedStorage.Database.Custom.GameStats.Settings.Votekick
-- Script path: ReplicatedStorage.Database.Custom.GameStats.Settings.Votekick
-- Decompile time: 0.27 ms

local u0 = {MIN_LEVEL = 3, MINIMUM_ACTIVE_PLAYERS = 4, PETITION_RATIO = 0.5, PETITION_EXTRA_YES_VOTES = 1}

function u0.GetActiveTeam(a1) -- Line: 16
    if a1 ~= "Counter-Terrorists" and a1 ~= "Terrorists" then
        return nil
    end
    return a1
end

function u0.GetRequiredYesVotes(a1) -- Line: 25 -- upvalues: u0 (val) -- types: a1: number
    return (math.ceil(a1 * u0.PETITION_RATIO)) + u0.PETITION_EXTRA_YES_VOTES
end

return table.freeze(u0)