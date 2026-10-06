-- Decompiled with Potassium's decompiler.

require(script.Parent:WaitForChild("Winding"));
local Brush = require(script.Parent:WaitForChild("Brush"));
local BSP = require(script.Parent:WaitForChild("BSP"));
local Portals = require(script.Parent:WaitForChild("Portals"));
local Vis = require(script.Parent:WaitForChild("Vis"));
local u1 = {
    DEFAULTS = table.freeze({
        pad = 3,
        padDown = 0,
        padUp = 1,
        band = 13,
        domainPad = 3,
        ground = true
    })
};
local u2 = { { 1, 3, 4 }, { 1, 4, 2 }, { 2, 4, 6 }, { 2, 6, 5 }, { 1, 5, 6 }, { 1, 6, 3 }, { 1, 2, 5 }, { 3, 6, 4 } };
local u3 = { { 1, 3, 4 }, { 1, 4, 2 }, { 3, 4, 5 }, { 1, 3, 5 }, { 1, 5, 2 }, { 2, 5, 4 } };

local function world(p4, p5, p6, p7) -- Line: 31
    local v8 = p4:PointToWorldSpace((Vector3.new(p5, p6, p7)));

    return { v8.X, v8.Y, v8.Z };
end;

local function boxPlanes(p9, p10, p11, p12, p13, p14) -- Line: 36
    return {
        {
            1,
            0,
            0,
            p12
        },
        {
            -1,
            0,
            0,
            -p9
        },
        {
            0,
            1,
            0,
            p13
        },
        {
            0,
            -1,
            0,
            -p10
        },
        {
            0,
            0,
            1,
            p14
        },
        {
            0,
            0,
            -1,
            -p11
        }
    };
end;

function u1.planesForPart(p15) -- Line: 48
    -- upvalues: Brush (copy), u2 (copy), u3 (copy)
    local CFrame = p15.CFrame;
    local v16 = p15.Size * 0.5;
    local X = v16.X;
    local Y = v16.Y;
    local Z = v16.Z;
    local v17 = nil;

    if p15:IsA("WedgePart") or p15:IsA("Part") and p15.Shape == Enum.PartType.Wedge then
        v17 = "Wedge";
    elseif p15:IsA("CornerWedgePart") or p15:IsA("Part") and p15.Shape == Enum.PartType.CornerWedge then
        v17 = "CornerWedge";
    elseif p15:IsA("Part") then
        local Shape = p15.Shape;
        v17 = Shape == Enum.PartType.Block and "Block" or (Shape == Enum.PartType.Cylinder and "Cylinder" or (Shape == Enum.PartType.Ball and "Ball" or v17));
    end;

    if v17 ~= "Block" then
        if v17 ~= "Wedge" then
            if v17 ~= "CornerWedge" then
                if v17 ~= "Cylinder" then
                    return v17, nil;
                end;

                local math_min_ret = math.min(Y, Z);
                local v18 = {};
                local v19 = {};

                for i = 0, 11 do
                    local v20 = i / 12 * 3.141592653589793 * 2;
                    local v21 = math.cos(v20) * math_min_ret;
                    local v22 = math.sin(v20) * math_min_ret;
                    local v23 = CFrame:PointToWorldSpace((Vector3.new(-X, v21, v22)));
                    v18[i * 2 + 1] = { v23.X, v23.Y, v23.Z };
                    local v24 = CFrame:PointToWorldSpace((Vector3.new(X, v21, v22)));
                    v18[i * 2 + 2] = { v24.X, v24.Y, v24.Z };
                    local _ = i;
                end;

                for i = 0, 11 do
                    local v25 = (i + 1) % 12;
                    v19[#v19 + 1] = { i * 2 + 1, v25 * 2 + 1, v25 * 2 + 2 };
                    local _ = i;
                end;

                v19[#v19 + 1] = { 1, 3, 5 };
                v19[#v19 + 1] = { 2, 6, 4 };

                return v17, Brush.planesFromMesh(v18, v19);
            end;

            local v26 = {};
            local v27 = CFrame:PointToWorldSpace((Vector3.new(-X, -Y, -Z)));
            local v28 = { v27.X, v27.Y, v27.Z };
            local v29 = CFrame:PointToWorldSpace((Vector3.new(-X, -Y, Z)));
            local v30 = { v29.X, v29.Y, v29.Z };
            local v31 = CFrame:PointToWorldSpace((Vector3.new(X, -Y, -Z)));
            local v32 = { v31.X, v31.Y, v31.Z };
            local v33 = CFrame:PointToWorldSpace((Vector3.new(X, -Y, Z)));
            local v34 = { v33.X, v33.Y, v33.Z };
            local v35 = CFrame:PointToWorldSpace((Vector3.new(X, Y, -Z)));
            v26[1], v26[2], v26[3], v26[4], v26[5] = v28, v30, v32, v34, { v35.X, v35.Y, v35.Z };

            return v17, Brush.planesFromMesh(v26, u3);
        end;

        local v36 = {};
        local v37 = CFrame:PointToWorldSpace((Vector3.new(-X, -Y, -Z)));
        local v38 = { v37.X, v37.Y, v37.Z };
        local v39 = CFrame:PointToWorldSpace((Vector3.new(-X, -Y, Z)));
        local v40 = { v39.X, v39.Y, v39.Z };
        local v41 = CFrame:PointToWorldSpace((Vector3.new(X, -Y, -Z)));
        local v42 = { v41.X, v41.Y, v41.Z };
        local v43 = CFrame:PointToWorldSpace((Vector3.new(X, -Y, Z)));
        local v44 = { v43.X, v43.Y, v43.Z };
        local v45 = CFrame:PointToWorldSpace((Vector3.new(-X, Y, Z)));
        local v46 = { v45.X, v45.Y, v45.Z };
        local v47 = CFrame:PointToWorldSpace((Vector3.new(X, Y, Z)));
        v36[1], v36[2], v36[3], v36[4], v36[5], v36[6] = v38, v40, v42, v44, v46, { v47.X, v47.Y, v47.Z };

        return v17, Brush.planesFromMesh(v36, u2);
    end;

    local Position = CFrame.Position;
    local RightVector = CFrame.RightVector;
    local UpVector = CFrame.UpVector;
    local LookVector = CFrame.LookVector;

    local function plane(p48, p49, p50, p51) -- Line: 70
        -- upvalues: Position (copy)
        return {
            p48,
            p49,
            p50,
            p48 * Position.X + p49 * Position.Y + p50 * Position.Z + p51
        };
    end;

    local v52 = {};
    local X2 = RightVector.X;
    local Y2 = RightVector.Y;
    local Z2 = RightVector.Z;
    local v53 = {
        X2,
        Y2,
        Z2,
        X2 * Position.X + Y2 * Position.Y + Z2 * Position.Z + X
    };
    local v54 = -RightVector.X;
    local v55 = -RightVector.Y;
    local v56 = -RightVector.Z;
    local v57 = {
        v54,
        v55,
        v56,
        v54 * Position.X + v55 * Position.Y + v56 * Position.Z + X
    };
    local X3 = UpVector.X;
    local Y3 = UpVector.Y;
    local Z3 = UpVector.Z;
    local v58 = {
        X3,
        Y3,
        Z3,
        X3 * Position.X + Y3 * Position.Y + Z3 * Position.Z + Y
    };
    local v59 = -UpVector.X;
    local v60 = -UpVector.Y;
    local v61 = -UpVector.Z;
    local v62 = {
        v59,
        v60,
        v61,
        v59 * Position.X + v60 * Position.Y + v61 * Position.Z + Y
    };
    local v63 = -LookVector.X;
    local v64 = -LookVector.Y;
    local v65 = -LookVector.Z;
    local v66 = {
        v63,
        v64,
        v65,
        v63 * Position.X + v64 * Position.Y + v65 * Position.Z + Z
    };
    local X4 = LookVector.X;
    local Y4 = LookVector.Y;
    local Z4 = LookVector.Z;
    v52[1], v52[2], v52[3], v52[4], v52[5], v52[6] = v53, v57, v58, v62, v66, {
    X4,
    Y4,
    Z4,
    X4 * Position.X + Y4 * Position.Y + Z4 * Position.Z + Z
};

    return v17, v52;
end;

function u1.buildGraph(p67, p68, p69) -- Line: 122
    -- upvalues: u1 (copy), Brush (copy), boxPlanes (copy), BSP (copy), Portals (copy), Vis (copy)
    local v70 = {};

    for i, v in u1.DEFAULTS do
        local v71;

        if p69 == nil or p69[i] == nil then
            v71 = v;
        else
            v71 = p69[i];
        end;

        v70[i] = v71;
    end;

    local v72;

    if p69 == nil then
        v72 = nil;
    else
        v72 = p69.yield;
    end;

    local os_clock_ret = os.clock();
    local v73 = {};
    local v74 = {
        brushes = 0,
        unsupported = 0,
        degenerate = 0,
        groundBrushes = 0
    };

    for i, v in p67 do
        if v72 ~= nil and i % 8 == 0 then
            v72();
        end;

        local _, v75 = u1.planesForPart(v);

        if v75 == nil then
            v74.unsupported = v74.unsupported + 1;
        else
            local v76 = Brush.fromPlanes(v75, #v73 + 1, v.Name);

            if v76 == nil then
                v74.degenerate = v74.degenerate + 1;
            else
                v73[#v73 + 1] = v76;
            end;
        end;
    end;

    v74.brushes = #v73;

    if #v73 == 0 then
        return nil, "NoBrushes";
    end;

    local pad = v70.pad;
    local v77 = (-1 / 0);
    local v78 = (-1 / 0);
    local v79 = (-1 / 0);
    local v80 = {};
    local v81 = (1 / 0);
    local v82 = (1 / 0);
    local v83 = (1 / 0);

    for i, v in p68.regions do
        v80[i] = {
            cluster = v.cluster,
            minX = v.minimum.X - pad,
            minY = v.minimum.Y - v70.padDown,
            minZ = v.minimum.Z - pad,
            maxX = v.maximum.X + pad,
            maxY = math.min(v.maximum.Y, v.minimum.Y + v70.band) + v70.padUp,
            maxZ = v.maximum.Z + pad
        };
        local domainPad = v70.domainPad;
        v81 = math.min(v81, v.minimum.X - domainPad);
        v82 = math.min(v82, v.minimum.Y - 2);
        v83 = math.min(v83, v.minimum.Z - domainPad);
        v77 = math.max(v77, v.maximum.X + domainPad);
        v78 = math.max(v78, v.maximum.Y + 2);
        v79 = math.max(v79, v.maximum.Z + domainPad);
    end;

    local v84 = boxPlanes(v81, v82, v83, v77, v78, v79);

    if v70.ground then
        for _, v in p68.regions do
            v73[#v73 + 1] = Brush.fromPlanes(boxPlanes(v.minimum.X, v82 - 1, v.minimum.Z, v.maximum.X, v.minimum.Y + 0.25 - 0.5, v.maximum.Z), #v73 + 1, "ground");
            v74.groundBrushes = v74.groundBrushes + 1;

            if v.maximum.Y - v.minimum.Y < 95 then
                v73[#v73 + 1] = Brush.fromPlanes(boxPlanes(v.minimum.X, v.maximum.Y + 0.25, v.minimum.Z, v.maximum.X, v78 + 1, v.maximum.Z), #v73 + 1, "ceiling");
                v74.groundBrushes = v74.groundBrushes + 1;
            end;
        end;
    end;

    local v85 = {};

    for i, v in v73 do
        local v86 = v;

        for _, v2 in v84 do
            if v86 == nil then
                break;
            end;

            local v87;
            v87, v86 = Brush.split(v86, v2[1], v2[2], v2[3], v2[4]);
        end;

        if v86 ~= nil then
            v85[#v85 + 1] = v86;
        end;

        if v72 ~= nil and i % 2 == 0 then
            v72();
        end;
    end;

    v74.clipped = #v85;
    local v88, v89, v90 = BSP.build(v85, v84, v72);
    v74.bsp = v90;
    local v91, v92 = Portals.build(v88, v89, v81, v82, v83, v77, v78, v79, v72);
    v74.portals = v92;
    local v93 = Vis.prepare(v91, v89, v72);
    v74.directedPortals = #v93.portals;
    v74.airLeaves = #v93.airLeaves;
    local v94 = #p68.cells;
    local table_create_ret = table.create(v94, false);
    local v95 = 0;
    local v96 = {};

    for _, v in v80 do
        local v97 = boxPlanes(v.minX, v.minY, v.minZ, v.maxX, v.maxY, v.maxZ);
        local v98 = v;

        for _, v2 in v93.airLeaves do
            if BSP.leafTouchesBox(v2, v98.minX, v98.minY, v98.minZ, v98.maxX, v98.maxY, v98.maxZ, 0.01) then
                local table_clone_ret = table.clone(v2.planes);
                local v99 = v2;

                for _, v3 in v97 do
                    table_clone_ret[#table_clone_ret + 1] = v3;
                end;

                local v100 = Brush.fromPlanes(table_clone_ret, 0, "volume");

                if v100 ~= nil then
                    local v101 = {};

                    for _, v3 in v100.sides do
                        v101[#v101 + 1] = {
                            w = v3.w,
                            nx = v3.nx,
                            ny = v3.ny,
                            nz = v3.nz,
                            d = v3.d
                        };
                    end;

                    v95 = v95 + #v101;
                    v96[#v96 + 1] = {
                        cell = v98.cluster,
                        leaf = v99.airIndex,
                        faces = v101
                    };
                    table_create_ret[v98.cluster] = true;
                end;
            end;
        end;

        if v72 ~= nil then
            v72();
        end;
    end;

    v74.volumes = #v96;
    v74.faces = v95;
    v74.buildSeconds = os.clock() - os_clock_ret;

    return {
        state = v93,
        volumes = v96,
        cellCount = v94,
        cellHasVolume = table_create_ret,
        clipped = v85,
        root = v88,
        leaves = v89,
        domain = {
            v81,
            v82,
            v83,
            v77,
            v78,
            v79
        },
        stats = v74
    };
end;

local function writeWinding(p102, p103, p104) -- Line: 288
    buffer.writeu32(p102, p103, #p104);
    local v105 = p103 + 4;

    for i = 1, #p104 do
        buffer.writef64(p102, v105, p104[i]);
        v105 = v105 + 8;
        local _ = i;
    end;

    return v105;
end;

local function readWinding(p106, p107) -- Line: 298
    local buffer_readu32_ret = buffer.readu32(p106, p107);
    local v108 = p107 + 4;
    local table_create_ret = table.create(buffer_readu32_ret);

    for i = 1, buffer_readu32_ret do
        table_create_ret[i] = buffer.readf64(p106, v108);
        v108 = v108 + 8;
        local _ = i;
    end;

    return table_create_ret, v108;
end;

function u1.encodeGraph(p109, p110) -- Line: 310
    local v111 = 8;

    for _, v in p109.portals do
        v111 = v111 + (#v.w * 8 + 92);
    end;

    for _, v in p109.airLeaves do
        v111 = v111 + (#v.planes * 32 + 4);
    end;

    local buffer_create_ret = buffer.create(v111);
    buffer.writeu32(buffer_create_ret, 0, #p109.airLeaves);
    buffer.writeu32(buffer_create_ret, 4, #p109.portals);
    local v112 = 8;

    for i, v in p109.portals do
        if p110 ~= nil and i % 256 == 0 then
            p110();
        end;

        buffer.writeu32(buffer_create_ret, v112, v.from);
        buffer.writeu32(buffer_create_ret, v112 + 4, v.leaf);
        local v113 = v112 + 8;

        for _, v2 in {
            v.nx,
            v.ny,
            v.nz,
            v.d,
            v.minX,
            v.minY,
            v.minZ,
            v.maxX,
            v.maxY,
            v.maxZ
        } do
            buffer.writef64(buffer_create_ret, v113, v2);
            v113 = v113 + 8;
        end;

        local w = v.w;
        buffer.writeu32(buffer_create_ret, v113, #w);
        v112 = v113 + 4;

        for i2 = 1, #w do
            buffer.writef64(buffer_create_ret, v112, w[i2]);
            v112 = v112 + 8;
            local _ = i2;
        end;
    end;

    for _, v in p109.airLeaves do
        buffer.writeu32(buffer_create_ret, v112, #v.planes);
        v112 = v112 + 4;

        for _, v2 in v.planes do
            buffer.writef64(buffer_create_ret, v112, v2[1]);
            local v114 = v112 + 8;
            buffer.writef64(buffer_create_ret, v114, v2[2]);
            local v115 = v114 + 8;
            buffer.writef64(buffer_create_ret, v115, v2[3]);
            local v116 = v115 + 8;
            buffer.writef64(buffer_create_ret, v116, v2[4]);
            v112 = v116 + 8;
        end;
    end;

    return buffer_create_ret;
end;

function u1.decodeGraph(p117, p118) -- Line: 348
    local buffer_readu32_ret = buffer.readu32(p117, 0);
    local buffer_readu32_ret2 = buffer.readu32(p117, 4);
    local table_create_ret = table.create(buffer_readu32_ret2);
    local table_create_ret2 = table.create(buffer_readu32_ret);
    local v119 = 8;

    for i = 1, buffer_readu32_ret do
        table_create_ret2[i] = {};
        local _ = i;
    end;

    for i = 1, buffer_readu32_ret2 do
        if p118 ~= nil and i % 256 == 0 then
            p118();
        end;

        local buffer_readu32_ret3 = buffer.readu32(p117, v119);
        local buffer_readu32_ret4 = buffer.readu32(p117, v119 + 4);
        local v120 = v119 + 8;
        local table_create_ret3 = table.create(10);
        local v121 = i;

        for i2 = 1, 10 do
            table_create_ret3[i2] = buffer.readf64(p117, v120);
            v120 = v120 + 8;
            local _ = i2;
        end;

        local buffer_readu32_ret5 = buffer.readu32(p117, v120);
        v119 = v120 + 4;
        local table_create_ret4 = table.create(buffer_readu32_ret5);

        for i2 = 1, buffer_readu32_ret5 do
            table_create_ret4[i2] = buffer.readf64(p117, v119);
            v119 = v119 + 8;
            local _ = i2;
        end;

        local v122 = {
            done = false,
            id = v121,
            from = buffer_readu32_ret3,
            leaf = buffer_readu32_ret4,
            nx = table_create_ret3[1],
            ny = table_create_ret3[2],
            nz = table_create_ret3[3],
            d = table_create_ret3[4],
            minX = table_create_ret3[5],
            minY = table_create_ret3[6],
            minZ = table_create_ret3[7],
            maxX = table_create_ret3[8],
            maxY = table_create_ret3[9],
            maxZ = table_create_ret3[10],
            w = table_create_ret4
        };
        table_create_ret[v121] = v122;
        local v123 = table_create_ret2[buffer_readu32_ret3];
        v123[#v123 + 1] = v122;
    end;

    local table_create_ret3 = table.create(buffer_readu32_ret);

    for i = 1, buffer_readu32_ret do
        local buffer_readu32_ret3 = buffer.readu32(p117, v119);
        v119 = v119 + 4;
        local table_create_ret4 = table.create(buffer_readu32_ret3);
        local v124 = i;

        for i2 = 1, buffer_readu32_ret3 do
            table_create_ret4[i2] = {
                buffer.readf64(p117, v119),
                buffer.readf64(p117, v119 + 8),
                buffer.readf64(p117, v119 + 16),
                (buffer.readf64(p117, v119 + 24))
            };
            v119 = v119 + 32;
            local _ = i2;
        end;

        table_create_ret3[v124] = {
            air = true,
            leaf = true,
            airIndex = v124,
            planes = table_create_ret4
        };
    end;

    return {
        portals = table_create_ret,
        leafPortals = table_create_ret2,
        airLeaves = table_create_ret3,
        leafWords = (buffer_readu32_ret + 31) // 32
    };
end;

function u1.encodeFronts(p125, p126, p127) -- Line: 412
    local v128 = (#p125.portals + 31) // 32;
    local buffer_create_ret = buffer.create(8 + (p127 - p126 + 1) * v128 * 4);
    buffer.writeu32(buffer_create_ret, 0, p126);
    buffer.writeu32(buffer_create_ret, 4, p127);
    local v129 = 8;

    for i = p126, p127 do
        buffer.copy(buffer_create_ret, v129, p125.portals[i].front);
        v129 = v129 + v128 * 4;
        local _ = i;
    end;

    return buffer_create_ret;
end;

function u1.applyFronts(p130, p131) -- Line: 426
    local v132 = (#p130.portals + 31) // 32;
    p130.portalWords = v132;
    local buffer_readu32_ret = buffer.readu32(p131, 0);
    local buffer_readu32_ret2 = buffer.readu32(p131, 4);
    local v133 = 8;

    for i = buffer_readu32_ret, buffer_readu32_ret2 do
        local buffer_create_ret = buffer.create(v132 * 4);
        buffer.copy(buffer_create_ret, 0, p131, v133, v132 * 4);
        p130.portals[i].front = buffer_create_ret;
        v133 = v133 + v132 * 4;
        local _ = i;
    end;

    return buffer_readu32_ret, buffer_readu32_ret2;
end;

function u1.encodeMightsee(p134, p135) -- Line: 442
    local v136 = p134.leafWords * 4;
    local buffer_create_ret = buffer.create(#p134.portals * (v136 + 4));
    local v137 = 0;

    for i, v in p134.portals do
        if p135 ~= nil and i % 512 == 0 then
            p135();
        end;

        buffer.writeu32(buffer_create_ret, v137, v.numMightsee or 0);
        buffer.copy(buffer_create_ret, v137 + 4, v.mightsee);
        v137 = v137 + (4 + v136);
    end;

    return buffer_create_ret;
end;

function u1.decodeMightsee(p138, p139, p140) -- Line: 457
    local v141 = p138.leafWords * 4;
    local v142 = 0;

    for i, v in p138.portals do
        if p140 ~= nil and i % 512 == 0 then
            p140();
        end;

        v.numMightsee = buffer.readu32(p139, v142);
        local buffer_create_ret = buffer.create(v141);
        buffer.copy(buffer_create_ret, 0, p139, v142 + 4, v141);
        v.mightsee = buffer_create_ret;
        v142 = v142 + (4 + v141);
    end;
end;

function u1.encodeVolumes(p143, p144) -- Line: 472
    local v145 = 4;

    for _, v in p143 do
        v145 = v145 + 12;

        for _, v2 in v.faces do
            v145 = v145 + (#v2.w * 8 + 36);
        end;
    end;

    local buffer_create_ret = buffer.create(v145);
    buffer.writeu32(buffer_create_ret, 0, #p143);
    local v146 = 4;

    for i, v in p143 do
        if p144 ~= nil and i % 128 == 0 then
            p144();
        end;

        buffer.writeu32(buffer_create_ret, v146, v.cell);
        buffer.writeu32(buffer_create_ret, v146 + 4, v.leaf);
        buffer.writeu32(buffer_create_ret, v146 + 8, #v.faces);
        v146 = v146 + 12;

        for _, v2 in v.faces do
            buffer.writef64(buffer_create_ret, v146, v2.nx);
            buffer.writef64(buffer_create_ret, v146 + 8, v2.ny);
            buffer.writef64(buffer_create_ret, v146 + 16, v2.nz);
            buffer.writef64(buffer_create_ret, v146 + 24, v2.d);
            local v147 = v146 + 32;
            local w = v2.w;
            buffer.writeu32(buffer_create_ret, v147, #w);
            v146 = v147 + 4;

            for i2 = 1, #w do
                buffer.writef64(buffer_create_ret, v146, w[i2]);
                v146 = v146 + 8;
                local _ = i2;
            end;
        end;
    end;

    return buffer_create_ret;
end;

function u1.decodeVolumes(p148, p149) -- Line: 503
    local buffer_readu32_ret = buffer.readu32(p148, 0);
    local table_create_ret = table.create(buffer_readu32_ret);
    local v150 = 4;

    for i = 1, buffer_readu32_ret do
        if p149 ~= nil and i % 128 == 0 then
            p149();
        end;

        local buffer_readu32_ret2 = buffer.readu32(p148, v150);
        local buffer_readu32_ret3 = buffer.readu32(p148, v150 + 4);
        local buffer_readu32_ret4 = buffer.readu32(p148, v150 + 8);
        v150 = v150 + 12;
        local table_create_ret2 = table.create(buffer_readu32_ret4);

        for i2 = 1, buffer_readu32_ret4 do
            local buffer_readf64_ret = buffer.readf64(p148, v150);
            local buffer_readf64_ret2 = buffer.readf64(p148, v150 + 8);
            local buffer_readf64_ret3 = buffer.readf64(p148, v150 + 16);
            local buffer_readf64_ret4 = buffer.readf64(p148, v150 + 24);
            local v151 = v150 + 32;
            local buffer_readu32_ret5 = buffer.readu32(p148, v151);
            v150 = v151 + 4;
            local table_create_ret3 = table.create(buffer_readu32_ret5);

            for i3 = 1, buffer_readu32_ret5 do
                table_create_ret3[i3] = buffer.readf64(p148, v150);
                v150 = v150 + 8;
                local _ = i3;
            end;

            table_create_ret2[i2] = {
                w = table_create_ret3,
                nx = buffer_readf64_ret,
                ny = buffer_readf64_ret2,
                nz = buffer_readf64_ret3,
                d = buffer_readf64_ret4
            };
        end;

        table_create_ret[i] = {
            cell = buffer_readu32_ret2,
            leaf = buffer_readu32_ret3,
            faces = table_create_ret2
        };
    end;

    return table_create_ret;
end;

function u1.encodeRow(p152, p153) -- Line: 533
    local v154 = {};

    for i in p153 do
        v154[#v154 + 1] = i;
    end;

    table.sort(v154);

    return p152 .. ":" .. table.concat(v154, " ");
end;

function u1.decodeRow(p155) -- Line: 542
    local string_match_ret, v156 = string.match(p155, "^(%d+):(.*)$");
    local v157 = {};

    for i in string.gmatch(v156 or "", "%d+") do
        v157[tonumber(i)] = true;
    end;

    return tonumber(string_match_ret), v157;
end;

local function regionGap(p158, p159) -- Line: 552
    local math_max_ret = math.max(p159.minimum.X - p158.maximum.X, p158.minimum.X - p159.maximum.X, 0);
    local math_max_ret2 = math.max(p159.minimum.Y - p158.maximum.Y, p158.minimum.Y - p159.maximum.Y, 0);
    local math_max_ret3 = math.max(p159.minimum.Z - p158.maximum.Z, p158.minimum.Z - p159.maximum.Z, 0);

    return math.sqrt(math_max_ret * math_max_ret + math_max_ret2 * math_max_ret2 + math_max_ret3 * math_max_ret3);
end;

function u1.applyVisibility(p160, p161, p162, p163, p164) -- Line: 560
    -- upvalues: regionGap (copy)
    local v165 = #p160.cells;
    local RowStride = p161.getRowStride(v165);
    local v166 = p161.newVisibilityBuffer(v165);
    local v167 = {
        pairs = 0,
        visible = 0,
        near = 0,
        failOpen = 0,
        floodOnly = 0,
        sampledOnly = 0
    };

    for i = 1, v165 do
        if p164 ~= nil then
            p164();
        end;

        p161.setVisible(v166, RowStride, i, i);
        local v168 = i;

        for i2 = i + 1, v165 do
            v167.pairs = v167.pairs + 1;
            local v169 = p161.isVisible(p160, v168, i2) or p161.isVisible(p160, i2, v168);
            local v170;

            if p162[v168] == nil or p162[v168][i2] ~= true then
                if p162[i2] == nil then
                    v170 = false;
                else
                    v170 = p162[i2][v168] == true;
                end;
            else
                v170 = true;
            end;

            local v171 = v169 or v170;
            local v172;

            if v171 then
                v172 = i2;
            else
                v172 = i2;
                local v173 = (1 / 0);

                for _, v in p160.cells[v168].regions or {} do
                    local v174 = v;

                    for _, v2 in p160.cells[v172].regions or {} do
                        local v175 = regionGap(v174, v2);
                        v173 = math.min(v173, v175);
                    end;
                end;

                if v173 <= p160.nearDistance then
                    v167.near = v167.near + 1;
                    v171 = true;
                elseif not (p163[v168] and p163[v172]) then
                    v167.failOpen = v167.failOpen + 1;
                    v171 = true;
                end;
            end;

            if v170 and not v169 then
                v167.floodOnly = v167.floodOnly + 1;
            elseif v169 and not v170 then
                v167.sampledOnly = v167.sampledOnly + 1;
            end;

            if v171 then
                p161.setVisible(v166, RowStride, v168, v172);
                p161.setVisible(v166, RowStride, v172, v168);
                v167.visible = v167.visible + 1;
            end;
        end;
    end;

    return buffer.tostring(v166), v167;
end;

return table.freeze(u1);