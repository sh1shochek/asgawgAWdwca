-- Decompiled with Potassium's decompiler.

return table.freeze({
    key = function(p1: table) -- Line: 8, Name: key
        if p1.UserId == 0 then
            return `bot:{p1.ActorId}`;
        end;

        return p1.UserId;
    end,

    keyLess = function(p2, p3) -- Line: 12, Name: keyLess
        if type(p2) == "number" then
            return type(p3) ~= "number" and true or p2 < p3;
        end;

        if type(p3) == "number" then
            return false;
        end;

        return p2 < p3;
    end,

    wireLess = function(p4: table, p5: table) -- Line: 19, Name: wireLess
        if p4.UserId == 0 and p5.UserId == 0 then
            return p4.ActorId < p5.ActorId;
        end;

        return p4.UserId < p5.UserId;
    end
});