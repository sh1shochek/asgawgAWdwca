-- IsSurvivalMode (ModuleScript)
-- full path: ReplicatedStorage.Components.Common.IsSurvivalMode

-- Decompiled with Potassium's decompiler.

return function() -- Line: 4
    return workspace:GetAttribute("Gamemode") == "Zombie Survival";
end;