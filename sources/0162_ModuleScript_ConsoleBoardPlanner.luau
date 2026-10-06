-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.ConsoleTypes);
local v1 = {
    COLUMN_COUNT = 8,
    ROW_COUNT = 5
};
local u2 = {
    Blue = 1,
    Purple = 2,
    Pink = 3,
    Red = 4
};
local u3 = { { 5 }, { 3, 4, 4, 4 }, { 3, 4 }, { 3, 3, 3, 4 }, { 3 }, { 2, 2, 3, 3, 3 }, { 2 }, { 1 } };
local u4 = { 5, 3, 3, 3, 3, 2, 2, 1 };
local u5 = { { 5 }, { 4 }, { 2, 2, 2, 3, 3 }, { 2, 2, 2, 2, 3 }, { 2, 2, 2, 2, 3 }, { 1, 2, 2, 2, 2 }, { 1, 1, 2, 2, 2 }, { 1 } };
local u6 = { 5, 4, 2, 2, 2, 2, 1, 1 };

local function countRows(p7: table) -- Line: 55
    local v8 = 0;

    for _ in p7 do
        v8 = v8 + 1;
    end;

    return v8;
end;

local function choose(p9: table) -- Line: 63
    return p9[math.random(1, #p9)];
end;

local function randomSubset(p10: table, p11: number) -- Line: 67
    local v12 = {};

    for i in p10 do
        table.insert(v12, i);
    end;

    local v13 = {};

    for i = 1, p11 do
        local math_random_ret = math.random(1, #v12);
        v13[table.remove(v12, math_random_ret)] = true;
        local _ = i;
    end;

    return v13;
end;

local function landingRows(p14: table, p15: table, p16: number) -- Line: 81
    local table_clone_ret = table.clone(p15);
    local v17 = {};

    if not p14[0] then
        table.insert(v17, 0);
    end;

    if not p14[1] then
        table.insert(v17, 1);
    end;

    if not p14[2] then
        table.insert(v17, 2);
    end;

    if not p14[3] then
        table.insert(v17, 3);
    end;

    if not p14[4] then
        table.insert(v17, 4);
    end;

    local v18 = 0;

    for _ in p15 do
        v18 = v18 + 1;
    end;

    local math_max_ret = math.max(p16 - v18, 0);

    for i = 1, math.min(math_max_ret, #v17) do
        local math_random_ret = math.random(1, #v17);
        table_clone_ret[table.remove(v17, math_random_ret)] = true;
        local _ = i;
    end;

    return table_clone_ret;
end;

local function cloneRowsByColumn(p19: table) -- Line: 98
    local v20 = {};

    for i = 0, 7 do
        v20[i] = table.clone(p19[i]);
        local _ = i;
    end;

    return v20;
end;

local function fitUpcomingMiss(p21: table, p22: number, p23: number, p24: number, p25: number) -- Line: 106
    -- upvalues: u4 (copy), u6 (copy), randomSubset (copy)
    local v26 = 0;

    for _ in p21[p23] do
        v26 = v26 + 1;
    end;

    local math_max_ret = math.max(u6[p22 + 1], u4[p22 + 1] - (5 - p24));
    local v27 = 5 - math.min(p24, math_max_ret);

    if v27 < v26 then
        p21[p23] = randomSubset({
            [0] = true,
            [1] = true,
            [2] = true,
            [3] = true,
            [4] = true
        }, v27);
    else
        v27 = v26;
    end;

    local math_min_ret = math.min(p24, p25, 5 - v27);

    return math.min(p25, 5 - p24 + math_min_ret), math_min_ret;
end;

local function chooseSurvivorCount(p28: number, p29: number, p30: number, p31: number) -- Line: 130
    -- upvalues: u5 (copy)
    local math_max_ret = math.max(1, p30 - (5 - p29));
    local math_min_ret = math.min(p31, p30);
    local math_max_ret2 = math.max(math_max_ret, math_min_ret);
    local v32 = u5[p28 + 1];
    local v33 = v32[math.random(1, #v32)];

    return math.clamp(v33, math_max_ret, math_max_ret2);
end;

function v1.createAllRows() -- Line: 47
    return {
        [0] = true,
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true
    };
end;

function v1.createInitialSpinRows() -- Line: 143
    -- upvalues: randomSubset (copy), u3 (copy)
    local v34 = {
        [0] = true,
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true
    };
    local v35 = {};

    for i = 0, 7 do
        local v36 = u3[i + 1];
        v35[i] = randomSubset(v34, v36[math.random(1, #v36)]);
        local _ = i;
    end;

    return v35;
end;

function v1.prepare(p37: table, p38: table, p39: table) -- Line: 152
    -- upvalues: cloneRowsByColumn (copy), fitUpcomingMiss (copy), u5 (copy), randomSubset (copy), landingRows (copy)
    local v40 = cloneRowsByColumn(p37);
    local table_clone_ret = table.clone(p38);
    local v41 = {};
    local v42 = {};

    for i, v in p39 do
        local columnIndex = v.columnIndex;
        local v43 = i;
        local v44 = v;
        local v45 = 0;

        for _ in table_clone_ret do
            v45 = v45 + 1;
        end;

        local v46 = 0;

        for _ in v40[columnIndex] do
            v46 = v46 + 1;
        end;

        local v47 = 0;

        if v44.result == "hit" then
            local v48 = p39[v43 + 1];
            local math_min_ret = math.min(v45, v46);

            if v48 and v48.result == "miss" then
                v46, math_min_ret = fitUpcomingMiss(v40, columnIndex, v48.columnIndex, v45, v46);
            end;

            local math_max_ret = math.max(1, v46 - (5 - v45));
            local math_min_ret2 = math.min(math_min_ret, v46);
            local math_max_ret2 = math.max(math_max_ret, math_min_ret2);
            local v49 = u5[columnIndex + 1];
            local v50 = v49[math.random(1, #v49)];
            v47 = math.clamp(v50, math_max_ret, math_max_ret2);
        else
            v46 = math.min(v46, 5 - v45);
        end;

        local v51 = randomSubset(table_clone_ret, v47);
        local v52 = landingRows(table_clone_ret, v51, v46);
        v41[columnIndex] = v51;
        v42[columnIndex] = v52;
        v40[columnIndex] = v52;

        if v44.result == "miss" then
            break;
        end;

        table_clone_ret = v51;
    end;

    for i = 0, 7 do
        v42[i] = v42[i] or table.clone(v40[i]);
        local _ = i;
    end;

    return {
        SpinRows = v40,
        SurvivingRows = v41,
        PlannedRows = v42
    };
end;

function v1.getDisplaySteps(p53) -- Line: 205
    -- upvalues: u2 (copy)
    local v54 = nil;

    for _, v in p53.path do
        if v.result == "miss" and v.columnIndex < 3 then
            v54 = v;
            break;
        end;
    end;

    if not v54 or v54.columnIndex ~= 2 then
        return p53.path;
    end;

    local v55;

    if v54.rarity then
        v55 = u2[v54.rarity];
    else
        v55 = nil;
    end;

    if v55 and u2[p53.finalRarity] < v55 then
        return p53.path;
    end;

    local v56 = {};

    for _, v in p53.path do
        if v == v54 then
            break;
        end;

        table.insert(v56, v);
    end;

    local table_clone_ret = table.clone(v54);
    table_clone_ret.hitRows = { 0, 1, 2, 3, 4 };
    table_clone_ret.result = "hit";
    table.insert(v56, table_clone_ret);
    table.insert(v56, {
        columnIndex = 3,
        kind = "bridge",
        rarity = nil,
        result = "miss",
        hitRows = {}
    });

    return v56;
end;

return table.freeze(v1);