-- Decompiled with Potassium's decompiler.

local TextChatService = game:GetService("TextChatService");

return function(u1: userdata) -- Line: 9
    -- upvalues: TextChatService (copy)
    local success, result = pcall(function() -- Line: 10
        -- upvalues: TextChatService (ref), u1 (copy)
        return TextChatService:CanUserChatAsync(u1.UserId);
    end);

    if success then
        return result;
    end;

    warn("[CanUserUseChat] Failed to check if user can use chat", result);

    return false;
end;