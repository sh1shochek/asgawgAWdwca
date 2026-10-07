-- ReplicatedStorage.Controllers.CaseSceneController.ConsoleBoardPlanner
-- Script path: ReplicatedStorage.Controllers.CaseSceneController.ConsoleBoardPlanner
-- Decompile time: 4.23 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.ConsoleTypes)
local v1 = {COLUMN_COUNT = 8, ROW_COUNT = 5}
local u11 = {Blue = 1, Purple = 2, Pink = 3, Red = 4}
local u12 = {{5}, {3, 4, 4, 4}, {3, 4}, {3, 3, 3, 4}, {3}, {2, 2, 3, 3, 3}, {2}, {1}}
local u40 = {5, 3, 3, 3, 3, 2, 2, 1}
local u49 = {{5}, {4}, {2, 2, 2, 3, 3}, {2, 2, 2, 2, 3}, {2, 2, 2, 2, 3}, {1, 2, 2, 2, 2}, {1, 1, 2, 2, 2}, {1}}
local u86 = {5, 4, 2, 2, 2, 2, 1, 1}

local function countRows(a1) -- Line: 55 -- types: a1: table
    local v1 = 0
    for i in a1 do
        v1 = v1 + 1
    end
    return v1
end

local function choose(a1) -- Line: 63 -- types: a1: table
    return a1[math.random(1, #a1)]
end

local function randomSubset(a1, a2) -- Line: 67 -- types: a1: table, a2: number
    local v1 = {}
    for i in a1 do
        table.insert(v1, i)
    end
    local v2 = {}
    for j = 1, a2 do
        v2[(table.remove(v1, (math.random(1, #v1))))] = true
    end
    return v2
end

local function landingRows(a1, a2, a3) -- Line: 81 -- types: a1: table, a2: table, a3: number
    local v1 = table.clone(a2)
    local v2 = {}
    if not a1[0] then
        table.insert(v2, 0)
    end
    if not a1[1] then
        table.insert(v2, 1)
    end
    if not a1[2] then
        table.insert(v2, 2)
    end
    if not a1[3] then
        table.insert(v2, 3)
    end
    if not a1[4] then
        table.insert(v2, 4)
    end
    local v3 = 0
    for i in a2 do
        v3 = v3 + 1
    end
    for j = 1, (math.min(math.max(a3 - v3, 0), #v2)) do
        v1[(table.remove(v2, (math.random(1, #v2))))] = true
    end
    return v1
end

local function cloneRowsByColumn(a1) -- Line: 98 -- types: a1: table
    local v1 = {}
    for i = 0, 7 do
        v1[i] = (table.clone(a1[i]))
    end
    return v1
end

local function fitUpcomingMiss(a1, a2, a3, a4, a5) -- Line: 106
    -- upvalues: u40 (val), u86 (val), randomSubset (val)
    local v1 = 0
    for i in a1[a3] do
        v1 = v1 + 1
    end
    local v2 = u40[a2 + 1] - (5 - a4)
    local v3 = 5 - math.min(a4, (math.max(u86[a2 + 1], v2)))
    if v3 < v1 then
        a1[a3] = (randomSubset({
            [0] = true,
            true,
            true,
            true,
            true,
        }, v3))
    end
    local v4 = math.min(a4, a5, 5 - v1)
    return math.min(a5, 5 - a4 + v4), v4
end

local function chooseSurvivorCount(a1, a2, a3, a4) -- Line: 130
    -- upvalues: u49 (val)
    local v1 = math.max(1, a3 - (5 - a2))
    local v2 = math.max(v1, (math.min(a4, a3)))
    local v3 = u49[a1 + 1]
    return (math.clamp(v3[math.random(1, #v3)], v1, v2))
end

function v1.createAllRows() -- Line: 47
    return {
        [0] = true,
        true,
        true,
        true,
        true,
    }
end

function v1.createInitialSpinRows() -- Line: 143 -- upvalues: randomSubset (val), u12 (val)
    local v1, v2
    local v3 = {}
    for i = 0, 7 do
        v1 = randomSubset
        v2 = u12[i + 1]
        v3[i] = (v1({
            [0] = true,
            true,
            true,
            true,
            true,
        }, v2[math.random(1, #v2)]))
    end
    return v3
end

function v1.prepare(a1, a2, a3) -- Line: 152
    -- upvalues: cloneRowsByColumn (val), fitUpcomingMiss (val), u49 (val), randomSubset (val), landingRows (val)
    local columnIndex, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
    local v13 = cloneRowsByColumn(a1)
    local v14 = table.clone(a2)
    local v15 = {}
    local v16 = {}
    local v17 = nil
    local v18 = nil
    for i, j in a3, v17, v18 do
        columnIndex = j.columnIndex
        v2 = 0
        for k in v14 do
            v2 = v2 + 1
        end
        v3 = 0
        v5 = v13[columnIndex]
        v6 = nil
        v7 = nil
        for n in v5, v6, v7 do
            v3 = v3 + 1
        end
        v4 = 0
        if j.result ~= "hit" then
            v3 = math.min(v3, 5 - v2)
        else
            v5 = v9[i + 1]
            v6 = math.min(v2, v3)
            if v5 and v5.result == "miss" then
                v7, v8 = fitUpcomingMiss(v13, columnIndex, v5.columnIndex, v2, v3)
                v3 = v7
                v6 = v8
            end
            v10 = math.max(1, v3 - (5 - v2))
            v11 = math.max(v10, (math.min(v6, v3)))
            v12 = u49[columnIndex + 1]
            v4 = math.clamp(v12[math.random(1, #v12)], v10, v11)
        end
        v5 = randomSubset(v14, v4)
        v6 = landingRows(v14, v5, v3)
        v15[columnIndex] = v5
        v16[columnIndex] = v6
        v13[columnIndex] = v6
        if j.result == "miss" then
            break
        end
    end
    for m = 0, 7 do
        v1 = v16[m] or table.clone(v13[m])
        v16[m] = v1
    end
    return {SpinRows = v13, SurvivingRows = v15, PlannedRows = v16}
end

function v1.getDisplaySteps(a1) -- Line: 205 -- upvalues: u11 (val)
    local v1 = nil
    local v2 = nil
    local v3 = nil
    for i, j in a1.path, v2, v3 do
        if j.result == "miss" and j.columnIndex < 3 then
            v1 = j
            break
        end
    end
    if v1 and v1.columnIndex == 2 then
        local v4 = if not v1.rarity then nil else u11[v1.rarity]
        if v4 and u11[a1.finalRarity] < v4 then
            return a1.path
        end
        v2 = {}
        for k, n in a1.path do
            if n == v1 then
                break
            end
            table.insert(v2, n)
        end
        v3 = table.clone(v1)
        v3.hitRows = {0, 1, 2, 3, 4}
        v3.result = "hit"
        table.insert(v2, v3)
        table.insert(v2, {columnIndex = 3, kind = "bridge", result = "miss", hitRows = {}})
        return v2
    end
    return a1.path
end

return table.freeze(v1)