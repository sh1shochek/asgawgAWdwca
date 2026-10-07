-- ReplicatedStorage.Shared.Base64
-- Script path: ReplicatedStorage.Shared.Base64
-- Decompile time: 1.44 ms

return table.freeze({
    ToBase64 = function(a1) -- Line: 2
        local v1 = {"", "==", "="}
        return (((a1:gsub(".", function(a1) -- Line: 4
            local v1 = ""
            local v2 = a1:byte()
            for i = 8, 1, -1 do
                v1 = v1 .. (if not (0 < v2 % 2 ^ i - v2 % 2 ^ (i - 1)) then "0" else "1")
            end
            return v1
        end)) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(a1) -- Line: 8
            if #a1 < 6 then
                return ""
            end
            local v1 = 0
            for i = 1, 6 do
                v1 = v1 + (not (a1:sub(i, i) ~= "1") and 2 ^ (6 - i) or 0)
            end
            return ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v1 + 1, v1 + 1)
        end)) .. v1[#a1 % 3 + 1]
    end,
    ToString = function(a1) -- Line: 15
        return ((string.gsub(a1, "[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]", ""):gsub(".", function(a1) -- Line: 18
            if a1 == "=" then
                return ""
            end
            local v1 = ""
            local v2 = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):find(a1) - 1
            for i = 6, 1, -1 do
                v1 = v1 .. (if not (0 < v2 % 2 ^ i - v2 % 2 ^ (i - 1)) then "0" else "1")
            end
            return v1
        end)):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(a1) -- Line: 23
            if #a1 ~= 8 then
                return ""
            end
            local v1 = 0
            for i = 1, 8 do
                v1 = v1 + (not (a1:sub(i, i) ~= "1") and 2 ^ (8 - i) or 0)
            end
            return (string.char(v1))
        end))
    end,
})