-- ReplicatedStorage.Database.Components.CharacterActions
-- Script path: ReplicatedStorage.Database.Components.CharacterActions
-- Decompile time: 0.35 ms

local u24 = table.freeze({
    "Shoot",
    "NoSuppressorShoot",
    "ShootRight",
    "ShootLeft",
    "SlamFire",
    "Reload",
    "Inspect",
    "Switch Fire Mode",
    "Add Suppressor",
    "Remove Suppressor",
    "RevolverChargeStart",
    "RevolverChargeCancel",
    "RevolverChargeRelease",
    "Use",
    "Cancel Plant",
    "StartThrow",
    "Throw",
    "CancelThrow",
    "Swing1",
    "Swing2",
    "Heavy Swing",
    "BackStab",
})
local u25 = {}
for i, v in ipairs(u24) do
    u25[v] = i
end
return table.freeze({
    Names = u24,
    ToId = function(a1) -- Line: 45 -- upvalues: u25 (val) -- types: a1: string?
        if typeof(a1) ~= "string" then
            return nil
        end
        return u25[a1]
    end,
    ToName = function(a1) -- Line: 53 -- upvalues: u24 (val) -- types: a1: number?
        if typeof(a1) ~= "number" then
            return nil
        end
        return u24[a1]
    end,
})