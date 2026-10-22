-- ReplicatedStorage.Shared.WeaponConstructor.AltFunctions.ScopeRifle
-- Script path: ReplicatedStorage.Shared.WeaponConstructor.AltFunctions.ScopeRifle
-- Decompile time: 4.89 ms

-- Decompiled with Potassium's decompiler.

return {
    Clear = function(p1: any, p2: boolean?) -- Line: 18, Name: Clear
        p1.PacketDirty = true;
        p1.SavedZoom = p2 and p1.Mode == 2 and 1 or 0;
        p1.Mode = 1;
    end,

    Restore = function(p3) -- Line: 25, Name: Restore
        p3.PacketDirty = true;

        if (p3.SavedZoom or 0) == 0 then
            return;
        end;

        p3.SavedZoom = 0;
        p3.Mode = 2;
        p3.AltFunctionRun:Fire(p3);
    end,

    Run = function(p4) -- Line: 38, Name: Run
        p4.PacketDirty = true;

        if p4.Mode == 1 then
            p4.Mode = 2;
        else
            p4.Mode = 1;
        end;

        p4.AltFunctionRun:Fire(p4);
    end
};