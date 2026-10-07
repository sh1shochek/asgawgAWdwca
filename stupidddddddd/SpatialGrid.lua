-- ReplicatedStorage.MovementV2.Collision.SpatialGrid
-- Script path: ReplicatedStorage.MovementV2.Collision.SpatialGrid
-- Decompile time: 5.82 ms

local Geometry = require(script.Parent.Geometry)
local u5 = {}
u5.__index = u5

local function cellRange(a1, a2, a3) -- Line: 20 -- types: a1: vector, a2: vector, a3: number
    return (math.floor(a1.X / a3)), (math.floor(a2.X / a3)), (math.floor(a1.Z / a3)), (math.floor(a2.Z / a3))
end

function u5.Build(a1, a2, a3, a4) -- Line: 27
    -- upvalues: Geometry (val), u5 (val)
    local AabbMax, AabbMin, v1, v2, v3, v4, v5, v6, v7, v8
    assert(a2 > 0, "spatial-grid cell size must be positive")
    local v9 = false
    if a3 >= 1 then
        v9 = a3 % 1 == 0
    end
    assert(v9, "invalid oversized-record threshold")
    v9 = true
    if a4 ~= nil then
        v9 = #a4 == #a1
    end
    assert(v9, "paired spatial-grid records must have equal counts")
    local v10 = {}
    v9 = {}
    local v11 = nil
    local v12 = nil
    local v13, v14 = a2, a4
    for i, j in a1, v11, v12 do
        AabbMin = j.AabbMin
        AabbMax = j.AabbMax
        v1 = if v14 == nil then nil else v14[i]
        if v1 ~= nil then
            AabbMin = Geometry.Min(AabbMin, v1.AabbMin)
            AabbMax = Geometry.Max(AabbMax, v1.AabbMax)
        end
        v2 = math.floor(AabbMin.X / v13)
        v3 = math.floor(AabbMax.X / v13)
        v4 = math.floor(AabbMin.Z / v13)
        v5 = math.floor(AabbMax.Z / v13)
        if not (v6 < (v3 - v2 + 1) * (v5 - v4 + 1)) then
            for k = v2, v3 do
                v7 = v10[k]
                if v7 == nil then
                    v10[k] = {}
                end
                for n = v4, v5 do
                    v8 = v7[n]
                    if v8 == nil then
                        v7[n] = {}
                    end
                    v8[#v8 + 1] = i
                end
            end
        else
            v9[#v9 + 1] = i
        end
    end
    v11 = nil
    v12 = nil
    for m, i5 in v10, v11, v12 do
        for i6, i7 in i5 do
            table.freeze(i7)
        end
        table.freeze(i5)
    end
    table.freeze(v10)
    table.freeze(v9)
    return (setmetatable({CellSize = v13, Cells = v10, Oversized = v9}, u5))
end

function u5.QueryInto(a1, a2, a3, a4, a5, a6, a7, a8, a9) -- Line: 86
    -- upvalues: 
    local AabbMax_3, AabbMin_3, v1, v2, v3, v4, v5, v6, v7
    local v8 = false
    if a7 % 1 == 0 then
        v8 = a7 > 0
    end
    assert(v8, "spatial-grid query stamp must be a positive integer")
    local CellSize = a1.CellSize
    local v9 = math.floor(a2.X / CellSize)
    v8 = math.floor(a3.X / CellSize)
    local v10 = math.floor(a2.Z / CellSize)
    local v11 = math.floor(a3.Z / CellSize)
    table.clear(a5)
    local v12 = a8 or {}
    table.clear(v12)
    if #a1.Oversized > 0 then
        v12[#v12 + 1] = a1.Oversized
    end
    local v13, v14, v15, v16, v17, v18, v19 = a1, a2, a3, a4, a5, a6, a7
    for i = v9, v8 do
        v1 = v13.Cells[i]
        if v1 ~= nil then
            for j = v10, v11 do
                v2 = v1[j]
                if v2 ~= nil then
                    v12[#v12 + 1] = v2
                end
            end
        end
    end
    local v20 = #v12
    local X_3 = v14.X
    local Y = v14.Y
    local Z_3 = v14.Z
    local X_4 = v15.X
    local Y_2 = v15.Y
    local Z_4 = v15.Z
    v2 = 0
    if v20 == 1 then
        local AabbMax_2, AabbMin_2
        for i6, i7 in v12[1] do
            v5 = v16[i7]
            AabbMin_2 = v5.AabbMin
            AabbMax_2 = v5.AabbMax
            if X_3 <= AabbMax_2.X
                and AabbMin_2.X <= X_4
                and Y <= AabbMax_2.Y
                and AabbMin_2.Y <= Y_2
                and Z_3 <= AabbMax_2.Z
                and AabbMin_2.Z <= Z_4 then
                v2 = v2 + 1
                v17[v2] = i7
            end
        end
        return
    end
    if v20 ~= 2 then
        local AabbMax, AabbMin, v21
        v3 = nil
        v4 = nil
        for k, n in v12, v3, v4 do
            for m, i5 in n do
                if v18[i5] ~= v19 then
                    v18[i5] = v19
                    v21 = v16[i5]
                    AabbMin = v21.AabbMin
                    AabbMax = v21.AabbMax
                    if X_3 <= AabbMax.X
                        and AabbMin.X <= X_4
                        and Y <= AabbMax.Y
                        and AabbMin.Y <= Y_2
                        and Z_3 <= AabbMax.Z
                        and AabbMin.Z <= Z_4 then
                        v2 = v2 + 1
                        v17[v2] = i5
                    end
                end
            end
        end
        table.sort(v17)
        return
    end
    local v22 = v12[1]
    v3 = v12[2]
    v4 = 1
    local v23 = 1
    local v24 = v22[1]
    v5 = v3[1]
    while true do
        if v24 ~= nil then
            if v5 == nil then
                v6 = v24
                v4 = v4 + 1
                v24 = v22[v4]
            elseif v24 == nil then
                if v24 == nil then
                    v6 = v5
                    v23 = v23 + 1
                elseif not (v5 < v24) then
                    v6 = v24
                    v4 = v4 + 1
                    v23 = v23 + 1
                    v24 = v22[v4]
                else
                    v6 = v5
                    v23 = v23 + 1
                end
                v5 = v3[v23]
            elseif v24 < v5 then
                v6 = v24
                v4 = v4 + 1
                v24 = v22[v4]
            else
                if v24 == nil then
                    v6 = v5
                    v23 = v23 + 1
                elseif not (v5 < v24) then
                    v6 = v24
                    v4 = v4 + 1
                    v23 = v23 + 1
                    v24 = v22[v4]
                else
                    v6 = v5
                    v23 = v23 + 1
                end
                v5 = v3[v23]
            end
            v7 = v16[v6]
            AabbMin_3 = v7.AabbMin
            AabbMax_3 = v7.AabbMax
            if X_3 <= AabbMax_3.X
                and AabbMin_3.X <= X_4
                and Y <= AabbMax_3.Y
                and AabbMin_3.Y <= Y_2
                and Z_3 <= AabbMax_3.Z
                and AabbMin_3.Z <= Z_4 then
                v2 = v2 + 1
                v17[v2] = v6
            end
            continue
        end
        if v5 == nil then
            break
        end
        if v5 == nil then
            v6 = v24
            v4 = v4 + 1
            v24 = v22[v4]
        elseif v24 == nil then
            if v24 == nil then
                v6 = v5
                v23 = v23 + 1
            elseif not (v5 < v24) then
                v6 = v24
                v4 = v4 + 1
                v23 = v23 + 1
                v24 = v22[v4]
            else
                v6 = v5
                v23 = v23 + 1
            end
            v5 = v3[v23]
        elseif v24 < v5 then
            v6 = v24
            v4 = v4 + 1
            v24 = v22[v4]
        else
            if v24 == nil then
                v6 = v5
                v23 = v23 + 1
            elseif not (v5 < v24) then
                v6 = v24
                v4 = v4 + 1
                v23 = v23 + 1
                v24 = v22[v4]
            else
                v6 = v5
                v23 = v23 + 1
            end
            v5 = v3[v23]
        end
        v7 = v16[v6]
        AabbMin_3 = v7.AabbMin
        AabbMax_3 = v7.AabbMax
        if X_3 <= AabbMax_3.X
            and AabbMin_3.X <= X_4
            and Y <= AabbMax_3.Y
            and AabbMin_3.Y <= Y_2
            and Z_3 <= AabbMax_3.Z
            and AabbMin_3.Z <= Z_4 then
            v2 = v2 + 1
            v17[v2] = v6
        end
    end
end

return table.freeze(u5)