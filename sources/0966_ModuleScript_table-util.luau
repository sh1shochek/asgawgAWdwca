-- Decompiled with Potassium's decompiler.

local v1 = {};
local HttpService = game:GetService("HttpService");
local Random_new_ret = Random.new();

local function Sync(p2, p3) -- Line: 84
    -- upvalues: Sync (copy)
    local v4 = type(p2) == "table";
    assert(v4, "First argument must be a table");
    local v5 = type(p3) == "table";
    assert(v5, "Second argument must be a table");
    local table_clone_ret = table.clone(p2);

    for i, v in pairs(table_clone_ret) do
        local v6 = p3[i];

        if v6 == nil then
            table_clone_ret[i] = nil;
        elseif type(v) == type(v6) then
            if type(v) == "table" then
                table_clone_ret[i] = Sync(v, v6);
            end;
        elseif type(v6) == "table" then
            local function DeepCopy(p7: table) -- Line: 44
                -- upvalues: DeepCopy (copy)
                local table_clone_ret2 = table.clone(p7);

                for i2, v2 in table_clone_ret2 do
                    if type(v2) == "table" then
                        table_clone_ret2[i2] = DeepCopy(v2);
                    end;
                end;

                return table_clone_ret2;
            end;

            table_clone_ret[i] = DeepCopy(v6);
        else
            table_clone_ret[i] = v6;
        end;
    end;

    for i, v in pairs(p3) do
        if table_clone_ret[i] == nil then
            if type(v) == "table" then
                local function u9(p8: table) -- Line: 44
                    -- upvalues: u9 (copy)
                    local table_clone_ret2 = table.clone(p8);

                    for i2, v2 in table_clone_ret2 do
                        if type(v2) == "table" then
                            table_clone_ret2[i2] = u9(v2);
                        end;
                    end;

                    return table_clone_ret2;
                end;

                table_clone_ret[i] = u9(v);
            else
                table_clone_ret[i] = v;
            end;
        end;
    end;

    return table_clone_ret;
end;

local function Reconcile(p10, p11) -- Line: 156
    -- upvalues: Reconcile (copy)
    local v12 = type(p10) == "table";
    assert(v12, "First argument must be a table");
    local v13 = type(p11) == "table";
    assert(v13, "Second argument must be a table");
    local table_clone_ret = table.clone(p10);

    for i, v in p11 do
        local v14 = p10[i];

        if v14 == nil then
            if type(v) == "table" then
                local function u16(p15: table) -- Line: 44
                    -- upvalues: u16 (copy)
                    local table_clone_ret2 = table.clone(p15);

                    for i2, v2 in table_clone_ret2 do
                        if type(v2) == "table" then
                            table_clone_ret2[i2] = u16(v2);
                        end;
                    end;

                    return table_clone_ret2;
                end;

                table_clone_ret[i] = u16(v);
            else
                table_clone_ret[i] = v;
            end;
        elseif type(v14) == "table" then
            if type(v) == "table" then
                table_clone_ret[i] = Reconcile(v14, v);
            else
                local function u18(p17: table) -- Line: 44
                    -- upvalues: u18 (copy)
                    local table_clone_ret2 = table.clone(p17);

                    for i2, v2 in table_clone_ret2 do
                        if type(v2) == "table" then
                            table_clone_ret2[i2] = u18(v2);
                        end;
                    end;

                    return table_clone_ret2;
                end;

                table_clone_ret[i] = u18(v14);
            end;
        end;
    end;

    return table_clone_ret;
end;

local function Map(p19: table, p20: function) -- Line: 262
    local v21 = type(p19) == "table";
    assert(v21, "First argument must be a table");
    local v22 = type(p20) == "function";
    assert(v22, "Second argument must be a function");
    local table_create_ret = table.create(#p19);

    for i, v in p19 do
        table_create_ret[i] = p20(v, i, p19);
    end;

    return table_create_ret;
end;

function v1.Copy(p23: any, p24: boolean?) -- Line: 40
    if not p24 then
        return table.clone(p23);
    end;

    local function u26(p25: table) -- Line: 44
        -- upvalues: u26 (copy)
        local table_clone_ret = table.clone(p25);

        for i, v in table_clone_ret do
            if type(v) == "table" then
                table_clone_ret[i] = u26(v);
            end;
        end;

        return table_clone_ret;
    end;

    return u26(p23);
end;

v1.Sync = Sync;
v1.Reconcile = Reconcile;

function v1.SwapRemove(p27: table, p28: number) -- Line: 209
    local v29 = #p27;
    p27[p28] = p27[v29];
    p27[v29] = nil;
end;

function v1.SwapRemoveFirstValue(p30: table, p31: any) -- Line: 234
    local table_find_ret = table.find(p30, p31);

    if table_find_ret then
        local v32 = #p30;
        p30[table_find_ret] = p30[v32];
        p30[v32] = nil;
    end;

    return table_find_ret;
end;

v1.Map = Map;

function v1.Filter(p33: table, p34: function) -- Line: 292
    local v35 = type(p33) == "table";
    assert(v35, "First argument must be a table");
    local v36 = type(p34) == "function";
    assert(v36, "Second argument must be a function");
    local table_create_ret = table.create(#p33);

    if #p33 <= 0 then
        for i, v in p33 do
            if p34(v, i, p33) then
                table_create_ret[i] = v;
            end;
        end;

        return table_create_ret;
    end;

    local v37 = 0;

    for i, v in p33 do
        if p34(v, i, p33) then
            v37 = v37 + 1;
            table_create_ret[v37] = v;
        end;
    end;

    return table_create_ret;
end;

function v1.Reduce(p38: table, p39: function, p40: any) -- Line: 335
    local v41 = type(p38) == "table";
    assert(v41, "First argument must be a table");
    local v42 = type(p39) == "function";
    assert(v42, "Second argument must be a function");

    if #p38 > 0 then
        local v43;

        if p40 == nil then
            p40 = p38[1];
            v43 = 2;
        else
            v43 = 1;
        end;

        for i = v43, #p38 do
            p40 = p39(p40, p38[i], i, p38);
            local _ = i;
        end;

        return p40;
    end;

    local v44;

    if p40 == nil then
        v44 = next(p38);
        p40 = v44;
    else
        v44 = nil;
    end;

    for i, v in next, p38, v44 do
        p40 = p39(p40, v, i, p38);
    end;

    return p40;
end;

function v1.Assign(p45: table, ...) -- Line: 378
    local table_clone_ret = table.clone(p45);

    for _, v in { ... } do
        for i, v2 in v do
            table_clone_ret[i] = v2;
        end;
    end;

    return table_clone_ret;
end;

function v1.Extend(p46: table, p47: table) -- Line: 407
    local table_clone_ret = table.clone(p46);

    for _, v in p47 do
        table.insert(table_clone_ret, v);
    end;

    return table_clone_ret;
end;

function v1.Reverse(p48: table) -- Line: 432
    local v49 = #p48;
    local table_create_ret = table.create(v49);

    for i = 1, v49 do
        table_create_ret[i] = p48[v49 - i + 1];
        local _ = i;
    end;

    return table_create_ret;
end;

function v1.Shuffle(p50: table, p51: userdata?) -- Line: 459
    -- upvalues: Random_new_ret (copy)
    local v52 = type(p50) == "table";
    assert(v52, "First argument must be a table");
    local table_clone_ret = table.clone(p50);

    if typeof(p51) ~= "Random" then
        p51 = Random_new_ret;
    end;

    for i = #p50, 2, -1 do
        local v53 = p51:NextInteger(1, i);
        local v54 = table_clone_ret[i];
        table_clone_ret[i] = table_clone_ret[v53];
        table_clone_ret[v53] = v54;
        local _ = i;
    end;

    return table_clone_ret;
end;

function v1.Sample(p55: table, p56: number, p57: userdata?) -- Line: 489
    -- upvalues: Random_new_ret (copy)
    local v58 = type(p55) == "table";
    assert(v58, "First argument must be a table");
    local v59 = type(p56) == "number";
    assert(v59, "Second argument must be a number");
    local v60 = #p55;

    if v60 == 0 then
        return {};
    end;

    local table_clone_ret = table.clone(p55);
    local table_create_ret = table.create(p56);

    if typeof(p57) ~= "Random" then
        p57 = Random_new_ret;
    end;

    local math_clamp_ret = math.clamp(p56, 1, v60);

    for i = 1, math_clamp_ret do
        local v61 = p57:NextInteger(i, v60);
        local v62 = table_clone_ret[i];
        table_clone_ret[i] = table_clone_ret[v61];
        table_clone_ret[v61] = v62;
        local _ = i;
    end;

    table.move(table_clone_ret, 1, math_clamp_ret, 1, table_create_ret);

    return table_create_ret;
end;

function v1.Flat(p63: table, p64: number?) -- Line: 537
    local u65 = type(p64) ~= "number" and 1 or p64;
    local table_create_ret = table.create(#p63);

    local function Scan(p66: table, p67: number) -- Line: 540
        -- upvalues: u65 (copy), Scan (copy), table_create_ret (copy)
        for _, v in p66 do
            if type(v) == "table" and p67 < u65 then
                Scan(v, p67 + 1);
            else
                table.insert(table_create_ret, v);
            end;
        end;
    end;

    Scan(p63, 0);

    return table_create_ret;
end;

function v1.FlatMap(p68: table, p69: function) -- Line: 574
    -- upvalues: Map (copy)
    local v70 = Map(p68, p69);
    local table_create_ret = table.create(#v70);
    local u71 = 1;

    local function u74(p72: table, p73: number) -- Line: 540
        -- upvalues: u71 (copy), u74 (copy), table_create_ret (copy)
        for _, v in p72 do
            if type(v) == "table" and p73 < u71 then
                u74(v, p73 + 1);
            else
                table.insert(table_create_ret, v);
            end;
        end;
    end;

    u74(v70, 0);

    return table_create_ret;
end;

function v1.Keys(p75: table) -- Line: 600
    local table_create_ret = table.create(#p75);

    for i in p75 do
        table.insert(table_create_ret, i);
    end;

    return table_create_ret;
end;

function v1.Values(p76: table) -- Line: 630
    local table_create_ret = table.create(#p76);

    for _, v in p76 do
        table.insert(table_create_ret, v);
    end;

    return table_create_ret;
end;

function v1.Find(p77: table, p78: function) -- Line: 669
    for i, v in p77 do
        if p78(v, i, p77) then
            return v, i;
        end;
    end;

    return nil, nil;
end;

function v1.Every(p79: table, p80: function) -- Line: 698
    for i, v in p79 do
        if not p80(v, i, p79) then
            return false;
        end;
    end;

    return true;
end;

function v1.Some(p81: table, p82: function) -- Line: 727
    for i, v in p81 do
        if p82(v, i, p81) then
            return true;
        end;
    end;

    return false;
end;

function v1.Truncate(p83: table, p84: number) -- Line: 753
    local v85 = #p83;
    local math_clamp_ret = math.clamp(p84, 1, v85);

    if math_clamp_ret == v85 then
        return table.clone(p83);
    end;

    return table.move(p83, 1, math_clamp_ret, 1, table.create(math_clamp_ret));
end;

function v1.Zip(...) -- Line: 786
    local v86 = select("#", ...) > 0;
    assert(v86, "Must supply at least 1 table");

    local function ZipIteratorArray(p87: table, p88: number) -- Line: 788
        local v89 = p88 + 1;
        local v90 = {};

        for i, v in p87 do
            local v91 = v[v89];

            if v91 == nil then
                return nil, nil;
            end;

            v90[i] = v91;
        end;

        return v89, v90;
    end;

    local function ZipIteratorMap(p92: table, p93: any) -- Line: 801
        local v94 = {};

        for i, v in p92 do
            local v95 = next(v, p93);

            if v95 == nil then
                return nil, nil;
            end;

            v94[i] = v95;
        end;

        return p93, v94;
    end;

    local v96 = { ... };

    if #v96[1] > 0 then
        return ZipIteratorArray, v96, 0;
    end;

    return ZipIteratorMap, v96, nil;
end;

function v1.Lock(p97) -- Line: 839
    local function Freeze(p98: table) -- Line: 840
        -- upvalues: Freeze (copy)
        for i, v in pairs(p98) do
            if type(v) == "table" then
                p98[i] = Freeze(v);
            end;
        end;

        return table.freeze(p98);
    end;

    return Freeze(p97);
end;

function v1.IsEmpty(p99: table) -- Line: 869
    return next(p99) == nil;
end;

function v1.EncodeJSON(p100) -- Line: 881
    -- upvalues: HttpService (copy)
    return HttpService:JSONEncode(p100);
end;

function v1.DecodeJSON(p101: string) -- Line: 893
    -- upvalues: HttpService (copy)
    return HttpService:JSONDecode(p101);
end;

return v1;