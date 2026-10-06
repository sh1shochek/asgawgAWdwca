-- Decompiled with Potassium's decompiler.

return table.freeze({
    ToBase64 = function(p1) -- Line: 2, Name: ToBase64
        return (p1:gsub(".", function(p2) -- Line: 4
            local v3 = p2:byte();
            local v4 = "";

            for i = 8, 1, -1 do
                v4 = v4 .. (v3 % 2 ^ i - v3 % 2 ^ (i - 1) > 0 and "1" or "0");
                local _ = i;
            end;

            return v4;
        end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(p5) -- Line: 8
            if #p5 < 6 then
                return "";
            end;

            local v6 = 0;

            for i = 1, 6 do
                v6 = v6 + (p5:sub(i, i) == "1" and (2 ^ (6 - i) or 0) or 0);
                local _ = i;
            end;

            return ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v6 + 1, v6 + 1);
        end) .. ({ "", "==", "=" })[#p1 % 3 + 1];
    end,

    ToString = function(p7) -- Line: 15, Name: ToString
        return string.gsub(p7, "[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]", ""):gsub(".", function(p8) -- Line: 18
            if p8 == "=" then
                return "";
            end;

            local v9 = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):find(p8) - 1;
            local v10 = "";

            for i = 6, 1, -1 do
                v10 = v10 .. (v9 % 2 ^ i - v9 % 2 ^ (i - 1) > 0 and "1" or "0");
                local _ = i;
            end;

            return v10;
        end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(p11) -- Line: 23
            if #p11 ~= 8 then
                return "";
            end;

            local v12 = 0;

            for i = 1, 8 do
                v12 = v12 + (p11:sub(i, i) == "1" and (2 ^ (8 - i) or 0) or 0);
                local _ = i;
            end;

            return string.char(v12);
        end);
    end
});