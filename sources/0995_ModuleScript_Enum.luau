-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {};
v1.enums = u2;

function v1.createEnum(p3, u4) -- Line: 20
    -- upvalues: u2 (copy)
    local v5 = typeof(p3) == "string";
    assert(v5, "bad argument #1 - enums must be created using a string name!");
    local v6 = typeof(u4) == "table";
    assert(v6, "bad argument #2 - enums must be created using a table!");
    assert(not u2[p3], ("enum \'%s\' already exists!"):format(p3));
    local u7 = {};
    local u8 = {};
    local u9 = {};
    local u19 = {
        getName = function(p10) -- Line: 30, Name: getName
            -- upvalues: u8 (copy), u9 (copy), u4 (copy)
            local v11 = tostring(p10);
            local v12 = u8[v11] or u9[v11];

            if v12 then
                return u4[v12][1];
            end;
        end,

        getValue = function(p13) -- Line: 40, Name: getValue
            -- upvalues: u7 (copy), u9 (copy), u4 (copy)
            local v14 = tostring(p13);
            local v15 = u7[v14] or u9[v14];

            if v15 then
                return u4[v15][2];
            end;
        end,

        getProperty = function(p16) -- Line: 50, Name: getProperty
            -- upvalues: u7 (copy), u8 (copy), u4 (copy)
            local v17 = tostring(p16);
            local v18 = u7[v17] or u8[v17];

            if v18 then
                return u4[v18][3];
            end;
        end
    };
    local v20 = {};

    for i, v in pairs(u4) do
        local v21 = typeof(v) == "table";
        assert(v21, ("bad argument #2.%s - details must only be comprised of tables!"):format(i));
        local v22 = v[1];
        local v23 = typeof(v22) == "string";
        assert(v23, ("bad argument #2.%s.1 - detail name must be a string!"):format(i));
        local v24 = typeof(not u7[v22]);
        assert(v24, ("bad argument #2.%s.1 - the detail name \'%s\' already exists!"):format(i, v22));
        local v25 = typeof(not u19[v22]);
        assert(v25, ("bad argument #2.%s.1 - that name is reserved."):format(i, v22));
        u7[tostring(v22)] = i;
        local v26 = v[2];
        local v27 = tostring(v26);
        local v28 = typeof(not u8[v27]);
        assert(v28, ("bad argument #2.%s.2 - the detail value \'%s\' already exists!"):format(i, v27));
        u8[v27] = i;
        local v29 = v[3];

        if v29 then
            local v30 = typeof(not u9[v29]);
            local v31 = tostring(v29);
            assert(v30, ("bad argument #2.%s.3 - the detail property \'%s\' already exists!"):format(i, v31));
            u9[tostring(v29)] = i;
        end;

        v20[v22] = v26;
        setmetatable(v20, {
            __index = function(p32, p33) -- Line: 80, Name: __index
                -- upvalues: u19 (copy)
                return u19[p33];
            end
        });
    end;

    u2[p3] = v20;

    return v20;
end;

function v1.getEnums() -- Line: 90
    -- upvalues: u2 (copy)
    return u2;
end;

local createEnum = v1.createEnum;

for _, child in pairs(script:GetChildren()) do
    if child:IsA("ModuleScript") then
        local v34 = require(child);
        createEnum(child.Name, v34);
    end;
end;

return v1;