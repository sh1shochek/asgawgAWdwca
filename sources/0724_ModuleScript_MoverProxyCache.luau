-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
u1.ContactMaxRotationRadiansPerSubdivision = 0.008726646259971648;
u1.ContactMaxRotationSubdivisions = 16;
u1.ContactMaxRotationRadiansPerTick = u1.ContactMaxRotationRadiansPerSubdivision * u1.ContactMaxRotationSubdivisions;
local table_freeze_ret = table.freeze({ Vector3.new(1, 0, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, 1) });

local function newContactHull() -- Line: 103
    return {
        Center = Vector3.new(0, 0, 0),
        SourceWorldHalf = Vector3.new(0, 0, 0),
        RotationPadding = 0,
        NormalCount = 0,
        Normals = table.create(30, Vector3.new(0, 0, 0)),
        SourceSupports = table.create(30, 0)
    };
end;

local function newContactProxy() -- Line: 114
    -- upvalues: u1 (copy), newContactHull (copy)
    local table_create_ret = table.create(u1.ContactMaxRotationSubdivisions);

    for i = 1, u1.ContactMaxRotationSubdivisions do
        table_create_ret[i] = {
            TimeStart = 0,
            TimeEnd = 0,
            ReferenceCenter = Vector3.new(0, 0, 0),
            Hull = newContactHull()
        };
        local _ = i;
    end;

    return {
        SubstepCount = 0,
        ScratchCount = 0,
        PreviousPose = nil,
        Pose = nil,
        Size = nil,
        Config = nil,
        StartHull = newContactHull(),
        EndHull = newContactHull(),
        Substeps = table_create_ret,
        ScratchDirections = table.create(30, Vector3.new(0, 0, 0))
    };
end;

local function directionLess(p2: vector, p3: vector) -- Line: 138
    if p2.X ~= p3.X then
        return p2.X < p3.X;
    end;

    if p2.Y == p3.Y then
        return p2.Z < p3.Z;
    end;

    return p2.Y < p3.Y;
end;

local function appendDirection(p4: table, p5: vector, p6: any) -- Line: 148
    local Magnitude = p5.Magnitude;

    if Magnitude <= p6.PlaneNormalEpsilon then
        return;
    end;

    local v7 = p5 / Magnitude;

    for i = 1, p4.ScratchCount do
        if p4.ScratchDirections[i]:Dot(v7) >= p6.PlaneDuplicateDot then
            return;
        end;

        local _ = i;
    end;

    local v8 = p4.ScratchCount + 1;
    assert(v8 <= 30, "mover contact SAT direction capacity exceeded");
    p4.ScratchDirections[v8] = v7;
    p4.ScratchCount = v8;
end;

local function appendBothDirections(p9: table, p10: vector, p11: any) -- Line: 165
    -- upvalues: appendDirection (copy)
    appendDirection(p9, p10, p11);
    appendDirection(p9, -p10, p11);
end;

local function sortScratchDirections(p12: table) -- Line: 170
    for i = 2, p12.ScratchCount do
        local v13 = p12.ScratchDirections[i];
        local v14 = i;
        local v15 = v14;
        local v16 = v14;
        v14 = v15;
        v16 = v15;

        while v15 > 1 do
            local v17 = p12.ScratchDirections[v15 - 1];
            local v18;

            if v13.X == v17.X then
                if v13.Y == v17.Y then
                    v18 = v13.Z < v17.Z;
                else
                    v18 = v13.Y < v17.Y;
                end;
            else
                v18 = v13.X < v17.X;
            end;

            if not v18 then
                break;
            end;

            p12.ScratchDirections[v15] = p12.ScratchDirections[v15 - 1];
            v15 = v15 - 1;
        end;

        p12.ScratchDirections[v15] = v13;
    end;
end;

local function prepareHull(p19: table, p20: table, p21: table, p22, p23: number, p24: any) -- Line: 183
    -- upvalues: table_freeze_ret (copy), appendDirection (copy), sortScratchDirections (copy)
    p19.ScratchCount = 0;

    for _, v in table_freeze_ret do
        appendDirection(p19, v, p24);
        appendDirection(p19, -v, p24);
    end;

    local RightVector = p22.RightVector;
    local UpVector = p22.UpVector;
    local LookVector = p22.LookVector;
    appendDirection(p19, RightVector, p24);
    appendDirection(p19, -RightVector, p24);

    for _, v in table_freeze_ret do
        local v25 = RightVector:Cross(v);
        appendDirection(p19, v25, p24);
        appendDirection(p19, -v25, p24);
    end;

    appendDirection(p19, UpVector, p24);
    appendDirection(p19, -UpVector, p24);

    for _, v in table_freeze_ret do
        local v26 = UpVector:Cross(v);
        appendDirection(p19, v26, p24);
        appendDirection(p19, -v26, p24);
    end;

    appendDirection(p19, LookVector, p24);
    appendDirection(p19, -LookVector, p24);

    for _, v in table_freeze_ret do
        local v27 = LookVector:Cross(v);
        appendDirection(p19, v27, p24);
        appendDirection(p19, -v27, p24);
    end;

    sortScratchDirections(p19);
    local v28 = p21.Size * 0.5;

    for i = 1, p19.ScratchCount do
        local v29 = p19.ScratchDirections[i];
        p20.Normals[i] = v29;
        local SourceSupports = p20.SourceSupports;
        local v30 = v29:Dot(RightVector);
        local v31 = math.abs(v30) * v28.X;
        local v32 = v29:Dot(UpVector);
        local v33 = v31 + math.abs(v32) * v28.Y;
        local v34 = v29:Dot(LookVector);
        SourceSupports[i] = v33 + math.abs(v34) * v28.Z;
        local _ = i;
    end;

    p20.NormalCount = p19.ScratchCount;
    p20.Center = p22.Position;
    p20.RotationPadding = p23;
    local v35 = math.abs(RightVector.X) * v28.X + math.abs(UpVector.X) * v28.Y + math.abs(LookVector.X) * v28.Z;
    local v36 = math.abs(RightVector.Y) * v28.X + math.abs(UpVector.Y) * v28.Y + math.abs(LookVector.Y) * v28.Z;
    local v37 = math.abs(RightVector.Z) * v28.X + math.abs(UpVector.Z) * v28.Y + math.abs(LookVector.Z) * v28.Z;
    p20.SourceWorldHalf = Vector3.new(v35, v36, v37);
end;

local function playerHalfSize(p38: any, p39: string) -- Line: 236
    if p39 == "Standing" then
        return p38.StandingHalfSize;
    end;

    if p39 == "Ducking" then
        return p38.DuckingHalfSize;
    end;

    error("contact mover body has an invalid stance", 3);
end;

function u1.ContactQueryBounds(p40, p41, p42: vector, p43: any) -- Line: 247
    local math_max_ret = math.max(p43.StandingHalfSize.Magnitude, p43.DuckingHalfSize.Magnitude);
    local v44 = math.max(p43.ContactEpsilon, p43.BrushEpsilon) + p43.BroadphasePadding;
    local v45 = (p42 * 0.5).Magnitude + math_max_ret + v44;
    local Vector3_new_ret = Vector3.new(v45, v45, v45);
    local Position = p40.Position;
    local Position2 = p41.Position;
    local math_min_ret = math.min(Position.X, Position2.X);
    local math_min_ret2 = math.min(Position.Y, Position2.Y);
    local math_min_ret3 = math.min(Position.Z, Position2.Z);
    local v46 = Vector3.new(math_min_ret, math_min_ret2, math_min_ret3) - Vector3_new_ret;
    local math_max_ret2 = math.max(Position.X, Position2.X);
    local math_max_ret3 = math.max(Position.Y, Position2.Y);
    local math_max_ret4 = math.max(Position.Z, Position2.Z);

    return v46, Vector3.new(math_max_ret2, math_max_ret3, math_max_ret4) + Vector3_new_ret;
end;

local function planeDistance(p47: table, p48: number, p49: vector) -- Line: 272
    local v50 = p47.Normals[p48];

    return p47.Center:Dot(v50) + p47.SourceSupports[p48] + math.abs(v50.X) * p49.X + math.abs(v50.Y) * p49.Y + math.abs(v50.Z) * p49.Z + p47.RotationPadding;
end;

local function containsHull(p51: table, p52: vector, p53: vector, p54: any) -- Line: 282
    -- upvalues: planeDistance (copy)
    local math_max_ret = math.max(p54.ContactEpsilon, p54.BrushEpsilon);

    for i = 1, p51.NormalCount do
        if p52:Dot(p51.Normals[i]) - planeDistance(p51, i, p53) >= -math_max_ret then
            return false;
        end;

        local _ = i;
    end;

    return true;
end;

local function maximumHullDistance(p55: table, p56: vector, p57: vector) -- Line: 293
    -- upvalues: planeDistance (copy)
    local v58 = (-1 / 0);
    local v59 = Vector3.new(0, 1, 0);

    for i = 1, p55.NormalCount do
        local v60 = p55.Normals[i];
        local v61 = p56:Dot(v60) - planeDistance(p55, i, p57);
        local v62;

        if v58 < v61 then
            v59 = v60;
            v58 = v61;
            v62 = i;
        else
            v62 = i;
        end;
    end;

    return v58, v59;
end;

local function pointSegmentDistanceSquared(p63: vector, p64: vector, p65: vector) -- Line: 307
    local v66 = p65 - p64;
    local v67 = v66:Dot(v66);

    if v67 <= 1e-18 then
        local v68 = p63 - p64;

        return v68:Dot(v68);
    end;

    local v69 = (p63 - p64):Dot(v66) / v67;
    local v70 = p63 - (p64 + v66 * math.clamp(v69, 0, 1));

    return v70:Dot(v70);
end;

local function couldReachAnyBody(p71: table, p72: table, p73: any) -- Line: 320
    -- upvalues: pointSegmentDistanceSquared (copy)
    local Position = p71.PreviousCFrame.Position;
    local Position2 = p71.CFrame.Position;
    local v74 = math.max(p73.ContactEpsilon, p73.BrushEpsilon) + p73.BroadphasePadding;

    for _, v in p72 do
        local BoundingRadius = p71.BoundingRadius;
        local Stance = v.Stance;
        local v75;

        if Stance == "Standing" then
            v75 = p73.StandingHalfSize;
        elseif Stance == "Ducking" then
            v75 = p73.DuckingHalfSize;
        else
            error("contact mover body has an invalid stance", 3);
            v75 = nil;
        end;

        local v76 = BoundingRadius + v75.Magnitude + v74;

        if pointSegmentDistanceSquared(v.Position, Position, Position2) <= v76 * v76 then
            return true;
        end;
    end;

    return false;
end;

local function boundsOverlapHull(p77: table, p78: vector, p79: vector, p80: vector, p81: number) -- Line: 333
    local v82 = p77.RotationPadding + p81;
    local v83 = p77.SourceWorldHalf + p80 + Vector3.new(v82, v82, v82);
    local v84 = p77.Center - v83;
    local v85 = p77.Center + v83;
    local v86;

    if math.min(p78.X, p79.X) <= v85.X and (math.max(p78.X, p79.X) >= v84.X and (math.min(p78.Y, p79.Y) <= v85.Y and (math.max(p78.Y, p79.Y) >= v84.Y and math.min(p78.Z, p79.Z) <= v85.Z))) then
        v86 = math.max(p78.Z, p79.Z) >= v84.Z;
    else
        v86 = false;
    end;

    return v86;
end;

local function sweepHull(p87: table, p88: vector, p89: vector, p90: vector, p91: any, p92: boolean?) -- Line: 353
    -- upvalues: boundsOverlapHull (copy), planeDistance (copy)
    if not boundsOverlapHull(p87, p88, p89, p90, p91.BroadphasePadding) then
        return nil, Vector3.new(0, 1, 0), false, false, 0;
    end;

    local v93 = p89 - p88;
    local Magnitude = v93.Magnitude;
    local v94 = (-1 / 0);
    local v95 = (1 / 0);
    local v96 = false;
    local v97 = false;
    local v98 = 1;
    local v99 = (-1 / 0);
    local v100 = false;
    local v101 = -1;
    local v102 = (1 / 0);
    local v103 = Vector3.new(0, 1, 0);
    local v104 = Vector3.new(0, 1, 0);

    for i = 1, p87.NormalCount do
        local v105 = p87.Normals[i];
        local v106 = p88:Dot(v105) - planeDistance(p87, i, p90);
        local v107 = v106 + v93:Dot(v105);

        if v94 + p91.BrushEpsilon < v106 or math.abs(v106 - v94) <= p91.BrushEpsilon and i < v102 then
            v104 = v105;
            v102 = i;
        end;

        v94 = math.max(v94, v106);
        v99 = math.max(v99, v107);
        v100 = v100 or v106 > 0;
        v96 = v96 or v107 > 0;

        if v106 > 0 and v107 > 0 then
            return nil, Vector3.new(0, 1, 0), false, false, 0;
        end;

        local v108;

        if v106 > 0 or v107 > 0 then
            if v107 < v106 then
                local math_max_ret = math.max(0, (v106 - p91.BrushEpsilon) / (v106 - v107));
                local v109 = math.abs(math_max_ret - v101) * Magnitude;

                if v97 and (p91.BrushEpsilon >= v109 or v101 >= math_max_ret) and (v109 > p91.BrushEpsilon or i >= v95) then
                    v105 = v103;
                else
                    v95 = i;
                end;

                v101 = math.max(v101, math_max_ret);
                v103 = v105;
                v108 = i;
                v97 = true;
            else
                local math_min_ret = math.min(1, (v106 + p91.BrushEpsilon) / (v106 - v107));
                v98 = math.min(v98, math_min_ret);
                v108 = i;
            end;
        else
            v108 = i;
        end;
    end;

    if v100 then
        if v97 and (v101 >= 0 and v98 > v101) then
            return math.max(0, v101), v103, false, false, v95;
        end;

        return nil, Vector3.new(0, 1, 0), false, false, 0;
    end;

    if (v96 or p92 == true) and (v94 < v99 and (p91.ContactEpsilon < Magnitude and v93.Unit:Dot(v104) > 0.25)) then
        return nil, Vector3.new(0, 1, 0), false, false, 0;
    end;

    local v110 = 0;
    local v111 = true;
    local v112 = not v96 and v99 < v94;

    if v102 < (1 / 0) then
        return v110, v104, v111, v112, v102;
    end;

    return v110, v104, v111, v112, 0;
end;

local function prepareContactProxy(p113: table, p114: table, p115: any) -- Line: 440
    -- upvalues: u1 (copy), prepareHull (copy)
    if p113.PreviousPose == p114.PreviousCFrame and (p113.Pose == p114.CFrame and (p113.Size == p114.Size and p113.Config == p115)) then
        return;
    end;

    local math_abs_ret = math.abs(p114.RotationAngle);

    if u1.ContactMaxRotationRadiansPerTick + 1e-9 < math_abs_ret then
        error(string.format("contact mover %d rotates %.4f degrees in one tick; authored maximum is %.4f", p114.Id, math.deg(math_abs_ret), (math.deg(u1.ContactMaxRotationRadiansPerTick))), 3);
    end;

    local math_ceil_ret = math.ceil(math_abs_ret / u1.ContactMaxRotationRadiansPerSubdivision - 1e-12);
    local math_max_ret = math.max(1, math_ceil_ret);
    assert(math_max_ret <= u1.ContactMaxRotationSubdivisions, "contact mover subdivision capacity exceeded");
    p113.SubstepCount = math_max_ret;
    prepareHull(p113, p113.StartHull, p114, p114.PreviousCFrame, 0, p115);
    prepareHull(p113, p113.EndHull, p114, p114.CFrame, 0, p115);

    for i = 1, math_max_ret do
        local v116 = (i - 1) / math_max_ret;
        local v117 = i / math_max_ret;
        local v118 = p114.PreviousCFrame:Lerp(p114.CFrame, (v116 + v117) * 0.5);
        local v119 = p113.Substeps[i];
        v119.TimeStart = v116;
        v119.TimeEnd = v117;
        v119.ReferenceCenter = v118.Position;
        prepareHull(p113, v119.Hull, p114, v118, p114.BoundingRadius * 2 * math.sin(math_abs_ret / math_max_ret * 0.25), p115);
        local _ = i;
    end;

    p113.PreviousPose = p114.PreviousCFrame;
    p113.Pose = p114.CFrame;
    p113.Size = p114.Size;
    p113.Config = p115;
end;

function u1.new() -- Line: 495
    -- upvalues: u1 (copy)
    local v120 = {
        _activeBank = 0,
        _banks = { {
                EndpointsById = {}
            }, {
                EndpointsById = {}
            } },
        _contactById = {},
        _endpointScratch = {
            ScratchCount = 0,
            ScratchDirections = table.create(30, Vector3.new(0, 0, 0))
        }
    };

    return setmetatable(v120, u1);
end;

function u1.BeginComposition(p121) -- Line: 510
    p121._activeBank = p121._activeBank == 1 and 2 or 1;
end;

function u1.ReserveMover(p122: any, p123: number) -- Line: 514
    -- upvalues: newContactHull (copy)
    local v124;

    if p123 % 1 == 0 then
        v124 = p123 > 0;
    else
        v124 = false;
    end;

    assert(v124, "mover ID must be a positive integer");

    if p122._banks[1].EndpointsById[p123] == nil then
        for _, v in p122._banks do
            v.EndpointsById[p123] = {
                Record = nil,
                Pose = nil,
                Size = nil,
                Config = nil,
                Hull = newContactHull()
            };
        end;

        return;
    end;

    assert(p122._banks[2].EndpointsById[p123] ~= nil, "mover endpoint proxy banks diverged");
end;

function u1.ReserveContactMover(p125: any, p126: number) -- Line: 531
    -- upvalues: newContactProxy (copy)
    p125:ReserveMover(p126);

    if p125._contactById[p126] == nil then
        p125._contactById[p126] = newContactProxy();
    end;
end;

function u1.BindEndpoint(p127: any, p128: table, p129: any) -- Line: 538
    -- upvalues: prepareHull (copy)
    assert(p127._activeBank ~= 0, "mover proxy cache composition was not begun");
    local v130 = p127._banks[p127._activeBank].EndpointsById[p128.Id];

    if v130 == nil then
        error(string.format("mover %d endpoint proxy was not reserved at registration", p128.Id), 2);
    end;

    if v130.Pose ~= p128.CFrame or (v130.Size ~= p128.Size or v130.Config ~= p129) then
        prepareHull(p127._endpointScratch, v130.Hull, p128, p128.CFrame, 0, p129);
        v130.Pose = p128.CFrame;
        v130.Size = p128.Size;
        v130.Config = p129;
    end;

    v130.Record = p128;

    return v130;
end;

function u1.SweepEndpoint(p131: table, p132: vector, p133: vector, p134: string, p135: any) -- Line: 554
    -- upvalues: sweepHull (copy)
    local Hull = p131.Hull;
    local v136;

    if p134 == "Standing" then
        v136 = p135.StandingHalfSize;
    elseif p134 == "Ducking" then
        v136 = p135.DuckingHalfSize;
    else
        error("contact mover body has an invalid stance", 3);
        v136 = nil;
    end;

    return sweepHull(Hull, p132, p133, v136, p135, true);
end;

function u1.ContainsEndpoint(p137: table, p138: vector, p139: string, p140: any) -- Line: 565
    -- upvalues: containsHull (copy)
    local Hull = p137.Hull;
    local v141;

    if p139 == "Standing" then
        v141 = p140.StandingHalfSize;
    elseif p139 == "Ducking" then
        v141 = p140.DuckingHalfSize;
    else
        error("contact mover body has an invalid stance", 3);
        v141 = nil;
    end;

    return containsHull(Hull, p138, v141, p140);
end;

function u1.PenetratesEndpoint(p142: table, p143: vector, p144: string, p145: any) -- Line: 575
    -- upvalues: planeDistance (copy)
    local Hull = p142.Hull;
    local v146;

    if p144 == "Standing" then
        v146 = p145.StandingHalfSize;
    elseif p144 == "Ducking" then
        v146 = p145.DuckingHalfSize;
    else
        error("contact mover body has an invalid stance", 3);
        v146 = nil;
    end;

    for i = 1, Hull.NormalCount do
        if p143:Dot(Hull.Normals[i]) - planeDistance(Hull, i, v146) > 0 then
            return false;
        end;

        local _ = i;
    end;

    return true;
end;

function u1.PushExitDistances(p147: table, p148: vector, p149: vector, p150: string, p151: any, p152: number) -- Line: 592
    -- upvalues: planeDistance (copy)
    local Hull = p147.Hull;
    local v153;

    if p150 == "Standing" then
        v153 = p151.StandingHalfSize;
    elseif p150 == "Ducking" then
        v153 = p151.DuckingHalfSize;
    else
        error("contact mover body has an invalid stance", 3);
        v153 = nil;
    end;

    local v154 = (1 / 0);
    local v155 = (1 / 0);

    for i = 1, Hull.NormalCount do
        local v156 = Hull.Normals[i];
        local v157 = p148:Dot(v156) - planeDistance(Hull, i, v153);

        if v157 > 0 then
            return nil, (1 / 0);
        end;

        local v158 = p149:Dot(v156);
        local v159;

        if p151.PlaneNormalEpsilon < v158 then
            v154 = math.min(v154, (p152 - v157) / v158);
            v159 = i;
        elseif v158 < -p151.PlaneNormalEpsilon then
            v155 = math.min(v155, (p152 - v157) / -v158);
            v159 = i;
        else
            v159 = i;
        end;
    end;

    return v154, v155;
end;

function u1.Retire(p160: any, p161: number) -- Line: 619
    for _, v in p160._banks do
        v.EndpointsById[p161] = nil;
    end;

    p160._contactById[p161] = nil;
end;

function u1.Reset(p162) -- Line: 626
    for _, v in p162._banks do
        table.clear(v.EndpointsById);
    end;

    table.clear(p162._contactById);
    p162._endpointScratch.ScratchCount = 0;
    p162._activeBank = 0;
end;

function u1.FindEarliestStationaryContact(p163: any, p164: table, p165: table, p166: any) -- Line: 636
    -- upvalues: couldReachAnyBody (copy), prepareContactProxy (copy), pointSegmentDistanceSquared (copy), maximumHullDistance (copy), sweepHull (copy)
    if #p165 == 0 then
        return nil, nil, nil;
    end;

    local v167 = p163._contactById[p164.Id];

    if v167 == nil then
        error(string.format("contact mover %d was not reserved at registration", p164.Id), 2);
    end;

    if not couldReachAnyBody(p164, p165, p166) then
        return nil, nil, nil;
    end;

    prepareContactProxy(v167, p164, p166);
    local Position = p164.PreviousCFrame.Position;
    local Position2 = p164.CFrame.Position;
    local v168 = math.max(p166.ContactEpsilon, p166.BrushEpsilon) + p166.BroadphasePadding;
    local v169 = nil;
    local v170 = nil;
    local v171 = nil;

    for i, v in p165 do
        local BoundingRadius = p164.BoundingRadius;
        local Stance = v.Stance;
        local v172;

        if Stance == "Standing" then
            v172 = p166.StandingHalfSize;
        elseif Stance == "Ducking" then
            v172 = p166.DuckingHalfSize;
        else
            error("contact mover body has an invalid stance", 3);
            v172 = nil;
        end;

        local v173 = BoundingRadius + v172.Magnitude + v168;

        if pointSegmentDistanceSquared(v.Position, Position, Position2) <= v173 * v173 then
            local v174 = v.Id or i;
            local Stance2 = v.Stance;
            local v175;

            if Stance2 == "Standing" then
                v175 = p166.StandingHalfSize;
            elseif Stance2 == "Ducking" then
                v175 = p166.DuckingHalfSize;
            else
                error("contact mover body has an invalid stance", 3);
                v175 = nil;
            end;

            local math_max_ret = math.max(p166.ContactEpsilon, p166.BrushEpsilon);
            local v176, v177 = maximumHullDistance(v167.StartHull, v.Position, v175);

            if v176 <= math_max_ret then
                if maximumHullDistance(v167.EndHull, v.Position, v175) <= v176 + math_max_ret then
                    return 0, v177, v174;
                end;
            else
                local v178 = v;

                for i2 = 1, v167.SubstepCount do
                    local v179 = v167.Substeps[i2];

                    if v169 ~= nil and v169 <= v179.TimeStart then
                        break;
                    end;

                    local v180 = p164.PreviousCFrame.Position:Lerp(p164.CFrame.Position, v179.TimeStart);
                    local v181 = p164.PreviousCFrame.Position:Lerp(p164.CFrame.Position, v179.TimeEnd);
                    local v182, v183 = sweepHull(v179.Hull, v178.Position - v180 + v179.ReferenceCenter, v178.Position - v181 + v179.ReferenceCenter, v175, p166);

                    if v182 ~= nil then
                        local v184 = v179.TimeStart + (v179.TimeEnd - v179.TimeStart) * v182;

                        if v169 == nil or v184 < v169 then
                            v171 = v174;
                            v170 = v183;
                            v169 = v184;
                        end;

                        if v184 <= 0 then
                            return 0, v183, v174;
                        end;

                        break;
                    end;

                    local _ = i2;
                end;
            end;
        end;
    end;

    return v169, v170, v171;
end;

return u1;