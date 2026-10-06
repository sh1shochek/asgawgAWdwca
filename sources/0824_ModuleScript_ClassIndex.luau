-- Decompiled with Potassium's decompiler.

local u1 = require(script["generated-api-dump"]);
local u2 = require(script["spritesheet-data"]);
local v3 = {
    Public = {},
    Private = {}
};
v3.Private.SpritesheetClassMap = {};

function v3.Public.FetchApiDump() -- Line: 33
    -- upvalues: u1 (copy)
    return u1;
end;

function v3.Public.FetchAllClasses() -- Line: 53
    -- upvalues: u1 (copy)
    local v4 = {};

    for i in u1.Classes do
        table.insert(v4, i);
    end;

    return v4;
end;

function v3.Public.IsClassRegistered(p5: string) -- Line: 83
    -- upvalues: u1 (copy)
    return u1.Classes[p5] and true or false;
end;

function v3.Public.FetchClassMembers(p6: string, p7: string?, p8: boolean?) -- Line: 127
    -- upvalues: u1 (copy)
    local v9 = p7 or "None";
    local v10 = {};

    for i, v in u1.Classes[p6].Members do
        if not v.Tags.NotScriptable or p8 then
            if type(v.Security) == "string" then
                if v.Security == v9 then
                    table.insert(v10, i);
                end;
            elseif v.Security.Read == v9 then
                table.insert(v10, i);
            end;
        end;
    end;

    return v10;
end;

function v3.Public.FetchClassIcon(p11: string) -- Line: 185
    -- upvalues: u2 (copy)
    local v12 = u2.Content[p11] or u2.Content.File;

    return {
        Image = "http://www.roblox.com/asset/?id=16231724441",
        ImageRectOffset = Vector2.new(v12.x, v12.y),
        ImageRectSize = Vector2.new(v12.w, v12.h)
    };
end;

function v3.Public.FetchClassMemberType(p13: string, p14: string) -- Line: 224
    -- upvalues: u1 (copy)
    return u1.Classes[p13].Members[p14].MemberType;
end;

function v3.Public.FetchClassMemberTags(p15: string, p16: string) -- Line: 250
    -- upvalues: u1 (copy)
    local v17 = {};

    for i, v in u1.Classes[p15].Members[p16].Tags do
        v17[i] = v;
    end;

    return v17;
end;

function v3.Public.FetchClassMemberSecurity(p18: string, p19: string) -- Line: 283
    -- upvalues: u1 (copy)
    local v20 = u1.Classes[p18].Members[p19];
    local v21 = {};

    if type(v20.Security) == "table" then
        for i, v in v20.Security do
            v21[i] = v;
        end;

        return v21;
    end;

    v21.Read = v20.Security;
    v21.Write = v20.Security;

    return v21;
end;

function v3.Public.FetchClassMemberThreadSafety(p22: string, p23: string) -- Line: 327
    -- upvalues: u1 (copy)
    return u1.Classes[p22].Members[p23].ThreadSafety;
end;

function v3.Public.FetchClassSuperclass(p24: string) -- Line: 350
    -- upvalues: u1 (copy)
    return u1.Classes[p24].Superclass;
end;

function v3.Public.FetchClassSuperclasses(p25: string) -- Line: 373
    -- upvalues: u1 (copy)
    local v26 = u1.Classes[p25];
    local v27 = {};

    while v26 do
        table.insert(v27, v26.Superclass);
        v26 = u1.Classes[v26.Superclass];
    end;

    return v27;
end;

return v3.Public;