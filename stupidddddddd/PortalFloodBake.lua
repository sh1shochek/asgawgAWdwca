-- ReplicatedStorage.Visibility.PortalVis.PortalFloodBake
-- Script path: ReplicatedStorage.Visibility.PortalVis.PortalFloodBake
-- Decompile time: 20.45 ms

require(script.Parent:WaitForChild("Winding"))
local Brush = require(script.Parent:WaitForChild("Brush"))
local BSP = require(script.Parent:WaitForChild("BSP"))
local Portals = require(script.Parent:WaitForChild("Portals"))
local Vis = require(script.Parent:WaitForChild("Vis"))
local u40 = {}
u40.DEFAULTS = table.freeze({
    pad = 3,
    padDown = 0,
    padUp = 1,
    band = 13,
    domainPad = 3,
    ground = true,
})
local u44 = {{1, 3, 4}, {1, 4, 2}, {2, 4, 6}, {2, 6, 5}, {1, 5, 6}, {1, 6, 3}, {1, 2, 5}, {3, 6, 4}}
local u77 = {{1, 3, 4}, {1, 4, 2}, {3, 4, 5}, {1, 3, 5}, {1, 5, 2}, {2, 5, 4}}

local function world(a1, a2, a3, a4) -- Line: 31
    local v1 = a1:PointToWorldSpace((Vector3.new(a2, a3, a4)))
    return {v1.X, v1.Y, v1.Z}
end

local function boxPlanes(a1, a2, a3, a4, a5, a6) -- Line: 36
    local v1 = {}
    local v2 = {-1, 0, 0, -a1}
    local v3 = {0, -1, 0, -a2}
    local v4 = {0, 0, -1, -a3}
    v1[1] = {1, 0, 0, a4}
    v1[2] = v2
    v1[3] = {0, 1, 0, a5}
    v1[4] = v3
    v1[5] = {0, 0, 1, a6}
    v1[6] = v4
    return v1
end

function u40.planesForPart(a1) -- Line: 48 -- upvalues: Brush (val), u44 (val), u77 (val)
    local v1, v2, v3, v4, v5, v6
    local CFrame = a1.CFrame
    local v7 = a1.Size * 0.5
    local X = v7.X
    local Y = v7.Y
    local Z = v7.Z
    local v8 = nil
    if a1:IsA("WedgePart") then
        v8 = "Wedge"
    else
        local Shape
        if not a1:IsA("Part") then
            if a1:IsA("CornerWedgePart") then
                v8 = "CornerWedge"
            elseif not a1:IsA("Part") then
                if a1:IsA("Part") then
                    Shape = a1.Shape
                    if Shape == Enum.PartType.Block then
                        v8 = "Block"
                    elseif Shape == Enum.PartType.Cylinder then
                        v8 = "Cylinder"
                    elseif Shape == Enum.PartType.Ball then
                        v8 = "Ball"
                    end
                end
            elseif a1.Shape == Enum.PartType.CornerWedge then
                v8 = "CornerWedge"
            elseif a1:IsA("Part") then
                Shape = a1.Shape
                if Shape == Enum.PartType.Block then
                    v8 = "Block"
                elseif Shape == Enum.PartType.Cylinder then
                    v8 = "Cylinder"
                elseif Shape == Enum.PartType.Ball then
                    v8 = "Ball"
                end
            end
        elseif a1.Shape == Enum.PartType.Wedge then
            v8 = "Wedge"
        elseif a1:IsA("CornerWedgePart") then
            v8 = "CornerWedge"
        elseif not a1:IsA("Part") then
            if a1:IsA("Part") then
                Shape = a1.Shape
                if Shape == Enum.PartType.Block then
                    v8 = "Block"
                elseif Shape == Enum.PartType.Cylinder then
                    v8 = "Cylinder"
                elseif Shape == Enum.PartType.Ball then
                    v8 = "Ball"
                end
            end
        elseif a1.Shape == Enum.PartType.CornerWedge then
            v8 = "CornerWedge"
        elseif a1:IsA("Part") then
            Shape = a1.Shape
            if Shape == Enum.PartType.Block then
                v8 = "Block"
            elseif Shape == Enum.PartType.Cylinder then
                v8 = "Cylinder"
            elseif Shape == Enum.PartType.Ball then
                v8 = "Ball"
            end
        end
    end
    if v8 ~= "Block" then
        local v9, v10, v11, v12, v13, v14
        if v8 == "Wedge" then
            v12 = {}
            v11 = CFrame:PointToWorldSpace((Vector3.new(-X, -Y, -Z)))
            v13 = {v11.X, v11.Y, v11.Z}
            v11 = CFrame:PointToWorldSpace((Vector3.new(-X, -Y, Z)))
            v14 = {v11.X, v11.Y, v11.Z}
            v1 = CFrame:PointToWorldSpace((Vector3.new(X, -Y, -Z)))
            v9 = {v1.X, v1.Y, v1.Z}
            v1 = CFrame:PointToWorldSpace((Vector3.new(X, -Y, Z)))
            v10 = {v1.X, v1.Y, v1.Z}
            v2 = CFrame:PointToWorldSpace((Vector3.new(-X, Y, Z)))
            v11 = {v2.X, v2.Y, v2.Z}
            v2 = CFrame:PointToWorldSpace((Vector3.new(X, Y, Z)))
            v1 = {v2.X, v2.Y, v2.Z}
            v12[1] = v13
            v12[2] = v14
            v12[3] = v9
            v12[4] = v10
            v12[5] = v11
            v12[6] = v1
            return v8, Brush.planesFromMesh(v12, u44)
        end
        if v8 == "CornerWedge" then
            v12 = {}
            v11 = CFrame:PointToWorldSpace((Vector3.new(-X, -Y, -Z)))
            v13 = {v11.X, v11.Y, v11.Z}
            v11 = CFrame:PointToWorldSpace((Vector3.new(-X, -Y, Z)))
            v14 = {v11.X, v11.Y, v11.Z}
            v1 = CFrame:PointToWorldSpace((Vector3.new(X, -Y, -Z)))
            v9 = {v1.X, v1.Y, v1.Z}
            v1 = CFrame:PointToWorldSpace((Vector3.new(X, -Y, Z)))
            v10 = {v1.X, v1.Y, v1.Z}
            v2 = CFrame:PointToWorldSpace((Vector3.new(X, Y, -Z)))
            v11 = {v2.X, v2.Y, v2.Z}
            v12[1] = v13
            v12[2] = v14
            v12[3] = v9
            v12[4] = v10
            v12[5] = v11
            return v8, Brush.planesFromMesh(v12, u77)
        end
        if v8 == "Cylinder" then
            v12 = math.min(Y, Z)
            v13 = {}
            v14 = {}
            for i = 0, 11 do
                v1 = i / 12 * 3.141592653589793 * 2
                v2 = math.cos(v1) * v12
                v3 = math.sin(v1) * v12
                v4 = i * 2 + 1
                v6 = CFrame:PointToWorldSpace((Vector3.new(-X, v2, v3)))
                v13[v4] = {v6.X, v6.Y, v6.Z}
                v4 = i * 2 + 2
                v5 = CFrame:PointToWorldSpace((Vector3.new(X, v2, v3)))
                v13[v4] = {v5.X, v5.Y, v5.Z}
            end
            for j = 0, 11 do
                v1 = (j + 1) % 12
                v14[#v14 + 1] = {j * 2 + 1, v1 * 2 + 1, v1 * 2 + 2}
            end
            v14[#v14 + 1] = {1, 3, 5}
            v14[#v14 + 1] = {2, 6, 4}
            return v8, Brush.planesFromMesh(v13, v14)
        end
        return v8, nil
    end
    local Position = CFrame.Position
    local RightVector = CFrame.RightVector
    local UpVector = CFrame.UpVector
    local LookVector = CFrame.LookVector

    local function plane(a1, a2, a3, a4) -- Line: 70 -- upvalues: Position (val)
        local v1 = {}
        local v2 = a1 * Position.X + a2 * Position.Y
        v1[1] = a1
        v1[2] = a2
        v1[3] = a3
        v1[4] = v2 + a3 * Position.Z + a4
        return v1
    end

    v1 = {}
    local X_2 = RightVector.X
    local Y_2 = RightVector.Y
    local Z_2 = RightVector.Z
    v2 = {}
    local v15 = X_2 * Position.X + Y_2 * Position.Y
    v2[1] = X_2
    v2[2] = Y_2
    v2[3] = Z_2
    v2[4] = v15 + Z_2 * Position.Z + X
    v4 = -RightVector.X
    local v16 = -RightVector.Y
    v5 = -RightVector.Z
    v3 = {}
    local v17 = v4 * Position.X + v16 * Position.Y
    v3[1] = v4
    v3[2] = v16
    v3[3] = v5
    v3[4] = v17 + v5 * Position.Z + X
    local X_3 = UpVector.X
    local Y_3 = UpVector.Y
    local Z_3 = UpVector.Z
    v4 = {}
    local v18 = X_3 * Position.X + Y_3 * Position.Y
    v4[1] = X_3
    v4[2] = Y_3
    v4[3] = Z_3
    v4[4] = v18 + Z_3 * Position.Z + Y
    v5 = -UpVector.X
    v6 = -UpVector.Y
    local v19 = -UpVector.Z
    v16 = {}
    local v20 = v5 * Position.X + v6 * Position.Y
    v16[1] = v5
    v16[2] = v6
    v16[3] = v19
    v16[4] = v20 + v19 * Position.Z + Y
    v6 = -LookVector.X
    v19 = -LookVector.Y
    local v21 = -LookVector.Z
    v5 = {}
    local v22 = v6 * Position.X + v19 * Position.Y
    v5[1] = v6
    v5[2] = v19
    v5[3] = v21
    v5[4] = v22 + v21 * Position.Z + Z
    local X_4 = LookVector.X
    local Y_4 = LookVector.Y
    local Z_4 = LookVector.Z
    v6 = {}
    local v23 = X_4 * Position.X + Y_4 * Position.Y
    v6[1] = X_4
    v6[2] = Y_4
    v6[3] = Z_4
    v6[4] = v23 + Z_4 * Position.Z + Z
    v1[1] = v2
    v1[2] = v3
    v1[3] = v4
    v1[4] = v16
    v1[5] = v5
    v1[6] = v6
    return v8, v1
end

function u40.buildGraph(a1, a2, a3) -- Line: 122
    -- upvalues: u40 (val), Brush (val), boxPlanes (val), BSP (val), Portals (val), Vis (val)
    local domainPad, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
    local v15 = {}
    local DEFAULTS = u40.DEFAULTS
    local v16 = nil
    local v17 = nil
    local v18, v19, v20 = a3, a1, a2
    for i, j in DEFAULTS, v16, v17 do
        v14 = if v18 == nil then j else if v18[i] == nil then j else v18[i]
        v15[i] = v14
    end
    local yield = if v18 == nil then nil else v18.yield
    v16 = os.clock()
    v17 = {brushes = 0, unsupported = 0, degenerate = 0, groundBrushes = 0}
    local v21 = {}
    v14 = nil
    local v22 = nil
    for k, n in v19, v14, v22 do
        if yield ~= nil and k % 8 == 0 then
            yield()
        end
        _, v1 = u40.planesForPart(n)
        if v1 ~= nil then
            v2 = Brush.fromPlanes(v1, #v21 + 1, n.Name)
            if v2 ~= nil then
                v21[#v21 + 1] = v2
            else
                v17.degenerate = v17.degenerate + 1
            end
        else
            v17.unsupported = v17.unsupported + 1
        end
    end
    v17.brushes = #v21
    if #v21 == 0 then
        return nil, "NoBrushes"
    end
    local pad = v15.pad
    v14 = (1 / 0)
    v22 = (1 / 0)
    local v23 = (1 / 0)
    local v24 = (-1 / 0)
    local v25 = (-1 / 0)
    v1 = (-1 / 0)
    v2 = {}
    for m, i5 in v20.regions do
        v4 = {
            cluster = i5.cluster,
            minX = i5.minimum.X - pad,
            minY = i5.minimum.Y - v15.padDown,
            minZ = i5.minimum.Z - pad,
            maxX = i5.maximum.X + pad,
            maxY = (math.min(i5.maximum.Y, i5.minimum.Y + v15.band)) + v15.padUp,
            maxZ = i5.maximum.Z + pad,
        }
        v2[m] = v4
        domainPad = v15.domainPad
        v14 = math.min(v14, i5.minimum.X - domainPad)
        v22 = math.min(v22, i5.minimum.Y - 2)
        v23 = math.min(v23, i5.minimum.Z - domainPad)
        v24 = math.max(v24, i5.maximum.X + domainPad)
        v25 = math.max(v25, i5.maximum.Y + 2)
        v1 = math.max(v1, i5.maximum.Z + domainPad)
    end
    local v26 = boxPlanes(v14, v22, v23, v24, v25, v1)
    if v15.ground then
        for i6, i7 in v20.regions do
            v5 = i7.minimum.Y + 0.25 - 0.5
            v21[#v21 + 1] = (Brush.fromPlanes(boxPlanes(i7.minimum.X, v22 - 1, i7.minimum.Z, i7.maximum.X, v5, i7.maximum.Z), #v21 + 1, "ground"))
            v17.groundBrushes = v17.groundBrushes + 1
            if i7.maximum.Y - i7.minimum.Y < 95 then
                v21[#v21 + 1] = (Brush.fromPlanes(
                    boxPlanes(i7.minimum.X, i7.maximum.Y + 0.25, i7.minimum.Z, i7.maximum.X, v25 + 1, i7.maximum.Z),
                    #v21 + 1,
                    "ceiling"
                ))
                v17.groundBrushes = v17.groundBrushes + 1
            end
        end
    end
    local v27 = {}
    local v28 = nil
    local v29 = nil
    for i8, i9 in v21, v28, v29 do
        v6 = i9
        for i10, i11 in v26 do
            if v6 == nil then
                break
            end
            _, v7 = Brush.split(v6, i11[1], i11[2], i11[3], i11[4])
            v6 = v7
        end
        if v6 ~= nil then
            v27[#v27 + 1] = v6
        end
        if yield ~= nil and i8 % 2 == 0 then
            yield()
        end
    end
    v17.clipped = #v27
    v3, v28, v29 = BSP.build(v27, v26, yield)
    v17.bsp = v29
    v4, v5 = Portals.build(v3, v28, v14, v22, v23, v24, v25, v1, yield)
    v17.portals = v5
    v6 = Vis.prepare(v4, v28, yield)
    v17.directedPortals = #v6.portals
    v17.airLeaves = #v6.airLeaves
    local v30 = #v20.cells
    local v31 = table.create(v30, false)
    local v32 = {}
    local v33 = 0
    local v34 = nil
    v7 = nil
    for i12, i13 in v2, v34, v7 do
        v8 = boxPlanes(i13.minX, i13.minY, i13.minZ, i13.maxX, i13.maxY, i13.maxZ)
        v9 = nil
        v10 = nil
        for i14, i15 in v6.airLeaves, v9, v10 do
            if BSP.leafTouchesBox(i15, i13.minX, i13.minY, i13.minZ, i13.maxX, i13.maxY, i13.maxZ, 0.01) then
                v11 = table.clone(i15.planes)
                v13 = nil
                for i16, i17 in v8, v13 do
                    v11[#v11 + 1] = i17
                end
                v12 = Brush.fromPlanes(v11, 0, "volume")
                if v12 ~= nil then
                    v13 = {}
                    for i18, i19 in v12.sides do
                        v13[#v13 + 1] = {
                            w = i19.w,
                            nx = i19.nx,
                            ny = i19.ny,
                            nz = i19.nz,
                            d = i19.d,
                        }
                    end
                    v33 = v33 + #v13
                    v32[#v32 + 1] = {cell = i13.cluster, leaf = i15.airIndex, faces = v13}
                    v31[i13.cluster] = true
                end
            end
        end
        if yield ~= nil then
            yield()
        end
    end
    v17.volumes = #v32
    v17.faces = v33
    v17.buildSeconds = os.clock() - v16
    return {
        state = v6,
        volumes = v32,
        cellCount = v30,
        cellHasVolume = v31,
        clipped = v27,
        root = v3,
        leaves = v28,
        domain = {v14, v22, v23, v24, v25, v1},
        stats = v17,
    }
end

local function writeWinding(a1, a2, a3) -- Line: 288
    local v1
    local v2 = #a3
    buffer.writeu32(a1, a2, v2)
    local v3 = a2 + 4
    local v4 = #a3
    for i = 1, v4 do
        v1 = a3[i]
        buffer.writef64(a1, v3, v1)
        v3 = v3 + 8
    end
    return v3
end

local function readWinding(a1, a2) -- Line: 298
    local v1 = buffer.readu32(a1, a2)
    local v2 = a2 + 4
    local v3 = table.create(v1)
    for i = 1, v1 do
        v3[i] = (buffer.readf64(a1, v2))
        v2 = v2 + 8
    end
    return v3, v2
end

function u40.encodeGraph(a1, a2) -- Line: 310
    local from, leaf, v1, v2, v3, v4, v5, v6, w
    local v7 = 8
    for i, j in a1.portals do
        v7 = v7 + (#j.w * 8 + 92)
    end
    for k, n in a1.airLeaves do
        v7 = v7 + (#n.planes * 32 + 4)
    end
    local v8 = buffer.create(v7)
    local v9 = #a1.airLeaves
    buffer.writeu32(v8, 0, v9)
    v9 = #a1.portals
    buffer.writeu32(v8, 4, v9)
    local v10 = 8
    local portals_3 = a1.portals
    local v11 = nil
    v9 = nil
    local v12, v13 = a1, a2
    for m, i5 in portals_3, v11, v9 do
        if v13 ~= nil and m % 256 == 0 then
            v13()
        end
        from = i5.from
        buffer.writeu32(v8, v10, from)
        v2 = v10 + 4
        leaf = i5.leaf
        buffer.writeu32(v8, v2, leaf)
        v10 = v10 + 8
        for i6, i7 in {
            i5.nx,
            i5.ny,
            i5.nz,
            i5.d,
            i5.minX,
            i5.minY,
            i5.minZ,
            i5.maxX,
            i5.maxY,
            i5.maxZ,
        } do
            buffer.writef64(v8, v10, i7)
            v10 = v10 + 8
        end
        w = i5.w
        v4 = #w
        buffer.writeu32(v8, v10, v4)
        v10 = v10 + 4
        v1 = #w
        for i8 = 1, v1 do
            v5 = w[i8]
            buffer.writef64(v8, v10, v5)
            v10 = v10 + 8
        end
    end
    v11 = nil
    v9 = nil
    for i9, i10 in v12.airLeaves, v11, v9 do
        v3 = #i10.planes
        buffer.writeu32(v8, v10, v3)
        v10 = v10 + 4
        for i11, i12 in i10.planes do
            v6 = i12[1]
            buffer.writef64(v8, v10, v6)
            v10 = v10 + 8
            v6 = i12[2]
            buffer.writef64(v8, v10, v6)
            v10 = v10 + 8
            v6 = i12[3]
            buffer.writef64(v8, v10, v6)
            v10 = v10 + 8
            v6 = i12[4]
            buffer.writef64(v8, v10, v6)
            v10 = v10 + 8
        end
    end
    return v8
end

function u40.decodeGraph(a1, a2) -- Line: 348
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13
    local v14 = buffer.readu32(a1, 0)
    local v15 = buffer.readu32(a1, 4)
    local v16 = 8
    local v17 = table.create(v15)
    local v18 = table.create(v14)
    for i = 1, v14 do
        v18[i] = {}
    end
    for j = 1, v15 do
        if a2 ~= nil and j % 256 == 0 then
            a2()
        end
        v1 = buffer.readu32(a1, v16)
        v4 = v16 + 4
        v2 = buffer.readu32(a1, v4)
        v16 = v16 + 8
        v3 = table.create(10)
        for k = 1, 10 do
            v3[k] = (buffer.readf64(a1, v16))
            v16 = v16 + 8
        end
        v7 = v16
        v8 = buffer.readu32(a1, v7)
        v7 = v7 + 4
        v9 = table.create(v8)
        for n = 1, v8 do
            v9[n] = (buffer.readf64(a1, v7))
            v7 = v7 + 8
        end
        v16 = v7
        v5 = {
            done = false,
            id = j,
            from = v1,
            leaf = v2,
            nx = v3[1],
            ny = v3[2],
            nz = v3[3],
            d = v3[4],
            minX = v3[5],
            minY = v3[6],
            minZ = v3[7],
            maxX = v3[8],
            maxY = v3[9],
            maxZ = v3[10],
            w = v9,
        }
        v17[j] = v5
        v6 = v18[v1]
        v6[#v6 + 1] = v5
    end
    local v19 = table.create(v14)
    for m = 1, v14 do
        v2 = buffer.readu32(a1, v16)
        v16 = v16 + 4
        v3 = table.create(v2)
        for i5 = 1, v2 do
            v7 = {}
            v8 = buffer.readf64(a1, v16)
            v11 = v16 + 8
            v9 = buffer.readf64(a1, v11)
            v12 = v16 + 16
            v10 = buffer.readf64(a1, v12)
            v13 = v16 + 24
            v7[1] = v8
            v7[2] = v9
            v7[3] = v10
            v7[4] = (buffer.readf64(a1, v13))
            v3[i5] = v7
            v16 = v16 + 32
        end
        v19[m] = {air = true, leaf = true, airIndex = m, planes = v3}
    end
    return {portals = v17, leafPortals = v18, airLeaves = v19, leafWords = (v14 + 31) // 32}
end

function u40.encodeFronts(a1, a2, a3) -- Line: 412
    local v1 = (#a1.portals + 31) // 32
    local v2 = a3 - a2 + 1
    local v3 = buffer.create(8 + v2 * v1 * 4)
    buffer.writeu32(v3, 0, a2)
    buffer.writeu32(v3, 4, a3)
    local v4 = 8
    for i = a2, a3 do
        buffer.copy(v3, v4, a1.portals[i].front)
        v4 = v4 + v1 * 4
    end
    return v3
end

function u40.applyFronts(a1, a2) -- Line: 426
    local v1
    local v2 = (#a1.portals + 31) // 32
    a1.portalWords = v2
    local v3 = buffer.readu32(a2, 0)
    local v4 = buffer.readu32(a2, 4)
    local v5 = 8
    for i = v3, v4 do
        v1 = buffer.create(v2 * 4)
        buffer.copy(v1, 0, a2, v5, v2 * 4)
        a1.portals[i].front = v1
        v5 = v5 + v2 * 4
    end
    return v3, v4
end

function u40.encodeMightsee(a1, a2) -- Line: 442
    local numMightsee
    local v1 = a1.leafWords * 4
    local v2 = buffer.create(#a1.portals * (v1 + 4))
    local v3 = 0
    local v4 = nil
    local v5 = nil
    local v6 = a2
    for i, j in a1.portals, v4, v5 do
        if v6 ~= nil and i % 512 == 0 then
            v6()
        end
        numMightsee = j.numMightsee
        buffer.writeu32(v2, v3, numMightsee or 0)
        buffer.copy(v2, v3 + 4, j.mightsee)
        v3 = v3 + (4 + v1)
    end
    return v2
end

function u40.decodeMightsee(a1, a2, a3) -- Line: 457
    local v1
    local v2 = a1.leafWords * 4
    local v3 = 0
    local v4 = nil
    local v5 = nil
    local v6 = a3
    for i, j in a1.portals, v4, v5 do
        if v6 ~= nil and i % 512 == 0 then
            v6()
        end
        j.numMightsee = buffer.readu32(v7, v3)
        v1 = buffer.create(v2)
        buffer.copy(v1, 0, v7, v3 + 4, v2)
        j.mightsee = v1
        v3 = v3 + (4 + v2)
    end
end

function u40.encodeVolumes(a1, a2) -- Line: 472
    local cell, d, leaf, nx, ny, nz, v1, v2, v3, v4, v5, v6, v7, w
    local v8 = 4
    local v9 = nil
    local v10 = nil
    local v11, v12 = a1, a2
    for i, j in a1, v9, v10 do
        v8 = v8 + 12
        for k, n in j.faces do
            v8 = v8 + (#n.w * 8 + 36)
        end
    end
    local v13 = buffer.create(v8)
    local v14 = #v11
    buffer.writeu32(v13, 0, v14)
    v9 = 4
    local v15 = nil
    v14 = nil
    for m, i5 in v11, v15, v14 do
        if v12 ~= nil and m % 128 == 0 then
            v12()
        end
        cell = i5.cell
        buffer.writeu32(v13, v9, cell)
        v2 = v9 + 4
        leaf = i5.leaf
        buffer.writeu32(v13, v2, leaf)
        v2 = v9 + 8
        v3 = #i5.faces
        buffer.writeu32(v13, v2, v3)
        v9 = v9 + 12
        v1 = nil
        v2 = nil
        for i6, i7 in i5.faces, v1, v2 do
            nx = i7.nx
            buffer.writef64(v13, v9, nx)
            v5 = v9 + 8
            ny = i7.ny
            buffer.writef64(v13, v5, ny)
            v5 = v9 + 16
            nz = i7.nz
            buffer.writef64(v13, v5, nz)
            v5 = v9 + 24
            d = i7.d
            buffer.writef64(v13, v5, d)
            v9 = v9 + 32
            w = i7.w
            v6 = #w
            buffer.writeu32(v13, v9, v6)
            v9 = v9 + 4
            v4 = #w
            for i8 = 1, v4 do
                v7 = w[i8]
                buffer.writef64(v13, v9, v7)
                v9 = v9 + 8
            end
        end
    end
    return v13
end

function u40.decodeVolumes(a1, a2) -- Line: 503
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15
    local v16 = buffer.readu32(a1, 0)
    local v17 = 4
    local v18 = table.create(v16)
    local v19 = a2
    for i = 1, v16 do
        if v19 ~= nil and i % 128 == 0 then
            v19()
        end
        v14 = buffer.readu32(v1, v17)
        v3 = v17 + 4
        v15 = buffer.readu32(v1, v3)
        v4 = v17 + 8
        v2 = buffer.readu32(v1, v4)
        v17 = v17 + 12
        v3 = table.create(v2)
        for j = 1, v2 do
            v5 = buffer.readf64(v1, v17)
            v10 = v17 + 8
            v6 = buffer.readf64(v1, v10)
            v10 = v17 + 16
            v7 = buffer.readf64(v1, v10)
            v9 = v17 + 24
            v8 = buffer.readf64(v1, v9)
            v11 = v17 + 32
            v12 = buffer.readu32(v1, v11)
            v11 = v11 + 4
            v13 = table.create(v12)
            for k = 1, v12 do
                v13[k] = (buffer.readf64(v1, v11))
                v11 = v11 + 8
            end
            v3[j] = {
                w = v13,
                nx = v5,
                ny = v6,
                nz = v7,
                d = v8,
            }
        end
        v18[i] = {cell = v14, leaf = v15, faces = v3}
    end
    return v18
end

function u40.encodeRow(a1, a2) -- Line: 533
    local v1 = {}
    for i in a2 do
        v1[#v1 + 1] = i
    end
    table.sort(v1)
    return a1 .. ":" .. table.concat(v1, " ")
end

function u40.decodeRow(a1) -- Line: 542
    local v1, v2 = string.match(a1, "^(%d+):(.*)$")
    local v3 = {}
    for i in string.gmatch(v2 or "", "%d+") do
        v3[(tonumber(i))] = true
    end
    return (tonumber(v1)), v3
end

local function regionGap(a1, a2) -- Line: 552
    local v1 = math.max(a2.minimum.X - a1.maximum.X, a1.minimum.X - a2.maximum.X, 0)
    local v2 = math.max(a2.minimum.Y - a1.maximum.Y, a1.minimum.Y - a2.maximum.Y, 0)
    local v3 = math.max(a2.minimum.Z - a1.maximum.Z, a1.minimum.Z - a2.maximum.Z, 0)
    return (math.sqrt(v1 * v1 + v2 * v2 + v3 * v3))
end

function u40.applyVisibility(a1, a2, a3, a4, a5) -- Line: 560 -- upvalues: regionGap (val)
    local regions, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
    local v11 = #a1.cells
    local v12 = a2.getRowStride(v11)
    local v13 = a2.newVisibilityBuffer(v11)
    local v14 = {
        pairs = 0,
        visible = 0,
        near = 0,
        failOpen = 0,
        floodOnly = 0,
        sampledOnly = 0,
    }
    local v15 = a5
    for i = 1, v11 do
        if v15 ~= nil then
            v15()
        end
        v2.setVisible(v13, v12, i, i)
        for j = i + 1, v11 do
            v14.pairs = v14.pairs + 1
            v3 = v2.isVisible(v1, i, j) or v2.isVisible(v1, j, i)
            if v7[i] == nil then
                v4 = false
                if v7[j] ~= nil then
                    v4 = v7[j][i] == true
                end
            else
                v4 = true
                if v7[i][j] ~= true then
                    v4 = false
                    if v7[j] ~= nil then
                        v4 = v7[j][i] == true
                    end
                end
            end
            v5 = v3 or v4
            if not v5 then
                v6 = (1 / 0)
                regions = v1.cells[i].regions or {}
                v8 = nil
                v9 = nil
                for k, n in regions, v8, v9 do
                    for m, i5 in v1.cells[j].regions or {} do
                        v6 = math.min(v6, (regionGap(n, i5)))
                    end
                end
                if v6 <= v1.nearDistance then
                    v5 = true
                    v14.near = v14.near + 1
                elseif not v10[i] or not v10[j] then
                    v5 = true
                    v14.failOpen = v14.failOpen + 1
                end
            end
            if not v4 then
                if v3 and not v4 then
                    v14.sampledOnly = v14.sampledOnly + 1
                end
            elseif not v3 then
                v14.floodOnly = v14.floodOnly + 1
            elseif v3 and not v4 then
                v14.sampledOnly = v14.sampledOnly + 1
            end
            if v5 then
                v2.setVisible(v13, v12, i, j)
                v2.setVisible(v13, v12, j, i)
                v14.visible = v14.visible + 1
            end
        end
    end
    return (buffer.tostring(v13)), v14
end

return table.freeze(u40)