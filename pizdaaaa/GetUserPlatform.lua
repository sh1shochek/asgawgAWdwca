-- ReplicatedStorage.Shared.Utility.GetUserPlatform
-- Script path: ReplicatedStorage.Shared.Utility.GetUserPlatform
-- Decompile time: 4.69 ms

-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");

return function() -- Line: 10
    -- upvalues: UserInputService (copy)
    return (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse and (UserInputService.TouchEnabled and not UserInputService.MouseEnabled)) and "Mobile" or (UserInputService.PreferredInput == Enum.PreferredInput.Gamepad and "Console" or "PC");
end;