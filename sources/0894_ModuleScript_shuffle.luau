-- Decompiled with Potassium's decompiler.

local copy = require(script.Parent.copy);

return function(p1: table) -- Line: 19, Name: shuffle
    -- upvalues: copy (copy)
    local Random_new_ret = Random.new(os.time() * #p1);
    local v2 = copy(p1);

    for i = #v2, 1, -1 do
        local v3 = Random_new_ret:NextInteger(1, i);
        local v4 = v2[i];
        v2[i] = v2[v3];
        v2[v3] = v4;
        local _ = i;
    end;

    return v2;
end;