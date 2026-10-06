-- Decompiled with Potassium's decompiler.

local u1 = {
    Attribute = "MovementHullPoints",
    MinPoints = 4,
    MaxPoints = 256
};
local u2 = {};

local function isFinite(p3: number?) -- Line: 13
    local v4;

    if p3 == nil or (p3 ~= p3 or p3 <= (-1 / 0)) then
        v4 = false;
    else
        v4 = p3 < (1 / 0);
    end;

    return v4;
end;

function u1.Decode(p5) -- Line: 17
    -- upvalues: u2 (copy), u1 (copy)
    if typeof(p5) ~= "string" then
        return nil, "hull points must be a string";
    end;

    local v6 = u2[p5];

    if v6 ~= nil then
        return v6, nil;
    end;

    local v7 = {};

    for _, v in string.split(p5, ";") do
        local string_split_ret = string.split(v, ",");
        local v8 = tonumber(string_split_ret[1]);
        local v9 = tonumber(string_split_ret[2]);
        local v10 = tonumber(string_split_ret[3]);

        if #string_split_ret ~= 3 then
            return nil, "hull points must be finite x,y,z triples";
        end;

        local v11;

        if v8 == nil or (v8 ~= v8 or v8 <= (-1 / 0)) then
            v11 = false;
        else
            v11 = v8 < (1 / 0);
        end;

        if not v11 then
            return nil, "hull points must be finite x,y,z triples";
        end;

        local v12;

        if v9 == nil or (v9 ~= v9 or v9 <= (-1 / 0)) then
            v12 = false;
        else
            v12 = v9 < (1 / 0);
        end;

        if not v12 then
            return nil, "hull points must be finite x,y,z triples";
        end;

        local v13;

        if v10 == nil or (v10 ~= v10 or v10 <= (-1 / 0)) then
            v13 = false;
        else
            v13 = v10 < (1 / 0);
        end;

        if not v13 then
            return nil, "hull points must be finite x,y,z triples";
        end;

        v7[#v7 + 1] = Vector3.new(v8, v9, v10);
    end;

    if #v7 < u1.MinPoints or #v7 > u1.MaxPoints then
        return nil, string.format("hull points need %d-%d points", u1.MinPoints, u1.MaxPoints);
    end;

    table.freeze(v7);
    u2[p5] = v7;

    return v7, nil;
end;

function u1.Read(p14: userdata) -- Line: 43
    -- upvalues: u1 (copy)
    local Attribute = p14:GetAttribute(u1.Attribute);

    if Attribute == nil then
        return nil;
    end;

    return u1.Decode(Attribute);
end;

return table.freeze(u1);