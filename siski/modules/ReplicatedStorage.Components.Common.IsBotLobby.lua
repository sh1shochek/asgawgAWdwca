-- ReplicatedStorage.Components.Common.IsBotLobby
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

return function() -- Line: 4
    return workspace:GetAttribute("BotLobby") == true;
end;