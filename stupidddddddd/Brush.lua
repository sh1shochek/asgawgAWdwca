-- ReplicatedStorage.Visibility.PortalVis.Brush
-- Script path: ReplicatedStorage.Visibility.PortalVis.Brush
-- Decompile time: 4.25 ms

local Winding = require(script.Parent:WaitForChild("Winding"))
local u8 = {}

local function makeSide(a1, a2, a3, a4, a5, a6) -- Line: 13 -- upvalues: Winding (val)
    return {
        nx = a1,
        ny = a2,
        nz = a3,
        d = a4,
        w = a5,
        used = a6,
        key = Winding.planeKey(a1, a2, a3, a4),
    }
end

local function finish(a1) -- Line: 17 -- upvalues: Winding (val)
    local v1, v2, v3, v4, v5, v6
    local v7 = (1 / 0)
    local v8 = (1 / 0)
    local v9 = (1 / 0)
    local v10 = (-1 / 0)
    local v11 = (-1 / 0)
    local v12 = (-1 / 0)
    local v13 = {}
    local v14 = nil
    local v15 = nil
    local v16 = a1
    for i, j in a1.sides, v14, v15 do
        v1, v2, v3, v4, v5, v6 = Winding.bounds(j.w)
        if v1 < v7 then
            v7 = v1
        end
        if v2 < v8 then
            v8 = v2
        end
        if v3 < v9 then
            v9 = v3
        end
        if v10 < v4 then
            v10 = v4
        end
        if v11 < v5 then
            v11 = v5
        end
        if v12 < v6 then
            v12 = v6
        end
        v13[j.key] = true
    end
    v16.minX = v7
    v16.minY = v8
    v16.minZ = v9
    v16.maxX = v10
    v16.maxY = v11
    v16.maxZ = v12
    v16.keys = v13
    return v16
end

function u8.fromPlanes(a1, a2, a3, a4) -- Line: 50 -- upvalues: Winding (val), finish (val)
    local v1, v2, v3, v4, v5, v6, v7, v8
    local v9 = {}
    local v10 = nil
    local v11 = nil
    local v12, v13, v14 = a2, a3, a1
    for i, j in a1, v10, v11 do
        v1 = Winding.baseForPlane(j[1], j[2], j[3], j[4])
        v2 = v14
        v3 = nil
        for k, n in v2, nil, v3 do
            if k ~= i and v1 ~= nil then
                v1 = Winding.clip(v1, -n[1], -n[2], -n[3], -n[4], 0.02)
            end
        end
        if v1 ~= nil then
            v2 = #v1
            for m = 1, v2 do
                if 50000 < (math.abs(v1[m])) then
                    return nil
                end
            end
            v2 = #v9 + 1
            v3 = j[1]
            v4 = j[2]
            v5 = j[3]
            v6 = j[4]
            v7 = false
            if v8 ~= nil then
                v7 = v8[i] == true
            end
            v9[v2] = {
                nx = v3,
                ny = v4,
                nz = v5,
                d = v6,
                w = v1,
                used = v7,
                key = Winding.planeKey(v3, v4, v5, v6),
            }
        end
    end
    if #v9 < 4 then
        return nil
    end
    return (finish({id = v12, name = v13, sides = v9}))
end

function u8.planesFromMesh(a1, a2) -- Line: 76 -- upvalues: Winding (val)
    local v1, v2, v3, v4, v5, v6, v7, v8
    local v9 = 0
    local v10 = 0
    local v11 = 0
    for i, j in a1 do
        v9 = v9 + j[1]
        v10 = v10 + j[2]
        v11 = v11 + j[3]
    end
    v9 = v9 / #a1
    v10 = v10 / #a1
    v11 = v11 / #a1
    local v12 = {}
    local v13 = {}
    local v14 = nil
    local v15 = nil
    local v16 = a1
    for k, n in a2, v14, v15 do
        v1 = v16[n[1]]
        v2 = v16[n[2]]
        v3 = v16[n[3]]
        v4, v5, v6, v7 = Winding.planeFromPoints(v1[1], v1[2], v1[3], v2[1], v2[2], v2[3], v3[1], v3[2], v3[3])
        if v4 ~= nil then
            if 0 < v4 * v9 + v5 * v10 + v6 * v11 - v7 then
                v4 = -v4
                v5 = -v5
                v6 = -v6
                v7 = -v7
            end
            v8 = string.format("%.5f,%.5f,%.5f,%.3f", v4, v5, v6, v7)
            if not v13[v8] then
                v13[v8] = true
                v12[#v12 + 1] = {v4, v5, v6, v7}
            end
        end
    end
    return v12
end

function u8.range(a1, a2, a3, a4, a5) -- Line: 104 -- upvalues: Winding (val)
    local v1, v2
    local v3 = (1 / 0)
    local v4 = (-1 / 0)
    local sides = a1.sides
    local v5 = nil
    local v6 = nil
    local v7, v8, v9, v10 = a2, a3, a4, a5
    for i, j in sides, v5, v6 do
        v1, v2 = Winding.range(j.w, v7, v8, v9, v10)
        if v1 < v3 then
            v3 = v1
        end
        if v4 < v2 then
            v4 = v2
        end
    end
    return v3, v4
end

function u8.boxRange(a1, a2, a3, a4, a5) -- Line: 119
    local minX = if not (a2 > 0) then a1.maxX else a1.minX
    local v1 = minX * a2
    local minY = if not (a3 > 0) then a1.maxY else a1.minY
    local v2 = v1 + minY * a3
    local minZ = if not (a4 > 0) then a1.maxZ else a1.minZ
    local v3 = v2 + minZ * a4 - a5
    local maxX = if not (a2 > 0) then a1.minX else a1.maxX
    local v4 = maxX * a2
    local maxY = if not (a3 > 0) then a1.minY else a1.maxY
    v1 = v4 + maxY * a3
    local maxZ = if not (a4 > 0) then a1.minZ else a1.maxZ
    return v3, v1 + maxZ * a4 - a5
end

function u8.classify(a1, a2, a3, a4, a5) -- Line: 132 -- upvalues: u8 (val)
    local v1, v2 = u8.boxRange(a1, a2, a3, a4, a5)
    if v2 <= 0.05 then
        return "back"
    end
    if v1 >= -0.05 then
        return "front"
    end
    local v3, v4 = u8.range(a1, a2, a3, a4, a5)
    if v4 <= 0.05 then
        return "back"
    end
    if v3 >= -0.05 then
        return "front"
    end
    return "cross"
end

function u8.split(a1, a2, a3, a4, a5) -- Line: 149 -- upvalues: u8 (val)
    local v1
    local v2, v3 = u8.range(a1, a2, a3, a4, a5)
    if v3 < 0.05 then
        return nil, a1
    end
    if v2 > -0.05 then
        return a1, nil
    end
    local v4 = {}
    local v5 = {}
    for i, j in a1.sides do
        v1 = {j.nx, j.ny, j.nz, j.d}
        v4[i] = v1
        v5[i] = j.used
    end
    local v6 = #v4
    local v7 = v6 + 1
    v4[v7] = {-a2, -a3, -a4, -a5}
    v5[v6 + 1] = true
    v7 = u8.fromPlanes(v4, a1.id, a1.name, v5)
    v4[v6 + 1] = {a2, a3, a4, a5}
    local v8 = u8.fromPlanes(v4, a1.id, a1.name, v5)

    local function thin(a1) -- Line: 168
        local v1 = true
        if a1 ~= nil then
            v1 = true
            if not (a1.maxX - a1.minX < 0.05) then
                v1 = true
                if not (a1.maxY - a1.minY < 0.05) then
                    v1 = a1.maxZ - a1.minZ < 0.05
                end
            end
        end
        return v1
    end

    local v9 = true
    if v7 ~= nil then
        v9 = true
        if not (v7.maxX - v7.minX < 0.05) then
            v9 = true
            if not (v7.maxY - v7.minY < 0.05) then
                v9 = v7.maxZ - v7.minZ < 0.05
            end
        end
    end
    if v9 then
        v7 = nil
    end
    v9 = true
    if v8 ~= nil then
        v9 = true
        if not (v8.maxX - v8.minX < 0.05) then
            v9 = true
            if not (v8.maxY - v8.minY < 0.05) then
                v9 = v8.maxZ - v8.minZ < 0.05
            end
        end
    end
    if v9 then
        v8 = nil
    end
    return v7, v8
end

function u8.markUsed(a1, a2) -- Line: 184
    for i, j in a1.sides do
        if j.key == a2 then
            j.used = true
        end
    end
end

return u8