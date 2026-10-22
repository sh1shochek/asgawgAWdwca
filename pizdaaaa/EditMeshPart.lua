-- ReplicatedStorage.Shared.ProjectDecal.EditMeshPart
-- Script path: ReplicatedStorage.Shared.ProjectDecal.EditMeshPart
-- Decompile time: 6.09 ms

-- Decompiled with Potassium's decompiler.

return {
    CreateEditMeshPart = function(p1) -- Line: 23, Name: CreateEditMeshPart
        local v27 = {
            meshPart = nil,
            editableMesh = nil,
            currentFaceIndex = 0,
            capacity = 0,
            dirtyCount = 0,
            faceList = {},
            indexList = {},

            Clear = function(p2) -- Line: 37, Name: Clear
                p2.currentFaceIndex = 0;
            end,

            Update = function(p3) -- Line: 42, Name: Update
                local editableMesh = p3.editableMesh;

                for i = p3.currentFaceIndex + 1, p3.dirtyCount do
                    local v4 = p3.indexList[i];
                    editableMesh:SetPosition(v4[1], Vector3.new(0, 0, 0));
                    editableMesh:SetPosition(v4[2], Vector3.new(0, 0, 0));
                    editableMesh:SetPosition(v4[3], Vector3.new(0, 0, 0));
                    local _ = i;
                end;

                p3.dirtyCount = p3.currentFaceIndex;
            end,

            AddTri = function(p5: table, p6: vector, p7: vector, p8: vector, p9: vector, p10: vector, p11: vector, p12, p13, p14) -- Line: 56, Name: AddTri
                local editableMesh = p5.editableMesh;

                if p5.capacity > 6666.666666666667 then
                    return;
                end;

                if p5.currentFaceIndex < p5.capacity then
                    local v15 = p5.currentFaceIndex + 1;
                    local _ = p5.faceList[v15];
                    local v16 = p5.indexList[v15];
                    editableMesh:SetPosition(v16[1], p6);
                    editableMesh:SetPosition(v16[2], p7);
                    editableMesh:SetPosition(v16[3], p8);
                    editableMesh:SetNormal(v16[4], p9);
                    editableMesh:SetNormal(v16[5], p10);
                    editableMesh:SetNormal(v16[6], p11);
                    editableMesh:SetUV(v16[7], p12);
                    editableMesh:SetUV(v16[8], p13);
                    editableMesh:SetUV(v16[9], p14);
                    p5.currentFaceIndex = p5.currentFaceIndex + 1;

                    return;
                end;

                local v17 = editableMesh:AddVertex(p6);
                local v18 = editableMesh:AddVertex(p7);
                local v19 = editableMesh:AddVertex(p8);
                local v20 = editableMesh:AddTriangle(v17, v18, v19);
                local v21 = editableMesh:AddNormal(p9);
                local v22 = editableMesh:AddNormal(p10);
                local v23 = editableMesh:AddNormal(p11);
                editableMesh:SetFaceNormals(v20, { v21, v22, v23 });
                local v24 = editableMesh:AddUV(p12);
                local v25 = editableMesh:AddUV(p13);
                local v26 = editableMesh:AddUV(p14);
                editableMesh:SetFaceUVs(v20, { v24, v25, v26 });
                table.insert(p5.faceList, v20);
                table.insert(p5.indexList, {
                    v17,
                    v18,
                    v19,
                    v21,
                    v22,
                    v23,
                    v24,
                    v25,
                    v26
                });
                p5.currentFaceIndex = p5.currentFaceIndex + 1;
                p5.capacity = p5.capacity + 1;
            end,

            editableMesh = game.AssetService:CreateEditableMesh()
        };

        if v27.editableMesh == nil then
            return nil;
        end;

        v27:AddTri(Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Vector3.new(1, 1, 1), Vector3.new(1, 1, 1), Vector3.new(1, 1, 1), Vector2.zero, Vector2.zero, Vector2.zero);
        local v28 = game.AssetService:CreateMeshPartAsync(Content.fromObject(v27.editableMesh), {
            CollisionFidelity = Enum.CollisionFidelity.Box,
            RenderFidelity = Enum.RenderFidelity.Precise,
            FluidFidelity = Enum.FluidFidelity.UseCollisionGeometry
        });

        if not v28 then
            v27.editableMesh:Destroy();

            return nil;
        end;

        v28.CanCollide = false;
        v28.CanQuery = false;
        v28.CanTouch = false;
        v28.CastShadow = false;
        v28.EnableFluidForces = false;
        v28.Color = Color3.new(1, 1, 1);
        v28.Anchored = true;
        v28.Parent = game.Workspace;
        v27.meshPart = v28;

        return v27;
    end
};