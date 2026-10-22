-- ReplicatedStorage.Shared.Utility.Table
-- Script path: ReplicatedStorage.Shared.Utility.Table
-- Decompile time: 5.66 ms

-- Decompiled with Potassium's decompiler.

local function DeepFreeze(p1) -- Line: 6
    -- upvalues: DeepFreeze (copy)
    local v2 = {};

    for i, v in p1 do
        local v3;

        if typeof(v) == "table" then
            v3 = DeepFreeze(v) or v;
        else
            v3 = v;
        end;

        v2[i] = v3;
    end;

    return table.freeze(v2);
end;

local function DeepCopy(p4) -- Line: 16
    -- upvalues: DeepCopy (copy)
    local v5 = {};

    for i, v in p4 do
        local v6;

        if typeof(v) == "table" then
            v6 = DeepCopy(v) or v;
        else
            v6 = v;
        end;

        v5[i] = v6;
    end;

    return v5;
end;

local function Delta(p7, p8) -- Line: 26
    -- upvalues: Delta (copy)
    if not (p7 and next(p7)) then
        return p8;
    end;

    local v9 = {};
    local v10 = false;

    for i, v in p8 do
        local v11 = p7[i];

        if v11 == nil then
            v9[i] = v;
            v10 = true;
        elseif type(v) == "table" then
            local v12, v13 = Delta(v11, v);

            if v13 then
                v9[i] = v12;
                v10 = true;
            end;
        elseif v11 ~= v then
            v9[i] = v;
            v10 = true;
        end;
    end;

    return v9, v10;
end;

local function ApplyDelta(p14, p15) -- Line: 140
    -- upvalues: ApplyDelta (copy)
    if not (p14 and next(p14)) then
        return p15;
    end;

    if not (p15 and next(p15)) then
        return p14;
    end;

    local table_clone_ret = table.clone(p14);

    for i, v in p15 do
        if type(v) == "table" then
            table_clone_ret[i] = ApplyDelta(table_clone_ret[i], v);
        else
            table_clone_ret[i] = v;
        end;
    end;

    return table_clone_ret;
end;

local function CopyInto(p16, p17) -- Line: 170
    -- upvalues: CopyInto (copy)
    for i, v in p17 do
        if typeof(v) == "table" then
            local v18 = p16[i];

            if typeof(v18) ~= "table" then
                v18 = {};
                p16[i] = v18;
            end;

            CopyInto(v18, v);
        else
            p16[i] = v;
        end;
    end;
end;

return table.freeze({
    Freeze = DeepFreeze,
    Copy = DeepCopy,
    Delta = Delta,

    DeltaWithoutBooleans = function(p19, p20, p21, p22) -- Line: 82, Name: DeltaWithoutBooleans
        -- upvalues: Delta (copy)
        if not (p19 and next(p19)) then
            return p20, true, true;
        end;

        local v23 = p21 or {};

        if p21 then
            table.clear(p21);
        end;

        local v24 = false;
        local v25 = false;

        for i, v in p20 do
            local v26 = p19[i];

            if type(v) == "boolean" then
                if v26 ~= v then
                    v25 = true;
                end;
            elseif v26 == nil then
                v23[i] = v;
                v24 = true;
            elseif type(v) == "table" then
                local v27, v28 = Delta(v26, v);

                if v28 then
                    v23[i] = v27;
                    v24 = true;
                end;
            elseif v26 ~= v then
                v24 = not (p22 and p22[i]) and true or v24;
                v23[i] = v;
            end;
        end;

        return v23, v24, v25;
    end,

    ApplyDelta = ApplyDelta,

    PackTables = function(p29, p30) -- Line: 192, Name: PackTablesInTable
        local table_clone_ret = table.clone(p29);

        if p30 then
            for i, v in p30 do
                table_clone_ret[i] = v;
            end;
        end;

        for i, v in table_clone_ret do
            if typeof(v) == "table" then
                table_clone_ret[i] = table.clone(v);
            end;
        end;

        return table_clone_ret;
    end,

    CopyInto = CopyInto
});