-- ReplicatedStorage.Visibility.PortalVis.BSP
-- Script path: ReplicatedStorage.Visibility.PortalVis.BSP
-- Decompile time: 3.24 ms

local Winding = require(script.Parent:WaitForChild("Winding"))
local Brush = require(script.Parent:WaitForChild("Brush"))
local v1 = {}

local function selectSplit(a1) -- Line: 10 -- upvalues: Brush (val), Winding (val)
    local nx, ny, nz, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
    local v11 = nil
    local v12 = (-1 / 0)
    local v13 = {}
    local v14 = nil
    local v15 = nil
    for i, j in a1, v14, v15 do
        v1 = nil
        v2 = nil
        for k, n in j.sides, v1, v2 do
            if not n.used and not v13[n.key] then
                v13[n.key] = true
                v3 = 0
                v4 = 0
                v5 = 0
                v6 = 0
                v8 = nil
                v9 = nil
                for m, i5 in a1, v8, v9 do
                    v10 = Brush.classify(i5, n.nx, n.ny, n.nz, n.d)
                    if v10 == "front" then
                        v3 = v3 + 1
                    elseif v10 ~= "back" then
                        v5 = v5 + 1
                    else
                        v4 = v4 + 1
                    end
                    if i5.keys[n.key] then
                        v6 = v6 + 1
                    end
                end
                v7 = v6 * 5 - v5 * 5 - math.abs(v3 - v4)
                if Winding.isAxial(nx, ny, nz) then
                    v7 = v7 + 5
                end
                if v12 < v7 then
                    v11 = n
                end
            end
        end
    end
    return v11
end

function v1.build(a1, a2, a3) -- Line: 47 -- upvalues: selectSplit (val), Brush (val)
    local build
    local u3 = {}
    local u4 = {
        nodes = 0,
        airLeaves = 0,
        solidLeaves = 0,
        maxDepth = 0,
        splitBrushes = 0,
    }

    local function makeLeaf(a1, a2, a3) -- Line: 51 -- upvalues: u3 (val), u4 (val)
        local v1
        local v2 = {
            leaf = true,
            air = a2,
            planes = a1,
            index = #u3 + 1,
            brushes = a3,
        }
        u3[#u3 + 1] = v2
        if a2 then
            v1 = u4
            v1.airLeaves = v1.airLeaves + 1
            return v2
        end
        v1 = u4
        v1.solidLeaves = v1.solidLeaves + 1
        return v2
    end

    function build(a1, a2, a3_2) -- Line: 62
        -- upvalues: u4 (val), u3 (val), selectSplit (upval), Brush (upval), a3 (val), build (val)
        local v1, v2, v3, v4, v5, v6
        if u4.maxDepth < a3_2 then
            u4.maxDepth = a3_2
        end
        if #a1 == 0 then
            v5 = {
                leaf = true,
                air = true,
                planes = a2,
                index = #u3 + 1,
                brushes = a1,
            }
            u3[#u3 + 1] = v5
            v6 = u4
            v6.airLeaves = v6.airLeaves + 1
            return v5
        end
        v5 = selectSplit(a1)
        if v5 == nil then
            v6 = {
                leaf = true,
                air = false,
                planes = a2,
                index = #u3 + 1,
                brushes = a1,
            }
            u3[#u3 + 1] = v6
            local v7 = u4
            v7.solidLeaves = v7.solidLeaves + 1
            return v6
        end
        local nx = v5.nx
        local ny = v5.ny
        local nz = v5.nz
        local d = v5.d
        local key = v5.key
        local v8 = {}
        local v9 = {}
        local v10 = nil
        local v11 = nil
        local v12, v13 = a2, a3_2
        for i, j in a1, v10, v11 do
            v1 = Brush.classify(j, nx, ny, nz, d)
            if v1 == "front" then
                Brush.markUsed(j, key)
                v8[#v8 + 1] = j
            elseif v1 ~= "back" then
                v2, v3 = Brush.split(j, nx, ny, nz, d)
                v4 = u4
                v4.splitBrushes = v4.splitBrushes + 1
                if v2 ~= nil then
                    Brush.markUsed(v2, key)
                    v8[#v8 + 1] = v2
                end
                if v3 ~= nil then
                    Brush.markUsed(v3, key)
                    v9[#v9 + 1] = v3
                end
            else
                Brush.markUsed(j, key)
                v9[#v9 + 1] = j
            end
        end
        local v14 = u4
        v14.nodes = v14.nodes + 1
        if a3 ~= nil and u4.nodes % 4 == 0 then
            a3()
        end
        v14 = {plane = {nx, ny, nz, d}}
        v10 = table.clone(v12)
        v10[#v10 + 1] = {-nx, -ny, -nz, -d}
        v11 = table.clone(v12)
        v11[#v11 + 1] = {nx, ny, nz, d}
        v14.front = build(v8, v10, v13 + 1)
        v14.back = build(v9, v11, v13 + 1)
        v14.front.parent = v14
        v14.back.parent = v14
        return v14
    end

    return build(a1, table.clone(a2), 0), u3, u4
end

function v1.leafTouchesBox(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 118
    local v1, v2, v3, v4, v5, v6, v7
    local planes = a1.planes
    local v8 = nil
    local v9 = nil
    local v10, v11 = a2, a5
    for i, j in planes, v8, v9 do
        v1 = j[1]
        v2 = j[2]
        v3 = j[3]
        v4 = j[4]
        v6 = (if not (v1 > 0) then v11 else v10) * v1
        v5 = v6 + (if not (v2 > 0) then v12 else v13) * v2
        v7 = if not (v3 > 0) then v14 else v15
        if v16 < v5 + v7 * v3 - v4 then
            return false
        end
    end
    return true
end

return v1