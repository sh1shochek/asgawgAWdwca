-- ReplicatedStorage.MovementV2.Simulation.PlayerBroadphase
-- Script path: ReplicatedStorage.MovementV2.Simulation.PlayerBroadphase
-- Decompile time: 2.24 ms

local Quantization = require(script.Parent.Parent.Quantization)
local Serial = require(script.Parent.Parent.Serial)
local u12 = {}
u12.__index = u12
u12.DefaultCellSize = 8

local function cellCoordinate(a1, a2) -- Line: 23 -- types: a1: number, a2: number
    return (math.floor(a1 / a2))
end

local function removeFromCell(a1, a2, a3, a4) -- Line: 27 -- types: a2: number, a3: number, a4: number
    local v1 = a1._cells[a3]
    if v1 == nil then
        return
    end
    local v2 = v1[a4]
    if v2 == nil then
        return
    end
    v2[a2] = nil
    if next(v2) == nil then
        v1[a4] = nil
        if next(v1) == nil then
            a1._cells[a3] = nil
        end
    end
end

function u12.new(a1) -- Line: 45 -- upvalues: u12 (val) -- types: a1: number?
    local DefaultCellSize = a1 or u12.DefaultCellSize
    local v1 = false
    if type(DefaultCellSize) == "number" then
        v1 = false
        if DefaultCellSize == DefaultCellSize then
            v1 = false
            if DefaultCellSize > 0 then
                v1 = DefaultCellSize < (1 / 0)
            end
        end
    end
    assert(v1, "invalid player broadphase cell size")
    return (setmetatable({
        _cellSize = DefaultCellSize,
        _cells = {},
        _cellXById = {},
        _cellZById = {},
        _queryScratch = {},
    }, u12))
end

function u12.clear(a1) -- Line: 63
    table.clear(a1._cells)
    table.clear(a1._cellXById)
    table.clear(a1._cellZById)
    table.clear(a1._queryScratch)
end

function u12.remove(a1, a2) -- Line: 70 -- types: a1: table, a2: number
    local v1 = a1._cellXById[a2]
    local v2 = a1._cellZById[a2]
    if v1 ~= nil and v2 ~= nil then
        local v3 = a1._cells[v1]
        if v3 ~= nil then
            local v4 = v3[v2]
            if v4 ~= nil then
                v4[a2] = nil
                if next(v4) == nil then
                    v3[v2] = nil
                    if next(v3) == nil then
                        a1._cells[v1] = nil
                    end
                end
            end
        end
        a1._cellXById[a2] = nil
        a1._cellZById[a2] = nil
        return
    end
end

function u12.upsert(a1, a2, a3) -- Line: 81
    -- upvalues: Serial (val), Quantization (val)
    local v1, v2
    assert(Serial.isUInt32(a2) and a2 > 0, "player broadphase ID must be a non-zero u32")
    assert(Quantization.isFiniteVector3(a3), "invalid player broadphase position")
    local v3 = math.floor(a3.X / a1._cellSize)
    local v4 = math.floor(a3.Z / a1._cellSize)
    local v5 = a1._cellXById[a2]
    local v6 = a1._cellZById[a2]
    if v5 == v3 and v6 == v4 then
        return
    end
    if v5 ~= nil and v6 ~= nil then
        v1 = a1._cells[v5]
        if v1 ~= nil then
            v2 = v1[v6]
            if v2 ~= nil then
                v2[a2] = nil
                if next(v2) == nil then
                    v1[v6] = nil
                    if next(v1) == nil then
                        a1._cells[v5] = nil
                    end
                end
            end
        end
    end
    v1 = a1._cells[v3]
    if v1 == nil then
        a1._cells[v3] = {}
    end
    v2 = v1[v4]
    if v2 == nil then
        v1[v4] = {}
    end
    v2[a2] = true
    a1._cellXById[a2] = v3
    a1._cellZById[a2] = v4
end

function u12.query(a1, a2, a3, a4) -- Line: 110
    -- upvalues: Quantization (val)
    local v1, v2
    assert(Quantization.isFiniteVector3(a2) and Quantization.isFiniteVector3(a3), "invalid query bounds")
    local v3 = false
    if a2.X <= a3.X then
        v3 = a2.Z <= a3.Z
    end
    assert(v3, "inverted player broadphase bounds")
    local _queryScratch = a4 or a1._queryScratch
    table.clear(_queryScratch)
    v3 = math.floor(a2.X / a1._cellSize)
    local v4 = math.floor(a3.X / a1._cellSize)
    local v5 = math.floor(a2.Z / a1._cellSize)
    local v6 = math.floor(a3.Z / a1._cellSize)
    for i = v3, v4 do
        v1 = a1._cells[i]
        if v1 ~= nil then
            for j = v5, v6 do
                v2 = v1[j]
                if v2 ~= nil then
                    for k in v2 do
                        _queryScratch[#_queryScratch + 1] = k
                    end
                end
            end
        end
    end
    table.sort(_queryScratch)
    return _queryScratch
end

return table.freeze(u12)