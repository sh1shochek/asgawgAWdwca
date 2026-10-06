-- Decompiled with Potassium's decompiler.

local u1 = {
    AttributeName = "CharacterGeneration",
    MaxValue = 65535
};

function u1.IsValid(p2) -- Line: 8
    -- upvalues: u1 (copy)
    local v3;

    if typeof(p2) == "number" and (p2 % 1 == 0 and p2 >= 1) then
        v3 = p2 <= u1.MaxValue;
    else
        v3 = false;
    end;

    return v3;
end;

function u1.Get(p4: userdata?) -- Line: 15
    -- upvalues: u1 (copy)
    if p4 == nil then
        return nil;
    end;

    local Attribute = p4:GetAttribute(u1.AttributeName);

    if u1.IsValid(Attribute) then
        return Attribute;
    end;

    return nil;
end;

function u1.Set(p5: userdata, p6: number) -- Line: 23
    -- upvalues: u1 (copy)
    local v7 = u1.IsValid(p6);
    assert(v7, "character generation must be a non-zero u16");
    p5:SetAttribute(u1.AttributeName, p6);
end;

function u1.Next(p8: number?) -- Line: 28
    -- upvalues: u1 (copy)
    return (not u1.IsValid(p8) or p8 == u1.MaxValue) and 1 or p8 + 1;
end;

function u1.Matches(p9: userdata?, p10: number) -- Line: 35
    -- upvalues: u1 (copy)
    return u1.Get(p9) == p10;
end;

return table.freeze(u1);