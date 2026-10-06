-- Decompiled with Potassium's decompiler.

local u1 = {
    Shared = table.freeze({
        MissionCreditRewardMultipliers = table.freeze({
            hourly = "HourlyMissionCreditRewardMultiplier",
            daily = "DailyMissionCreditRewardMultiplier",
            weekly = "WeeklyMissionCreditRewardMultiplier",
            monthly = "MonthlyMissionCreditRewardMultiplier"
        })
    }),
    ServerOnly = table.freeze({
        GameplayCreditRewardMultiplier = "GameplayCreditRewardMultiplier"
    }),
    Defaults = table.freeze({
        GameplayCreditRewardMultiplier = 1,
        HourlyMissionCreditRewardMultiplier = 1,
        DailyMissionCreditRewardMultiplier = 1,
        WeeklyMissionCreditRewardMultiplier = 1,
        MonthlyMissionCreditRewardMultiplier = 1
    })
};

local function collectKeys(p2: any, p3: table) -- Line: 26
    -- upvalues: collectKeys (copy)
    if typeof(p2) == "string" then
        table.insert(p3, p2);

        return;
    end;

    if typeof(p2) ~= "table" then
        return;
    end;

    for _, v in pairs(p2) do
        collectKeys(v, p3);
    end;
end;

function u1.GetSharedKeys() -- Line: 41
    -- upvalues: collectKeys (copy), u1 (copy)
    local v4 = {};
    collectKeys(u1.Shared, v4);

    return v4;
end;

return table.freeze(u1);