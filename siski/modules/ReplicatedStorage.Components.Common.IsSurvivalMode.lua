-- ReplicatedStorage.Components.Common.IsSurvivalMode
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

return function() -- Line: 4
    return workspace:GetAttribute("Gamemode") == "Zombie Survival";
end;