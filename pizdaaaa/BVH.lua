-- ReplicatedStorage.Shared.CollisionModule.BVH
-- Script path: ReplicatedStorage.Shared.CollisionModule.BVH
-- Decompile time: 28.83 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local CollisionState = require(script.Parent.CollisionState);
local u2 = {
    EndPosition = Vector3.new(0, 0, 0),
    Fraction = 1,
    StartSolid = false,
    AllSolid = false,
    Normal = Vector3.new(0, 1, 0),
    SweepMin = Vector3.new(0, 0, 0),
    SweepMax = Vector3.new(0, 0, 0),
    Instance = nil,
    Climbable = nil,
    StartInHull = false,
    EndInHull = false
};
local u3 = false;
local u4 = 0;
local u5 = 0;
local u6 = 0;
local u7 = false;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = 1;
local u24 = 1;
local u25 = nil;
local u26 = nil;
local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = nil;
local u31 = -1;
local u32 = nil;
local u33 = nil;
local u34 = nil;
local u35 = nil;
local u36 = nil;
local u37 = nil;
local u38 = nil;
local u39 = nil;
local u40 = 0;
local u41 = Vector3.new(0, 0, 0);
local u42 = 0;
local u43 = nil;
local u44 = nil;
local u45 = nil;
local u46 = nil;
local u47 = nil;
local u48 = nil;
local u49 = nil;
local u50 = nil;
local u51 = nil;
local u52 = nil;
local u53 = nil;
local u54 = nil;

local function BindTreeArrays() -- Line: 76
    -- upvalues: CollisionState (copy), u32 (ref), u33 (ref), u34 (ref), u35 (ref), u36 (ref), u37 (ref), u38 (ref), u39 (ref), u40 (ref), u41 (ref), u43 (ref), u44 (ref), u45 (ref), u46 (ref), u47 (ref), u48 (ref), u49 (ref), u50 (ref), u51 (ref), u52 (ref), u53 (ref), u54 (ref), u42 (ref), u31 (ref)
    local v55 = CollisionState;
    u32 = v55.NodeMin;
    u33 = v55.NodeMax;
    u34 = v55.NodeLeft;
    u35 = v55.NodeRight;
    u36 = v55.NodeRecordStart;
    u37 = v55.NodeRecordCount;
    u38 = v55.LeafRecords;
    u39 = v55.GlobalEds;
    u40 = v55.SkinThickness;
    u41 = v55.SkinThicknessVector;
    u43 = v55.HullClimbable;
    u44 = v55.HullInstance;
    u45 = v55.StandMin;
    u46 = v55.StandMax;
    u47 = v55.StandNormals;
    u48 = v55.StandEdsStart;
    u49 = v55.StandHullCount;
    u50 = v55.CrouchMin;
    u51 = v55.CrouchMax;
    u52 = v55.CrouchNormals;
    u53 = v55.CrouchEdsStart;
    u54 = v55.CrouchHullCount;
    u42 = v55.BVHRoot;
    u31 = v55.Generation;
end;

local function EnsureBound() -- Line: 106
    -- upvalues: u31 (ref), CollisionState (copy), u32 (ref), u33 (ref), u34 (ref), u35 (ref), u36 (ref), u37 (ref), u38 (ref), u39 (ref), u40 (ref), u41 (ref), u43 (ref), u44 (ref), u45 (ref), u46 (ref), u47 (ref), u48 (ref), u49 (ref), u50 (ref), u51 (ref), u52 (ref), u53 (ref), u54 (ref), u42 (ref)
    if u31 ~= CollisionState.Generation then
        local v56 = CollisionState;
        u32 = v56.NodeMin;
        u33 = v56.NodeMax;
        u34 = v56.NodeLeft;
        u35 = v56.NodeRight;
        u36 = v56.NodeRecordStart;
        u37 = v56.NodeRecordCount;
        u38 = v56.LeafRecords;
        u39 = v56.GlobalEds;
        u40 = v56.SkinThickness;
        u41 = v56.SkinThicknessVector;
        u43 = v56.HullClimbable;
        u44 = v56.HullInstance;
        u45 = v56.StandMin;
        u46 = v56.StandMax;
        u47 = v56.StandNormals;
        u48 = v56.StandEdsStart;
        u49 = v56.StandHullCount;
        u50 = v56.CrouchMin;
        u51 = v56.CrouchMax;
        u52 = v56.CrouchNormals;
        u53 = v56.CrouchEdsStart;
        u54 = v56.CrouchHullCount;
        u42 = v56.BVHRoot;
        u31 = v56.Generation;
    end;
end;

local u57 = 0;
local u58 = 0;
local u59 = 0;
local u60 = Vector3.new(0, 0, 0);
local u61 = Vector3.new(0, 0, 0);
local u62 = 1;
local u63 = false;

local function CheckBrushNoStuck(p64: vector, p65: any, p66: number, p67: any, p68: any, p69: any) -- Line: 120
    -- upvalues: u40 (ref), u39 (ref), u13 (ref), u3 (ref), u7 (ref), u4 (ref), u5 (ref), u6 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u63 (ref), u62 (ref), u24 (ref), u23 (ref), u43 (ref), u44 (ref)
    local v70 = u40;
    local v71 = u39;
    local v72 = u13;
    local v73 = p67[p66];
    local v74 = p68[p66] * 4;
    local v75 = (-1 / 0);
    local v76 = -1;
    local v77 = 1;
    local v78 = false;
    local v79 = (-1 / 0);
    local v80 = false;
    local v81 = nil;

    for i = 1, p69[p66] do
        local v82 = v73[i];
        local buffer_readf32_ret = buffer.readf32(v71, v74);
        v74 = v74 + 4;

        if u3 then
            if u7 then
                buffer_readf32_ret = buffer_readf32_ret + (math.abs(v82.X) * u4 + math.abs(v82.Y) * u5 + math.abs(v82.Z) * u6);
            else
                local vector_dot_ret = vector.dot(v82, u8);
                local math_abs_ret = math.abs(vector_dot_ret);
                local vector_dot_ret2 = vector.dot(v82, u9);
                local v83 = math_abs_ret + math.abs(vector_dot_ret2);
                local vector_dot_ret3 = vector.dot(v82, u10);
                buffer_readf32_ret = buffer_readf32_ret + (v83 + math.abs(vector_dot_ret3) - (math.abs(v82.X) * u11.X + math.abs(v82.Y) * u11.Y + math.abs(v82.Z) * u11.Z));
            end;
        end;

        local v84 = vector.dot(p64, v82) - buffer_readf32_ret;
        local v85 = vector.dot(v72, v82) - buffer_readf32_ret;
        v78 = v84 > 0 and true or v78;
        v80 = v85 > 0 and true or v80;

        if v84 > 0 and (v70 <= v85 or v84 <= v85) then
            return;
        end;

        if not v78 then
            if v79 < v84 then
                v79 = v84;
            end;

            if v75 < v85 then
                v75 = v85;
            end;
        end;

        local v86;

        if v84 <= 0 and v85 <= 0 then
            v86 = i;
        elseif v85 < v84 then
            local v87 = v84 - v85;
            local v88 = v84 - v70;

            if v76 < 0 or v76 * v87 < v88 then
                local v89 = v88 / v87;
                local v90 = v89 < 0 and 0 or v89;

                if v76 < v90 then
                    v81 = v82;
                    v76 = v90;
                    v86 = i;
                else
                    v86 = i;
                end;
            else
                v86 = i;
            end;
        else
            local v91 = v84 - v85;
            local v92 = v84 + v70;

            if v77 * v91 < v92 then
                local v93 = v92 / v91;
                local v94 = v93 > 1 and 1 or v93;

                if v94 < v77 then
                    v77 = v94;
                    v86 = i;
                else
                    v86 = i;
                end;
            else
                v86 = i;
            end;
        end;
    end;

    if not v80 then
        p65.EndInHull = true;
    end;

    if v78 then
        if v76 < v77 and (v76 > -1 and v76 < u62) then
            local math_max_ret = math.max(0, v76);
            u62 = math_max_ret;
            u24 = math.min(1, math_max_ret + u23);
            p65.Normal = v81;
            p65.Climbable = u43[p66];
            p65.Instance = u44[p66];
        end;

        return;
    end;

    p65.StartInHull = true;
    p65.StartSolid = true;

    if v80 or v75 >= v79 then
        p65.StartSolid = false;

        return;
    end;

    u63 = true;
end;

local function BindQuery(p95: vector, p96: vector, p97: vector) -- Line: 227
    -- upvalues: u31 (ref), CollisionState (copy), u32 (ref), u33 (ref), u34 (ref), u35 (ref), u36 (ref), u37 (ref), u38 (ref), u39 (ref), u40 (ref), u41 (ref), u43 (ref), u44 (ref), u45 (ref), u46 (ref), u47 (ref), u48 (ref), u49 (ref), u50 (ref), u51 (ref), u52 (ref), u53 (ref), u54 (ref), u42 (ref), u13 (ref), u62 (ref), u24 (ref), u63 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u60 (ref), u61 (ref), u57 (ref), u58 (ref), u59 (ref)
    if u31 ~= CollisionState.Generation then
        local v98 = CollisionState;
        u32 = v98.NodeMin;
        u33 = v98.NodeMax;
        u34 = v98.NodeLeft;
        u35 = v98.NodeRight;
        u36 = v98.NodeRecordStart;
        u37 = v98.NodeRecordCount;
        u38 = v98.LeafRecords;
        u39 = v98.GlobalEds;
        u40 = v98.SkinThickness;
        u41 = v98.SkinThicknessVector;
        u43 = v98.HullClimbable;
        u44 = v98.HullInstance;
        u45 = v98.StandMin;
        u46 = v98.StandMax;
        u47 = v98.StandNormals;
        u48 = v98.StandEdsStart;
        u49 = v98.StandHullCount;
        u50 = v98.CrouchMin;
        u51 = v98.CrouchMax;
        u52 = v98.CrouchNormals;
        u53 = v98.CrouchEdsStart;
        u54 = v98.CrouchHullCount;
        u42 = v98.BVHRoot;
        u31 = v98.Generation;
    end;

    u13 = p95;
    u62 = 1;
    u24 = 1;
    u63 = false;
    local v99 = 0;
    local v100 = 0;
    local v101 = 0;

    if u3 then
        if u4 > 0 then
            v99 = u4;
        end;

        if u5 > 0 then
            v100 = u5;
        end;

        if u6 > 0 then
            v101 = u6;
        end;
    end;

    local vector_create_ret = vector.create(v99, v100, v101);
    u60 = p96 - vector_create_ret;
    u61 = p97 + vector_create_ret;
    local v102 = u40 * 2;
    u57 = v102 + v99;
    u58 = v102 + v100;
    u59 = v102 + v101;
end;

local function FinishQuery(p103) -- Line: 255
    -- upvalues: u63 (ref), u62 (ref)
    if u63 then
        p103.AllSolid = true;
        u62 = 0;
    end;

    p103.Fraction = u62;
end;

local function SetupSweepFrame(p104: vector, p105: vector) -- Line: 263
    -- upvalues: u12 (ref), u14 (ref), u15 (ref), u16 (ref), u20 (ref), u21 (ref), u22 (ref), u17 (ref), u18 (ref), u19 (ref), u23 (ref), u40 (ref)
    u12 = p104;
    u14 = p104.X;
    u15 = p104.Y;
    u16 = p104.Z;
    local v106 = p105 - p104;
    local X = v106.X;
    local Y = v106.Y;
    local Z = v106.Z;
    local v107;

    if X > -1e-8 then
        v107 = X < 1e-8;
    else
        v107 = false;
    end;

    u20 = v107;
    local v108;

    if Y > -1e-8 then
        v108 = Y < 1e-8;
    else
        v108 = false;
    end;

    u21 = v108;
    local v109;

    if Z > -1e-8 then
        v109 = Z < 1e-8;
    else
        v109 = false;
    end;

    u22 = v109;
    u17 = u20 and 0 or 1 / X;
    u18 = u21 and 0 or 1 / Y;
    u19 = u22 and 0 or 1 / Z;
    local vector_magnitude_ret = vector.magnitude(v106);
    u23 = vector_magnitude_ret > 0.0001 and u40 * 4 / vector_magnitude_ret or 1;
end;

local function NodeEntryT(p110: number, p111: number) -- Line: 280
    -- upvalues: u32 (ref), u33 (ref), u57 (ref), u20 (ref), u14 (ref), u17 (ref), u58 (ref), u21 (ref), u15 (ref), u18 (ref), u59 (ref), u22 (ref), u16 (ref), u19 (ref)
    local v112 = u32[p110];
    local v113 = u33[p110];
    local v114 = 0;
    local v115 = u57;
    local v116 = v112.X - v115;
    local v117 = v113.X + v115;
    local v118, v119;

    if u20 then
        if u14 < v116 or v117 < u14 then
            return (1 / 0);
        end;

        v118 = p111;
        v119 = v114;
    else
        local v120 = u17;
        v118 = (v116 - u14) * v120;
        v119 = (v117 - u14) * v120;

        if v119 >= v118 then
            local v121 = v118;
            v118 = v119;
            v119 = v121;
        end;

        if v114 >= v119 then
            v119 = v114;
        end;

        if v118 >= p111 then
            v118 = p111;
        end;

        if v118 < v119 then
            return (1 / 0);
        end;
    end;

    local v122 = u58;
    local v123 = v112.Y - v122;
    local v124 = v113.Y + v122;

    if u21 then
        if u15 < v123 or v124 < u15 then
            return (1 / 0);
        end;
    else
        local v125 = u18;
        local v126 = (v123 - u15) * v125;
        local v127 = (v124 - u15) * v125;

        if v127 >= v126 then
            local v128 = v126;
            v126 = v127;
            v127 = v128;
        end;

        if v119 >= v127 then
            v127 = v119;
        end;

        if v126 >= v118 then
            v126 = v118;
        end;

        if v126 < v127 then
            return (1 / 0);
        end;

        v118 = v126;
        v119 = v127;
    end;

    local v129 = u59;
    local v130 = v112.Z - v129;
    local v131 = v113.Z + v129;

    if u22 then
        if u16 < v130 or v131 < u16 then
            return (1 / 0);
        end;
    else
        local v132 = u19;
        local v133 = (v130 - u16) * v132;
        local v134 = (v131 - u16) * v132;

        if v134 >= v133 then
            local v135 = v133;
            v133 = v134;
            v134 = v135;
        end;

        if v119 >= v134 then
            v134 = v119;
        end;

        if v133 >= v118 then
            v133 = v118;
        end;

        if v133 < v134 then
            return (1 / 0);
        end;

        v119 = v134;
    end;

    return v119;
end;

local table_create_ret = table.create(32);
local table_create_ret2 = table.create(32);

local function SweepNode(p136: number) -- Line: 335
    -- upvalues: table_create_ret (copy), table_create_ret2 (copy), u24 (ref), u37 (ref), u36 (ref), u25 (ref), u26 (ref), u27 (ref), u60 (ref), u61 (ref), u38 (ref), CheckBrushNoStuck (copy), u12 (ref), u28 (ref), u29 (ref), u30 (ref), u63 (ref), u34 (ref), u35 (ref), NodeEntryT (copy)
    table_create_ret[1] = p136;
    table_create_ret2[1] = 0;
    local v137 = 1;
    local v138;

    while true do
        v138 = table_create_ret[v137];
        local v139 = table_create_ret2[v137];
        v137 = v137 - 1;

        if v139 <= u24 then
            break;
        end;

        if v137 == 0 then
            return;
        end;
    end;

    local v140;

    while true do
        v140 = u37[v138];

        if v140 > 0 then
            break;
        end;

        local v141 = u24;
        local v142 = u34[v138];
        v138 = u35[v138];
        local v143 = NodeEntryT(v142, v141);
        local v144 = NodeEntryT(v138, v141);

        if v144 < v143 then
            if v143 < (1 / 0) then
                v137 = v137 + 1;
                table_create_ret[v137] = v142;
                table_create_ret2[v137] = v143;
            end;
        else
            if v143 >= (1 / 0) then
                if v137 == 0 then
                    return;
                end;
            end;

            if v144 < (1 / 0) then
                v137 = v137 + 1;
                table_create_ret[v137] = v138;
                table_create_ret2[v137] = v144;
            end;

            v138 = v142;
        end;
    end;

    local v145 = u36[v138];
    local v146 = u25;
    local v147 = u26;
    local v148 = u27;
    local v149 = u60;
    local v150 = u61;

    for i = 1, v140 do
        local v151 = u38[v145 + i];
        local v152 = v147[v151];
        local v153 = v148[v151];
        local v154;

        if v149.X <= v153.X and (v150.X >= v152.X and (v149.Y <= v153.Y and (v150.Y >= v152.Y and (v149.Z <= v153.Z and v150.Z >= v152.Z)))) then
            CheckBrushNoStuck(u12, v146, v151, u28, u29, u30);

            if u63 then
                return;
            end;

            v154 = i;
        else
            v154 = i;
        end;
    end;

    if v137 == 0 then
    end;
end;

local function ResetSweepResult(p155: vector, p156: vector, p157: vector) -- Line: 393
    -- upvalues: u2 (copy)
    local v158 = u2;
    v158.EndPosition = p155;
    v158.Fraction = 1;
    v158.StartSolid = false;
    v158.AllSolid = false;
    v158.Normal = Vector3.new(0, 1, 0);
    v158.SweepMin = p156;
    v158.SweepMax = p157;
    v158.Instance = nil;
    v158.Climbable = nil;
    v158.StartInHull = false;
    v158.EndInHull = false;

    return v158;
end;

local u159 = false;

local function BoxInHull(p160: vector, p161: number, p162: any, p163: any, p164: any, p165: any, p166: any) -- Line: 419
    -- upvalues: u60 (ref), u61 (ref), u39 (ref), u3 (ref), u7 (ref), u4 (ref), u5 (ref), u6 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref)
    local v167 = u60;
    local v168 = u61;
    local v169 = p162[p161];
    local v170 = p163[p161];

    if v167.X > v170.X or (v168.X < v169.X or (v167.Y > v170.Y or (v168.Y < v169.Y or (v167.Z > v170.Z or v168.Z < v169.Z)))) then
        return false;
    end;

    local v171 = u39;
    local v172 = p164[p161];
    local v173 = p165[p161] * 4;

    for i = 1, p166[p161] do
        local v174 = v172[i];
        local buffer_readf32_ret = buffer.readf32(v171, v173);
        v173 = v173 + 4;

        if u3 then
            if u7 then
                buffer_readf32_ret = buffer_readf32_ret + (math.abs(v174.X) * u4 + math.abs(v174.Y) * u5 + math.abs(v174.Z) * u6);
            else
                local vector_dot_ret = vector.dot(v174, u8);
                local math_abs_ret = math.abs(vector_dot_ret);
                local vector_dot_ret2 = vector.dot(v174, u9);
                local v175 = math_abs_ret + math.abs(vector_dot_ret2);
                local vector_dot_ret3 = vector.dot(v174, u10);
                buffer_readf32_ret = buffer_readf32_ret + (v175 + math.abs(vector_dot_ret3) - (math.abs(v174.X) * u11.X + math.abs(v174.Y) * u11.Y + math.abs(v174.Z) * u11.Z));
            end;
        end;

        if vector.dot(p160, v174) - buffer_readf32_ret > 0 then
            return false;
        end;

        local _ = i;
    end;

    return true;
end;

local function SolidNode(p176: number) -- Line: 461
    -- upvalues: u37 (ref), u36 (ref), BoxInHull (copy), u12 (ref), u38 (ref), u26 (ref), u27 (ref), u28 (ref), u29 (ref), u30 (ref), u159 (ref), u34 (ref), u35 (ref), NodeEntryT (copy), SolidNode (copy)
    local v177 = u37[p176];

    if v177 > 0 then
        local v178 = u36[p176];

        for i = 1, v177 do
            if BoxInHull(u12, u38[v178 + i], u26, u27, u28, u29, u30) then
                u159 = true;

                return;
            end;

            local _ = i;
        end;

        return;
    end;

    local v179 = u34[p176];
    local v180 = u35[p176];

    if NodeEntryT(v179, 1) < (1 / 0) then
        SolidNode(v179);

        if u159 then
            return;
        end;
    end;

    if NodeEntryT(v180, 1) < (1 / 0) then
        SolidNode(v180);
    end;
end;

function u1.BoxSolid(p181: vector, p182: vector, p183) -- Line: 488
    -- upvalues: u31 (ref), CollisionState (copy), u32 (ref), u33 (ref), u34 (ref), u35 (ref), u36 (ref), u37 (ref), u38 (ref), u39 (ref), u40 (ref), u41 (ref), u43 (ref), u44 (ref), u45 (ref), u46 (ref), u47 (ref), u48 (ref), u49 (ref), u50 (ref), u51 (ref), u52 (ref), u53 (ref), u54 (ref), u42 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u3 (ref), u13 (ref), u62 (ref), u24 (ref), u63 (ref), u60 (ref), u61 (ref), u57 (ref), u58 (ref), u59 (ref), u159 (ref), SetupSweepFrame (copy), u26 (ref), u27 (ref), u28 (ref), u29 (ref), u30 (ref), NodeEntryT (copy), SolidNode (copy)
    if u31 ~= CollisionState.Generation then
        local v184 = CollisionState;
        u32 = v184.NodeMin;
        u33 = v184.NodeMax;
        u34 = v184.NodeLeft;
        u35 = v184.NodeRight;
        u36 = v184.NodeRecordStart;
        u37 = v184.NodeRecordCount;
        u38 = v184.LeafRecords;
        u39 = v184.GlobalEds;
        u40 = v184.SkinThickness;
        u41 = v184.SkinThicknessVector;
        u43 = v184.HullClimbable;
        u44 = v184.HullInstance;
        u45 = v184.StandMin;
        u46 = v184.StandMax;
        u47 = v184.StandNormals;
        u48 = v184.StandEdsStart;
        u49 = v184.StandHullCount;
        u50 = v184.CrouchMin;
        u51 = v184.CrouchMax;
        u52 = v184.CrouchNormals;
        u53 = v184.CrouchEdsStart;
        u54 = v184.CrouchHullCount;
        u42 = v184.BVHRoot;
        u31 = v184.Generation;
    end;

    local v185 = u41;
    local HalfDefaultCollisionBox = CollisionState.HalfDefaultCollisionBox;
    local v186 = p182 * 0.5;

    if p183 then
        u8 = p183.XVector * v186.X;
        u9 = p183.YVector * v186.Y;
        u10 = p183.ZVector * v186.Z;
    else
        u8 = vector.create(v186.X, 0, 0);
        u9 = vector.create(0, v186.Y, 0);
        u10 = vector.create(0, 0, v186.Z);
    end;

    u11 = HalfDefaultCollisionBox;
    local v187 = math.abs(u8.X) + math.abs(u9.X) + math.abs(u10.X);
    local v188 = math.abs(u8.Y) + math.abs(u9.Y) + math.abs(u10.Y);
    local v189 = math.abs(u8.Z) + math.abs(u9.Z) + math.abs(u10.Z);
    local vector_create_ret = vector.create(v187, v188, v189);
    u4 = vector_create_ret.X - HalfDefaultCollisionBox.X;
    u5 = vector_create_ret.Y - HalfDefaultCollisionBox.Y;
    u6 = vector_create_ret.Z - HalfDefaultCollisionBox.Z;
    u7 = p183 == nil;
    local v190 = u7;

    if v190 then
        if u4 == 0 and u5 == 0 then
            v190 = u6 == 0;
        else
            v190 = false;
        end;
    end;

    u3 = not v190;

    if u31 ~= CollisionState.Generation then
        local v191 = CollisionState;
        u32 = v191.NodeMin;
        u33 = v191.NodeMax;
        u34 = v191.NodeLeft;
        u35 = v191.NodeRight;
        u36 = v191.NodeRecordStart;
        u37 = v191.NodeRecordCount;
        u38 = v191.LeafRecords;
        u39 = v191.GlobalEds;
        u40 = v191.SkinThickness;
        u41 = v191.SkinThicknessVector;
        u43 = v191.HullClimbable;
        u44 = v191.HullInstance;
        u45 = v191.StandMin;
        u46 = v191.StandMax;
        u47 = v191.StandNormals;
        u48 = v191.StandEdsStart;
        u49 = v191.StandHullCount;
        u50 = v191.CrouchMin;
        u51 = v191.CrouchMax;
        u52 = v191.CrouchNormals;
        u53 = v191.CrouchEdsStart;
        u54 = v191.CrouchHullCount;
        u42 = v191.BVHRoot;
        u31 = v191.Generation;
    end;

    u13 = p181;
    u62 = 1;
    u24 = 1;
    u63 = false;
    local v192 = 0;
    local v193 = 0;
    local v194 = 0;

    if u3 then
        if u4 > 0 then
            v192 = u4;
        end;

        if u5 > 0 then
            v193 = u5;
        end;

        if u6 > 0 then
            v194 = u6;
        end;
    end;

    local vector_create_ret2 = vector.create(v192, v193, v194);
    u60 = p181 - v185 - vector_create_ret2;
    u61 = p181 + v185 + vector_create_ret2;
    local v195 = u40 * 2;
    u57 = v195 + v192;
    u58 = v195 + v193;
    u59 = v195 + v194;
    u159 = false;
    local v196 = u42;

    if v196 ~= 0 then
        SetupSweepFrame(p181, p181);
        u26 = u45;
        u27 = u46;
        u28 = u47;
        u29 = u48;
        u30 = u49;

        if NodeEntryT(v196, 1) < (1 / 0) then
            SolidNode(v196);
        end;
    end;

    u3 = false;

    return u159;
end;

function u1.Sweep(p197: vector, p198: vector, p199: boolean) -- Line: 538
    -- upvalues: u3 (ref), u31 (ref), CollisionState (copy), u32 (ref), u33 (ref), u34 (ref), u35 (ref), u36 (ref), u37 (ref), u38 (ref), u39 (ref), u40 (ref), u41 (ref), u43 (ref), u44 (ref), u45 (ref), u46 (ref), u47 (ref), u48 (ref), u49 (ref), u50 (ref), u51 (ref), u52 (ref), u53 (ref), u54 (ref), u42 (ref), u2 (copy), u13 (ref), u62 (ref), u24 (ref), u63 (ref), u4 (ref), u5 (ref), u6 (ref), u60 (ref), u61 (ref), u57 (ref), u58 (ref), u59 (ref), SetupSweepFrame (copy), u25 (ref), u26 (ref), u27 (ref), u28 (ref), u29 (ref), u30 (ref), NodeEntryT (copy), SweepNode (copy)
    u3 = false;

    if u31 ~= CollisionState.Generation then
        local v200 = CollisionState;
        u32 = v200.NodeMin;
        u33 = v200.NodeMax;
        u34 = v200.NodeLeft;
        u35 = v200.NodeRight;
        u36 = v200.NodeRecordStart;
        u37 = v200.NodeRecordCount;
        u38 = v200.LeafRecords;
        u39 = v200.GlobalEds;
        u40 = v200.SkinThickness;
        u41 = v200.SkinThicknessVector;
        u43 = v200.HullClimbable;
        u44 = v200.HullInstance;
        u45 = v200.StandMin;
        u46 = v200.StandMax;
        u47 = v200.StandNormals;
        u48 = v200.StandEdsStart;
        u49 = v200.StandHullCount;
        u50 = v200.CrouchMin;
        u51 = v200.CrouchMax;
        u52 = v200.CrouchNormals;
        u53 = v200.CrouchEdsStart;
        u54 = v200.CrouchHullCount;
        u42 = v200.BVHRoot;
        u31 = v200.Generation;
    end;

    local v201 = u41;
    local v202 = vector.min(p197, p198) - v201;
    local v203 = vector.max(p197, p198) + v201;
    local v204 = u2;
    v204.EndPosition = p198;
    v204.Fraction = 1;
    v204.StartSolid = false;
    v204.AllSolid = false;
    v204.Normal = Vector3.new(0, 1, 0);
    v204.SweepMin = v202;
    v204.SweepMax = v203;
    v204.Instance = nil;
    v204.Climbable = nil;
    v204.StartInHull = false;
    v204.EndInHull = false;

    if u31 ~= CollisionState.Generation then
        local v205 = CollisionState;
        u32 = v205.NodeMin;
        u33 = v205.NodeMax;
        u34 = v205.NodeLeft;
        u35 = v205.NodeRight;
        u36 = v205.NodeRecordStart;
        u37 = v205.NodeRecordCount;
        u38 = v205.LeafRecords;
        u39 = v205.GlobalEds;
        u40 = v205.SkinThickness;
        u41 = v205.SkinThicknessVector;
        u43 = v205.HullClimbable;
        u44 = v205.HullInstance;
        u45 = v205.StandMin;
        u46 = v205.StandMax;
        u47 = v205.StandNormals;
        u48 = v205.StandEdsStart;
        u49 = v205.StandHullCount;
        u50 = v205.CrouchMin;
        u51 = v205.CrouchMax;
        u52 = v205.CrouchNormals;
        u53 = v205.CrouchEdsStart;
        u54 = v205.CrouchHullCount;
        u42 = v205.BVHRoot;
        u31 = v205.Generation;
    end;

    u13 = p198;
    u62 = 1;
    u24 = 1;
    u63 = false;
    local v206 = 0;
    local v207 = 0;
    local v208 = 0;

    if u3 then
        if u4 > 0 then
            v206 = u4;
        end;

        if u5 > 0 then
            v207 = u5;
        end;

        if u6 > 0 then
            v208 = u6;
        end;
    end;

    local vector_create_ret = vector.create(v206, v207, v208);
    u60 = v202 - vector_create_ret;
    u61 = v203 + vector_create_ret;
    local v209 = u40 * 2;
    u57 = v209 + v206;
    u58 = v209 + v207;
    u59 = v209 + v208;
    local v210 = u42;

    if v210 ~= 0 then
        SetupSweepFrame(p197, p198);
        u25 = v204;

        if p199 then
            u26 = u50;
            u27 = u51;
            u28 = u52;
            u29 = u53;
            u30 = u54;
        else
            u26 = u45;
            u27 = u46;
            u28 = u47;
            u29 = u48;
            u30 = u49;
        end;

        if NodeEntryT(v210, 1) < (1 / 0) then
            SweepNode(v210);
        end;
    end;

    if u63 then
        v204.AllSolid = true;
        u62 = 0;
    end;

    v204.Fraction = u62;

    if v204.Fraction < 1 then
        v204.EndPosition = p197 + (p198 - p197) * v204.Fraction;
    end;

    return v204;
end;

function u1.SweepBox(p211: vector, p212: vector, p213: vector, p214) -- Line: 579
    -- upvalues: u31 (ref), CollisionState (copy), u32 (ref), u33 (ref), u34 (ref), u35 (ref), u36 (ref), u37 (ref), u38 (ref), u39 (ref), u40 (ref), u41 (ref), u43 (ref), u44 (ref), u45 (ref), u46 (ref), u47 (ref), u48 (ref), u49 (ref), u50 (ref), u51 (ref), u52 (ref), u53 (ref), u54 (ref), u42 (ref), u2 (copy), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u3 (ref), u13 (ref), u62 (ref), u24 (ref), u63 (ref), u60 (ref), u61 (ref), u57 (ref), u58 (ref), u59 (ref), SetupSweepFrame (copy), u25 (ref), u26 (ref), u27 (ref), u28 (ref), u29 (ref), u30 (ref), NodeEntryT (copy), SweepNode (copy)
    if u31 ~= CollisionState.Generation then
        local v215 = CollisionState;
        u32 = v215.NodeMin;
        u33 = v215.NodeMax;
        u34 = v215.NodeLeft;
        u35 = v215.NodeRight;
        u36 = v215.NodeRecordStart;
        u37 = v215.NodeRecordCount;
        u38 = v215.LeafRecords;
        u39 = v215.GlobalEds;
        u40 = v215.SkinThickness;
        u41 = v215.SkinThicknessVector;
        u43 = v215.HullClimbable;
        u44 = v215.HullInstance;
        u45 = v215.StandMin;
        u46 = v215.StandMax;
        u47 = v215.StandNormals;
        u48 = v215.StandEdsStart;
        u49 = v215.StandHullCount;
        u50 = v215.CrouchMin;
        u51 = v215.CrouchMax;
        u52 = v215.CrouchNormals;
        u53 = v215.CrouchEdsStart;
        u54 = v215.CrouchHullCount;
        u42 = v215.BVHRoot;
        u31 = v215.Generation;
    end;

    local v216 = u41;
    local v217 = vector.min(p211, p212) - v216;
    local v218 = vector.max(p211, p212) + v216;
    local v219 = u2;
    v219.EndPosition = p212;
    v219.Fraction = 1;
    v219.StartSolid = false;
    v219.AllSolid = false;
    v219.Normal = Vector3.new(0, 1, 0);
    v219.SweepMin = v217;
    v219.SweepMax = v218;
    v219.Instance = nil;
    v219.Climbable = nil;
    v219.StartInHull = false;
    v219.EndInHull = false;
    local HalfDefaultCollisionBox = CollisionState.HalfDefaultCollisionBox;
    local v220 = p213 * 0.5;

    if p214 then
        u8 = p214.XVector * v220.X;
        u9 = p214.YVector * v220.Y;
        u10 = p214.ZVector * v220.Z;
    else
        u8 = vector.create(v220.X, 0, 0);
        u9 = vector.create(0, v220.Y, 0);
        u10 = vector.create(0, 0, v220.Z);
    end;

    u11 = HalfDefaultCollisionBox;
    local v221 = math.abs(u8.X) + math.abs(u9.X) + math.abs(u10.X);
    local v222 = math.abs(u8.Y) + math.abs(u9.Y) + math.abs(u10.Y);
    local v223 = math.abs(u8.Z) + math.abs(u9.Z) + math.abs(u10.Z);
    local vector_create_ret = vector.create(v221, v222, v223);
    u4 = vector_create_ret.X - HalfDefaultCollisionBox.X;
    u5 = vector_create_ret.Y - HalfDefaultCollisionBox.Y;
    u6 = vector_create_ret.Z - HalfDefaultCollisionBox.Z;
    u7 = p214 == nil;
    local v224 = u7;

    if v224 then
        if u4 == 0 and u5 == 0 then
            v224 = u6 == 0;
        else
            v224 = false;
        end;
    end;

    u3 = not v224;

    if u31 ~= CollisionState.Generation then
        local v225 = CollisionState;
        u32 = v225.NodeMin;
        u33 = v225.NodeMax;
        u34 = v225.NodeLeft;
        u35 = v225.NodeRight;
        u36 = v225.NodeRecordStart;
        u37 = v225.NodeRecordCount;
        u38 = v225.LeafRecords;
        u39 = v225.GlobalEds;
        u40 = v225.SkinThickness;
        u41 = v225.SkinThicknessVector;
        u43 = v225.HullClimbable;
        u44 = v225.HullInstance;
        u45 = v225.StandMin;
        u46 = v225.StandMax;
        u47 = v225.StandNormals;
        u48 = v225.StandEdsStart;
        u49 = v225.StandHullCount;
        u50 = v225.CrouchMin;
        u51 = v225.CrouchMax;
        u52 = v225.CrouchNormals;
        u53 = v225.CrouchEdsStart;
        u54 = v225.CrouchHullCount;
        u42 = v225.BVHRoot;
        u31 = v225.Generation;
    end;

    u13 = p212;
    u62 = 1;
    u24 = 1;
    u63 = false;
    local v226 = 0;
    local v227 = 0;
    local v228 = 0;

    if u3 then
        if u4 > 0 then
            v226 = u4;
        end;

        if u5 > 0 then
            v227 = u5;
        end;

        if u6 > 0 then
            v228 = u6;
        end;
    end;

    local vector_create_ret2 = vector.create(v226, v227, v228);
    u60 = v217 - vector_create_ret2;
    u61 = v218 + vector_create_ret2;
    local v229 = u40 * 2;
    u57 = v229 + v226;
    u58 = v229 + v227;
    u59 = v229 + v228;
    local v230 = u42;

    if v230 ~= 0 then
        SetupSweepFrame(p211, p212);
        u25 = v219;
        u26 = u45;
        u27 = u46;
        u28 = u47;
        u29 = u48;
        u30 = u49;

        if NodeEntryT(v230, 1) < (1 / 0) then
            SweepNode(v230);
        end;
    end;

    u3 = false;

    if u63 then
        v219.AllSolid = true;
        u62 = 0;
    end;

    v219.Fraction = u62;

    if v219.Fraction < 1 then
        v219.EndPosition = p211 + (p212 - p211) * v219.Fraction;
    end;

    return v219;
end;

function u1.SweepLadders(p231: vector, p232: vector, p233: boolean) -- Line: 636
    -- upvalues: u3 (ref), u31 (ref), CollisionState (copy), u32 (ref), u33 (ref), u34 (ref), u35 (ref), u36 (ref), u37 (ref), u38 (ref), u39 (ref), u40 (ref), u41 (ref), u43 (ref), u44 (ref), u45 (ref), u46 (ref), u47 (ref), u48 (ref), u49 (ref), u50 (ref), u51 (ref), u52 (ref), u53 (ref), u54 (ref), u42 (ref), u2 (copy), u13 (ref), u62 (ref), u24 (ref), u63 (ref), u4 (ref), u5 (ref), u6 (ref), u60 (ref), u61 (ref), u57 (ref), u58 (ref), u59 (ref), CheckBrushNoStuck (copy), u1 (copy)
    u3 = false;

    if u31 ~= CollisionState.Generation then
        local v234 = CollisionState;
        u32 = v234.NodeMin;
        u33 = v234.NodeMax;
        u34 = v234.NodeLeft;
        u35 = v234.NodeRight;
        u36 = v234.NodeRecordStart;
        u37 = v234.NodeRecordCount;
        u38 = v234.LeafRecords;
        u39 = v234.GlobalEds;
        u40 = v234.SkinThickness;
        u41 = v234.SkinThicknessVector;
        u43 = v234.HullClimbable;
        u44 = v234.HullInstance;
        u45 = v234.StandMin;
        u46 = v234.StandMax;
        u47 = v234.StandNormals;
        u48 = v234.StandEdsStart;
        u49 = v234.StandHullCount;
        u50 = v234.CrouchMin;
        u51 = v234.CrouchMax;
        u52 = v234.CrouchNormals;
        u53 = v234.CrouchEdsStart;
        u54 = v234.CrouchHullCount;
        u42 = v234.BVHRoot;
        u31 = v234.Generation;
    end;

    local v235 = u41;
    local v236 = vector.min(p231, p232) - v235;
    local v237 = vector.max(p231, p232) + v235;
    local v238 = u2;
    v238.EndPosition = p232;
    v238.Fraction = 1;
    v238.StartSolid = false;
    v238.AllSolid = false;
    v238.Normal = Vector3.new(0, 1, 0);
    v238.SweepMin = v236;
    v238.SweepMax = v237;
    v238.Instance = nil;
    v238.Climbable = nil;
    v238.StartInHull = false;
    v238.EndInHull = false;

    if u31 ~= CollisionState.Generation then
        local v239 = CollisionState;
        u32 = v239.NodeMin;
        u33 = v239.NodeMax;
        u34 = v239.NodeLeft;
        u35 = v239.NodeRight;
        u36 = v239.NodeRecordStart;
        u37 = v239.NodeRecordCount;
        u38 = v239.LeafRecords;
        u39 = v239.GlobalEds;
        u40 = v239.SkinThickness;
        u41 = v239.SkinThicknessVector;
        u43 = v239.HullClimbable;
        u44 = v239.HullInstance;
        u45 = v239.StandMin;
        u46 = v239.StandMax;
        u47 = v239.StandNormals;
        u48 = v239.StandEdsStart;
        u49 = v239.StandHullCount;
        u50 = v239.CrouchMin;
        u51 = v239.CrouchMax;
        u52 = v239.CrouchNormals;
        u53 = v239.CrouchEdsStart;
        u54 = v239.CrouchHullCount;
        u42 = v239.BVHRoot;
        u31 = v239.Generation;
    end;

    u13 = p232;
    u62 = 1;
    u24 = 1;
    u63 = false;
    local v240 = 0;
    local v241 = 0;
    local v242 = 0;

    if u3 then
        if u4 > 0 then
            v240 = u4;
        end;

        if u5 > 0 then
            v241 = u5;
        end;

        if u6 > 0 then
            v242 = u6;
        end;
    end;

    local vector_create_ret = vector.create(v240, v241, v242);
    u60 = v236 - vector_create_ret;
    u61 = v237 + vector_create_ret;
    local v243 = u40 * 2;
    u57 = v243 + v240;
    u58 = v243 + v241;
    u59 = v243 + v242;
    local v244, v245, v246, v247, v248, v249;

    if p233 then
        v244 = CollisionState.CrouchLadders;
        v245 = u50;
        v246 = u51;
        v247 = u52;
        v248 = u53;
        v249 = u54;
    else
        v244 = CollisionState.StandLadders;
        v245 = u45;
        v246 = u46;
        v247 = u47;
        v248 = u48;
        v249 = u49;
    end;

    local v250 = u60;
    local v251 = u61;
    local v252 = p231.Y + u40;

    for i = 1, #v244 do
        local v253 = v244[i];
        local v254 = v245[v253];
        local v255 = v246[v253];
        local v256;

        if v252 < v255.Y and (v250.X <= v255.X and (v251.X >= v254.X and (v250.Y <= v255.Y and (v251.Y >= v254.Y and (v250.Z <= v255.Z and v251.Z >= v254.Z))))) then
            CheckBrushNoStuck(p231, v238, v253, v247, v248, v249);

            if u63 then
                break;
            end;

            v256 = i;
        else
            v256 = i;
        end;
    end;

    if u63 then
        v238.AllSolid = true;
        u62 = 0;
    end;

    v238.Fraction = u62;
    local Fraction = v238.Fraction;

    if Fraction < 1 then
        local Normal = v238.Normal;
        local Climbable = v238.Climbable;
        local Instance = v238.Instance;
        local StartSolid = v238.StartSolid;
        local AllSolid = v238.AllSolid;
        local StartInHull = v238.StartInHull;
        local EndInHull = v238.EndInHull;
        local v257 = u1.Sweep(p231, p232, p233);
        local vector_magnitude_ret = vector.magnitude(p232 - p231);
        local v258 = not v257.Climbable and u40 < (Fraction - v257.Fraction) * vector_magnitude_ret;
        local SweepMin = v257.SweepMin;
        local SweepMax = v257.SweepMax;
        local v259 = u2;
        v259.EndPosition = p232;
        v259.Fraction = 1;
        v259.StartSolid = false;
        v259.AllSolid = false;
        v259.Normal = Vector3.new(0, 1, 0);
        v259.SweepMin = SweepMin;
        v259.SweepMax = SweepMax;
        v259.Instance = nil;
        v259.Climbable = nil;
        v259.StartInHull = false;
        v259.EndInHull = false;

        if not v258 then
            v238.Fraction = Fraction;
            v238.Normal = Normal;
            v238.Climbable = Climbable;
            v238.Instance = Instance;
            v238.StartSolid = StartSolid;
            v238.AllSolid = AllSolid;
            v238.StartInHull = StartInHull;
            v238.EndInHull = EndInHull;
            v238.EndPosition = p231 + (p232 - p231) * Fraction;
        end;
    end;

    return v238;
end;

return u1;