-- Decompiled with Potassium's decompiler.

return {
    parse = function(p1: string) -- Line: 11, Name: parse
        local string_split_ret = string.split(p1, ".");

        if p1 == "" or #string_split_ret ~= 3 then
            return nil;
        end;

        local success, result = pcall(function() -- Line: 18
            -- upvalues: string_split_ret (copy)
            if string_split_ret[2] == "KeyCode" then
                return Enum.KeyCode[string_split_ret[3]];
            end;

            if string_split_ret[2] == "UserInputType" then
                return Enum.UserInputType[string_split_ret[3]];
            end;

            if string_split_ret[2] == "CustomInputType" and (string_split_ret[3] == "ScrollWheelUp" or string_split_ret[3] == "ScrollWheelDown") then
                return string_split_ret[3];
            end;

            return nil;
        end);

        return success and result and result or nil;
    end
};