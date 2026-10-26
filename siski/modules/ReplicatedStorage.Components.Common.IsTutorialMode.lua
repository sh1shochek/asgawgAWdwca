-- ReplicatedStorage.Components.Common.IsTutorialMode
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

return function() -- Line: 3
    return workspace:GetAttribute("ServerGamemode") == "Tutorial" and true or workspace:GetAttribute("Gamemode") == "Tutorial";
end;