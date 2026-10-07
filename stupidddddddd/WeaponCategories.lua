-- ReplicatedStorage.Database.Custom.GameStats.WeaponCategories
-- Script path: ReplicatedStorage.Database.Custom.GameStats.WeaponCategories
-- Decompile time: 1.05 ms

local u167 = {}
local u168 = table.freeze({
    Rifle = "RIFLE",
    SMG = "SMG",
    Pistol = "PISTOL",
    Shotgun = "HEAVY",
    Sniper = "SNIPER",
    Melee = "MELEE",
    Special = "SPECIAL",
})
local v1 = table.freeze({
    Rifle = table.freeze({"AK-47", "M4A4", "M4A1-S", "AUG", "SG 553", "FAMAS", "Galil AR"}),
    SMG = table.freeze({"MP9", "MAC-10", "P90"}),
    Pistol = table.freeze({"Glock-18", "USP-S", "P250", "Five-SeveN", "Tec-9", "Dual Berettas", "Desert Eagle", "R8 Revolver"}),
    Shotgun = table.freeze({"Nova", "XM1014", "MAG-7", "Sawed-Off", "Negev"}),
    Sniper = table.freeze({"AWP", "SSG 08"}),
    Melee = table.freeze({
        "CT Knife",
        "T Knife",
        "Karambit",
        "M9 Bayonet",
        "Butterfly Knife",
        "Flip Knife",
        "Gut Knife",
        "Skeleton Knife",
        "Stiletto Knife",
        "LightSaber",
    }),
    Special = table.freeze({"HE Grenade", "Molotov", "Incendiary Grenade", "Zeus x27"}),
})
local u170 = {["Zeus x27"] = true}
local u171 = {}
local u172 = {}
for i, v in ipairs({"Rifle", "SMG", "Pistol", "Shotgun", "Sniper", "Melee", "Special"}) do
    for i2, i3 in ipairs(v1[v]) do
        u171[i3] = v
        table.insert(u172, i3)
    end
end
for i4, j in ipairs({"Melee", "Special"}) do
    for i5, k in ipairs(v1[j]) do
        u170[k] = true
    end
end
table.freeze(u171)
table.freeze(u172)
table.freeze(u170)

function u167.GetWeapons() -- Line: 118 -- upvalues: u172 (val)
    return u172
end

function u167.GetCategory(a1) -- Line: 125 -- upvalues: u171 (val) -- types: a1: string
    return u171[a1] or "Special"
end

function u167.GetLabel(a1) -- Line: 131 -- upvalues: u168 (val), u167 (val) -- types: a1: string
    return u168[u167.GetCategory(a1)] or "SPECIAL"
end

function u167.CountsTowardsAccuracy(a1) -- Line: 137 -- upvalues: u170 (val) -- types: a1: string?
    if a1 ~= nil and a1 ~= "" then
        return not u170[a1]
    end
    return false
end

return table.freeze(u167)