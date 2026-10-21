-- ReplicatedStorage.Database.Custom.GameStats.Settings.Votekick
-- Script path: ReplicatedStorage.Database.Custom.GameStats.Settings.Votekick
-- Decompile time: 3.34 ms

-- Decompiled with Potassium's decompiler.

local u2 = {
    MIN_LEVEL = 3,
    MINIMUM_ACTIVE_PLAYERS = 4,
    PETITION_PERCENT = 65,

    GetActiveTeam = function(p1) -- Line: 15, Name: GetActiveTeam
        if p1 == "Counter-Terrorists" or p1 == "Terrorists" then
            return p1;
        end;

        return nil;
    end
};

function u2.GetRequiredYesVotes(p3: number) -- Line: 24
    -- upvalues: u2 (copy)
    return math.floor((p3 * u2.PETITION_PERCENT + 50) / 100);
end;

return table.freeze(u2);