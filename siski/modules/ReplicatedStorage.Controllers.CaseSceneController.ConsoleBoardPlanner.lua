-- ReplicatedStorage.Controllers.CaseSceneController.ConsoleBoardPlanner
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.ConsoleTypes);
local v1 = {
    ROW_COUNT = 5
};
local u2 = {
    Blue = 1,
    Purple = 2,
    Pink = 3,
    Red = 4,
    Special = 5
};
local u3 = {
    [8] = {
        ArrowCountOptions = { { 5 }, { 3, 4, 4, 4 }, { 3, 4 }, { 3, 3, 3, 4 }, { 3 }, { 2, 2, 3, 3, 3 }, { 2 }, { 1 } },
        MinimumArrowCounts = { 5, 3, 3, 3, 3, 2, 2, 1 },
        SurvivingRowOptions = { { 5 }, { 4 }, { 2, 2, 2, 3, 3 }, { 2, 2, 2, 2, 3 }, { 2, 2, 2, 2, 3 }, { 1, 2, 2, 2, 2 }, { 1, 1, 2, 2, 2 }, { 1 } },
        MinimumSurvivingRowsBeforeMiss = { 5, 4, 2, 2, 2, 2, 1, 1 }
    },
    [10] = {
        ArrowCountOptions = { { 5 }, { 3, 4, 4, 4 }, { 3, 4 }, { 3, 4 }, { 3, 3, 3, 4 }, { 3 }, { 2, 2, 3, 3, 3 }, { 2 }, { 1, 2 }, { 1 } },
        MinimumArrowCounts = { 5, 3, 3, 3, 3, 3, 2, 2, 1, 1 },
        SurvivingRowOptions = { { 5 }, { 4 }, { 2, 2, 2, 3, 3 }, { 2, 2, 2, 2, 3 }, { 2, 2, 2, 2, 3 }, { 2, 2, 2, 2, 3 }, { 1, 2, 2, 2, 2 }, { 1, 1, 2, 2, 2 }, { 1, 1, 1, 2 }, { 1 } },
        MinimumSurvivingRowsBeforeMiss = { 5, 4, 2, 2, 2, 2, 2, 1, 1, 1 }
    }
};

local function countRows(p4: table) -- Line: 92
    local v5 = 0;

    for _ in p4 do
        v5 = v5 + 1;
    end;

    return v5;
end;

local function choose(p6: table) -- Line: 100
    return p6[math.random(1, #p6)];
end;

local function randomSubset(p7: table, p8: number) -- Line: 104
    local v9 = {};

    for i in p7 do
        table.insert(v9, i);
    end;

    local v10 = {};

    for i = 1, p8 do
        local math_random_ret = math.random(1, #v9);
        v10[table.remove(v9, math_random_ret)] = true;
        local _ = i;
    end;

    return v10;
end;

local function landingRows(p11: table, p12: table, p13: number) -- Line: 118
    local table_clone_ret = table.clone(p12);
    local v14 = {};

    if not p11[0] then
        table.insert(v14, 0);
    end;

    if not p11[1] then
        table.insert(v14, 1);
    end;

    if not p11[2] then
        table.insert(v14, 2);
    end;

    if not p11[3] then
        table.insert(v14, 3);
    end;

    if not p11[4] then
        table.insert(v14, 4);
    end;

    local v15 = 0;

    for _ in p12 do
        v15 = v15 + 1;
    end;

    local math_max_ret = math.max(p13 - v15, 0);

    for i = 1, math.min(math_max_ret, #v14) do
        local math_random_ret = math.random(1, #v14);
        table_clone_ret[table.remove(v14, math_random_ret)] = true;
        local _ = i;
    end;

    return table_clone_ret;
end;

local function getLayout(p16: number) -- Line: 135
    -- upvalues: u3 (copy)
    local v17 = u3[p16];
    local v18 = `[ConsoleBoardPlanner] No layout for {p16} columns`;

    return assert(v17, v18);
end;

local function cloneRowsByColumn(p19: table, p20: number) -- Line: 139
    local v21 = {};

    for i = 0, p20 - 1 do
        v21[i] = table.clone(p19[i]);
        local _ = i;
    end;

    return v21;
end;

local function fitUpcomingMiss(p22: table, p23: table, p24: number, p25: number, p26: number, p27: number) -- Line: 147
    -- upvalues: randomSubset (copy)
    local v28 = 0;

    for _ in p23[p25] do
        v28 = v28 + 1;
    end;

    local math_max_ret = math.max(p22.MinimumSurvivingRowsBeforeMiss[p24 + 1], p22.MinimumArrowCounts[p24 + 1] - (5 - p26));
    local v29 = 5 - math.min(p26, math_max_ret);

    if v29 < v28 then
        p23[p25] = randomSubset({
            [0] = true,
            [1] = true,
            [2] = true,
            [3] = true,
            [4] = true
        }, v29);
    else
        v29 = v28;
    end;

    local math_min_ret = math.min(p26, p27, 5 - v29);

    return math.min(p27, 5 - p26 + math_min_ret), math_min_ret;
end;

local function chooseSurvivorCount(p30: table, p31: number, p32: number, p33: number, p34: number) -- Line: 172
    local math_max_ret = math.max(1, p33 - (5 - p32));
    local math_min_ret = math.min(p34, p33);
    local math_max_ret2 = math.max(math_max_ret, math_min_ret);
    local v35 = p30.SurvivingRowOptions[p31 + 1];
    local v36 = v35[math.random(1, #v35)];

    return math.clamp(v36, math_max_ret, math_max_ret2);
end;

function v1.createAllRows() -- Line: 84
    return {
        [0] = true,
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true
    };
end;

function v1.createInitialSpinRows(p37: number) -- Line: 186
    -- upvalues: u3 (copy), randomSubset (copy)
    local v38 = u3[p37];
    local v39 = `[ConsoleBoardPlanner] No layout for {p37} columns`;
    local v40 = assert(v38, v39);
    local v41 = {
        [0] = true,
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true
    };
    local v42 = {};

    for i = 0, p37 - 1 do
        local v43 = v40.ArrowCountOptions[i + 1];
        v42[i] = randomSubset(v41, v43[math.random(1, #v43)]);
        local _ = i;
    end;

    return v42;
end;

function v1.prepare(p44: table, p45: table, p46: table, p47: number) -- Line: 196
    -- upvalues: u3 (copy), cloneRowsByColumn (copy), fitUpcomingMiss (copy), randomSubset (copy), landingRows (copy)
    local v48 = u3[p47];
    local v49 = `[ConsoleBoardPlanner] No layout for {p47} columns`;
    local v50 = assert(v48, v49);
    local v51 = cloneRowsByColumn(p44, p47);
    local table_clone_ret = table.clone(p45);
    local v52 = {};
    local v53 = {};

    for i, v in p46 do
        local columnIndex = v.columnIndex;
        local v54 = i;
        local v55 = v;
        local v56 = 0;

        for _ in table_clone_ret do
            v56 = v56 + 1;
        end;

        local v57 = 0;

        for _ in v51[columnIndex] do
            v57 = v57 + 1;
        end;

        local v58 = 0;

        if v55.result == "hit" then
            local v59 = p46[v54 + 1];
            local math_min_ret = math.min(v56, v57);

            if v59 and v59.result == "miss" then
                v57, math_min_ret = fitUpcomingMiss(v50, v51, columnIndex, v59.columnIndex, v56, v57);
            end;

            local math_max_ret = math.max(1, v57 - (5 - v56));
            local math_min_ret2 = math.min(math_min_ret, v57);
            local math_max_ret2 = math.max(math_max_ret, math_min_ret2);
            local v60 = v50.SurvivingRowOptions[columnIndex + 1];
            local v61 = v60[math.random(1, #v60)];
            v58 = math.clamp(v61, math_max_ret, math_max_ret2);
        else
            v57 = math.min(v57, 5 - v56);
        end;

        local v62 = randomSubset(table_clone_ret, v58);
        local v63 = landingRows(table_clone_ret, v62, v57);
        v52[columnIndex] = v62;
        v53[columnIndex] = v63;
        v51[columnIndex] = v63;

        if v55.result == "miss" then
            break;
        end;

        table_clone_ret = v62;
    end;

    for i = 0, p47 - 1 do
        v53[i] = v53[i] or table.clone(v51[i]);
        local _ = i;
    end;

    return {
        SpinRows = v51,
        SurvivingRows = v52,
        PlannedRows = v53
    };
end;

function v1.getDisplaySteps(p64) -- Line: 251
    -- upvalues: u2 (copy)
    local v65 = nil;

    for _, v in p64.path do
        if v.result == "miss" and v.columnIndex < 3 then
            v65 = v;
            break;
        end;
    end;

    if not v65 or v65.columnIndex ~= 2 then
        return p64.path;
    end;

    local v66;

    if v65.rarity then
        v66 = u2[v65.rarity];
    else
        v66 = nil;
    end;

    if v66 and u2[p64.finalRarity] < v66 then
        return p64.path;
    end;

    local v67 = {};

    for _, v in p64.path do
        if v == v65 then
            break;
        end;

        table.insert(v67, v);
    end;

    local table_clone_ret = table.clone(v65);
    table_clone_ret.hitRows = { 0, 1, 2, 3, 4 };
    table_clone_ret.result = "hit";
    table.insert(v67, table_clone_ret);
    table.insert(v67, {
        columnIndex = 3,
        kind = "bridge",
        rarity = nil,
        result = "miss",
        hitRows = {}
    });

    return v67;
end;

return table.freeze(v1);