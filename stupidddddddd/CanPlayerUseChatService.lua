-- ReplicatedStorage.Database.Components.Common.Roblox.CanPlayerUseChatService
-- Script path: ReplicatedStorage.Database.Components.Common.Roblox.CanPlayerUseChatService
-- Decompile time: 0.26 ms

local TextChatService = game:GetService("TextChatService")
return function(a1) -- Line: 9 -- upvalues: TextChatService (val) -- types: a1: userdata
    local success, result = pcall(function() -- Line: 10 -- upvalues: TextChatService (upval), a1 (val)
        return TextChatService:CanUserChatAsync(a1.UserId)
    end)
    if success then
        return result
    end
    warn("[CanUserUseChat] Failed to check if user can use chat", result)
    return false
end