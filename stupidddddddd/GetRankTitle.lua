-- ReplicatedStorage.Components.Common.GetRankTitle
-- Script path: ReplicatedStorage.Components.Common.GetRankTitle
-- Decompile time: 0.40 ms

local u26 = table.freeze({
    table.freeze({maxLevel = 5, title = "Recruit"}),
    table.freeze({maxLevel = 10, title = "Private"}),
    table.freeze({maxLevel = 15, title = "Corporal"}),
    table.freeze({maxLevel = 20, title = "Sergeant"}),
    table.freeze({maxLevel = 25, title = "Master Sergeant"}),
    table.freeze({maxLevel = 30, title = "Lieutenant"}),
    table.freeze({maxLevel = 35, title = "Captain"}),
    (table.freeze({maxLevel = 40, title = "Global Elite"})),
})
return function(a1) -- Line: 25 -- upvalues: u26 (val) -- types: a1: number
    for i, v in ipairs(u26) do
        if a1 <= v.maxLevel then
            return v.title
        end
    end
    return "Global Elite"
end