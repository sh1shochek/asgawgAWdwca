-- ReplicatedStorage.Visibility.SilhouetteCoverage
-- Script path: ReplicatedStorage.Visibility.SilhouetteCoverage
-- Decompile time: 10.77 ms

require(script.Parent.StaticOcclusionRuntime)
local u5 = {}
u5.__index = u5

local function spanMask(a1, a2) -- Line: 50 -- types: a1: number, a2: number
    return (bit32.lshift(1, a2 + 1)) - bit32.lshift(1, a1)
end

local function projectFrame(a1, a2, a3, a4) -- Line: 55 -- types: a2: vector, a3: table, a4: number
    local v1, v2, v3, v4, v5
    local v6 = Vector3.new(0, 0, 0)
    for i = 1, a4 do
        v6 = v6 + a3[i]
    end
    local v7 = v6 / a4 - a2
    if v7.Magnitude <= 0.05 then
        return false
    end
    local Unit = v7.Unit
    local v8 = Unit:Cross((Vector3.new(0, 1, 0)))
    if v8.Magnitude < 0.0001 then
        v8 = Unit:Cross((Vector3.new(1, 0, 0)))
    end
    local Unit_2 = v8.Unit
    local v9 = Unit_2:Cross(Unit)
    local v10 = (1 / 0)
    local v11 = (1 / 0)
    local v12 = (-1 / 0)
    local v13 = (-1 / 0)
    local v14 = (1 / 0)
    for j = 1, a4 do
        v1 = a3[j] - a2
        v2 = v1:Dot(Unit)
        if v2 - 0.75 <= 0.05 then
            return false
        end
        v14 = math.min(v14, v2 - 0.75)
        v3 = v1:Dot(Unit_2) / v2
        v4 = v1:Dot(v9) / v2
        v5 = 0.75 / (v2 - 0.75)
        v10 = math.min(v10, v3 - v5)
        v12 = math.max(v12, v3 + v5)
        v11 = math.min(v11, v4 - v5)
        v13 = math.max(v13, v4 + v5)
    end
    a1.Origin = a2
    a1.Forward = Unit
    a1.Right = Unit_2
    a1.Up = v9
    a1.MinX = v10
    a1.MinY = v11
    a1.StepX = (v12 - v10) / 16
    a1.StepY = (v13 - v11) / 16
    a1.MinNearest = v14
    return true
end

local function fillWindow(a1) -- Line: 103
    local Pending = a1.Pending
    local RowDepth = a1.RowDepth
    for i = 1, 16 do
        Pending[i] = 65535
        RowDepth[i] = a1.MinNearest
    end
    a1.PendingRows = 16
end

local function fillSilhouette(a1, a2, a3) -- Line: 113 -- types: a2: table, a3: number
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
    local Origin = a1.Origin
    local Forward = a1.Forward
    local Right = a1.Right
    local Up = a1.Up
    local MinX = a1.MinX
    local MinY = a1.MinY
    local StepX = a1.StepX
    local StepY = a1.StepY
    local Pending = a1.Pending
    local RowDepth = a1.RowDepth
    Pending[1] = 0
    RowDepth[1] = (1 / 0)
    Pending[2] = 0
    RowDepth[2] = (1 / 0)
    Pending[3] = 0
    RowDepth[3] = (1 / 0)
    Pending[4] = 0
    RowDepth[4] = (1 / 0)
    Pending[5] = 0
    RowDepth[5] = (1 / 0)
    Pending[6] = 0
    RowDepth[6] = (1 / 0)
    Pending[7] = 0
    RowDepth[7] = (1 / 0)
    Pending[8] = 0
    RowDepth[8] = (1 / 0)
    Pending[9] = 0
    RowDepth[9] = (1 / 0)
    Pending[10] = 0
    RowDepth[10] = (1 / 0)
    Pending[11] = 0
    RowDepth[11] = (1 / 0)
    Pending[12] = 0
    RowDepth[12] = (1 / 0)
    Pending[13] = 0
    RowDepth[13] = (1 / 0)
    Pending[14] = 0
    RowDepth[14] = (1 / 0)
    Pending[15] = 0
    RowDepth[15] = (1 / 0)
    Pending[16] = 0
    RowDepth[16] = (1 / 0)
    for i = 1, a3 do
        v1 = a2[i] - Origin
        v2 = v1:Dot(Forward)
        v3 = v1:Dot(Right) / v2
        v4 = v1:Dot(Up) / v2
        v5 = 0.75 / (v2 - 0.75)
        v6 = v2 - 0.75
        for j = (math.clamp(math.ceil((v4 - v5 - MinY) / StepY - 0.5), 0, 15)), (math.clamp(math.floor((v4 + v5 - MinY) / StepY - 0.5), 0, 15)) do
            v9 = MinY + (j + 0.5) * StepY - v4
            v10 = v5 * v5 - v9 * v9
            if not (v10 < 0) then
                v11 = math.sqrt(v10)
                v12 = math.max(math.ceil((v3 - v11 - MinX) / StepX - 0.5), 0)
                v13 = math.min(math.floor((v3 + v11 - MinX) / StepX - 0.5), 15)
                if v12 <= v13 then
                    v14 = j + 1
                    Pending[v14] = (bit32.bor(Pending[j + 1], (bit32.lshift(1, v13 + 1)) - (bit32.lshift(1, v12))))
                    v14 = j + 1
                    RowDepth[v14] = (math.min(RowDepth[j + 1], v6))
                end
            end
        end
        v7 = math.clamp(math.floor((v3 - MinX) / StepX), 0, 15)
        v8 = math.clamp(math.floor((v4 - MinY) / StepY), 0, 15) + 1
        Pending[v8] = (bit32.bor(Pending[v8], (bit32.lshift(1, v7))))
        RowDepth[v8] = (math.min(RowDepth[v8], v6))
    end
    local v15 = 0
    for k = 1, 16 do
        if Pending[k] ~= 0 then
            v15 = v15 + 1
        end
    end
    a1.PendingRows = v15
end

local function rasterTriangle(a1, a2, a3, a4) -- Line: 160 -- types: a2: vector, a3: vector, a4: vector
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21
    local Origin = a1.Origin
    local Forward = a1.Forward
    local Right = a1.Right
    local Up = a1.Up
    local ClipX = a1.ClipX
    local ClipY = a1.ClipY
    local ClipW = a1.ClipW
    local v22 = 0
    local v23, v24, v25 = a2, a3, a4
    for i = 1, 3 do
        v1 = if i ~= 1 then if i ~= 2 then v25 else v24 else v23
        v2 = if i ~= 1 then if i ~= 2 then v23 else v25 else v24
        v3 = v1 - Origin
        v4 = v3:Dot(Forward)
        v5 = (v2 - Origin):Dot(Forward)
        if v4 >= 0.05 then
            v22 = v22 + 1
            ClipX[v22] = v3:Dot(Right) / v4
            ClipY[v22] = v3:Dot(Up) / v4
            ClipW[v22] = 1 / v4
        end
        v7 = v5 >= 0.05
        if v6 ~= v7 then
            v7 = (0.05 - v4) / (v5 - v4)
            v8 = v3 + (v2 - v1) * v7
            v22 = v22 + 1
            ClipX[v22] = v8:Dot(Right) / 0.05
            ClipY[v22] = v8:Dot(Up) / 0.05
            ClipW[v22] = 20
        end
    end
    if v22 < 3 then
        return false
    end
    local v26 = ClipX[1]
    local v27 = ClipY[1]
    local v28 = ClipW[1]
    v1 = 2
    v2 = 3
    v3 = (ClipX[2] - v26) * (ClipY[3] - v27) - (ClipX[3] - v26) * (ClipY[2] - v27)
    if v22 == 4 then
        v4 = (ClipX[3] - v26) * (ClipY[4] - v27) - (ClipX[4] - v26) * (ClipY[3] - v27)
        v5 = math.abs(v4)
        if math.abs(v3) < v5 then
            v1 = 3
            v2 = 4
            v3 = v4
        end
    end
    if (math.abs(v3)) < 1e-12 then
        return false
    end
    v4 = ClipX[v1] - v26
    v5 = ClipY[v1] - v27
    v6 = ClipW[v1] - v28
    v7 = ClipX[v2] - v26
    v8 = ClipY[v2] - v27
    local v29 = ClipW[v2] - v28
    local v30 = (v6 * v8 - v29 * v5) / v3
    local v31 = (v4 * v29 - v7 * v6) / v3
    local v32 = v28 - v30 * v26 - v31 * v27
    local v33 = (1 / 0)
    local v34 = (-1 / 0)
    for j = 1, v22 do
        v33 = math.min(v33, ClipY[j])
        v34 = math.max(v34, ClipY[j])
    end
    local MinX = a1.MinX
    local MinY = a1.MinY
    local StepX = a1.StepX
    local StepY = a1.StepY
    local v35 = StepX * 0.0001
    local v36 = math.max(math.ceil((v33 - MinY) / StepY - 0.5), 0)
    local v37 = math.min(math.floor((v34 - MinY) / StepY - 0.5), 15)
    local Pending = a1.Pending
    local v38 = false
    for k = v36, v37 do
        v9 = Pending[k + 1]
        if v9 ~= 0 then
            v10 = MinY + (k + 0.5) * StepY
            v11 = (1 / 0)
            v12 = (-1 / 0)
            v13 = v22
            for n = 1, v13 do
                v16 = if n ~= v22 then n + 1 else 1
                v17 = ClipY[n]
                v18 = ClipY[v16]
                if not (v17 <= v10) then
                    if v18 <= v10 and v10 <= v17 then
                        v19 = ClipX[n]
                        v20 = ClipX[v16]
                        if v17 ~= v18 then
                            v21 = v19 + (v10 - v17) / (v18 - v17) * (v20 - v19)
                            v11 = math.min(v11, v21)
                            v12 = math.max(v12, v21)
                        else
                            v11 = math.min(v11, v19, v20)
                            v12 = math.max(v12, v19, v20)
                        end
                    end
                elseif v10 <= v18 or v18 <= v10 and v10 <= v17 then
                    v19 = ClipX[n]
                    v20 = ClipX[v16]
                    if v17 ~= v18 then
                        v21 = v19 + (v10 - v17) / (v18 - v17) * (v20 - v19)
                        v11 = math.min(v11, v21)
                        v12 = math.max(v12, v21)
                    else
                        v11 = math.min(v11, v19, v20)
                        v12 = math.max(v12, v19, v20)
                    end
                end
            end
            if not (v12 < v11) then
                v11 = v11 - v35
                v12 = v12 + v35
                v13 = 1 / (a1.RowDepth[k + 1] - 0.02)
                v14 = v31 * v10 + v32
                v15 = math.abs(v30)
                if not (v15 < 1e-12) then
                    if not (v30 > 0) then
                        v12 = math.min(v12, (v13 - v14) / v30)
                    else
                        v11 = math.max(v11, (v13 - v14) / v30)
                    end
                    v15 = math.max(math.ceil((v11 - MinX) / StepX - 0.5), 0)
                    v16 = math.min(math.floor((v12 - MinX) / StepX - 0.5), 15)
                    if not (v16 < v15) then
                        v17 = bit32.band(v9, (bit32.lshift(1, v16 + 1)) - (bit32.lshift(1, v15)))
                        if v17 ~= 0 then
                            v9 = v9 - v17
                            Pending[k + 1] = v9
                            if v9 == 0 then
                                a1.PendingRows = a1.PendingRows - 1
                            end
                            v38 = true
                        end
                    end
                elseif not (v14 <= v13) then
                    v15 = math.max(math.ceil((v11 - MinX) / StepX - 0.5), 0)
                    v16 = math.min(math.floor((v12 - MinX) / StepX - 0.5), 15)
                    if not (v16 < v15) then
                        v17 = bit32.band(v9, (bit32.lshift(1, v16 + 1)) - (bit32.lshift(1, v15)))
                        if v17 ~= 0 then
                            v9 = v9 - v17
                            Pending[k + 1] = v9
                            if v9 == 0 then
                                a1.PendingRows = a1.PendingRows - 1
                            end
                            v38 = true
                        end
                    end
                end
            end
        end
    end
    return v38
end

local function sameList(a1, a2) -- Line: 276 -- types: a1: table, a2: table
    if #a1 ~= #a2 then
        return false
    end
    for i, j in a1 do
        if a2[i] ~= j then
            return false
        end
    end
    return true
end

local function proved(a1, a2) -- Line: 288 -- types: a2: table?
    local Contributors = a1.Contributors
    if a2 ~= nil then
        local v1
        if #Contributors == #a2 then
            for i, j in Contributors do
                if a2[i] ~= j then
                    if false then
                        return true, a2
                    end
                    return true, table.clone(Contributors)
                end
            end
            v1 = true
        else
            v1 = false
        end
        if v1 then
            return true, a2
        end
    end
    return true, table.clone(Contributors)
end

function u5.new() -- Line: 296 -- upvalues: u5 (val), rasterTriangle (val)
    local v1 = {
        PendingRows = 0,
        Origin = Vector3.new(0, 0, 0),
        Forward = Vector3.new(0, 0, 0),
        Right = Vector3.new(0, 0, 0),
        Up = Vector3.new(0, 0, 0),
        MinX = 0,
        MinY = 0,
        StepX = 0,
        StepY = 0,
        MinNearest = 0,
        Pending = table.create(16, 0),
        RowDepth = table.create(16, 0),
        Contributors = table.create(96),
        Planes = table.create(4),
        ClipX = table.create(4),
        ClipY = table.create(4),
        ClipW = table.create(4),
    }
    local u26 = setmetatable(v1, u5)

    function u26.Visit(a1) -- Line: 319 -- upvalues: u26 (val), rasterTriangle (upval) -- types: a1: number
        local v1, v2, v3 = u26.Static:TriangleVertices(a1)
        if not rasterTriangle(u26, v1, v2, v3) then
            return false
        end
        local Contributors = u26.Contributors
        if #Contributors < 96 then
            Contributors[#Contributors + 1] = a1
        end
        return u26.PendingRows == 0
    end

    return u26
end

function u5.OriginCovered(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 334
    -- upvalues: projectFrame (val), fillWindow (val), rasterTriangle (val), proved (val), fillSilhouette (val)
    if a5 ~= 0 and projectFrame(a1, a3, a4, a5) then
        local v1, v2, v3, v4, v5, v6, v7
        local Contributors = a1.Contributors
        table.clear(Contributors)
        if a6 ~= nil and #a6 > 0 then
            fillWindow(a1)
            for i, j in a6 do
                v2, v3, v4 = a2:TriangleVertices(j)
                if rasterTriangle(a1, v2, v3, v4) then
                    Contributors[#Contributors + 1] = j
                    if a1.PendingRows == 0 then
                        return proved(a1, a6)
                    end
                end
            end
            table.clear(Contributors)
        end
        fillSilhouette(a1, a4, a5)
        for k = 1, 2 do
            v1 = if k ~= 1 then a8 else a6
            if v1 ~= nil then
                v2 = nil
                v3 = nil
                for n, m in v1, v2, v3 do
                    v5, v6, v7 = a2:TriangleVertices(m)
                    if rasterTriangle(a1, v5, v6, v7) then
                        if #Contributors < 96 then
                            Contributors[#Contributors + 1] = m
                        end
                        if a1.PendingRows == 0 then
                            return proved(a1, a6)
                        end
                    end
                end
            end
        end
        local v8 = 16
        v1 = -1
        local v9 = 0
        v2 = 0
        for i5 = 0, 15 do
            v5 = a1.Pending[i5 + 1]
            if v5 ~= 0 then
                v8 = math.min(v8, i5)
                v1 = i5
                v9 = bit32.bor(v9, v5)
                v2 = math.max(v2, a1.RowDepth[i5 + 1])
            end
        end
        v3 = bit32.countrz(v9)
        v4 = 31 - bit32.countlz(v9)
        local Forward = a1.Forward
        local Right = a1.Right
        local Up = a1.Up
        v7 = a1.MinX + a1.StepX * v3
        local v10 = a1.MinX + a1.StepX * (v4 + 1)
        local v11 = a1.MinY + a1.StepY * v8
        local v12 = a1.MinY + a1.StepY * (v1 + 1)
        local Planes = a1.Planes
        Planes[1] = Right - Forward * v7
        Planes[2] = Forward * v10 - Right
        Planes[3] = Up - Forward * v11
        Planes[4] = Forward * v12 - Up
        a1.Static = a2
        local v13, v14 = a2:VisitFrustumTriangles(a3, Planes, Forward, 0.05, v2, a1.Visit, 20000, a7)
        a1.Static = nil
        if v13 then
            return proved(a1, nil)
        end
        if not v14 then
            return nil, nil
        end
        return false, nil
    end
    return nil, nil
end

return table.freeze(u5)