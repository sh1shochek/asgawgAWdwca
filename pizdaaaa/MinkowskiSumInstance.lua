-- ReplicatedStorage.Shared.CollisionModule.CollisionBuilder.MinkowskiSumInstance
-- Script path: ReplicatedStorage.Shared.CollisionModule.CollisionBuilder.MinkowskiSumInstance
-- Decompile time: 22.59 ms

-- Decompiled with Potassium's decompiler.

local script_QuickHull2 = require(script.QuickHull2);
local table_create_ret = table.create(24);
local v1 = 0;
local v2 = {};
local u3 = { Vector3.new(0.5, 0.5, 0.5), Vector3.new(0.5, 0.5, -0.5), Vector3.new(-0.5, 0.5, 0.5), Vector3.new(-0.5, 0.5, -0.5), Vector3.new(0.5, -0.5, 0.5), Vector3.new(0.5, -0.5, -0.5), Vector3.new(-0.5, -0.5, 0.5), Vector3.new(-0.5, -0.5, -0.5) };
local u4 = { Vector3.new(0.5, -0.5, -0.5), Vector3.new(-0.5, -0.5, -0.5), Vector3.new(0.5, -0.5, 0.5), Vector3.new(-0.5, -0.5, 0.5), Vector3.new(0.5, 0.5, 0.5), Vector3.new(-0.5, 0.5, 0.5) };
local u5 = { Vector3.new(0.5, 0.5, -0.5), Vector3.new(0.5, -0.5, 0.5), Vector3.new(-0.5, -0.5, 0.5), Vector3.new(0.5, -0.5, -0.5), Vector3.new(-0.5, -0.5, -0.5) };

for i = 0, 11 do
    local v6 = 0.5235987755982988 * i;
    local v7 = math.cos(v6) * 0.5;
    local v8 = math.sin(v6) * 0.5;
    local v9 = v1 + 1;
    table_create_ret[v9] = vector.create(0.5, v7, v8);
    v1 = v9 + 1;
    table_create_ret[v1] = vector.create(-0.5, v7, v8);
    local _ = i;
end;

local table_create_ret2 = table.create(20);

for i = 0, 19 do
    local v10 = 1 - i / 19 * 2;
    local math_max_ret = math.max(0, 1 - v10 * v10);
    local math_sqrt_ret = math.sqrt(math_max_ret);
    local v11 = 2.399963229728653 * i;
    local v12 = math.cos(v11) * math_sqrt_ret * 0.5;
    local v13 = math.sin(v11) * math_sqrt_ret * 0.5;
    table_create_ret2[i + 1] = vector.create(v12, v10 * 0.5, v13);
    local _ = i;
end;

local function BoxSupport(p14: number, p15: number, p16: number, p17: any) -- Line: 75
    return math.abs(p14) * p17.X + math.abs(p15) * p17.Y + math.abs(p16) * p17.Z;
end;

local function ResolveShapeId(p18) -- Line: 81
    if p18:IsA("Part") then
        local Shape = p18.Shape;

        if Shape == Enum.PartType.Block then
            return 1;
        end;

        if Shape == Enum.PartType.Wedge then
            return 2;
        end;

        if Shape == Enum.PartType.CornerWedge then
            return 3;
        end;

        if Shape == Enum.PartType.Cylinder then
            return 4;
        end;

        if Shape == Enum.PartType.Ball then
            return 5;
        end;
    else
        if p18:IsA("WedgePart") then
            return 2;
        end;

        if p18:IsA("CornerWedgePart") then
            return 3;
        end;
    end;

    return nil;
end;

function v2.GetPlanesForInstance(p19, p20, p21, p22) -- Line: 108
    -- upvalues: ResolveShapeId (copy)
    local v23 = ResolveShapeId(p20);

    if v23 then
        return p19:GetPlanesAnalytic(v23, p20.Size, p22, p21 * 0.5);
    end;

    return p19:GetPlanesForPoints((p19:GeneratePointsForInstance(p20, p21, p22)));
end;

function v2.GetPlanesForPoints(p24, p25) -- Line: 121
    -- upvalues: script_QuickHull2 (copy)
    local v26 = script_QuickHull2:GenerateHull(p25);
    local v27 = {};
    local v28 = {};
    local v29 = 0;

    if v26 ~= nil then
        local v30 = {};

        for _, v in pairs(v26) do
            local vector_cross_ret = vector.cross(v[1] - v[2], v[1] - v[3]);

            if vector.magnitude(vector_cross_ret) >= 1e-8 then
                local vector_normalize_ret = vector.normalize(vector_cross_ret);
                local vector_dot_ret = vector.dot(v[1], vector_normalize_ret);
                local vector_create_ret = vector.create(vector_normalize_ret.X, vector_normalize_ret.Y, vector_normalize_ret.Z);
                local math_floor_ret = math.floor(vector_create_ret.X * 10);
                local math_floor_ret2 = math.floor(vector_create_ret.Y * 10);
                local math_floor_ret3 = math.floor(vector_create_ret.Z * 10);
                local math_floor_ret4 = math.floor(vector_dot_ret * 100);
                local v31 = math_floor_ret + math_floor_ret2 * 21 + math_floor_ret3 * 441 + math_floor_ret4 * 9261;
                local v32 = true;
                local v33 = v30[v31];

                if v33 then
                    for i = 1, #v33 do
                        local v34 = v33[i];

                        if math.abs(v34.ed - vector_dot_ret) < 0.01 and vector.dot(v34.n, vector_create_ret) > 0.95 then
                            v32 = false;
                            break;
                        end;

                        local _ = i;
                    end;
                else
                    v33 = {};
                    v30[v31] = v33;
                end;

                if v32 then
                    v33[#v33 + 1] = {
                        n = vector_create_ret,
                        ed = vector_dot_ret
                    };
                    v29 = v29 + 1;
                    v27[v29] = vector_create_ret;
                    v28[v29] = vector_dot_ret;
                end;
            end;
        end;
    end;

    return v27, v28, v29;
end;

local u35 = {};

local function build(p36, p37, p38) -- Line: 205
    local v39 = #p36;
    local v40 = 0;
    local v41 = 0;
    local v42 = 0;

    for i = 1, v39 do
        local v43 = p36[i];
        v40 = v40 + v43.X;
        v41 = v41 + v43.Y;
        v42 = v42 + v43.Z;
        local _ = i;
    end;

    local vector_create_ret = vector.create(v40 / v39, v41 / v39, v42 / v39);
    local v44 = {};

    for _, v in p37 do
        local v45 = p36[v[1]];
        local vector_cross_ret = vector.cross(p36[v[2]] - v45, p36[v[3]] - v45);
        local vector_normalize_ret = vector.normalize(vector_cross_ret);

        if vector.dot(vector_normalize_ret, v45 - vector_create_ret) < 0 then
            vector_normalize_ret = -vector_normalize_ret;
        end;

        local v46 = true;

        for _, v3 in v44 do
            if vector.dot(v3, vector_normalize_ret) > 0.9999 then
                v46 = false;
                break;
            end;
        end;

        if v46 then
            table.insert(v44, vector_normalize_ret);
        end;
    end;

    local v47 = {};

    for _, v in p38 do
        local vector_normalize_ret = vector.normalize(p36[v[2]] - p36[v[1]]);
        local v48 = true;

        for _, v3 in v47 do
            local vector_dot_ret = vector.dot(v3, vector_normalize_ret);

            if math.abs(vector_dot_ret) > 0.9999 then
                v48 = false;
                break;
            end;
        end;

        if v48 then
            table.insert(v47, vector_normalize_ret);
        end;
    end;

    return {
        Verts = p36,
        FaceNormals = v44,
        EdgeDirs = v47
    };
end;

u35[1] = build(u3, { { 1, 2, 3 }, { 5, 6, 7 }, { 1, 2, 5 }, { 3, 4, 7 }, { 1, 3, 5 }, { 2, 4, 6 } }, { { 1, 3 }, { 1, 2 }, { 1, 5 } });
u35[2] = build(u4, { { 1, 2, 3 }, { 3, 4, 5 }, { 1, 2, 5 }, { 1, 3, 5 }, { 2, 4, 6 } }, { { 1, 2 }, { 1, 3 }, { 3, 5 }, { 1, 5 } });
u35[3] = build(u5, { { 2, 3, 4 }, { 1, 2, 4 }, { 1, 4, 5 }, { 1, 2, 3 }, { 1, 3, 5 } }, { { 2, 3 }, { 2, 4 }, { 1, 4 }, { 1, 2 }, { 1, 3 }, { 1, 5 } });
local u49 = { Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 1, 0), Vector3.new(0, -1, 0), Vector3.new(0, 0, 1), Vector3.new(0, 0, -1) };
local u50 = { Vector3.new(1, 0, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, 1) };

local function AddCandidate(p51, p52) -- Line: 265
    for i = 1, #p51 do
        if vector.dot(p51[i], p52) > 0.999999 then
            return;
        end;

        local _ = i;
    end;

    p51[#p51 + 1] = p52;
end;

local function BuildPolyTemplate(p53, p54, p55, p56) -- Line: 273
    -- upvalues: u49 (copy), u50 (copy)
    local X = p54.X;
    local Y = p54.Y;
    local Z = p54.Z;
    local Verts = p53.Verts;
    local v57 = #Verts;
    local table_create_ret3 = table.create(v57);

    for i = 1, v57 do
        local v58 = Verts[i];
        table_create_ret3[i] = p55:VectorToWorldSpace((vector.create(v58.X * X, v58.Y * Y, v58.Z * Z)));
        local _ = i;
    end;

    local v59 = {};

    for _, v in p53.FaceNormals do
        local vector_create_ret = vector.create(v.X / X, v.Y / Y, v.Z / Z);
        local v60 = p55:VectorToWorldSpace((vector.normalize(vector_create_ret)));

        for i = 1, #v59 do
            if vector.dot(v59[i], v60) > 0.999999 then
                break;
            end;

            local _ = i;
        end;

        v59[#v59 + 1] = v60;
    end;

    for _, v in u49 do
        local v61 = v;

        for i = 1, #v59 do
            if vector.dot(v59[i], v61) > 0.999999 then
                break;
            end;

            local _ = i;
        end;

        v59[#v59 + 1] = v61;
    end;

    for _, v in p53.EdgeDirs do
        local v62 = p55:VectorToWorldSpace((vector.create(v.X * X, v.Y * Y, v.Z * Z)));

        for _, v3 in u50 do
            local vector_cross_ret = vector.cross(v62, v3);

            if vector.magnitude(vector_cross_ret) > 1e-6 then
                local vector_normalize_ret = vector.normalize(vector_cross_ret);

                for i = 1, #v59 do
                    if vector.dot(v59[i], vector_normalize_ret) > 0.999999 then
                        break;
                    end;

                    local _ = i;
                end;

                v59[#v59 + 1] = vector_normalize_ret;
                local v63 = -vector_normalize_ret;

                for i = 1, #v59 do
                    if vector.dot(v59[i], v63) > 0.999999 then
                        break;
                    end;

                    local _ = i;
                end;

                v59[#v59 + 1] = v63;
            end;
        end;
    end;

    local v64 = 0;
    local v65 = {};

    for _, v in v59 do
        local v66 = v;
        local v67 = (-1 / 0);

        for i = 1, v57 do
            local vector_dot_ret = vector.dot(v66, table_create_ret3[i]);
            local v68;

            if v67 < vector_dot_ret then
                v67 = vector_dot_ret;
                v68 = i;
            else
                v68 = i;
            end;
        end;

        local v69 = 0;

        for i = 1, v57 do
            local v70;

            if v67 - vector.dot(v66, table_create_ret3[i]) < 0.001 then
                v69 = v69 + 1;
                v70 = i;
            else
                v70 = i;
            end;
        end;

        local X2 = v66.X;
        local Y2 = v66.Y;
        local Z2 = v66.Z;

        if (v69 >= 3 and 2 or (v69 == 2 and 1 or 0)) + ((math.abs(X2) < 1e-6 and 1 or 0) + (math.abs(Y2) < 1e-6 and 1 or 0) + (math.abs(Z2) < 1e-6 and 1 or 0)) >= 2 then
            v64 = v64 + 1;
            v65[v64] = {
                n = vector.create(X2, Y2, Z2),
                offset = v67 + (math.abs(X2) * p56.X + math.abs(Y2) * p56.Y + math.abs(Z2) * p56.Z)
            };
        end;
    end;

    return v65;
end;

local function BuildCylinderTemplate(p71, p72, p73) -- Line: 345
    -- upvalues: u49 (copy)
    local v74 = p71.X * 0.5;
    local v75 = math.min(p71.Y, p71.Z) * 0.5;
    local RightVector = p72.RightVector;
    local UpVector = p72.UpVector;
    local LookVector = p72.LookVector;
    local v76 = {};

    for i = 1, #v76 do
        if vector.dot(v76[i], RightVector) > 0.999999 then
            break;
        end;

        local _ = i;
    end;

    v76[#v76 + 1] = RightVector;
    local v77 = -RightVector;

    for i = 1, #v76 do
        if vector.dot(v76[i], v77) > 0.999999 then
            break;
        end;

        local _ = i;
    end;

    v76[#v76 + 1] = v77;

    for i = 0, 11 do
        local v78 = 0.5235987755982988 * i;
        local v79 = UpVector * math.cos(v78) + LookVector * math.sin(v78);
        local _ = i;

        for i2 = 1, #v76 do
            if vector.dot(v76[i2], v79) > 0.999999 then
                break;
            end;

            local _ = i2;
        end;

        v76[#v76 + 1] = v79;
    end;

    for _, v in u49 do
        local v80 = v;

        for i = 1, #v76 do
            if vector.dot(v76[i], v80) > 0.999999 then
                break;
            end;

            local _ = i;
        end;

        v76[#v76 + 1] = v80;
    end;

    local table_create_ret3 = table.create(#v76);

    for i, v in v76 do
        local vector_dot_ret = vector.dot(v, RightVector);
        local v81 = v74 * math.abs(vector_dot_ret);
        local math_max_ret = math.max(0, 1 - vector_dot_ret * vector_dot_ret);
        local v82 = v81 + v75 * math.sqrt(math_max_ret);
        local X = v.X;
        local Y = v.Y;
        local Z = v.Z;
        table_create_ret3[i] = {
            n = vector.create(X, Y, Z),
            offset = v82 + (math.abs(X) * p73.X + math.abs(Y) * p73.Y + math.abs(Z) * p73.Z)
        };
    end;

    return table_create_ret3;
end;

local function BuildSphereTemplate(p83, p84) -- Line: 374
    -- upvalues: table_create_ret2 (copy), u49 (copy)
    local v85 = math.min(p83.X, p83.Y, p83.Z) * 0.5;
    local v86 = {};

    for _, v in table_create_ret2 do
        local vector_normalize_ret = vector.normalize(v);

        for i = 1, #v86 do
            if vector.dot(v86[i], vector_normalize_ret) > 0.999999 then
                break;
            end;

            local _ = i;
        end;

        v86[#v86 + 1] = vector_normalize_ret;
    end;

    for _, v in u49 do
        local v87 = v;

        for i = 1, #v86 do
            if vector.dot(v86[i], v87) > 0.999999 then
                break;
            end;

            local _ = i;
        end;

        v86[#v86 + 1] = v87;
    end;

    local table_create_ret3 = table.create(#v86);

    for i, v in v86 do
        local X = v.X;
        local Y = v.Y;
        local Z = v.Z;
        table_create_ret3[i] = {
            n = vector.create(X, Y, Z),
            offset = v85 + (math.abs(X) * p84.X + math.abs(Y) * p84.Y + math.abs(Z) * p84.Z)
        };
    end;

    return table_create_ret3;
end;

function v2.GetShapeDef(p88, p89) -- Line: 397
    -- upvalues: ResolveShapeId (copy), u35 (copy)
    local v90 = ResolveShapeId(p89);

    return v90 and u35[v90] or nil;
end;

local u91 = {};

function v2.GetPlanesAnalytic(p92, p93, p94, p95, p96) -- Line: 404
    -- upvalues: u91 (ref), BuildCylinderTemplate (copy), BuildSphereTemplate (copy), BuildPolyTemplate (copy), u35 (copy)
    local _, _, _, v97, v98, v99, v100, v101, v102, v103, v104, v105 = p95:GetComponents();
    local math_floor_ret = math.floor(p94.X * 1000);
    local math_floor_ret2 = math.floor(p94.Y * 1000);
    local math_floor_ret3 = math.floor(p94.Z * 1000);
    local math_floor_ret4 = math.floor(v97 * 1000);
    local math_floor_ret5 = math.floor(v98 * 1000);
    local math_floor_ret6 = math.floor(v99 * 1000);
    local math_floor_ret7 = math.floor(v100 * 1000);
    local math_floor_ret8 = math.floor(v101 * 1000);
    local math_floor_ret9 = math.floor(v102 * 1000);
    local math_floor_ret10 = math.floor(v103 * 1000);
    local math_floor_ret11 = math.floor(v104 * 1000);
    local math_floor_ret12 = math.floor(v105 * 1000);
    local math_floor_ret13 = math.floor(p96.X * 1000);
    local math_floor_ret14 = math.floor(p96.Y * 1000);
    local math_floor_ret15 = math.floor(p96.Z * 1000);
    local string_format_ret = string.format("%d|%d,%d,%d|%d,%d,%d,%d,%d,%d,%d,%d,%d|%d,%d,%d", p93, math_floor_ret, math_floor_ret2, math_floor_ret3, math_floor_ret4, math_floor_ret5, math_floor_ret6, math_floor_ret7, math_floor_ret8, math_floor_ret9, math_floor_ret10, math_floor_ret11, math_floor_ret12, math_floor_ret13, math_floor_ret14, math_floor_ret15);
    local v106 = u91[string_format_ret];

    if v106 == nil then
        if p93 == 4 then
            v106 = BuildCylinderTemplate(p94, p95, p96);
        elseif p93 == 5 then
            v106 = BuildSphereTemplate(p94, p96);
        else
            v106 = BuildPolyTemplate(u35[p93], p94, p95, p96);
        end;

        u91[string_format_ret] = v106;
    end;

    local Position = p95.Position;
    local X = Position.X;
    local Y = Position.Y;
    local Z = Position.Z;
    local v107 = #v106;
    local table_create_ret3 = table.create(v107);
    local table_create_ret4 = table.create(v107);

    for i = 1, v107 do
        local v108 = v106[i];
        local n = v108.n;
        table_create_ret3[i] = n;
        table_create_ret4[i] = X * n.X + Y * n.Y + Z * n.Z + v108.offset;
        local _ = i;
    end;

    return table_create_ret3, table_create_ret4, v107;
end;

function v2.GeneratePointsForInstance(p109, p110, p111, p112) -- Line: 451
    -- upvalues: u3 (copy), u4 (copy), u5 (copy), table_create_ret (copy), table_create_ret2 (copy)
    local v113 = u3;

    if p110:IsA("Part") then
        local Shape = p110.Shape;

        if Shape == Enum.PartType.Wedge then
            v113 = u4;
        elseif Shape == Enum.PartType.CornerWedge then
            v113 = u5;
        elseif Shape == Enum.PartType.Cylinder then
            v113 = table_create_ret;
        elseif Shape == Enum.PartType.Ball then
            v113 = table_create_ret2;
        else
            v113 = u3;
        end;
    elseif p110:IsA("WedgePart") then
        v113 = u4;
    elseif p110:IsA("CornerWedgePart") then
        v113 = u5;
    end;

    local v114 = #v113;
    local Size = p110.Size;
    local table_create_ret3 = table.create(v114 * 8);
    local v115 = 0;

    for i = 1, v114 do
        local v116 = p112:PointToWorldSpace(v113[i] * Size);
        local _ = i;

        for i2 = 1, 8 do
            v115 = v115 + 1;
            table_create_ret3[v115] = v116 + u3[i2] * p111;
            local _ = i2;
        end;
    end;

    return table_create_ret3;
end;

function v2.ClearCache(p117) -- Line: 491
    -- upvalues: u91 (ref)
    u91 = {};
end;

return v2;