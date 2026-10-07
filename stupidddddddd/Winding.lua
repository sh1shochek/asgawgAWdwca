-- ReplicatedStorage.Visibility.PortalVis.Winding
-- Script path: ReplicatedStorage.Visibility.PortalVis.Winding
-- Decompile time: 9.63 ms

local u0 = {}

function u0.count(a1) -- Line: 9
    return #a1 // 3
end

function u0.baseForPlane(a1, a2, a3, a4) -- Line: 13
    local v1, v2, v3
    local v4 = math.abs(a1)
    local v5 = math.abs(a2)
    local v6 = math.abs(a3)
    if not (v4 <= v6) or not (v5 <= v6) then
        v1 = 0
        v2 = 0
        v3 = 1
    else
        v1 = 1
        v2 = 0
        v3 = 0
    end
    local v7 = v1 * a1 + v2 * a2 + v3 * a3
    v1 = v1 - a1 * v7
    v2 = v2 - a2 * v7
    v3 = v3 - a3 * v7
    local v8 = math.sqrt(v1 * v1 + v2 * v2 + v3 * v3)
    v1 = v1 / v8
    v2 = v2 / v8
    v3 = v3 / v8
    local v9 = a1 * a4
    local v10 = a2 * a4
    local v11 = a3 * a4
    local v12 = v2 * a3 - v3 * a2
    local v13 = v3 * a1 - v1 * a3
    local v14 = v1 * a2 - v2 * a1
    v1 = v1 * 100000
    v2 = v2 * 100000
    v3 = v3 * 100000
    v12 = v12 * 100000
    v13 = v13 * 100000
    v14 = v14 * 100000
    return {
        v9 - v12 + v1,
        v10 - v13 + v2,
        v11 - v14 + v3,
        v9 + v12 + v1,
        v10 + v13 + v2,
        v11 + v14 + v3,
        v9 + v12 - v1,
        v10 + v13 - v2,
        v11 + v14 - v3,
        v9 - v12 - v1,
        v10 - v13 - v2,
        v11 - v14 - v3,
    }
end

function u0.clip(a1, a2, a3, a4, a5, a6) -- Line: 47
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20
    local v21 = #a1 // 3
    local v22 = table.create(v21)
    local v23 = table.create(v21)
    local v24 = 0
    local v25 = 0
    local v26 = a6
    for i = 1, v21 do
        v1 = i * 3
        v2 = a1[v1 - 2] * a2 + a1[v1 - 1] * a3 + a1[v1] * a4 - a5
        v22[i] = v2
        if v26 < v2 then
            v23[i] = 1
            v24 = v24 + 1
        elseif not (v2 < -v26) then
            v23[i] = 0
        else
            v23[i] = -1
            v25 = v25 + 1
        end
    end
    if v24 == 0 then
        return nil
    end
    if v25 == 0 then
        return a1
    end
    local v27 = {}
    local v28 = 0
    for j = 1, v21 do
        v3 = j * 3
        v4 = a1[v3 - 2]
        v5 = a1[v3 - 1]
        v6 = a1[v3]
        v7 = v23[j]
        if v7 ~= 0 then
            if v7 == 1 then
                v8 = v28 + 1
                v9 = v28 + 2
                v10 = v28 + 3
                v27[v8] = v4
                v27[v9] = v5
                v27[v10] = v6
                v28 = v28 + 3
            end
            v8 = j % v21 + 1
            v9 = v23[v8]
            if v9 ~= 0 and v9 ~= v7 then
                v10 = v8 * 3
                v11 = a1[v10 - 2]
                v12 = a1[v10 - 1]
                v13 = a1[v10]
                v14 = v22[j] / (v22[j] - v22[v8])
                v15 = if a2 ~= 1 then if a2 ~= -1 then v4 + v14 * (v11 - v4) else -a5 else a5
                v16 = if a3 ~= 1 then if a3 ~= -1 then v5 + v14 * (v12 - v5) else -a5 else a5
                v17 = if a4 ~= 1 then if a4 ~= -1 then v6 + v14 * (v13 - v6) else -a5 else a5
                v18 = v28 + 1
                v19 = v28 + 2
                v20 = v28 + 3
                v27[v18] = v15
                v27[v19] = v16
                v27[v20] = v17
                v28 = v28 + 3
            end
        else
            v8 = v28 + 1
            v9 = v28 + 2
            v10 = v28 + 3
            v27[v8] = v4
            v27[v9] = v5
            v27[v10] = v6
            v28 = v28 + 3
        end
    end
    if v28 < 9 then
        return nil
    end
    return v27
end

function u0.split(a1, a2, a3, a4, a5, a6) -- Line: 107
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20
    local v21 = #a1 // 3
    local v22 = table.create(v21)
    local v23 = table.create(v21)
    local v24 = 0
    local v25 = 0
    local v26 = a6
    for i = 1, v21 do
        v1 = i * 3
        v2 = a1[v1 - 2] * a2 + a1[v1 - 1] * a3 + a1[v1] * a4 - a5
        v22[i] = v2
        if v26 < v2 then
            v23[i] = 1
            v24 = v24 + 1
        elseif not (v2 < -v26) then
            v23[i] = 0
        else
            v23[i] = -1
            v25 = v25 + 1
        end
    end
    if v24 == 0 then
        return nil, a1
    end
    if v25 == 0 then
        return a1, nil
    end
    local v27 = {}
    local v28 = {}
    for j = 1, v21 do
        v3 = j * 3
        v4 = a1[v3 - 2]
        v5 = a1[v3 - 1]
        v6 = a1[v3]
        v7 = v23[j]
        if v7 ~= 0 then
            if v7 ~= 1 then
                v8 = #v28 + 1
                v9 = #v28 + 2
                v10 = #v28 + 3
                v28[v8] = v4
                v28[v9] = v5
                v28[v10] = v6
            else
                v8 = #v27 + 1
                v9 = #v27 + 2
                v10 = #v27 + 3
                v27[v8] = v4
                v27[v9] = v5
                v27[v10] = v6
            end
            v8 = j % v21 + 1
            v9 = v23[v8]
            if v9 ~= 0 and v9 ~= v7 then
                v10 = v8 * 3
                v11 = a1[v10 - 2]
                v12 = a1[v10 - 1]
                v13 = a1[v10]
                v14 = v22[j] / (v22[j] - v22[v8])
                v15 = if a2 ~= 1 then if a2 ~= -1 then v4 + v14 * (v11 - v4) else -a5 else a5
                v16 = if a3 ~= 1 then if a3 ~= -1 then v5 + v14 * (v12 - v5) else -a5 else a5
                v17 = if a4 ~= 1 then if a4 ~= -1 then v6 + v14 * (v13 - v6) else -a5 else a5
                v18 = #v27 + 1
                v19 = #v27 + 2
                v20 = #v27 + 3
                v27[v18] = v15
                v27[v19] = v16
                v27[v20] = v17
                v18 = #v28 + 1
                v19 = #v28 + 2
                v20 = #v28 + 3
                v28[v18] = v15
                v28[v19] = v16
                v28[v20] = v17
            end
        else
            v8 = #v27 + 1
            v9 = #v27 + 2
            v10 = #v27 + 3
            v27[v8] = v4
            v27[v9] = v5
            v27[v10] = v6
            v8 = #v28 + 1
            v9 = #v28 + 2
            v10 = #v28 + 3
            v28[v8] = v4
            v28[v9] = v5
            v28[v10] = v6
        end
    end
    local v29 = if not (#v27 >= 9) then nil else v27
    if #v28 >= 9 then
        return v29, v28
    end
    return v29, nil
end

function u0.area(a1) -- Line: 164
    local v1, v2, v3, v4, v5, v6
    local v7 = #a1 // 3
    if v7 < 3 then
        return 0
    end
    local v8 = 0
    local v9 = 0
    local v10 = 0
    local v11 = a1[1]
    local v12 = a1[2]
    local v13 = a1[3]
    local v14 = v7 - 1
    for i = 2, v14 do
        v1 = a1[i * 3 - 2] - v11
        v2 = a1[i * 3 - 1] - v12
        v3 = a1[i * 3] - v13
        v4 = a1[i * 3 + 1] - v11
        v5 = a1[i * 3 + 2] - v12
        v6 = a1[i * 3 + 3] - v13
        v8 = v8 + (v2 * v6 - v3 * v5)
        v9 = v9 + (v3 * v4 - v1 * v6)
        v10 = v10 + (v1 * v5 - v2 * v4)
    end
    return math.sqrt(v8 * v8 + v9 * v9 + v10 * v10) * 0.5
end

function u0.contains(a1, a2, a3, a4, a5, a6) -- Line: 182 -- upvalues: u0 (val)
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16
    local v17 = #a1 // 3
    local v18, v19, v20, v21, v22, v23 = a1, a3, a4, a2, a5, a6
    for i = 1, v17 do
        v1 = i % v17 + 1
        v2 = v18[i * 3 - 2]
        v3 = v18[i * 3 - 1]
        v4 = v18[i * 3]
        v5 = v18[v1 * 3 - 2] - v2
        v6 = v18[v1 * 3 - 1] - v3
        v7 = v18[v1 * 3] - v4
        v8 = v19 * v7 - v20 * v6
        v9 = v20 * v5 - v21 * v7
        v10 = v21 * v6 - v19 * v5
        v11 = math.sqrt(v8 * v8 + v9 * v9 + v10 * v10)
        if not (v11 < 1e-09) then
            v8 = v8 / v11
            v9 = v9 / v11
            v10 = v10 / v11
            v12 = v8 * v2 + v9 * v3 + v10 * v4
            v13, v14, v15 = u0.center(v18)
            if v8 * v13 + v9 * v14 + v10 * v15 - v12 < 0 then
                v8 = -v8
                v9 = -v9
                v10 = -v10
                v12 = -v12
            end
            v16 = #v22
            for j = 1, v16, 3 do
                if v8 * v22[j] + v9 * v22[j + 1] + v10 * v22[j + 2] - v12 < -v23 then
                    return false
                end
            end
        end
    end
    return true
end

function u0.reverse(a1) -- Line: 210
    local v1, v2, v3, v4, v5, v6, v7
    local v8 = #a1 // 3
    local v9 = table.create(#a1)
    for i = 1, v8 do
        v4 = v8 + 1 - i
        v5 = i * 3 - 2
        v6 = i * 3 - 1
        v7 = i * 3
        v1 = a1[v4 * 3 - 2]
        v2 = a1[v4 * 3 - 1]
        v3 = a1[v4 * 3]
        v9[v5] = v1
        v9[v6] = v2
        v9[v7] = v3
    end
    return v9
end

function u0.range(a1, a2, a3, a4, a5) -- Line: 221
    local v1
    local v2 = (1 / 0)
    local v3 = (-1 / 0)
    local v4 = #a1
    local v5, v6, v7, v8, v9 = a1, a2, a3, a4, a5
    for i = 1, v4, 3 do
        v1 = v5[i] * v6 + v5[i + 1] * v7 + v5[i + 2] * v8 - v9
        if v1 < v2 then
            v2 = v1
        end
        if v3 < v1 then
            v3 = v1
        end
    end
    return v2, v3
end

function u0.center(a1) -- Line: 235
    local v1 = #a1 // 3
    local v2 = 0
    local v3 = 0
    local v4 = 0
    local v5 = #a1
    for i = 1, v5, 3 do
        v2 = v2 + a1[i]
        v3 = v3 + a1[i + 1]
        v4 = v4 + a1[i + 2]
    end
    return v2 / v1, v3 / v1, v4 / v1
end

function u0.bounds(a1) -- Line: 246
    local v1, v2, v3
    local v4 = (1 / 0)
    local v5 = (1 / 0)
    local v6 = (1 / 0)
    local v7 = (-1 / 0)
    local v8 = (-1 / 0)
    local v9 = (-1 / 0)
    local v10 = #a1
    local v11 = a1
    for i = 1, v10, 3 do
        v1 = v11[i]
        v2 = v11[i + 1]
        v3 = v11[i + 2]
        if v1 < v4 then
            v4 = v1
        end
        if v2 < v5 then
            v5 = v2
        end
        if v3 < v6 then
            v6 = v3
        end
        if v7 < v1 then
            v7 = v1
        end
        if v8 < v2 then
            v8 = v2
        end
        if v9 < v3 then
            v9 = v3
        end
    end
    return v4, v5, v6, v7, v8, v9
end

function u0.planeFromPoints(a1, a2, a3, a4, a5, a6, a7, a8, a9) -- Line: 274
    local v1 = a4 - a1
    local v2 = a5 - a2
    local v3 = a6 - a3
    local v4 = a7 - a1
    local v5 = a8 - a2
    local v6 = a9 - a3
    local v7 = v2 * v6 - v3 * v5
    local v8 = v3 * v4 - v1 * v6
    local v9 = v1 * v5 - v2 * v4
    local v10 = math.sqrt(v7 * v7 + v8 * v8 + v9 * v9)
    if v10 < 1e-06 then
        return nil
    end
    v7 = v7 / v10
    v8 = v8 / v10
    v9 = v9 / v10
    return v7, v8, v9, v7 * a1 + v8 * a2 + v9 * a3
end

function u0.planeKey(a1, a2, a3, a4) -- Line: 287
    local v1, v2, v3, v4
    local v5 = true
    if not (a1 < -1e-06) then
        v5 = false
        if (math.abs(a1)) <= 1e-06 then
            v5 = true
            if not (a2 < -1e-06) then
                v5 = false
                if (math.abs(a2)) <= 1e-06 then
                    v5 = a3 < 0
                end
            end
        end
    end
    if not v5 then
        v1, v2, v3, v4 = a1, a2, a3, a4
    else
        v1 = -a1
        v2 = -a2
        v3 = -a3
        v4 = -a4
    end
    return string.format("%.4f,%.4f,%.4f,%.2f", v1, v2, v3, v4)
end

function u0.isAxial(a1, a2, a3) -- Line: 295
    local v1 = true
    if not (0.9999 < (math.abs(a1))) then
        v1 = true
        if not (0.9999 < (math.abs(a2))) then
            v1 = 0.9999 < (math.abs(a3))
        end
    end
    return v1
end

return u0