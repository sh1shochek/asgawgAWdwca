-- ReplicatedStorage.Visibility.VisibilitySampling
-- Script path: ReplicatedStorage.Visibility.VisibilitySampling
-- Decompile time: 4.17 ms

local u0 = {}

local function quantize(a1, a2) -- Line: 9 -- types: a1: number, a2: number
    return (math.round(a1 / a2))
end

local function appendOrientedBox(a1, a2, a3, a4, a5, a6, a7, a8, a9) -- Line: 13
    -- upvalues: 
    local v1, v2, v3, v4, v5, v6, v7
    local v8, v9, v10 = a4, a8, a7
    for i = 0, 1 do
        v3 = if i ~= 1 then v8 * -v10 else v8 * v9
        for j = -1, 1, 2 do
            v1[#v1 + 1] = v2 + v3 + v4 * (v6 * j) + v5 * (v7 * -1)
            v1[#v1 + 1] = v2 + v3 + v4 * (v6 * j) + v5 * (v7 * 1)
        end
    end
end

u0.appendOrientedBox = appendOrientedBox

function u0.orientedBox(a1, a2, a3, a4, a5, a6) -- Line: 39
    -- upvalues: appendOrientedBox (val)
    local v1 = CFrame.Angles(0, a2, 0)
    local v2 = table.create(8)
    appendOrientedBox(v2, a1, v1.RightVector, Vector3.new(0, 1, 0), v1.LookVector, a3, a4, a5, a6)
    return v2
end

function u0.orientedPartBox(a1, a2, a3) -- Line: 64 -- types: a1: userdata, a2: vector, a3: number?
    local v1, v2, v3
    local v4 = math.max(a3 or 0, 0)
    local v5 = a2 * 0.5 + Vector3.new(1, 1, 1) * v4
    local v6 = table.create(8)
    local v7 = {-1, 1}
    local v8 = nil
    local v9 = nil
    for i, j in v7, v8, v9 do
        v1 = {-1, 1}
        v2 = nil
        v3 = nil
        for k, n in v1, v2, v3 do
            for m, i5 in {-1, 1} do
                v6[#v6 + 1] = (a1:PointToWorldSpace((Vector3.new(v5.X * j, v5.Y * n, v5.Z * i5))))
            end
        end
    end
    return v6
end

function u0.capsuleBox(a1, a2, a3) -- Line: 81 -- types: a1: vector, a2: vector, a3: number
    local v1, v2, v3, v4
    local v5 = a2 - a1
    local Magnitude = v5.Magnitude
    local Unit = v4:Cross(if not ((math.abs(((if not (Magnitude > 1e-05) then Vector3.new(0, 1, 0) else v5 / Magnitude):Dot((Vector3.new(0, 1, 0)))))) < 0.9) then Vector3.new(1, 0, 0) else Vector3.new(0, 1, 0)).Unit
    local Unit_2 = Unit:Cross(v4).Unit
    local v6 = math.max(a3, 0)
    local v7 = a1 - v4 * v6
    local v8 = a2 + v4 * v6
    local v9 = table.create(8)
    local v10 = {v7, v8}
    local v11 = nil
    local v12 = nil
    for i, j in v10, v11, v12 do
        v1 = {-1, 1}
        v2 = nil
        v3 = nil
        for k, n in v1, v2, v3 do
            for m, i5 in {-1, 1} do
                v9[#v9 + 1] = j + Unit * (v6 * n) + Unit_2 * (v6 * i5)
            end
        end
    end
    return v9
end

function u0.pointBoxes(a1, a2) -- Line: 102 -- types: a1: table, a2: number
    local v1, v2, v3, v4
    local v5 = Vector3.new(1, 1, 1) * math.max(a2, 0)
    local v6 = table.create(#a1)
    local v7 = nil
    local v8 = nil
    for i, j in a1, v7, v8 do
        v4 = j - v5
        v1 = j + v5
        v2 = table.create(8)
        for k = 0, 1 do
            for n = 0, 1 do
                for m = 0, 1 do
                    v3 = #v2 + 1
                    v2[v3] = (Vector3.new(if k ~= 0 then v1.X else v4.X, if n ~= 0 then v1.Y else v4.Y, if m ~= 0 then v1.Z else v4.Z))
                end
            end
        end
        v6[#v6 + 1] = v2
    end
    return v6
end

function u0.animatedCapsuleFallback(a1, a2, a3, a4, a5, a6, a7, a8, a9) -- Line: 126
    -- upvalues: u0 (val)
    local v1 = math.max(a8, 0)
    local v2 = math.max(a9 or 0, 0)
    local v3 = a4.X + a5 + v1
    local v4 = a4.Z + a5 + v1
    local v5 = {
        (u0.orientedBox(a1, a2, v3, a4.Y + v2 + v1, a4.Y + a6 + v1, v4)),
    }
    if a7 <= 0 then
        return v5
    end
    local LookVector = CFrame.Angles(0, a2, 0).LookVector
    local v6 = math.clamp(a3, -1, 1)
    local v7 = LookVector * math.sqrt((math.max(1 - v6 * v6, 0))) + Vector3.new(0, 1, 0) * v6
    local v8 = math.max(0.65, a4.X + a5) + v1
    local v9 = a4.Y * 0.25
    v9 = a1 + Vector3.new(0, 1, 0) * math.max(v9, 0.5) + LookVector * math.max(a4.Z * 0.5, 0.25)
    local v10 = v9 + v7 * (a4.Z + a5 + a7)
    v5[#v5 + 1] = (u0.capsuleBox(v9, v10, v8))
    return v5
end

function u0.fingerprint(a1, a2) -- Line: 168 -- types: a1: table, a2: number?
    local v1
    local v2 = a2 or 0.05
    if v2 <= 0 or v2 ~= v2 then
        v2 = 0.05
    end
    local v3 = table.create(#a1 + 1)
    v3[1] = (tostring(#a1))
    for i, j in a1 do
        v1 = i + 1
        v3[v1] = (("%*,%*,%*"):format(math.round(j.X / v2), math.round(j.Y / v2), (math.round(j.Z / v2))))
    end
    return table.concat(v3, ";")
end

function u0.orientedBodyFallback(a1, a2, a3, a4, a5, a6, a7) -- Line: 182
    -- upvalues: appendOrientedBox (val)
    local v1 = CFrame.Angles(0, a2, 0)
    local RightVector = v1.RightVector
    local LookVector = v1.LookVector
    local v2 = a3.X + a4
    local v3 = a3.Z + a4
    local v4 = a3.Y + math.max(a7 or 0, 0)
    local v5 = a3.Y + a5
    local v6 = {}
    appendOrientedBox(v6, a1, RightVector, Vector3.new(0, 1, 0), LookVector, v2, v4, v5, v3)
    local v7 = #v6 + 1
    local v8 = a1 + LookVector * (v3 + a6)
    local v9 = a3.Y * 0.35
    v6[v7] = v8 + Vector3.new(0, 1, 0) * math.max(v9, 0.5)
    return v6
end

return table.freeze(u0)