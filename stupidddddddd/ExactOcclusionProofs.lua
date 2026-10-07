-- ReplicatedStorage.Visibility.ExactOcclusionProofs
-- Script path: ReplicatedStorage.Visibility.ExactOcclusionProofs
-- Decompile time: 13.82 ms

local u0 = {}
u0.__index = u0

local function validBounds(a1) -- Line: 12 -- types: a1: table
    if #a1 ~= 6 then
        return false
    end
    for i = 1, 6 do
        if a1[i] == a1[i] and math.abs(a1[i]) ~= (1 / 0) then
            continue
        end
        return false
    end
    local v1 = false
    if a1[1] <= a1[4] then
        v1 = false
        if a1[2] <= a1[5] then
            v1 = a1[3] <= a1[6]
        end
    end
    return v1
end

local function checksum(a1, a2, a3) -- Line: 26 -- types: a1: buffer, a2: number, a3: function?
    local v1 = 5381
    local v2 = buffer.len(a1) - 1
    local v3 = a3
    for i = a2, v2 do
        if v3 and i % 4096 == 0 then
            v3()
        end
        v1 = (v1 * 33 + buffer.readu8(v4, i)) % 4294967296
    end
    return v1
end

local function triangle(a1, a2) -- Line: 36 -- types: a2: number
    local buffer_2, buffer_3, buffer_4, buffer_5, v1, v2, v3, v4, v5, v6, v7
    local v8 = false
    if a2 >= 1 then
        v8 = a2 <= a1.triangleCount
    end
    assert(v8, "invalid proof triangle")
    local v9 = {}
    for i = 0, 2 do
        buffer_2 = a1.buffer
        v6 = a1.triangleOffset + (a2 - 1) * 12 + i * 4
        v5 = a1.vertexOffset + ((buffer.readu32(buffer_2, v6)) - 1) * 12
        v6 = i + 1
        v7 = {}
        buffer_3 = a1.buffer
        v1 = buffer.readf32(buffer_3, v5)
        buffer_4 = a1.buffer
        v3 = v5 + 4
        v2 = buffer.readf32(buffer_4, v3)
        buffer_5 = a1.buffer
        v4 = v5 + 8
        v7[1] = v1
        v7[2] = v2
        v7[3] = (buffer.readf32(buffer_5, v4))
        v9[v6] = v7
    end
    return v9
end

local function half(a1) -- Line: 47 -- types: a1: table
    local v1, v2, v3, v4, v5, v6, v7, v8, v9
    local v10 = a1
    for i = 1, 3 do
        v4 = v10[1][i]
        if v4 == v10[2][i] then
            v4 = v10[1][i]
            if v4 == v10[3][i] then
                v4 = i % 3 + 1
                v5 = (i + 1) % 3 + 1
                v6 = (1 / 0)
                v7 = (-1 / 0)
                v8 = (1 / 0)
                v9 = (-1 / 0)
                v1 = v10
                v2 = nil
                for j, k in v1, nil, v2 do
                    v6 = math.min(v6, k[v4])
                    v7 = math.max(v7, k[v4])
                    v8 = math.min(v8, k[v5])
                    v9 = math.max(v9, k[v5])
                end
                if not (v7 <= v6) and not (v9 <= v8) then
                    v1 = 0
                    v2 = nil
                    v3 = nil
                    for n, m in v10, v2, v3 do
                        if m[v4] ~= v6 and m[v4] ~= v7 then
                            return nil, nil
                        end
                        if m[v5] ~= v8 and m[v5] ~= v9 then
                            return nil, nil
                        end
                        v1 = bit32.bor(v1, (bit32.lshift(1, (if m[v4] ~= v7 then 0 else 1) + (if m[v5] ~= v9 then 0 else 2))))
                    end
                    for i5 = 0, 3 do
                        if v1 == 15 - bit32.lshift(1, i5) then
                            return {
                                axis = i,
                                d = v10[1][i],
                                u0 = v6,
                                u1 = v7,
                                v0 = v8,
                                v1 = v9,
                            }, i5
                        end
                    end
                end
            end
        end
    end
    return nil, nil
end

local function same(a1, a2) -- Line: 76 -- types: a1: table, a2: table
    local v1 = false
    if a1.axis == a2.axis then
        v1 = false
        if a1.d == a2.d then
            v1 = false
            if a1.u0 == a2.u0 then
                v1 = false
                if a1.u1 == a2.u1 then
                    v1 = false
                    if a1.v0 == a2.v0 then
                        v1 = a1.v1 == a2.v1
                    end
                end
            end
        end
    end
    return v1
end

local function join(a1, a2) -- Line: 79 -- types: a1: table, a2: table
    local v1 = false
    if a1.axis == a2.axis then
        v1 = a1.d == a2.d
    end
    assert(v1, "noncoplanar proof merge")
    local v2 = false
    if a1.v0 == a2.v0 then
        v2 = false
        if a1.v1 == a2.v1 then
            v2 = false
            if a2.u0 <= a1.u1 then
                v2 = a1.u0 <= a2.u1
            end
        end
    end
    v1 = false
    if a1.u0 == a2.u0 then
        v1 = false
        if a1.u1 == a2.u1 then
            v1 = false
            if a2.v0 <= a1.v1 then
                v1 = a1.v0 <= a2.v1
            end
        end
    end
    assert(v2 or v1, "proof merge crosses a gap or nonrectangular union")
    return {
        axis = a1.axis,
        d = a1.d,
        u0 = math.min(a1.u0, a2.u0),
        u1 = math.max(a1.u1, a2.u1),
        v0 = math.min(a1.v0, a2.v0),
        v1 = math.max(a1.v1, a2.v1),
    }
end

function u0.new(a1, a2, a3) -- Line: 94
    -- upvalues: checksum (val), half (val), triangle (val), join (val), u0 (val)
    local v1, v2, v3, v4, v5, v6, v7, v8, v9
    assert(a2.version == 3, "proofs require indexed exact geometry")
    local v10 = buffer.fromstring(a1)
    local v11 = false
    if 40 <= (buffer.len(v10)) then
        v11 = false
        if (buffer.len(v10)) <= 8388608 then
            v11 = buffer.readstring(v10, 0, 8) == "PVSPRF1\000"
        end
    end
    assert(v11, "invalid proof header")
    assert(buffer.readu32(v10, 8) == 1, "unsupported proof version")
    v11 = false
    local v12 = buffer.readu32(v10, 12)
    local buffer_2 = a2.buffer
    if v12 == buffer.readu32(buffer_2, 40) then
        v11 = (buffer.readu32(v10, 16)) == a2.triangleCount
    end
    assert(v11, "proof geometry mismatch")
    local v13 = buffer.readu32(v10, 20)
    v11 = buffer.readu32(v10, 24)
    v12 = buffer.readu32(v10, 28)
    local v14 = buffer.readu32(v10, 32)
    local v15 = false
    if v13 >= 1 then
        v15 = false
        if v13 <= 512 then
            v15 = false
            if v11 >= 1 then
                v15 = false
                if v11 + v12 <= 400000 then
                    v15 = v14 <= v11
                end
            end
        end
    end
    assert(v15, "proof limits")
    assert((buffer.len(v10)) == v13 + 40 + (v11 + v12) * 8 + v14 * 4, "proof length mismatch")
    assert((buffer.readstring(v10, 40, v13)) == a2.fingerprint, "proof fingerprint mismatch")
    assert((checksum(v10, 40, a3)) == buffer.readu32(v10, 36), "proof checksum mismatch")
    local v16 = table.create(v11 + v12)
    v15 = v13 + 40
    local v17 = a3
    for i = 1, v11 do
        if v17 and i % 128 == 0 then
            v17()
        end
        v2, v3 = half((triangle(v1, (buffer.readu32(v10, v15)))))
        v4 = half
        v5 = triangle
        v9 = v15 + 4
        v4, v5 = v4((v5(v1, (buffer.readu32(v10, v9)))))
        v7 = v2
        if v7 then
            v7 = v4
            if v7 then
                v7 = v3
                if v7 then
                    v7 = v5
                    if v7 then
                        v7 = false
                        if v2.axis == v4.axis then
                            v7 = false
                            if v2.d == v4.d then
                                v7 = false
                                if v2.u0 == v4.u0 then
                                    v7 = false
                                    if v2.u1 == v4.u1 then
                                        v7 = false
                                        if v2.v0 == v4.v0 then
                                            v7 = v2.v1 == v4.v1
                                        end
                                    end
                                end
                            end
                        end
                        if v7 then
                            v7 = bit32.bxor(v3, v5) == 3
                        end
                    end
                end
            end
        end
        assert(v7, "invalid rectangle triangle witnesses")
        v16[i] = v2
        v15 = v15 + 8
    end
    local v18 = v11 + 1
    local v19 = v11 + v12
    for j = v18, v19 do
        if v17 and j % 512 == 0 then
            v17()
        end
        v2 = buffer.readu32(v10, v15)
        v5 = v15 + 4
        v3 = buffer.readu32(v10, v5)
        v5 = false
        if v2 >= 1 then
            v5 = false
            if v2 < j then
                v5 = false
                if v3 >= 1 then
                    v5 = false
                    if v3 < j then
                        v5 = v2 ~= v3
                    end
                end
            end
        end
        assert(v5, "invalid proof DAG reference")
        v16[j] = (join(v16[v2], v16[v3]))
        v15 = v15 + 8
    end
    v19 = {}
    local v20 = {{}, {}, {}}
    v18 = {{}, {}, {}}
    v2 = {}
    for k = 1, v14 do
        v6 = buffer.readu32(v10, v15)
        v15 = v15 + 4
        v8 = false
        if v6 >= 1 then
            v8 = false
            if v6 <= #v16 then
                v8 = not v2[v6]
            end
        end
        assert(v8, "invalid proof root")
        v2[v6] = true
        v7 = v16[v6]
        v8 = v20[v7.axis][v7.d]
        if not v8 then
            v8 = {
                axis = v7.axis,
                d = v7.d,
                rects = {},
                id = #v19 + 1,
                u0 = v7.u0,
                u1 = v7.u1,
                v0 = v7.v0,
                v1 = v7.v1,
            }
            v19[#v19 + 1] = v8
            v9 = v20[v7.axis]
            v9[v7.d] = v8
            table.insert(v18[v7.axis], v8)
        end
        v8.rects[#v8.rects + 1] = v7
        v8.u0 = math.min(v8.u0, v7.u0)
        v8.u1 = math.max(v8.u1, v7.u1)
        v8.v0 = math.min(v8.v0, v7.v0)
        v8.v1 = math.max(v8.v1, v7.v1)
    end
    for n, m in v19 do
        table.sort(m.rects, function(a1, a2) -- Line: 157
            local v1 = (a1.u1 - a1.u0) * (a1.v1 - a1.v0)
            return (a2.u1 - a2.u0) * (a2.v1 - a2.v0) < v1
        end)
    end
    for i5, i6 in v18 do
        table.sort(i6, function(a1, a2) -- Line: 162
            return a1.d < a2.d
        end)
    end
    return (setmetatable({
        Tests = 0,
        Hits = 0,
        Data = v1,
        Planes = v19,
        ByAxis = v20,
        Sorted = v18,
        PatchCount = v14,
        HintIds = {},
        Hints = {},
    }, u0))
end

local function footprint(a1, a2, a3) -- Line: 179 -- types: a1: table, a2: table, a3: table
    local v1, v2, v3, v4, v5, v6, v7
    local axis = a1.axis
    local d = a1.d
    local v8 = a2[axis + 3]
    if v8 < d - 0.02 then
        v8 = a3[axis]
        if d + 0.02 < v8 then
            v8 = math.abs(a2[axis] - d)
            v4 = math.abs(a2[axis + 3] - d)
            v5 = math.abs(a3[axis] - d)
            v6 = math.abs(a3[axis + 3] - d)
            v7 = (math.min(v8, v4)) / ((math.min(v8, v4)) + math.max(v5, v6))
            v1 = (math.max(v8, v4)) / ((math.max(v8, v4)) + math.min(v5, v6))
            v2 = axis % 3 + 1
            v3 = (axis + 1) % 3 + 1
            return math.min(a2[v2] + (a3[v2] - a2[v2]) * v7, a2[v2] + (a3[v2] - a2[v2]) * v1) - 0.02, math.max(a2[v2 + 3] + (a3[v2 + 3] - a2[v2 + 3]) * v7, a2[v2 + 3] + (a3[v2 + 3] - a2[v2 + 3]) * v1) + 0.02, math.min(a2[v3] + (a3[v3] - a2[v3]) * v7, a2[v3] + (a3[v3] - a2[v3]) * v1) - 0.02, math.max(a2[v3 + 3] + (a3[v3 + 3] - a2[v3 + 3]) * v7, a2[v3 + 3] + (a3[v3 + 3] - a2[v3 + 3]) * v1) + 0.02
        end
    end
    v8 = a3[axis + 3]
    if v8 < d - 0.02 then
        v8 = a2[axis]
        if d + 0.02 < v8 then
            v8 = math.abs(a2[axis] - d)
            v4 = math.abs(a2[axis + 3] - d)
            v5 = math.abs(a3[axis] - d)
            v6 = math.abs(a3[axis + 3] - d)
            v7 = (math.min(v8, v4)) / ((math.min(v8, v4)) + math.max(v5, v6))
            v1 = (math.max(v8, v4)) / ((math.max(v8, v4)) + math.min(v5, v6))
            v2 = axis % 3 + 1
            v3 = (axis + 1) % 3 + 1
            return math.min(a2[v2] + (a3[v2] - a2[v2]) * v7, a2[v2] + (a3[v2] - a2[v2]) * v1) - 0.02, math.max(a2[v2 + 3] + (a3[v2 + 3] - a2[v2 + 3]) * v7, a2[v2 + 3] + (a3[v2 + 3] - a2[v2 + 3]) * v1) + 0.02, math.min(a2[v3] + (a3[v3] - a2[v3]) * v7, a2[v3] + (a3[v3] - a2[v3]) * v1) - 0.02, math.max(a2[v3 + 3] + (a3[v3 + 3] - a2[v3 + 3]) * v7, a2[v3 + 3] + (a3[v3 + 3] - a2[v3 + 3]) * v1) + 0.02
        end
    end
    return nil, nil, nil, nil
end

function u0:Covers(a2, a3, a4, a5) -- Line: 197
    -- upvalues: validBounds (val), footprint (val)
    if validBounds(a3) and validBounds(a4) then
        local v1 = self.Planes[a2]
        if not v1 then
            return false
        end
        self.Tests = self.Tests + 1
        local v2, v3, v4, v5 = footprint(v1, a3, a4)
        if v2 ~= nil
            and v3 ~= nil
            and v4 ~= nil
            and v5 ~= nil
            and not (v2 < v1.u0)
            and not (v1.u1 < v3)
            and not (v4 < v1.v0)
            and not (v1.v1 < v5) then
            local v6, v7, v8, v9, v10, v11, v12, v13
            local v14 = {{v2, v3, v4, v5}}
            local v15 = nil
            local v16 = nil
            local v17 = a5
            for i, j in v1.rects, v15, v16 do
                if v17 and i % 16 == 1 and v17 <= os.clock() then
                    return false
                end
                if i > 128 then
                    return false
                end
                if not (j.u1 < v2) and not (v3 < j.u0) and not (j.v1 < v4) and not (v5 < j.v0) then
                    if j.u0 <= v2 and v3 <= j.u1 and j.v0 <= v4 and v5 <= j.v1 then
                        v6.Hits = v6.Hits + 1
                        return true
                    end
                    v7 = {}
                    v8 = nil
                    v9 = nil
                    for k, n in v14, v8, v9 do
                        v10 = math.max(n[1], j.u0)
                        v11 = math.min(n[2], j.u1)
                        v12 = math.max(n[3], j.v0)
                        v13 = math.min(n[4], j.v1)
                        if v11 <= v10 then
                            v7[#v7 + 1] = n
                        elseif not (v13 <= v12) then
                            if n[1] < v10 then
                                v7[#v7 + 1] = {n[1], v10, n[3], n[4]}
                            end
                            if v11 < n[2] then
                                v7[#v7 + 1] = {v11, n[2], n[3], n[4]}
                            end
                            if n[3] < v12 then
                                v7[#v7 + 1] = {v10, v11, n[3], v12}
                            end
                            if v13 < n[4] then
                                v7[#v7 + 1] = {v10, v11, v13, n[4]}
                            end
                        else
                            v7[#v7 + 1] = n
                        end
                        if #v7 > 32 then
                            return false
                        end
                    end
                    if #v7 == 0 then
                        v6.Hits = v6.Hits + 1
                        return true
                    end
                end
            end
            return false
        end
        return false
    end
    return false
end

function u0:PlaneForTriangle(a2) -- Line: 258 -- upvalues: triangle (val) -- types: a2: number
    local v1
    local v2 = (a2 - 1) % 2048 + 1
    if self.HintIds[v2] == a2 then
        if self.Hints[v2] == 0 then
            return nil
        end
        return self.Hints[v2]
    end
    local v3 = triangle(self.Data, a2)
    local id = nil
    for i = 1, 3 do
        v1 = v3[1][i]
        if v1 == v3[2][i] then
            v1 = v3[1][i]
            if v1 == v3[3][i] then
                v1 = self.ByAxis[i][v3[1][i]]
                if v1 then
                    id = v1.id
                    break
                end
            end
        end
    end
    self.HintIds[v2] = a2
    self.Hints[v2] = id or 0
    return id
end

function u0.Search(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 278
    -- upvalues: 
    local id, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
    local u105 = {}
    if a6 then
        u105[a6] = true
        if a8 then
            a8[#a8 + 1] = a6
        end
    end
    local u50 = 0

    local function test(a1_2) -- Line: 296
        -- upvalues: a7 (val), u105 (val), a8 (val), u50 (ref), a1 (val), a2 (val), a3 (val)
        if a7 and a7 <= (os.clock()) then
            return false
        end
        if u105[a1_2] then
            return false
        end
        u105[a1_2] = true
        if a8 then
            a8[#a8 + 1] = a1_2
        end
        u50 = u50 + 1
        return a1:Covers(a1_2, a2, a3, a7)
    end

    for i = a5, 1, -1 do
        v1 = a1:PlaneForTriangle(a4[i])
        if v1 then
            if not a7 then
                if not u105[v1] then
                    u105[v1] = true
                    if a8 then
                        a8[#a8 + 1] = v1
                    end
                    u50 = u50 + 1
                    v2 = a1:Covers(v1, a2, a3, a7)
                else
                    v2 = false
                end
            elseif a7 <= os.clock() then
                v2 = false
            elseif not u105[v1] then
                u105[v1] = true
                if a8 then
                    a8[#a8 + 1] = v1
                end
                u50 = u50 + 1
                v2 = a1:Covers(v1, a2, a3, a7)
            else
                v2 = false
            end
            if v2 then
                return v1
            end
        end
    end
    for j = 1, 3 do
        v1 = math.min(a2[j + 3], a3[j + 3]) + 0.02
        v2 = math.max(a2[j], a3[j]) - 0.02
        if not (v2 <= v1) then
            v3 = a1.Sorted[j]
            v4 = 1
            v5 = #v3 + 1
            v6 = (v1 + v2) * 0.5
            while v4 < v5 do
                v7 = (v4 + v5) // 2
                if not (v3[v7].d < v6) then
                    v5 = v7
                else
                    v4 = v7 + 1
                end
            end
            v7 = v4 - 1
            v8 = v4
            for k = 1, 16 do
                if u50 >= 24 then
                    return nil
                end
                v9 = if k % 2 ~= 1 then v7 else v8
                if k % 2 ~= 1 then
                    v7 = v7 - 1
                else
                    v8 = v8 + 1
                end
                v10 = v3[v9]
                if v10 and v1 < v10.d and v10.d < v2 then
                    id = v10.id
                    if not a7 then
                        if not u105[id] then
                            u105[id] = true
                            if a8 then
                                a8[#a8 + 1] = id
                            end
                            u50 = u50 + 1
                            v11 = a1:Covers(id, a2, a3, a7)
                        else
                            v11 = false
                        end
                    elseif a7 <= os.clock() then
                        v11 = false
                    elseif not u105[id] then
                        u105[id] = true
                        if a8 then
                            a8[#a8 + 1] = id
                        end
                        u50 = u50 + 1
                        v11 = a1:Covers(id, a2, a3, a7)
                    else
                        v11 = false
                    end
                    if v11 then
                        return v10.id
                    end
                end
            end
        end
    end
    return nil
end

function u0.CoversOrigin(a1, a2, a3, a4, a5, a6) -- Line: 353
    -- upvalues: 
    local v1
    local v2 = {a2.X, a2.Y, a2.Z, a2.X, a2.Y, a2.Z}
    if a5 and a1:Covers(a5, v2, a3, a6) then
        return a5
    end
    local v3, v4, v5, v6, v7 = a4, a5, a3, a6, a1
    for i = 1, (math.min(#a4, 8)) do
        v1 = v3[i]
        if v1 ~= v4 and v7:Covers(v1, v2, v5, v6) then
            return v1
        end
    end
    return nil
end

return table.freeze(u0)