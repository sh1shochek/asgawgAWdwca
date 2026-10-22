-- ReplicatedStorage.Shared.ValueCodec
-- Script path: ReplicatedStorage.Shared.ValueCodec
-- Decompile time: 14.84 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};

local function Trim(p2: string) -- Line: 28
    return p2:gsub("^%s*(.-)%s*$", "%1");
end;

local function SplitTopLevel(p3: string) -- Line: 33
    local v4 = 0;
    local v5 = 1;
    local v6 = {};

    for i = 1, #p3 do
        local v7 = p3:sub(i, i);
        local v8;

        if v7 == "(" or (v7 == "[" or v7 == "{") then
            v4 = v4 + 1;
            v8 = i;
        elseif v7 == ")" or (v7 == "]" or v7 == "}") then
            v4 = v4 - 1;
            v8 = i;
        elseif v7 == "," and v4 == 0 then
            local v9 = p3:sub(v5, i - 1):gsub("^%s*(.-)%s*$", "%1");
            table.insert(v6, v9);
            v5 = i + 1;
            v8 = i;
        else
            v8 = i;
        end;
    end;

    local v10 = p3:sub(v5):gsub("^%s*(.-)%s*$", "%1");
    table.insert(v6, v10);

    return v6;
end;

local function ParseVector(p11: string) -- Line: 56
    -- upvalues: SplitTopLevel (copy)
    local v12 = SplitTopLevel(p11);

    if #v12 ~= 3 then
        return nil;
    end;

    local v13 = tonumber(v12[1]);
    local v14 = tonumber(v12[2]);
    local v15 = tonumber(v12[3]);

    if v13 and (v14 and v15) then
        return vector.create(v13, v14, v15);
    end;

    return nil;
end;

function u1.Decode(p16: string) -- Line: 74
    -- upvalues: SplitTopLevel (copy), u1 (copy)
    local v17 = (p16 or ""):gsub("^%s*(.-)%s*$", "%1");

    if v17 == "" then
        return nil;
    end;

    local v18 = tonumber(v17);

    if v18 ~= nil then
        return v18;
    end;

    local v19 = v17:lower();

    if v19 == "true" then
        return true;
    end;

    if v19 == "false" then
        return false;
    end;

    if v17:sub(1, 1) == "(" and v17:sub(-1) == ")" then
        local v20 = SplitTopLevel((v17:sub(2, -2)));
        local v21;

        if #v20 == 3 then
            local v22 = tonumber(v20[1]);
            local v23 = tonumber(v20[2]);
            local v24 = tonumber(v20[3]);

            if v22 and (v23 and v24) then
                v21 = vector.create(v22, v23, v24);
            else
                v21 = nil;
            end;
        else
            v21 = nil;
        end;

        if v21 then
            return v21;
        end;
    end;

    if v17:sub(1, 1) == "[" and v17:sub(-1) == "]" then
        local v25 = v17:sub(2, -2):gsub("^%s*(.-)%s*$", "%1");
        local v26 = {};

        if v25 ~= "" then
            for _, v in SplitTopLevel(v25) do
                table.insert(v26, u1.Decode(v));
            end;
        end;

        return v26;
    end;

    local v27;

    if v17:sub(1, 1) == "{" and v17:sub(-1) == "}" then
        v27 = v17:sub(2, -2):gsub("^%s*(.-)%s*$", "%1");
    else
        v27 = v17;
    end;

    if v27:find("=") then
        local v28 = {};

        for _, v in SplitTopLevel(v27) do
            local v29, v30 = v:match("^(.-)=(.*)$");

            if v29 then
                local v31 = v29:gsub("^%s*(.-)%s*$", "%1");
                v28[tonumber(v31) or v31] = u1.Decode((v30:gsub("^%s*(.-)%s*$", "%1")));
            end;
        end;

        return v28;
    end;

    local v32 = SplitTopLevel(v17);
    local v33;

    if #v32 == 3 then
        local v34 = tonumber(v32[1]);
        local v35 = tonumber(v32[2]);
        local v36 = tonumber(v32[3]);

        if v34 and (v35 and v36) then
            v33 = vector.create(v34, v35, v36);
        else
            v33 = nil;
        end;
    else
        v33 = nil;
    end;

    return v33 or v17;
end;

function u1.Encode(p37) -- Line: 145
    -- upvalues: u1 (copy)
    local v38 = typeof(p37);

    if v38 == "number" then
        return tostring(p37);
    end;

    if v38 == "boolean" then
        return p37 and "true" or "false";
    end;

    if v38 == "vector" or v38 == "Vector3" then
        return ("%s,%s,%s"):format(tostring(p37.X), tostring(p37.Y), (tostring(p37.Z)));
    end;

    if v38 == "string" then
        return p37;
    end;

    if v38 ~= "table" then
        return tostring(p37);
    end;

    local v39 = #p37;
    local v40 = v39 > 0;

    if v40 then
        for i in pairs(p37) do
            if typeof(i) ~= "number" or (i < 1 or (v39 < i or i % 1 ~= 0)) then
                v40 = false;
                break;
            end;
        end;
    end;

    local v41 = {};

    if v40 then
        for i = 1, v39 do
            local v42 = u1.Encode(p37[i]);

            if typeof(p37[i]) == "vector" or typeof(p37[i]) == "Vector3" then
                v42 = "(" .. v42 .. ")";
            end;

            table.insert(v41, v42);
            local _ = i;
        end;

        return "[" .. table.concat(v41, ",") .. "]";
    end;

    for i, v in pairs(p37) do
        local v43 = tostring(i);
        table.insert(v41, ("%s=%s"):format(v43, u1.Encode(v)));
    end;

    return "{" .. table.concat(v41, ",") .. "}";
end;

return u1;