-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2: vector, p3: number) -- Line: 6
    -- upvalues: u1 (copy)
    return setmetatable({
        next = nil,
        prev = nil,
        face = nil,
        point = p2,
        index = p3
    }, u1);
end;

local u4 = {};
u4.__index = u4;

function u4.new() -- Line: 19
    -- upvalues: u4 (copy)
    return setmetatable({
        head = nil,
        tail = nil
    }, u4);
end;

function u4.clear(p5) -- Line: 26
    p5.head = nil;
    p5.tail = nil;
end;

function u4.first(p6) -- Line: 31
    return p6.head;
end;

function u4.isEmpty(p7) -- Line: 35
    return p7.head == nil;
end;

function u4.add(p8, p9) -- Line: 39
    if p8.head then
        p8.tail.next = p9;
    else
        p8.head = p9;
    end;

    p9.prev = p8.tail;
    p9.next = nil;
    p8.tail = p9;
end;

function u4.addAll(p10, p11) -- Line: 50
    if p10.head then
        p10.tail.next = p11;
    else
        p10.head = p11;
    end;

    p11.prev = p10.tail;

    while p11.next do
        p11 = p11.next;
    end;

    p10.tail = p11;
end;

function u4.insertBefore(p12, p13, p14) -- Line: 63
    p14.prev = p13.prev;
    p14.next = p13;

    if p14.prev then
        p14.prev.next = p14;
    else
        p12.head = p14;
    end;

    p13.prev = p14;
end;

function u4.remove(p15, p16) -- Line: 74
    if p16.prev then
        p16.prev.next = p16.next;
    else
        p15.head = p16.next;
    end;

    if p16.next then
        p16.next.prev = p16.prev;

        return;
    end;

    p15.tail = p16.prev;
end;

function u4.removeChain(p17, p18, p19) -- Line: 87
    if p18.prev then
        p18.prev.next = p19.next;
    else
        p17.head = p19.next;
    end;

    if p19.next then
        p19.next.prev = p18.prev;

        return;
    end;

    p17.tail = p18.prev;
end;

local u20 = {};
u20.__index = u20;

function u20.new(p21, p22) -- Line: 103
    -- upvalues: u20 (copy)
    return setmetatable({
        next = nil,
        prev = nil,
        opposite = nil,
        vertex = p21,
        face = p22
    }, u20);
end;

function u20.head(p23) -- Line: 113
    return p23.vertex;
end;

function u20.tail(p24) -- Line: 117
    if p24.prev then
        return p24.prev.vertex;
    end;

    return nil;
end;

function u20.lengthSquared(p25) -- Line: 121
    local v26 = p25:tail();

    if not v26 then
        return -1;
    end;

    local v27 = p25:head().point - v26.point;

    return v27.X * v27.X + v27.Y * v27.Y + v27.Z * v27.Z;
end;

function u20.setOpposite(p28, p29) -- Line: 130
    p28.opposite = p29;
    p29.opposite = p28;
end;

local u30 = {};
u30.__index = u30;

function u30.new() -- Line: 138
    -- upvalues: u30 (copy)
    return setmetatable({
        normal = Vector3.new(0, 0, 0),
        centroid = Vector3.new(0, 0, 0),
        offset = 0,
        outside = nil,
        mark = 0,
        edge = nil,
        nVertices = 0,
        area = 0
    }, u30);
end;

function u30.createTriangle(p31: any, p32: any, p33: any, p34: number?) -- Line: 151
    -- upvalues: u30 (copy), u20 (copy)
    local v35 = u30.new();
    local v36 = u20.new(p31, v35);
    local v37 = u20.new(p32, v35);
    local v38 = u20.new(p33, v35);
    v36.next = v37;
    v37.prev = v36;
    v37.next = v38;
    v38.prev = v37;
    v38.next = v36;
    v36.prev = v38;
    v35.edge = v36;
    v35:computeNormalAndCentroid(p34 or 0);

    return v35;
end;

function u30.getEdge(p39: table, p40: number) -- Line: 169
    local edge = p39.edge;

    while p40 > 0 do
        edge = edge.next;
        p40 = p40 - 1;
    end;

    while p40 < 0 do
        edge = edge.prev;
        p40 = p40 + 1;
    end;

    return edge;
end;

function u30.computeNormal(p41) -- Line: 182
    local edge = p41.edge;
    local next = edge.next;
    local next2 = next.next;
    local v42 = next:head().point - edge:head().point;
    p41.nVertices = 2;
    p41.normal = Vector3.new(0, 0, 0);

    while next2 ~= edge do
        local v43 = next2:head().point - edge:head().point;
        p41.normal = p41.normal + v42:Cross(v43);
        next2 = next2.next;
        p41.nVertices = p41.nVertices + 1;
        v42 = v43;
    end;

    p41.area = p41.normal.Magnitude;

    if p41.area > 0 then
        p41.normal = p41.normal / p41.area;

        return;
    end;

    p41.normal = Vector3.new(0, 1, 0);
end;

function u30.computeNormalMinArea(p44: table, p45: number) -- Line: 207
    p44:computeNormal();

    if p45 <= p44.area then
        return;
    end;

    local edge = p44.edge;
    local v46 = 0;
    local v47 = nil;

    while true do
        local v48 = edge:lengthSquared();

        if v46 < v48 then
            v47 = edge;
        else
            v48 = v46;
        end;

        edge = edge.next;

        if edge == p44.edge then
            if not v47 or v48 <= 0 then
                return;
            end;

            local v49 = v47:tail();

            if not v49 then
                return;
            end;

            local Unit = (v47:head().point - v49.point).Unit;
            p44.normal = p44.normal - Unit * p44.normal:Dot(Unit);

            if p44.normal.Magnitude > 0 then
                p44.normal = p44.normal.Unit;

                return;
            end;

            p44.normal = Vector3.new(0, 1, 0);

            return;
        end;

        v46 = v48;
    end;
end;

function u30.computeCentroid(p50) -- Line: 243
    p50.centroid = Vector3.new(0, 0, 0);
    local edge = p50.edge;

    repeat
        p50.centroid = p50.centroid + edge:head().point;
        edge = edge.next;
    until edge == p50.edge;

    p50.centroid = p50.centroid / p50.nVertices;
end;

function u30.computeNormalAndCentroid(p51: table, p52: number?) -- Line: 253
    if p52 and p52 > 0 then
        p51:computeNormalMinArea(p52);
    else
        p51:computeNormal();
    end;

    p51:computeCentroid();
    p51.offset = p51.normal:Dot(p51.centroid);
end;

function u30.distanceToPlane(p53: table, p54: vector) -- Line: 263
    return p53.normal:Dot(p54) - p53.offset;
end;

function u30.connectHalfEdges(p55, p56, p57) -- Line: 267
    if p56.opposite.face ~= p57.opposite.face then
        p56.next = p57;
        p57.prev = p56;

        return nil;
    end;

    local face = p57.opposite.face;

    if p56 == p55.edge then
        p55.edge = p57;
    end;

    local v58 = nil;
    local v59;

    if face.nVertices == 3 then
        v59 = p57.opposite.prev.opposite;
        face.mark = 2;
        v58 = face;
    else
        v59 = p57.opposite.next;

        if face.edge == v59.prev then
            face.edge = v59;
        end;

        v59.prev = v59.prev.prev;
        v59.prev.next = v59;
    end;

    p57.prev = p56.prev;
    p57.prev.next = p57;
    p57:setOpposite(v59);
    face:computeNormalAndCentroid();

    return v58;
end;

function u30.mergeAdjacentFaces(p60, p61, p62) -- Line: 302
    local face = p61.opposite.face;
    table.insert(p62, face);
    face.mark = 2;
    local prev = p61.prev;
    local next = p61.next;
    local prev2 = p61.opposite.prev;
    local next2 = p61.opposite.next;

    while prev.opposite.face == face do
        prev = prev.prev;
        next2 = next2.next;
    end;

    while next.opposite.face == face do
        next = next.next;
        prev2 = prev2.prev;
    end;

    local v63 = next2;

    while next2 ~= prev2.next do
        next2.face = p60;
        next2 = next2.next;
    end;

    p60.edge = next;
    local v64 = p60:connectHalfEdges(prev2, next);

    if v64 then
        table.insert(p62, v64);
    end;

    local v65 = p60:connectHalfEdges(prev, v63);

    if v65 then
        table.insert(p62, v65);
    end;

    p60:computeNormalAndCentroid();

    return p62;
end;

function u30.collectIndices(p66) -- Line: 345
    local edge = p66.edge;
    local v67 = {};

    repeat
        local index = edge:head().index;
        table.insert(v67, index);
        edge = edge.next;
    until edge == p66.edge;

    return v67;
end;

local u68 = {};
u68.__index = u68;
local u69 = { "X", "Y", "Z" };

local function getAxisValue(p70: vector, p71: number) -- Line: 360
    if p71 == 1 then
        return p70.X;
    end;

    if p71 == 2 then
        return p70.Y;
    end;

    return p70.Z;
end;

local function appendArray(p72: table, p73: table) -- Line: 370
    local table_clone_ret = table.clone(p72);

    for _, v in ipairs(p73) do
        table.insert(table_clone_ret, v);
    end;

    return table_clone_ret;
end;

local function distancePointToLine(p74: vector, p75: vector, p76: vector) -- Line: 378
    local v77 = p76 - p75;

    if v77.Magnitude <= 0 then
        error("line points are identical");
    end;

    return (p74 - p75):Cross(v77).Magnitude / v77.Magnitude;
end;

function u68.new(p78: table) -- Line: 386
    -- upvalues: u4 (copy), u68 (copy), u1 (copy)
    assert(#p78 >= 4, "cannot build a simplex out of < 4 points");
    local v79 = {
        tolerance = -1,
        faces = {},
        newFaces = {},
        claimed = u4.new(),
        unclaimed = u4.new(),
        vertices = {}
    };
    local v80 = setmetatable(v79, u68);

    for i, v in ipairs(p78) do
        table.insert(v80.vertices, u1.new(v, i));
    end;

    return v80;
end;

function u68.addVertexToFace(p81, p82, p83) -- Line: 405
    p82.face = p83;

    if p83.outside then
        p81.claimed:insertBefore(p83.outside, p82);
    else
        p81.claimed:add(p82);
    end;

    p83.outside = p82;
end;

function u68.removeVertexFromFace(p84, p85, p86) -- Line: 415
    if p85 == p86.outside then
        if p85.next and p85.next.face == p86 then
            p86.outside = p85.next;
        else
            p86.outside = nil;
        end;
    end;

    p84.claimed:remove(p85);
end;

function u68.removeAllVerticesFromFace(p87, p88) -- Line: 426
    if not p88.outside then
        return nil;
    end;

    local outside = p88.outside;

    while outside.next and outside.next.face == p88 do
        outside = outside.next;
    end;

    p87.claimed:removeChain(p88.outside, outside);
    outside.next = nil;

    return p88.outside;
end;

function u68.deleteFaceVertices(p89, p90, p91) -- Line: 440
    local v92 = p89:removeAllVerticesFromFace(p90);

    if not v92 then
        return;
    end;

    if p91 then
        while v92 do
            local next = v92.next;

            if p91:distanceToPlane(v92.point) > p89.tolerance then
                p89:addVertexToFace(v92, p91);
                v92 = next;
            else
                p89.unclaimed:add(v92);
                v92 = next;
            end;
        end;

        return;
    end;

    p89.unclaimed:addAll(v92);
end;

function u68.resolveUnclaimedPoints(p93, p94) -- Line: 463
    local v95 = p93.unclaimed:first();

    while true do
        if not v95 then
            return;
        end;

        local next = v95.next;
        local tolerance = p93.tolerance;
        local v96 = nil;

        for _, v in ipairs(p94) do
            if v.mark == 0 then
                local v97 = v:distanceToPlane(v95.point);

                if tolerance < v97 then
                    if 1000 * p93.tolerance < v97 then
                        v96 = v;
                        break;
                    end;

                    v96 = v;
                    tolerance = v97;
                end;
            end;
        end;

        if v96 then
            p93:addVertexToFace(v95, v96);
            v95 = next;
        else
            v95 = next;
        end;
    end;
end;

function u68.computeExtremes(p98) -- Line: 490
    -- upvalues: u69 (copy)
    local v99 = { p98.vertices[1], p98.vertices[1], p98.vertices[1] };
    local v100 = { p98.vertices[1], p98.vertices[1], p98.vertices[1] };
    local v101 = { p98.vertices[1].point.X, p98.vertices[1].point.Y, p98.vertices[1].point.Z };
    local v102 = { p98.vertices[1].point.X, p98.vertices[1].point.Y, p98.vertices[1].point.Z };

    for i = 2, #p98.vertices do
        local v103 = p98.vertices[i];
        local _ = i;

        for i2, _ in ipairs(u69) do
            local point = v103.point;
            local v104;

            if i2 == 1 then
                v104 = point.X;
            elseif i2 == 2 then
                v104 = point.Y;
            else
                v104 = point.Z;
            end;

            if v104 < v101[i2] then
                v101[i2] = v104;
                v99[i2] = v103;
            end;

            if v102[i2] < v104 then
                v102[i2] = v104;
                v100[i2] = v103;
            end;
        end;
    end;

    local math_abs_ret = math.abs(v101[1]);
    local math_abs_ret2 = math.abs(v102[1]);
    local math_max_ret = math.max(math_abs_ret, math_abs_ret2);
    local math_abs_ret3 = math.abs(v101[2]);
    local math_abs_ret4 = math.abs(v102[2]);
    local v105 = math_max_ret + math.max(math_abs_ret3, math_abs_ret4);
    local math_abs_ret5 = math.abs(v101[3]);
    local math_abs_ret6 = math.abs(v102[3]);
    p98.tolerance = (v105 + math.max(math_abs_ret5, math_abs_ret6)) * 0.0003;

    return v99, v100;
end;

function u68.createInitialSimplex(p106) -- Line: 520
    -- upvalues: u69 (copy), u30 (copy)
    local v107, v108 = p106:computeExtremes();
    local v109 = 0;
    local v110 = 1;

    for i, _ in ipairs(u69) do
        local point = v108[i].point;
        local v111;

        if i == 1 then
            v111 = point.X;
        elseif i == 2 then
            v111 = point.Y;
        else
            v111 = point.Z;
        end;

        local point2 = v107[i].point;
        local v112;

        if i == 1 then
            v112 = point2.X;
        elseif i == 2 then
            v112 = point2.Y;
        else
            v112 = point2.Z;
        end;

        local v113 = v111 - v112;

        if v109 < v113 then
            v110 = i;
            v109 = v113;
        end;
    end;

    local v114 = v107[v110];
    local v115 = v108[v110];

    if v109 <= p106.tolerance then
        return nil;
    end;

    local v116 = 0;
    local v117 = nil;

    for _, v in ipairs(p106.vertices) do
        if v ~= v114 and v ~= v115 then
            local point = v.point;
            local point2 = v114.point;
            local v118 = v115.point - point2;

            if v118.Magnitude <= 0 then
                error("line points are identical");
            end;

            local v119 = (point - point2):Cross(v118).Magnitude / v118.Magnitude;

            if v116 < v119 then
                v117 = v;
                v116 = v119;
            end;
        end;
    end;

    if not v117 or v116 <= p106.tolerance then
        return nil;
    end;

    local v120 = (v114.point - v115.point):Cross(v115.point - v117.point);

    if v120.Magnitude <= p106.tolerance then
        return nil;
    end;

    local Unit = v120.Unit;
    local v121 = v114.point:Dot(Unit);
    local v122 = 0;
    local v123 = nil;

    for _, v in ipairs(p106.vertices) do
        if v ~= v114 and (v ~= v115 and v ~= v117) then
            local v124 = Unit:Dot(v.point) - v121;
            local math_abs_ret = math.abs(v124);

            if v122 < math_abs_ret then
                v123 = v;
                v122 = math_abs_ret;
            end;
        end;
    end;

    if not v123 or v122 <= p106.tolerance then
        return nil;
    end;

    local v125;

    if v123.point:Dot(Unit) - v121 < 0 then
        local v126 = {
            u30.createTriangle(v114, v115, v117),
            u30.createTriangle(v123, v115, v114),
            u30.createTriangle(v123, v117, v115),
            u30.createTriangle(v123, v114, v117)
        };
        v125 = table.clone({});

        for _, v in ipairs(v126) do
            table.insert(v125, v);
        end;

        for i = 0, 2 do
            local v127 = (i + 1) % 3;
            v125[i + 2]:getEdge(2):setOpposite(v125[1]:getEdge(v127));
            v125[i + 2]:getEdge(1):setOpposite(v125[v127 + 2]:getEdge(0));
            local _ = i;
        end;
    else
        local v128 = {
            u30.createTriangle(v114, v117, v115),
            u30.createTriangle(v123, v114, v115),
            u30.createTriangle(v123, v115, v117),
            u30.createTriangle(v123, v117, v114)
        };
        v125 = table.clone({});

        for _, v in ipairs(v128) do
            table.insert(v125, v);
        end;

        for i = 0, 2 do
            v125[i + 2]:getEdge(2):setOpposite(v125[1]:getEdge((3 - i) % 3));
            v125[i + 2]:getEdge(0):setOpposite(v125[(i + 1) % 3 + 2]:getEdge(1));
            local _ = i;
        end;
    end;

    p106.faces = v125;

    for _, v in ipairs(p106.vertices) do
        if v ~= v114 and (v ~= v115 and (v ~= v117 and v ~= v123)) then
            local tolerance = p106.tolerance;
            local v129 = v;
            local v130 = nil;

            for _, v2 in ipairs(v125) do
                local v131 = v2:distanceToPlane(v129.point);

                if tolerance < v131 then
                    v130 = v2;
                    tolerance = v131;
                end;
            end;

            if v130 then
                p106:addVertexToFace(v129, v130);
            end;
        end;
    end;

    return true;
end;

function u68.reindexFaceAndVertices(p132) -- Line: 628
    local v133 = {};

    for _, v in ipairs(p132.faces) do
        if v.mark == 0 then
            table.insert(v133, v);
        end;
    end;

    p132.faces = v133;
end;

function u68.collectFaces(p134: table, p135: boolean?) -- Line: 638
    local v136 = {};

    for _, v in ipairs(p134.faces) do
        assert(v.mark == 0, "attempt to include a destroyed face in the hull");
        local v137 = v:collectIndices();

        if p135 then
            table.insert(v136, v137);
        else
            for i = 1, #v137 - 2 do
                table.insert(v136, { v137[1], v137[i + 1], v137[i + 2] });
                local _ = i;
            end;
        end;
    end;

    return v136;
end;

function u68.nextVertexToAdd(p138) -- Line: 654
    if p138.claimed:isEmpty() then
        return nil;
    end;

    local face = p138.claimed:first().face;
    local outside = face.outside;
    local v139 = 0;
    local v140 = nil;

    while outside and outside.face == face do
        local v141 = face:distanceToPlane(outside.point);

        if v139 < v141 then
            v140 = outside;
        else
            v141 = v139;
        end;

        outside = outside.next;
        v139 = v141;
    end;

    return v140;
end;

function u68.computeHorizon(p142: table, p143: vector, p144: any, p145: any, p146: any) -- Line: 676
    p142:deleteFaceVertices(p145);
    p145.mark = 2;
    local v147;

    if p144 then
        v147 = p144.next;
    else
        v147 = p145:getEdge(0);
    end;

    local v148 = p144 or v147;

    while true do
        local opposite = v147.opposite;
        local face = opposite.face;

        if face.mark == 0 then
            if face:distanceToPlane(p143) > p142.tolerance then
                p142:computeHorizon(p143, opposite, face, p146);
            else
                table.insert(p146, v147);
            end;
        end;

        v147 = v147.next;

        if v147 == v148 then
            return;
        end;
    end;
end;

function u68.addAdjoiningFace(p149, p150, p151) -- Line: 700
    -- upvalues: u30 (copy)
    local v152 = u30.createTriangle(p150, p151:tail(), p151:head());
    table.insert(p149.faces, v152);
    v152:getEdge(-1):setOpposite(p151.opposite);

    return v152:getEdge(0);
end;

function u68.addNewFaces(p153, p154, p155) -- Line: 707
    p153.newFaces = {};
    local v156 = nil;
    local v157 = nil;

    for _, v in ipairs(p155) do
        local v158 = p153:addAdjoiningFace(p154, v);

        if v156 then
            v158.next:setOpposite(v157);
        else
            v156 = v158;
        end;

        table.insert(p153.newFaces, v158.face);
        v157 = v158;
    end;

    if v156 and v157 then
        v156.next:setOpposite(v157);
    end;
end;

function u68.oppositeFaceDistance(p159, p160) -- Line: 728
    return p160.face:distanceToPlane(p160.opposite.face.centroid);
end;

function u68.doAdjacentMerge(p161: table, p162: any, p163: number) -- Line: 732
    local edge = p162.edge;
    local v164 = 0;
    local v165 = true;

    while true do
        if p162.nVertices < v164 then
            error("merge recursion limit exceeded");
        end;

        local face = edge.opposite.face;
        local v166 = false;

        if p163 == 2 then
            v166 = p161:oppositeFaceDistance(edge) > -p161.tolerance and true or p161:oppositeFaceDistance(edge.opposite) > p161.tolerance;
        elseif p162.area > face.area then
            if p161:oppositeFaceDistance(edge) > -p161.tolerance then
                v166 = true;
            elseif p161:oppositeFaceDistance(edge.opposite) > -p161.tolerance then
                v165 = false;
            end;
        elseif p161:oppositeFaceDistance(edge.opposite) > -p161.tolerance then
            v166 = true;
        elseif p161:oppositeFaceDistance(edge) > -p161.tolerance then
            v165 = false;
        end;

        if v166 then
            local v167 = p162:mergeAdjacentFaces(edge, {});

            for _, v in ipairs(v167) do
                p161:deleteFaceVertices(v, p162);
            end;

            return true;
        end;

        edge = edge.next;
        v164 = v164 + 1;

        if edge == p162.edge then
            if not v165 then
                p162.mark = 1;
            end;

            return false;
        end;
    end;
end;

function u68.addVertexToHull(p168, p169) -- Line: 783
    local v170 = {};
    p168.unclaimed:clear();
    p168:removeVertexFromFace(p169, p169.face);
    p168:computeHorizon(p169.point, nil, p169.face, v170);
    p168:addNewFaces(p169, v170);

    for _, v in ipairs(p168.newFaces) do
        if v.mark == 0 then
            while p168:doAdjacentMerge(v, 1) do

            end;
        end;
    end;

    for _, v in ipairs(p168.newFaces) do
        if v.mark == 1 then
            v.mark = 0;

            while p168:doAdjacentMerge(v, 2) do

            end;
        end;
    end;

    p168:resolveUnclaimedPoints(p168.newFaces);
end;

function u68.build(p171) -- Line: 808
    if not p171:createInitialSimplex() then
        return false;
    end;

    local v172 = p171:nextVertexToAdd();

    while v172 do
        p171:addVertexToHull(v172);
        v172 = p171:nextVertexToAdd();
    end;

    p171:reindexFaceAndVertices();

    return true;
end;

function u68.GenerateHull(p173: table) -- Line: 823
    -- upvalues: u68 (copy)
    local v174 = u68.new(p173);

    if not v174:build() then
        return nil;
    end;

    local v175 = {};

    for _, v in ipairs(v174:collectFaces(false)) do
        table.insert(v175, { v174.vertices[v[1]].point, v174.vertices[v[2]].point, v174.vertices[v[3]].point });
    end;

    return v175;
end;

return u68;