-- Decompiled with Potassium's decompiler.

return function(u1: string) -- Line: 2, Name: Symbol
    local v2 = newproxy(true);

    getmetatable(v2).__tostring = function() -- Line: 5, Name: __tostring
        -- upvalues: u1 (copy)
        return u1;
    end;

    return v2;
end;