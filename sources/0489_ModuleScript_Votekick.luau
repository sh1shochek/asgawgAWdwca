-- Decompiled with Potassium's decompiler.

local u2 = {
    MIN_LEVEL = 3,
    MINIMUM_ACTIVE_PLAYERS = 4,
    PETITION_RATIO = 0.5,
    PETITION_EXTRA_YES_VOTES = 1,

    GetActiveTeam = function(p1) -- Line: 16, Name: GetActiveTeam
        if p1 == "Counter-Terrorists" or p1 == "Terrorists" then
            return p1;
        end;

        return nil;
    end
};

function u2.GetRequiredYesVotes(p3: number) -- Line: 25
    -- upvalues: u2 (copy)
    return math.ceil(p3 * u2.PETITION_RATIO) + u2.PETITION_EXTRA_YES_VOTES;
end;

return table.freeze(u2);