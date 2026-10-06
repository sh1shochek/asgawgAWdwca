-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local QuickHull = require(script.Parent.QuickHull);
local HullPoints = require(script.Parent.HullPoints);
local CanonicalGeometry = require(script.Parent.CanonicalGeometry);
local u1 = setmetatable({}, {
    __mode = "k"
});
local u2 = setmetatable({}, {
    __mode = "k"
});
local u8 = {
    Get = function(p3: userdata) -- Line: 15, Name: Get
        -- upvalues: u1 (copy), CanonicalGeometry (copy)
        local v4 = u1[p3];

        if v4 ~= nil then
            return v4;
        end;

        local v5, v6 = CanonicalGeometry.ReadPublished(p3);
        assert(v5 ~= nil, v6);
        local v7 = {
            CFrame = v5.CFrame,
            Size = v5.Size
        };
        u1[p3] = v7;

        return v7;
    end
};

function u8.GetCFrame(p9: userdata) -- Line: 30
    -- upvalues: u8 (copy)
    return u8.Get(p9).CFrame;
end;

local v10 = {};
local u11 = { Vector3.new(0.5, 0.5, 0.5), Vector3.new(0.5, 0.5, -0.5), Vector3.new(-0.5, 0.5, 0.5), Vector3.new(-0.5, 0.5, -0.5), Vector3.new(0.5, -0.5, 0.5), Vector3.new(0.5, -0.5, -0.5), Vector3.new(-0.5, -0.5, 0.5), Vector3.new(-0.5, -0.5, -0.5) };
local u12 = { Vector3.new(0.5, -0.5, -0.5), Vector3.new(-0.5, -0.5, -0.5), Vector3.new(0.5, -0.5, 0.5), Vector3.new(-0.5, -0.5, 0.5), Vector3.new(0.5, 0.5, 0.5), Vector3.new(-0.5, 0.5, 0.5) };
local u13 = { Vector3.new(0.5, 0.5, -0.5), Vector3.new(0.5, -0.5, 0.5), Vector3.new(-0.5, -0.5, 0.5), Vector3.new(0.5, -0.5, -0.5), Vector3.new(-0.5, -0.5, -0.5) };

local function quantizeVectorKey(p14: vector) -- Line: 81
    return string.format("%d|%d|%d", math.round(p14.X * 10000), math.round(p14.Y * 10000), (math.round(p14.Z * 10000)));
end;

local function findShapeForInstance(p15: userdata) -- Line: 90
    if p15:IsA("WedgePart") then
        return Enum.PartType.Wedge;
    end;

    if p15:IsA("CornerWedgePart") then
        return Enum.PartType.CornerWedge;
    end;

    if p15:IsA("Part") then
        return p15.Shape;
    end;

    return Enum.PartType.Block;
end;

local function isClimbableInstance(p16: userdata) -- Line: 103
    -- upvalues: CollectionService (copy)
    return p16:GetAttribute("Climbable") == true and true or CollectionService:HasTag(p16, "Ladder");
end;

local function getSurfaceFriction(p17: userdata) -- Line: 107
    return 1;
end;

local function isMergeEligibleShape(p18) -- Line: 111
    return (p18 == Enum.PartType.Block or p18 == Enum.PartType.Wedge) and true or p18 == Enum.PartType.CornerWedge;
end;

local function getCylinderCollisionRadius(p19: vector) -- Line: 115
    return math.min(p19.Y, p19.Z) * 0.5;
end;

local function generateLocalPointsForPrimitive(p20: userdata, p21: vector) -- Line: 120
    -- upvalues: HullPoints (copy), findShapeForInstance (copy), u12 (copy), u13 (copy), u11 (copy)
    local v22 = HullPoints.Read(p20);

    if v22 ~= nil then
        return v22;
    end;

    local v23 = findShapeForInstance(p20);

    if v23 == Enum.PartType.Wedge then
        local v24 = {};

        for _, v in ipairs(u12) do
            table.insert(v24, v * p21);
        end;

        return v24;
    end;

    if v23 == Enum.PartType.CornerWedge then
        local v25 = {};

        for _, v in ipairs(u13) do
            table.insert(v25, v * p21);
        end;

        return v25;
    end;

    if v23 ~= Enum.PartType.Cylinder then
        if v23 ~= Enum.PartType.Ball then
            local v26 = {};

            for _, v in ipairs(u11) do
                table.insert(v26, v * p21);
            end;

            return v26;
        end;

        local v27 = math.min(p21.X, p21.Y, p21.Z) * 0.5;
        local v28 = {
            Vector3.new(v27, 0, 0),
            Vector3.new(-v27, 0, 0),
            Vector3.new(0, v27, 0),
            Vector3.new(0, -v27, 0),
            Vector3.new(0, 0, v27),
            (Vector3.new(0, 0, -v27))
        };

        for i = 1, 8 do
            local v29 = i / 9 * 3.141592653589793;
            local v30 = math.sin(v29) * v27;
            local v31 = math.cos(v29) * v27;
            local _ = i;

            for i2 = 0, 15 do
                local v32 = i2 / 16 * 3.141592653589793 * 2;
                local v33 = math.cos(v32) * v30;
                local v34 = math.sin(v32) * v30;
                local Vector3_new_ret = Vector3.new(v31, v33, v34);
                table.insert(v28, Vector3_new_ret);
                local Vector3_new_ret2 = Vector3.new(-v31, v33, v34);
                table.insert(v28, Vector3_new_ret2);
                local _ = i2;
            end;
        end;

        return v28;
    end;

    local v35 = p21.X * 0.5;
    local v36 = math.min(p21.Y, p21.Z) * 0.5;
    local v37 = p20:GetAttribute("PreciseMovementCylinder") == true and 32 or 12;
    local v38 = {};

    for i = 0, v37 - 1 do
        local v39 = i / v37 * 3.141592653589793 * 2;
        local v40 = math.cos(v39) * v36;
        local v41 = math.sin(v39) * v36;
        local Vector3_new_ret = Vector3.new(-v35, v40, v41);
        table.insert(v38, Vector3_new_ret);
        local Vector3_new_ret2 = Vector3.new(v35, v40, v41);
        table.insert(v38, Vector3_new_ret2);
        local _ = i;
    end;

    return v38;
end;

local function addUniquePoint(p42: table, p43: table, p44: vector) -- Line: 193
    local math_round_ret = math.round(p44.Y * 10000);
    local math_round_ret2 = math.round(p44.Z * 10000);

    if math.abs(math_round_ret) >= 67108864 or math.abs(math_round_ret2) >= 67108864 then
        local string_format_ret = string.format("%d|%d|%d", math.round(p44.X * 10000), math.round(p44.Y * 10000), (math.round(p44.Z * 10000)));

        if p43[string_format_ret] then
            return;
        end;

        p43[string_format_ret] = true;
        table.insert(p42, p44);

        return;
    end;

    local math_round_ret3 = math.round(p44.X * 10000);
    local v45 = p43[math_round_ret3];

    if v45 == nil then
        v45 = {};
        p43[math_round_ret3] = v45;
    end;

    local v46 = math_round_ret * 134217728 + math_round_ret2;

    if v45[v46] then
        return;
    end;

    v45[v46] = true;
    table.insert(p42, p44);
end;

local function buildExpandedPoints(p47: userdata, p48, p49: vector, p50: vector) -- Line: 219
    -- upvalues: generateLocalPointsForPrimitive (copy), u11 (copy), addUniquePoint (copy)
    local v51 = generateLocalPointsForPrimitive(p47, p49);
    local v52 = {};
    local v53 = {};

    for _, v in ipairs(v51) do
        local v54 = p48:PointToWorldSpace(v);

        for _, v2 in ipairs(u11) do
            addUniquePoint(v52, v53, v54 + v2 * p50);
        end;
    end;

    return v52;
end;

local function buildExpandedPointsForInstances(p55: table, p56: vector) -- Line: 239
    -- upvalues: u8 (copy), generateLocalPointsForPrimitive (copy), u11 (copy), addUniquePoint (copy)
    local v57 = {};
    local v58 = {};

    for _, v in ipairs(p55) do
        local v59 = u8.Get(v);
        local v60 = generateLocalPointsForPrimitive(v, v59.Size);

        for _, v2 in ipairs(v60) do
            local v61 = v59.CFrame:PointToWorldSpace(v2);

            for _, v3 in ipairs(u11) do
                addUniquePoint(v57, v58, v61 + v3 * p56);
            end;
        end;
    end;

    return v57;
end;

local function buildWorldPointsForInstances(p62: table) -- Line: 257
    -- upvalues: u8 (copy), generateLocalPointsForPrimitive (copy), addUniquePoint (copy)
    local v63 = {};
    local v64 = {};

    for _, v in ipairs(p62) do
        local v65 = u8.Get(v);
        local v66 = generateLocalPointsForPrimitive(v, v65.Size);

        for _, v2 in ipairs(v66) do
            addUniquePoint(v63, v64, v65.CFrame:PointToWorldSpace(v2));
        end;
    end;

    return v63;
end;

local function buildWorldPointsFromLocalPoints(p67, p68: table) -- Line: 272
    local table_create_ret = table.create(#p68);

    for i, v in ipairs(p68) do
        table_create_ret[i] = p67:PointToWorldSpace(v);
    end;

    return table_create_ret;
end;

local function findPointBounds(p69: table) -- Line: 280
    local v70 = Vector3.new(inf, inf, inf);
    local v71 = Vector3.new(-inf, -inf, -inf);

    for _, v in ipairs(p69) do
        local math_min_ret = math.min(v70.X, v.X);
        local math_min_ret2 = math.min(v70.Y, v.Y);
        local math_min_ret3 = math.min(v70.Z, v.Z);
        v70 = Vector3.new(math_min_ret, math_min_ret2, math_min_ret3);
        local math_max_ret = math.max(v71.X, v.X);
        local math_max_ret2 = math.max(v71.Y, v.Y);
        local math_max_ret3 = math.max(v71.Z, v.Z);
        v71 = Vector3.new(math_max_ret, math_max_ret2, math_max_ret3);
    end;

    return v70, v71;
end;

local function buildWorldAabb(p72, p73: vector) -- Line: 294
    -- upvalues: u11 (copy)
    local v74 = Vector3.new(inf, inf, inf);
    local v75 = Vector3.new(-inf, -inf, -inf);

    for _, v in ipairs(u11) do
        local v76 = p72:PointToWorldSpace(v * p73);
        local math_min_ret = math.min(v74.X, v76.X);
        local math_min_ret2 = math.min(v74.Y, v76.Y);
        local math_min_ret3 = math.min(v74.Z, v76.Z);
        v74 = Vector3.new(math_min_ret, math_min_ret2, math_min_ret3);
        local math_max_ret = math.max(v75.X, v76.X);
        local math_max_ret2 = math.max(v75.Y, v76.Y);
        local math_max_ret3 = math.max(v75.Z, v76.Z);
        v75 = Vector3.new(math_max_ret, math_max_ret2, math_max_ret3);
    end;

    return v74, v75;
end;

local function buildWorldAabbCornerPoints(p77: vector, p78: vector) -- Line: 315
    return {
        Vector3.new(p77.X, p77.Y, p77.Z),
        Vector3.new(p77.X, p77.Y, p78.Z),
        Vector3.new(p77.X, p78.Y, p77.Z),
        Vector3.new(p77.X, p78.Y, p78.Z),
        Vector3.new(p78.X, p77.Y, p77.Z),
        Vector3.new(p78.X, p77.Y, p78.Z),
        Vector3.new(p78.X, p78.Y, p77.Z),
        (Vector3.new(p78.X, p78.Y, p78.Z))
    };
end;

local function planeMatches(p79: any, p80: vector, p81: number) -- Line: 328
    local v82;

    if (p79.n - p80).Magnitude <= 0.001 then
        v82 = math.abs(p79.ed - p81) <= 0.001;
    else
        v82 = false;
    end;

    return v82;
end;

local function addPlane(p83: any, p84: vector, p85: number, p86: number, p87: string?) -- Line: 333
    for _, v in ipairs(p83) do
        local v88;

        if (v.n - p84).Magnitude <= 0.001 then
            v88 = math.abs(v.ed - p85) <= 0.001;
        else
            v88 = false;
        end;

        if v88 then
            return false;
        end;
    end;

    table.insert(p83, {
        n = p84,
        ed = p85,
        planeNum = p86,
        minkowskiPlaneKind = p87
    });

    return true;
end;

local function buildAabbPlanes(p89: table, u90: number) -- Line: 349
    -- upvalues: findPointBounds (copy)
    local v91, v92 = findPointBounds(p89);
    local u93 = {};

    local function pushPlane(p94: vector, p95: number) -- Line: 352
        -- upvalues: u90 (ref), u93 (copy)
        u90 = u90 + 1;
        table.insert(u93, {
            n = p94,
            ed = p95,
            planeNum = u90
        });
    end;

    u90 = u90 + 1;
    table.insert(u93, {
        n = Vector3.new(1, 0, 0),
        ed = v92.X,
        planeNum = u90
    });
    u90 = u90 + 1;
    table.insert(u93, {
        n = Vector3.new(-1, -0, -0),
        ed = -v91.X,
        planeNum = u90
    });
    u90 = u90 + 1;
    table.insert(u93, {
        n = Vector3.new(0, 1, 0),
        ed = v92.Y,
        planeNum = u90
    });
    u90 = u90 + 1;
    table.insert(u93, {
        n = Vector3.new(-0, -1, -0),
        ed = -v91.Y,
        planeNum = u90
    });
    u90 = u90 + 1;
    table.insert(u93, {
        n = Vector3.new(0, 0, 1),
        ed = v92.Z,
        planeNum = u90
    });
    u90 = u90 + 1;
    table.insert(u93, {
        n = Vector3.new(-0, -0, -1),
        ed = -v91.Z,
        planeNum = u90
    });

    return u93, u90;
end;

local function buildPlanesForPoints(p96: table, p97: number) -- Line: 371
    -- upvalues: QuickHull (copy), addPlane (copy)
    assert(#p96 >= 4, "A convex movement hull requires at least four points");
    local v98 = QuickHull.GenerateHull(p96);
    assert(#v98 > 0, "QuickHull returned no triangles");
    local v99 = {};

    for _, v in ipairs(v98) do
        local v100 = (v[1] - v[2]):Cross(v[1] - v[3]);

        if v100.Magnitude > 0.001 then
            local Unit = v100.Unit;

            if addPlane(v99, Unit, v[1]:Dot(Unit), p97 + 1) then
                p97 = p97 + 1;
                v99[#v99].planeNum = p97;
            end;
        end;
    end;

    assert(#v99 > 0, "QuickHull returned no usable planes");

    return v99, p97;
end;

local function isAxisAlignedBlockPart(p101: userdata, p102: any, p103) -- Line: 395
    if p102 ~= Enum.PartType.Block or not p101:IsA("Part") then
        return false;
    end;

    for _, v in ipairs({ p103.RightVector, p103.UpVector, p103.LookVector }) do
        local math_abs_ret = math.abs(v.X);
        local math_abs_ret2 = math.abs(v.Y);
        local math_abs_ret3 = math.abs(v.Z);

        if math.max(math_abs_ret, math_abs_ret2, math_abs_ret3) < 0.999999 then
            return false;
        end;
    end;

    return true;
end;

local function rawHullRecord(p104: string, p105: string, p106: any, p107: number, p108: any, p109: table, p110: vector, p111: vector) -- Line: 411
    return {
        buildMode = p104,
        sourceShape = p105,
        sourceCFrame = p106.CFrame,
        sourceSize = p106.Size,
        surfaceFriction = p107,
        hull = p108,
        points = p109,
        aabbMin = p110,
        aabbMax = p111
    };
end;

local function buildAxisAlignedBlockHullRecord(p112: userdata, p113: any, p114: vector, p115: number) -- Line: 434
    -- upvalues: buildWorldAabb (copy), buildAabbPlanes (copy), buildWorldAabbCornerPoints (copy)
    local v116, v117 = buildWorldAabb(p113.CFrame, p113.Size);
    local v118 = p114 * 0.5;
    local v119 = v116 - v118;
    local v120 = v117 + v118;
    local v121, v122 = buildAabbPlanes({ v119, v120 }, p115);
    local v123 = buildWorldAabbCornerPoints(v119, v120);

    return {
        buildMode = "primitiveAabbPlanes",
        sourceShape = Enum.PartType.Block.Name,
        sourceCFrame = p113.CFrame,
        sourceSize = p113.Size,
        surfaceFriction = 1,
        hull = v121,
        points = v123,
        aabbMin = v119,
        aabbMax = v120
    }, v122;
end;

local u124 = { Vector3.new(1, 0, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, 1) };

local function buildOrientedBlockPlanes(p125, p126: vector, u127: vector, u128: number) -- Line: 460
    -- upvalues: addPlane (copy), u124 (copy)
    local Position = p125.Position;
    local v129 = p126 * 0.5;
    local u130 = {
        {
            direction = p125.RightVector,
            halfSpan = v129.X
        },
        {
            direction = p125.UpVector,
            halfSpan = v129.Y
        },
        {
            direction = p125.LookVector,
            halfSpan = v129.Z
        }
    };
    local u131 = {};

    local function v136(p132: vector, p133: number) -- Line: 475
        -- upvalues: Position (copy), u127 (copy), u130 (copy), addPlane (ref), u131 (copy), u128 (ref)
        if p132.Magnitude <= p133 then
            return;
        end;

        local Unit = p132.Unit;
        local v134 = Unit:Dot(Position) + math.abs(Unit.X) * u127.X + math.abs(Unit.Y) * u127.Y + math.abs(Unit.Z) * u127.Z;

        for _, v in ipairs(u130) do
            local v135 = Unit:Dot(v.direction);
            v134 = v134 + math.abs(v135) * v.halfSpan;
        end;

        if addPlane(u131, Unit, v134, u128 + 1) then
            u128 = u128 + 1;
        end;
    end;

    for _, v in ipairs(u130) do
        v136(v.direction, 0.001);
        v136(-v.direction, 0.001);
    end;

    for _, v in ipairs(u124) do
        v136(v, 0.001);
        v136(-v, 0.001);
    end;

    for _, v in ipairs(u130) do
        local v137 = v;

        for _, v2 in ipairs(u124) do
            local v138 = v137.direction:Cross(v2);
            v136(v138, 0.02);
            v136(-v138, 0.02);
        end;
    end;

    return u131, u128;
end;

local function buildLocalFaceNormals(p139: table) -- Line: 513
    -- upvalues: QuickHull (copy)
    local v140 = QuickHull.GenerateHull(p139);
    local v141 = {};

    for _, v in ipairs(v140) do
        local v142 = (v[1] - v[2]):Cross(v[1] - v[3]);

        if v142.Magnitude > 0.001 then
            local Unit = v142.Unit;
            local v143 = true;

            for _, v2 in ipairs(v141) do
                if (v2 - Unit).Magnitude <= 0.001 then
                    v143 = false;
                    break;
                end;
            end;

            if v143 then
                table.insert(v141, Unit);
            end;
        end;
    end;

    return v141;
end;

local function getLocalFaceNormals(p144: string, p145: userdata, p146: table) -- Line: 535
    -- upvalues: u2 (copy), buildLocalFaceNormals (copy)
    local v147 = u2[p145];

    if v147 == nil then
        v147 = {};
        u2[p145] = v147;
    end;

    local v148 = v147[p144];

    if v148 ~= nil and #v148.Points == #p146 then
        local v149 = true;

        for i, v in ipairs(p146) do
            if v148.Points[i] ~= v then
                v149 = false;
                break;
            end;
        end;

        if v149 then
            return v148.Normals;
        end;
    end;

    local v150 = buildLocalFaceNormals(p146);
    v147[p144] = {
        Points = table.clone(p146),
        Normals = v150
    };

    return v150;
end;

local function buildLocalHullMinkowskiPlanes(p151, p152: table, u153: table, u154: vector, u155: number, p156: table) -- Line: 559
    -- upvalues: addPlane (copy), u124 (copy)
    local u157 = {};

    local function v162(p158: vector, p159: number, p160: string) -- Line: 568
        -- upvalues: u153 (copy), u154 (copy), addPlane (ref), u157 (copy), u155 (ref)
        if p158.Magnitude <= p159 then
            return;
        end;

        local Unit = p158.Unit;
        local v161 = (-1 / 0);

        for _, v in ipairs(u153) do
            v161 = math.max(v161, v:Dot(Unit));
        end;

        if addPlane(u157, Unit, v161 + (math.abs(Unit.X) * u154.X + math.abs(Unit.Y) * u154.Y + math.abs(Unit.Z) * u154.Z), u155 + 1, p160) then
            u155 = u155 + 1;
        end;
    end;

    for _, v in ipairs(p156) do
        v162(p151:VectorToWorldSpace(v), 0.001, "sourceFace");
    end;

    for _, v in ipairs(u124) do
        v162(v, 0.001, "playerAxis");
        v162(-v, 0.001, "playerAxis");
    end;

    for i = 1, #p156 do
        local v163 = i;

        for i2 = i + 1, #p156 do
            local v164 = p156[v163]:Cross(p156[i2]);
            local v165;

            if v164.Magnitude > 0.02 then
                local v166 = p151:VectorToWorldSpace(v164.Unit);
                v165 = i2;

                for _, v in ipairs(u124) do
                    local v167 = v166:Cross(v);
                    v162(v167, 0.02, "edgeBevel");
                    v162(-v167, 0.02, "edgeBevel");
                end;
            else
                v165 = i2;
            end;
        end;
    end;

    return u157, u155;
end;

local function buildLocalPrimitiveHullRecord(p168: userdata, p169: any, p170: any, p171: vector, p172: number, p173: boolean?) -- Line: 610
    -- upvalues: generateLocalPointsForPrimitive (copy), buildWorldPointsFromLocalPoints (copy), buildLocalHullMinkowskiPlanes (copy), getLocalFaceNormals (copy), buildExpandedPoints (copy), findPointBounds (copy)
    local v174 = generateLocalPointsForPrimitive(p168, p169.Size);
    local v175 = buildWorldPointsFromLocalPoints(p169.CFrame, v174);
    local v176, v177 = buildLocalHullMinkowskiPlanes(p169.CFrame, v174, v175, p171 * 0.5, p172, (getLocalFaceNormals("Primitive", p168, v174)));
    local v178 = buildExpandedPoints(p168, p169.CFrame, p169.Size, p171);
    local v179, v180 = findPointBounds(v178);

    return {
        buildMode = p173 and "authoredHullPlanes" or (p170 == Enum.PartType.Cylinder and "polygonCylinderLocalHullPlanes" or "primitiveLocalHullPlanes"),
        sourceShape = p173 and "Hull" or p170.Name,
        sourceCFrame = p169.CFrame,
        sourceSize = p169.Size,
        surfaceFriction = 1,
        hull = v176,
        points = v178,
        aabbMin = v179,
        aabbMax = v180
    }, v177;
end;

local function buildOrientedBlockHullRecord(p181: userdata, p182: any, p183: vector, p184: number) -- Line: 646
    -- upvalues: buildOrientedBlockPlanes (copy), buildExpandedPoints (copy), findPointBounds (copy)
    local v185, v186 = buildOrientedBlockPlanes(p182.CFrame, p182.Size, p183 * 0.5, p184);
    local v187 = buildExpandedPoints(p181, p182.CFrame, p182.Size, p183);
    local v188, v189 = findPointBounds(v187);

    return {
        buildMode = "primitiveBlockPlanes",
        sourceShape = Enum.PartType.Block.Name,
        sourceCFrame = p182.CFrame,
        sourceSize = p182.Size,
        surfaceFriction = 1,
        hull = v185,
        points = v187,
        aabbMin = v188,
        aabbMax = v189
    }, v186;
end;

function v10.BuildHullRecord(p190: userdata, p191: vector, p192: number) -- Line: 663
    -- upvalues: findShapeForInstance (copy), u8 (copy), HullPoints (copy), buildLocalPrimitiveHullRecord (copy), isAxisAlignedBlockPart (copy), buildAxisAlignedBlockHullRecord (copy), buildOrientedBlockHullRecord (copy), buildExpandedPoints (copy), buildPlanesForPoints (copy), findPointBounds (copy)
    local v193 = findShapeForInstance(p190);
    local v194 = u8.Get(p190);

    if HullPoints.Read(p190) ~= nil then
        return buildLocalPrimitiveHullRecord(p190, v194, v193, p191, p192, true);
    end;

    if isAxisAlignedBlockPart(p190, v193, v194.CFrame) then
        return buildAxisAlignedBlockHullRecord(p190, v194, p191, p192);
    end;

    if v193 == Enum.PartType.Block then
        return buildOrientedBlockHullRecord(p190, v194, p191, p192);
    end;

    if v193 == Enum.PartType.Cylinder or (v193 == Enum.PartType.Wedge or v193 == Enum.PartType.CornerWedge) then
        return buildLocalPrimitiveHullRecord(p190, v194, v193, p191, p192);
    end;

    local v195 = buildExpandedPoints(p190, v194.CFrame, v194.Size, p191);
    local v196, v197 = buildPlanesForPoints(v195, p192);
    local v198, v199 = findPointBounds(v195);

    return {
        buildMode = "primitiveQuickHull",
        sourceShape = v193.Name,
        sourceCFrame = v194.CFrame,
        sourceSize = v194.Size,
        surfaceFriction = 1,
        hull = v196,
        points = v195,
        aabbMin = v198,
        aabbMax = v199
    }, v197;
end;

function v10.BuildMergedHullRecord(p200: table, p201: vector, p202: number) -- Line: 696
    -- upvalues: u8 (copy), buildWorldPointsForInstances (copy), buildLocalHullMinkowskiPlanes (copy), getLocalFaceNormals (copy), buildExpandedPointsForInstances (copy), findPointBounds (copy)
    assert(#p200 >= 2, "A merged movement hull requires at least two parts");
    local v203 = p200[1];
    local v204 = u8.Get(v203);
    local CFrame = v204.CFrame;
    local v205 = buildWorldPointsForInstances(p200);
    local table_create_ret = table.create(#v205);

    for i, v in ipairs(v205) do
        table_create_ret[i] = CFrame:PointToObjectSpace(v);
    end;

    local v206, v207 = buildLocalHullMinkowskiPlanes(CFrame, table_create_ret, v205, p201 * 0.5, p202, (getLocalFaceNormals("Merged", v203, table_create_ret)));
    local v208 = buildExpandedPointsForInstances(p200, p201);
    local v209, v210 = findPointBounds(v208);

    return {
        buildMode = "mergedLocalHullPlanes",
        sourceShape = "Merged",
        sourceCFrame = v204.CFrame,
        sourceSize = v204.Size,
        surfaceFriction = 1,
        hull = v206,
        points = v208,
        aabbMin = v209,
        aabbMax = v210
    }, v207;
end;

local function aabbsTouch(p211: vector, p212: vector, p213: vector, p214: vector) -- Line: 730
    local v215;

    if p211.X <= p214.X + 0.05 and (p212.X + 0.05 >= p213.X and (p211.Y <= p214.Y + 0.05 and (p212.Y + 0.05 >= p213.Y and p211.Z <= p214.Z + 0.05))) then
        v215 = p212.Z + 0.05 >= p213.Z;
    else
        v215 = false;
    end;

    return v215;
end;

local function hasCompatibleOrientation(p216: userdata, p217: userdata) -- Line: 739
    -- upvalues: u8 (copy)
    local CFrame = u8.GetCFrame(p216);
    local CFrame2 = u8.GetCFrame(p217);
    local v218;

    if CFrame.RightVector:Dot(CFrame2.RightVector) >= 0.999 and CFrame.UpVector:Dot(CFrame2.UpVector) >= 0.999 then
        v218 = CFrame.LookVector:Dot(CFrame2.LookVector) >= 0.999;
    else
        v218 = false;
    end;

    return v218;
end;

local function componentContainsRampShape(p219: table) -- Line: 747
    -- upvalues: findShapeForInstance (copy)
    for _, v in ipairs(p219) do
        local v220 = findShapeForInstance(v);

        if v220 == Enum.PartType.Wedge or v220 == Enum.PartType.CornerWedge then
            return true;
        end;
    end;

    return false;
end;

local function componentIsNarrowStrip(p221: table) -- Line: 758
    -- upvalues: u8 (copy)
    local CFrame = u8.GetCFrame(p221[1]);
    local v222 = 0;
    local v223 = (1 / 0);
    local v224 = (-1 / 0);
    local v225 = (1 / 0);
    local v226 = (-1 / 0);
    local v227 = 0;

    for _, v in ipairs(p221) do
        local v228 = u8.Get(v);
        local v229 = CFrame:PointToObjectSpace(v228.CFrame.Position);
        v223 = math.min(v223, v229.X);
        v224 = math.max(v224, v229.X);
        v225 = math.min(v225, v229.Z);
        v226 = math.max(v226, v229.Z);
        v227 = v227 + v228.Size.X;
        v222 = v222 + v228.Size.Z;
    end;

    local v230 = v227 / math.max(#p221, 1);
    local v231 = v222 / math.max(#p221, 1);
    local math_max_ret = math.max(0.05, v230 * 0.6);
    local math_max_ret2 = math.max(0.05, v231 * 0.6);

    return v224 - v223 <= math_max_ret and true or v226 - v225 <= math_max_ret2;
end;

local function getExplicitConvexGroupId(p232: userdata) -- Line: 786
    local Attribute = p232:GetAttribute("MovementConvexGroup");

    if typeof(Attribute) == "string" and Attribute ~= "" then
        return Attribute;
    end;

    if typeof(Attribute) == "number" then
        return tostring(Attribute);
    end;

    return nil;
end;

function v10.FindMergedPartGroups(p233: table) -- Line: 798
    -- upvalues: findShapeForInstance (copy), CollectionService (copy), HullPoints (copy), u8 (copy), buildWorldAabb (copy), hasCompatibleOrientation (copy), aabbsTouch (copy), componentContainsRampShape (copy), componentIsNarrowStrip (copy)
    local v234 = #p233 <= 512;
    local v235 = {};
    local v236 = {};
    local v237 = {};
    local v238 = {};
    local v239 = {};

    for _, v in ipairs(p233) do
        local v240 = findShapeForInstance(v);

        if not (v240 ~= Enum.PartType.Block and v240 ~= Enum.PartType.Wedge and v240 ~= Enum.PartType.CornerWedge or (v:GetAttribute("Climbable") == true or CollectionService:HasTag(v, "Ladder") or (v:GetAttribute("DisableMovementSeamMerge") == true or HullPoints.Read(v) ~= nil))) then
            local v241 = u8.Get(v);
            local v242, v243 = buildWorldAabb(v241.CFrame, v241.Size);
            v237[v] = {
                minPoint = v242,
                maxPoint = v243
            };
            local Attribute = v:GetAttribute("MovementConvexGroup");

            if typeof(Attribute) ~= "string" or Attribute == "" then
                if typeof(Attribute) == "number" then
                    Attribute = tostring(Attribute);
                else
                    Attribute = nil;
                end;
            end;

            if Attribute == nil then
                local Parent = v.Parent;

                if Parent ~= nil and v234 then
                    local v244 = v235[Parent];

                    if v244 == nil then
                        v244 = {};
                        v235[Parent] = v244;
                    end;

                    v244[#v244 + 1] = v;
                end;
            else
                local v245 = v236[Attribute];

                if v245 == nil then
                    v245 = {};
                    v236[Attribute] = v245;
                end;

                v245[#v245 + 1] = v;
            end;
        end;
    end;

    for _, v in pairs(v236) do
        if #v >= 2 then
            v238[#v238 + 1] = v;

            for _, v2 in ipairs(v) do
                v239[v2] = true;
            end;
        end;
    end;

    for _, v in pairs(v235) do
        local v246 = v;
        local v247 = {};

        for _, v2 in ipairs(v) do
            if not (v247[v2] or v239[v2]) then
                v247[v2] = true;
                local v248 = { v2 };
                local v249 = {};

                while #v248 > 0 do
                    local v250 = v248[#v248];
                    v248[#v248] = nil;
                    v249[#v249 + 1] = v250;
                    local v251 = v237[v250];

                    if v251 ~= nil then
                        for _, v3 in ipairs(v246) do
                            if not (v247[v3] or (v239[v3] or v3 == v250)) then
                                local v252 = v237[v3];

                                if v252 ~= nil and (hasCompatibleOrientation(v250, v3) and aabbsTouch(v251.minPoint, v251.maxPoint, v252.minPoint, v252.maxPoint)) then
                                    v247[v3] = true;
                                    v248[#v248 + 1] = v3;
                                end;
                            end;
                        end;
                    end;
                end;

                if #v249 >= 2 and (#v249 <= 8 and (componentContainsRampShape(v249) and componentIsNarrowStrip(v249))) then
                    v238[#v238 + 1] = v249;

                    for _, v3 in ipairs(v249) do
                        v239[v3] = true;
                    end;
                end;
            end;
        end;
    end;

    return v238;
end;

return v10;