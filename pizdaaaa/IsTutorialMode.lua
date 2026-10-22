-- ReplicatedStorage.Components.Common.IsTutorialMode
-- Script path: ReplicatedStorage.Components.Common.IsTutorialMode
-- Decompile time: 3.52 ms

-- Decompiled with Potassium's decompiler.

return function() -- Line: 3
    return workspace:GetAttribute("ServerGamemode") == "Tutorial" and true or workspace:GetAttribute("Gamemode") == "Tutorial";
end;