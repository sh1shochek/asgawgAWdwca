-- ReplicatedStorage.Visibility.PVSCodec
-- Script path: ReplicatedStorage.Visibility.PVSCodec
-- Decompile time: 18.08 ms

local u0 = {}

local function ensureFinite(a1, a2) -- Line: 42 -- types: a1: number, a2: string
    if a1 ~= a1 or a1 == (1 / 0) or a1 == (-1 / 0) then
        error((("PVSData contains non-finite %*"):format(a2)))
    end
    return a1
end

local function expectedRowStride(a1) -- Line: 49 -- types: a1: number
    return (math.ceil(a1 / 8))
end

local function cellWorldAABB(a1) -- Line: 53 -- types: a1: table
    local v1 = a1.size * 0.5
    local RightVector = a1.cframe.RightVector
    local UpVector = a1.cframe.UpVector
    local LookVector = a1.cframe.LookVector
    local v2 = Vector3.new(
        (math.abs(RightVector.X)) * v1.X + (math.abs(UpVector.X)) * v1.Y + (math.abs(LookVector.X)) * v1.Z,
        (math.abs(RightVector.Y)) * v1.X + (math.abs(UpVector.Y)) * v1.Y + (math.abs(LookVector.Y)) * v1.Z,
        (math.abs(RightVector.Z)) * v1.X + (math.abs(UpVector.Z)) * v1.Y + (math.abs(LookVector.Z)) * v1.Z
    )
    return a1.cframe.Position - v2, a1.cframe.Position + v2
end

local function validateCell(a1, a2, a3) -- Line: 66 -- types: a1: table, a2: number, a3: table
    local v1
    if a1.id < 1 or 65535 < a1.id or a1.id % 1 ~= 0 then
        error((("PVSData cluster %* has an invalid ID"):format(a2)))
    end
    if a3[a1.id] then
        error((("PVSData contains duplicate cluster ID %*"):format(a1.id)))
    end
    a3[a1.id] = true
    local size = a1.size
    local X = size.X
    local v2 = ("cluster %* size X"):format(a2)
    if X ~= X or X == (1 / 0) or X == (-1 / 0) then
        error((("PVSData contains non-finite %*"):format(v2)))
    end
    local Y = size.Y
    v2 = ("cluster %* size Y"):format(a2)
    if Y ~= Y or Y == (1 / 0) or Y == (-1 / 0) then
        error((("PVSData contains non-finite %*"):format(v2)))
    end
    local Z = size.Z
    v2 = ("cluster %* size Z"):format(a2)
    if Z ~= Z or Z == (1 / 0) or Z == (-1 / 0) then
        error((("PVSData contains non-finite %*"):format(v2)))
    end
    if size.X <= 0 or size.Y <= 0 or size.Z <= 0 then
        error((("PVSData cluster %* has a non-positive size"):format(a2)))
    end
    for i, v in ipairs({a1.cframe:GetComponents()}) do
        v1 = ("cluster %* CFrame component %*"):format(a2, i)
        if v ~= v or v == (1 / 0) or v == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v1)))
        end
    end
end

local function validateRegion(a1, a2, a3) -- Line: 89 -- types: a1: table, a2: number, a3: number
    if a1.cluster < 1 or a3 < a1.cluster or a1.cluster % 1 ~= 0 then
        error((("PVSData region %* has an invalid cluster"):format(a2)))
    end
    local X = a1.minimum.X
    local v1 = ("region %* minimum X"):format(a2)
    if X ~= X or X == (1 / 0) or X == (-1 / 0) then
        error((("PVSData contains non-finite %*"):format(v1)))
    end
    local Y = a1.minimum.Y
    v1 = ("region %* minimum Y"):format(a2)
    if Y ~= Y or Y == (1 / 0) or Y == (-1 / 0) then
        error((("PVSData contains non-finite %*"):format(v1)))
    end
    local Z = a1.minimum.Z
    v1 = ("region %* minimum Z"):format(a2)
    if Z ~= Z or Z == (1 / 0) or Z == (-1 / 0) then
        error((("PVSData contains non-finite %*"):format(v1)))
    end
    local X_2 = a1.maximum.X
    v1 = ("region %* maximum X"):format(a2)
    if X_2 ~= X_2 or X_2 == (1 / 0) or X_2 == (-1 / 0) then
        error((("PVSData contains non-finite %*"):format(v1)))
    end
    local Y_2 = a1.maximum.Y
    v1 = ("region %* maximum Y"):format(a2)
    if Y_2 ~= Y_2 or Y_2 == (1 / 0) or Y_2 == (-1 / 0) then
        error((("PVSData contains non-finite %*"):format(v1)))
    end
    local Z_2 = a1.maximum.Z
    v1 = ("region %* maximum Z"):format(a2)
    if Z_2 ~= Z_2 or Z_2 == (1 / 0) or Z_2 == (-1 / 0) then
        error((("PVSData contains non-finite %*"):format(v1)))
    end
    local v2 = a1.maximum - a1.minimum
    if v2.X <= 0 or v2.Y <= 0 or v2.Z <= 0 then
        error((("PVSData region %* has non-positive bounds"):format(a2)))
    end
end

local function attachRegionsToCells(a1) -- Line: 105 -- types: a1: table
    local regions
    for i, v in ipairs(a1.cells) do
        v.regions = {}
    end
    for i2, i3 in ipairs(a1.regions) do
        regions = a1.cells[i3.cluster].regions
        assert(regions ~= nil)
        regions[#regions + 1] = i3
    end
end

local function validateData(a1, a2) -- Line: 116
    -- upvalues: validateCell (val), validateRegion (val)
    local cluster, v1, v2, v3, v4, v5, v6
    local v7 = #a1.cells
    if v7 < 1 or v7 > 8192 then
        error((("PVSData cluster count must be between 1 and %*"):format(8192)))
    end
    if #a1.regions < 1 or #a1.regions > 65535 then
        error((("PVSData region count must be between 1 and %*"):format(65535)))
    end
    local v8 = math.ceil(v7 / 8)
    if a1.rowStride ~= v8 then
        error((("PVSData row stride mismatch: expected %*, got %*"):format(v8, a1.rowStride)))
    end
    if #a1.visibleBytes ~= v7 * v8 then
        error((("PVSData visibility byte count mismatch: expected %*, got %*"):format(v7 * v8, #a1.visibleBytes)))
    end
    local maxDistance = a1.maxDistance
    if maxDistance ~= maxDistance or maxDistance == (1 / 0) or maxDistance == (-1 / 0) then
        error("PVSData contains non-finite maximum distance")
    end
    local nearDistance = a1.nearDistance
    if nearDistance ~= nearDistance or nearDistance == (1 / 0) or nearDistance == (-1 / 0) then
        error("PVSData contains non-finite near distance")
    end
    if a1.maxDistance < 0 or a1.nearDistance < 0 then
        error("PVSData distances cannot be negative")
    end
    if a1.raysPerPair < 1 or 255 < a1.raysPerPair or a1.raysPerPair % 1 ~= 0 then
        error("PVSData bake quality must be an integer between 1 and 255")
    end
    for i, v in ipairs(a1.cells) do
        validateCell(v, i, {})
    end
    local v9 = table.create(v7, 0)
    for i2, i3 in ipairs(a1.regions) do
        validateRegion(i3, i2, v7)
        cluster = i3.cluster
        v9[cluster] = v9[cluster] + 1
    end
    for j = 1, v7 do
        if v9[j] == 0 then
            error((("PVSData cluster %* has no spatial regions"):format(j)))
        end
    end
    local v10 = buffer.fromstring(a1.visibleBytes)
    local v11 = {}
    local v12 = {}
    for k = 1, v7 do
        v2 = (k - 1) / 8
        v11[k] = (math.floor(v2))
        v3 = (k - 1) % 8
        v12[k] = (bit32.lshift(1, v3))
    end
    for n = 1, v7 do
        if a2 and n % 32 == 0 then
            a2()
        end
        v1 = (n - 1) * v8
        v2 = v11[n]
        v3 = v12[n]
        v4 = v1 + v2
        if bit32.band(buffer.readu8(v10, v4), v3) == 0 then
            error((("PVSData cluster %* is not visible to itself"):format(n)))
        end
        for m = n + 1, v7 do
            v5 = v1 + v11[m]
            v4 = bit32.band(buffer.readu8(v10, v5), v12[m]) ~= 0
            v6 = (m - 1) * v8 + v2
            if v4 ~= (bit32.band(buffer.readu8(v10, v6), v3) ~= 0) then
                error((("PVSData visibility is not mutual for clusters %* and %*"):format(n, m)))
            end
        end
    end
end

function u0.getRowStride(a1) -- Line: 183 -- types: a1: number
    local v1 = false
    if a1 >= 0 then
        v1 = a1 % 1 == 0
    end
    assert(v1, "cellCount must be a non-negative integer")
    return (math.ceil(a1 / 8))
end

function u0.newVisibilityBuffer(a1) -- Line: 188 -- types: a1: number
    local v1 = false
    if a1 >= 1 then
        v1 = false
        if a1 <= 8192 then
            v1 = a1 % 1 == 0
        end
    end
    assert(v1, "invalid PVS cluster count")
    return buffer.create(a1 * math.ceil(a1 / 8))
end

function u0.setVisible(a1, a2, a3, a4) -- Line: 193 -- types: a1: buffer, a2: number, a3: number, a4: number
    local v1 = (a3 - 1) * a2 + math.floor((a4 - 1) / 8)
    local v2 = bit32.lshift(1, (a4 - 1) % 8)
    local v3 = bit32.bor(buffer.readu8(a1, v1), v2)
    buffer.writeu8(a1, v1, v3)
end

function u0.isVisible(a1, a2, a3) -- Line: 199 -- types: a1: table, a2: number, a3: number
    local v1 = #a1.cells
    if not (a2 < 1) and not (v1 < a2) and not (a3 < 1) and not (v1 < a3) then
        local v2 = string.byte(a1.visibleBytes, (a2 - 1) * a1.rowStride + (math.floor((a3 - 1) / 8)) + 1)
        if v2 == nil then
            return false
        end
        return bit32.band(v2, (bit32.lshift(1, (a3 - 1) % 8))) ~= 0
    end
    return false
end

function u0.regionContainsPoint(a1, a2, a3) -- Line: 213 -- types: a1: table, a2: vector, a3: number?
    local v1 = math.max(a3 or 0, 0)
    local v2 = false
    local X = a2.X
    if a1.minimum.X - v1 <= X then
        v2 = false
        if a2.X <= a1.maximum.X + v1 then
            v2 = false
            local Y = a2.Y
            if a1.minimum.Y - v1 <= Y then
                v2 = false
                if a2.Y <= a1.maximum.Y + v1 then
                    v2 = false
                    local Z = a2.Z
                    if a1.minimum.Z - v1 <= Z then
                        v2 = a2.Z <= a1.maximum.Z + v1
                    end
                end
            end
        end
    end
    return v2
end

function u0.findCellIndices(a1, a2, a3) -- Line: 223 -- upvalues: u0 (val) -- types: a1: table, a2: vector, a3: number?
    local v1 = {}
    local v2 = {}
    for i, v in ipairs(a1.regions) do
        if not v1[v.cluster] and u0.regionContainsPoint(v, a2, a3) then
            v1[v.cluster] = true
            v2[#v2 + 1] = v.cluster
        end
    end
    table.sort(v2)
    return v2
end

function u0.regionFromCell(a1, a2) -- Line: 236 -- upvalues: cellWorldAABB (val) -- types: a1: table, a2: number
    local v1, v2 = cellWorldAABB(a1)
    return {cluster = a2, minimum = v1, maximum = v2}
end

function u0.encode(a1) -- Line: 245 -- upvalues: validateData (val) -- types: a1: table
    local cluster, id, v1
    validateData(a1)
    local v2 = #a1.cells
    local v3 = #a1.regions
    local v4 = v2 * 62 + 22 + v3 * 26 + #a1.visibleBytes
    local v5 = buffer.create(v4)
    local v6 = 0
    buffer.writestring(v5, v6, "BLXPVS2")
    v6 = v6 + 7
    buffer.writeu16(v5, v6, v2)
    v6 = v6 + 2
    local rowStride = a1.rowStride
    buffer.writeu16(v5, v6, rowStride)
    v6 = v6 + 2
    buffer.writeu16(v5, v6, v3)
    v6 = v6 + 2
    local maxDistance = a1.maxDistance
    buffer.writef32(v5, v6, maxDistance)
    v6 = v6 + 4
    local nearDistance = a1.nearDistance
    buffer.writef32(v5, v6, nearDistance)
    v6 = v6 + 4
    local raysPerPair = a1.raysPerPair
    buffer.writeu8(v5, v6, raysPerPair)
    v6 = v6 + 1
    local v7 = a1
    for i, v in ipairs(a1.cells) do
        id = v.id
        buffer.writeu16(v5, v6, id)
        v6 = v6 + 2
        v1 = {v.cframe:GetComponents()}
        v1[#v1 + 1] = v.size.X
        v1[#v1 + 1] = v.size.Y
        v1[#v1 + 1] = v.size.Z
        for i2, i3 in ipairs(v1) do
            buffer.writef32(v5, v6, i3)
            v6 = v6 + 4
        end
    end
    for i4, j in ipairs(v7.regions) do
        cluster = j.cluster
        buffer.writeu16(v5, v6, cluster)
        v6 = v6 + 2
        for i5, k in ipairs({
            j.minimum.X,
            j.minimum.Y,
            j.minimum.Z,
            j.maximum.X,
            j.maximum.Y,
            j.maximum.Z,
        }) do
            buffer.writef32(v5, v6, k)
            v6 = v6 + 4
        end
    end
    buffer.writestring(v5, v6, v7.visibleBytes)
    return buffer.tostring(v5)
end

function u0.isEncoded(a1) -- Line: 301
    local v1 = false
    if typeof(a1) == "string" then
        v1 = false
        if #a1 >= 7 then
            v1 = true
            if string.sub(a1, 1, 7) ~= "BLXPVS1" then
                v1 = string.sub(a1, 1, 7) == "BLXPVS2"
            end
        end
    end
    return v1
end

function u0.decode(a1, a2) -- Line: 307
    -- upvalues: u0 (val), validateData (val), attachRegionsToCells (val)
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22
    if not u0.isEncoded(a1) then
        error("PVSData does not start with a supported BLXPVS header")
    end
    local v23 = string.sub(a1, 1, 7) == "BLXPVS2"
    local u2143 = buffer.fromstring(a1)
    local u21 = 7
    local u2105 = #a1

    local function ensureCanRead(a1, a2) -- Line: 318
        -- upvalues: u2105 (val), u21 (ref)
        if u2105 - u21 < a1 then
            error((("PVSData ended while reading %*"):format(a2)))
        end
    end

    local function readu16(a1) -- Line: 324 -- upvalues: u2105 (val), u21 (ref), u2143 (val) -- types: a1: string
        if u2105 - u21 < 2 then
            error((("PVSData ended while reading %*"):format(a1)))
        end
        local v1 = u21
        local v2 = buffer.readu16(u2143, v1)
        u21 = u21 + 2
        return v2
    end

    local function readu8(a1) -- Line: 331 -- upvalues: u2105 (val), u21 (ref), u2143 (val) -- types: a1: string
        if u2105 - u21 < 1 then
            error((("PVSData ended while reading %*"):format(a1)))
        end
        local v1 = u21
        local v2 = buffer.readu8(u2143, v1)
        u21 = u21 + 1
        return v2
    end

    local function readf32(a1) -- Line: 338 -- upvalues: u2105 (val), u21 (ref), u2143 (val) -- types: a1: string
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(a1)))
        end
        local v1 = u21
        local v2 = buffer.readf32(u2143, v1)
        if v2 ~= v2 or v2 == (1 / 0) or v2 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(a1)))
        end
        u21 = u21 + 4
        return v2
    end

    if u2105 - u21 < 2 then
        error("PVSData ended while reading cluster count")
    end
    local v24 = u21
    local v25 = buffer.readu16(u2143, v24)
    u21 = u21 + 2
    if v25 < 1 or v25 > 8192 then
        error((("PVSData has an invalid cluster count: %*"):format(v25)))
    end
    if u2105 - u21 < 2 then
        error("PVSData ended while reading row stride")
    end
    local v26 = u21
    local v27 = buffer.readu16(u2143, v26)
    u21 = u21 + 2
    if not v23 then
        v24 = v25
    else
        if u2105 - u21 < 2 then
            error("PVSData ended while reading region count")
        end
        v2 = u21
        v24 = buffer.readu16(u2143, v2)
        u21 = u21 + 2
    end
    if v24 < 1 or v24 > 65535 then
        error((("PVSData has an invalid region count: %*"):format(v24)))
    end
    if u2105 - u21 < 4 then
        error("PVSData ended while reading maximum distance")
    end
    local v28 = u21
    v26 = buffer.readf32(u2143, v28)
    if v26 ~= v26 or v26 == (1 / 0) or v26 == (-1 / 0) then
        error("PVSData contains non-finite maximum distance")
    end
    u21 = u21 + 4
    if u2105 - u21 < 4 then
        error("PVSData ended while reading near distance")
    end
    local v29 = u21
    v2 = buffer.readf32(u2143, v29)
    if v2 ~= v2 or v2 == (1 / 0) or v2 == (-1 / 0) then
        error("PVSData contains non-finite near distance")
    end
    u21 = u21 + 4
    if u2105 - u21 < 1 then
        error("PVSData ended while reading bake quality")
    end
    local v30 = u21
    v28 = buffer.readu8(u2143, v30)
    u21 = u21 + 1
    v30 = if not v23 then 0 else v24 * 26
    local v31 = (if not v23 then 20 else 22) + v25 * 62 + v30 + v25 * v27
    if u2105 ~= v31 then
        error((("PVSData byte count mismatch: expected %*, got %*"):format(v31, u2105)))
    end
    local v32 = table.create(v25)
    for i = 1, v25 do
        v4 = ("cluster %* ID"):format(i)
        if u2105 - u21 < 2 then
            error((("PVSData ended while reading %*"):format(v4)))
        end
        v7 = u21
        v3 = buffer.readu16(u2143, v7)
        u21 = u21 + 2
        v5 = ("cluster %* position X"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v5)))
        end
        v8 = u21
        v4 = buffer.readf32(u2143, v8)
        if v4 ~= v4 or v4 == (1 / 0) or v4 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v5)))
        end
        u21 = u21 + 4
        v6 = ("cluster %* position Y"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v6)))
        end
        v9 = u21
        v5 = buffer.readf32(u2143, v9)
        if v5 ~= v5 or v5 == (1 / 0) or v5 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v6)))
        end
        u21 = u21 + 4
        v7 = ("cluster %* position Z"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v7)))
        end
        v10 = u21
        v6 = buffer.readf32(u2143, v10)
        if v6 ~= v6 or v6 == (1 / 0) or v6 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v7)))
        end
        u21 = u21 + 4
        v8 = ("cluster %* rotation 00"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v8)))
        end
        v11 = u21
        v7 = buffer.readf32(u2143, v11)
        if v7 ~= v7 or v7 == (1 / 0) or v7 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v8)))
        end
        u21 = u21 + 4
        v9 = ("cluster %* rotation 01"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v9)))
        end
        v12 = u21
        v8 = buffer.readf32(u2143, v12)
        if v8 ~= v8 or v8 == (1 / 0) or v8 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v9)))
        end
        u21 = u21 + 4
        v10 = ("cluster %* rotation 02"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v10)))
        end
        v13 = u21
        v9 = buffer.readf32(u2143, v13)
        if v9 ~= v9 or v9 == (1 / 0) or v9 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v10)))
        end
        u21 = u21 + 4
        v11 = ("cluster %* rotation 10"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v11)))
        end
        v14 = u21
        v10 = buffer.readf32(u2143, v14)
        if v10 ~= v10 or v10 == (1 / 0) or v10 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v11)))
        end
        u21 = u21 + 4
        v12 = ("cluster %* rotation 11"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v12)))
        end
        v15 = u21
        v11 = buffer.readf32(u2143, v15)
        if v11 ~= v11 or v11 == (1 / 0) or v11 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v12)))
        end
        u21 = u21 + 4
        v13 = ("cluster %* rotation 12"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v13)))
        end
        v16 = u21
        v12 = buffer.readf32(u2143, v16)
        if v12 ~= v12 or v12 == (1 / 0) or v12 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v13)))
        end
        u21 = u21 + 4
        v14 = ("cluster %* rotation 20"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v14)))
        end
        v17 = u21
        v13 = buffer.readf32(u2143, v17)
        if v13 ~= v13 or v13 == (1 / 0) or v13 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v14)))
        end
        u21 = u21 + 4
        v15 = ("cluster %* rotation 21"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v15)))
        end
        v18 = u21
        v14 = buffer.readf32(u2143, v18)
        if v14 ~= v14 or v14 == (1 / 0) or v14 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v15)))
        end
        u21 = u21 + 4
        v16 = ("cluster %* rotation 22"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v16)))
        end
        v19 = u21
        v15 = buffer.readf32(u2143, v19)
        if v15 ~= v15 or v15 == (1 / 0) or v15 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v16)))
        end
        u21 = u21 + 4
        v17 = ("cluster %* size X"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v17)))
        end
        v20 = u21
        v16 = buffer.readf32(u2143, v20)
        if v16 ~= v16 or v16 == (1 / 0) or v16 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v17)))
        end
        u21 = u21 + 4
        v18 = ("cluster %* size Y"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v18)))
        end
        v21 = u21
        v17 = buffer.readf32(u2143, v21)
        if v17 ~= v17 or v17 == (1 / 0) or v17 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v18)))
        end
        u21 = u21 + 4
        v19 = ("cluster %* size Z"):format(i)
        if u2105 - u21 < 4 then
            error((("PVSData ended while reading %*"):format(v19)))
        end
        v22 = u21
        v18 = buffer.readf32(u2143, v22)
        if v18 ~= v18 or v18 == (1 / 0) or v18 == (-1 / 0) then
            error((("PVSData contains non-finite %*"):format(v19)))
        end
        u21 = u21 + 4
        v19 = {
            id = v3,
            cframe = CFrame.new(v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15),
            size = Vector3.new(v16, v17, v18),
        }
        v32[i] = v19
    end
    local v33 = table.create(v24)
    if not v23 then
        for i2, v in ipairs(v32) do
            v33[i2] = (u0.regionFromCell(v, i2))
        end
    else
        for j = 1, v24 do
            v4 = {}
            v6 = ("region %* cluster"):format(j)
            if u2105 - u21 < 2 then
                error((("PVSData ended while reading %*"):format(v6)))
            end
            v7 = buffer.readu16(u2143, u21)
            u21 = u21 + 2
            v4.cluster = v7
            v7 = ("region %* minimum X"):format(j)
            if u2105 - u21 < 4 then
                error((("PVSData ended while reading %*"):format(v7)))
            end
            v10 = u21
            v6 = buffer.readf32(u2143, v10)
            if v6 ~= v6 or v6 == (1 / 0) or v6 == (-1 / 0) then
                error((("PVSData contains non-finite %*"):format(v7)))
            end
            u21 = u21 + 4
            v8 = ("region %* minimum Y"):format(j)
            if u2105 - u21 < 4 then
                error((("PVSData ended while reading %*"):format(v8)))
            end
            v11 = u21
            v7 = buffer.readf32(u2143, v11)
            if v7 ~= v7 or v7 == (1 / 0) or v7 == (-1 / 0) then
                error((("PVSData contains non-finite %*"):format(v8)))
            end
            u21 = u21 + 4
            v9 = ("region %* minimum Z"):format(j)
            if u2105 - u21 < 4 then
                error((("PVSData ended while reading %*"):format(v9)))
            end
            v12 = u21
            v8 = buffer.readf32(u2143, v12)
            if v8 ~= v8 or v8 == (1 / 0) or v8 == (-1 / 0) then
                error((("PVSData contains non-finite %*"):format(v9)))
            end
            u21 = u21 + 4
            v4.minimum = Vector3.new(v6, v7, v8)
            v7 = ("region %* maximum X"):format(j)
            if u2105 - u21 < 4 then
                error((("PVSData ended while reading %*"):format(v7)))
            end
            v10 = u21
            v6 = buffer.readf32(u2143, v10)
            if v6 ~= v6 or v6 == (1 / 0) or v6 == (-1 / 0) then
                error((("PVSData contains non-finite %*"):format(v7)))
            end
            u21 = u21 + 4
            v8 = ("region %* maximum Y"):format(j)
            if u2105 - u21 < 4 then
                error((("PVSData ended while reading %*"):format(v8)))
            end
            v11 = u21
            v7 = buffer.readf32(u2143, v11)
            if v7 ~= v7 or v7 == (1 / 0) or v7 == (-1 / 0) then
                error((("PVSData contains non-finite %*"):format(v8)))
            end
            u21 = u21 + 4
            v9 = ("region %* maximum Z"):format(j)
            if u2105 - u21 < 4 then
                error((("PVSData ended while reading %*"):format(v9)))
            end
            v12 = u21
            v8 = buffer.readf32(u2143, v12)
            if v8 ~= v8 or v8 == (1 / 0) or v8 == (-1 / 0) then
                error((("PVSData contains non-finite %*"):format(v9)))
            end
            u21 = u21 + 4
            v4.maximum = Vector3.new(v6, v7, v8)
            v33[j] = v4
        end
    end
    local v34 = v25 * v27
    if u2105 - u21 < v34 then
        error("PVSData ended while reading visibility rows")
    end
    local v35 = {
        cells = v32,
        regions = v33,
        rowStride = v27,
        visibleBytes = buffer.readstring(u2143, u21, v34),
        maxDistance = v26,
        nearDistance = v2,
        raysPerPair = v28,
    }
    validateData(v35, v1)
    attachRegionsToCells(v35)
    return v35
end

return table.freeze(u0)