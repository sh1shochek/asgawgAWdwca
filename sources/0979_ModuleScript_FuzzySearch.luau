-- Decompiled with Potassium's decompiler.

return {
    MatchesQuery = function(p1: string, p2: string) -- Line: 5, Name: MatchesQuery
        if p2 == "" then
            return true;
        end;

        local v3 = p1:lower():gsub("[^%w]", "");
        local v4 = p2:lower():gsub("[^%w]", "");
        local v5 = 1;
        local v6 = 1;

        while v5 <= #v3 and v6 <= #v4 do
            if v3:sub(v5, v5) == v4:sub(v6, v6) then
                v6 = v6 + 1;
            end;

            v5 = v5 + 1;
        end;

        return #v4 < v6;
    end
};