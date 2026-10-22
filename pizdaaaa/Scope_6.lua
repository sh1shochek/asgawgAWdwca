-- ReplicatedStorage.Shared.WeaponConstructor.AltFunctions.Scope
-- Script path: ReplicatedStorage.Shared.WeaponConstructor.AltFunctions.Scope
-- Decompile time: 4.31 ms

-- Decompiled with Potassium's decompiler.

return {
    Clear = function(p1, p2) -- Line: 8, Name: Clear
        p1.PacketDirty = true;
        p1.SavedZoom = p2 and (p1.ZoomLevel > 0 and p1.ZoomLevel or (p1.SavedZoom or 0)) or 0;
        p1.ZoomLevel = 0;
        p1.Mode = 1;
        p1.SniperShotActive = false;
        p1.SniperUnscopeAt = 0;
        p1.AltFunctionRun:Fire(p1);
    end,

    Restore = function(p3) -- Line: 20, Name: Restore
        p3.PacketDirty = true;

        if p3.SavedZoom == 0 then
            return;
        end;

        p3.ZoomLevel = p3.SavedZoom;
        p3.SavedZoom = 0;
        p3.Mode = 2;
        p3.AltFunctionRun:Fire(p3);
    end,

    Run = function(p4) -- Line: 33, Name: Run
        p4.PacketDirty = true;

        if p4.SniperShotActive or p4.SavedZoom > 0 then
            return;
        end;

        local ZoomLevel = p4.ZoomLevel;
        local v5 = ZoomLevel >= 2 and 0 or ZoomLevel + 1;
        p4.ZoomLevel = v5;
        p4.AltFunctionRun:Fire(p4);
        p4.Mode = v5 == 0 and 1 or 2;
    end,

    Fired = function(p6, p7) -- Line: 49, Name: Fired
        p6.PacketDirty = true;

        if p7 and not p6.SniperShotActive then
            p6.SniperShotActive = true;
            p6.SniperUnscopeAt = p6.Timer + (p6:GetSetting("Game", "Gameplay", "Delay Sniper Rifle Un-Scope after Shot", false) and 0.1 or 0);
        end;

        if p6.SniperShotActive and (p6.ZoomLevel > 0 and p6.Timer >= p6.SniperUnscopeAt) then
            p6.SavedZoom = p6.ZoomLevel;
            p6.Mode = 1;
            p6.ZoomLevel = 0;
            p6.AltFunctionRun:Fire(p6);
        end;

        if not p7 and p6.SniperShotActive then
            p6.SniperShotActive = false;
            p6.SniperUnscopeAt = 0;

            if p6.SavedZoom > 0 then
                if p6:GetSetting("Game", "Gameplay", "Auto Re-Zoom Sniper Rifle after Shot", true) then
                    p6.ZoomLevel = p6.SavedZoom;
                    p6.Mode = 2;
                end;

                p6.SavedZoom = 0;
                p6.AltFunctionRun:Fire(p6);
            end;
        end;
    end
};