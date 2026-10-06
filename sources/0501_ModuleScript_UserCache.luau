-- Decompiled with Potassium's decompiler.

local UserService = game:GetService("UserService");
local utf8_char_ret = utf8.char(57344);
local u1 = {};

return {
    Fetch = function(p2: number) -- Line: 16, Name: Fetch
        -- upvalues: u1 (copy), UserService (copy), utf8_char_ret (copy)
        local v3 = u1[p2];

        if v3 then
            return v3;
        end;

        local success, result = pcall(UserService.GetUserInfosByUserIdsAsync, UserService, { p2 });
        local v4;

        if success and typeof(result) == "table" then
            v4 = result[1];
        else
            v4 = nil;
        end;

        local v5;

        if v4 then
            local v6 = v4.HasVerifiedBadge == true;
            v5 = {
                Username = v4.Username
            };
            local v7;

            if v6 then
                v7 = `{v4.DisplayName} {utf8_char_ret}`;
            else
                v7 = v4.DisplayName;
            end;

            v5.DisplayName = v7;
            v5.HasVerifiedBadge = v6;
        else
            v5 = {
                Username = "Unknown User",
                DisplayName = "Unknown User",
                HasVerifiedBadge = false
            };
        end;

        u1[p2] = v5;

        return v5;
    end
};