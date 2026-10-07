-- ReplicatedStorage.Visibility.PortalVis.Vis
-- Script path: ReplicatedStorage.Visibility.PortalVis.Vis
-- Decompile time: 41.13 ms

local Winding = require(script.Parent:WaitForChild("Winding"))
local v1 = {
    bsSet = function(a1, a2) -- Line: 11
        local v1 = (a2 - 1) // 32 * 4
        local v2 = bit32.bor(buffer.readu32(a1, v1), (bit32.lshift(1, (a2 - 1) % 32)))
        buffer.writeu32(a1, v1, v2)
    end,
    bsTest = function(a1, a2) -- Line: 16
        local v1 = (a2 - 1) // 32 * 4
        return bit32.band(buffer.readu32(a1, v1), (bit32.lshift(1, (a2 - 1) % 32))) ~= 0
    end,
    bsCount = function(a1) -- Line: 21
        local v1
        local v2 = 0
        local v3 = buffer.len(a1) - 4
        for i = 0, v3, 4 do
            v1 = buffer.readu32(a1, i)
            while v1 ~= 0 do
                v1 = bit32.band(v1, v1 - 1)
                v2 = v2 + 1
            end
        end
        return v2
    end,
    prepare = function(a1, a2, a3) -- Line: 36 -- upvalues: Winding (val)
        local plane
        local v1 = {}
        for i, j in a2 do
            if j.air then
                v1[#v1 + 1] = j
                j.airIndex = #v1
            end
        end
        local u90 = {}
        local u91 = {}
        local v2 = #v1
        for k = 1, v2 do
            u91[k] = {}
        end

        local function add(a1, a2, a3, a4, a5, a6, a7) -- Line: 49 -- upvalues: Winding (upval), u90 (val), u91 (val)
            local v1, v2, v3, v4, v5, v6 = Winding.bounds(a7)
            local v7 = {
                done = false,
                id = #u90 + 1,
                from = a1.airIndex,
                leaf = a2.airIndex,
                nx = a3,
                ny = a4,
                nz = a5,
                d = a6,
                w = a7,
                minX = v1,
                minY = v2,
                minZ = v3,
                maxX = v4,
                maxY = v5,
                maxZ = v6,
            }
            u90[v7.id] = v7
            local v8 = u91[a1.airIndex]
            v8[#v8 + 1] = v7
        end

        local v3 = nil
        local v4 = nil
        local v5 = a3
        for n, m in a1, v3, v4 do
            if v5 ~= nil and n % 32 == 0 then
                v5()
            end
            plane = m.plane
            add(m.front, m.back, -plane[1], -plane[2], -plane[3], -plane[4], m.w)
            add(m.back, m.front, plane[1], plane[2], plane[3], plane[4], m.w)
        end
        return {portals = u90, leafPortals = u91, airLeaves = v1, leafWords = (#v1 + 31) // 32}
    end,
}

local function boxRange(a1, a2, a3, a4, a5) -- Line: 84
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

function v1.basePortalVis(a1, a2, a3, a4, a5) -- Line: 97 -- upvalues: boxRange (val), Winding (val)
    local d, nx, ny, nz, v1, v2, v3, v4, v5, v6
    local portals = a1.portals
    local v7 = #portals
    local v8 = (v7 + 31) // 32
    a1.portalWords = v8
    local v9 = a4 or v7
    local v10 = a5
    for i = a3 or 1, v9 do
        v1 = portals[i]
        if v10 ~= nil then
            v10()
        end
        v2 = buffer.create(v8 * 4)
        nx = v1.nx
        ny = v1.ny
        nz = v1.nz
        d = v1.d
        for j, k in portals do
            if j ~= i then
                _, v3 = boxRange(k, nx, ny, nz, d)
                if not (v3 <= 0.05) then
                    _, v4 = Winding.range(k.w, nx, ny, nz, d)
                    if not (v4 <= 0.05)
                        and not (-0.05 <= (boxRange(v1, k.nx, k.ny, k.nz, k.d)))
                        and not (-0.05 <= (Winding.range(v1.w, k.nx, k.ny, k.nz, k.d))) then
                        v5 = (j - 1) // 32 * 4
                        v6 = bit32.bor(buffer.readu32(v2, v5), (bit32.lshift(1, (j - 1) % 32)))
                        buffer.writeu32(v2, v5, v6)
                    end
                end
            end
        end
        v1.front = v2
        if v11 ~= nil and i % 1000 == 0 then
            v11(i, v7)
        end
    end
end

function v1.simpleFlood(a1, a2) -- Line: 139
    local front, id, leaf, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
    local leafWords = a1.leafWords
    local leafPortals = a1.leafPortals
    local v11 = 0
    local portals = a1.portals
    local v12 = nil
    local v13 = nil
    local v14, v15 = a1, a2
    for i, j in portals, v12, v13 do
        if v15 ~= nil and i % 8 == 0 then
            v15()
        end
        v1 = buffer.create(leafWords * 4)
        v2 = 0
        v3 = {j.leaf}
        while #v3 > 0 do
            v4 = table.remove(v3)
            v6 = (v4 - 1) // 32 * 4
            v5 = bit32.band(buffer.readu32(v1, v6), (bit32.lshift(1, (v4 - 1) % 32))) ~= 0
            if not v5 then
                v5 = (v4 - 1) // 32 * 4
                v8 = bit32.bor(buffer.readu32(v1, v5), (bit32.lshift(1, (v4 - 1) % 32)))
                buffer.writeu32(v1, v5, v8)
                v2 = v2 + 1
                v5 = leafPortals[v4]
                v6 = nil
                v7 = nil
                for k, n in v5, v6, v7 do
                    front = j.front
                    id = n.id
                    v10 = (id - 1) // 32 * 4
                    if bit32.band(buffer.readu32(front, v10), (bit32.lshift(1, (id - 1) % 32))) ~= 0 then
                        leaf = n.leaf
                        v9 = (leaf - 1) // 32 * 4
                        if not (bit32.band(buffer.readu32(v1, v9), (bit32.lshift(1, (leaf - 1) % 32))) ~= 0) then
                            v3[#v3 + 1] = n.leaf
                        end
                    end
                end
            end
        end
        j.mightsee = v1
        j.numMightsee = v2
        v11 = v11 + v2
    end
    return v11 / #v14.portals
end

local function clipToSeparators(a1, a2, a3, a4) -- Line: 170 -- upvalues: Winding (val)
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23
    local v24 = #a1 // 3
    local v25 = #a2 // 3
    local v26, v27, v28 = a1, a2, a4
    for i = 1, v24 do
        v23 = i % v24 + 1
        v1 = v26[i * 3 - 2]
        v2 = v26[i * 3 - 1]
        v3 = v26[i * 3]
        v4 = v26[v23 * 3 - 2] - v1
        v5 = v26[v23 * 3 - 1] - v2
        v6 = v26[v23 * 3] - v3
        for j = 1, v25 do
            v7 = v27[j * 3 - 2]
            v8 = v27[j * 3 - 1]
            v9 = v27[j * 3]
            v10 = v7 - v1
            v11 = v8 - v2
            v12 = v9 - v3
            v13 = v5 * v12 - v6 * v11
            v14 = v6 * v10 - v4 * v12
            v15 = v4 * v11 - v5 * v10
            v16 = math.sqrt(v13 * v13 + v14 * v14 + v15 * v15)
            if not (v16 < 0.05) then
                v13 = v13 / v16
                v14 = v14 / v16
                v15 = v15 / v16
                v17 = v7 * v13 + v8 * v14 + v9 * v15
                v18 = nil
                v19 = v24
                for k = 1, v19 do
                    if k ~= i and k ~= v23 then
                        v21 = v26[k * 3 - 2] * v13 + v26[k * 3 - 1] * v14 + v26[k * 3] * v15 - v17
                        if v21 < -0.05 then
                            v18 = false
                            break
                        end
                        if v21 > 0.05 then
                            v18 = true
                            break
                        end
                    end
                end
                if v18 ~= nil then
                    if v18 then
                        v13 = -v13
                        v14 = -v14
                        v15 = -v15
                        v17 = -v17
                    end
                    v19 = 0
                    v20 = true
                    for n = 1, v25 do
                        if n ~= j then
                            v22 = v27[n * 3 - 2] * v13 + v27[n * 3 - 1] * v14 + v27[n * 3] * v15 - v17
                            if v22 < -0.05 then
                                v20 = false
                                break
                            end
                            if v22 > 0.05 then
                                v19 = v19 + 1
                            end
                        end
                    end
                    if v20 and v19 ~= 0 then
                        if v28 then
                            v13 = -v13
                            v14 = -v14
                            v15 = -v15
                            v17 = -v17
                        end
                        a3 = Winding.clip(a3, v13, v14, v15, v17, 0.05)
                        if a3 == nil then
                            return nil
                        end
                    end
                end
            end
        end
    end
    return a3
end

function v1.portalFlow(a1, a2, a3) -- Line: 236 -- upvalues: Winding (val), clipToSeparators (val)
    local flow
    local leafWords = a1.leafWords
    local leafPortals = a1.leafPortals
    local u26 = buffer.create(leafWords * 4)
    local u8 = {
        portal = a2,
        source = a2.w,
        nx = a2.nx,
        ny = a2.ny,
        nz = a2.nz,
        d = a2.d,
        mightsee = a2.mightsee,
    }
    local u15 = {portalTests = 0, portalPasses = 0, budgeted = false}
    local u16 = a3 or (1 / 0)

    function flow(a1, a2) -- Line: 253
        -- upvalues: u26 (ref), u15 (val), u16 (val), leafPortals (val), leafWords (val), Winding (upval), u8 (val)
        -- upvalues: flow (val), clipToSeparators (upval)
        local leaf, leafvis, mightsee, mightsee_2, v1, v2, v3, v4, v5, v6, v7
        local v8 = u26
        local v9 = (a1 - 1) // 32 * 4
        local v10 = bit32.bor(buffer.readu32(v8, v9), (bit32.lshift(1, (a1 - 1) % 32)))
        buffer.writeu32(v8, v9, v10)
        if u16 < u15.portalPasses then
            u15.budgeted = true
            return
        end
        v8 = leafPortals[a1]
        v9 = nil
        local v11 = nil
        local v12 = a2
        for i, j in v8, v9, v11 do
            if u15.budgeted then
                return
            end
            mightsee = v12.mightsee
            leaf = j.leaf
            v1 = (leaf - 1) // 32 * 4
            v3 = buffer.readu32(mightsee, v1)
            if bit32.band(v3, (bit32.lshift(1, (leaf - 1) % 32))) ~= 0 then
                leafvis = if not j.done then j.mightsee else j.leafvis
                v6 = buffer.create(leafWords * 4)
                v7 = false
                v1 = leafWords * 4 - 4
                for k = 0, v1, 4 do
                    mightsee_2 = v12.mightsee
                    v4 = bit32.band(buffer.readu32(mightsee_2, k), (buffer.readu32(leafvis, k)))
                    buffer.writeu32(v6, k, v4)
                    v5 = u26
                    if bit32.band(v4, (bit32.bnot((buffer.readu32(v5, k))))) ~= 0 then
                        v7 = true
                    end
                end
                if v7 then
                    v1 = j.nx * v12.nx + j.ny * v12.ny + j.nz * v12.nz
                    if not (v1 < -0.9999) then
                        v1 = u15
                        v1.portalTests = v1.portalTests + 1
                        v1 = Winding.clip(j.w, u8.nx, u8.ny, u8.nz, u8.d, 0.05)
                        if v1 ~= nil then
                            v2 = {
                                portal = j,
                                nx = j.nx,
                                ny = j.ny,
                                nz = j.nz,
                                d = j.d,
                                mightsee = v6,
                            }
                            if v12.pass ~= nil then
                                v1 = Winding.clip(v1, v12.nx, v12.ny, v12.nz, v12.d, 0.05)
                                if v1 ~= nil then
                                    v3 = Winding.clip(v12.source, -j.nx, -j.ny, -j.nz, -j.d, 0.05)
                                    if v3 ~= nil then
                                        v1 = clipToSeparators(v3, v12.pass, v1, false)
                                        if v1 ~= nil then
                                            v1 = clipToSeparators(v12.pass, v3, v1, true)
                                            if v1 ~= nil then
                                                v2.source = v3
                                                v2.pass = v1
                                                v4 = u15
                                                v4.portalPasses = v4.portalPasses + 1
                                                flow(j.leaf, v2)
                                            end
                                        end
                                    end
                                end
                            else
                                v2.source = v12.source
                                v2.pass = v1
                                v3 = u15
                                v3.portalPasses = v3.portalPasses + 1
                                flow(j.leaf, v2)
                            end
                        end
                    else
                        v1 = math.abs(j.d + v12.d)
                        if not (v1 < 0.05) then
                            v1 = u15
                            v1.portalTests = v1.portalTests + 1
                            v1 = Winding.clip(j.w, u8.nx, u8.ny, u8.nz, u8.d, 0.05)
                            if v1 ~= nil then
                                v2 = {
                                    portal = j,
                                    nx = j.nx,
                                    ny = j.ny,
                                    nz = j.nz,
                                    d = j.d,
                                    mightsee = v6,
                                }
                                if v12.pass ~= nil then
                                    v1 = Winding.clip(v1, v12.nx, v12.ny, v12.nz, v12.d, 0.05)
                                    if v1 ~= nil then
                                        v3 = Winding.clip(v12.source, -j.nx, -j.ny, -j.nz, -j.d, 0.05)
                                        if v3 ~= nil then
                                            v1 = clipToSeparators(v3, v12.pass, v1, false)
                                            if v1 ~= nil then
                                                v1 = clipToSeparators(v12.pass, v3, v1, true)
                                                if v1 ~= nil then
                                                    v2.source = v3
                                                    v2.pass = v1
                                                    v4 = u15
                                                    v4.portalPasses = v4.portalPasses + 1
                                                    flow(j.leaf, v2)
                                                end
                                            end
                                        end
                                    end
                                else
                                    v2.source = v12.source
                                    v2.pass = v1
                                    v3 = u15
                                    v3.portalPasses = v3.portalPasses + 1
                                    flow(j.leaf, v2)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    flow(a2.leaf, u8)
    if u15.budgeted then
        u26 = buffer.create(leafWords * 4)
        buffer.copy(u26, 0, a2.mightsee)
    end
    a2.leafvis = u26
    a2.done = true
    return u15
end

function v1.floodCells(a1, a2, a3, a4) -- Line: 331 -- upvalues: Winding (val), clipToSeparators (val)
    local floodFace, interiorFace, mightsee, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23
    local leafWords = a1.leafWords
    local leafPortals = a1.leafPortals
    local u764 = {}
    local u765 = {}
    local v24 = {}
    local v25 = #a1.airLeaves
    for i = 1, v25 do
        u764[i] = {}
    end
    local v26 = nil
    local v27 = nil
    for j, k in a2, v26, v27 do
        v1 = u764[k.leaf]
        v1[#v1 + 1] = k
        if u765[k.cell] == nil then
            u765[k.cell] = {}
            v24[#v24 + 1] = k.cell
        end
        v2 = u765[k.cell]
        v2[#v2 + 1] = k
    end
    table.sort(v24)
    v25 = a3.shardIndex or 1
    v26 = a3.shardCount or 1
    local u769 = a3.budget or (1 / 0)
    local u770 = a3.yieldEvery or 0
    local yield = a3.yield
    v1 = nil
    if a3.cells ~= nil then
        v1 = {}
        for n, m in a3.cells do
            v1[m] = true
        end
    end
    v2 = {}
    local u774 = {floods = 0, passes = 0, budgeted = 0, interior = 0}

    local function coplanar(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 365
        local v1 = false
        if 0.9999 < a1 * a5 + a2 * a6 + a3 * a7 then
            v1 = (math.abs(a4 - a8)) < 0.05
        end
        return v1
    end

    local v28 = nil
    local v29 = nil
    for i5, i6 in v24, v28, v29 do
        if v1 == nil then
            if (i5 - 1) % v26 == v25 - 1 then
                local u779 = {[i6] = true}
                local u157 = buffer.create(leafWords * 4)
                local u159 = {}
                v3 = #a1.airLeaves
                for i7 = 1, v3 do
                    v4 = 0
                    v5 = u764[i7]
                    for i8, i9 in v5 do
                        if i9.cell ~= i6 then
                            v4 = v4 + 1
                        end
                    end
                    u159[i7] = v4
                    if v4 > 0 then
                        v5 = (i7 - 1) // 32 * 4
                        v8 = bit32.bor(buffer.readu32(u157, v5), (bit32.lshift(1, (i7 - 1) % 32)))
                        buffer.writeu32(u157, v5, v8)
                    end
                end

                local function mark(a1_2) -- Line: 393
                    -- upvalues: u779 (val), a1 (val), u159 (val), u764 (val), u157 (val)
                    local v1, v2, v3, v4, v5
                    if u779[a1_2.cell] then
                        return
                    end
                    u779[a1_2.cell] = true
                    local v6 = #a1.airLeaves
                    for i = 1, v6 do
                        v2 = u159[i]
                        if v2 > 0 then
                            v3 = 0
                            v4 = u764[i]
                            v5 = nil
                            for j, k in v4, nil, v5 do
                                if k.cell == a1_2.cell then
                                    v3 = v3 + 1
                                end
                            end
                            if v3 > 0 then
                                u159[i] = v2 - v3
                                if v2 - v3 == 0 then
                                    v4 = (i - 1) // 32 * 4
                                    v5 = u157
                                    v1 = bit32.band(buffer.readu32(u157, v4), (bit32.bnot((bit32.lshift(1, (i - 1) % 32)))))
                                    buffer.writeu32(v5, v4, v1)
                                end
                            end
                        end
                    end
                end

                local function reachable(a1, a2, a3) -- Line: 422 -- upvalues: Winding (upval), clipToSeparators (upval)
                    local v1, v2, w
                    for i, j in a1.faces do
                        w = j.w
                        _, v1 = Winding.range(w, a3.nx, a3.ny, a3.nz, a3.d)
                        if not (v1 <= 0.05) then
                            if a2.pass == nil then
                                return true
                            end
                            v2 = Winding.clip(w, a3.nx, a3.ny, a3.nz, a3.d, 0.05)
                            if v2 ~= nil then
                                v2 = Winding.clip(v2, a2.nx, a2.ny, a2.nz, a2.d, 0.05)
                                if v2 ~= nil then
                                    v2 = clipToSeparators(a2.source, a2.pass, v2, false)
                                    if v2 ~= nil and clipToSeparators(a2.pass, a2.source, v2, true) ~= nil then
                                        return true
                                    end
                                end
                            end
                        end
                    end
                    return false
                end

                function floodFace(a1_2, a2) -- Line: 452
                    -- upvalues: leafWords (val), u764 (val), u779 (val), reachable (val), mark (val), u769 (val)
                    -- upvalues: leafPortals (val), u157 (val), Winding (upval), clipToSeparators (upval), u770 (val)
                    -- upvalues: yield (val), u774 (val), a1 (val)
                    local flow
                    local u5 = buffer.create(leafWords * 4)
                    local u6 = {passes = 0, budgeted = false}

                    function flow(a1, a2_2) -- Line: 455
                        -- upvalues: u5 (val), u764 (upval), u779 (upval), reachable (upval), a2 (val), mark (upval)
                        -- upvalues: u6 (val), u769 (upval), leafPortals (upval), leafWords (upval), u157 (upval)
                        -- upvalues: Winding (upval), flow (val), clipToSeparators (upval), u770 (upval), yield (upval)
                        local leaf, leafvis, mightsee, mightsee_2, v1, v2, v3, v4, v5, v6, v7, v8
                        local v9 = u5
                        local v10 = (a1 - 1) // 32 * 4
                        local v11 = bit32.bor(buffer.readu32(v9, v10), (bit32.lshift(1, (a1 - 1) % 32)))
                        buffer.writeu32(v9, v10, v11)
                        for i, j in u764[a1] do
                            if not u779[j.cell] and reachable(j, a2_2, a2) then
                                mark(j)
                            end
                        end
                        local passes = u6.passes
                        if u769 < passes then
                            u6.budgeted = true
                            return
                        end
                        v9 = leafPortals[a1]
                        v10 = nil
                        local v12 = nil
                        local v13 = a2_2
                        for k, n in v9, v10, v12 do
                            if u6.budgeted then
                                return
                            end
                            mightsee = v13.mightsee
                            leaf = n.leaf
                            v1 = (leaf - 1) // 32 * 4
                            v3 = buffer.readu32(mightsee, v1)
                            v5 = (leaf - 1) % 32
                            if bit32.band(v3, (bit32.lshift(1, v5))) ~= 0 then
                                leafvis = if not n.done then n.mightsee else n.leafvis
                                v7 = buffer.create(leafWords * 4)
                                v8 = false
                                v1 = leafWords * 4 - 4
                                for m = 0, v1, 4 do
                                    mightsee_2 = v13.mightsee
                                    v4 = bit32.band(buffer.readu32(mightsee_2, m), (buffer.readu32(leafvis, m)))
                                    buffer.writeu32(v7, m, v4)
                                    v5 = bit32.bnot((buffer.readu32(u5, m)))
                                    v6 = u157
                                    if bit32.band(v4, (bit32.bor(v5, (buffer.readu32(v6, m))))) ~= 0 then
                                        v8 = true
                                    end
                                end
                                if v8 then
                                    v1 = n.nx * v13.nx + n.ny * v13.ny + n.nz * v13.nz
                                    if not (v1 < -0.9999) then
                                        v1 = Winding.clip(n.w, a2.nx, a2.ny, a2.nz, a2.d, 0.05)
                                        if v1 ~= nil then
                                            v2 = {
                                                portal = n,
                                                nx = n.nx,
                                                ny = n.ny,
                                                nz = n.nz,
                                                d = n.d,
                                                mightsee = v7,
                                            }
                                            if v13.pass ~= nil then
                                                v1 = Winding.clip(v1, v13.nx, v13.ny, v13.nz, v13.d, 0.05)
                                                if v1 ~= nil then
                                                    v3 = Winding.clip(v13.source, -n.nx, -n.ny, -n.nz, -n.d, 0.05)
                                                    if v3 ~= nil then
                                                        v1 = clipToSeparators(v3, v13.pass, v1, false)
                                                        if v1 ~= nil then
                                                            v1 = clipToSeparators(v13.pass, v3, v1, true)
                                                            if v1 ~= nil then
                                                                v2.source = v3
                                                                v2.pass = v1
                                                                v4 = u6
                                                                v4.passes = v4.passes + 1
                                                                if u770 > 0
                                                                    and u6.passes % u770 == 0
                                                                    and yield ~= nil then
                                                                    yield()
                                                                end
                                                                flow(n.leaf, v2)
                                                            end
                                                        end
                                                    end
                                                end
                                            else
                                                v2.source = v13.source
                                                v2.pass = v1
                                                v3 = u6
                                                v3.passes = v3.passes + 1
                                                flow(n.leaf, v2)
                                            end
                                        end
                                    else
                                        v1 = math.abs(n.d + v13.d)
                                        if not (v1 < 0.05) then
                                            v1 = Winding.clip(n.w, a2.nx, a2.ny, a2.nz, a2.d, 0.05)
                                            if v1 ~= nil then
                                                v2 = {
                                                    portal = n,
                                                    nx = n.nx,
                                                    ny = n.ny,
                                                    nz = n.nz,
                                                    d = n.d,
                                                    mightsee = v7,
                                                }
                                                if v13.pass ~= nil then
                                                    v1 = Winding.clip(v1, v13.nx, v13.ny, v13.nz, v13.d, 0.05)
                                                    if v1 ~= nil then
                                                        v3 = Winding.clip(v13.source, -n.nx, -n.ny, -n.nz, -n.d, 0.05)
                                                        if v3 ~= nil then
                                                            v1 = clipToSeparators(v3, v13.pass, v1, false)
                                                            if v1 ~= nil then
                                                                v1 = clipToSeparators(v13.pass, v3, v1, true)
                                                                if v1 ~= nil then
                                                                    v2.source = v3
                                                                    v2.pass = v1
                                                                    v4 = u6
                                                                    v4.passes = v4.passes + 1
                                                                    if u770 > 0
                                                                        and u6.passes % u770 == 0
                                                                        and yield ~= nil then
                                                                        yield()
                                                                    end
                                                                    flow(n.leaf, v2)
                                                                end
                                                            end
                                                        end
                                                    end
                                                else
                                                    v2.source = v13.source
                                                    v2.pass = v1
                                                    v3 = u6
                                                    v3.passes = v3.passes + 1
                                                    flow(n.leaf, v2)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    flow(a1_2, a2)
                    local v1 = u774
                    v1.floods = v1.floods + 1
                    v1 = u774
                    v1.passes = v1.passes + u6.passes
                    if u6.budgeted then
                        local mightsee, v2
                        v1 = u774
                        v1.budgeted = v1.budgeted + 1
                        v1 = #a1.airLeaves
                        for i = 1, v1 do
                            mightsee = a2.mightsee
                            v2 = (i - 1) // 32 * 4
                            if bit32.band(buffer.readu32(mightsee, v2), (bit32.lshift(1, (i - 1) % 32))) ~= 0 then
                                for j, k in u764[i] do
                                    if not u779[k.cell] then
                                        mark(k)
                                    end
                                end
                            end
                        end
                    end
                end

                function interiorFace(a1, a2) -- Line: 549 -- upvalues: u765 (val), i6 (val), Winding (upval)
                    local v1 = u765[i6]
                    local v2 = nil
                    local v3 = nil
                    local v4, v5 = a2, a1
                    for i, j in v1, v2, v3 do
                        if j ~= v4 then
                            for k, n in j.faces do
                                if not (-0.9999 < v5.nx * n.nx + v5.ny * n.ny + v5.nz * n.nz)
                                    and not (0.01 < (math.abs(v5.d + n.d)))
                                    and Winding.contains(n.w, n.nx, n.ny, n.nz, v5.w, 0.01) then
                                    return true
                                end
                            end
                        end
                    end
                    return false
                end

                v5 = u765[i6]
                v6 = nil
                v7 = nil
                for i10, i11 in v5, v6, v7 do
                    for i12, i13 in u764[i11.leaf] do
                        if not u779[i13.cell] then
                            mark(i13)
                        end
                    end
                    v9 = a1.airLeaves[i11.leaf]
                    v10 = nil
                    v11 = nil
                    for i14, i15 in i11.faces, v10, v11 do
                        if not interiorFace(i15, i11) then
                            v12 = {}
                            v13 = leafPortals[i11.leaf]
                            v14 = nil
                            v15 = nil
                            for i16, i17 in v13, v14, v15 do
                                v18 = false
                                if 0.9999 < i15.nx * i17.nx + i15.ny * i17.ny + i15.nz * i17.nz then
                                    v18 = (math.abs(i15.d - i17.d)) < 0.05
                                end
                                if v18 then
                                    v12[#v12 + 1] = i17
                                end
                            end
                            v13 = false
                            v15 = nil
                            v16 = nil
                            for i18, i19 in v9.planes, v15, v16 do
                                v19 = false
                                if 0.9999 < i15.nx * i19[1] + i15.ny * i19[2] + i15.nz * i19[3] then
                                    v19 = (math.abs(i15.d - i19[4])) < 0.05
                                end
                                if v19 then
                                    v13 = true
                                    break
                                end
                            end
                            if not v13 then
                                if not (#v12 > 0) then
                                    v14 = buffer.create(leafWords * 4)
                                    v15 = leafPortals[i11.leaf]
                                    v16 = nil
                                    v17 = nil
                                    for i20, i21 in v15, v16, v17 do
                                        _, v20 = Winding.range(i21.w, i15.nx, i15.ny, i15.nz, i15.d)
                                        if v20 > 0.05 then
                                            v21 = leafWords * 4 - 4
                                            for i22 = 0, v21, 4 do
                                                v23 = buffer.readu32(v14, i22)
                                                mightsee = i21.mightsee
                                                v22 = bit32.bor(v23, (buffer.readu32(mightsee, i22)))
                                                buffer.writeu32(v14, i22, v22)
                                            end
                                        end
                                    end
                                    floodFace(i11.leaf, {
                                        source = i15.w,
                                        nx = i15.nx,
                                        ny = i15.ny,
                                        nz = i15.nz,
                                        d = i15.d,
                                        mightsee = v14,
                                    })
                                else
                                    for i23, i24 in v12 do
                                        floodFace(i24.leaf, {
                                            source = i15.w,
                                            nx = i15.nx,
                                            ny = i15.ny,
                                            nz = i15.nz,
                                            d = i15.d,
                                            mightsee = i24.mightsee,
                                        })
                                    end
                                end
                            elseif #v12 ~= 0 then
                                if not (#v12 > 0) then
                                    v14 = buffer.create(leafWords * 4)
                                    v15 = leafPortals[i11.leaf]
                                    v16 = nil
                                    v17 = nil
                                    for i25, i26 in v15, v16, v17 do
                                        _, v20 = Winding.range(i26.w, i15.nx, i15.ny, i15.nz, i15.d)
                                        if v20 > 0.05 then
                                            v21 = leafWords * 4 - 4
                                            for i27 = 0, v21, 4 do
                                                v23 = buffer.readu32(v14, i27)
                                                mightsee = i26.mightsee
                                                v22 = bit32.bor(v23, (buffer.readu32(mightsee, i27)))
                                                buffer.writeu32(v14, i27, v22)
                                            end
                                        end
                                    end
                                    floodFace(i11.leaf, {
                                        source = i15.w,
                                        nx = i15.nx,
                                        ny = i15.ny,
                                        nz = i15.nz,
                                        d = i15.d,
                                        mightsee = v14,
                                    })
                                else
                                    for i28, i29 in v12 do
                                        floodFace(i29.leaf, {
                                            source = i15.w,
                                            nx = i15.nx,
                                            ny = i15.ny,
                                            nz = i15.nz,
                                            d = i15.d,
                                            mightsee = i29.mightsee,
                                        })
                                    end
                                end
                            end
                        else
                            u774.interior = u774.interior + 1
                        end
                    end
                end
                v2[i6] = u779
                if a4 ~= nil then
                    a4(i6, #v24, u774)
                end
            end
        elseif v1[i6] then
            local u779 = {[i6] = true}
            local u157 = buffer.create(leafWords * 4)
            local u159 = {}
            v3 = #a1.airLeaves
            for i30 = 1, v3 do
                v4 = 0
                v5 = u764[i30]
                for i31, i32 in v5 do
                    if i32.cell ~= i6 then
                        v4 = v4 + 1
                    end
                end
                u159[i30] = v4
                if v4 > 0 then
                    v5 = (i30 - 1) // 32 * 4
                    v8 = bit32.bor(buffer.readu32(u157, v5), (bit32.lshift(1, (i30 - 1) % 32)))
                    buffer.writeu32(u157, v5, v8)
                end
            end

            local function mark(a1_2) -- Line: 393 -- upvalues: u779 (val), a1 (val), u159 (val), u764 (val), u157 (val)
                local v1, v2, v3, v4, v5
                if u779[a1_2.cell] then
                    return
                end
                u779[a1_2.cell] = true
                local v6 = #a1.airLeaves
                for i = 1, v6 do
                    v2 = u159[i]
                    if v2 > 0 then
                        v3 = 0
                        v4 = u764[i]
                        v5 = nil
                        for j, k in v4, nil, v5 do
                            if k.cell == a1_2.cell then
                                v3 = v3 + 1
                            end
                        end
                        if v3 > 0 then
                            u159[i] = v2 - v3
                            if v2 - v3 == 0 then
                                v4 = (i - 1) // 32 * 4
                                v5 = u157
                                v1 = bit32.band(buffer.readu32(u157, v4), (bit32.bnot((bit32.lshift(1, (i - 1) % 32)))))
                                buffer.writeu32(v5, v4, v1)
                            end
                        end
                    end
                end
            end

            local function reachable(a1, a2, a3) -- Line: 422 -- upvalues: Winding (upval), clipToSeparators (upval)
                local v1, v2, w
                for i, j in a1.faces do
                    w = j.w
                    _, v1 = Winding.range(w, a3.nx, a3.ny, a3.nz, a3.d)
                    if not (v1 <= 0.05) then
                        if a2.pass == nil then
                            return true
                        end
                        v2 = Winding.clip(w, a3.nx, a3.ny, a3.nz, a3.d, 0.05)
                        if v2 ~= nil then
                            v2 = Winding.clip(v2, a2.nx, a2.ny, a2.nz, a2.d, 0.05)
                            if v2 ~= nil then
                                v2 = clipToSeparators(a2.source, a2.pass, v2, false)
                                if v2 ~= nil and clipToSeparators(a2.pass, a2.source, v2, true) ~= nil then
                                    return true
                                end
                            end
                        end
                    end
                end
                return false
            end

            function floodFace(a1_2, a2) -- Line: 452
                -- upvalues: leafWords (val), u764 (val), u779 (val), reachable (val), mark (val), u769 (val)
                -- upvalues: leafPortals (val), u157 (val), Winding (upval), clipToSeparators (upval), u770 (val)
                -- upvalues: yield (val), u774 (val), a1 (val)
                local flow
                local u5 = buffer.create(leafWords * 4)
                local u6 = {passes = 0, budgeted = false}

                function flow(a1, a2_2) -- Line: 455
                    -- upvalues: u5 (val), u764 (upval), u779 (upval), reachable (upval), a2 (val), mark (upval)
                    -- upvalues: u6 (val), u769 (upval), leafPortals (upval), leafWords (upval), u157 (upval)
                    -- upvalues: Winding (upval), flow (val), clipToSeparators (upval), u770 (upval), yield (upval)
                    local leaf, leafvis, mightsee, mightsee_2, v1, v2, v3, v4, v5, v6, v7, v8
                    local v9 = u5
                    local v10 = (a1 - 1) // 32 * 4
                    local v11 = bit32.bor(buffer.readu32(v9, v10), (bit32.lshift(1, (a1 - 1) % 32)))
                    buffer.writeu32(v9, v10, v11)
                    for i, j in u764[a1] do
                        if not u779[j.cell] and reachable(j, a2_2, a2) then
                            mark(j)
                        end
                    end
                    local passes = u6.passes
                    if u769 < passes then
                        u6.budgeted = true
                        return
                    end
                    v9 = leafPortals[a1]
                    v10 = nil
                    local v12 = nil
                    local v13 = a2_2
                    for k, n in v9, v10, v12 do
                        if u6.budgeted then
                            return
                        end
                        mightsee = v13.mightsee
                        leaf = n.leaf
                        v1 = (leaf - 1) // 32 * 4
                        v3 = buffer.readu32(mightsee, v1)
                        v5 = (leaf - 1) % 32
                        if bit32.band(v3, (bit32.lshift(1, v5))) ~= 0 then
                            leafvis = if not n.done then n.mightsee else n.leafvis
                            v7 = buffer.create(leafWords * 4)
                            v8 = false
                            v1 = leafWords * 4 - 4
                            for m = 0, v1, 4 do
                                mightsee_2 = v13.mightsee
                                v4 = bit32.band(buffer.readu32(mightsee_2, m), (buffer.readu32(leafvis, m)))
                                buffer.writeu32(v7, m, v4)
                                v5 = bit32.bnot((buffer.readu32(u5, m)))
                                v6 = u157
                                if bit32.band(v4, (bit32.bor(v5, (buffer.readu32(v6, m))))) ~= 0 then
                                    v8 = true
                                end
                            end
                            if v8 then
                                v1 = n.nx * v13.nx + n.ny * v13.ny + n.nz * v13.nz
                                if not (v1 < -0.9999) then
                                    v1 = Winding.clip(n.w, a2.nx, a2.ny, a2.nz, a2.d, 0.05)
                                    if v1 ~= nil then
                                        v2 = {
                                            portal = n,
                                            nx = n.nx,
                                            ny = n.ny,
                                            nz = n.nz,
                                            d = n.d,
                                            mightsee = v7,
                                        }
                                        if v13.pass ~= nil then
                                            v1 = Winding.clip(v1, v13.nx, v13.ny, v13.nz, v13.d, 0.05)
                                            if v1 ~= nil then
                                                v3 = Winding.clip(v13.source, -n.nx, -n.ny, -n.nz, -n.d, 0.05)
                                                if v3 ~= nil then
                                                    v1 = clipToSeparators(v3, v13.pass, v1, false)
                                                    if v1 ~= nil then
                                                        v1 = clipToSeparators(v13.pass, v3, v1, true)
                                                        if v1 ~= nil then
                                                            v2.source = v3
                                                            v2.pass = v1
                                                            v4 = u6
                                                            v4.passes = v4.passes + 1
                                                            if u770 > 0
                                                                and u6.passes % u770 == 0
                                                                and yield ~= nil then
                                                                yield()
                                                            end
                                                            flow(n.leaf, v2)
                                                        end
                                                    end
                                                end
                                            end
                                        else
                                            v2.source = v13.source
                                            v2.pass = v1
                                            v3 = u6
                                            v3.passes = v3.passes + 1
                                            flow(n.leaf, v2)
                                        end
                                    end
                                else
                                    v1 = math.abs(n.d + v13.d)
                                    if not (v1 < 0.05) then
                                        v1 = Winding.clip(n.w, a2.nx, a2.ny, a2.nz, a2.d, 0.05)
                                        if v1 ~= nil then
                                            v2 = {
                                                portal = n,
                                                nx = n.nx,
                                                ny = n.ny,
                                                nz = n.nz,
                                                d = n.d,
                                                mightsee = v7,
                                            }
                                            if v13.pass ~= nil then
                                                v1 = Winding.clip(v1, v13.nx, v13.ny, v13.nz, v13.d, 0.05)
                                                if v1 ~= nil then
                                                    v3 = Winding.clip(v13.source, -n.nx, -n.ny, -n.nz, -n.d, 0.05)
                                                    if v3 ~= nil then
                                                        v1 = clipToSeparators(v3, v13.pass, v1, false)
                                                        if v1 ~= nil then
                                                            v1 = clipToSeparators(v13.pass, v3, v1, true)
                                                            if v1 ~= nil then
                                                                v2.source = v3
                                                                v2.pass = v1
                                                                v4 = u6
                                                                v4.passes = v4.passes + 1
                                                                if u770 > 0
                                                                    and u6.passes % u770 == 0
                                                                    and yield ~= nil then
                                                                    yield()
                                                                end
                                                                flow(n.leaf, v2)
                                                            end
                                                        end
                                                    end
                                                end
                                            else
                                                v2.source = v13.source
                                                v2.pass = v1
                                                v3 = u6
                                                v3.passes = v3.passes + 1
                                                flow(n.leaf, v2)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                flow(a1_2, a2)
                local v1 = u774
                v1.floods = v1.floods + 1
                v1 = u774
                v1.passes = v1.passes + u6.passes
                if u6.budgeted then
                    local mightsee, v2
                    v1 = u774
                    v1.budgeted = v1.budgeted + 1
                    v1 = #a1.airLeaves
                    for i = 1, v1 do
                        mightsee = a2.mightsee
                        v2 = (i - 1) // 32 * 4
                        if bit32.band(buffer.readu32(mightsee, v2), (bit32.lshift(1, (i - 1) % 32))) ~= 0 then
                            for j, k in u764[i] do
                                if not u779[k.cell] then
                                    mark(k)
                                end
                            end
                        end
                    end
                end
            end

            function interiorFace(a1, a2) -- Line: 549 -- upvalues: u765 (val), i6 (val), Winding (upval)
                local v1 = u765[i6]
                local v2 = nil
                local v3 = nil
                local v4, v5 = a2, a1
                for i, j in v1, v2, v3 do
                    if j ~= v4 then
                        for k, n in j.faces do
                            if not (-0.9999 < v5.nx * n.nx + v5.ny * n.ny + v5.nz * n.nz)
                                and not (0.01 < (math.abs(v5.d + n.d)))
                                and Winding.contains(n.w, n.nx, n.ny, n.nz, v5.w, 0.01) then
                                return true
                            end
                        end
                    end
                end
                return false
            end

            v5 = u765[i6]
            v6 = nil
            v7 = nil
            for i33, i34 in v5, v6, v7 do
                for i35, i36 in u764[i34.leaf] do
                    if not u779[i36.cell] then
                        mark(i36)
                    end
                end
                v9 = a1.airLeaves[i34.leaf]
                v10 = nil
                v11 = nil
                for i37, i38 in i34.faces, v10, v11 do
                    if not interiorFace(i38, i34) then
                        v12 = {}
                        v13 = leafPortals[i34.leaf]
                        v14 = nil
                        v15 = nil
                        for i39, i40 in v13, v14, v15 do
                            v18 = false
                            if 0.9999 < i38.nx * i40.nx + i38.ny * i40.ny + i38.nz * i40.nz then
                                v18 = (math.abs(i38.d - i40.d)) < 0.05
                            end
                            if v18 then
                                v12[#v12 + 1] = i40
                            end
                        end
                        v13 = false
                        v15 = nil
                        v16 = nil
                        for i41, i42 in v9.planes, v15, v16 do
                            v19 = false
                            if 0.9999 < i38.nx * i42[1] + i38.ny * i42[2] + i38.nz * i42[3] then
                                v19 = (math.abs(i38.d - i42[4])) < 0.05
                            end
                            if v19 then
                                v13 = true
                                break
                            end
                        end
                        if not v13 then
                            if not (#v12 > 0) then
                                v14 = buffer.create(leafWords * 4)
                                v15 = leafPortals[i34.leaf]
                                v16 = nil
                                v17 = nil
                                for i43, i44 in v15, v16, v17 do
                                    _, v20 = Winding.range(i44.w, i38.nx, i38.ny, i38.nz, i38.d)
                                    if v20 > 0.05 then
                                        v21 = leafWords * 4 - 4
                                        for i45 = 0, v21, 4 do
                                            v23 = buffer.readu32(v14, i45)
                                            mightsee = i44.mightsee
                                            v22 = bit32.bor(v23, (buffer.readu32(mightsee, i45)))
                                            buffer.writeu32(v14, i45, v22)
                                        end
                                    end
                                end
                                floodFace(i34.leaf, {
                                    source = i38.w,
                                    nx = i38.nx,
                                    ny = i38.ny,
                                    nz = i38.nz,
                                    d = i38.d,
                                    mightsee = v14,
                                })
                            else
                                for i46, i47 in v12 do
                                    floodFace(i47.leaf, {
                                        source = i38.w,
                                        nx = i38.nx,
                                        ny = i38.ny,
                                        nz = i38.nz,
                                        d = i38.d,
                                        mightsee = i47.mightsee,
                                    })
                                end
                            end
                        elseif #v12 ~= 0 then
                            if not (#v12 > 0) then
                                v14 = buffer.create(leafWords * 4)
                                v15 = leafPortals[i34.leaf]
                                v16 = nil
                                v17 = nil
                                for i48, i49 in v15, v16, v17 do
                                    _, v20 = Winding.range(i49.w, i38.nx, i38.ny, i38.nz, i38.d)
                                    if v20 > 0.05 then
                                        v21 = leafWords * 4 - 4
                                        for i50 = 0, v21, 4 do
                                            v23 = buffer.readu32(v14, i50)
                                            mightsee = i49.mightsee
                                            v22 = bit32.bor(v23, (buffer.readu32(mightsee, i50)))
                                            buffer.writeu32(v14, i50, v22)
                                        end
                                    end
                                end
                                floodFace(i34.leaf, {
                                    source = i38.w,
                                    nx = i38.nx,
                                    ny = i38.ny,
                                    nz = i38.nz,
                                    d = i38.d,
                                    mightsee = v14,
                                })
                            else
                                for i51, i52 in v12 do
                                    floodFace(i52.leaf, {
                                        source = i38.w,
                                        nx = i38.nx,
                                        ny = i38.ny,
                                        nz = i38.nz,
                                        d = i38.d,
                                        mightsee = i52.mightsee,
                                    })
                                end
                            end
                        end
                    else
                        u774.interior = u774.interior + 1
                    end
                end
            end
            v2[i6] = u779
            if a4 ~= nil then
                a4(i6, #v24, u774)
            end
        end
    end
    return v2, u774
end

function v1.floodOrder(a1) -- Line: 649
    local v1 = table.clone(a1.portals)
    table.sort(v1, function(a1, a2) -- Line: 651
        if a1.numMightsee ~= a2.numMightsee then
            return a1.numMightsee < a2.numMightsee
        end
        return a1.id < a2.id
    end)
    return v1
end

return v1