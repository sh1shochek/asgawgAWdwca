-- ReplicatedStorage.Database.Components.CharacterActions
-- Script path: ReplicatedStorage.Database.Components.CharacterActions
-- Decompile time: 3.49 ms

-- Decompiled with Potassium's decompiler.

local table_freeze_ret = table.freeze({ "Shoot", "NoSuppressorShoot", "ShootRight", "ShootLeft", "SlamFire", "Reload", "Inspect", "Switch Fire Mode", "Add Suppressor", "Remove Suppressor", "RevolverChargeStart", "RevolverChargeCancel", "RevolverChargeRelease", "Use", "Cancel Plant", "StartThrow", "Throw", "CancelThrow", "Swing1", "Swing2", "Heavy Swing", "BackStab", "ReloadStart", "ReloadEnd" });
local u1 = {};

for i, v in ipairs(table_freeze_ret) do
    u1[v] = i;
end;

return table.freeze({
    Names = table_freeze_ret,

    ToId = function(p2: string?) -- Line: 49, Name: ToId
        -- upvalues: u1 (copy)
        if typeof(p2) == "string" then
            return u1[p2];
        end;

        return nil;
    end,

    ToName = function(p3: number?) -- Line: 57, Name: ToName
        -- upvalues: table_freeze_ret (copy)
        if typeof(p3) == "number" then
            return table_freeze_ret[p3];
        end;

        return nil;
    end
});