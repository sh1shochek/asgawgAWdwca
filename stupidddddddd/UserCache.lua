-- ReplicatedStorage.Database.Custom.UserCache
-- Script path: ReplicatedStorage.Database.Custom.UserCache
-- Decompile time: 0.68 ms

local UserService = game:GetService("UserService")
local u7 = utf8.char(57344)
local u8 = {}
return {
    Fetch = function(a1) -- Line: 16 -- upvalues: u8 (val), UserService (val), u7 (val) -- types: a1: number
        local v1 = u8[a1]
        if v1 then
            return v1
        end
        local v2 = {a1}
        local success, result = pcall(UserService.GetUserInfosByUserIdsAsync, UserService, v2)
        local v3 = if not success then nil else if typeof(result) ~= "table" then nil else result[1]
        if v3 then
            v2 = v3.HasVerifiedBadge == true
            local v4 = {Username = v3.Username}
            local DisplayName_2 = if not v2 then v3.DisplayName else ("%* %*"):format(v3.DisplayName, u7)
            v4.DisplayName = DisplayName_2
            v4.HasVerifiedBadge = v2
            v1 = v4
        else
            v1 = {Username = "Unknown User", DisplayName = "Unknown User", HasVerifiedBadge = false}
        end
        u8[a1] = v1
        return v1
    end,
}