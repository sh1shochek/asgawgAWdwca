-- ReplicatedStorage.Shared.CollisionModule.CollisionBuilder.CoincidentFloors
-- Script path: ReplicatedStorage.Shared.CollisionModule.CollisionBuilder.CoincidentFloors
-- Decompile time: 9.23 ms

-- Decompiled with Potassium's decompiler.

local u20 = {
    Facet = function(p1: any, p2: vector, p3) -- Line: 75, Name: Facet
        if not p1 then
            return nil;
        end;

        local X = p2.X;
        local Y = p2.Y;
        local Z = p2.Z;
        local Verts = p1.Verts;
        local v4 = #Verts;
        local table_create_ret = table.create(v4);

        for i = 1, v4 do
            local v5 = Verts[i];
            table_create_ret[i] = p3:PointToWorldSpace((vector.create(v5.X * X, v5.Y * Y, v5.Z * Z)));
            local _ = i;
        end;

        local table_create_ret2 = table.create(#p1.FaceNormals);
        local v6 = nil;

        for _, v in p1.FaceNormals do
            local vector_create_ret = vector.create(v.X / X, v.Y / Y, v.Z / Z);
            local v7 = p3:VectorToWorldSpace((vector.normalize(vector_create_ret)));
            local v8 = (-1 / 0);

            for i = 1, v4 do
                local vector_dot_ret = vector.dot(v7, table_create_ret[i]);
                local v9;

                if v8 < vector_dot_ret then
                    v8 = vector_dot_ret;
                    v9 = i;
                else
                    v9 = i;
                end;
            end;

            local v10 = {
                n = v7,
                d = v8
            };
            table_create_ret2[#table_create_ret2 + 1] = v10;

            if v6 == nil or v7.Y > v6.n.Y then
                v6 = v10;
            end;
        end;

        if v6 == nil or v6.n.Y < 0.7 then
            return nil;
        end;

        local v11 = {};

        for i = 1, v4 do
            local v12;

            if v6.d - vector.dot(v6.n, table_create_ret[i]) < 0.001 then
                v11[#v11 + 1] = table_create_ret[i];
                v12 = i;
            else
                v12 = i;
            end;
        end;

        return {
            N = v6.n,
            D = v6.d,
            Face = v11,
            Verts = table_create_ret,
            Planes = table_create_ret2
        };
    end,

    Covers = function(p13: any, p14: table, p15: number) -- Line: 138, Name: Covers
        for _, v in p14 do
            local v16 = v;

            for _, v2 in p13.Planes do
                if p15 < vector.dot(v2.n, v16) - v2.d then
                    return false;
                end;
            end;
        end;

        return true;
    end,

    Flush = function(p17: any, p18: any, p19: number) -- Line: 155, Name: Flush
        for _, v in p18.Face do
            if p19 < p17.D - vector.dot(p17.N, v) then
                return false;
            end;
        end;

        return true;
    end
};

function u20.Filter(p21: any, p22: number, p23: any) -- Line: 171
    -- upvalues: u20 (copy)
    local table_create_ret = table.create(#p21);
    local v24 = {};

    for i, v in p21 do
        local v25 = u20.Facet(p23(v), v.Size, v.CFrame);
        table_create_ret[i] = v25;

        if v25 then
            local v26 = i;
            local v27 = (1 / 0);
            local v28 = (-1 / 0);
            local v29 = (1 / 0);
            local v30 = (-1 / 0);

            for _, v2 in v25.Face do
                if v2.X < v27 then
                    v27 = v2.X;
                end;

                if v28 < v2.X then
                    v28 = v2.X;
                end;

                if v2.Z < v29 then
                    v29 = v2.Z;
                end;

                if v30 < v2.Z then
                    v30 = v2.Z;
                end;
            end;

            for i2 = math.floor(v27 / 16), math.floor(v28 / 16) do
                local v31 = i2;

                for i3 = math.floor(v29 / 16), math.floor(v30 / 16) do
                    local v32 = v31 * 100003 + i3;
                    local v33 = v24[v32];

                    if not v33 then
                        v33 = {};
                        v24[v32] = v33;
                    end;

                    v33[#v33 + 1] = v26;
                    local _ = i3;
                end;
            end;
        end;
    end;

    local v34 = {};
    local v35 = {};

    for i, v in table_create_ret do
        if v and not v35[i] then
            local v36 = v.Face[1];
            local v37 = v24[math.floor(v36.X / 16) * 100003 + math.floor(v36.Z / 16)];

            if v37 then
                local v38 = v;
                local v39 = i;

                for _, v2 in v37 do
                    if v2 ~= v39 and (not v35[v2] and (u20.Flush(table_create_ret[v2], v38, p22) and u20.Covers(table_create_ret[v2], v38.Verts, p22))) then
                        v35[v39] = true;
                        v34[p21[v39]] = p21[v2];
                        break;
                    end;
                end;
            end;
        end;
    end;

    local table_create_ret2 = table.create(#p21);
    local v40 = 0;

    for i, v in p21 do
        if not v35[i] then
            v40 = v40 + 1;
            table_create_ret2[v40] = v;
        end;
    end;

    return table_create_ret2, #p21 - v40, v34;
end;

return u20;