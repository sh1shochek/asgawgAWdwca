-- ReplicatedStorage.Shared.CollisionModule.CollisionBuilder.MinkowskiSumInstance.QuickHull2
-- Script path: ReplicatedStorage.Shared.CollisionModule.CollisionBuilder.MinkowskiSumInstance.QuickHull2
-- Decompile time: 20.41 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = 0;

local function Cross(p3, p4) -- Line: 20
    return Vector3.new(p3.y * p4.z - p3.z * p4.y, p3.z * p4.x - p3.x * p4.z, p3.x * p4.y - p3.y * p4.x);
end;

local function Dot(p5, p6) -- Line: 27
    return p5.x * p6.x + p5.y * p6.y + p5.z * p6.z;
end;

local function PointFaceDistance(p7, p8, p9) -- Line: 31
    local Normal = p9.Normal;
    local v10 = p7 - p8;

    return Normal.x * v10.x + Normal.y * v10.y + Normal.z * v10.z;
end;

local function Normal(p11, p12, p13) -- Line: 35
    local v14 = p12 - p11;
    local v15 = p13 - p11;

    return Vector3.new(v14.y * v15.z - v14.z * v15.y, v14.z * v15.x - v14.x * v15.z, v14.x * v15.y - v14.y * v15.x).Unit;
end;

local function AreCoincident(p16, p17) -- Line: 39
    return (p16 - p17).Magnitude <= 0.0001;
end;

local function AreCollinear(p18, p19, p20) -- Line: 43
    local v21 = p20 - p18;
    local v22 = p20 - p19;

    return Vector3.new(v21.y * v22.z - v21.z * v22.y, v21.z * v22.x - v21.x * v22.z, v21.x * v22.y - v21.y * v22.x).Magnitude <= 0.0001;
end;

local function AreCoplanar(p23, p24, p25, p26) -- Line: 47
    local v27 = p25 - p23;
    local v28 = p25 - p24;
    local Vector3_new_ret = Vector3.new(v27.y * v28.z - v27.z * v28.y, v27.z * v28.x - v27.x * v28.z, v27.x * v28.y - v27.y * v28.x);
    local v29 = p26 - p23;
    local v30 = p26 - p24;
    local Vector3_new_ret2 = Vector3.new(v29.y * v30.z - v29.z * v30.y, v29.z * v30.x - v29.x * v30.z, v29.x * v30.y - v29.y * v30.x);
    local Magnitude = Vector3_new_ret.Magnitude;
    local Magnitude2 = Vector3_new_ret2.Magnitude;
    local v31;

    if Magnitude <= 0.0001 or Magnitude2 <= 0.0001 then
        v31 = true;
    else
        local v32 = 1 / Magnitude2 * Vector3_new_ret2;
        local v33 = v32 - Vector3.new(0, 0, 0);
        local v34 = v32 - 1 / Magnitude * Vector3_new_ret;
        v31 = Vector3.new(v33.y * v34.z - v33.z * v34.y, v33.z * v34.x - v33.x * v34.z, v33.x * v34.y - v33.y * v34.x).Magnitude <= 0.0001;
    end;

    return v31;
end;

local function Face(p35, p36, p37, p38, p39, p40, p41) -- Line: 59
    return {
        Alive = true,
        Vertex0 = p35,
        Vertex1 = p36,
        Vertex2 = p37,
        Opposite0 = p38,
        Opposite1 = p39,
        Opposite2 = p40,
        Normal = p41
    };
end;

function FaceEquals(p42, p43)
    local v44;

    if p42.Vertex0 == p43.Vertex0 and (p42.Vertex1 == p43.Vertex1 and (p42.Vertex2 == p43.Vertex2 and (p42.Opposite0 == p43.Opposite0 and (p42.Opposite1 == p43.Opposite1 and p42.Opposite2 == p43.Opposite2)))) then
        v44 = p42.Normal == p43.Normal;
    else
        v44 = false;
    end;

    return v44;
end;

local function PointFace(p45, p46, p47) -- Line: 82
    return {
        Point = p45,
        Face = p46,
        Distance = p47
    };
end;

local function HorizonEdge(p48, p49, p50) -- Line: 90
    return {
        Face = p48,
        Edge0 = p49,
        Edge1 = p50
    };
end;

local function Count(p51) -- Line: 101
    return #p51;
end;

local u52 = {};
local u53 = {};
local u54 = {};
local u55 = {};
local u56 = -1;
local u57 = 0;

local function HasEdge(p58, p59, p60) -- Line: 116
    local v61;

    if p58.Vertex0 == p59 and p58.Vertex1 == p60 or p58.Vertex1 == p59 and p58.Vertex2 == p60 then
        v61 = true;
    elseif p58.Vertex2 == p59 then
        v61 = p58.Vertex0 == p60;
    else
        v61 = false;
    end;

    return v61;
end;

local function VerifyFaces(p62) -- Line: 122
    -- upvalues: u52 (copy)
    for i, v in pairs(u52) do
        assert(u52[v.Opposite0] ~= nil);
        assert(u52[v.Opposite1] ~= nil);
        assert(u52[v.Opposite2] ~= nil);
        assert(v.Opposite0 ~= i);
        assert(v.Opposite1 ~= i);
        assert(v.Opposite2 ~= i);
        assert(v.Vertex0 ~= v.Vertex1);
        assert(v.Vertex0 ~= v.Vertex2);
        assert(v.Vertex1 ~= v.Vertex2);
        local v63 = u52[v.Opposite0];
        local Vertex2 = v.Vertex2;
        local Vertex1 = v.Vertex1;
        local v64;

        if v63.Vertex0 == Vertex2 and v63.Vertex1 == Vertex1 or v63.Vertex1 == Vertex2 and v63.Vertex2 == Vertex1 then
            v64 = true;
        elseif v63.Vertex2 == Vertex2 then
            v64 = v63.Vertex0 == Vertex1;
        else
            v64 = false;
        end;

        assert(v64);
        local v65 = u52[v.Opposite1];
        local Vertex0 = v.Vertex0;
        local Vertex22 = v.Vertex2;
        local v66;

        if v65.Vertex0 == Vertex0 and v65.Vertex1 == Vertex22 or v65.Vertex1 == Vertex0 and v65.Vertex2 == Vertex22 then
            v66 = true;
        elseif v65.Vertex2 == Vertex0 then
            v66 = v65.Vertex0 == Vertex22;
        else
            v66 = false;
        end;

        assert(v66);
        local v67 = u52[v.Opposite2];
        local Vertex12 = v.Vertex1;
        local Vertex02 = v.Vertex0;
        local v68;

        if v67.Vertex0 == Vertex12 and v67.Vertex1 == Vertex02 or v67.Vertex1 == Vertex12 and v67.Vertex2 == Vertex02 then
            v68 = true;
        elseif v67.Vertex2 == Vertex12 then
            v68 = v67.Vertex0 == Vertex02;
        else
            v68 = false;
        end;

        assert(v68);
    end;
end;

local function ReassignPoints(p69, p70) -- Line: 170
    -- upvalues: u56 (ref), u53 (copy), u54 (copy), u57 (ref), u52 (copy)
    local v71 = 0;

    while true do
        local v72;

        repeat
            if v71 >= u56 then
                return;
            end;

            v71 = v71 + 1;
            v72 = u53[v71];
        until u54[v72.Face];

        local v73 = p69[v72.Point];
        local v74 = false;

        for i = p70 + 1, u57 do
            local v75 = u52[i];
            local v76;

            if v75.Alive then
                local Normal2 = v75.Normal;
                local v77 = v73 - p69[v75.Vertex0];
                local v78 = Normal2.x * v77.x + Normal2.y * v77.y + Normal2.z * v77.z;

                if v78 > 0.0001 then
                    v72.Face = i;
                    v72.Distance = v78;
                    u53[v71] = v72;
                    v74 = true;
                    break;
                end;

                v76 = i;
            else
                v76 = i;
            end;
        end;

        if v74 == false then
            v72.Face = -1;
            v72.Distance = (0 / 0);
            u53[v71] = u53[u56];
            u53[u56] = v72;
            v71 = v71 - 1;
            u56 = u56 - 1;
        end;
    end;
end;

local function VerifyOpenSet(p79) -- Line: 241
    -- upvalues: u53 (copy), u56 (ref), u52 (copy)
    for i = 1, #u53 do
        local v80;

        if u56 < i then
            assert(u53[i].Face == -1);
            v80 = i;
        else
            assert(u53[i].Face ~= -1);
            assert(u53[i].Face ~= -2);
            local Normal2 = u52[u53[i].Face].Normal;
            local v81 = p79[u53[i].Point] - p79[u52[u53[i].Face].Vertex0];
            assert(Normal2.x * v81.x + Normal2.y * v81.y + Normal2.z * v81.z > 0);
            v80 = i;
        end;
    end;
end;

local function VerifyHorizon() -- Line: 258
    -- upvalues: u55 (copy), u52 (copy)
    for i = 1, #u55 do
        local v82;

        if i == 1 then
            v82 = #u55;
        else
            v82 = i - 1;
        end;

        assert(u55[v82].Edge1 == u55[i].Edge0);
        local v83 = u52[u55[i].Face];
        local Edge1 = u55[i].Edge1;
        local Edge0 = u55[i].Edge0;
        local v84;

        if v83.Vertex0 == Edge1 and v83.Vertex1 == Edge0 or v83.Vertex1 == Edge1 and v83.Vertex2 == Edge0 then
            v84 = true;
        elseif v83.Vertex2 == Edge1 then
            v84 = v83.Vertex0 == Edge0;
        else
            v84 = false;
        end;

        assert(v84);
        local _ = i;
    end;
end;

local function SearchHorizon(p85, p86, p87, p88, p89) -- Line: 276
    -- upvalues: u54 (copy), u52 (copy), u55 (copy), SearchHorizon (copy)
    u54[p88] = true;
    local v90, v91, v92, v93, v94;

    if p87 == p89.Opposite0 then
        v90 = p89.Opposite1;
        v91 = p89.Opposite2;
        v92 = p89.Vertex2;
        v93 = p89.Vertex0;
        v94 = p89.Vertex1;
    elseif p87 == p89.Opposite1 then
        v90 = p89.Opposite2;
        v91 = p89.Opposite0;
        v92 = p89.Vertex0;
        v93 = p89.Vertex1;
        v94 = p89.Vertex2;
    else
        v90 = p89.Opposite0;
        v91 = p89.Opposite1;
        v92 = p89.Vertex1;
        v93 = p89.Vertex2;
        v94 = p89.Vertex0;
    end;

    if not u54[v90] then
        local v95 = u52[v90];
        local Normal2 = v95.Normal;
        local v96 = p86 - p85[v95.Vertex0];

        if Normal2.x * v96.x + Normal2.y * v96.y + Normal2.z * v96.z <= 0 then
            table.insert(u55, {
                Face = v90,
                Edge0 = v92,
                Edge1 = v93
            });
        else
            SearchHorizon(p85, p86, p88, v90, v95);
        end;
    end;

    if not u54[v91] then
        local v97 = u52[v91];
        local Normal2 = v97.Normal;
        local v98 = p86 - p85[v97.Vertex0];

        if Normal2.x * v98.x + Normal2.y * v98.y + Normal2.z * v98.z <= 0 then
            table.insert(u55, {
                Face = v91,
                Edge0 = v93,
                Edge1 = v94
            });

            return;
        end;

        SearchHorizon(p85, p86, p88, v91, v97);
    end;
end;

local function FindHorizon(p99, p100, p101, p102) -- Line: 372
    -- upvalues: u54 (copy), u55 (copy), u52 (copy), SearchHorizon (copy)
    table.clear(u54);
    table.clear(u55);
    u54[p101] = true;
    local v103 = u52[p102.Opposite0];
    local Normal2 = v103.Normal;
    local v104 = p100 - p99[v103.Vertex0];

    if Normal2.x * v104.x + Normal2.y * v104.y + Normal2.z * v104.z <= 0 then
        table.insert(u55, {
            Face = p102.Opposite0,
            Edge0 = p102.Vertex1,
            Edge1 = p102.Vertex2
        });
    else
        SearchHorizon(p99, p100, p101, p102.Opposite0, v103);
    end;

    if not u54[p102.Opposite1] then
        local v105 = u52[p102.Opposite1];
        local Normal3 = v105.Normal;
        local v106 = p100 - p99[v105.Vertex0];

        if Normal3.x * v106.x + Normal3.y * v106.y + Normal3.z * v106.z <= 0 then
            table.insert(u55, {
                Face = p102.Opposite1,
                Edge0 = p102.Vertex2,
                Edge1 = p102.Vertex0
            });
        else
            SearchHorizon(p99, p100, p101, p102.Opposite1, v105);
        end;
    end;

    if not u54[p102.Opposite2] then
        local v107 = u52[p102.Opposite2];
        local Normal3 = v107.Normal;
        local v108 = p100 - p99[v107.Vertex0];

        if Normal3.x * v108.x + Normal3.y * v108.y + Normal3.z * v108.z <= 0 then
            table.insert(u55, {
                Face = p102.Opposite2,
                Edge0 = p102.Vertex0,
                Edge1 = p102.Vertex1
            });

            return;
        end;

        SearchHorizon(p99, p100, p101, p102.Opposite2, v107);
    end;
end;

local function FindInitialHullIndices(p109) -- Line: 438
    local v110 = #p109;
    local v111 = 1;
    local v112 = 1;
    local v113 = 1;
    local v114 = 1;
    local v115 = 1;
    local v116 = 1;

    for i = 2, v110 do
        local v117 = p109[i];

        if v117.X < p109[v113].X then
            v113 = i;
        end;

        if v117.X > p109[v114].X then
            v114 = i;
        end;

        if v117.Y < p109[v115].Y then
            v115 = i;
        end;

        if v117.Y > p109[v116].Y then
            v116 = i;
        end;

        if v117.Z < p109[v111].Z then
            v111 = i;
        end;

        local v118;

        if v117.Z > p109[v112].Z then
            v118 = i;
            v112 = v118;
            local v119 = v118;
            v118 = v112;
            v119 = v112;
        else
            v118 = i;
        end;
    end;

    local v120 = {
        v113,
        v114,
        v115,
        v116,
        v111,
        v112
    };

    for i = 1, 6 do
        local v121 = v120[i];
        local _ = i;

        for i2 = i + 1, 6 do
            local v122 = v120[i2];
            local v123;

            if v121 == v122 or (p109[v121] - p109[v122]).Magnitude <= 0.0001 then
                v123 = i2;
            else
                v123 = i2;

                for i3 = 1, v110 do
                    local v124;

                    if v121 == i3 or v122 == i3 then
                        v124 = i3;
                    else
                        local v125 = p109[i3];
                        local v126 = v125 - p109[v121];
                        local v127 = v125 - p109[v122];

                        if Vector3.new(v126.y * v127.z - v126.z * v127.y, v126.z * v127.x - v126.x * v127.z, v126.x * v127.y - v126.y * v127.x).Magnitude <= 0.0001 then
                            v124 = i3;
                        else
                            v124 = i3;

                            for i4 = 1, v110 do
                                local v128;

                                if v121 == i4 or (v122 == i4 or v124 == i4) then
                                    v128 = i4;
                                else
                                    local v129 = p109[v121];
                                    local v130 = p109[v122];
                                    local v131 = p109[v124];
                                    local v132 = p109[i4];
                                    local v133 = v131 - v129;
                                    local v134 = v131 - v130;
                                    local Vector3_new_ret = Vector3.new(v133.y * v134.z - v133.z * v134.y, v133.z * v134.x - v133.x * v134.z, v133.x * v134.y - v133.y * v134.x);
                                    local v135 = v132 - v129;
                                    local v136 = v132 - v130;
                                    local Vector3_new_ret2 = Vector3.new(v135.y * v136.z - v135.z * v136.y, v135.z * v136.x - v135.x * v136.z, v135.x * v136.y - v135.y * v136.x);
                                    local Magnitude = Vector3_new_ret.Magnitude;
                                    local Magnitude2 = Vector3_new_ret2.Magnitude;
                                    local v137;

                                    if Magnitude <= 0.0001 or Magnitude2 <= 0.0001 then
                                        v137 = true;
                                    else
                                        local v138 = 1 / Magnitude2 * Vector3_new_ret2;
                                        local v139 = v138 - Vector3.new(0, 0, 0);
                                        local v140 = v138 - 1 / Magnitude * Vector3_new_ret;
                                        v137 = Vector3.new(v139.y * v140.z - v139.z * v140.y, v139.z * v140.x - v139.x * v140.z, v139.x * v140.y - v139.y * v140.x).Magnitude <= 0.0001;
                                    end;

                                    if not v137 then
                                        return v121, v122, v124, i4;
                                    end;

                                    v128 = i4;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    for i = 1, v110 - 2 do
        local v141 = i;

        for i2 = i + 1, v110 - 1 do
            local v142 = p109[v141];
            local v143 = p109[i2];
            local v144;

            if (v142 - v143).Magnitude <= 0.0001 then
                v144 = i2;
            else
                v144 = i2;

                for i3 = i2 + 1, v110 do
                    local v145 = p109[i3];
                    local v146 = v145 - v142;
                    local v147 = v145 - v143;
                    local v148;

                    if Vector3.new(v146.y * v147.z - v146.z * v147.y, v146.z * v147.x - v146.x * v147.z, v146.x * v147.y - v146.y * v147.x).Magnitude <= 0.0001 then
                        v148 = i3;
                    else
                        v148 = i3;

                        for i4 = i3 + 1, v110 do
                            local v149 = p109[i4];
                            local v150 = v145 - v142;
                            local v151 = v145 - v143;
                            local Vector3_new_ret = Vector3.new(v150.y * v151.z - v150.z * v151.y, v150.z * v151.x - v150.x * v151.z, v150.x * v151.y - v150.y * v151.x);
                            local v152 = v149 - v142;
                            local v153 = v149 - v143;
                            local Vector3_new_ret2 = Vector3.new(v152.y * v153.z - v152.z * v153.y, v152.z * v153.x - v152.x * v153.z, v152.x * v153.y - v152.y * v153.x);
                            local Magnitude = Vector3_new_ret.Magnitude;
                            local Magnitude2 = Vector3_new_ret2.Magnitude;
                            local v154;

                            if Magnitude <= 0.0001 or Magnitude2 <= 0.0001 then
                                v154 = true;
                            else
                                local v155 = 1 / Magnitude2 * Vector3_new_ret2;
                                local v156 = v155 - Vector3.new(0, 0, 0);
                                local v157 = v155 - 1 / Magnitude * Vector3_new_ret;
                                v154 = Vector3.new(v156.y * v157.z - v156.z * v157.y, v156.z * v157.x - v156.x * v157.z, v156.x * v157.y - v156.y * v157.x).Magnitude <= 0.0001;
                            end;

                            if not v154 then
                                return v141, v144, v148, i4;
                            end;

                            local _ = i4;
                        end;
                    end;
                end;
            end;
        end;
    end;

    error("Can\'t generate hull, points are coplanar");
end;

local function GenerateInitialHull(p158) -- Line: 488
    -- upvalues: FindInitialHullIndices (copy), u57 (ref), u52 (copy), u53 (copy), u56 (ref)
    local v159, v160, v161, v162 = FindInitialHullIndices(p158);
    local v163 = p158[v159];
    local v164 = p158[v160];
    local v165 = p158[v162] - v164;
    local v166 = v164 - v163;
    local v167 = p158[v161] - v163;
    local Vector3_new_ret = Vector3.new(v166.y * v167.z - v166.z * v167.y, v166.z * v167.x - v166.x * v167.z, v166.x * v167.y - v166.y * v167.x);
    u57 = 0;

    if v165.x * Vector3_new_ret.x + v165.y * Vector3_new_ret.y + v165.z * Vector3_new_ret.z > 0 then
        local v168 = p158[v159];
        local v169 = p158[v161] - v168;
        local v170 = p158[v160] - v168;
        u52[u57 + 1] = {
            Opposite0 = 4,
            Opposite1 = 2,
            Opposite2 = 3,
            Alive = true,
            Vertex0 = v159,
            Vertex1 = v161,
            Vertex2 = v160,
            Normal = Vector3.new(v169.y * v170.z - v169.z * v170.y, v169.z * v170.x - v169.x * v170.z, v169.x * v170.y - v169.y * v170.x).Unit
        };
        u57 = u57 + 1;
        local v171 = p158[v159];
        local v172 = p158[v160] - v171;
        local v173 = p158[v162] - v171;
        u52[u57 + 1] = {
            Opposite0 = 4,
            Opposite1 = 3,
            Opposite2 = 1,
            Alive = true,
            Vertex0 = v159,
            Vertex1 = v160,
            Vertex2 = v162,
            Normal = Vector3.new(v172.y * v173.z - v172.z * v173.y, v172.z * v173.x - v172.x * v173.z, v172.x * v173.y - v172.y * v173.x).Unit
        };
        u57 = u57 + 1;
        local v174 = p158[v159];
        local v175 = p158[v162] - v174;
        local v176 = p158[v161] - v174;
        u52[u57 + 1] = {
            Opposite0 = 4,
            Opposite1 = 1,
            Opposite2 = 2,
            Alive = true,
            Vertex0 = v159,
            Vertex1 = v162,
            Vertex2 = v161,
            Normal = Vector3.new(v175.y * v176.z - v175.z * v176.y, v175.z * v176.x - v175.x * v176.z, v175.x * v176.y - v175.y * v176.x).Unit
        };
        u57 = u57 + 1;
        local v177 = p158[v160];
        local v178 = p158[v161] - v177;
        local v179 = p158[v162] - v177;
        u52[u57 + 1] = {
            Opposite0 = 3,
            Opposite1 = 2,
            Opposite2 = 1,
            Alive = true,
            Vertex0 = v160,
            Vertex1 = v161,
            Vertex2 = v162,
            Normal = Vector3.new(v178.y * v179.z - v178.z * v179.y, v178.z * v179.x - v178.x * v179.z, v178.x * v179.y - v178.y * v179.x).Unit
        };
        u57 = u57 + 1;
    else
        local v180 = p158[v159];
        local v181 = p158[v160] - v180;
        local v182 = p158[v161] - v180;
        u52[u57 + 1] = {
            Opposite0 = 4,
            Opposite1 = 3,
            Opposite2 = 2,
            Alive = true,
            Vertex0 = v159,
            Vertex1 = v160,
            Vertex2 = v161,
            Normal = Vector3.new(v181.y * v182.z - v181.z * v182.y, v181.z * v182.x - v181.x * v182.z, v181.x * v182.y - v181.y * v182.x).Unit
        };
        u57 = u57 + 1;
        local v183 = p158[v159];
        local v184 = p158[v162] - v183;
        local v185 = p158[v160] - v183;
        u52[u57 + 1] = {
            Opposite0 = 4,
            Opposite1 = 1,
            Opposite2 = 3,
            Alive = true,
            Vertex0 = v159,
            Vertex1 = v162,
            Vertex2 = v160,
            Normal = Vector3.new(v184.y * v185.z - v184.z * v185.y, v184.z * v185.x - v184.x * v185.z, v184.x * v185.y - v184.y * v185.x).Unit
        };
        u57 = u57 + 1;
        local v186 = p158[v159];
        local v187 = p158[v161] - v186;
        local v188 = p158[v162] - v186;
        u52[u57 + 1] = {
            Opposite0 = 4,
            Opposite1 = 2,
            Opposite2 = 1,
            Alive = true,
            Vertex0 = v159,
            Vertex1 = v161,
            Vertex2 = v162,
            Normal = Vector3.new(v187.y * v188.z - v187.z * v188.y, v187.z * v188.x - v187.x * v188.z, v187.x * v188.y - v187.y * v188.x).Unit
        };
        u57 = u57 + 1;
        local v189 = p158[v160];
        local v190 = p158[v162] - v189;
        local v191 = p158[v161] - v189;
        u52[u57 + 1] = {
            Opposite0 = 3,
            Opposite1 = 1,
            Opposite2 = 2,
            Alive = true,
            Vertex0 = v160,
            Vertex1 = v162,
            Vertex2 = v161,
            Normal = Vector3.new(v190.y * v191.z - v190.z * v191.y, v190.z * v191.x - v190.x * v191.z, v190.x * v191.y - v190.y * v191.x).Unit
        };
        u57 = u57 + 1;
    end;

    for i = 1, #p158 do
        local v192;

        if i == v159 or (i == v160 or (i == v161 or i == v162)) then
            v192 = i;
        else
            table.insert(u53, {
                Face = -2,
                Distance = 0,
                Point = i
            });
            v192 = i;
        end;
    end;

    table.insert(u53, {
        Face = -1,
        Distance = (0 / 0),
        Point = v159
    });
    table.insert(u53, {
        Face = -1,
        Distance = (0 / 0),
        Point = v160
    });
    table.insert(u53, {
        Face = -1,
        Distance = (0 / 0),
        Point = v161
    });
    table.insert(u53, {
        Face = -1,
        Distance = (0 / 0),
        Point = v162
    });
    u56 = #u53 - 4;
    local v193 = 0;

    while true do
        if v193 >= u56 then
            return;
        end;

        v193 = v193 + 1;
        local v194 = u53[v193];
        local v195 = false;

        for i = 1, 4 do
            local v196 = u52[i];
            local Normal2 = v196.Normal;
            local v197 = p158[v194.Point] - p158[v196.Vertex0];
            local v198 = Normal2.x * v197.x + Normal2.y * v197.y + Normal2.z * v197.z;

            if v198 > 0 then
                v194.Face = i;
                v194.Distance = v198;
                u53[v193] = v194;
                v195 = true;
                break;
            end;

            local _ = i;
        end;

        if v195 == false then
            v194.Face = -1;
            v194.Distance = (0 / 0);
            u53[v193] = u53[u56];
            u53[u56] = v194;
            u56 = u56 - 1;
            v193 = v193 - 1;
        end;
    end;
end;

local function ConstructCone(p199, p200) -- Line: 662
    -- upvalues: u54 (copy), u52 (copy), u57 (ref), u55 (copy)
    for i in pairs(u54) do
        u52[i].Alive = false;
    end;

    local v201 = u57;

    for i = 1, #u55 do
        local Edge0 = u55[i].Edge0;
        local Edge1 = u55[i].Edge1;
        local v202;

        if i == #u55 then
            v202 = v201 + 1;
        else
            v202 = v201 + i + 1;
        end;

        local v203;

        if i == 1 then
            v203 = v201 + #u55;
        else
            v203 = v201 + i - 1;
        end;

        local v204 = u57 + 1;
        u57 = u57 + 1;
        local v205 = p199[p200];
        local v206 = p199[Edge0] - v205;
        local v207 = p199[Edge1] - v205;
        u52[v204] = {
            Alive = true,
            Vertex0 = p200,
            Vertex1 = Edge0,
            Vertex2 = Edge1,
            Opposite0 = u55[i].Face,
            Opposite1 = v202,
            Opposite2 = v203,
            Normal = Vector3.new(v206.y * v207.z - v206.z * v207.y, v206.z * v207.x - v206.x * v207.z, v206.x * v207.y - v206.y * v207.x).Unit
        };
        local v208 = u52[u55[i].Face];

        if v208.Vertex0 == Edge0 then
            v208.Opposite1 = v204;
        elseif v208.Vertex1 == Edge0 then
            v208.Opposite2 = v204;
        else
            v208.Opposite0 = v204;
        end;

        u52[u55[i].Face] = v208;
        local _ = i;
    end;

    return v201;
end;

local function GrowHull(p209) -- Line: 736
    -- upvalues: u2 (ref), u53 (copy), u56 (ref), FindHorizon (copy), u52 (copy), ConstructCone (copy), ReassignPoints (copy)
    u2 = u2 + 1;
    local Distance = u53[1].Distance;
    local v210 = 1;

    for i = 2, u56 do
        local v211;

        if Distance < u53[i].Distance then
            Distance = u53[i].Distance;
            v210 = i;
            v211 = v210;
            local v212 = v210;
            v210 = v211;
            v212 = v211;
        else
            v211 = i;
        end;
    end;

    FindHorizon(p209, p209[u53[v210].Point], u53[v210].Face, u52[u53[v210].Face]);
    ReassignPoints(p209, (ConstructCone(p209, u53[v210].Point)));
end;

function v1.GenerateHull(p213, p214) -- Line: 776
    -- upvalues: u57 (ref), u56 (ref), u52 (copy), u53 (copy), u54 (copy), u55 (copy), GenerateInitialHull (copy), GrowHull (copy)
    if #p214 < 4 then
        return nil;
    end;

    u57 = 0;
    u56 = -1;
    table.clear(u52);
    table.clear(u53);
    table.clear(u54);
    table.clear(u55);
    GenerateInitialHull(p214);

    while u56 >= 1 do
        GrowHull(p214);
    end;

    local v215 = {};

    for i = 1, u57 do
        local v216 = u52[i];
        local v217;

        if v216.Alive then
            v215[#v215 + 1] = { p214[v216.Vertex0], p214[v216.Vertex1], p214[v216.Vertex2] };
            v217 = i;
        else
            v217 = i;
        end;
    end;

    return v215;
end;

return v1;