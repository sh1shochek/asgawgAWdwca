-- ReplicatedStorage.Shared.WeaponConstructor.AltFunctions.Burst
-- Script path: ReplicatedStorage.Shared.WeaponConstructor.AltFunctions.Burst
-- Decompile time: 6.99 ms

-- Decompiled with Potassium's decompiler.

return {
    Run = function(p1) -- Line: 8, Name: Run
        p1.PacketDirty = true;

        if p1.Mode == 1 then
            p1.Mode = 2;
        else
            p1.Mode = 1;
        end;

        p1.BurstFireRemaining = 0;
        p1.AltFunctionRun:Fire();
    end
};