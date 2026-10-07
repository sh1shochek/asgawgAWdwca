-- ReplicatedStorage.Database.Custom.ConfigKeys
-- Script path: ReplicatedStorage.Database.Custom.ConfigKeys
-- Decompile time: 0.46 ms

local collectKeys
local u0 = {}
u0.Shared = table.freeze({
    MissionCreditRewardMultipliers = table.freeze({
        hourly = "HourlyMissionCreditRewardMultiplier",
        daily = "DailyMissionCreditRewardMultiplier",
        weekly = "WeeklyMissionCreditRewardMultiplier",
        monthly = "MonthlyMissionCreditRewardMultiplier",
    }),
})
u0.ServerOnly = table.freeze({GameplayCreditRewardMultiplier = "GameplayCreditRewardMultiplier"})
u0.Defaults = table.freeze({
    GameplayCreditRewardMultiplier = 1,
    HourlyMissionCreditRewardMultiplier = 1,
    DailyMissionCreditRewardMultiplier = 1,
    WeeklyMissionCreditRewardMultiplier = 1,
    MonthlyMissionCreditRewardMultiplier = 1,
})

function collectKeys(a1, a2) -- Line: 26 -- upvalues: collectKeys (val) -- types: a2: table
    if typeof(a1) == "string" then
        table.insert(a2, a1)
        return
    end
    if typeof(a1) ~= "table" then
        return
    end
    for k, v in pairs(a1) do
        collectKeys(v, a2)
    end
end

function u0.GetSharedKeys() -- Line: 41 -- upvalues: collectKeys (val), u0 (val)
    local v1 = {}
    collectKeys(u0.Shared, v1)
    return v1
end

return table.freeze(u0)