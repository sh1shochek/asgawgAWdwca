-- ReplicatedStorage.Shared.ProjectDecal
-- Script path: ReplicatedStorage.Shared.ProjectDecal
-- Decompile time: 17.39 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local script_Primitives = require(script.Primitives);
local script_EditMeshPart = require(script.EditMeshPart);
u1.decalThickness = 0.004;
u1.backfaceTolerance = 0.05;
u1.removeBackfaces = true;
u1.debugNormals = false;
u1.debugShowTime = false;
u1.localSpaceMeshes = {};
u1.cacheBudgetBytes = 8388608;
local u2 = 0;
local VectorToWorldSpace = CFrame.identity.VectorToWorldSpace;
local PointToWorldSpace = CFrame.identity.PointToWorldSpace;

local function writeVec(p3: buffer, p4: number, p5: vector) -- Line: 77
    buffer.writef32(p3, p4, p5.X);
    buffer.writef32(p3, p4 + 4, p5.Y);
    buffer.writef32(p3, p4 + 8, p5.Z);
end;

local function readVec(p6: buffer, p7: number) -- Line: 83
    local buffer_readf32_ret = buffer.readf32(p6, p7);
    local buffer_readf32_ret2 = buffer.readf32(p6, p7 + 4);
    local buffer_readf32_ret3 = buffer.readf32(p6, p7 + 8);

    return vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
end;

local function writeTri(p8: buffer, p9: number, p10: vector, p11: vector, p12: vector, p13: vector, p14: vector, p15: vector) -- Line: 87
    buffer.writef32(p8, p9, p10.X);
    buffer.writef32(p8, p9 + 4, p10.Y);
    buffer.writef32(p8, p9 + 8, p10.Z);
    local v16 = p9 + 12;
    buffer.writef32(p8, v16, p11.X);
    buffer.writef32(p8, v16 + 4, p11.Y);
    buffer.writef32(p8, v16 + 8, p11.Z);
    local v17 = p9 + 24;
    buffer.writef32(p8, v17, p12.X);
    buffer.writef32(p8, v17 + 4, p12.Y);
    buffer.writef32(p8, v17 + 8, p12.Z);
    local v18 = p9 + 36;
    buffer.writef32(p8, v18, p13.X);
    buffer.writef32(p8, v18 + 4, p13.Y);
    buffer.writef32(p8, v18 + 8, p13.Z);
    local v19 = p9 + 48;
    buffer.writef32(p8, v19, p14.X);
    buffer.writef32(p8, v19 + 4, p14.Y);
    buffer.writef32(p8, v19 + 8, p14.Z);
    local v20 = p9 + 60;
    buffer.writef32(p8, v20, p15.X);
    buffer.writef32(p8, v20 + 4, p15.Y);
    buffer.writef32(p8, v20 + 8, p15.Z);
end;

local function bounds(p21: buffer, p22: number) -- Line: 96
    local v23 = Vector3.new(inf, inf, inf);
    local v24 = Vector3.new(-inf, -inf, -inf);

    for i = 0, (p22 - 1) * 72, 72 do
        local buffer_readf32_ret = buffer.readf32(p21, i);
        local buffer_readf32_ret2 = buffer.readf32(p21, i + 4);
        local buffer_readf32_ret3 = buffer.readf32(p21, i + 8);
        local vector_create_ret = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
        local v25 = i + 12;
        local buffer_readf32_ret4 = buffer.readf32(p21, v25);
        local buffer_readf32_ret5 = buffer.readf32(p21, v25 + 4);
        local buffer_readf32_ret6 = buffer.readf32(p21, v25 + 8);
        local vector_create_ret2 = vector.create(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
        local v26 = i + 24;
        local buffer_readf32_ret7 = buffer.readf32(p21, v26);
        local buffer_readf32_ret8 = buffer.readf32(p21, v26 + 4);
        local buffer_readf32_ret9 = buffer.readf32(p21, v26 + 8);
        local vector_create_ret3 = vector.create(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);
        v23 = vector.min(v23, vector_create_ret, vector_create_ret2, vector_create_ret3);
        v24 = vector.max(v24, vector_create_ret, vector_create_ret2, vector_create_ret3);
        local _ = i;
    end;

    return v23, v24;
end;

local function disjoint(p27: vector, p28: vector, p29: vector, p30: vector) -- Line: 109
    return (p27.X > p30.X or (p27.Y > p30.Y or (p27.Z > p30.Z or (p28.X < p29.X or p28.Y < p29.Y)))) and true or p28.Z < p29.Z;
end;

local function toBuffer(p31) -- Line: 115
    -- upvalues: writeTri (copy), bounds (copy)
    local buffer_create_ret = buffer.create(#p31.sourceTris * 72);

    for i, v in p31.sourceTris do
        writeTri(buffer_create_ret, (i - 1) * 72, v.va, v.vb, v.vc, v.na, v.nb, v.nc);
    end;

    local v32, v33 = bounds(buffer_create_ret, #p31.sourceTris);

    return {
        state = "loaded",
        lastUsed = 0,
        tris = buffer_create_ret,
        count = #p31.sourceTris,
        meshSize = p31.meshSize,
        min = v32,
        max = v33
    };
end;

local u34 = {
    [Enum.PartType.Block] = toBuffer(script_Primitives:GetBlock()),
    [Enum.PartType.Wedge] = toBuffer(script_Primitives:GetWedge()),
    [Enum.PartType.Ball] = toBuffer(script_Primitives:GetBall()),
    [Enum.PartType.Cylinder] = toBuffer(script_Primitives:GetCylinder()),
    [Enum.PartType.CornerWedge] = toBuffer(script_Primitives:GetCornerWedge())
};

local function rayPlaneSplit(p35: vector, p36: vector, p37: vector, p38: number) -- Line: 134
    local vector_dot_ret = vector.dot(p36, p37);

    return math.abs(vector_dot_ret) < 0.00001 and 0 or (-vector.dot(p35, p37) - p38) / vector_dot_ret;
end;

local function FetchLocalSpaceMesh(u39: userdata) -- Line: 141
    -- upvalues: u1 (copy), writeTri (copy), bounds (copy), u2 (ref)
    if u39.MeshId == nil then
        return nil;
    end;

    local u40 = u1.localSpaceMeshes[u39.MeshId];

    if u40 == nil then
        local MeshId = u39.MeshId;
        u40 = {
            count = 0,
            state = "loading",
            min = Vector3.new(0, 0, 0),
            max = Vector3.new(0, 0, 0),
            tris = buffer.create(0),
            meshSize = u39.MeshSize,
            lastUsed = os.clock()
        };
        u1.localSpaceMeshes[MeshId] = u40;
        task.spawn(function() -- Line: 165
            -- upvalues: u39 (copy), u40 (copy), u1 (ref), MeshId (copy), writeTri (ref), bounds (ref), u2 (ref)
            local success, result = pcall(function() -- Line: 167
                -- upvalues: u39 (ref)
                return game.AssetService:CreateEditableMeshAsync(u39.MeshContent);
            end);

            if success ~= true then
                warn("Failed to load mesh ", u39:GetFullName());
                u40.state = "failed";

                return;
            end;

            if result == nil then
                warn("Mesh load skipped, EditableMesh budget exhausted: ", u39:GetFullName());
                u1.localSpaceMeshes[MeshId] = nil;
                u40.state = "failed";

                return;
            end;

            local Faces = result:GetFaces();
            local buffer_create_ret = buffer.create(#Faces * 72);
            local u41 = {};
            local u42 = {};

            local function position(p43) -- Line: 193
                -- upvalues: u41 (copy), result (copy)
                local v44 = u41[p43];

                if v44 == nil then
                    v44 = result:GetPosition(p43);
                    u41[p43] = v44;
                end;

                return v44;
            end;

            local function normal(p45) -- Line: 202
                -- upvalues: u42 (copy), result (copy)
                local v46 = u42[p45];

                if v46 == nil then
                    v46 = result:GetNormal(p45) or Vector3.new(1, 1, 1);
                    u42[p45] = v46;
                end;

                return v46;
            end;

            for i, v in Faces do
                local FaceVertices = result:GetFaceVertices(v);
                local FaceNormals = result:GetFaceNormals(v);
                local v47 = FaceVertices[1];
                local v48 = u41[v47];

                if v48 == nil then
                    v48 = result:GetPosition(v47);
                    u41[v47] = v48;
                end;

                local v49 = FaceVertices[2];
                local v50 = u41[v49];

                if v50 == nil then
                    v50 = result:GetPosition(v49);
                    u41[v49] = v50;
                end;

                local v51 = FaceVertices[3];
                local v52 = u41[v51];

                if v52 == nil then
                    v52 = result:GetPosition(v51);
                    u41[v51] = v52;
                end;

                local v53 = FaceNormals[1];
                local v54 = u42[v53];

                if v54 == nil then
                    v54 = result:GetNormal(v53) or Vector3.new(1, 1, 1);
                    u42[v53] = v54;
                end;

                local v55 = FaceNormals[2];
                local v56 = u42[v55];

                if v56 == nil then
                    v56 = result:GetNormal(v55) or Vector3.new(1, 1, 1);
                    u42[v55] = v56;
                end;

                local v57 = FaceNormals[3];
                local v58 = u42[v57];

                if v58 == nil then
                    v58 = result:GetNormal(v57) or Vector3.new(1, 1, 1);
                    u42[v57] = v58;
                end;

                writeTri(buffer_create_ret, (i - 1) * 72, v48, v50, v52, v54, v56, v58);
            end;

            result:Destroy();
            u40.tris = buffer_create_ret;
            u40.count = #Faces;
            local v59, v60 = bounds(buffer_create_ret, #Faces);
            u40.min = v59;
            u40.max = v60;
            u40.state = "loaded";
            u2 = u2 + buffer.len(buffer_create_ret);

            while u2 > u1.cacheBudgetBytes do
                local v61 = nil;
                local v62 = nil;

                for i, v in u1.localSpaceMeshes do
                    if v ~= u40 and (v.state == "loaded" and (v61 == nil or v.lastUsed < v61.lastUsed)) then
                        v62 = i;
                        v61 = v;
                    end;
                end;

                if v61 == nil then
                    break;
                end;

                u2 = u2 - buffer.len(v61.tris);
                u1.localSpaceMeshes[v62] = nil;
            end;
        end);
    end;

    u40.lastUsed = os.clock();

    if u40 then
        while u40.state == "loading" do
            task.wait();
        end;
    end;

    return u40;
end;

function EmitDebugNormal(p63: vector, p64: vector, p65: any)
    local Part = Instance.new("Part");
    Part.Parent = game.Workspace;
    Part.Size = Vector3.new(0.1, 0.1, 1);
    Part.Anchored = true;
    Part.Material = Enum.Material.Neon;
    Part.Color = Color3.new(1, 0.9, 0.8);
    Part.CFrame = CFrame.lookAt(p63 + p64 / 2, p63 + p64);
    Part:SetAttribute("debug", p65);
    local Part2 = Instance.new("Part");
    Part2.Parent = game.Workspace;
    Part2.Size = Vector3.new(0.2, 0.2, 0.2);
    Part2.Anchored = true;
    Part2.Material = Enum.Material.Neon;
    Part2.Color = Color3.new(1, 0.5, 0.5);
    Part2.CFrame = CFrame.new(p63);
end;

function CreateMeshPartFromEditMesh(p66: userdata)
    debug.profilebegin("CreateMeshPartFromEditMesh");
    local v67 = game.AssetService:CreateMeshPartAsync(Content.fromObject(p66), {
        CollisionFidelity = Enum.CollisionFidelity.Box,
        RenderFidelity = Enum.RenderFidelity.Precise,
        FluidFidelity = Enum.FluidFidelity.UseCollisionGeometry
    });

    if v67 then
        v67.CanCollide = false;
        v67.CanQuery = false;
        v67.CanTouch = false;
        v67.CastShadow = false;
        v67.EnableFluidForces = false;
        v67.Color = Color3.new(1, 1, 1);
        v67.Anchored = true;
        v67.Parent = game.Workspace;
    end;

    debug.profileend();

    return v67;
end;

function GetMeshRec(p68: userdata)
    -- upvalues: u34 (copy), FetchLocalSpaceMesh (copy)
    if p68:IsA("Part") then
        local v69 = u34[p68.Shape];

        if v69 == nil then
            return nil, nil, nil, nil;
        end;

        local CFrame_fromMatrix_ret = CFrame.fromMatrix(Vector3.new(0, 0, 0), Vector3.new(p68.Size.X, 0, 0), Vector3.new(0, p68.Size.Y, 0), (Vector3.new(0, 0, p68.Size.Z)));

        return v69, p68.CFrame * CFrame_fromMatrix_ret, p68.CFrame, p68.Size;
    end;

    if not p68:IsA("MeshPart") then
        return nil, nil, nil, nil;
    end;

    local v70 = FetchLocalSpaceMesh(p68);

    if v70 == nil or v70.count == 0 then
        return nil, nil, nil, nil;
    end;

    local v71 = p68.Size / p68.MeshSize;
    local CFrame_fromMatrix_ret = CFrame.fromMatrix(Vector3.new(0, 0, 0), Vector3.new(v71.X, 0, 0), Vector3.new(0, v71.Y, 0), (Vector3.new(0, 0, v71.Z)));

    return v70, p68.CFrame * CFrame_fromMatrix_ret, p68.CFrame, v71;
end;

function u1.ProjectMeshOntoTriangles(p72: table, u73: any, p74: table, p75: table, p76: table, p77: table, p78: table, p79: number) -- Line: 345
    -- upvalues: u1 (copy), PointToWorldSpace (copy), VectorToWorldSpace (copy)
    debug.profilebegin("ProjectMeshOntoTriangles");
    local v80 = tick();
    local v81 = p79 + 1;

    for _, v in p78 do
        local v82 = 1 / v.size;
        local u83 = CFrame.fromMatrix(Vector3.new(-0.5, -0.5, -0.5), Vector3.new(v82.X, 0, 0), Vector3.new(0, 1, 0), (Vector3.new(0, 0, v82.Z))) * v.cframe:Inverse();

        if v.rect then
            u83 = CFrame.fromMatrix(Vector3.new(v.rect.Min.X, 0, v.rect.Min.Y), Vector3.new(v.rect.Width, 0, 0), Vector3.new(0, 1, 0), (Vector3.new(0, 0, v.rect.Height))) * u83;
        end;

        local UpVector = v.cframe.UpVector;
        local u84 = -UpVector * v81 * u1.decalThickness * v.size.Y;
        local v85 = v.size / 2;
        local v86 = v;
        local v87 = {};

        for _, v2 in { -1, 1 } do
            local v88 = v2;

            for _, v3 in { -1, 1 } do
                local v89 = v3;

                for _, v4 in { -1, 1 } do
                    local v90 = v85 * Vector3.new(v88, v89, v4);
                    table.insert(v87, v90);
                end;
            end;
        end;

        local u91 = {
            {
                n = Vector3.new(0, 1, 0),
                d = v85.Y
            },
            {
                n = Vector3.new(0, -1, 0),
                d = v85.Y
            },
            {
                n = Vector3.new(0, 0, 1),
                d = v85.Z
            },
            {
                n = Vector3.new(0, 0, -1),
                d = v85.Z
            },
            {
                n = Vector3.new(1, 0, 0),
                d = v85.X
            },
            {
                n = Vector3.new(-1, 0, 0),
                d = v85.X
            }
        };

        for _, v2 in u91 do
            local v92 = CFrame.identity.VectorToWorldSpace(v86.cframe, v2.n);
            local vector_normalize_ret = vector.normalize(v92);
            local v93 = CFrame.identity.PointToWorldSpace(v86.cframe, v2.n * v2.d);
            local vector_dot_ret = vector.dot(vector_normalize_ret, v93);
            v2.n = -vector_normalize_ret;
            v2.d = vector_dot_ret;
        end;

        local function PlaneClipTri(p94: vector, p95: vector, p96: vector, p97: vector, p98: vector, p99: vector, p100: number) -- Line: 397
            -- upvalues: u91 (copy), PlaneClipTri (copy), PointToWorldSpace (ref), u83 (ref), u73 (copy), u84 (copy)
            for i = p100, #u91 do
                local v101 = u91[i];
                local n = v101.n;
                local d = v101.d;
                local v102 = vector.dot(n, p94) + d;
                local v103 = vector.dot(n, p95) + d;
                local v104 = vector.dot(n, p96) + d;

                if v102 < 0 and (v103 < 0 and v104 < 0) then
                    return;
                end;

                local v105;

                if v102 * v103 < 0 then
                    if v102 * v104 < 0 then
                        local vector_dot_ret = vector.dot(p95 - p94, n);
                        local v106 = math.abs(vector_dot_ret) < 0.00001 and 0 or (-vector.dot(p94, n) - d) / vector_dot_ret;
                        local vector_dot_ret2 = vector.dot(p96 - p94, n);
                        local v107 = math.abs(vector_dot_ret2) < 0.00001 and 0 or (-vector.dot(p94, n) - d) / vector_dot_ret2;
                        local v108 = Vector3.zero.Lerp(p94, p95, v106);
                        local v109 = Vector3.zero.Lerp(p97, p98, v106);
                        local vector_normalize_ret = vector.normalize(v109);
                        local v110 = Vector3.zero.Lerp(p94, p96, v107);
                        local v111 = Vector3.zero.Lerp(p97, p99, v107);
                        local vector_normalize_ret2 = vector.normalize(v111);

                        if v102 > 0 then
                            p99 = vector_normalize_ret2;
                            p98 = vector_normalize_ret;
                            p96 = v110;
                            p95 = v108;
                            v105 = i;
                        else
                            PlaneClipTri(v110, p95, p96, vector_normalize_ret2, p98, p99, p100 + 1);
                            p99 = vector_normalize_ret2;
                            p96 = v110;
                            p94 = v108;
                            v105 = i;
                            p97 = vector_normalize_ret;
                        end;
                    else
                        local vector_dot_ret = vector.dot(p96 - p95, n);
                        local v112 = math.abs(vector_dot_ret) < 0.00001 and 0 or (-vector.dot(p95, n) - d) / vector_dot_ret;
                        local vector_dot_ret2 = vector.dot(p94 - p95, n);
                        local v113 = math.abs(vector_dot_ret2) < 0.00001 and 0 or (-vector.dot(p95, n) - d) / vector_dot_ret2;
                        local v114 = Vector3.zero.Lerp(p95, p96, v112);
                        local v115 = Vector3.zero.Lerp(p98, p99, v112);
                        local vector_normalize_ret = vector.normalize(v115);
                        local v116 = Vector3.zero.Lerp(p95, p94, v113);
                        local v117 = Vector3.zero.Lerp(p98, p97, v113);
                        local vector_normalize_ret2 = vector.normalize(v117);

                        if v103 > 0 then
                            p99 = vector_normalize_ret;
                            p96 = v114;
                            p94 = v116;
                            v105 = i;
                            p97 = vector_normalize_ret2;
                        else
                            if v104 ~= 0 then
                                PlaneClipTri(v116, v114, p96, vector_normalize_ret2, vector_normalize_ret, p99, p100 + 1);
                            end;

                            p98 = vector_normalize_ret2;
                            p95 = v116;
                            v105 = i;
                        end;
                    end;
                elseif v102 * v104 < 0 or v103 * v104 < 0 then
                    local vector_dot_ret = vector.dot(p94 - p96, n);
                    local v118 = math.abs(vector_dot_ret) < 0.00001 and 0 or (-vector.dot(p96, n) - d) / vector_dot_ret;
                    local vector_dot_ret2 = vector.dot(p95 - p96, n);
                    local v119 = math.abs(vector_dot_ret2) < 0.00001 and 0 or (-vector.dot(p96, n) - d) / vector_dot_ret2;
                    local v120 = Vector3.zero.Lerp(p96, p94, v118);
                    local v121 = Vector3.zero.Lerp(p99, p97, v118);
                    local vector_normalize_ret = vector.normalize(v121);
                    local v122 = Vector3.zero.Lerp(p96, p95, v119);
                    local v123 = Vector3.zero.Lerp(p99, p98, v119);
                    local vector_normalize_ret2 = vector.normalize(v123);

                    if v104 > 0 then
                        p98 = vector_normalize_ret2;
                        p95 = v122;
                        p94 = v120;
                        v105 = i;
                        p97 = vector_normalize_ret;
                    elseif v103 == 0 then
                        p99 = vector_normalize_ret;
                        p96 = v120;
                        v105 = i;
                    elseif v102 == 0 then
                        p99 = vector_normalize_ret2;
                        p96 = v122;
                        v105 = i;
                    else
                        PlaneClipTri(p94, v122, v120, p97, vector_normalize_ret2, vector_normalize_ret, p100 + 1);
                        p99 = vector_normalize_ret2;
                        p96 = v122;
                        v105 = i;
                    end;
                else
                    if v102 < 0 then
                        return;
                    end;

                    v105 = i;
                end;
            end;

            local v124, v125, v126 = PointToWorldSpace(u83, p94, p95, p96);
            u73:AddTri(p94 + u84, p95 + u84, p96 + u84, p97, p98, p99, Vector2.new(v124.X, v124.Z), Vector2.new(v125.X, v125.Z), Vector2.new(v126.X, v126.Z));
        end;

        for i = 1, #p74 do
            local v127 = p74[i];
            local v128 = p75[i];
            local v129 = p76[i];
            local v130 = p77[i];
            local _ = i;
            local v131 = Vector3.new(inf, inf, inf);
            local v132 = Vector3.new(-inf, -inf, -inf);

            for _, v2 in v87 do
                local v133 = v129:PointToObjectSpace(PointToWorldSpace(v86.cframe, v2)) / v130;
                v131 = vector.min(v131, v133);
                v132 = vector.max(v132, v133);
            end;

            local v134 = (v132 - v131) * 0.001;
            local v135 = v131 - v134;
            local v136 = v132 + v134;
            local min = v127.min;
            local max = v127.max;

            if min.X <= v136.X and (min.Y <= v136.Y and (min.Z <= v136.Z and (max.X >= v135.X and max.Y >= v135.Y))) and max.Z >= v135.Z then
                local tris = v127.tris;

                for i2 = 0, (v127.count - 1) * 72, 72 do
                    local buffer_readf32_ret = buffer.readf32(tris, i2);
                    local buffer_readf32_ret2 = buffer.readf32(tris, i2 + 4);
                    local buffer_readf32_ret3 = buffer.readf32(tris, i2 + 8);
                    local vector_create_ret = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
                    local v137 = i2 + 12;
                    local buffer_readf32_ret4 = buffer.readf32(tris, v137);
                    local buffer_readf32_ret5 = buffer.readf32(tris, v137 + 4);
                    local buffer_readf32_ret6 = buffer.readf32(tris, v137 + 8);
                    local vector_create_ret2 = vector.create(buffer_readf32_ret4, buffer_readf32_ret5, buffer_readf32_ret6);
                    local v138 = i2 + 24;
                    local buffer_readf32_ret7 = buffer.readf32(tris, v138);
                    local buffer_readf32_ret8 = buffer.readf32(tris, v138 + 4);
                    local buffer_readf32_ret9 = buffer.readf32(tris, v138 + 8);
                    local vector_create_ret3 = vector.create(buffer_readf32_ret7, buffer_readf32_ret8, buffer_readf32_ret9);
                    local vector_min_ret = vector.min(vector_create_ret, vector_create_ret2, vector_create_ret3);
                    local vector_max_ret = vector.max(vector_create_ret, vector_create_ret2, vector_create_ret3);
                    local v139;

                    if (vector_min_ret.X > v136.X or (vector_min_ret.Y > v136.Y or (vector_min_ret.Z > v136.Z or (vector_max_ret.X < v135.X or vector_max_ret.Y < v135.Y)))) and true or vector_max_ret.Z < v135.Z then
                        v139 = i2;
                    else
                        local v140, v141, v142 = PointToWorldSpace(v128, vector_create_ret, vector_create_ret2, vector_create_ret3);
                        local v143 = i2 + 36;
                        local buffer_readf32_ret10 = buffer.readf32(tris, v143);
                        local buffer_readf32_ret11 = buffer.readf32(tris, v143 + 4);
                        local buffer_readf32_ret12 = buffer.readf32(tris, v143 + 8);
                        local vector_create_ret4 = vector.create(buffer_readf32_ret10, buffer_readf32_ret11, buffer_readf32_ret12);
                        local v144 = i2 + 48;
                        local buffer_readf32_ret13 = buffer.readf32(tris, v144);
                        local buffer_readf32_ret14 = buffer.readf32(tris, v144 + 4);
                        local buffer_readf32_ret15 = buffer.readf32(tris, v144 + 8);
                        local vector_create_ret5 = vector.create(buffer_readf32_ret13, buffer_readf32_ret14, buffer_readf32_ret15);
                        local v145 = i2 + 60;
                        local buffer_readf32_ret16 = buffer.readf32(tris, v145);
                        local buffer_readf32_ret17 = buffer.readf32(tris, v145 + 4);
                        local buffer_readf32_ret18 = buffer.readf32(tris, v145 + 8);
                        local v146, v147, v148 = VectorToWorldSpace(v129, vector_create_ret4, vector_create_ret5, (vector.create(buffer_readf32_ret16, buffer_readf32_ret17, buffer_readf32_ret18)));

                        if u1.removeBackfaces then
                            local backfaceTolerance = u1.backfaceTolerance;
                            local vector_cross_ret = vector.cross(v141 - v140, v141 - v142);
                            local vector_normalize_ret = vector.normalize(vector_cross_ret);

                            if vector.dot(vector_normalize_ret, UpVector) < backfaceTolerance then
                                v139 = i2;
                            else
                                PlaneClipTri(v140, v141, v142, v146, v147, v148, 1);
                                v139 = i2;
                            end;
                        else
                            PlaneClipTri(v140, v141, v142, v146, v147, v148, 1);
                            v139 = i2;
                        end;
                    end;
                end;
            end;
        end;
    end;

    debug.profileend();
    local v149 = tick();

    if u1.debugShowTime then
        print("TT: ", (v149 - v80) * 1000, "ms");
    end;
end;

function u1.ProjectMeshAsync(p150: table, p151: any, p152: table, p153: table, p154: number) -- Line: 565
    local v155 = {};
    local v156 = {};
    local v157 = {};
    local v158 = {};

    for _, v in p152 do
        local v159, v160, v161, v162 = GetMeshRec(v);

        if v159 and (v160 and (v161 and v162)) then
            table.insert(v155, v159);
            table.insert(v156, v160);
            table.insert(v157, v161);
            table.insert(v158, v162);
        end;
    end;

    p150:ProjectMeshOntoTriangles(p151, v155, v156, v157, v158, p153, p154);
end;

function u1.CreateEditMeshPart(p163) -- Line: 586
    -- upvalues: script_EditMeshPart (copy)
    return script_EditMeshPart:CreateEditMeshPart();
end;

return u1;