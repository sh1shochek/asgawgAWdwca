-- ReplicatedStorage.Visibility.OcclusionMath
-- Script path: ReplicatedStorage.Visibility.OcclusionMath
-- Decompile time: 5.41 ms

local u0 = {}

local function finite(a1) -- Line: 15 -- types: a1: number
    local v1 = false
    if a1 == a1 then
        v1 = false
        if a1 > (-1 / 0) then
            v1 = a1 < (1 / 0)
        end
    end
    return v1
end

function u0.isFiniteVector(a1) -- Line: 19
    local v1 = false
    if typeof(a1) == "Vector3" then
        local X = a1.X
        v1 = false
        if X == X then
            v1 = false
            if X > (-1 / 0) then
                v1 = X < (1 / 0)
            end
        end
        if v1 then
            local Y = a1.Y
            v1 = false
            if Y == Y then
                v1 = false
                if Y > (-1 / 0) then
                    v1 = Y < (1 / 0)
                end
            end
            if v1 then
                local Z = a1.Z
                v1 = false
                if Z == Z then
                    v1 = false
                    if Z > (-1 / 0) then
                        v1 = Z < (1 / 0)
                    end
                end
            end
        end
    end
    return v1
end

local function clipAxis(a1, a2, a3, a4, a5, a6) -- Line: 23
    -- upvalues: 
    if (math.abs(a2)) <= 1e-09 then
        if not (a1 < a3) and not (a4 < a1) then
            return a5, a6
        end
        return nil, nil
    end
    local v1 = 1 / a2
    local v2 = (a3 - a1) * v1
    local v3 = (a4 - a1) * v1
    if v3 < v2 then
        local v4 = v3
        v3 = v2
        v2 = v4
    end
    local v5 = math.max(a5, v2)
    local v6 = math.min(a6, v3)
    if v6 < v5 then
        return nil, nil
    end
    return v5, v6
end

function u0.segmentAABBInterval(a1, a2, a3, a4) -- Line: 52
    -- upvalues: u0 (val), clipAxis (val)
    if u0.isFiniteVector(a1)
        and u0.isFiniteVector(a2)
        and u0.isFiniteVector(a3)
        and u0.isFiniteVector(a4)
        and not (a4.X < a3.X)
        and not (a4.Y < a3.Y)
        and not (a4.Z < a3.Z) then
        local v1, v2, v3, v4, v5
        local v6 = a2 - a1
        local X_2 = a1.X
        local X_3 = v6.X
        local X_4 = a3.X
        local X_5 = a4.X
        local v7 = 0
        local v8 = 1
        local v9 = math.abs(X_3)
        if not (v9 <= 1e-09) then
            v9 = 1 / X_3
            v1 = (X_4 - X_2) * v9
            v2 = (X_5 - X_2) * v9
            if v2 < v1 then
                v3 = v2
                v2 = v1
                v1 = v3
            end
            v7 = math.max(v7, v1)
            v8 = math.min(v8, v2)
            if not (v8 < v7) then
                v4 = v7
                v5 = v8
            else
                v4 = nil
                v5 = nil
            end
        elseif X_2 < X_4 then
            v4 = nil
            v5 = nil
        elseif not (X_5 < X_2) then
            v4 = v7
            v5 = v8
        else
            v4 = nil
            v5 = nil
        end
        if v4 ~= nil and v5 ~= nil then
            local v10, v11
            local Y_2 = a1.Y
            local Y_3 = v6.Y
            local Y_4 = a3.Y
            local Y_5 = a4.Y
            v9 = v4
            v1 = v5
            v2 = math.abs(Y_3)
            if not (v2 <= 1e-09) then
                v2 = 1 / Y_3
                v3 = (Y_4 - Y_2) * v2
                local v12 = (Y_5 - Y_2) * v2
                if v12 < v3 then
                    local v13 = v12
                    v12 = v3
                    v3 = v13
                end
                v9 = math.max(v9, v3)
                v1 = math.min(v1, v12)
                if not (v1 < v9) then
                    v10 = v9
                    v11 = v1
                else
                    v10 = nil
                    v11 = nil
                end
            elseif Y_2 < Y_4 then
                v10 = nil
                v11 = nil
            elseif not (Y_5 < Y_2) then
                v10 = v9
                v11 = v1
            else
                v10 = nil
                v11 = nil
            end
            v4 = v10
            v5 = v11
            if v4 ~= nil and v5 ~= nil then
                return clipAxis(a1.Z, v6.Z, a3.Z, a4.Z, v4, v5)
            end
            return nil, nil
        end
        return nil, nil
    end
    return nil, nil
end

function u0.segmentSphereInterval(a1, a2, a3, a4) -- Line: 82
    -- upvalues: u0 (val)
    if u0.isFiniteVector(a1) and u0.isFiniteVector(a2) and u0.isFiniteVector(a3) then
        local v1 = false
        if a4 == a4 then
            v1 = false
            if a4 > (-1 / 0) then
                v1 = a4 < (1 / 0)
            end
        end
        if v1 and not (a4 <= 0) then
            v1 = a2 - a1
            local v2 = v1:Dot(v1)
            if v2 <= 1e-06 then
                if (a1 - a3).Magnitude <= a4 then
                    return 0, 1
                end
                return nil, nil
            end
            local v3 = a1 - a3
            local v4 = 2 * v3:Dot(v1)
            local v5 = (v3:Dot(v3)) - a4 * a4
            local v6 = v4 * v4 - 4 * v2 * v5
            if v6 < 0 then
                return nil, nil
            end
            local v7 = math.sqrt(v6)
            local v8 = (-v4 - v7) / (2 * v2)
            local v9 = (-v4 + v7) / (2 * v2)
            local v10 = math.max(0, (math.min(v8, v9)))
            local v11 = math.min(1, (math.max(v8, v9)))
            if v11 < v10 then
                return nil, nil
            end
            return v10, v11
        end
    end
    return nil, nil
end

local function mergedIntervals(a1) -- Line: 125 -- types: a1: table
    local v1, v2, v3, v4
    local v5 = {}
    local v6 = nil
    local v7 = nil
    for i, j in a1, v6, v7 do
        v2 = math.clamp(j.minimum, 0, 1)
        v3 = math.clamp(j.maximum, 0, 1)
        v4 = false
        if v2 == v2 then
            v4 = false
            if v2 > (-1 / 0) then
                v4 = v2 < (1 / 0)
            end
        end
        if v4 then
            v4 = false
            if v3 == v3 then
                v4 = false
                if v3 > (-1 / 0) then
                    v4 = v3 < (1 / 0)
                end
            end
            if v4 and v2 < v3 then
                v5[#v5 + 1] = {minimum = v2, maximum = v3}
            end
        end
    end
    if #v5 <= 1 then
        return v5
    end
    table.sort(v5, function(a1, a2) -- Line: 137
        if a1.minimum == a2.minimum then
            return a1.maximum < a2.maximum
        end
        return a1.minimum < a2.minimum
    end)
    local v8 = {v5[1]}
    v6 = #v5
    for k = 2, v6 do
        v1 = v5[k]
        v2 = v8[#v8]
        if not (v1.minimum <= v2.maximum + 1e-06) then
            v8[#v8 + 1] = v1
        else
            v2.maximum = math.max(v2.maximum, v1.maximum)
        end
    end
    return v8
end

function u0.uncoveredUnionLength(a1, a2) -- Line: 158 -- upvalues: mergedIntervals (val) -- types: a1: table, a2: table
    local minimum, v1, v2, v3
    local v4 = mergedIntervals(a1)
    if #v4 == 0 then
        return 0
    end
    local v5 = mergedIntervals(a2)
    if #v5 == 0 then
        v3 = 0
        for k, n in v4 do
            v3 = v3 + (n.maximum - n.minimum)
        end
        return v3
    end
    v3 = 0
    local v6 = 1
    local v7 = nil
    local v8 = nil
    for i, j in v4, v7, v8 do
        minimum = j.minimum
        while v6 <= #v5 do
            if not (v5[v6].maximum <= minimum) then
                break
            end
            v6 = v6 + 1
        end
        v1 = v6
        while v1 <= #v5 do
            if not (v5[v1].minimum < j.maximum) then
                break
            end
            v2 = v5[v1]
            if minimum < v2.minimum then
                v3 = v3 + (math.min(v2.minimum, j.maximum) - minimum)
            end
            minimum = math.max(minimum, v2.maximum)
            if j.maximum <= minimum then
                break
            end
            v1 = v1 + 1
        end
        if minimum < j.maximum then
            v3 = v3 + (j.maximum - minimum)
        end
    end
    return (math.max(v3, 0))
end

return table.freeze(u0)