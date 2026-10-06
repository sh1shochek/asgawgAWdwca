-- Decompiled with Potassium's decompiler.

return table.freeze({
    sample = function(p1: boolean, p2: boolean, p3: boolean) -- Line: 7, Name: sample
        if p1 then
            return true, false, false;
        end;

        if p3 then
            return false, p2, false;
        end;

        if p2 then
            return true, false, true;
        end;

        return false, false, false;
    end
});